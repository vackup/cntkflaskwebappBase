FROM tiangolo/uwsgi-nginx-flask:python3.6

#debugger
#EXPOSE 5678
#RUN pip3 install ptvsd==3.0.0

# Add demo app
COPY ./app /app
WORKDIR /app

RUN apt-get update

## update pip
RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install wheel

# install openmpi-bin from sources
RUN OPENMPI_VERSION=1.10.3 && \
    wget -q -O - https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-${OPENMPI_VERSION}.tar.gz | tar -xzf - && \
    cd openmpi-${OPENMPI_VERSION} && \
    ./configure --prefix=/usr/local/mpi && \
    make -j"$(nproc)" install && \
    rm -rf /openmpi-${OPENMPI_VERSION}

RUN pip install https://cntk.ai/PythonWheel/CPU-Only/cntk-2.5.1-cp36-cp36m-linux_x86_64.whl 
RUN pip install -r /app/requirements.txt

ENV LISTEN_PORT=88
EXPOSE 88

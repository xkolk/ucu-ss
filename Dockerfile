FROM python:3.7-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache jupyterlab

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

WORKDIR ${HOME}
RUN pip install --no-cache -r requirements.txt
RUN apt update && apt dist-upgrade -y && apt autoremove -y && \
    apt install -y `cat ./apt.txt`
RUN chmod +x ./postBuild && \
    ./postBuild

USER ${USER}

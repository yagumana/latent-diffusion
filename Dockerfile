FROM pytorch/pytorch:2.2.2-cuda12.1-cudnn8-devel

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y wget tmux git curl build-essential \
    && apt-get clean

# Rustのインストールと環境設定の適用
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Rustの環境設定を有効にする
ENV PATH="/root/.cargo/bin:$PATH"

# Rustコンパイラのバージョン確認（デバッグ用）
RUN /bin/bash -c "source /root/.cargo/env && rustc --version && cargo --version"


COPY requirements.txt /tmp/
# setup.pyファイルを作業ディレクトリにコピー
COPY setup.py .

RUN pip install --requirement /tmp/requirements.txt

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    poppler-utils \
    ffmpeg \
    && apt-get clean

# dockerが起動し続けるためのもの
CMD ["tail", "-f", "/dev/null"]

# ENTRYPOINT ["/bin/bash"]
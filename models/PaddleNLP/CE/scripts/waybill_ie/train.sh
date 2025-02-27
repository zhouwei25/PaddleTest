#unset http_proxy
HTTPPROXY=$http_proxy
HTTPSPROXY=$https_proxy
unset http_proxy
unset https_proxy

#外部传入参数说明
# $1:  $XPU = gpu or cpu
#获取当前路径
cur_path=`pwd`
model_name=${PWD##*/}

echo "$model_name 模型训练阶段"

#路径配置
root_path=$cur_path/../../
code_path=$cur_path/../../models_repo/examples/information_extraction/waybill_ie/
log_path=$root_path/log/$model_name/
mkdir -p $log_path

print_info(){
    cat ${log_path}/$2.log
if [ $1 -ne 0 ];then
    echo "exit_code: 1.0" >> ${log_path}/$2.log
else
    echo "exit_code: 0.0" >> ${log_path}/$2.log
fi
}

#访问RD程序
cd $code_path

DEVICE=$1
MODEL=$2
if [[ ${MODEL} == "bigru_crf" ]]
then
    python run_bigru_crf.py >$log_path/train_${DEVICE}_${MODEL}.log 2>&1
elif [[ ${MODEL} == "ernie" ]]
then
    python run_ernie.py >$log_path/train_${DEVICE}_${MODEL}.log 2>&1
elif [[ ${MODEL} == "ernie_crf" ]]
then
    python run_ernie_crf.py > $log_path/train_${DEVICE}_${MODEL}.log 2>&1
fi

print_info $? train_${DEVICE}_${MODEL}

#set http_proxy
export http_proxy=$HTTPPROXY
export https_proxy=$HTTPSPROXY

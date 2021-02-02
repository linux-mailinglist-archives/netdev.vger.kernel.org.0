Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A2230B4AA
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBBB1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:27:37 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:4604 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhBBB1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 20:27:17 -0500
Received: from dggeme716-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4DV6ZB1zCDzY0SS;
        Tue,  2 Feb 2021 09:25:22 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme716-chm.china.huawei.com
 (10.1.199.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Tue, 2 Feb
 2021 09:26:31 +0800
Subject: Re: [PATCH V2 net-next 2/2] net: hns3: add debugfs support for tm
 nodes, priority and qset info
To:     Nathan Chancellor <nathan@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <1611834696-56207-1-git-send-email-tanhuazhong@huawei.com>
 <1611834696-56207-3-git-send-email-tanhuazhong@huawei.com>
 <20210201212557.GA3126741@localhost>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <4144bae3-4b99-8dfa-c979-4ac0d278eb2d@huawei.com>
Date:   Tue, 2 Feb 2021 09:26:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210201212557.GA3126741@localhost>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggeme716-chm.china.huawei.com (10.1.199.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/2 5:25, Nathan Chancellor wrote:
> On Thu, Jan 28, 2021 at 07:51:36PM +0800, Huazhong Tan wrote:
>> From: Guangbin Huang <huangguangbin2@huawei.com>
>>
>> In order to query tm info of nodes, priority and qset
>> for debugging, adds three debugfs files tm_nodes,
>> tm_priority and tm_qset in newly created tm directory.
>>
>> Unlike previous debugfs commands, these three files
>> just support read ops, so they only support to use cat
>> command to dump their info.
>>
>> The new tm file style is acccording to suggestion from
>> Jakub Kicinski's opinion as link https://lkml.org/lkml/2020/9/29/2101.
>>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 ++
>>   drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  55 +++++++-
>>   .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 153 +++++++++++++++++++++
>>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
>>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
>>   5 files changed, 218 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> index a7daf6d..fe09cf6 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> @@ -465,6 +465,8 @@ struct hnae3_ae_dev {
>>    *   Delete clsflower rule
>>    * cls_flower_active
>>    *   Check if any cls flower rule exist
>> + * dbg_read_cmd
>> + *   Execute debugfs read command.
>>    */
>>   struct hnae3_ae_ops {
>>   	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
>> @@ -620,6 +622,8 @@ struct hnae3_ae_ops {
>>   	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
>>   			      u16 flow_id, struct flow_keys *fkeys);
>>   	int (*dbg_run_cmd)(struct hnae3_handle *handle, const char *cmd_buf);
>> +	int (*dbg_read_cmd)(struct hnae3_handle *handle, const char *cmd_buf,
>> +			    char *buf, int len);
>>   	pci_ers_result_t (*handle_hw_ras_error)(struct hnae3_ae_dev *ae_dev);
>>   	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
>>   	bool (*ae_dev_resetting)(struct hnae3_handle *handle);
>> @@ -777,6 +781,10 @@ struct hnae3_handle {
>>   #define hnae3_get_bit(origin, shift) \
>>   	hnae3_get_field((origin), (0x1 << (shift)), (shift))
>>   
>> +#define HNAE3_DBG_TM_NODES		"tm_nodes"
>> +#define HNAE3_DBG_TM_PRI		"tm_priority"
>> +#define HNAE3_DBG_TM_QSET		"tm_qset"
>> +
>>   int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
>>   void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
>>   
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
>> index 9d4e9c0..6978304 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
>> @@ -7,7 +7,7 @@
>>   #include "hnae3.h"
>>   #include "hns3_enet.h"
>>   
>> -#define HNS3_DBG_READ_LEN 256
>> +#define HNS3_DBG_READ_LEN 65536
>>   #define HNS3_DBG_WRITE_LEN 1024
>>   
>>   static struct dentry *hns3_dbgfs_root;
>> @@ -484,6 +484,42 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
>>   	return count;
>>   }
>>   
>> +static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
>> +			     size_t count, loff_t *ppos)
>> +{
>> +	struct hnae3_handle *handle = filp->private_data;
>> +	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
>> +	struct hns3_nic_priv *priv = handle->priv;
>> +	char *cmd_buf, *read_buf;
>> +	ssize_t size = 0;
>> +	int ret = 0;
>> +
>> +	if (!filp->f_path.dentry->d_iname)
>> +		return -EINVAL;
> Clang warns this check is pointless:
>
> drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:497:28: warning:
> address of array 'filp->f_path.dentry->d_iname' will always evaluate to
> 'true' [-Wpointer-bool-conversion]
>          if (!filp->f_path.dentry->d_iname)
>              ~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
> 1 warning generated.
>
> Was it intended to be something else or can it just be removed?


yes, it is unnecessary, will remove it later.

Thanks.


>> +	read_buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
>> +	if (!read_buf)
>> +		return -ENOMEM;
>> +
>> +	cmd_buf = filp->f_path.dentry->d_iname;
>> +
>> +	if (ops->dbg_read_cmd)
>> +		ret = ops->dbg_read_cmd(handle, cmd_buf, read_buf,
>> +					HNS3_DBG_READ_LEN);
>> +
>> +	if (ret) {
>> +		dev_info(priv->dev, "unknown command\n");
>> +		goto out;
>> +	}
>> +
>> +	size = simple_read_from_buffer(buffer, count, ppos, read_buf,
>> +				       strlen(read_buf));
>> +
>> +out:
>> +	kfree(read_buf);
>> +	return size;
>> +}
> Cheers,
> Nathan
>
> .


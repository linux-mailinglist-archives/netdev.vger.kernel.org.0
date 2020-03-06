Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F61017B6A5
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 07:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgCFGS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 01:18:27 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:38996 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbgCFGS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 01:18:27 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3289ACFFA47CA2E10DB1;
        Fri,  6 Mar 2020 14:18:22 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 6 Mar 2020
 14:18:12 +0800
Subject: Re: [PATCH net-next 1/9] net: hns3: fix some mixed type assignment
To:     "shenjian (K)" <shenjian15@huawei.com>, <davem@davemloft.net>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <kuba@kernel.org>
References: <1583463438-60953-1-git-send-email-tanhuazhong@huawei.com>
 <1583463438-60953-2-git-send-email-tanhuazhong@huawei.com>
 <03bf7b86-6674-163a-5df2-1840966de960@huawei.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <3a4a0a49-1cdf-9d30-de15-1a5c6d6892cb@huawei.com>
Date:   Fri, 6 Mar 2020 14:18:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <03bf7b86-6674-163a-5df2-1840966de960@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/3/6 11:39, shenjian (K) wrote:
> 
> 
> 在 2020/3/6 10:57, Huazhong Tan 写道:
>> From: Guojia Liao <liaoguojia@huawei.com>
>>
>> This patch cleans up some incorrect type in assignment reported by sparse
>> and compiler.
>> The warning as below:
>> - warning : restricted __le16 degrades to integer
>> - warning : cast from restricted __le32
>> - warning : cast from restricted __be32
>> - warning : cast from restricted __be16
>> and "mixed operation".
>>
>> Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> should add fixes id.

This is just a cleanup.

>> ---
>>   .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 23 
>> ++++++++++++----------
>>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  3 ++-
>>   2 files changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git 
>> a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c 
>> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
>> index 6295cf9..5b4045c 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
>> @@ -87,7 +87,7 @@ static int hclge_dbg_get_dfx_bd_num(struct hclge_dev 
>> *hdev, int offset)
>>       entries_per_desc = ARRAY_SIZE(desc[0].data);
>>       index = offset % entries_per_desc;
>> -    return (int)desc[offset / entries_per_desc].data[index];
>> +    return le32_to_cpu(desc[offset / entries_per_desc].data[index]);
>>   }
>>   static int hclge_dbg_cmd_send(struct hclge_dev *hdev,
>> @@ -583,7 +583,7 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev 
>> *hdev,
>>       ret = hclge_cmd_send(&hdev->hw, &desc, 1);
>>       if (ret)
>>           goto err_tm_map_cmd_send;
>> -    qset_id = nq_to_qs_map->qset_id & 0x3FF;
>> +    qset_id = le16_to_cpu(nq_to_qs_map->qset_id) & 0x3FF;
>>       cmd = HCLGE_OPC_TM_QS_TO_PRI_LINK;
>>       map = (struct hclge_qs_to_pri_link_cmd *)desc.data;
>> @@ -623,7 +623,8 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev 
>> *hdev,
>>           if (ret)
>>               goto err_tm_map_cmd_send;
>> -        qset_maping[group_id] = bp_to_qs_map_cmd->qs_bit_map;
>> +        qset_maping[group_id] =
>> +            le32_to_cpu(bp_to_qs_map_cmd->qs_bit_map);
>>       }
>>       dev_info(&hdev->pdev->dev, "index | tm bp qset maping:\n");
>> @@ -826,6 +827,7 @@ static void hclge_dbg_dump_mng_table(struct 
>> hclge_dev *hdev)
>>       struct hclge_mac_ethertype_idx_rd_cmd *req0;
>>       char printf_buf[HCLGE_DBG_BUF_LEN];
>>       struct hclge_desc desc;
>> +    u32 msg_egress_port;
>>       int ret, i;
>>       dev_info(&hdev->pdev->dev, "mng tab:\n");
>> @@ -867,20 +869,21 @@ static void hclge_dbg_dump_mng_table(struct 
>> hclge_dev *hdev)
>>                HCLGE_DBG_BUF_LEN - strlen(printf_buf),
>>                "%x   |%04x |%x   |%04x|%x   |%02x   |%02x   |",
>>                !!(req0->flags & HCLGE_DBG_MNG_MAC_MASK_B),
>> -             req0->ethter_type,
>> +             le16_to_cpu(req0->ethter_type),
>>                !!(req0->flags & HCLGE_DBG_MNG_ETHER_MASK_B),
>> -             req0->vlan_tag & HCLGE_DBG_MNG_VLAN_TAG,
>> +             le16_to_cpu(req0->vlan_tag) & HCLGE_DBG_MNG_VLAN_TAG,
>>                !!(req0->flags & HCLGE_DBG_MNG_VLAN_MASK_B),
>>                req0->i_port_bitmap, req0->i_port_direction);
>> +        msg_egress_port = le16_to_cpu(req0->egress_port);
>>           snprintf(printf_buf + strlen(printf_buf),
>>                HCLGE_DBG_BUF_LEN - strlen(printf_buf),
>>                "%d     |%d    |%02d   |%04d|%x\n",
>> -             !!(req0->egress_port & HCLGE_DBG_MNG_E_TYPE_B),
>> -             req0->egress_port & HCLGE_DBG_MNG_PF_ID,
>> -             (req0->egress_port >> 3) & HCLGE_DBG_MNG_VF_ID,
>> -             req0->egress_queue,
>> -             !!(req0->egress_port & HCLGE_DBG_MNG_DROP_B));
>> +             !!(msg_egress_port & HCLGE_DBG_MNG_E_TYPE_B),
>> +             msg_egress_port & HCLGE_DBG_MNG_PF_ID,
>> +             (msg_egress_port >> 3) & HCLGE_DBG_MNG_VF_ID,
>> +             le16_to_cpu(req0->egress_queue),
>> +             !!(msg_egress_port & HCLGE_DBG_MNG_DROP_B));
> 
> msg_egress_port is unsigned, but print format is "%d" ?

should use '%x' instead.
Thanks.

>>           dev_info(&hdev->pdev->dev, "%s", printf_buf);
>>       }
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c 
>> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> index 89d3523..e64027c 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> @@ -10252,8 +10252,9 @@ static int hclge_dfx_reg_fetch_data(struct 
>> hclge_desc *desc_src, int bd_num,
>>   static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
>>   {
>>       u32 dfx_reg_type_num = ARRAY_SIZE(hclge_dfx_bd_offset_list);
>> -    int data_len_per_desc, data_len, bd_num, i;
>> +    int data_len_per_desc, bd_num, i;
>>       int bd_num_list[BD_LIST_MAX_NUM];
>> +    u32 data_len;
>>       int ret;
>>       ret = hclge_get_dfx_reg_bd_num(hdev, bd_num_list, 
>> dfx_reg_type_num);
> 
> 
> 
> .
> 


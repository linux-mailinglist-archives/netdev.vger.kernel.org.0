Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C793F74311
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 04:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388718AbfGYCFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 22:05:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2716 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388438AbfGYCFL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 22:05:11 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8054973CF4BA97690F29;
        Thu, 25 Jul 2019 10:05:08 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 25 Jul 2019
 10:04:47 +0800
Subject: Re: [PATCH net-next 04/11] net: hns3: fix mis-counting IRQ vector
 numbers issue
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liuyonglong@huawei.com" <liuyonglong@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-5-git-send-email-tanhuazhong@huawei.com>
 <ad63b46dfb7e36d63d95866a023ef181af40aa76.camel@mellanox.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <327e1905-30e3-6dea-f3f1-71dc73478e0b@huawei.com>
Date:   Thu, 25 Jul 2019 10:04:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <ad63b46dfb7e36d63d95866a023ef181af40aa76.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/25 2:28, Saeed Mahameed wrote:
> On Wed, 2019-07-24 at 11:18 +0800, Huazhong Tan wrote:
>> From: Yonglong Liu <liuyonglong@huawei.com>
>>
>> The num_msi_left means the vector numbers of NIC, but if the
>> PF supported RoCE, it contains the vector numbers of NIC and
>> RoCE(Not expected).
>>
>> This may cause interrupts lost in some case, because of the
>> NIC module used the vector resources which belongs to RoCE.
>>
>> This patch corrects the value of num_msi_left to be equals to
>> the vector numbers of NIC, and adjust the default tqp numbers
>> according to the value of num_msi_left.
>>
>> Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine &
>> Compatibility Layer Support")
>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>> Signed-off-by: Peng Li <lipeng321@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |  5 ++++-
>>   drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 12
>> ++++++++++--
>>   2 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> index 3c64d70..a59d13f 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> @@ -1470,13 +1470,16 @@ static int hclge_vport_setup(struct
>> hclge_vport *vport, u16 num_tqps)
>>   {
>>   	struct hnae3_handle *nic = &vport->nic;
>>   	struct hclge_dev *hdev = vport->back;
>> +	u16 alloc_tqps;
>>   	int ret;
>>   
>>   	nic->pdev = hdev->pdev;
>>   	nic->ae_algo = &ae_algo;
>>   	nic->numa_node_mask = hdev->numa_node_mask;
>>   
>> -	ret = hclge_knic_setup(vport, num_tqps,
>> +	alloc_tqps = min_t(u16, hdev->roce_base_msix_offset - 1,
> 
> 
> Why do you need the extra alloc_tqps ? just overwrite num_tqps, the
> original value is not needed afterwards.
> 

Yes, using num_tqps is better.
I will remove the extra alloc_tqps in V2.
Thanks.

>> num_tqps);
>> +
>> +	ret = hclge_knic_setup(vport, alloc_tqps,
>>   			       hdev->num_tx_desc, hdev->num_rx_desc);
>>   	if (ret)
>>   		dev_err(&hdev->pdev->dev, "knic setup failed %d\n",
>> ret);
>>


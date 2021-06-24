Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41AE3B311E
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhFXOSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:18:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5423 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhFXOSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:18:14 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G9hst3KXjz72F0;
        Thu, 24 Jun 2021 22:12:34 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 22:15:51 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 24
 Jun 2021 22:15:50 +0800
Subject: Re: [PATCH net-next 2/3] net: hns3: add support for TX push mode
To:     Will Deacon <will@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <catalin.marinas@arm.com>, <maz@kernel.org>,
        <mark.rutland@arm.com>, <dbrazdil@google.com>,
        <qperret@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <lipeng321@huawei.com>,
        <peterz@infradead.org>
References: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
 <1624360271-17525-3-git-send-email-huangguangbin2@huawei.com>
 <20210622121611.GB30757@willie-the-truck>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <ea9f2737-6639-b9ce-9472-bb3c04581734@huawei.com>
Date:   Thu, 24 Jun 2021 22:15:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210622121611.GB30757@willie-the-truck>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/22 20:16, Will Deacon wrote:
> On Tue, Jun 22, 2021 at 07:11:10PM +0800, Guangbin Huang wrote:
>> From: Huazhong Tan <tanhuazhong@huawei.com>
>>
>> For the device that supports the TX push capability, the BD can
>> be directly copied to the device memory. However, due to hardware
>> restrictions, the push mode can be used only when there are no
>> more than two BDs, otherwise, the doorbell mode based on device
>> memory is used.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
>>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 83 ++++++++++++++++++++--
>>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  6 ++
>>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 +
>>   .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 +
>>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 11 ++-
>>   .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  8 +++
>>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 +
>>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 11 ++-
>>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  8 +++
>>   10 files changed, 126 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> index 0b202f4def83..3979d5d2e842 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> @@ -163,6 +163,7 @@ struct hnae3_handle;
>>   
>>   struct hnae3_queue {
>>   	void __iomem *io_base;
>> +	void __iomem *mem_base;
>>   	struct hnae3_ae_algo *ae_algo;
>>   	struct hnae3_handle *handle;
>>   	int tqp_index;		/* index in a handle */
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> index cdb5f14fb6bc..8649bd8e1b57 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> @@ -2002,9 +2002,77 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
>>   	return bd_num;
>>   }
>>   
>> +static void hns3_tx_push_bd(struct hns3_enet_ring *ring, int num)
>> +{
>> +#define HNS3_BYTES_PER_64BIT		8
>> +
>> +	struct hns3_desc desc[HNS3_MAX_PUSH_BD_NUM] = {};
>> +	int offset = 0;
>> +
>> +	/* make sure everything is visible to device before
>> +	 * excuting tx push or updating doorbell
>> +	 */
>> +	dma_wmb();
>> +
>> +	do {
>> +		int idx = (ring->next_to_use - num + ring->desc_num) %
>> +			  ring->desc_num;
>> +
>> +		u64_stats_update_begin(&ring->syncp);
>> +		ring->stats.tx_push++;
>> +		u64_stats_update_end(&ring->syncp);
>> +		memcpy(&desc[offset], &ring->desc[idx],
>> +		       sizeof(struct hns3_desc));
>> +		offset++;
>> +	} while (--num);
>> +
>> +	__iowrite64_copy(ring->tqp->mem_base, desc,
>> +			 (sizeof(struct hns3_desc) * HNS3_MAX_PUSH_BD_NUM) /
>> +			 HNS3_BYTES_PER_64BIT);
>> +
>> +#if defined(CONFIG_ARM64)
>> +	dgh();
>> +#endif
> 
> It looks a bit weird putting this at the end of the function, given that
> it's supposed to do something to a pair of accesses. Please can you explain
> what it's doing, and also provide some numbers to show that it's worthwhile
> (given that it's a performance hint not a correctness thing afaict).
> 
When the driver writes the device space mapped to the WriteCombine,
CPU combines into the cacheline unit by using the merge window mechanism
and delivers the cacheline to the device. However, even if the cacheline
is full, the device space is delivered only after the merge window
ends. (There is about 10ns delay at 3G frequency). To reduce the delay,
the WriteCombine needs to be flushed explicitly. This is why the DGH
needs to be invoked here.

>> +}
>> +
>> +static void hns3_tx_mem_doorbell(struct hns3_enet_ring *ring)
>> +{
>> +#define HNS3_MEM_DOORBELL_OFFSET	64
>> +
>> +	__le64 bd_num = cpu_to_le64((u64)ring->pending_buf);
>> +
>> +	/* make sure everything is visible to device before
>> +	 * excuting tx push or updating doorbell
>> +	 */
>> +	dma_wmb();
>> +
>> +	__iowrite64_copy(ring->tqp->mem_base + HNS3_MEM_DOORBELL_OFFSET,
>> +			 &bd_num, 1);
>> +	u64_stats_update_begin(&ring->syncp);
>> +	ring->stats.tx_mem_doorbell += ring->pending_buf;
>> +	u64_stats_update_end(&ring->syncp);
>> +
>> +#if defined(CONFIG_ARM64)
>> +	dgh();
>> +#endif
> 
> Same here.
> 
> Thanks,
> 
> Will
> .
> 
Thanks,

Guangbin
.

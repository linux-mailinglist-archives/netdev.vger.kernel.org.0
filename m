Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE58269F0E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 09:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgIOHEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 03:04:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36512 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbgIOHEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 03:04:40 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 394AD1C3D1EE78AF187E;
        Tue, 15 Sep 2020 15:04:22 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Tue, 15 Sep 2020 15:04:14 +0800
Subject: Re: [PATCH net-next 6/6] net: hns3: use napi_consume_skb() when
 cleaning tx desc
To:     Saeed Mahameed <saeedm@nvidia.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
 <1600085217-26245-7-git-send-email-tanhuazhong@huawei.com>
 <e615366cb2b260bf1b77fdaa0692957ab750a9a4.camel@nvidia.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2b1219b6-a7dd-38a3-bfb7-1cb49330df90@huawei.com>
Date:   Tue, 15 Sep 2020 15:04:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <e615366cb2b260bf1b77fdaa0692957ab750a9a4.camel@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/15 13:09, Saeed Mahameed wrote:
> On Mon, 2020-09-14 at 20:06 +0800, Huazhong Tan wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> Use napi_consume_skb() to batch consuming skb when cleaning
>> tx desc in NAPI polling.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 27 +++++++++++-
>> ----------
>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
>>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  4 ++--
>>  3 files changed, 17 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> index 4a49a76..feeaf75 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> @@ -2333,10 +2333,10 @@ static int hns3_alloc_buffer(struct
>> hns3_enet_ring *ring,
>>  }
>>  
>>  static void hns3_free_buffer(struct hns3_enet_ring *ring,
>> -			     struct hns3_desc_cb *cb)
>> +			     struct hns3_desc_cb *cb, int budget)
>>  {
>>  	if (cb->type == DESC_TYPE_SKB)
>> -		dev_kfree_skb_any((struct sk_buff *)cb->priv);
>> +		napi_consume_skb(cb->priv, budget);
> 
> This code can be reached from hns3_lb_clear_tx_ring() below which is
> your loopback test and called with non-zero budget, I am not sure you
> are allowed to call napi_consume_skb() with non-zero budget outside
> napi context, perhaps the cb->type for loopback test is different in lb
> test case ? Idk.. , please double check other code paths.

Yes, loopback test may call napi_consume_skb() with non-zero budget outside
napi context. Thanks for pointing out this case.

How about add the below WARN_ONCE() in napi_consume_skb() to catch this
kind of error?

WARN_ONCE(!in_serving_softirq(), "napi_consume_skb() is called with non-zero budget outside napi context");

> 
> [...]
> 
>>  static void hns3_lb_clear_tx_ring(struct hns3_nic_priv *priv, u32
>> start_ringid,
>> -				  u32 end_ringid, u32 budget)
>> +				  u32 end_ringid, int budget)
>>  {
>>  	u32 i;
>>  
>>  	for (i = start_ringid; i <= end_ringid; i++) {
>>  		struct hns3_enet_ring *ring = &priv->ring[i];
>>  
>> -		hns3_clean_tx_ring(ring);
>> +		hns3_clean_tx_ring(ring, budget);
>>  	}
>>  }
>>  

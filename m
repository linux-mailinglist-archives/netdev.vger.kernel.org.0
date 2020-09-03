Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C74625C359
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgICOts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:49:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3152 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729085AbgICOTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 10:19:03 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id A7780D5446FE09AD0058;
        Thu,  3 Sep 2020 22:18:52 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 3 Sep 2020 22:18:52 +0800
Subject: Re: [PATCH net 3/3] hinic: fix bug of send pkts while setting
 channels
To:     Eric Dumazet <eric.dumazet@gmail.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
References: <20200902094145.12216-1-luobin9@huawei.com>
 <20200902094145.12216-4-luobin9@huawei.com>
 <fa78a6e8-c21e-ca4a-e40b-4109fb8a78d5@gmail.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <533ff752-f9eb-7afb-66aa-48e411ef6040@huawei.com>
Date:   Thu, 3 Sep 2020 22:18:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <fa78a6e8-c21e-ca4a-e40b-4109fb8a78d5@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/2 18:16, Eric Dumazet wrote:
> 
> 
> On 9/2/20 2:41 AM, Luo bin wrote:
>> When calling hinic_close in hinic_set_channels, netif_carrier_off
>> and netif_tx_disable are excuted, and TX host resources are freed
>> after that. Core may call hinic_xmit_frame to send pkt after
>> netif_tx_disable within a short time, so we should judge whether
>> carrier is on before sending pkt otherwise the resources that
>> have already been freed in hinic_close may be accessed.
>>
>> Fixes: 2eed5a8b614b ("hinic: add set_channels ethtool_ops support")
>> Signed-off-by: Luo bin <luobin9@huawei.com>
>> ---
>>  drivers/net/ethernet/huawei/hinic/hinic_tx.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
>> index a97498ee6914..a0662552a39c 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
>> @@ -531,6 +531,11 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>>  	struct hinic_txq *txq;
>>  	struct hinic_qp *qp;
>>  
>> +	if (unlikely(!netif_carrier_ok(netdev))) {
>> +		dev_kfree_skb_any(skb);
>> +		return NETDEV_TX_OK;
>> +	}
>> +
>>  	txq = &nic_dev->txqs[q_id];
>>  	qp = container_of(txq->sq, struct hinic_qp, sq);
>>  
>>
> 
> Adding this kind of tests in fast path seems a big hammer to me.
> 
> See https://marc.info/?l=linux-netdev&m=159903844423389&w=2   for a similar problem.
> 
> Normally, after hinic_close() operation, no packet should be sent by core networking stack.
> 
> Trying to work around some core networking issue in each driver is a dead end.
Thanks for your review. I agree with what you said. Theoretically, core can't call ndo_start_xmit
to send packet after netif_tx_disable called by hinic_close because __QUEUE_STATE_DRV_XOFF bit is set
and this bit is protected by __netif_tx_lock but it does call hinic_xmit_frame after netif_tx_disable
in my debug message. I'll try to figure out why and fix it. It seems like that the patch from
https://marc.info/?l=linux-netdev&m=159903844423389&w=2 can't fix this problem.
> 
> 
> 
> 
> 
> 
> .
> 

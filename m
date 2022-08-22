Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01F759B749
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 03:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiHVBj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 21:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiHVBjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 21:39:25 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933662127A;
        Sun, 21 Aug 2022 18:39:24 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M9w175Wqnz1N7R0;
        Mon, 22 Aug 2022 09:35:55 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 22 Aug 2022 09:39:22 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 22 Aug 2022 09:39:22 +0800
Subject: Re: [PATCH net v2] net: neigh: don't call kfree_skb() under
 spin_lock_irqsave()
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <den@openvz.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>
References: <20220819044724.961356-1-yangyingliang@huawei.com>
 <c9bc0382-fd0d-c596-5f61-365a8e0cbb21@blackwall.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <eb7a4bac-965e-c68d-da34-22921fd94141@huawei.com>
Date:   Mon, 22 Aug 2022 09:39:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c9bc0382-fd0d-c596-5f61-365a8e0cbb21@blackwall.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/8/19 20:15, Nikolay Aleksandrov wrote:
> On 19/08/2022 07:47, Yang Yingliang wrote:
>> It is not allowed to call kfree_skb() from hardware interrupt
>> context or with interrupts being disabled. So add all skb to
>> a tmp list, then free them after spin_unlock_irqrestore() at
>> once.
>>
>> Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   net/core/neighbour.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> index 5b669eb80270..d21c7de1ff1a 100644
>> --- a/net/core/neighbour.c
>> +++ b/net/core/neighbour.c
>> @@ -309,14 +309,17 @@ static int neigh_del_timer(struct neighbour *n)
>>   
>>   static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
>>   {
>> +	struct sk_buff_head tmp;
>>   	unsigned long flags;
>>   	struct sk_buff *skb;
>>   
>> +	skb_queue_head_init(&tmp);
>>   	spin_lock_irqsave(&list->lock, flags);
>>   	skb = skb_peek(list);
>>   	while (skb != NULL) {
>>   		struct sk_buff *skb_next = skb_peek_next(skb, list);
>>   		struct net_device *dev = skb->dev;
>> +
>>   		if (net == NULL || net_eq(dev_net(dev), net)) {
>>   			struct in_device *in_dev;
>>   
>> @@ -328,11 +331,16 @@ static void :q
> (struct sk_buff_head *list, struct net *net)
>>   			__skb_unlink(skb, list);
>>   
>>   			dev_put(dev);
>> -			kfree_skb(skb);
>> +			dev_kfree_skb_irq(skb);
> this is still doing dev_kfree_skb_irq() instead of attaching the skb to tmp, in fact
> tmp seems unused so the loop below does nothing
>
>>   		}
>>   		skb = skb_next;
>>   	}
>>   	spin_unlock_irqrestore(&list->lock, flags);
>> +
>> +	while ((skb = __skb_dequeue(&tmp))) {
>> +		dev_put(skb->dev);
> Also note that there's already a dev_put() above
I made a mistake and send a wrong patch, please ignore this patch.

Thanks,
Yang
>
>> +		kfree_skb(skb);
>> +	}
>>   }
>>   
>>   static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
>
> .

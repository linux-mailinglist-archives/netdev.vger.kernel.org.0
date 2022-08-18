Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B7859819D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 12:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244146AbiHRKrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 06:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244141AbiHRKrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 06:47:39 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61D9816BD;
        Thu, 18 Aug 2022 03:47:35 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4M7hPf5yGpzGpVw;
        Thu, 18 Aug 2022 18:45:58 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 18 Aug 2022 18:47:32 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 18 Aug 2022 18:47:31 +0800
Subject: Re: [PATCH -next] net: neigh: use dev_kfree_skb_irq instead of
 kfree_skb()
To:     "Denis V. Lunev" <den@virtuozzo.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>
References: <20220818043729.412753-1-yangyingliang@huawei.com>
 <79784952-0d15-8a4a-aa8d-590bc243ab5e@virtuozzo.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <705de4aa-91bf-c559-419c-2bfd083c9067@huawei.com>
Date:   Thu, 18 Aug 2022 18:47:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <79784952-0d15-8a4a-aa8d-590bc243ab5e@virtuozzo.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

On 2022/8/18 17:00, Denis V. Lunev wrote:
> On 18.08.2022 06:37, 'Yang Yingliang' via den wrote:
>> It is not allowed to call kfree_skb() from hardware interrupt
>> context or with interrupts being disabled. So replace kfree_skb()
>> with dev_kfree_skb_irq() under spin_lock_irqsave().
>>
>> Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface 
>> start/stop loop")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   net/core/neighbour.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> index 5b669eb80270..167826200f3e 100644
>> --- a/net/core/neighbour.c
>> +++ b/net/core/neighbour.c
>> @@ -328,7 +328,7 @@ static void pneigh_queue_purge(struct 
>> sk_buff_head *list, struct net *net)
>>               __skb_unlink(skb, list);
>>                 dev_put(dev);
>> -            kfree_skb(skb);
>> +            dev_kfree_skb_irq(skb);
>>           }
>>           skb = skb_next;
>>       }
>
> Technically this is pretty much correct, but would it be better to
> move all skb to purge into the new list and after that purge
> them at once?
>
> what about something like this?
>
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index aa16a8017c5e..f7e30daa46ae 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -311,6 +311,9 @@ static void pneigh_queue_purge(struct sk_buff_head 
> *list, struct net *net)
>  {
>         unsigned long flags;
>         struct sk_buff *skb;
> +       struct sk_buff_head tmp;
> +
> +       skb_queue_head_init(&tmp);
>
>         spin_lock_irqsave(&list->lock, flags);
>         skb = skb_peek(list);
> @@ -318,12 +321,16 @@ static void pneigh_queue_purge(struct 
> sk_buff_head *list, struct net *net)
>                 struct sk_buff *skb_next = skb_peek_next(skb, list);
>                 if (net == NULL || net == dev_net(skb->dev)) {
>                         __skb_unlink(skb, list);
> -                       dev_put(skb->dev);
> -                       kfree_skb(skb);
> +                       __skb_queue_tail(&tmp, skb);
>                 }
>                 skb = skb_next;
>         } while (skb != NULL);
>         spin_unlock_irqrestore(&list->lock, flags);
> +
> +       while ((skb = __skb_dequeue(&tmp)) != NULL) {
> +               dev_put(skb->dev);
> +               kfree_skb(skb);
> +       }
>  }
It's better, I can send a v2 later.

Thanks,
Yang
>
> iris ~/src/linux-2.6 $
>
> .

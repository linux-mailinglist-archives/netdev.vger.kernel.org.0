Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6765992B1
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 03:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbiHSBof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 21:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239163AbiHSBod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 21:44:33 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9244AD571D;
        Thu, 18 Aug 2022 18:44:32 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M84Hs0BfWznTcd;
        Fri, 19 Aug 2022 09:42:17 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 19 Aug 2022 09:44:30 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 19 Aug 2022 09:44:30 +0800
Subject: Re: [PATCH -next] net: neigh: use dev_kfree_skb_irq instead of
 kfree_skb()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Denis V. Lunev" <den@virtuozzo.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>
References: <20220818043729.412753-1-yangyingliang@huawei.com>
 <79784952-0d15-8a4a-aa8d-590bc243ab5e@virtuozzo.com>
 <20220818093224.2539d0bc@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <6fab4f14-3afd-2576-e539-da37408f6b84@huawei.com>
Date:   Fri, 19 Aug 2022 09:44:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20220818093224.2539d0bc@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
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


On 2022/8/19 0:32, Jakub Kicinski wrote:
> Please put [PATCH net] as the tag for v2, this is a fix, not -next
> material.
OK.
I don't find the commit 66ba215cb513 ("neigh: fix possible DoS due to 
net iface start/stop loop")
on linux/master, so made the patch based on linux-next/master, and add 
-next.
Later I will send a v2 based on net/master.

Thanks,
Yang
>
> On Thu, 18 Aug 2022 11:00:13 +0200 Denis V. Lunev wrote:
>>           unsigned long flags;
>>           struct sk_buff *skb;
>> +       struct sk_buff_head tmp;
> reverse xmas tree, so tmp should be declared before the shorter lines
>
>> +       skb_queue_head_init(&tmp);
>>
>>           spin_lock_irqsave(&list->lock, flags);
>>           skb = skb_peek(list);
>> @@ -318,12 +321,16 @@ static void pneigh_queue_purge(struct sk_buff_head
>> *list, struct net *net)
>>                   struct sk_buff *skb_next = skb_peek_next(skb, list);
> while at it let's add an empty line here
>
>>                   if (net == NULL || net == dev_net(skb->dev)) {
>>                           __skb_unlink(skb, list);
>> -                       dev_put(skb->dev);
>> -                       kfree_skb(skb);
>> +                       __skb_queue_tail(&tmp, skb);
>>                   }
>>                   skb = skb_next;
>>           } while (skb != NULL);
>>           spin_unlock_irqrestore(&list->lock, flags);
>> +
>> +       while ((skb = __skb_dequeue(&tmp)) != NULL) {
> No need to compare pointers to NULL
>
>> +               dev_put(skb->dev);
>> +               kfree_skb(skb);
>> +       }
> .

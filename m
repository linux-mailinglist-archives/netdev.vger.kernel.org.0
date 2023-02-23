Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1361B6A04A7
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbjBWJUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjBWJUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:20:03 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2101C48E33
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 01:20:00 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PMnVz4QLKzKq69;
        Thu, 23 Feb 2023 17:18:03 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Thu, 23 Feb
 2023 17:18:31 +0800
Subject: Re: [PATCH net] net: fix __dev_kfree_skb_any() vs drop monitor
To:     Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <eric.dumazet@gmail.com>
References: <20230223000713.1407316-1-edumazet@google.com>
 <d57c8374-3803-2038-c83c-627ee5d4523f@huawei.com>
 <CANn89iLhD=tMjYRscr51uSGWtt_0Fggh48G8niDxYA8jHNay_g@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <88402539-2d87-7508-c36a-03279b4257fd@huawei.com>
Date:   Thu, 23 Feb 2023 17:18:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLhD=tMjYRscr51uSGWtt_0Fggh48G8niDxYA8jHNay_g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/2/23 16:27, Eric Dumazet wrote:
> On Thu, Feb 23, 2023 at 1:48 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2023/2/23 8:07, Eric Dumazet wrote:
>>> dev_kfree_skb() is aliased to consume_skb().
>>>
>>> When a driver is dropping a packet by calling dev_kfree_skb_any()
>>> we should propagate the drop reason instead of pretending
>>> the packet was consumed.
>>>
>>> Note: Now we have enum skb_drop_reason we could remove
>>> enum skb_free_reason (for linux-6.4)
>>>
>>> Fixes: e6247027e517 ("net: introduce dev_consume_skb_any()")
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> ---
>>>  net/core/dev.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index 18dc8d75ead9795163ace74e8e86fe35cb9b7552..2bf60afde1e2e4be4806070754ae7486705c5237 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -3134,8 +3134,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
>>>  {
>>>       if (in_hardirq() || irqs_disabled())
>>>               __dev_kfree_skb_irq(skb, reason);
>>> +     else if (reason == SKB_REASON_DROPPED)
>>
>> Perhaps add the unlikely() for the SKB_REASON_DROPPED case
>> as it is uesed in data path.
> 
> Sure I can do this, I will send a v2.
> 
> Note that I plan to switch the whole thing when net-next opens with
> something like this
> (showing not complete patch of course)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 2bf60afde1e2e4be4806070754ae7486705c5237..67baed2c8c5ef6577a2256c02c300947b8a919b7
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3130,16 +3130,14 @@ void __dev_kfree_skb_irq(struct sk_buff *skb,
> enum skb_free_reason reason)
>  }
>  EXPORT_SYMBOL(__dev_kfree_skb_irq);
> 
> -void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
> +void dev_kfree_skb_any_reason(struct sk_buff *skb, enum skb_drop_reason reason)
>  {
>         if (in_hardirq() || irqs_disabled())
>                 __dev_kfree_skb_irq(skb, reason);
> -       else if (reason == SKB_REASON_DROPPED)
> -               kfree_skb(skb);
>         else
> -               consume_skb(skb);
> +               kfree_skb_reason(skb, reason);

Yes, it should remove one additional checking branch.

>  }
> -EXPORT_SYMBOL(__dev_kfree_skb_any);
> +EXPORT_SYMBOL(dev_kfree_skb_any_reason);
> 
> 
>  /**
> .
> 

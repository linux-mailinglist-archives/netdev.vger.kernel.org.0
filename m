Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6FE271E28
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgIUIkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:40:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41486 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbgIUIkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 04:40:13 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8CE2CAB2206491486E5A;
        Mon, 21 Sep 2020 16:40:11 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 16:40:04 +0800
Subject: Re: [PATCH net-next] net: use in_softirq() to indicate the NAPI
 context in napi_consume_skb()
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linmiaohe <linmiaohe@huawei.com>, <martin.varghese@nokia.com>,
        "Florian Westphal" <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>, <kyk.segfault@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
References: <1600653893-206277-1-git-send-email-linyunsheng@huawei.com>
 <CANn89iLHH=CRzz5tavy_KEg0mhgXkhD9DBfh9bhcqSkcZ2xaaA@mail.gmail.com>
 <2102eba1-eeea-bf95-2df5-7fcfa3141694@huawei.com>
 <CANn89i+ADkkEFDM=zpm3nHu6XjcACwPrhvG-eZ8GfWot9eo57w@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a5ac987f-eac5-a8c6-59db-aa383eb82598@huawei.com>
Date:   Mon, 21 Sep 2020 16:40:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+ADkkEFDM=zpm3nHu6XjcACwPrhvG-eZ8GfWot9eo57w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/21 16:17, Eric Dumazet wrote:
> On Mon, Sep 21, 2020 at 10:10 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2020/9/21 15:19, Eric Dumazet wrote:
>>> On Mon, Sep 21, 2020 at 4:08 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>
>>>> When napi_consume_skb() is called in the tx desc cleaning process,
>>>> it is usually in the softirq context(BH disabled, or are processing
>>>> softirqs), but it may also be in the task context, such as in the
>>>> netpoll or loopback selftest process.
>>>>
>>>> Currently napi_consume_skb() uses non-zero budget to indicate the
>>>> NAPI context, the driver writer may provide the wrong budget when
>>>> tx desc cleaning function is reused for both NAPI and non-NAPI
>>>> context, see [1].
>>>>
>>>> So this patch uses in_softirq() to indicate the NAPI context, which
>>>> doesn't necessarily mean in NAPI context, but it shouldn't care if
>>>> NAPI context or not as long as it runs in softirq context or with BH
>>>> disabled, then _kfree_skb_defer() will push the skb to the particular
>>>> cpu' napi_alloc_cache atomically.
>>>>
>>>> [1] https://lkml.org/lkml/2020/9/15/38
>>>>
>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>> ---
>>>> note that budget parameter is not removed in this patch because it
>>>> involves many driver changes, we can remove it in separate patch if
>>>> this patch is accepted.
>>>> ---
>>>>  net/core/skbuff.c | 6 ++++--
>>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>> index e077447..03d0d28 100644
>>>> --- a/net/core/skbuff.c
>>>> +++ b/net/core/skbuff.c
>>>> @@ -895,8 +895,10 @@ void __kfree_skb_defer(struct sk_buff *skb)
>>>>
>>>>  void napi_consume_skb(struct sk_buff *skb, int budget)
>>>>  {
>>>> -       /* Zero budget indicate non-NAPI context called us, like netpoll */
>>>> -       if (unlikely(!budget)) {
>>>> +       /* called by non-softirq context, which usually means non-NAPI
>>>> +        * context, like netpoll.
>>>> +        */
>>>> +       if (unlikely(!in_softirq())) {
>>>>                 dev_consume_skb_any(skb);
>>>>                 return;
>>>>         }
>>>> --
>>>
>>>
>>> I do not think we should add this kind of fuzzy logic, just because
>>> _one_ driver author made a mistake.
>>>
>>> Add a disable_bh() in the driver slow path, and accept the _existing_
>>> semantic, the one that was understood by dozens.
>>
>> As my understanding, this patch did not change _existing_ semantic,
>> it still only call _kfree_skb_defer() in softirq context. This patch
>> just remove the requirement that a softirq context hint need to be
>> provided to decide whether calling _kfree_skb_defer().
> 
> I do not want to remove the requirement.
> 
>>
>> Yes, we can add DEBUG_NET() clauses to catch this kind of error as
>> you suggested.
>>
>> But why we need such a debug clauses, when we can decide if delaying
>> skb freeing is possible in napi_consume_skb(), why not just use
>> in_softirq() to make this API more easy to use? Just as __dev_kfree_skb_any()
>> API use "in_irq() || irqs_disabled()" checking to handle the irq context
>> and non-irq context.
> 
> 
> I just do not like your patch.
> 
> Copying another piece of fuzzy logic, inherited from legacy code is
> not an excuse.
> 
> Add a local_bh_disable() in the driver slow path to meet _existing_
> requirement, so that we can keep the hot path fast.

"!in_softirq()" checking make the napi_consume_skb() slower than
"!budget" checking? do I miss something?

As a matter of fact, the hns3 driver has fixed this problem by
passing zero-budget to napi_consume_skb() in non-NAPI context, this
patch is more about how to avoid or catch this kind of error.

So your opinion is still to catch this kind of error using something
like DEBUG_NET() clauses?

> .
> 

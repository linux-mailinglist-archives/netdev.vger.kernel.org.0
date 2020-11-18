Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916262B7402
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgKRB5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:57:41 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7946 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKRB5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:57:41 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CbQtH5PmbzhcF4;
        Wed, 18 Nov 2020 09:57:27 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Nov 2020 09:57:30 +0800
Subject: Re: [PATCH net-next] net: add in_softirq() debug checking in
 napi_consume_skb()
To:     Jakub Kicinski <kuba@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
CC:     <davem@davemloft.net>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <fw@strlen.de>, <gnault@redhat.com>,
        <steffen.klassert@secunet.com>, <kyk.segfault@gmail.com>,
        <viro@zeniv.linux.org.uk>, <vladimir.oltean@nxp.com>,
        <edumazet@google.com>, <saeed@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1603971288-4786-1-git-send-email-linyunsheng@huawei.com>
 <20201031153824.7ae83b90@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5b04ad33-1611-8d7b-8fec-4269c01ecab3@huawei.com>
 <20201102114110.4a20d461@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5bd6de52-b8e0-db6f-3362-862ae7b2c728@huawei.com>
Date:   Wed, 18 Nov 2020 09:57:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20201102114110.4a20d461@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/3 3:41, Jakub Kicinski wrote:
> On Mon, 2 Nov 2020 11:14:32 +0800 Yunsheng Lin wrote:
>> On 2020/11/1 6:38, Jakub Kicinski wrote:
>>> On Thu, 29 Oct 2020 19:34:48 +0800 Yunsheng Lin wrote:  
>>>> The current semantic for napi_consume_skb() is that caller need
>>>> to provide non-zero budget when calling from NAPI context, and
>>>> breaking this semantic will cause hard to debug problem, because
>>>> _kfree_skb_defer() need to run in atomic context in order to push
>>>> the skb to the particular cpu' napi_alloc_cache atomically.
>>>>
>>>> So add a in_softirq() debug checking in napi_consume_skb() to catch
>>>> this kind of error.
>>>>
>>>> Suggested-by: Eric Dumazet <edumazet@google.com>
>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>  
>>>   
>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>> index 1ba8f01..1834007 100644
>>>> --- a/net/core/skbuff.c
>>>> +++ b/net/core/skbuff.c
>>>> @@ -897,6 +897,10 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
>>>>  		return;
>>>>  	}
>>>>  
>>>> +	DEBUG_NET_WARN(!in_softirq(),
>>>> +		       "%s is called with non-zero budget outside softirq context.\n",
>>>> +		       __func__);  
>>>
>>> Can't we use lockdep instead of defining our own knobs?  
>>
>> From the first look, using the below seems better than defining our
>> own knobs, because there is similar lockdep_assert_in_irq() checking
>> already and lockdep_assert_in_*() is NULL-OP when CONFIG_PROVE_LOCKING
>> is not defined.
>>
>>>
>>> Like this maybe?
>>>
>>> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
>>> index f5594879175a..5253a167d00c 100644
>>> --- a/include/linux/lockdep.h
>>> +++ b/include/linux/lockdep.h
>>> @@ -594,6 +594,14 @@ do {                                                                       \
>>>                       this_cpu_read(hardirqs_enabled)));                \
>>>  } while (0)
>>>  
>>> +#define lockdep_assert_in_softirq()                                    \
>>> +do {                                                                   \
>>> +       WARN_ON_ONCE(__lockdep_enabled                  &&              \
>>> +                    (softirq_count() == 0              ||              \
>>> +                     this_cpu_read(hardirq_context)));                 \  
>>
>> Using in_softirq() seems more obvious then using softirq_count()?
>> And there is below comment above avoiding the using of in_softirq(), maybe
>> that is why you use softirq_count() directly here?
>> "softirq_count() == 0" still mean we are not in the SoftIRQ context and
>> BH is not disabled. right? Perhap lockdep_assert_in_softirq_or_bh_disabled()
>> is more obvious?
> 
> Let's add Peter to the recipients to get his opinion.
> 
> We have a per-cpu resource which is also accessed from BH (see
> _kfree_skb_defer()).
> 
> We're trying to come up with the correct lockdep incantation for it.

Hi, Peter
	Any suggestion?

> 
>> /*
>>  * Are we doing bottom half or hardware interrupt processing?
>>  *
>>  * in_irq()       - We're in (hard) IRQ context
>>  * in_softirq()   - We have BH disabled, or are processing softirqs
>>  * in_interrupt() - We're in NMI,IRQ,SoftIRQ context or have BH disabled
>>  * in_serving_softirq() - We're in softirq context
>>  * in_nmi()       - We're in NMI context
>>  * in_task()	  - We're in task context
>>  *
>>  * Note: due to the BH disabled confusion: in_softirq(),in_interrupt() really
>>  *       should not be used in new code.
>>  */
>>
>>
>> Also, is there any particular reason we do the "this_cpu_read(hardirq_context)"
>> checking?
> 
> Accessing BH resources from a hard IRQ context would be a bug, we may
> have interrupted a BH, so AFAIU softirq_count() != 0, but we can nest
> calls to _kfree_skb_defer().

In that case, maybe just call lockdep_assert_in_irq() is enough?

> .
> 

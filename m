Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76D04102BC
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 03:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhIRBod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 21:44:33 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9745 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhIRBob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 21:44:31 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HBD8B2qTRzW4M7;
        Sat, 18 Sep 2021 09:42:02 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 18 Sep 2021 09:43:06 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Sat, 18 Sep
 2021 09:43:06 +0800
Subject: Re: [PATCH net-next v2 3/3] skbuff: keep track of pp page when
 __skb_frag_ref() is called
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Jesper Dangaard Brouer <jbrouer@redhat.com>, <brouer@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <hawk@kernel.org>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
References: <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com>
 <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
 <YUMD2v7ffs1xAjaW@apalos.home>
 <ac16cc82-8d98-6a2c-b0a6-7c186808c72c@huawei.com>
 <YUMelDd16Aw8w5ZH@apalos.home>
 <e2e127be-c9e4-5236-ba3c-28fdb53aa29b@huawei.com>
 <YUMxKhzm+9MDR0jW@apalos.home>
 <36676c07-c2ca-bbd2-972c-95b4027c424f@huawei.com>
 <YUQ3ySFxc/DWzsMy@apalos.home>
 <4a682251-3b40-b16a-8999-69acb36634f3@huawei.com>
 <YUStryKMMhhqbQdz@Iliass-MBP>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5d8232b1-4b85-f755-a92a-d305bff9eab3@huawei.com>
Date:   Sat, 18 Sep 2021 09:43:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YUStryKMMhhqbQdz@Iliass-MBP>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/17 23:01, Ilias Apalodimas wrote:
>>>>>>> In that case you'd need to call virt_to_head_page() early though, get it
> [...]
>>>>>>> and then compare the signature.   I guess that's avoidable by using 
>>>>>>> frag->bv_page for the fragments?
>>>>>>
>>>>>> If a page of a skb frag is from page pool, It seems frag->bv_page is
>>>>>> always point to head_page of a compound page, so the calling of
>>>>>> virt_to_head_page() does not seems necessary.
>>>>>>
>>>>>
>>>>> I was mostly referring to the skb head here and how would you trigger the
>>>>> recycling path. 
>>>>>
>>>>> I think we are talking about different things here.  
>>>>> One idea is to use the last bit of frag->bv_page to identify fragments
>>>>> allocated from page_pool, which is done today with the signature.
>>>>>
>>>>> The signature however exists in the head page so my question was, can we rid
>>>>> of that without having a performance penalty?
>>>>
>>>> As both skb frag and head page is eventually operated on the head page
>>>> of a compound page(if it is a compound page) for normal case too, maybe
>>>> we can refactor the code to get the head page of a compound page before
>>>> the signature checking without doing a second virt_to_head_page() or
>>>> compound_head() call?
>>>
>>> Yea that's doable, but my concern is different here.  If we do that the
>>> standard network stack, even for drivers that don't use page_pool,  will
>>> have to do a virt_to_head_page() -> check signature, to decide if it has to
>>> try recycling the packet.  That's the performance part I am worried about,
>>> since it happens for every packet. 
>>
>> Yes, there is theoretically performance penalty for virt_to_head_page() or
>> compound_head(), will do more test if we decide to go with the signature
>> checking.
> 
> Can we check this somehow?  I can send a patch for this,  but my 
> testing is limited to 1Gbit for the recycling.  I can find
> 25/100Gbit interfaces for the 'normal' path.

I have done the signature checking for frag page of a skb, I am not
able to see noticable change between patched(patched with this patch) and
unpatched, for small packet drop test case(perfermance data is about 34Mpps).

As the hns3 driver does not use the build_skb() API, so I am not able to test
the signature checking penalty for head page of a skb, any chance to do the
testing for head page of a skb on your side?

> 
>>
>>>
>>>>
>>>>>
>>>>> IOW in skb_free_head() an we replace:
>>>>>
>>>>> if (skb_pp_recycle(skb, head)) 
>>>>> with
>>>>> if (page->pp_magic & ~0x3UL) == PP_SIGNATURE)
>>>>> and get rid of the 'bool recycle' argument in __skb_frag_unref()?
>>>>
>>>> For the frag page of a skb, it seems ok to get rid of the 'bool recycle'
>>>> argument in __skb_frag_unref(), as __skb_frag_unref() and __skb_frag_ref()
>>>> is symmetrically called to put/get a page.
>>>>
>>>> For the head page of a skb, we might need to make sure the head page
>>>> passed to __build_skb_around() meet below condition:
>>>> do pp_frag_count incrementing instead of _refcount incrementing when
>>>> the head page is not newly allocated and it is from page pool.
>>>> It seems hard to audit that?
>>>
>>> Yea that seems a bit weird at least to me and I am not sure, it's the only
>>> place we'll have to go and do that.
>>
>> Yes, That is why I avoid changing the behavior of a head page for a skb.
>> In other word, maybe we should not track if head page for a skb is pp page
>> or not when the page'_refcount is incremented during network stack journey,
>> just treat it as normal page?
>>  
> 
> I am not sure I understand this.

I was saying only treat the head page of a skb as pp page when it is newly
allocated from page pool, if that page is reference-counted to build another
head page for another skb later, just treat it as normal page.

> 
>>>
>>>>
>>>>
>>>>>
>>>>>> bit 0 of frag->bv_page is different way of indicatior for a pp page,
>>>>>> it is better we do not confuse with the page signature way. Using
>>>>>> a bit 0 may give us a free word in 'struct page' if we manage to
>>>>>> use skb->pp_recycle to indicate a head page of the skb uniquely, meaning
>>>>>> page->pp_magic can be used for future feature.
>>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>> for pp_recycle right now?  __skb_frag_unref() in skb_shift() or
>>>>>>>>> skb_try_coalesce() (the latter can probably be removed tbh).
>>>>>>>>
>>>>>>>> If we decide to go with accurate indicator of a pp page, we just need
>>>>>>>> to make sure network stack use __skb_frag_unref() and __skb_frag_ref()
>>>>>>>> to put and get a page frag, the indicator checking need only done in
>>>>>>>> __skb_frag_unref() and __skb_frag_ref(), so the skb_shift() and
>>>>>>>> skb_try_coalesce() should be fine too.
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Another way is to use the bit 0 of frag->bv_page ptr to indicate if a frag
>>>>>>>>>> page is from page pool.
>>>>>>>>>
>>>>>>>>> Instead of the 'struct page' signature?  And the pp_recycle bit will
>>>>>>>>> continue to exist?  
>>>>>>>>
>>>>>>>> pp_recycle bit might only exist or is only used for the head page for the skb.
>>>>>>>> The bit 0 of frag->bv_page ptr can be used to indicate a frag page uniquely.
>>>>>>>> Doing a memcpying of shinfo or "*fragto = *fragfrom" automatically pass the
>>>>>>>> indicator to the new shinfo before doing a __skb_frag_ref(), and __skb_frag_ref()
>>>>>>>> will increment the _refcount or pp_frag_count according to the bit 0 of
>>>>>>>> frag->bv_page.
>>>>>>>>
>>>>>>>> By the way, I also prototype the above idea, and it seems to work well too.
>>>>>>>>
>>>>>>>
>>>>>>> As long as no one else touches this, it's just another way of identifying a
>>>>>>> page_pool allocated page.  But are we gaining by that?  Not using
>>>>>>> virt_to_head_page() as stated above? But in that case you still need to
>>>>>>> keep pp_recycle around. 
>>>>>>
>>>>>> No, we do not need the pp_recycle, as long as the we make sure __skb_frag_ref()
>>>>>> is called after memcpying the shinfo or doing "*fragto = *fragfrom".
>>>>>
>>>>> But we'll have to keep it for the skb head in this case.
>>>>
>>>> As above, I am not really look into skb head case:)
>>>
>>> Let me take a step back here, because I think we drifted a bit. 
>>> The page signature was introduced in order to be able to identify skb
>>> fragments. The problem was that you couldn't rely on the pp_recycle bit of
>>> the skb head,  since fragments could come from anywhere.  So you use the
>>> skb bit as a hint for skb frags, and you eventually decide using the page
>>> signature.
>>>
>>> So we got 3 options (Anything I've missed ?)
>>> - try to remove pp_recycle bit, since the page signature is enough for the
>>>   skb head and fragments.  That in my opinion is the cleanest option,  as
>>>   long as we can prove there's no performance hit on the standard network
>>>   path.
>>>
>>> - Replace the page signature with frag->bv_page bit0.  In that case we
>>>   still have to keep the pp_recycle bit,  but we do have an 'easier'
>>>   indication that a skb frag comes from page_pool.  That's still pretty
>>>   safe, since you now have unique identifiers for the skb and page
>>>   fragments and you can be sure of their origin (page pool or not).
>>>   What I am missing here, is what do we get out of this?  I think the
>>>   advantage is not having to call virt_to_head_page() for frags ?
>>
>> Not using the signature will free a word space in struct page for future
>> feature?
> 
> Yea that's another thing we gain,  but I am not sure how useful how this is
> going to turn out.  
> 
>>
>>>
>>> - Keep all of them(?) and use frag->bv_page bit0 similarly to pp_recycle
>>>   bit?  I don't see much value on this one,  I am just keeping it here for
>>>   completeness.
>>
>>
>> For safty and performance reason:
>> 1. maybe we should move the pp_recycle bit from "struct sk_buff" to
>>    "struct skb_shared_info", and use it to only indicate if the head page of
>>    a skb is from page pool.
> 
> What's the safety or performance we gain out of this?  The only performance

safety is that we still have two ways to indicate a pp page.
the pp_recycle bit in  "struct skb_shared_info" or frag->bv_page bit0 tell
if we want to treat a page as pp page, the page signature checking is used
to tell if we if set those bits correctly?

> I can think of is the dirty cache line of the recycle bit we set to 0.
> If we do move it to skb_shared)info we'll have to make sure it's on the
> same cacheline as the ones we already change.

Yes, when we move the pp_recycle bit to skb_shared_info, that bit is only
set once, and we seems to not need to worry about skb doing cloning or
expanding as the it is part of head page(shinfo is part of head page).

>>
>> 2. The frag->bv_page bit0 is used to indicate if the frag page of a skb is
>>    from page pool, and modify __skb_frag_unref() and __skb_frag_ref() to keep
>>    track of it.
>>
>> 3. For safty or debugging reason, keep the page signature for now, and put a
>>    page signature WARN_ON checking in page pool to catch any misbehaviour?
>>
>> If there is not bug showing up later, maybe we can free the page signature space
>> for other usage?
> 
> Yea that's essentially identical to (2) but we move the pp_recycle on the
> skb_shared_info.  I'd really prefer getting rid of the pp_recycle entirely,

When also removing the pp_recycle for head page of a skb, it seems a little
risky as we are not sure when a not-newly-allocated pp page is called with
__build_skb_around() to build to head page?


> since it's the cleanest thing we can do in my head.  If we ever need an
> extra 4/8 bytes in the future,  we can always go back and implement this.
> 
> Alexander/Jesper any additional thoughts?
> 
> Regards
> /Ilias
>>
>>>
>>> Thanks
>>> /Ilias
>>
> .
> 

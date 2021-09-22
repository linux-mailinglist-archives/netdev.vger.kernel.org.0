Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141D9414019
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 05:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhIVDj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 23:39:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9752 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhIVDj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 23:39:56 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HDkWH3TYYzWM09;
        Wed, 22 Sep 2021 11:37:15 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 11:38:25 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Wed, 22 Sep
 2021 11:38:24 +0800
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
References: <YUMD2v7ffs1xAjaW@apalos.home>
 <ac16cc82-8d98-6a2c-b0a6-7c186808c72c@huawei.com>
 <YUMelDd16Aw8w5ZH@apalos.home>
 <e2e127be-c9e4-5236-ba3c-28fdb53aa29b@huawei.com>
 <YUMxKhzm+9MDR0jW@apalos.home>
 <36676c07-c2ca-bbd2-972c-95b4027c424f@huawei.com>
 <YUQ3ySFxc/DWzsMy@apalos.home>
 <4a682251-3b40-b16a-8999-69acb36634f3@huawei.com>
 <YUStryKMMhhqbQdz@Iliass-MBP>
 <5d8232b1-4b85-f755-a92a-d305bff9eab3@huawei.com>
 <YUWwESRQbloKWBND@Iliass-MBP>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <91cd084f-f8a3-19e7-42d7-95138378aa9d@huawei.com>
Date:   Wed, 22 Sep 2021 11:38:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YUWwESRQbloKWBND@Iliass-MBP>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/18 17:23, Ilias Apalodimas wrote:
> [...]
> 

[...]

>>>>>>
>>>>>>>
>>>>>>> IOW in skb_free_head() an we replace:
>>>>>>>
>>>>>>> if (skb_pp_recycle(skb, head)) 
>>>>>>> with
>>>>>>> if (page->pp_magic & ~0x3UL) == PP_SIGNATURE)
>>>>>>> and get rid of the 'bool recycle' argument in __skb_frag_unref()?
>>>>>>
>>>>>> For the frag page of a skb, it seems ok to get rid of the 'bool recycle'
>>>>>> argument in __skb_frag_unref(), as __skb_frag_unref() and __skb_frag_ref()
>>>>>> is symmetrically called to put/get a page.
>>>>>>
>>>>>> For the head page of a skb, we might need to make sure the head page
>>>>>> passed to __build_skb_around() meet below condition:
>>>>>> do pp_frag_count incrementing instead of _refcount incrementing when
>>>>>> the head page is not newly allocated and it is from page pool.
>>>>>> It seems hard to audit that?
>>>>>
>>>>> Yea that seems a bit weird at least to me and I am not sure, it's the only
>>>>> place we'll have to go and do that.
>>>>
>>>> Yes, That is why I avoid changing the behavior of a head page for a skb.
>>>> In other word, maybe we should not track if head page for a skb is pp page
>>>> or not when the page'_refcount is incremented during network stack journey,
>>>> just treat it as normal page?
>>>>  
>>>
>>> I am not sure I understand this.
>>
>> I was saying only treat the head page of a skb as pp page when it is newly
>> allocated from page pool, if that page is reference-counted to build another
>> head page for another skb later, just treat it as normal page.
> 
> But the problem here is that a cloned/expanded SKB could trigger a race
> when freeing the fragments.  That's why we reset the pp_recycle bit if
> there's still references to the frags.  What does 'normal' page means here?
> We'll have to at least unmap dma part.

'normal' page means non-pp page here. Maybe forget the above.

I read the code related to head page headling for a skb, it seems the
NAPI_GRO_FREE_STOLEN_HEAD and skb_head_frag_to_page_desc() case is just
fine as it is now when the page signature is used to identify a pp page
for the head page of a skb uniquely?

> 
>>
>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>>> bit 0 of frag->bv_page is different way of indicatior for a pp page,
>>>>>>>> it is better we do not confuse with the page signature way. Using
>>>>>>>> a bit 0 may give us a free word in 'struct page' if we manage to
>>>>>>>> use skb->pp_recycle to indicate a head page of the skb uniquely, meaning
>>>>>>>> page->pp_magic can be used for future feature.
>>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> for pp_recycle right now?  __skb_frag_unref() in skb_shift() or
>>>>>>>>>>> skb_try_coalesce() (the latter can probably be removed tbh).
>>>>>>>>>>
>>>>>>>>>> If we decide to go with accurate indicator of a pp page, we just need
>>>>>>>>>> to make sure network stack use __skb_frag_unref() and __skb_frag_ref()
>>>>>>>>>> to put and get a page frag, the indicator checking need only done in
>>>>>>>>>> __skb_frag_unref() and __skb_frag_ref(), so the skb_shift() and
>>>>>>>>>> skb_try_coalesce() should be fine too.
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Another way is to use the bit 0 of frag->bv_page ptr to indicate if a frag
>>>>>>>>>>>> page is from page pool.
>>>>>>>>>>>
>>>>>>>>>>> Instead of the 'struct page' signature?  And the pp_recycle bit will
>>>>>>>>>>> continue to exist?  
>>>>>>>>>>
>>>>>>>>>> pp_recycle bit might only exist or is only used for the head page for the skb.
>>>>>>>>>> The bit 0 of frag->bv_page ptr can be used to indicate a frag page uniquely.
>>>>>>>>>> Doing a memcpying of shinfo or "*fragto = *fragfrom" automatically pass the
>>>>>>>>>> indicator to the new shinfo before doing a __skb_frag_ref(), and __skb_frag_ref()
>>>>>>>>>> will increment the _refcount or pp_frag_count according to the bit 0 of
>>>>>>>>>> frag->bv_page.
>>>>>>>>>>
>>>>>>>>>> By the way, I also prototype the above idea, and it seems to work well too.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> As long as no one else touches this, it's just another way of identifying a
>>>>>>>>> page_pool allocated page.  But are we gaining by that?  Not using
>>>>>>>>> virt_to_head_page() as stated above? But in that case you still need to
>>>>>>>>> keep pp_recycle around. 
>>>>>>>>
>>>>>>>> No, we do not need the pp_recycle, as long as the we make sure __skb_frag_ref()
>>>>>>>> is called after memcpying the shinfo or doing "*fragto = *fragfrom".
>>>>>>>
>>>>>>> But we'll have to keep it for the skb head in this case.
>>>>>>
>>>>>> As above, I am not really look into skb head case:)
>>>>>
>>>>> Let me take a step back here, because I think we drifted a bit. 
>>>>> The page signature was introduced in order to be able to identify skb
>>>>> fragments. The problem was that you couldn't rely on the pp_recycle bit of
>>>>> the skb head,  since fragments could come from anywhere.  So you use the
>>>>> skb bit as a hint for skb frags, and you eventually decide using the page
>>>>> signature.
>>>>>
>>>>> So we got 3 options (Anything I've missed ?)
>>>>> - try to remove pp_recycle bit, since the page signature is enough for the
>>>>>   skb head and fragments.  That in my opinion is the cleanest option,  as
>>>>>   long as we can prove there's no performance hit on the standard network
>>>>>   path.
>>>>>
>>>>> - Replace the page signature with frag->bv_page bit0.  In that case we
>>>>>   still have to keep the pp_recycle bit,  but we do have an 'easier'
>>>>>   indication that a skb frag comes from page_pool.  That's still pretty
>>>>>   safe, since you now have unique identifiers for the skb and page
>>>>>   fragments and you can be sure of their origin (page pool or not).
>>>>>   What I am missing here, is what do we get out of this?  I think the
>>>>>   advantage is not having to call virt_to_head_page() for frags ?
>>>>
>>>> Not using the signature will free a word space in struct page for future
>>>> feature?
>>>
>>> Yea that's another thing we gain,  but I am not sure how useful how this is
>>> going to turn out.  
>>>
>>>>
>>>>>
>>>>> - Keep all of them(?) and use frag->bv_page bit0 similarly to pp_recycle
>>>>>   bit?  I don't see much value on this one,  I am just keeping it here for
>>>>>   completeness.
>>>>
>>>>
>>>> For safty and performance reason:
>>>> 1. maybe we should move the pp_recycle bit from "struct sk_buff" to
>>>>    "struct skb_shared_info", and use it to only indicate if the head page of
>>>>    a skb is from page pool.
>>>
>>> What's the safety or performance we gain out of this?  The only performance
>>
>> safety is that we still have two ways to indicate a pp page.
>> the pp_recycle bit in  "struct skb_shared_info" or frag->bv_page bit0 tell
>> if we want to treat a page as pp page, the page signature checking is used
>> to tell if we if set those bits correctly?
>>
> 
> Yea but in the long run we'll want the page signature.  So that's basically
> (2) once we do that.
> 
>>> I can think of is the dirty cache line of the recycle bit we set to 0.
>>> If we do move it to skb_shared)info we'll have to make sure it's on the
>>> same cacheline as the ones we already change.
>>
>> Yes, when we move the pp_recycle bit to skb_shared_info, that bit is only
>> set once, and we seems to not need to worry about skb doing cloning or
>> expanding as the it is part of head page(shinfo is part of head page).
>>
>>>>
>>>> 2. The frag->bv_page bit0 is used to indicate if the frag page of a skb is
>>>>    from page pool, and modify __skb_frag_unref() and __skb_frag_ref() to keep
>>>>    track of it.
>>>>
>>>> 3. For safty or debugging reason, keep the page signature for now, and put a
>>>>    page signature WARN_ON checking in page pool to catch any misbehaviour?
>>>>
>>>> If there is not bug showing up later, maybe we can free the page signature space
>>>> for other usage?
>>>
>>> Yea that's essentially identical to (2) but we move the pp_recycle on the
>>> skb_shared_info.  I'd really prefer getting rid of the pp_recycle entirely,
>>
>> When also removing the pp_recycle for head page of a skb, it seems a little
>> risky as we are not sure when a not-newly-allocated pp page is called with
>> __build_skb_around() to build to head page?
> 
> Removing the pp_recyle, is only safe if we keep the page signature.  I was
> suggesting we follow (1) first before starting moving things around.

I suppose (1) means the below, right:

> - try to remove pp_recycle bit, since the page signature is enough for the
>   skb head and fragments.  That in my opinion is the cleanest option,  as
>   long as we can prove there's no performance hit on the standard network
>   path.

It seems doable if my above analysis of head page headling for a skb does not
miss anything.

> 
>>
>>> since it's the cleanest thing we can do in my head.  If we ever need an
>>> extra 4/8 bytes in the future,  we can always go back and implement this.
>>>
>>> Alexander/Jesper any additional thoughts?
>>>
> 
> Thanks
> /Ilias
> .
> 

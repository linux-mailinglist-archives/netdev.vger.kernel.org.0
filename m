Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FE540D18A
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 04:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhIPCHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 22:07:14 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:16216 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbhIPCHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 22:07:13 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4H90lQ2twvz1DGrc;
        Thu, 16 Sep 2021 10:04:50 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 16 Sep 2021 10:05:51 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Thu, 16 Sep
 2021 10:05:51 +0800
Subject: Re: [Linuxarm] Re: [PATCH net-next v2 3/3] skbuff: keep track of pp
 page when __skb_frag_ref() is called
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     <brouer@redhat.com>, Alexander Duyck <alexander.duyck@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <hawk@kernel.org>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
References: <20210914121114.28559-1-linyunsheng@huawei.com>
 <20210914121114.28559-4-linyunsheng@huawei.com>
 <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
 <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com>
 <YUHtf+lI8ktBdjsQ@apalos.home>
 <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
Date:   Thu, 16 Sep 2021 10:05:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/15 23:42, Jesper Dangaard Brouer wrote:
> 
> On 15/09/2021 14.56, Ilias Apalodimas wrote:
>> Hi Yunsheng,  Alexander,
>>
>> On Wed, Sep 15, 2021 at 05:07:08PM +0800, Yunsheng Lin wrote:
>>> On 2021/9/15 8:59, Alexander Duyck wrote:
>>>> On Tue, Sep 14, 2021 at 5:12 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>>
>>>>> As the skb->pp_recycle and page->pp_magic may not be enough
>>>>> to track if a frag page is from page pool after the calling
>>>>> of __skb_frag_ref(), mostly because of a data race, see:
>>>>> commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
>>>>> recycling page_pool packets").
>>>>
>>>> I'm not sure how this comment actually applies. It is an issue that
>>>> was fixed. If anything my concern is that this change will introduce
>>>> new races instead of fixing any existing ones.
>>>
>>> My initial thinking about adding the above comment is to emphasize
>>> that we might clear cloned skb's pp_recycle when doing head expanding,
>>> and page pool might need to give up on that page if that cloned skb is
>>> the last one to be freed.
>>>
>>>>
>>>>> There may be clone and expand head case that might lose the
>>>>> track if a frag page is from page pool or not.
>>>>
>>>> Can you explain how? If there is such a case we should fix it instead
>>>> of trying to introduce new features to address it. This seems more
>>>> like a performance optimization rather than a fix.
>>>
>>> Yes, I consider it an optimization too, that's why I am targetting
>>> net-next.
>>>
>>> Even for the below skb_split() case in tso_fragment(), I am not sure
>>> how can a rx pp page can go through the tcp stack yet.
>>
>> I am bit confused :).  We don't have that problem *now* right?  This will
>> appear if we try to pull in your patches on using page pool and recycling
>> for Tx where TSO and skb_split are used?

As my understanding, the problem might exists without tx recycling, because a
skb from wire would be passed down to the tcp stack and retransmited back to
the wire theoretically. As I am not able to setup a configuration to verify
and test it and the handling seems tricky, so I am targetting net-next branch
instead of net branch.

>>
>> I'll be honest, when I came up with the recycling idea for page pool, I
>> never intended to support Tx.  I agree with Alexander here,  If people want
>> to use it on Tx and think there's value,  we might need to go back to the
>> drawing board and see what I've missed.  It's still early and there's a
>> handful of drivers using it,  so it will less painful now.

Yes, we also need to prototype it to see if there is something missing in the
drawing board and how much improvement we get from that:)

> 
> I agree, page_pool is NOT designed or intended for TX support.
> E.g. it doesn't make sense to allocate a page_pool instance per socket, as the backing memory structures for page_pool are too much.
> As the number RX-queues are more limited it was deemed okay that we use page_pool per RX-queue, which sacrifice some memory to gain speed.

As memtioned before, Tx recycling is based on page_pool instance per socket.
it shares the page_pool instance with rx.

Anyway, based on feedback from edumazet and dsahern, I am still trying to
see if the page pool is meaningful for tx.

> 
> 
>> The pp_recycle_bit was introduced to make the checking faster, instead of
>> getting stuff into cache and check the page signature.  If that ends up
>> being counterproductive, we could just replace the entire logic with the
>> frag count and the page signature, couldn't we?  In that case we should be
>> very cautious and measure potential regression on the standard path.
> 
> +1

I am not sure "pp_recycle_bit was introduced to make the checking faster" is a
valid. The size of "struct page" is only about 9 words(36/72 bytes), which is
mostly to be in the same cache line, and both standard path and recycle path have
been touching the "struct page", so it seems the overhead for checking signature
seems minimal.

I agree that we need to be cautious and measure potential regression on the
standard path.

Another way is to use the bit 0 of frag->bv_page ptr to indicate if a frag
page is from page pool.

> 
>> But in general,  I'd be happier if we only had a simple logic in our
>> testing for the pages we have to recycle.  Debugging and understanding this
>> otherwise will end up being a mess.
> 
> 
> [...]
>>>
>>>>
>>>>> For 32 bit systems with 64 bit dma, we preserve the orginial
>>>>> behavior as frag count is used to trace how many time does a
>>>>> frag page is called with __skb_frag_ref().
>>>>>
>>>>> We still use both skb->pp_recycle and page->pp_magic to decide
>>>>> the head page for a skb is from page pool or not.
>>>>>
>>
>> [...]
>>
>>>>>
>>>>> +/**
>>>>> + * skb_frag_is_pp_page - decide if a page is recyclable.
>>>>> + * @page: frag page
>>>>> + * @recycle: skb->pp_recycle
>>>>> + *
>>>>> + * For 32 bit systems with 64 bit dma, the skb->pp_recycle is
>>>>> + * also used to decide if a page can be recycled to the page
>>>>> + * pool.
>>>>> + */
>>>>> +static inline bool skb_frag_is_pp_page(struct page *page,
>>>>> +                                      bool recycle)
>>>>> +{
>>>>> +       return page_pool_is_pp_page(page) ||
>>>>> +               (recycle && __page_pool_is_pp_page(page));
>>>>> +}
>>>>> +
>>>>
>>>> The logic for this check is ugly. You are essentially calling
>>>> __page_pool_is_pp_page again if it fails the first check. It would
>>>> probably make more sense to rearrange things and just call
>>>> (!DMA_USE_PP_FRAG_COUNT || recycle)  && __page_pool_is_pp_page(). With
>>>> that the check of recycle could be dropped entirely if frag count is
>>>> valid to use, and in the non-fragcount case it reverts back to the
>>>> original check.
>>>
>>> The reason I did not do that is I kind of did not want to use the
>>> DMA_USE_PP_FRAG_COUNT outside of page pool.
>>> I can use DMA_USE_PP_FRAG_COUNT directly in skbuff.h if the above
>>> is considered harmless:)
>>>
>>> The 32 bit systems with 64 bit dma really seems a burden here, as
>>> memtioned by Ilias [1], there seems to be no such system using page
>>> pool, we might as well consider disabling page pool for such system?
>>>
>>> Ilias, Jesper, what do you think?
>>>
>>> 1. http://lkml.iu.edu/hypermail/linux/kernel/2107.1/06321.html
>>>
>>
>> Well I can't really disagree with myself too much :).  I still think we are
>> carrying a lot of code and complexity for systems that don't exist.
> 
> I would be fine with rejecting such systems at page_pool setup time. Meaning that NIC drivers using page_pool for DMA-mapping, getting compiled on 32-bit systems and needing 64-bit DMA-mappings, will have their call to page_pool_create() fail (with something else than -EINVAL please).
> If drivers really want work on such systems, they have to implement their own DMA-mapping fallback tracking outside page_pool.  Meaning it is only the keeping track of DMA-mapping part of page_pool they cannot use.

Ok, will send out a patch to reject DMA-mapping support for such system.

> 
> [...]
>>>
>>>>
>>>>> +static inline bool __page_pool_is_pp_page(struct page *page)
>>>>> +{
>>>>> +       /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
>>>>> +        * in order to preserve any existing bits, such as bit 0 for the
>>>>> +        * head page of compound page and bit 1 for pfmemalloc page, so
>>>>> +        * mask those bits for freeing side when doing below checking,
>>>>> +        * and page_is_pfmemalloc() is checked in __page_pool_put_page()
>>>>> +        * to avoid recycling the pfmemalloc page.
>>>>> +        */
>>>>> +       return (page->pp_magic & ~0x3UL) == PP_SIGNATURE;
>>>>> +}
>>>>> +
>>>>> +static inline bool page_pool_is_pp_page(struct page *page)
>>>>> +{
>>>>> +       /* For systems with the same dma addr as the bus addr, we can use
>>>>> +        * page->pp_magic to indicate a pp page uniquely.
>>>>> +        */
>>>>> +       return !PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
>>>>> +                       __page_pool_is_pp_page(page);
>>>>> +}
>>>>> +
>>>>
>>>> We should really change the name of the #define. I keep reading it as
>>>> we are using the PP_FRAG_COUNT, not that it is already in use. Maybe
>>>> we should look at something like PP_FRAG_COUNT_VALID and just invert
>>>> the logic for it.
>>>
>>> Yes, Jesper seems to have the similar confusion.
>>
>> +1
> 
> +1
> 
> 
>>> I seems better that we can remove that macro completely if the 32 bit
>>> systems with 64 bit dma turn out to be not existing at all?
>>>
>>>>
>>>> Also this function naming is really confusing. You don't have to have
>>>> the frag count to be a page pool page. Maybe this should be something
>>>> like page_pool_is_pp_frag_page.
>>>
>>
>> [...]
>>
>> Regards
>> /Ilias
> 
> --Jesper
> _______________________________________________
> Linuxarm mailing list -- linuxarm@openeuler.org
> To unsubscribe send an email to linuxarm-leave@openeuler.org

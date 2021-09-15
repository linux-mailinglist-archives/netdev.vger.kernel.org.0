Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C3F40C262
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 11:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbhIOJIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 05:08:31 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9048 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbhIOJIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 05:08:30 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H8Z813X29zW66K;
        Wed, 15 Sep 2021 17:06:09 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 17:07:08 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Wed, 15 Sep
 2021 17:07:08 +0800
Subject: Re: [PATCH net-next v2 3/3] skbuff: keep track of pp page when
 __skb_frag_ref() is called
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <jonathan.lemon@gmail.com>, <alobakin@pm.me>, <willemb@google.com>,
        <cong.wang@bytedance.com>, <pabeni@redhat.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <memxor@gmail.com>, <edumazet@google.com>, <dsahern@gmail.com>
References: <20210914121114.28559-1-linyunsheng@huawei.com>
 <20210914121114.28559-4-linyunsheng@huawei.com>
 <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com>
Date:   Wed, 15 Sep 2021 17:07:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/15 8:59, Alexander Duyck wrote:
> On Tue, Sep 14, 2021 at 5:12 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> As the skb->pp_recycle and page->pp_magic may not be enough
>> to track if a frag page is from page pool after the calling
>> of __skb_frag_ref(), mostly because of a data race, see:
>> commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
>> recycling page_pool packets").
> 
> I'm not sure how this comment actually applies. It is an issue that
> was fixed. If anything my concern is that this change will introduce
> new races instead of fixing any existing ones.

My initial thinking about adding the above comment is to emphasize
that we might clear cloned skb's pp_recycle when doing head expanding,
and page pool might need to give up on that page if that cloned skb is
the last one to be freed.

> 
>> There may be clone and expand head case that might lose the
>> track if a frag page is from page pool or not.
> 
> Can you explain how? If there is such a case we should fix it instead
> of trying to introduce new features to address it. This seems more
> like a performance optimization rather than a fix.

Yes, I consider it an optimization too, that's why I am targetting
net-next.

Even for the below skb_split() case in tso_fragment(), I am not sure
how can a rx pp page can go through the tcp stack yet.

> 
>> And not being able to keep track of pp page may cause problem
>> for the skb_split() case in tso_fragment() too:
>> Supposing a skb has 3 frag pages, all coming from a page pool,
>> and is split to skb1 and skb2:
>> skb1: first frag page + first half of second frag page
>> skb2: second half of second frag page + third frag page
>>
>> How do we set the skb->pp_recycle of skb1 and skb2?
>> 1. If we set both of them to 1, then we may have a similar
>>    race as the above commit for second frag page.
>> 2. If we set only one of them to 1, then we may have resource
>>    leaking problem as both first frag page and third frag page
>>    are indeed from page pool.
> 
> The question I would have is in the above cases how is skb->pp_recycle
> being set on the second buffer? Is it already coming that way? If so,

As the skb_split() implemention, it takes skb and skb1 for input,
skb have pp_recycle set, and the skb1 is the newly allocated without
pp_recycle set, after skb_split(), some payload of skb is split to
the skb1, how to set the pp_recycle of skb1 seems tricky here.

> maybe you should special case the __skb_frag_ref when you know you are
> loading a recycling skb instead of just assuming you want to do it
> automatically.

I am not sure what does "special case" and "automatically" means here.
One way I can think of is to avoid doing the __skb_frag_ref, and allocate
a new frag for skb1 and do memcpying if there is a sharing frag between
skb and skb1 when splitting. But it seems the allocating a new frag
and memcpying seems much heavier doing the __skb_frag_ref.

> 
>> So increment the frag count when __skb_frag_ref() is called,
>> and only use page->pp_magic to indicate if a frag page is from
>> page pool, to avoid the above data race.
> 
> This assumes the page is only going to be used by the network stack.
> My concern is what happens when the page is pulled out of the skb and
> used for example in storage?

As my understanding, the above case works as before, as if the storage
is holding reference to that page, the page pool will give up on that
page by checking "page_ref_count(page) == 1" when the last user from
network stack has done with a pp page(by checking page->pp_frag_count).

> 
>> For 32 bit systems with 64 bit dma, we preserve the orginial
>> behavior as frag count is used to trace how many time does a
>> frag page is called with __skb_frag_ref().
>>
>> We still use both skb->pp_recycle and page->pp_magic to decide
>> the head page for a skb is from page pool or not.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  include/linux/skbuff.h  | 40 ++++++++++++++++++++++++++++++++++++----
>>  include/net/page_pool.h | 28 +++++++++++++++++++++++++++-
>>  net/core/page_pool.c    | 16 ++--------------
>>  3 files changed, 65 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> index 35eebc2310a5..4d975ab27078 100644
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -3073,7 +3073,16 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
>>   */
>>  static inline void __skb_frag_ref(skb_frag_t *frag)
>>  {
>> -       get_page(skb_frag_page(frag));
>> +       struct page *page = skb_frag_page(frag);
>> +
>> +#ifdef CONFIG_PAGE_POOL
>> +       if (page_pool_is_pp_page(page)) {
>> +               page_pool_atomic_inc_frag_count(page);
>> +               return;
>> +       }
>> +#endif
>> +
>> +       get_page(page);
>>  }
>>
>>  /**
>> @@ -3088,6 +3097,22 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
>>         __skb_frag_ref(&skb_shinfo(skb)->frags[f]);
>>  }
>>
>> +/**
>> + * skb_frag_is_pp_page - decide if a page is recyclable.
>> + * @page: frag page
>> + * @recycle: skb->pp_recycle
>> + *
>> + * For 32 bit systems with 64 bit dma, the skb->pp_recycle is
>> + * also used to decide if a page can be recycled to the page
>> + * pool.
>> + */
>> +static inline bool skb_frag_is_pp_page(struct page *page,
>> +                                      bool recycle)
>> +{
>> +       return page_pool_is_pp_page(page) ||
>> +               (recycle && __page_pool_is_pp_page(page));
>> +}
>> +
> 
> The logic for this check is ugly. You are essentially calling
> __page_pool_is_pp_page again if it fails the first check. It would
> probably make more sense to rearrange things and just call
> (!DMA_USE_PP_FRAG_COUNT || recycle)  && __page_pool_is_pp_page(). With
> that the check of recycle could be dropped entirely if frag count is
> valid to use, and in the non-fragcount case it reverts back to the
> original check.

The reason I did not do that is I kind of did not want to use the
DMA_USE_PP_FRAG_COUNT outside of page pool.
I can use DMA_USE_PP_FRAG_COUNT directly in skbuff.h if the above
is considered harmless:)

The 32 bit systems with 64 bit dma really seems a burden here, as
memtioned by Ilias [1], there seems to be no such system using page
pool, we might as well consider disabling page pool for such system?

Ilias, Jesper, what do you think?

1. http://lkml.iu.edu/hypermail/linux/kernel/2107.1/06321.html

> 
>>  /**
>>   * __skb_frag_unref - release a reference on a paged fragment.
>>   * @frag: the paged fragment
>> @@ -3101,8 +3126,10 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>>         struct page *page = skb_frag_page(frag);
>>
>>  #ifdef CONFIG_PAGE_POOL
>> -       if (recycle && page_pool_return_skb_page(page))
>> +       if (skb_frag_is_pp_page(page, recycle)) {
>> +               page_pool_return_skb_page(page);
>>                 return;
>> +       }
>>  #endif
>>         put_page(page);
>>  }
>> @@ -4720,9 +4747,14 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
>>
>>  static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
>>  {
>> -       if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
>> +       struct page *page = virt_to_head_page(data);
>> +
>> +       if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle ||
>> +           !__page_pool_is_pp_page(page))
>>                 return false;
>> -       return page_pool_return_skb_page(virt_to_head_page(data));
>> +
>> +       page_pool_return_skb_page(page);
>> +       return true;
>>  }
>>
>>  #endif /* __KERNEL__ */
> 
> As I recall the virt_to_head_page isn't necessarily a cheap call as it
> can lead to quite a bit of pointer chasing and a few extra math steps
> to do the virt to page conversion. I would be curious how much extra
> overhead this is adding to the non-fragcount or non-recycling case.

As the page pool can only deal with head_page as the checking of
"page_ref_count(page) == 1" in __page_pool_put_page() seems requiring
head_page, and skb_free_frag() in skb_free_head() seems to operate on
the head_page, so I assume the overhead is minimal?

> 
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index 2ad0706566c5..eb103d86f453 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -164,7 +164,7 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
>>         return pool->p.dma_dir;
>>  }
>>
>> -bool page_pool_return_skb_page(struct page *page);
>> +void page_pool_return_skb_page(struct page *page);
>>
>>  struct page_pool *page_pool_create(const struct page_pool_params *params);
>>
>> @@ -244,6 +244,32 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
>>         atomic_long_set(&page->pp_frag_count, nr);
>>  }
>>
>> +static inline void page_pool_atomic_inc_frag_count(struct page *page)
>> +{
>> +       atomic_long_inc(&page->pp_frag_count);
>> +}
>> +
> 
> Your function name is almost as long as the function itself. Maybe you
> don't need it?

It is about avoiding exposing the pp_frag_count outside of page pool.
It is not needed if the above is not a issue:)

> 
>> +static inline bool __page_pool_is_pp_page(struct page *page)
>> +{
>> +       /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
>> +        * in order to preserve any existing bits, such as bit 0 for the
>> +        * head page of compound page and bit 1 for pfmemalloc page, so
>> +        * mask those bits for freeing side when doing below checking,
>> +        * and page_is_pfmemalloc() is checked in __page_pool_put_page()
>> +        * to avoid recycling the pfmemalloc page.
>> +        */
>> +       return (page->pp_magic & ~0x3UL) == PP_SIGNATURE;
>> +}
>> +
>> +static inline bool page_pool_is_pp_page(struct page *page)
>> +{
>> +       /* For systems with the same dma addr as the bus addr, we can use
>> +        * page->pp_magic to indicate a pp page uniquely.
>> +        */
>> +       return !PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
>> +                       __page_pool_is_pp_page(page);
>> +}
>> +
> 
> We should really change the name of the #define. I keep reading it as
> we are using the PP_FRAG_COUNT, not that it is already in use. Maybe
> we should look at something like PP_FRAG_COUNT_VALID and just invert
> the logic for it.

Yes, Jesper seems to have the similar confusion.
I seems better that we can remove that macro completely if the 32 bit
systems with 64 bit dma turn out to be not existing at all?

> 
> Also this function naming is really confusing. You don't have to have
> the frag count to be a page pool page. Maybe this should be something
> like page_pool_is_pp_frag_page.

I am not sure what does the extra *frag* means here.

> 
>>  static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>>                                                           long nr)
>>  {
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 09d7b8614ef5..3a419871d4bc 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -24,7 +24,7 @@
>>  #define DEFER_TIME (msecs_to_jiffies(1000))
>>  #define DEFER_WARN_INTERVAL (60 * HZ)
>>
>> -#define BIAS_MAX       LONG_MAX
>> +#define BIAS_MAX       (LONG_MAX / 2)
>>
>>  static int page_pool_init(struct page_pool *pool,
>>                           const struct page_pool_params *params)
> 
> I still think this would be better as a separate patch calling out the
> fact that you are changing the value with the plan to support
> incrementing it in the future.

Sure.

> 
>> @@ -736,20 +736,10 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
>>  }
>>  EXPORT_SYMBOL(page_pool_update_nid);
>>
>> -bool page_pool_return_skb_page(struct page *page)
>> +void page_pool_return_skb_page(struct page *page)
>>  {
>>         struct page_pool *pp;
>>
>> -       /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
>> -        * in order to preserve any existing bits, such as bit 0 for the
>> -        * head page of compound page and bit 1 for pfmemalloc page, so
>> -        * mask those bits for freeing side when doing below checking,
>> -        * and page_is_pfmemalloc() is checked in __page_pool_put_page()
>> -        * to avoid recycling the pfmemalloc page.
>> -        */
>> -       if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
>> -               return false;
>> -
>>         pp = page->pp;
>>
>>         /* Driver set this to memory recycling info. Reset it on recycle.
>> @@ -758,7 +748,5 @@ bool page_pool_return_skb_page(struct page *page)
>>          * 'flipped' fragment being in use or not.
>>          */
>>         page_pool_put_full_page(pp, page, false);
>> -
>> -       return true;
>>  }
>>  EXPORT_SYMBOL(page_pool_return_skb_page);
>> --
>> 2.33.0
>>
> .
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824E93FC368
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 09:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbhHaHVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 03:21:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8803 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239538AbhHaHVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 03:21:30 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GzJVH1QyyzYw6X;
        Tue, 31 Aug 2021 15:19:51 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 31 Aug 2021 15:20:21 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Tue, 31 Aug
 2021 15:20:20 +0800
Subject: Re: [PATCH net-next 2/2] skbuff: keep track of pp page when
 __skb_frag_ref() is called
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Kevin Hao" <haokexin@gmail.com>, <nogikh@google.com>,
        Marco Elver <elver@google.com>, <memxor@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>
References: <1630286290-43714-1-git-send-email-linyunsheng@huawei.com>
 <1630286290-43714-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0UfmcB93Hn1AS_o2a_h98xxZMouTiGzJfG09qsWf+O6L1Q@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9cf28179-0cd5-a8c5-2bfd-bd844315ad1a@huawei.com>
Date:   Tue, 31 Aug 2021 15:20:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfmcB93Hn1AS_o2a_h98xxZMouTiGzJfG09qsWf+O6L1Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/30 23:14, Alexander Duyck wrote:
> On Sun, Aug 29, 2021 at 6:19 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> As the skb->pp_recycle and page->pp_magic may not be enough
>> to track if a frag page is from page pool after the calling
>> of __skb_frag_ref(), mostly because of a data race, see:
>> commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
>> recycling page_pool packets").
>>
>> There may be clone and expand head case that might lose the
>> track if a frag page is from page pool or not.
>>
>> So increment the frag count when __skb_frag_ref() is called,
>> and only use page->pp_magic to indicate if a frag page is from
>> page pool, to avoid the above data race.
>>
>> For 32 bit systems with 64 bit dma, we preserve the orginial
>> behavior as frag count is used to trace how many time does a
>> frag page is called with __skb_frag_ref().
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> Is this really a common enough case to justify adding this extra overhead?

I am not sure I understand what does extra overhead mean here.
But it seems this patch does not add any explicit overhead?
As the added page_pool_is_pp_page() checking in __skb_frag_ref() is
neutralized by avoiding the recycle checking in __skb_frag_unref(),
and the atomic operation is with either pp_frag_count or _refcount?

> 
>> ---
>>  include/linux/skbuff.h  | 13 ++++++++++++-
>>  include/net/page_pool.h | 17 +++++++++++++++++
>>  net/core/page_pool.c    | 12 ++----------
>>  3 files changed, 31 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> index 6bdb0db..8311482 100644
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -3073,6 +3073,16 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
>>   */
>>  static inline void __skb_frag_ref(skb_frag_t *frag)
>>  {
>> +       struct page *page = skb_frag_page(frag);
>> +
>> +#ifdef CONFIG_PAGE_POOL
>> +       if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
>> +           page_pool_is_pp_page(page)) {
>> +               page_pool_atomic_inc_frag_count(page);
>> +               return;
>> +       }
>> +#endif
>> +
>>         get_page(skb_frag_page(frag));
>>  }
>>
> 
> This just seems like a bad idea in general. We are likely increasing
> the potential for issues with this patch instead of avoiding them. I

Yes, I am agreed that calling the __skb_frag_ref() without calling the
__skb_frag_unref() for the same page might be more likely to cause problem
for this patch. But we are already depending on the calling of
__skb_frag_unref() to free the pp page, making it more likely just enable
us to catch the bug more quickly?

Or is there other situation that I am not awared of, which might cause
issues?

> really feel it would be better for us to just give up on the page and
> kick it out of the page pool if we are cloning frames and multiple
> references are being taken on the pages.

For Rx, it seems fine for normal case.
For Tx, it seems the cloning and multiple references happens when
tso_fragment() is called in tcp_write_xmit(), and the driver need to
reliable way to tell if a page is from the page pool, so that the
dma mapping can be avoided for Tx too.

> 
>> @@ -3101,7 +3111,8 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>>         struct page *page = skb_frag_page(frag);
>>
>>  #ifdef CONFIG_PAGE_POOL
>> -       if (recycle && page_pool_return_skb_page(page))
>> +       if ((!PAGE_POOL_DMA_USE_PP_FRAG_COUNT || recycle) &&
>> +           page_pool_return_skb_page(page))
>>                 return;
>>  #endif
>>         put_page(page);
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index 2ad0706..8b43e3d9 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -244,6 +244,23 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
>>         atomic_long_set(&page->pp_frag_count, nr);
>>  }
>>
>> +static inline void page_pool_atomic_inc_frag_count(struct page *page)
>> +{
>> +       atomic_long_inc(&page->pp_frag_count);
>> +}
>> +
>> +static inline bool page_pool_is_pp_page(struct page *page)
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
>>  static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>>                                                           long nr)
>>  {
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index ba9f14d..442d37b 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -24,7 +24,7 @@
>>  #define DEFER_TIME (msecs_to_jiffies(1000))
>>  #define DEFER_WARN_INTERVAL (60 * HZ)
>>
>> -#define BIAS_MAX       LONG_MAX
>> +#define BIAS_MAX       (LONG_MAX / 2)
> 
> This piece needs some explaining in the patch. Why are you changing
> the BIAS_MAX?

When __skb_frag_ref() is called for the pp page that is not drained yet,
the pp_frag_count could be overflowed if the BIAS is too big.

> 
>>  static int page_pool_init(struct page_pool *pool,
>>                           const struct page_pool_params *params)
>> @@ -741,15 +741,7 @@ bool page_pool_return_skb_page(struct page *page)
>>         struct page_pool *pp;
>>
>>         page = compound_head(page);
>> -
>> -       /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
>> -        * in order to preserve any existing bits, such as bit 0 for the
>> -        * head page of compound page and bit 1 for pfmemalloc page, so
>> -        * mask those bits for freeing side when doing below checking,
>> -        * and page_is_pfmemalloc() is checked in __page_pool_put_page()
>> -        * to avoid recycling the pfmemalloc page.
>> -        */
>> -       if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
>> +       if (!page_pool_is_pp_page(page))
>>                 return false;
>>
>>         pp = page->pp;
>> --
>> 2.7.4
>>
> .
> 

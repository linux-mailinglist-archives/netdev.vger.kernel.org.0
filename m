Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84463C6B23
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 09:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhGMHXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 03:23:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6918 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbhGMHXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 03:23:13 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GPBlM40brz7Bc5;
        Tue, 13 Jul 2021 15:16:47 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 15:20:19 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 13 Jul
 2021 15:20:19 +0800
Subject: Re: [PATCH rfc v3 3/4] page_pool: add frag page recycling support in
 page pool
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, "Salil Mehta" <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Will Deacon" <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Vlastimil Babka" <vbabka@suse.cz>, <fenghua.yu@intel.com>,
        <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Alexander Lobakin" <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, <wenxu@ucloud.cn>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        <kpsingh@kernel.org>, <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>, <songliubraving@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1626092196-44697-1-git-send-email-linyunsheng@huawei.com>
 <1626092196-44697-4-git-send-email-linyunsheng@huawei.com>
 <CAKgT0UdQS585DyUELZoVpVg-MSLDw=EYrkywgWS_zU1Gqt6Xqw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <6e5b27bc-14ea-6ca4-d51c-50a45e7e2cea@huawei.com>
Date:   Tue, 13 Jul 2021 15:20:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UdQS585DyUELZoVpVg-MSLDw=EYrkywgWS_zU1Gqt6Xqw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/13 3:46, Alexander Duyck wrote:
> On Mon, Jul 12, 2021 at 5:17 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> Currently page pool only support page recycling only when
>> there is only one user of the page, and the split page
>> reusing implemented in the most driver can not use the
>> page pool as bing-pong way of reusing requires the multi
>> user support in page pool.
>>
>> Those reusing or recycling has below limitations:
>> 1. page from page pool can only be used be one user in order
>>    for the page recycling to happen.
>> 2. Bing-pong way of reusing in most driver does not support
>>    multi desc using different part of the same page in order
>>    to save memory.
>>
>> So add multi-users support and frag page recycling in page pool
>> to overcome the above limitation.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  include/net/page_pool.h |  22 ++++++++-
>>  net/core/page_pool.c    | 126 +++++++++++++++++++++++++++++++++++++++++++-----
>>  2 files changed, 134 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index 84cd972..d9a736f 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -45,7 +45,10 @@
>>                                         * Please note DMA-sync-for-CPU is still
>>                                         * device driver responsibility
>>                                         */
>> -#define PP_FLAG_ALL            (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
>> +#define PP_FLAG_PAGE_FRAG      BIT(2)  /* for page frag feature */
>> +#define PP_FLAG_ALL            (PP_FLAG_DMA_MAP |\
>> +                                PP_FLAG_DMA_SYNC_DEV |\
>> +                                PP_FLAG_PAGE_FRAG)
>>
>>  /*
>>   * Fast allocation side cache array/stack
>> @@ -88,6 +91,9 @@ struct page_pool {
>>         unsigned long defer_warn;
>>
>>         u32 pages_state_hold_cnt;
>> +       unsigned int frag_offset;
>> +       int frag_bias;
>> +       struct page *frag_page;
>>
>>         /*
>>          * Data structure for allocation side
>> @@ -137,6 +143,20 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>>         return page_pool_alloc_pages(pool, gfp);
>>  }
>>
>> +struct page *page_pool_alloc_frag(struct page_pool *pool,
>> +                                 unsigned int *offset,
>> +                                 unsigned int size,
>> +                                 gfp_t gfp);
>> +
>> +static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
>> +                                                   unsigned int *offset,
>> +                                                   unsigned int size)
>> +{
>> +       gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
>> +
>> +       return page_pool_alloc_frag(pool, offset, size, gfp);
>> +}
>> +
>>  /* get the stored dma direction. A driver might decide to treat this locally and
>>   * avoid the extra cache line from page_pool to determine the direction
>>   */
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 1abefc6..39d5156 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -24,6 +24,8 @@
>>  #define DEFER_TIME (msecs_to_jiffies(1000))
>>  #define DEFER_WARN_INTERVAL (60 * HZ)
>>
>> +#define BIAS_MAX       (PAGE_SIZE - 1)
>> +
>>  static int page_pool_init(struct page_pool *pool,
>>                           const struct page_pool_params *params)
>>  {
>> @@ -304,6 +306,33 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>>         return page;
>>  }
>>
>> +/* nr could be negative */
>> +static int page_pool_atomic_add_bias(struct page *page, int nr)
>> +{
>> +       unsigned long *bias_ptr = page_pool_pagecnt_bias_ptr(page);
>> +       unsigned long old_bias = READ_ONCE(*bias_ptr);
>> +       unsigned long new_bias;
>> +
>> +       do {
>> +               int bias = (int)(old_bias & ~PAGE_MASK);
>> +
>> +               /* Warn when page_pool_dev_alloc_pages() is called
>> +                * with PP_FLAG_PAGE_FRAG flag in driver.
>> +                */
>> +               WARN_ON(!bias);
>> +
>> +               /* already the last user */
>> +               if (!(bias + nr))
>> +                       return 0;
>> +
>> +               new_bias = old_bias + nr;
>> +       } while (!try_cmpxchg(bias_ptr, &old_bias, new_bias));
>> +
>> +       WARN_ON((new_bias & PAGE_MASK) != (old_bias & PAGE_MASK));
>> +
>> +       return new_bias & ~PAGE_MASK;
>> +}
>> +
> 
> So instead of having a function to add bias it might make more sense
> to have a function that does a subtract and test since that is what we
> are really doing. So in a way you could think of it as a countdown
> until unmap or recycle.

ok

> 
> For the frags case we could probably default to one of two values. For
> the variable sized frags we default to a pagecnt_bias of PAGE_SIZE - 1
> and then eventually do the subtraction at the end to free up unused
> count when the page has been fully used. For fixed sized frags you
> could theoretically just store off the PAGE_SIZE / frag_size - 1 and
> use that to initialize the pagecnt_bias of the pages as you use them.

Will default to a pagecnt_bias of PAGE_SIZE - 1.

> 
> Also one thing we may want to do is look at renaming this since we
> aren't messing with the page_ref_count anymore. It might make more
> sense to refer to this as something such as pp_frag_refcount. Also as
> per the other patch if we can get away from having to share the same
> space as DMA that would be even better.

page_pool_pagecnt_bias_ptr() is gone in the new version when we get away
from having to share the same space as DMA.

> 
>>  /* For using page_pool replace: alloc_pages() API calls, but provide
>>   * synchronization guarantee for allocation side.
>>   */
>> @@ -425,6 +454,11 @@ static __always_inline struct page *
>>  __page_pool_put_page(struct page_pool *pool, struct page *page,
>>                      unsigned int dma_sync_size, bool allow_direct)
>>  {
>> +       /* It is not the last user for the page frag case */
>> +       if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
>> +           page_pool_atomic_add_bias(page, -1))
>> +               return NULL;
>> +
>>         /* This allocator is optimized for the XDP mode that uses
>>          * one-frame-per-page, but have fallbacks that act like the
>>          * regular page allocator APIs.
>> @@ -448,19 +482,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>>                 /* Page found as candidate for recycling */
>>                 return page;
>>         }
>> -       /* Fallback/non-XDP mode: API user have elevated refcnt.
>> -        *
>> -        * Many drivers split up the page into fragments, and some
>> -        * want to keep doing this to save memory and do refcnt based
>> -        * recycling. Support this use case too, to ease drivers
>> -        * switching between XDP/non-XDP.
>> -        *
>> -        * In-case page_pool maintains the DMA mapping, API user must
>> -        * call page_pool_put_page once.  In this elevated refcnt
>> -        * case, the DMA is unmapped/released, as driver is likely
>> -        * doing refcnt based recycle tricks, meaning another process
>> -        * will be invoking put_page.
>> -        */
>> +
>>         /* Do not replace this with page_pool_return_page() */
>>         page_pool_release_page(pool, page);
>>         put_page(page);
>> @@ -517,6 +539,82 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>>  }
>>  EXPORT_SYMBOL(page_pool_put_page_bulk);
>>
>> +/* When BIAS_RESERVE to avoid frag page being recycled back to
>> + * page pool while the frag page is still in pool->frag_page
>> + * waiting for more user. As minimum align size for DMA seems to
>> + * be 32, so we support max size of 2047 * 32 for 4K page size.
>> + */
>> +#define BIAS_RESERVE           ((int)(BIAS_MAX / 2 + 1))
>> +#define BIAS_NEGATIVE_RESERVE  (0 - BIAS_RESERVE)
> 
> The explanation and these values don't make sense to me. BIAS_RESERVE
> would be 4095 / 2 + 1 which should come out to 2048, and
> BIAS_NEGATIVE_REVERSE is -2048. Should these values have been 127/-127
> which would have been 4096 / 32 - 1?

The idea is to prevent the bias from being subtracted to zeor while
the frag page is sitting in the page pool waiting for more users.

Anyway, the above comment is not needed if I take the "default to a
pagecnt_bias of PAGE_SIZE - 1" suggestion.

> 
>> +static struct page *page_pool_drain_frag(struct page_pool *pool,
>> +                                        struct page *page)
>> +{
>> +       /* page pool is not the last user */
>> +       if (page_pool_atomic_add_bias(page, pool->frag_bias +
>> +                                     BIAS_NEGATIVE_RESERVE))
>> +               return NULL;
>> +       else
>> +               return page;
>> +}
>> +
> 
> So this check isn't quite complete, and I probably wouldn't use it
> this way. To be complete you would need to check the page_ref_count
> and pfmemalloc flags. Also, we already have recycling into the page
> pool so we might as well just use that rather than trying to introduce
> yet another layer of recycling.

Yes, will add the the pfmemalloc and page_ref_count checking.

As introducing another layer of recycling, it seems we can not call
page_pool_put_page() directly, and if the page is reusable, adding
back to the pool and taking one from the pool seems unnecessary.

> 
>> +static void page_pool_free_frag(struct page_pool *pool)
>> +{
>> +       struct page *page = pool->frag_page;
>> +
>> +       if (!page ||
>> +           page_pool_atomic_add_bias(page, pool->frag_bias +
>> +                                     BIAS_NEGATIVE_RESERVE))
>> +               return;
>> +
>> +       page_pool_return_page(pool, page);
>> +       pool->frag_page = NULL;
>> +}
>> +
> 
> If we make the add_bias into a sub_bias then we are just needing to
> flip the values so that you are subtracting BIAS_RESERVE -
> pool->frag_bias which is much more readable in my opinion.

ok.

> 
>> +struct page *page_pool_alloc_frag(struct page_pool *pool,
>> +                                 unsigned int *offset,
>> +                                 unsigned int size,
>> +                                 gfp_t gfp)
>> +{
>> +       unsigned int max_size = PAGE_SIZE << pool->p.order;
>> +       unsigned int frag_offset = pool->frag_offset;
>> +       struct page *frag_page = pool->frag_page;
>> +
>> +       if (WARN_ON(!(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
>> +                   size > max_size))
>> +               return NULL;
>> +
>> +       size = ALIGN(size, dma_get_cache_alignment());
>> +
>> +       if (frag_page && frag_offset + size > max_size) {
>> +               frag_page = page_pool_drain_frag(pool, frag_page);
>> +               if (frag_page)
>> +                       goto frag_reset;
>> +       }
>> +
>> +       if (!frag_page) {
>> +               frag_page = page_pool_alloc_pages(pool, gfp);
>> +               if (unlikely(!frag_page)) {
>> +                       pool->frag_page = NULL;
>> +                       return NULL;
>> +               }
>> +
>> +               pool->frag_page = frag_page;
>> +
>> +frag_reset:
>> +               pool->frag_bias = 0;
>> +               frag_offset = 0;
>> +               page_pool_set_pagecnt_bias(frag_page, BIAS_RESERVE);
>> +       }
>> +
>> +       pool->frag_bias++;
>> +       *offset = frag_offset;
>> +       pool->frag_offset = frag_offset + size;
>> +
>> +       return frag_page;
>> +}
>> +EXPORT_SYMBOL(page_pool_alloc_frag);
>> +
>>  static void page_pool_empty_ring(struct page_pool *pool)
>>  {
>>         struct page *page;
>> @@ -622,6 +720,8 @@ void page_pool_destroy(struct page_pool *pool)
>>         if (!page_pool_put(pool))
>>                 return;
>>
>> +       page_pool_free_frag(pool);
>> +
>>         if (!page_pool_release(pool))
>>                 return;
>>
>> --
>> 2.7.4
>>
> .
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00003C6405
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 21:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbhGLTtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 15:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236588AbhGLTti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 15:49:38 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B945C0613E8;
        Mon, 12 Jul 2021 12:46:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so16463592eds.4;
        Mon, 12 Jul 2021 12:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfylmfpcYXAG5FaEelcfXTlqAPC5pGHHN6Wee/xefxQ=;
        b=ELfe8KSHW2Kf84Xsl1SF4THSQFaHxATDM89DUCKjFYocx579QQHEW7TYR9vbvZ5nD8
         pQih8NDoqV2WG7zu5y8WA8BbafSRKrce3yIhDQGa/ir/rfHEML9DK/RPLNORhp3ty8S5
         xkm+54edX6U+HWTfkYjolGntfSMi3LQKfhnGpJUV8dxB8gIMjPJhkbFL8wBsp5Bw37w4
         8vk5GzUPMly/97DgMZTKj75Di0HEEu/uuRykvfZsZkmqPWMgY8e34S7p39f3EccKxA/L
         vmuYjrcNSfa3v4yIFPP2B6/BgS+nuG5BNCMOept8mfEYvuYYpOnqZe2uVZNelSARZ2iJ
         CCog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfylmfpcYXAG5FaEelcfXTlqAPC5pGHHN6Wee/xefxQ=;
        b=XrVjw65Rg/wq9f0X7aZjwkWoZY8rvem5ew3/wDhp50II4tRpGLzDZKP+bqkWbuWgID
         mMmnP3ctj60tPsUF0W0HyaXi+XIgD2iI+2WSH87M7/zATbZARlfZMtDf7l7YA9qLQQpp
         gttiLSid0+1Tjn8KmBjc0JSyxVLHm0JM3YLqVjgS6rd+R0DWqH1vp/eUrwnLVcM3whFV
         6Ghl7NS/6nKyjbRHg/gdwzOcaXGwafyDX6AGBlCmsGxjg+BpkQ0D2T8OWiWTi9+pxpSC
         e6z4z7gqj+ZGz9CLVARDv6TFLjse22HIkV5o1RWE8yUrjZlR6iHNVddXoY9LLSV2zPS/
         popg==
X-Gm-Message-State: AOAM53112oszE3kc3+JkvYIIKdLFvFdzLsySGfiY8D2TRXmIW1mnBYyv
        iNjXXakb+0Y539XdBxn4AaneyE7z4SllQu42T9c=
X-Google-Smtp-Source: ABdhPJz+jKAREhQ4GgFq7HdUBk2lhbC2mURdgGZIEn3t1i9wX3IjjFEdLAgxNq2M3GMZ4xul41ySK1VjFwFWKdBtXbM=
X-Received: by 2002:a05:6402:40c4:: with SMTP id z4mr617608edb.364.1626119207935;
 Mon, 12 Jul 2021 12:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <1626092196-44697-1-git-send-email-linyunsheng@huawei.com> <1626092196-44697-4-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1626092196-44697-4-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 12 Jul 2021 12:46:36 -0700
Message-ID: <CAKgT0UdQS585DyUELZoVpVg-MSLDw=EYrkywgWS_zU1Gqt6Xqw@mail.gmail.com>
Subject: Re: [PATCH rfc v3 3/4] page_pool: add frag page recycling support in
 page pool
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, songliubraving@fb.com,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 5:17 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> Currently page pool only support page recycling only when
> there is only one user of the page, and the split page
> reusing implemented in the most driver can not use the
> page pool as bing-pong way of reusing requires the multi
> user support in page pool.
>
> Those reusing or recycling has below limitations:
> 1. page from page pool can only be used be one user in order
>    for the page recycling to happen.
> 2. Bing-pong way of reusing in most driver does not support
>    multi desc using different part of the same page in order
>    to save memory.
>
> So add multi-users support and frag page recycling in page pool
> to overcome the above limitation.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/net/page_pool.h |  22 ++++++++-
>  net/core/page_pool.c    | 126 +++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 134 insertions(+), 14 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 84cd972..d9a736f 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -45,7 +45,10 @@
>                                         * Please note DMA-sync-for-CPU is still
>                                         * device driver responsibility
>                                         */
> -#define PP_FLAG_ALL            (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
> +#define PP_FLAG_PAGE_FRAG      BIT(2)  /* for page frag feature */
> +#define PP_FLAG_ALL            (PP_FLAG_DMA_MAP |\
> +                                PP_FLAG_DMA_SYNC_DEV |\
> +                                PP_FLAG_PAGE_FRAG)
>
>  /*
>   * Fast allocation side cache array/stack
> @@ -88,6 +91,9 @@ struct page_pool {
>         unsigned long defer_warn;
>
>         u32 pages_state_hold_cnt;
> +       unsigned int frag_offset;
> +       int frag_bias;
> +       struct page *frag_page;
>
>         /*
>          * Data structure for allocation side
> @@ -137,6 +143,20 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>         return page_pool_alloc_pages(pool, gfp);
>  }
>
> +struct page *page_pool_alloc_frag(struct page_pool *pool,
> +                                 unsigned int *offset,
> +                                 unsigned int size,
> +                                 gfp_t gfp);
> +
> +static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
> +                                                   unsigned int *offset,
> +                                                   unsigned int size)
> +{
> +       gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
> +
> +       return page_pool_alloc_frag(pool, offset, size, gfp);
> +}
> +
>  /* get the stored dma direction. A driver might decide to treat this locally and
>   * avoid the extra cache line from page_pool to determine the direction
>   */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1abefc6..39d5156 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -24,6 +24,8 @@
>  #define DEFER_TIME (msecs_to_jiffies(1000))
>  #define DEFER_WARN_INTERVAL (60 * HZ)
>
> +#define BIAS_MAX       (PAGE_SIZE - 1)
> +
>  static int page_pool_init(struct page_pool *pool,
>                           const struct page_pool_params *params)
>  {
> @@ -304,6 +306,33 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>         return page;
>  }
>
> +/* nr could be negative */
> +static int page_pool_atomic_add_bias(struct page *page, int nr)
> +{
> +       unsigned long *bias_ptr = page_pool_pagecnt_bias_ptr(page);
> +       unsigned long old_bias = READ_ONCE(*bias_ptr);
> +       unsigned long new_bias;
> +
> +       do {
> +               int bias = (int)(old_bias & ~PAGE_MASK);
> +
> +               /* Warn when page_pool_dev_alloc_pages() is called
> +                * with PP_FLAG_PAGE_FRAG flag in driver.
> +                */
> +               WARN_ON(!bias);
> +
> +               /* already the last user */
> +               if (!(bias + nr))
> +                       return 0;
> +
> +               new_bias = old_bias + nr;
> +       } while (!try_cmpxchg(bias_ptr, &old_bias, new_bias));
> +
> +       WARN_ON((new_bias & PAGE_MASK) != (old_bias & PAGE_MASK));
> +
> +       return new_bias & ~PAGE_MASK;
> +}
> +

So instead of having a function to add bias it might make more sense
to have a function that does a subtract and test since that is what we
are really doing. So in a way you could think of it as a countdown
until unmap or recycle.

For the frags case we could probably default to one of two values. For
the variable sized frags we default to a pagecnt_bias of PAGE_SIZE - 1
and then eventually do the subtraction at the end to free up unused
count when the page has been fully used. For fixed sized frags you
could theoretically just store off the PAGE_SIZE / frag_size - 1 and
use that to initialize the pagecnt_bias of the pages as you use them.

Also one thing we may want to do is look at renaming this since we
aren't messing with the page_ref_count anymore. It might make more
sense to refer to this as something such as pp_frag_refcount. Also as
per the other patch if we can get away from having to share the same
space as DMA that would be even better.

>  /* For using page_pool replace: alloc_pages() API calls, but provide
>   * synchronization guarantee for allocation side.
>   */
> @@ -425,6 +454,11 @@ static __always_inline struct page *
>  __page_pool_put_page(struct page_pool *pool, struct page *page,
>                      unsigned int dma_sync_size, bool allow_direct)
>  {
> +       /* It is not the last user for the page frag case */
> +       if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
> +           page_pool_atomic_add_bias(page, -1))
> +               return NULL;
> +
>         /* This allocator is optimized for the XDP mode that uses
>          * one-frame-per-page, but have fallbacks that act like the
>          * regular page allocator APIs.
> @@ -448,19 +482,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>                 /* Page found as candidate for recycling */
>                 return page;
>         }
> -       /* Fallback/non-XDP mode: API user have elevated refcnt.
> -        *
> -        * Many drivers split up the page into fragments, and some
> -        * want to keep doing this to save memory and do refcnt based
> -        * recycling. Support this use case too, to ease drivers
> -        * switching between XDP/non-XDP.
> -        *
> -        * In-case page_pool maintains the DMA mapping, API user must
> -        * call page_pool_put_page once.  In this elevated refcnt
> -        * case, the DMA is unmapped/released, as driver is likely
> -        * doing refcnt based recycle tricks, meaning another process
> -        * will be invoking put_page.
> -        */
> +
>         /* Do not replace this with page_pool_return_page() */
>         page_pool_release_page(pool, page);
>         put_page(page);
> @@ -517,6 +539,82 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  }
>  EXPORT_SYMBOL(page_pool_put_page_bulk);
>
> +/* When BIAS_RESERVE to avoid frag page being recycled back to
> + * page pool while the frag page is still in pool->frag_page
> + * waiting for more user. As minimum align size for DMA seems to
> + * be 32, so we support max size of 2047 * 32 for 4K page size.
> + */
> +#define BIAS_RESERVE           ((int)(BIAS_MAX / 2 + 1))
> +#define BIAS_NEGATIVE_RESERVE  (0 - BIAS_RESERVE)

The explanation and these values don't make sense to me. BIAS_RESERVE
would be 4095 / 2 + 1 which should come out to 2048, and
BIAS_NEGATIVE_REVERSE is -2048. Should these values have been 127/-127
which would have been 4096 / 32 - 1?

> +static struct page *page_pool_drain_frag(struct page_pool *pool,
> +                                        struct page *page)
> +{
> +       /* page pool is not the last user */
> +       if (page_pool_atomic_add_bias(page, pool->frag_bias +
> +                                     BIAS_NEGATIVE_RESERVE))
> +               return NULL;
> +       else
> +               return page;
> +}
> +

So this check isn't quite complete, and I probably wouldn't use it
this way. To be complete you would need to check the page_ref_count
and pfmemalloc flags. Also, we already have recycling into the page
pool so we might as well just use that rather than trying to introduce
yet another layer of recycling.

> +static void page_pool_free_frag(struct page_pool *pool)
> +{
> +       struct page *page = pool->frag_page;
> +
> +       if (!page ||
> +           page_pool_atomic_add_bias(page, pool->frag_bias +
> +                                     BIAS_NEGATIVE_RESERVE))
> +               return;
> +
> +       page_pool_return_page(pool, page);
> +       pool->frag_page = NULL;
> +}
> +

If we make the add_bias into a sub_bias then we are just needing to
flip the values so that you are subtracting BIAS_RESERVE -
pool->frag_bias which is much more readable in my opinion.

> +struct page *page_pool_alloc_frag(struct page_pool *pool,
> +                                 unsigned int *offset,
> +                                 unsigned int size,
> +                                 gfp_t gfp)
> +{
> +       unsigned int max_size = PAGE_SIZE << pool->p.order;
> +       unsigned int frag_offset = pool->frag_offset;
> +       struct page *frag_page = pool->frag_page;
> +
> +       if (WARN_ON(!(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
> +                   size > max_size))
> +               return NULL;
> +
> +       size = ALIGN(size, dma_get_cache_alignment());
> +
> +       if (frag_page && frag_offset + size > max_size) {
> +               frag_page = page_pool_drain_frag(pool, frag_page);
> +               if (frag_page)
> +                       goto frag_reset;
> +       }
> +
> +       if (!frag_page) {
> +               frag_page = page_pool_alloc_pages(pool, gfp);
> +               if (unlikely(!frag_page)) {
> +                       pool->frag_page = NULL;
> +                       return NULL;
> +               }
> +
> +               pool->frag_page = frag_page;
> +
> +frag_reset:
> +               pool->frag_bias = 0;
> +               frag_offset = 0;
> +               page_pool_set_pagecnt_bias(frag_page, BIAS_RESERVE);
> +       }
> +
> +       pool->frag_bias++;
> +       *offset = frag_offset;
> +       pool->frag_offset = frag_offset + size;
> +
> +       return frag_page;
> +}
> +EXPORT_SYMBOL(page_pool_alloc_frag);
> +
>  static void page_pool_empty_ring(struct page_pool *pool)
>  {
>         struct page *page;
> @@ -622,6 +720,8 @@ void page_pool_destroy(struct page_pool *pool)
>         if (!page_pool_put(pool))
>                 return;
>
> +       page_pool_free_frag(pool);
> +
>         if (!page_pool_release(pool))
>                 return;
>
> --
> 2.7.4
>

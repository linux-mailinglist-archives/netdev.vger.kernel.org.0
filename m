Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08CF3C35C4
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 19:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhGJR1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 13:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhGJR1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 13:27:50 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68865C0613DD;
        Sat, 10 Jul 2021 10:25:05 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id hc16so23125697ejc.12;
        Sat, 10 Jul 2021 10:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uxMdy/rdmGG4ZeveHeZXluvptCN/zyVgHIFfueKI8s4=;
        b=JHGvJby+FFbQkynQ5sdc0MT44mHv6asCcwAQCUYP9tC0Y6Tp9CXrTLV5dSsM0MYlVl
         4l0u243GddpsDNJlnOt9TycEM1WO+mHwYhHvHVSVt44UQS/Ptgp7uF/nRkJlLc+DMbas
         FcMX9MKX+xVhdIi/wz4+9MUkpS2o0zrstow2q7j8vbrczaRB4fgfjxeVnq4I3P4qRkHL
         R7F2SJthsec1hOlhZKg+Y7AGj2oSNFDoEVdARYsCXGlMWHT5KD02iiPcr4Wz66I/LdbL
         dNzxVk2DvZt2Unrfzis2AGTRLirHlsj/k/5Swm28o8hT3qa8I4NVaD5J+hszuYGWnPpz
         wdTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uxMdy/rdmGG4ZeveHeZXluvptCN/zyVgHIFfueKI8s4=;
        b=rTnTmtvtB+emT46I42no3GMqAs08LwzdaOK85HaeoaJfirvCXaXpEN8cOlvPYuQ6aP
         2BZtQ1r5AezX6rguWwh+urjehRDtuhbjN+NL+myH4Zef5cZfpxPaZxP7U/mcS4qUG+b/
         s51SCrUrzb1eTkV7bDCN5w7YJFrzsPCzyNbnsNzgOpNDFslKZo305AUcFUe4Up68GsG3
         Lib+80MIaFOack7FjlJWKO3lLkDmVJ6RQM1lvlc521hV+6sgY8+ekzptNYZYLy7tyq75
         BHuYMqpgf5ZlV9NS52lxodLFeBOnsHwR+58pOb8EzI/EMPeeJD4Cxlu1TF6CV8NApRQP
         OhjQ==
X-Gm-Message-State: AOAM53202Ap0aFU3ter3WXDMUtoDs8CFQrqVH/c0dIRYFzUcwECgtMl0
        jK5oEGNIazT7IBCioJ7tKga2zmLYJfb2tyPUnuo=
X-Google-Smtp-Source: ABdhPJyJE54xOFtYyu0bgge8y9KBkOGzhd4fsyRu6Jv/Hbi6Eb+3LrP8+35KNNXJxswSzTQAFdkmB/Z92UNgqmHBgDw=
X-Received: by 2002:a17:907:3e22:: with SMTP id hp34mr32486310ejc.470.1625937902956;
 Sat, 10 Jul 2021 10:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com> <1625903002-31619-4-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1625903002-31619-4-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 10 Jul 2021 10:24:51 -0700
Message-ID: <CAKgT0Uc2JRR4c+-kt31-BCu1Y179YP8o3uvyuHQ=RPtOq0dDPQ@mail.gmail.com>
Subject: Re: [PATCH rfc v2 3/5] page_pool: add page recycling support based on
 elevated refcnt
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
        Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:44 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> Currently page pool only support page recycling only when
> refcnt of page is one, which means it can not support the
> split page recycling implemented in the most driver.
>
> The expectation of page recycling based on elevated refcnt
> is that we only do the recycling or freeing of page when the
> last user has dropped the refcnt that has given to it.
>
> The above expectation is based on that the last user will
> always call page_pool_put_full_page() in order to do the
> recycling or do the resource cleanup(dma unmaping..etc) and
> freeing.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/net/page_pool.h |   5 ++-
>  net/core/page_pool.c    | 106 ++++++++++++++++++++++++++++++++++++------------
>  2 files changed, 84 insertions(+), 27 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 5746f17..f0e708d 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -45,7 +45,10 @@
>                                         * Please note DMA-sync-for-CPU is still
>                                         * device driver responsibility
>                                         */
> -#define PP_FLAG_ALL            (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
> +#define PP_FLAG_PAGECNT_BIAS   BIT(2)  /* For elevated refcnt feature */
> +#define PP_FLAG_ALL            (PP_FLAG_DMA_MAP |\
> +                                PP_FLAG_DMA_SYNC_DEV |\
> +                                PP_FLAG_PAGECNT_BIAS)
>
>  /*
>   * Fast allocation side cache array/stack
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 78838c6..a87cbe1 100644
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
> @@ -209,14 +211,24 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>  static void page_pool_set_pp_info(struct page_pool *pool,
>                                   struct page *page)
>  {
> +       if (pool->p.flags & PP_FLAG_PAGECNT_BIAS) {
> +               page_ref_add(page, BIAS_MAX);
> +               page_pool_set_pagecnt_bias(page, BIAS_MAX);
> +       }
> +
>         page->pp = pool;
>         page->pp_magic |= PP_SIGNATURE;
>  }

I think this piece makes more sense as a part of
__page_pool_alloc_page_order. Basically have it run parallel to the
DMA mapping setup.

> -static void page_pool_clear_pp_info(struct page *page)
> +static int page_pool_clear_pp_info(struct page *page)
>  {
> +       int bias = page_pool_get_pagecnt_bias(page);
> +
>         page->pp_magic = 0;
>         page->pp = NULL;
> +       page_pool_set_pagecnt_bias(page, 0);
> +
> +       return bias;
>  }
>
>  static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
> @@ -298,6 +310,23 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>         return page;
>  }
>
> +static void page_pool_sub_bias(struct page_pool *pool,
> +                              struct page *page, int nr)
> +{
> +       int bias;
> +
> +       if (!(pool->p.flags & PP_FLAG_PAGECNT_BIAS))
> +               return;
> +
> +       bias = page_pool_get_pagecnt_bias(page);
> +       if (unlikely(bias <= nr)) {
> +               page_ref_add(page, BIAS_MAX - bias);
> +               bias = BIAS_MAX;
> +       }
> +
> +       page_pool_set_pagecnt_bias(page, bias - nr);
> +}
> +
>  /* For using page_pool replace: alloc_pages() API calls, but provide
>   * synchronization guarantee for allocation side.
>   */
> @@ -307,11 +336,16 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
>
>         /* Fast-path: Get a page from cache */
>         page = __page_pool_get_cached(pool);
> -       if (page)
> +       if (page) {
> +               page_pool_sub_bias(pool, page, 1);
>                 return page;
> +       }
>
>         /* Slow-path: cache empty, do real allocation */
>         page = __page_pool_alloc_pages_slow(pool, gfp);
> +       if (likely(page))
> +               page_pool_sub_bias(pool, page, 1);
> +
>         return page;

I would probably just reorder this a bit. Do something like:
    page = __page_pool_get_cached()

    if (!page) {
        page = __page_pool_alloc_pages_slow()
        if (!page)
            return NULL;
    }

    page_pool_sub_bias()
    return page;


>  }
>  EXPORT_SYMBOL(page_pool_alloc_pages);
> @@ -340,10 +374,11 @@ static s32 page_pool_inflight(struct page_pool *pool)
>   * a regular page (that will eventually be returned to the normal
>   * page-allocator via put_page).
>   */
> -void page_pool_release_page(struct page_pool *pool, struct page *page)
> +static int __page_pool_release_page(struct page_pool *pool,
> +                                   struct page *page)
>  {
> +       int bias, count;
>         dma_addr_t dma;
> -       int count;
>
>         if (!(pool->p.flags & PP_FLAG_DMA_MAP))
>                 /* Always account for inflight pages, even if we didn't
> @@ -359,22 +394,30 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>                              DMA_ATTR_SKIP_CPU_SYNC);
>         page_pool_set_dma_addr(page, 0);
>  skip_dma_unmap:
> -       page_pool_clear_pp_info(page);
> +       bias = page_pool_clear_pp_info(page);
>
>         /* This may be the last page returned, releasing the pool, so
>          * it is not safe to reference pool afterwards.
>          */
>         count = atomic_inc_return(&pool->pages_state_release_cnt);
>         trace_page_pool_state_release(pool, page, count);
> +
> +       return bias;
> +}
> +
> +void page_pool_release_page(struct page_pool *pool, struct page *page)
> +{
> +       int bias = __page_pool_release_page(pool, page);
> +
> +       WARN_ONCE(bias, "%s is called from driver with elevated refcnt\n",
> +                 __func__);
>  }

I'm not sure it makes sense to have a warning about this. There are
multiple scenarios where you will still have to release the page early
and deduct the pagecnt_bias.

>  EXPORT_SYMBOL(page_pool_release_page);
>
>  /* Return a page to the page allocator, cleaning up our state */
>  static void page_pool_return_page(struct page_pool *pool, struct page *page)
>  {
> -       page_pool_release_page(pool, page);
> -
> -       put_page(page);
> +       __page_frag_cache_drain(page, __page_pool_release_page(pool, page) + 1);
>         /* An optimization would be to call __free_pages(page, pool->p.order)
>          * knowing page is not part of page-cache (thus avoiding a
>          * __page_cache_release() call).
> @@ -409,6 +452,15 @@ static bool page_pool_recycle_in_cache(struct page *page,
>         return true;
>  }
>
> +static bool page_pool_bias_page_recyclable(struct page *page, int bias)
> +{
> +       int ref = page_ref_dec_return(page);
> +
> +       WARN_ON(ref <= bias);
> +
> +       return ref == bias + 1;
> +}
> +
>  /* If the page refcnt == 1, this will try to recycle the page.
>   * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
>   * the configured size min(dma_sync_size, pool->max_len).
> @@ -419,6 +471,20 @@ static __always_inline struct page *
>  __page_pool_put_page(struct page_pool *pool, struct page *page,
>                      unsigned int dma_sync_size, bool allow_direct)
>  {
> +       int bias = page_pool_get_pagecnt_bias(page);
> +
> +       /* Handle the elevated refcnt case first */
> +       if (bias) {
> +               /* It is not the last user yet */
> +               if (!page_pool_bias_page_recyclable(page, bias))
> +                       return NULL;
> +
> +               if (likely(!page_is_pfmemalloc(page)))
> +                       goto recyclable;
> +               else
> +                       goto unrecyclable;
> +       }
> +
>         /* This allocator is optimized for the XDP mode that uses
>          * one-frame-per-page, but have fallbacks that act like the
>          * regular page allocator APIs.
> @@ -430,7 +496,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>          */
>         if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
>                 /* Read barrier done in page_ref_count / READ_ONCE */
> -
> +recyclable:
>                 if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>                         page_pool_dma_sync_for_device(pool, page,
>                                                       dma_sync_size);
> @@ -442,22 +508,9 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
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
> -       /* Do not replace this with page_pool_return_page() */
> -       page_pool_release_page(pool, page);
> -       put_page(page);
> +
> +unrecyclable:
> +       page_pool_return_page(pool, page);
>
>         return NULL;
>  }
> @@ -518,7 +571,8 @@ static void page_pool_empty_ring(struct page_pool *pool)
>         /* Empty recycle ring */
>         while ((page = ptr_ring_consume_bh(&pool->ring))) {
>                 /* Verify the refcnt invariant of cached pages */
> -               if (!(page_ref_count(page) == 1))
> +               if (!(page_ref_count(page) ==
> +                     (page_pool_get_pagecnt_bias(page) + 1)))
>                         pr_crit("%s() page_pool refcnt %d violation\n",
>                                 __func__, page_ref_count(page));
>

So I am not sure this is entirely useful since there are cases where
the mm subsystem will take references on pages like I mentioned
before.

Also we should probably be caching the output from page_ref_count
instead of calling it twice as it would guarantee that we will see the
actual value the test saw versus performing the read twice which might
indicate two different values if somebody else is messing with the
page.

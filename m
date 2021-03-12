Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E4433979F
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhCLTo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbhCLToU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:44:20 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC35CC061574;
        Fri, 12 Mar 2021 11:44:20 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id m7so7929517iow.7;
        Fri, 12 Mar 2021 11:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IrWHb7e61pTPvPUh0s6DcH0r8uWJp80nkzN2uBpyjtY=;
        b=PMWj0/6b1uBHAkLW6cI/Gu34nsxx+y7a4JvGeoBTncNLNxu3zFtZV0HQiPTKZduw2e
         F1KjIvob0YOHvSAIAmlgJqasjPivrlftKbNfMcYPFECGxQrjaX5f0qWm07fOoUWUwiFg
         AsDXko4eWFC7+6xnB7OWJaWeXOTKkwD29NCf34wC/ueTpfz8HDikKHQOI4tsBay7Vcna
         7vFh3j9IfX76+WA46ZYBGQzragR1HNKicQ+X01TVrsOnsdbyY6FdZJdSXllSQwmjk4mE
         cFR+5R5N3+1q9KXpf0cDmoRpyuySbOOpXbM3ja1cLSlnZF2G+3I9hGxqiA6nrKfj2u/2
         i8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IrWHb7e61pTPvPUh0s6DcH0r8uWJp80nkzN2uBpyjtY=;
        b=tjEzOsvCjsrQJqKnG8eZG5MXM6F/W87chlT4zvkQ8/n/ihAtEPF1i9NGrX1MQtI3pp
         26TgnKnEdJeB8MA2aVRYoWjM7Bzu56pRYTa7j38ucRpn4hvkRg0/NnfB/OvE6fPUAzpQ
         E45VT7ocjABFTPrlU80jNnRNiQxW+2XKEhlvmn8dOYJrc9iya3J/C9q66AnfzrXrmtPZ
         ZmRKhDY2FMsGHFHUszlqSBzZWWvsZGMiD1lJW7g0Q8ws1z8GKPPMu1euBdQOge/EL3g2
         FPYld/JP3yrEYQry22pBcL5bMEa3iqxhZrWoo2rxpid0wMDRVPnT4/SLHbaKcpS2tNat
         llhg==
X-Gm-Message-State: AOAM531bureaBQfe4GShBc1i2PR4GZ+4Ov2HWMAaM9MO0PEZ4JmrRr9p
        RZMowo30rI3h5dG4Zw9kc190JXWS7H184mQVQoM=
X-Google-Smtp-Source: ABdhPJxXoAuoGft6APOatuPiNeFYWHQlyeWRffGWbdQcyc8QnfQK+a0JqLGWTYPaq43wupJXFppFnoNnUV5+hlEQwDg=
X-Received: by 2002:a6b:d60e:: with SMTP id w14mr599160ioa.187.1615578260009;
 Fri, 12 Mar 2021 11:44:20 -0800 (PST)
MIME-Version: 1.0
References: <20210312154331.32229-1-mgorman@techsingularity.net> <20210312154331.32229-8-mgorman@techsingularity.net>
In-Reply-To: <20210312154331.32229-8-mgorman@techsingularity.net>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 12 Mar 2021 11:44:09 -0800
Message-ID: <CAKgT0UebK=mMwDV+UH8CqBRt0E0Koc7EB42kwgf0hYHDT_2OfQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] net: page_pool: use alloc_pages_bulk in refill code path
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 7:43 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> From: Jesper Dangaard Brouer <brouer@redhat.com>
>
> There are cases where the page_pool need to refill with pages from the
> page allocator. Some workloads cause the page_pool to release pages
> instead of recycling these pages.
>
> For these workload it can improve performance to bulk alloc pages from
> the page-allocator to refill the alloc cache.
>
> For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
> redirecting xdp_frame packets into a veth, that does XDP_PASS to create
> an SKB from the xdp_frame, which then cannot return the page to the
> page_pool. In this case, we saw[1] an improvement of 18.8% from using
> the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).
>
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
>  net/core/page_pool.c | 62 ++++++++++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 23 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 40e1b2beaa6c..a5889f1b86aa 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -208,44 +208,60 @@ noinline
>  static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>                                                  gfp_t _gfp)
>  {
> +       const int bulk = PP_ALLOC_CACHE_REFILL;
> +       struct page *page, *next, *first_page;
>         unsigned int pp_flags = pool->p.flags;
> -       struct page *page;
> +       unsigned int pp_order = pool->p.order;
> +       int pp_nid = pool->p.nid;
> +       LIST_HEAD(page_list);
>         gfp_t gfp = _gfp;
>
> -       /* We could always set __GFP_COMP, and avoid this branch, as
> -        * prep_new_page() can handle order-0 with __GFP_COMP.
> -        */
> -       if (pool->p.order)
> +       /* Don't support bulk alloc for high-order pages */
> +       if (unlikely(pp_order)) {
>                 gfp |= __GFP_COMP;
> +               first_page = alloc_pages_node(pp_nid, gfp, pp_order);
> +               if (unlikely(!first_page))
> +                       return NULL;
> +               goto out;
> +       }
>
> -       /* FUTURE development:
> -        *
> -        * Current slow-path essentially falls back to single page
> -        * allocations, which doesn't improve performance.  This code
> -        * need bulk allocation support from the page allocator code.
> -        */
> -
> -       /* Cache was empty, do real allocation */
> -#ifdef CONFIG_NUMA
> -       page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
> -#else
> -       page = alloc_pages(gfp, pool->p.order);
> -#endif
> -       if (!page)
> +       if (unlikely(!__alloc_pages_bulk(gfp, pp_nid, NULL, bulk, &page_list)))
>                 return NULL;
>
> +       /* First page is extracted and returned to caller */
> +       first_page = list_first_entry(&page_list, struct page, lru);
> +       list_del(&first_page->lru);
> +

This seems kind of broken to me. If you pull the first page and then
cannot map it you end up returning NULL even if you placed a number of
pages in the cache.

It might make more sense to have the loop below record a pointer to
the last page you processed and handle things in two stages so that on
the first iteration you map one page.

So something along the lines of:
1. Initialize last_page to NULL

for each page in the list
  2. Map page
  3. If last_page is non-NULL, move to cache
  4. Assign page to last_page
  5. Return to step 2 for each page in list

6. return last_page

> +       /* Remaining pages store in alloc.cache */
> +       list_for_each_entry_safe(page, next, &page_list, lru) {
> +               list_del(&page->lru);
> +               if ((pp_flags & PP_FLAG_DMA_MAP) &&
> +                   unlikely(!page_pool_dma_map(pool, page))) {
> +                       put_page(page);
> +                       continue;
> +               }

So if you added a last_page pointer what you could do is check for it
here and assign it to the alloc cache. If last_page is not set the
block would be skipped.

> +               if (likely(pool->alloc.count < PP_ALLOC_CACHE_SIZE)) {
> +                       pool->alloc.cache[pool->alloc.count++] = page;
> +                       pool->pages_state_hold_cnt++;
> +                       trace_page_pool_state_hold(pool, page,
> +                                                  pool->pages_state_hold_cnt);
> +               } else {
> +                       put_page(page);

If you are just calling put_page here aren't you leaking DMA mappings?
Wouldn't you need to potentially unmap the page before you call
put_page on it?

> +               }
> +       }
> +out:
>         if ((pp_flags & PP_FLAG_DMA_MAP) &&
> -           unlikely(!page_pool_dma_map(pool, page))) {
> -               put_page(page);
> +           unlikely(!page_pool_dma_map(pool, first_page))) {
> +               put_page(first_page);

I would probably move this block up and make it a part of the pp_order
block above. Also since you are doing this in 2 spots it might make
sense to look at possibly making this an inline function.

>                 return NULL;
>         }
>
>         /* Track how many pages are held 'in-flight' */
>         pool->pages_state_hold_cnt++;
> -       trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
> +       trace_page_pool_state_hold(pool, first_page, pool->pages_state_hold_cnt);
>
>         /* When page just alloc'ed is should/must have refcnt 1. */
> -       return page;
> +       return first_page;
>  }
>
>  /* For using page_pool replace: alloc_pages() API calls, but provide
> --
> 2.26.2
>

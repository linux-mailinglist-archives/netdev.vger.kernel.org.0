Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA4B679B37
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbjAXOMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbjAXOMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:12:23 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330C742BDF
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:12:21 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id br9so23609901lfb.4
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Et1U0qRDBVHunlz3VLcQ+yR/3MAgGPpTdM5N1/ite3c=;
        b=mjRHvGEcIztBYb8kQLhA1+OgNevyPdNmYb23v7XKPgVBVyy9JjqO23vYwYcPdrqzIA
         1HaTCRhx7TtZdMMdRzXytveJRO2m4YLWrwn8Vw1GxqsBJuN42303cMleOVQ2thNnOUN5
         mH3TjrCX867NRw9i29UC2DN3ftO9dL45IrstzLR1uu4rnXSjj6YidaAqqhvu5MiCERI9
         rlXYDJBJQcun0z5vsIGnJfu4m8MDo8qXTY1IkQ1rxFMWHj5I2uNabOPGg6Jxo81Q7zTX
         oX2wuObCrlDLQSJflJknKp6sUH4CzRtPtb71ouHnYCvFZJpzlJnK51KPgJcCz5E7MK04
         jIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Et1U0qRDBVHunlz3VLcQ+yR/3MAgGPpTdM5N1/ite3c=;
        b=1sQRZzFSHWPcGS8ouN1sYNbAU+DpzkJ4jA6+jDGTuu9TZNBYPto5Gq5TEDVNehXJ6Q
         //m/AplFTHRN0dEK6ImR8PXFcNfJG46zrnfsLJf4QeZWwct2BErkCZBm0EJMypEKdRin
         ciZEPMjE6gMqsPdPxR8Skylo0CtlJT0XZvihPVFR4GUwuwPsia7hq+X64grvmHCyDLD1
         Ixw64i9xhJgF4bcvB76Nt3vwzcDmQHqvzlq17qwmY3mDLCVVRFGlDGTU/AONbynVRMua
         ojI9TG47eqGnB6yR69G4BtkV13EBpjcg2ViKETcEkeYaWXqtn+vFHtMHf7+gxQ0neUZ6
         yvvg==
X-Gm-Message-State: AFqh2koHHanaxKayNRqyZC/K/Rw+fVfhnyVDG7Ik/zvQ82Ia7WY1+u+G
        9cO6ZO0vxfY9KXvzanRPkYNLw+ZEm09cQrQ8T9rKoA==
X-Google-Smtp-Source: AMrXdXt3cl414porwTQDSj+4AQRu0ZkfEDS/y7PzcXLeZIBEsyjhqlspFYHAZ87h44jEAEYSctVj3KlBEhPkWHnljqw=
X-Received: by 2002:ac2:4e96:0:b0:4cb:4488:7d97 with SMTP id
 o22-20020ac24e96000000b004cb44887d97mr1222592lfr.447.1674569539400; Tue, 24
 Jan 2023 06:12:19 -0800 (PST)
MIME-Version: 1.0
References: <20230124124300.94886-1-nbd@nbd.name>
In-Reply-To: <20230124124300.94886-1-nbd@nbd.name>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 24 Jan 2023 16:11:43 +0200
Message-ID: <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented allocation
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Felix,

++cc Alexander and Yunsheng.

Thanks for the report

On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
>
> While testing fragmented page_pool allocation in the mt76 driver, I was able
> to reliably trigger page refcount underflow issues, which did not occur with
> full-page page_pool allocation.
> It appears to me, that handling refcounting in two separate counters
> (page->pp_frag_count and page refcount) is racy when page refcount gets
> incremented by code dealing with skb fragments directly, and
> page_pool_return_skb_page is called multiple times for the same fragment.
>
> Dropping page->pp_frag_count and relying entirely on the page refcount makes
> these underflow issues and crashes go away.
>

This has been discussed here [1].  TL;DR changing this to page
refcount might blow up in other colorful ways.  Can we look closer and
figure out why the underflow happens?

[1] https://lore.kernel.org/netdev/1625903002-31619-4-git-send-email-linyunsheng@huawei.com/

Thanks
/Ilias

> Cc: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  include/linux/mm_types.h | 17 +++++------------
>  include/net/page_pool.h  | 19 ++++---------------
>  net/core/page_pool.c     | 12 ++++--------
>  3 files changed, 13 insertions(+), 35 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 9757067c3053..96ec3b19a86d 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -125,18 +125,11 @@ struct page {
>                         struct page_pool *pp;
>                         unsigned long _pp_mapping_pad;
>                         unsigned long dma_addr;
> -                       union {
> -                               /**
> -                                * dma_addr_upper: might require a 64-bit
> -                                * value on 32-bit architectures.
> -                                */
> -                               unsigned long dma_addr_upper;
> -                               /**
> -                                * For frag page support, not supported in
> -                                * 32-bit architectures with 64-bit DMA.
> -                                */
> -                               atomic_long_t pp_frag_count;
> -                       };
> +                       /**
> +                        * dma_addr_upper: might require a 64-bit
> +                        * value on 32-bit architectures.
> +                        */
> +                       unsigned long dma_addr_upper;
>                 };
>                 struct {        /* Tail pages of compound page */
>                         unsigned long compound_head;    /* Bit zero is set */
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 813c93499f20..28e1fdbdcd53 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -279,14 +279,14 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
>
>  static inline void page_pool_fragment_page(struct page *page, long nr)
>  {
> -       atomic_long_set(&page->pp_frag_count, nr);
> +       page_ref_add(page, nr);
>  }
>
>  static inline long page_pool_defrag_page(struct page *page, long nr)
>  {
>         long ret;
>
> -       /* If nr == pp_frag_count then we have cleared all remaining
> +       /* If nr == page_ref_count then we have cleared all remaining
>          * references to the page. No need to actually overwrite it, instead
>          * we can leave this to be overwritten by the calling function.
>          *
> @@ -295,22 +295,14 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
>          * especially when dealing with a page that may be partitioned
>          * into only 2 or 3 pieces.
>          */
> -       if (atomic_long_read(&page->pp_frag_count) == nr)
> +       if (page_ref_count(page) == nr)
>                 return 0;
>
> -       ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> +       ret = page_ref_sub_return(page, nr);
>         WARN_ON(ret < 0);
>         return ret;
>  }
>
> -static inline bool page_pool_is_last_frag(struct page_pool *pool,
> -                                         struct page *page)
> -{
> -       /* If fragments aren't enabled or count is 0 we were the last user */
> -       return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
> -              (page_pool_defrag_page(page, 1) == 0);
> -}
> -
>  static inline void page_pool_put_page(struct page_pool *pool,
>                                       struct page *page,
>                                       unsigned int dma_sync_size,
> @@ -320,9 +312,6 @@ static inline void page_pool_put_page(struct page_pool *pool,
>          * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
>          */
>  #ifdef CONFIG_PAGE_POOL
> -       if (!page_pool_is_last_frag(pool, page))
> -               return;
> -
>         page_pool_put_defragged_page(pool, page, dma_sync_size, allow_direct);
>  #endif
>  }
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9b203d8660e4..0defcadae225 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -25,7 +25,7 @@
>  #define DEFER_TIME (msecs_to_jiffies(1000))
>  #define DEFER_WARN_INTERVAL (60 * HZ)
>
> -#define BIAS_MAX       LONG_MAX
> +#define BIAS_MAX(pool) (PAGE_SIZE << ((pool)->p.order))
>
>  #ifdef CONFIG_PAGE_POOL_STATS
>  /* alloc_stat_inc is intended to be used in softirq context */
> @@ -619,10 +619,6 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>         for (i = 0; i < count; i++) {
>                 struct page *page = virt_to_head_page(data[i]);
>
> -               /* It is not the last user for the page frag case */
> -               if (!page_pool_is_last_frag(pool, page))
> -                       continue;
> -
>                 page = __page_pool_put_page(pool, page, -1, false);
>                 /* Approved for bulk recycling in ptr_ring cache */
>                 if (page)
> @@ -659,7 +655,7 @@ EXPORT_SYMBOL(page_pool_put_page_bulk);
>  static struct page *page_pool_drain_frag(struct page_pool *pool,
>                                          struct page *page)
>  {
> -       long drain_count = BIAS_MAX - pool->frag_users;
> +       long drain_count = BIAS_MAX(pool) - pool->frag_users;
>
>         /* Some user is still using the page frag */
>         if (likely(page_pool_defrag_page(page, drain_count)))
> @@ -678,7 +674,7 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
>
>  static void page_pool_free_frag(struct page_pool *pool)
>  {
> -       long drain_count = BIAS_MAX - pool->frag_users;
> +       long drain_count = BIAS_MAX(pool) - pool->frag_users;
>         struct page *page = pool->frag_page;
>
>         pool->frag_page = NULL;
> @@ -724,7 +720,7 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
>                 pool->frag_users = 1;
>                 *offset = 0;
>                 pool->frag_offset = size;
> -               page_pool_fragment_page(page, BIAS_MAX);
> +               page_pool_fragment_page(page, BIAS_MAX(pool));
>                 return page;
>         }
>
> --
> 2.39.0
>

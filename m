Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600375C0531
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiIURTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIURTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:19:11 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8529E698
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 10:19:10 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3487d84e477so71784387b3.6
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 10:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Re5+W/yerbPrQETe5eQpJTToGP65sptVc3hxcdfipEU=;
        b=IFD9tAQixPHc+ozlr97G7X+Y5E6Rd/1EHmX2BXVLFuZP7FnOdbdImpjbqFmXwriSMS
         2VSZbkvPr+8nZ1UBmBbibB7xeZoTDG8VnzOCs9iTo385zcQwqCYAuhNMmopTygtrEYDi
         H3+eZNLJp+NPXmR4Fhfm5SUlMwshq3BAvUM7ggoEvb+zWEduGJzTPBPXWt1fN0ekVc6P
         YFcTcuRnR1mVWNKxZ/O9UnZvs7RQN8Bb8CXjeJY6uojidS50GgPcHBIQ54A3zqYjpbak
         IUwrkPmJbjtecJOvJ1F0mPIPRH0acxc8p7NI6dc8P6XqHhoV2MuAqlWb+OI+AuqSrCCz
         Dw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Re5+W/yerbPrQETe5eQpJTToGP65sptVc3hxcdfipEU=;
        b=yFk4gEqr04Z+Xyex8PYz123xmi+zY6x/80ZVNEoJGqKEUB56FTBwRC/oZi2uoyJvs/
         KuQexL41UH0NTrwHC7o7/FCu9VT3KOpb5nJmZmZ4AMPxYcwEaJ7tn3ILk00zYelcWdGR
         8fMxvyY+HC1fIphLJbYbakIF3TuAAgYcComJ/nGqW/d//4CBaKHRrL9gUS/QLmfBAUKk
         cVDAxGzV8XVFlRFPaRLqjLKDfa8OwGcaKUH5WLyYcyBFNtdI2sJc+Rd+YPWNP4QTOpvl
         Trvar0ZoTmhvy3aPZL7aRtltKyLjQG7hZwBYhknU/5mAuDHHQqwbJj2mygGmqZMmEFmZ
         pZvw==
X-Gm-Message-State: ACrzQf273OmwICyt6nMzIKsN86q+NgDIkFjyL11/e5Cy67VGAAgSvBpW
        Khr5Br91GoXoa48MT/xBbtFq+UmUjvs1yLRY3La6ug==
X-Google-Smtp-Source: AMsMyM6CpDTpmITtG03E9dx7lfIfnXk1xYsf+VAzsBjVsgCTHFkOQS6mgxz/mmgxSQVx4BjZGTh5yjrEB5467Uaipd0=
X-Received: by 2002:a81:c08:0:b0:34d:5b:f80b with SMTP id 8-20020a810c08000000b0034d005bf80bmr14383925ywm.332.1663780749497;
 Wed, 21 Sep 2022 10:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
In-Reply-To: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 21 Sep 2022 10:18:58 -0700
Message-ID: <CANn89iK=hdV0Wya8nrdZ=z=yipAxg3OPEOBWT_arzYSuXDENLw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: skb: introduce and use a single page frag cache
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 9:42 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> for tiny skbs") we are observing 10-20% regressions in performance
> tests with small packets. The perf trace points to high pressure on
> the slab allocator.
>
> This change tries to improve the allocation schema for small packets
> using an idea originally suggested by Eric: a new per CPU page frag is
> introduced and used in __napi_alloc_skb to cope with small allocation
> requests.
>
> To ensure that the above does not lead to excessive truesize
> underestimation, the frag size for small allocation is inflated to 1K
> and all the above is restricted to build with 4K page size.
>
> Note that we need to update accordingly the run-time check introduced
> with commit fd9ea57f4e95 ("net: add napi_get_frags_check() helper").
>
> Alex suggested a smart page refcount schema to reduce the number
> of atomic operations and deal properly with pfmemalloc pages.
>
> Under small packet UDP flood, I measure a 15% peak tput increases.
>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Suggested-by: Alexander H Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> @Eric, @Alex please let me know if you are comfortable with the
> attribution
> ---
>  include/linux/netdevice.h |   1 +
>  net/core/dev.c            |  17 ------
>  net/core/skbuff.c         | 115 +++++++++++++++++++++++++++++++++++++-
>  3 files changed, 113 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 9f42fc871c3b..a1938560192a 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3822,6 +3822,7 @@ void netif_receive_skb_list(struct list_head *head);
>  gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb);
>  void napi_gro_flush(struct napi_struct *napi, bool flush_old);
>  struct sk_buff *napi_get_frags(struct napi_struct *napi);
> +void napi_get_frags_check(struct napi_struct *napi);
>  gro_result_t napi_gro_frags(struct napi_struct *napi);
>  struct packet_offload *gro_find_receive_by_type(__be16 type);
>  struct packet_offload *gro_find_complete_by_type(__be16 type);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d66c73c1c734..fa53830d0683 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6358,23 +6358,6 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
>  }
>  EXPORT_SYMBOL(dev_set_threaded);
>
> -/* Double check that napi_get_frags() allocates skbs with
> - * skb->head being backed by slab, not a page fragment.
> - * This is to make sure bug fixed in 3226b158e67c
> - * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> - * does not accidentally come back.
> - */
> -static void napi_get_frags_check(struct napi_struct *napi)
> -{
> -       struct sk_buff *skb;
> -
> -       local_bh_disable();
> -       skb = napi_get_frags(napi);
> -       WARN_ON_ONCE(skb && skb->head_frag);
> -       napi_free_frags(napi);
> -       local_bh_enable();
> -}
> -
>  void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
>                            int (*poll)(struct napi_struct *, int), int weight)
>  {
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f1b8b20fc20b..2be11b487df1 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -134,8 +134,73 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
>  #define NAPI_SKB_CACHE_BULK    16
>  #define NAPI_SKB_CACHE_HALF    (NAPI_SKB_CACHE_SIZE / 2)
>
> +/* the compiler doesn't like 'SKB_TRUESIZE(GRO_MAX_HEAD) > 512', but we
> + * can imply such condition checking the double word and MAX_HEADER size
> + */
> +#if PAGE_SIZE == SZ_4K && (defined(CONFIG_64BIT) || MAX_HEADER > 64)
> +
> +#define NAPI_HAS_SMALL_PAGE_FRAG 1
> +
> +/* specializzed page frag allocator using a single order 0 page
> + * and slicing it into 1K sized fragment. Constrained to system
> + * with:
> + * - a very limited amount of 1K fragments fitting a single
> + *   page - to avoid excessive truesize underestimation
> + * - reasonably high truesize value for napi_get_frags()
> + *   allocation - to avoid memory usage increased compared
> + *   to kalloc, see __napi_alloc_skb()
> + *
> + */
> +struct page_frag_1k {
> +       void *va;
> +       u16 offset;
> +       bool pfmemalloc;
> +};
> +
> +static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
> +{
> +       struct page *page;
> +       int offset;
> +
> +       if (likely(nc->va)) {
> +               offset = nc->offset - SZ_1K;
> +               if (likely(offset >= 0))
> +                       goto out;
> +
> +               put_page(virt_to_page(nc->va));

This probably can be removed, if the page_ref_add() later is adjusted by one ?

We know that for an exact chunk size of 1K, a 4K page is split in 4,
no matter what.

> +       }
> +
> +       page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
> +       if (!page) {
> +               nc->va = NULL;
> +               return NULL;
> +       }
> +
> +       nc->va = page_address(page);
> +       nc->pfmemalloc = page_is_pfmemalloc(page);
> +       page_ref_add(page, PAGE_SIZE / SZ_1K);

page_ref_add(page, PAGE_SIZE / SZ_1K - 1);


> +       offset = PAGE_SIZE - SZ_1K;
> +
> +out:
> +       nc->offset = offset;
> +       return nc->va + offset;
> +}
> +#else
> +#define NAPI_HAS_SMALL_PAGE_FRAG 0
> +
> +struct page_frag_1k {
> +};
> +
> +static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp_mask)
> +{
> +       return NULL;
> +}
> +
> +#endif
> +
>  struct napi_alloc_cache {
>         struct page_frag_cache page;
> +       struct page_frag_1k page_small;
>         unsigned int skb_count;
>         void *skb_cache[NAPI_SKB_CACHE_SIZE];
>  };
> @@ -143,6 +208,23 @@ struct napi_alloc_cache {
>  static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
>  static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
>
> +/* Double check that napi_get_frags() allocates skbs with
> + * skb->head being backed by slab, not a page fragment.
> + * This is to make sure bug fixed in 3226b158e67c
> + * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> + * does not accidentally come back.
> + */
> +void napi_get_frags_check(struct napi_struct *napi)
> +{
> +       struct sk_buff *skb;
> +
> +       local_bh_disable();
> +       skb = napi_get_frags(napi);
> +       WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
> +       napi_free_frags(napi);
> +       local_bh_enable();
> +}
> +
>  void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
>  {
>         struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> @@ -561,15 +643,39 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>  {
>         struct napi_alloc_cache *nc;
>         struct sk_buff *skb;
> +       bool pfmemalloc;
>         void *data;
>
>         DEBUG_NET_WARN_ON_ONCE(!in_softirq());
>         len += NET_SKB_PAD + NET_IP_ALIGN;
>
> +       /* When the small frag allocator is available, prefer it over kmalloc
> +        * for small fragments
> +        */
> +       if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
> +               nc = this_cpu_ptr(&napi_alloc_cache);
> +
> +               if (sk_memalloc_socks())
> +                       gfp_mask |= __GFP_MEMALLOC;
> +
> +               /* we are artificially inflating the allocation size, but
> +                * that is not as bad as it may look like, as:
> +                * - 'len' less then GRO_MAX_HEAD makes little sense
> +                * - larger 'len' values lead to fragment size above 512 bytes
> +                *   as per NAPI_HAS_SMALL_PAGE_FRAG definition
> +                * - kmalloc would use the kmalloc-1k slab for such values
> +                */
> +               len = SZ_1K;
> +
> +               data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
> +               pfmemalloc = nc->page_small.pfmemalloc;
> +               goto check_data;
> +       }
> +
>         /* If requested length is either too small or too big,
>          * we use kmalloc() for skb->head allocation.
>          */
> -       if (len <= SKB_WITH_OVERHEAD(1024) ||
> +       if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
>             len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
>             (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
>                 skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
> @@ -587,6 +693,9 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>                 gfp_mask |= __GFP_MEMALLOC;
>
>         data = page_frag_alloc(&nc->page, len, gfp_mask);
> +       pfmemalloc = nc->page.pfmemalloc;
> +
> +check_data:
>         if (unlikely(!data))
>                 return NULL;
>
> @@ -596,8 +705,8 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>                 return NULL;
>         }
>
> -       if (nc->page.pfmemalloc)
> -               skb->pfmemalloc = 1;
> +       if (pfmemalloc)
> +               skb->pfmemalloc = pfmemalloc;
>         skb->head_frag = 1;
>
>  skb_success:
> --
> 2.37.3
>

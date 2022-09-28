Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878515ED3C4
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 06:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiI1EFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 00:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI1EFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 00:05:17 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F05E1189
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 21:05:13 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3511e80f908so55826157b3.2
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 21:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=RPf4151VG3PqLiTuQMZei3P/bXFjSC+7L6moUhbV24Q=;
        b=C0Mbe//EoVN+AFTPrufHnV6QnEf8K6fI5pOkqmq5QI+EDohT8Mi4kp6w4fPWm3Sk5E
         pVZ1g80EeLkQWbGaAo1fbjfFsnkvKpceAXiuT2UrfeUJ77a0AGejk0SlCRtqmt0Z5E31
         iXAL0GiCqtY2CP+SaDuZKJfDA1su6LlbKyxKly/949xsA2Vrwzoxpo9HXzTH5IMtgC0o
         XXI2m23GBKh7Uc7NjhAR+CrwSC4SqGDp8ZwyYJxyCLcNG9D6GeRastiFCZmuBfhw+NgI
         FMD5pamuwgZuuXDTDRRG1yDl3QbG64OgLGe6TCR23PnzVYxkSMecq/fiLHNpVubuTYAB
         DwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=RPf4151VG3PqLiTuQMZei3P/bXFjSC+7L6moUhbV24Q=;
        b=OEM1vaK3J3jC3y5Pvflet7O/o7Rh/eulrr9r3uAuSdSPzsRY5eMCX9vFm9Z3njA6Bi
         jyPXeq1BVgxk7pzBFwwiUHUU51PqRMhz+5gfuescEVw02y7QTnb1P7rXuT2mX7b8xio/
         dohH5isefIvG5z10/IdZX/kkTq0ECwlpiNDie1/1Cj/+TFmtQqfqSG4pDBTtJtV00U2Z
         98a759mlIHPyrdSNWCcB4eKiYRZ6H/ZzMWgLzuyYnIAH1czuYTppXH6d2ifbZ84xHZfl
         EyhsKhLfyLr061WusT9IEWjcS6HRGcXHD/rKa4YZZje/fV+3yq+xbhNXG5KxR/keuc6/
         IbJA==
X-Gm-Message-State: ACrzQf2X55nL03olurJlauFYmbtCClM8045oPOtjmOZAc4kw2etFyKt7
        ZIKvVJrJwQFdQRzvu1pzKFkoqeLx+riO27d5Q+pQ80ywj9PG+g==
X-Google-Smtp-Source: AMsMyM6GVN09ot7T3GipxCytlw8bG4CGhtuCfNG/3eqfOiZoW3I8dA9IlSCA3RtKONtlhuUvuTv24yq7KtcFCds7ns0=
X-Received: by 2002:a81:4e0d:0:b0:351:99d8:1862 with SMTP id
 c13-20020a814e0d000000b0035199d81862mr7376833ywb.278.1664337912381; Tue, 27
 Sep 2022 21:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <8596dd058b9f94f519a8f035dbf8a94670c1ccea.1663953061.git.pabeni@redhat.com>
In-Reply-To: <8596dd058b9f94f519a8f035dbf8a94670c1ccea.1663953061.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 21:05:01 -0700
Message-ID: <CANn89i+NWzLxyXPMysaLrMZ-_fWmKUBTFdoL74exBzsSPi8Www@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: skb: introduce and use a single page
 frag cache
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander H Duyck <alexanderduyck@fb.com>
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

On Fri, Sep 23, 2022 at 10:14 AM Paolo Abeni <pabeni@redhat.com> wrote:
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
> Suggested-by: Alexander H Duyck <alexanderduyck@fb.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v2 -> v3:
>  - updated Alex email address
>  - fixed build with !NAPI_HAS_SMALL_PAGE_FRAG
>
> v1 -> v2:
>  - better page_frag_alloc_1k() (Alex & Eric)
>  - avoid duplicate code and gfp_flags misuse in __napi_alloc_skb() (Alex)
> ---
>  include/linux/netdevice.h |   1 +
>  net/core/dev.c            |  17 ------
>  net/core/skbuff.c         | 112 ++++++++++++++++++++++++++++++++++++--
>  3 files changed, 108 insertions(+), 22 deletions(-)
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
> index f1b8b20fc20b..e7578549a561 100644
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

This looks quite convoluted to me.
It hides the relation between GRO_MAX_HEAD and MAX_HEADER ?
Is anyone going to notice if we consume 1K instead of 512 bytes on
32bit arches, and when LL_MAX_HEADER==32
and no tunnel is enabled ?

I would simply use

#if PAGE_SIZE == SZ_4K


> +
> +#define NAPI_HAS_SMALL_PAGE_FRAG       1
> +#define NAPI_SMALL_PAGE_PFMEMALLOC(nc) ((nc).pfmemalloc)
> +
> +/* specializzed page frag allocator using a single order 0 page

specialized

> + * and slicing it into 1K sized fragment. Constrained to system
> + * with:
> + * - a very limited amount of 1K fragments fitting a single
> + *   page - to avoid excessive truesize underestimation
> + * - reasonably high truesize value for napi_get_frags()
> + *   allocation - to avoid memory usage increased compared
> + *   to kalloc, see __napi_alloc_skb()
> + */
> +
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
> +       offset = nc->offset - SZ_1K;
> +       if (likely(offset >= 0))
> +               goto use_frag;
> +
> +       page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
> +       if (!page)
> +               return NULL;
> +
> +       nc->va = page_address(page);
> +       nc->pfmemalloc = page_is_pfmemalloc(page);
> +       offset = PAGE_SIZE - SZ_1K;
> +       page_ref_add(page, offset / SZ_1K);
> +
> +use_frag:
> +       nc->offset = offset;
> +       return nc->va + offset;
> +}
> +#else
> +
> +/* the small page is actually unused in this build; add dummy helpers
> + * to plase the compiler and avoiding later preprocessor's conditionals
> + */
> +#define NAPI_HAS_SMALL_PAGE_FRAG       0
> +#define NAPI_SMALL_PAGE_PFMEMALLOC(nc) false
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
> @@ -561,6 +643,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>  {
>         struct napi_alloc_cache *nc;
>         struct sk_buff *skb;
> +       bool pfmemalloc;
>         void *data;
>
>         DEBUG_NET_WARN_ON_ONCE(!in_softirq());
> @@ -568,8 +651,10 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>
>         /* If requested length is either too small or too big,
>          * we use kmalloc() for skb->head allocation.
> +        * When the small frag allocator is available, prefer it over kmalloc
> +        * for small fragments
>          */
> -       if (len <= SKB_WITH_OVERHEAD(1024) ||
> +       if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
>             len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
>             (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
>                 skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
> @@ -580,13 +665,30 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>         }
>
>         nc = this_cpu_ptr(&napi_alloc_cache);
> -       len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -       len = SKB_DATA_ALIGN(len);
>
>         if (sk_memalloc_socks())
>                 gfp_mask |= __GFP_MEMALLOC;
>
> -       data = page_frag_alloc(&nc->page, len, gfp_mask);
> +       if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
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
> +               pfmemalloc = NAPI_SMALL_PAGE_PFMEMALLOC(nc->page_small);
> +       } else {
> +               len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +               len = SKB_DATA_ALIGN(len);
> +
> +               data = page_frag_alloc(&nc->page, len, gfp_mask);
> +               pfmemalloc = nc->page.pfmemalloc;
> +       }
> +
>         if (unlikely(!data))
>                 return NULL;
>
> @@ -596,7 +698,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>                 return NULL;
>         }
>
> -       if (nc->page.pfmemalloc)
> +       if (pfmemalloc)
>                 skb->pfmemalloc = 1;
>         skb->head_frag = 1;
>
> --
> 2.37.3
>

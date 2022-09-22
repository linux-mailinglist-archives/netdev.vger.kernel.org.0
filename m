Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0A05E6DD6
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiIVVRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiIVVRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:17:33 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CD610D664
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:17:30 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b21so9984799plz.7
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1IpU1OQQhj4jva4GWHionpZ2OE70RQB3XVmWh6ZlAMs=;
        b=Vd28LuLwOWrD4/X7wE2rdjyLMdtn4RXRzzSUc7+mXL0K6FwEFOYHFivfT/ZnoVeN5E
         JtQz7OrwzyihooqrbVjEDei9Mke0GyJccY3hmc6yuuM1ymqU0C5EWC5tUWKr/PcaHsrR
         nmNE6UjzoNnGZkEdCuk4TaCWhQvg9lgeovAOLP9sdzTYk9cl6t8O9nk2ZX1E2dixJlm+
         +WZk3zii6sAKFSRGcSmt7w8ZaBIdjm1HrGoCxemfxL7VIDdNldxuiqqou+LeQp4SUqur
         0pTXHFMUyaJOsG6xytFfA4PdVmNhTOV3FmHUUd+Z/tAQpsRaRW29RIx25yRRoOEThvAB
         V5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1IpU1OQQhj4jva4GWHionpZ2OE70RQB3XVmWh6ZlAMs=;
        b=4TWmspVOXiH5SV8db7NKzeQIgVYf58XgfbfIVwYIKoayarlJXcSc/XqGeeMAxd4stI
         zCff0UAXG9uRoehot1WXd8nXLKwOnmDrg0NioiDXPdv9efvAh6BJxkbFO3FC3ZXxgYxd
         PBLMLlcM3MAOGxp6CBo2G4tghZ6InPWk8wYxXH2hhtGmC/DyE0fHu5aac3FA482w6xNp
         9W5RTzoFBRF9MoQQT9sMeJFA48CAoLPU0CrIESf2qw3MBeO6y/pZNn+r/EMDPb1/d30y
         On8vK9Aql4YlGI3qLyMzjx0PdXZKIOkUAnOvAqhq0H6TCYhWfDY7Gcar59JgLrMz7+7Q
         2nlw==
X-Gm-Message-State: ACrzQf3/OI1Xh9asjJvZ8hwot1c8noiv7hQckH5mJ0N4wpNgQ2DL+DSV
        ROnS2fVEG/uqF2gIt5jC5ITllr3IljEgvlvSq2U=
X-Google-Smtp-Source: AMsMyM6k6krvvHSPHteWtV/ITx016TgQ1/N0YSLrFAkSZwzuPb2y9ejcw8qpFbZApQ6qsmliUeE9+4cZzMBJP4XS7Ko=
X-Received: by 2002:a17:90b:1b0e:b0:202:c913:221f with SMTP id
 nu14-20020a17090b1b0e00b00202c913221fmr17488887pjb.211.1663881450060; Thu, 22
 Sep 2022 14:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <162fe40c387cd395d633729fa4f2b5245531514a.1663879752.git.pabeni@redhat.com>
In-Reply-To: <162fe40c387cd395d633729fa4f2b5245531514a.1663879752.git.pabeni@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 22 Sep 2022 14:17:18 -0700
Message-ID: <CAKgT0Uc2qmKTeZMCTR3ZkibioxEwKHjKqLrnz-=cfSt+5TAv=g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: skb: introduce and use a single page
 frag cache
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 2:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
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

Please update my email to <alexanderduyck@fb.com>.

> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v1 -> v2:
>  - better page_frag_alloc_1k() (Alex & Eric)
>  - avoid duplicate code and gfp_flags misuse in __napi_alloc_skb() (Alex)
> ---
>  include/linux/netdevice.h |   1 +
>  net/core/dev.c            |  17 ------
>  net/core/skbuff.c         | 106 ++++++++++++++++++++++++++++++++++++--
>  3 files changed, 102 insertions(+), 22 deletions(-)
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
> index f1b8b20fc20b..00340b0cf6eb 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -134,8 +134,67 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
>  #define NAPI_SKB_CACHE_BULK    16
>  #define NAPI_SKB_CACHE_HALF    (NAPI_SKB_CACHE_SIZE / 2)
>
> +/* the compiler doesn't like 'SKB_TRUESIZE(GRO_MAX_HEAD) > 512', but we
> + * can imply such condition checking the double word and MAX_HEADER size
> + */
> +#if PAGE_SIZE == SZ_4K && (defined(CONFIG_64BIT) || MAX_HEADER > 64)
> +
> +#define NAPI_HAS_SMALL_PAGE_FRAG       1
> +
> +/* specializzed page frag allocator using a single order 0 page
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
> +#define NAPI_HAS_SMALL_PAGE_FRAG       0
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

My suggestion earlier was to just make the 1k cache a page_frag_cache.
It will allow you to reuse the same structure members and a single
pointer to track them. Waste would be minimal since the only real
difference between the structures is about 8B for the structure, and
odds are the napi_alloc_cache allocation is being rounded up anyway.

>         unsigned int skb_count;
>         void *skb_cache[NAPI_SKB_CACHE_SIZE];
>  };
> @@ -143,6 +202,23 @@ struct napi_alloc_cache {
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
> @@ -561,6 +637,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>  {
>         struct napi_alloc_cache *nc;
>         struct sk_buff *skb;
> +       bool pfmemalloc;

Rather than adding this I think you would be better off adding a
struct page_frag_cache pointer. I will reference it here as "pfc".

>         void *data;
>
>         DEBUG_NET_WARN_ON_ONCE(!in_softirq());
> @@ -568,8 +645,10 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
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
> @@ -580,13 +659,30 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
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

Then here you would add a line that would be:
pfc = &nc->page_small;

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

Instead of setting pfmemalloc you could just update the line below. In
addition you would just be passing pfc as the parameter.

> +       } else {

Likewise here you would have the line:
pfc = &nc->page;

> +               len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +               len = SKB_DATA_ALIGN(len);
> +
> +               data = page_frag_alloc(&nc->page, len, gfp_mask);
> +               pfmemalloc = nc->page.pfmemalloc;

Again no need for the pfmemalloc and the alloc could just come from pfc

> +       }
> +
>         if (unlikely(!data))
>                 return NULL;
>
> @@ -596,7 +692,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>                 return NULL;
>         }
>
> -       if (nc->page.pfmemalloc)
> +       if (pfmemalloc)

Instead of passing pfmemalloc you could just check pfc->pfmemalloc.
Alternatively I wonder if it wouldn't be faster to just set the value
directly based on frag_cache->pfmemalloc and avoid the conditional
check entirely.

>                 skb->pfmemalloc = 1;
>         skb->head_frag = 1;
>
> --
> 2.37.3
>

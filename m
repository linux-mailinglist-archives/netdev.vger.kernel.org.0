Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291E168881E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjBBUOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbjBBUOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:14:48 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73066252A2
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:14:47 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id o187so3737382ybg.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 12:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6ng0lSlV3YAk3L4/aoYmEoWmfDKyNF440IgQ6SYkohU=;
        b=iq6oGifjp+R2/kyLLI88Vhr6YIgH0wnuITxm5XbVrURECmssm7JE78Usdq1uldEUjB
         xlA1sHNFVnkOhCKnA9rs3ke/COuIF0/IHYuFM/vX1r+dKf69RDOGbMSWNUf30SEv0sEn
         gW204k0OOAeqfhPqT74m34pItuNWSDVhjphV49GjA4mTkxavp4xAmms3kLWHPKEOxPxF
         4G5wZaYayTnxi//tHLtouzs3t4kkJtOTVNakyTr0vxRpkA/GjsVFnCkPAc/nL9p7888n
         MV1WqQHPSQJAyBNYCzW/YcNl7NyLa/Ltt2qSY/uZILssOTIyA9C/8EyotLIPkPg8QHiv
         corQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ng0lSlV3YAk3L4/aoYmEoWmfDKyNF440IgQ6SYkohU=;
        b=DWya2WzS4cF8S3hC23CCvXj4kycJp+xa61Z6impDo5cKJ3v+vt5TmEVYYOJ/2Ta8am
         O0nGsz+T5McnWw1Mza38s0U/cKGi+kuAARlQcKnLsG0s9hH6Fop8ElNBxQxbbapfjcti
         fahHeRVufErlxhS7aO2BafoLHopNDbMVp2bABxPEy5znFi7Akf3m5ZHhjhVCv5SyAdhx
         mDyWGmQqajD7LBjY4/8/HMG+BHGxE1Qehu6+bO3tca7qIOrp+iLdh4El++NpcLBLUMoI
         Utj/osDv8JNybhHKCa9vRkiEW79RQKCz9WNecubKG9RRGmFhqH1lsIp+q8tpXom3snUq
         yKEA==
X-Gm-Message-State: AO0yUKVfJg/JGcOy2Q0+XpJh7VOMPau/C5t4YWh0H4DgdwE6xtv/tKgD
        HHduRFkVblG9DcPI4Rx5yhU6aVW6kqTt8bHBzaPpGQ==
X-Google-Smtp-Source: AK7set/vAlMj0BiAshTKttYeQ4E2UuKZjphYvrLU5kgDxWGm1Rj/l0dy9PJPmdhkDt8n4Pp2674b1A0ahCczjnOwCeM=
X-Received: by 2002:a25:be8b:0:b0:80b:55ea:1510 with SMTP id
 i11-20020a25be8b000000b0080b55ea1510mr741334ybk.577.1675368886315; Thu, 02
 Feb 2023 12:14:46 -0800 (PST)
MIME-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com> <20230202185801.4179599-5-edumazet@google.com>
In-Reply-To: <20230202185801.4179599-5-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 2 Feb 2023 15:14:10 -0500
Message-ID: <CACSApvYfnBBobJz5hXeyhKktGOqSOf4JNvQYOHXVdf6aysZ2Qw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: add dedicated kmem_cache for
 typical/small skb->head
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Alexander Duyck <alexanderduyck@fb.com>
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

On Thu, Feb 2, 2023 at 1:58 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Recent removal of ksize() in alloc_skb() increased
> performance because we no longer read
> the associated struct page.
>
> We have an equivalent cost at kfree_skb() time.
>
> kfree(skb->head) has to access a struct page,
> often cold in cpu caches to get the owning
> struct kmem_cache.
>
> Considering that many allocations are small,
> we can have our own kmem_cache to avoid the cache line miss.
>
> This also saves memory because these small heads
> are no longer padded to 1024 bytes.
>
> CONFIG_SLUB=y
> $ grep skbuff_small_head /proc/slabinfo
> skbuff_small_head   2907   2907    640   51    8 : tunables    0    0    0 : slabdata     57     57      0
>
> CONFIG_SLAB=y
> $ grep skbuff_small_head /proc/slabinfo
> skbuff_small_head    607    624    640    6    1 : tunables   54   27    8 : slabdata    104    104      5
>
> Note: after Kees Cook patches and this one, we might
> be able to revert commit
> dbae2b062824 ("net: skb: introduce and use a single page frag cache")
> because GRO_MAX_HEAD is also small.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Very nice!

> ---
>  net/core/skbuff.c | 52 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 47 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index ae0b2aa1f01e8060cc4fe69137e9bd98e44280cc..3e540b4924701cc57b6fbd1b668bab3b652ee94c 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -89,6 +89,19 @@ static struct kmem_cache *skbuff_fclone_cache __ro_after_init;
>  #ifdef CONFIG_SKB_EXTENSIONS
>  static struct kmem_cache *skbuff_ext_cache __ro_after_init;
>  #endif
> +static struct kmem_cache *skb_small_head_cache __ro_after_init;
> +
> +#define SKB_SMALL_HEAD_SIZE SKB_HEAD_ALIGN(MAX_TCP_HEADER)
> +
> +/* We want SKB_SMALL_HEAD_CACHE_SIZE to not be a power of two. */
> +#define SKB_SMALL_HEAD_CACHE_SIZE                                      \
> +       (is_power_of_2(SKB_SMALL_HEAD_SIZE) ?                   \
> +               (SKB_SMALL_HEAD_SIZE + L1_CACHE_BYTES) :        \
> +               SKB_SMALL_HEAD_SIZE)
> +
> +#define SKB_SMALL_HEAD_HEADROOM                                                \
> +       SKB_WITH_OVERHEAD(SKB_SMALL_HEAD_CACHE_SIZE)
> +
>  int sysctl_max_skb_frags __read_mostly = MAX_SKB_FRAGS;
>  EXPORT_SYMBOL(sysctl_max_skb_frags);
>
> @@ -486,6 +499,21 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
>         void *obj;
>
>         obj_size = SKB_HEAD_ALIGN(*size);
> +       if (obj_size <= SKB_SMALL_HEAD_CACHE_SIZE &&
> +           !(flags & KMALLOC_NOT_NORMAL_BITS)) {
> +
> +               /* skb_small_head_cache has non power of two size,
> +                * likely forcing SLUB to use order-3 pages.
> +                * We deliberately attempt a NOMEMALLOC allocation only.
> +                */
> +               obj = kmem_cache_alloc_node(skb_small_head_cache,
> +                               flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
> +                               node);
> +               if (obj) {
> +                       *size = SKB_SMALL_HEAD_CACHE_SIZE;
> +                       goto out;
> +               }
> +       }
>         *size = obj_size = kmalloc_size_roundup(obj_size);
>         /*
>          * Try a regular allocation, when that fails and we're not entitled
> @@ -805,6 +833,14 @@ static bool skb_pp_recycle(struct sk_buff *skb, void *data)
>         return page_pool_return_skb_page(virt_to_page(data));
>  }
>
> +static void skb_kfree_head(void *head, unsigned int end_offset)
> +{
> +       if (end_offset == SKB_SMALL_HEAD_HEADROOM)
> +               kmem_cache_free(skb_small_head_cache, head);
> +       else
> +               kfree(head);
> +}
> +
>  static void skb_free_head(struct sk_buff *skb)
>  {
>         unsigned char *head = skb->head;
> @@ -814,7 +850,7 @@ static void skb_free_head(struct sk_buff *skb)
>                         return;
>                 skb_free_frag(head);
>         } else {
> -               kfree(head);
> +               skb_kfree_head(head, skb_end_offset(skb));
>         }
>  }
>
> @@ -1995,7 +2031,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>         return 0;
>
>  nofrags:
> -       kfree(data);
> +       skb_kfree_head(data, size);
>  nodata:
>         return -ENOMEM;
>  }
> @@ -4633,6 +4669,12 @@ void __init skb_init(void)
>                                                 0,
>                                                 SLAB_HWCACHE_ALIGN|SLAB_PANIC,
>                                                 NULL);
> +       skb_small_head_cache = kmem_cache_create("skbuff_small_head",
> +                                               SKB_SMALL_HEAD_CACHE_SIZE,
> +                                               0,
> +                                               SLAB_HWCACHE_ALIGN | SLAB_PANIC,
> +                                               NULL);
> +
>         skb_extensions_init();
>  }
>
> @@ -6297,7 +6339,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
>         if (skb_cloned(skb)) {
>                 /* drop the old head gracefully */
>                 if (skb_orphan_frags(skb, gfp_mask)) {
> -                       kfree(data);
> +                       skb_kfree_head(data, size);
>                         return -ENOMEM;
>                 }
>                 for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
> @@ -6405,7 +6447,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
>         memcpy((struct skb_shared_info *)(data + size),
>                skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));
>         if (skb_orphan_frags(skb, gfp_mask)) {
> -               kfree(data);
> +               skb_kfree_head(data, size);
>                 return -ENOMEM;
>         }
>         shinfo = (struct skb_shared_info *)(data + size);
> @@ -6441,7 +6483,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
>                 /* skb_frag_unref() is not needed here as shinfo->nr_frags = 0. */
>                 if (skb_has_frag_list(skb))
>                         kfree_skb_list(skb_shinfo(skb)->frag_list);
> -               kfree(data);
> +               skb_kfree_head(data, size);
>                 return -ENOMEM;
>         }
>         skb_release_data(skb, SKB_CONSUMED);
> --
> 2.39.1.456.gfc5497dd1b-goog
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7DD68880B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjBBUKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbjBBUKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:10:19 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EF97C719
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:10:14 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-5249a65045aso9438477b3.13
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 12:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MIn/H8lzpdfEjIseQL0kZZEuDmxfsNbogRm3rguVyIw=;
        b=N4o5JAYVqvaDWtuLk8aWyC1SP5JggjSZ2cOTIVQ9qO8ivn+TOm1jklpjaGWP58pdyn
         q7tX3DbMd8TJO3Ul+kvIiwE3hf5uGSMzWnuPEHeLAreX3VUfOsfblCWSW0x6OtcXfYqQ
         Ub3FAbRiRUCPYxPmu8voJKzct1qfvlKm80UhY0w4GEeefknjwhbNbq3a3SwXyi+VE76X
         gfAGHMdxOjXo/GB3BdAH5DZv3aqNP1NTb1xMS0LNdDLF4VELu9msv2I/Ev/J0F8+Zaio
         cJwh7NSG226P7heodvxAXpMh9AbqEKr/nxfMMDoAGzrvKGy+u24rjBgBvVLFzJzQXv97
         COVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MIn/H8lzpdfEjIseQL0kZZEuDmxfsNbogRm3rguVyIw=;
        b=V0eVpQ6chmlz3zmovKUZbW7QzonTBIFdr7+H7LogCjXyYVIPMho9LlczA4naSK/tQh
         IdosWfPbRHJIhBwNOlwK2GPu+34j7V9f8Y+AYptt6mxxg89FMeV/0vvmtxrPKTmki4lE
         BZvMc3yJbbVVi3HuaDmVQNaIA5GiW2XwQ+chHyswp2jGbIbF1tl0FJKuCM24D42giTyr
         FpsdC/MO+1Ui03l9dASAAjwLBTjNTmRLsVshbCKhARQ8HdxRRJCQFCLuWLmLF6tVLo9X
         VIyi2lghOu8MLSNtuI8em4qNKsr7OQdAJeiL8H8GSstXyVahwbmT47MnJ1n67JtcBQ2M
         UUzg==
X-Gm-Message-State: AO0yUKXopaGsvgqoaHDugd7NhjP2aow7vvYuhAimg0AGxirzEAanXXVE
        Lu/XRxg65ZdyESU02waMEH88YY8kHecnk4kKs9QIzg==
X-Google-Smtp-Source: AK7set9iekyBhpZCcabm2/8n0CCphQ8nvDddAJFfeAIUG1JZkXXKQamycWsdO+O8GeM69qhxs3WWrGn1x6nipzG82C4=
X-Received: by 2002:a05:690c:842:b0:506:ac51:f94a with SMTP id
 bz2-20020a05690c084200b00506ac51f94amr1024106ywb.64.1675368613275; Thu, 02
 Feb 2023 12:10:13 -0800 (PST)
MIME-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com> <20230202185801.4179599-4-edumazet@google.com>
In-Reply-To: <20230202185801.4179599-4-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 2 Feb 2023 15:09:37 -0500
Message-ID: <CACSApvaHFKGNEm8p5mG9b7XRPX2U0ScPXFSRgFhYSz=L3AE-HQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: factorize code in kmalloc_reserve()
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
> All kmalloc_reserve() callers have to make the same computation,
> we can factorize them, to prepare following patch in the series.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  net/core/skbuff.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index a82df5289208d69716e60c5c1f201ec3ca50a258..ae0b2aa1f01e8060cc4fe69137e9bd98e44280cc 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -478,17 +478,20 @@ EXPORT_SYMBOL(napi_build_skb);
>   * may be used. Otherwise, the packet data may be discarded until enough
>   * memory is free
>   */
> -static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
> +static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
>                              bool *pfmemalloc)
>  {
> -       void *obj;
>         bool ret_pfmemalloc = false;
> +       unsigned int obj_size;
> +       void *obj;
>
> +       obj_size = SKB_HEAD_ALIGN(*size);
> +       *size = obj_size = kmalloc_size_roundup(obj_size);
>         /*
>          * Try a regular allocation, when that fails and we're not entitled
>          * to the reserves, fail.
>          */
> -       obj = kmalloc_node_track_caller(size,
> +       obj = kmalloc_node_track_caller(obj_size,
>                                         flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
>                                         node);
>         if (obj || !(gfp_pfmemalloc_allowed(flags)))
> @@ -496,7 +499,7 @@ static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
>
>         /* Try again but now we are using pfmemalloc reserves */
>         ret_pfmemalloc = true;
> -       obj = kmalloc_node_track_caller(size, flags, node);
> +       obj = kmalloc_node_track_caller(obj_size, flags, node);
>
>  out:
>         if (pfmemalloc)
> @@ -557,9 +560,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>          * aligned memory blocks, unless SLUB/SLAB debug is enabled.
>          * Both skb->head and skb_shared_info are cache line aligned.
>          */
> -       size = SKB_HEAD_ALIGN(size);
> -       size = kmalloc_size_roundup(size);
> -       data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> +       data = kmalloc_reserve(&size, gfp_mask, node, &pfmemalloc);
>         if (unlikely(!data))
>                 goto nodata;
>         /* kmalloc_size_roundup() might give us more room than requested.
> @@ -1931,9 +1932,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>         if (skb_pfmemalloc(skb))
>                 gfp_mask |= __GFP_MEMALLOC;
>
> -       size = SKB_HEAD_ALIGN(size);
> -       size = kmalloc_size_roundup(size);
> -       data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
> +       data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
>         if (!data)
>                 goto nodata;
>         size = SKB_WITH_OVERHEAD(size);
> @@ -6282,9 +6281,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
>         if (skb_pfmemalloc(skb))
>                 gfp_mask |= __GFP_MEMALLOC;
>
> -       size = SKB_HEAD_ALIGN(size);
> -       size = kmalloc_size_roundup(size);
> -       data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
> +       data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
>         if (!data)
>                 return -ENOMEM;
>         size = SKB_WITH_OVERHEAD(size);
> @@ -6400,9 +6397,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
>         if (skb_pfmemalloc(skb))
>                 gfp_mask |= __GFP_MEMALLOC;
>
> -       size = SKB_HEAD_ALIGN(size);
> -       size = kmalloc_size_roundup(size);
> -       data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
> +       data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
>         if (!data)
>                 return -ENOMEM;
>         size = SKB_WITH_OVERHEAD(size);
> --
> 2.39.1.456.gfc5497dd1b-goog
>

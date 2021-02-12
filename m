Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1A43198A9
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBLDTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhBLDTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:19:37 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D48C061574;
        Thu, 11 Feb 2021 19:18:57 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e133so7938646iof.8;
        Thu, 11 Feb 2021 19:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gC9STVbE2ob8taGqJ2B3Q5LeUbYPwP+eNdSIa6spCUM=;
        b=ZEzsEWpPR2rbQ/c2UL8vEy2CL3CFEoUUQbesWOu8YYUGQq6GxgsJNHxxC8xsHeoaoO
         SjGIH6pSEGa4AurfM3zAoRjBViezGTJkyGYCQRaGYW0jAcJsRJ0q76H8EFddgGxlH6wQ
         MnsP+7rYdacYXQi3PWDpFbd2RW9qV1tLvUn4WNy+pldFW6fEUt9eMX8XtnwFBEPaw+2y
         xE69CwXIe1e7bp16lZQWA9ETxUx8ZV8/++SYpsjcobmpuMtliwnDm+q9wQ5y7Z8gmWBf
         /ZnVSeLs8wRvS1iQ7Z5p4AiBn2Jc4Oizte1PLsQ+hB8Ccx94dA571Ze6uH/XuGuiyUmX
         oDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gC9STVbE2ob8taGqJ2B3Q5LeUbYPwP+eNdSIa6spCUM=;
        b=ECnRNuq4/zHU0nVyM7nmWIBmTWO2s+ORwgpgJTjTq6yXRTyVhVWA3Kio26DXWinOpN
         FC0RUU/MATHzUSpNBJwYT9rmF+liOgG59C2llKyZdegUbiAwP/psgbHDV5jxUsXgFStJ
         rDojx00rLVBGBAlKMPRHDB5q/aul+xONdOwsU9DG4vQQTKg5C0d0kl00VGxurcOgB3wm
         /TqXOFlwuloHqimyjsuRHrLxDjXMNkESUwZqOsdAgSc36x3UrytFa6k73gy5Wcnnontt
         HFhBXH0TFxz5tEKLDXSMzlA8m7SPATz2J5NumVyBVb+8vthAFwYFxPpXLE3JBOlZVDAn
         46LA==
X-Gm-Message-State: AOAM530ZMgGrksLzuRkzK7HjZyqbEjOdz58wSepcdm1yHr3GZO64gyvl
        cymqnu4yYRiL8acRTc3vDCiWLOuBs95H+JTIA8s=
X-Google-Smtp-Source: ABdhPJxrKJnsXZXzvSEHPa0vNE78OHxSq8C2jRwzawbDEc8S9S0mm3QUIAEUfkweYLJCBPFZanXUiHOhm6umU63vo8Y=
X-Received: by 2002:a05:6638:11a:: with SMTP id x26mr858514jao.121.1613099936449;
 Thu, 11 Feb 2021 19:18:56 -0800 (PST)
MIME-Version: 1.0
References: <20210211185220.9753-1-alobakin@pm.me> <20210211185220.9753-10-alobakin@pm.me>
In-Reply-To: <20210211185220.9753-10-alobakin@pm.me>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Feb 2021 19:18:45 -0800
Message-ID: <CAKgT0UejU=YC-3xnORHh8uj_uuf79yYMGTdFvo9o7aY03eGeqA@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 09/11] skbuff: allow to optionally use NAPI
 cache from __alloc_skb()
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 11:00 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Reuse the old and forgotten SKB_ALLOC_NAPI to add an option to get
> an skbuff_head from the NAPI cache instead of inplace allocation
> inside __alloc_skb().
> This implies that the function is called from softirq or BH-off
> context, not for allocating a clone or from a distant node.
>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/core/skbuff.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 9e1a8ded4acc..a0b457ae87c2 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -397,15 +397,20 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>         struct sk_buff *skb;
>         u8 *data;
>         bool pfmemalloc;
> +       bool clone;
>
> -       cache = (flags & SKB_ALLOC_FCLONE)
> -               ? skbuff_fclone_cache : skbuff_head_cache;
> +       clone = !!(flags & SKB_ALLOC_FCLONE);

The boolean conversion here is probably unnecessary. I would make
clone an int like flags and work with that. I suspect the compiler is
doing it already, but it is better to be explicit.

> +       cache = clone ? skbuff_fclone_cache : skbuff_head_cache;
>
>         if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
>                 gfp_mask |= __GFP_MEMALLOC;
>
>         /* Get the HEAD */
> -       skb = kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
> +       if ((flags & SKB_ALLOC_NAPI) && !clone &&

Rather than having to do two checks you could just check for
SKB_ALLOC_NAPI and SKB_ALLOC_FCLONE in a single check. You could just
do something like:
    if ((flags & (SKB_ALLOC_FCLONE | SKB_ALLOC_NAPI) == SKB_ALLOC_NAPI)

That way you can avoid the extra conditional jumps and can start
computing the flags value sooner.

> +           likely(node == NUMA_NO_NODE || node == numa_mem_id()))
> +               skb = napi_skb_cache_get();
> +       else
> +               skb = kmem_cache_alloc_node(cache, gfp_mask & ~GFP_DMA, node);
>         if (unlikely(!skb))
>                 return NULL;
>         prefetchw(skb);
> @@ -436,7 +441,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>         __build_skb_around(skb, data, 0);
>         skb->pfmemalloc = pfmemalloc;
>
> -       if (flags & SKB_ALLOC_FCLONE) {
> +       if (clone) {
>                 struct sk_buff_fclones *fclones;
>
>                 fclones = container_of(skb, struct sk_buff_fclones, skb1);
> --
> 2.30.1
>
>

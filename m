Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152E931AB1A
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 12:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBMLyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 06:54:15 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:28722 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhBMLyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 06:54:14 -0500
Date:   Sat, 13 Feb 2021 11:53:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613217205; bh=U9h7ecCA02bgXdLGxxosUvrTLcI+jIc/SZnrWbn3k90=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ZMq4DHhrTAzzviEoROqpXjW+tTJgetKNneTLYWBIlq1hjBTgqXgIdVKLHdwApgF7D
         v6L+0+0nn2UAdmV3DHCnIKrIcYo3rYVJfsas0IkWgFG1DFZ4ISVs+MUGiqZikiQ5cu
         zgqi1RJsyMOhvehrQ0f88EyM8+UGaK/FXcLBFOtbzEfdNQ50aP3QQzCevV27iIoNk3
         lWwWv3QRAwYmKvAA823cwxis7+DpyMK6eB0dh9BfcGG0sZlxUwme2Y41HSFgbrci0Y
         +YCAKrVwxz45r9IAYqW+hXstZ1PBaISrHf+hxT5PA5XPhcCA3C91XpOaKUCTJBUl5y
         YyC7MAAwCewEg==
To:     Alexander Duyck <alexander.duyck@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
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
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
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
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v5 net-next 09/11] skbuff: allow to optionally use NAPI cache from __alloc_skb()
Message-ID: <20210213115229.2728-1-alobakin@pm.me>
In-Reply-To: <CAKgT0UejU=YC-3xnORHh8uj_uuf79yYMGTdFvo9o7aY03eGeqA@mail.gmail.com>
References: <20210211185220.9753-1-alobakin@pm.me> <20210211185220.9753-10-alobakin@pm.me> <CAKgT0UejU=YC-3xnORHh8uj_uuf79yYMGTdFvo9o7aY03eGeqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Thu, 11 Feb 2021 19:18:45 -0800

> On Thu, Feb 11, 2021 at 11:00 AM Alexander Lobakin <alobakin@pm.me> wrote=
:
> >
> > Reuse the old and forgotten SKB_ALLOC_NAPI to add an option to get
> > an skbuff_head from the NAPI cache instead of inplace allocation
> > inside __alloc_skb().
> > This implies that the function is called from softirq or BH-off
> > context, not for allocating a clone or from a distant node.
> >
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/core/skbuff.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 9e1a8ded4acc..a0b457ae87c2 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -397,15 +397,20 @@ struct sk_buff *__alloc_skb(unsigned int size, gf=
p_t gfp_mask,
> >         struct sk_buff *skb;
> >         u8 *data;
> >         bool pfmemalloc;
> > +       bool clone;
> >
> > -       cache =3D (flags & SKB_ALLOC_FCLONE)
> > -               ? skbuff_fclone_cache : skbuff_head_cache;
> > +       clone =3D !!(flags & SKB_ALLOC_FCLONE);
>=20
> The boolean conversion here is probably unnecessary. I would make
> clone an int like flags and work with that. I suspect the compiler is
> doing it already, but it is better to be explicit.
>=20
> > +       cache =3D clone ? skbuff_fclone_cache : skbuff_head_cache;
> >
> >         if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
> >                 gfp_mask |=3D __GFP_MEMALLOC;
> >
> >         /* Get the HEAD */
> > -       skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, nod=
e);
> > +       if ((flags & SKB_ALLOC_NAPI) && !clone &&
>=20
> Rather than having to do two checks you could just check for
> SKB_ALLOC_NAPI and SKB_ALLOC_FCLONE in a single check. You could just
> do something like:
>     if ((flags & (SKB_ALLOC_FCLONE | SKB_ALLOC_NAPI) =3D=3D SKB_ALLOC_NAP=
I)
>=20
> That way you can avoid the extra conditional jumps and can start
> computing the flags value sooner.

I thought about combined check for two flags yesterday, so yeah, that
probably should be better than the current version.

> > +           likely(node =3D=3D NUMA_NO_NODE || node =3D=3D numa_mem_id(=
)))
> > +               skb =3D napi_skb_cache_get();
> > +       else
> > +               skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~GFP_DM=
A, node);
> >         if (unlikely(!skb))
> >                 return NULL;
> >         prefetchw(skb);
> > @@ -436,7 +441,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_=
t gfp_mask,
> >         __build_skb_around(skb, data, 0);
> >         skb->pfmemalloc =3D pfmemalloc;
> >
> > -       if (flags & SKB_ALLOC_FCLONE) {
> > +       if (clone) {
> >                 struct sk_buff_fclones *fclones;
> >
> >                 fclones =3D container_of(skb, struct sk_buff_fclones, s=
kb1);
> > --
> > 2.30.1

Thanks,
Al


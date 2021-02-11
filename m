Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99213318E98
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 16:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhBKPaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 10:30:25 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:63616 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhBKP1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 10:27:54 -0500
Date:   Thu, 11 Feb 2021 15:26:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613057213; bh=LVzb0WFXP5BTyndSSDvVZrA0sSqaGkk4EkDkTvrQzYY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=k4fRLo6TGq5i8/y0neBrbr1UFF/+tigMTucFWh1ZDkibUA0IGp5OYm4ln4611hldw
         R40OrDgEWU5j2UViTIgwmpEOGIj3j0+m/atEP1c7Kxl+aVqHZ8BB1jXX8BSjx5W93m
         tzEzTUtQjeuegLRX6/Aosmh5G7aOnr2zdC/bCyRTXMsDQRkpB8N0OTSkRd60CFvjJD
         1VNUJG5Je7ylv4wdnlPyy+9C1yDV+QjE2V+FZZB0w8oc9Ul1pvcLE1nQ6w7pJQ+gCb
         TaHZtiRmr2TZs0PPM2j8xlKjfkb69Fpp8iy7SE8VEbzBerAEYrAJ/zSObgRKpgJO2O
         zBaV7m6CheHgg==
To:     Paolo Abeni <pabeni@redhat.com>
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
        Jesper Dangaard Brouer <brouer@redhat.com>,
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v4 net-next 09/11] skbuff: allow to optionally use NAPI cache from __alloc_skb()
Message-ID: <20210211152620.3339-1-alobakin@pm.me>
In-Reply-To: <e30145f4fccae3f3543da88cef40633db42b59d2.camel@redhat.com>
References: <20210210162732.80467-1-alobakin@pm.me> <20210210162732.80467-10-alobakin@pm.me> <58147c2d36ea7b6e0284d400229cd79185c53463.camel@redhat.com> <20210211142811.1813-1-alobakin@pm.me> <e30145f4fccae3f3543da88cef40633db42b59d2.camel@redhat.com>
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

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 11 Feb 2021 15:55:04 +0100

> On Thu, 2021-02-11 at 14:28 +0000, Alexander Lobakin wrote:
> > From: Paolo Abeni <pabeni@redhat.com> on Thu, 11 Feb 2021 11:16:40 +010=
0 wrote:
> > > What about changing __napi_alloc_skb() to always use
> > > the __napi_build_skb(), for both kmalloc and page backed skbs? That i=
s,
> > > always doing the 'data' allocation in __napi_alloc_skb() - either via
> > > page_frag or via kmalloc() - and than call __napi_build_skb().
> > >=20
> > > I think that should avoid adding more checks in __alloc_skb() and
> > > should probably reduce the number of conditional used
> > > by __napi_alloc_skb().
> >=20
> > I thought of this too. But this will introduce conditional branch
> > to set or not skb->head_frag. So one branch less in __alloc_skb(),
> > one branch more here, and we also lose the ability to __alloc_skb()
> > with decached head.
>=20
> Just to try to be clear, I mean something alike the following (not even
> build tested). In the fast path it has less branches than the current
> code - for both kmalloc and page_frag allocation.
>=20
> ---
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 785daff48030..a242fbe4730e 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -506,23 +506,12 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct=
 *napi, unsigned int len,
>  =09=09=09=09 gfp_t gfp_mask)
>  {
>  =09struct napi_alloc_cache *nc;
> +=09bool head_frag, pfmemalloc;
>  =09struct sk_buff *skb;
>  =09void *data;
> =20
>  =09len +=3D NET_SKB_PAD + NET_IP_ALIGN;
> =20
> -=09/* If requested length is either too small or too big,
> -=09 * we use kmalloc() for skb->head allocation.
> -=09 */
> -=09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
> -=09    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> -=09    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> -=09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
> -=09=09if (!skb)
> -=09=09=09goto skb_fail;
> -=09=09goto skb_success;
> -=09}
> -
>  =09nc =3D this_cpu_ptr(&napi_alloc_cache);
>  =09len +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  =09len =3D SKB_DATA_ALIGN(len);
> @@ -530,25 +519,34 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct=
 *napi, unsigned int len,
>  =09if (sk_memalloc_socks())
>  =09=09gfp_mask |=3D __GFP_MEMALLOC;
> =20
> -=09data =3D page_frag_alloc(&nc->page, len, gfp_mask);
> +=09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
> +            len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> +            (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> +=09=09data =3D kmalloc_reserve(len, gfp_mask, NUMA_NO_NODE, &pfmemalloc)=
;
> +=09=09head_frag =3D 0;
> +=09=09len =3D 0;
> +=09} else {
> +=09=09data =3D page_frag_alloc(&nc->page, len, gfp_mask);
> +=09=09pfmemalloc =3D nc->page.pfmemalloc;
> +=09=09head_frag =3D 1;
> +=09}
>  =09if (unlikely(!data))
>  =09=09return NULL;

Sure. I have a separate WIP series that reworks all three *alloc_skb()
functions, as there's a nice room for optimization, especially after
that tiny skbs now fall back to __alloc_skb().
It will likely hit mailing lists after the merge window and next
net-next season, not now. And it's not really connected with NAPI
cache reusing.

>  =09skb =3D __build_skb(data, len);
>  =09if (unlikely(!skb)) {
> -=09=09skb_free_frag(data);
> +=09=09if (head_frag)
> +=09=09=09skb_free_frag(data);
> +=09=09else
> +=09=09=09kfree(data);
>  =09=09return NULL;
>  =09}
> =20
> -=09if (nc->page.pfmemalloc)
> -=09=09skb->pfmemalloc =3D 1;
> -=09skb->head_frag =3D 1;
> +=09skb->pfmemalloc =3D pfmemalloc;
> +=09skb->head_frag =3D head_frag;
> =20
> -skb_success:
>  =09skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
>  =09skb->dev =3D napi->dev;
> -
> -skb_fail:
>  =09return skb;
>  }
>  EXPORT_SYMBOL(__napi_alloc_skb);

Al


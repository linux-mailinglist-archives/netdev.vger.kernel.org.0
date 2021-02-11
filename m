Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384B4318D6E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhBKObw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:31:52 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:29951 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbhBKO3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 09:29:43 -0500
Date:   Thu, 11 Feb 2021 14:28:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613053726; bh=4xocI6Y84o0C8SN+c5+jodbADfHJzOMvCfknyLO1yME=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=foN/WQKGYThrxBEjRjf9HIes+P7Srf/sw2oVoLyinbcnGYesiyY6tGORnRuVCD7nx
         N3PaPd5hG1eekN6EF8k+jGzTYuZaenxmM+a3H/WJV0ojuf6VPdZcc8lz560uLFDh+Z
         rcIbCqBqlL0RzsT0iH080QnjOXBx1unc7YkCXytNXc5SBhpPDs+02+9+FFUrsKKkgL
         qZK26yY1Si/GZ9qmfXJwxfR6KsmrzSGhdAaWbn41+vgPAS/MN/uMGhrN7zExZ5FfLC
         GKlSlzrngjiBPogDmysCzFeNHFjzuuLfb6N3E4EWsFogDpKh8iBRzJwKHYe0QhRBBt
         9i/H0pehl3xfg==
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
Message-ID: <20210211142811.1813-1-alobakin@pm.me>
In-Reply-To: <58147c2d36ea7b6e0284d400229cd79185c53463.camel@redhat.com>
References: <20210210162732.80467-1-alobakin@pm.me> <20210210162732.80467-10-alobakin@pm.me> <58147c2d36ea7b6e0284d400229cd79185c53463.camel@redhat.com>
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
Date: Thu, 11 Feb 2021 11:16:40 +0100

> On Wed, 2021-02-10 at 16:30 +0000, Alexander Lobakin wrote:
> > Reuse the old and forgotten SKB_ALLOC_NAPI to add an option to get
> > an skbuff_head from the NAPI cache instead of inplace allocation
> > inside __alloc_skb().
> > This implies that the function is called from softirq or BH-off
> > context, not for allocating a clone or from a distant node.
> >=20
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/core/skbuff.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 9e1a8ded4acc..750fa1825b28 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -397,15 +397,20 @@ struct sk_buff *__alloc_skb(unsigned int size, gf=
p_t gfp_mask,
> >  =09struct sk_buff *skb;
> >  =09u8 *data;
> >  =09bool pfmemalloc;
> > +=09bool clone;
> > =20
> > -=09cache =3D (flags & SKB_ALLOC_FCLONE)
> > -=09=09? skbuff_fclone_cache : skbuff_head_cache;
> > +=09clone =3D !!(flags & SKB_ALLOC_FCLONE);
> > +=09cache =3D clone ? skbuff_fclone_cache : skbuff_head_cache;
> > =20
> >  =09if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
> >  =09=09gfp_mask |=3D __GFP_MEMALLOC;
> > =20
> >  =09/* Get the HEAD */
> > -=09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
> > +=09if (!clone && (flags & SKB_ALLOC_NAPI) &&
> > +=09    likely(node =3D=3D NUMA_NO_NODE || node =3D=3D numa_mem_id()))
> > +=09=09skb =3D napi_skb_cache_get();
> > +=09else
> > +=09=09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~GFP_DMA, node);
> >  =09if (unlikely(!skb))
> >  =09=09return NULL;
> >  =09prefetchw(skb);
>=20
> I hope the opt-in thing would have allowed leaving this code unchanged.
> I see it's not trivial avoid touching this code path.
> Still I think it would be nice if you would be able to let the device
> driver use the cache without touching the above, which is also used
> e.g. by the TCP xmit path, which in turn will not leverage the cache
> (as it requires FCLONE skbs).
>=20
> If I read correctly, the above chunk is needed to
> allow __napi_alloc_skb() access the cache even for small skb
> allocation.

Not only. I wanted to give an ability to access the new feature
through __alloc_skb() too, not only through napi_build_skb() or
napi_alloc_skb().
And not only for drivers. As you may remember, firstly
napi_consume_skb()'s batching system landed for drivers, but then
it got used in network core code.
I think that some core parts may benefit from reusing the NAPI
caches. We'll only see it later.

It's not as complex as it may seem. NUMA check is cheap and tends
to be true for the vast majority of cases. Check for fclone is
already present in baseline code, even two times through the function.
So it's mostly about (flags & SKB_ALLOC_NAPI).

> Good device drivers should not call alloc_skb() in the fast
> path.

Not really. Several enterprise NIC drivers use __alloc_skb() and
alloc_skb(): ChelsIO and Mellanox for inline TLS, Netronome etc.
Lots of RDMA and wireless drivers (not the legacy ones), too.
__alloc_skb() gives you more control on NUMA node and needed skb
headroom, so it's still sometimes useful in drivers.

> What about changing __napi_alloc_skb() to always use
> the __napi_build_skb(), for both kmalloc and page backed skbs? That is,
> always doing the 'data' allocation in __napi_alloc_skb() - either via
> page_frag or via kmalloc() - and than call __napi_build_skb().
>
> I think that should avoid adding more checks in __alloc_skb() and
> should probably reduce the number of conditional used
> by __napi_alloc_skb().

I thought of this too. But this will introduce conditional branch
to set or not skb->head_frag. So one branch less in __alloc_skb(),
one branch more here, and we also lose the ability to __alloc_skb()
with decached head.

> Thanks!
>=20
> Paolo

Thanks,
Al


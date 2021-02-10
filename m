Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAF03166A3
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBJM2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:28:35 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:50992 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhBJM0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:26:01 -0500
Date:   Wed, 10 Feb 2021 12:25:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612959913; bh=xGF8idln5DY1PO9HkDWrauDAxRsmR5JdyZwu33GXJko=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=WE+Kn8/NJVX3wXyKMbyM7oQj0jtBG7RyeNM3vmbFY/Zg0+u2o8FeMkCpZdPO3BcQN
         3npB/oy2YP58r9knjc2Nwyg7+mWU4zD5uf7lhrAVJvmxsgCqsMH+cDdwRF4wuUjZJe
         lDRc98AVvgzNkrDe4hS+oimi2C9IHNzYjgPINS8HXzkson8hiV8hrq8D+pIoObYStQ
         Zx0pDoBWFe/Thmu4zpB5tPC6LonKO+v9z3kD8O/p3ouc4N3kaHwPGi+njmdftnAgLZ
         Rmb+vBeK9mEVstooxysxbjxMa0cGQbUCDMzKugEiFlg9SLXUYhnFhOZr7PvVFJplpg
         9RjTfXuLTGLgg==
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [v3 net-next 08/10] skbuff: reuse NAPI skb cache on allocation path (__build_skb())
Message-ID: <20210210122414.8064-1-alobakin@pm.me>
In-Reply-To: <b6efe8d3a4ebf8188c040c5401b50b6c11b6eaf9.camel@redhat.com>
References: <20210209204533.327360-1-alobakin@pm.me> <20210209204533.327360-9-alobakin@pm.me> <b6efe8d3a4ebf8188c040c5401b50b6c11b6eaf9.camel@redhat.com>
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
Date: Wed, 10 Feb 2021 11:21:06 +0100

> Hello,

Hi!
=20
> I'm sorry for the late feedback, I could not step-in before.
>=20
> Also adding Jesper for awareness, as he introduced the bulk free
> infrastructure.
>=20
> On Tue, 2021-02-09 at 20:48 +0000, Alexander Lobakin wrote:
> > @@ -231,7 +256,7 @@ struct sk_buff *__build_skb(void *data, unsigned in=
t frag_size)
> >   */
> >  struct sk_buff *build_skb(void *data, unsigned int frag_size)
> >  {
> > -=09struct sk_buff *skb =3D __build_skb(data, frag_size);
> > +=09struct sk_buff *skb =3D __build_skb(data, frag_size, true);
>=20
> I must admit I'm a bit scared of this. There are several high speed
> device drivers that will move to bulk allocation, and we don't have any
> performance figure for them.
>=20
> In my experience with (low end) MIPS board, cache misses cost tend to
> be much less visible there compared to reasonably recent server H/W,
> because the CPU/memory access time difference is much lower.
>=20
> When moving to higher end H/W the performance gain you measured could
> be completely countered by less optimal cache usage.
>=20
> I fear also latency spikes - I'm unsure if a 32 skbs allocation vs a
> single skb would be visible e.g. in a round-robin test. Generally
> speaking bulk allocating 32 skbs looks a bit too much. IIRC, when
> Edward added listification to GRO, he did several measures with
> different list size and found 8 to be the optimal value (for the tested
> workload). Above such number the list become too big and the pressure
> on the cache outweighted the bulking benefits.

I can change to logics the way so it would allocate the first 8.
I think I've already seen this batch value somewhere in XDP code,
so this might be a balanced one.

Regarding bulk-freeing: can the batch size make sense when freeing
or it's okay to wipe 32 (currently 64 in baseline) in a row?

> Perhaps giving the device drivers the ability to opt-in on this infra
> via a new helper - as done back then with napi_consume_skb() - would
> make this change safer?

That's actually a very nice idea. There's only a little in the code
to change to introduce an ability to take heads from the cache
optionally. This way developers could switch to it when needed.

Thanks for the suggestions! I'll definitely absorb them into the code
and give it a test.

> > @@ -838,31 +863,31 @@ void __consume_stateless_skb(struct sk_buff *skb)
> >  =09kfree_skbmem(skb);
> >  }
> >
> > -static inline void _kfree_skb_defer(struct sk_buff *skb)
> > +static void napi_skb_cache_put(struct sk_buff *skb)
> >  {
> >  =09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
> > +=09u32 i;
> >
> >  =09/* drop skb->head and call any destructors for packet */
> >  =09skb_release_all(skb);
> >
> > -=09/* record skb to CPU local list */
> > +=09kasan_poison_object_data(skbuff_head_cache, skb);
> >  =09nc->skb_cache[nc->skb_count++] =3D skb;
> >
> > -#ifdef CONFIG_SLUB
> > -=09/* SLUB writes into objects when freeing */
> > -=09prefetchw(skb);
> > -#endif
>=20
> It looks like this chunk has been lost. Is that intentional?

Yep. This prefetchw() assumed that skbuff_heads will be wiped
immediately or at the end of network softirq. Reusing this cache
means that heads can be reused later or may be kept in a cache for
some time, so prefetching makes no sense anymore.

> Thanks!
>=20
> Paolo

Al


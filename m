Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75C531AC23
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhBMOO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 09:14:27 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:43384 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhBMON0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 09:13:26 -0500
Date:   Sat, 13 Feb 2021 14:12:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613225563; bh=3aXvGlMYhjuYNoMv1QkUBlOKt06EtJNy+kSzarvpakw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=B+oH2yjqSGCqjT4gu1JBuBQ9z3AMFtJCzINmCXl9TOdJyd3sGTxkbCuNRS0aHzaAz
         QoVolhWtkftZEfLL22/dzA5ggAoUpA7NPbEYkq6EPaNf0HPXaC37aWGM6o2zCl7oeO
         voObrpsn99pDwlXFUTRAcJMvFdjZo15IBjqoqRhtQCaEIff1a7Ah50hu9ZMc7dDPpw
         G1emoWviDy2PQs7IkGUOq5n119g8PBqH+zLiLG0srBl8Rt+HyM+B/77P66IHEvBYgH
         Ps82QbhfkbexNWUC04QmsKno1MgSDjNVAdG1n2ZEzbFxa0O1R+5CuZmbMQdQzuR3Gt
         TzW/4Tt8eTrhQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v6 net-next 09/11] skbuff: allow to optionally use NAPI cache from __alloc_skb()
Message-ID: <20210213141021.87840-10-alobakin@pm.me>
In-Reply-To: <20210213141021.87840-1-alobakin@pm.me>
References: <20210213141021.87840-1-alobakin@pm.me>
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

Reuse the old and forgotten SKB_ALLOC_NAPI to add an option to get
an skbuff_head from the NAPI cache instead of inplace allocation
inside __alloc_skb().
This implies that the function is called from softirq or BH-off
context, not for allocating a clone or from a distant node.

Cc: Alexander Duyck <alexander.duyck@gmail.com> # Simplified flags check
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9e1a8ded4acc..a80581eed7fc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -405,7 +405,11 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t g=
fp_mask,
 =09=09gfp_mask |=3D __GFP_MEMALLOC;
=20
 =09/* Get the HEAD */
-=09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
+=09if ((flags & (SKB_ALLOC_FCLONE | SKB_ALLOC_NAPI)) =3D=3D SKB_ALLOC_NAPI=
 &&
+=09    likely(node =3D=3D NUMA_NO_NODE || node =3D=3D numa_mem_id()))
+=09=09skb =3D napi_skb_cache_get();
+=09else
+=09=09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~GFP_DMA, node);
 =09if (unlikely(!skb))
 =09=09return NULL;
 =09prefetchw(skb);
--=20
2.30.1



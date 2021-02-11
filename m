Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB991319299
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 19:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhBKSzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 13:55:51 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:42451 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhBKSyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 13:54:31 -0500
Date:   Thu, 11 Feb 2021 18:53:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613069629; bh=vHu/tYcVI950QN5Rrw2gSn3oUyiXAKr/E1pyrHPMHnU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=OcEKXvc9lB8MZ7pLpGYPZww1FfVTPZ9/MNWqTIsjPziumYZg3wMt5NpN/dGqCm66S
         7JO8uX4vfg42nNGSI4/QicWPVC7jt1ztwi+ZrAG5FGazf+LOPNnHinkkgukPwM68Gc
         QS+jhR1W5act17EiDGsfoWTiYsPE/o1ij9kfoxxkuHYPLINrgcpfuZ82XXGbVdVjgr
         FE4yUYVGVAoULOLIFflu2lEs/bXN1mXi6OG3++6+4fZBrKxz/tqGj/R2f6dRGCA5U6
         QCSsiELAPjC7KzQy3J0PcADTHXs7IQ1ZFaJhbwJeI44Q/yrnJmg+LFwRBoPpEMM5L3
         hxx4+l8QAOzYA==
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
Subject: [PATCH v5 net-next 04/11] skbuff: simplify __alloc_skb() a bit
Message-ID: <20210211185220.9753-5-alobakin@pm.me>
In-Reply-To: <20210211185220.9753-1-alobakin@pm.me>
References: <20210211185220.9753-1-alobakin@pm.me>
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

Use unlikely() annotations for skbuff_head and data similarly to the
two other allocation functions and remove totally redundant goto.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c7d184e11547..88566de26cd1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -339,8 +339,8 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gf=
p_mask,
=20
 =09/* Get the HEAD */
 =09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
-=09if (!skb)
-=09=09goto out;
+=09if (unlikely(!skb))
+=09=09return NULL;
 =09prefetchw(skb);
=20
 =09/* We do our best to align skb_shared_info on a separate cache
@@ -351,7 +351,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gf=
p_mask,
 =09size =3D SKB_DATA_ALIGN(size);
 =09size +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 =09data =3D kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
-=09if (!data)
+=09if (unlikely(!data))
 =09=09goto nodata;
 =09/* kmalloc(size) might give us more room than requested.
 =09 * Put skb_shared_info exactly at the end of allocated zone,
@@ -395,12 +395,11 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t =
gfp_mask,
=20
 =09skb_set_kcov_handle(skb, kcov_common_handle());
=20
-out:
 =09return skb;
+
 nodata:
 =09kmem_cache_free(cache, skb);
-=09skb =3D NULL;
-=09goto out;
+=09return NULL;
 }
 EXPORT_SYMBOL(__alloc_skb);
=20
--=20
2.30.1



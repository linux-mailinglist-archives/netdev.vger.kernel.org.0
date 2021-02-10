Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59777316B4A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhBJQbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:31:46 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:20594 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbhBJQae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:30:34 -0500
Date:   Wed, 10 Feb 2021 16:29:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612974568; bh=vHu/tYcVI950QN5Rrw2gSn3oUyiXAKr/E1pyrHPMHnU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=X2mB14Zre1cBumX33fMkvOTJrgIUhnlZlMNHlZEncYmFJReS5ErVDr0Bp9B0D3mGO
         7H+gj7Gpe1uh3P+QB8yv5oSLYY2z4oW3xM2BdrpOxRZ5uyZ1S+PiG5dWknocuaqhqJ
         lUr0uH2xWyo0z8AiHzONnplhpbtJAm0CHHgSimMq+jYz8eFsskMee/B9+HebJe/qYM
         ArD4Z1m7p06IOoQOeEgSgmzerc9pVnwQjakxYyL7sMkrCvE0sW5cNiS8hhc+g2juD3
         3p5cU5hh/AoLLWVWAQJn1ae4ciutBOzwdM4DW2p6ao6UylqERj9GDe9G4KCbenhagN
         TfaNWejyoMgPA==
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
Subject: [PATCH v4 net-next 04/11] skbuff: simplify __alloc_skb() a bit
Message-ID: <20210210162732.80467-5-alobakin@pm.me>
In-Reply-To: <20210210162732.80467-1-alobakin@pm.me>
References: <20210210162732.80467-1-alobakin@pm.me>
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



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B492C316B51
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhBJQc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:32:56 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:20594 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbhBJQbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:31:18 -0500
Date:   Wed, 10 Feb 2021 16:30:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612974648; bh=1ZV3MU5hm/yFjfHuP1nAedRaPlzwJRc6+iABOHDpkjs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Fk22STlnmZbcQinLN0RWEHztMBRSvRCr/YY2hJLvMmnQ4yCcvnjQ7wS2eZLpZ0ZFO
         Okk/5rqp8eQxwIFo3kZC9+A0KKOOX3ElintYQHYAE94L2TXSwrVpxtyMCPqa3p4rqr
         JKrpzR6McJfP3snSHtOYJ96D6vhvwKR8O8TUVZsNnte/sjWNfldORZcrCxUoz8SBt1
         XZheXN+ccIZCuqyf5iUO78V1AlET3KntLwNr5/QwjG6j4Z4T+AiJmQiGqn72pBNQBL
         rIpzSGNILOprRhNMnmue4lbg804eu3MHeM8sc0D9ZtGFYI/vFNf21PUBAB7+QHzpRK
         RqIaJoVFdMGSg==
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
Subject: [PATCH v4 net-next 09/11] skbuff: allow to optionally use NAPI cache from __alloc_skb()
Message-ID: <20210210162732.80467-10-alobakin@pm.me>
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

Reuse the old and forgotten SKB_ALLOC_NAPI to add an option to get
an skbuff_head from the NAPI cache instead of inplace allocation
inside __alloc_skb().
This implies that the function is called from softirq or BH-off
context, not for allocating a clone or from a distant node.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9e1a8ded4acc..750fa1825b28 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -397,15 +397,20 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t =
gfp_mask,
 =09struct sk_buff *skb;
 =09u8 *data;
 =09bool pfmemalloc;
+=09bool clone;
=20
-=09cache =3D (flags & SKB_ALLOC_FCLONE)
-=09=09? skbuff_fclone_cache : skbuff_head_cache;
+=09clone =3D !!(flags & SKB_ALLOC_FCLONE);
+=09cache =3D clone ? skbuff_fclone_cache : skbuff_head_cache;
=20
 =09if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
 =09=09gfp_mask |=3D __GFP_MEMALLOC;
=20
 =09/* Get the HEAD */
-=09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
+=09if (!clone && (flags & SKB_ALLOC_NAPI) &&
+=09    likely(node =3D=3D NUMA_NO_NODE || node =3D=3D numa_mem_id()))
+=09=09skb =3D napi_skb_cache_get();
+=09else
+=09=09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~GFP_DMA, node);
 =09if (unlikely(!skb))
 =09=09return NULL;
 =09prefetchw(skb);
@@ -436,7 +441,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gf=
p_mask,
 =09__build_skb_around(skb, data, 0);
 =09skb->pfmemalloc =3D pfmemalloc;
=20
-=09if (flags & SKB_ALLOC_FCLONE) {
+=09if (clone) {
 =09=09struct sk_buff_fclones *fclones;
=20
 =09=09fclones =3D container_of(skb, struct sk_buff_fclones, skb1);
--=20
2.30.1



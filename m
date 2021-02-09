Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DB431583E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhBIVC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:02:56 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:56060 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbhBIUuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:50:05 -0500
Date:   Tue, 09 Feb 2021 20:49:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612903762; bh=CJXPkGdmY5RiFBPMnrBdmPj6J9CQqoGZFly0kXKbtyw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=LBBLa5jHOXunOIAbx1jOTy6WCs9mzG8gehuj6+j9+Ssi6RHGUbkSBOywMviBEwCQu
         lda9a7LCxOO7zb5vCmPtWdQZgRedj4QRYcs0q7fq1MpyHfK2kbnNc2y3/wKF+gP0SN
         0mOUjWozbuoWUmtEYhXVKu+iqba5NkBBowwTil2osat0R/LaHA6hQHZ9AbSQtnLa5Z
         wulmrHPn2qAn8TKsxIwF4jcuwmiwnMJinduz+ihs8vbj4VH02CdFsEaWNf7ejHVprp
         rzzYXuB3ZA0scy0lRt0M08SlYRNW1MM2XPkdJV0RTCt9F5fQCXSe8A4/kgvOLWWpNn
         rXq8yG7HImKTw==
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [v3 net-next 09/10] skbuff: reuse NAPI skb cache on allocation path (__alloc_skb())
Message-ID: <20210209204533.327360-10-alobakin@pm.me>
In-Reply-To: <20210209204533.327360-1-alobakin@pm.me>
References: <20210209204533.327360-1-alobakin@pm.me>
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

Try to use the same technique for obtaining skbuff_head from NAPI
cache in {,__}alloc_skb(). Two points here:
 - __alloc_skb() can be used for allocating clones or allocating skbs
   for distant nodes. Try to grab head from the cache only for
   non-clones and for local nodes;
 - can be called from any context, so napi_safe =3D=3D false.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8747566a8136..8850086f8605 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -354,15 +354,19 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t =
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
+=09if (clone || unlikely(node !=3D NUMA_NO_NODE && node !=3D numa_mem_id()=
))
+=09=09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~GFP_DMA, node);
+=09else
+=09=09skb =3D napi_skb_cache_get(false);
 =09if (unlikely(!skb))
 =09=09return NULL;
 =09prefetchw(skb);
@@ -393,7 +397,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gf=
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
2.30.0



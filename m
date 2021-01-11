Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A812F1E0C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390545AbhAKSaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:30:12 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:23265 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390530AbhAKSaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:30:12 -0500
Date:   Mon, 11 Jan 2021 18:29:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610389769; bh=zIOKkbaTUZEnQc1ND01YiT6/uvlP61oysJn+nnvfaLw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=XHMFEB4eGdt6GGKVfUxQkAFPCfAP/Ync4+3YHTB5iNOmp52136/LyuTJL4aHcLZEf
         +L8zKUPLopwF0Xx4VP5OyW9X5M557N7D/QhqzGdNOFCksnHd7Mf8K8lc0Sv6OK3t3u
         Dgy/mTOsXLiQrtKh82kPoudz4tKIVtfVNDy0714alvvKSTXEh4qCSu+im5OJagS+ZR
         6GH724zqXQS2J09KHS3dPdv7/Z+Y8dFHSn2Tr860zUbn1NGqb3Frw+fnvXc6+v23Bg
         Zc3QKJMToB4fu5h8hKvFhQ3CQ5TSoBo5qq4asMcwyXCrZ/E8Zl3CjBh3Cxt4E4ylK+
         Lx43tCLUNh3PA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 4/5] skbuff: allocate skbuff_heads by bulks instead of one by one
Message-ID: <20210111182801.12609-4-alobakin@pm.me>
In-Reply-To: <20210111182801.12609-1-alobakin@pm.me>
References: <20210111182655.12159-1-alobakin@pm.me> <20210111182801.12609-1-alobakin@pm.me>
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

Use the same napi_alloc_cache struct and the same approach as used
for bulk-freeing skbuff_heads to allocate them for new skbs.
The new skb_cache will store up to NAPI_SKB_CACHE_SIZE (currently
64, which equals to NAPI_POLL_WEIGHT to be capable to serve one
polling cycle) and will be refilled by bulks in case of full
depletion or after completing network softirqs.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0e8c597ff6ce..57a7307689f3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -367,6 +367,8 @@ EXPORT_SYMBOL(build_skb_around);
=20
 struct napi_alloc_cache {
 =09struct page_frag_cache=09page;
+=09u32=09=09=09skb_count;
+=09void=09=09=09*skb_cache[NAPI_SKB_CACHE_SIZE];
 =09u32=09=09=09flush_skb_count;
 =09void=09=09=09*flush_skb_cache[NAPI_SKB_CACHE_SIZE];
 };
@@ -490,7 +492,15 @@ static struct sk_buff *__napi_decache_skb(struct napi_=
alloc_cache *nc)
 =09if (nc->flush_skb_count)
 =09=09return nc->flush_skb_cache[--nc->flush_skb_count];
=20
-=09return kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+=09if (unlikely(!nc->skb_count))
+=09=09nc->skb_count =3D kmem_cache_alloc_bulk(skbuff_head_cache,
+=09=09=09=09=09=09      GFP_ATOMIC,
+=09=09=09=09=09=09      NAPI_SKB_CACHE_SIZE,
+=09=09=09=09=09=09      nc->skb_cache);
+=09if (unlikely(!nc->skb_count))
+=09=09return NULL;
+
+=09return nc->skb_cache[--nc->skb_count];
 }
=20
 /**
@@ -870,6 +880,7 @@ void __consume_stateless_skb(struct sk_buff *skb)
 void __kfree_skb_flush(void)
 {
 =09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
+=09u32 num;
=20
 =09/* flush flush_skb_cache if containing objects */
 =09if (nc->flush_skb_count) {
@@ -877,6 +888,13 @@ void __kfree_skb_flush(void)
 =09=09=09=09     nc->flush_skb_cache);
 =09=09nc->flush_skb_count =3D 0;
 =09}
+
+=09num =3D NAPI_SKB_CACHE_SIZE - nc->skb_count;
+=09if (num)
+=09=09nc->skb_count +=3D kmem_cache_alloc_bulk(skbuff_head_cache,
+=09=09=09=09=09=09       GFP_ATOMIC, num,
+=09=09=09=09=09=09       nc->skb_cache +
+=09=09=09=09=09=09       nc->skb_count);
 }
=20
 static inline void _kfree_skb_defer(struct sk_buff *skb)
--=20
2.30.0



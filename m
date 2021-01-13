Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04902F4C52
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbhAMNh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:37:59 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:53707 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbhAMNh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 08:37:59 -0500
Date:   Wed, 13 Jan 2021 13:37:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610545035; bh=UfgI6Rrb/SGM19pvZtc2Put5d76631YVvNFcRByKDyk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=FiJR8qIkTMbWnEjOFEEyCr3hSq5mmGIMsWdSKxVPbhuY6DMnAzbJ0WLY2iGqAmyw9
         VpaKgK0nqCdeHjAChrRwnwyT5v6d3k7R3BSqW7C/e4cnFG014lmD/ojlXkZ81LrtuA
         U+TNew4ZPlrG5nfmjGxkkQkX7zWdIAnBpGpm5w2kDNXxhYCMdMqV2o2SE+nIie7dQ8
         o7mZNjFT21k7MtSl2d3MK9MpgfWvrgIe2b0oiaFlyHfpq1U94WU0+vVW5g4arpCBrj
         QwlImqVhqBh1XO2i+qxgb7cIbOfOIwfFCThRXQ2C7v54AKqa0VfU5MehPSJERJDCka
         HSo4B0ExigOqQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
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
Subject: [PATCH v2 net-next 2/3] skbuff: (re)use NAPI skb cache on allocation path
Message-ID: <20210113133635.39402-2-alobakin@pm.me>
In-Reply-To: <20210113133635.39402-1-alobakin@pm.me>
References: <20210113133523.39205-1-alobakin@pm.me> <20210113133635.39402-1-alobakin@pm.me>
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

Instead of calling kmem_cache_alloc() every time when building a NAPI
skb, (re)use skbuff_heads from napi_alloc_cache.skb_cache. Previously
this cache was only used for bulk-freeing skbuff_heads consumed via
napi_consume_skb() or __kfree_skb_defer().

Typical path is:
 - skb is queued for freeing from driver or stack, its skbuff_head
   goes into the cache instead of immediate freeing;
 - driver or stack requests NAPI skb allocation, an skbuff_head is
   taken from the cache instead of allocation.

Corner cases:
 - if it's empty on skb allocation, bulk-allocate the first half;
 - if it's full on skb consuming, bulk-wipe the second half.

Also try to balance its size after completing network softirqs
(__kfree_skb_flush()).

prefetchw() on CONFIG_SLUB is dropped since it makes no sense anymore.

Suggested-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 54 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index dc3300dc2ac4..f42a3a04b918 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -364,6 +364,7 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
 EXPORT_SYMBOL(build_skb_around);
=20
 #define NAPI_SKB_CACHE_SIZE=0964
+#define NAPI_SKB_CACHE_HALF=09(NAPI_SKB_CACHE_SIZE / 2)
=20
 struct napi_alloc_cache {
 =09struct page_frag_cache page;
@@ -487,7 +488,15 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
=20
 static struct sk_buff *napi_skb_cache_get(struct napi_alloc_cache *nc)
 {
-=09return kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+=09if (unlikely(!nc->skb_count))
+=09=09nc->skb_count =3D kmem_cache_alloc_bulk(skbuff_head_cache,
+=09=09=09=09=09=09      GFP_ATOMIC,
+=09=09=09=09=09=09      NAPI_SKB_CACHE_HALF,
+=09=09=09=09=09=09      nc->skb_cache);
+=09if (unlikely(!nc->skb_count))
+=09=09return NULL;
+
+=09return nc->skb_cache[--nc->skb_count];
 }
=20
 /**
@@ -867,40 +876,47 @@ void __consume_stateless_skb(struct sk_buff *skb)
 void __kfree_skb_flush(void)
 {
 =09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
+=09size_t count;
+=09void **ptr;
+
+=09if (unlikely(nc->skb_count =3D=3D NAPI_SKB_CACHE_HALF))
+=09=09return;
+
+=09if (nc->skb_count > NAPI_SKB_CACHE_HALF) {
+=09=09count =3D nc->skb_count - NAPI_SKB_CACHE_HALF;
+=09=09ptr =3D nc->skb_cache + NAPI_SKB_CACHE_HALF;
=20
-=09/* flush skb_cache if containing objects */
-=09if (nc->skb_count) {
-=09=09kmem_cache_free_bulk(skbuff_head_cache, nc->skb_count,
-=09=09=09=09     nc->skb_cache);
-=09=09nc->skb_count =3D 0;
+=09=09kmem_cache_free_bulk(skbuff_head_cache, count, ptr);
+=09=09nc->skb_count =3D NAPI_SKB_CACHE_HALF;
+=09} else {
+=09=09count =3D NAPI_SKB_CACHE_HALF - nc->skb_count;
+=09=09ptr =3D nc->skb_cache + nc->skb_count;
+
+=09=09nc->skb_count +=3D kmem_cache_alloc_bulk(skbuff_head_cache,
+=09=09=09=09=09=09       GFP_ATOMIC, count,
+=09=09=09=09=09=09       ptr);
 =09}
 }
=20
-static inline void _kfree_skb_defer(struct sk_buff *skb)
+static void napi_skb_cache_put(struct sk_buff *skb)
 {
 =09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
=20
 =09/* drop skb->head and call any destructors for packet */
 =09skb_release_all(skb);
=20
-=09/* record skb to CPU local list */
 =09nc->skb_cache[nc->skb_count++] =3D skb;
=20
-#ifdef CONFIG_SLUB
-=09/* SLUB writes into objects when freeing */
-=09prefetchw(skb);
-#endif
-
-=09/* flush skb_cache if it is filled */
 =09if (unlikely(nc->skb_count =3D=3D NAPI_SKB_CACHE_SIZE)) {
-=09=09kmem_cache_free_bulk(skbuff_head_cache, NAPI_SKB_CACHE_SIZE,
-=09=09=09=09     nc->skb_cache);
-=09=09nc->skb_count =3D 0;
+=09=09kmem_cache_free_bulk(skbuff_head_cache, NAPI_SKB_CACHE_HALF,
+=09=09=09=09     nc->skb_cache + NAPI_SKB_CACHE_HALF);
+=09=09nc->skb_count =3D NAPI_SKB_CACHE_HALF;
 =09}
 }
+
 void __kfree_skb_defer(struct sk_buff *skb)
 {
-=09_kfree_skb_defer(skb);
+=09napi_skb_cache_put(skb);
 }
=20
 void napi_consume_skb(struct sk_buff *skb, int budget)
@@ -925,7 +941,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 =09=09return;
 =09}
=20
-=09_kfree_skb_defer(skb);
+=09napi_skb_cache_put(skb);
 }
 EXPORT_SYMBOL(napi_consume_skb);
=20
--=20
2.30.0



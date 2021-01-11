Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0B32F1DFF
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390397AbhAKS3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:29:09 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:46450 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389074AbhAKS3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:29:09 -0500
X-Greylist: delayed 22704 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2021 13:29:08 EST
Date:   Mon, 11 Jan 2021 18:28:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610389706; bh=gXXU1styr81EC3F2Bwbxq+s5c4Q77ESXBToxUwsCrQs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=RGkKbnVP8ThOFM7803+38qDOY3bT36OdUxsDpI0RmrxKBowzL+X+fiZ4rBoS7dhL8
         mBVt/UmLpRuEWsHnfofnzXQc99P33fa+1PzRr8LmmMA16Q+H11RfCY/T6jf+z6SFw8
         BtT79uC4U2tXtY01x8GPv3Qk5ItKb3p9AEECxUumKMB+o5rvFF1wjEe2pppSbmLwrS
         B08FYcU7Uk0uBciwT5Qx7N943xzLW2vx4suxQ5ZNElFZtO2ebZVR0CdVRwpy1Gm5tn
         dvexlp53KIKtkso+1kjdGTh3PSkNjCFhyBvgtjx9Ipvy0y+c7QJu+Rkkq40E5Imm/f
         AGGzlloiDMUaw==
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
Subject: [PATCH net-next 1/5] skbuff: rename fields of struct napi_alloc_cache to be more intuitive
Message-ID: <20210111182801.12609-1-alobakin@pm.me>
In-Reply-To: <20210111182655.12159-1-alobakin@pm.me>
References: <20210111182655.12159-1-alobakin@pm.me>
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

skb_cache and skb_count fields are used to store skbuff_heads queued
for freeing to flush them by bulks, and aren't related to allocation
path. Give them more obvious names to improve code understanding and
allow to expand this struct with more allocation-related elements.

Misc: indent struct napi_alloc_cache declaration for better reading.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7626a33cce59..17ae5e90f103 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -366,9 +366,9 @@ EXPORT_SYMBOL(build_skb_around);
 #define NAPI_SKB_CACHE_SIZE=0964
=20
 struct napi_alloc_cache {
-=09struct page_frag_cache page;
-=09unsigned int skb_count;
-=09void *skb_cache[NAPI_SKB_CACHE_SIZE];
+=09struct page_frag_cache=09page;
+=09u32=09=09=09flush_skb_count;
+=09void=09=09=09*flush_skb_cache[NAPI_SKB_CACHE_SIZE];
 };
=20
 static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
@@ -860,11 +860,11 @@ void __kfree_skb_flush(void)
 {
 =09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
=20
-=09/* flush skb_cache if containing objects */
-=09if (nc->skb_count) {
-=09=09kmem_cache_free_bulk(skbuff_head_cache, nc->skb_count,
-=09=09=09=09     nc->skb_cache);
-=09=09nc->skb_count =3D 0;
+=09/* flush flush_skb_cache if containing objects */
+=09if (nc->flush_skb_count) {
+=09=09kmem_cache_free_bulk(skbuff_head_cache, nc->flush_skb_count,
+=09=09=09=09     nc->flush_skb_cache);
+=09=09nc->flush_skb_count =3D 0;
 =09}
 }
=20
@@ -876,18 +876,18 @@ static inline void _kfree_skb_defer(struct sk_buff *s=
kb)
 =09skb_release_all(skb);
=20
 =09/* record skb to CPU local list */
-=09nc->skb_cache[nc->skb_count++] =3D skb;
+=09nc->flush_skb_cache[nc->flush_skb_count++] =3D skb;
=20
 #ifdef CONFIG_SLUB
 =09/* SLUB writes into objects when freeing */
 =09prefetchw(skb);
 #endif
=20
-=09/* flush skb_cache if it is filled */
-=09if (unlikely(nc->skb_count =3D=3D NAPI_SKB_CACHE_SIZE)) {
+=09/* flush flush_skb_cache if it is filled */
+=09if (unlikely(nc->flush_skb_count =3D=3D NAPI_SKB_CACHE_SIZE)) {
 =09=09kmem_cache_free_bulk(skbuff_head_cache, NAPI_SKB_CACHE_SIZE,
-=09=09=09=09     nc->skb_cache);
-=09=09nc->skb_count =3D 0;
+=09=09=09=09     nc->flush_skb_cache);
+=09=09nc->flush_skb_count =3D 0;
 =09}
 }
 void __kfree_skb_defer(struct sk_buff *skb)
--=20
2.30.0



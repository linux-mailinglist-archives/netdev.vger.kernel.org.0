Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF1A2F4C54
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbhAMNiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:38:15 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:17434 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbhAMNiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 08:38:15 -0500
Date:   Wed, 13 Jan 2021 13:37:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610545052; bh=q+0EE369dr2h9X/gAhh7q0i4CdC3yGGoUz33tMS3zRg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=JjOso4hKWYW+3zksOpVBtrjglv3v/DlT8/WAyovGt1tf1EJjVeijNX1S/CfhBuD/e
         OJDuZqLkG/A7KLlO6ow4Y5t7c0Mwi9F6xTiXNIb+NdQ5+VnF5OnUfLOMNmB59HASx3
         lPoBCyuexpmXAgFCBSiYWHGv7KgZfXML0y1V0+GYw0GsLJYW4fGc8zuRFwCualGcjE
         f57n8B9UApeLSxcPtRPTukeI4hk8w4D9Ij3zvAywLUALGvt4Z5jXYfDNwohYX6IjxT
         2Rn+3JomIlO+vT//HHaI7z6ilgZCLSh6vKmViO6AKP19vHjclnyJmLIPit+nqi73gN
         O8oJBJccyVaqQ==
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
Subject: [PATCH v2 net-next 3/3] skbuff: recycle GRO_MERGED_FREE skbs into NAPI skb cache
Message-ID: <20210113133635.39402-3-alobakin@pm.me>
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

Instead of immediate freeing, recycle GRO_MERGED_FREE skbs into
NAPI skb cache. This is safe, because napi_gro_receive() and
napi_gro_frags() are called only inside NAPI softirq context.
As many drivers call napi_alloc_skb()/napi_get_frags() on their
receive path, this becomes especially useful.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/skbuff.h |  1 +
 net/core/dev.c         |  9 +--------
 net/core/skbuff.c      | 12 +++++++++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7a057b1f1eb8..507f1598e446 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2888,6 +2888,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget=
);
=20
 void __kfree_skb_flush(void);
 void __kfree_skb_defer(struct sk_buff *skb);
+void napi_skb_free_stolen_head(struct sk_buff *skb);
=20
 /**
  * __dev_alloc_pages - allocate page for network Rx
diff --git a/net/core/dev.c b/net/core/dev.c
index e4d77c8abe76..c28f0d601378 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6054,13 +6054,6 @@ struct packet_offload *gro_find_complete_by_type(__b=
e16 type)
 }
 EXPORT_SYMBOL(gro_find_complete_by_type);
=20
-static void napi_skb_free_stolen_head(struct sk_buff *skb)
-{
-=09skb_dst_drop(skb);
-=09skb_ext_put(skb);
-=09kmem_cache_free(skbuff_head_cache, skb);
-}
-
 static gro_result_t napi_skb_finish(struct napi_struct *napi,
 =09=09=09=09    struct sk_buff *skb,
 =09=09=09=09    gro_result_t ret)
@@ -6074,7 +6067,7 @@ static gro_result_t napi_skb_finish(struct napi_struc=
t *napi,
 =09=09if (NAPI_GRO_CB(skb)->free =3D=3D NAPI_GRO_FREE_STOLEN_HEAD)
 =09=09=09napi_skb_free_stolen_head(skb);
 =09=09else
-=09=09=09__kfree_skb(skb);
+=09=09=09__kfree_skb_defer(skb);
 =09=09break;
=20
 =09case GRO_HELD:
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f42a3a04b918..bf6f92f1f4c7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -902,9 +902,6 @@ static void napi_skb_cache_put(struct sk_buff *skb)
 {
 =09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
=20
-=09/* drop skb->head and call any destructors for packet */
-=09skb_release_all(skb);
-
 =09nc->skb_cache[nc->skb_count++] =3D skb;
=20
 =09if (unlikely(nc->skb_count =3D=3D NAPI_SKB_CACHE_SIZE)) {
@@ -916,6 +913,14 @@ static void napi_skb_cache_put(struct sk_buff *skb)
=20
 void __kfree_skb_defer(struct sk_buff *skb)
 {
+=09skb_release_all(skb);
+=09napi_skb_cache_put(skb);
+}
+
+void napi_skb_free_stolen_head(struct sk_buff *skb)
+{
+=09skb_dst_drop(skb);
+=09skb_ext_put(skb);
 =09napi_skb_cache_put(skb);
 }
=20
@@ -941,6 +946,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 =09=09return;
 =09}
=20
+=09skb_release_all(skb);
 =09napi_skb_cache_put(skb);
 }
 EXPORT_SYMBOL(napi_consume_skb);
--=20
2.30.0



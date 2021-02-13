Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386D331AC28
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBMOPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 09:15:22 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:46364 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhBMOOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 09:14:00 -0500
Date:   Sat, 13 Feb 2021 14:13:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613225597; bh=wLqNe1V/JXPVogyy1vgzidOihnW8r5KVyZjTCq70nMY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=e/xy0IYCa1GYe0sA5hMJ1cIMChs2ZV8qdGnhUodNMK2Yvrx5SQwHTzx5JDfR+399v
         Jq1MP9s4AeygOC1EMVYQXv2o4Y7QQPbJ5A0M/DU0OEOf9KwWtMW5fV/o12tkUZ8Y+1
         QTOMw6B62RJQTfopedmxA7mgLJH6KG9tGOzO2Q1bvcymKtTeVL6+Mr/u4FgzTwv3FR
         5cs1hBkgBl30cVzPKd/d0AwwODoOmDWGePOwxLwHqEfzLIBCDvTZp9USLM0dV1vs2+
         QrxjlwubMQfwqp6PKPxSzMzCVlMqno/DQmzzqMV3EIuKuOfF8pF39O0wTCchgDRJcj
         g4OYhfbszjJyQ==
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
Subject: [PATCH v6 net-next 11/11] skbuff: queue NAPI_MERGED_FREE skbs into NAPI cache instead of freeing
Message-ID: <20210213141021.87840-12-alobakin@pm.me>
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

napi_frags_finish() and napi_skb_finish() can only be called inside
NAPI Rx context, so we can feed NAPI cache with skbuff_heads that
got NAPI_MERGED_FREE verdict instead of immediate freeing.
Replace __kfree_skb() with __kfree_skb_defer() in napi_skb_finish()
and move napi_skb_free_stolen_head() to skbuff.c, so it can drop skbs
to NAPI cache.
As many drivers call napi_alloc_skb()/napi_get_frags() on their
receive path, this becomes especially useful.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/skbuff.h |  1 +
 net/core/dev.c         |  9 +--------
 net/core/skbuff.c      | 12 +++++++++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 906122eac82a..6d0a33d1c0db 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2921,6 +2921,7 @@ static inline struct sk_buff *napi_alloc_skb(struct n=
api_struct *napi,
 }
 void napi_consume_skb(struct sk_buff *skb, int budget);
=20
+void napi_skb_free_stolen_head(struct sk_buff *skb);
 void __kfree_skb_defer(struct sk_buff *skb);
=20
 /**
diff --git a/net/core/dev.c b/net/core/dev.c
index 631807c196ad..ea9b46318d23 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6095,13 +6095,6 @@ struct packet_offload *gro_find_complete_by_type(__b=
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
@@ -6115,7 +6108,7 @@ static gro_result_t napi_skb_finish(struct napi_struc=
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
index 875e1a453f7e..545a472273a5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -916,9 +916,6 @@ static void napi_skb_cache_put(struct sk_buff *skb)
 =09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
 =09u32 i;
=20
-=09/* drop skb->head and call any destructors for packet */
-=09skb_release_all(skb);
-
 =09kasan_poison_object_data(skbuff_head_cache, skb);
 =09nc->skb_cache[nc->skb_count++] =3D skb;
=20
@@ -935,6 +932,14 @@ static void napi_skb_cache_put(struct sk_buff *skb)
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
@@ -960,6 +965,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 =09=09return;
 =09}
=20
+=09skb_release_all(skb);
 =09napi_skb_cache_put(skb);
 }
 EXPORT_SYMBOL(napi_consume_skb);
--=20
2.30.1



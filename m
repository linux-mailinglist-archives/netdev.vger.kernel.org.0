Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9373431AC21
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhBMOOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 09:14:03 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:35485 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhBMONM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 09:13:12 -0500
Date:   Sat, 13 Feb 2021 14:12:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613225548; bh=OJItbnlO9/miYI8tp2rCg3ReZOArter9GMDQWwcIoz0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=hEoWGl6LPNuVQjvF48w6Z7gcQWWHww5AeUVD9C1rVqMwcHJvrba7pjouo2Yc0Kxha
         4NYfCP4X8n6HBKo8vCTZghGeQlJG2bxWOTA1biPfb6T//XrMduSJCQ+cTM89JHjQAq
         FmVzOABo6KyLTVfW8ONAT2nXHtuV+KgJdClEhQ6hX8vYMcY/kMyOy28N6o/s2p2jx5
         n2VrMulcf3IXSs6Q4+cgf+y4x1NvX2St6Sf+9XS21WWCX+FGV7/tt/1knqUblDLZ9s
         tHwyseYp/obAFYiCIwSN9auE9Kgswq40KCO0EyylKW95SCOhu9stDlV0vEMAnwTOkl
         RaAPKNLeeYXwA==
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
Subject: [PATCH v6 net-next 08/11] skbuff: introduce {,__}napi_build_skb() which reuses NAPI cache heads
Message-ID: <20210213141021.87840-9-alobakin@pm.me>
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

Instead of just bulk-flushing skbuff_heads queued up through
napi_consume_skb() or __kfree_skb_defer(), try to reuse them
on allocation path.
If the cache is empty on allocation, bulk-allocate the first
16 elements, which is more efficient than per-skb allocation.
If the cache is full on freeing, bulk-wipe the second half of
the cache (32 elements).
This also includes custom KASAN poisoning/unpoisoning to be
double sure there are no use-after-free cases.

To not change current behaviour, introduce a new function,
napi_build_skb(), to optionally use a new approach later
in drivers.

Note on selected bulk size, 16:
 - this equals to XDP_BULK_QUEUE_SIZE, DEV_MAP_BULK_SIZE
   and especially VETH_XDP_BATCH, which is also used to
   bulk-allocate skbuff_heads and was tested on powerful
   setups;
 - this also showed the best performance in the actual
   test series (from the array of {8, 16, 32}).

Suggested-by: Edward Cree <ecree.xilinx@gmail.com> # Divide on two halves
Suggested-by: Eric Dumazet <edumazet@google.com>   # KASAN poisoning
Cc: Dmitry Vyukov <dvyukov@google.com>             # Help with KASAN
Cc: Paolo Abeni <pabeni@redhat.com>                # Reduced batch size
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/skbuff.h |  2 +
 net/core/skbuff.c      | 94 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 83 insertions(+), 13 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0e0707296098..906122eac82a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1087,6 +1087,8 @@ struct sk_buff *build_skb(void *data, unsigned int fr=
ag_size);
 struct sk_buff *build_skb_around(struct sk_buff *skb,
 =09=09=09=09 void *data, unsigned int frag_size);
=20
+struct sk_buff *napi_build_skb(void *data, unsigned int frag_size);
+
 /**
  * alloc_skb - allocate a network buffer
  * @size: size to allocate
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 860a9d4f752f..9e1a8ded4acc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -120,6 +120,8 @@ static void skb_under_panic(struct sk_buff *skb, unsign=
ed int sz, void *addr)
 }
=20
 #define NAPI_SKB_CACHE_SIZE=0964
+#define NAPI_SKB_CACHE_BULK=0916
+#define NAPI_SKB_CACHE_HALF=09(NAPI_SKB_CACHE_SIZE / 2)
=20
 struct napi_alloc_cache {
 =09struct page_frag_cache page;
@@ -164,6 +166,25 @@ void *__netdev_alloc_frag_align(unsigned int fragsz, u=
nsigned int align_mask)
 }
 EXPORT_SYMBOL(__netdev_alloc_frag_align);
=20
+static struct sk_buff *napi_skb_cache_get(void)
+{
+=09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
+=09struct sk_buff *skb;
+
+=09if (unlikely(!nc->skb_count))
+=09=09nc->skb_count =3D kmem_cache_alloc_bulk(skbuff_head_cache,
+=09=09=09=09=09=09      GFP_ATOMIC,
+=09=09=09=09=09=09      NAPI_SKB_CACHE_BULK,
+=09=09=09=09=09=09      nc->skb_cache);
+=09if (unlikely(!nc->skb_count))
+=09=09return NULL;
+
+=09skb =3D nc->skb_cache[--nc->skb_count];
+=09kasan_unpoison_object_data(skbuff_head_cache, skb);
+
+=09return skb;
+}
+
 /* Caller must provide SKB that is memset cleared */
 static void __build_skb_around(struct sk_buff *skb, void *data,
 =09=09=09       unsigned int frag_size)
@@ -265,6 +286,53 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(build_skb_around);
=20
+/**
+ * __napi_build_skb - build a network buffer
+ * @data: data buffer provided by caller
+ * @frag_size: size of data, or 0 if head was kmalloced
+ *
+ * Version of __build_skb() that uses NAPI percpu caches to obtain
+ * skbuff_head instead of inplace allocation.
+ *
+ * Returns a new &sk_buff on success, %NULL on allocation failure.
+ */
+static struct sk_buff *__napi_build_skb(void *data, unsigned int frag_size=
)
+{
+=09struct sk_buff *skb;
+
+=09skb =3D napi_skb_cache_get();
+=09if (unlikely(!skb))
+=09=09return NULL;
+
+=09memset(skb, 0, offsetof(struct sk_buff, tail));
+=09__build_skb_around(skb, data, frag_size);
+
+=09return skb;
+}
+
+/**
+ * napi_build_skb - build a network buffer
+ * @data: data buffer provided by caller
+ * @frag_size: size of data, or 0 if head was kmalloced
+ *
+ * Version of __napi_build_skb() that takes care of skb->head_frag
+ * and skb->pfmemalloc when the data is a page or page fragment.
+ *
+ * Returns a new &sk_buff on success, %NULL on allocation failure.
+ */
+struct sk_buff *napi_build_skb(void *data, unsigned int frag_size)
+{
+=09struct sk_buff *skb =3D __napi_build_skb(data, frag_size);
+
+=09if (likely(skb) && frag_size) {
+=09=09skb->head_frag =3D 1;
+=09=09skb_propagate_pfmemalloc(virt_to_head_page(data), skb);
+=09}
+
+=09return skb;
+}
+EXPORT_SYMBOL(napi_build_skb);
+
 /*
  * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tell=
s
  * the caller if emergency pfmemalloc reserves are being used. If it is an=
d
@@ -838,31 +906,31 @@ void __consume_stateless_skb(struct sk_buff *skb)
 =09kfree_skbmem(skb);
 }
=20
-static inline void _kfree_skb_defer(struct sk_buff *skb)
+static void napi_skb_cache_put(struct sk_buff *skb)
 {
 =09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
+=09u32 i;
=20
 =09/* drop skb->head and call any destructors for packet */
 =09skb_release_all(skb);
=20
-=09/* record skb to CPU local list */
+=09kasan_poison_object_data(skbuff_head_cache, skb);
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
+=09=09for (i =3D NAPI_SKB_CACHE_HALF; i < NAPI_SKB_CACHE_SIZE; i++)
+=09=09=09kasan_unpoison_object_data(skbuff_head_cache,
+=09=09=09=09=09=09   nc->skb_cache[i]);
+
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
@@ -887,7 +955,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 =09=09return;
 =09}
=20
-=09_kfree_skb_defer(skb);
+=09napi_skb_cache_put(skb);
 }
 EXPORT_SYMBOL(napi_consume_skb);
=20
--=20
2.30.1



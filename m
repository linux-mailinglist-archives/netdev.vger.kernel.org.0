Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2066D31585D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhBIVMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:12:55 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:27345 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbhBIUty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:49:54 -0500
Date:   Tue, 09 Feb 2021 20:48:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612903738; bh=RvDCm6tIZoYg2bGWqrbsgh3uj/6504ovRb8wDmucExM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=KZV8LP67Z+l2Rd6WCrkmG/LpyISpqpz9CBxVx+vlfl3gPh+hnzmwKncxPno1p5KX9
         13eVWCXg1Rt9eB+DAmaTHPhqAZHDSbGr2a+N0ms97bfKzSD40mKmKEIQxZDtaqBrlp
         +VeD4OfaDfuubIfFX/YJhZLbCpWzgPwKiwGklk+ugtp4csH/vXrb2KA0aqoiBDR6mT
         92anaNSurAKxC+nJ54suOcF27lK1xlzq7EfDXvlTVkKvnCdm/5quTt+f6fH6XUbPIk
         hC4bPnIemYpktuVDeGjOLh6kjU+UcHqJAqgAQJVPywNomnkB2jhrVfGsBmlrI16pzb
         vTyide4+xG5GA==
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [v3 net-next 08/10] skbuff: reuse NAPI skb cache on allocation path (__build_skb())
Message-ID: <20210209204533.327360-9-alobakin@pm.me>
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

Instead of just bulk-flushing skbuff_heads queued up through
napi_consume_skb() or __kfree_skb_defer(), try to reuse them
on allocation path.
If the cache is empty on allocation, bulk-allocate the first
half, which is more efficient than per-skb allocation.
If the cache is full on freeing, bulk-wipe the second half.
This also includes custom KASAN poisoning/unpoisoning to be
double sure there are no use-after-free cases.

Functions that got cache fastpath:
 - {,__}build_skb();
 - {,__}netdev_alloc_skb();
 - {,__}napi_alloc_skb().

Note on "napi_safe" argument:
NAPI cache should be accessed only from BH-disabled or (better)
NAPI context. To make sure access is safe, in_serving_softirq()
check is used.
Hovewer, there are plenty of cases when we know for sure that
we're in such context. This includes: build_skb() (called only
from NIC drivers in NAPI Rx context) and {,__}napi_alloc_skb()
(called from the same place or from kernel network softirq
functions).
We can use that knowledge to avoid unnecessary checks.

Suggested-by: Edward Cree <ecree.xilinx@gmail.com> # Unified cache part
Suggested-by: Eric Dumazet <edumazet@google.com>   # KASAN poisoning
Suggested-by: Dmitry Vyukov <dvyukov@google.com>   # Help with KASAN
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/skbuff.h   |  2 +-
 net/core/skbuff.c        | 61 ++++++++++++++++++++++++++++------------
 net/netlink/af_netlink.c |  2 +-
 3 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0e0707296098..5bb443d37bf4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1082,7 +1082,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_b=
uff *from,
=20
 struct sk_buff *__alloc_skb(unsigned int size, gfp_t priority, int flags,
 =09=09=09    int node);
-struct sk_buff *__build_skb(void *data, unsigned int frag_size);
+struct sk_buff *__build_skb(void *data, unsigned int frag_size, bool napi_=
safe);
 struct sk_buff *build_skb(void *data, unsigned int frag_size);
 struct sk_buff *build_skb_around(struct sk_buff *skb,
 =09=09=09=09 void *data, unsigned int frag_size);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 860a9d4f752f..8747566a8136 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -120,6 +120,7 @@ static void skb_under_panic(struct sk_buff *skb, unsign=
ed int sz, void *addr)
 }
=20
 #define NAPI_SKB_CACHE_SIZE=0964
+#define NAPI_SKB_CACHE_HALF=09(NAPI_SKB_CACHE_SIZE / 2)
=20
 struct napi_alloc_cache {
 =09struct page_frag_cache page;
@@ -164,6 +165,30 @@ void *__netdev_alloc_frag_align(unsigned int fragsz, u=
nsigned int align_mask)
 }
 EXPORT_SYMBOL(__netdev_alloc_frag_align);
=20
+static struct sk_buff *napi_skb_cache_get(bool napi_safe)
+{
+=09struct napi_alloc_cache *nc;
+=09struct sk_buff *skb;
+
+=09if (!napi_safe && unlikely(!in_serving_softirq()))
+=09=09return kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+
+=09nc =3D this_cpu_ptr(&napi_alloc_cache);
+
+=09if (unlikely(!nc->skb_count))
+=09=09nc->skb_count =3D kmem_cache_alloc_bulk(skbuff_head_cache,
+=09=09=09=09=09=09      GFP_ATOMIC,
+=09=09=09=09=09=09      NAPI_SKB_CACHE_HALF,
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
@@ -210,11 +235,11 @@ static void __build_skb_around(struct sk_buff *skb, v=
oid *data,
  *  before giving packet to stack.
  *  RX rings only contains data buffers, not full skbs.
  */
-struct sk_buff *__build_skb(void *data, unsigned int frag_size)
+struct sk_buff *__build_skb(void *data, unsigned int frag_size, bool napi_=
safe)
 {
 =09struct sk_buff *skb;
=20
-=09skb =3D kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+=09skb =3D napi_skb_cache_get(napi_safe);
 =09if (unlikely(!skb))
 =09=09return NULL;
=20
@@ -231,7 +256,7 @@ struct sk_buff *__build_skb(void *data, unsigned int fr=
ag_size)
  */
 struct sk_buff *build_skb(void *data, unsigned int frag_size)
 {
-=09struct sk_buff *skb =3D __build_skb(data, frag_size);
+=09struct sk_buff *skb =3D __build_skb(data, frag_size, true);
=20
 =09if (skb && frag_size) {
 =09=09skb->head_frag =3D 1;
@@ -443,7 +468,7 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *d=
ev, unsigned int len,
 =09if (unlikely(!data))
 =09=09return NULL;
=20
-=09skb =3D __build_skb(data, len);
+=09skb =3D __build_skb(data, len, false);
 =09if (unlikely(!skb)) {
 =09=09skb_free_frag(data);
 =09=09return NULL;
@@ -507,7 +532,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *na=
pi, unsigned int len,
 =09if (unlikely(!data))
 =09=09return NULL;
=20
-=09skb =3D __build_skb(data, len);
+=09skb =3D __build_skb(data, len, true);
 =09if (unlikely(!skb)) {
 =09=09skb_free_frag(data);
 =09=09return NULL;
@@ -838,31 +863,31 @@ void __consume_stateless_skb(struct sk_buff *skb)
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
@@ -887,7 +912,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 =09=09return;
 =09}
=20
-=09_kfree_skb_defer(skb);
+=09napi_skb_cache_put(skb);
 }
 EXPORT_SYMBOL(napi_consume_skb);
=20
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index dd488938447f..afba4e11a526 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1190,7 +1190,7 @@ static struct sk_buff *netlink_alloc_large_skb(unsign=
ed int size,
 =09if (data =3D=3D NULL)
 =09=09return NULL;
=20
-=09skb =3D __build_skb(data, size);
+=09skb =3D __build_skb(data, size, false);
 =09if (skb =3D=3D NULL)
 =09=09vfree(data);
 =09else
--=20
2.30.0



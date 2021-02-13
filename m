Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BA431AC10
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBMOL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 09:11:58 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:10891 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhBMOLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 09:11:54 -0500
Date:   Sat, 13 Feb 2021 14:11:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613225464; bh=vxbPqVTP+yyafvrJZY9PHRZqLx4yQzye7I3rd2J7vYA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=GjMoIRUAJ6UcGZKXG4IiQPpf0iR8IBnchx1eS1foms5C6tEdbjOZ1oXrzlBFPemXd
         y9GBwZotQMazJe8RL9qZXktNKkqpmRG1PpSFGoIunOLi5GODbUna7sRsx61LMHndi2
         4k79kXEIKQMECKCP92ExcyPUuK8vnsmX3AAEXHxNnQHNblPt3/9qLxzMBvApKBAt1z
         ub36wR5Ac7VBn9N1ztI3WgocBKIqLI2H5AjeXFwEa0P83Wm+VVow1tge03RGSbJ6kG
         ewD69agRU2a69KCoscUopyIm9FATDcaxDbmMZAETJ3MF4IF/kLLYGQLqkNHsG0AMIA
         MRhAX2cqRAw9w==
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
Subject: [PATCH v6 net-next 01/11] skbuff: move __alloc_skb() next to the other skb allocation functions
Message-ID: <20210213141021.87840-2-alobakin@pm.me>
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

In preparation before reusing several functions in all three skb
allocation variants, move __alloc_skb() next to the
__netdev_alloc_skb() and __napi_alloc_skb().
No functional changes.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 284 +++++++++++++++++++++++-----------------------
 1 file changed, 142 insertions(+), 142 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d380c7b5a12d..a0f846872d19 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -119,148 +119,6 @@ static void skb_under_panic(struct sk_buff *skb, unsi=
gned int sz, void *addr)
 =09skb_panic(skb, sz, addr, __func__);
 }
=20
-/*
- * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tell=
s
- * the caller if emergency pfmemalloc reserves are being used. If it is an=
d
- * the socket is later found to be SOCK_MEMALLOC then PFMEMALLOC reserves
- * may be used. Otherwise, the packet data may be discarded until enough
- * memory is free
- */
-#define kmalloc_reserve(size, gfp, node, pfmemalloc) \
-=09 __kmalloc_reserve(size, gfp, node, _RET_IP_, pfmemalloc)
-
-static void *__kmalloc_reserve(size_t size, gfp_t flags, int node,
-=09=09=09       unsigned long ip, bool *pfmemalloc)
-{
-=09void *obj;
-=09bool ret_pfmemalloc =3D false;
-
-=09/*
-=09 * Try a regular allocation, when that fails and we're not entitled
-=09 * to the reserves, fail.
-=09 */
-=09obj =3D kmalloc_node_track_caller(size,
-=09=09=09=09=09flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
-=09=09=09=09=09node);
-=09if (obj || !(gfp_pfmemalloc_allowed(flags)))
-=09=09goto out;
-
-=09/* Try again but now we are using pfmemalloc reserves */
-=09ret_pfmemalloc =3D true;
-=09obj =3D kmalloc_node_track_caller(size, flags, node);
-
-out:
-=09if (pfmemalloc)
-=09=09*pfmemalloc =3D ret_pfmemalloc;
-
-=09return obj;
-}
-
-/* =09Allocate a new skbuff. We do this ourselves so we can fill in a few
- *=09'private' fields and also do memory statistics to find all the
- *=09[BEEP] leaks.
- *
- */
-
-/**
- *=09__alloc_skb=09-=09allocate a network buffer
- *=09@size: size to allocate
- *=09@gfp_mask: allocation mask
- *=09@flags: If SKB_ALLOC_FCLONE is set, allocate from fclone cache
- *=09=09instead of head cache and allocate a cloned (child) skb.
- *=09=09If SKB_ALLOC_RX is set, __GFP_MEMALLOC will be used for
- *=09=09allocations in case the data is required for writeback
- *=09@node: numa node to allocate memory on
- *
- *=09Allocate a new &sk_buff. The returned buffer has no headroom and a
- *=09tail room of at least size bytes. The object has a reference count
- *=09of one. The return is the buffer. On a failure the return is %NULL.
- *
- *=09Buffers may only be allocated from interrupts using a @gfp_mask of
- *=09%GFP_ATOMIC.
- */
-struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
-=09=09=09    int flags, int node)
-{
-=09struct kmem_cache *cache;
-=09struct skb_shared_info *shinfo;
-=09struct sk_buff *skb;
-=09u8 *data;
-=09bool pfmemalloc;
-
-=09cache =3D (flags & SKB_ALLOC_FCLONE)
-=09=09? skbuff_fclone_cache : skbuff_head_cache;
-
-=09if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
-=09=09gfp_mask |=3D __GFP_MEMALLOC;
-
-=09/* Get the HEAD */
-=09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
-=09if (!skb)
-=09=09goto out;
-=09prefetchw(skb);
-
-=09/* We do our best to align skb_shared_info on a separate cache
-=09 * line. It usually works because kmalloc(X > SMP_CACHE_BYTES) gives
-=09 * aligned memory blocks, unless SLUB/SLAB debug is enabled.
-=09 * Both skb->head and skb_shared_info are cache line aligned.
-=09 */
-=09size =3D SKB_DATA_ALIGN(size);
-=09size +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-=09data =3D kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
-=09if (!data)
-=09=09goto nodata;
-=09/* kmalloc(size) might give us more room than requested.
-=09 * Put skb_shared_info exactly at the end of allocated zone,
-=09 * to allow max possible filling before reallocation.
-=09 */
-=09size =3D SKB_WITH_OVERHEAD(ksize(data));
-=09prefetchw(data + size);
-
-=09/*
-=09 * Only clear those fields we need to clear, not those that we will
-=09 * actually initialise below. Hence, don't put any more fields after
-=09 * the tail pointer in struct sk_buff!
-=09 */
-=09memset(skb, 0, offsetof(struct sk_buff, tail));
-=09/* Account for allocated memory : skb + skb->head */
-=09skb->truesize =3D SKB_TRUESIZE(size);
-=09skb->pfmemalloc =3D pfmemalloc;
-=09refcount_set(&skb->users, 1);
-=09skb->head =3D data;
-=09skb->data =3D data;
-=09skb_reset_tail_pointer(skb);
-=09skb->end =3D skb->tail + size;
-=09skb->mac_header =3D (typeof(skb->mac_header))~0U;
-=09skb->transport_header =3D (typeof(skb->transport_header))~0U;
-
-=09/* make sure we initialize shinfo sequentially */
-=09shinfo =3D skb_shinfo(skb);
-=09memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
-=09atomic_set(&shinfo->dataref, 1);
-
-=09if (flags & SKB_ALLOC_FCLONE) {
-=09=09struct sk_buff_fclones *fclones;
-
-=09=09fclones =3D container_of(skb, struct sk_buff_fclones, skb1);
-
-=09=09skb->fclone =3D SKB_FCLONE_ORIG;
-=09=09refcount_set(&fclones->fclone_ref, 1);
-
-=09=09fclones->skb2.fclone =3D SKB_FCLONE_CLONE;
-=09}
-
-=09skb_set_kcov_handle(skb, kcov_common_handle());
-
-out:
-=09return skb;
-nodata:
-=09kmem_cache_free(cache, skb);
-=09skb =3D NULL;
-=09goto out;
-}
-EXPORT_SYMBOL(__alloc_skb);
-
 /* Caller must provide SKB that is memset cleared */
 static struct sk_buff *__build_skb_around(struct sk_buff *skb,
 =09=09=09=09=09  void *data, unsigned int frag_size)
@@ -408,6 +266,148 @@ void *__netdev_alloc_frag_align(unsigned int fragsz, =
unsigned int align_mask)
 }
 EXPORT_SYMBOL(__netdev_alloc_frag_align);
=20
+/*
+ * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tell=
s
+ * the caller if emergency pfmemalloc reserves are being used. If it is an=
d
+ * the socket is later found to be SOCK_MEMALLOC then PFMEMALLOC reserves
+ * may be used. Otherwise, the packet data may be discarded until enough
+ * memory is free
+ */
+#define kmalloc_reserve(size, gfp, node, pfmemalloc) \
+=09 __kmalloc_reserve(size, gfp, node, _RET_IP_, pfmemalloc)
+
+static void *__kmalloc_reserve(size_t size, gfp_t flags, int node,
+=09=09=09       unsigned long ip, bool *pfmemalloc)
+{
+=09void *obj;
+=09bool ret_pfmemalloc =3D false;
+
+=09/*
+=09 * Try a regular allocation, when that fails and we're not entitled
+=09 * to the reserves, fail.
+=09 */
+=09obj =3D kmalloc_node_track_caller(size,
+=09=09=09=09=09flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
+=09=09=09=09=09node);
+=09if (obj || !(gfp_pfmemalloc_allowed(flags)))
+=09=09goto out;
+
+=09/* Try again but now we are using pfmemalloc reserves */
+=09ret_pfmemalloc =3D true;
+=09obj =3D kmalloc_node_track_caller(size, flags, node);
+
+out:
+=09if (pfmemalloc)
+=09=09*pfmemalloc =3D ret_pfmemalloc;
+
+=09return obj;
+}
+
+/* =09Allocate a new skbuff. We do this ourselves so we can fill in a few
+ *=09'private' fields and also do memory statistics to find all the
+ *=09[BEEP] leaks.
+ *
+ */
+
+/**
+ *=09__alloc_skb=09-=09allocate a network buffer
+ *=09@size: size to allocate
+ *=09@gfp_mask: allocation mask
+ *=09@flags: If SKB_ALLOC_FCLONE is set, allocate from fclone cache
+ *=09=09instead of head cache and allocate a cloned (child) skb.
+ *=09=09If SKB_ALLOC_RX is set, __GFP_MEMALLOC will be used for
+ *=09=09allocations in case the data is required for writeback
+ *=09@node: numa node to allocate memory on
+ *
+ *=09Allocate a new &sk_buff. The returned buffer has no headroom and a
+ *=09tail room of at least size bytes. The object has a reference count
+ *=09of one. The return is the buffer. On a failure the return is %NULL.
+ *
+ *=09Buffers may only be allocated from interrupts using a @gfp_mask of
+ *=09%GFP_ATOMIC.
+ */
+struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
+=09=09=09    int flags, int node)
+{
+=09struct kmem_cache *cache;
+=09struct skb_shared_info *shinfo;
+=09struct sk_buff *skb;
+=09u8 *data;
+=09bool pfmemalloc;
+
+=09cache =3D (flags & SKB_ALLOC_FCLONE)
+=09=09? skbuff_fclone_cache : skbuff_head_cache;
+
+=09if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
+=09=09gfp_mask |=3D __GFP_MEMALLOC;
+
+=09/* Get the HEAD */
+=09skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
+=09if (!skb)
+=09=09goto out;
+=09prefetchw(skb);
+
+=09/* We do our best to align skb_shared_info on a separate cache
+=09 * line. It usually works because kmalloc(X > SMP_CACHE_BYTES) gives
+=09 * aligned memory blocks, unless SLUB/SLAB debug is enabled.
+=09 * Both skb->head and skb_shared_info are cache line aligned.
+=09 */
+=09size =3D SKB_DATA_ALIGN(size);
+=09size +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+=09data =3D kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
+=09if (!data)
+=09=09goto nodata;
+=09/* kmalloc(size) might give us more room than requested.
+=09 * Put skb_shared_info exactly at the end of allocated zone,
+=09 * to allow max possible filling before reallocation.
+=09 */
+=09size =3D SKB_WITH_OVERHEAD(ksize(data));
+=09prefetchw(data + size);
+
+=09/*
+=09 * Only clear those fields we need to clear, not those that we will
+=09 * actually initialise below. Hence, don't put any more fields after
+=09 * the tail pointer in struct sk_buff!
+=09 */
+=09memset(skb, 0, offsetof(struct sk_buff, tail));
+=09/* Account for allocated memory : skb + skb->head */
+=09skb->truesize =3D SKB_TRUESIZE(size);
+=09skb->pfmemalloc =3D pfmemalloc;
+=09refcount_set(&skb->users, 1);
+=09skb->head =3D data;
+=09skb->data =3D data;
+=09skb_reset_tail_pointer(skb);
+=09skb->end =3D skb->tail + size;
+=09skb->mac_header =3D (typeof(skb->mac_header))~0U;
+=09skb->transport_header =3D (typeof(skb->transport_header))~0U;
+
+=09/* make sure we initialize shinfo sequentially */
+=09shinfo =3D skb_shinfo(skb);
+=09memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
+=09atomic_set(&shinfo->dataref, 1);
+
+=09if (flags & SKB_ALLOC_FCLONE) {
+=09=09struct sk_buff_fclones *fclones;
+
+=09=09fclones =3D container_of(skb, struct sk_buff_fclones, skb1);
+
+=09=09skb->fclone =3D SKB_FCLONE_ORIG;
+=09=09refcount_set(&fclones->fclone_ref, 1);
+
+=09=09fclones->skb2.fclone =3D SKB_FCLONE_CLONE;
+=09}
+
+=09skb_set_kcov_handle(skb, kcov_common_handle());
+
+out:
+=09return skb;
+nodata:
+=09kmem_cache_free(cache, skb);
+=09skb =3D NULL;
+=09goto out;
+}
+EXPORT_SYMBOL(__alloc_skb);
+
 /**
  *=09__netdev_alloc_skb - allocate an skbuff for rx on a specific device
  *=09@dev: network device to receive on
--=20
2.30.1



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA96697500
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjBODov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBODou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:44:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92986311E0
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 19:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A833619B9
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 03:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E755C433D2;
        Wed, 15 Feb 2023 03:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676432688;
        bh=NF3yznBIC7kSNQ/9iwEjj2Wpq+tCyf4LxSnygbSE1W4=;
        h=From:To:Cc:Subject:Date:From;
        b=KDEZxsacFXZ0cW+HgCJUlOLf8uNBME0FclKCnwt7NnwFKcrev+1Q5sQQRW2pI4v4s
         d1EcUOqCEf/SBXw0ET5UApFFEY/c0jKal6Xy10L/Lr9+HI6bwuHOSkLV4lTjcJq9JD
         7+PLQAs8Pb1BYO45Hc5boUKhomHaj9pWsYYP0BuMFlEme28Gm1aGTAr7FlsGtFb92y
         nr+xBQW8wK9t/Mvr+9pu5+ZZyE8hYE0xvfc70Y/4fyNKwZP/ATRSzzK1tZ8wbKPoEF
         Ya3uhKgigCx5fLxWN12T7JJxxommqV4S9U6Lx1niEHE89VbDIKtA0rJxblC8ovAsen
         kHIstMQ8GZ6tA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com, fw@strlen.de, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC] net: skbuff: let struct skb_ext live inside the head
Date:   Tue, 14 Feb 2023 19:44:44 -0800
Message-Id: <20230215034444.482178-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a bit more crazy than the previous patch. For drivers
which already use build_skb() it's relatively easy to add more
space to the shinfo. Use this approach to place skb_ext inside
the head. No allocation needed.

This approach is a bit slower in trivial benchmarks than the recycling
because it requires extra cache line accesses (12.1% loss, ->18.6Gbps).

In-place skb_ext may be shorter than a full skb_ext object.
The driver only reserves space for exts it may use.
Any later addition will reallocate the space via CoW,
abandoning the in-place skb_ext and copying the data to
a full slab object.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h |  29 +++++++-
 net/core/gro.c         |   1 +
 net/core/skbuff.c      | 156 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 178 insertions(+), 8 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e68cb0a777b9..86486b667c94 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1257,6 +1257,8 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
 				 void *data, unsigned int frag_size);
 void skb_attempt_defer_free(struct sk_buff *skb);
 
+struct sk_buff *napi_build_skb_ext(void *data, unsigned int frag_size,
+				   unsigned int ext_size);
 struct sk_buff *napi_build_skb(void *data, unsigned int frag_size);
 struct sk_buff *slab_build_skb(void *data);
 
@@ -4601,6 +4603,16 @@ enum skb_ext_id {
 	SKB_EXT_NUM, /* must be last */
 };
 
+enum skb_ext_ref {
+	/* Normal skb ext from the kmem_cache */
+	SKB_EXT_ALLOC_SLAB,
+	/* Shard is a read-only skb ext placed after shinfo in the head,
+	 * shards may be shorter than full skb_ext length!
+	 */
+	SKB_EXT_ALLOC_SHARD_NOREF,
+	SKB_EXT_ALLOC_SHARD_REF,
+};
+
 /**
  *	struct skb_ext - sk_buff extensions
  *	@refcnt: 1 on allocation, deallocated on 0
@@ -4613,6 +4625,7 @@ enum skb_ext_id {
  */
 struct skb_ext {
 	refcount_t refcnt;
+	u8 alloc_type;
 	u8 offset[SKB_EXT_NUM]; /* in chunks of 8 bytes */
 	u8 chunks;		/* same */
 	char data[] __aligned(8);
@@ -4623,8 +4636,10 @@ void *__skb_ext_set(struct sk_buff *skb, enum skb_ext_id id,
 		    struct skb_ext *ext);
 void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id);
 void *napi_skb_ext_add(struct sk_buff *skb, enum skb_ext_id id);
+void *skb_ext_add_inplace(struct sk_buff *skb, enum skb_ext_id id);
 void __skb_ext_del(struct sk_buff *skb, enum skb_ext_id id);
 void __skb_ext_put(struct skb_ext *ext);
+void __skb_ext_copy_get(struct skb_ext *ext);
 
 static inline void skb_ext_put(struct sk_buff *skb)
 {
@@ -4640,7 +4655,7 @@ static inline void __skb_ext_copy(struct sk_buff *dst,
 	if (src->active_extensions) {
 		struct skb_ext *ext = src->extensions;
 
-		refcount_inc(&ext->refcnt);
+		__skb_ext_copy_get(ext);
 		dst->extensions = ext;
 	}
 }
@@ -4699,6 +4714,18 @@ static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *s) {}
 static inline bool skb_has_extensions(struct sk_buff *skb) { return false; }
 #endif /* CONFIG_SKB_EXTENSIONS */
 
+/* Head got merged into another skb, skb itself will be freed later by
+ * kfree_skb_partial() or napi_skb_free_stolen_head().
+ */
+static inline void skb_head_stolen(struct sk_buff *skb)
+{
+#ifdef CONFIG_SKB_EXTENSIONS
+	if (unlikely(skb->active_extensions) &&
+	    skb->extensions->alloc_type == SKB_EXT_ALLOC_SHARD_NOREF)
+		skb->active_extensions = 0;
+#endif
+}
+
 static inline void nf_reset_ct(struct sk_buff *skb)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
diff --git a/net/core/gro.c b/net/core/gro.c
index a606705a0859..f1e091fa0d4c 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -250,6 +250,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 		delta_truesize = skb->truesize - new_truesize;
 		skb->truesize = new_truesize;
 		NAPI_GRO_CB(skb)->free = NAPI_GRO_FREE_STOLEN_HEAD;
+		skb_head_stolen(skb);
 		goto done;
 	}
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index feb5034b13ad..19e16d7533ac 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -128,6 +128,8 @@ const char * const drop_reasons[] = {
 };
 EXPORT_SYMBOL(drop_reasons);
 
+static int skb_ext_evacuate_head(struct sk_buff *skb);
+
 /**
  *	skb_panic - private function for out-of-line support
  *	@skb:	buffer
@@ -502,6 +504,35 @@ struct sk_buff *napi_build_skb(void *data, unsigned int frag_size)
 }
 EXPORT_SYMBOL(napi_build_skb);
 
+/**
+ * napi_build_skb_ext - build a network buffer with in-place skb_ext
+ * @data: data buffer provided by caller
+ * @frag_size: size of data
+ * @ext_size: size of space to reserve for skb_ext
+ *
+ * Version of napi_build_skb() that reserves space in the head for
+ * struct skb_ext. If @ext_size is zero or skb_ext_add_inplace()
+ * is never called there should be no performance loss compared
+ * to napi_build_skb().
+ *
+ * Returns a new &sk_buff on success, %NULL on allocation failure.
+ */
+struct sk_buff *
+napi_build_skb_ext(void *data, unsigned int frag_size, unsigned int ext_size)
+{
+	struct sk_buff *skb;
+
+	skb = __napi_build_skb(data, frag_size - ext_size);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb->head_frag = 1;
+	skb_propagate_pfmemalloc(virt_to_head_page(data), skb);
+
+	return skb;
+}
+EXPORT_SYMBOL(napi_build_skb_ext);
+
 /*
  * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tells
  * the caller if emergency pfmemalloc reserves are being used. If it is and
@@ -1257,7 +1288,9 @@ static void napi_skb_ext_put(struct sk_buff *skb)
 	if (!skb_ext_needs_destruct(ext)) {
 		struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 
-		if (refcount_read(&ext->refcnt) == 1 && !nc->ext) {
+		if (refcount_read(&ext->refcnt) == 1 &&
+		    ext->alloc_type == SKB_EXT_ALLOC_SLAB &&
+		    !nc->ext) {
 			kasan_poison_object_data(skbuff_ext_cache, ext);
 			nc->ext = ext;
 			return;
@@ -2028,6 +2061,9 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
+	if (skb_ext_evacuate_head(skb))
+		return -ENOMEM;
+
 	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
@@ -5666,6 +5702,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 
 		skb_fill_page_desc(to, to_shinfo->nr_frags,
 				   page, offset, skb_headlen(from));
+		skb_head_stolen(from);
 		*fragstolen = true;
 	} else {
 		if (to_shinfo->nr_frags +
@@ -6389,6 +6426,9 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
+	if (skb_ext_evacuate_head(skb))
+		return -ENOMEM;
+
 	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
@@ -6505,6 +6545,9 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
+	if (skb_ext_evacuate_head(skb))
+		return -ENOMEM;
+
 	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
@@ -6639,10 +6682,11 @@ static void *skb_ext_get_ptr(struct skb_ext *ext, enum skb_ext_id id)
 	return (void *)ext + (ext->offset[id] * SKB_EXT_ALIGN_VALUE);
 }
 
-static void skb_ext_init(struct skb_ext *new)
+static void skb_ext_init_slab(struct skb_ext *new)
 {
 	memset(new->offset, 0, sizeof(new->offset));
 	refcount_set(&new->refcnt, 1);
+	new->alloc_type = SKB_EXT_ALLOC_SLAB;
 }
 
 /**
@@ -6659,7 +6703,7 @@ struct skb_ext *__skb_ext_alloc(gfp_t flags)
 	struct skb_ext *new = kmem_cache_alloc(skbuff_ext_cache, flags);
 
 	if (new)
-		skb_ext_init(new);
+		skb_ext_init_slab(new);
 
 	return new;
 }
@@ -6669,7 +6713,8 @@ static struct skb_ext *skb_ext_maybe_cow(struct skb_ext *old,
 {
 	struct skb_ext *new;
 
-	if (refcount_read(&old->refcnt) == 1)
+	if (refcount_read(&old->refcnt) == 1 &&
+	    old->alloc_type == SKB_EXT_ALLOC_SLAB)
 		return old;
 
 	new = kmem_cache_alloc(skbuff_ext_cache, GFP_ATOMIC);
@@ -6678,6 +6723,7 @@ static struct skb_ext *skb_ext_maybe_cow(struct skb_ext *old,
 
 	memcpy(new, old, old->chunks * SKB_EXT_ALIGN_VALUE);
 	refcount_set(&new->refcnt, 1);
+	new->alloc_type = SKB_EXT_ALLOC_SLAB;
 
 #ifdef CONFIG_XFRM
 	if (old_active & (1 << SKB_EXT_SEC_PATH)) {
@@ -6793,13 +6839,41 @@ void *napi_skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
 				return NULL;
 		}
 
-		skb_ext_init(new);
+		skb_ext_init_slab(new);
 	}
 
 	return skb_ext_add_finalize(skb, id, new);
 }
 EXPORT_SYMBOL(napi_skb_ext_add);
 
+/**
+ * skb_ext_add_inplace - allocate ext space in napi_build_skb_ext() skb
+ * @skb: buffer
+ * @id: extension to allocate space for
+ *
+ * Creates an extension in a private skb allocated with napi_build_skb_ext().
+ * The caller must have allocated the @skb and must guarantee that there
+ * will be enough space for all the extensions.
+ *
+ * Returns pointer to the extension or NULL on failure.
+ */
+void *skb_ext_add_inplace(struct sk_buff *skb, enum skb_ext_id id)
+{
+	struct skb_ext *new = NULL;
+
+	if (!skb->active_extensions) {
+		new = (void *)&skb_shinfo(skb)[1];
+		skb->extensions = new;
+
+		memset(new->offset, 0, sizeof(new->offset));
+		refcount_set(&new->refcnt, 1);
+		new->alloc_type = SKB_EXT_ALLOC_SHARD_NOREF;
+	}
+
+	return skb_ext_add_finalize(skb, id, new);
+}
+EXPORT_SYMBOL(skb_ext_add_inplace);
+
 #ifdef CONFIG_XFRM
 static void skb_ext_put_sp(struct sec_path *sp)
 {
@@ -6846,8 +6920,11 @@ void __skb_ext_put(struct skb_ext *ext)
 	if (refcount_read(&ext->refcnt) == 1)
 		goto free_now;
 
-	if (!refcount_dec_and_test(&ext->refcnt))
+	if (!refcount_dec_and_test(&ext->refcnt)) {
+		if (ext->alloc_type == SKB_EXT_ALLOC_SHARD_REF)
+			goto free_shard;
 		return;
+	}
 free_now:
 #ifdef CONFIG_XFRM
 	if (__skb_ext_exist(ext, SKB_EXT_SEC_PATH))
@@ -6858,9 +6935,74 @@ void __skb_ext_put(struct skb_ext *ext)
 		skb_ext_put_mctp(skb_ext_get_ptr(ext, SKB_EXT_MCTP));
 #endif
 
-	kmem_cache_free(skbuff_ext_cache, ext);
+	switch (ext->alloc_type) {
+	case SKB_EXT_ALLOC_SLAB:
+		kmem_cache_free(skbuff_ext_cache, ext);
+		break;
+	case SKB_EXT_ALLOC_SHARD_NOREF:
+		break;
+	case SKB_EXT_ALLOC_SHARD_REF:
+free_shard:
+		skb_free_frag(ext);
+		break;
+	}
 }
 EXPORT_SYMBOL(__skb_ext_put);
+
+/* Only safe to use as part of a copy operation */
+void __skb_ext_copy_get(struct skb_ext *ext)
+{
+	struct page *head_page;
+	unsigned int type;
+	int old;
+
+	__refcount_inc(&ext->refcnt, &old);
+
+	type = READ_ONCE(ext->alloc_type);
+	if (type == SKB_EXT_ALLOC_SLAB)
+		return;
+
+	head_page = virt_to_head_page(ext);
+	get_page(head_page);
+
+	/* First reference to a shard does not hold a reference to
+	 * the underlying page, take it now. This function can only
+	 * be called during copy, so caller has a reference on ext,
+	 * we just took the second one - there is no risk that two
+	 * callers will race to do this upgrade.
+	 */
+	if (type == SKB_EXT_ALLOC_SHARD_NOREF && old == 1) {
+		get_page(head_page);
+		WRITE_ONCE(ext->alloc_type, SKB_EXT_ALLOC_SHARD_REF);
+	}
+}
+EXPORT_SYMBOL(__skb_ext_copy_get);
+
+static int skb_ext_evacuate_head(struct sk_buff *skb)
+{
+	struct skb_ext *old, *new;
+
+	if (likely(!skb->active_extensions))
+		return 0;
+	old = skb->extensions;
+	if (old->alloc_type != SKB_EXT_ALLOC_SHARD_NOREF)
+		return 0;
+
+	WARN_ON_ONCE(!skb->head_frag);
+	new = kmem_cache_alloc(skbuff_ext_cache, GFP_ATOMIC);
+	if (!new)
+		return -ENOMEM;
+
+	memcpy(new, old, old->chunks * SKB_EXT_ALIGN_VALUE);
+	WARN_ON_ONCE(refcount_read(&old->refcnt) != 1);
+	refcount_set(&new->refcnt, 1);
+	new->alloc_type = SKB_EXT_ALLOC_SLAB;
+
+	skb->extensions = new;
+	/* We're dealing with NOREF and we copied contents, so no freeing */
+
+	return 0;
+}
 #endif /* CONFIG_SKB_EXTENSIONS */
 
 /**
-- 
2.39.1


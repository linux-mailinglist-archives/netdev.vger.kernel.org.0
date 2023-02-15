Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BE46974FC
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjBODoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBODoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:44:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2638A311FF
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 19:44:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7EE7619DD
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 03:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98ACC433A0;
        Wed, 15 Feb 2023 03:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676432644;
        bh=+ho7+UZPd4eqxh9QKBOTMu5eq27p8JpjeeszV6u/W70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEufy4Ghi2IDntF5XsCPvssguTm0KYknM8fybkHIRmm9YGyxCU4XVce7ddXUcFHiU
         +bCApG6b5OET83Agb2PHrAISUq9Hj6ZGtxd8MUDG2G8QDEqnyDJOtTqjLeaxM095Q0
         RuBbiN2iylUs1ZVbP5sm4XJvPuM82xHvX9tr/ZfxE8O4/HMkptiFHJRwv01ZnhqBix
         +iz1lwh0hrXtbJJfW6UO7dDv+LPhziM6/bO4/s9DrCu4KrzJkmNtineiyA+AAQn5aF
         GI8G7gpBzwM1o5l9r777FKbI0vdw6YUrCX7Zx04q1TXVnHtD7lh7rHY+rtIj4ibBdr
         q30nw+FM4+RZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com, fw@strlen.de, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by GRO
Date:   Tue, 14 Feb 2023 19:43:54 -0800
Message-Id: <20230215034355.481925-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215034355.481925-1-kuba@kernel.org>
References: <20230215034355.481925-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the driver -> GRO path we can avoid thrashing the kmemcache
by holding onto one skb_ext.

Drivers usually report static data, so don't bother trying to
hold onto the skb_ext if the ext has contents which require
a destructor.

With a single flow and SW GRO adding a tc_skb_ext to every
frame costs around 16.6% of performance (21.2Gbps -> 17.6Gbps,
yes it's a relatively slow CPU). Using the cache reduces
the loss to 9.3%, (-> 19.2Gbps) although obviously in real
life the recycling will be less effective.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 79 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d5602b15c714..e68cb0a777b9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4622,6 +4622,7 @@ struct skb_ext *__skb_ext_alloc(gfp_t flags);
 void *__skb_ext_set(struct sk_buff *skb, enum skb_ext_id id,
 		    struct skb_ext *ext);
 void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id);
+void *napi_skb_ext_add(struct sk_buff *skb, enum skb_ext_id id);
 void __skb_ext_del(struct sk_buff *skb, enum skb_ext_id id);
 void __skb_ext_put(struct skb_ext *ext);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6f0fc1f09536..feb5034b13ad 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -224,6 +224,9 @@ static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp_mask)
 struct napi_alloc_cache {
 	struct page_frag_cache page;
 	struct page_frag_1k page_small;
+#ifdef CONFIG_SKB_EXTENSIONS
+	struct skb_ext *ext;
+#endif
 	unsigned int skb_count;
 	void *skb_cache[NAPI_SKB_CACHE_SIZE];
 };
@@ -1228,6 +1231,43 @@ static void napi_skb_cache_put(struct sk_buff *skb)
 	}
 }
 
+static bool skb_ext_needs_destruct(const struct skb_ext *ext)
+{
+	bool needs_destruct = false;
+
+#ifdef CONFIG_XFRM
+	needs_destruct |= __skb_ext_exist(ext, SKB_EXT_SEC_PATH);
+#endif
+#ifdef CONFIG_MCTP_FLOWS
+	needs_destruct |= __skb_ext_exist(ext, SKB_EXT_MCTP);
+#endif
+
+	return needs_destruct;
+}
+
+static void napi_skb_ext_put(struct sk_buff *skb)
+{
+#ifdef CONFIG_SKB_EXTENSIONS
+	struct skb_ext *ext;
+
+	if (!skb->active_extensions)
+		return;
+
+	ext = skb->extensions;
+	if (!skb_ext_needs_destruct(ext)) {
+		struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
+
+		if (refcount_read(&ext->refcnt) == 1 && !nc->ext) {
+			kasan_poison_object_data(skbuff_ext_cache, ext);
+			nc->ext = ext;
+			return;
+		}
+	}
+
+	__skb_ext_put(ext);
+#endif
+}
+
 void __kfree_skb_defer(struct sk_buff *skb)
 {
 	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
@@ -1239,7 +1279,7 @@ void napi_skb_free_stolen_head(struct sk_buff *skb)
 	if (unlikely(skb->slow_gro)) {
 		nf_reset_ct(skb);
 		skb_dst_drop(skb);
-		skb_ext_put(skb);
+		napi_skb_ext_put(skb);
 		skb_orphan(skb);
 		skb->slow_gro = 0;
 	}
@@ -6599,6 +6639,12 @@ static void *skb_ext_get_ptr(struct skb_ext *ext, enum skb_ext_id id)
 	return (void *)ext + (ext->offset[id] * SKB_EXT_ALIGN_VALUE);
 }
 
+static void skb_ext_init(struct skb_ext *new)
+{
+	memset(new->offset, 0, sizeof(new->offset));
+	refcount_set(&new->refcnt, 1);
+}
+
 /**
  * __skb_ext_alloc - allocate a new skb extensions storage
  *
@@ -6612,10 +6658,8 @@ struct skb_ext *__skb_ext_alloc(gfp_t flags)
 {
 	struct skb_ext *new = kmem_cache_alloc(skbuff_ext_cache, flags);
 
-	if (new) {
-		memset(new->offset, 0, sizeof(new->offset));
-		refcount_set(&new->refcnt, 1);
-	}
+	if (new)
+		skb_ext_init(new);
 
 	return new;
 }
@@ -6731,6 +6775,31 @@ void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
 }
 EXPORT_SYMBOL(skb_ext_add);
 
+void *napi_skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
+{
+	struct skb_ext *new = NULL;
+
+	if (!skb->active_extensions) {
+		struct napi_alloc_cache *nc;
+
+		nc = this_cpu_ptr(&napi_alloc_cache);
+		new = nc->ext;
+		if (new) {
+			kasan_unpoison_object_data(skbuff_ext_cache, new);
+			nc->ext = NULL;
+		} else {
+			new = kmem_cache_alloc(skbuff_ext_cache, GFP_ATOMIC);
+			if (!new)
+				return NULL;
+		}
+
+		skb_ext_init(new);
+	}
+
+	return skb_ext_add_finalize(skb, id, new);
+}
+EXPORT_SYMBOL(napi_skb_ext_add);
+
 #ifdef CONFIG_XFRM
 static void skb_ext_put_sp(struct sec_path *sp)
 {
-- 
2.39.1


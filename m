Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C86397C2A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhFAWIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:37 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39566 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbhFAWIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:20 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 638A264175;
        Wed,  2 Jun 2021 00:05:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/16] netfilter: nf_tables: prefer direct calls for set lookups
Date:   Wed,  2 Jun 2021 00:06:17 +0200
Message-Id: <20210601220629.18307-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Extend nft_set_do_lookup() to use direct calls when retpoline feature
is enabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h | 24 ++++++++++++++++++++
 net/netfilter/nft_lookup.c             | 31 ++++++++++++++++++++++++++
 net/netfilter/nft_set_bitmap.c         |  5 +++--
 net/netfilter/nft_set_hash.c           | 17 ++++++++------
 net/netfilter/nft_set_pipapo.h         |  2 --
 net/netfilter/nft_set_pipapo_avx2.h    |  2 --
 net/netfilter/nft_set_rbtree.c         |  5 +++--
 7 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 5eb699454490..46c8d5bb5d8d 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -3,6 +3,7 @@
 #define _NET_NF_TABLES_CORE_H
 
 #include <net/netfilter/nf_tables.h>
+#include <linux/indirect_call_wrapper.h>
 
 extern struct nft_expr_type nft_imm_type;
 extern struct nft_expr_type nft_cmp_type;
@@ -88,12 +89,35 @@ extern const struct nft_set_type nft_set_bitmap_type;
 extern const struct nft_set_type nft_set_pipapo_type;
 extern const struct nft_set_type nft_set_pipapo_avx2_type;
 
+#ifdef CONFIG_RETPOLINE
+bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
+		      const u32 *key, const struct nft_set_ext **ext);
+bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext);
+bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext);
+bool nft_hash_lookup_fast(const struct net *net,
+			  const struct nft_set *set,
+			  const u32 *key, const struct nft_set_ext **ext);
+bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
+		     const u32 *key, const struct nft_set_ext **ext);
+bool nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext);
+#else
 static inline bool
 nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		  const u32 *key, const struct nft_set_ext **ext)
 {
 	return set->ops->lookup(net, set, key, ext);
 }
+#endif
+
+/* called from nft_pipapo_avx2.c */
+bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext);
+/* called from nft_set_pipapo.c */
+bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
+			    const u32 *key, const struct nft_set_ext **ext);
 
 struct nft_expr;
 struct nft_regs;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 1a8581879af5..90becbf5bff3 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -23,6 +23,37 @@ struct nft_lookup {
 	struct nft_set_binding		binding;
 };
 
+#ifdef CONFIG_RETPOLINE
+bool nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext)
+{
+	if (set->ops == &nft_set_hash_fast_type.ops)
+		return nft_hash_lookup_fast(net, set, key, ext);
+	if (set->ops == &nft_set_hash_type.ops)
+		return nft_hash_lookup(net, set, key, ext);
+
+	if (set->ops == &nft_set_rhash_type.ops)
+		return nft_rhash_lookup(net, set, key, ext);
+
+	if (set->ops == &nft_set_bitmap_type.ops)
+		return nft_bitmap_lookup(net, set, key, ext);
+
+	if (set->ops == &nft_set_pipapo_type.ops)
+		return nft_pipapo_lookup(net, set, key, ext);
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
+	if (set->ops == &nft_set_pipapo_avx2_type.ops)
+		return nft_pipapo_avx2_lookup(net, set, key, ext);
+#endif
+
+	if (set->ops == &nft_set_rbtree_type.ops)
+		return nft_rbtree_lookup(net, set, key, ext);
+
+	WARN_ON_ONCE(1);
+	return set->ops->lookup(net, set, key, ext);
+}
+EXPORT_SYMBOL_GPL(nft_set_do_lookup);
+#endif
+
 void nft_lookup_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs,
 		     const struct nft_pktinfo *pkt)
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 2a81ea421819..e7ae5914971e 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -73,8 +73,9 @@ nft_bitmap_active(const u8 *bitmap, u32 idx, u32 off, u8 genmask)
 	return (bitmap[idx] & (0x3 << off)) & (genmask << off);
 }
 
-static bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
-			      const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext)
 {
 	const struct nft_bitmap *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 7b3d0a78c569..df40314de21f 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -74,8 +74,9 @@ static const struct rhashtable_params nft_rhash_params = {
 	.automatic_shrinking	= true,
 };
 
-static bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
-			     const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
+		      const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
 	const struct nft_rhash_elem *he;
@@ -446,8 +447,9 @@ struct nft_hash_elem {
 	struct nft_set_ext		ext;
 };
 
-static bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
-			    const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
+		     const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
@@ -484,9 +486,10 @@ static void *nft_hash_get(const struct net *net, const struct nft_set *set,
 	return ERR_PTR(-ENOENT);
 }
 
-static bool nft_hash_lookup_fast(const struct net *net,
-				 const struct nft_set *set,
-				 const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_hash_lookup_fast(const struct net *net,
+			  const struct nft_set *set,
+			  const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index d84afb8fa79a..25a75591583e 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -178,8 +178,6 @@ struct nft_pipapo_elem {
 
 int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
 		  union nft_pipapo_map_bucket *mt, bool match_only);
-bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
-		       const u32 *key, const struct nft_set_ext **ext);
 
 /**
  * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
diff --git a/net/netfilter/nft_set_pipapo_avx2.h b/net/netfilter/nft_set_pipapo_avx2.h
index 394bcb704db7..dbb6aaca8a7a 100644
--- a/net/netfilter/nft_set_pipapo_avx2.h
+++ b/net/netfilter/nft_set_pipapo_avx2.h
@@ -5,8 +5,6 @@
 #include <asm/fpu/xstate.h>
 #define NFT_PIPAPO_ALIGN	(XSAVE_YMM_SIZE / BITS_PER_BYTE)
 
-bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
-			    const u32 *key, const struct nft_set_ext **ext);
 bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
 			      struct nft_set_estimate *est);
 #endif /* defined(CONFIG_X86_64) && !defined(CONFIG_UML) */
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9e36eb4a7429..d600a566da32 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -107,8 +107,9 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 	return false;
 }
 
-static bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
-			      const u32 *key, const struct nft_set_ext **ext)
+INDIRECT_CALLABLE_SCOPE
+bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
+		       const u32 *key, const struct nft_set_ext **ext)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	unsigned int seq = read_seqcount_begin(&priv->count);
-- 
2.30.2


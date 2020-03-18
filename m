Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3BB189320
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbgCRAlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:41:16 -0400
Received: from correo.us.es ([193.147.175.20]:45608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbgCRAkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 458BB27F8A1
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3890CDA3A0
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2C03FDA3A1; Wed, 18 Mar 2020 01:39:43 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3597ADA390;
        Wed, 18 Mar 2020 01:39:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0E4E8426CCB9;
        Wed, 18 Mar 2020 01:39:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/29] netfilter: nf_tables: make all set structs const
Date:   Wed, 18 Mar 2020 01:39:32 +0100
Message-Id: <20200318003956.73573-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

They do not need to be writeable anymore.

v2: remove left-over __read_mostly annotation in set_pipapo.c (Stefano)

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      |  4 ----
 include/net/netfilter/nf_tables_core.h | 12 ++++++------
 net/netfilter/nf_tables_api.c          | 14 ++------------
 net/netfilter/nft_set_bitmap.c         |  3 +--
 net/netfilter/nft_set_hash.c           |  9 +++------
 net/netfilter/nft_set_pipapo.c         |  3 +--
 net/netfilter/nft_set_rbtree.c         |  3 +--
 7 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9a5f41028736..d913cdb6a27b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -385,14 +385,10 @@ struct nft_set_ops {
  *      struct nft_set_type - nf_tables set type
  *
  *      @ops: set ops for this type
- *      @list: used internally
- *      @owner: module reference
  *      @features: features supported by the implementation
  */
 struct nft_set_type {
 	const struct nft_set_ops	ops;
-	struct list_head		list;
-	struct module			*owner;
 	u32				features;
 };
 #define to_set_type(o) container_of(o, struct nft_set_type, ops)
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 29e7e1021267..3e30cc5d195b 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -69,12 +69,12 @@ extern const struct nft_expr_ops nft_payload_fast_ops;
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
 
-extern struct nft_set_type nft_set_rhash_type;
-extern struct nft_set_type nft_set_hash_type;
-extern struct nft_set_type nft_set_hash_fast_type;
-extern struct nft_set_type nft_set_rbtree_type;
-extern struct nft_set_type nft_set_bitmap_type;
-extern struct nft_set_type nft_set_pipapo_type;
+extern const struct nft_set_type nft_set_rhash_type;
+extern const struct nft_set_type nft_set_hash_type;
+extern const struct nft_set_type nft_set_hash_fast_type;
+extern const struct nft_set_type nft_set_rbtree_type;
+extern const struct nft_set_type nft_set_bitmap_type;
+extern const struct nft_set_type nft_set_pipapo_type;
 
 struct nft_expr;
 struct nft_regs;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f26a9b638d6c..3bdf2d0259f6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3344,11 +3344,6 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 			break;
 		}
 
-		if (!try_module_get(type->owner))
-			continue;
-		if (bops != NULL)
-			module_put(to_set_type(bops)->owner);
-
 		bops = ops;
 		best = est;
 	}
@@ -4047,10 +4042,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		size = ops->privsize(nla, &desc);
 
 	set = kvzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
-	if (!set) {
-		err = -ENOMEM;
-		goto err1;
-	}
+	if (!set)
+		return -ENOMEM;
 
 	name = nla_strdup(nla[NFTA_SET_NAME], GFP_KERNEL);
 	if (!name) {
@@ -4109,8 +4102,6 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	kfree(set->name);
 err2:
 	kvfree(set);
-err1:
-	module_put(to_set_type(ops)->owner);
 	return err;
 }
 
@@ -4120,7 +4111,6 @@ static void nft_set_destroy(struct nft_set *set)
 		return;
 
 	set->ops->destroy(set);
-	module_put(to_set_type(set->ops)->owner);
 	kfree(set->name);
 	kvfree(set);
 }
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 87e8d9ba0c9b..1cb2e67e6e03 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -293,8 +293,7 @@ static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
-struct nft_set_type nft_set_bitmap_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_bitmap_type = {
 	.ops		= {
 		.privsize	= nft_bitmap_privsize,
 		.elemsize	= offsetof(struct nft_bitmap_elem, ext),
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index d350a7cd3af0..4d3f147e8d8d 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -662,8 +662,7 @@ static bool nft_hash_fast_estimate(const struct nft_set_desc *desc, u32 features
 	return true;
 }
 
-struct nft_set_type nft_set_rhash_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_rhash_type = {
 	.features	= NFT_SET_MAP | NFT_SET_OBJECT |
 			  NFT_SET_TIMEOUT | NFT_SET_EVAL,
 	.ops		= {
@@ -686,8 +685,7 @@ struct nft_set_type nft_set_rhash_type __read_mostly = {
 	},
 };
 
-struct nft_set_type nft_set_hash_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_hash_type = {
 	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
 	.ops		= {
 		.privsize       = nft_hash_privsize,
@@ -706,8 +704,7 @@ struct nft_set_type nft_set_hash_type __read_mostly = {
 	},
 };
 
-struct nft_set_type nft_set_hash_fast_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_hash_fast_type = {
 	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
 	.ops		= {
 		.privsize       = nft_hash_privsize,
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 4fc0c924ed5d..34a1678cf290 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2081,8 +2081,7 @@ static void nft_pipapo_gc_init(const struct nft_set *set)
 	priv->last_gc = jiffies;
 }
 
-struct nft_set_type nft_set_pipapo_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_pipapo_type = {
 	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT |
 			  NFT_SET_TIMEOUT,
 	.ops		= {
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 5000b938ab1e..172ef8189f99 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -481,8 +481,7 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
-struct nft_set_type nft_set_rbtree_type __read_mostly = {
-	.owner		= THIS_MODULE,
+const struct nft_set_type nft_set_rbtree_type = {
 	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT | NFT_SET_TIMEOUT,
 	.ops		= {
 		.privsize	= nft_rbtree_privsize,
-- 
2.11.0


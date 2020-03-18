Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6F61892F1
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgCRAkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:14 -0400
Received: from correo.us.es ([193.147.175.20]:45608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgCRAkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E39F27F8AB
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C5C6DA38F
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 81DFCDA3A0; Wed, 18 Mar 2020 01:39:42 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 924B8DA3A5;
        Wed, 18 Mar 2020 01:39:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6BC99426CCB9;
        Wed, 18 Mar 2020 01:39:40 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/29] netfilter: nf_tables: make sets built-in
Date:   Wed, 18 Mar 2020 01:39:31 +0100
Message-Id: <20200318003956.73573-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Placing nftables set support in an extra module is pointless:

1. nf_tables needs dynamic registeration interface for sake of one module
2. nft heavily relies on sets, e.g. even simple rule like
   "nft ... tcp dport { 80, 443 }" will not work with _SETS=n.

IOW, either nftables isn't used or both nf_tables and nf_tables_set
modules are needed anyway.

With extra module:
 307K net/netfilter/nf_tables.ko
  79K net/netfilter/nf_tables_set.ko

   text  data  bss     dec filename
 146416  3072  545  150033 nf_tables.ko
  35496  1817    0   37313 nf_tables_set.ko

This patch:
 373K net/netfilter/nf_tables.ko

 178563  4049  545  183157 nf_tables.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h  |  6 ------
 net/netfilter/Kconfig              |  8 --------
 net/netfilter/Makefile             |  9 +++------
 net/netfilter/nf_tables_api.c      | 41 +++++++++++---------------------------
 net/netfilter/nf_tables_set_core.c | 31 ----------------------------
 5 files changed, 15 insertions(+), 80 deletions(-)
 delete mode 100644 net/netfilter/nf_tables_set_core.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4170c033d461..9a5f41028736 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -397,9 +397,6 @@ struct nft_set_type {
 };
 #define to_set_type(o) container_of(o, struct nft_set_type, ops)
 
-int nft_register_set(struct nft_set_type *type);
-void nft_unregister_set(struct nft_set_type *type);
-
 /**
  * 	struct nft_set - nf_tables set instance
  *
@@ -1253,9 +1250,6 @@ void nft_trace_notify(struct nft_traceinfo *info);
 #define MODULE_ALIAS_NFT_EXPR(name) \
 	MODULE_ALIAS("nft-expr-" name)
 
-#define MODULE_ALIAS_NFT_SET() \
-	MODULE_ALIAS("nft-set")
-
 #define MODULE_ALIAS_NFT_OBJ(type) \
 	MODULE_ALIAS("nft-obj-" __stringify(type))
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 91efae88e8c2..468fea1aebba 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -455,14 +455,6 @@ config NF_TABLES
 	  To compile it as a module, choose M here.
 
 if NF_TABLES
-
-config NF_TABLES_SET
-	tristate "Netfilter nf_tables set infrastructure"
-	help
-	  This option enables the nf_tables set infrastructure that allows to
-	  look up for elements in a set and to build one-way mappings between
-	  matchings and actions.
-
 config NF_TABLES_INET
 	depends on IPV6
 	select NF_TABLES_IPV4
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3f572e5a975e..4fff7d0e2d27 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -78,14 +78,11 @@ nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
 		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
 		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o \
-		  nft_chain_route.o nf_tables_offload.o
-
-nf_tables_set-objs := nf_tables_set_core.o \
-		      nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
-		      nft_set_pipapo.o
+		  nft_chain_route.o nf_tables_offload.o \
+		  nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
+		  nft_set_pipapo.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
-obj-$(CONFIG_NF_TABLES_SET)	+= nf_tables_set.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_CONNLIMIT)	+= nft_connlimit.o
 obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 38c680f28f15..f26a9b638d6c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3266,25 +3266,14 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 /*
  * Sets
  */
-
-static LIST_HEAD(nf_tables_set_types);
-
-int nft_register_set(struct nft_set_type *type)
-{
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	list_add_tail_rcu(&type->list, &nf_tables_set_types);
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nft_register_set);
-
-void nft_unregister_set(struct nft_set_type *type)
-{
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	list_del_rcu(&type->list);
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-}
-EXPORT_SYMBOL_GPL(nft_unregister_set);
+static const struct nft_set_type *nft_set_types[] = {
+	&nft_set_hash_fast_type,
+	&nft_set_hash_type,
+	&nft_set_rhash_type,
+	&nft_set_bitmap_type,
+	&nft_set_rbtree_type,
+	&nft_set_pipapo_type,
+};
 
 #define NFT_SET_FEATURES	(NFT_SET_INTERVAL | NFT_SET_MAP | \
 				 NFT_SET_TIMEOUT | NFT_SET_OBJECT | \
@@ -3310,15 +3299,11 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 	struct nft_set_estimate est, best;
 	const struct nft_set_type *type;
 	u32 flags = 0;
+	int i;
 
 	lockdep_assert_held(&ctx->net->nft.commit_mutex);
 	lockdep_nfnl_nft_mutex_not_held();
-#ifdef CONFIG_MODULES
-	if (list_empty(&nf_tables_set_types)) {
-		if (nft_request_module(ctx->net, "nft-set") == -EAGAIN)
-			return ERR_PTR(-EAGAIN);
-	}
-#endif
+
 	if (nla[NFTA_SET_FLAGS] != NULL)
 		flags = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
 
@@ -3327,7 +3312,8 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 	best.lookup = ~0;
 	best.space  = ~0;
 
-	list_for_each_entry(type, &nf_tables_set_types, list) {
+	for (i = 0; i < ARRAY_SIZE(nft_set_types); i++) {
+		type = nft_set_types[i];
 		ops = &type->ops;
 
 		if (!nft_set_ops_candidate(type, flags))
@@ -4312,7 +4298,6 @@ const struct nft_set_ext_type nft_set_ext_types[] = {
 		.align	= __alignof__(u32),
 	},
 };
-EXPORT_SYMBOL_GPL(nft_set_ext_types);
 
 /*
  * Set elements
@@ -5365,7 +5350,6 @@ void nft_set_gc_batch_release(struct rcu_head *rcu)
 		nft_set_elem_destroy(gcb->head.set, gcb->elems[i], true);
 	kfree(gcb);
 }
-EXPORT_SYMBOL_GPL(nft_set_gc_batch_release);
 
 struct nft_set_gc_batch *nft_set_gc_batch_alloc(const struct nft_set *set,
 						gfp_t gfp)
@@ -5378,7 +5362,6 @@ struct nft_set_gc_batch *nft_set_gc_batch_alloc(const struct nft_set *set,
 	gcb->head.set = set;
 	return gcb;
 }
-EXPORT_SYMBOL_GPL(nft_set_gc_batch_alloc);
 
 /*
  * Stateful objects
diff --git a/net/netfilter/nf_tables_set_core.c b/net/netfilter/nf_tables_set_core.c
deleted file mode 100644
index 586b621007eb..000000000000
--- a/net/netfilter/nf_tables_set_core.c
+++ /dev/null
@@ -1,31 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#include <linux/module.h>
-#include <net/netfilter/nf_tables_core.h>
-
-static int __init nf_tables_set_module_init(void)
-{
-	nft_register_set(&nft_set_hash_fast_type);
-	nft_register_set(&nft_set_hash_type);
-	nft_register_set(&nft_set_rhash_type);
-	nft_register_set(&nft_set_bitmap_type);
-	nft_register_set(&nft_set_rbtree_type);
-	nft_register_set(&nft_set_pipapo_type);
-
-	return 0;
-}
-
-static void __exit nf_tables_set_module_exit(void)
-{
-	nft_unregister_set(&nft_set_pipapo_type);
-	nft_unregister_set(&nft_set_rbtree_type);
-	nft_unregister_set(&nft_set_bitmap_type);
-	nft_unregister_set(&nft_set_rhash_type);
-	nft_unregister_set(&nft_set_hash_type);
-	nft_unregister_set(&nft_set_hash_fast_type);
-}
-
-module_init(nf_tables_set_module_init);
-module_exit(nf_tables_set_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_NFT_SET();
-- 
2.11.0


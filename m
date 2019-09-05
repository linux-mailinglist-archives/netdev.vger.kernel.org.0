Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6E0AA7F1
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390842AbfIEQEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:04:22 -0400
Received: from correo.us.es ([193.147.175.20]:53062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390796AbfIEQEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 406AB1228CB
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30766B7FFB
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 251AEB7FF2; Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F378CB7FFB;
        Thu,  5 Sep 2019 18:04:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C5E5C42EE38E;
        Thu,  5 Sep 2019 18:04:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/8] netfilter: nft_dynset: support for element deletion
Date:   Thu,  5 Sep 2019 18:03:56 +0200
Message-Id: <20190905160400.25399-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ander Juaristi <a@juaristi.eus>

This patch implements the delete operation from the ruleset.

It implements a new delete() function in nft_set_rhash. It is simpler
to use than the already existing remove(), because it only takes the set
and the key as arguments, whereas remove() expects a full
nft_set_elem structure.

Signed-off-by: Ander Juaristi <a@juaristi.eus>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        | 10 +++++++++-
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nft_dynset.c               |  6 ++++++
 net/netfilter/nft_set_hash.c             | 19 +++++++++++++++++++
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 64765140657b..498665158ee0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -302,17 +302,23 @@ struct nft_expr;
  *	struct nft_set_ops - nf_tables set operations
  *
  *	@lookup: look up an element within the set
+ *	@update: update an element if exists, add it if doesn't exist
+ *	@delete: delete an element
  *	@insert: insert new element into set
  *	@activate: activate new element in the next generation
  *	@deactivate: lookup for element and deactivate it in the next generation
  *	@flush: deactivate element in the next generation
  *	@remove: remove element from set
- *	@walk: iterate over all set elemeennts
+ *	@walk: iterate over all set elements
  *	@get: get set elements
  *	@privsize: function to return size of set private data
  *	@init: initialize private data of new set instance
  *	@destroy: destroy private data of set instance
  *	@elemsize: element private size
+ *
+ *	Operations lookup, update and delete have simpler interfaces, are faster
+ *	and currently only used in the packet path. All the rest are slower,
+ *	control plane functions.
  */
 struct nft_set_ops {
 	bool				(*lookup)(const struct net *net,
@@ -327,6 +333,8 @@ struct nft_set_ops {
 						  const struct nft_expr *expr,
 						  struct nft_regs *regs,
 						  const struct nft_set_ext **ext);
+	bool				(*delete)(const struct nft_set *set,
+						  const u32 *key);
 
 	int				(*insert)(const struct net *net,
 						  const struct nft_set *set,
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index b83b62eb4b01..0ff932dadc8e 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -636,6 +636,7 @@ enum nft_lookup_attributes {
 enum nft_dynset_ops {
 	NFT_DYNSET_OP_ADD,
 	NFT_DYNSET_OP_UPDATE,
+	NFT_DYNSET_OP_DELETE,
 };
 
 enum nft_dynset_flags {
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 33833a0cb989..8887295414dc 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -84,6 +84,11 @@ void nft_dynset_eval(const struct nft_expr *expr,
 	const struct nft_expr *sexpr;
 	u64 timeout;
 
+	if (priv->op == NFT_DYNSET_OP_DELETE) {
+		set->ops->delete(set, &regs->data[priv->sreg_key]);
+		return;
+	}
+
 	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
 			     expr, regs, &ext)) {
 		sexpr = NULL;
@@ -161,6 +166,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	priv->op = ntohl(nla_get_be32(tb[NFTA_DYNSET_OP]));
 	switch (priv->op) {
 	case NFT_DYNSET_OP_ADD:
+	case NFT_DYNSET_OP_DELETE:
 		break;
 	case NFT_DYNSET_OP_UPDATE:
 		if (!(set->flags & NFT_SET_TIMEOUT))
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index c490451fcebf..b331a3c9a3a8 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -234,6 +234,24 @@ static void nft_rhash_remove(const struct net *net,
 	rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params);
 }
 
+static bool nft_rhash_delete(const struct nft_set *set,
+			     const u32 *key)
+{
+	struct nft_rhash *priv = nft_set_priv(set);
+	struct nft_rhash_cmp_arg arg = {
+		.genmask = NFT_GENMASK_ANY,
+		.set = set,
+		.key = key,
+	};
+	struct nft_rhash_elem *he;
+
+	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
+	if (he == NULL)
+		return false;
+
+	return rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params) == 0;
+}
+
 static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			   struct nft_set_iter *iter)
 {
@@ -662,6 +680,7 @@ struct nft_set_type nft_set_rhash_type __read_mostly = {
 		.remove		= nft_rhash_remove,
 		.lookup		= nft_rhash_lookup,
 		.update		= nft_rhash_update,
+		.delete		= nft_rhash_delete,
 		.walk		= nft_rhash_walk,
 		.get		= nft_rhash_get,
 	},
-- 
2.11.0


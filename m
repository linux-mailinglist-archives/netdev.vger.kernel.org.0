Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3676D218ED1
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgGHRqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:46:53 -0400
Received: from correo.us.es ([193.147.175.20]:34782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbgGHRq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:46:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3D6F83066B5
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2DC82DA797
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 16809DA850; Wed,  8 Jul 2020 19:46:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA570DA840;
        Wed,  8 Jul 2020 19:46:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 19:46:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ACF954265A2F;
        Wed,  8 Jul 2020 19:46:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 06/12] netfilter: nf_tables: add NFTA_CHAIN_ID attribute
Date:   Wed,  8 Jul 2020 19:46:03 +0200
Message-Id: <20200708174609.1343-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708174609.1343-1-pablo@netfilter.org>
References: <20200708174609.1343-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This netlink attribute allows you to refer to chains inside a
transaction as an alternative to the name and the handle. The chain
binding support requires this new chain ID approach.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  3 +++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 15 ++++++++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6f0f6fca9ac3..3e5226684017 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1433,6 +1433,7 @@ struct nft_trans_chain {
 	char				*name;
 	struct nft_stats __percpu	*stats;
 	u8				policy;
+	u32				chain_id;
 };
 
 #define nft_trans_chain_update(trans)	\
@@ -1443,6 +1444,8 @@ struct nft_trans_chain {
 	(((struct nft_trans_chain *)trans->data)->stats)
 #define nft_trans_chain_policy(trans)	\
 	(((struct nft_trans_chain *)trans->data)->policy)
+#define nft_trans_chain_id(trans)	\
+	(((struct nft_trans_chain *)trans->data)->chain_id)
 
 struct nft_trans_table {
 	bool				update;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 4565456c0ef4..477779595b78 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -196,6 +196,7 @@ enum nft_table_attributes {
  * @NFTA_CHAIN_TYPE: type name of the string (NLA_NUL_STRING)
  * @NFTA_CHAIN_COUNTERS: counter specification of the chain (NLA_NESTED: nft_counter_attributes)
  * @NFTA_CHAIN_FLAGS: chain flags
+ * @NFTA_CHAIN_ID: uniquely identifies a chain in a transaction (NLA_U32)
  */
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
@@ -209,6 +210,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_COUNTERS,
 	NFTA_CHAIN_PAD,
 	NFTA_CHAIN_FLAGS,
+	NFTA_CHAIN_ID,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7647ecfa0d40..650ef0dd0773 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -280,9 +280,15 @@ static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
 	if (trans == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	if (msg_type == NFT_MSG_NEWCHAIN)
+	if (msg_type == NFT_MSG_NEWCHAIN) {
 		nft_activate_next(ctx->net, ctx->chain);
 
+		if (ctx->nla[NFTA_CHAIN_ID]) {
+			nft_trans_chain_id(trans) =
+				ntohl(nla_get_be32(ctx->nla[NFTA_CHAIN_ID]));
+		}
+	}
+
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return trans;
 }
@@ -1274,6 +1280,7 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 				    .len = NFT_MODULE_AUTOLOAD_LIMIT },
 	[NFTA_CHAIN_COUNTERS]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_CHAIN_ID]		= { .type = NLA_U32 },
 };
 
 static const struct nla_policy nft_hook_policy[NFTA_HOOK_MAX + 1] = {
@@ -2154,9 +2161,9 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
+	struct nft_chain *chain = NULL;
 	const struct nlattr *attr;
 	struct nft_table *table;
-	struct nft_chain *chain;
 	u8 policy = NF_ACCEPT;
 	struct nft_ctx ctx;
 	u64 handle = 0;
@@ -2181,7 +2188,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 			return PTR_ERR(chain);
 		}
 		attr = nla[NFTA_CHAIN_HANDLE];
-	} else {
+	} else if (nla[NFTA_CHAIN_NAME]) {
 		chain = nft_chain_lookup(net, table, attr, genmask);
 		if (IS_ERR(chain)) {
 			if (PTR_ERR(chain) != -ENOENT) {
@@ -2190,6 +2197,8 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 			}
 			chain = NULL;
 		}
+	} else if (!nla[NFTA_CHAIN_ID]) {
+		return -EINVAL;
 	}
 
 	if (nla[NFTA_CHAIN_POLICY]) {
-- 
2.20.1


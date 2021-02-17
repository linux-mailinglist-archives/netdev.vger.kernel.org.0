Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C7A31DF66
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 20:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhBQTFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 14:05:02 -0500
Received: from correo.us.es ([193.147.175.20]:40478 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232624AbhBQTEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 14:04:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2FE45C5173
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 20:03:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 126A9DA78E
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 20:03:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 07563DA704; Wed, 17 Feb 2021 20:03:48 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E97BDA78A;
        Wed, 17 Feb 2021 20:03:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Feb 2021 20:03:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id F21DB42DC701;
        Wed, 17 Feb 2021 20:03:44 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 3/3] netfilter: nftables: introduce table ownership
Date:   Wed, 17 Feb 2021 20:03:32 +0100
Message-Id: <20210217190332.21722-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210217190332.21722-1-pablo@netfilter.org>
References: <20210217190332.21722-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A userspace daemon like firewalld might need to monitor for netlink
updates to detect its ruleset removal by the (global) flush ruleset
command to ensure ruleset persistency. This adds extra complexity from
userspace and, for some little time, the firewall policy is not in
place.

This patch adds the NFT_TABLE_F_OWNER flag which allows a userspace
program to own the table that creates in exclusivity.

Tables that are owned...

- can only be updated and removed by the owner, non-owners hit EPERM if
  they try to update it or remove it.
- are destroyed when the owner closes the netlink socket or the process
  is gone (implicit netlink socket closure).
- are skipped by the global flush ruleset command.
- are listed in the global ruleset.

The userspace process that sets on the NFT_TABLE_F_OWNER flag need to
leave open the netlink socket.

A new NFTA_TABLE_OWNER netlink attribute specifies the netlink port ID
to identify the owner from userspace.

This patch also updates error reporting when an unknown table flag is
specified to change it from EINVAL to EOPNOTSUPP given that EINVAL is
usually reserved to report for malformed netlink messages to userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   6 +
 include/uapi/linux/netfilter/nf_tables.h |   5 +
 net/netfilter/nf_tables_api.c            | 163 ++++++++++++++++-------
 3 files changed, 128 insertions(+), 46 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 80bc2e8282ae..fdec57d862b7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1106,11 +1106,17 @@ struct nft_table {
 	u16				family:6,
 					flags:8,
 					genmask:2;
+	u32				nlpid;
 	char				*name;
 	u16				udlen;
 	u8				*udata;
 };
 
+static inline bool nft_table_has_owner(const struct nft_table *table)
+{
+	return table->flags & NFT_TABLE_F_OWNER;
+}
+
 static inline bool nft_base_chain_netdev(int family, u32 hooknum)
 {
 	return family == NFPROTO_NETDEV ||
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index b1633e7ba529..79bab7a36b30 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -164,7 +164,10 @@ enum nft_hook_attributes {
  */
 enum nft_table_flags {
 	NFT_TABLE_F_DORMANT	= 0x1,
+	NFT_TABLE_F_OWNER	= 0x2,
 };
+#define NFT_TABLE_F_MASK	(NFT_TABLE_F_DORMANT | \
+				 NFT_TABLE_F_OWNER)
 
 /**
  * enum nft_table_attributes - nf_tables table netlink attributes
@@ -173,6 +176,7 @@ enum nft_table_flags {
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
  * @NFTA_TABLE_USERDATA: user data (NLA_BINARY)
+ * @NFTA_TABLE_OWNER: owner of this table through netlink portID (NLA_U32)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
@@ -182,6 +186,7 @@ enum nft_table_attributes {
 	NFTA_TABLE_HANDLE,
 	NFTA_TABLE_PAD,
 	NFTA_TABLE_USERDATA,
+	NFTA_TABLE_OWNER,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dffb4f8ef17f..c1eb5cdb3033 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -508,7 +508,7 @@ static int nft_delflowtable(struct nft_ctx *ctx,
 
 static struct nft_table *nft_table_lookup(const struct net *net,
 					  const struct nlattr *nla,
-					  u8 family, u8 genmask)
+					  u8 family, u8 genmask, u32 nlpid)
 {
 	struct nft_table *table;
 
@@ -519,8 +519,13 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 				lockdep_is_held(&net->nft.commit_mutex)) {
 		if (!nla_strcmp(nla, table->name) &&
 		    table->family == family &&
-		    nft_active_genmask(table, genmask))
+		    nft_active_genmask(table, genmask)) {
+			if (nft_table_has_owner(table) &&
+			    table->nlpid != nlpid)
+				return ERR_PTR(-EPERM);
+
 			return table;
+		}
 	}
 
 	return ERR_PTR(-ENOENT);
@@ -679,6 +684,9 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 	    nla_put_be64(skb, NFTA_TABLE_HANDLE, cpu_to_be64(table->handle),
 			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
+	if (nft_table_has_owner(table) &&
+	    nla_put_be32(skb, NFTA_TABLE_OWNER, htonl(table->nlpid)))
+		goto nla_put_failure;
 
 	if (table->udata) {
 		if (nla_put(skb, NFTA_TABLE_USERDATA, table->udlen, table->udata))
@@ -821,7 +829,7 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
-	table = nft_table_lookup(net, nla[NFTA_TABLE_NAME], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_TABLE_NAME], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_TABLE_NAME]);
 		return PTR_ERR(table);
@@ -902,8 +910,8 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		return 0;
 
 	flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
-	if (flags & ~NFT_TABLE_F_DORMANT)
-		return -EINVAL;
+	if (flags & ~NFT_TABLE_F_MASK)
+		return -EOPNOTSUPP;
 
 	if (flags == ctx->table->flags)
 		return 0;
@@ -1003,7 +1011,8 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 
 	lockdep_assert_held(&net->nft.commit_mutex);
 	attr = nla[NFTA_TABLE_NAME];
-	table = nft_table_lookup(net, attr, family, genmask);
+	table = nft_table_lookup(net, attr, family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		if (PTR_ERR(table) != -ENOENT)
 			return PTR_ERR(table);
@@ -1021,8 +1030,8 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 
 	if (nla[NFTA_TABLE_FLAGS]) {
 		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
-		if (flags & ~NFT_TABLE_F_DORMANT)
-			return -EINVAL;
+		if (flags & ~NFT_TABLE_F_MASK)
+			return -EOPNOTSUPP;
 	}
 
 	err = -ENOMEM;
@@ -1053,6 +1062,8 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	table->family = family;
 	table->flags = flags;
 	table->handle = ++table_handle;
+	if (table->flags & NFT_TABLE_F_OWNER)
+		table->nlpid = NETLINK_CB(skb).portid;
 
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
@@ -1160,6 +1171,9 @@ static int nft_flush(struct nft_ctx *ctx, int family)
 		if (!nft_is_active_next(ctx->net, table))
 			continue;
 
+		if (nft_table_has_owner(table) && table->nlpid != ctx->portid)
+			continue;
+
 		if (nla[NFTA_TABLE_NAME] &&
 		    nla_strcmp(nla[NFTA_TABLE_NAME], table->name) != 0)
 			continue;
@@ -1196,7 +1210,8 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 		table = nft_table_lookup_byhandle(net, attr, genmask);
 	} else {
 		attr = nla[NFTA_TABLE_NAME];
-		table = nft_table_lookup(net, attr, family, genmask);
+		table = nft_table_lookup(net, attr, family, genmask,
+					 NETLINK_CB(skb).portid);
 	}
 
 	if (IS_ERR(table)) {
@@ -1579,7 +1594,7 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
-	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TABLE]);
 		return PTR_ERR(table);
@@ -2299,7 +2314,8 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 
 	lockdep_assert_held(&net->nft.commit_mutex);
 
-	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TABLE]);
 		return PTR_ERR(table);
@@ -2395,7 +2411,8 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 	u32 use;
 	int err;
 
-	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TABLE]);
 		return PTR_ERR(table);
@@ -3041,7 +3058,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
 	}
 
-	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
 		return PTR_ERR(table);
@@ -3179,7 +3196,8 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 	lockdep_assert_held(&net->nft.commit_mutex);
 
-	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
 		return PTR_ERR(table);
@@ -3403,7 +3421,8 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 	int family = nfmsg->nfgen_family, err = 0;
 	struct nft_ctx ctx;
 
-	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
 		return PTR_ERR(table);
@@ -3584,7 +3603,7 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
 				     const struct nlmsghdr *nlh,
 				     const struct nlattr * const nla[],
 				     struct netlink_ext_ack *extack,
-				     u8 genmask)
+				     u8 genmask, u32 nlpid)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	int family = nfmsg->nfgen_family;
@@ -3592,7 +3611,7 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
 
 	if (nla[NFTA_SET_TABLE] != NULL) {
 		table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family,
-					 genmask);
+					 genmask, nlpid);
 		if (IS_ERR(table)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
 			return PTR_ERR(table);
@@ -4007,7 +4026,7 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 
 	/* Verify existence before starting dump */
 	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla, extack,
-					genmask);
+					genmask, 0);
 	if (err < 0)
 		return err;
 
@@ -4236,7 +4255,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	if (nla[NFTA_SET_EXPR] || nla[NFTA_SET_EXPRESSIONS])
 		desc.expr = true;
 
-	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
 		return PTR_ERR(table);
@@ -4413,7 +4433,7 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla, extack,
-					genmask);
+					genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
 
@@ -4608,14 +4628,14 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx, struct net *net,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nla[],
 				      struct netlink_ext_ack *extack,
-				      u8 genmask)
+				      u8 genmask, u32 nlpid)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	int family = nfmsg->nfgen_family;
 	struct nft_table *table;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
-				 genmask);
+				 genmask, nlpid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
 		return PTR_ERR(table);
@@ -5032,7 +5052,7 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 	int rem, err = 0;
 
 	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, extack,
-					 genmask);
+					 genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
 
@@ -5613,7 +5633,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, extack,
-					 genmask);
+					 genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
 
@@ -5821,7 +5841,7 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 	int rem, err = 0;
 
 	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, extack,
-					 genmask);
+					 genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
 
@@ -6124,7 +6144,8 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	    !nla[NFTA_OBJ_DATA])
 		return -EINVAL;
 
-	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
 		return PTR_ERR(table);
@@ -6394,7 +6415,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	    !nla[NFTA_OBJ_TYPE])
 		return -EINVAL;
 
-	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
 		return PTR_ERR(table);
@@ -6468,7 +6489,8 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	    (!nla[NFTA_OBJ_NAME] && !nla[NFTA_OBJ_HANDLE]))
 		return -EINVAL;
 
-	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask);
+	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask,
+				 NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
 		return PTR_ERR(table);
@@ -6885,7 +6907,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	table = nft_table_lookup(net, nla[NFTA_FLOWTABLE_TABLE], family,
-				 genmask);
+				 genmask, NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_TABLE]);
 		return PTR_ERR(table);
@@ -7069,7 +7091,7 @@ static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	table = nft_table_lookup(net, nla[NFTA_FLOWTABLE_TABLE], family,
-				 genmask);
+				 genmask, NETLINK_CB(skb).portid);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_TABLE]);
 		return PTR_ERR(table);
@@ -7277,7 +7299,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 		return -EINVAL;
 
 	table = nft_table_lookup(net, nla[NFTA_FLOWTABLE_TABLE], family,
-				 genmask);
+				 genmask, 0);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -9051,14 +9073,55 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 	nf_tables_table_destroy(&ctx);
 }
 
-static void __nft_release_tables(struct net *net)
+static void __nft_release_tables(struct net *net, u32 nlpid)
 {
 	struct nft_table *table, *nt;
 
-	list_for_each_entry_safe(table, nt, &net->nft.tables, list)
+	list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
+		if (nft_table_has_owner(table) &&
+		    nlpid != table->nlpid)
+			continue;
+
 		__nft_release_table(net, table);
+	}
+}
+
+static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
+			    void *ptr)
+{
+	struct netlink_notify *n = ptr;
+	struct nft_table *table, *nt;
+	struct net *net = n->net;
+	bool release = false;
+
+	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
+		return NOTIFY_DONE;
+
+	mutex_lock(&net->nft.commit_mutex);
+	list_for_each_entry(table, &net->nft.tables, list) {
+		if (nft_table_has_owner(table) &&
+		    n->portid == table->nlpid) {
+			__nft_release_hook(net, table);
+			release = true;
+		}
+	}
+	if (release) {
+		synchronize_rcu();
+		list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
+			if (nft_table_has_owner(table) &&
+			    n->portid == table->nlpid)
+				__nft_release_table(net, table);
+		}
+	}
+	mutex_unlock(&net->nft.commit_mutex);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block nft_nl_notifier = {
+	.notifier_call  = nft_rcv_nl_event,
+};
+
 static int __net_init nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.tables);
@@ -9082,7 +9145,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
-	__nft_release_tables(net);
+	__nft_release_tables(net, 0);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
 	WARN_ON_ONCE(!list_empty(&net->nft.module_list));
@@ -9106,43 +9169,50 @@ static int __init nf_tables_module_init(void)
 
 	err = nft_chain_filter_init();
 	if (err < 0)
-		goto err1;
+		goto err_chain_filter;
 
 	err = nf_tables_core_module_init();
 	if (err < 0)
-		goto err2;
+		goto err_core_module;
 
 	err = register_netdevice_notifier(&nf_tables_flowtable_notifier);
 	if (err < 0)
-		goto err3;
+		goto err_netdev_notifier;
 
 	err = rhltable_init(&nft_objname_ht, &nft_objname_ht_params);
 	if (err < 0)
-		goto err4;
+		goto err_rht_objname;
 
 	err = nft_offload_init();
 	if (err < 0)
-		goto err5;
+		goto err_offload;
+
+	err = netlink_register_notifier(&nft_nl_notifier);
+	if (err < 0)
+		goto err_netlink_notifier;
 
 	/* must be last */
 	err = nfnetlink_subsys_register(&nf_tables_subsys);
 	if (err < 0)
-		goto err6;
+		goto err_nfnl_subsys;
 
 	nft_chain_route_init();
 
 	return err;
-err6:
+
+err_nfnl_subsys:
+	netlink_unregister_notifier(&nft_nl_notifier);
+err_netlink_notifier:
 	nft_offload_exit();
-err5:
+err_offload:
 	rhltable_destroy(&nft_objname_ht);
-err4:
+err_rht_objname:
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
-err3:
+err_netdev_notifier:
 	nf_tables_core_module_exit();
-err2:
+err_core_module:
 	nft_chain_filter_fini();
-err1:
+err_chain_filter:
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	return err;
 }
@@ -9150,6 +9220,7 @@ static int __init nf_tables_module_init(void)
 static void __exit nf_tables_module_exit(void)
 {
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
+	netlink_unregister_notifier(&nft_nl_notifier);
 	nft_offload_exit();
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
-- 
2.20.1


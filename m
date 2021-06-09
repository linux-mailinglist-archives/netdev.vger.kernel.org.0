Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7893A1F38
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFIVrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:35 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60486 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhFIVr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:28 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6F1726422E;
        Wed,  9 Jun 2021 23:44:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 03/13] netfilter: nf_tables: remove nft_ctx_init_from_setattr()
Date:   Wed,  9 Jun 2021 23:45:13 +0200
Message-Id: <20210609214523.1678-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace nft_ctx_init_from_setattr() by nft_table_lookup().

This patch also disentangles nf_tables_delset() where NFTA_SET_TABLE is
required while nft_ctx_init_from_setattr() allows it to be optional.

From the nf_tables_delset() path, this also allows to set up the context
structure when it is needed.

Removing this helper function saves us 14 LoC, so it is not helping to
consolidate code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 64 ++++++++++++++---------------------
 1 file changed, 25 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2fbcb2543795..6c2000a11c7e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3639,30 +3639,6 @@ static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
 	[NFTA_SET_DESC_CONCAT]		= { .type = NLA_NESTED },
 };
 
-static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
-				     const struct sk_buff *skb,
-				     const struct nlmsghdr *nlh,
-				     const struct nlattr * const nla[],
-				     struct netlink_ext_ack *extack,
-				     u8 genmask, u32 nlpid)
-{
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	int family = nfmsg->nfgen_family;
-	struct nft_table *table = NULL;
-
-	if (nla[NFTA_SET_TABLE] != NULL) {
-		table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family,
-					 genmask, nlpid);
-		if (IS_ERR(table)) {
-			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
-			return PTR_ERR(table);
-		}
-	}
-
-	nft_ctx_init(ctx, net, skb, nlh, family, table, NULL, nla);
-	return 0;
-}
-
 static struct nft_set *nft_set_lookup(const struct nft_table *table,
 				      const struct nlattr *nla, u8 genmask)
 {
@@ -4044,17 +4020,24 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	struct nft_table *table = NULL;
 	struct net *net = info->net;
 	const struct nft_set *set;
 	struct sk_buff *skb2;
 	struct nft_ctx ctx;
 	int err;
 
-	/* Verify existence before starting dump */
-	err = nft_ctx_init_from_setattr(&ctx, net, skb, info->nlh, nla, extack,
-					genmask, 0);
-	if (err < 0)
-		return err;
+	if (nla[NFTA_SET_TABLE]) {
+		table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family,
+					 genmask, 0);
+		if (IS_ERR(table)) {
+			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
+			return PTR_ERR(table);
+		}
+	}
+
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -4074,7 +4057,7 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!nla[NFTA_SET_TABLE])
 		return -EINVAL;
 
-	set = nft_set_lookup(ctx.table, nla[NFTA_SET_NAME], genmask);
+	set = nft_set_lookup(table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
@@ -4467,28 +4450,29 @@ static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
+	u8 family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
 	const struct nlattr *attr;
+	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
-	int err;
 
 	if (info->nfmsg->nfgen_family == NFPROTO_UNSPEC)
 		return -EAFNOSUPPORT;
-	if (nla[NFTA_SET_TABLE] == NULL)
-		return -EINVAL;
 
-	err = nft_ctx_init_from_setattr(&ctx, net, skb, info->nlh, nla, extack,
-					genmask, NETLINK_CB(skb).portid);
-	if (err < 0)
-		return err;
+	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family,
+				 genmask, NETLINK_CB(skb).portid);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
+		return PTR_ERR(table);
+	}
 
 	if (nla[NFTA_SET_HANDLE]) {
 		attr = nla[NFTA_SET_HANDLE];
-		set = nft_set_lookup_byhandle(ctx.table, attr, genmask);
+		set = nft_set_lookup_byhandle(table, attr, genmask);
 	} else {
 		attr = nla[NFTA_SET_NAME];
-		set = nft_set_lookup(ctx.table, attr, genmask);
+		set = nft_set_lookup(table, attr, genmask);
 	}
 
 	if (IS_ERR(set)) {
@@ -4502,6 +4486,8 @@ static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 		return -EBUSY;
 	}
 
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+
 	return nft_delset(&ctx, set);
 }
 
-- 
2.30.2


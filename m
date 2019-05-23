Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD3C28C6D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388262AbfEWVf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:35:57 -0400
Received: from mail.us.es ([193.147.175.20]:46938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387709AbfEWVf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 17:35:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A28B2C1A6F
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92853DA708
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88262DA705; Thu, 23 May 2019 23:35:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 585FDDA705;
        Thu, 23 May 2019 23:35:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2619A4265A32;
        Thu, 23 May 2019 23:35:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/11] netfilter: nf_tables: fix oops during rule dump
Date:   Thu, 23 May 2019 23:35:37 +0200
Message-Id: <20190523213547.15523-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523213547.15523-1-pablo@netfilter.org>
References: <20190523213547.15523-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We can oops in nf_tables_fill_rule_info().

Its not possible to fetch previous element in rcu-protected lists
when deletions are not prevented somehow: list_del_rcu poisons
the ->prev pointer value.

Before rcu-conversion this was safe as dump operations did hold
nfnetlink mutex.

Pass previous rule as argument, obtained by keeping a pointer to
the previous rule during traversal.

Fixes: d9adf22a291883 ("netfilter: nf_tables: use call_rcu in netlink dumps")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 28241e82fd15..4b5159936034 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2270,13 +2270,13 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 				    u32 flags, int family,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
-				    const struct nft_rule *rule)
+				    const struct nft_rule *rule,
+				    const struct nft_rule *prule)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	const struct nft_expr *expr, *next;
 	struct nlattr *list;
-	const struct nft_rule *prule;
 	u16 type = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(struct nfgenmsg), flags);
@@ -2296,8 +2296,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 			 NFTA_RULE_PAD))
 		goto nla_put_failure;
 
-	if ((event != NFT_MSG_DELRULE) && (rule->list.prev != &chain->rules)) {
-		prule = list_prev_entry(rule, list);
+	if (event != NFT_MSG_DELRULE && prule) {
 		if (nla_put_be64(skb, NFTA_RULE_POSITION,
 				 cpu_to_be64(prule->handle),
 				 NFTA_RULE_PAD))
@@ -2344,7 +2343,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
 				       event, 0, ctx->family, ctx->table,
-				       ctx->chain, rule);
+				       ctx->chain, rule, NULL);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -2369,12 +2368,13 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 				  const struct nft_chain *chain)
 {
 	struct net *net = sock_net(skb->sk);
+	const struct nft_rule *rule, *prule;
 	unsigned int s_idx = cb->args[0];
-	const struct nft_rule *rule;
 
+	prule = NULL;
 	list_for_each_entry_rcu(rule, &chain->rules, list) {
 		if (!nft_is_active(net, rule))
-			goto cont;
+			goto cont_skip;
 		if (*idx < s_idx)
 			goto cont;
 		if (*idx > s_idx) {
@@ -2386,11 +2386,13 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule) < 0)
+					table, chain, rule, prule) < 0)
 			return 1;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
+		prule = rule;
+cont_skip:
 		(*idx)++;
 	}
 	return 0;
@@ -2546,7 +2548,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 
 	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
 				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
-				       family, table, chain, rule);
+				       family, table, chain, rule, NULL);
 	if (err < 0)
 		goto err;
 
-- 
2.11.0


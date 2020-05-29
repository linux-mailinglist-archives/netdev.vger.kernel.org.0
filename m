Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459EE1E85B9
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgE2Rum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:50:42 -0400
Received: from correo.us.es ([193.147.175.20]:58838 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbgE2Ruh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:50:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3293F8140C
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23149DA736
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 189F3DA723; Fri, 29 May 2020 19:50:35 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D30BCDA70E;
        Fri, 29 May 2020 19:50:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 19:50:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A73BD42EE38E;
        Fri, 29 May 2020 19:50:32 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 5/9] netfilter: nf_tables: pass hook list to flowtable event notifier
Date:   Fri, 29 May 2020 19:50:22 +0200
Message-Id: <20200529175026.30541-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529175026.30541-1-pablo@netfilter.org>
References: <20200529175026.30541-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the flowtable netlink notifier to take the list of hooks as input.
This allows to reuse this function in incremental flowtable hook updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f5d100787ccb..4db70e68d7f4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6523,7 +6523,8 @@ static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
 static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 					 u32 portid, u32 seq, int event,
 					 u32 flags, int family,
-					 struct nft_flowtable *flowtable)
+					 struct nft_flowtable *flowtable,
+					 struct list_head *hook_list)
 {
 	struct nlattr *nest, *nest_devs;
 	struct nfgenmsg *nfmsg;
@@ -6559,7 +6560,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	if (!nest_devs)
 		goto nla_put_failure;
 
-	list_for_each_entry_rcu(hook, &flowtable->hook_list, list) {
+	list_for_each_entry_rcu(hook, hook_list, list) {
 		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
 			goto nla_put_failure;
 	}
@@ -6612,7 +6613,9 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 							  cb->nlh->nlmsg_seq,
 							  NFT_MSG_NEWFLOWTABLE,
 							  NLM_F_MULTI | NLM_F_APPEND,
-							  table->family, flowtable) < 0)
+							  table->family,
+							  flowtable,
+							  &flowtable->hook_list) < 0)
 				goto done;
 
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -6709,7 +6712,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 	err = nf_tables_fill_flowtable_info(skb2, net, NETLINK_CB(skb).portid,
 					    nlh->nlmsg_seq,
 					    NFT_MSG_NEWFLOWTABLE, 0, family,
-					    flowtable);
+					    flowtable, &flowtable->hook_list);
 	if (err < 0)
 		goto err;
 
@@ -6721,6 +6724,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 
 static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 				       struct nft_flowtable *flowtable,
+				       struct list_head *hook_list,
 				       int event)
 {
 	struct sk_buff *skb;
@@ -6736,7 +6740,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 
 	err = nf_tables_fill_flowtable_info(skb, ctx->net, ctx->portid,
 					    ctx->seq, event, 0,
-					    ctx->family, flowtable);
+					    ctx->family, flowtable, hook_list);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -7494,6 +7498,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_clear(net, nft_trans_flowtable(trans));
 			nf_tables_flowtable_notify(&trans->ctx,
 						   nft_trans_flowtable(trans),
+						   &nft_trans_flowtable(trans)->hook_list,
 						   NFT_MSG_NEWFLOWTABLE);
 			nft_trans_destroy(trans);
 			break;
@@ -7501,6 +7506,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			list_del_rcu(&nft_trans_flowtable(trans)->list);
 			nf_tables_flowtable_notify(&trans->ctx,
 						   nft_trans_flowtable(trans),
+						   &nft_trans_flowtable(trans)->hook_list,
 						   NFT_MSG_DELFLOWTABLE);
 			nft_unregister_flowtable_net_hooks(net,
 					&nft_trans_flowtable(trans)->hook_list);
-- 
2.20.1


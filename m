Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CD01E85C5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgE2RvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:51:03 -0400
Received: from correo.us.es ([193.147.175.20]:58812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbgE2Rug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:50:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1047C81418
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1195DA72A
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E4B8DDA722; Fri, 29 May 2020 19:50:33 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2CEDDA716;
        Fri, 29 May 2020 19:50:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 19:50:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8656642EE38E;
        Fri, 29 May 2020 19:50:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/9] netfilter: nf_tables: pass hook list to nft_{un,}register_flowtable_net_hooks()
Date:   Fri, 29 May 2020 19:50:20 +0200
Message-Id: <20200529175026.30541-4-pablo@netfilter.org>
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

This patch prepares for incremental flowtable hook updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 87945b4a6789..1505552aaa74 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6279,23 +6279,24 @@ static void nft_unregister_flowtable_hook(struct net *net,
 }
 
 static void nft_unregister_flowtable_net_hooks(struct net *net,
-					       struct nft_flowtable *flowtable)
+					       struct list_head *hook_list)
 {
 	struct nft_hook *hook;
 
-	list_for_each_entry(hook, &flowtable->hook_list, list)
+	list_for_each_entry(hook, hook_list, list)
 		nf_unregister_net_hook(net, &hook->ops);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
 					    struct nft_table *table,
+					    struct list_head *hook_list,
 					    struct nft_flowtable *flowtable)
 {
 	struct nft_hook *hook, *hook2, *next;
 	struct nft_flowtable *ft;
 	int err, i = 0;
 
-	list_for_each_entry(hook, &flowtable->hook_list, list) {
+	list_for_each_entry(hook, hook_list, list) {
 		list_for_each_entry(ft, &table->flowtables, list) {
 			list_for_each_entry(hook2, &ft->hook_list, list) {
 				if (hook->ops.dev == hook2->ops.dev &&
@@ -6326,7 +6327,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return 0;
 
 err_unregister_net_hooks:
-	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+	list_for_each_entry_safe(hook, next, hook_list, list) {
 		if (i-- <= 0)
 			break;
 
@@ -6428,7 +6429,9 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	flowtable->data.priority = flowtable_hook.priority;
 	flowtable->hooknum = flowtable_hook.num;
 
-	err = nft_register_flowtable_net_hooks(ctx.net, table, flowtable);
+	err = nft_register_flowtable_net_hooks(ctx.net, table,
+					       &flowtable->hook_list,
+					       flowtable);
 	if (err < 0) {
 		list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
 			list_del_rcu(&hook->list);
@@ -7493,7 +7496,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 						   nft_trans_flowtable(trans),
 						   NFT_MSG_DELFLOWTABLE);
 			nft_unregister_flowtable_net_hooks(net,
-					nft_trans_flowtable(trans));
+					&nft_trans_flowtable(trans)->hook_list);
 			break;
 		}
 	}
@@ -7652,7 +7655,7 @@ static int __nf_tables_abort(struct net *net, bool autoload)
 			trans->ctx.table->use--;
 			list_del_rcu(&nft_trans_flowtable(trans)->list);
 			nft_unregister_flowtable_net_hooks(net,
-					nft_trans_flowtable(trans));
+					&nft_trans_flowtable(trans)->hook_list);
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			trans->ctx.table->use++;
-- 
2.20.1


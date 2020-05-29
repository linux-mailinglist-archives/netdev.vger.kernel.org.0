Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351741E85C3
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgE2Ruz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:50:55 -0400
Received: from correo.us.es ([193.147.175.20]:58812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgE2Rui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:50:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 471738142B
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36E3EDA723
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2A3E6DA721; Fri, 29 May 2020 19:50:36 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE26BDA71F;
        Fri, 29 May 2020 19:50:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 19:50:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A2AD242EE38E;
        Fri, 29 May 2020 19:50:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 7/9] netfilter: nf_tables: delete devices from flowtable
Date:   Fri, 29 May 2020 19:50:24 +0200
Message-Id: <20200529175026.30541-8-pablo@netfilter.org>
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

This patch allows users to delete devices from existing flowtables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   1 +
 net/netfilter/nf_tables_api.c     | 113 +++++++++++++++++++++++++-----
 2 files changed, 98 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4f58c4411bb4..6f0f6fca9ac3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1002,6 +1002,7 @@ struct nft_stats {
 
 struct nft_hook {
 	struct list_head	list;
+	bool			inactive;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 98f2cbb97e39..1c2c3bb78fa0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1669,6 +1669,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		goto err_hook_dev;
 	}
 	hook->ops.dev = dev;
+	hook->inactive = false;
 
 	return hook;
 
@@ -1678,17 +1679,17 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	return ERR_PTR(err);
 }
 
-static bool nft_hook_list_find(struct list_head *hook_list,
-			       const struct nft_hook *this)
+static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
+					   const struct nft_hook *this)
 {
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
 		if (this->ops.dev == hook->ops.dev)
-			return true;
+			return hook;
 	}
 
-	return false;
+	return NULL;
 }
 
 static int nf_tables_parse_netdev_hooks(struct net *net,
@@ -6530,6 +6531,51 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	return err;
 }
 
+static int nft_delflowtable_hook(struct nft_ctx *ctx,
+				 struct nft_flowtable *flowtable)
+{
+	const struct nlattr * const *nla = ctx->nla;
+	struct nft_flowtable_hook flowtable_hook;
+	struct nft_hook *this, *next, *hook;
+	struct nft_trans *trans;
+	int err;
+
+	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
+				       &flowtable_hook, &flowtable->data);
+	if (err < 0)
+		return err;
+
+	list_for_each_entry_safe(this, next, &flowtable_hook.list, list) {
+		hook = nft_hook_list_find(&flowtable->hook_list, this);
+		if (!hook) {
+			err = -ENOENT;
+			goto err_flowtable_del_hook;
+		}
+		hook->inactive = true;
+		list_del(&this->list);
+		kfree(this);
+	}
+
+	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
+				sizeof(struct nft_trans_flowtable));
+	if (!trans)
+		return -ENOMEM;
+
+	nft_trans_flowtable(trans) = flowtable;
+	nft_trans_flowtable_update(trans) = true;
+	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
+
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return 0;
+
+err_flowtable_del_hook:
+	list_for_each_entry(hook, &flowtable_hook.list, list)
+		hook->inactive = false;
+
+	return err;
+}
+
 static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
 				  struct sk_buff *skb,
 				  const struct nlmsghdr *nlh,
@@ -6568,13 +6614,17 @@ static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(flowtable);
 	}
+
+	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+
+	if (nla[NFTA_FLOWTABLE_HOOK])
+		return nft_delflowtable_hook(&ctx, flowtable);
+
 	if (flowtable->use > 0) {
 		NL_SET_BAD_ATTR(extack, attr);
 		return -EBUSY;
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
-
 	return nft_delflowtable(&ctx, flowtable);
 }
 
@@ -7184,7 +7234,10 @@ static void nft_commit_release(struct nft_trans *trans)
 		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
 		break;
 	case NFT_MSG_DELFLOWTABLE:
-		nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
+		if (nft_trans_flowtable_update(trans))
+			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+		else
+			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
 	}
 
@@ -7345,6 +7398,17 @@ static void nft_chain_del(struct nft_chain *chain)
 	list_del_rcu(&chain->list);
 }
 
+static void nft_flowtable_hooks_del(struct nft_flowtable *flowtable,
+				    struct list_head *hook_list)
+{
+	struct nft_hook *hook, *next;
+
+	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+		if (hook->inactive)
+			list_move(&hook->list, hook_list);
+	}
+}
+
 static void nf_tables_module_autoload_cleanup(struct net *net)
 {
 	struct nft_module_request *req, *next;
@@ -7570,13 +7634,24 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELFLOWTABLE:
-			list_del_rcu(&nft_trans_flowtable(trans)->list);
-			nf_tables_flowtable_notify(&trans->ctx,
-						   nft_trans_flowtable(trans),
-						   &nft_trans_flowtable(trans)->hook_list,
-						   NFT_MSG_DELFLOWTABLE);
-			nft_unregister_flowtable_net_hooks(net,
-					&nft_trans_flowtable(trans)->hook_list);
+			if (nft_trans_flowtable_update(trans)) {
+				nft_flowtable_hooks_del(nft_trans_flowtable(trans),
+							&nft_trans_flowtable_hooks(trans));
+				nf_tables_flowtable_notify(&trans->ctx,
+							   nft_trans_flowtable(trans),
+							   &nft_trans_flowtable_hooks(trans),
+							   NFT_MSG_DELFLOWTABLE);
+				nft_unregister_flowtable_net_hooks(net,
+								   &nft_trans_flowtable_hooks(trans));
+			} else {
+				list_del_rcu(&nft_trans_flowtable(trans)->list);
+				nf_tables_flowtable_notify(&trans->ctx,
+							   nft_trans_flowtable(trans),
+							   &nft_trans_flowtable(trans)->hook_list,
+							   NFT_MSG_DELFLOWTABLE);
+				nft_unregister_flowtable_net_hooks(net,
+						&nft_trans_flowtable(trans)->hook_list);
+			}
 			break;
 		}
 	}
@@ -7638,6 +7713,7 @@ static int __nf_tables_abort(struct net *net, bool autoload)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
+	struct nft_hook *hook;
 
 	list_for_each_entry_safe_reverse(trans, next, &net->nft.commit_list,
 					 list) {
@@ -7746,8 +7822,13 @@ static int __nf_tables_abort(struct net *net, bool autoload)
 			}
 			break;
 		case NFT_MSG_DELFLOWTABLE:
-			trans->ctx.table->use++;
-			nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
+			if (nft_trans_flowtable_update(trans)) {
+				list_for_each_entry(hook, &nft_trans_flowtable(trans)->hook_list, list)
+					hook->inactive = false;
+			} else {
+				trans->ctx.table->use++;
+				nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
+			}
 			nft_trans_destroy(trans);
 			break;
 		}
-- 
2.20.1


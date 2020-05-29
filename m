Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330D61E85BB
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgE2Run (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:50:43 -0400
Received: from correo.us.es ([193.147.175.20]:58856 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgE2Rui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:50:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD09A81428
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B00C0DA722
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4153DA711; Fri, 29 May 2020 19:50:35 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59BB1DA714;
        Fri, 29 May 2020 19:50:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 19:50:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2E7E242EE38E;
        Fri, 29 May 2020 19:50:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 6/9] netfilter: nf_tables: add devices to existing flowtable
Date:   Fri, 29 May 2020 19:50:23 +0200
Message-Id: <20200529175026.30541-7-pablo@netfilter.org>
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

This patch allows users to add devices to an existing flowtable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  6 ++
 net/netfilter/nf_tables_api.c     | 97 +++++++++++++++++++++++++++----
 2 files changed, 92 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d4e29c952c40..4f58c4411bb4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1481,10 +1481,16 @@ struct nft_trans_obj {
 
 struct nft_trans_flowtable {
 	struct nft_flowtable		*flowtable;
+	bool				update;
+	struct list_head		hook_list;
 };
 
 #define nft_trans_flowtable(trans)	\
 	(((struct nft_trans_flowtable *)trans->data)->flowtable)
+#define nft_trans_flowtable_update(trans)	\
+	(((struct nft_trans_flowtable *)trans->data)->update)
+#define nft_trans_flowtable_hooks(trans)	\
+	(((struct nft_trans_flowtable *)trans->data)->hook_list)
 
 int __init nft_chain_filter_init(void);
 void nft_chain_filter_fini(void);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4db70e68d7f4..98f2cbb97e39 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6349,6 +6349,62 @@ static void nft_flowtable_hooks_destroy(struct list_head *hook_list)
 	}
 }
 
+static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
+				struct nft_flowtable *flowtable)
+{
+	const struct nlattr * const *nla = ctx->nla;
+	struct nft_flowtable_hook flowtable_hook;
+	struct nft_hook *hook, *next;
+	struct nft_trans *trans;
+	bool unregister = false;
+	int err;
+
+	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
+				       &flowtable_hook, &flowtable->data);
+	if (err < 0)
+		return err;
+
+	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
+		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
+			list_del(&hook->list);
+			kfree(hook);
+		}
+	}
+
+	err = nft_register_flowtable_net_hooks(ctx->net, ctx->table,
+					       &flowtable_hook.list, flowtable);
+	if (err < 0)
+		goto err_flowtable_update_hook;
+
+	trans = nft_trans_alloc(ctx, NFT_MSG_NEWFLOWTABLE,
+				sizeof(struct nft_trans_flowtable));
+	if (!trans) {
+		unregister = true;
+		err = -ENOMEM;
+		goto err_flowtable_update_hook;
+	}
+
+	nft_trans_flowtable(trans) = flowtable;
+	nft_trans_flowtable_update(trans) = true;
+	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
+	list_splice(&flowtable_hook.list, &nft_trans_flowtable_hooks(trans));
+
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return 0;
+
+err_flowtable_update_hook:
+	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
+		if (unregister)
+			nft_unregister_flowtable_hook(ctx->net, flowtable, hook);
+		list_del_rcu(&hook->list);
+		kfree_rcu(hook, rcu);
+	}
+
+	return err;
+
+}
+
 static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				  struct sk_buff *skb,
 				  const struct nlmsghdr *nlh,
@@ -6392,7 +6448,9 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 			return -EEXIST;
 		}
 
-		return 0;
+		nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+
+		return nft_flowtable_update(&ctx, nlh, flowtable);
 	}
 
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
@@ -7495,11 +7553,20 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 					     NFT_MSG_DELOBJ);
 			break;
 		case NFT_MSG_NEWFLOWTABLE:
-			nft_clear(net, nft_trans_flowtable(trans));
-			nf_tables_flowtable_notify(&trans->ctx,
-						   nft_trans_flowtable(trans),
-						   &nft_trans_flowtable(trans)->hook_list,
-						   NFT_MSG_NEWFLOWTABLE);
+			if (nft_trans_flowtable_update(trans)) {
+				nf_tables_flowtable_notify(&trans->ctx,
+							   nft_trans_flowtable(trans),
+							   &nft_trans_flowtable_hooks(trans),
+							   NFT_MSG_NEWFLOWTABLE);
+				list_splice(&nft_trans_flowtable_hooks(trans),
+					    &nft_trans_flowtable(trans)->hook_list);
+			} else {
+				nft_clear(net, nft_trans_flowtable(trans));
+				nf_tables_flowtable_notify(&trans->ctx,
+							   nft_trans_flowtable(trans),
+							   &nft_trans_flowtable(trans)->hook_list,
+							   NFT_MSG_NEWFLOWTABLE);
+			}
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELFLOWTABLE:
@@ -7558,7 +7625,10 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
 		break;
 	case NFT_MSG_NEWFLOWTABLE:
-		nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
+		if (nft_trans_flowtable_update(trans))
+			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+		else
+			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
 	}
 	kfree(trans);
@@ -7665,10 +7735,15 @@ static int __nf_tables_abort(struct net *net, bool autoload)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWFLOWTABLE:
-			trans->ctx.table->use--;
-			list_del_rcu(&nft_trans_flowtable(trans)->list);
-			nft_unregister_flowtable_net_hooks(net,
-					&nft_trans_flowtable(trans)->hook_list);
+			if (nft_trans_flowtable_update(trans)) {
+				nft_unregister_flowtable_net_hooks(net,
+						&nft_trans_flowtable_hooks(trans));
+			} else {
+				trans->ctx.table->use--;
+				list_del_rcu(&nft_trans_flowtable(trans)->list);
+				nft_unregister_flowtable_net_hooks(net,
+						&nft_trans_flowtable(trans)->hook_list);
+			}
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			trans->ctx.table->use++;
-- 
2.20.1


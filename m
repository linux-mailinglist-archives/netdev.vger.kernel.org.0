Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8A93411F0
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhCSBGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhCSBGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:06:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C715AC061762;
        Thu, 18 Mar 2021 18:06:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6B94F630C2;
        Fri, 19 Mar 2021 02:06:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 7/9] netfilter: nftables: allow to update flowtable flags
Date:   Fri, 19 Mar 2021 02:06:06 +0100
Message-Id: <20210319010608.9758-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210319010608.9758-1-pablo@netfilter.org>
References: <20210319010608.9758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Honor flowtable flags from the control update path. Disallow disabling
to toggle hardware offload support though.

Fixes: 8bb69f3b2918 ("netfilter: nf_tables: add flowtable offload control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fdec57d862b7..5aaced6bf13e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1536,6 +1536,7 @@ struct nft_trans_flowtable {
 	struct nft_flowtable		*flowtable;
 	bool				update;
 	struct list_head		hook_list;
+	u32				flags;
 };
 
 #define nft_trans_flowtable(trans)	\
@@ -1544,6 +1545,8 @@ struct nft_trans_flowtable {
 	(((struct nft_trans_flowtable *)trans->data)->update)
 #define nft_trans_flowtable_hooks(trans)	\
 	(((struct nft_trans_flowtable *)trans->data)->hook_list)
+#define nft_trans_flowtable_flags(trans)	\
+	(((struct nft_trans_flowtable *)trans->data)->flags)
 
 int __init nft_chain_filter_init(void);
 void nft_chain_filter_fini(void);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0d034f895b7b..4fcd07f1e925 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6842,6 +6842,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
+	u32 flags;
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
@@ -6856,6 +6857,17 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		}
 	}
 
+	if (nla[NFTA_FLOWTABLE_FLAGS]) {
+		flags = ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
+		if (flags & ~NFT_FLOWTABLE_MASK)
+			return -EOPNOTSUPP;
+		if ((flowtable->data.flags & NFT_FLOWTABLE_HW_OFFLOAD) ^
+		    (flags & NFT_FLOWTABLE_HW_OFFLOAD))
+			return -EOPNOTSUPP;
+	} else {
+		flags = flowtable->data.flags;
+	}
+
 	err = nft_register_flowtable_net_hooks(ctx->net, ctx->table,
 					       &flowtable_hook.list, flowtable);
 	if (err < 0)
@@ -6869,6 +6881,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		goto err_flowtable_update_hook;
 	}
 
+	nft_trans_flowtable_flags(trans) = flags;
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
@@ -8178,6 +8191,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_NEWFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
+				nft_trans_flowtable(trans)->data.flags =
+					nft_trans_flowtable_flags(trans);
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
-- 
2.20.1


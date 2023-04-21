Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156376EB5F7
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbjDUXu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbjDUXug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:50:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C368A2D6B;
        Fri, 21 Apr 2023 16:50:35 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 19/19] netfilter: nf_tables: allow to create netdev chain without device
Date:   Sat, 22 Apr 2023 01:50:21 +0200
Message-Id: <20230421235021.216950-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421235021.216950-1-pablo@netfilter.org>
References: <20230421235021.216950-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Relax netdev chain creation to allow for loading the ruleset, then
adding/deleting devices at a later stage. Hardware offload does not
support for this feature yet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c55ac3d57c51..09542951656c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2023,10 +2023,9 @@ struct nft_chain_hook {
 	struct list_head		list;
 };
 
-static int nft_chain_parse_netdev(struct net *net,
-				  struct nlattr *tb[],
+static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
 				  struct list_head *hook_list,
-				  struct netlink_ext_ack *extack)
+				  struct netlink_ext_ack *extack, u32 flags)
 {
 	struct nft_hook *hook;
 	int err;
@@ -2045,12 +2044,12 @@ static int nft_chain_parse_netdev(struct net *net,
 		if (err < 0)
 			return err;
 
-		if (list_empty(hook_list))
-			return -EINVAL;
-	} else {
-		return -EINVAL;
 	}
 
+	if (flags & NFT_CHAIN_HW_OFFLOAD &&
+	    list_empty(hook_list))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -2058,7 +2057,7 @@ static int nft_chain_parse_hook(struct net *net,
 				struct nft_base_chain *basechain,
 				const struct nlattr * const nla[],
 				struct nft_chain_hook *hook, u8 family,
-				struct netlink_ext_ack *extack)
+				u32 flags, struct netlink_ext_ack *extack)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
@@ -2125,7 +2124,7 @@ static int nft_chain_parse_hook(struct net *net,
 
 	INIT_LIST_HEAD(&hook->list);
 	if (nft_base_chain_netdev(family, hook->num)) {
-		err = nft_chain_parse_netdev(net, ha, &hook->list, extack);
+		err = nft_chain_parse_netdev(net, ha, &hook->list, extack, flags);
 		if (err < 0) {
 			module_put(type->owner);
 			return err;
@@ -2263,7 +2262,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		if (flags & NFT_CHAIN_BINDING)
 			return -EOPNOTSUPP;
 
-		err = nft_chain_parse_hook(net, NULL, nla, &hook, family,
+		err = nft_chain_parse_hook(net, NULL, nla, &hook, family, flags,
 					   extack);
 		if (err < 0)
 			return err;
@@ -2407,7 +2406,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 		basechain = nft_base_chain(chain);
 		err = nft_chain_parse_hook(ctx->net, basechain, nla, &hook,
-					   ctx->family, extack);
+					   ctx->family, flags, extack);
 		if (err < 0)
 			return err;
 
@@ -2683,7 +2682,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx, struct nft_chain *chain,
 
 	basechain = nft_base_chain(chain);
 	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
-				   ctx->family, extack);
+				   ctx->family, chain->flags, extack);
 	if (err < 0)
 		return err;
 
-- 
2.30.2


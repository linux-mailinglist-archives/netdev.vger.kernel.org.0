Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BC76EB573
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjDUXC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbjDUXCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:02:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 981002D40;
        Fri, 21 Apr 2023 16:02:25 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 15/20] netfilter: nf_tables: extended netlink error reporting for netdevice
Date:   Sat, 22 Apr 2023 01:02:06 +0200
Message-Id: <20230421230211.214635-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421230211.214635-1-pablo@netfilter.org>
References: <20230421230211.214635-1-pablo@netfilter.org>
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

Flowtable and netdev chains are bound to one or several netdevice,
extend netlink error reporting to specify the the netdevice that
triggers the error.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 38 ++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 44ebc5f9598e..0fd4e28fbb60 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1954,7 +1954,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 
 static int nf_tables_parse_netdev_hooks(struct net *net,
 					const struct nlattr *attr,
-					struct list_head *hook_list)
+					struct list_head *hook_list,
+					struct netlink_ext_ack *extack)
 {
 	struct nft_hook *hook, *next;
 	const struct nlattr *tmp;
@@ -1968,10 +1969,12 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 
 		hook = nft_netdev_hook_alloc(net, tmp);
 		if (IS_ERR(hook)) {
+			NL_SET_BAD_ATTR(extack, tmp);
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
 		if (nft_hook_list_find(hook_list, hook)) {
+			NL_SET_BAD_ATTR(extack, tmp);
 			kfree(hook);
 			err = -EEXIST;
 			goto err_hook;
@@ -2004,20 +2007,23 @@ struct nft_chain_hook {
 
 static int nft_chain_parse_netdev(struct net *net,
 				  struct nlattr *tb[],
-				  struct list_head *hook_list)
+				  struct list_head *hook_list,
+				  struct netlink_ext_ack *extack)
 {
 	struct nft_hook *hook;
 	int err;
 
 	if (tb[NFTA_HOOK_DEV]) {
 		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV]);
-		if (IS_ERR(hook))
+		if (IS_ERR(hook)) {
+			NL_SET_BAD_ATTR(extack, tb[NFTA_HOOK_DEV]);
 			return PTR_ERR(hook);
+		}
 
 		list_add_tail(&hook->list, hook_list);
 	} else if (tb[NFTA_HOOK_DEVS]) {
 		err = nf_tables_parse_netdev_hooks(net, tb[NFTA_HOOK_DEVS],
-						   hook_list);
+						   hook_list, extack);
 		if (err < 0)
 			return err;
 
@@ -2085,7 +2091,7 @@ static int nft_chain_parse_hook(struct net *net,
 
 	INIT_LIST_HEAD(&hook->list);
 	if (nft_base_chain_netdev(family, hook->num)) {
-		err = nft_chain_parse_netdev(net, ha, &hook->list);
+		err = nft_chain_parse_netdev(net, ha, &hook->list, extack);
 		if (err < 0) {
 			module_put(type->owner);
 			return err;
@@ -7560,7 +7566,8 @@ static const struct nla_policy nft_flowtable_hook_policy[NFTA_FLOWTABLE_HOOK_MAX
 static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 				    const struct nlattr *attr,
 				    struct nft_flowtable_hook *flowtable_hook,
-				    struct nft_flowtable *flowtable, bool add)
+				    struct nft_flowtable *flowtable,
+				    struct netlink_ext_ack *extack, bool add)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
 	struct nft_hook *hook;
@@ -7607,7 +7614,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 	if (tb[NFTA_FLOWTABLE_HOOK_DEVS]) {
 		err = nf_tables_parse_netdev_hooks(ctx->net,
 						   tb[NFTA_FLOWTABLE_HOOK_DEVS],
-						   &flowtable_hook->list);
+						   &flowtable_hook->list,
+						   extack);
 		if (err < 0)
 			return err;
 	}
@@ -7750,7 +7758,8 @@ static void nft_flowtable_hooks_destroy(struct list_head *hook_list)
 }
 
 static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
-				struct nft_flowtable *flowtable)
+				struct nft_flowtable *flowtable,
+				struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
@@ -7761,7 +7770,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, false);
+				       &flowtable_hook, flowtable, extack, false);
 	if (err < 0)
 		return err;
 
@@ -7866,7 +7875,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
-		return nft_flowtable_update(&ctx, info->nlh, flowtable);
+		return nft_flowtable_update(&ctx, info->nlh, flowtable, extack);
 	}
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
@@ -7907,7 +7916,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		goto err3;
 
 	err = nft_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, true);
+				       &flowtable_hook, flowtable, extack, true);
 	if (err < 0)
 		goto err4;
 
@@ -7959,7 +7968,8 @@ static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook
 }
 
 static int nft_delflowtable_hook(struct nft_ctx *ctx,
-				 struct nft_flowtable *flowtable)
+				 struct nft_flowtable *flowtable,
+				 struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
@@ -7969,7 +7979,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, false);
+				       &flowtable_hook, flowtable, extack, false);
 	if (err < 0)
 		return err;
 
@@ -8051,7 +8061,7 @@ static int nf_tables_delflowtable(struct sk_buff *skb,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	if (nla[NFTA_FLOWTABLE_HOOK])
-		return nft_delflowtable_hook(&ctx, flowtable);
+		return nft_delflowtable_hook(&ctx, flowtable, extack);
 
 	if (flowtable->use > 0) {
 		NL_SET_BAD_ATTR(extack, attr);
-- 
2.30.2


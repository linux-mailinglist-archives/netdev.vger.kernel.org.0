Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D51961BBA
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 10:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfGHI3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 04:29:39 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:5908 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfGHI3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 04:29:36 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A057E41C3F;
        Mon,  8 Jul 2019 16:29:29 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next 3/3] netfilter: nft_nat: add nft_bridge_nat_type support
Date:   Mon,  8 Jul 2019 16:29:27 +0800
Message-Id: <1562574567-8293-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
References: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlDS0tLS09PQ0lJTUJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nww6DQw*Qjg#Ig45EBhMSCgh
        IU0aC0NVSlVKTk1JTkxPTk1CQkpCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPT0o3Bg++
X-HM-Tid: 0a6bd0b3c1752086kuqya057e41c3f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nft_bridge_nat_type to configure nat rule in bridge family

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_nat.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index c3c93e9..ba396851 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -136,7 +136,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 
 	family = ntohl(nla_get_be32(tb[NFTA_NAT_FAMILY]));
-	if (ctx->family != NFPROTO_INET && ctx->family != family)
+	if (ctx->family != NFPROTO_INET &&
+	    ctx->family != NFPROTO_BRIDGE &&
+	    ctx->family != family)
 		return -EOPNOTSUPP;
 
 	switch (family) {
@@ -318,6 +320,40 @@ static void nft_nat_inet_module_exit(void)
 static void nft_nat_inet_module_exit(void) { }
 #endif
 
+#ifdef CONFIG_NF_TABLES_BRIDGE
+static const struct nft_expr_ops nft_nat_bridge_ops = {
+	.type           = &nft_nat_type,
+	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
+	.eval           = nft_nat_eval,
+	.init           = nft_nat_init,
+	.destroy        = nft_nat_destroy,
+	.dump           = nft_nat_dump,
+	.validate	= nft_nat_validate,
+};
+
+static struct nft_expr_type nft_bridge_nat_type __read_mostly = {
+	.name           = "nat",
+	.family		= NFPROTO_BRIDGE,
+	.ops            = &nft_nat_bridge_ops,
+	.policy         = nft_nat_policy,
+	.maxattr        = NFTA_NAT_MAX,
+	.owner          = THIS_MODULE,
+};
+
+static int nft_nat_bridge_module_init(void)
+{
+	return nft_register_expr(&nft_bridge_nat_type);
+}
+
+static void nft_nat_bridge_module_exit(void)
+{
+	nft_unregister_expr(&nft_bridge_nat_type);
+}
+#else
+static int nft_nat_bridge_module_init(void) { return 0; }
+static void nft_nat_bridge_module_exit(void) { }
+#endif
+
 static int __init nft_nat_module_init(void)
 {
 	int ret = nft_nat_inet_module_init();
@@ -325,15 +361,24 @@ static int __init nft_nat_module_init(void)
 	if (ret)
 		return ret;
 
+	ret = nft_nat_bridge_module_init();
+	if (ret) {
+		nft_nat_inet_module_exit();
+		return ret;
+	}
+
 	ret = nft_register_expr(&nft_nat_type);
-	if (ret)
+	if (ret) {
+		nft_nat_bridge_module_exit();
 		nft_nat_inet_module_exit();
+	}
 
 	return ret;
 }
 
 static void __exit nft_nat_module_exit(void)
 {
+	nft_nat_bridge_module_exit();
 	nft_nat_inet_module_exit();
 	nft_unregister_expr(&nft_nat_type);
 }
-- 
1.8.3.1


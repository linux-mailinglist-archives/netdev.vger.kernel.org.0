Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E6161BB7
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 10:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbfGHI3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 04:29:36 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:5906 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727551AbfGHI3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 04:29:35 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 037A041CE1;
        Mon,  8 Jul 2019 16:29:28 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next 2/3] netfilter: nft_chain_nat: add nft_chain_nat_bridge support
Date:   Mon,  8 Jul 2019 16:29:26 +0800
Message-Id: <1562574567-8293-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
References: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJDS0tLS0xIT0hJQklZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NhQ6ODo6Ejg*HA4jEBhOSBg1
        LxwwCUlVSlVKTk1JTkxPTk1CSElIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlDS043Bg++
X-HM-Tid: 0a6bd0b3bef32086kuqy037a041ce1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nft_chan_nat_bridge to handle nat rule in bridge family

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_chain_nat.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index 2f89bde..2ae3fbb 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -104,6 +104,23 @@ static void nft_nat_inet_unreg(struct net *net, const struct nf_hook_ops *ops)
 };
 #endif
 
+#ifdef CONFIG_NF_TABLES_BRIDGE
+static const struct nft_chain_type nft_chain_nat_bridge = {
+	.name		= "nat",
+	.type		= NFT_CHAIN_T_NAT,
+	.family		= NFPROTO_BRIDGE,
+	.owner		= THIS_MODULE,
+	.hook_mask	= (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_POST_ROUTING),
+	.hooks		= {
+		[NF_INET_PRE_ROUTING]	= nft_nat_do_chain,
+		[NF_INET_POST_ROUTING]	= nft_nat_do_chain,
+	},
+	.ops_register = nf_nat_bridge_register_fn,
+	.ops_unregister = nf_nat_bridge_unregister_fn,
+};
+#endif
+
 static int __init nft_chain_nat_init(void)
 {
 #ifdef CONFIG_NF_TABLES_IPV6
@@ -115,6 +132,9 @@ static int __init nft_chain_nat_init(void)
 #ifdef CONFIG_NF_TABLES_INET
 	nft_register_chain_type(&nft_chain_nat_inet);
 #endif
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	nft_register_chain_type(&nft_chain_nat_bridge);
+#endif
 
 	return 0;
 }
@@ -130,6 +150,9 @@ static void __exit nft_chain_nat_exit(void)
 #ifdef CONFIG_NF_TABLES_INET
 	nft_unregister_chain_type(&nft_chain_nat_inet);
 #endif
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	nft_unregister_chain_type(&nft_chain_nat_bridge);
+#endif
 }
 
 module_init(nft_chain_nat_init);
@@ -142,3 +165,6 @@ static void __exit nft_chain_nat_exit(void)
 #ifdef CONFIG_NF_TABLES_IPV6
 MODULE_ALIAS_NFT_CHAIN(AF_INET6, "nat");
 #endif
+#ifdef CONFIG_NF_TABLES_BRIDGE
+MODULE_ALIAS_NFT_CHAIN(AF_BRIDGE, "nat");
+#endif
-- 
1.8.3.1


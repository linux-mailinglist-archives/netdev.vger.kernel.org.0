Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B33261BB6
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 10:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbfGHI3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 04:29:34 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:5904 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfGHI3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 04:29:34 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9C87D41CE3;
        Mon,  8 Jul 2019 16:29:28 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next 1/3] netfilter: nf_nat_proto: add nf_nat_bridge_ops support
Date:   Mon,  8 Jul 2019 16:29:25 +0800
Message-Id: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0tCQkJDQkNCSktOSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MS46KCo*Cjg2UQ49Ph8KSCEt
        Kx5PFEhVSlVKTk1JTkxPTk1DQ0NCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhMTk83Bg++
X-HM-Tid: 0a6bd0b3bd912086kuqy9c87d41ce3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_nat_bridge_ops to do nat in the bridge family

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_nat.h |  3 ++
 net/netfilter/nf_nat_proto.c   | 63 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 423cda2..0c2d326 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -101,6 +101,9 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
 int nf_nat_inet_register_fn(struct net *net, const struct nf_hook_ops *ops);
 void nf_nat_inet_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 
+int nf_nat_bridge_register_fn(struct net *net, const struct nf_hook_ops *ops);
+void nf_nat_bridge_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
+
 unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 888292e..652a71e 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -1035,3 +1035,66 @@ void nf_nat_inet_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
 }
 EXPORT_SYMBOL_GPL(nf_nat_inet_unregister_fn);
 #endif /* NFT INET NAT */
+
+#if defined(CONFIG_NF_TABLES_BRIDGE) && IS_ENABLED(CONFIG_NFT_NAT)
+static unsigned int
+nf_nat_bridge_in(void *priv, struct sk_buff *skb,
+		 const struct nf_hook_state *state)
+{
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return nf_nat_ipv4_in(priv, skb, state);
+	case htons(ETH_P_IPV6):
+		return nf_nat_ipv6_in(priv, skb, state);
+	default:
+		return NF_ACCEPT;
+	}
+}
+
+static unsigned int
+nf_nat_bridge_out(void *priv, struct sk_buff *skb,
+		  const struct nf_hook_state *state)
+{
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return nf_nat_ipv4_out(priv, skb, state);
+	case htons(ETH_P_IPV6):
+		return nf_nat_ipv6_out(priv, skb, state);
+	default:
+		return NF_ACCEPT;
+	}
+}
+
+const struct nf_hook_ops nf_nat_bridge_ops[] = {
+	/* Before packet filtering, change destination */
+	{
+		.hook		= nf_nat_bridge_in,
+		.pf		= NFPROTO_BRIDGE,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP_PRI_NAT_DST,
+	},
+	/* After packet filtering, change source */
+	{
+		.hook		= nf_nat_bridge_out,
+		.pf		= NFPROTO_BRIDGE,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP_PRI_NAT_SRC,
+	},
+};
+
+int nf_nat_bridge_register_fn(struct net *net, const struct nf_hook_ops *ops)
+{
+	if (WARN_ON_ONCE(ops->pf != NFPROTO_BRIDGE))
+		return -EINVAL;
+
+	return nf_nat_register_fn(net, ops->pf, ops, nf_nat_bridge_ops,
+				  ARRAY_SIZE(nf_nat_bridge_ops));
+}
+EXPORT_SYMBOL_GPL(nf_nat_bridge_register_fn);
+
+void nf_nat_bridge_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
+{
+	nf_nat_unregister_fn(net, ops->pf, ops, ARRAY_SIZE(nf_nat_bridge_ops));
+}
+EXPORT_SYMBOL_GPL(nf_nat_bridge_unregister_fn);
+#endif
-- 
1.8.3.1


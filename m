Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6998161D01
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfGHKcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:32:55 -0400
Received: from mail.us.es ([193.147.175.20]:34262 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729429AbfGHKcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 73DB2BAE97
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D4B26E7AC
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 52644DA732; Mon,  8 Jul 2019 12:32:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3A036DA6D;
        Mon,  8 Jul 2019 12:32:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C5DF04265A2F;
        Mon,  8 Jul 2019 12:32:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/15] netfilter: nft_meta: move bridge meta keys into nft_meta_bridge
Date:   Mon,  8 Jul 2019 12:32:29 +0200
Message-Id: <20190708103237.28061-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Separate bridge meta key from nft_meta to meta_bridge to avoid a
dependency between the bridge module and nft_meta when using the bridge
API available through include/linux/if_bridge.h

Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nft_meta.h       |  44 ++++++++++++
 net/bridge/netfilter/Kconfig           |   6 ++
 net/bridge/netfilter/Makefile          |   1 +
 net/bridge/netfilter/nft_meta_bridge.c | 127 +++++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_core.c         |   1 +
 net/netfilter/nft_meta.c               |  81 ++++++++-------------
 6 files changed, 207 insertions(+), 53 deletions(-)
 create mode 100644 include/net/netfilter/nft_meta.h
 create mode 100644 net/bridge/netfilter/nft_meta_bridge.c

diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
new file mode 100644
index 000000000000..5c69e9b09388
--- /dev/null
+++ b/include/net/netfilter/nft_meta.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NFT_META_H_
+#define _NFT_META_H_
+
+struct nft_meta {
+	enum nft_meta_keys	key:8;
+	union {
+		enum nft_registers	dreg:8;
+		enum nft_registers	sreg:8;
+	};
+};
+
+extern const struct nla_policy nft_meta_policy[];
+
+int nft_meta_get_init(const struct nft_ctx *ctx,
+		      const struct nft_expr *expr,
+		      const struct nlattr * const tb[]);
+
+int nft_meta_set_init(const struct nft_ctx *ctx,
+		      const struct nft_expr *expr,
+		      const struct nlattr * const tb[]);
+
+int nft_meta_get_dump(struct sk_buff *skb,
+		      const struct nft_expr *expr);
+
+int nft_meta_set_dump(struct sk_buff *skb,
+		      const struct nft_expr *expr);
+
+void nft_meta_get_eval(const struct nft_expr *expr,
+		       struct nft_regs *regs,
+		       const struct nft_pktinfo *pkt);
+
+void nft_meta_set_eval(const struct nft_expr *expr,
+		       struct nft_regs *regs,
+		       const struct nft_pktinfo *pkt);
+
+void nft_meta_set_destroy(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr);
+
+int nft_meta_set_validate(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr,
+			  const struct nft_data **data);
+
+#endif
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index f4fb0b9b927d..fbc708508360 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -9,6 +9,12 @@ menuconfig NF_TABLES_BRIDGE
 	bool "Ethernet Bridge nf_tables support"
 
 if NF_TABLES_BRIDGE
+
+config NFT_BRIDGE_META
+	tristate "Netfilter nf_table bridge meta support"
+	help
+	  Add support for bridge dedicated meta key.
+
 config NFT_BRIDGE_REJECT
 	tristate "Netfilter nf_tables bridge reject support"
 	depends on NFT_REJECT && NFT_REJECT_IPV4 && NFT_REJECT_IPV6
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 9d7767322a64..8e2c5759d964 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -3,6 +3,7 @@
 # Makefile for the netfilter modules for Link Layer filtering on a bridge.
 #
 
+obj-$(CONFIG_NFT_BRIDGE_META)  += nft_meta_bridge.o
 obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 
 # connection tracking
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
new file mode 100644
index 000000000000..dde8651254ac
--- /dev/null
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nft_meta.h>
+
+#include "../br_private.h"
+
+static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
+				     struct nft_regs *regs,
+				     const struct nft_pktinfo *pkt)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
+	u32 *dest = &regs->data[priv->dreg];
+	const struct net_bridge_port *p;
+
+	switch (priv->key) {
+	case NFT_META_BRI_IIFNAME:
+		if (in == NULL || (p = br_port_get_rcu(in)) == NULL)
+			goto err;
+		break;
+	case NFT_META_BRI_OIFNAME:
+		if (out == NULL || (p = br_port_get_rcu(out)) == NULL)
+			goto err;
+		break;
+	default:
+		goto out;
+	}
+
+	strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
+	return;
+out:
+	return nft_meta_get_eval(expr, regs, pkt);
+err:
+	regs->verdict.code = NFT_BREAK;
+}
+
+static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr,
+				    const struct nlattr * const tb[])
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	unsigned int len;
+
+	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
+	switch (priv->key) {
+	case NFT_META_BRI_IIFNAME:
+	case NFT_META_BRI_OIFNAME:
+		len = IFNAMSIZ;
+		break;
+	default:
+		return nft_meta_get_init(ctx, expr, tb);
+	}
+
+	priv->dreg = nft_parse_register(tb[NFTA_META_DREG]);
+	return nft_validate_register_store(ctx, priv->dreg, NULL,
+					   NFT_DATA_VALUE, len);
+}
+
+static struct nft_expr_type nft_meta_bridge_type;
+static const struct nft_expr_ops nft_meta_bridge_get_ops = {
+	.type		= &nft_meta_bridge_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
+	.eval		= nft_meta_bridge_get_eval,
+	.init		= nft_meta_bridge_get_init,
+	.dump		= nft_meta_get_dump,
+};
+
+static const struct nft_expr_ops nft_meta_bridge_set_ops = {
+	.type		= &nft_meta_bridge_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
+	.eval		= nft_meta_set_eval,
+	.init		= nft_meta_set_init,
+	.destroy	= nft_meta_set_destroy,
+	.dump		= nft_meta_set_dump,
+	.validate	= nft_meta_set_validate,
+};
+
+static const struct nft_expr_ops *
+nft_meta_bridge_select_ops(const struct nft_ctx *ctx,
+			   const struct nlattr * const tb[])
+{
+	if (tb[NFTA_META_KEY] == NULL)
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_META_DREG] && tb[NFTA_META_SREG])
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_META_DREG])
+		return &nft_meta_bridge_get_ops;
+
+	if (tb[NFTA_META_SREG])
+		return &nft_meta_bridge_set_ops;
+
+	return ERR_PTR(-EINVAL);
+}
+
+static struct nft_expr_type nft_meta_bridge_type __read_mostly = {
+	.family         = NFPROTO_BRIDGE,
+	.name           = "meta",
+	.select_ops     = nft_meta_bridge_select_ops,
+	.policy         = nft_meta_policy,
+	.maxattr        = NFTA_META_MAX,
+	.owner          = THIS_MODULE,
+};
+
+static int __init nft_meta_bridge_module_init(void)
+{
+	return nft_register_expr(&nft_meta_bridge_type);
+}
+
+static void __exit nft_meta_bridge_module_exit(void)
+{
+	nft_unregister_expr(&nft_meta_bridge_type);
+}
+
+module_init(nft_meta_bridge_module_init);
+module_exit(nft_meta_bridge_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("wenxu <wenxu@ucloud.cn>");
+MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "meta");
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index b950cd31348b..96c74c4c7176 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -19,6 +19,7 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_log.h>
+#include <net/netfilter/nft_meta.h>
 
 static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 					const struct nft_chain *chain,
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index a54329b8634a..18a848b01759 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -21,23 +21,12 @@
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nft_meta.h>
 
 #include <uapi/linux/netfilter_bridge.h> /* NF_BR_PRE_ROUTING */
 
-struct nft_meta {
-	enum nft_meta_keys	key:8;
-	union {
-		enum nft_registers	dreg:8;
-		enum nft_registers	sreg:8;
-	};
-};
-
 static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
 
-#ifdef CONFIG_NF_TABLES_BRIDGE
-#include "../bridge/br_private.h"
-#endif
-
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -47,9 +36,6 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
 	struct sock *sk;
 	u32 *dest = &regs->data[priv->dreg];
-#ifdef CONFIG_NF_TABLES_BRIDGE
-	const struct net_bridge_port *p;
-#endif
 
 	switch (priv->key) {
 	case NFT_META_LEN:
@@ -229,18 +215,6 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store8(dest, secpath_exists(skb));
 		break;
 #endif
-#ifdef CONFIG_NF_TABLES_BRIDGE
-	case NFT_META_BRI_IIFNAME:
-		if (in == NULL || (p = br_port_get_rcu(in)) == NULL)
-			goto err;
-		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
-		return;
-	case NFT_META_BRI_OIFNAME:
-		if (out == NULL || (p = br_port_get_rcu(out)) == NULL)
-			goto err;
-		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
-		return;
-#endif
 	case NFT_META_IIFKIND:
 		if (in == NULL || in->rtnl_link_ops == NULL)
 			goto err;
@@ -260,10 +234,11 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 err:
 	regs->verdict.code = NFT_BREAK;
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_eval);
 
-static void nft_meta_set_eval(const struct nft_expr *expr,
-			      struct nft_regs *regs,
-			       const struct nft_pktinfo *pkt)
+void nft_meta_set_eval(const struct nft_expr *expr,
+		       struct nft_regs *regs,
+		       const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *meta = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
@@ -300,16 +275,18 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 		WARN_ON(1);
 	}
 }
+EXPORT_SYMBOL_GPL(nft_meta_set_eval);
 
-static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
+const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
 	[NFTA_META_DREG]	= { .type = NLA_U32 },
 	[NFTA_META_KEY]		= { .type = NLA_U32 },
 	[NFTA_META_SREG]	= { .type = NLA_U32 },
 };
+EXPORT_SYMBOL_GPL(nft_meta_policy);
 
-static int nft_meta_get_init(const struct nft_ctx *ctx,
-			     const struct nft_expr *expr,
-			     const struct nlattr * const tb[])
+int nft_meta_get_init(const struct nft_ctx *ctx,
+		      const struct nft_expr *expr,
+		      const struct nlattr * const tb[])
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int len;
@@ -360,14 +337,6 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = sizeof(u8);
 		break;
 #endif
-#ifdef CONFIG_NF_TABLES_BRIDGE
-	case NFT_META_BRI_IIFNAME:
-	case NFT_META_BRI_OIFNAME:
-		if (ctx->family != NFPROTO_BRIDGE)
-			return -EOPNOTSUPP;
-		len = IFNAMSIZ;
-		break;
-#endif
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -376,6 +345,7 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, len);
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_init);
 
 static int nft_meta_get_validate(const struct nft_ctx *ctx,
 				 const struct nft_expr *expr,
@@ -409,9 +379,9 @@ static int nft_meta_get_validate(const struct nft_ctx *ctx,
 #endif
 }
 
-static int nft_meta_set_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nft_data **data)
+int nft_meta_set_validate(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr,
+			  const struct nft_data **data)
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
@@ -437,10 +407,11 @@ static int nft_meta_set_validate(const struct nft_ctx *ctx,
 
 	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
+EXPORT_SYMBOL_GPL(nft_meta_set_validate);
 
-static int nft_meta_set_init(const struct nft_ctx *ctx,
-			     const struct nft_expr *expr,
-			     const struct nlattr * const tb[])
+int nft_meta_set_init(const struct nft_ctx *ctx,
+		      const struct nft_expr *expr,
+		      const struct nlattr * const tb[])
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int len;
@@ -475,9 +446,10 @@ static int nft_meta_set_init(const struct nft_ctx *ctx,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nft_meta_set_init);
 
-static int nft_meta_get_dump(struct sk_buff *skb,
-			     const struct nft_expr *expr)
+int nft_meta_get_dump(struct sk_buff *skb,
+		      const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -490,8 +462,9 @@ static int nft_meta_get_dump(struct sk_buff *skb,
 nla_put_failure:
 	return -1;
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_dump);
 
-static int nft_meta_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
+int nft_meta_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -505,15 +478,17 @@ static int nft_meta_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
 nla_put_failure:
 	return -1;
 }
+EXPORT_SYMBOL_GPL(nft_meta_set_dump);
 
-static void nft_meta_set_destroy(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr)
+void nft_meta_set_destroy(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
 	if (priv->key == NFT_META_NFTRACE)
 		static_branch_dec(&nft_trace_enabled);
 }
+EXPORT_SYMBOL_GPL(nft_meta_set_destroy);
 
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
-- 
2.11.0


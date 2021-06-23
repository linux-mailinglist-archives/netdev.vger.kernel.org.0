Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A033B1F2F
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhFWRFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:05:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33528 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhFWRFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 13:05:30 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A54686427C;
        Wed, 23 Jun 2021 19:01:46 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 3/6] netfilter: nf_tables: add last expression
Date:   Wed, 23 Jun 2021 19:02:58 +0200
Message-Id: <20210623170301.59973-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623170301.59973-1-pablo@netfilter.org>
References: <20210623170301.59973-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new optional expression that tells you when last matching on a
given rule / set element element has happened.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h   |  1 +
 include/uapi/linux/netfilter/nf_tables.h | 15 ++++
 net/netfilter/Makefile                   |  2 +-
 net/netfilter/nf_tables_core.c           |  1 +
 net/netfilter/nft_last.c                 | 87 ++++++++++++++++++++++++
 5 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100644 net/netfilter/nft_last.c

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 46c8d5bb5d8d..0fa5a6d98a00 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -16,6 +16,7 @@ extern struct nft_expr_type nft_range_type;
 extern struct nft_expr_type nft_meta_type;
 extern struct nft_expr_type nft_rt_type;
 extern struct nft_expr_type nft_exthdr_type;
+extern struct nft_expr_type nft_last_type;
 
 #ifdef CONFIG_NETWORK_SECMARK
 extern struct nft_object_type nft_secmark_obj_type;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 19715e2679d1..e94d1fa554cb 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1195,6 +1195,21 @@ enum nft_counter_attributes {
 };
 #define NFTA_COUNTER_MAX	(__NFTA_COUNTER_MAX - 1)
 
+/**
+ * enum nft_last_attributes - nf_tables last expression netlink attributes
+ *
+ * @NFTA_LAST_SET: last update has been set, zero means never updated (NLA_U32)
+ * @NFTA_LAST_MSECS: milliseconds since last update (NLA_U64)
+ */
+enum nft_last_attributes {
+	NFTA_LAST_UNSPEC,
+	NFTA_LAST_SET,
+	NFTA_LAST_MSECS,
+	NFTA_LAST_PAD,
+	__NFTA_LAST_MAX
+};
+#define NFTA_LAST_MAX	(__NFTA_LAST_MAX - 1)
+
 /**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 87112dad1fd4..049890e00a3d 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -74,7 +74,7 @@ obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
 		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
-		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o \
+		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o nft_last.o \
 		  nft_chain_route.o nf_tables_offload.o \
 		  nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
 		  nft_set_pipapo.o
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 7780342e2f2d..866cfba04d6c 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -268,6 +268,7 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_meta_type,
 	&nft_rt_type,
 	&nft_exthdr_type,
+	&nft_last_type,
 };
 
 static struct nft_object_type *nft_basic_objects[] = {
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
new file mode 100644
index 000000000000..913ac45167f2
--- /dev/null
+++ b/net/netfilter/nft_last.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_tables.h>
+
+struct nft_last_priv {
+	unsigned long	last_jiffies;
+	unsigned int	last_set;
+};
+
+static const struct nla_policy nft_last_policy[NFTA_LAST_MAX + 1] = {
+	[NFTA_LAST_SET] = { .type = NLA_U32 },
+	[NFTA_LAST_MSECS] = { .type = NLA_U64 },
+};
+
+static int nft_last_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+			 const struct nlattr * const tb[])
+{
+	struct nft_last_priv *priv = nft_expr_priv(expr);
+	u64 last_jiffies;
+	int err;
+
+	if (tb[NFTA_LAST_MSECS]) {
+		err = nf_msecs_to_jiffies64(tb[NFTA_LAST_MSECS], &last_jiffies);
+		if (err < 0)
+			return err;
+
+		priv->last_jiffies = jiffies + (unsigned long)last_jiffies;
+		priv->last_set = 1;
+	}
+
+	return 0;
+}
+
+static void nft_last_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs, const struct nft_pktinfo *pkt)
+{
+	struct nft_last_priv *priv = nft_expr_priv(expr);
+
+	priv->last_jiffies = jiffies;
+	priv->last_set = 1;
+}
+
+static int nft_last_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_last_priv *priv = nft_expr_priv(expr);
+	__be64 msecs;
+
+	if (time_before(jiffies, priv->last_jiffies))
+		priv->last_set = 0;
+
+	if (priv->last_set)
+		msecs = nf_jiffies64_to_msecs(jiffies - priv->last_jiffies);
+	else
+		msecs = 0;
+
+	if (nla_put_be32(skb, NFTA_LAST_SET, htonl(priv->last_set)) ||
+	    nla_put_be64(skb, NFTA_LAST_MSECS, msecs, NFTA_LAST_PAD))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nft_expr_ops nft_last_ops = {
+	.type		= &nft_last_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_last_priv)),
+	.eval		= nft_last_eval,
+	.init		= nft_last_init,
+	.dump		= nft_last_dump,
+};
+
+struct nft_expr_type nft_last_type __read_mostly = {
+	.name		= "last",
+	.ops		= &nft_last_ops,
+	.policy		= nft_last_policy,
+	.maxattr	= NFTA_LAST_MAX,
+	.flags		= NFT_EXPR_STATEFUL,
+	.owner		= THIS_MODULE,
+};
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5981612CF75
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 12:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfL3LWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 06:22:12 -0500
Received: from correo.us.es ([193.147.175.20]:59448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbfL3LWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3FB124DE72A
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30237DA701
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 24242DA709; Mon, 30 Dec 2019 12:22:08 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6D37DA705;
        Mon, 30 Dec 2019 12:22:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:22:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5B9E941E4800;
        Mon, 30 Dec 2019 12:22:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/17] netfilter: nft_meta: add support for slave device ifindex matching
Date:   Mon, 30 Dec 2019 12:21:43 +0100
Message-Id: <20191230112143.121708-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Allow to match on vrf slave ifindex or name.

In case there was no slave interface involved, store 0 in the
destination register just like existing iif/oif matching.

sdif(name) is restricted to the ipv4/ipv6 input and forward hooks,
as it depends on ip(6) stack parsing/storing info in skb->cb[].

Cc: Martin Willi <martin@strongswan.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Shrijeet Mukherjee <shrijeet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++
 net/netfilter/nft_meta.c                 | 76 +++++++++++++++++++++++++++++---
 2 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index bb9b049310df..e237ecbdcd8a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -805,6 +805,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_TIME_NS: time since epoch (in nanoseconds)
  * @NFT_META_TIME_DAY: day of week (from 0 = Sunday to 6 = Saturday)
  * @NFT_META_TIME_HOUR: hour of day (in seconds)
+ * @NFT_META_SDIF: slave device interface index
+ * @NFT_META_SDIFNAME: slave device interface name
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -840,6 +842,8 @@ enum nft_meta_keys {
 	NFT_META_TIME_NS,
 	NFT_META_TIME_DAY,
 	NFT_META_TIME_HOUR,
+	NFT_META_SDIF,
+	NFT_META_SDIFNAME,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index fb1a571db924..951b6e87ed5d 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -17,6 +17,7 @@
 #include <linux/smp.h>
 #include <linux/static_key.h>
 #include <net/dst.h>
+#include <net/ip.h>
 #include <net/sock.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
@@ -287,6 +288,28 @@ nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
 }
 #endif
 
+static noinline u32 nft_meta_get_eval_sdif(const struct nft_pktinfo *pkt)
+{
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		return inet_sdif(pkt->skb);
+	case NFPROTO_IPV6:
+		return inet6_sdif(pkt->skb);
+	}
+
+	return 0;
+}
+
+static noinline void
+nft_meta_get_eval_sdifname(u32 *dest, const struct nft_pktinfo *pkt)
+{
+	u32 sdif = nft_meta_get_eval_sdif(pkt);
+	const struct net_device *dev;
+
+	dev = sdif ? dev_get_by_index_rcu(nft_net(pkt), sdif) : NULL;
+	nft_meta_store_ifname(dest, dev);
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -379,6 +402,12 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	case NFT_META_TIME_HOUR:
 		nft_meta_get_eval_time(priv->key, dest);
 		break;
+	case NFT_META_SDIF:
+		*dest = nft_meta_get_eval_sdif(pkt);
+		break;
+	case NFT_META_SDIFNAME:
+		nft_meta_get_eval_sdifname(dest, pkt);
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -459,6 +488,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	case NFT_META_MARK:
 	case NFT_META_IIF:
 	case NFT_META_OIF:
+	case NFT_META_SDIF:
 	case NFT_META_SKUID:
 	case NFT_META_SKGID:
 #ifdef CONFIG_IP_ROUTE_CLASSID
@@ -480,6 +510,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	case NFT_META_OIFNAME:
 	case NFT_META_IIFKIND:
 	case NFT_META_OIFKIND:
+	case NFT_META_SDIFNAME:
 		len = IFNAMSIZ;
 		break;
 	case NFT_META_PRANDOM:
@@ -510,16 +541,28 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_init);
 
-static int nft_meta_get_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nft_data **data)
+static int nft_meta_get_validate_sdif(const struct nft_ctx *ctx)
 {
-#ifdef CONFIG_XFRM
-	const struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
 
-	if (priv->key != NFT_META_SECPATH)
-		return 0;
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		hooks = (1 << NF_INET_LOCAL_IN) |
+			(1 << NF_INET_FORWARD);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
+static int nft_meta_get_validate_xfrm(const struct nft_ctx *ctx)
+{
+#ifdef CONFIG_XFRM
+	unsigned int hooks;
 
 	switch (ctx->family) {
 	case NFPROTO_NETDEV:
@@ -542,6 +585,25 @@ static int nft_meta_get_validate(const struct nft_ctx *ctx,
 #endif
 }
 
+static int nft_meta_get_validate(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 const struct nft_data **data)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+
+	switch (priv->key) {
+	case NFT_META_SECPATH:
+		return nft_meta_get_validate_xfrm(ctx);
+	case NFT_META_SDIF:
+	case NFT_META_SDIFNAME:
+		return nft_meta_get_validate_sdif(ctx);
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nft_data **data)
-- 
2.11.0


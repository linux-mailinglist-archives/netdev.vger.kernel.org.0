Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2F012CF72
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 12:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfL3LWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 06:22:08 -0500
Received: from correo.us.es ([193.147.175.20]:59448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727488AbfL3LWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 135704DE741
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F339BDA729
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E88FADA71A; Mon, 30 Dec 2019 12:22:04 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D1788DA70E;
        Mon, 30 Dec 2019 12:22:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:22:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 42E4B41E4800;
        Mon, 30 Dec 2019 12:22:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 14/17] netfilter: nft_meta: move all interface related keys to helper
Date:   Mon, 30 Dec 2019 12:21:40 +0100
Message-Id: <20191230112143.121708-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Reduces repetiveness and reduces size of meta eval function.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 95 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 70 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 2f7cc64b0c15..022f1473ddd1 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -199,13 +199,79 @@ static noinline bool nft_meta_get_eval_kind(enum nft_meta_keys key,
 	return true;
 }
 
+static void nft_meta_store_ifindex(u32 *dest, const struct net_device *dev)
+{
+	*dest = dev ? dev->ifindex : 0;
+}
+
+static void nft_meta_store_ifname(u32 *dest, const struct net_device *dev)
+{
+	strncpy((char *)dest, dev ? dev->name : "", IFNAMSIZ);
+}
+
+static bool nft_meta_store_iftype(u32 *dest, const struct net_device *dev)
+{
+	if (!dev)
+		return false;
+
+	nft_reg_store16(dest, dev->type);
+	return true;
+}
+
+static bool nft_meta_store_ifgroup(u32 *dest, const struct net_device *dev)
+{
+	if (!dev)
+		return false;
+
+	*dest = dev->group;
+	return true;
+}
+
+static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
+				     const struct nft_pktinfo *pkt)
+{
+	switch (key) {
+	case NFT_META_IIFNAME:
+		nft_meta_store_ifname(dest, nft_in(pkt));
+		break;
+	case NFT_META_OIFNAME:
+		nft_meta_store_ifname(dest, nft_out(pkt));
+		break;
+	case NFT_META_IIF:
+		nft_meta_store_ifindex(dest, nft_in(pkt));
+		break;
+	case NFT_META_OIF:
+		nft_meta_store_ifindex(dest, nft_out(pkt));
+		break;
+	case NFT_META_IIFTYPE:
+		if (!nft_meta_store_iftype(dest, nft_in(pkt)))
+			return false;
+		break;
+	case NFT_META_OIFTYPE:
+		if (!nft_meta_store_iftype(dest, nft_out(pkt)))
+			return false;
+		break;
+	case NFT_META_IIFGROUP:
+		if (!nft_meta_store_ifgroup(dest, nft_out(pkt)))
+			return false;
+		break;
+	case NFT_META_OIFGROUP:
+		if (!nft_meta_store_ifgroup(dest, nft_out(pkt)))
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
 	u32 *dest = &regs->data[priv->dreg];
 
 	switch (priv->key) {
@@ -230,26 +296,15 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*dest = skb->mark;
 		break;
 	case NFT_META_IIF:
-		*dest = in ? in->ifindex : 0;
-		break;
 	case NFT_META_OIF:
-		*dest = out ? out->ifindex : 0;
-		break;
 	case NFT_META_IIFNAME:
-		strncpy((char *)dest, in ? in->name : "", IFNAMSIZ);
-		break;
 	case NFT_META_OIFNAME:
-		strncpy((char *)dest, out ? out->name : "", IFNAMSIZ);
-		break;
 	case NFT_META_IIFTYPE:
-		if (in == NULL)
-			goto err;
-		nft_reg_store16(dest, in->type);
-		break;
 	case NFT_META_OIFTYPE:
-		if (out == NULL)
+	case NFT_META_IIFGROUP:
+	case NFT_META_OIFGROUP:
+		if (!nft_meta_get_eval_ifname(priv->key, dest, pkt))
 			goto err;
-		nft_reg_store16(dest, out->type);
 		break;
 	case NFT_META_SKUID:
 	case NFT_META_SKGID:
@@ -283,16 +338,6 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	case NFT_META_CPU:
 		*dest = raw_smp_processor_id();
 		break;
-	case NFT_META_IIFGROUP:
-		if (in == NULL)
-			goto err;
-		*dest = in->group;
-		break;
-	case NFT_META_OIFGROUP:
-		if (out == NULL)
-			goto err;
-		*dest = out->group;
-		break;
 #ifdef CONFIG_CGROUP_NET_CLASSID
 	case NFT_META_CGROUP:
 		if (!nft_meta_get_eval_cgroup(dest, pkt))
-- 
2.11.0


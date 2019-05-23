Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B7728C79
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388404AbfEWVgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:36:17 -0400
Received: from mail.us.es ([193.147.175.20]:46954 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387447AbfEWVf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 17:35:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7E81AC1A74
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D32CDA70A
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 62615DA708; Thu, 23 May 2019 23:35:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12DE0DA702;
        Thu, 23 May 2019 23:35:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DE0094265A32;
        Thu, 23 May 2019 23:35:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/11] netfilter: nft_fib: Fix existence check support
Date:   Thu, 23 May 2019 23:35:39 +0200
Message-Id: <20190523213547.15523-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523213547.15523-1-pablo@netfilter.org>
References: <20190523213547.15523-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

NFTA_FIB_F_PRESENT flag was not always honored since eval functions did
not call nft_fib_store_result in all cases.

Given that in all callsites there is a struct net_device pointer
available which holds the interface data to be stored in destination
register, simplify nft_fib_store_result() to just accept that pointer
instead of the nft_pktinfo pointer and interface index. This also
allows to drop the index to interface lookup previously needed to get
the name associated with given index.

Fixes: 055c4b34b94f6 ("netfilter: nft_fib: Support existence check")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nft_fib.h   |  2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c | 23 +++--------------------
 net/ipv6/netfilter/nft_fib_ipv6.c | 16 ++--------------
 net/netfilter/nft_fib.c           |  6 +++---
 4 files changed, 9 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index a88f92737308..e4c4d8eaca8c 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -34,5 +34,5 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt);
 
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
-			  const struct nft_pktinfo *pkt, int index);
+			  const struct net_device *dev);
 #endif
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 94eb25bc8d7e..c8888e52591f 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -58,11 +58,6 @@ void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval_type);
 
-static int get_ifindex(const struct net_device *dev)
-{
-	return dev ? dev->ifindex : 0;
-}
-
 void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt)
 {
@@ -94,8 +89,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, pkt,
-				     nft_in(pkt)->ifindex);
+		nft_fib_store_result(dest, priv, nft_in(pkt));
 		return;
 	}
 
@@ -108,8 +102,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (ipv4_is_zeronet(iph->saddr)) {
 		if (ipv4_is_lbcast(iph->daddr) ||
 		    ipv4_is_local_multicast(iph->daddr)) {
-			nft_fib_store_result(dest, priv, pkt,
-					     get_ifindex(pkt->skb->dev));
+			nft_fib_store_result(dest, priv, pkt->skb->dev);
 			return;
 		}
 	}
@@ -150,17 +143,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		found = oif;
 	}
 
-	switch (priv->result) {
-	case NFT_FIB_RESULT_OIF:
-		*dest = found->ifindex;
-		break;
-	case NFT_FIB_RESULT_OIFNAME:
-		strncpy((char *)dest, found->name, IFNAMSIZ);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
+	nft_fib_store_result(dest, priv, found);
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval);
 
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 73cdc0bc63f7..ec068b0cffca 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -169,8 +169,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, pkt,
-				     nft_in(pkt)->ifindex);
+		nft_fib_store_result(dest, priv, nft_in(pkt));
 		return;
 	}
 
@@ -187,18 +186,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (oif && oif != rt->rt6i_idev->dev)
 		goto put_rt_err;
 
-	switch (priv->result) {
-	case NFT_FIB_RESULT_OIF:
-		*dest = rt->rt6i_idev->dev->ifindex;
-		break;
-	case NFT_FIB_RESULT_OIFNAME:
-		strncpy((char *)dest, rt->rt6i_idev->dev->name, IFNAMSIZ);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-
+	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
  put_rt_err:
 	ip6_rt_put(rt);
 }
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 21df8cccea65..77f00a99dfab 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -135,17 +135,17 @@ int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr)
 EXPORT_SYMBOL_GPL(nft_fib_dump);
 
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
-			  const struct nft_pktinfo *pkt, int index)
+			  const struct net_device *dev)
 {
-	struct net_device *dev;
 	u32 *dreg = reg;
+	int index;
 
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
+		index = dev ? dev->ifindex : 0;
 		*dreg = (priv->flags & NFTA_FIB_F_PRESENT) ? !!index : index;
 		break;
 	case NFT_FIB_RESULT_OIFNAME:
-		dev = dev_get_by_index_rcu(nft_net(pkt), index);
 		if (priv->flags & NFTA_FIB_F_PRESENT)
 			*dreg = !!dev;
 		else
-- 
2.11.0


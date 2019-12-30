Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D27C12CF73
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 12:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfL3LWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 06:22:09 -0500
Received: from correo.us.es ([193.147.175.20]:59226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbfL3LWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF455DA716
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E122CDA715
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D6C91DA710; Mon, 30 Dec 2019 12:22:06 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8879DA713;
        Mon, 30 Dec 2019 12:22:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:22:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 573FF41E4800;
        Mon, 30 Dec 2019 12:22:04 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/17] netfilter: nft_meta: place rtclassid handling in a helper
Date:   Mon, 30 Dec 2019 12:21:42 +0100
Message-Id: <20191230112143.121708-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

skb_dst is an inline helper with a WARN_ON(), so this is a bit more code
than it looks like.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ac6fc95387dc..fb1a571db924 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -273,6 +273,20 @@ static noinline u32 nft_prandom_u32(void)
 	return prandom_u32_state(state);
 }
 
+#ifdef CONFIG_IP_ROUTE_CLASSID
+static noinline bool
+nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
+{
+	const struct dst_entry *dst = skb_dst(skb);
+
+	if (!dst)
+		return false;
+
+	*dest = dst->tclassid;
+	return true;
+}
+#endif
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -319,14 +333,10 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 #ifdef CONFIG_IP_ROUTE_CLASSID
-	case NFT_META_RTCLASSID: {
-		const struct dst_entry *dst = skb_dst(skb);
-
-		if (dst == NULL)
+	case NFT_META_RTCLASSID:
+		if (!nft_meta_get_eval_rtclassid(skb, dest))
 			goto err;
-		*dest = dst->tclassid;
 		break;
-	}
 #endif
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
-- 
2.11.0


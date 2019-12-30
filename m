Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A021E12CF77
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 12:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfL3LWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 06:22:07 -0500
Received: from correo.us.es ([193.147.175.20]:59226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727477AbfL3LWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 914B84DE729
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8519CDA71A
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7ABF2DA714; Mon, 30 Dec 2019 12:22:03 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB83FDA737;
        Mon, 30 Dec 2019 12:22:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:22:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3BFA441E4800;
        Mon, 30 Dec 2019 12:22:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/17] netfilter: nft_meta: move cgroup handling to helper
Date:   Mon, 30 Dec 2019 12:21:38 +0100
Message-Id: <20191230112143.121708-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Reduce size of main eval function.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 1b32440ec2e6..3fca1c3ec361 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -161,6 +161,20 @@ nft_meta_get_eval_skugid(enum nft_meta_keys key,
 	return true;
 }
 
+#ifdef CONFIG_CGROUP_NET_CLASSID
+static noinline bool
+nft_meta_get_eval_cgroup(u32 *dest, const struct nft_pktinfo *pkt)
+{
+	struct sock *sk = skb_to_full_sk(pkt->skb);
+
+	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
+		return false;
+
+	*dest = sock_cgroup_classid(&sk->sk_cgrp_data);
+	return true;
+}
+#endif
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -168,7 +182,6 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
 	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
-	struct sock *sk;
 	u32 *dest = &regs->data[priv->dreg];
 
 	switch (priv->key) {
@@ -258,11 +271,8 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		break;
 #ifdef CONFIG_CGROUP_NET_CLASSID
 	case NFT_META_CGROUP:
-		sk = skb_to_full_sk(skb);
-		if (!sk || !sk_fullsock(sk) ||
-		    !net_eq(nft_net(pkt), sock_net(sk)))
+		if (!nft_meta_get_eval_cgroup(dest, pkt))
 			goto err;
-		*dest = sock_cgroup_classid(&sk->sk_cgrp_data);
 		break;
 #endif
 	case NFT_META_PRANDOM: {
-- 
2.11.0


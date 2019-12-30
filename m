Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3E112CF71
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 12:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfL3LWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 06:22:06 -0500
Received: from correo.us.es ([193.147.175.20]:59240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbfL3LWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EDA974DE730
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8250DA702
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:22:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4199DA710; Mon, 30 Dec 2019 12:22:01 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5930DA78D;
        Mon, 30 Dec 2019 12:21:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 43A7241E4800;
        Mon, 30 Dec 2019 12:21:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/17] netfilter: nft_meta: move sk uid/git handling to helper
Date:   Mon, 30 Dec 2019 12:21:37 +0100
Message-Id: <20191230112143.121708-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Not a hot path.  Also, both have copy&paste case statements,
so use a common helper for both.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 65 +++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index fe49b27dfa87..1b32440ec2e6 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -126,6 +126,41 @@ nft_meta_get_eval_pkttype_lo(const struct nft_pktinfo *pkt,
 	return true;
 }
 
+static noinline bool
+nft_meta_get_eval_skugid(enum nft_meta_keys key,
+			 u32 *dest,
+			 const struct nft_pktinfo *pkt)
+{
+	struct sock *sk = skb_to_full_sk(pkt->skb);
+	struct socket *sock;
+
+	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
+		return false;
+
+	read_lock_bh(&sk->sk_callback_lock);
+	sock = sk->sk_socket;
+	if (!sock || !sock->file) {
+		read_unlock_bh(&sk->sk_callback_lock);
+		return false;
+	}
+
+	switch (key) {
+	case NFT_META_SKUID:
+		*dest = from_kuid_munged(&init_user_ns,
+					 sock->file->f_cred->fsuid);
+		break;
+	case NFT_META_SKGID:
+		*dest =	from_kgid_munged(&init_user_ns,
+					 sock->file->f_cred->fsgid);
+		break;
+	default:
+		break;
+	}
+
+	read_unlock_bh(&sk->sk_callback_lock);
+	return true;
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -180,37 +215,9 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store16(dest, out->type);
 		break;
 	case NFT_META_SKUID:
-		sk = skb_to_full_sk(skb);
-		if (!sk || !sk_fullsock(sk) ||
-		    !net_eq(nft_net(pkt), sock_net(sk)))
-			goto err;
-
-		read_lock_bh(&sk->sk_callback_lock);
-		if (sk->sk_socket == NULL ||
-		    sk->sk_socket->file == NULL) {
-			read_unlock_bh(&sk->sk_callback_lock);
-			goto err;
-		}
-
-		*dest =	from_kuid_munged(&init_user_ns,
-				sk->sk_socket->file->f_cred->fsuid);
-		read_unlock_bh(&sk->sk_callback_lock);
-		break;
 	case NFT_META_SKGID:
-		sk = skb_to_full_sk(skb);
-		if (!sk || !sk_fullsock(sk) ||
-		    !net_eq(nft_net(pkt), sock_net(sk)))
+		if (!nft_meta_get_eval_skugid(priv->key, dest, pkt))
 			goto err;
-
-		read_lock_bh(&sk->sk_callback_lock);
-		if (sk->sk_socket == NULL ||
-		    sk->sk_socket->file == NULL) {
-			read_unlock_bh(&sk->sk_callback_lock);
-			goto err;
-		}
-		*dest =	from_kgid_munged(&init_user_ns,
-				 sk->sk_socket->file->f_cred->fsgid);
-		read_unlock_bh(&sk->sk_callback_lock);
 		break;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_META_RTCLASSID: {
-- 
2.11.0


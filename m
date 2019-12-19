Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B437125FF7
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfLSKwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:52:53 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:3377 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfLSKww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:52:52 -0500
Received: from cyclone.blr.asicdesigners.com (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBJAqL23010899;
        Thu, 19 Dec 2019 02:52:45 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 2/2] chtls: Fixed memory leak
Date:   Thu, 19 Dec 2019 16:21:48 +0530
Message-Id: <20191219105148.32456-3-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20191219105148.32456-1-vinay.yadav@chelsio.com>
References: <20191219105148.32456-1-vinay.yadav@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Freed work request skbs when connection terminates.
enqueue_wr()/ dequeue_wr() is shared between softirq
and application contexts, should be protected by socket
lock. Moved dequeue_wr() to appropriate file.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 27 +++++++++++++------------
 drivers/crypto/chelsio/chtls/chtls_cm.h | 21 +++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_hw.c |  3 +++
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 72e5b0f65a91..cae836c0e43c 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -727,6 +727,14 @@ static int chtls_close_listsrv_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	return 0;
 }
 
+static void chtls_purge_wr_queue(struct sock *sk)
+{
+	struct sk_buff *skb;
+
+	while ((skb = dequeue_wr(sk)) != NULL)
+		kfree_skb(skb);
+}
+
 static void chtls_release_resources(struct sock *sk)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
@@ -741,6 +749,11 @@ static void chtls_release_resources(struct sock *sk)
 	kfree_skb(csk->txdata_skb_cache);
 	csk->txdata_skb_cache = NULL;
 
+	if (csk->wr_credits != csk->wr_max_credits) {
+		chtls_purge_wr_queue(sk);
+		chtls_reset_wr_list(csk);
+	}
+
 	if (csk->l2t_entry) {
 		cxgb4_l2t_release(csk->l2t_entry);
 		csk->l2t_entry = NULL;
@@ -1735,6 +1748,7 @@ static void chtls_peer_close(struct sock *sk, struct sk_buff *skb)
 		else
 			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	}
+	kfree_skb(skb);
 }
 
 static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
@@ -2062,19 +2076,6 @@ static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	return 0;
 }
 
-static struct sk_buff *dequeue_wr(struct sock *sk)
-{
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
-	struct sk_buff *skb = csk->wr_skb_head;
-
-	if (likely(skb)) {
-	/* Don't bother clearing the tail */
-		csk->wr_skb_head = WR_SKB_CB(skb)->next_wr;
-		WR_SKB_CB(skb)->next_wr = NULL;
-	}
-	return skb;
-}
-
 static void chtls_rx_ack(struct sock *sk, struct sk_buff *skb)
 {
 	struct cpl_fw4_ack *hdr = cplhdr(skb) + RSS_HDR;
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.h b/drivers/crypto/chelsio/chtls/chtls_cm.h
index 129d7ac649a9..3fac0c74a41f 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.h
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.h
@@ -185,6 +185,12 @@ static inline void chtls_kfree_skb(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+static inline void chtls_reset_wr_list(struct chtls_sock *csk)
+{
+	csk->wr_skb_head = NULL;
+	csk->wr_skb_tail = NULL;
+}
+
 static inline void enqueue_wr(struct chtls_sock *csk, struct sk_buff *skb)
 {
 	WR_SKB_CB(skb)->next_wr = NULL;
@@ -197,4 +203,19 @@ static inline void enqueue_wr(struct chtls_sock *csk, struct sk_buff *skb)
 		WR_SKB_CB(csk->wr_skb_tail)->next_wr = skb;
 	csk->wr_skb_tail = skb;
 }
+
+static inline struct sk_buff *dequeue_wr(struct sock *sk)
+{
+	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct sk_buff *skb = NULL;
+
+	skb = csk->wr_skb_head;
+
+	if (likely(skb)) {
+	 /* Don't bother clearing the tail */
+		csk->wr_skb_head = WR_SKB_CB(skb)->next_wr;
+		WR_SKB_CB(skb)->next_wr = NULL;
+	}
+	return skb;
+}
 #endif
diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c b/drivers/crypto/chelsio/chtls/chtls_hw.c
index 14d82f4e3dcf..f1820aca0d33 100644
--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -376,6 +376,7 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen,
 	kwr->sc_imm.cmd_more = cpu_to_be32(ULPTX_CMD_V(ULP_TX_SC_IMM));
 	kwr->sc_imm.len = cpu_to_be32(klen);
 
+	lock_sock(sk);
 	/* key info */
 	kctx = (struct _key_ctx *)(kwr + 1);
 	ret = chtls_key_info(csk, kctx, keylen, optname, cipher_type);
@@ -414,8 +415,10 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen,
 		csk->tlshws.txkey = keyid;
 	}
 
+	release_sock(sk);
 	return ret;
 out_notcb:
+	release_sock(sk);
 	free_tls_keyid(sk);
 out_nokey:
 	kfree_skb(skb);
-- 
2.18.1


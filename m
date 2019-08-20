Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C9996C65
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbfHTWeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:34:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36976 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730957AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1gdNAeXt8OgvuJ6X+8IOh2ZR1ZcjsyOrJ3lAttPcG2U=; b=rHoBQMSwPyAxCZkdo2x+ejZcK3
        iBoJDbgUf/So0cS3wv7zBuFYOVMI+XhSG0uxSynqI5DzlMCGkdpoO238B6DgBTi1ceA13aSme4ktA
        vzOiuk+GwY2WSRbJA61OIq+ICxcJ9vhLN+wtlfwUYRqSks4vxVn99negfzUhQEIqS7WXjvHaTiOeP
        A6jPwFH92UN8GqEScclkhPO7ckE4UMxRgNA/ZxMTz9eI8jshgp0aut3iX2K6WJSeJYED0BfFceZO9
        r6z1Qg8+t+G9ExYeHt3vgNzULxAfWQvx5dhfQs8tAeID1lG8/IbrrUjd803VmkLM40AAGuJ2Ghaef
        qDj0gemg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005qM-49; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 09/38] ath10k: Convert pending_tx to XArray
Date:   Tue, 20 Aug 2019 15:32:30 -0700
Message-Id: <20190820223259.22348-10-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Leave the tx_lock in place; it might be removable around some of the
places that use the XArray, but err on the side of double locking for now.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  2 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 31 ++++++++++++------------
 drivers/net/wireless/ath/ath10k/mac.c    |  4 +--
 drivers/net/wireless/ath/ath10k/txrx.c   |  2 +-
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 30c080094af1..971f0a8629bc 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1965,7 +1965,7 @@ struct ath10k_htt {
 	int max_num_pending_tx;
 	int num_pending_tx;
 	int num_pending_mgmt_tx;
-	struct idr pending_tx;
+	struct xarray pending_tx;
 	wait_queue_head_t empty_tx_wq;
 
 	/* FIFO for storing tx done status {ack, no-ack, discard} and msdu id */
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 2ef717f18795..c25b01fcfa53 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -195,13 +195,16 @@ void ath10k_htt_tx_mgmt_dec_pending(struct ath10k_htt *htt)
 int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb)
 {
 	struct ath10k *ar = htt->ar;
-	int ret;
+	int ret, id;
 
 	spin_lock_bh(&htt->tx_lock);
-	ret = idr_alloc(&htt->pending_tx, skb, 0,
-			htt->max_num_pending_tx, GFP_ATOMIC);
+	ret = xa_alloc(&htt->pending_tx, &id, skb,
+			XA_LIMIT(0, htt->max_num_pending_tx - 1), GFP_ATOMIC);
 	spin_unlock_bh(&htt->tx_lock);
 
+	if (ret == 0)
+		ret = id;
+
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx alloc msdu_id %d\n", ret);
 
 	return ret;
@@ -215,7 +218,7 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx free msdu_id %hu\n", msdu_id);
 
-	idr_remove(&htt->pending_tx, msdu_id);
+	xa_erase(&htt->pending_tx, msdu_id);
 }
 
 static void ath10k_htt_tx_free_cont_txbuf_32(struct ath10k_htt *htt)
@@ -479,7 +482,7 @@ int ath10k_htt_tx_start(struct ath10k_htt *htt)
 		   htt->max_num_pending_tx);
 
 	spin_lock_init(&htt->tx_lock);
-	idr_init(&htt->pending_tx);
+	xa_init_flags(&htt->pending_tx, XA_FLAGS_ALLOC);
 
 	if (htt->tx_mem_allocated)
 		return 0;
@@ -489,21 +492,15 @@ int ath10k_htt_tx_start(struct ath10k_htt *htt)
 
 	ret = ath10k_htt_tx_alloc_buf(htt);
 	if (ret)
-		goto free_idr_pending_tx;
+		return ret;
 
 	htt->tx_mem_allocated = true;
 
 	return 0;
-
-free_idr_pending_tx:
-	idr_destroy(&htt->pending_tx);
-
-	return ret;
 }
 
-static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
+static int ath10k_htt_tx_clean_up_pending(int msdu_id, struct ath10k *ar)
 {
-	struct ath10k *ar = ctx;
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_tx_done tx_done = {0};
 
@@ -531,8 +528,12 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
 
 void ath10k_htt_tx_stop(struct ath10k_htt *htt)
 {
-	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
-	idr_destroy(&htt->pending_tx);
+	struct sk_buff *skb;
+	unsigned long index;
+
+	xa_for_each(&htt->pending_tx, index, skb)
+		ath10k_htt_tx_clean_up_pending(index, htt->ar);
+	xa_destroy(&htt->pending_tx);
 }
 
 void ath10k_htt_tx_free(struct ath10k_htt *htt)
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 12dad659bf68..9c4cb2e31b76 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3939,13 +3939,13 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 {
 	struct ath10k_skb_cb *cb;
 	struct sk_buff *msdu;
-	int msdu_id;
+	unsigned long msdu_id;
 
 	if (!txq)
 		return;
 
 	spin_lock_bh(&ar->htt.tx_lock);
-	idr_for_each_entry(&ar->htt.pending_tx, msdu, msdu_id) {
+	xa_for_each(&ar->htt.pending_tx, msdu_id, msdu) {
 		cb = ATH10K_SKB_CB(msdu);
 		if (cb->txq == txq)
 			cb->txq = NULL;
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 4102df016931..87bf6ab65347 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -62,7 +62,7 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	}
 
 	spin_lock_bh(&htt->tx_lock);
-	msdu = idr_find(&htt->pending_tx, tx_done->msdu_id);
+	msdu = xa_load(&htt->pending_tx, tx_done->msdu_id);
 	if (!msdu) {
 		ath10k_warn(ar, "received tx completion for invalid msdu_id: %d\n",
 			    tx_done->msdu_id);
-- 
2.23.0.rc1


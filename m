Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2563196C45
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbfHTWdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36982 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730974AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2reZNvY6HIasWwjCkHC0sIy5XYZGJpS4stMviGUKElk=; b=SV9M3JVFSBZd/Qz5trFM0uMgIl
        vKNFk+702rc/Z1u06J7AWESdGAMGv7OQDohYZseHThpjqsh+2F+o9jz+P1UQoj/g7raTWriWnZwms
        wDUGBx3RnRYLPK+WuMAefaMA8TERKoQIHVuwm5JiIJ80KQ2ox70DYjsEmU3e1UbSKO4hR+pEASdGw
        ht1Cu0nmE5W1TlpJEUfF4IjI9hUhYayoeSJEedPZbSVmB0R/WGtSowKxHbqVZtpaQ1VQ+nS3HZJDH
        IUCBfy8dx+8mBt1Nbc0sYUbd/SJ1+xpmTCmXN9uNpUYfW0fRZVCpCTqQQfGsTaTZHlgcdI/5TYcOd
        WVJ/ey4w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005qf-9U; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 12/38] mwifiex: Convert ack_status_frames to XArray
Date:   Tue, 20 Aug 2019 15:32:33 -0700
Message-Id: <20190820223259.22348-13-willy@infradead.org>
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

Straightforward locking conversion; the only two points of note is that we
can't pass the address of the tx_token_id to xa_alloc() because it's too
small (an unsigned char), and mwifiex_free_ack_frame() becomes inlined
into its caller.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c |  4 ++--
 drivers/net/wireless/marvell/mwifiex/main.c | 10 ++++------
 drivers/net/wireless/marvell/mwifiex/main.h |  4 +---
 drivers/net/wireless/marvell/mwifiex/txrx.c |  4 +---
 drivers/net/wireless/marvell/mwifiex/wmm.c  | 15 ++++++---------
 5 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 6c0e52eb8794..03e43077ae45 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -477,8 +477,8 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 		spin_lock_init(&priv->tx_ba_stream_tbl_lock);
 		spin_lock_init(&priv->rx_reorder_tbl_lock);
 
-		spin_lock_init(&priv->ack_status_lock);
-		idr_init(&priv->ack_status_frames);
+		xa_init_flags(&priv->ack_status_frames,
+				XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index a9657ae6d782..0587bd7c8a13 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -822,14 +822,12 @@ mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
 
 	skb = skb_clone(skb, GFP_ATOMIC);
 	if (skb) {
-		int id;
+		int err, id;
 
-		spin_lock_bh(&priv->ack_status_lock);
-		id = idr_alloc(&priv->ack_status_frames, orig_skb,
-			       1, 0x10, GFP_ATOMIC);
-		spin_unlock_bh(&priv->ack_status_lock);
+		err = xa_alloc_bh(&priv->ack_status_frames, &id, orig_skb,
+			       XA_LIMIT(1, 0xf), GFP_ATOMIC);
 
-		if (id >= 0) {
+		if (err == 0) {
 			tx_info = MWIFIEX_SKB_TXCB(skb);
 			tx_info->ack_frame_id = id;
 			tx_info->flags |= flag;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 095837fba300..5e06bc9d9519 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -682,9 +682,7 @@ struct mwifiex_private {
 	u8 check_tdls_tx;
 	struct timer_list auto_tdls_timer;
 	bool auto_tdls_timer_active;
-	struct idr ack_status_frames;
-	/* spin lock for ack status */
-	spinlock_t ack_status_lock;
+	struct xarray ack_status_frames;
 	/** rx histogram data */
 	struct mwifiex_histogram_data *hist_data;
 	struct cfg80211_chan_def dfs_chandef;
diff --git a/drivers/net/wireless/marvell/mwifiex/txrx.c b/drivers/net/wireless/marvell/mwifiex/txrx.c
index e3c1446dd847..b2ef30d9f26d 100644
--- a/drivers/net/wireless/marvell/mwifiex/txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/txrx.c
@@ -339,9 +339,7 @@ void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
 	if (!tx_status->tx_token_id)
 		return;
 
-	spin_lock_bh(&priv->ack_status_lock);
-	ack_skb = idr_remove(&priv->ack_status_frames, tx_status->tx_token_id);
-	spin_unlock_bh(&priv->ack_status_lock);
+	ack_skb = xa_erase_bh(&priv->ack_status_frames, tx_status->tx_token_id);
 
 	if (ack_skb) {
 		tx_info = MWIFIEX_SKB_TXCB(ack_skb);
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index 41f0231376c0..64ff6ac3889b 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -562,13 +562,6 @@ static void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 	}
 }
 
-static int mwifiex_free_ack_frame(int id, void *p, void *data)
-{
-	pr_warn("Have pending ack frames!\n");
-	kfree_skb(p);
-	return 0;
-}
-
 /*
  * This function cleans up the Tx and Rx queues.
  *
@@ -582,6 +575,7 @@ static int mwifiex_free_ack_frame(int id, void *p, void *data)
 void
 mwifiex_clean_txrx(struct mwifiex_private *priv)
 {
+	unsigned long index;
 	struct sk_buff *skb, *tmp;
 
 	mwifiex_11n_cleanup_reorder_tbl(priv);
@@ -612,8 +606,11 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 	}
 	atomic_set(&priv->adapter->bypass_tx_pending, 0);
 
-	idr_for_each(&priv->ack_status_frames, mwifiex_free_ack_frame, NULL);
-	idr_destroy(&priv->ack_status_frames);
+	xa_for_each(&priv->ack_status_frames, index, skb) {
+		WARN_ONCE(1, "Have pending ack frames!\n");
+		kfree_skb(skb);
+	}
+	xa_destroy(&priv->ack_status_frames);
 }
 
 /*
-- 
2.23.0.rc1


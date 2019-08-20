Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC07096C50
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbfHTWdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731063AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cxcxLvH6l1nBcsZKYtcoeA4LGVqYEte7Yi+i+yeNoos=; b=eQA0DfxGGlC5jvEWwa/WRZUMgj
        An8VwlVxs6dW98DjRexGy93p9qMNgMX7ojMjW6+SyA2hCYcmP2QnEolMrCIhS15TV767E8GIM4Hzm
        QSnVIz+Xkdjr0qZlpZVi2st4Ub2ObSvd8XOywSRy3OZa5dkNb4pLGVXnObmUzgeZXXTS1akGC6St0
        1k52qQqf1bHZmT/47JH3P6B0LQlrXlNeL1s2fgc6JY8j6omEVykTxasnB8opLYmYOEeWjxzk6hx2h
        VqojVAdZc3gL1leFRPFymWeMdurLJazWI6DzeRgKs6DeJZJoyUQsQso3FUN1zzKRpfqi3nY0KwjY+
        Ad9ombdg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005t8-Ka; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 37/38] mac80211: Convert ack_status_frames to XArray
Date:   Tue, 20 Aug 2019 15:32:58 -0700
Message-Id: <20190820223259.22348-38-willy@infradead.org>
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

Replace the ack_status_lock with the XArray internal lock.  Using the
xa_for_each() iterator lets us inline ieee80211_free_ack_frame().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/mac80211/cfg.c         | 13 ++++++-------
 net/mac80211/ieee80211_i.h |  3 +--
 net/mac80211/main.c        | 20 ++++++++------------
 net/mac80211/status.c      |  6 +++---
 net/mac80211/tx.c          | 16 ++++++++--------
 5 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ed56b0c6fe19..47d7670094a9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3425,24 +3425,23 @@ int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 {
 	unsigned long spin_flags;
 	struct sk_buff *ack_skb;
-	int id;
+	int err, id;
 
 	ack_skb = skb_copy(skb, gfp);
 	if (!ack_skb)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&local->ack_status_lock, spin_flags);
-	id = idr_alloc(&local->ack_status_frames, ack_skb,
-		       1, 0x10000, GFP_ATOMIC);
-	spin_unlock_irqrestore(&local->ack_status_lock, spin_flags);
+	xa_lock_irqsave(&local->ack_status_frames, spin_flags);
+	err = __xa_alloc(&local->ack_status_frames, &id, ack_skb,
+			XA_LIMIT(0, 0xffff), GFP_ATOMIC);
+	xa_unlock_irqrestore(&local->ack_status_frames, spin_flags);
 
-	if (id < 0) {
+	if (err < 0) {
 		kfree_skb(ack_skb);
 		return -ENOMEM;
 	}
 
 	IEEE80211_SKB_CB(skb)->ack_frame_id = id;
-
 	*cookie = ieee80211_mgmt_tx_cookie(local);
 	IEEE80211_SKB_CB(ack_skb)->ack.cookie = *cookie;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 791ce58d0f09..ade005892099 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1393,8 +1393,7 @@ struct ieee80211_local {
 	unsigned long hw_roc_start_time;
 	u64 roc_cookie_counter;
 
-	struct idr ack_status_frames;
-	spinlock_t ack_status_lock;
+	struct xarray ack_status_frames;
 
 	struct ieee80211_sub_if_data __rcu *p2p_sdata;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 29b9d57df1a3..0d46aa52368a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -693,8 +693,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 
 	INIT_WORK(&local->tdls_chsw_work, ieee80211_tdls_chsw_work);
 
-	spin_lock_init(&local->ack_status_lock);
-	idr_init(&local->ack_status_frames);
+	xa_init_flags(&local->ack_status_frames, XA_FLAGS_ALLOC1);
 
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
 		skb_queue_head_init(&local->pending[i]);
@@ -1353,16 +1352,11 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_unregister_hw);
 
-static int ieee80211_free_ack_frame(int id, void *p, void *data)
-{
-	WARN_ONCE(1, "Have pending ack frames!\n");
-	kfree_skb(p);
-	return 0;
-}
-
 void ieee80211_free_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct sk_buff *skb;
+	unsigned long index;
 	enum nl80211_band band;
 
 	mutex_destroy(&local->iflist_mtx);
@@ -1371,9 +1365,11 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 	if (local->wiphy_ciphers_allocated)
 		kfree(local->hw.wiphy->cipher_suites);
 
-	idr_for_each(&local->ack_status_frames,
-		     ieee80211_free_ack_frame, NULL);
-	idr_destroy(&local->ack_status_frames);
+	xa_for_each(&local->ack_status_frames, index, skb) {
+		WARN_ONCE(1, "Have pending ack frames!\n");
+		kfree_skb(skb);
+	}
+	xa_destroy(&local->ack_status_frames);
 
 	sta_info_stop(local);
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index f03aa8924d23..8f38af968941 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -619,9 +619,9 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
 	struct sk_buff *skb;
 	unsigned long flags;
 
-	spin_lock_irqsave(&local->ack_status_lock, flags);
-	skb = idr_remove(&local->ack_status_frames, info->ack_frame_id);
-	spin_unlock_irqrestore(&local->ack_status_lock, flags);
+	xa_lock_irqsave(&local->ack_status_frames, flags);
+	skb = __xa_erase(&local->ack_status_frames, info->ack_frame_id);
+	xa_unlock_irqrestore(&local->ack_status_frames, flags);
 
 	if (!skb)
 		return;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 235c6377a203..a7c0e3a0dbfb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2459,7 +2459,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	bool wme_sta = false, authorized = false;
 	bool tdls_peer;
 	bool multicast;
-	u16 info_id = 0;
+	u32 info_id = 0;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
 	enum nl80211_band band;
@@ -2721,15 +2721,15 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 		if (ack_skb) {
 			unsigned long flags;
-			int id;
+			int err;
 
-			spin_lock_irqsave(&local->ack_status_lock, flags);
-			id = idr_alloc(&local->ack_status_frames, ack_skb,
-				       1, 0x10000, GFP_ATOMIC);
-			spin_unlock_irqrestore(&local->ack_status_lock, flags);
+			xa_lock_irqsave(&local->ack_status_frames, flags);
+			err = __xa_alloc(&local->ack_status_frames, &info_id,
+					ack_skb, XA_LIMIT(0, 0xffff),
+					GFP_ATOMIC);
+			xa_unlock_irqrestore(&local->ack_status_frames, flags);
 
-			if (id >= 0) {
-				info_id = id;
+			if (!err) {
 				info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 			} else {
 				kfree_skb(ack_skb);
-- 
2.23.0.rc1


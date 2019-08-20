Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFBF96C64
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbfHTWdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730962AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KsfEU9i349Ud9KdlgKH1KjkZNJ+NKRlUdUSatN9sH2o=; b=Bq/5/2hIDhbcwiE5orTAJAt/iA
        pzdI44kSCUY+RnTa6hWRYRdWWD672EWb6D6gXd3C8jB2jJH2S8IvRcTElhVfdm0QE2ZwHnDNgHWEk
        sr0qRxZDp6bfWyqSO5XpSWvSeAxgj5o3XIZNe7sBa/MKOd7NxZ1KFtDglDscoadPu0puHGyJ13YDC
        TCTY1Mj0ZuZT2va7kZF99nQJ0n2wASy++8l3z27tipgKWteVvSWC8Rkj2EzajrYV/kqTw5jTtqSXz
        gU7M945H8/+3uuJ/0Wsd1b6hPyt59JAmBzeqQXx9W0dIzczJCMrDj68XJ+OQmRdnU203BgQzYm7Ev
        PxR1QWdw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005qS-61; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 10/38] ath10k: Convert mgmt_pending_tx IDR to XArray
Date:   Tue, 20 Aug 2019 15:32:31 -0700
Message-Id: <20190820223259.22348-11-willy@infradead.org>
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

Leave the ->data_lock locking in place; it may be possible to remove it,
but err on the side of double-locking for now.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/wireless/ath/ath10k/core.h    |  2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  8 +++--
 drivers/net/wireless/ath/ath10k/wmi.c     | 43 ++++++++++-------------
 3 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4d7db07db6ba..89b94322aeb1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -175,7 +175,7 @@ struct ath10k_wmi {
 	u32 mgmt_max_num_pending_tx;
 
 	/* Protected by data_lock */
-	struct idr mgmt_pending_tx;
+	struct xarray mgmt_pending_tx;
 
 	u32 num_mem_chunks;
 	u32 rx_decap_mode;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 2985bb17decd..6144d6d9c539 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2843,7 +2843,7 @@ ath10k_wmi_mgmt_tx_alloc_msdu_id(struct ath10k *ar, struct sk_buff *skb,
 {
 	struct ath10k_wmi *wmi = &ar->wmi;
 	struct ath10k_mgmt_tx_pkt_addr *pkt_addr;
-	int ret;
+	int ret, id;
 
 	pkt_addr = kmalloc(sizeof(*pkt_addr), GFP_ATOMIC);
 	if (!pkt_addr)
@@ -2853,9 +2853,11 @@ ath10k_wmi_mgmt_tx_alloc_msdu_id(struct ath10k *ar, struct sk_buff *skb,
 	pkt_addr->paddr = paddr;
 
 	spin_lock_bh(&ar->data_lock);
-	ret = idr_alloc(&wmi->mgmt_pending_tx, pkt_addr, 0,
-			wmi->mgmt_max_num_pending_tx, GFP_ATOMIC);
+	ret = xa_alloc(&wmi->mgmt_pending_tx, &id, pkt_addr,
+			XA_LIMIT(0, wmi->mgmt_max_num_pending_tx), GFP_ATOMIC);
 	spin_unlock_bh(&ar->data_lock);
+	if (ret == 0)
+		ret = id;
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx alloc msdu_id ret %d\n", ret);
 	return ret;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 4f707c6394bb..280220c4fe3b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2353,7 +2353,7 @@ wmi_process_mgmt_tx_comp(struct ath10k *ar, struct mgmt_tx_compl_params *param)
 
 	spin_lock_bh(&ar->data_lock);
 
-	pkt_addr = idr_find(&wmi->mgmt_pending_tx, param->desc_id);
+	pkt_addr = xa_load(&wmi->mgmt_pending_tx, param->desc_id);
 	if (!pkt_addr) {
 		ath10k_warn(ar, "received mgmt tx completion for invalid msdu_id: %d\n",
 			    param->desc_id);
@@ -2380,7 +2380,7 @@ wmi_process_mgmt_tx_comp(struct ath10k *ar, struct mgmt_tx_compl_params *param)
 	ret = 0;
 
 out:
-	idr_remove(&wmi->mgmt_pending_tx, param->desc_id);
+	xa_erase(&wmi->mgmt_pending_tx, param->desc_id);
 	spin_unlock_bh(&ar->data_lock);
 	return ret;
 }
@@ -9389,7 +9389,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 
 	if (test_bit(ATH10K_FW_FEATURE_MGMT_TX_BY_REF,
 		     ar->running_fw->fw_file.fw_features)) {
-		idr_init(&ar->wmi.mgmt_pending_tx);
+		xa_init_flags(&ar->wmi.mgmt_pending_tx, XA_FLAGS_ALLOC);
 	}
 
 	return 0;
@@ -9410,32 +9410,27 @@ void ath10k_wmi_free_host_mem(struct ath10k *ar)
 	ar->wmi.num_mem_chunks = 0;
 }
 
-static int ath10k_wmi_mgmt_tx_clean_up_pending(int msdu_id, void *ptr,
-					       void *ctx)
-{
-	struct ath10k_mgmt_tx_pkt_addr *pkt_addr = ptr;
-	struct ath10k *ar = ctx;
-	struct sk_buff *msdu;
-
-	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "force cleanup mgmt msdu_id %hu\n", msdu_id);
-
-	msdu = pkt_addr->vaddr;
-	dma_unmap_single(ar->dev, pkt_addr->paddr,
-			 msdu->len, DMA_FROM_DEVICE);
-	ieee80211_free_txskb(ar->hw, msdu);
-
-	return 0;
-}
-
 void ath10k_wmi_detach(struct ath10k *ar)
 {
 	if (test_bit(ATH10K_FW_FEATURE_MGMT_TX_BY_REF,
 		     ar->running_fw->fw_file.fw_features)) {
+		struct ath10k_mgmt_tx_pkt_addr *pkt_addr;
+		unsigned long index;
+
 		spin_lock_bh(&ar->data_lock);
-		idr_for_each(&ar->wmi.mgmt_pending_tx,
-			     ath10k_wmi_mgmt_tx_clean_up_pending, ar);
-		idr_destroy(&ar->wmi.mgmt_pending_tx);
+		xa_for_each(&ar->wmi.mgmt_pending_tx, index, pkt_addr) {
+			struct sk_buff *msdu;
+
+			ath10k_dbg(ar, ATH10K_DBG_WMI,
+					"force cleanup mgmt msdu_id %lu\n",
+					index);
+
+			msdu = pkt_addr->vaddr;
+			dma_unmap_single(ar->dev, pkt_addr->paddr, msdu->len,
+					DMA_FROM_DEVICE);
+			ieee80211_free_txskb(ar->hw, msdu);
+		}
+		xa_destroy(&ar->wmi.mgmt_pending_tx);
 		spin_unlock_bh(&ar->data_lock);
 	}
 
-- 
2.23.0.rc1


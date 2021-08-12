Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989583EACBF
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 23:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbhHLVnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 17:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhHLVnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 17:43:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FCF960C3F;
        Thu, 12 Aug 2021 21:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628804567;
        bh=XFK4yA210lRZo75z9OXStq+bZH+u7Gcd5Y8jgmMbNi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNRXDP7zOvnxT82AJHxWgff2alMlgDxXt3JyqMemm4oCf6DAe2r3/Le+LJI80YYxG
         p6a4/2DofFqZ3zkXr37lpjYUnd7klRK+CfvQ5zh2G0BMnzNseDOBVGB/ISFGgVw9a+
         1S3lsH91mNpsJaoiun8EzloYa1b8yKMYQkqpcrmdiRAd+H8uA8lf0kWev+hWj13fRT
         1ZLpSbA7TP2WpWDXN6aANceR6nMAkX3EVIEWbhzQ/TyyG0braqnfD8VM1KEGq+BeQh
         /jnZrpj+b7IIwmXJ4mGk5RVCcMwW4tyX1AZEjZ9HpdgsvQfwY2cnswXrBbY18RhK9V
         HHnhOspED+Faw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        prashant@broadcom.com, eddie.wai@broadcom.com,
        huangjw@broadcom.com, gospo@broadcom.com, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 3/4] bnxt: make sure xmit_more + errors does not miss doorbells
Date:   Thu, 12 Aug 2021 14:42:41 -0700
Message-Id: <20210812214242.578039-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812214242.578039-1-kuba@kernel.org>
References: <20210812214242.578039-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skbs are freed on error and not put on the ring. We may, however,
be in a situation where we're freeing the last skb of a batch,
and there is a doorbell ring pending because of xmit_more() being
true earlier. Make sure we ring the door bell in such situations.

Since errors are rare don't pay attention to xmit_more() and just
always flush the pending frames.

The busy case should be safe to be left alone because it can
only happen if start_xmit races with completions and they
both enable the queue. In that case the kick can't be pending.

Noticed while reading the code.

Fixes: 4d172f21cefe ("bnxt_en: Implement xmit_more.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: - netdev_warn() -> netif_warn() [Edwin]
    - use correct prod value [Michael]
v3: - consolidate the txbuf->skb clearing [Michael]
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 39 +++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 721b5df36311..389016ea65cf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -72,7 +72,8 @@
 #include "bnxt_debugfs.h"
 
 #define BNXT_TX_TIMEOUT		(5 * HZ)
-#define BNXT_DEF_MSG_ENABLE	(NETIF_MSG_DRV | NETIF_MSG_HW)
+#define BNXT_DEF_MSG_ENABLE	(NETIF_MSG_DRV | NETIF_MSG_HW | \
+				 NETIF_MSG_TX_ERR)
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom BCM573xx network driver");
@@ -365,6 +366,13 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
 	return md_dst->u.port_info.port_id;
 }
 
+static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+			     u16 prod)
+{
+	bnxt_db_write(bp, &txr->tx_db, prod);
+	txr->kick_pending = 0;
+}
+
 static bool bnxt_txr_netif_try_stop_queue(struct bnxt *bp,
 					  struct bnxt_tx_ring_info *txr,
 					  struct netdev_queue *txq)
@@ -413,6 +421,10 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
+		/* We must have raced with NAPI cleanup */
+		if (net_ratelimit() && txr->kick_pending)
+			netif_warn(bp, tx_err, dev,
+				   "bnxt: ring busy w/ flush pending!\n");
 		if (bnxt_txr_netif_try_stop_queue(bp, txr, txq))
 			return NETDEV_TX_BUSY;
 	}
@@ -537,21 +549,16 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 normal_tx:
 	if (length < BNXT_MIN_PKT_SIZE) {
 		pad = BNXT_MIN_PKT_SIZE - length;
-		if (skb_pad(skb, pad)) {
+		if (skb_pad(skb, pad))
 			/* SKB already freed. */
-			tx_buf->skb = NULL;
-			return NETDEV_TX_OK;
-		}
+			goto tx_kick_pending;
 		length = BNXT_MIN_PKT_SIZE;
 	}
 
 	mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(&pdev->dev, mapping))) {
-		dev_kfree_skb_any(skb);
-		tx_buf->skb = NULL;
-		return NETDEV_TX_OK;
-	}
+	if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
+		goto tx_free;
 
 	dma_unmap_addr_set(tx_buf, mapping, mapping);
 	flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
@@ -638,13 +645,15 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	txr->tx_prod = prod;
 
 	if (!netdev_xmit_more() || netif_xmit_stopped(txq))
-		bnxt_db_write(bp, &txr->tx_db, prod);
+		bnxt_txr_db_kick(bp, txr, prod);
+	else
+		txr->kick_pending = 1;
 
 tx_done:
 
 	if (unlikely(bnxt_tx_avail(bp, txr) <= MAX_SKB_FRAGS + 1)) {
 		if (netdev_xmit_more() && !tx_buf->is_push)
-			bnxt_db_write(bp, &txr->tx_db, prod);
+			bnxt_txr_db_kick(bp, txr, prod);
 
 		bnxt_txr_netif_try_stop_queue(bp, txr, txq);
 	}
@@ -659,7 +668,6 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* start back at beginning and unmap skb */
 	prod = txr->tx_prod;
 	tx_buf = &txr->tx_buf_ring[prod];
-	tx_buf->skb = NULL;
 	dma_unmap_single(&pdev->dev, dma_unmap_addr(tx_buf, mapping),
 			 skb_headlen(skb), PCI_DMA_TODEVICE);
 	prod = NEXT_TX(prod);
@@ -673,7 +681,12 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			       PCI_DMA_TODEVICE);
 	}
 
+tx_free:
 	dev_kfree_skb_any(skb);
+tx_kick_pending:
+	if (txr->kick_pending)
+		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
+	txr->tx_buf_ring[txr->tx_prod].skb = NULL;
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index bcf8d00b8c80..ba4e0fc38520 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -786,6 +786,7 @@ struct bnxt_tx_ring_info {
 	u16			tx_prod;
 	u16			tx_cons;
 	u16			txq_index;
+	u8			kick_pending;
 	struct bnxt_db_info	tx_db;
 
 	struct tx_bd		*tx_desc_ring[MAX_TX_PAGES];
-- 
2.31.1


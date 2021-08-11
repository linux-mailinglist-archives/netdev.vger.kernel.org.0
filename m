Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E9C3E9A73
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhHKVim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232191AbhHKVih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 17:38:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2DDC6109E;
        Wed, 11 Aug 2021 21:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628717892;
        bh=2fn+0OkdrN4knwhxjuBycRFDiUcc18ZikiSmxRSRFF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWWOiIEQ2e6KazQwwR56kY4CNWoIam7u2SeQ8+wnfX86M8c2TYt9m9twRsV/uFO8z
         vB9YYqXToC+FmwTmcsa06qCvjRc3L3lOpsO+/O43fvEyoPTaBIeWH4BcSHfGPpCWfN
         Tag6BupcvOG5Q3adeVH8C3fJk39950dRsFEDntDUOQ89gENZuiuGzR4OqrmBkJoGpS
         Kab5hFOB3FOJWXRAXThJjybx8VraO0sNhIS3o5vwRWG6rcgkVkDOZQE/sDPSHyPjrz
         7EvTTdsa0MLO1EKMzEVb430WTuCz0AMof5b5sdnwzGd6nbcx8OYPn7UaV7hr1VuHHS
         BbWzFLh5eo3ww==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 3/4] bnxt: make sure xmit_more + errors does not miss doorbells
Date:   Wed, 11 Aug 2021 14:37:48 -0700
Message-Id: <20210811213749.3276687-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811213749.3276687-1-kuba@kernel.org>
References: <20210811213749.3276687-1-kuba@kernel.org>
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
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 36 +++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 52f5c8405e76..79bbd6ec7ef7 100644
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
@@ -367,6 +368,13 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
 	return md_dst->u.port_info.port_id;
 }
 
+static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+			     u16 prod)
+{
+	bnxt_db_write(bp, &txr->tx_db, prod);
+	txr->kick_pending = 0;
+}
+
 static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -396,6 +404,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
 		netif_tx_stop_queue(txq);
+		if (net_ratelimit() && txr->kick_pending)
+			netif_warn(bp, tx_err, dev, "bnxt: ring busy!\n");
 		return NETDEV_TX_BUSY;
 	}
 
@@ -516,21 +526,16 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -617,13 +622,15 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
 
 		netif_tx_stop_queue(txq);
 
@@ -661,7 +668,12 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			       PCI_DMA_TODEVICE);
 	}
 
+tx_free:
 	dev_kfree_skb_any(skb);
+tx_kick_pending:
+	tx_buf->skb = NULL;
+	if (txr->kick_pending)
+		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 9c3324e76ff7..7b989b6e4f6e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -799,6 +799,7 @@ struct bnxt_tx_ring_info {
 	u16			tx_prod;
 	u16			tx_cons;
 	u16			txq_index;
+	u8			kick_pending;
 	struct bnxt_db_info	tx_db;
 
 	struct tx_bd		*tx_desc_ring[MAX_TX_PAGES];
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ADD3E98CE
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhHKTdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231474AbhHKTdG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 15:33:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D30196108C;
        Wed, 11 Aug 2021 19:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628710362;
        bh=EpvcxNk3XZhp6kbjU8WYaSjcdKV3tii8DScI5ELFLB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSEJ1qKnyWOsDeIIMeu0pwyDAikqQXJjs7kHVCDAVMAgJy5vdA77TwrWngLcO6SL5
         1QIk0kbMv+X9PO+te0lHh2qDSyEAGDG7P8Y38uSOazCyE8lNByO3TzEClXiHxikxW2
         hqYpwGGOkO4/hevaaexMbhcVAG7LfulFbOISFyPaEO6Bm0jhPyuJ60MPdWFbWjFkI0
         z2Cg4o/3HNp/6ZZr1tSMAnPPMNnQH5oPqcQsTTCXonuTwrFlYEvL5Fgof/sMQRrOjq
         XwXwD3FvMh/TzwRnWrMikF1RVQzgfq4JnuPtsqtgZ0QJhXHOH6rxpo+SdVXGh4WiUw
         x4E/OAw6b/fFA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/4] bnxt: make sure xmit_more + errors does not miss doorbells
Date:   Wed, 11 Aug 2021 12:32:38 -0700
Message-Id: <20210811193239.3155396-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811193239.3155396-1-kuba@kernel.org>
References: <20210811193239.3155396-1-kuba@kernel.org>
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

The ring should never be busy given the queue is stopped in advance
so add a warning there and ignore the busy case.

Noticed while reading the code.

Fixes: 4d172f21cefe ("bnxt_en: Implement xmit_more.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 33 +++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2c0240ee2105..b80ed556c28b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -367,6 +367,13 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
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
@@ -396,6 +403,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
 		netif_tx_stop_queue(txq);
+		if (net_ratelimit())
+			netdev_warn(dev, "bnxt: ring busy!\n");
 		return NETDEV_TX_BUSY;
 	}
 
@@ -516,21 +525,16 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -617,13 +621,15 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
 
@@ -661,7 +667,12 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			       PCI_DMA_TODEVICE);
 	}
 
+tx_free:
 	dev_kfree_skb_any(skb);
+tx_kick_pending:
+	tx_buf->skb = NULL;
+	if (txr->kick_pending)
+		bnxt_txr_db_kick(bp, txr, prod);
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


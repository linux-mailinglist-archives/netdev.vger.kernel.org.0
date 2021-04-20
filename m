Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE7F366277
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbhDTX1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:27:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33344 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbhDTX1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 19:27:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id B90444D2540B5
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 16:26:31 -0700 (PDT)
Date:   Tue, 20 Apr 2021 16:26:27 -0700 (PDT)
Message-Id: <20210420.162627.432702890482234178.davem@davemloft.net>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next] korina: Fix conflict with global symbol
 desc_empty on x86.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 20 Apr 2021 16:26:31 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/korina.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 4878e527e3c8..4613bc21130b 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1,4 +1,4 @@
-/*
+>/*
  *  Driver for the IDT RC32434 (Korina) on-chip ethernet controller.
  *
  *  Copyright 2004 IDT Inc. (rischelp@idt.com)
@@ -323,7 +323,7 @@ struct dma_reg {
 
 enum chain_status {
 	desc_filled,
-	desc_empty
+	desc_is_empty
 };
 
 #define DMA_COUNT(count)	((count) & DMA_DESC_COUNT_MSK)
@@ -459,7 +459,7 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 	chain_next = (idx + 1) & KORINA_TDS_MASK;
 
 	if (readl(&(lp->tx_dma_regs->dmandptr)) == 0) {
-		if (lp->tx_chain_status == desc_empty) {
+		if (lp->tx_chain_status == desc_is_empty) {
 			/* Update tail */
 			td->control = DMA_COUNT(length) |
 					DMA_DESC_COF | DMA_DESC_IOF;
@@ -486,10 +486,10 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 			       &lp->tx_dma_regs->dmandptr);
 			/* Move head to tail */
 			lp->tx_chain_head = lp->tx_chain_tail;
-			lp->tx_chain_status = desc_empty;
+			lp->tx_chain_status = desc_is_empty;
 		}
 	} else {
-		if (lp->tx_chain_status == desc_empty) {
+		if (lp->tx_chain_status == desc_is_empty) {
 			/* Update tail */
 			td->control = DMA_COUNT(length) |
 					DMA_DESC_COF | DMA_DESC_IOF;
@@ -868,7 +868,7 @@ korina_tx_dma_interrupt(int irq, void *dev_id)
 			(readl(&(lp->tx_dma_regs->dmandptr)) == 0)) {
 			writel(korina_tx_dma(lp, lp->tx_chain_head),
 			       &lp->tx_dma_regs->dmandptr);
-			lp->tx_chain_status = desc_empty;
+			lp->tx_chain_status = desc_is_empty;
 			lp->tx_chain_head = lp->tx_chain_tail;
 			netif_trans_update(dev);
 		}
@@ -999,7 +999,7 @@ static int korina_alloc_ring(struct net_device *dev)
 	}
 	lp->tx_next_done = lp->tx_chain_head = lp->tx_chain_tail =
 			lp->tx_full = lp->tx_count = 0;
-	lp->tx_chain_status = desc_empty;
+	lp->tx_chain_status = desc_is_empty;
 
 	/* Initialize the receive descriptors */
 	for (i = 0; i < KORINA_NUM_RDS; i++) {
@@ -1027,7 +1027,7 @@ static int korina_alloc_ring(struct net_device *dev)
 	lp->rx_next_done  = 0;
 	lp->rx_chain_head = 0;
 	lp->rx_chain_tail = 0;
-	lp->rx_chain_status = desc_empty;
+	lp->rx_chain_status = desc_is_empty;
 
 	return 0;
 }
-- 
2.26.3


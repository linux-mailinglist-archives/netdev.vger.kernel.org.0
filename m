Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC750366D78
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbhDUOB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236913AbhDUOB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 10:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04BEC61439;
        Wed, 21 Apr 2021 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619013684;
        bh=NAHWkIPCTubNFEdu5PvwFwsX+MLtZ95c+VqOn5fzIh4=;
        h=From:To:Cc:Subject:Date:From;
        b=V0OlZwE/BdwxgfEFfE7u7GYoWVM37GunB6tDOud82E9Xz8pxNlkcuPkX+mZI20RbS
         u1rOmTgFI9nLr9EPxFOyPUOa71vI7xohjtKWJ5zlA0pwxNUA7NZeHLvumsxtCnacKC
         cGOOc/C6rnyCBmwakagZxIFYlvgi9r7pihmezpatE1dGc7HI7V64wYxg9IzLJbcmA3
         fkeNKAiChjdTCd3ii74YakQDxgD+SRDNOG8FPaNAiOKdawT9MUz3xoNyl1STztOewQ
         aT/hJL+4f8v8b2e67055l901H0Lup7vIzBLoBXNedPIWinQ+VKzB09RLhxo6wvtISJ
         BtWUvxgN2WTaA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Mike Rapoport <rppt@kernel.org>,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] net: korina: fix compile-testing on x86
Date:   Wed, 21 Apr 2021 16:01:12 +0200
Message-Id: <20210421140117.3745422-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The 'desc_empty' enum in this driver conflicts with a function
of the same namem that is declared in an x86 header:

drivers/net/ethernet/korina.c:326:9: error: 'desc_empty' redeclared as different kind of symbol
  326 |         desc_empty
      |         ^~~~~~~~~~
In file included from arch/x86/include/asm/elf.h:93,
                 from include/linux/elf.h:6,
                 from include/linux/module.h:18,
                 from drivers/net/ethernet/korina.c:36:
arch/x86/include/asm/desc.h:99:19: note: previous definition of 'desc_empty' with type 'int(const void *)'
   99 | static inline int desc_empty(const void *ptr)

As the header was there first, rename the enum value to use
a more specific namespace.

Fixes: 6ef92063bf94 ("net: korina: Make driver COMPILE_TESTable")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/korina.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 4878e527e3c8..300b5e8aac3a 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -322,8 +322,8 @@ struct dma_reg {
 #define TX_TIMEOUT	(6000 * HZ / 1000)
 
 enum chain_status {
-	desc_filled,
-	desc_empty
+	korina_desc_filled,
+	korina_desc_empty
 };
 
 #define DMA_COUNT(count)	((count) & DMA_DESC_COUNT_MSK)
@@ -459,7 +459,7 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 	chain_next = (idx + 1) & KORINA_TDS_MASK;
 
 	if (readl(&(lp->tx_dma_regs->dmandptr)) == 0) {
-		if (lp->tx_chain_status == desc_empty) {
+		if (lp->tx_chain_status == korina_desc_empty) {
 			/* Update tail */
 			td->control = DMA_COUNT(length) |
 					DMA_DESC_COF | DMA_DESC_IOF;
@@ -486,16 +486,16 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 			       &lp->tx_dma_regs->dmandptr);
 			/* Move head to tail */
 			lp->tx_chain_head = lp->tx_chain_tail;
-			lp->tx_chain_status = desc_empty;
+			lp->tx_chain_status = korina_desc_empty;
 		}
 	} else {
-		if (lp->tx_chain_status == desc_empty) {
+		if (lp->tx_chain_status == korina_desc_empty) {
 			/* Update tail */
 			td->control = DMA_COUNT(length) |
 					DMA_DESC_COF | DMA_DESC_IOF;
 			/* Move tail */
 			lp->tx_chain_tail = chain_next;
-			lp->tx_chain_status = desc_filled;
+			lp->tx_chain_status = korina_desc_filled;
 		} else {
 			/* Update tail */
 			td->control = DMA_COUNT(length) |
@@ -864,11 +864,11 @@ korina_tx_dma_interrupt(int irq, void *dev_id)
 
 		korina_tx(dev);
 
-		if (lp->tx_chain_status == desc_filled &&
+		if (lp->tx_chain_status == korina_desc_filled &&
 			(readl(&(lp->tx_dma_regs->dmandptr)) == 0)) {
 			writel(korina_tx_dma(lp, lp->tx_chain_head),
 			       &lp->tx_dma_regs->dmandptr);
-			lp->tx_chain_status = desc_empty;
+			lp->tx_chain_status = korina_desc_empty;
 			lp->tx_chain_head = lp->tx_chain_tail;
 			netif_trans_update(dev);
 		}
@@ -999,7 +999,7 @@ static int korina_alloc_ring(struct net_device *dev)
 	}
 	lp->tx_next_done = lp->tx_chain_head = lp->tx_chain_tail =
 			lp->tx_full = lp->tx_count = 0;
-	lp->tx_chain_status = desc_empty;
+	lp->tx_chain_status = korina_desc_empty;
 
 	/* Initialize the receive descriptors */
 	for (i = 0; i < KORINA_NUM_RDS; i++) {
@@ -1027,7 +1027,7 @@ static int korina_alloc_ring(struct net_device *dev)
 	lp->rx_next_done  = 0;
 	lp->rx_chain_head = 0;
 	lp->rx_chain_tail = 0;
-	lp->rx_chain_status = desc_empty;
+	lp->rx_chain_status = korina_desc_empty;
 
 	return 0;
 }
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8910292411
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgJSI6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:58:02 -0400
Received: from twspam01.aspeedtech.com ([211.20.114.71]:65365 "EHLO
        twspam01.aspeedtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729915AbgJSI6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 04:58:01 -0400
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 09J8sp8m046775;
        Mon, 19 Oct 2020 16:54:51 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.9) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct
 2020 16:57:27 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ratbert@faraday-tech.com>,
        <linux-aspeed@lists.ozlabs.org>, <openbmc@lists.ozlabs.org>
CC:     <BMC-SW@aspeedtech.com>, Joel Stanley <joel@jms.id.au>
Subject: [PATCH 3/4] ftgmac100: Add a dummy read to ensure running sequence
Date:   Mon, 19 Oct 2020 16:57:16 +0800
Message-ID: <20201019085717.32413-4-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201019085717.32413-1-dylan_hung@aspeedtech.com>
References: <20201019085717.32413-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.10.9]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 09J8sp8m046775
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the AST2600 care must be taken to ensure writes appear correctly when
modifying the interrupt reglated registers.

Add a function to perform a read after all writes to the IER and ISR registers.

Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 38 ++++++++++++------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 810bda80f138..0c67fc3e27df 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -111,6 +111,14 @@ struct ftgmac100 {
 	bool is_aspeed;
 };
 
+/* Helper to ensure writes are observed with the correct ordering. Use only
+ * for IER and ISR accesses. */
+static void ftgmac100_write(u32 val, void __iomem *addr)
+{
+	iowrite32(val, addr);
+	ioread32(addr);
+}
+
 static int ftgmac100_reset_mac(struct ftgmac100 *priv, u32 maccr)
 {
 	struct net_device *netdev = priv->netdev;
@@ -1048,7 +1056,7 @@ static void ftgmac100_adjust_link(struct net_device *netdev)
 		return;
 
 	/* Disable all interrupts */
-	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
+	ftgmac100_write(0, priv->base + FTGMAC100_OFFSET_IER);
 
 	/* Reset the adapter asynchronously */
 	schedule_work(&priv->reset_task);
@@ -1246,7 +1254,7 @@ static irqreturn_t ftgmac100_interrupt(int irq, void *dev_id)
 
 	/* Fetch and clear interrupt bits, process abnormal ones */
 	status = ioread32(priv->base + FTGMAC100_OFFSET_ISR);
-	iowrite32(status, priv->base + FTGMAC100_OFFSET_ISR);
+	ftgmac100_write(status, priv->base + FTGMAC100_OFFSET_ISR);
 	if (unlikely(status & FTGMAC100_INT_BAD)) {
 
 		/* RX buffer unavailable */
@@ -1266,7 +1274,7 @@ static irqreturn_t ftgmac100_interrupt(int irq, void *dev_id)
 			if (net_ratelimit())
 				netdev_warn(netdev,
 					   "AHB bus error ! Resetting chip.\n");
-			iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
+			ftgmac100_write(0, priv->base + FTGMAC100_OFFSET_IER);
 			schedule_work(&priv->reset_task);
 			return IRQ_HANDLED;
 		}
@@ -1281,7 +1289,7 @@ static irqreturn_t ftgmac100_interrupt(int irq, void *dev_id)
 	}
 
 	/* Only enable "bad" interrupts while NAPI is on */
-	iowrite32(new_mask, priv->base + FTGMAC100_OFFSET_IER);
+	ftgmac100_write(new_mask, priv->base + FTGMAC100_OFFSET_IER);
 
 	/* Schedule NAPI bh */
 	napi_schedule_irqoff(&priv->napi);
@@ -1320,8 +1328,7 @@ static int ftgmac100_poll(struct napi_struct *napi, int budget)
 		ftgmac100_start_hw(priv);
 
 		/* Re-enable "bad" interrupts */
-		iowrite32(FTGMAC100_INT_BAD,
-			  priv->base + FTGMAC100_OFFSET_IER);
+		ftgmac100_write(FTGMAC100_INT_BAD, priv->base + FTGMAC100_OFFSET_IER);
 	}
 
 	/* As long as we are waiting for transmit packets to be
@@ -1336,13 +1343,7 @@ static int ftgmac100_poll(struct napi_struct *napi, int budget)
 		 * they were masked. So we clear them first, then we need
 		 * to re-check if there's something to process
 		 */
-		iowrite32(FTGMAC100_INT_RXTX,
-			  priv->base + FTGMAC100_OFFSET_ISR);
-
-		/* Push the above (and provides a barrier vs. subsequent
-		 * reads of the descriptor).
-		 */
-		ioread32(priv->base + FTGMAC100_OFFSET_ISR);
+		ftgmac100_write(FTGMAC100_INT_RXTX, priv->base + FTGMAC100_OFFSET_ISR);
 
 		/* Check RX and TX descriptors for more work to do */
 		if (ftgmac100_check_rx(priv) ||
@@ -1353,8 +1354,7 @@ static int ftgmac100_poll(struct napi_struct *napi, int budget)
 		napi_complete(napi);
 
 		/* enable all interrupts */
-		iowrite32(FTGMAC100_INT_ALL,
-			  priv->base + FTGMAC100_OFFSET_IER);
+		ftgmac100_write(FTGMAC100_INT_ALL, priv->base + FTGMAC100_OFFSET_IER);
 	}
 
 	return work_done;
@@ -1382,7 +1382,7 @@ static int ftgmac100_init_all(struct ftgmac100 *priv, bool ignore_alloc_err)
 	netif_start_queue(priv->netdev);
 
 	/* Enable all interrupts */
-	iowrite32(FTGMAC100_INT_ALL, priv->base + FTGMAC100_OFFSET_IER);
+	ftgmac100_write(FTGMAC100_INT_ALL, priv->base + FTGMAC100_OFFSET_IER);
 
 	return err;
 }
@@ -1508,7 +1508,7 @@ static int ftgmac100_open(struct net_device *netdev)
  err_irq:
 	netif_napi_del(&priv->napi);
  err_hw:
-	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
+	ftgmac100_write(0, priv->base + FTGMAC100_OFFSET_IER);
 	ftgmac100_free_rings(priv);
 	return err;
 }
@@ -1526,7 +1526,7 @@ static int ftgmac100_stop(struct net_device *netdev)
 	 */
 
 	/* disable all interrupts */
-	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
+	ftgmac100_write(0, priv->base + FTGMAC100_OFFSET_IER);
 
 	netif_stop_queue(netdev);
 	napi_disable(&priv->napi);
@@ -1549,7 +1549,7 @@ static void ftgmac100_tx_timeout(struct net_device *netdev, unsigned int txqueue
 	struct ftgmac100 *priv = netdev_priv(netdev);
 
 	/* Disable all interrupts */
-	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
+	ftgmac100_write(0, priv->base + FTGMAC100_OFFSET_IER);
 
 	/* Do the reset outside of interrupt context */
 	schedule_work(&priv->reset_task);
-- 
2.17.1


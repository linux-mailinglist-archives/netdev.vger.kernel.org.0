Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB924C1EF9
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244635AbiBWWpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244641AbiBWWpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:45:06 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A76D541BB
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:44:01 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0MZ-0006yL-Ax
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:59 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 008CB3BC61
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9128F3BC44;
        Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9a91e8b4;
        Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 35/36] can: mcp251xfd: prepare for multiple RX-FIFOs
Date:   Wed, 23 Feb 2022 23:43:31 +0100
Message-Id: <20220223224332.2965690-36-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223224332.2965690-1-mkl@pengutronix.de>
References: <20220223224332.2965690-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prepares the driver to use more than one RX-FIFO. Having a
bigger RX buffer is beneficial in high load situations, where the
system temporarily cannot keep up reading CAN frames from the chip.
Using a bigger RX buffer also allows to implement RX IRQ coalescing,
which will be added in a later patch series.

If using more than 1 RX-FIFO the driver has to figure out, which FIFOs
have RX'ed CAN frames pending. This is indicated by a set bit in the
RXIF register, which is positioned directly after the interrupt status
register INT. If more than 1 RX-FIFO is used, the driver reads both
registers in 1 transfer.

The mcp251xfd_handle_rxif() function iterates over all RX rings and
reads out the RX'ed CAN frames for for all pending FIFOs. To keep the
logic for the 1 RX-FIFO only case in mcp251xfd_handle_rxif() simple,
the driver marks that FIFO pending in mcp251xfd_ring_init().

The chip has a dedicated RX interrupt line to signal pending RX'ed
frames. If connected to an input GPIO and the driver will skip the
initial read of the interrupt status register (INT) and directly read
the pending RX'ed frames if the line is active. The driver assumes the
1st RX-FIFO pending (a read of the RXIF register would re-introduce
the skipped initial read of the INT register). Any other pending
RX-FIFO will be served in the main interrupt handler.

Link: https://lore.kernel.org/all/20220217103826.2299157-8-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 32 +++++++++++++++----
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    | 18 +++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c  | 12 +++++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  1 +
 4 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 2d033d12cdbb..d9aaaa91109d 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1384,6 +1384,20 @@ static int mcp251xfd_handle_spicrcif(struct mcp251xfd_priv *priv)
 	return 0;
 }
 
+static int mcp251xfd_read_regs_status(struct mcp251xfd_priv *priv)
+{
+	const int val_bytes = regmap_get_val_bytes(priv->map_reg);
+	size_t len;
+
+	if (priv->rx_ring_num == 1)
+		len = sizeof(priv->regs_status.intf);
+	else
+		len = sizeof(priv->regs_status);
+
+	return regmap_bulk_read(priv->map_reg, MCP251XFD_REG_INT,
+				&priv->regs_status, len / val_bytes);
+}
+
 #define mcp251xfd_handle(priv, irq, ...) \
 ({ \
 	struct mcp251xfd_priv *_priv = (priv); \
@@ -1400,7 +1414,6 @@ static int mcp251xfd_handle_spicrcif(struct mcp251xfd_priv *priv)
 static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 {
 	struct mcp251xfd_priv *priv = dev_id;
-	const int val_bytes = regmap_get_val_bytes(priv->map_reg);
 	irqreturn_t handled = IRQ_NONE;
 	int err;
 
@@ -1412,21 +1425,28 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 			if (!rx_pending)
 				break;
 
+			/* Assume 1st RX-FIFO pending, if other FIFOs
+			 * are pending the main IRQ handler will take
+			 * care.
+			 */
+			priv->regs_status.rxif = BIT(priv->rx[0]->fifo_nr);
 			err = mcp251xfd_handle(priv, rxif);
 			if (err)
 				goto out_fail;
 
 			handled = IRQ_HANDLED;
-		} while (1);
+
+			/* We don't know which RX-FIFO is pending, but only
+			 * handle the 1st RX-FIFO. Leave loop here if we have
+			 * more than 1 RX-FIFO to avoid starvation.
+			 */
+		} while (priv->rx_ring_num == 1);
 
 	do {
 		u32 intf_pending, intf_pending_clearable;
 		bool set_normal_mode = false;
 
-		err = regmap_bulk_read(priv->map_reg, MCP251XFD_REG_INT,
-				       &priv->regs_status,
-				       sizeof(priv->regs_status) /
-				       val_bytes);
+		err = mcp251xfd_read_regs_status(priv);
 		if (err)
 			goto out_fail;
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index 9610d262e966..848b8b2ecb5f 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -220,6 +220,24 @@ int mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 	mcp251xfd_ring_init_rx(priv, &base, &fifo_nr);
 	mcp251xfd_ring_init_tx(priv, &base, &fifo_nr);
 
+	/* mcp251xfd_handle_rxif() will iterate over all RX rings.
+	 * Rings with their corresponding bit set in
+	 * priv->regs_status.rxif are read out.
+	 *
+	 * If the chip is configured for only 1 RX-FIFO, and if there
+	 * is an RX interrupt pending (RXIF in INT register is set),
+	 * it must be the 1st RX-FIFO.
+	 *
+	 * We mark the RXIF of the 1st FIFO as pending here, so that
+	 * we can skip the read of the RXIF register in
+	 * mcp251xfd_read_regs_status() for the 1 RX-FIFO only case.
+	 *
+	 * If we use more than 1 RX-FIFO, this value gets overwritten
+	 * in mcp251xfd_read_regs_status(), so set it unconditionally
+	 * here.
+	 */
+	priv->regs_status.rxif = BIT(priv->rx[0]->fifo_nr);
+
 	netdev_dbg(priv->ndev,
 		   "FIFO setup: TEF:         0x%03x: %2d*%zu bytes = %4zu bytes\n",
 		   mcp251xfd_get_tef_obj_addr(0),
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
index 63f2526464b3..e6d39876065a 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
@@ -19,7 +19,7 @@
 static inline int
 mcp251xfd_rx_head_get_from_chip(const struct mcp251xfd_priv *priv,
 				const struct mcp251xfd_rx_ring *ring,
-				u8 *rx_head)
+				u8 *rx_head, bool *fifo_empty)
 {
 	u32 fifo_sta;
 	int err;
@@ -30,6 +30,7 @@ mcp251xfd_rx_head_get_from_chip(const struct mcp251xfd_priv *priv,
 		return err;
 
 	*rx_head = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
+	*fifo_empty = !(fifo_sta & MCP251XFD_REG_FIFOSTA_TFNRFNIF);
 
 	return 0;
 }
@@ -84,10 +85,12 @@ mcp251xfd_rx_ring_update(const struct mcp251xfd_priv *priv,
 {
 	u32 new_head;
 	u8 chip_rx_head;
+	bool fifo_empty;
 	int err;
 
-	err = mcp251xfd_rx_head_get_from_chip(priv, ring, &chip_rx_head);
-	if (err)
+	err = mcp251xfd_rx_head_get_from_chip(priv, ring, &chip_rx_head,
+					      &fifo_empty);
+	if (err || fifo_empty)
 		return err;
 
 	/* chip_rx_head, is the next RX-Object filled by the HW.
@@ -251,6 +254,9 @@ int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv)
 	int err, n;
 
 	mcp251xfd_for_each_rx_ring(priv, ring, n) {
+		if (!(priv->regs_status.rxif & BIT(ring->fifo_nr)))
+			continue;
+
 		err = mcp251xfd_handle_rxif_ring(priv, ring);
 		if (err)
 			return err;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 58e76064cf9e..f359dd0aa458 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -561,6 +561,7 @@ struct mcp251xfd_ecc {
 
 struct mcp251xfd_regs_status {
 	u32 intf;
+	u32 rxif;
 };
 
 enum mcp251xfd_model {
-- 
2.34.1



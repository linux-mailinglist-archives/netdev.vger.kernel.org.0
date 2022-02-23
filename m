Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359244C1F04
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbiBWWpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244629AbiBWWoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:44:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5152C53B4C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:43:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0MW-0006pA-ES
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:56 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id AD8693BC4F
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 42F603BC27;
        Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 47566219;
        Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 31/36] can: mcp251xfd: ring: prepare to change order of TX and RX FIFOs
Date:   Wed, 23 Feb 2022 23:43:27 +0100
Message-Id: <20220223224332.2965690-32-mkl@pengutronix.de>
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

This patch improves the initialization of the TX and RX rings. The
initialization functions are now called with pointers to the next free
address (in the on chip RAM) and next free hardware FIFO. The rings
are initialized using these values and the pointers are modified to
point to the next free elements.

This means the order of the mcp251xfd_ring_init_*() functions
specifies the order of the rings in the hardware FIFO. This makes it
possible to change the order of the TX and RX FIFOs, which is done in
the next patch.

This gives the opportunity to minimize the number of SPI transfers in
the IRQ handler. The read of the IRQ status register and RX FIFO
status registers can be combined into single SPI transfer. If the RX
ring uses FIFO 1, the overall length of the transfer is smaller than
in the original layout, where the RX FIFO comes after the TX FIFO.

Link: https://lore.kernel.org/all/20220217103826.2299157-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    | 47 ++++++++++---------
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  2 -
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index b9300554543e..39005725c665 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -52,7 +52,8 @@ mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
 	return len;
 }
 
-static void mcp251xfd_ring_init_tef(struct mcp251xfd_priv *priv)
+static void
+mcp251xfd_ring_init_tef(struct mcp251xfd_priv *priv, u16 *base)
 {
 	struct mcp251xfd_tef_ring *tef_ring;
 	struct spi_transfer *xfer;
@@ -66,6 +67,9 @@ static void mcp251xfd_ring_init_tef(struct mcp251xfd_priv *priv)
 	tef_ring->head = 0;
 	tef_ring->tail = 0;
 
+	/* TEF- and TX-FIFO have same number of objects */
+	*base = mcp251xfd_get_tef_obj_addr(priv->tx->obj_num);
+
 	/* FIFO increment TEF tail pointer */
 	addr = MCP251XFD_REG_TEFCON;
 	val = MCP251XFD_REG_TEFCON_UINC;
@@ -127,7 +131,8 @@ mcp251xfd_tx_ring_init_tx_obj(const struct mcp251xfd_priv *priv,
 					ARRAY_SIZE(tx_obj->xfer));
 }
 
-static void mcp251xfd_ring_init_tx(struct mcp251xfd_priv *priv)
+static void
+mcp251xfd_ring_init_tx(struct mcp251xfd_priv *priv, u16 *base, u8 *fifo_nr)
 {
 	struct mcp251xfd_tx_ring *tx_ring;
 	struct mcp251xfd_tx_obj *tx_obj;
@@ -139,9 +144,12 @@ static void mcp251xfd_ring_init_tx(struct mcp251xfd_priv *priv)
 	tx_ring = priv->tx;
 	tx_ring->head = 0;
 	tx_ring->tail = 0;
-	tx_ring->base = mcp251xfd_get_tef_obj_addr(tx_ring->obj_num);
+	tx_ring->base = *base;
 	tx_ring->nr = 0;
-	tx_ring->fifo_nr = MCP251XFD_TX_FIFO;
+	tx_ring->fifo_nr = *fifo_nr;
+
+	*base = mcp251xfd_get_tx_obj_addr(tx_ring, tx_ring->obj_num);
+	*fifo_nr += 1;
 
 	/* FIFO request to send */
 	addr = MCP251XFD_REG_FIFOCON(tx_ring->fifo_nr);
@@ -153,33 +161,25 @@ static void mcp251xfd_ring_init_tx(struct mcp251xfd_priv *priv)
 		mcp251xfd_tx_ring_init_tx_obj(priv, tx_ring, tx_obj, len, i);
 }
 
-static void mcp251xfd_ring_init_rx(struct mcp251xfd_priv *priv)
+static void
+mcp251xfd_ring_init_rx(struct mcp251xfd_priv *priv, u16 *base, u8 *fifo_nr)
 {
-	struct mcp251xfd_rx_ring *rx_ring, *prev_rx_ring = NULL;
-	struct mcp251xfd_tx_ring *tx_ring;
+	struct mcp251xfd_rx_ring *rx_ring;
 	struct spi_transfer *xfer;
 	u32 val;
 	u16 addr;
 	u8 len;
 	int i, j;
 
-	tx_ring = priv->tx;
 	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
 		rx_ring->head = 0;
 		rx_ring->tail = 0;
+		rx_ring->base = *base;
 		rx_ring->nr = i;
-		rx_ring->fifo_nr = MCP251XFD_RX_FIFO(i);
+		rx_ring->fifo_nr = *fifo_nr;
 
-		if (!prev_rx_ring)
-			rx_ring->base =
-				mcp251xfd_get_tx_obj_addr(tx_ring,
-							  tx_ring->obj_num);
-		else
-			rx_ring->base = prev_rx_ring->base +
-				prev_rx_ring->obj_size *
-				prev_rx_ring->obj_num;
-
-		prev_rx_ring = rx_ring;
+		*base = mcp251xfd_get_rx_obj_addr(rx_ring, rx_ring->obj_num);
+		*fifo_nr += 1;
 
 		/* FIFO increment RX tail pointer */
 		addr = MCP251XFD_REG_FIFOCON(rx_ring->fifo_nr);
@@ -209,11 +209,14 @@ static void mcp251xfd_ring_init_rx(struct mcp251xfd_priv *priv)
 
 void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 {
+	u16 base = 0;
+	u8 fifo_nr = 1;
+
 	netdev_reset_queue(priv->ndev);
 
-	mcp251xfd_ring_init_tef(priv);
-	mcp251xfd_ring_init_tx(priv);
-	mcp251xfd_ring_init_rx(priv);
+	mcp251xfd_ring_init_tef(priv, &base);
+	mcp251xfd_ring_init_tx(priv, &base, &fifo_nr);
+	mcp251xfd_ring_init_rx(priv, &base, &fifo_nr);
 }
 
 void mcp251xfd_ring_free(struct mcp251xfd_priv *priv)
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 12d3f2b84c0a..5c3f7f25caf0 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -383,8 +383,6 @@
 #endif
 
 #define MCP251XFD_NAPI_WEIGHT 32
-#define MCP251XFD_TX_FIFO 1
-#define MCP251XFD_RX_FIFO(x) (MCP251XFD_TX_FIFO + 1 + (x))
 
 /* SPI commands */
 #define MCP251XFD_SPI_INSTRUCTION_RESET 0x0000
-- 
2.34.1



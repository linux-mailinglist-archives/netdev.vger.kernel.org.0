Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A34D34E6B9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhC3LrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbhC3Lqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22762C061765
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpU-0006Mr-I2
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:40 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4A3FB603E9E
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:23 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 26A42603E27;
        Tue, 30 Mar 2021 11:46:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id da7df84e;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 23/39] can: mcp251xfd: simplify UINC handling
Date:   Tue, 30 Mar 2021 13:45:43 +0200
Message-Id: <20210330114559.1114855-24-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the patches:

| 1f652bb6bae7 can: mcp25xxfd: rx-path: reduce number of SPI core requests to set UINC bit
| 68c0c1c7f966 can: mcp251xfd: tef-path: reduce number of SPI core requests to set UINC bit

the setting of the UINC bit in the TEF and RX FIFO was batched into a
single SPI message consisting of several transfers. All transfers but
the last need to have the cs_change set to 1.

In the original patches the array of prepared transfers is send from
the beginning with the length depending on the number of read TEF/RX
objects. The cs_change of the last transfer is temporarily set to
0 during send.

This patch removes the modification of cs_change by preparing the last
transfer with cs_change to 0 and all other to 1. When sending the SPI
message the driver now starts with an offset into the array, so that
it always ends on the last entry in the array, which has the cs_change
set to 0.

Link: https://lore.kernel.org/r/20210304160328.2752293-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 69 ++++++++++---------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 88c6efeebe06..0c7bd1aa7719 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2,8 +2,8 @@
 //
 // mcp251xfd - Microchip MCP251xFD Family CAN controller driver
 //
-// Copyright (c) 2019, 2020 Pengutronix,
-//                          Marc Kleine-Budde <kernel@pengutronix.de>
+// Copyright (c) 2019, 2020, 2021 Pengutronix,
+//               Marc Kleine-Budde <kernel@pengutronix.de>
 //
 // Based on:
 //
@@ -330,6 +330,7 @@ static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 	struct mcp251xfd_tx_ring *tx_ring;
 	struct mcp251xfd_rx_ring *rx_ring, *prev_rx_ring = NULL;
 	struct mcp251xfd_tx_obj *tx_obj;
+	struct spi_transfer *xfer;
 	u32 val;
 	u16 addr;
 	u8 len;
@@ -347,8 +348,6 @@ static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 					      addr, val, val);
 
 	for (j = 0; j < ARRAY_SIZE(tef_ring->uinc_xfer); j++) {
-		struct spi_transfer *xfer;
-
 		xfer = &tef_ring->uinc_xfer[j];
 		xfer->tx_buf = &tef_ring->uinc_buf;
 		xfer->len = len;
@@ -357,6 +356,15 @@ static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 		xfer->cs_change_delay.unit = SPI_DELAY_UNIT_NSECS;
 	}
 
+	/* "cs_change == 1" on the last transfer results in an active
+	 * chip select after the complete SPI message. This causes the
+	 * controller to interpret the next register access as
+	 * data. Set "cs_change" of the last transfer to "0" to
+	 * properly deactivate the chip select at the end of the
+	 * message.
+	 */
+	xfer->cs_change = 0;
+
 	/* TX */
 	tx_ring = priv->tx;
 	tx_ring->head = 0;
@@ -397,8 +405,6 @@ static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 						      addr, val, val);
 
 		for (j = 0; j < ARRAY_SIZE(rx_ring->uinc_xfer); j++) {
-			struct spi_transfer *xfer;
-
 			xfer = &rx_ring->uinc_xfer[j];
 			xfer->tx_buf = &rx_ring->uinc_buf;
 			xfer->len = len;
@@ -406,6 +412,15 @@ static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 			xfer->cs_change_delay.value = 0;
 			xfer->cs_change_delay.unit = SPI_DELAY_UNIT_NSECS;
 		}
+
+		/* "cs_change == 1" on the last transfer results in an
+		 * active chip select after the complete SPI
+		 * message. This causes the controller to interpret
+		 * the next register access as data. Set "cs_change"
+		 * of the last transfer to "0" to properly deactivate
+		 * the chip select at the end of the message.
+		 */
+		xfer->cs_change = 0;
 	}
 }
 
@@ -1366,25 +1381,20 @@ static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
 	if (len) {
 		struct mcp251xfd_tef_ring *ring = priv->tef;
 		struct mcp251xfd_tx_ring *tx_ring = priv->tx;
-		struct spi_transfer *last_xfer;
+		int offset;
 
 		/* Increment the TEF FIFO tail pointer 'len' times in
 		 * a single SPI message.
 		 *
 		 * Note:
-		 *
-		 * "cs_change == 1" on the last transfer results in an
-		 * active chip select after the complete SPI
-		 * message. This causes the controller to interpret
-		 * the next register access as data. Temporary set
-		 * "cs_change" of the last transfer to "0" to properly
-		 * deactivate the chip select at the end of the
-		 * message.
+		 * Calculate offset, so that the SPI transfer ends on
+		 * the last message of the uinc_xfer array, which has
+		 * "cs_change == 0", to properly deactivate the chip
+		 * select.
 		 */
-		last_xfer = &ring->uinc_xfer[len - 1];
-		last_xfer->cs_change = 0;
-		err = spi_sync_transfer(priv->spi, ring->uinc_xfer, len);
-		last_xfer->cs_change = 1;
+		offset = ARRAY_SIZE(ring->uinc_xfer) - len;
+		err = spi_sync_transfer(priv->spi,
+					ring->uinc_xfer + offset, len);
 		if (err)
 			return err;
 
@@ -1536,7 +1546,7 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 		return err;
 
 	while ((len = mcp251xfd_get_rx_linear_len(ring))) {
-		struct spi_transfer *last_xfer;
+		int offset;
 
 		rx_tail = mcp251xfd_get_rx_tail(ring);
 
@@ -1557,19 +1567,14 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 		 * single SPI message.
 		 *
 		 * Note:
-		 *
-		 * "cs_change == 1" on the last transfer results in an
-		 * active chip select after the complete SPI
-		 * message. This causes the controller to interpret
-		 * the next register access as data. Temporary set
-		 * "cs_change" of the last transfer to "0" to properly
-		 * deactivate the chip select at the end of the
-		 * message.
+		 * Calculate offset, so that the SPI transfer ends on
+		 * the last message of the uinc_xfer array, which has
+		 * "cs_change == 0", to properly deactivate the chip
+		 * select.
 		 */
-		last_xfer = &ring->uinc_xfer[len - 1];
-		last_xfer->cs_change = 0;
-		err = spi_sync_transfer(priv->spi, ring->uinc_xfer, len);
-		last_xfer->cs_change = 1;
+		offset = ARRAY_SIZE(ring->uinc_xfer) - len;
+		err = spi_sync_transfer(priv->spi,
+					ring->uinc_xfer + offset, len);
 		if (err)
 			return err;
 
-- 
2.30.2



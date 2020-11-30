Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9171B2C8659
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgK3OQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgK3OQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:16:02 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908BDC061A48
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:14:45 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjjwy-0007eA-02
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 15:14:44 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B6FB859FAFB
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:14:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7922D59FAC4;
        Mon, 30 Nov 2020 14:14:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 850c4d2a;
        Mon, 30 Nov 2020 14:14:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Ursula Maplehurst <ursula@kangatronix.co.uk>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 03/14] can: mcp25xxfd: rx-path: reduce number of SPI core requests to set UINC bit
Date:   Mon, 30 Nov 2020 15:14:21 +0100
Message-Id: <20201130141432.278219-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130141432.278219-1-mkl@pengutronix.de>
References: <20201130141432.278219-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Maplehurst <ursula@kangatronix.co.uk>

Reduce the number of separate SPI core requests when setting the UINC bit in
the RX FIFO, and instead batch them up into a single SPI core request.

Link: https://github.com/marckleinebudde/linux/issues/4
Link: https://lore.kernel.org/r/20201126132144.351154-3-mkl@pengutronix.de
Tested-by: Thomas Kopp <thomas.kopp@microchip.com>
Signed-off-by: Ursula Maplehurst <ursula@kangatronix.co.uk>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 51 ++++++++++++++++---
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  2 +
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 476a2e4a1de8..c770733ecbcc 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -332,7 +332,7 @@ static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 	u32 val;
 	u16 addr;
 	u8 len;
-	int i;
+	int i, j;
 
 	/* TEF */
 	priv->tef.head = 0;
@@ -370,6 +370,23 @@ static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 				prev_rx_ring->obj_num;
 
 		prev_rx_ring = rx_ring;
+
+		/* FIFO increment RX tail pointer */
+		addr = MCP251XFD_REG_FIFOCON(rx_ring->fifo_nr);
+		val = MCP251XFD_REG_FIFOCON_UINC;
+		len = mcp251xfd_cmd_prepare_write_reg(priv, &rx_ring->uinc_buf,
+						      addr, val, val);
+
+		for (j = 0; j < ARRAY_SIZE(rx_ring->uinc_xfer); j++) {
+			struct spi_transfer *xfer;
+
+			xfer = &rx_ring->uinc_xfer[j];
+			xfer->tx_buf = &rx_ring->uinc_buf;
+			xfer->len = len;
+			xfer->cs_change = 1;
+			xfer->cs_change_delay.value = 0;
+			xfer->cs_change_delay.unit = SPI_DELAY_UNIT_NSECS;
+		}
 	}
 }
 
@@ -1440,13 +1457,7 @@ mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
 	if (err)
 		stats->rx_fifo_errors++;
 
-	ring->tail++;
-
-	/* finally increment the RX pointer */
-	return regmap_update_bits(priv->map_reg,
-				  MCP251XFD_REG_FIFOCON(ring->fifo_nr),
-				  GENMASK(15, 8),
-				  MCP251XFD_REG_FIFOCON_UINC);
+	return 0;
 }
 
 static inline int
@@ -1478,6 +1489,8 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 		return err;
 
 	while ((len = mcp251xfd_get_rx_linear_len(ring))) {
+		struct spi_transfer *last_xfer;
+
 		rx_tail = mcp251xfd_get_rx_tail(ring);
 
 		err = mcp251xfd_rx_obj_read(priv, ring, hw_rx_obj,
@@ -1492,6 +1505,28 @@ mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
 			if (err)
 				return err;
 		}
+
+		/* Increment the RX FIFO tail pointer 'len' times in a
+		 * single SPI message.
+		 */
+		ring->tail += len;
+
+		/* Note:
+		 *
+		 * "cs_change == 1" on the last transfer results in an
+		 * active chip select after the complete SPI
+		 * message. This causes the controller to interpret
+		 * the next register access as data. Temporary set
+		 * "cs_change" of the last transfer to "0" to properly
+		 * deactivate the chip select at the end of the
+		 * message.
+		 */
+		last_xfer = &ring->uinc_xfer[len - 1];
+		last_xfer->cs_change = 0;
+		err = spi_sync_transfer(priv->spi, ring->uinc_xfer, len);
+		last_xfer->cs_change = 1;
+		if (err)
+			return err;
 	}
 
 	return 0;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index c20c97d01072..97dc182e2b42 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -528,6 +528,8 @@ struct mcp251xfd_rx_ring {
 	u8 obj_num;
 	u8 obj_size;
 
+	union mcp251xfd_write_reg_buf uinc_buf;
+	struct spi_transfer uinc_xfer[MCP251XFD_RX_OBJ_NUM_MAX];
 	struct mcp251xfd_hw_rx_obj_canfd obj[];
 };
 
-- 
2.29.2



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA036488662
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiAHVoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbiAHVoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BF4C06175A
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:07 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVO-0004Yy-3S
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:06 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id F10EF6D3A90
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4B6D56D3A19;
        Sat,  8 Jan 2022 21:43:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ec3a42c2;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 12/22] can: mcp251xfd: move chip FIFO init into separate file
Date:   Sat,  8 Jan 2022 22:43:35 +0100
Message-Id: <20220108214345.1848470-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108214345.1848470-1-mkl@pengutronix.de>
References: <20220108214345.1848470-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the chip FIFO initialization from the mcp251xfd core
file into a separate one to make the driver a bit more orderly.

Link: https://lore.kernel.org/all/20220105154300.1258636-12-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/Makefile        |   1 +
 .../can/spi/mcp251xfd/mcp251xfd-chip-fifo.c   | 119 ++++++++++++++++++
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 102 ---------------
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |   1 +
 4 files changed, 121 insertions(+), 102 deletions(-)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c

diff --git a/drivers/net/can/spi/mcp251xfd/Makefile b/drivers/net/can/spi/mcp251xfd/Makefile
index 801367e98c54..6de680e7ea50 100644
--- a/drivers/net/can/spi/mcp251xfd/Makefile
+++ b/drivers/net/can/spi/mcp251xfd/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_CAN_MCP251XFD) += mcp251xfd.o
 
 mcp251xfd-objs :=
+mcp251xfd-objs += mcp251xfd-chip-fifo.o
 mcp251xfd-objs += mcp251xfd-core.o
 mcp251xfd-objs += mcp251xfd-crc16.o
 mcp251xfd-objs += mcp251xfd-regmap.o
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c
new file mode 100644
index 000000000000..ce94dd744a93
--- /dev/null
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// mcp251xfd - Microchip MCP251xFD Family CAN controller driver
+//
+// Copyright (c) 2019, 2020, 2021 Pengutronix,
+//               Marc Kleine-Budde <kernel@pengutronix.de>
+//
+// Based on:
+//
+// CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+//
+// Copyright (c) 2019 Martin Sperl <kernel@martin.sperl.org>
+//
+
+#include <linux/bitfield.h>
+
+#include "mcp251xfd.h"
+
+static int
+mcp251xfd_chip_rx_fifo_init_one(const struct mcp251xfd_priv *priv,
+				const struct mcp251xfd_rx_ring *ring)
+{
+	u32 fifo_con;
+
+	/* Enable RXOVIE on _all_ RX FIFOs, not just the last one.
+	 *
+	 * FIFOs hit by a RX MAB overflow and RXOVIE enabled will
+	 * generate a RXOVIF, use this to properly detect RX MAB
+	 * overflows.
+	 */
+	fifo_con = FIELD_PREP(MCP251XFD_REG_FIFOCON_FSIZE_MASK,
+			      ring->obj_num - 1) |
+		MCP251XFD_REG_FIFOCON_RXTSEN |
+		MCP251XFD_REG_FIFOCON_RXOVIE |
+		MCP251XFD_REG_FIFOCON_TFNRFNIE;
+
+	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_FD))
+		fifo_con |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
+				       MCP251XFD_REG_FIFOCON_PLSIZE_64);
+	else
+		fifo_con |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
+				       MCP251XFD_REG_FIFOCON_PLSIZE_8);
+
+	return regmap_write(priv->map_reg,
+			    MCP251XFD_REG_FIFOCON(ring->fifo_nr), fifo_con);
+}
+
+static int
+mcp251xfd_chip_rx_filter_init_one(const struct mcp251xfd_priv *priv,
+				  const struct mcp251xfd_rx_ring *ring)
+{
+	u32 fltcon;
+
+	fltcon = MCP251XFD_REG_FLTCON_FLTEN(ring->nr) |
+		MCP251XFD_REG_FLTCON_FBP(ring->nr, ring->fifo_nr);
+
+	return regmap_update_bits(priv->map_reg,
+				  MCP251XFD_REG_FLTCON(ring->nr >> 2),
+				  MCP251XFD_REG_FLTCON_FLT_MASK(ring->nr),
+				  fltcon);
+}
+
+int mcp251xfd_chip_fifo_init(const struct mcp251xfd_priv *priv)
+{
+	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	const struct mcp251xfd_rx_ring *rx_ring;
+	u32 val;
+	int err, n;
+
+	/* TEF */
+	val = FIELD_PREP(MCP251XFD_REG_TEFCON_FSIZE_MASK,
+			 tx_ring->obj_num - 1) |
+		MCP251XFD_REG_TEFCON_TEFTSEN |
+		MCP251XFD_REG_TEFCON_TEFOVIE |
+		MCP251XFD_REG_TEFCON_TEFNEIE;
+
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_TEFCON, val);
+	if (err)
+		return err;
+
+	/* FIFO 1 - TX */
+	val = FIELD_PREP(MCP251XFD_REG_FIFOCON_FSIZE_MASK,
+			 tx_ring->obj_num - 1) |
+		MCP251XFD_REG_FIFOCON_TXEN |
+		MCP251XFD_REG_FIFOCON_TXATIE;
+
+	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_FD))
+		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
+				  MCP251XFD_REG_FIFOCON_PLSIZE_64);
+	else
+		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
+				  MCP251XFD_REG_FIFOCON_PLSIZE_8);
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_TXAT_MASK,
+				  MCP251XFD_REG_FIFOCON_TXAT_ONE_SHOT);
+	else
+		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_TXAT_MASK,
+				  MCP251XFD_REG_FIFOCON_TXAT_UNLIMITED);
+
+	err = regmap_write(priv->map_reg,
+			   MCP251XFD_REG_FIFOCON(MCP251XFD_TX_FIFO),
+			   val);
+	if (err)
+		return err;
+
+	/* RX FIFOs */
+	mcp251xfd_for_each_rx_ring(priv, rx_ring, n) {
+		err = mcp251xfd_chip_rx_fifo_init_one(priv, rx_ring);
+		if (err)
+			return err;
+
+		err = mcp251xfd_chip_rx_filter_init_one(priv, rx_ring);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 65803b9fe2a2..f7326c1b1723 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -767,108 +767,6 @@ static int mcp251xfd_chip_rx_int_disable(const struct mcp251xfd_priv *priv)
 	return regmap_write(priv->map_reg, MCP251XFD_REG_IOCON, val);
 }
 
-static int
-mcp251xfd_chip_rx_fifo_init_one(const struct mcp251xfd_priv *priv,
-				const struct mcp251xfd_rx_ring *ring)
-{
-	u32 fifo_con;
-
-	/* Enable RXOVIE on _all_ RX FIFOs, not just the last one.
-	 *
-	 * FIFOs hit by a RX MAB overflow and RXOVIE enabled will
-	 * generate a RXOVIF, use this to properly detect RX MAB
-	 * overflows.
-	 */
-	fifo_con = FIELD_PREP(MCP251XFD_REG_FIFOCON_FSIZE_MASK,
-			      ring->obj_num - 1) |
-		MCP251XFD_REG_FIFOCON_RXTSEN |
-		MCP251XFD_REG_FIFOCON_RXOVIE |
-		MCP251XFD_REG_FIFOCON_TFNRFNIE;
-
-	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_FD))
-		fifo_con |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
-				       MCP251XFD_REG_FIFOCON_PLSIZE_64);
-	else
-		fifo_con |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
-				       MCP251XFD_REG_FIFOCON_PLSIZE_8);
-
-	return regmap_write(priv->map_reg,
-			    MCP251XFD_REG_FIFOCON(ring->fifo_nr), fifo_con);
-}
-
-static int
-mcp251xfd_chip_rx_filter_init_one(const struct mcp251xfd_priv *priv,
-				  const struct mcp251xfd_rx_ring *ring)
-{
-	u32 fltcon;
-
-	fltcon = MCP251XFD_REG_FLTCON_FLTEN(ring->nr) |
-		MCP251XFD_REG_FLTCON_FBP(ring->nr, ring->fifo_nr);
-
-	return regmap_update_bits(priv->map_reg,
-				  MCP251XFD_REG_FLTCON(ring->nr >> 2),
-				  MCP251XFD_REG_FLTCON_FLT_MASK(ring->nr),
-				  fltcon);
-}
-
-static int mcp251xfd_chip_fifo_init(const struct mcp251xfd_priv *priv)
-{
-	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
-	const struct mcp251xfd_rx_ring *rx_ring;
-	u32 val;
-	int err, n;
-
-	/* TEF */
-	val = FIELD_PREP(MCP251XFD_REG_TEFCON_FSIZE_MASK,
-			 tx_ring->obj_num - 1) |
-		MCP251XFD_REG_TEFCON_TEFTSEN |
-		MCP251XFD_REG_TEFCON_TEFOVIE |
-		MCP251XFD_REG_TEFCON_TEFNEIE;
-
-	err = regmap_write(priv->map_reg, MCP251XFD_REG_TEFCON, val);
-	if (err)
-		return err;
-
-	/* FIFO 1 - TX */
-	val = FIELD_PREP(MCP251XFD_REG_FIFOCON_FSIZE_MASK,
-			 tx_ring->obj_num - 1) |
-		MCP251XFD_REG_FIFOCON_TXEN |
-		MCP251XFD_REG_FIFOCON_TXATIE;
-
-	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_FD))
-		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
-				  MCP251XFD_REG_FIFOCON_PLSIZE_64);
-	else
-		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
-				  MCP251XFD_REG_FIFOCON_PLSIZE_8);
-
-	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
-		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_TXAT_MASK,
-				  MCP251XFD_REG_FIFOCON_TXAT_ONE_SHOT);
-	else
-		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_TXAT_MASK,
-				  MCP251XFD_REG_FIFOCON_TXAT_UNLIMITED);
-
-	err = regmap_write(priv->map_reg,
-			   MCP251XFD_REG_FIFOCON(MCP251XFD_TX_FIFO),
-			   val);
-	if (err)
-		return err;
-
-	/* RX FIFOs */
-	mcp251xfd_for_each_rx_ring(priv, rx_ring, n) {
-		err = mcp251xfd_chip_rx_fifo_init_one(priv, rx_ring);
-		if (err)
-			return err;
-
-		err = mcp251xfd_chip_rx_filter_init_one(priv, rx_ring);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static int mcp251xfd_chip_ecc_init(struct mcp251xfd_priv *priv)
 {
 	struct mcp251xfd_ecc *ecc = &priv->ecc;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 22a18d6fbda4..69220de0e413 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -868,6 +868,7 @@ mcp251xfd_get_rx_linear_len(const struct mcp251xfd_rx_ring *ring)
 	     (n) < (priv)->rx_ring_num; \
 	     (n)++, (ring) = *((priv)->rx + (n)))
 
+int mcp251xfd_chip_fifo_init(const struct mcp251xfd_priv *priv);
 u16 mcp251xfd_crc16_compute2(const void *cmd, size_t cmd_size,
 			     const void *data, size_t data_size);
 u16 mcp251xfd_crc16_compute(const void *data, size_t data_size);
-- 
2.34.1



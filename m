Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BB3488664
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiAHVoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiAHVoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D83DC061751
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:06 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVM-0004XD-Q3
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:04 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9E2B86D3A87
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 673066D3A1C;
        Sat,  8 Jan 2022 21:43:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 20133ac2;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/22] can: mcp251xfd: move ring init into separate function
Date:   Sat,  8 Jan 2022 22:43:36 +0100
Message-Id: <20220108214345.1848470-14-mkl@pengutronix.de>
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

This patch moves the ring initialization from the mcp251xfd core file
into a separate one to make the driver a bit more orderly.

Link: https://lore.kernel.org/all/20220105154300.1258636-13-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/Makefile        |   1 +
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 255 -----------------
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    | 270 ++++++++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |   3 +
 4 files changed, 274 insertions(+), 255 deletions(-)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c

diff --git a/drivers/net/can/spi/mcp251xfd/Makefile b/drivers/net/can/spi/mcp251xfd/Makefile
index 6de680e7ea50..a83d685d64e0 100644
--- a/drivers/net/can/spi/mcp251xfd/Makefile
+++ b/drivers/net/can/spi/mcp251xfd/Makefile
@@ -7,6 +7,7 @@ mcp251xfd-objs += mcp251xfd-chip-fifo.o
 mcp251xfd-objs += mcp251xfd-core.o
 mcp251xfd-objs += mcp251xfd-crc16.o
 mcp251xfd-objs += mcp251xfd-regmap.o
+mcp251xfd-objs += mcp251xfd-ring.o
 mcp251xfd-objs += mcp251xfd-rx.o
 mcp251xfd-objs += mcp251xfd-tef.o
 mcp251xfd-objs += mcp251xfd-timestamp.o
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index f7326c1b1723..b5986df6eca0 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -20,8 +20,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/property.h>
 
-#include <asm/unaligned.h>
-
 #include "mcp251xfd.h"
 
 #define DEVICE_NAME "mcp251xfd"
@@ -180,259 +178,6 @@ static int mcp251xfd_clks_and_vdd_disable(const struct mcp251xfd_priv *priv)
 	return 0;
 }
 
-static inline u8
-mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
-				union mcp251xfd_write_reg_buf *write_reg_buf,
-				const u16 reg, const u32 mask, const u32 val)
-{
-	u8 first_byte, last_byte, len;
-	u8 *data;
-	__le32 val_le32;
-
-	first_byte = mcp251xfd_first_byte_set(mask);
-	last_byte = mcp251xfd_last_byte_set(mask);
-	len = last_byte - first_byte + 1;
-
-	data = mcp251xfd_spi_cmd_write(priv, write_reg_buf, reg + first_byte);
-	val_le32 = cpu_to_le32(val >> BITS_PER_BYTE * first_byte);
-	memcpy(data, &val_le32, len);
-
-	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG) {
-		u16 crc;
-
-		mcp251xfd_spi_cmd_crc_set_len_in_reg(&write_reg_buf->crc.cmd,
-						     len);
-		/* CRC */
-		len += sizeof(write_reg_buf->crc.cmd);
-		crc = mcp251xfd_crc16_compute(&write_reg_buf->crc, len);
-		put_unaligned_be16(crc, (void *)write_reg_buf + len);
-
-		/* Total length */
-		len += sizeof(write_reg_buf->crc.crc);
-	} else {
-		len += sizeof(write_reg_buf->nocrc.cmd);
-	}
-
-	return len;
-}
-
-static void
-mcp251xfd_tx_ring_init_tx_obj(const struct mcp251xfd_priv *priv,
-			      const struct mcp251xfd_tx_ring *ring,
-			      struct mcp251xfd_tx_obj *tx_obj,
-			      const u8 rts_buf_len,
-			      const u8 n)
-{
-	struct spi_transfer *xfer;
-	u16 addr;
-
-	/* FIFO load */
-	addr = mcp251xfd_get_tx_obj_addr(ring, n);
-	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX)
-		mcp251xfd_spi_cmd_write_crc_set_addr(&tx_obj->buf.crc.cmd,
-						     addr);
-	else
-		mcp251xfd_spi_cmd_write_nocrc(&tx_obj->buf.nocrc.cmd,
-					      addr);
-
-	xfer = &tx_obj->xfer[0];
-	xfer->tx_buf = &tx_obj->buf;
-	xfer->len = 0;	/* actual len is assigned on the fly */
-	xfer->cs_change = 1;
-	xfer->cs_change_delay.value = 0;
-	xfer->cs_change_delay.unit = SPI_DELAY_UNIT_NSECS;
-
-	/* FIFO request to send */
-	xfer = &tx_obj->xfer[1];
-	xfer->tx_buf = &ring->rts_buf;
-	xfer->len = rts_buf_len;
-
-	/* SPI message */
-	spi_message_init_with_transfers(&tx_obj->msg, tx_obj->xfer,
-					ARRAY_SIZE(tx_obj->xfer));
-}
-
-static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
-{
-	struct mcp251xfd_tef_ring *tef_ring;
-	struct mcp251xfd_tx_ring *tx_ring;
-	struct mcp251xfd_rx_ring *rx_ring, *prev_rx_ring = NULL;
-	struct mcp251xfd_tx_obj *tx_obj;
-	struct spi_transfer *xfer;
-	u32 val;
-	u16 addr;
-	u8 len;
-	int i, j;
-
-	netdev_reset_queue(priv->ndev);
-
-	/* TEF */
-	tef_ring = priv->tef;
-	tef_ring->head = 0;
-	tef_ring->tail = 0;
-
-	/* FIFO increment TEF tail pointer */
-	addr = MCP251XFD_REG_TEFCON;
-	val = MCP251XFD_REG_TEFCON_UINC;
-	len = mcp251xfd_cmd_prepare_write_reg(priv, &tef_ring->uinc_buf,
-					      addr, val, val);
-
-	for (j = 0; j < ARRAY_SIZE(tef_ring->uinc_xfer); j++) {
-		xfer = &tef_ring->uinc_xfer[j];
-		xfer->tx_buf = &tef_ring->uinc_buf;
-		xfer->len = len;
-		xfer->cs_change = 1;
-		xfer->cs_change_delay.value = 0;
-		xfer->cs_change_delay.unit = SPI_DELAY_UNIT_NSECS;
-	}
-
-	/* "cs_change == 1" on the last transfer results in an active
-	 * chip select after the complete SPI message. This causes the
-	 * controller to interpret the next register access as
-	 * data. Set "cs_change" of the last transfer to "0" to
-	 * properly deactivate the chip select at the end of the
-	 * message.
-	 */
-	xfer->cs_change = 0;
-
-	/* TX */
-	tx_ring = priv->tx;
-	tx_ring->head = 0;
-	tx_ring->tail = 0;
-	tx_ring->base = mcp251xfd_get_tef_obj_addr(tx_ring->obj_num);
-
-	/* FIFO request to send */
-	addr = MCP251XFD_REG_FIFOCON(MCP251XFD_TX_FIFO);
-	val = MCP251XFD_REG_FIFOCON_TXREQ | MCP251XFD_REG_FIFOCON_UINC;
-	len = mcp251xfd_cmd_prepare_write_reg(priv, &tx_ring->rts_buf,
-					      addr, val, val);
-
-	mcp251xfd_for_each_tx_obj(tx_ring, tx_obj, i)
-		mcp251xfd_tx_ring_init_tx_obj(priv, tx_ring, tx_obj, len, i);
-
-	/* RX */
-	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
-		rx_ring->head = 0;
-		rx_ring->tail = 0;
-		rx_ring->nr = i;
-		rx_ring->fifo_nr = MCP251XFD_RX_FIFO(i);
-
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
-
-		/* FIFO increment RX tail pointer */
-		addr = MCP251XFD_REG_FIFOCON(rx_ring->fifo_nr);
-		val = MCP251XFD_REG_FIFOCON_UINC;
-		len = mcp251xfd_cmd_prepare_write_reg(priv, &rx_ring->uinc_buf,
-						      addr, val, val);
-
-		for (j = 0; j < ARRAY_SIZE(rx_ring->uinc_xfer); j++) {
-			xfer = &rx_ring->uinc_xfer[j];
-			xfer->tx_buf = &rx_ring->uinc_buf;
-			xfer->len = len;
-			xfer->cs_change = 1;
-			xfer->cs_change_delay.value = 0;
-			xfer->cs_change_delay.unit = SPI_DELAY_UNIT_NSECS;
-		}
-
-		/* "cs_change == 1" on the last transfer results in an
-		 * active chip select after the complete SPI
-		 * message. This causes the controller to interpret
-		 * the next register access as data. Set "cs_change"
-		 * of the last transfer to "0" to properly deactivate
-		 * the chip select at the end of the message.
-		 */
-		xfer->cs_change = 0;
-	}
-}
-
-static void mcp251xfd_ring_free(struct mcp251xfd_priv *priv)
-{
-	int i;
-
-	for (i = ARRAY_SIZE(priv->rx) - 1; i >= 0; i--) {
-		kfree(priv->rx[i]);
-		priv->rx[i] = NULL;
-	}
-}
-
-static int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
-{
-	struct mcp251xfd_tx_ring *tx_ring;
-	struct mcp251xfd_rx_ring *rx_ring;
-	int tef_obj_size, tx_obj_size, rx_obj_size;
-	int tx_obj_num;
-	int ram_free, i;
-
-	tef_obj_size = sizeof(struct mcp251xfd_hw_tef_obj);
-	/* listen-only mode works like FD mode */
-	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_FD)) {
-		tx_obj_num = MCP251XFD_TX_OBJ_NUM_CANFD;
-		tx_obj_size = sizeof(struct mcp251xfd_hw_tx_obj_canfd);
-		rx_obj_size = sizeof(struct mcp251xfd_hw_rx_obj_canfd);
-	} else {
-		tx_obj_num = MCP251XFD_TX_OBJ_NUM_CAN;
-		tx_obj_size = sizeof(struct mcp251xfd_hw_tx_obj_can);
-		rx_obj_size = sizeof(struct mcp251xfd_hw_rx_obj_can);
-	}
-
-	tx_ring = priv->tx;
-	tx_ring->obj_num = tx_obj_num;
-	tx_ring->obj_size = tx_obj_size;
-
-	ram_free = MCP251XFD_RAM_SIZE - tx_obj_num *
-		(tef_obj_size + tx_obj_size);
-
-	for (i = 0;
-	     i < ARRAY_SIZE(priv->rx) && ram_free >= rx_obj_size;
-	     i++) {
-		int rx_obj_num;
-
-		rx_obj_num = ram_free / rx_obj_size;
-		rx_obj_num = min(1 << (fls(rx_obj_num) - 1),
-				 MCP251XFD_RX_OBJ_NUM_MAX);
-
-		rx_ring = kzalloc(sizeof(*rx_ring) + rx_obj_size * rx_obj_num,
-				  GFP_KERNEL);
-		if (!rx_ring) {
-			mcp251xfd_ring_free(priv);
-			return -ENOMEM;
-		}
-		rx_ring->obj_num = rx_obj_num;
-		rx_ring->obj_size = rx_obj_size;
-		priv->rx[i] = rx_ring;
-
-		ram_free -= rx_ring->obj_num * rx_ring->obj_size;
-	}
-	priv->rx_ring_num = i;
-
-	netdev_dbg(priv->ndev,
-		   "FIFO setup: TEF: %d*%d bytes = %d bytes, TX: %d*%d bytes = %d bytes\n",
-		   tx_obj_num, tef_obj_size, tef_obj_size * tx_obj_num,
-		   tx_obj_num, tx_obj_size, tx_obj_size * tx_obj_num);
-
-	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
-		netdev_dbg(priv->ndev,
-			   "FIFO setup: RX-%d: %d*%d bytes = %d bytes\n",
-			   i, rx_ring->obj_num, rx_ring->obj_size,
-			   rx_ring->obj_size * rx_ring->obj_num);
-	}
-
-	netdev_dbg(priv->ndev,
-		   "FIFO setup: free: %d bytes\n",
-		   ram_free);
-
-	return 0;
-}
-
 static inline int
 mcp251xfd_chip_get_mode(const struct mcp251xfd_priv *priv, u8 *mode)
 {
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
new file mode 100644
index 000000000000..ffb3691c4ba7
--- /dev/null
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -0,0 +1,270 @@
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
+#include <asm/unaligned.h>
+
+#include "mcp251xfd.h"
+
+static inline u8
+mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
+				union mcp251xfd_write_reg_buf *write_reg_buf,
+				const u16 reg, const u32 mask, const u32 val)
+{
+	u8 first_byte, last_byte, len;
+	u8 *data;
+	__le32 val_le32;
+
+	first_byte = mcp251xfd_first_byte_set(mask);
+	last_byte = mcp251xfd_last_byte_set(mask);
+	len = last_byte - first_byte + 1;
+
+	data = mcp251xfd_spi_cmd_write(priv, write_reg_buf, reg + first_byte);
+	val_le32 = cpu_to_le32(val >> BITS_PER_BYTE * first_byte);
+	memcpy(data, &val_le32, len);
+
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG) {
+		u16 crc;
+
+		mcp251xfd_spi_cmd_crc_set_len_in_reg(&write_reg_buf->crc.cmd,
+						     len);
+		/* CRC */
+		len += sizeof(write_reg_buf->crc.cmd);
+		crc = mcp251xfd_crc16_compute(&write_reg_buf->crc, len);
+		put_unaligned_be16(crc, (void *)write_reg_buf + len);
+
+		/* Total length */
+		len += sizeof(write_reg_buf->crc.crc);
+	} else {
+		len += sizeof(write_reg_buf->nocrc.cmd);
+	}
+
+	return len;
+}
+
+static void
+mcp251xfd_tx_ring_init_tx_obj(const struct mcp251xfd_priv *priv,
+			      const struct mcp251xfd_tx_ring *ring,
+			      struct mcp251xfd_tx_obj *tx_obj,
+			      const u8 rts_buf_len,
+			      const u8 n)
+{
+	struct spi_transfer *xfer;
+	u16 addr;
+
+	/* FIFO load */
+	addr = mcp251xfd_get_tx_obj_addr(ring, n);
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX)
+		mcp251xfd_spi_cmd_write_crc_set_addr(&tx_obj->buf.crc.cmd,
+						     addr);
+	else
+		mcp251xfd_spi_cmd_write_nocrc(&tx_obj->buf.nocrc.cmd,
+					      addr);
+
+	xfer = &tx_obj->xfer[0];
+	xfer->tx_buf = &tx_obj->buf;
+	xfer->len = 0;	/* actual len is assigned on the fly */
+	xfer->cs_change = 1;
+	xfer->cs_change_delay.value = 0;
+	xfer->cs_change_delay.unit = SPI_DELAY_UNIT_NSECS;
+
+	/* FIFO request to send */
+	xfer = &tx_obj->xfer[1];
+	xfer->tx_buf = &ring->rts_buf;
+	xfer->len = rts_buf_len;
+
+	/* SPI message */
+	spi_message_init_with_transfers(&tx_obj->msg, tx_obj->xfer,
+					ARRAY_SIZE(tx_obj->xfer));
+}
+
+void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
+{
+	struct mcp251xfd_tef_ring *tef_ring;
+	struct mcp251xfd_tx_ring *tx_ring;
+	struct mcp251xfd_rx_ring *rx_ring, *prev_rx_ring = NULL;
+	struct mcp251xfd_tx_obj *tx_obj;
+	struct spi_transfer *xfer;
+	u32 val;
+	u16 addr;
+	u8 len;
+	int i, j;
+
+	netdev_reset_queue(priv->ndev);
+
+	/* TEF */
+	tef_ring = priv->tef;
+	tef_ring->head = 0;
+	tef_ring->tail = 0;
+
+	/* FIFO increment TEF tail pointer */
+	addr = MCP251XFD_REG_TEFCON;
+	val = MCP251XFD_REG_TEFCON_UINC;
+	len = mcp251xfd_cmd_prepare_write_reg(priv, &tef_ring->uinc_buf,
+					      addr, val, val);
+
+	for (j = 0; j < ARRAY_SIZE(tef_ring->uinc_xfer); j++) {
+		xfer = &tef_ring->uinc_xfer[j];
+		xfer->tx_buf = &tef_ring->uinc_buf;
+		xfer->len = len;
+		xfer->cs_change = 1;
+		xfer->cs_change_delay.value = 0;
+		xfer->cs_change_delay.unit = SPI_DELAY_UNIT_NSECS;
+	}
+
+	/* "cs_change == 1" on the last transfer results in an active
+	 * chip select after the complete SPI message. This causes the
+	 * controller to interpret the next register access as
+	 * data. Set "cs_change" of the last transfer to "0" to
+	 * properly deactivate the chip select at the end of the
+	 * message.
+	 */
+	xfer->cs_change = 0;
+
+	/* TX */
+	tx_ring = priv->tx;
+	tx_ring->head = 0;
+	tx_ring->tail = 0;
+	tx_ring->base = mcp251xfd_get_tef_obj_addr(tx_ring->obj_num);
+
+	/* FIFO request to send */
+	addr = MCP251XFD_REG_FIFOCON(MCP251XFD_TX_FIFO);
+	val = MCP251XFD_REG_FIFOCON_TXREQ | MCP251XFD_REG_FIFOCON_UINC;
+	len = mcp251xfd_cmd_prepare_write_reg(priv, &tx_ring->rts_buf,
+					      addr, val, val);
+
+	mcp251xfd_for_each_tx_obj(tx_ring, tx_obj, i)
+		mcp251xfd_tx_ring_init_tx_obj(priv, tx_ring, tx_obj, len, i);
+
+	/* RX */
+	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
+		rx_ring->head = 0;
+		rx_ring->tail = 0;
+		rx_ring->nr = i;
+		rx_ring->fifo_nr = MCP251XFD_RX_FIFO(i);
+
+		if (!prev_rx_ring)
+			rx_ring->base =
+				mcp251xfd_get_tx_obj_addr(tx_ring,
+							  tx_ring->obj_num);
+		else
+			rx_ring->base = prev_rx_ring->base +
+				prev_rx_ring->obj_size *
+				prev_rx_ring->obj_num;
+
+		prev_rx_ring = rx_ring;
+
+		/* FIFO increment RX tail pointer */
+		addr = MCP251XFD_REG_FIFOCON(rx_ring->fifo_nr);
+		val = MCP251XFD_REG_FIFOCON_UINC;
+		len = mcp251xfd_cmd_prepare_write_reg(priv, &rx_ring->uinc_buf,
+						      addr, val, val);
+
+		for (j = 0; j < ARRAY_SIZE(rx_ring->uinc_xfer); j++) {
+			xfer = &rx_ring->uinc_xfer[j];
+			xfer->tx_buf = &rx_ring->uinc_buf;
+			xfer->len = len;
+			xfer->cs_change = 1;
+			xfer->cs_change_delay.value = 0;
+			xfer->cs_change_delay.unit = SPI_DELAY_UNIT_NSECS;
+		}
+
+		/* "cs_change == 1" on the last transfer results in an
+		 * active chip select after the complete SPI
+		 * message. This causes the controller to interpret
+		 * the next register access as data. Set "cs_change"
+		 * of the last transfer to "0" to properly deactivate
+		 * the chip select at the end of the message.
+		 */
+		xfer->cs_change = 0;
+	}
+}
+
+void mcp251xfd_ring_free(struct mcp251xfd_priv *priv)
+{
+	int i;
+
+	for (i = ARRAY_SIZE(priv->rx) - 1; i >= 0; i--) {
+		kfree(priv->rx[i]);
+		priv->rx[i] = NULL;
+	}
+}
+
+int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
+{
+	struct mcp251xfd_tx_ring *tx_ring;
+	struct mcp251xfd_rx_ring *rx_ring;
+	int tef_obj_size, tx_obj_size, rx_obj_size;
+	int tx_obj_num;
+	int ram_free, i;
+
+	tef_obj_size = sizeof(struct mcp251xfd_hw_tef_obj);
+	/* listen-only mode works like FD mode */
+	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_FD)) {
+		tx_obj_num = MCP251XFD_TX_OBJ_NUM_CANFD;
+		tx_obj_size = sizeof(struct mcp251xfd_hw_tx_obj_canfd);
+		rx_obj_size = sizeof(struct mcp251xfd_hw_rx_obj_canfd);
+	} else {
+		tx_obj_num = MCP251XFD_TX_OBJ_NUM_CAN;
+		tx_obj_size = sizeof(struct mcp251xfd_hw_tx_obj_can);
+		rx_obj_size = sizeof(struct mcp251xfd_hw_rx_obj_can);
+	}
+
+	tx_ring = priv->tx;
+	tx_ring->obj_num = tx_obj_num;
+	tx_ring->obj_size = tx_obj_size;
+
+	ram_free = MCP251XFD_RAM_SIZE - tx_obj_num *
+		(tef_obj_size + tx_obj_size);
+
+	for (i = 0;
+	     i < ARRAY_SIZE(priv->rx) && ram_free >= rx_obj_size;
+	     i++) {
+		int rx_obj_num;
+
+		rx_obj_num = ram_free / rx_obj_size;
+		rx_obj_num = min(1 << (fls(rx_obj_num) - 1),
+				 MCP251XFD_RX_OBJ_NUM_MAX);
+
+		rx_ring = kzalloc(sizeof(*rx_ring) + rx_obj_size * rx_obj_num,
+				  GFP_KERNEL);
+		if (!rx_ring) {
+			mcp251xfd_ring_free(priv);
+			return -ENOMEM;
+		}
+		rx_ring->obj_num = rx_obj_num;
+		rx_ring->obj_size = rx_obj_size;
+		priv->rx[i] = rx_ring;
+
+		ram_free -= rx_ring->obj_num * rx_ring->obj_size;
+	}
+	priv->rx_ring_num = i;
+
+	netdev_dbg(priv->ndev,
+		   "FIFO setup: TEF: %d*%d bytes = %d bytes, TX: %d*%d bytes = %d bytes\n",
+		   tx_obj_num, tef_obj_size, tef_obj_size * tx_obj_num,
+		   tx_obj_num, tx_obj_size, tx_obj_size * tx_obj_num);
+
+	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
+		netdev_dbg(priv->ndev,
+			   "FIFO setup: RX-%d: %d*%d bytes = %d bytes\n",
+			   i, rx_ring->obj_num, rx_ring->obj_size,
+			   rx_ring->obj_size * rx_ring->obj_num);
+	}
+
+	netdev_dbg(priv->ndev,
+		   "FIFO setup: free: %d bytes\n",
+		   ram_free);
+
+	return 0;
+}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 69220de0e413..597786a85621 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -873,6 +873,9 @@ u16 mcp251xfd_crc16_compute2(const void *cmd, size_t cmd_size,
 			     const void *data, size_t data_size);
 u16 mcp251xfd_crc16_compute(const void *data, size_t data_size);
 int mcp251xfd_regmap_init(struct mcp251xfd_priv *priv);
+void mcp251xfd_ring_init(struct mcp251xfd_priv *priv);
+void mcp251xfd_ring_free(struct mcp251xfd_priv *priv);
+int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv);
 int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv);
 int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv);
 void mcp251xfd_skb_set_timestamp(const struct mcp251xfd_priv *priv,
-- 
2.34.1



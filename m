Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A31F4C1F01
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244655AbiBWWpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244634AbiBWWoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:44:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6CA53B54
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:43:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0MW-0006qE-LN
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:56 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B3D113BC54
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 27BB63BC1A;
        Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0754bbb7;
        Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 29/36] can: mcp251xfd: introduce struct mcp251xfd_tx_ring::nr and ::fifo_nr and make use of it
Date:   Wed, 23 Feb 2022 23:43:25 +0100
Message-Id: <20220223224332.2965690-30-mkl@pengutronix.de>
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

This patch removes the hard coded assumption that the TX ring uses
hardware FIFO 1. This allows the hardware FIFO 1 to be used for RX and
the next free FIFO for TX.

This gives the opportunity to minimize the number of SPI transfers in
the IRQ handler. The read of the IRQ status register and RX FIFO
status registers can be combined into single SPI transfer. If the RX
ring uses FIFO 1, the overall length of the transfer is smaller than
in the original layout, where the RX FIFO comes after the TX FIFO.

Link: https://lore.kernel.org/all/20220217103826.2299157-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../can/spi/mcp251xfd/mcp251xfd-chip-fifo.c   |  4 ++--
 .../net/can/spi/mcp251xfd/mcp251xfd-dump.c    |  4 ++--
 .../net/can/spi/mcp251xfd/mcp251xfd-regmap.c  | 22 ++++++++++++++-----
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    |  4 +++-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  4 +++-
 5 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c
index 2f9a623d381d..0d96097a2547 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c
@@ -78,7 +78,7 @@ int mcp251xfd_chip_fifo_init(const struct mcp251xfd_priv *priv)
 	if (err)
 		return err;
 
-	/* FIFO 1 - TX */
+	/* TX FIFO */
 	val = FIELD_PREP(MCP251XFD_REG_FIFOCON_FSIZE_MASK,
 			 tx_ring->obj_num - 1) |
 		MCP251XFD_REG_FIFOCON_TXEN |
@@ -99,7 +99,7 @@ int mcp251xfd_chip_fifo_init(const struct mcp251xfd_priv *priv)
 				  MCP251XFD_REG_FIFOCON_TXAT_UNLIMITED);
 
 	err = regmap_write(priv->map_reg,
-			   MCP251XFD_REG_FIFOCON(MCP251XFD_TX_FIFO),
+			   MCP251XFD_REG_FIFOCON(priv->tx->fifo_nr),
 			   val);
 	if (err)
 		return err;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
index ffae8fdd3af0..c991b30bc9f0 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
@@ -207,10 +207,10 @@ static void mcp251xfd_dump_tx_ring(const struct mcp251xfd_priv *priv,
 			.val = tx->base,
 		}, {
 			.key = MCP251XFD_DUMP_OBJECT_RING_KEY_NR,
-			.val = 0,
+			.val = tx->nr,
 		}, {
 			.key = MCP251XFD_DUMP_OBJECT_RING_KEY_FIFO_NR,
-			.val = MCP251XFD_TX_FIFO,
+			.val = tx->fifo_nr,
 		}, {
 			.key = MCP251XFD_DUMP_OBJECT_RING_KEY_OBJ_NUM,
 			.val = tx->obj_num,
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
index 8112f8df22a6..217510c12af5 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -2,8 +2,8 @@
 //
 // mcp251xfd - Microchip MCP251xFD Family CAN controller driver
 //
-// Copyright (c) 2019, 2020 Pengutronix,
-//                          Marc Kleine-Budde <kernel@pengutronix.de>
+// Copyright (c) 2019, 2020, 2021 Pengutronix,
+//               Marc Kleine-Budde <kernel@pengutronix.de>
 //
 
 #include "mcp251xfd.h"
@@ -47,22 +47,32 @@ mcp251xfd_regmap_nocrc_gather_write(void *context,
 	return spi_sync_transfer(spi, xfer, ARRAY_SIZE(xfer));
 }
 
-static inline bool mcp251xfd_update_bits_read_reg(unsigned int reg)
+static inline bool
+mcp251xfd_update_bits_read_reg(const struct mcp251xfd_priv *priv,
+			       unsigned int reg)
 {
+	struct mcp251xfd_rx_ring *ring;
+	int n;
+
 	switch (reg) {
 	case MCP251XFD_REG_INT:
 	case MCP251XFD_REG_TEFCON:
-	case MCP251XFD_REG_FIFOCON(MCP251XFD_RX_FIFO(0)):
 	case MCP251XFD_REG_FLTCON(0):
 	case MCP251XFD_REG_ECCSTAT:
 	case MCP251XFD_REG_CRC:
 		return false;
 	case MCP251XFD_REG_CON:
-	case MCP251XFD_REG_FIFOSTA(MCP251XFD_RX_FIFO(0)):
 	case MCP251XFD_REG_OSC:
 	case MCP251XFD_REG_ECCCON:
 		return true;
 	default:
+		mcp251xfd_for_each_rx_ring(priv, ring, n) {
+			if (reg == MCP251XFD_REG_FIFOCON(ring->fifo_nr))
+				return false;
+			if (reg == MCP251XFD_REG_FIFOSTA(ring->fifo_nr))
+				return true;
+		}
+
 		WARN(1, "Status of reg 0x%04x unknown.\n", reg);
 	}
 
@@ -92,7 +102,7 @@ mcp251xfd_regmap_nocrc_update_bits(void *context, unsigned int reg,
 	last_byte = mcp251xfd_last_byte_set(mask);
 	len = last_byte - first_byte + 1;
 
-	if (mcp251xfd_update_bits_read_reg(reg)) {
+	if (mcp251xfd_update_bits_read_reg(priv, reg)) {
 		struct spi_transfer xfer[2] = { };
 		struct spi_message msg;
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index 92f9e9b01289..6e394ac0bc5e 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -136,9 +136,11 @@ void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 	tx_ring->head = 0;
 	tx_ring->tail = 0;
 	tx_ring->base = mcp251xfd_get_tef_obj_addr(tx_ring->obj_num);
+	tx_ring->nr = 0;
+	tx_ring->fifo_nr = MCP251XFD_TX_FIFO;
 
 	/* FIFO request to send */
-	addr = MCP251XFD_REG_FIFOCON(MCP251XFD_TX_FIFO);
+	addr = MCP251XFD_REG_FIFOCON(tx_ring->fifo_nr);
 	val = MCP251XFD_REG_FIFOCON_TXREQ | MCP251XFD_REG_FIFOCON_UINC;
 	len = mcp251xfd_cmd_prepare_write_reg(priv, &tx_ring->rts_buf,
 					      addr, val, val);
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index ded927b4873d..12d3f2b84c0a 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -521,6 +521,8 @@ struct mcp251xfd_tx_ring {
 	unsigned int tail;
 
 	u16 base;
+	u8 nr;
+	u8 fifo_nr;
 	u8 obj_num;
 	u8 obj_size;
 
@@ -779,7 +781,7 @@ mcp251xfd_tx_tail_get_from_chip(const struct mcp251xfd_priv *priv,
 	int err;
 
 	err = regmap_read(priv->map_reg,
-			  MCP251XFD_REG_FIFOSTA(MCP251XFD_TX_FIFO),
+			  MCP251XFD_REG_FIFOSTA(priv->tx->fifo_nr),
 			  &fifo_sta);
 	if (err)
 		return err;
-- 
2.34.1



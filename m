Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70844488661
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbiAHVoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiAHVoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B46C061746
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:03 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVJ-0004RG-PH
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 673596D3A6F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:52 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 26C466D3A16;
        Sat,  8 Jan 2022 21:43:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 629bbe62;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 11/22] can: mcp251xfd: move TEF handling into separate file
Date:   Sat,  8 Jan 2022 22:43:34 +0100
Message-Id: <20220108214345.1848470-12-mkl@pengutronix.de>
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

This patch moves the TEF handling from the mcp251xfd core file into a
separate one to make the driver a bit more orderly.

Link: https://lore.kernel.org/all/20220105154300.1258636-11-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/Makefile        |   1 +
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 261 ------------------
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c | 260 +++++++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  20 ++
 4 files changed, 281 insertions(+), 261 deletions(-)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c

diff --git a/drivers/net/can/spi/mcp251xfd/Makefile b/drivers/net/can/spi/mcp251xfd/Makefile
index 397595dd505c..801367e98c54 100644
--- a/drivers/net/can/spi/mcp251xfd/Makefile
+++ b/drivers/net/can/spi/mcp251xfd/Makefile
@@ -7,6 +7,7 @@ mcp251xfd-objs += mcp251xfd-core.o
 mcp251xfd-objs += mcp251xfd-crc16.o
 mcp251xfd-objs += mcp251xfd-regmap.o
 mcp251xfd-objs += mcp251xfd-rx.o
+mcp251xfd-objs += mcp251xfd-tef.o
 mcp251xfd-objs += mcp251xfd-timestamp.o
 mcp251xfd-objs += mcp251xfd-tx.o
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 4445653e7743..65803b9fe2a2 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -216,40 +216,6 @@ mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
 	return len;
 }
 
-static inline int
-mcp251xfd_tef_tail_get_from_chip(const struct mcp251xfd_priv *priv,
-				 u8 *tef_tail)
-{
-	u32 tef_ua;
-	int err;
-
-	err = regmap_read(priv->map_reg, MCP251XFD_REG_TEFUA, &tef_ua);
-	if (err)
-		return err;
-
-	*tef_tail = tef_ua / sizeof(struct mcp251xfd_hw_tef_obj);
-
-	return 0;
-}
-
-static inline int
-mcp251xfd_tx_tail_get_from_chip(const struct mcp251xfd_priv *priv,
-				u8 *tx_tail)
-{
-	u32 fifo_sta;
-	int err;
-
-	err = regmap_read(priv->map_reg,
-			  MCP251XFD_REG_FIFOSTA(MCP251XFD_TX_FIFO),
-			  &fifo_sta);
-	if (err)
-		return err;
-
-	*tx_tail = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
-
-	return 0;
-}
-
 static void
 mcp251xfd_tx_ring_init_tx_obj(const struct mcp251xfd_priv *priv,
 			      const struct mcp251xfd_tx_ring *ring,
@@ -931,13 +897,6 @@ static int mcp251xfd_chip_ecc_init(struct mcp251xfd_priv *priv)
 	return err;
 }
 
-static inline void mcp251xfd_ecc_tefif_successful(struct mcp251xfd_priv *priv)
-{
-	struct mcp251xfd_ecc *ecc = &priv->ecc;
-
-	ecc->ecc_stat = 0;
-}
-
 static u8 mcp251xfd_get_normal_mode(const struct mcp251xfd_priv *priv)
 {
 	u8 mode;
@@ -1148,226 +1107,6 @@ static int mcp251xfd_get_berr_counter(const struct net_device *ndev,
 	return __mcp251xfd_get_berr_counter(ndev, bec);
 }
 
-static int mcp251xfd_check_tef_tail(const struct mcp251xfd_priv *priv)
-{
-	u8 tef_tail_chip, tef_tail;
-	int err;
-
-	if (!IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY))
-		return 0;
-
-	err = mcp251xfd_tef_tail_get_from_chip(priv, &tef_tail_chip);
-	if (err)
-		return err;
-
-	tef_tail = mcp251xfd_get_tef_tail(priv);
-	if (tef_tail_chip != tef_tail) {
-		netdev_err(priv->ndev,
-			   "TEF tail of chip (0x%02x) and ours (0x%08x) inconsistent.\n",
-			   tef_tail_chip, tef_tail);
-		return -EILSEQ;
-	}
-
-	return 0;
-}
-
-static int
-mcp251xfd_handle_tefif_recover(const struct mcp251xfd_priv *priv, const u32 seq)
-{
-	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
-	u32 tef_sta;
-	int err;
-
-	err = regmap_read(priv->map_reg, MCP251XFD_REG_TEFSTA, &tef_sta);
-	if (err)
-		return err;
-
-	if (tef_sta & MCP251XFD_REG_TEFSTA_TEFOVIF) {
-		netdev_err(priv->ndev,
-			   "Transmit Event FIFO buffer overflow.\n");
-		return -ENOBUFS;
-	}
-
-	netdev_info(priv->ndev,
-		    "Transmit Event FIFO buffer %s. (seq=0x%08x, tef_tail=0x%08x, tef_head=0x%08x, tx_head=0x%08x).\n",
-		    tef_sta & MCP251XFD_REG_TEFSTA_TEFFIF ?
-		    "full" : tef_sta & MCP251XFD_REG_TEFSTA_TEFNEIF ?
-		    "not empty" : "empty",
-		    seq, priv->tef->tail, priv->tef->head, tx_ring->head);
-
-	/* The Sequence Number in the TEF doesn't match our tef_tail. */
-	return -EAGAIN;
-}
-
-static int
-mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
-			   const struct mcp251xfd_hw_tef_obj *hw_tef_obj,
-			   unsigned int *frame_len_ptr)
-{
-	struct net_device_stats *stats = &priv->ndev->stats;
-	struct sk_buff *skb;
-	u32 seq, seq_masked, tef_tail_masked, tef_tail;
-
-	seq = FIELD_GET(MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK,
-			hw_tef_obj->flags);
-
-	/* Use the MCP2517FD mask on the MCP2518FD, too. We only
-	 * compare 7 bits, this should be enough to detect
-	 * net-yet-completed, i.e. old TEF objects.
-	 */
-	seq_masked = seq &
-		field_mask(MCP251XFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
-	tef_tail_masked = priv->tef->tail &
-		field_mask(MCP251XFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
-	if (seq_masked != tef_tail_masked)
-		return mcp251xfd_handle_tefif_recover(priv, seq);
-
-	tef_tail = mcp251xfd_get_tef_tail(priv);
-	skb = priv->can.echo_skb[tef_tail];
-	if (skb)
-		mcp251xfd_skb_set_timestamp(priv, skb, hw_tef_obj->ts);
-	stats->tx_bytes +=
-		can_rx_offload_get_echo_skb(&priv->offload,
-					    tef_tail, hw_tef_obj->ts,
-					    frame_len_ptr);
-	stats->tx_packets++;
-	priv->tef->tail++;
-
-	return 0;
-}
-
-static int mcp251xfd_tef_ring_update(struct mcp251xfd_priv *priv)
-{
-	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
-	unsigned int new_head;
-	u8 chip_tx_tail;
-	int err;
-
-	err = mcp251xfd_tx_tail_get_from_chip(priv, &chip_tx_tail);
-	if (err)
-		return err;
-
-	/* chip_tx_tail, is the next TX-Object send by the HW.
-	 * The new TEF head must be >= the old head, ...
-	 */
-	new_head = round_down(priv->tef->head, tx_ring->obj_num) + chip_tx_tail;
-	if (new_head <= priv->tef->head)
-		new_head += tx_ring->obj_num;
-
-	/* ... but it cannot exceed the TX head. */
-	priv->tef->head = min(new_head, tx_ring->head);
-
-	return mcp251xfd_check_tef_tail(priv);
-}
-
-static inline int
-mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
-		       struct mcp251xfd_hw_tef_obj *hw_tef_obj,
-		       const u8 offset, const u8 len)
-{
-	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
-	const int val_bytes = regmap_get_val_bytes(priv->map_rx);
-
-	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
-	    (offset > tx_ring->obj_num ||
-	     len > tx_ring->obj_num ||
-	     offset + len > tx_ring->obj_num)) {
-		netdev_err(priv->ndev,
-			   "Trying to read too many TEF objects (max=%d, offset=%d, len=%d).\n",
-			   tx_ring->obj_num, offset, len);
-		return -ERANGE;
-	}
-
-	return regmap_bulk_read(priv->map_rx,
-				mcp251xfd_get_tef_obj_addr(offset),
-				hw_tef_obj,
-				sizeof(*hw_tef_obj) / val_bytes * len);
-}
-
-static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
-{
-	struct mcp251xfd_hw_tef_obj hw_tef_obj[MCP251XFD_TX_OBJ_NUM_MAX];
-	unsigned int total_frame_len = 0;
-	u8 tef_tail, len, l;
-	int err, i;
-
-	err = mcp251xfd_tef_ring_update(priv);
-	if (err)
-		return err;
-
-	tef_tail = mcp251xfd_get_tef_tail(priv);
-	len = mcp251xfd_get_tef_len(priv);
-	l = mcp251xfd_get_tef_linear_len(priv);
-	err = mcp251xfd_tef_obj_read(priv, hw_tef_obj, tef_tail, l);
-	if (err)
-		return err;
-
-	if (l < len) {
-		err = mcp251xfd_tef_obj_read(priv, &hw_tef_obj[l], 0, len - l);
-		if (err)
-			return err;
-	}
-
-	for (i = 0; i < len; i++) {
-		unsigned int frame_len = 0;
-
-		err = mcp251xfd_handle_tefif_one(priv, &hw_tef_obj[i], &frame_len);
-		/* -EAGAIN means the Sequence Number in the TEF
-		 * doesn't match our tef_tail. This can happen if we
-		 * read the TEF objects too early. Leave loop let the
-		 * interrupt handler call us again.
-		 */
-		if (err == -EAGAIN)
-			goto out_netif_wake_queue;
-		if (err)
-			return err;
-
-		total_frame_len += frame_len;
-	}
-
- out_netif_wake_queue:
-	len = i;	/* number of handled goods TEFs */
-	if (len) {
-		struct mcp251xfd_tef_ring *ring = priv->tef;
-		struct mcp251xfd_tx_ring *tx_ring = priv->tx;
-		int offset;
-
-		/* Increment the TEF FIFO tail pointer 'len' times in
-		 * a single SPI message.
-		 *
-		 * Note:
-		 * Calculate offset, so that the SPI transfer ends on
-		 * the last message of the uinc_xfer array, which has
-		 * "cs_change == 0", to properly deactivate the chip
-		 * select.
-		 */
-		offset = ARRAY_SIZE(ring->uinc_xfer) - len;
-		err = spi_sync_transfer(priv->spi,
-					ring->uinc_xfer + offset, len);
-		if (err)
-			return err;
-
-		tx_ring->tail += len;
-		netdev_completed_queue(priv->ndev, len, total_frame_len);
-
-		err = mcp251xfd_check_tef_tail(priv);
-		if (err)
-			return err;
-	}
-
-	mcp251xfd_ecc_tefif_successful(priv);
-
-	if (mcp251xfd_get_tx_free(priv->tx)) {
-		/* Make sure that anybody stopping the queue after
-		 * this sees the new tx_ring->tail.
-		 */
-		smp_mb();
-		netif_wake_queue(priv->ndev);
-	}
-
-	return 0;
-}
-
 static struct sk_buff *
 mcp251xfd_alloc_can_err_skb(struct mcp251xfd_priv *priv,
 			    struct can_frame **cf, u32 *timestamp)
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
new file mode 100644
index 000000000000..406166005b99
--- /dev/null
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
@@ -0,0 +1,260 @@
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
+static inline int
+mcp251xfd_tef_tail_get_from_chip(const struct mcp251xfd_priv *priv,
+				 u8 *tef_tail)
+{
+	u32 tef_ua;
+	int err;
+
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_TEFUA, &tef_ua);
+	if (err)
+		return err;
+
+	*tef_tail = tef_ua / sizeof(struct mcp251xfd_hw_tef_obj);
+
+	return 0;
+}
+
+static int mcp251xfd_check_tef_tail(const struct mcp251xfd_priv *priv)
+{
+	u8 tef_tail_chip, tef_tail;
+	int err;
+
+	if (!IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY))
+		return 0;
+
+	err = mcp251xfd_tef_tail_get_from_chip(priv, &tef_tail_chip);
+	if (err)
+		return err;
+
+	tef_tail = mcp251xfd_get_tef_tail(priv);
+	if (tef_tail_chip != tef_tail) {
+		netdev_err(priv->ndev,
+			   "TEF tail of chip (0x%02x) and ours (0x%08x) inconsistent.\n",
+			   tef_tail_chip, tef_tail);
+		return -EILSEQ;
+	}
+
+	return 0;
+}
+
+static int
+mcp251xfd_handle_tefif_recover(const struct mcp251xfd_priv *priv, const u32 seq)
+{
+	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	u32 tef_sta;
+	int err;
+
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_TEFSTA, &tef_sta);
+	if (err)
+		return err;
+
+	if (tef_sta & MCP251XFD_REG_TEFSTA_TEFOVIF) {
+		netdev_err(priv->ndev,
+			   "Transmit Event FIFO buffer overflow.\n");
+		return -ENOBUFS;
+	}
+
+	netdev_info(priv->ndev,
+		    "Transmit Event FIFO buffer %s. (seq=0x%08x, tef_tail=0x%08x, tef_head=0x%08x, tx_head=0x%08x).\n",
+		    tef_sta & MCP251XFD_REG_TEFSTA_TEFFIF ?
+		    "full" : tef_sta & MCP251XFD_REG_TEFSTA_TEFNEIF ?
+		    "not empty" : "empty",
+		    seq, priv->tef->tail, priv->tef->head, tx_ring->head);
+
+	/* The Sequence Number in the TEF doesn't match our tef_tail. */
+	return -EAGAIN;
+}
+
+static int
+mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
+			   const struct mcp251xfd_hw_tef_obj *hw_tef_obj,
+			   unsigned int *frame_len_ptr)
+{
+	struct net_device_stats *stats = &priv->ndev->stats;
+	struct sk_buff *skb;
+	u32 seq, seq_masked, tef_tail_masked, tef_tail;
+
+	seq = FIELD_GET(MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK,
+			hw_tef_obj->flags);
+
+	/* Use the MCP2517FD mask on the MCP2518FD, too. We only
+	 * compare 7 bits, this should be enough to detect
+	 * net-yet-completed, i.e. old TEF objects.
+	 */
+	seq_masked = seq &
+		field_mask(MCP251XFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
+	tef_tail_masked = priv->tef->tail &
+		field_mask(MCP251XFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
+	if (seq_masked != tef_tail_masked)
+		return mcp251xfd_handle_tefif_recover(priv, seq);
+
+	tef_tail = mcp251xfd_get_tef_tail(priv);
+	skb = priv->can.echo_skb[tef_tail];
+	if (skb)
+		mcp251xfd_skb_set_timestamp(priv, skb, hw_tef_obj->ts);
+	stats->tx_bytes +=
+		can_rx_offload_get_echo_skb(&priv->offload,
+					    tef_tail, hw_tef_obj->ts,
+					    frame_len_ptr);
+	stats->tx_packets++;
+	priv->tef->tail++;
+
+	return 0;
+}
+
+static int mcp251xfd_tef_ring_update(struct mcp251xfd_priv *priv)
+{
+	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	unsigned int new_head;
+	u8 chip_tx_tail;
+	int err;
+
+	err = mcp251xfd_tx_tail_get_from_chip(priv, &chip_tx_tail);
+	if (err)
+		return err;
+
+	/* chip_tx_tail, is the next TX-Object send by the HW.
+	 * The new TEF head must be >= the old head, ...
+	 */
+	new_head = round_down(priv->tef->head, tx_ring->obj_num) + chip_tx_tail;
+	if (new_head <= priv->tef->head)
+		new_head += tx_ring->obj_num;
+
+	/* ... but it cannot exceed the TX head. */
+	priv->tef->head = min(new_head, tx_ring->head);
+
+	return mcp251xfd_check_tef_tail(priv);
+}
+
+static inline int
+mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
+		       struct mcp251xfd_hw_tef_obj *hw_tef_obj,
+		       const u8 offset, const u8 len)
+{
+	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	const int val_bytes = regmap_get_val_bytes(priv->map_rx);
+
+	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
+	    (offset > tx_ring->obj_num ||
+	     len > tx_ring->obj_num ||
+	     offset + len > tx_ring->obj_num)) {
+		netdev_err(priv->ndev,
+			   "Trying to read too many TEF objects (max=%d, offset=%d, len=%d).\n",
+			   tx_ring->obj_num, offset, len);
+		return -ERANGE;
+	}
+
+	return regmap_bulk_read(priv->map_rx,
+				mcp251xfd_get_tef_obj_addr(offset),
+				hw_tef_obj,
+				sizeof(*hw_tef_obj) / val_bytes * len);
+}
+
+static inline void mcp251xfd_ecc_tefif_successful(struct mcp251xfd_priv *priv)
+{
+	struct mcp251xfd_ecc *ecc = &priv->ecc;
+
+	ecc->ecc_stat = 0;
+}
+
+int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
+{
+	struct mcp251xfd_hw_tef_obj hw_tef_obj[MCP251XFD_TX_OBJ_NUM_MAX];
+	unsigned int total_frame_len = 0;
+	u8 tef_tail, len, l;
+	int err, i;
+
+	err = mcp251xfd_tef_ring_update(priv);
+	if (err)
+		return err;
+
+	tef_tail = mcp251xfd_get_tef_tail(priv);
+	len = mcp251xfd_get_tef_len(priv);
+	l = mcp251xfd_get_tef_linear_len(priv);
+	err = mcp251xfd_tef_obj_read(priv, hw_tef_obj, tef_tail, l);
+	if (err)
+		return err;
+
+	if (l < len) {
+		err = mcp251xfd_tef_obj_read(priv, &hw_tef_obj[l], 0, len - l);
+		if (err)
+			return err;
+	}
+
+	for (i = 0; i < len; i++) {
+		unsigned int frame_len = 0;
+
+		err = mcp251xfd_handle_tefif_one(priv, &hw_tef_obj[i], &frame_len);
+		/* -EAGAIN means the Sequence Number in the TEF
+		 * doesn't match our tef_tail. This can happen if we
+		 * read the TEF objects too early. Leave loop let the
+		 * interrupt handler call us again.
+		 */
+		if (err == -EAGAIN)
+			goto out_netif_wake_queue;
+		if (err)
+			return err;
+
+		total_frame_len += frame_len;
+	}
+
+ out_netif_wake_queue:
+	len = i;	/* number of handled goods TEFs */
+	if (len) {
+		struct mcp251xfd_tef_ring *ring = priv->tef;
+		struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+		int offset;
+
+		/* Increment the TEF FIFO tail pointer 'len' times in
+		 * a single SPI message.
+		 *
+		 * Note:
+		 * Calculate offset, so that the SPI transfer ends on
+		 * the last message of the uinc_xfer array, which has
+		 * "cs_change == 0", to properly deactivate the chip
+		 * select.
+		 */
+		offset = ARRAY_SIZE(ring->uinc_xfer) - len;
+		err = spi_sync_transfer(priv->spi,
+					ring->uinc_xfer + offset, len);
+		if (err)
+			return err;
+
+		tx_ring->tail += len;
+		netdev_completed_queue(priv->ndev, len, total_frame_len);
+
+		err = mcp251xfd_check_tef_tail(priv);
+		if (err)
+			return err;
+	}
+
+	mcp251xfd_ecc_tefif_successful(priv);
+
+	if (mcp251xfd_get_tx_free(priv->tx)) {
+		/* Make sure that anybody stopping the queue after
+		 * this sees the new tx_ring->tail.
+		 */
+		smp_mb();
+		netif_wake_queue(priv->ndev);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index bd1c22815f31..22a18d6fbda4 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -10,6 +10,7 @@
 #ifndef _MCP251XFD_H
 #define _MCP251XFD_H
 
+#include <linux/bitfield.h>
 #include <linux/can/core.h>
 #include <linux/can/dev.h>
 #include <linux/can/rx-offload.h>
@@ -761,6 +762,24 @@ mcp251xfd_get_rx_obj_addr(const struct mcp251xfd_rx_ring *ring, u8 n)
 	return ring->base + ring->obj_size * n;
 }
 
+static inline int
+mcp251xfd_tx_tail_get_from_chip(const struct mcp251xfd_priv *priv,
+				u8 *tx_tail)
+{
+	u32 fifo_sta;
+	int err;
+
+	err = regmap_read(priv->map_reg,
+			  MCP251XFD_REG_FIFOSTA(MCP251XFD_TX_FIFO),
+			  &fifo_sta);
+	if (err)
+		return err;
+
+	*tx_tail = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
+
+	return 0;
+}
+
 static inline u8 mcp251xfd_get_tef_head(const struct mcp251xfd_priv *priv)
 {
 	return priv->tef->head & (priv->tx->obj_num - 1);
@@ -854,6 +873,7 @@ u16 mcp251xfd_crc16_compute2(const void *cmd, size_t cmd_size,
 u16 mcp251xfd_crc16_compute(const void *data, size_t data_size);
 int mcp251xfd_regmap_init(struct mcp251xfd_priv *priv);
 int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv);
+int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv);
 void mcp251xfd_skb_set_timestamp(const struct mcp251xfd_priv *priv,
 				 struct sk_buff *skb, u32 timestamp);
 void mcp251xfd_timestamp_init(struct mcp251xfd_priv *priv);
-- 
2.34.1



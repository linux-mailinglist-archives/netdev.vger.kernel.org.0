Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2413F488660
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbiAHVoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiAHVoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA97C061751
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVJ-0004Pv-0Z
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 380DE6D3A6B
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:52 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E049A6D3A11;
        Sat,  8 Jan 2022 21:43:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4c15bdd9;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/22] can: mcp251xfd: move RX handling into separate file
Date:   Sat,  8 Jan 2022 22:43:32 +0100
Message-Id: <20220108214345.1848470-10-mkl@pengutronix.de>
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

This patch moves the RX handling from the mcp251xfd core file into a
separate one to make the driver a bit more orderly.

Link: https://lore.kernel.org/all/20220105154300.1258636-9-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/Makefile        |   1 +
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 244 ----------------
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c  | 260 ++++++++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |   1 +
 4 files changed, 262 insertions(+), 244 deletions(-)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c

diff --git a/drivers/net/can/spi/mcp251xfd/Makefile b/drivers/net/can/spi/mcp251xfd/Makefile
index 3cba3b9447ea..8e1146015eeb 100644
--- a/drivers/net/can/spi/mcp251xfd/Makefile
+++ b/drivers/net/can/spi/mcp251xfd/Makefile
@@ -6,6 +6,7 @@ mcp251xfd-objs :=
 mcp251xfd-objs += mcp251xfd-core.o
 mcp251xfd-objs += mcp251xfd-crc16.o
 mcp251xfd-objs += mcp251xfd-regmap.o
+mcp251xfd-objs += mcp251xfd-rx.o
 mcp251xfd-objs += mcp251xfd-timestamp.o
 
 mcp251xfd-$(CONFIG_DEV_COREDUMP) += mcp251xfd-dump.o
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 105426dcf065..d6d0d0f34893 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -250,43 +250,6 @@ mcp251xfd_tx_tail_get_from_chip(const struct mcp251xfd_priv *priv,
 	return 0;
 }
 
-static inline int
-mcp251xfd_rx_head_get_from_chip(const struct mcp251xfd_priv *priv,
-				const struct mcp251xfd_rx_ring *ring,
-				u8 *rx_head)
-{
-	u32 fifo_sta;
-	int err;
-
-	err = regmap_read(priv->map_reg, MCP251XFD_REG_FIFOSTA(ring->fifo_nr),
-			  &fifo_sta);
-	if (err)
-		return err;
-
-	*rx_head = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
-
-	return 0;
-}
-
-static inline int
-mcp251xfd_rx_tail_get_from_chip(const struct mcp251xfd_priv *priv,
-				const struct mcp251xfd_rx_ring *ring,
-				u8 *rx_tail)
-{
-	u32 fifo_ua;
-	int err;
-
-	err = regmap_read(priv->map_reg, MCP251XFD_REG_FIFOUA(ring->fifo_nr),
-			  &fifo_ua);
-	if (err)
-		return err;
-
-	fifo_ua -= ring->base - MCP251XFD_RAM_START;
-	*rx_tail = fifo_ua / ring->obj_size;
-
-	return 0;
-}
-
 static void
 mcp251xfd_tx_ring_init_tx_obj(const struct mcp251xfd_priv *priv,
 			      const struct mcp251xfd_tx_ring *ring,
@@ -1208,31 +1171,6 @@ static int mcp251xfd_check_tef_tail(const struct mcp251xfd_priv *priv)
 	return 0;
 }
 
-static int
-mcp251xfd_check_rx_tail(const struct mcp251xfd_priv *priv,
-			const struct mcp251xfd_rx_ring *ring)
-{
-	u8 rx_tail_chip, rx_tail;
-	int err;
-
-	if (!IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY))
-		return 0;
-
-	err = mcp251xfd_rx_tail_get_from_chip(priv, ring, &rx_tail_chip);
-	if (err)
-		return err;
-
-	rx_tail = mcp251xfd_get_rx_tail(ring);
-	if (rx_tail_chip != rx_tail) {
-		netdev_err(priv->ndev,
-			   "RX tail of chip (%d) and ours (%d) inconsistent.\n",
-			   rx_tail_chip, rx_tail);
-		return -EILSEQ;
-	}
-
-	return 0;
-}
-
 static int
 mcp251xfd_handle_tefif_recover(const struct mcp251xfd_priv *priv, const u32 seq)
 {
@@ -1430,188 +1368,6 @@ static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
 	return 0;
 }
 
-static int
-mcp251xfd_rx_ring_update(const struct mcp251xfd_priv *priv,
-			 struct mcp251xfd_rx_ring *ring)
-{
-	u32 new_head;
-	u8 chip_rx_head;
-	int err;
-
-	err = mcp251xfd_rx_head_get_from_chip(priv, ring, &chip_rx_head);
-	if (err)
-		return err;
-
-	/* chip_rx_head, is the next RX-Object filled by the HW.
-	 * The new RX head must be >= the old head.
-	 */
-	new_head = round_down(ring->head, ring->obj_num) + chip_rx_head;
-	if (new_head <= ring->head)
-		new_head += ring->obj_num;
-
-	ring->head = new_head;
-
-	return mcp251xfd_check_rx_tail(priv, ring);
-}
-
-static void
-mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
-			   const struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj,
-			   struct sk_buff *skb)
-{
-	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
-	u8 dlc;
-
-	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_IDE) {
-		u32 sid, eid;
-
-		eid = FIELD_GET(MCP251XFD_OBJ_ID_EID_MASK, hw_rx_obj->id);
-		sid = FIELD_GET(MCP251XFD_OBJ_ID_SID_MASK, hw_rx_obj->id);
-
-		cfd->can_id = CAN_EFF_FLAG |
-			FIELD_PREP(MCP251XFD_REG_FRAME_EFF_EID_MASK, eid) |
-			FIELD_PREP(MCP251XFD_REG_FRAME_EFF_SID_MASK, sid);
-	} else {
-		cfd->can_id = FIELD_GET(MCP251XFD_OBJ_ID_SID_MASK,
-					hw_rx_obj->id);
-	}
-
-	dlc = FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC_MASK, hw_rx_obj->flags);
-
-	/* CANFD */
-	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_FDF) {
-
-		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_ESI)
-			cfd->flags |= CANFD_ESI;
-
-		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_BRS)
-			cfd->flags |= CANFD_BRS;
-
-		cfd->len = can_fd_dlc2len(dlc);
-	} else {
-		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR)
-			cfd->can_id |= CAN_RTR_FLAG;
-
-		can_frame_set_cc_len((struct can_frame *)cfd, dlc,
-				     priv->can.ctrlmode);
-	}
-
-	if (!(hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR))
-		memcpy(cfd->data, hw_rx_obj->data, cfd->len);
-
-	mcp251xfd_skb_set_timestamp(priv, skb, hw_rx_obj->ts);
-}
-
-static int
-mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
-			  struct mcp251xfd_rx_ring *ring,
-			  const struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj)
-{
-	struct net_device_stats *stats = &priv->ndev->stats;
-	struct sk_buff *skb;
-	struct canfd_frame *cfd;
-	int err;
-
-	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_FDF)
-		skb = alloc_canfd_skb(priv->ndev, &cfd);
-	else
-		skb = alloc_can_skb(priv->ndev, (struct can_frame **)&cfd);
-
-	if (!skb) {
-		stats->rx_dropped++;
-		return 0;
-	}
-
-	mcp251xfd_hw_rx_obj_to_skb(priv, hw_rx_obj, skb);
-	err = can_rx_offload_queue_sorted(&priv->offload, skb, hw_rx_obj->ts);
-	if (err)
-		stats->rx_fifo_errors++;
-
-	return 0;
-}
-
-static inline int
-mcp251xfd_rx_obj_read(const struct mcp251xfd_priv *priv,
-		      const struct mcp251xfd_rx_ring *ring,
-		      struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj,
-		      const u8 offset, const u8 len)
-{
-	const int val_bytes = regmap_get_val_bytes(priv->map_rx);
-	int err;
-
-	err = regmap_bulk_read(priv->map_rx,
-			       mcp251xfd_get_rx_obj_addr(ring, offset),
-			       hw_rx_obj,
-			       len * ring->obj_size / val_bytes);
-
-	return err;
-}
-
-static int
-mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
-			   struct mcp251xfd_rx_ring *ring)
-{
-	struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj = ring->obj;
-	u8 rx_tail, len;
-	int err, i;
-
-	err = mcp251xfd_rx_ring_update(priv, ring);
-	if (err)
-		return err;
-
-	while ((len = mcp251xfd_get_rx_linear_len(ring))) {
-		int offset;
-
-		rx_tail = mcp251xfd_get_rx_tail(ring);
-
-		err = mcp251xfd_rx_obj_read(priv, ring, hw_rx_obj,
-					    rx_tail, len);
-		if (err)
-			return err;
-
-		for (i = 0; i < len; i++) {
-			err = mcp251xfd_handle_rxif_one(priv, ring,
-							(void *)hw_rx_obj +
-							i * ring->obj_size);
-			if (err)
-				return err;
-		}
-
-		/* Increment the RX FIFO tail pointer 'len' times in a
-		 * single SPI message.
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
-		ring->tail += len;
-	}
-
-	return 0;
-}
-
-static int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv)
-{
-	struct mcp251xfd_rx_ring *ring;
-	int err, n;
-
-	mcp251xfd_for_each_rx_ring(priv, ring, n) {
-		err = mcp251xfd_handle_rxif_ring(priv, ring);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static struct sk_buff *
 mcp251xfd_alloc_can_err_skb(struct mcp251xfd_priv *priv,
 			    struct can_frame **cf, u32 *timestamp)
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
new file mode 100644
index 000000000000..63f2526464b3
--- /dev/null
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
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
+mcp251xfd_rx_head_get_from_chip(const struct mcp251xfd_priv *priv,
+				const struct mcp251xfd_rx_ring *ring,
+				u8 *rx_head)
+{
+	u32 fifo_sta;
+	int err;
+
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_FIFOSTA(ring->fifo_nr),
+			  &fifo_sta);
+	if (err)
+		return err;
+
+	*rx_head = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
+
+	return 0;
+}
+
+static inline int
+mcp251xfd_rx_tail_get_from_chip(const struct mcp251xfd_priv *priv,
+				const struct mcp251xfd_rx_ring *ring,
+				u8 *rx_tail)
+{
+	u32 fifo_ua;
+	int err;
+
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_FIFOUA(ring->fifo_nr),
+			  &fifo_ua);
+	if (err)
+		return err;
+
+	fifo_ua -= ring->base - MCP251XFD_RAM_START;
+	*rx_tail = fifo_ua / ring->obj_size;
+
+	return 0;
+}
+
+static int
+mcp251xfd_check_rx_tail(const struct mcp251xfd_priv *priv,
+			const struct mcp251xfd_rx_ring *ring)
+{
+	u8 rx_tail_chip, rx_tail;
+	int err;
+
+	if (!IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY))
+		return 0;
+
+	err = mcp251xfd_rx_tail_get_from_chip(priv, ring, &rx_tail_chip);
+	if (err)
+		return err;
+
+	rx_tail = mcp251xfd_get_rx_tail(ring);
+	if (rx_tail_chip != rx_tail) {
+		netdev_err(priv->ndev,
+			   "RX tail of chip (%d) and ours (%d) inconsistent.\n",
+			   rx_tail_chip, rx_tail);
+		return -EILSEQ;
+	}
+
+	return 0;
+}
+
+static int
+mcp251xfd_rx_ring_update(const struct mcp251xfd_priv *priv,
+			 struct mcp251xfd_rx_ring *ring)
+{
+	u32 new_head;
+	u8 chip_rx_head;
+	int err;
+
+	err = mcp251xfd_rx_head_get_from_chip(priv, ring, &chip_rx_head);
+	if (err)
+		return err;
+
+	/* chip_rx_head, is the next RX-Object filled by the HW.
+	 * The new RX head must be >= the old head.
+	 */
+	new_head = round_down(ring->head, ring->obj_num) + chip_rx_head;
+	if (new_head <= ring->head)
+		new_head += ring->obj_num;
+
+	ring->head = new_head;
+
+	return mcp251xfd_check_rx_tail(priv, ring);
+}
+
+static void
+mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
+			   const struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj,
+			   struct sk_buff *skb)
+{
+	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+	u8 dlc;
+
+	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_IDE) {
+		u32 sid, eid;
+
+		eid = FIELD_GET(MCP251XFD_OBJ_ID_EID_MASK, hw_rx_obj->id);
+		sid = FIELD_GET(MCP251XFD_OBJ_ID_SID_MASK, hw_rx_obj->id);
+
+		cfd->can_id = CAN_EFF_FLAG |
+			FIELD_PREP(MCP251XFD_REG_FRAME_EFF_EID_MASK, eid) |
+			FIELD_PREP(MCP251XFD_REG_FRAME_EFF_SID_MASK, sid);
+	} else {
+		cfd->can_id = FIELD_GET(MCP251XFD_OBJ_ID_SID_MASK,
+					hw_rx_obj->id);
+	}
+
+	dlc = FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC_MASK, hw_rx_obj->flags);
+
+	/* CANFD */
+	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_FDF) {
+		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_ESI)
+			cfd->flags |= CANFD_ESI;
+
+		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_BRS)
+			cfd->flags |= CANFD_BRS;
+
+		cfd->len = can_fd_dlc2len(dlc);
+	} else {
+		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR)
+			cfd->can_id |= CAN_RTR_FLAG;
+
+		can_frame_set_cc_len((struct can_frame *)cfd, dlc,
+				     priv->can.ctrlmode);
+	}
+
+	if (!(hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR))
+		memcpy(cfd->data, hw_rx_obj->data, cfd->len);
+
+	mcp251xfd_skb_set_timestamp(priv, skb, hw_rx_obj->ts);
+}
+
+static int
+mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
+			  struct mcp251xfd_rx_ring *ring,
+			  const struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj)
+{
+	struct net_device_stats *stats = &priv->ndev->stats;
+	struct sk_buff *skb;
+	struct canfd_frame *cfd;
+	int err;
+
+	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_FDF)
+		skb = alloc_canfd_skb(priv->ndev, &cfd);
+	else
+		skb = alloc_can_skb(priv->ndev, (struct can_frame **)&cfd);
+
+	if (!skb) {
+		stats->rx_dropped++;
+		return 0;
+	}
+
+	mcp251xfd_hw_rx_obj_to_skb(priv, hw_rx_obj, skb);
+	err = can_rx_offload_queue_sorted(&priv->offload, skb, hw_rx_obj->ts);
+	if (err)
+		stats->rx_fifo_errors++;
+
+	return 0;
+}
+
+static inline int
+mcp251xfd_rx_obj_read(const struct mcp251xfd_priv *priv,
+		      const struct mcp251xfd_rx_ring *ring,
+		      struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj,
+		      const u8 offset, const u8 len)
+{
+	const int val_bytes = regmap_get_val_bytes(priv->map_rx);
+	int err;
+
+	err = regmap_bulk_read(priv->map_rx,
+			       mcp251xfd_get_rx_obj_addr(ring, offset),
+			       hw_rx_obj,
+			       len * ring->obj_size / val_bytes);
+
+	return err;
+}
+
+static int
+mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
+			   struct mcp251xfd_rx_ring *ring)
+{
+	struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj = ring->obj;
+	u8 rx_tail, len;
+	int err, i;
+
+	err = mcp251xfd_rx_ring_update(priv, ring);
+	if (err)
+		return err;
+
+	while ((len = mcp251xfd_get_rx_linear_len(ring))) {
+		int offset;
+
+		rx_tail = mcp251xfd_get_rx_tail(ring);
+
+		err = mcp251xfd_rx_obj_read(priv, ring, hw_rx_obj,
+					    rx_tail, len);
+		if (err)
+			return err;
+
+		for (i = 0; i < len; i++) {
+			err = mcp251xfd_handle_rxif_one(priv, ring,
+							(void *)hw_rx_obj +
+							i * ring->obj_size);
+			if (err)
+				return err;
+		}
+
+		/* Increment the RX FIFO tail pointer 'len' times in a
+		 * single SPI message.
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
+		ring->tail += len;
+	}
+
+	return 0;
+}
+
+int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv)
+{
+	struct mcp251xfd_rx_ring *ring;
+	int err, n;
+
+	mcp251xfd_for_each_rx_ring(priv, ring, n) {
+		err = mcp251xfd_handle_rxif_ring(priv, ring);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 8a6e07ba66d5..8b35417316a0 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -853,6 +853,7 @@ u16 mcp251xfd_crc16_compute2(const void *cmd, size_t cmd_size,
 			     const void *data, size_t data_size);
 u16 mcp251xfd_crc16_compute(const void *data, size_t data_size);
 int mcp251xfd_regmap_init(struct mcp251xfd_priv *priv);
+int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv);
 void mcp251xfd_skb_set_timestamp(const struct mcp251xfd_priv *priv,
 				 struct sk_buff *skb, u32 timestamp);
 void mcp251xfd_timestamp_init(struct mcp251xfd_priv *priv);
-- 
2.34.1



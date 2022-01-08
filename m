Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A301848865F
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiAHVoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiAHVoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922BBC06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVI-0004OZ-RW
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:00 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D5B696D3A64
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:51 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 042476D3A13;
        Sat,  8 Jan 2022 21:43:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9314c556;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/22] can: mcp251xfd: move TX handling into separate file
Date:   Sat,  8 Jan 2022 22:43:33 +0100
Message-Id: <20220108214345.1848470-11-mkl@pengutronix.de>
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

This patch moves the TX handling from the mcp251xfd core file into a
separate one to make the driver a bit more orderly.

Link: https://lore.kernel.org/all/20220105154300.1258636-10-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/Makefile        |   1 +
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 187 ----------------
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c  | 205 ++++++++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |   3 +
 4 files changed, 209 insertions(+), 187 deletions(-)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c

diff --git a/drivers/net/can/spi/mcp251xfd/Makefile b/drivers/net/can/spi/mcp251xfd/Makefile
index 8e1146015eeb..397595dd505c 100644
--- a/drivers/net/can/spi/mcp251xfd/Makefile
+++ b/drivers/net/can/spi/mcp251xfd/Makefile
@@ -8,5 +8,6 @@ mcp251xfd-objs += mcp251xfd-crc16.o
 mcp251xfd-objs += mcp251xfd-regmap.o
 mcp251xfd-objs += mcp251xfd-rx.o
 mcp251xfd-objs += mcp251xfd-timestamp.o
+mcp251xfd-objs += mcp251xfd-tx.o
 
 mcp251xfd-$(CONFIG_DEV_COREDUMP) += mcp251xfd-dump.o
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index d6d0d0f34893..4445653e7743 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2069,193 +2069,6 @@ static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 	return handled;
 }
 
-static inline struct
-mcp251xfd_tx_obj *mcp251xfd_get_tx_obj_next(struct mcp251xfd_tx_ring *tx_ring)
-{
-	u8 tx_head;
-
-	tx_head = mcp251xfd_get_tx_head(tx_ring);
-
-	return &tx_ring->obj[tx_head];
-}
-
-static void
-mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
-			  struct mcp251xfd_tx_obj *tx_obj,
-			  const struct sk_buff *skb,
-			  unsigned int seq)
-{
-	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
-	struct mcp251xfd_hw_tx_obj_raw *hw_tx_obj;
-	union mcp251xfd_tx_obj_load_buf *load_buf;
-	u8 dlc;
-	u32 id, flags;
-	int len_sanitized = 0, len;
-
-	if (cfd->can_id & CAN_EFF_FLAG) {
-		u32 sid, eid;
-
-		sid = FIELD_GET(MCP251XFD_REG_FRAME_EFF_SID_MASK, cfd->can_id);
-		eid = FIELD_GET(MCP251XFD_REG_FRAME_EFF_EID_MASK, cfd->can_id);
-
-		id = FIELD_PREP(MCP251XFD_OBJ_ID_EID_MASK, eid) |
-			FIELD_PREP(MCP251XFD_OBJ_ID_SID_MASK, sid);
-
-		flags = MCP251XFD_OBJ_FLAGS_IDE;
-	} else {
-		id = FIELD_PREP(MCP251XFD_OBJ_ID_SID_MASK, cfd->can_id);
-		flags = 0;
-	}
-
-	/* Use the MCP2518FD mask even on the MCP2517FD. It doesn't
-	 * harm, only the lower 7 bits will be transferred into the
-	 * TEF object.
-	 */
-	flags |= FIELD_PREP(MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK, seq);
-
-	if (cfd->can_id & CAN_RTR_FLAG)
-		flags |= MCP251XFD_OBJ_FLAGS_RTR;
-	else
-		len_sanitized = canfd_sanitize_len(cfd->len);
-
-	/* CANFD */
-	if (can_is_canfd_skb(skb)) {
-		if (cfd->flags & CANFD_ESI)
-			flags |= MCP251XFD_OBJ_FLAGS_ESI;
-
-		flags |= MCP251XFD_OBJ_FLAGS_FDF;
-
-		if (cfd->flags & CANFD_BRS)
-			flags |= MCP251XFD_OBJ_FLAGS_BRS;
-
-		dlc = can_fd_len2dlc(cfd->len);
-	} else {
-		dlc = can_get_cc_dlc((struct can_frame *)cfd,
-				     priv->can.ctrlmode);
-	}
-
-	flags |= FIELD_PREP(MCP251XFD_OBJ_FLAGS_DLC_MASK, dlc);
-
-	load_buf = &tx_obj->buf;
-	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX)
-		hw_tx_obj = &load_buf->crc.hw_tx_obj;
-	else
-		hw_tx_obj = &load_buf->nocrc.hw_tx_obj;
-
-	put_unaligned_le32(id, &hw_tx_obj->id);
-	put_unaligned_le32(flags, &hw_tx_obj->flags);
-
-	/* Copy data */
-	memcpy(hw_tx_obj->data, cfd->data, cfd->len);
-
-	/* Clear unused data at end of CAN frame */
-	if (MCP251XFD_SANITIZE_CAN && len_sanitized) {
-		int pad_len;
-
-		pad_len = len_sanitized - cfd->len;
-		if (pad_len)
-			memset(hw_tx_obj->data + cfd->len, 0x0, pad_len);
-	}
-
-	/* Number of bytes to be written into the RAM of the controller */
-	len = sizeof(hw_tx_obj->id) + sizeof(hw_tx_obj->flags);
-	if (MCP251XFD_SANITIZE_CAN)
-		len += round_up(len_sanitized, sizeof(u32));
-	else
-		len += round_up(cfd->len, sizeof(u32));
-
-	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX) {
-		u16 crc;
-
-		mcp251xfd_spi_cmd_crc_set_len_in_ram(&load_buf->crc.cmd,
-						     len);
-		/* CRC */
-		len += sizeof(load_buf->crc.cmd);
-		crc = mcp251xfd_crc16_compute(&load_buf->crc, len);
-		put_unaligned_be16(crc, (void *)load_buf + len);
-
-		/* Total length */
-		len += sizeof(load_buf->crc.crc);
-	} else {
-		len += sizeof(load_buf->nocrc.cmd);
-	}
-
-	tx_obj->xfer[0].len = len;
-}
-
-static int mcp251xfd_tx_obj_write(const struct mcp251xfd_priv *priv,
-				  struct mcp251xfd_tx_obj *tx_obj)
-{
-	return spi_async(priv->spi, &tx_obj->msg);
-}
-
-static bool mcp251xfd_tx_busy(const struct mcp251xfd_priv *priv,
-			      struct mcp251xfd_tx_ring *tx_ring)
-{
-	if (mcp251xfd_get_tx_free(tx_ring) > 0)
-		return false;
-
-	netif_stop_queue(priv->ndev);
-
-	/* Memory barrier before checking tx_free (head and tail) */
-	smp_mb();
-
-	if (mcp251xfd_get_tx_free(tx_ring) == 0) {
-		netdev_dbg(priv->ndev,
-			   "Stopping tx-queue (tx_head=0x%08x, tx_tail=0x%08x, len=%d).\n",
-			   tx_ring->head, tx_ring->tail,
-			   tx_ring->head - tx_ring->tail);
-
-		return true;
-	}
-
-	netif_start_queue(priv->ndev);
-
-	return false;
-}
-
-static netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
-					struct net_device *ndev)
-{
-	struct mcp251xfd_priv *priv = netdev_priv(ndev);
-	struct mcp251xfd_tx_ring *tx_ring = priv->tx;
-	struct mcp251xfd_tx_obj *tx_obj;
-	unsigned int frame_len;
-	u8 tx_head;
-	int err;
-
-	if (can_dropped_invalid_skb(ndev, skb))
-		return NETDEV_TX_OK;
-
-	if (mcp251xfd_tx_busy(priv, tx_ring))
-		return NETDEV_TX_BUSY;
-
-	tx_obj = mcp251xfd_get_tx_obj_next(tx_ring);
-	mcp251xfd_tx_obj_from_skb(priv, tx_obj, skb, tx_ring->head);
-
-	/* Stop queue if we occupy the complete TX FIFO */
-	tx_head = mcp251xfd_get_tx_head(tx_ring);
-	tx_ring->head++;
-	if (mcp251xfd_get_tx_free(tx_ring) == 0)
-		netif_stop_queue(ndev);
-
-	frame_len = can_skb_get_frame_len(skb);
-	err = can_put_echo_skb(skb, ndev, tx_head, frame_len);
-	if (!err)
-		netdev_sent_queue(priv->ndev, frame_len);
-
-	err = mcp251xfd_tx_obj_write(priv, tx_obj);
-	if (err)
-		goto out_err;
-
-	return NETDEV_TX_OK;
-
- out_err:
-	netdev_err(priv->ndev, "ERROR in %s: %d\n", __func__, err);
-
-	return NETDEV_TX_OK;
-}
-
 static int mcp251xfd_open(struct net_device *ndev)
 {
 	struct mcp251xfd_priv *priv = netdev_priv(ndev);
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
new file mode 100644
index 000000000000..ffb6c36b7d9b
--- /dev/null
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
@@ -0,0 +1,205 @@
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
+#include <linux/bitfield.h>
+
+#include "mcp251xfd.h"
+
+static inline struct
+mcp251xfd_tx_obj *mcp251xfd_get_tx_obj_next(struct mcp251xfd_tx_ring *tx_ring)
+{
+	u8 tx_head;
+
+	tx_head = mcp251xfd_get_tx_head(tx_ring);
+
+	return &tx_ring->obj[tx_head];
+}
+
+static void
+mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
+			  struct mcp251xfd_tx_obj *tx_obj,
+			  const struct sk_buff *skb,
+			  unsigned int seq)
+{
+	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+	struct mcp251xfd_hw_tx_obj_raw *hw_tx_obj;
+	union mcp251xfd_tx_obj_load_buf *load_buf;
+	u8 dlc;
+	u32 id, flags;
+	int len_sanitized = 0, len;
+
+	if (cfd->can_id & CAN_EFF_FLAG) {
+		u32 sid, eid;
+
+		sid = FIELD_GET(MCP251XFD_REG_FRAME_EFF_SID_MASK, cfd->can_id);
+		eid = FIELD_GET(MCP251XFD_REG_FRAME_EFF_EID_MASK, cfd->can_id);
+
+		id = FIELD_PREP(MCP251XFD_OBJ_ID_EID_MASK, eid) |
+			FIELD_PREP(MCP251XFD_OBJ_ID_SID_MASK, sid);
+
+		flags = MCP251XFD_OBJ_FLAGS_IDE;
+	} else {
+		id = FIELD_PREP(MCP251XFD_OBJ_ID_SID_MASK, cfd->can_id);
+		flags = 0;
+	}
+
+	/* Use the MCP2518FD mask even on the MCP2517FD. It doesn't
+	 * harm, only the lower 7 bits will be transferred into the
+	 * TEF object.
+	 */
+	flags |= FIELD_PREP(MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK, seq);
+
+	if (cfd->can_id & CAN_RTR_FLAG)
+		flags |= MCP251XFD_OBJ_FLAGS_RTR;
+	else
+		len_sanitized = canfd_sanitize_len(cfd->len);
+
+	/* CANFD */
+	if (can_is_canfd_skb(skb)) {
+		if (cfd->flags & CANFD_ESI)
+			flags |= MCP251XFD_OBJ_FLAGS_ESI;
+
+		flags |= MCP251XFD_OBJ_FLAGS_FDF;
+
+		if (cfd->flags & CANFD_BRS)
+			flags |= MCP251XFD_OBJ_FLAGS_BRS;
+
+		dlc = can_fd_len2dlc(cfd->len);
+	} else {
+		dlc = can_get_cc_dlc((struct can_frame *)cfd,
+				     priv->can.ctrlmode);
+	}
+
+	flags |= FIELD_PREP(MCP251XFD_OBJ_FLAGS_DLC_MASK, dlc);
+
+	load_buf = &tx_obj->buf;
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX)
+		hw_tx_obj = &load_buf->crc.hw_tx_obj;
+	else
+		hw_tx_obj = &load_buf->nocrc.hw_tx_obj;
+
+	put_unaligned_le32(id, &hw_tx_obj->id);
+	put_unaligned_le32(flags, &hw_tx_obj->flags);
+
+	/* Copy data */
+	memcpy(hw_tx_obj->data, cfd->data, cfd->len);
+
+	/* Clear unused data at end of CAN frame */
+	if (MCP251XFD_SANITIZE_CAN && len_sanitized) {
+		int pad_len;
+
+		pad_len = len_sanitized - cfd->len;
+		if (pad_len)
+			memset(hw_tx_obj->data + cfd->len, 0x0, pad_len);
+	}
+
+	/* Number of bytes to be written into the RAM of the controller */
+	len = sizeof(hw_tx_obj->id) + sizeof(hw_tx_obj->flags);
+	if (MCP251XFD_SANITIZE_CAN)
+		len += round_up(len_sanitized, sizeof(u32));
+	else
+		len += round_up(cfd->len, sizeof(u32));
+
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX) {
+		u16 crc;
+
+		mcp251xfd_spi_cmd_crc_set_len_in_ram(&load_buf->crc.cmd,
+						     len);
+		/* CRC */
+		len += sizeof(load_buf->crc.cmd);
+		crc = mcp251xfd_crc16_compute(&load_buf->crc, len);
+		put_unaligned_be16(crc, (void *)load_buf + len);
+
+		/* Total length */
+		len += sizeof(load_buf->crc.crc);
+	} else {
+		len += sizeof(load_buf->nocrc.cmd);
+	}
+
+	tx_obj->xfer[0].len = len;
+}
+
+static int mcp251xfd_tx_obj_write(const struct mcp251xfd_priv *priv,
+				  struct mcp251xfd_tx_obj *tx_obj)
+{
+	return spi_async(priv->spi, &tx_obj->msg);
+}
+
+static bool mcp251xfd_tx_busy(const struct mcp251xfd_priv *priv,
+			      struct mcp251xfd_tx_ring *tx_ring)
+{
+	if (mcp251xfd_get_tx_free(tx_ring) > 0)
+		return false;
+
+	netif_stop_queue(priv->ndev);
+
+	/* Memory barrier before checking tx_free (head and tail) */
+	smp_mb();
+
+	if (mcp251xfd_get_tx_free(tx_ring) == 0) {
+		netdev_dbg(priv->ndev,
+			   "Stopping tx-queue (tx_head=0x%08x, tx_tail=0x%08x, len=%d).\n",
+			   tx_ring->head, tx_ring->tail,
+			   tx_ring->head - tx_ring->tail);
+
+		return true;
+	}
+
+	netif_start_queue(priv->ndev);
+
+	return false;
+}
+
+netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
+				 struct net_device *ndev)
+{
+	struct mcp251xfd_priv *priv = netdev_priv(ndev);
+	struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	struct mcp251xfd_tx_obj *tx_obj;
+	unsigned int frame_len;
+	u8 tx_head;
+	int err;
+
+	if (can_dropped_invalid_skb(ndev, skb))
+		return NETDEV_TX_OK;
+
+	if (mcp251xfd_tx_busy(priv, tx_ring))
+		return NETDEV_TX_BUSY;
+
+	tx_obj = mcp251xfd_get_tx_obj_next(tx_ring);
+	mcp251xfd_tx_obj_from_skb(priv, tx_obj, skb, tx_ring->head);
+
+	/* Stop queue if we occupy the complete TX FIFO */
+	tx_head = mcp251xfd_get_tx_head(tx_ring);
+	tx_ring->head++;
+	if (mcp251xfd_get_tx_free(tx_ring) == 0)
+		netif_stop_queue(ndev);
+
+	frame_len = can_skb_get_frame_len(skb);
+	err = can_put_echo_skb(skb, ndev, tx_head, frame_len);
+	if (!err)
+		netdev_sent_queue(priv->ndev, frame_len);
+
+	err = mcp251xfd_tx_obj_write(priv, tx_obj);
+	if (err)
+		goto out_err;
+
+	return NETDEV_TX_OK;
+
+ out_err:
+	netdev_err(priv->ndev, "ERROR in %s: %d\n", __func__, err);
+
+	return NETDEV_TX_OK;
+}
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 8b35417316a0..bd1c22815f31 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -859,6 +859,9 @@ void mcp251xfd_skb_set_timestamp(const struct mcp251xfd_priv *priv,
 void mcp251xfd_timestamp_init(struct mcp251xfd_priv *priv);
 void mcp251xfd_timestamp_stop(struct mcp251xfd_priv *priv);
 
+netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
+				 struct net_device *ndev);
+
 #if IS_ENABLED(CONFIG_DEV_COREDUMP)
 void mcp251xfd_dump(const struct mcp251xfd_priv *priv);
 #else
-- 
2.34.1



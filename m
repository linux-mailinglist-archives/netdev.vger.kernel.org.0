Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA742BAB56
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgKTNeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgKTNd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB53C061A47
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XT-0006Fn-R2; Fri, 20 Nov 2020 14:33:23 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 06/25] can: rename CAN FD related can_len2dlc and can_dlc2len helpers
Date:   Fri, 20 Nov 2020 14:32:59 +0100
Message-Id: <20201120133318.3428231-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

The helper functions can_len2dlc and can_dlc2len are only relevant for
CAN FD data length code (DLC) conversion.

To fit the introduced can_cc_dlc2len for Classical CAN we rename:

can_dlc2len -> can_fd_dlc2len to get the payload length from the DLC
can_len2dlc -> can_fd_len2dlc to get the DLC from the payload length

Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201110101852.1973-6-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/can.rst                  | 2 +-
 drivers/net/can/dev.c                             | 8 ++++----
 drivers/net/can/flexcan.c                         | 4 ++--
 drivers/net/can/ifi_canfd/ifi_canfd.c             | 4 ++--
 drivers/net/can/kvaser_pciefd.c                   | 6 +++---
 drivers/net/can/m_can/m_can.c                     | 6 +++---
 drivers/net/can/peak_canfd/peak_canfd.c           | 4 ++--
 drivers/net/can/rcar/rcar_canfd.c                 | 4 ++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c    | 8 ++++----
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 6 +++---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c        | 4 ++--
 drivers/net/can/xilinx_can.c                      | 4 ++--
 include/linux/can/dev.h                           | 4 ++--
 13 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
index ff05cbd05e0d..4895b0dd2714 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -1332,7 +1332,7 @@ layer is a plain value from 0 .. 64 instead of the CAN 'data length code'.
 The data length code was a 1:1 mapping to the payload length in the legacy
 CAN frames anyway. The payload length to the bus-relevant DLC mapping is
 only performed inside the CAN drivers, preferably with the helper
-functions can_dlc2len() and can_len2dlc().
+functions can_fd_dlc2len() and can_fd_len2dlc().
 
 The CAN netdevice driver capabilities can be distinguished by the network
 devices maximum transfer unit (MTU)::
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 806e8b646b12..3486704c8a95 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -31,11 +31,11 @@ static const u8 dlc2len[] = {0, 1, 2, 3, 4, 5, 6, 7,
 			     8, 12, 16, 20, 24, 32, 48, 64};
 
 /* get data length from raw data length code (DLC) */
-u8 can_dlc2len(u8 dlc)
+u8 can_fd_dlc2len(u8 dlc)
 {
 	return dlc2len[dlc & 0x0F];
 }
-EXPORT_SYMBOL_GPL(can_dlc2len);
+EXPORT_SYMBOL_GPL(can_fd_dlc2len);
 
 static const u8 len2dlc[] = {0, 1, 2, 3, 4, 5, 6, 7, 8,		/* 0 - 8 */
 			     9, 9, 9, 9,			/* 9 - 12 */
@@ -49,14 +49,14 @@ static const u8 len2dlc[] = {0, 1, 2, 3, 4, 5, 6, 7, 8,		/* 0 - 8 */
 			     15, 15, 15, 15, 15, 15, 15, 15};	/* 57 - 64 */
 
 /* map the sanitized data length to an appropriate data length code */
-u8 can_len2dlc(u8 len)
+u8 can_fd_len2dlc(u8 len)
 {
 	if (unlikely(len > 64))
 		return 0xF;
 
 	return len2dlc[len];
 }
-EXPORT_SYMBOL_GPL(can_len2dlc);
+EXPORT_SYMBOL_GPL(can_fd_len2dlc);
 
 #ifdef CONFIG_CAN_CALC_BITTIMING
 #define CAN_CALC_MAX_ERROR 50 /* in one-tenth of a percent */
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 985569f946e5..6f3555381230 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -746,7 +746,7 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *skb, struct net_device *de
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	u32 can_id;
 	u32 data;
-	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | ((can_len2dlc(cfd->len)) << 16);
+	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | ((can_fd_len2dlc(cfd->len)) << 16);
 	int i;
 
 	if (can_dropped_invalid_skb(dev, skb))
@@ -1000,7 +1000,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 		cfd->can_id = (reg_id >> 18) & CAN_SFF_MASK;
 
 	if (reg_ctrl & FLEXCAN_MB_CNT_EDL) {
-		cfd->len = can_dlc2len((reg_ctrl >> 16) & 0xf);
+		cfd->len = can_fd_dlc2len((reg_ctrl >> 16) & 0xf);
 
 		if (reg_ctrl & FLEXCAN_MB_CNT_BRS)
 			cfd->flags |= CANFD_BRS;
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 3df55b0e4ef3..86b0e1406a21 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -271,7 +271,7 @@ static void ifi_canfd_read_fifo(struct net_device *ndev)
 	dlc = (rxdlc >> IFI_CANFD_RXFIFO_DLC_DLC_OFFSET) &
 	      IFI_CANFD_RXFIFO_DLC_DLC_MASK;
 	if (rxdlc & IFI_CANFD_RXFIFO_DLC_EDL)
-		cf->len = can_dlc2len(dlc);
+		cf->len = can_fd_dlc2len(dlc);
 	else
 		cf->len = can_cc_dlc2len(dlc);
 
@@ -900,7 +900,7 @@ static netdev_tx_t ifi_canfd_start_xmit(struct sk_buff *skb,
 		txid = cf->can_id & CAN_SFF_MASK;
 	}
 
-	txdlc = can_len2dlc(cf->len);
+	txdlc = can_fd_len2dlc(cf->len);
 	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) && can_is_canfd_skb(skb)) {
 		txdlc |= IFI_CANFD_TXFIFO_DLC_EDL;
 		if (cf->flags & CANFD_BRS)
diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index de268a344fcf..1bafa614950e 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -740,7 +740,7 @@ static int kvaser_pciefd_prepare_tx_packet(struct kvaser_pciefd_tx_packet *p,
 		p->header[0] |= KVASER_PCIEFD_RPACKET_IDE;
 
 	p->header[0] |= cf->can_id & CAN_EFF_MASK;
-	p->header[1] |= can_len2dlc(cf->len) << KVASER_PCIEFD_RPACKET_DLC_SHIFT;
+	p->header[1] |= can_fd_len2dlc(cf->len) << KVASER_PCIEFD_RPACKET_DLC_SHIFT;
 	p->header[1] |= KVASER_PCIEFD_TPACKET_AREQ;
 
 	if (can_is_canfd_skb(skb)) {
@@ -1174,7 +1174,7 @@ static int kvaser_pciefd_handle_data_packet(struct kvaser_pciefd *pcie,
 	if (p->header[0] & KVASER_PCIEFD_RPACKET_IDE)
 		cf->can_id |= CAN_EFF_FLAG;
 
-	cf->len = can_dlc2len(p->header[1] >> KVASER_PCIEFD_RPACKET_DLC_SHIFT);
+	cf->len = can_fd_dlc2len(p->header[1] >> KVASER_PCIEFD_RPACKET_DLC_SHIFT);
 
 	if (p->header[0] & KVASER_PCIEFD_RPACKET_RTR)
 		cf->can_id |= CAN_RTR_FLAG;
@@ -1600,7 +1600,7 @@ static int kvaser_pciefd_read_packet(struct kvaser_pciefd *pcie, int *start_pos,
 		if (!(p->header[0] & KVASER_PCIEFD_RPACKET_RTR)) {
 			u8 data_len;
 
-			data_len = can_dlc2len(p->header[1] >>
+			data_len = can_fd_dlc2len(p->header[1] >>
 					       KVASER_PCIEFD_RPACKET_DLC_SHIFT);
 			pos += DIV_ROUND_UP(data_len, 4);
 		}
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index b7df90ceee4b..a345e22f545e 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -457,7 +457,7 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	}
 
 	if (dlc & RX_BUF_FDF)
-		cf->len = can_dlc2len((dlc >> 16) & 0x0F);
+		cf->len = can_fd_dlc2len((dlc >> 16) & 0x0F);
 	else
 		cf->len = can_cc_dlc2len((dlc >> 16) & 0x0F);
 
@@ -1489,7 +1489,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		/* message ram configuration */
 		m_can_fifo_write(cdev, 0, M_CAN_FIFO_ID, id);
 		m_can_fifo_write(cdev, 0, M_CAN_FIFO_DLC,
-				 can_len2dlc(cf->len) << 16);
+				 can_fd_len2dlc(cf->len) << 16);
 
 		for (i = 0; i < cf->len; i += 4)
 			m_can_fifo_write(cdev, 0,
@@ -1557,7 +1557,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DLC,
 				 ((putidx << TX_BUF_MM_SHIFT) &
 				  TX_BUF_MM_MASK) |
-				 (can_len2dlc(cf->len) << 16) |
+				 (can_fd_len2dlc(cf->len) << 16) |
 				 fdflags | TX_BUF_EFC);
 
 		for (i = 0; i < cf->len; i += 4)
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index fff3a35276aa..c5334b0c3038 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -257,7 +257,7 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 	u8 cf_len;
 
 	if (rx_msg_flags & PUCAN_MSG_EXT_DATA_LEN)
-		cf_len = can_dlc2len(pucan_msg_get_dlc(msg));
+		cf_len = can_fd_dlc2len(pucan_msg_get_dlc(msg));
 	else
 		cf_len = can_cc_dlc2len(pucan_msg_get_dlc(msg));
 
@@ -682,7 +682,7 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 
 	if (can_is_canfd_skb(skb)) {
 		/* CAN FD frame format */
-		len = can_len2dlc(cf->len);
+		len = can_fd_len2dlc(cf->len);
 
 		msg_flags |= PUCAN_MSG_EXT_DATA_LEN;
 
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 86c6cbdb7e53..2778ed5c61d1 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1357,7 +1357,7 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 	if (cf->can_id & CAN_RTR_FLAG)
 		id |= RCANFD_CFID_CFRTR;
 
-	dlc = RCANFD_CFPTR_CFDLC(can_len2dlc(cf->len));
+	dlc = RCANFD_CFPTR_CFDLC(can_fd_len2dlc(cf->len));
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		rcar_canfd_write(priv->base,
@@ -1446,7 +1446,7 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		if (sts & RCANFD_RFFDSTS_RFFDF)
-			cf->len = can_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
+			cf->len = can_fd_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 		else
 			cf->len = can_cc_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 3bac7274ee5b..afa8cfc729b5 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1405,7 +1405,7 @@ mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
 			cfd->flags |= CANFD_BRS;
 
 		dlc = FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC, hw_rx_obj->flags);
-		cfd->len = can_dlc2len(dlc);
+		cfd->len = can_fd_dlc2len(dlc);
 	} else {
 		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR)
 			cfd->can_id |= CAN_RTR_FLAG;
@@ -2244,7 +2244,7 @@ mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
 	 * harm, only the lower 7 bits will be transferred into the
 	 * TEF object.
 	 */
-	dlc = can_len2dlc(cfd->len);
+	dlc = can_fd_len2dlc(cfd->len);
 	flags |= FIELD_PREP(MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK, seq) |
 		FIELD_PREP(MCP251XFD_OBJ_FLAGS_DLC, dlc);
 
@@ -2273,7 +2273,7 @@ mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
 
 	/* Clear data at end of CAN frame */
 	offset = round_down(cfd->len, sizeof(u32));
-	len = round_up(can_dlc2len(dlc), sizeof(u32)) - offset;
+	len = round_up(can_fd_dlc2len(dlc), sizeof(u32)) - offset;
 	if (MCP251XFD_SANITIZE_CAN && len)
 		memset(hw_tx_obj->data + offset, 0x0, len);
 	memcpy(hw_tx_obj->data, cfd->data, cfd->len);
@@ -2281,7 +2281,7 @@ mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
 	/* Number of bytes to be written into the RAM of the controller */
 	len = sizeof(hw_tx_obj->id) + sizeof(hw_tx_obj->flags);
 	if (MCP251XFD_SANITIZE_CAN)
-		len += round_up(can_dlc2len(dlc), sizeof(u32));
+		len += round_up(can_fd_dlc2len(dlc), sizeof(u32));
 	else
 		len += round_up(cfd->len, sizeof(u32));
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index c6d5f3f656c3..107b205b77ab 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1120,7 +1120,7 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 		struct net_device_stats *stats = &priv->netdev->stats;
 
 		stats->tx_packets++;
-		stats->tx_bytes += can_dlc2len(context->dlc);
+		stats->tx_bytes += can_fd_dlc2len(context->dlc);
 	}
 
 	spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);
@@ -1251,7 +1251,7 @@ static void kvaser_usb_hydra_rx_msg_ext(const struct kvaser_usb *dev,
 		kvaser_usb_can_rx_over_error(priv->netdev);
 
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_FDF) {
-		cf->len = can_dlc2len(dlc);
+		cf->len = can_fd_dlc2len(dlc);
 		if (flags & KVASER_USB_HYDRA_CF_FLAG_BRS)
 			cf->flags |= CANFD_BRS;
 		if (flags & KVASER_USB_HYDRA_CF_FLAG_ESI)
@@ -1351,7 +1351,7 @@ kvaser_usb_hydra_frame_to_cmd_ext(const struct kvaser_usb_net_priv *priv,
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd_ext *cmd;
 	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
-	u8 dlc = can_len2dlc(cf->len);
+	u8 dlc = can_fd_len2dlc(cf->len);
 	u8 nbr_of_bytes = cf->len;
 	u32 flags;
 	u32 id;
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 922280692a8f..761e78d8e647 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -492,7 +492,7 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 		if (rx_msg_flags & PUCAN_MSG_ERROR_STATE_IND)
 			cfd->flags |= CANFD_ESI;
 
-		cfd->len = can_dlc2len(pucan_msg_get_dlc(rm));
+		cfd->len = can_fd_dlc2len(pucan_msg_get_dlc(rm));
 	} else {
 		/* CAN 2.0 frame case */
 		skb = alloc_can_skb(netdev, (struct can_frame **)&cfd);
@@ -756,7 +756,7 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 
 	if (can_is_canfd_skb(skb)) {
 		/* considering a CANFD frame */
-		len = can_len2dlc(cfd->len);
+		len = can_fd_len2dlc(cfd->len);
 
 		tx_msg_flags |= PUCAN_MSG_EXT_DATA_LEN;
 
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 88831ce0f2f8..3f54edee92eb 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -583,7 +583,7 @@ static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
 			id |= XCAN_IDR_SRR_MASK;
 	}
 
-	dlc = can_len2dlc(cf->len) << XCAN_DLCR_DLC_SHIFT;
+	dlc = can_fd_len2dlc(cf->len) << XCAN_DLCR_DLC_SHIFT;
 	if (can_is_canfd_skb(skb)) {
 		if (cf->flags & CANFD_BRS)
 			dlc |= XCAN_DLCR_BRS_MASK;
@@ -832,7 +832,7 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
 	 * format
 	 */
 	if (dlc & XCAN_DLCR_EDL_MASK)
-		cf->len = can_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
+		cf->len = can_fd_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
 				  XCAN_DLCR_DLC_SHIFT);
 	else
 		cf->len = can_cc_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 77da061c21c9..e767a96ae075 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -186,10 +186,10 @@ static inline void can_set_static_ctrlmode(struct net_device *dev,
 }
 
 /* get data length from raw data length code (DLC) */
-u8 can_dlc2len(u8 dlc);
+u8 can_fd_dlc2len(u8 dlc);
 
 /* map the sanitized data length to an appropriate data length code */
-u8 can_len2dlc(u8 len);
+u8 can_fd_len2dlc(u8 len);
 
 struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
 				    unsigned int txqs, unsigned int rxqs);
-- 
2.29.2


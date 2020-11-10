Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302402AD36A
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732044AbgKJKTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:19:17 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:23173 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731886AbgKJKTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:19:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1605003548;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=998jvg33guotTgYt35/RlgpnmOOkOUBLFFKj1YMI8B0=;
        b=SbJnpEKIYAt02c5Uos1N4PUb4HLlDa+SGT84sHe4B1Kec9KIWrSIV5Kv7anTbGvXGO
        5MYx/Gvi05KIQSf+1t3rlkiB8ID37z/eO+YzYS+Kuvi1Az4VPw/NguVATgVrNJRWjGAS
        nk4ifCfWNUZtvWo1Cbst/rhz9A/iWNnFgWwoNPLXIgH2eLCdejol62rinmGHYor33xZE
        A39MML2nno0EYqah9idlq1NQ+PqZVJhGT7d0kH8BJIUtvz34IiAsFGy46wTWF0f20wXS
        LH9FZSR1zwHk2BBnO38LobS31FykX6K1+u4bZaskCry7IcAZ0ZR45oFhjJ16eQ+t1fnd
        lr8w==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJywjsi+/Fw=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwAAAJ3AQh
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Nov 2020 11:19:03 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v6 5/8] can: rename CAN FD related can_len2dlc and can_dlc2len helpers
Date:   Tue, 10 Nov 2020 11:18:49 +0100
Message-Id: <20201110101852.1973-6-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110101852.1973-1-socketcan@hartkopp.net>
References: <20201110101852.1973-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper functions can_len2dlc and can_dlc2len are only relevant for
CAN FD data length code (DLC) conversion.

To fit the introduced can_cc_dlc2len for Classical CAN we rename:

can_dlc2len -> can_fd_dlc2len to get the payload length from the DLC
can_len2dlc -> can_fd_len2dlc to get the DLC from the payload length

Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
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
@@ -1330,11 +1330,11 @@ payload. The representation of this length in can_frame.can_dlc and
 canfd_frame.len for userspace applications and inside the Linux network
 layer is a plain value from 0 .. 64 instead of the CAN 'data length code'.
 The data length code was a 1:1 mapping to the payload length in the legacy
 CAN frames anyway. The payload length to the bus-relevant DLC mapping is
 only performed inside the CAN drivers, preferably with the helper
-functions can_dlc2len() and can_len2dlc().
+functions can_fd_dlc2len() and can_fd_len2dlc().
 
 The CAN netdevice driver capabilities can be distinguished by the network
 devices maximum transfer unit (MTU)::
 
   MTU = 16 (CAN_MTU)   => sizeof(struct can_frame)   => 'legacy' CAN device
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 566501a02b91..7878544184b9 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -29,15 +29,15 @@ MODULE_AUTHOR("Wolfgang Grandegger <wg@grandegger.com>");
 
 static const u8 dlc2len[] = {0, 1, 2, 3, 4, 5, 6, 7,
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
 			     10, 10, 10, 10,			/* 13 - 16 */
 			     11, 11, 11, 11,			/* 17 - 20 */
@@ -47,18 +47,18 @@ static const u8 len2dlc[] = {0, 1, 2, 3, 4, 5, 6, 7, 8,		/* 0 - 8 */
 			     14, 14, 14, 14, 14, 14, 14, 14,	/* 41 - 48 */
 			     15, 15, 15, 15, 15, 15, 15, 15,	/* 49 - 56 */
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
 
 /* Bit-timing calculation derived from:
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e76fb1500fa1..5542290d29f5 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -742,11 +742,11 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *skb, struct net_device *de
 {
 	const struct flexcan_priv *priv = netdev_priv(dev);
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	u32 can_id;
 	u32 data;
-	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | ((can_len2dlc(cfd->len)) << 16);
+	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | ((can_fd_len2dlc(cfd->len)) << 16);
 	int i;
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
 
@@ -996,11 +996,11 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 		cfd->can_id = ((reg_id >> 0) & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
 		cfd->can_id = (reg_id >> 18) & CAN_SFF_MASK;
 
 	if (reg_ctrl & FLEXCAN_MB_CNT_EDL) {
-		cfd->len = can_dlc2len((reg_ctrl >> 16) & 0xf);
+		cfd->len = can_fd_dlc2len((reg_ctrl >> 16) & 0xf);
 
 		if (reg_ctrl & FLEXCAN_MB_CNT_BRS)
 			cfd->flags |= CANFD_BRS;
 	} else {
 		cfd->len = can_cc_dlc2len((reg_ctrl >> 16) & 0xf);
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 3df55b0e4ef3..86b0e1406a21 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -269,11 +269,11 @@ static void ifi_canfd_read_fifo(struct net_device *ndev)
 	}
 
 	dlc = (rxdlc >> IFI_CANFD_RXFIFO_DLC_DLC_OFFSET) &
 	      IFI_CANFD_RXFIFO_DLC_DLC_MASK;
 	if (rxdlc & IFI_CANFD_RXFIFO_DLC_EDL)
-		cf->len = can_dlc2len(dlc);
+		cf->len = can_fd_dlc2len(dlc);
 	else
 		cf->len = can_cc_dlc2len(dlc);
 
 	rxid = readl(priv->base + IFI_CANFD_RXFIFO_ID);
 	id = (rxid >> IFI_CANFD_RXFIFO_ID_ID_OFFSET);
@@ -898,11 +898,11 @@ static netdev_tx_t ifi_canfd_start_xmit(struct sk_buff *skb,
 		txid |= IFI_CANFD_TXFIFO_ID_IDE;
 	} else {
 		txid = cf->can_id & CAN_SFF_MASK;
 	}
 
-	txdlc = can_len2dlc(cf->len);
+	txdlc = can_fd_len2dlc(cf->len);
 	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) && can_is_canfd_skb(skb)) {
 		txdlc |= IFI_CANFD_TXFIFO_DLC_EDL;
 		if (cf->flags & CANFD_BRS)
 			txdlc |= IFI_CANFD_TXFIFO_DLC_BRS;
 	}
diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 8b5f75209b09..118c6d7b38ac 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -738,11 +738,11 @@ static int kvaser_pciefd_prepare_tx_packet(struct kvaser_pciefd_tx_packet *p,
 
 	if (cf->can_id & CAN_EFF_FLAG)
 		p->header[0] |= KVASER_PCIEFD_RPACKET_IDE;
 
 	p->header[0] |= cf->can_id & CAN_EFF_MASK;
-	p->header[1] |= can_len2dlc(cf->len) << KVASER_PCIEFD_RPACKET_DLC_SHIFT;
+	p->header[1] |= can_fd_len2dlc(cf->len) << KVASER_PCIEFD_RPACKET_DLC_SHIFT;
 	p->header[1] |= KVASER_PCIEFD_TPACKET_AREQ;
 
 	if (can_is_canfd_skb(skb)) {
 		p->header[1] |= KVASER_PCIEFD_RPACKET_FDF;
 		if (cf->flags & CANFD_BRS)
@@ -1172,11 +1172,11 @@ static int kvaser_pciefd_handle_data_packet(struct kvaser_pciefd *pcie,
 
 	cf->can_id = p->header[0] & CAN_EFF_MASK;
 	if (p->header[0] & KVASER_PCIEFD_RPACKET_IDE)
 		cf->can_id |= CAN_EFF_FLAG;
 
-	cf->len = can_dlc2len(p->header[1] >> KVASER_PCIEFD_RPACKET_DLC_SHIFT);
+	cf->len = can_fd_dlc2len(p->header[1] >> KVASER_PCIEFD_RPACKET_DLC_SHIFT);
 
 	if (p->header[0] & KVASER_PCIEFD_RPACKET_RTR)
 		cf->can_id |= CAN_RTR_FLAG;
 	else
 		memcpy(cf->data, data, cf->len);
@@ -1598,11 +1598,11 @@ static int kvaser_pciefd_read_packet(struct kvaser_pciefd *pcie, int *start_pos,
 	case KVASER_PCIEFD_PACK_TYPE_DATA:
 		ret = kvaser_pciefd_handle_data_packet(pcie, p, &buffer[pos]);
 		if (!(p->header[0] & KVASER_PCIEFD_RPACKET_RTR)) {
 			u8 data_len;
 
-			data_len = can_dlc2len(p->header[1] >>
+			data_len = can_fd_dlc2len(p->header[1] >>
 					       KVASER_PCIEFD_RPACKET_DLC_SHIFT);
 			pos += DIV_ROUND_UP(data_len, 4);
 		}
 		break;
 
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e753c5f636bb..18a0f41bd90a 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -455,11 +455,11 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 		stats->rx_dropped++;
 		return;
 	}
 
 	if (dlc & RX_BUF_FDF)
-		cf->len = can_dlc2len((dlc >> 16) & 0x0F);
+		cf->len = can_fd_dlc2len((dlc >> 16) & 0x0F);
 	else
 		cf->len = can_cc_dlc2len((dlc >> 16) & 0x0F);
 
 	id = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID);
 	if (id & RX_BUF_XTD)
@@ -1482,11 +1482,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		netif_stop_queue(dev);
 
 		/* message ram configuration */
 		m_can_fifo_write(cdev, 0, M_CAN_FIFO_ID, id);
 		m_can_fifo_write(cdev, 0, M_CAN_FIFO_DLC,
-				 can_len2dlc(cf->len) << 16);
+				 can_fd_len2dlc(cf->len) << 16);
 
 		for (i = 0; i < cf->len; i += 4)
 			m_can_fifo_write(cdev, 0,
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
@@ -1550,11 +1550,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		 * sending the correct echo frame
 		 */
 		m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DLC,
 				 ((putidx << TX_BUF_MM_SHIFT) &
 				  TX_BUF_MM_MASK) |
-				 (can_len2dlc(cf->len) << 16) |
+				 (can_fd_len2dlc(cf->len) << 16) |
 				 fdflags | TX_BUF_EFC);
 
 		for (i = 0; i < cf->len; i += 4)
 			m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index fff3a35276aa..c5334b0c3038 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -255,11 +255,11 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 	struct sk_buff *skb;
 	const u16 rx_msg_flags = le16_to_cpu(msg->flags);
 	u8 cf_len;
 
 	if (rx_msg_flags & PUCAN_MSG_EXT_DATA_LEN)
-		cf_len = can_dlc2len(pucan_msg_get_dlc(msg));
+		cf_len = can_fd_dlc2len(pucan_msg_get_dlc(msg));
 	else
 		cf_len = can_cc_dlc2len(pucan_msg_get_dlc(msg));
 
 	/* if this frame is an echo, */
 	if (rx_msg_flags & PUCAN_MSG_LOOPED_BACK) {
@@ -680,11 +680,11 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 		msg->can_id = cpu_to_le32(cf->can_id & CAN_SFF_MASK);
 	}
 
 	if (can_is_canfd_skb(skb)) {
 		/* CAN FD frame format */
-		len = can_len2dlc(cf->len);
+		len = can_fd_len2dlc(cf->len);
 
 		msg_flags |= PUCAN_MSG_EXT_DATA_LEN;
 
 		if (cf->flags & CANFD_BRS)
 			msg_flags |= PUCAN_MSG_BITRATE_SWITCH;
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 86c6cbdb7e53..2778ed5c61d1 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1355,11 +1355,11 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 	}
 
 	if (cf->can_id & CAN_RTR_FLAG)
 		id |= RCANFD_CFID_CFRTR;
 
-	dlc = RCANFD_CFPTR_CFDLC(can_len2dlc(cf->len));
+	dlc = RCANFD_CFPTR_CFDLC(can_fd_len2dlc(cf->len));
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		rcar_canfd_write(priv->base,
 				 RCANFD_F_CFID(ch, RCANFD_CFFIFO_IDX), id);
 		rcar_canfd_write(priv->base,
@@ -1444,11 +1444,11 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 	else
 		cf->can_id = id & CAN_SFF_MASK;
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		if (sts & RCANFD_RFFDSTS_RFFDF)
-			cf->len = can_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
+			cf->len = can_fd_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 		else
 			cf->len = can_cc_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 
 		if (sts & RCANFD_RFFDSTS_RFESI) {
 			cf->flags |= CANFD_ESI;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 3bac7274ee5b..afa8cfc729b5 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1403,11 +1403,11 @@ mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
 
 		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_BRS)
 			cfd->flags |= CANFD_BRS;
 
 		dlc = FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC, hw_rx_obj->flags);
-		cfd->len = can_dlc2len(dlc);
+		cfd->len = can_fd_dlc2len(dlc);
 	} else {
 		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR)
 			cfd->can_id |= CAN_RTR_FLAG;
 
 		cfd->len = can_cc_dlc2len(FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC,
@@ -2242,11 +2242,11 @@ mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
 
 	/* Use the MCP2518FD mask even on the MCP2517FD. It doesn't
 	 * harm, only the lower 7 bits will be transferred into the
 	 * TEF object.
 	 */
-	dlc = can_len2dlc(cfd->len);
+	dlc = can_fd_len2dlc(cfd->len);
 	flags |= FIELD_PREP(MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK, seq) |
 		FIELD_PREP(MCP251XFD_OBJ_FLAGS_DLC, dlc);
 
 	if (cfd->can_id & CAN_RTR_FLAG)
 		flags |= MCP251XFD_OBJ_FLAGS_RTR;
@@ -2271,19 +2271,19 @@ mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
 	put_unaligned_le32(id, &hw_tx_obj->id);
 	put_unaligned_le32(flags, &hw_tx_obj->flags);
 
 	/* Clear data at end of CAN frame */
 	offset = round_down(cfd->len, sizeof(u32));
-	len = round_up(can_dlc2len(dlc), sizeof(u32)) - offset;
+	len = round_up(can_fd_dlc2len(dlc), sizeof(u32)) - offset;
 	if (MCP251XFD_SANITIZE_CAN && len)
 		memset(hw_tx_obj->data + offset, 0x0, len);
 	memcpy(hw_tx_obj->data, cfd->data, cfd->len);
 
 	/* Number of bytes to be written into the RAM of the controller */
 	len = sizeof(hw_tx_obj->id) + sizeof(hw_tx_obj->flags);
 	if (MCP251XFD_SANITIZE_CAN)
-		len += round_up(can_dlc2len(dlc), sizeof(u32));
+		len += round_up(can_fd_dlc2len(dlc), sizeof(u32));
 	else
 		len += round_up(cfd->len, sizeof(u32));
 
 	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX) {
 		u16 crc;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index fea87398e5b7..b8e0e2a88326 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1118,11 +1118,11 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 	context = &priv->tx_contexts[transid % dev->max_tx_urbs];
 	if (!one_shot_fail) {
 		struct net_device_stats *stats = &priv->netdev->stats;
 
 		stats->tx_packets++;
-		stats->tx_bytes += can_dlc2len(context->dlc);
+		stats->tx_bytes += can_fd_dlc2len(context->dlc);
 	}
 
 	spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);
 
 	can_get_echo_skb(priv->netdev, context->echo_index);
@@ -1249,11 +1249,11 @@ static void kvaser_usb_hydra_rx_msg_ext(const struct kvaser_usb *dev,
 
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_OVERRUN)
 		kvaser_usb_can_rx_over_error(priv->netdev);
 
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_FDF) {
-		cf->len = can_dlc2len(dlc);
+		cf->len = can_fd_dlc2len(dlc);
 		if (flags & KVASER_USB_HYDRA_CF_FLAG_BRS)
 			cf->flags |= CANFD_BRS;
 		if (flags & KVASER_USB_HYDRA_CF_FLAG_ESI)
 			cf->flags |= CANFD_ESI;
 	} else {
@@ -1349,11 +1349,11 @@ kvaser_usb_hydra_frame_to_cmd_ext(const struct kvaser_usb_net_priv *priv,
 				  int *cmd_len, u16 transid)
 {
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd_ext *cmd;
 	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
-	u8 dlc = can_len2dlc(cf->len);
+	u8 dlc = can_fd_len2dlc(cf->len);
 	u8 nbr_of_bytes = cf->len;
 	u32 flags;
 	u32 id;
 	u32 kcan_id;
 	u32 kcan_header;
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 922280692a8f..761e78d8e647 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -490,11 +490,11 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 			cfd->flags |= CANFD_BRS;
 
 		if (rx_msg_flags & PUCAN_MSG_ERROR_STATE_IND)
 			cfd->flags |= CANFD_ESI;
 
-		cfd->len = can_dlc2len(pucan_msg_get_dlc(rm));
+		cfd->len = can_fd_dlc2len(pucan_msg_get_dlc(rm));
 	} else {
 		/* CAN 2.0 frame case */
 		skb = alloc_can_skb(netdev, (struct can_frame **)&cfd);
 		if (!skb)
 			return -ENOMEM;
@@ -754,11 +754,11 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 		tx_msg->can_id = cpu_to_le32(cfd->can_id & CAN_SFF_MASK);
 	}
 
 	if (can_is_canfd_skb(skb)) {
 		/* considering a CANFD frame */
-		len = can_len2dlc(cfd->len);
+		len = can_fd_len2dlc(cfd->len);
 
 		tx_msg_flags |= PUCAN_MSG_EXT_DATA_LEN;
 
 		if (cfd->flags & CANFD_BRS)
 			tx_msg_flags |= PUCAN_MSG_BITRATE_SWITCH;
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 88831ce0f2f8..3f54edee92eb 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -581,11 +581,11 @@ static void xcan_write_frame(struct net_device *ndev, struct sk_buff *skb,
 		if (cf->can_id & CAN_RTR_FLAG)
 			/* Standard frames remote TX request */
 			id |= XCAN_IDR_SRR_MASK;
 	}
 
-	dlc = can_len2dlc(cf->len) << XCAN_DLCR_DLC_SHIFT;
+	dlc = can_fd_len2dlc(cf->len) << XCAN_DLCR_DLC_SHIFT;
 	if (can_is_canfd_skb(skb)) {
 		if (cf->flags & CANFD_BRS)
 			dlc |= XCAN_DLCR_BRS_MASK;
 		dlc |= XCAN_DLCR_EDL_MASK;
 	}
@@ -830,11 +830,11 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
 
 	/* Change Xilinx CANFD data length format to socketCAN data
 	 * format
 	 */
 	if (dlc & XCAN_DLCR_EDL_MASK)
-		cf->len = can_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
+		cf->len = can_fd_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
 				  XCAN_DLCR_DLC_SHIFT);
 	else
 		cf->len = can_cc_dlc2len((dlc & XCAN_DLCR_DLC_MASK) >>
 					  XCAN_DLCR_DLC_SHIFT);
 
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 77da061c21c9..e767a96ae075 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -184,14 +184,14 @@ static inline void can_set_static_ctrlmode(struct net_device *dev,
 	if (static_mode & CAN_CTRLMODE_FD)
 		dev->mtu = CANFD_MTU;
 }
 
 /* get data length from raw data length code (DLC) */
-u8 can_dlc2len(u8 dlc);
+u8 can_fd_dlc2len(u8 dlc);
 
 /* map the sanitized data length to an appropriate data length code */
-u8 can_len2dlc(u8 len);
+u8 can_fd_len2dlc(u8 len);
 
 struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
 				    unsigned int txqs, unsigned int rxqs);
 #define alloc_candev(sizeof_priv, echo_skb_max) \
 	alloc_candev_mqs(sizeof_priv, echo_skb_max, 1, 1)
-- 
2.28.0


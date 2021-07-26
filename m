Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387103D5B6B
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhGZNe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbhGZNdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C39C0619F1
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81La-0002SO-Td
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B37A16582EE
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CB5CD65820A;
        Mon, 26 Jul 2021 14:12:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e4aaabd9;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 35/46] can: peak_usb: PCAN-USB: add support of loopback and one-shot mode
Date:   Mon, 26 Jul 2021 16:11:33 +0200
Message-Id: <20210726141144.862529-36-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

The CAN - USB PCAN-USB interface is able to generate one-shot frames
as well as loopback frames that it transmits starting from version 4.1
of its firmware.

This patch adds support for the one-shot and loopback functionality to
the driver, that can be activated if the embedded firmware allows it.
If the driver detects that the PCAN-USB device runs an old firmware
(< 4.1) it prints a message suggesting to contact
<support@peak-system.com> for a possible firmware update.

Link: https://lore.kernel.org/r/20210625130931.27438-3-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 53 +++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 9f3e16684e28..2362ac80c3da 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -73,6 +73,10 @@
 #define PCAN_USB_STATUSLEN_RTR		(1 << 4)
 #define PCAN_USB_STATUSLEN_DLC		(0xf)
 
+/* PCAN-USB 4.1 CAN Id tx extended flags */
+#define PCAN_USB_TX_SRR			0x01	/* SJA1000 SRR command */
+#define PCAN_USB_TX_AT			0x02	/* SJA1000 AT command */
+
 /* PCAN-USB error flags */
 #define PCAN_USB_ERROR_TXFULL		0x01
 #define PCAN_USB_ERROR_RXQOVR		0x02
@@ -705,6 +709,7 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 	struct sk_buff *skb;
 	struct can_frame *cf;
 	struct skb_shared_hwtstamps *hwts;
+	u32 can_id_flags;
 
 	skb = alloc_can_skb(mc->netdev, &cf);
 	if (!skb)
@@ -714,13 +719,15 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		if ((mc->ptr + 4) > mc->end)
 			goto decode_failed;
 
-		cf->can_id = get_unaligned_le32(mc->ptr) >> 3 | CAN_EFF_FLAG;
+		can_id_flags = get_unaligned_le32(mc->ptr);
+		cf->can_id = can_id_flags >> 3 | CAN_EFF_FLAG;
 		mc->ptr += 4;
 	} else {
 		if ((mc->ptr + 2) > mc->end)
 			goto decode_failed;
 
-		cf->can_id = get_unaligned_le16(mc->ptr) >> 5;
+		can_id_flags = get_unaligned_le16(mc->ptr);
+		cf->can_id = can_id_flags >> 5;
 		mc->ptr += 2;
 	}
 
@@ -743,6 +750,10 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 
 		memcpy(cf->data, mc->ptr, cf->len);
 		mc->ptr += rec_len;
+
+		/* Ignore next byte (client private id) if SRR bit is set */
+		if (can_id_flags & PCAN_USB_TX_SRR)
+			mc->ptr++;
 	}
 
 	/* convert timestamp into kernel time */
@@ -820,6 +831,7 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 	struct net_device *netdev = dev->netdev;
 	struct net_device_stats *stats = &netdev->stats;
 	struct can_frame *cf = (struct can_frame *)skb->data;
+	u32 can_id_flags = cf->can_id & CAN_ERR_MASK;
 	u8 *pc;
 
 	obuf[0] = 2;
@@ -838,12 +850,28 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 		*pc |= PCAN_USB_STATUSLEN_EXT_ID;
 		pc++;
 
-		put_unaligned_le32((cf->can_id & CAN_ERR_MASK) << 3, pc);
+		can_id_flags <<= 3;
+
+		if (dev->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
+			can_id_flags |= PCAN_USB_TX_SRR;
+
+		if (dev->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+			can_id_flags |= PCAN_USB_TX_AT;
+
+		put_unaligned_le32(can_id_flags, pc);
 		pc += 4;
 	} else {
 		pc++;
 
-		put_unaligned_le16((cf->can_id & CAN_ERR_MASK) << 5, pc);
+		can_id_flags <<= 5;
+
+		if (dev->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
+			can_id_flags |= PCAN_USB_TX_SRR;
+
+		if (dev->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+			can_id_flags |= PCAN_USB_TX_AT;
+
+		put_unaligned_le16(can_id_flags, pc);
 		pc += 2;
 	}
 
@@ -853,6 +881,10 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 		pc += cf->len;
 	}
 
+	/* SRR bit needs a writer id (useless here) */
+	if (can_id_flags & PCAN_USB_TX_SRR)
+		*pc++ = 0x80;
+
 	obuf[(*size)-1] = (u8)(stats->tx_packets & 0xff);
 
 	return 0;
@@ -927,6 +959,19 @@ static int pcan_usb_init(struct peak_usb_device *dev)
 		return err;
 	}
 
+	/* Since rev 4.1, PCAN-USB is able to make single-shot as well as
+	 * looped back frames.
+	 */
+	if (dev->device_rev >= 41) {
+		struct can_priv *priv = netdev_priv(dev->netdev);
+
+		priv->ctrlmode_supported |= CAN_CTRLMODE_ONE_SHOT |
+					    CAN_CTRLMODE_LOOPBACK;
+	} else {
+		dev_info(dev->netdev->dev.parent,
+			 "Firmware update available. Please contact support@peak-system.com\n");
+	}
+
 	dev_info(dev->netdev->dev.parent,
 		 "PEAK-System %s adapter hwrev %u serial %08X (%u channel)\n",
 		 pcan_usb.name, dev->device_rev, serial_number,
-- 
2.30.2



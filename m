Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968902AB4CD
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgKIK0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:26:52 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:31417 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729079AbgKIK0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:26:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604917606;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=BDT2VpctXon6JpSAiR5InoarRTIh3SEiX+6eGMUfvgE=;
        b=OIdcqV+zuUtbAQlfwNsW70pJ1uB8SsGGwbq1nzqizqjaLeUHXFUy8Etne2UtvjU3zB
        PbEBVNiP2vfxnrrKVNu/vrY0R2eXL24vHmyh+sKKuoyREB63W3ydhxwU0mO5QJ02lbZH
        2pMX5/p4AT0Rbelc3BzB3Zi+JBhB4iKo/xZWNtcckdqNtY7G0ni0t6g2/FwR5ue4rrfO
        9pgWjhCJW55Cg0vQpr1nBNCG2JQSzEhlYJ1cS5q8j0m+t+f0m2vB38ClXzbH94ZC2gVA
        XCoqIOUVFDbvqMWOvGU9QETQ52rbjfpAghGbVXZC8D4IM1bLBC6DFYQHjDMRwYCZQIfH
        jhwg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJywjskA="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwA9AQh6dU
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 9 Nov 2020 11:26:43 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v4 7/7] can-dev: add len8_dlc support for various CAN USB adapters
Date:   Mon,  9 Nov 2020 11:26:18 +0100
Message-Id: <20201109102618.2495-8-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201109102618.2495-1-socketcan@hartkopp.net>
References: <20201109102618.2495-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the Classical CAN raw DLC functionality to send and receive DLC
values from 9 .. 15 on various Classican CAN capable USB network drivers:

- gs_usb
- pcan_usb
- pcan_usb_fd
- usb_8dev

Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 drivers/net/can/usb/gs_usb.c               |  8 ++++++--
 drivers/net/can/usb/peak_usb/pcan_usb.c    |  8 ++++++--
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 17 ++++++++++++-----
 drivers/net/can/usb/usb_8dev.c             |  9 ++++++---
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 3a097c240e5a..fab6ed073e45 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -330,10 +330,13 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			return;
 
 		cf->can_id = hf->can_id;
 
 		cf->len = can_get_cc_len(hf->len);
+		cf->len8_dlc = can_get_len8_dlc(dev->can.ctrlmode, cf->len,
+						hf->len);
+
 		memcpy(cf->data, hf->data, 8);
 
 		/* ERROR frames tell us information about the controller */
 		if (hf->can_id & CAN_ERR_FLAG)
 			gs_update_state(dev, cf);
@@ -502,11 +505,12 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	hf->channel = dev->channel;
 
 	cf = (struct can_frame *)skb->data;
 
 	hf->can_id = cf->can_id;
-	hf->len = cf->len;
+	hf->len = can_get_cc_dlc(dev->can.ctrlmode, cf->len, cf->len8_dlc);
+
 	memcpy(hf->data, cf->data, cf->len);
 
 	usb_fill_bulk_urb(urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
 			  hf,
@@ -856,11 +860,11 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	dev->can.state = CAN_STATE_STOPPED;
 	dev->can.clock.freq = bt_const->fclk_can;
 	dev->can.bittiming_const = &dev->bt_const;
 	dev->can.do_set_bittiming = gs_usb_set_bittiming;
 
-	dev->can.ctrlmode_supported = 0;
+	dev->can.ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC;
 
 	if (bt_const->feature & GS_CAN_FEATURE_LISTEN_ONLY)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_LISTENONLY;
 
 	if (bt_const->feature & GS_CAN_FEATURE_LOOP_BACK)
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index abecb77e34f2..105a17dc8075 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -733,10 +733,12 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 
 		cf->can_id = le16_to_cpu(tmp16) >> 5;
 	}
 
 	cf->len = can_get_cc_len(rec_len);
+	cf->len8_dlc = can_get_len8_dlc(mc->pdev->dev.can.ctrlmode, cf->len,
+					rec_len);
 
 	/* Only first packet timestamp is a word */
 	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
 		goto decode_failed;
 
@@ -836,11 +838,12 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 	obuf[1] = 1;
 
 	pc = obuf + PCAN_USB_MSG_HEADER_LEN;
 
 	/* status/len byte */
-	*pc = cf->len;
+	*pc = can_get_cc_dlc(dev->can.ctrlmode, cf->len, cf->len8_dlc);
+
 	if (cf->can_id & CAN_RTR_FLAG)
 		*pc |= PCAN_USB_STATUSLEN_RTR;
 
 	/* can id */
 	if (cf->can_id & CAN_EFF_FLAG) {
@@ -990,11 +993,12 @@ static const struct can_bittiming_const pcan_usb_const = {
 const struct peak_usb_adapter pcan_usb = {
 	.name = "PCAN-USB",
 	.device_id = PCAN_USB_PRODUCT_ID,
 	.ctrl_count = 1,
 	.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
-			      CAN_CTRLMODE_BERR_REPORTING,
+			      CAN_CTRLMODE_BERR_REPORTING |
+			      CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_USB_CRYSTAL_HZ / 2 ,
 	},
 	.bittiming_const = &pcan_usb_const,
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 3e875cdbadac..bd90ce8c3f15 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -492,16 +492,21 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 		if (rx_msg_flags & PUCAN_MSG_ERROR_STATE_IND)
 			cfd->flags |= CANFD_ESI;
 
 		cfd->len = can_dlc2len(pucan_msg_get_dlc(rm));
 	} else {
+		struct can_frame *cf;
+
 		/* CAN 2.0 frame case */
 		skb = alloc_can_skb(netdev, (struct can_frame **)&cfd);
 		if (!skb)
 			return -ENOMEM;
 
 		cfd->len = can_get_cc_len(pucan_msg_get_dlc(rm));
+		cf = (struct can_frame *)cfd;
+		cf->len8_dlc = can_get_len8_dlc(dev->can.ctrlmode, cf->len,
+						pucan_msg_get_dlc(rm));
 	}
 
 	cfd->can_id = le32_to_cpu(rm->can_id);
 
 	if (rx_msg_flags & PUCAN_MSG_EXT_ID)
@@ -764,12 +769,14 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 			tx_msg_flags |= PUCAN_MSG_BITRATE_SWITCH;
 
 		if (cfd->flags & CANFD_ESI)
 			tx_msg_flags |= PUCAN_MSG_ERROR_STATE_IND;
 	} else {
+		struct can_frame *cf = (struct can_frame *)cfd;
+
 		/* CAND 2.0 frames */
-		len = cfd->len;
+		len = can_get_cc_dlc(dev->can.ctrlmode, cf->len, cf->len8_dlc);
 
 		if (cfd->can_id & CAN_RTR_FLAG)
 			tx_msg_flags |= PUCAN_MSG_RTR;
 	}
 
@@ -1033,11 +1040,11 @@ static const struct can_bittiming_const pcan_usb_fd_data_const = {
 
 const struct peak_usb_adapter pcan_usb_fd = {
 	.name = "PCAN-USB FD",
 	.device_id = PCAN_USBFD_PRODUCT_ID,
 	.ctrl_count = PCAN_USBFD_CHANNEL_COUNT,
-	.ctrlmode_supported = CAN_CTRLMODE_FD |
+	.ctrlmode_supported = CAN_CTRLMODE_FD | CAN_CTRLMODE_CC_LEN8_DLC |
 			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
 	.bittiming_const = &pcan_usb_fd_const,
@@ -1105,11 +1112,11 @@ static const struct can_bittiming_const pcan_usb_chip_data_const = {
 
 const struct peak_usb_adapter pcan_usb_chip = {
 	.name = "PCAN-Chip USB",
 	.device_id = PCAN_USBCHIP_PRODUCT_ID,
 	.ctrl_count = PCAN_USBFD_CHANNEL_COUNT,
-	.ctrlmode_supported = CAN_CTRLMODE_FD |
+	.ctrlmode_supported = CAN_CTRLMODE_FD | CAN_CTRLMODE_CC_LEN8_DLC |
 		CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
 	.bittiming_const = &pcan_usb_chip_const,
@@ -1177,11 +1184,11 @@ static const struct can_bittiming_const pcan_usb_pro_fd_data_const = {
 
 const struct peak_usb_adapter pcan_usb_pro_fd = {
 	.name = "PCAN-USB Pro FD",
 	.device_id = PCAN_USBPROFD_PRODUCT_ID,
 	.ctrl_count = PCAN_USBPROFD_CHANNEL_COUNT,
-	.ctrlmode_supported = CAN_CTRLMODE_FD |
+	.ctrlmode_supported = CAN_CTRLMODE_FD | CAN_CTRLMODE_CC_LEN8_DLC |
 			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
 	.bittiming_const = &pcan_usb_pro_fd_const,
@@ -1249,11 +1256,11 @@ static const struct can_bittiming_const pcan_usb_x6_data_const = {
 
 const struct peak_usb_adapter pcan_usb_x6 = {
 	.name = "PCAN-USB X6",
 	.device_id = PCAN_USBX6_PRODUCT_ID,
 	.ctrl_count = PCAN_USBPROFD_CHANNEL_COUNT,
-	.ctrlmode_supported = CAN_CTRLMODE_FD |
+	.ctrlmode_supported = CAN_CTRLMODE_FD | CAN_CTRLMODE_CC_LEN8_DLC |
 			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
 	.bittiming_const = &pcan_usb_x6_const,
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 8aedb2ba37fb..e15650c0663e 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -469,10 +469,12 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 		if (!skb)
 			return;
 
 		cf->can_id = be32_to_cpu(msg->id);
 		cf->len = can_get_cc_len(msg->dlc & 0xF);
+		cf->len8_dlc = can_get_len8_dlc(priv->can.ctrlmode, cf->len,
+						msg->dlc & 0xF);
 
 		if (msg->flags & USB_8DEV_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
 		if (msg->flags & USB_8DEV_RTR)
@@ -635,11 +637,11 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 
 	if (cf->can_id & CAN_EFF_FLAG)
 		msg->flags |= USB_8DEV_EXTID;
 
 	msg->id = cpu_to_be32(cf->can_id & CAN_ERR_MASK);
-	msg->dlc = cf->len;
+	msg->dlc = can_get_cc_dlc(priv->can.ctrlmode, cf->len, cf->len8_dlc);
 	memcpy(msg->data, cf->data, cf->len);
 	msg->end = USB_8DEV_DATA_END;
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
 		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
@@ -925,12 +927,13 @@ static int usb_8dev_probe(struct usb_interface *intf,
 	priv->can.clock.freq = USB_8DEV_ABP_CLOCK;
 	priv->can.bittiming_const = &usb_8dev_bittiming_const;
 	priv->can.do_set_mode = usb_8dev_set_mode;
 	priv->can.do_get_berr_counter = usb_8dev_get_berr_counter;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
-				      CAN_CTRLMODE_LISTENONLY |
-				      CAN_CTRLMODE_ONE_SHOT;
+				       CAN_CTRLMODE_LISTENONLY |
+				       CAN_CTRLMODE_ONE_SHOT |
+				       CAN_CTRLMODE_CC_LEN8_DLC;
 
 	netdev->netdev_ops = &usb_8dev_netdev_ops;
 
 	netdev->flags |= IFF_ECHO; /* we support local echo */
 
-- 
2.28.0


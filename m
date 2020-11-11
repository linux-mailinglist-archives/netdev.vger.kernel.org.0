Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6A52AEE54
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbgKKJ7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:59:40 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:32781 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgKKJ7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 04:59:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1605088773;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=V/IBoSZRjnSHnq2y9I6hoW6PgNCNZDUCvCwI3HghDlA=;
        b=XU3tSGIv8ckHnPBVsG5qan8A1adj7AhSdWJJK9CaRLOUnxdsJ8msZjlOcSIXopkJfi
        1Ox9ggCTqD2lyo1WovVi/Ym8N6kpCQGavqH38Z3lGfr4WxdayYOaoEPsBjC29VV5yeId
        k3UaNXFuDKVTz3HjtPOTw3jtYOk0yk+fi4KDUYJUjDz1wJeOHDdOGN7TJYXA6l1eFGVJ
        YIJQcsNkQj/J9656TMfOD9kJxsXe9HDQ856tCWyNaJxzSbkqrDayLxBielyXWFokuYcV
        PAcc4w7HAOpeE2KvUtELgPMzLhc88Fy5PlA7Ti00/2wtbjf0CRb6Ps+6xtZvGCwdNk6q
        hYZw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9dyKNLCWJaRrQ0pDCeGtVbNHMQ98lI/DcPKMT"
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 47.3.4 AUTH)
        with ESMTPSA id n07f3bwAB9xU3St
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 11 Nov 2020 10:59:30 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v8] can-dev: add len8_dlc support for various CAN adapters
Date:   Wed, 11 Nov 2020 10:59:23 +0100
Message-Id: <20201111095923.2535-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the Classical CAN raw DLC functionality to send and receive DLC
values from 9 .. 15 on various Classical CAN capable CAN network drivers:

- sja1000
- gs_usb
- pcan_usb
- pcan_usb_fd
- usb_8dev

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201110101852.1973-9-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/sja1000.c          | 10 +++++-----
 drivers/net/can/usb/gs_usb.c               |  7 ++++---
 drivers/net/can/usb/peak_usb/pcan_usb.c    |  8 +++++---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 19 +++++++++++++------
 drivers/net/can/usb/usb_8dev.c             |  9 +++++----
 5 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index d55394aa0b95..e60329972d70 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -282,22 +282,21 @@ static netdev_tx_t sja1000_start_xmit(struct sk_buff *skb,
 					    struct net_device *dev)
 {
 	struct sja1000_priv *priv = netdev_priv(dev);
 	struct can_frame *cf = (struct can_frame *)skb->data;
 	uint8_t fi;
-	uint8_t dlc;
 	canid_t id;
 	uint8_t dreg;
 	u8 cmd_reg_val = 0x00;
 	int i;
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
 
-	fi = dlc = cf->len;
+	fi = can_get_cc_dlc(cf, priv->can.ctrlmode);
 	id = cf->can_id;
 
 	if (id & CAN_RTR_FLAG)
 		fi |= SJA1000_FI_RTR;
 
@@ -314,11 +313,11 @@ static netdev_tx_t sja1000_start_xmit(struct sk_buff *skb,
 		priv->write_reg(priv, SJA1000_FI, fi);
 		priv->write_reg(priv, SJA1000_ID1, (id & 0x000007f8) >> 3);
 		priv->write_reg(priv, SJA1000_ID2, (id & 0x00000007) << 5);
 	}
 
-	for (i = 0; i < dlc; i++)
+	for (i = 0; i < cf->len; i++)
 		priv->write_reg(priv, dreg++, cf->data[i]);
 
 	can_put_echo_skb(skb, dev, 0);
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
@@ -365,11 +364,11 @@ static void sja1000_rx(struct net_device *dev)
 		dreg = SJA1000_SFF_BUF;
 		id = (priv->read_reg(priv, SJA1000_ID1) << 3)
 		    | (priv->read_reg(priv, SJA1000_ID2) >> 5);
 	}
 
-	cf->len = can_cc_dlc2len(fi & 0x0F);
+	can_frame_set_cc_len(cf, fi & 0x0F, priv->can.ctrlmode);
 	if (fi & SJA1000_FI_RTR) {
 		id |= CAN_RTR_FLAG;
 	} else {
 		for (i = 0; i < cf->len; i++)
 			cf->data[i] = priv->read_reg(priv, dreg++);
@@ -636,11 +635,12 @@ struct net_device *alloc_sja1000dev(int sizeof_priv)
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 				       CAN_CTRLMODE_LISTENONLY |
 				       CAN_CTRLMODE_3_SAMPLES |
 				       CAN_CTRLMODE_ONE_SHOT |
 				       CAN_CTRLMODE_BERR_REPORTING |
-				       CAN_CTRLMODE_PRESUME_ACK;
+				       CAN_CTRLMODE_PRESUME_ACK |
+				       CAN_CTRLMODE_CC_LEN8_DLC;
 
 	spin_lock_init(&priv->cmdreg_lock);
 
 	if (sizeof_priv)
 		priv->priv = (void *)priv + sizeof(struct sja1000_priv);
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 940589667a7f..dc0b9f65bbe3 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -329,11 +329,11 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		if (!skb)
 			return;
 
 		cf->can_id = hf->can_id;
 
-		cf->len = can_cc_dlc2len(hf->len);
+		can_frame_set_cc_len(cf, hf->len, dev->can.ctrlmode);
 		memcpy(cf->data, hf->data, 8);
 
 		/* ERROR frames tell us information about the controller */
 		if (hf->can_id & CAN_ERR_FLAG)
 			gs_update_state(dev, cf);
@@ -502,11 +502,12 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	hf->channel = dev->channel;
 
 	cf = (struct can_frame *)skb->data;
 
 	hf->can_id = cf->can_id;
-	hf->len = cf->len;
+	hf->len = can_get_cc_dlc(cf, dev->can.ctrlmode);
+
 	memcpy(hf->data, cf->data, cf->len);
 
 	usb_fill_bulk_urb(urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
 			  hf,
@@ -856,11 +857,11 @@ static struct gs_can *gs_make_candev(unsigned int channel,
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
index ec34f87cc02c..e6c1e5d33924 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -732,11 +732,11 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		mc->ptr += 2;
 
 		cf->can_id = le16_to_cpu(tmp16) >> 5;
 	}
 
-	cf->len = can_cc_dlc2len(rec_len);
+	can_frame_set_cc_len(cf, rec_len, mc->pdev->dev.can.ctrlmode);
 
 	/* Only first packet timestamp is a word */
 	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
 		goto decode_failed;
 
@@ -836,11 +836,12 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 	obuf[1] = 1;
 
 	pc = obuf + PCAN_USB_MSG_HEADER_LEN;
 
 	/* status/len byte */
-	*pc = cf->len;
+	*pc = can_get_cc_dlc(cf, dev->can.ctrlmode);
+
 	if (cf->can_id & CAN_RTR_FLAG)
 		*pc |= PCAN_USB_STATUSLEN_RTR;
 
 	/* can id */
 	if (cf->can_id & CAN_EFF_FLAG) {
@@ -990,11 +991,12 @@ static const struct can_bittiming_const pcan_usb_const = {
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
index 761e78d8e647..b050226adae5 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -497,11 +497,13 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 		/* CAN 2.0 frame case */
 		skb = alloc_can_skb(netdev, (struct can_frame **)&cfd);
 		if (!skb)
 			return -ENOMEM;
 
-		cfd->len = can_cc_dlc2len(pucan_msg_get_dlc(rm));
+		can_frame_set_cc_len((struct can_frame *)cfd,
+				     pucan_msg_get_dlc(rm),
+				     dev->can.ctrlmode);
 	}
 
 	cfd->can_id = le32_to_cpu(rm->can_id);
 
 	if (rx_msg_flags & PUCAN_MSG_EXT_ID)
@@ -765,11 +767,12 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 
 		if (cfd->flags & CANFD_ESI)
 			tx_msg_flags |= PUCAN_MSG_ERROR_STATE_IND;
 	} else {
 		/* CAND 2.0 frames */
-		len = cfd->len;
+		len = can_get_cc_dlc((struct can_frame *)cfd,
+				     dev->can.ctrlmode);
 
 		if (cfd->can_id & CAN_RTR_FLAG)
 			tx_msg_flags |= PUCAN_MSG_RTR;
 	}
 
@@ -1034,11 +1037,12 @@ static const struct can_bittiming_const pcan_usb_fd_data_const = {
 const struct peak_usb_adapter pcan_usb_fd = {
 	.name = "PCAN-USB FD",
 	.device_id = PCAN_USBFD_PRODUCT_ID,
 	.ctrl_count = PCAN_USBFD_CHANNEL_COUNT,
 	.ctrlmode_supported = CAN_CTRLMODE_FD |
-			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
+			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
+			CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
 	.bittiming_const = &pcan_usb_fd_const,
 	.data_bittiming_const = &pcan_usb_fd_data_const,
@@ -1106,11 +1110,12 @@ static const struct can_bittiming_const pcan_usb_chip_data_const = {
 const struct peak_usb_adapter pcan_usb_chip = {
 	.name = "PCAN-Chip USB",
 	.device_id = PCAN_USBCHIP_PRODUCT_ID,
 	.ctrl_count = PCAN_USBFD_CHANNEL_COUNT,
 	.ctrlmode_supported = CAN_CTRLMODE_FD |
-		CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
+		CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
+		CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
 	.bittiming_const = &pcan_usb_chip_const,
 	.data_bittiming_const = &pcan_usb_chip_data_const,
@@ -1178,11 +1183,12 @@ static const struct can_bittiming_const pcan_usb_pro_fd_data_const = {
 const struct peak_usb_adapter pcan_usb_pro_fd = {
 	.name = "PCAN-USB Pro FD",
 	.device_id = PCAN_USBPROFD_PRODUCT_ID,
 	.ctrl_count = PCAN_USBPROFD_CHANNEL_COUNT,
 	.ctrlmode_supported = CAN_CTRLMODE_FD |
-			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
+			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
+			CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
 	.bittiming_const = &pcan_usb_pro_fd_const,
 	.data_bittiming_const = &pcan_usb_pro_fd_data_const,
@@ -1250,11 +1256,12 @@ static const struct can_bittiming_const pcan_usb_x6_data_const = {
 const struct peak_usb_adapter pcan_usb_x6 = {
 	.name = "PCAN-USB X6",
 	.device_id = PCAN_USBX6_PRODUCT_ID,
 	.ctrl_count = PCAN_USBPROFD_CHANNEL_COUNT,
 	.ctrlmode_supported = CAN_CTRLMODE_FD |
-			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
+			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
+			CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_UFD_CRYSTAL_HZ,
 	},
 	.bittiming_const = &pcan_usb_x6_const,
 	.data_bittiming_const = &pcan_usb_x6_data_const,
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 6517aaeb4bc0..3587bfcee13d 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -468,11 +468,11 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 		skb = alloc_can_skb(priv->netdev, &cf);
 		if (!skb)
 			return;
 
 		cf->can_id = be32_to_cpu(msg->id);
-		cf->len = can_cc_dlc2len(msg->dlc & 0xF);
+		can_frame_set_cc_len(cf, msg->dlc & 0xF, priv->can.ctrlmode);
 
 		if (msg->flags & USB_8DEV_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
 		if (msg->flags & USB_8DEV_RTR)
@@ -635,11 +635,11 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 
 	if (cf->can_id & CAN_EFF_FLAG)
 		msg->flags |= USB_8DEV_EXTID;
 
 	msg->id = cpu_to_be32(cf->can_id & CAN_ERR_MASK);
-	msg->dlc = cf->len;
+	msg->dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
 	memcpy(msg->data, cf->data, cf->len);
 	msg->end = USB_8DEV_DATA_END;
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
 		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
@@ -925,12 +925,13 @@ static int usb_8dev_probe(struct usb_interface *intf,
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


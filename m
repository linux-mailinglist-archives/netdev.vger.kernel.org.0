Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B8E4D4A03
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbiCJOc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344020AbiCJObg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C57DEBAE5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJnA-0006KN-FZ
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:24 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 53B8247E1D
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6ACCC47E01;
        Thu, 10 Mar 2022 14:29:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c4db0ec4;
        Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Peter Fink <pfink@christ-es.de>,
        Eric Evenchick <eric@evenchick.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 23/29] can: gs_usb: add CAN-FD support
Date:   Thu, 10 Mar 2022 15:28:57 +0100
Message-Id: <20220310142903.341658-24-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310142903.341658-1-mkl@pengutronix.de>
References: <20220310142903.341658-1-mkl@pengutronix.de>
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

From: Peter Fink <pfink@christ-es.de>

CANtact Pro from Linklayer is the first gs_usb compatible device
supporting CAN-FD with a different HW and re-written candlelight FW.

Support for CAN-FD is indicated by the device setting the
GS_CAN_FEATURE_FD flag. CAN-FD support is requested by the driver with
the GS_CAN_MODE_FD flag. The CAN-FD specific data bit timing
parameters are set with the GS_USB_BREQ_DATA_BITTIMING control
message.

This patch is based on the Eric Evenchick's gs_usb_fd driver (which
itself is a fork of gs_usb). The gs_usb_fd code base was reintegrated
into the gs_usb driver, and reworked to not break the existing
classical-CAN only hardware.

Link: https://lore.kernel.org/all/20220309124132.291861-16-mkl@pengutronix.de
Link: https://github.com/linklayer/gs_usb_fd/issues/2
Co-developed-by: Eric Evenchick <eric@evenchick.com>
Signed-off-by: Eric Evenchick <eric@evenchick.com>
Signed-off-by: Peter Fink <pfink@christ-es.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 124 ++++++++++++++++++++++++++++++-----
 1 file changed, 108 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 1fe9d9f08c17..29389de99326 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -42,6 +42,7 @@ enum gs_usb_breq {
 	GS_USB_BREQ_IDENTIFY,
 	GS_USB_BREQ_GET_USER_ID,
 	GS_USB_BREQ_SET_USER_ID,
+	GS_USB_BREQ_DATA_BITTIMING,
 };
 
 enum gs_can_mode {
@@ -98,6 +99,7 @@ struct gs_device_config {
 /* GS_CAN_FEATURE_IDENTIFY BIT(5) */
 /* GS_CAN_FEATURE_USER_ID BIT(6) */
 #define GS_CAN_MODE_PAD_PKTS_TO_MAX_PKT_SIZE BIT(7)
+#define GS_CAN_MODE_FD BIT(8)
 
 struct gs_device_mode {
 	__le32 mode;
@@ -130,6 +132,7 @@ struct gs_identify_mode {
 #define GS_CAN_FEATURE_IDENTIFY BIT(5)
 #define GS_CAN_FEATURE_USER_ID BIT(6)
 #define GS_CAN_FEATURE_PAD_PKTS_TO_MAX_PKT_SIZE BIT(7)
+#define GS_CAN_FEATURE_FD BIT(8)
 
 struct gs_device_bt_const {
 	__le32 feature;
@@ -145,11 +148,18 @@ struct gs_device_bt_const {
 } __packed;
 
 #define GS_CAN_FLAG_OVERFLOW BIT(0)
+#define GS_CAN_FLAG_FD BIT(1)
+#define GS_CAN_FLAG_BRS BIT(2)
+#define GS_CAN_FLAG_ESI BIT(3)
 
 struct classic_can {
 	u8 data[8];
 } __packed;
 
+struct canfd {
+	u8 data[64];
+} __packed;
+
 struct gs_host_frame {
 	u32 echo_id;
 	__le32 can_id;
@@ -161,6 +171,7 @@ struct gs_host_frame {
 
 	union {
 		DECLARE_FLEX_ARRAY(struct classic_can, classic_can);
+		DECLARE_FLEX_ARRAY(struct canfd, canfd);
 	};
 } __packed;
 /* The GS USB devices make use of the same flags and masks as in
@@ -317,6 +328,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	struct gs_host_frame *hf = urb->transfer_buffer;
 	struct gs_tx_context *txc;
 	struct can_frame *cf;
+	struct canfd_frame *cfd;
 	struct sk_buff *skb;
 
 	BUG_ON(!usbcan);
@@ -345,18 +357,33 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		return;
 
 	if (hf->echo_id == -1) { /* normal rx */
-		skb = alloc_can_skb(dev->netdev, &cf);
-		if (!skb)
-			return;
+		if (hf->flags & GS_CAN_FLAG_FD) {
+			skb = alloc_canfd_skb(dev->netdev, &cfd);
+			if (!skb)
+				return;
+
+			cfd->can_id = le32_to_cpu(hf->can_id);
+			cfd->len = can_fd_dlc2len(hf->can_dlc);
+			if (hf->flags & GS_CAN_FLAG_BRS)
+				cfd->flags |= CANFD_BRS;
+			if (hf->flags & GS_CAN_FLAG_ESI)
+				cfd->flags |= CANFD_ESI;
+
+			memcpy(cfd->data, hf->canfd->data, cfd->len);
+		} else {
+			skb = alloc_can_skb(dev->netdev, &cf);
+			if (!skb)
+				return;
 
-		cf->can_id = le32_to_cpu(hf->can_id);
+			cf->can_id = le32_to_cpu(hf->can_id);
+			can_frame_set_cc_len(cf, hf->can_dlc, dev->can.ctrlmode);
 
-		can_frame_set_cc_len(cf, hf->can_dlc, dev->can.ctrlmode);
-		memcpy(cf->data, hf->classic_can->data, 8);
+			memcpy(cf->data, hf->classic_can->data, 8);
 
-		/* ERROR frames tell us information about the controller */
-		if (le32_to_cpu(hf->can_id) & CAN_ERR_FLAG)
-			gs_update_state(dev, cf);
+			/* ERROR frames tell us information about the controller */
+			if (le32_to_cpu(hf->can_id) & CAN_ERR_FLAG)
+				gs_update_state(dev, cf);
+		}
 
 		netdev->stats.rx_packets++;
 		netdev->stats.rx_bytes += hf->can_dlc;
@@ -456,6 +483,40 @@ static int gs_usb_set_bittiming(struct net_device *netdev)
 	return (rc > 0) ? 0 : rc;
 }
 
+static int gs_usb_set_data_bittiming(struct net_device *netdev)
+{
+	struct gs_can *dev = netdev_priv(netdev);
+	struct can_bittiming *bt = &dev->can.data_bittiming;
+	struct usb_interface *intf = dev->iface;
+	struct gs_device_bittiming *dbt;
+	int rc;
+
+	dbt = kmalloc(sizeof(*dbt), GFP_KERNEL);
+	if (!dbt)
+		return -ENOMEM;
+
+	dbt->prop_seg = cpu_to_le32(bt->prop_seg);
+	dbt->phase_seg1 = cpu_to_le32(bt->phase_seg1);
+	dbt->phase_seg2 = cpu_to_le32(bt->phase_seg2);
+	dbt->sjw = cpu_to_le32(bt->sjw);
+	dbt->brp = cpu_to_le32(bt->brp);
+
+	/* request bit timings */
+	rc = usb_control_msg(interface_to_usbdev(intf),
+			     usb_sndctrlpipe(interface_to_usbdev(intf), 0),
+			     GS_USB_BREQ_DATA_BITTIMING,
+			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+			     dev->channel, 0, dbt, sizeof(*dbt), 1000);
+
+	kfree(dbt);
+
+	if (rc < 0)
+		dev_err(netdev->dev.parent,
+			"Couldn't set data bittimings (err=%d)", rc);
+
+	return (rc > 0) ? 0 : rc;
+}
+
 static void gs_usb_xmit_callback(struct urb *urb)
 {
 	struct gs_tx_context *txc = urb->context;
@@ -477,6 +538,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	struct urb *urb;
 	struct gs_host_frame *hf;
 	struct can_frame *cf;
+	struct canfd_frame *cfd;
 	int rc;
 	unsigned int idx;
 	struct gs_tx_context *txc;
@@ -513,12 +575,26 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	hf->flags = 0;
 	hf->reserved = 0;
 
-	cf = (struct can_frame *)skb->data;
+	if (can_is_canfd_skb(skb)) {
+		cfd = (struct canfd_frame *)skb->data;
+
+		hf->can_id = cpu_to_le32(cfd->can_id);
+		hf->can_dlc = can_fd_len2dlc(cfd->len);
+		hf->flags |= GS_CAN_FLAG_FD;
+		if (cfd->flags & CANFD_BRS)
+			hf->flags |= GS_CAN_FLAG_BRS;
+		if (cfd->flags & CANFD_ESI)
+			hf->flags |= GS_CAN_FLAG_ESI;
 
-	hf->can_id = cpu_to_le32(cf->can_id);
-	hf->can_dlc = can_get_cc_dlc(cf, dev->can.ctrlmode);
+		memcpy(hf->canfd->data, cfd->data, cfd->len);
+	} else {
+		cf = (struct can_frame *)skb->data;
 
-	memcpy(hf->classic_can->data, cf->data, cf->len);
+		hf->can_id = cpu_to_le32(cf->can_id);
+		hf->can_dlc = can_get_cc_dlc(cf, dev->can.ctrlmode);
+
+		memcpy(hf->classic_can->data, cf->data, cf->len);
+	}
 
 	usb_fill_bulk_urb(urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
@@ -587,7 +663,13 @@ static int gs_can_open(struct net_device *netdev)
 	if (rc)
 		return rc;
 
-	dev->hf_size_tx = struct_size(hf, classic_can, 1);
+	ctrlmode = dev->can.ctrlmode;
+	if (ctrlmode & CAN_CTRLMODE_FD) {
+		flags |= GS_CAN_MODE_FD;
+		dev->hf_size_tx = struct_size(hf, canfd, 1);
+	} else {
+		dev->hf_size_tx = struct_size(hf, classic_can, 1);
+	}
 
 	if (!parent->active_channels) {
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
@@ -648,8 +730,6 @@ static int gs_can_open(struct net_device *netdev)
 		return -ENOMEM;
 
 	/* flags */
-	ctrlmode = dev->can.ctrlmode;
-
 	if (ctrlmode & CAN_CTRLMODE_LOOPBACK)
 		flags |= GS_CAN_MODE_LOOP_BACK;
 	else if (ctrlmode & CAN_CTRLMODE_LISTENONLY)
@@ -870,6 +950,12 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	if (feature & GS_CAN_FEATURE_ONE_SHOT)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_ONE_SHOT;
 
+	if (feature & GS_CAN_FEATURE_FD) {
+		dev->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+		dev->can.data_bittiming_const = &dev->bt_const;
+		dev->can.do_set_data_bittiming = gs_usb_set_data_bittiming;
+	}
+
 	if (le32_to_cpu(dconf->sw_version) > 1)
 		if (feature & GS_CAN_FEATURE_IDENTIFY)
 			netdev->ethtool_ops = &gs_usb_ethtool_ops;
@@ -961,6 +1047,9 @@ static int gs_usb_probe(struct usb_interface *intf,
 	}
 
 	init_usb_anchor(&dev->rx_submitted);
+	/* default to classic CAN, switch to CAN-FD if at least one of
+	 * our channels support CAN-FD.
+	 */
 	dev->hf_size_rx = struct_size(hf, classic_can, 1);
 
 	usb_set_intfdata(intf, dev);
@@ -983,6 +1072,9 @@ static int gs_usb_probe(struct usb_interface *intf,
 			return rc;
 		}
 		dev->canch[i]->parent = dev;
+
+		if (dev->canch[i]->can.ctrlmode_supported & CAN_CTRLMODE_FD)
+			dev->hf_size_rx = struct_size(hf, canfd, 1);
 	}
 
 	kfree(dconf);
-- 
2.35.1



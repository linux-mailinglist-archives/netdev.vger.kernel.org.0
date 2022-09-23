Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A105E7A65
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiIWMSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbiIWMQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:16:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B8113C879
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:09:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1obhUT-0007Jy-MQ
        for netdev@vger.kernel.org; Fri, 23 Sep 2022 14:09:09 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D20DAEB14D
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 12:09:06 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2D022EB12E;
        Fri, 23 Sep 2022 12:09:05 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 506ced78;
        Fri, 23 Sep 2022 12:09:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 07/11] can: gs_usb: convert from usb_control_msg() to usb_control_msg_{send,recv}()
Date:   Fri, 23 Sep 2022 14:08:55 +0200
Message-Id: <20220923120859.740577-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220923120859.740577-1-mkl@pengutronix.de>
References: <20220923120859.740577-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the driver to use usb_control_msg_{send,recv}() instead of
usb_control_msg(). These functions allow the data to be placed on the
stack. This makes the driver a lot easier as we don't have to deal
with dynamically allocated memory.

Link: https://lore.kernel.org/all/20220921193902.575416-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 301 +++++++++++++----------------------
 1 file changed, 107 insertions(+), 194 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 629ab664ca3f..28a645409df9 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -360,25 +360,15 @@ static struct gs_tx_context *gs_get_tx_context(struct gs_can *dev,
 
 static int gs_cmd_reset(struct gs_can *dev)
 {
-	struct gs_device_mode *dm;
-	struct usb_interface *intf = dev->iface;
-	int rc;
-
-	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
-	if (!dm)
-		return -ENOMEM;
-
-	dm->mode = GS_CAN_MODE_RESET;
-
-	rc = usb_control_msg(interface_to_usbdev(intf),
-			     usb_sndctrlpipe(interface_to_usbdev(intf), 0),
-			     GS_USB_BREQ_MODE,
-			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     dev->channel, 0, dm, sizeof(*dm), 1000);
-
-	kfree(dm);
+	struct gs_device_mode dm = {
+		.mode = GS_CAN_MODE_RESET,
+	};
 
-	return rc;
+	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
+				    GS_USB_BREQ_MODE,
+				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				    dev->channel, 0, &dm, sizeof(dm), 1000,
+				    GFP_KERNEL);
 }
 
 static inline int gs_usb_get_timestamp(const struct gs_can *dev,
@@ -656,72 +646,44 @@ static int gs_usb_set_bittiming(struct net_device *netdev)
 {
 	struct gs_can *dev = netdev_priv(netdev);
 	struct can_bittiming *bt = &dev->can.bittiming;
-	struct usb_interface *intf = dev->iface;
-	int rc;
-	struct gs_device_bittiming *dbt;
-
-	dbt = kmalloc(sizeof(*dbt), GFP_KERNEL);
-	if (!dbt)
-		return -ENOMEM;
-
-	dbt->prop_seg = cpu_to_le32(bt->prop_seg);
-	dbt->phase_seg1 = cpu_to_le32(bt->phase_seg1);
-	dbt->phase_seg2 = cpu_to_le32(bt->phase_seg2);
-	dbt->sjw = cpu_to_le32(bt->sjw);
-	dbt->brp = cpu_to_le32(bt->brp);
+	struct gs_device_bittiming dbt = {
+		.prop_seg = cpu_to_le32(bt->prop_seg),
+		.phase_seg1 = cpu_to_le32(bt->phase_seg1),
+		.phase_seg2 = cpu_to_le32(bt->phase_seg2),
+		.sjw = cpu_to_le32(bt->sjw),
+		.brp = cpu_to_le32(bt->brp),
+	};
 
 	/* request bit timings */
-	rc = usb_control_msg(interface_to_usbdev(intf),
-			     usb_sndctrlpipe(interface_to_usbdev(intf), 0),
-			     GS_USB_BREQ_BITTIMING,
-			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     dev->channel, 0, dbt, sizeof(*dbt), 1000);
-
-	kfree(dbt);
-
-	if (rc < 0)
-		dev_err(netdev->dev.parent, "Couldn't set bittimings (err=%d)",
-			rc);
-
-	return (rc > 0) ? 0 : rc;
+	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
+				    GS_USB_BREQ_BITTIMING,
+				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				    dev->channel, 0, &dbt, sizeof(dbt), 1000,
+				    GFP_KERNEL);
 }
 
 static int gs_usb_set_data_bittiming(struct net_device *netdev)
 {
 	struct gs_can *dev = netdev_priv(netdev);
 	struct can_bittiming *bt = &dev->can.data_bittiming;
-	struct usb_interface *intf = dev->iface;
-	struct gs_device_bittiming *dbt;
+	struct gs_device_bittiming dbt = {
+		.prop_seg = cpu_to_le32(bt->prop_seg),
+		.phase_seg1 = cpu_to_le32(bt->phase_seg1),
+		.phase_seg2 = cpu_to_le32(bt->phase_seg2),
+		.sjw = cpu_to_le32(bt->sjw),
+		.brp = cpu_to_le32(bt->brp),
+	};
 	u8 request = GS_USB_BREQ_DATA_BITTIMING;
-	int rc;
-
-	dbt = kmalloc(sizeof(*dbt), GFP_KERNEL);
-	if (!dbt)
-		return -ENOMEM;
-
-	dbt->prop_seg = cpu_to_le32(bt->prop_seg);
-	dbt->phase_seg1 = cpu_to_le32(bt->phase_seg1);
-	dbt->phase_seg2 = cpu_to_le32(bt->phase_seg2);
-	dbt->sjw = cpu_to_le32(bt->sjw);
-	dbt->brp = cpu_to_le32(bt->brp);
 
 	if (dev->feature & GS_CAN_FEATURE_QUIRK_BREQ_CANTACT_PRO)
 		request = GS_USB_BREQ_QUIRK_CANTACT_PRO_DATA_BITTIMING;
 
-	/* request bit timings */
-	rc = usb_control_msg(interface_to_usbdev(intf),
-			     usb_sndctrlpipe(interface_to_usbdev(intf), 0),
-			     request,
-			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     dev->channel, 0, dbt, sizeof(*dbt), 1000);
-
-	kfree(dbt);
-
-	if (rc < 0)
-		dev_err(netdev->dev.parent,
-			"Couldn't set data bittimings (err=%d)", rc);
-
-	return (rc > 0) ? 0 : rc;
+	/* request data bit timings */
+	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
+				    request,
+				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				    dev->channel, 0, &dbt, sizeof(dbt), 1000,
+				    GFP_KERNEL);
 }
 
 static void gs_usb_xmit_callback(struct urb *urb)
@@ -860,11 +822,13 @@ static int gs_can_open(struct net_device *netdev)
 {
 	struct gs_can *dev = netdev_priv(netdev);
 	struct gs_usb *parent = dev->parent;
-	int rc, i;
-	struct gs_device_mode *dm;
+	struct gs_device_mode dm = {
+		.mode = cpu_to_le32(GS_CAN_MODE_START),
+	};
 	struct gs_host_frame *hf;
 	u32 ctrlmode;
 	u32 flags = 0;
+	int rc, i;
 
 	rc = open_candev(netdev);
 	if (rc)
@@ -949,10 +913,6 @@ static int gs_can_open(struct net_device *netdev)
 		}
 	}
 
-	dm = kmalloc(sizeof(*dm), GFP_KERNEL);
-	if (!dm)
-		return -ENOMEM;
-
 	/* flags */
 	if (ctrlmode & CAN_CTRLMODE_LOOPBACK)
 		flags |= GS_CAN_MODE_LOOP_BACK;
@@ -978,25 +938,20 @@ static int gs_can_open(struct net_device *netdev)
 
 	/* finally start device */
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
-	dm->mode = cpu_to_le32(GS_CAN_MODE_START);
-	dm->flags = cpu_to_le32(flags);
-	rc = usb_control_msg(interface_to_usbdev(dev->iface),
-			     usb_sndctrlpipe(interface_to_usbdev(dev->iface), 0),
-			     GS_USB_BREQ_MODE,
-			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     dev->channel, 0, dm, sizeof(*dm), 1000);
-
-	if (rc < 0) {
+	dm.flags = cpu_to_le32(flags);
+	rc = usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
+				  GS_USB_BREQ_MODE,
+				  USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				  dev->channel, 0, &dm, sizeof(dm), 1000,
+				  GFP_KERNEL);
+	if (rc) {
 		netdev_err(netdev, "Couldn't start device (err=%d)\n", rc);
-		kfree(dm);
 		if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 			gs_usb_timestamp_stop(dev);
 		dev->can.state = CAN_STATE_STOPPED;
 		return rc;
 	}
 
-	kfree(dm);
-
 	parent->active_channels++;
 	if (!(dev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY))
 		netif_start_queue(netdev);
@@ -1070,28 +1025,18 @@ static const struct net_device_ops gs_usb_netdev_ops = {
 static int gs_usb_set_identify(struct net_device *netdev, bool do_identify)
 {
 	struct gs_can *dev = netdev_priv(netdev);
-	struct gs_identify_mode *imode;
-	int rc;
-
-	imode = kmalloc(sizeof(*imode), GFP_KERNEL);
-
-	if (!imode)
-		return -ENOMEM;
+	struct gs_identify_mode imode;
 
 	if (do_identify)
-		imode->mode = cpu_to_le32(GS_CAN_IDENTIFY_ON);
+		imode.mode = cpu_to_le32(GS_CAN_IDENTIFY_ON);
 	else
-		imode->mode = cpu_to_le32(GS_CAN_IDENTIFY_OFF);
-
-	rc = usb_control_msg(interface_to_usbdev(dev->iface),
-			     usb_sndctrlpipe(interface_to_usbdev(dev->iface), 0),
-			     GS_USB_BREQ_IDENTIFY,
-			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     dev->channel, 0, imode, sizeof(*imode), 100);
-
-	kfree(imode);
+		imode.mode = cpu_to_le32(GS_CAN_IDENTIFY_OFF);
 
-	return (rc > 0) ? 0 : rc;
+	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
+				    GS_USB_BREQ_IDENTIFY,
+				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				    dev->channel, 0, &imode, sizeof(imode), 100,
+				    GFP_KERNEL);
 }
 
 /* blink LED's for finding the this interface */
@@ -1142,26 +1087,21 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	struct gs_can *dev;
 	struct net_device *netdev;
 	int rc;
-	struct gs_device_bt_const *bt_const;
-	struct gs_device_bt_const_extended *bt_const_extended;
+	struct gs_device_bt_const_extended bt_const_extended;
+	struct gs_device_bt_const bt_const;
 	u32 feature;
 
-	bt_const = kmalloc(sizeof(*bt_const), GFP_KERNEL);
-	if (!bt_const)
-		return ERR_PTR(-ENOMEM);
-
 	/* fetch bit timing constants */
-	rc = usb_control_msg(interface_to_usbdev(intf),
-			     usb_rcvctrlpipe(interface_to_usbdev(intf), 0),
-			     GS_USB_BREQ_BT_CONST,
-			     USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     channel, 0, bt_const, sizeof(*bt_const), 1000);
+	rc = usb_control_msg_recv(interface_to_usbdev(intf), 0,
+				  GS_USB_BREQ_BT_CONST,
+				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				  channel, 0, &bt_const, sizeof(bt_const), 1000,
+				  GFP_KERNEL);
 
-	if (rc < 0) {
+	if (rc) {
 		dev_err(&intf->dev,
 			"Couldn't get bit timing const for channel (err=%d)\n",
 			rc);
-		kfree(bt_const);
 		return ERR_PTR(rc);
 	}
 
@@ -1169,7 +1109,6 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	netdev = alloc_candev(sizeof(struct gs_can), GS_MAX_TX_URBS);
 	if (!netdev) {
 		dev_err(&intf->dev, "Couldn't allocate candev\n");
-		kfree(bt_const);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1182,14 +1121,14 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	/* dev setup */
 	strcpy(dev->bt_const.name, KBUILD_MODNAME);
-	dev->bt_const.tseg1_min = le32_to_cpu(bt_const->tseg1_min);
-	dev->bt_const.tseg1_max = le32_to_cpu(bt_const->tseg1_max);
-	dev->bt_const.tseg2_min = le32_to_cpu(bt_const->tseg2_min);
-	dev->bt_const.tseg2_max = le32_to_cpu(bt_const->tseg2_max);
-	dev->bt_const.sjw_max = le32_to_cpu(bt_const->sjw_max);
-	dev->bt_const.brp_min = le32_to_cpu(bt_const->brp_min);
-	dev->bt_const.brp_max = le32_to_cpu(bt_const->brp_max);
-	dev->bt_const.brp_inc = le32_to_cpu(bt_const->brp_inc);
+	dev->bt_const.tseg1_min = le32_to_cpu(bt_const.tseg1_min);
+	dev->bt_const.tseg1_max = le32_to_cpu(bt_const.tseg1_max);
+	dev->bt_const.tseg2_min = le32_to_cpu(bt_const.tseg2_min);
+	dev->bt_const.tseg2_max = le32_to_cpu(bt_const.tseg2_max);
+	dev->bt_const.sjw_max = le32_to_cpu(bt_const.sjw_max);
+	dev->bt_const.brp_min = le32_to_cpu(bt_const.brp_min);
+	dev->bt_const.brp_max = le32_to_cpu(bt_const.brp_max);
+	dev->bt_const.brp_inc = le32_to_cpu(bt_const.brp_inc);
 
 	dev->udev = interface_to_usbdev(intf);
 	dev->iface = intf;
@@ -1206,13 +1145,13 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	/* can setup */
 	dev->can.state = CAN_STATE_STOPPED;
-	dev->can.clock.freq = le32_to_cpu(bt_const->fclk_can);
+	dev->can.clock.freq = le32_to_cpu(bt_const.fclk_can);
 	dev->can.bittiming_const = &dev->bt_const;
 	dev->can.do_set_bittiming = gs_usb_set_bittiming;
 
 	dev->can.ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC;
 
-	feature = le32_to_cpu(bt_const->feature);
+	feature = le32_to_cpu(bt_const.feature);
 	dev->feature = FIELD_GET(GS_CAN_FEATURE_MASK, feature);
 	if (feature & GS_CAN_FEATURE_LISTEN_ONLY)
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_LISTENONLY;
@@ -1263,45 +1202,35 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	      feature & GS_CAN_FEATURE_IDENTIFY))
 		dev->feature &= ~GS_CAN_FEATURE_IDENTIFY;
 
-	kfree(bt_const);
-
 	/* fetch extended bit timing constants if device has feature
 	 * GS_CAN_FEATURE_FD and GS_CAN_FEATURE_BT_CONST_EXT
 	 */
 	if (feature & GS_CAN_FEATURE_FD &&
 	    feature & GS_CAN_FEATURE_BT_CONST_EXT) {
-		bt_const_extended = kmalloc(sizeof(*bt_const_extended), GFP_KERNEL);
-		if (!bt_const_extended)
-			return ERR_PTR(-ENOMEM);
-
-		rc = usb_control_msg(interface_to_usbdev(intf),
-				     usb_rcvctrlpipe(interface_to_usbdev(intf), 0),
-				     GS_USB_BREQ_BT_CONST_EXT,
-				     USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-				     channel, 0, bt_const_extended,
-				     sizeof(*bt_const_extended),
-				     1000);
-		if (rc < 0) {
+		rc = usb_control_msg_recv(interface_to_usbdev(intf), 0,
+					  GS_USB_BREQ_BT_CONST_EXT,
+					  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+					  channel, 0, &bt_const_extended,
+					  sizeof(bt_const_extended),
+					  1000, GFP_KERNEL);
+		if (rc) {
 			dev_err(&intf->dev,
 				"Couldn't get extended bit timing const for channel (err=%d)\n",
 				rc);
-			kfree(bt_const_extended);
 			return ERR_PTR(rc);
 		}
 
 		strcpy(dev->data_bt_const.name, KBUILD_MODNAME);
-		dev->data_bt_const.tseg1_min = le32_to_cpu(bt_const_extended->dtseg1_min);
-		dev->data_bt_const.tseg1_max = le32_to_cpu(bt_const_extended->dtseg1_max);
-		dev->data_bt_const.tseg2_min = le32_to_cpu(bt_const_extended->dtseg2_min);
-		dev->data_bt_const.tseg2_max = le32_to_cpu(bt_const_extended->dtseg2_max);
-		dev->data_bt_const.sjw_max = le32_to_cpu(bt_const_extended->dsjw_max);
-		dev->data_bt_const.brp_min = le32_to_cpu(bt_const_extended->dbrp_min);
-		dev->data_bt_const.brp_max = le32_to_cpu(bt_const_extended->dbrp_max);
-		dev->data_bt_const.brp_inc = le32_to_cpu(bt_const_extended->dbrp_inc);
+		dev->data_bt_const.tseg1_min = le32_to_cpu(bt_const_extended.dtseg1_min);
+		dev->data_bt_const.tseg1_max = le32_to_cpu(bt_const_extended.dtseg1_max);
+		dev->data_bt_const.tseg2_min = le32_to_cpu(bt_const_extended.dtseg2_min);
+		dev->data_bt_const.tseg2_max = le32_to_cpu(bt_const_extended.dtseg2_max);
+		dev->data_bt_const.sjw_max = le32_to_cpu(bt_const_extended.dsjw_max);
+		dev->data_bt_const.brp_min = le32_to_cpu(bt_const_extended.dbrp_min);
+		dev->data_bt_const.brp_max = le32_to_cpu(bt_const_extended.dbrp_max);
+		dev->data_bt_const.brp_inc = le32_to_cpu(bt_const_extended.dbrp_inc);
 
 		dev->can.data_bittiming_const = &dev->data_bt_const;
-
-		kfree(bt_const_extended);
 	}
 
 	SET_NETDEV_DEV(netdev, &intf->dev);
@@ -1329,64 +1258,51 @@ static int gs_usb_probe(struct usb_interface *intf,
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct gs_host_frame *hf;
 	struct gs_usb *dev;
-	int rc = -ENOMEM;
+	struct gs_host_config hconf = {
+		.byte_order = cpu_to_le32(0x0000beef),
+	};
+	struct gs_device_config dconf;
 	unsigned int icount, i;
-	struct gs_host_config *hconf;
-	struct gs_device_config *dconf;
-
-	hconf = kmalloc(sizeof(*hconf), GFP_KERNEL);
-	if (!hconf)
-		return -ENOMEM;
-
-	hconf->byte_order = cpu_to_le32(0x0000beef);
+	int rc;
 
 	/* send host config */
-	rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
-			     GS_USB_BREQ_HOST_FORMAT,
-			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     1, intf->cur_altsetting->desc.bInterfaceNumber,
-			     hconf, sizeof(*hconf), 1000);
-
-	kfree(hconf);
-
-	if (rc < 0) {
+	rc = usb_control_msg_send(udev, 0,
+				  GS_USB_BREQ_HOST_FORMAT,
+				  USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				  1, intf->cur_altsetting->desc.bInterfaceNumber,
+				  &hconf, sizeof(hconf), 1000,
+				  GFP_KERNEL);
+	if (rc) {
 		dev_err(&intf->dev, "Couldn't send data format (err=%d)\n", rc);
 		return rc;
 	}
 
-	dconf = kmalloc(sizeof(*dconf), GFP_KERNEL);
-	if (!dconf)
-		return -ENOMEM;
-
 	/* read device config */
-	rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-			     GS_USB_BREQ_DEVICE_CONFIG,
-			     USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     1, intf->cur_altsetting->desc.bInterfaceNumber,
-			     dconf, sizeof(*dconf), 1000);
-	if (rc < 0) {
+	rc = usb_control_msg_recv(udev, 0,
+				  GS_USB_BREQ_DEVICE_CONFIG,
+				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				  1, intf->cur_altsetting->desc.bInterfaceNumber,
+				  &dconf, sizeof(dconf), 1000,
+				  GFP_KERNEL);
+	if (rc) {
 		dev_err(&intf->dev, "Couldn't get device config: (err=%d)\n",
 			rc);
-		kfree(dconf);
 		return rc;
 	}
 
-	icount = dconf->icount + 1;
+	icount = dconf.icount + 1;
 	dev_info(&intf->dev, "Configuring for %u interfaces\n", icount);
 
 	if (icount > GS_MAX_INTF) {
 		dev_err(&intf->dev,
 			"Driver cannot handle more that %u CAN interfaces\n",
 			GS_MAX_INTF);
-		kfree(dconf);
 		return -EINVAL;
 	}
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		kfree(dconf);
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	init_usb_anchor(&dev->rx_submitted);
 
@@ -1396,7 +1312,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 	for (i = 0; i < icount; i++) {
 		unsigned int hf_size_rx = 0;
 
-		dev->canch[i] = gs_make_candev(i, intf, dconf);
+		dev->canch[i] = gs_make_candev(i, intf, &dconf);
 		if (IS_ERR_OR_NULL(dev->canch[i])) {
 			/* save error code to return later */
 			rc = PTR_ERR(dev->canch[i]);
@@ -1407,7 +1323,6 @@ static int gs_usb_probe(struct usb_interface *intf,
 				gs_destroy_candev(dev->canch[i]);
 
 			usb_kill_anchored_urbs(&dev->rx_submitted);
-			kfree(dconf);
 			kfree(dev);
 			return rc;
 		}
@@ -1430,8 +1345,6 @@ static int gs_usb_probe(struct usb_interface *intf,
 		dev->hf_size_rx = max(dev->hf_size_rx, hf_size_rx);
 	}
 
-	kfree(dconf);
-
 	return 0;
 }
 
-- 
2.35.1



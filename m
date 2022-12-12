Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1D7649DE1
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiLLLcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiLLLbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF0560FF
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:08 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1W-0000bx-Tt
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:06 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5EF4613CC43
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C8DB513CBDB;
        Mon, 12 Dec 2022 11:30:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 069c0a86;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 25/39] can: gs_usb: remove gs_can::iface
Date:   Mon, 12 Dec 2022 12:30:31 +0100
Message-Id: <20221212113045.222493-26-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The iface field of struct gs_can is only used to retrieve the
usb_device which is already available in gs_can::udev.

Replace each occurrence of interface_to_usbdev(dev->iface) with
dev->udev. This done, remove gs_can::iface.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221208081142.16936-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 838744d2ce34..d476c2884008 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -299,7 +299,6 @@ struct gs_can {
 
 	struct net_device *netdev;
 	struct usb_device *udev;
-	struct usb_interface *iface;
 
 	struct can_bittiming_const bt_const, data_bt_const;
 	unsigned int channel;	/* channel number */
@@ -383,8 +382,7 @@ static int gs_cmd_reset(struct gs_can *dev)
 		.mode = GS_CAN_MODE_RESET,
 	};
 
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    GS_USB_BREQ_MODE,
+	return usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_MODE,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0, &dm, sizeof(dm), 1000,
 				    GFP_KERNEL);
@@ -396,8 +394,7 @@ static inline int gs_usb_get_timestamp(const struct gs_can *dev,
 	__le32 timestamp;
 	int rc;
 
-	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface), 0,
-				  GS_USB_BREQ_TIMESTAMP,
+	rc = usb_control_msg_recv(dev->udev, 0, GS_USB_BREQ_TIMESTAMP,
 				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				  dev->channel, 0,
 				  &timestamp, sizeof(timestamp),
@@ -674,8 +671,7 @@ static int gs_usb_set_bittiming(struct net_device *netdev)
 	};
 
 	/* request bit timings */
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    GS_USB_BREQ_BITTIMING,
+	return usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_BITTIMING,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0, &dbt, sizeof(dbt), 1000,
 				    GFP_KERNEL);
@@ -698,8 +694,7 @@ static int gs_usb_set_data_bittiming(struct net_device *netdev)
 		request = GS_USB_BREQ_QUIRK_CANTACT_PRO_DATA_BITTIMING;
 
 	/* request data bit timings */
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    request,
+	return usb_control_msg_send(dev->udev, 0, request,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0, &dbt, sizeof(dbt), 1000,
 				    GFP_KERNEL);
@@ -941,8 +936,7 @@ static int gs_can_open(struct net_device *netdev)
 	/* finally start device */
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 	dm.flags = cpu_to_le32(flags);
-	rc = usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				  GS_USB_BREQ_MODE,
+	rc = usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_MODE,
 				  USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				  dev->channel, 0, &dm, sizeof(dm), 1000,
 				  GFP_KERNEL);
@@ -969,8 +963,7 @@ static int gs_usb_get_state(const struct net_device *netdev,
 	struct gs_device_state ds;
 	int rc;
 
-	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface), 0,
-				  GS_USB_BREQ_GET_STATE,
+	rc = usb_control_msg_recv(dev->udev, 0, GS_USB_BREQ_GET_STATE,
 				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				  dev->channel, 0,
 				  &ds, sizeof(ds),
@@ -1064,8 +1057,7 @@ static int gs_usb_set_identify(struct net_device *netdev, bool do_identify)
 	else
 		imode.mode = cpu_to_le32(GS_CAN_IDENTIFY_OFF);
 
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    GS_USB_BREQ_IDENTIFY,
+	return usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_IDENTIFY,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0, &imode, sizeof(imode), 100,
 				    GFP_KERNEL);
@@ -1118,8 +1110,7 @@ static int gs_usb_get_termination(struct net_device *netdev, u16 *term)
 	struct gs_device_termination_state term_state;
 	int rc;
 
-	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface), 0,
-				  GS_USB_BREQ_GET_TERMINATION,
+	rc = usb_control_msg_recv(dev->udev, 0, GS_USB_BREQ_GET_TERMINATION,
 				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				  dev->channel, 0,
 				  &term_state, sizeof(term_state), 1000,
@@ -1145,8 +1136,7 @@ static int gs_usb_set_termination(struct net_device *netdev, u16 term)
 	else
 		term_state.state = cpu_to_le32(GS_CAN_TERMINATION_STATE_OFF);
 
-	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
-				    GS_USB_BREQ_SET_TERMINATION,
+	return usb_control_msg_send(dev->udev, 0, GS_USB_BREQ_SET_TERMINATION,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 				    dev->channel, 0,
 				    &term_state, sizeof(term_state), 1000,
@@ -1210,7 +1200,6 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	dev->bt_const.brp_inc = le32_to_cpu(bt_const.brp_inc);
 
 	dev->udev = interface_to_usbdev(intf);
-	dev->iface = intf;
 	dev->netdev = netdev;
 	dev->channel = channel;
 
-- 
2.35.1



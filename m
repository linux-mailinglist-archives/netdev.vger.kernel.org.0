Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359D14D4B95
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244178AbiCJOdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344036AbiCJObi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08FCBF943
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:28 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJnD-0006Ny-7X
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:27 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 56B4947E45
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:14 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6682A47E22;
        Thu, 10 Mar 2022 14:29:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d2041011;
        Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Peter Fink <pfink@christ-es.de>,
        =?UTF-8?q?Christoph=20M=C3=B6hring?= <cmoehring@christ-es.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 27/29] can: gs_usb: add extended bt_const feature
Date:   Thu, 10 Mar 2022 15:29:01 +0100
Message-Id: <20220310142903.341658-28-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310142903.341658-1-mkl@pengutronix.de>
References: <20220310142903.341658-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

For example CANext FD needs to distinguish between bittiming constants
valid for arbitration phase and data phase to reach maximum
performance at higher speeds.

Link: https://lore.kernel.org/all/20220309124132.291861-20-mkl@pengutronix.de
Signed-off-by: Peter Fink <pfink@christ-es.de>
Signed-off-by: Christoph Möhring <cmoehring@christ-es.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 70 ++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 915c5dd8199b..8bc219823ccf 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -45,6 +45,7 @@ enum gs_usb_breq {
 	GS_USB_BREQ_QUIRK_CANTACT_PRO_DATA_BITTIMING = GS_USB_BREQ_GET_USER_ID,
 	GS_USB_BREQ_SET_USER_ID,
 	GS_USB_BREQ_DATA_BITTIMING,
+	GS_USB_BREQ_BT_CONST_EXT,
 };
 
 enum gs_can_mode {
@@ -103,6 +104,7 @@ struct gs_device_config {
 #define GS_CAN_MODE_PAD_PKTS_TO_MAX_PKT_SIZE BIT(7)
 #define GS_CAN_MODE_FD BIT(8)
 /* GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX BIT(9) */
+/* GS_CAN_FEATURE_BT_CONST_EXT BIT(10) */
 
 struct gs_device_mode {
 	__le32 mode;
@@ -137,7 +139,8 @@ struct gs_identify_mode {
 #define GS_CAN_FEATURE_PAD_PKTS_TO_MAX_PKT_SIZE BIT(7)
 #define GS_CAN_FEATURE_FD BIT(8)
 #define GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX BIT(9)
-#define GS_CAN_FEATURE_MASK GENMASK(9, 0)
+#define GS_CAN_FEATURE_BT_CONST_EXT BIT(10)
+#define GS_CAN_FEATURE_MASK GENMASK(10, 0)
 
 /* internal quirks - keep in GS_CAN_FEATURE space for now */
 
@@ -159,6 +162,28 @@ struct gs_device_bt_const {
 	__le32 brp_inc;
 } __packed;
 
+struct gs_device_bt_const_extended {
+	__le32 feature;
+	__le32 fclk_can;
+	__le32 tseg1_min;
+	__le32 tseg1_max;
+	__le32 tseg2_min;
+	__le32 tseg2_max;
+	__le32 sjw_max;
+	__le32 brp_min;
+	__le32 brp_max;
+	__le32 brp_inc;
+
+	__le32 dtseg1_min;
+	__le32 dtseg1_max;
+	__le32 dtseg2_min;
+	__le32 dtseg2_max;
+	__le32 dsjw_max;
+	__le32 dbrp_min;
+	__le32 dbrp_max;
+	__le32 dbrp_inc;
+} __packed;
+
 #define GS_CAN_FLAG_OVERFLOW BIT(0)
 #define GS_CAN_FLAG_FD BIT(1)
 #define GS_CAN_FLAG_BRS BIT(2)
@@ -225,7 +250,7 @@ struct gs_can {
 	struct usb_device *udev;
 	struct usb_interface *iface;
 
-	struct can_bittiming_const bt_const;
+	struct can_bittiming_const bt_const, data_bt_const;
 	unsigned int channel;	/* channel number */
 
 	u32 feature;
@@ -906,6 +931,7 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	struct net_device *netdev;
 	int rc;
 	struct gs_device_bt_const *bt_const;
+	struct gs_device_bt_const_extended *bt_const_extended;
 	u32 feature;
 
 	bt_const = kmalloc(sizeof(*bt_const), GFP_KERNEL);
@@ -989,6 +1015,9 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	if (feature & GS_CAN_FEATURE_FD) {
 		dev->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+		/* The data bit timing will be overwritten, if
+		 * GS_CAN_FEATURE_BT_CONST_EXT is set.
+		 */
 		dev->can.data_bittiming_const = &dev->bt_const;
 		dev->can.do_set_data_bittiming = gs_usb_set_data_bittiming;
 	}
@@ -1022,6 +1051,43 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 
 	kfree(bt_const);
 
+	/* fetch extended bit timing constants if device has feature
+	 * GS_CAN_FEATURE_FD and GS_CAN_FEATURE_BT_CONST_EXT
+	 */
+	if (feature & GS_CAN_FEATURE_FD &&
+	    feature & GS_CAN_FEATURE_BT_CONST_EXT) {
+		bt_const_extended = kmalloc(sizeof(*bt_const_extended), GFP_KERNEL);
+		if (!bt_const_extended)
+			return ERR_PTR(-ENOMEM);
+
+		rc = usb_control_msg(interface_to_usbdev(intf),
+				     usb_rcvctrlpipe(interface_to_usbdev(intf), 0),
+				     GS_USB_BREQ_BT_CONST_EXT,
+				     USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				     channel, 0, bt_const_extended,
+				     sizeof(*bt_const_extended),
+				     1000);
+		if (rc < 0) {
+			dev_err(&intf->dev,
+				"Couldn't get extended bit timing const for channel (err=%d)\n",
+				rc);
+			kfree(bt_const_extended);
+			return ERR_PTR(rc);
+		}
+
+		strcpy(dev->data_bt_const.name, "gs_usb");
+		dev->data_bt_const.tseg1_min = le32_to_cpu(bt_const_extended->dtseg1_min);
+		dev->data_bt_const.tseg1_max = le32_to_cpu(bt_const_extended->dtseg1_max);
+		dev->data_bt_const.tseg2_min = le32_to_cpu(bt_const_extended->dtseg2_min);
+		dev->data_bt_const.tseg2_max = le32_to_cpu(bt_const_extended->dtseg2_max);
+		dev->data_bt_const.sjw_max = le32_to_cpu(bt_const_extended->dsjw_max);
+		dev->data_bt_const.brp_min = le32_to_cpu(bt_const_extended->dbrp_min);
+		dev->data_bt_const.brp_max = le32_to_cpu(bt_const_extended->dbrp_max);
+		dev->data_bt_const.brp_inc = le32_to_cpu(bt_const_extended->dbrp_inc);
+
+		dev->can.data_bittiming_const = &dev->data_bt_const;
+	}
+
 	SET_NETDEV_DEV(netdev, &intf->dev);
 
 	rc = register_candev(dev->netdev);
-- 
2.35.1



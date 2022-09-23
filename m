Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A41E5E7A62
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiIWMSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiIWMQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:16:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016A913E7C1
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:09:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1obhUV-0007Lw-7k
        for netdev@vger.kernel.org; Fri, 23 Sep 2022 14:09:11 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 125B4EB15E
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 12:09:08 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 14FC2EB13E;
        Fri, 23 Sep 2022 12:09:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5c109006;
        Fri, 23 Sep 2022 12:09:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Daniel Trevitz <daniel.trevitz@wika.com>,
        Ryan Edwards <ryan.edwards@gmail.com>
Subject: [PATCH net-next 09/11] can: gs_usb: add switchable termination support
Date:   Fri, 23 Sep 2022 14:08:57 +0200
Message-Id: <20220923120859.740577-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220923120859.740577-1-mkl@pengutronix.de>
References: <20220923120859.740577-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The candleLight community is working on switchable termination support
for the candleLight firmware. As the the Linux CAN framework supports
switchable termination add this feature to the gs_usb driver.

Devices supporting the feature should set the
GS_CAN_FEATURE_TERMINATION and implement the
GS_USB_BREQ_SET_TERMINATION and GS_USB_BREQ_GET_TERMINATION control
messages.

For now the driver assumes for activated termination the standard
termination value of 120Ω.

Link: https://lore.kernel.org/all/20220923074114.662045-1-mkl@pengutronix.de
Link: https://github.com/candle-usb/candleLight_fw/issues/92
Link: https://github.com/candle-usb/candleLight_fw/pull/109
Link: https://github.com/candle-usb/candleLight_fw/pull/108
Cc: Daniel Trevitz <daniel.trevitz@wika.com>
Cc: Ryan Edwards <ryan.edwards@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 79 +++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index e9b07e5f988f..fbe9db46a41a 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -64,6 +64,8 @@ enum gs_usb_breq {
 	GS_USB_BREQ_SET_USER_ID,
 	GS_USB_BREQ_DATA_BITTIMING,
 	GS_USB_BREQ_BT_CONST_EXT,
+	GS_USB_BREQ_SET_TERMINATION,
+	GS_USB_BREQ_GET_TERMINATION,
 };
 
 enum gs_can_mode {
@@ -87,6 +89,14 @@ enum gs_can_identify_mode {
 	GS_CAN_IDENTIFY_ON
 };
 
+enum gs_can_termination_state {
+	GS_CAN_TERMINATION_STATE_OFF = 0,
+	GS_CAN_TERMINATION_STATE_ON
+};
+
+#define GS_USB_TERMINATION_DISABLED CAN_TERMINATION_DISABLED
+#define GS_USB_TERMINATION_ENABLED 120
+
 /* data types passed between host and device */
 
 /* The firmware on the original USB2CAN by Geschwister Schneider
@@ -123,6 +133,7 @@ struct gs_device_config {
 #define GS_CAN_MODE_FD BIT(8)
 /* GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX BIT(9) */
 /* GS_CAN_FEATURE_BT_CONST_EXT BIT(10) */
+/* GS_CAN_FEATURE_TERMINATION BIT(11) */
 
 struct gs_device_mode {
 	__le32 mode;
@@ -147,6 +158,10 @@ struct gs_identify_mode {
 	__le32 mode;
 } __packed;
 
+struct gs_device_termination_state {
+	__le32 state;
+} __packed;
+
 #define GS_CAN_FEATURE_LISTEN_ONLY BIT(0)
 #define GS_CAN_FEATURE_LOOP_BACK BIT(1)
 #define GS_CAN_FEATURE_TRIPLE_SAMPLE BIT(2)
@@ -158,7 +173,8 @@ struct gs_identify_mode {
 #define GS_CAN_FEATURE_FD BIT(8)
 #define GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX BIT(9)
 #define GS_CAN_FEATURE_BT_CONST_EXT BIT(10)
-#define GS_CAN_FEATURE_MASK GENMASK(10, 0)
+#define GS_CAN_FEATURE_TERMINATION BIT(11)
+#define GS_CAN_FEATURE_MASK GENMASK(11, 0)
 
 /* internal quirks - keep in GS_CAN_FEATURE space for now */
 
@@ -1080,6 +1096,52 @@ static const struct ethtool_ops gs_usb_ethtool_ops = {
 	.get_ts_info = gs_usb_get_ts_info,
 };
 
+static int gs_usb_get_termination(struct net_device *netdev, u16 *term)
+{
+	struct gs_can *dev = netdev_priv(netdev);
+	struct gs_device_termination_state term_state;
+	int rc;
+
+	rc = usb_control_msg_recv(interface_to_usbdev(dev->iface), 0,
+				  GS_USB_BREQ_GET_TERMINATION,
+				  USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				  dev->channel, 0,
+				  &term_state, sizeof(term_state), 1000,
+				  GFP_KERNEL);
+	if (rc)
+		return rc;
+
+	if (term_state.state == cpu_to_le32(GS_CAN_TERMINATION_STATE_ON))
+		*term = GS_USB_TERMINATION_ENABLED;
+	else
+		*term = GS_USB_TERMINATION_DISABLED;
+
+	return 0;
+}
+
+static int gs_usb_set_termination(struct net_device *netdev, u16 term)
+{
+	struct gs_can *dev = netdev_priv(netdev);
+	struct gs_device_termination_state term_state;
+
+	if (term == GS_USB_TERMINATION_ENABLED)
+		term_state.state = cpu_to_le32(GS_CAN_TERMINATION_STATE_ON);
+	else
+		term_state.state = cpu_to_le32(GS_CAN_TERMINATION_STATE_OFF);
+
+	return usb_control_msg_send(interface_to_usbdev(dev->iface), 0,
+				    GS_USB_BREQ_SET_TERMINATION,
+				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+				    dev->channel, 0,
+				    &term_state, sizeof(term_state), 1000,
+				    GFP_KERNEL);
+}
+
+static const u16 gs_usb_termination_const[] = {
+	GS_USB_TERMINATION_DISABLED,
+	GS_USB_TERMINATION_ENABLED
+};
+
 static struct gs_can *gs_make_candev(unsigned int channel,
 				     struct usb_interface *intf,
 				     struct gs_device_config *dconf)
@@ -1174,6 +1236,21 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 		dev->can.do_set_data_bittiming = gs_usb_set_data_bittiming;
 	}
 
+	if (feature & GS_CAN_FEATURE_TERMINATION) {
+		rc = gs_usb_get_termination(netdev, &dev->can.termination);
+		if (rc) {
+			dev->feature &= ~GS_CAN_FEATURE_TERMINATION;
+
+			dev_info(&intf->dev,
+				 "Disabling termination support for channel %d (%pe)\n",
+				 channel, ERR_PTR(rc));
+		} else {
+			dev->can.termination_const = gs_usb_termination_const;
+			dev->can.termination_const_cnt = ARRAY_SIZE(gs_usb_termination_const);
+			dev->can.do_set_termination = gs_usb_set_termination;
+		}
+	}
+
 	/* The CANtact Pro from LinkLayer Labs is based on the
 	 * LPC54616 µC, which is affected by the NXP LPC USB transfer
 	 * erratum. However, the current firmware (version 2) doesn't
-- 
2.35.1



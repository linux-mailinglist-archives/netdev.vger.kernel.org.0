Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A18E4D49C0
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244148AbiCJOc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344023AbiCJObg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A04EBAFF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJnA-0006LI-Ty
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:24 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 794B347E27
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EC99047E10;
        Thu, 10 Mar 2022 14:29:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e28dd7ba;
        Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 25/29] can: gs_usb: add quirk for CANtact Pro overlapping GS_USB_BREQ value
Date:   Thu, 10 Mar 2022 15:28:59 +0100
Message-Id: <20220310142903.341658-26-mkl@pengutronix.de>
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

For the GS_USB_BREQ_DATA_BITTIMING USB control message the CANtact Pro
firmware uses a request value, which is already used by the
candleLight firmware for a different
purpose (GS_USB_BREQ_GET_USER_ID).

This patch adds a quirk to use the CANtact Pro's value for the
GS_USB_BREQ_DATA_BITTIMING USB control message instead of the official
one.

Link: https://lore.kernel.org/all/20220309124132.291861-18-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index b0651789ccd3..1661b91de364 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -42,6 +42,7 @@ enum gs_usb_breq {
 	GS_USB_BREQ_TIMESTAMP,
 	GS_USB_BREQ_IDENTIFY,
 	GS_USB_BREQ_GET_USER_ID,
+	GS_USB_BREQ_QUIRK_CANTACT_PRO_DATA_BITTIMING = GS_USB_BREQ_GET_USER_ID,
 	GS_USB_BREQ_SET_USER_ID,
 	GS_USB_BREQ_DATA_BITTIMING,
 };
@@ -138,6 +139,13 @@ struct gs_identify_mode {
 #define GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX BIT(9)
 #define GS_CAN_FEATURE_MASK GENMASK(9, 0)
 
+/* internal quirks - keep in GS_CAN_FEATURE space for now */
+
+/* CANtact Pro original firmware:
+ * BREQ DATA_BITTIMING overlaps with GET_USER_ID
+ */
+#define GS_CAN_FEATURE_QUIRK_BREQ_CANTACT_PRO BIT(31)
+
 struct gs_device_bt_const {
 	__le32 feature;
 	__le32 fclk_can;
@@ -506,6 +514,7 @@ static int gs_usb_set_data_bittiming(struct net_device *netdev)
 	struct can_bittiming *bt = &dev->can.data_bittiming;
 	struct usb_interface *intf = dev->iface;
 	struct gs_device_bittiming *dbt;
+	u8 request = GS_USB_BREQ_DATA_BITTIMING;
 	int rc;
 
 	dbt = kmalloc(sizeof(*dbt), GFP_KERNEL);
@@ -518,10 +527,13 @@ static int gs_usb_set_data_bittiming(struct net_device *netdev)
 	dbt->sjw = cpu_to_le32(bt->sjw);
 	dbt->brp = cpu_to_le32(bt->brp);
 
+	if (dev->feature & GS_CAN_FEATURE_QUIRK_BREQ_CANTACT_PRO)
+		request = GS_USB_BREQ_QUIRK_CANTACT_PRO_DATA_BITTIMING;
+
 	/* request bit timings */
 	rc = usb_control_msg(interface_to_usbdev(intf),
 			     usb_sndctrlpipe(interface_to_usbdev(intf), 0),
-			     GS_USB_BREQ_DATA_BITTIMING,
+			     request,
 			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			     dev->channel, 0, dbt, sizeof(*dbt), 1000);
 
-- 
2.35.1



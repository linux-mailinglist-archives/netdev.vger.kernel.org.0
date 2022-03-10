Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AAE4D4B5D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244091AbiCJOcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344011AbiCJObg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784D6C3C11
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJn7-0006DY-Jd
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:21 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2A91547DFB
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A736D47DE8;
        Thu, 10 Mar 2022 14:29:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b5535a2b;
        Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 20/29] can: gs_usb: gs_usb_probe(): introduce udev and make use of it
Date:   Thu, 10 Mar 2022 15:28:54 +0100
Message-Id: <20220310142903.341658-21-mkl@pengutronix.de>
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

Introduce the variable udev in the gs_usb_probe() function to hold a
pointer to the struct usb_device. This avoids recalculating the value
several times in this function.

Link: https://lore.kernel.org/all/20220309124132.291861-13-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 52c84792361e..f56bfbeae3be 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -885,6 +885,7 @@ static void gs_destroy_candev(struct gs_can *dev)
 static int gs_usb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
+	struct usb_device *udev = interface_to_usbdev(intf);
 	struct gs_usb *dev;
 	int rc = -ENOMEM;
 	unsigned int icount, i;
@@ -898,8 +899,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 	hconf->byte_order = cpu_to_le32(0x0000beef);
 
 	/* send host config */
-	rc = usb_control_msg(interface_to_usbdev(intf),
-			     usb_sndctrlpipe(interface_to_usbdev(intf), 0),
+	rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			     GS_USB_BREQ_HOST_FORMAT,
 			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			     1, intf->cur_altsetting->desc.bInterfaceNumber,
@@ -917,8 +917,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 		return -ENOMEM;
 
 	/* read device config */
-	rc = usb_control_msg(interface_to_usbdev(intf),
-			     usb_rcvctrlpipe(interface_to_usbdev(intf), 0),
+	rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			     GS_USB_BREQ_DEVICE_CONFIG,
 			     USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			     1, intf->cur_altsetting->desc.bInterfaceNumber,
@@ -950,7 +949,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 	init_usb_anchor(&dev->rx_submitted);
 
 	usb_set_intfdata(intf, dev);
-	dev->udev = interface_to_usbdev(intf);
+	dev->udev = udev;
 
 	for (i = 0; i < icount; i++) {
 		dev->canch[i] = gs_make_candev(i, intf, dconf);
-- 
2.35.1



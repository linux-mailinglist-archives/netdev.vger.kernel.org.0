Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F50C4D4B19
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbiCJOc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343992AbiCJObe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6E0EB142
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:19 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJn4-00066u-3O
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2D4DD47DD2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6DB7647DBA;
        Thu, 10 Mar 2022 14:29:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7d953a8d;
        Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/29] can: gs_usb: rewrap usb_control_msg() and usb_fill_bulk_urb()
Date:   Thu, 10 Mar 2022 15:28:48 +0100
Message-Id: <20220310142903.341658-15-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch rewraps the arguments of usb_control_msg() and
usb_fill_bulk_urb() to make full use of the standard line length of 80
characters.

Link: https://lore.kernel.org/all/20220309124132.291861-7-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 87 +++++++++---------------------------
 1 file changed, 22 insertions(+), 65 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index b99f526fdfcd..7ba492150cdb 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -258,11 +258,7 @@ static int gs_cmd_reset(struct gs_can *gsdev)
 			     usb_sndctrlpipe(interface_to_usbdev(intf), 0),
 			     GS_USB_BREQ_MODE,
 			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     gsdev->channel,
-			     0,
-			     dm,
-			     sizeof(*dm),
-			     1000);
+			     gsdev->channel, 0, dm, sizeof(*dm), 1000);
 
 	kfree(dm);
 
@@ -392,14 +388,10 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	}
 
  resubmit_urb:
-	usb_fill_bulk_urb(urb,
-			  usbcan->udev,
+	usb_fill_bulk_urb(urb, usbcan->udev,
 			  usb_rcvbulkpipe(usbcan->udev, GSUSB_ENDPOINT_IN),
-			  hf,
-			  sizeof(struct gs_host_frame),
-			  gs_usb_receive_bulk_callback,
-			  usbcan
-			  );
+			  hf, sizeof(struct gs_host_frame),
+			  gs_usb_receive_bulk_callback, usbcan);
 
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 
@@ -436,11 +428,7 @@ static int gs_usb_set_bittiming(struct net_device *netdev)
 			     usb_sndctrlpipe(interface_to_usbdev(intf), 0),
 			     GS_USB_BREQ_BITTIMING,
 			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     dev->channel,
-			     0,
-			     dbt,
-			     sizeof(*dbt),
-			     1000);
+			     dev->channel, 0, dbt, sizeof(*dbt), 1000);
 
 	kfree(dbt);
 
@@ -460,10 +448,8 @@ static void gs_usb_xmit_callback(struct urb *urb)
 	if (urb->status)
 		netdev_info(netdev, "usb xmit fail %u\n", txc->echo_id);
 
-	usb_free_coherent(urb->dev,
-			  urb->transfer_buffer_length,
-			  urb->transfer_buffer,
-			  urb->transfer_dma);
+	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
+			  urb->transfer_buffer, urb->transfer_dma);
 }
 
 static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
@@ -519,10 +505,8 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 
 	usb_fill_bulk_urb(urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
-			  hf,
-			  sizeof(*hf),
-			  gs_usb_xmit_callback,
-			  txc);
+			  hf, sizeof(*hf),
+			  gs_usb_xmit_callback, txc);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &dev->tx_submitted);
@@ -540,9 +524,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 
 		usb_unanchor_urb(urb);
 		usb_free_coherent(dev->udev,
-				  sizeof(*hf),
-				  hf,
-				  urb->transfer_dma);
+				  sizeof(*hf), hf, urb->transfer_dma);
 
 		if (rc == -ENODEV) {
 			netif_device_detach(netdev);
@@ -562,10 +544,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
  badidx:
-	usb_free_coherent(dev->udev,
-			  sizeof(*hf),
-			  hf,
-			  urb->transfer_dma);
+	usb_free_coherent(dev->udev, sizeof(*hf), hf, urb->transfer_dma);
  nomem_hf:
 	usb_free_urb(urb);
 
@@ -618,8 +597,7 @@ static int gs_can_open(struct net_device *netdev)
 							  GSUSB_ENDPOINT_IN),
 					  buf,
 					  sizeof(struct gs_host_frame),
-					  gs_usb_receive_bulk_callback,
-					  parent);
+					  gs_usb_receive_bulk_callback, parent);
 			urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
 			usb_anchor_urb(urb, &parent->rx_submitted);
@@ -671,13 +649,8 @@ static int gs_can_open(struct net_device *netdev)
 	rc = usb_control_msg(interface_to_usbdev(dev->iface),
 			     usb_sndctrlpipe(interface_to_usbdev(dev->iface), 0),
 			     GS_USB_BREQ_MODE,
-			     USB_DIR_OUT | USB_TYPE_VENDOR |
-			     USB_RECIP_INTERFACE,
-			     dev->channel,
-			     0,
-			     dm,
-			     sizeof(*dm),
-			     1000);
+			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+			     dev->channel, 0, dm, sizeof(*dm), 1000);
 
 	if (rc < 0) {
 		netdev_err(netdev, "Couldn't start device (err=%d)\n", rc);
@@ -754,16 +727,10 @@ static int gs_usb_set_identify(struct net_device *netdev, bool do_identify)
 		imode->mode = cpu_to_le32(GS_CAN_IDENTIFY_OFF);
 
 	rc = usb_control_msg(interface_to_usbdev(dev->iface),
-			     usb_sndctrlpipe(interface_to_usbdev(dev->iface),
-					     0),
+			     usb_sndctrlpipe(interface_to_usbdev(dev->iface), 0),
 			     GS_USB_BREQ_IDENTIFY,
-			     USB_DIR_OUT | USB_TYPE_VENDOR |
-			     USB_RECIP_INTERFACE,
-			     dev->channel,
-			     0,
-			     imode,
-			     sizeof(*imode),
-			     100);
+			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
+			     dev->channel, 0, imode, sizeof(*imode), 100);
 
 	kfree(imode);
 
@@ -813,11 +780,7 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 			     usb_rcvctrlpipe(interface_to_usbdev(intf), 0),
 			     GS_USB_BREQ_BT_CONST,
 			     USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     channel,
-			     0,
-			     bt_const,
-			     sizeof(*bt_const),
-			     1000);
+			     channel, 0, bt_const, sizeof(*bt_const), 1000);
 
 	if (rc < 0) {
 		dev_err(&intf->dev,
@@ -931,11 +894,8 @@ static int gs_usb_probe(struct usb_interface *intf,
 			     usb_sndctrlpipe(interface_to_usbdev(intf), 0),
 			     GS_USB_BREQ_HOST_FORMAT,
 			     USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     1,
-			     intf->cur_altsetting->desc.bInterfaceNumber,
-			     hconf,
-			     sizeof(*hconf),
-			     1000);
+			     1, intf->cur_altsetting->desc.bInterfaceNumber,
+			     hconf, sizeof(*hconf), 1000);
 
 	kfree(hconf);
 
@@ -953,11 +913,8 @@ static int gs_usb_probe(struct usb_interface *intf,
 			     usb_rcvctrlpipe(interface_to_usbdev(intf), 0),
 			     GS_USB_BREQ_DEVICE_CONFIG,
 			     USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
-			     1,
-			     intf->cur_altsetting->desc.bInterfaceNumber,
-			     dconf,
-			     sizeof(*dconf),
-			     1000);
+			     1, intf->cur_altsetting->desc.bInterfaceNumber,
+			     dconf, sizeof(*dconf), 1000);
 	if (rc < 0) {
 		dev_err(&intf->dev, "Couldn't get device config: (err=%d)\n",
 			rc);
-- 
2.35.1



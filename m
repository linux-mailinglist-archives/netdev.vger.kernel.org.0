Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B96328A3C3
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgJJW41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:27 -0400
Received: from hosting.gsystem.sk ([212.5.213.30]:49450 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387535AbgJJURp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 16:17:45 -0400
X-Greylist: delayed 4183 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2020 16:17:42 EDT
Received: from gsql.ggedos.sk (off-20.infotel.telecom.sk [212.5.213.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 3147D7A02E9;
        Sat, 10 Oct 2020 16:01:23 +0200 (CEST)
From:   Ondrej Zary <linux@zary.sk>
To:     Oliver Neukum <oneukum@suse.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cx82310_eth: re-enable ethernet mode after router reboot
Date:   Sat, 10 Oct 2020 16:00:46 +0200
Message-Id: <20201010140048.12067-1-linux@zary.sk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the router is rebooted without a power cycle, the USB device
remains connected but its configuration is reset. This results in
a non-working ethernet connection with messages like this in syslog:
	usb 2-2: RX packet too long: 65535 B

Re-enable ethernet mode when receiving a packet with invalid size of
0xffff.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/net/usb/cx82310_eth.c | 50 ++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/cx82310_eth.c b/drivers/net/usb/cx82310_eth.c
index 32b08b18e120..043679311399 100644
--- a/drivers/net/usb/cx82310_eth.c
+++ b/drivers/net/usb/cx82310_eth.c
@@ -40,6 +40,11 @@ enum cx82310_status {
 #define CX82310_MTU	1514
 #define CMD_EP		0x01
 
+struct cx82310_priv {
+	struct work_struct reenable_work;
+	struct usbnet *dev;
+};
+
 /*
  * execute control command
  *  - optionally send some data (command parameters)
@@ -115,6 +120,23 @@ static int cx82310_cmd(struct usbnet *dev, enum cx82310_cmd cmd, bool reply,
 	return ret;
 }
 
+static int cx82310_enable_ethernet(struct usbnet *dev)
+{
+	int ret = cx82310_cmd(dev, CMD_ETHERNET_MODE, true, "\x01", 1, NULL, 0);
+
+	if (ret)
+		netdev_err(dev->net, "unable to enable ethernet mode: %d\n",
+			   ret);
+	return ret;
+}
+
+static void cx82310_reenable_work(struct work_struct *work)
+{
+	struct cx82310_priv *priv = container_of(work, struct cx82310_priv,
+						 reenable_work);
+	cx82310_enable_ethernet(priv->dev);
+}
+
 #define partial_len	data[0]		/* length of partial packet data */
 #define partial_rem	data[1]		/* remaining (missing) data length */
 #define partial_data	data[2]		/* partial packet data */
@@ -126,6 +148,7 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	struct usb_device *udev = dev->udev;
 	u8 link[3];
 	int timeout = 50;
+	struct cx82310_priv *priv;
 
 	/* avoid ADSL modems - continue only if iProduct is "USB NET CARD" */
 	if (usb_string(udev, udev->descriptor.iProduct, buf, sizeof(buf)) > 0
@@ -152,6 +175,15 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (!dev->partial_data)
 		return -ENOMEM;
 
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		goto err_partial;
+	}
+	dev->driver_priv = priv;
+	INIT_WORK(&priv->reenable_work, cx82310_reenable_work);
+	priv->dev = dev;
+
 	/* wait for firmware to become ready (indicated by the link being up) */
 	while (--timeout) {
 		ret = cx82310_cmd(dev, CMD_GET_LINK_STATUS, true, NULL, 0,
@@ -168,12 +200,8 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 
 	/* enable ethernet mode (?) */
-	ret = cx82310_cmd(dev, CMD_ETHERNET_MODE, true, "\x01", 1, NULL, 0);
-	if (ret) {
-		dev_err(&udev->dev, "unable to enable ethernet mode: %d\n",
-			ret);
+	if (cx82310_enable_ethernet(dev))
 		goto err;
-	}
 
 	/* get the MAC address */
 	ret = cx82310_cmd(dev, CMD_GET_MAC_ADDR, true, NULL, 0,
@@ -190,13 +218,19 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	return 0;
 err:
+	kfree(dev->driver_priv);
+err_partial:
 	kfree((void *)dev->partial_data);
 	return ret;
 }
 
 static void cx82310_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
+	struct cx82310_priv *priv = dev->driver_priv;
+
 	kfree((void *)dev->partial_data);
+	cancel_work_sync(&priv->reenable_work);
+	kfree(dev->driver_priv);
 }
 
 /*
@@ -211,6 +245,7 @@ static int cx82310_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
 	int len;
 	struct sk_buff *skb2;
+	struct cx82310_priv *priv = dev->driver_priv;
 
 	/*
 	 * If the last skb ended with an incomplete packet, this skb contains
@@ -245,7 +280,10 @@ static int cx82310_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			break;
 		}
 
-		if (len > CX82310_MTU) {
+		if (len == 0xffff) {
+			netdev_info(dev->net, "router was rebooted, re-enabling ethernet mode");
+			schedule_work(&priv->reenable_work);
+		} else if (len > CX82310_MTU) {
 			dev_err(&dev->udev->dev, "RX packet too long: %d B\n",
 				len);
 			return 0;
-- 
Ondrej Zary


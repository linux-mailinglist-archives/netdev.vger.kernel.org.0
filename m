Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3553D5B6D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbhGZNea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234592AbhGZNdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31F9C0619FA
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81La-0002Rv-WA
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:47 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id ABBD36582ED
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 36D7E658228;
        Mon, 26 Jul 2021 14:12:07 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 279693ad;
        Mon, 26 Jul 2021 14:11:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 41/46] can: etas_es58x: add es58x_free_netdevs() to factorize code
Date:   Mon, 26 Jul 2021 16:11:39 +0200
Message-Id: <20210726141144.862529-42-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Both es58x_probe() and es58x_disconnect() use a similar code snippet
to release the netdev resources. Factorize it in an helper function
named es58x_free_netdevs().

Link: https://lore.kernel.org/r/20210628155420.1176217-5-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 46 +++++++++++----------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index d2bb1b56f962..126e4d57332e 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2107,6 +2107,25 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	return ret;
 }
 
+/**
+ * es58x_free_netdevs() - Release all network resources of the device.
+ * @es58x_dev: ES58X device.
+ */
+static void es58x_free_netdevs(struct es58x_device *es58x_dev)
+{
+	int i;
+
+	for (i = 0; i < es58x_dev->num_can_ch; i++) {
+		struct net_device *netdev = es58x_dev->netdev[i];
+
+		if (!netdev)
+			continue;
+		unregister_candev(netdev);
+		es58x_dev->netdev[i] = NULL;
+		free_candev(netdev);
+	}
+}
+
 /**
  * es58x_get_product_info() - Get the product information and print them.
  * @es58x_dev: ES58X device.
@@ -2240,18 +2259,11 @@ static int es58x_probe(struct usb_interface *intf,
 
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
 		ret = es58x_init_netdev(es58x_dev, ch_idx);
-		if (ret)
-			goto cleanup_candev;
-	}
-
-	return ret;
-
- cleanup_candev:
-	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++)
-		if (es58x_dev->netdev[ch_idx]) {
-			unregister_candev(es58x_dev->netdev[ch_idx]);
-			free_candev(es58x_dev->netdev[ch_idx]);
+		if (ret) {
+			es58x_free_netdevs(es58x_dev);
+			return ret;
 		}
+	}
 
 	return ret;
 }
@@ -2266,21 +2278,11 @@ static int es58x_probe(struct usb_interface *intf,
 static void es58x_disconnect(struct usb_interface *intf)
 {
 	struct es58x_device *es58x_dev = usb_get_intfdata(intf);
-	struct net_device *netdev;
-	int i;
 
 	dev_info(&intf->dev, "Disconnecting %s %s\n",
 		 es58x_dev->udev->manufacturer, es58x_dev->udev->product);
 
-	for (i = 0; i < es58x_dev->num_can_ch; i++) {
-		netdev = es58x_dev->netdev[i];
-		if (!netdev)
-			continue;
-		unregister_candev(netdev);
-		es58x_dev->netdev[i] = NULL;
-		free_candev(netdev);
-	}
-
+	es58x_free_netdevs(es58x_dev);
 	es58x_free_urbs(es58x_dev);
 	usb_set_intfdata(intf, NULL);
 }
-- 
2.30.2



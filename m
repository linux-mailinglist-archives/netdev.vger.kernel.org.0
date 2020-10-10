Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F01228A3C5
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbgJJW43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:29 -0400
Received: from hosting.gsystem.sk ([212.5.213.30]:49448 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387537AbgJJURp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 16:17:45 -0400
Received: from gsql.ggedos.sk (off-20.infotel.telecom.sk [212.5.213.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 54AAB7A0414;
        Sat, 10 Oct 2020 16:01:23 +0200 (CEST)
From:   Ondrej Zary <linux@zary.sk>
To:     Oliver Neukum <oneukum@suse.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cx82310_eth: use netdev_err instead of dev_err
Date:   Sat, 10 Oct 2020 16:00:47 +0200
Message-Id: <20201010140048.12067-2-linux@zary.sk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201010140048.12067-1-linux@zary.sk>
References: <20201010140048.12067-1-linux@zary.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_err for better device identification in syslog.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/net/usb/cx82310_eth.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/usb/cx82310_eth.c b/drivers/net/usb/cx82310_eth.c
index 043679311399..ca89d8258dd3 100644
--- a/drivers/net/usb/cx82310_eth.c
+++ b/drivers/net/usb/cx82310_eth.c
@@ -71,8 +71,8 @@ static int cx82310_cmd(struct usbnet *dev, enum cx82310_cmd cmd, bool reply,
 			   CMD_PACKET_SIZE, &actual_len, CMD_TIMEOUT);
 	if (ret < 0) {
 		if (cmd != CMD_GET_LINK_STATUS)
-			dev_err(&dev->udev->dev, "send command %#x: error %d\n",
-				cmd, ret);
+			netdev_err(dev->net, "send command %#x: error %d\n",
+				   cmd, ret);
 		goto end;
 	}
 
@@ -84,30 +84,27 @@ static int cx82310_cmd(struct usbnet *dev, enum cx82310_cmd cmd, bool reply,
 					   CMD_TIMEOUT);
 			if (ret < 0) {
 				if (cmd != CMD_GET_LINK_STATUS)
-					dev_err(&dev->udev->dev,
-						"reply receive error %d\n",
-						ret);
+					netdev_err(dev->net, "reply receive error %d\n",
+						   ret);
 				goto end;
 			}
 			if (actual_len > 0)
 				break;
 		}
 		if (actual_len == 0) {
-			dev_err(&dev->udev->dev, "no reply to command %#x\n",
-				cmd);
+			netdev_err(dev->net, "no reply to command %#x\n", cmd);
 			ret = -EIO;
 			goto end;
 		}
 		if (buf[0] != cmd) {
-			dev_err(&dev->udev->dev,
-				"got reply to command %#x, expected: %#x\n",
-				buf[0], cmd);
+			netdev_err(dev->net, "got reply to command %#x, expected: %#x\n",
+				   buf[0], cmd);
 			ret = -EIO;
 			goto end;
 		}
 		if (buf[1] != STATUS_SUCCESS) {
-			dev_err(&dev->udev->dev, "command %#x failed: %#x\n",
-				cmd, buf[1]);
+			netdev_err(dev->net, "command %#x failed: %#x\n", cmd,
+				   buf[1]);
 			ret = -EIO;
 			goto end;
 		}
@@ -194,7 +191,7 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 		msleep(500);
 	}
 	if (!timeout) {
-		dev_err(&udev->dev, "firmware not ready in time\n");
+		netdev_err(dev->net, "firmware not ready in time\n");
 		ret = -ETIMEDOUT;
 		goto err;
 	}
@@ -207,7 +204,7 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = cx82310_cmd(dev, CMD_GET_MAC_ADDR, true, NULL, 0,
 			  dev->net->dev_addr, ETH_ALEN);
 	if (ret) {
-		dev_err(&udev->dev, "unable to read MAC address: %d\n", ret);
+		netdev_err(dev->net, "unable to read MAC address: %d\n", ret);
 		goto err;
 	}
 
@@ -284,8 +281,7 @@ static int cx82310_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			netdev_info(dev->net, "router was rebooted, re-enabling ethernet mode");
 			schedule_work(&priv->reenable_work);
 		} else if (len > CX82310_MTU) {
-			dev_err(&dev->udev->dev, "RX packet too long: %d B\n",
-				len);
+			netdev_err(dev->net, "RX packet too long: %d B\n", len);
 			return 0;
 		}
 
-- 
Ondrej Zary


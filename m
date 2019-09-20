Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0F0B8B62
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 09:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394960AbfITHFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 03:05:05 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:33727 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394945AbfITHFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 03:05:05 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Sep 2019 03:05:03 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1568963102;
        s=strato-dkim-0002; d=pixelbox.red;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=CfOqpHyuGvSB95fhV5I1R6aCppSl4Qzwo51zChZ9v6k=;
        b=MLyHKs9w/D/tSu4Vqi3uKg48TRzvzoA47PxHbpBMG1P7xYafSB1HS12yHVnb53F9tu
        HeGp0WYleiuZRuEuV91PpHubuh6S7RvG8/DfzUwkzmV8RVNNUBkbvNnrjCztVFw12bMi
        ftgWf5iQPQCl+qx8l2pQNKf+83joa4r6/Hs8h43tMPaWHjKnnRbOhzNosRA7WnJDt+9d
        6xGNqXIKUWyRzyGz9J+7fAQSBlTCulgO7LZIK7u0Zd2GzQztK6+HwjRKUjGRdMgCdOh4
        FlEUTdN8PEFtMD70YVAcJHbrzqtNiu1de3qwgKn1c9z0IIBZfUsDbb9ty92Q2hOrzogf
        iJAg==
X-RZG-AUTH: ":PGkAZ0+Ia/aHbZh+i/9QzqYeH5BDcTFH98iPmzDT881S1Jv9Y40I0vUpkEK3poY1KyL7e8vwUVd6rhLT+3nQPD/JTWrS4IlCVOSV0M8="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 44.27.0 AUTH)
        with ESMTPSA id w0149ev8K6x86mY
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 20 Sep 2019 08:59:08 +0200 (CEST)
From:   Peter Fink <pedro@pixelbox.red>
To:     netdev@vger.kernel.org
Cc:     pfink@christ-es.de, davem@davemloft.net, linux@christ-es.de
Subject: [PATCH net-next] net: usb: ax88179_178a: allow optionally getting mac address from device tree
Date:   Fri, 20 Sep 2019 08:58:30 +0200
Message-Id: <1568962710-14845-2-git-send-email-pedro@pixelbox.red>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568962710-14845-1-git-send-email-pedro@pixelbox.red>
References: <1568962710-14845-1-git-send-email-pedro@pixelbox.red>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Fink <pfink@christ-es.de>

Adopt and integrate the feature to pass the MAC address via device tree
from asix_device.c (03fc5d4) also to other ax88179 based asix chips.
E.g. the bootloader fills in local-mac-address and the driver will then
pick up and use this MAC address.

Signed-off-by: Peter Fink <pfink@christ-es.de>
---
 drivers/net/usb/ax88179_178a.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index daa5448..5a58766 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1214,6 +1214,29 @@ static int ax88179_led_setting(struct usbnet *dev)
 	return 0;
 }
 
+static void ax88179_get_mac_addr(struct usbnet *dev)
+{
+	u8 mac[ETH_ALEN];
+
+	/* Maybe the boot loader passed the MAC address via device tree */
+	if (!eth_platform_get_mac_address(&dev->udev->dev, mac)) {
+		netif_dbg(dev, ifup, dev->net,
+			  "MAC address read from device tree");
+	} else {
+		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
+				 ETH_ALEN, mac);
+		netif_dbg(dev, ifup, dev->net,
+			  "MAC address read from ASIX chip");
+	}
+
+	if (is_valid_ether_addr(mac)) {
+		memcpy(dev->net->dev_addr, mac, ETH_ALEN);
+	} else {
+		netdev_info(dev->net, "invalid MAC address, using random\n");
+		eth_hw_addr_random(dev->net);
+	}
+}
+
 static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	u8 buf[5];
@@ -1240,8 +1263,8 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, tmp);
 	msleep(100);
 
-	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
-			 ETH_ALEN, dev->net->dev_addr);
+	/* Read MAC address from DTB or asix chip */
+	ax88179_get_mac_addr(dev);
 	memcpy(dev->net->perm_addr, dev->net->dev_addr, ETH_ALEN);
 
 	/* RX bulk configuration */
@@ -1541,8 +1564,8 @@ static int ax88179_reset(struct usbnet *dev)
 	/* Ethernet PHY Auto Detach*/
 	ax88179_auto_detach(dev, 0);
 
-	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN, ETH_ALEN,
-			 dev->net->dev_addr);
+	/* Read MAC address from DTB or asix chip */
+	ax88179_get_mac_addr(dev);
 
 	/* RX bulk configuration */
 	memcpy(tmp, &AX88179_BULKIN_SIZE[0], 5);
-- 
2.7.4


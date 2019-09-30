Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652D5C2050
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 14:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbfI3MEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 08:04:42 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:20670 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfI3MEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 08:04:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1569845077;
        s=strato-dkim-0002; d=pixelbox.red;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=CfOqpHyuGvSB95fhV5I1R6aCppSl4Qzwo51zChZ9v6k=;
        b=l/jyskGmiUHJkRfTUrarVdWko8+KqXrPowflLHdDfiBxfe5autrl/qvBKYkCfJQ0vE
        qjY7It5hLGtzyHlb//f7BKIeMslZtJwaYKjq997z/eFTxWeW//feGiBzVha+Ixxm/7o5
        xz49qE7G4D3bS3rC7BwU/Bjzulo0gxe5LqmZeC0qn5W3o9fHLh884nf5xTa0nda5Lrhh
        3dQJaOZyWPyRy5Xk63N17qKnEQMo78e2FsJoga/RpzW2/Mk+wDp5d20pLbodJysrdU0Q
        9kCc6jSzke/9dNI59sSd/1pUtlMlqB0OY1W4iIV68g9Pd1SOZGSbdf0freCewwN4T8Br
        uXSQ==
X-RZG-AUTH: ":PGkAZ0+Ia/aHbZh+i/9QzqYeH5BDcTFH98iPmzDT881S1Jv9Y40I0vUpkEK3poY1KyL7e8vwUVd6rhLT+3nQPD/JTWrS4IlCVOSV0M8="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 44.28.0 AUTH)
        with ESMTPSA id d0520cv8UC4YJ7W
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 30 Sep 2019 14:04:34 +0200 (CEST)
From:   Peter Fink <pedro@pixelbox.red>
To:     netdev@vger.kernel.org
Cc:     pfink@christ-es.de, davem@davemloft.net, linux@christ-es.de
Subject: [PATCH net-next] net: usb: ax88179_178a: allow optionally getting mac address from device tree
Date:   Mon, 30 Sep 2019 14:04:03 +0200
Message-Id: <1569845043-27318-2-git-send-email-pedro@pixelbox.red>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569845043-27318-1-git-send-email-pedro@pixelbox.red>
References: <1569845043-27318-1-git-send-email-pedro@pixelbox.red>
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


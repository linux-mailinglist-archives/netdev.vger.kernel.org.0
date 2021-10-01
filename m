Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8406141F6FB
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355686AbhJAVe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355537AbhJAVeT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C2661AF0;
        Fri,  1 Oct 2021 21:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123954;
        bh=tHgagq9ZjTLAqFPCyPyAVdwxQBT014g6x6ywlPaCZ0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLtfgUz5MLXl7B+X8qlT1DgsZn0qW4tkN/xf6QcV+6SdfCo7H1BwaPfoA3G/OTHNZ
         e6XHeOjWvFNx+uQVRQaPhsaxHtI5IOkuC0favrw9KkangQdB42qc6ooFf2EFIq0z4x
         Z6ffKZ/wxy0oEcULkj+8AZmheZjlgr7lTj+cHYllZgBEvZ9Larz/AfFMtNMXocTVei
         gvsqXfTmPZKjOfebVoPTuO9AljXqOtQVWFwEBCzFYEHe5xisSUSuDbWPf13NP1WqnZ
         ZGsgMVss+YkqkPkNmnrChdFGYQt6Kimg6FDV2Te6iAr+T0HTs5qoP9dtPXOh12aPGB
         S+x3hzHNPlZcA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH net-next 04/11] net: usb: use eth_hw_addr_set()
Date:   Fri,  1 Oct 2021 14:32:21 -0700
Message-Id: <20211001213228.1735079-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Convert usb drivers from memcpy(... ETH_ADDR) to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - memcpy(dev->dev_addr, np, ETH_ALEN)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Oliver Neukum <oliver@neukum.org>
---
 drivers/net/usb/asix_common.c  | 2 +-
 drivers/net/usb/asix_devices.c | 2 +-
 drivers/net/usb/ax88172a.c     | 2 +-
 drivers/net/usb/ax88179_178a.c | 4 ++--
 drivers/net/usb/dm9601.c       | 2 +-
 drivers/net/usb/ipheth.c       | 2 +-
 drivers/net/usb/kalmia.c       | 2 +-
 drivers/net/usb/sr9800.c       | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 38cda590895c..42ba4af68090 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -791,7 +791,7 @@ int asix_set_mac_address(struct net_device *net, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(net->dev_addr, addr->sa_data, ETH_ALEN);
+	eth_hw_addr_set(net, addr->sa_data);
 
 	/* We use the 20 byte dev->data
 	 * for our 6 byte mac buffer
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 30821f6a6d7a..4514d35ef4c4 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -59,7 +59,7 @@ static void asix_status(struct usbnet *dev, struct urb *urb)
 static void asix_set_netdev_dev_addr(struct usbnet *dev, u8 *addr)
 {
 	if (is_valid_ether_addr(addr)) {
-		memcpy(dev->net->dev_addr, addr, ETH_ALEN);
+		eth_hw_addr_set(dev->net, addr);
 	} else {
 		netdev_info(dev->net, "invalid hw address, using random\n");
 		eth_hw_addr_random(dev->net);
diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index d9777d9a7c5d..3777c7e2e6fc 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -176,7 +176,7 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 		ret = -EIO;
 		goto free;
 	}
-	memcpy(dev->net->dev_addr, buf, ETH_ALEN);
+	eth_hw_addr_set(dev->net, buf);
 
 	dev->net->netdev_ops = &ax88172a_netdev_ops;
 	dev->net->ethtool_ops = &ax88172a_ethtool_ops;
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index f25448a08870..5ed59d9dd631 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1015,7 +1015,7 @@ static int ax88179_set_mac_addr(struct net_device *net, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(net->dev_addr, addr->sa_data, ETH_ALEN);
+	eth_hw_addr_set(net, addr->sa_data);
 
 	/* Set the MAC address */
 	ret = ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
@@ -1310,7 +1310,7 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
 	}
 
 	if (is_valid_ether_addr(mac)) {
-		memcpy(dev->net->dev_addr, mac, ETH_ALEN);
+		eth_hw_addr_set(dev->net, mac);
 	} else {
 		netdev_info(dev->net, "invalid MAC address, using random\n");
 		eth_hw_addr_random(dev->net);
diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index 907f98b1eefe..f4b03202472d 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -391,7 +391,7 @@ static int dm9601_bind(struct usbnet *dev, struct usb_interface *intf)
 	 * Overwrite the auto-generated address only with good ones.
 	 */
 	if (is_valid_ether_addr(mac))
-		memcpy(dev->net->dev_addr, mac, ETH_ALEN);
+		eth_hw_addr_set(dev->net, mac);
 	else {
 		printk(KERN_WARNING
 			"dm9601: No valid MAC address in EEPROM, using %pM\n",
diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 06e2181e5810..cd33955df0b6 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -303,7 +303,7 @@ static int ipheth_get_macaddr(struct ipheth_device *dev)
 			__func__, retval);
 		retval = -EINVAL;
 	} else {
-		memcpy(net->dev_addr, dev->ctrl_buf, ETH_ALEN);
+		eth_hw_addr_set(net, dev->ctrl_buf);
 		retval = 0;
 	}
 
diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index fc5895f85cee..9f2b70ef39aa 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -149,7 +149,7 @@ kalmia_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (status)
 		return status;
 
-	memcpy(dev->net->dev_addr, ethernet_addr, ETH_ALEN);
+	eth_hw_addr_set(dev->net, ethernet_addr);
 
 	return status;
 }
diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index 576401c8b1be..838f4e9e8b58 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -503,7 +503,7 @@ static int sr_set_mac_address(struct net_device *net, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(net->dev_addr, addr->sa_data, ETH_ALEN);
+	eth_hw_addr_set(net, addr->sa_data);
 
 	/* We use the 20 byte dev->data
 	 * for our 6 byte mac buffer
-- 
2.31.1


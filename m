Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07B4434F6C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhJTP6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230219AbhJTP6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15A6861391;
        Wed, 20 Oct 2021 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745385;
        bh=Q6GukgSxum5heAjWu5WVyDdY9rzmygiOSc8He3sQwrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IR4Gnr2XMuyGLrAh4Wgp2n7WVebOkBKwoenrs0vDN7Fk1lQRD3njkHRI5QnSGIWU/
         BHLlOjW8SS8hwNHRxd5NlTzHOdqAZ/VL/NDvmga+FACCVe+ft4q9xCqgppaqguwdjt
         PsPceZg1Wh1y7Sf92ToeOKem8Aht29iYMxy0g6nJrA4xTOtbtsyUJmdrpm/MWjzzlq
         Y/h6Osj6wzxQE8JtL/Lvv7/dMrSxZSWti8GcJ5BhpVx4W/OGRo0gICVaJQJoPnXhCb
         4jg794KV2ImAGmjtjmXoqQXCbYOrb6jByWldoRMdMsOQfwQxNc0eD7ZlrgpdKzSRDY
         mgc8SfBpQuK/Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        linux-usb@vger.kernel.org
Subject: [PATCH net-next 02/12] usb: smsc: use eth_hw_addr_set()
Date:   Wed, 20 Oct 2021 08:56:07 -0700
Message-Id: <20211020155617.1721694-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020155617.1721694-1-kuba@kernel.org>
References: <20211020155617.1721694-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: steve.glendinning@shawell.net
CC: UNGLinuxDriver@microchip.com
CC: linux-usb@vger.kernel.org
---
 drivers/net/usb/smsc75xx.c | 6 ++++--
 drivers/net/usb/smsc95xx.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 3b6987bb4fbe..95de452ff4da 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -757,6 +757,8 @@ static int smsc75xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 
 static void smsc75xx_init_mac_address(struct usbnet *dev)
 {
+	u8 addr[ETH_ALEN];
+
 	/* maybe the boot loader passed the MAC address in devicetree */
 	if (!platform_get_ethdev_address(&dev->udev->dev, dev->net)) {
 		if (is_valid_ether_addr(dev->net->dev_addr)) {
@@ -767,8 +769,8 @@ static void smsc75xx_init_mac_address(struct usbnet *dev)
 	}
 
 	/* try reading mac address from EEPROM */
-	if (smsc75xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
-			dev->net->dev_addr) == 0) {
+	if (smsc75xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN, addr) == 0) {
+		eth_hw_addr_set(dev->net, addr);
 		if (is_valid_ether_addr(dev->net->dev_addr)) {
 			/* eeprom values are valid so use them */
 			netif_dbg(dev, ifup, dev->net,
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 21a42a6527dc..20fe4cd8f784 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -755,6 +755,8 @@ static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 
 static void smsc95xx_init_mac_address(struct usbnet *dev)
 {
+	u8 addr[ETH_ALEN];
+
 	/* maybe the boot loader passed the MAC address in devicetree */
 	if (!platform_get_ethdev_address(&dev->udev->dev, dev->net)) {
 		if (is_valid_ether_addr(dev->net->dev_addr)) {
@@ -765,8 +767,8 @@ static void smsc95xx_init_mac_address(struct usbnet *dev)
 	}
 
 	/* try reading mac address from EEPROM */
-	if (smsc95xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
-			dev->net->dev_addr) == 0) {
+	if (smsc95xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN, addr) == 0) {
+		eth_hw_addr_set(dev->net, addr);
 		if (is_valid_ether_addr(dev->net->dev_addr)) {
 			/* eeprom values are valid so use them */
 			netif_dbg(dev, ifup, dev->net, "MAC address read from EEPROM\n");
-- 
2.31.1


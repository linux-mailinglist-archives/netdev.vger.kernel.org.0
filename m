Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03344253FB
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241364AbhJGN1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:27:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232869AbhJGN1P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:27:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EEC061260;
        Thu,  7 Oct 2021 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633613121;
        bh=Zfh1PMyB1Wj0CvhmHjvy7xzyxhIKVN4ppZXNCBouEBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8xo6Pz1W3l/4jM57kUYRqpij6s5/UPfmjtHg9NwsrTYNVuiNlayGzLmNxlBMuky+
         Ci6Eo+hw4DmFVpfUj6KjnC9O3O0hfYbk9kRCFjwNijpc/WWN/6yp3o2O2TfDP3orFN
         Z8cWTEX4GXAOzubyUWMXRX6S0ygkBDCHJrpS1utWuN4CfL70PpPTjAnYELUHDox+Iw
         bwogytAclmIJfBcw5D3+AvdWRzzH46JZxNqTuoIiD+O2HegmMGT0dUh66eZy1lSelE
         AKm/V/24op2IsMPXLvWC+GegjHM6EBe0qIV/yw9UKPFCkSuhw1uHqmmjM8+7Mz+c5N
         OTN006RfkYrvQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com, michael@walle.cc,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] ethernet: use platform_get_ethdev_address()
Date:   Thu,  7 Oct 2021 06:25:11 -0700
Message-Id: <20211007132511.3462291-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007132511.3462291-1-kuba@kernel.org>
References: <20211007132511.3462291-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new platform_get_ethdev_address() helper for the cases
where dev->dev_addr is passed in directly as the destination.

  @@
  expression dev, net;
  @@
  - eth_platform_get_mac_address(dev, net->dev_addr)
  + platform_get_ethdev_address(dev, net)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/actions/owl-emac.c       | 2 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 +-
 drivers/net/usb/smsc75xx.c                    | 3 +--
 drivers/net/usb/smsc95xx.c                    | 3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
index 2c25ff3623cd..dce93acd1644 100644
--- a/drivers/net/ethernet/actions/owl-emac.c
+++ b/drivers/net/ethernet/actions/owl-emac.c
@@ -1385,7 +1385,7 @@ static void owl_emac_get_mac_addr(struct net_device *netdev)
 	struct device *dev = netdev->dev.parent;
 	int ret;
 
-	ret = eth_platform_get_mac_address(dev, netdev->dev_addr);
+	ret = platform_get_ethdev_address(dev, netdev);
 	if (!ret && is_valid_ether_addr(netdev->dev_addr))
 		return;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 1d5dd2015453..e2ebfd8115a0 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1544,7 +1544,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = eth_platform_get_mac_address(dev, ndev->dev_addr);
+	ret = platform_get_ethdev_address(dev, ndev);
 	if (ret || !is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
 
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 76f7af161313..3b6987bb4fbe 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -758,8 +758,7 @@ static int smsc75xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 static void smsc75xx_init_mac_address(struct usbnet *dev)
 {
 	/* maybe the boot loader passed the MAC address in devicetree */
-	if (!eth_platform_get_mac_address(&dev->udev->dev,
-			dev->net->dev_addr)) {
+	if (!platform_get_ethdev_address(&dev->udev->dev, dev->net)) {
 		if (is_valid_ether_addr(dev->net->dev_addr)) {
 			/* device tree values are valid so use them */
 			netif_dbg(dev, ifup, dev->net, "MAC address read from the device tree\n");
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 26b1bd8e845b..21a42a6527dc 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -756,8 +756,7 @@ static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 static void smsc95xx_init_mac_address(struct usbnet *dev)
 {
 	/* maybe the boot loader passed the MAC address in devicetree */
-	if (!eth_platform_get_mac_address(&dev->udev->dev,
-			dev->net->dev_addr)) {
+	if (!platform_get_ethdev_address(&dev->udev->dev, dev->net)) {
 		if (is_valid_ether_addr(dev->net->dev_addr)) {
 			/* device tree values are valid so use them */
 			netif_dbg(dev, ifup, dev->net, "MAC address read from the device tree\n");
-- 
2.31.1


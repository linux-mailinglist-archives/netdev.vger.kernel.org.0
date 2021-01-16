Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9122F8E11
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbhAPROZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:14:25 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:33127 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbhAPROJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 12:14:09 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DJ3sW3btxz1rvxj;
        Sat, 16 Jan 2021 17:48:47 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DJ3sW2fRPz1qqkg;
        Sat, 16 Jan 2021 17:48:47 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ddhxtQ8tENzH; Sat, 16 Jan 2021 17:48:46 +0100 (CET)
X-Auth-Info: R75VtrxGbqFRNZBINekOw/+eDDIsV4Uw3GFvTMbZWNM=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 16 Jan 2021 17:48:45 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net-next V2] net: ks8851: Fix mixed module/builtin build
Date:   Sat, 16 Jan 2021 17:48:28 +0100
Message-Id: <20210116164828.40545-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When either the SPI or PAR variant is compiled as module AND the other
variant is compiled as built-in, the following build error occurs:

arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'

Fix this by passing THIS_MODULE as argument to ks8851_probe_common(),
ks8851_register_mdiobus(), and ultimately __mdiobus_register() in the
ks8851_common.c.

Fixes: ef3631220d2b ("net: ks8851: Register MDIO bus and the internal PHY")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>
---
V2: Pass the THIS_MODULE into ks8851_common.c
---
 drivers/net/ethernet/micrel/ks8851.h        | 2 +-
 drivers/net/ethernet/micrel/ks8851_common.c | 9 +++++----
 drivers/net/ethernet/micrel/ks8851_par.c    | 2 +-
 drivers/net/ethernet/micrel/ks8851_spi.c    | 2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index ef13929036cf..037138fc6cb4 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -428,7 +428,7 @@ struct ks8851_net {
 };
 
 int ks8851_probe_common(struct net_device *netdev, struct device *dev,
-			int msg_en);
+			int msg_en, struct module *owner);
 int ks8851_remove_common(struct device *dev);
 int ks8851_suspend(struct device *dev);
 int ks8851_resume(struct device *dev);
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index f1996787bba5..88303ba4869d 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -1104,7 +1104,8 @@ int ks8851_resume(struct device *dev)
 }
 #endif
 
-static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
+static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev,
+				   struct module *owner)
 {
 	struct phy_device *phy_dev;
 	struct mii_bus *mii_bus;
@@ -1122,7 +1123,7 @@ static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
 	mii_bus->phy_mask = ~((u32)BIT(0));
 	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
-	ret = mdiobus_register(mii_bus);
+	ret = __mdiobus_register(mii_bus, owner);
 	if (ret)
 		goto err_mdiobus_register;
 
@@ -1149,7 +1150,7 @@ static void ks8851_unregister_mdiobus(struct ks8851_net *ks)
 }
 
 int ks8851_probe_common(struct net_device *netdev, struct device *dev,
-			int msg_en)
+			int msg_en, struct module *owner)
 {
 	struct ks8851_net *ks = netdev_priv(netdev);
 	unsigned cider;
@@ -1224,7 +1225,7 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 
 	dev_info(dev, "message enable is %d\n", msg_en);
 
-	ret = ks8851_register_mdiobus(ks, dev);
+	ret = ks8851_register_mdiobus(ks, dev, owner);
 	if (ret)
 		goto err_mdio;
 
diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
index 3bab0cb2b1a5..d6fc53d3efbb 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -324,7 +324,7 @@ static int ks8851_probe_par(struct platform_device *pdev)
 
 	netdev->irq = platform_get_irq(pdev, 0);
 
-	return ks8851_probe_common(netdev, dev, msg_enable);
+	return ks8851_probe_common(netdev, dev, msg_enable, THIS_MODULE);
 }
 
 static int ks8851_remove_par(struct platform_device *pdev)
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 4ec7f1615977..9fbb7a548580 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -451,7 +451,7 @@ static int ks8851_probe_spi(struct spi_device *spi)
 
 	netdev->irq = spi->irq;
 
-	return ks8851_probe_common(netdev, dev, msg_enable);
+	return ks8851_probe_common(netdev, dev, msg_enable, THIS_MODULE);
 }
 
 static int ks8851_remove_spi(struct spi_device *spi)
-- 
2.29.2


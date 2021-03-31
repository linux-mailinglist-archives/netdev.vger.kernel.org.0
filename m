Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C3B35020A
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhCaOSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbhCaOSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 10:18:14 -0400
Received: from hs01.dk-develop.de (hs01.dk-develop.de [IPv6:2a02:c207:3002:6234::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E35C061574;
        Wed, 31 Mar 2021 07:18:12 -0700 (PDT)
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     linux@armlinux.org.uk, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeremy.linton@arm.com,
        Danilo Krummrich <danilokrummrich@dk-develop.de>
Subject: [PATCH 1/2] net: mdio: rename mii bus probe_capabilities
Date:   Wed, 31 Mar 2021 16:17:54 +0200
Message-Id: <20210331141755.126178-2-danilokrummrich@dk-develop.de>
In-Reply-To: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the probe_capabilities field of struct mii_bus to capabilities.

This field represents the supported frame formats of the mdio controller
backing this bus as by IEEE 802.3 in general. This is not specific to the
probing procedure of the bus.

Signed-off-by: Danilo Krummrich <danilokrummrich@dk-develop.de>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c       | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
 drivers/net/phy/mdio_bus.c                        | 2 +-
 include/linux/phy.h                               | 7 +++++--
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index bfa2826c5545..bda04154fca2 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -268,7 +268,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
-	bus->probe_capabilities = MDIOBUS_C22_C45;
+	bus->capabilities = MDIOBUS_C22_C45;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);
 
 	/* Set the PHY base address */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index d64116e0543e..917537731131 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -366,7 +366,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 	new_bus->name = "stmmac";
 
 	if (priv->plat->has_gmac4)
-		new_bus->probe_capabilities = MDIOBUS_C22_C45;
+		new_bus->capabilities = MDIOBUS_C22_C45;
 
 	if (priv->plat->has_xgmac) {
 		new_bus->read = &stmmac_xgmac2_mdio_read;
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 823518554079..d03e40a0fbae 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -670,7 +670,7 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 	struct phy_device *phydev = ERR_PTR(-ENODEV);
 	int err;
 
-	switch (bus->probe_capabilities) {
+	switch (bus->capabilities) {
 	case MDIOBUS_NO_CAP:
 	case MDIOBUS_C22:
 		phydev = get_phy_device(bus, addr, false);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1a12e4436b5b..ba5eb317a471 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -362,13 +362,16 @@ struct mii_bus {
 	/** @reset_gpiod: Reset GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
 
-	/** @probe_capabilities: bus capabilities, used for probing */
+	/**
+	 * @capabilities: bus capabilities, representing supported frame
+	 * formats as by IEEE 802.3
+	 */
 	enum {
 		MDIOBUS_NO_CAP = 0,
 		MDIOBUS_C22,
 		MDIOBUS_C45,
 		MDIOBUS_C22_C45,
-	} probe_capabilities;
+	} capabilities;
 
 	/** @shared_lock: protect access to the shared element */
 	struct mutex shared_lock;
-- 
2.31.0


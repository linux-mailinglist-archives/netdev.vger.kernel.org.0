Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A17214E8D
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgGESbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:31:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47510 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbgGESbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 14:31:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1js9Q3-003iuB-HS; Sun, 05 Jul 2020 20:31:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH net-next 7/7] net: phy: mdio-octeon: Cleanup module loading dependencies
Date:   Sun,  5 Jul 2020 20:29:21 +0200
Message-Id: <20200705182921.887441-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705182921.887441-1-andrew@lunn.ch>
References: <20200705182921.887441-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To ensure that the octoen MDIO driver has been loaded, the Cavium
ethernet drivers reference a dummy symbol in the MDIO driver. This
forces it to be loaded first. And this symbol has not been cleanly
implemented, resulting in warnings when build W=1 C=1.

Since device tree is being used, and a phandle points to the PHY on
the MDIO bus, we can make use of deferred probing. If the PHY fails to
connect, it should be because the MDIO bus driver has not loaded
yet. Return -EPROBE_DEFER so it will be tried again later.

Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Robert Richter <rrichter@marvell.com>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 6 +-----
 drivers/net/phy/mdio-octeon.c                    | 6 ------
 drivers/staging/octeon/ethernet-mdio.c           | 2 +-
 drivers/staging/octeon/ethernet-mdio.h           | 2 --
 drivers/staging/octeon/ethernet.c                | 2 --
 5 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index cbaa1924afbe..4bf0237ee52e 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -961,7 +961,7 @@ static int octeon_mgmt_init_phy(struct net_device *netdev)
 				PHY_INTERFACE_MODE_MII);
 
 	if (!phydev)
-		return -ENODEV;
+		return -EPROBE_DEFER;
 
 	return 0;
 }
@@ -1554,12 +1554,8 @@ static struct platform_driver octeon_mgmt_driver = {
 	.remove		= octeon_mgmt_remove,
 };
 
-extern void octeon_mdiobus_force_mod_depencency(void);
-
 static int __init octeon_mgmt_mod_init(void)
 {
-	/* Force our mdiobus driver module to be loaded first. */
-	octeon_mdiobus_force_mod_depencency();
 	return platform_driver_register(&octeon_mgmt_driver);
 }
 
diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/phy/mdio-octeon.c
index a2f93948db97..d1e1009d51af 100644
--- a/drivers/net/phy/mdio-octeon.c
+++ b/drivers/net/phy/mdio-octeon.c
@@ -108,12 +108,6 @@ static struct platform_driver octeon_mdiobus_driver = {
 	.remove		= octeon_mdiobus_remove,
 };
 
-void octeon_mdiobus_force_mod_depencency(void)
-{
-	/* Let ethernet drivers force us to be loaded.  */
-}
-EXPORT_SYMBOL(octeon_mdiobus_force_mod_depencency);
-
 module_platform_driver(octeon_mdiobus_driver);
 
 MODULE_DESCRIPTION("Cavium OCTEON MDIO bus driver");
diff --git a/drivers/staging/octeon/ethernet-mdio.c b/drivers/staging/octeon/ethernet-mdio.c
index c798672d61b2..cfb673a52b25 100644
--- a/drivers/staging/octeon/ethernet-mdio.c
+++ b/drivers/staging/octeon/ethernet-mdio.c
@@ -163,7 +163,7 @@ int cvm_oct_phy_setup_device(struct net_device *dev)
 	of_node_put(phy_node);
 
 	if (!phydev)
-		return -ENODEV;
+		return -EPROBE_DEFER;
 
 	priv->last_link = 0;
 	phy_start(phydev);
diff --git a/drivers/staging/octeon/ethernet-mdio.h b/drivers/staging/octeon/ethernet-mdio.h
index e3771d48c49b..7f6716e3fad4 100644
--- a/drivers/staging/octeon/ethernet-mdio.h
+++ b/drivers/staging/octeon/ethernet-mdio.h
@@ -22,7 +22,5 @@
 
 extern const struct ethtool_ops cvm_oct_ethtool_ops;
 
-void octeon_mdiobus_force_mod_depencency(void);
-
 int cvm_oct_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 int cvm_oct_phy_setup_device(struct net_device *dev);
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index f42c3816ce49..920ab08e4311 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -689,8 +689,6 @@ static int cvm_oct_probe(struct platform_device *pdev)
 	mtu_overhead += VLAN_HLEN;
 #endif
 
-	octeon_mdiobus_force_mod_depencency();
-
 	pip = pdev->dev.of_node;
 	if (!pip) {
 		pr_err("Error: No 'pip' in /aliases\n");
-- 
2.27.0.rc2


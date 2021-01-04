Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93F72E94E3
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 13:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbhADMbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 07:31:32 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:52230 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADMbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 07:31:32 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D8ZjB3nntz1qs3D;
        Mon,  4 Jan 2021 13:30:38 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D8ZjB3Cmcz1qwHK;
        Mon,  4 Jan 2021 13:30:38 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id JUd93HhTgGxl; Mon,  4 Jan 2021 13:30:37 +0100 (CET)
X-Auth-Info: GyL2it64dbzpH0IwOddxl8qZyqcr7+b+qYJlXsLisUE=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon,  4 Jan 2021 13:30:37 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH V2 2/2] net: ks8851: Register MDIO bus and the internal PHY
Date:   Mon,  4 Jan 2021 13:30:17 +0100
Message-Id: <20210104123017.261452-2-marex@denx.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104123017.261452-1-marex@denx.de>
References: <20210104123017.261452-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KS8851 has a reduced internal PHY, which is accessible through its
registers at offset 0xe4. The PHY is compatible with KS886x PHY present
in Micrel switches, except the PHY ID Low/High registers are swapped.
Register MDIO bus so this PHY can be detected and probed by phylib.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>
To: netdev@vger.kernel.org
---
V2: - Cast the BIT(0) to u32 to avoid build warnings
    - Swap PHY ID Hi/Lo registers for MDIO bus access
      (retain old behavior for MII bus access)
    - Return -EOPNOTSUPP on read from nonexisting PHY registers
---
 drivers/net/ethernet/micrel/ks8851.h        |   1 +
 drivers/net/ethernet/micrel/ks8851_common.c | 113 +++++++++++++++++---
 2 files changed, 98 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index 2b319e451121..9bed9e024d81 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -403,6 +403,7 @@ struct ks8851_net {
 	struct regulator	*vdd_reg;
 	struct regulator	*vdd_io;
 	int			gpio;
+	struct mii_bus		*mii_bus;
 
 	void			(*lock)(struct ks8851_net *ks,
 					unsigned long *flags);
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 6fc7483aea03..e0de9c4c98d1 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -23,6 +23,7 @@
 
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
+#include <linux/of_mdio.h>
 #include <linux/of_net.h>
 
 #include "ks8851.h"
@@ -932,7 +933,25 @@ static int ks8851_phy_reg(int reg)
 		return KS_P1ANLPR;
 	}
 
-	return 0x0;
+	return -EOPNOTSUPP;
+}
+
+static int ks8851_phy_read_common(struct net_device *dev, int phy_addr, int reg)
+{
+	struct ks8851_net *ks = netdev_priv(dev);
+	unsigned long flags;
+	int result;
+	int ksreg;
+
+	ksreg = ks8851_phy_reg(reg);
+	if (ksreg < 0)
+		return ksreg;
+
+	ks8851_lock(ks, &flags);
+	result = ks8851_rdreg16(ks, ksreg);
+	ks8851_unlock(ks, &flags);
+
+	return result;
 }
 
 /**
@@ -952,20 +971,13 @@ static int ks8851_phy_reg(int reg)
  */
 static int ks8851_phy_read(struct net_device *dev, int phy_addr, int reg)
 {
-	struct ks8851_net *ks = netdev_priv(dev);
-	unsigned long flags;
-	int ksreg;
-	int result;
+	int ret;
 
-	ksreg = ks8851_phy_reg(reg);
-	if (!ksreg)
+	ret = ks8851_phy_read_common(dev, phy_addr, reg);
+	if (ret < 0)
 		return 0x0;	/* no error return allowed, so use zero */
 
-	ks8851_lock(ks, &flags);
-	result = ks8851_rdreg16(ks, ksreg);
-	ks8851_unlock(ks, &flags);
-
-	return result;
+	return ret;
 }
 
 static void ks8851_phy_write(struct net_device *dev,
@@ -976,13 +988,38 @@ static void ks8851_phy_write(struct net_device *dev,
 	int ksreg;
 
 	ksreg = ks8851_phy_reg(reg);
-	if (ksreg) {
+	if (ksreg >= 0) {
 		ks8851_lock(ks, &flags);
 		ks8851_wrreg16(ks, ksreg, value);
 		ks8851_unlock(ks, &flags);
 	}
 }
 
+static int ks8851_mdio_read(struct mii_bus *bus, int phy_id, int reg)
+{
+	struct ks8851_net *ks = bus->priv;
+	int ret;
+
+	if (phy_id != 0)
+		return -EOPNOTSUPP;
+
+	/* KS8851 PHY ID registers are swapped in HW, swap them back. */
+	if (reg == MII_PHYSID1)
+		reg = MII_PHYSID2;
+	else if (reg == MII_PHYSID2)
+		reg = MII_PHYSID1;
+
+	return ks8851_phy_read_common(ks->netdev, phy_id, reg);
+}
+
+static int ks8851_mdio_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
+{
+	struct ks8851_net *ks = bus->priv;
+
+	ks8851_phy_write(ks->netdev, phy_id, reg, val);
+	return 0;
+}
+
 /**
  * ks8851_read_selftest - read the selftest memory info.
  * @ks: The device state
@@ -1046,6 +1083,42 @@ int ks8851_resume(struct device *dev)
 }
 #endif
 
+static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
+{
+	struct mii_bus *mii_bus;
+	int ret;
+
+	mii_bus = mdiobus_alloc();
+	if (!mii_bus)
+		return -ENOMEM;
+
+	mii_bus->name = "ks8851_eth_mii";
+	mii_bus->read = ks8851_mdio_read;
+	mii_bus->write = ks8851_mdio_write;
+	mii_bus->priv = ks;
+	mii_bus->parent = dev;
+	mii_bus->phy_mask = ~((u32)BIT(0));
+	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
+
+	ret = mdiobus_register(mii_bus);
+	if (ret)
+		goto err_mdiobus_register;
+
+	ks->mii_bus = mii_bus;
+
+	return 0;
+
+err_mdiobus_register:
+	mdiobus_free(mii_bus);
+	return ret;
+}
+
+static void ks8851_unregister_mdiobus(struct ks8851_net *ks)
+{
+	mdiobus_unregister(ks->mii_bus);
+	mdiobus_free(ks->mii_bus);
+}
+
 int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 			int msg_en)
 {
@@ -1104,6 +1177,8 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 
 	INIT_WORK(&ks->rxctrl_work, ks8851_rxctrl_work);
 
+	SET_NETDEV_DEV(netdev, dev);
+
 	/* setup EEPROM state */
 	ks->eeprom.data = ks;
 	ks->eeprom.width = PCI_EEPROM_WIDTH_93C46;
@@ -1120,6 +1195,10 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 
 	dev_info(dev, "message enable is %d\n", msg_en);
 
+	ret = ks8851_register_mdiobus(ks, dev);
+	if (ret)
+		goto err_mdio;
+
 	/* set the default message enable */
 	ks->msg_enable = netif_msg_init(msg_en, NETIF_MSG_DRV |
 						NETIF_MSG_PROBE |
@@ -1128,7 +1207,6 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 	skb_queue_head_init(&ks->txq);
 
 	netdev->ethtool_ops = &ks8851_ethtool_ops;
-	SET_NETDEV_DEV(netdev, dev);
 
 	dev_set_drvdata(dev, ks);
 
@@ -1156,7 +1234,7 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 	ret = register_netdev(netdev);
 	if (ret) {
 		dev_err(dev, "failed to register network device\n");
-		goto err_netdev;
+		goto err_id;
 	}
 
 	netdev_info(netdev, "revision %d, MAC %pM, IRQ %d, %s EEPROM\n",
@@ -1165,8 +1243,9 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 
 	return 0;
 
-err_netdev:
 err_id:
+	ks8851_unregister_mdiobus(ks);
+err_mdio:
 	if (gpio_is_valid(gpio))
 		gpio_set_value(gpio, 0);
 	regulator_disable(ks->vdd_reg);
@@ -1180,6 +1259,8 @@ int ks8851_remove_common(struct device *dev)
 {
 	struct ks8851_net *priv = dev_get_drvdata(dev);
 
+	ks8851_unregister_mdiobus(priv);
+
 	if (netif_msg_drv(priv))
 		dev_info(dev, "remove\n");
 
-- 
2.29.2


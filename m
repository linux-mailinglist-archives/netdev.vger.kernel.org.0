Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425A5296D2A
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462621AbgJWK45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 06:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462583AbgJWK4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 06:56:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4F6C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 03:56:40 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukG-00087n-Kp; Fri, 23 Oct 2020 12:56:28 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukF-0001k9-D5; Fri, 23 Oct 2020 12:56:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, linux-can@vger.kernel.org
Subject: [RFC PATCH v1 1/6] net: phy: add CAN PHY Virtual Bus
Date:   Fri, 23 Oct 2020 12:56:21 +0200
Message-Id: <20201023105626.6534-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201023105626.6534-1-o.rempel@pengutronix.de>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of CAN PHYs (transceivers) are not attached to any data bus, so we
are not able to communicate with them. For this case, we introduce a CAN
specific virtual bus to make use of existing PHY framework.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/Kconfig       |   8 ++
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/can_phy_bus.c | 196 ++++++++++++++++++++++++++++++++++
 include/linux/can/phy.h       |  21 ++++
 4 files changed, 226 insertions(+)
 create mode 100644 drivers/net/phy/can_phy_bus.c
 create mode 100644 include/linux/can/phy.h

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 698bea312adc..39e3f57ea60a 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -153,6 +153,14 @@ config BCM_CYGNUS_PHY
 config BCM_NET_PHYLIB
 	tristate
 
+config CAN_PHY_BUS
+	tristate "Virtual CAN PHY Bus"
+	depends on PHYLIB
+	help
+	  Most CAN PHYs (transceivers) are not attached to any data bus, so we
+	  are not able to communicate with them. For this case, a CAN specific
+	  virtual bus to make use of existing PHY framework.
+
 config CICADA_PHY
 	tristate "Cicada PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a13e402074cf..0d76d802c07f 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_BCM87XX_PHY)	+= bcm87xx.o
 obj-$(CONFIG_BCM_CYGNUS_PHY)	+= bcm-cygnus.o
 obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o
 obj-$(CONFIG_BROADCOM_PHY)	+= broadcom.o
+obj-$(CONFIG_CAN_PHY_BUS)	+= can_phy_bus.o
 obj-$(CONFIG_CICADA_PHY)	+= cicada.o
 obj-$(CONFIG_CORTINA_PHY)	+= cortina.o
 obj-$(CONFIG_DAVICOM_PHY)	+= davicom.o
diff --git a/drivers/net/phy/can_phy_bus.c b/drivers/net/phy/can_phy_bus.c
new file mode 100644
index 000000000000..b1712e19327c
--- /dev/null
+++ b/drivers/net/phy/can_phy_bus.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-FileCopyrightText: 2020 Oleksij Rempel <kernel@pengutronix.de>, Pengutronix
+
+#include <linux/can/phy.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+
+struct can_mdio_bus {
+	struct mii_bus *mii_bus;
+	struct list_head phys;
+};
+
+struct can_phy {
+	int addr;
+	struct phy_device *phydev;
+	struct list_head node;
+};
+
+static struct platform_device *pdev;
+static struct can_mdio_bus platform_fmb = {
+	.phys = LIST_HEAD_INIT(platform_fmb.phys),
+};
+
+static DEFINE_IDA(phy_can_ida);
+
+/* The is the fake bus. All read/write operations are bugs. */
+static int can_mdio_read(struct mii_bus *bus, int phy_addr, int reg_num)
+{
+	WARN_ON_ONCE(1);
+	return 0xFFFF;
+}
+
+static int can_mdio_write(struct mii_bus *bus, int phy_addr, int reg_num,
+			  u16 val)
+{
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static int can_phy_add(int phy_addr)
+{
+	struct can_mdio_bus *fmb = &platform_fmb;
+	struct can_phy *fp;
+
+	fp = kzalloc(sizeof(*fp), GFP_KERNEL);
+	if (!fp)
+		return -ENOMEM;
+
+	fp->addr = phy_addr;
+
+	list_add_tail(&fp->node, &fmb->phys);
+
+	return 0;
+}
+
+static void can_phy_del(int phy_addr)
+{
+	struct can_mdio_bus *fmb = &platform_fmb;
+	struct can_phy *fp, *tmp;
+
+	list_for_each_entry_safe(fp, tmp, &fmb->phys, node) {
+		if (fp->addr == phy_addr) {
+			list_del(&fp->node);
+			kfree(fp);
+			ida_simple_remove(&phy_can_ida, phy_addr);
+			return;
+		}
+	}
+}
+
+struct phy_device *can_phy_register(struct device_node *mac_node)
+{
+	struct can_mdio_bus *fmb = &platform_fmb;
+	struct device_node *np;
+	struct phy_device *phy;
+	int phy_addr;
+	int ret;
+
+	if (!fmb->mii_bus || fmb->mii_bus->state != MDIOBUS_REGISTERED)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	/* New binding */
+	np = of_get_child_by_name(mac_node, "can-transceiver");
+	if (!np)
+		return ERR_PTR(-ENODEV);
+
+	/* Get the next available PHY address, up to PHY_MAX_ADDR */
+	phy_addr = ida_simple_get(&phy_can_ida, 0, PHY_MAX_ADDR, GFP_KERNEL);
+	if (phy_addr < 0) {
+		err = ERR_PTR(phy_addr);
+		goto err_of_node_put;
+	}
+
+	ret = can_phy_add(phy_addr);
+	if (ret < 0)
+		goto err_ida_simple_remove;
+
+	phy = phy_device_create(fmb->mii_bus, phy_addr, 0, false, NULL);
+	if (IS_ERR(phy)) {
+		ret = ERR_PTR(phy);
+		goto err_can_phy_del;
+	}
+
+	of_node_get(np);
+	phy->mdio.dev.of_node = np;
+	phy->is_pseudo_fixed_link = true;
+
+	phy_advertise_supported(phy);
+
+	ret = phy_device_register(phy);
+	if (ret)
+		goto err_phy_device_free;
+
+	return phy;
+
+err_phy_device_free:
+	phy_device_free(phy);
+err_can_phy_del:
+	can_phy_del(phy_addr);
+err_ida_simple_remove:
+	ida_simple_remove(&phy_can_ida, phy_addr);
+err_of_node_put:
+	of_node_put(np);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(can_phy_register);
+
+void can_phy_unregister(struct phy_device *phy)
+{
+	phy_device_remove(phy);
+	of_node_put(phy->mdio.dev.of_node);
+	can_phy_del(phy->mdio.addr);
+}
+EXPORT_SYMBOL_GPL(can_phy_unregister);
+
+static int __init can_mdio_bus_init(void)
+{
+	struct can_mdio_bus *fmb = &platform_fmb;
+	int ret;
+
+	pdev = platform_device_register_simple("Virtual CAN PHY Bus", 0, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	fmb->mii_bus = mdiobus_alloc();
+	if (fmb->mii_bus == NULL) {
+		ret = -ENOMEM;
+		goto err_mdiobus_reg;
+	}
+
+	snprintf(fmb->mii_bus->id, MII_BUS_ID_SIZE, "virtual-can-0");
+	fmb->mii_bus->name = "Virtual CAN PHY Bus";
+	fmb->mii_bus->priv = fmb;
+	fmb->mii_bus->parent = &pdev->dev;
+	fmb->mii_bus->read = &can_mdio_read;
+	fmb->mii_bus->write = &can_mdio_write;
+	/* do not scan the bus for PHYs */
+	fmb->mii_bus->phy_mask = ~0;
+
+	ret = mdiobus_register(fmb->mii_bus);
+	if (ret)
+		goto err_mdiobus_alloc;
+
+	return 0;
+
+err_mdiobus_alloc:
+	mdiobus_free(fmb->mii_bus);
+err_mdiobus_reg:
+	platform_device_unregister(pdev);
+	return ret;
+}
+module_init(can_mdio_bus_init);
+
+static void __exit can_mdio_bus_exit(void)
+{
+	struct can_mdio_bus *fmb = &platform_fmb;
+	struct can_phy *fp, *tmp;
+
+	mdiobus_unregister(fmb->mii_bus);
+	mdiobus_free(fmb->mii_bus);
+	platform_device_unregister(pdev);
+
+	list_for_each_entry_safe(fp, tmp, &fmb->phys, node) {
+		list_del(&fp->node);
+		kfree(fp);
+	}
+	ida_destroy(&phy_can_ida);
+}
+module_exit(can_mdio_bus_exit);
+
+MODULE_DESCRIPTION("Virtual CAN PHY Bus");
+MODULE_AUTHOR("Oleksij Rempel");
+MODULE_LICENSE("GPLv2");
diff --git a/include/linux/can/phy.h b/include/linux/can/phy.h
new file mode 100644
index 000000000000..3772132d9100
--- /dev/null
+++ b/include/linux/can/phy.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __CAN_PHY_H
+#define __CAN_PHY_H
+
+#include <linux/phy.h>
+
+#if IS_ENABLED(CONFIG_CAN_PHY)
+extern void can_phy_unregister(struct phy_device *phydev);
+struct phy_device *can_phy_register(struct device_node *mac_node);
+#else
+static inline struct phy_device *can_phy_register(struct device_node *mac_node)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void can_phy_unregister(struct phy_device *phydev)
+{
+}
+#endif /* CONFIG_CAN_PHY */
+
+#endif /* __CAN_PHY_H */
-- 
2.28.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4E33151D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfEaTQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:16:07 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:36797 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbfEaTQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:16:07 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VJG6JW019361
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 13:16:06 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VJG6dm007508
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 13:16:06 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: phy: xilinx: add Xilinx PHY driver
Date:   Fri, 31 May 2019 13:15:49 -0600
Message-Id: <1559330150-30099-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a driver for the PHY device implemented in the Xilinx PCS/PMA
Core logic. Aside from being a generic gigabit PHY, it includes an
important register setting to disable the PHY isolation bit, which is
required for the PHY to operate in 1000BaseX mode.

This version is a simplified version of the GPL 2+ version from the
Xilinx kernel tree.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/Kconfig      |  6 +++++
 drivers/net/phy/Makefile     |  1 +
 drivers/net/phy/xilinx_phy.c | 60 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)
 create mode 100644 drivers/net/phy/xilinx_phy.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index db5645b..101c794 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -462,6 +462,12 @@ config VITESSE_PHY
 	---help---
 	  Currently supports the vsc8244
 
+config XILINX_PHY
+	tristate "Drivers for Xilinx PHYs"
+	help
+	  This module provides a driver for the PHY implemented in the
+	  Xilinx PCS/PMA Core.
+
 config XILINX_GMII2RGMII
 	tristate "Xilinx GMII2RGMII converter driver"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index bac339e..f71359d 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -92,3 +92,4 @@ obj-$(CONFIG_STE10XP)		+= ste10Xp.o
 obj-$(CONFIG_TERANETICS_PHY)	+= teranetics.o
 obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
 obj-$(CONFIG_XILINX_GMII2RGMII) += xilinx_gmii2rgmii.o
+obj-$(CONFIG_XILINX_PHY)	+= xilinx_phy.o
diff --git a/drivers/net/phy/xilinx_phy.c b/drivers/net/phy/xilinx_phy.c
new file mode 100644
index 0000000..2d468c7
--- /dev/null
+++ b/drivers/net/phy/xilinx_phy.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Xilinx PCS/PMA Core phy driver
+ *
+ * Copyright (C) 2019 SED Systems, a division of Calian Ltd.
+ *
+ * Based upon Xilinx version of this driver:
+ * Copyright (C) 2015 Xilinx, Inc.
+ *
+ * Description:
+ * This driver is developed for PCS/PMA Core.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/phy.h>
+
+/* Mask used for ID comparisons */
+#define XILINX_PHY_ID_MASK		0xfffffff0
+
+/* Known PHY IDs */
+#define XILINX_PHY_ID			0x01740c00
+
+#define XPCSPMA_PHY_CTRL_ISOLATE_DISABLE 0xFBFF
+
+static int xilinxphy_config_init(struct phy_device *phydev)
+{
+	int temp;
+
+	temp = phy_read(phydev, MII_BMCR);
+	temp &= XPCSPMA_PHY_CTRL_ISOLATE_DISABLE;
+	phy_write(phydev, MII_BMCR, temp);
+
+	return 0;
+}
+
+static struct phy_driver xilinx_drivers[] = {
+{
+	.phy_id		= XILINX_PHY_ID,
+	.phy_id_mask	= XILINX_PHY_ID_MASK,
+	.name		= "Xilinx PCS/PMA PHY",
+	.features	= PHY_GBIT_FEATURES,
+	.config_init	= xilinxphy_config_init,
+	.resume		= genphy_resume,
+	.suspend	= genphy_suspend,
+	.set_loopback   = genphy_loopback,
+},
+};
+
+module_phy_driver(xilinx_drivers);
+
+static struct mdio_device_id __maybe_unused xilinx_tbl[] = {
+	{ XILINX_PHY_ID, XILINX_PHY_ID_MASK },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, xilinx_tbl);
+MODULE_DESCRIPTION("Xilinx PCS/PMA PHY driver");
+MODULE_LICENSE("GPL");
+
-- 
1.8.3.1


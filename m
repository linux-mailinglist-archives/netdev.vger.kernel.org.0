Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92EA33BC7
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfFCXMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:12:13 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25215 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfFCXMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:12:13 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x53NCCe1010576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 3 Jun 2019 17:12:13 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x53NCCOk061532
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 3 Jun 2019 17:12:12 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v2] net: phy: xilinx: add Xilinx PHY driver
Date:   Mon,  3 Jun 2019 17:12:04 -0600
Message-Id: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a driver for the PHY device implemented in the Xilinx PCS/PMA
Core logic. This is mostly a generic gigabit PHY, except that the
features are explicitly set because the PHY wrongly indicates it has no
extended status register when it actually does.

This version is a simplified version of the GPL 2+ version from the
Xilinx kernel tree.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---

Differences from v1:
-Removed unnecessary config_init method
-Added comment to explain why features are explicitly set

 drivers/net/phy/Kconfig  |  6 ++++++
 drivers/net/phy/Makefile |  1 +
 drivers/net/phy/xilinx.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)
 create mode 100644 drivers/net/phy/xilinx.c

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
index bac339e..3ee9cdb 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -91,4 +91,5 @@ obj-$(CONFIG_SMSC_PHY)		+= smsc.o
 obj-$(CONFIG_STE10XP)		+= ste10Xp.o
 obj-$(CONFIG_TERANETICS_PHY)	+= teranetics.o
 obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
+obj-$(CONFIG_XILINX_PHY)	+= xilinx.o
 obj-$(CONFIG_XILINX_GMII2RGMII) += xilinx_gmii2rgmii.o
diff --git a/drivers/net/phy/xilinx.c b/drivers/net/phy/xilinx.c
new file mode 100644
index 0000000..0e5509b
--- /dev/null
+++ b/drivers/net/phy/xilinx.c
@@ -0,0 +1,51 @@
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
+static struct phy_driver xilinx_drivers[] = {
+{
+	.phy_id		= XILINX_PHY_ID,
+	.phy_id_mask	= XILINX_PHY_ID_MASK,
+	.name		= "Xilinx PCS/PMA PHY",
+	/* Xilinx PHY wrongly indicates BMSR_ESTATEN = 0 even though
+	 * extended status registers are supported. So we force the PHY
+	 * features to PHY_GBIT_FEATURES in order to allow gigabit support
+	 * to be detected.
+	 */
+	.features	= PHY_GBIT_FEATURES,
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


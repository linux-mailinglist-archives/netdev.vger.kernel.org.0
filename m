Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B34022FA4F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgG0Urq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:47:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58086 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgG0Urp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 16:47:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0A2A-0079fb-Kc; Mon, 27 Jul 2020 22:47:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC net-next 3/3] net: phy: Move and rename mdio-xpcs
Date:   Mon, 27 Jul 2020 22:47:31 +0200
Message-Id: <20200727204731.1705418-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727204731.1705418-1-andrew@lunn.ch>
References: <20200727204731.1705418-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a subdirectory for PCS drivers. Introduce a new naming
convention for PCS drivers, in that the files should have the prefix
pcs-, and the Kconfig symbols should use the PCS_ prefix. This means
renaming the one such driver that currently exists.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |  2 +-
 drivers/net/phy/Kconfig                       |  8 ++------
 drivers/net/phy/Makefile                      |  4 +---
 drivers/net/phy/pcs/Kconfig                   | 20 +++++++++++++++++++
 drivers/net/phy/pcs/Makefile                  |  4 ++++
 .../net/phy/{mdio-xpcs.c => pcs/pcs-xpcs.c}   |  2 +-
 include/linux/{mdio-xpcs.h => pcs-xpcs.h}     |  8 ++++----
 8 files changed, 34 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/phy/pcs/Kconfig
 create mode 100644 drivers/net/phy/pcs/Makefile
 rename drivers/net/phy/{mdio-xpcs.c => pcs/pcs-xpcs.c} (99%)
 rename include/linux/{mdio-xpcs.h => pcs-xpcs.h} (88%)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 9a47c5aec91a..35e8fd6411e2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -3,7 +3,7 @@ config STMMAC_ETH
 	tristate "STMicroelectronics Multi-Gigabit Ethernet driver"
 	depends on HAS_IOMEM && HAS_DMA
 	select MII
-	select MDIO_XPCS
+	select PCS_XPCS
 	select PAGE_POOL
 	select PHYLINK
 	select CRC32
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 127f75862962..74dc742c9a3b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -15,7 +15,7 @@
 #include <linux/netdevice.h>
 #include <linux/stmmac.h>
 #include <linux/phy.h>
-#include <linux/mdio-xpcs.h>
+#include <linux/pcs-xpcs.h>
 #include <linux/module.h>
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 #define STMMAC_VLAN_TAG_USED
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index a193236fd65a..6ce151b1254d 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -5,12 +5,6 @@
 
 source "drivers/net/phy/mdio/Kconfig"
 
-config MDIO_XPCS
-	tristate "Synopsys DesignWare XPCS controller"
-	help
-	  This module provides helper functions for Synopsys DesignWare XPCS
-	  controllers.
-
 config PHYLINK
 	tristate
 	depends on NETDEVICES
@@ -92,6 +86,8 @@ config XILINX_GMII2RGMII
 
 endif # PHYLIB
 
+source "drivers/net/phy/pcs/Kconfig"
+
 config MICREL_KS8995MA
 	tristate "Micrel KS8995MA 5-ports 10/100 managed Ethernet switch"
 	depends on SPI
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 6bdf04478d34..c5db11f70ccf 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux PHY drivers and MDIO bus drivers
 
-obj-y				+= phy/ mdio/
+obj-y				+= phy/ mdio/ pcs/
 
 libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o \
 				   linkmode.o
@@ -27,8 +27,6 @@ obj-$(CONFIG_PHYLINK)		+= phylink.o
 obj-$(CONFIG_PHYLIB)		+= libphy.o
 obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
 
-obj-$(CONFIG_MDIO_XPCS)		+= mdio-xpcs.o
-
 obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
 
 obj-$(CONFIG_SFP)		+= sfp.o
diff --git a/drivers/net/phy/pcs/Kconfig b/drivers/net/phy/pcs/Kconfig
new file mode 100644
index 000000000000..436b6348f7e8
--- /dev/null
+++ b/drivers/net/phy/pcs/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# PCS driver configuration
+#
+# Please keep this file sorted by sting which apears in menuconfig.
+
+menuconfig PCS_DEVICE
+	tristate "PCS device drivers"
+	help
+	  PCS devices and driver infrastructure code.
+
+if PCS_DEVICE
+
+config PCS_XPCS
+	tristate "Synopsys DesignWare XPCS controller"
+	help
+	  This module provides helper functions for Synopsys DesignWare XPCS
+	  controllers.
+
+endif
diff --git a/drivers/net/phy/pcs/Makefile b/drivers/net/phy/pcs/Makefile
new file mode 100644
index 000000000000..f0480afc7157
--- /dev/null
+++ b/drivers/net/phy/pcs/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for Linux PCS drivers
+
+obj-$(CONFIG_PCS_XPCS)		+= pcs-xpcs.o
diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/phy/pcs/pcs-xpcs.c
similarity index 99%
rename from drivers/net/phy/mdio-xpcs.c
rename to drivers/net/phy/pcs/pcs-xpcs.c
index 0d66a8ba7eb6..2c77b6245279 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/phy/pcs/pcs-xpcs.c
@@ -8,7 +8,7 @@
 
 #include <linux/delay.h>
 #include <linux/mdio.h>
-#include <linux/mdio-xpcs.h>
+#include <linux/pcs-xpcs.h>
 #include <linux/phylink.h>
 #include <linux/workqueue.h>
 
diff --git a/include/linux/mdio-xpcs.h b/include/linux/pcs-xpcs.h
similarity index 88%
rename from include/linux/mdio-xpcs.h
rename to include/linux/pcs-xpcs.h
index 9a841aa5982d..351c1c9aedc5 100644
--- a/include/linux/mdio-xpcs.h
+++ b/include/linux/pcs-xpcs.h
@@ -4,8 +4,8 @@
  * Synopsys DesignWare XPCS helpers
  */
 
-#ifndef __LINUX_MDIO_XPCS_H
-#define __LINUX_MDIO_XPCS_H
+#ifndef __LINUX_PCS_XPCS_H
+#define __LINUX_PCS_XPCS_H
 
 #include <linux/phy.h>
 #include <linux/phylink.h>
@@ -29,7 +29,7 @@ struct mdio_xpcs_ops {
 	int (*probe)(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
 };
 
-#if IS_ENABLED(CONFIG_MDIO_XPCS)
+#if IS_ENABLED(CONFIG_PCS_XPCS)
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
 #else
 static inline struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
@@ -38,4 +38,4 @@ static inline struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
 }
 #endif
 
-#endif /* __LINUX_MDIO_XPCS_H */
+#endif /* __LINUX_PCS_XPCS_H */
-- 
2.28.0.rc0


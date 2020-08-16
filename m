Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612C724590E
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 20:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgHPS4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 14:56:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55312 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbgHPS4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 14:56:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7NpV-009blE-DB; Sun, 16 Aug 2020 20:56:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net-next v2 1/5] net: pcs: Move XPCS into new PCS subdirectory
Date:   Sun, 16 Aug 2020 20:56:07 +0200
Message-Id: <20200816185611.2290056-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200816185611.2290056-1-andrew@lunn.ch>
References: <20200816185611.2290056-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create drivers/net/pcs and move the Synopsys DesignWare XPCS into the
new directory.

Start a naming convention of all PCS files use the prefix pcs-, and
rename the XPCS files to fit.

Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 MAINTAINERS                                   |  5 +++--
 drivers/net/Kconfig                           |  2 ++
 drivers/net/Makefile                          |  1 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |  2 +-
 drivers/net/pcs/Kconfig                       | 20 +++++++++++++++++++
 drivers/net/pcs/Makefile                      |  4 ++++
 .../net/{phy/mdio-xpcs.c => pcs/pcs-xpcs.c}   |  2 +-
 drivers/net/phy/Kconfig                       |  6 ------
 drivers/net/phy/Makefile                      |  1 -
 include/linux/{mdio-xpcs.h => pcs-xpcs.h}     |  8 ++++----
 11 files changed, 37 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/pcs/Kconfig
 create mode 100644 drivers/net/pcs/Makefile
 rename drivers/net/{phy/mdio-xpcs.c => pcs/pcs-xpcs.c} (99%)
 rename include/linux/{mdio-xpcs.h => pcs-xpcs.h} (88%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2843effadff8..b403a1200dd5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6504,6 +6504,7 @@ F:	Documentation/devicetree/bindings/net/ethernet-phy.yaml
 F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
+F:	drivers/net/pcs/
 F:	drivers/net/phy/
 F:	drivers/of/of_mdio.c
 F:	drivers/of/of_net.c
@@ -16679,8 +16680,8 @@ SYNOPSYS DESIGNWARE ETHERNET XPCS DRIVER
 M:	Jose Abreu <Jose.Abreu@synopsys.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	drivers/net/phy/mdio-xpcs.c
-F:	include/linux/mdio-xpcs.h
+F:	drivers/net/pcs/pcs-xpcs.c
+F:	include/linux/pcs-xpcs.h
 
 SYNOPSYS DESIGNWARE I2C DRIVER
 M:	Jarkko Nikula <jarkko.nikula@linux.intel.com>
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 1368d1d6a114..2b07566de78c 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -473,6 +473,8 @@ config NET_SB1000
 
 source "drivers/net/phy/Kconfig"
 
+source "drivers/net/pcs/Kconfig"
+
 source "drivers/net/plip/Kconfig"
 
 source "drivers/net/ppp/Kconfig"
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 94b60800887a..f7402d766b67 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_MDIO) += mdio.o
 obj-$(CONFIG_NET) += Space.o loopback.o
 obj-$(CONFIG_NETCONSOLE) += netconsole.o
 obj-y += phy/
+obj-y += pcs/
 obj-$(CONFIG_RIONET) += rionet.o
 obj-$(CONFIG_NET_TEAM) += team/
 obj-$(CONFIG_TUN) += tun.o
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
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
new file mode 100644
index 000000000000..f81c6446c0fc
--- /dev/null
+++ b/drivers/net/pcs/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# PCS Layer Configuration
+#
+
+menuconfig PCS_DEVICE
+	tristate "PCS device drivers"
+	help
+	  PCS drivers, sitting between the MAC and the PHY
+
+if PCS_DEVICE
+
+config PCS_XPCS
+	tristate "Synopsys DesignWare XPCS controller"
+	select MDIO_BUS
+	help
+	  This module provides helper functions for Synopsys DesignWare XPCS
+	  controllers.
+
+endif
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
new file mode 100644
index 000000000000..f0480afc7157
--- /dev/null
+++ b/drivers/net/pcs/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for Linux PCS drivers
+
+obj-$(CONFIG_PCS_XPCS)		+= pcs-xpcs.o
diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
similarity index 99%
rename from drivers/net/phy/mdio-xpcs.c
rename to drivers/net/pcs/pcs-xpcs.c
index 0d66a8ba7eb6..7ef8bbc68eed 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -7,8 +7,8 @@
  */
 
 #include <linux/delay.h>
+#include <linux/pcs-xpcs.h>
 #include <linux/mdio.h>
-#include <linux/mdio-xpcs.h>
 #include <linux/phylink.h>
 #include <linux/workqueue.h>
 
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 726e4b240e7e..c69cc806f064 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -234,12 +234,6 @@ config MDIO_XGENE
 	  This module provides a driver for the MDIO busses found in the
 	  APM X-Gene SoC's.
 
-config MDIO_XPCS
-	tristate "Synopsys DesignWare XPCS controller"
-	help
-	  This module provides helper functions for Synopsys DesignWare XPCS
-	  controllers.
-
 endif
 endif
 
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index d84bab489a53..7cd8a0d1c0d0 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -47,7 +47,6 @@ obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
 obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
-obj-$(CONFIG_MDIO_XPCS)		+= mdio-xpcs.o
 
 obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
 
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
2.28.0


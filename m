Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE1F253BC7
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 04:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgH0CBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 22:01:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgH0CAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 22:00:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kB7Dc-00C1gM-Jf; Thu, 27 Aug 2020 04:00:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net-next v4 1/5] net: pcs: Move XPCS into new PCS subdirectory
Date:   Thu, 27 Aug 2020 04:00:28 +0200
Message-Id: <20200827020032.2866339-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200827020032.2866339-1-andrew@lunn.ch>
References: <20200827020032.2866339-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create drivers/net/pcs and move the Synopsys DesignWare XPCS into the
new directory. Move the header file into a subdirectory
include/linux/pcs

Start a naming convention of all PCS files use the prefix pcs-, and
rename the XPCS files to fit.

v2:
Add include/linux/pcs

v4:
Fix include path in stmmac.
Remove PCS_DEVICES to avoid new prompts

Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 MAINTAINERS                                     |  5 +++--
 drivers/net/Kconfig                             |  2 ++
 drivers/net/Makefile                            |  1 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig     |  2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h    |  2 +-
 drivers/net/pcs/Kconfig                         | 16 ++++++++++++++++
 drivers/net/pcs/Makefile                        |  4 ++++
 drivers/net/{phy/mdio-xpcs.c => pcs/pcs-xpcs.c} |  2 +-
 drivers/net/phy/Kconfig                         |  6 ------
 drivers/net/phy/Makefile                        |  1 -
 include/linux/{mdio-xpcs.h => pcs/pcs-xpcs.h}   |  8 ++++----
 11 files changed, 33 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/pcs/Kconfig
 create mode 100644 drivers/net/pcs/Makefile
 rename drivers/net/{phy/mdio-xpcs.c => pcs/pcs-xpcs.c} (99%)
 rename include/linux/{mdio-xpcs.h => pcs/pcs-xpcs.h} (88%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 36ec0bd50a8f..347ed6904fdf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6513,6 +6513,7 @@ F:	Documentation/devicetree/bindings/net/ethernet-phy.yaml
 F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
+F:	drivers/net/pcs/
 F:	drivers/net/phy/
 F:	drivers/of/of_mdio.c
 F:	drivers/of/of_net.c
@@ -16730,8 +16731,8 @@ SYNOPSYS DESIGNWARE ETHERNET XPCS DRIVER
 M:	Jose Abreu <Jose.Abreu@synopsys.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	drivers/net/phy/mdio-xpcs.c
-F:	include/linux/mdio-xpcs.h
+F:	drivers/net/pcs/pcs-xpcs.c
+F:	include/linux/pcs/pcs-xpcs.h
 
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
index 7572cea9d59e..53f14c5a9e02 100644
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
index 127f75862962..acc5e3fc1c2f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -15,7 +15,7 @@
 #include <linux/netdevice.h>
 #include <linux/stmmac.h>
 #include <linux/phy.h>
-#include <linux/mdio-xpcs.h>
+#include <linux/pcs/pcs-xpcs.h>
 #include <linux/module.h>
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 #define STMMAC_VLAN_TAG_USED
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
new file mode 100644
index 000000000000..9d6e2be32060
--- /dev/null
+++ b/drivers/net/pcs/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# PCS Layer Configuration
+#
+
+menu "PCS device drivers"
+
+config PCS_XPCS
+	tristate "Synopsys DesignWare XPCS controller"
+	select MDIO_BUS
+	depends on MDIO_DEVICE
+	help
+	  This module provides helper functions for Synopsys DesignWare XPCS
+	  controllers.
+
+endmenu
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
index 0d66a8ba7eb6..1aa9903d602e 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -7,8 +7,8 @@
  */
 
 #include <linux/delay.h>
+#include <linux/pcs/pcs-xpcs.h>
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
 
diff --git a/include/linux/mdio-xpcs.h b/include/linux/pcs/pcs-xpcs.h
similarity index 88%
rename from include/linux/mdio-xpcs.h
rename to include/linux/pcs/pcs-xpcs.h
index 9a841aa5982d..351c1c9aedc5 100644
--- a/include/linux/mdio-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
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


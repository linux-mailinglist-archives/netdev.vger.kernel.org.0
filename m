Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E148D214E8B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgGESbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:31:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47498 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbgGESbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 14:31:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1js9Q3-003itz-EU; Sun, 05 Jul 2020 20:31:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>
Subject: [PATCH net-next 6/7] net: phy: cavium: Improve __iomem mess
Date:   Sun,  5 Jul 2020 20:29:20 +0200
Message-Id: <20200705182921.887441-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705182921.887441-1-andrew@lunn.ch>
References: <20200705182921.887441-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MIPS low level register access functions seem to be missing
__iomem annotation. This cases lots of sparse warnings, when code
casts off the __iomem. Make the Cavium MDIO drivers cleaner by pushing
the casts lower down into the helpers, allow the drivers to work as
normal, with __iomem.

bus->register_base is now an void *, rather than a u64. So forming the
mii_bus->id string cannot use %llx any more. Use %px, so this kernel
address is still exposed to user space, as it was before.

Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Robert Richter <rrichter@marvell.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/mdio-cavium.h  | 14 +++++++-------
 drivers/net/phy/mdio-octeon.c  |  5 ++---
 drivers/net/phy/mdio-thunder.c |  2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
index e33d3ea9a907..a2245d436f5d 100644
--- a/drivers/net/phy/mdio-cavium.h
+++ b/drivers/net/phy/mdio-cavium.h
@@ -90,7 +90,7 @@ union cvmx_smix_wr_dat {
 
 struct cavium_mdiobus {
 	struct mii_bus *mii_bus;
-	u64 register_base;
+	void __iomem *register_base;
 	enum cavium_mdiobus_mode mode;
 };
 
@@ -98,20 +98,20 @@ struct cavium_mdiobus {
 
 #include <asm/octeon/octeon.h>
 
-static inline void oct_mdio_writeq(u64 val, u64 addr)
+static inline void oct_mdio_writeq(u64 val, void __iomem *addr)
 {
-	cvmx_write_csr(addr, val);
+	cvmx_write_csr((u64 __force)addr, val);
 }
 
-static inline u64 oct_mdio_readq(u64 addr)
+static inline u64 oct_mdio_readq(void __iomem *addr)
 {
-	return cvmx_read_csr(addr);
+	return cvmx_read_csr((u64 __force)addr);
 }
 #else
 #include <linux/io-64-nonatomic-lo-hi.h>
 
-#define oct_mdio_writeq(val, addr)	writeq(val, (void *)addr)
-#define oct_mdio_readq(addr)		readq((void *)addr)
+#define oct_mdio_writeq(val, addr)	writeq(val, addr)
+#define oct_mdio_readq(addr)		readq(addr)
 #endif
 
 int cavium_mdiobus_read(struct mii_bus *bus, int phy_id, int regnum);
diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/phy/mdio-octeon.c
index 8327382aa568..a2f93948db97 100644
--- a/drivers/net/phy/mdio-octeon.c
+++ b/drivers/net/phy/mdio-octeon.c
@@ -44,8 +44,7 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	bus->register_base =
-		(u64)devm_ioremap(&pdev->dev, mdio_phys, regsize);
+	bus->register_base = devm_ioremap(&pdev->dev, mdio_phys, regsize);
 	if (!bus->register_base) {
 		dev_err(&pdev->dev, "dev_ioremap failed\n");
 		return -ENOMEM;
@@ -56,7 +55,7 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 
 	bus->mii_bus->name = KBUILD_MODNAME;
-	snprintf(bus->mii_bus->id, MII_BUS_ID_SIZE, "%llx", bus->register_base);
+	snprintf(bus->mii_bus->id, MII_BUS_ID_SIZE, "%px", bus->register_base);
 	bus->mii_bus->parent = &pdev->dev;
 
 	bus->mii_bus->read = cavium_mdiobus_read;
diff --git a/drivers/net/phy/mdio-thunder.c b/drivers/net/phy/mdio-thunder.c
index 2a97938d1972..3d7eda99d34e 100644
--- a/drivers/net/phy/mdio-thunder.c
+++ b/drivers/net/phy/mdio-thunder.c
@@ -84,7 +84,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		nexus->buses[i] = bus;
 		i++;
 
-		bus->register_base = (u64)nexus->bar0 +
+		bus->register_base = nexus->bar0 +
 			r.start - pci_resource_start(pdev, 0);
 
 		smi_en.u64 = 0;
-- 
2.27.0.rc2


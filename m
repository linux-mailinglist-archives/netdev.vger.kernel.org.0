Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8079A1D675A
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 12:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgEQKVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 06:21:11 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:52811 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbgEQKVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 06:21:11 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 0FE7A44004C;
        Sun, 17 May 2020 13:21:07 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [RFC PATCH] drivers: net: mdio_bus: try indirect clause 45 regs access
Date:   Sun, 17 May 2020 13:20:56 +0300
Message-Id: <3e2c01449dc29bc3d138d3a19e0c2220495dd7ed.1589710856.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the MDIO bus does not support directly clause 45 access, fallback
to indirect registers access method to read/write clause 45 registers
using clause 22 registers.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---

Is that the right course?

Currently, this does not really work on the my target machine, which is
using the Armada 385 native MDIO bus (mvmdio) connected to clause 45
Marvell 88E2110 PHY. Registers MDIO_DEVS1 and MDIO_DEVS1 read bogus
values which breaks PHY identification. However, the phytool utility
reads the same registers correctly:

phytool eth1/2:1/5
ieee-phy: reg:0x05 val:0x008a

eth1 is connected to another PHY (clause 22) on the same MDIO bus.

The same hardware works nicely with the mdio-gpio bus implementation,
when mdio pins are muxed as GPIOs.
---
 drivers/net/phy/mdio_bus.c | 12 ++++++++++++
 drivers/net/phy/phy-core.c |  2 +-
 include/linux/phy.h        |  2 ++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7a4eb3f2cb74..12e39f794b29 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -790,6 +790,12 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
 	retval = bus->read(bus, addr, regnum);
+	if (retval == -EOPNOTSUPP && regnum & MII_ADDR_C45) {
+		int c45_devad = (regnum >> 16) & 0x1f;
+
+		mmd_phy_indirect(bus, addr, c45_devad, regnum & 0xfff);
+		retval = bus->read(bus, addr, MII_MMD_DATA);
+	}
 
 	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
 	mdiobus_stats_acct(&bus->stats[addr], true, retval);
@@ -816,6 +822,12 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
 	err = bus->write(bus, addr, regnum, val);
+	if (err == -EOPNOTSUPP && regnum & MII_ADDR_C45) {
+		int c45_devad = (regnum >> 16) & 0x1f;
+
+		mmd_phy_indirect(bus, addr, c45_devad, regnum & 0xfff);
+		err = bus->write(bus, addr, MII_MMD_DATA, val);
+	}
 
 	trace_mdio_access(bus, 0, addr, regnum, val, err);
 	mdiobus_stats_acct(&bus->stats[addr], false, err);
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 66b8c61ca74c..74b8cf8599aa 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -395,7 +395,7 @@ int phy_speed_down_core(struct phy_device *phydev)
 	return __set_linkmode_max_speed(min_common_speed, phydev->advertising);
 }
 
-static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
+void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
 			     u16 regnum)
 {
 	/* Write the desired MMD Devad */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2432ca463ddc..6e7a5fc1906f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -864,6 +864,8 @@ int __phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 		     u16 mask, u16 set);
 int phy_modify_mmd(struct phy_device *phydev, int devad, u32 regnum,
 		   u16 mask, u16 set);
+void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
+		      u16 regnum);
 
 /**
  * __phy_set_bits - Convenience function for setting bits in a PHY register
-- 
2.26.2


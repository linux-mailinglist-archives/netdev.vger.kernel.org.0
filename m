Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D47918177B
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 13:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgCKMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 08:07:40 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53116 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgCKMHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 08:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=T4+cf3zaAyUcUrHSWSzEyuThO4soiBlKHL1jWYoSAlI=; b=ercibkFprFuij+cfMB9o+XN+74
        /w4hfJJPCIsYVTLZSw91xp2ORy17t7TEf3N2jGnTxblU2BAP4163tzLAmByr5y6pa2z0MHWqAgIyC
        WchdrkSsNPL37GgXN58N7NtheVh1Tys5hoodJBSGY+7vWr3jtBGFDXX3OeFRFQuR75nk7gY6IPWNW
        /xoz/GXnY/JiQoX/rYo5TzINTjuFWBdvaQlncBvARujgnGD8+U87Rbo3sQwnOulf0HW3/7hSnSszG
        7anvRe0QeLA5KkAxzu5KUVW43B8RGDMFr4wu607KLvPkZUinD9bE8/vteZKqniQ1QtTRevnQI/Zg1
        Xs7wicTw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44516 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jC096-00037R-ID; Wed, 11 Mar 2020 12:07:32 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jC094-0001cR-QP; Wed, 11 Mar 2020 12:07:30 +0000
In-Reply-To: <20200311120643.GN25745@shell.armlinux.org.uk>
References: <20200311120643.GN25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/5] net: mdiobus: add APIs for modifying a MDIO
 device register
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jC094-0001cR-QP@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Mar 2020 12:07:30 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add APIs for modifying a MDIO device register, similar to the existing
phy_modify() group of functions, but at mdiobus level instead.  Adapt
__phy_modify_changed() to use the new mdiobus level helper.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/mdio_bus.c | 55 ++++++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy-core.c | 31 ---------------------
 include/linux/mdio.h       |  4 +++
 include/linux/phy.h        | 19 +++++++++++++
 4 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 3ab9ca7614d1..b33d1e793686 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -824,6 +824,38 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(__mdiobus_write);
 
+/**
+ * __mdiobus_modify_changed - Unlocked version of the mdiobus_modify function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @regnum: register number to modify
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * Read, modify, and if any change, write the register value back to the
+ * device. Any error returns a negative number.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
+			     u16 mask, u16 set)
+{
+	int new, ret;
+
+	ret = __mdiobus_read(bus, addr, regnum);
+	if (ret < 0)
+		return ret;
+
+	new = (ret & ~mask) | set;
+	if (new == ret)
+		return 0;
+
+	ret = __mdiobus_write(bus, addr, regnum, new);
+
+	return ret < 0 ? ret : 1;
+}
+EXPORT_SYMBOL_GPL(__mdiobus_modify_changed);
+
 /**
  * mdiobus_read_nested - Nested version of the mdiobus_read function
  * @bus: the mii_bus struct
@@ -928,6 +960,29 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(mdiobus_write);
 
+/**
+ * mdiobus_modify - Convenience function for modifying a given mdio device
+ *	register
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @regnum: register number to write
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ */
+int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask, u16 set)
+{
+	int err;
+
+	BUG_ON(in_interrupt());
+
+	mutex_lock(&bus->mdio_lock);
+	err = __mdiobus_modify_changed(bus, addr, regnum, mask, set);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err < 0 ? err : 0;
+}
+EXPORT_SYMBOL_GPL(mdiobus_modify);
+
 /**
  * mdio_bus_match - determine if given MDIO driver supports the given
  *		    MDIO device
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index e083e7a76ada..94cd85b1e49b 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -488,37 +488,6 @@ int phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(phy_write_mmd);
 
-/**
- * __phy_modify_changed() - Convenience function for modifying a PHY register
- * @phydev: a pointer to a &struct phy_device
- * @regnum: register number
- * @mask: bit mask of bits to clear
- * @set: bit mask of bits to set
- *
- * Unlocked helper function which allows a PHY register to be modified as
- * new register value = (old register value & ~mask) | set
- *
- * Returns negative errno, 0 if there was no change, and 1 in case of change
- */
-int __phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
-			 u16 set)
-{
-	int new, ret;
-
-	ret = __phy_read(phydev, regnum);
-	if (ret < 0)
-		return ret;
-
-	new = (ret & ~mask) | set;
-	if (new == ret)
-		return 0;
-
-	ret = __phy_write(phydev, regnum, new);
-
-	return ret < 0 ? ret : 1;
-}
-EXPORT_SYMBOL_GPL(__phy_modify_changed);
-
 /**
  * phy_modify_changed - Function for modifying a PHY register
  * @phydev: the phy_device struct
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index a7604248777b..917e4bb2ed71 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -316,11 +316,15 @@ static inline void mii_10gbt_stat_mod_linkmode_lpa_t(unsigned long *advertising,
 
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
+int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
+			     u16 mask, u16 set);
 
 int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int mdiobus_read_nested(struct mii_bus *bus, int addr, u32 regnum);
 int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
+int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
+		   u16 set);
 
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index e72dbd0d2d6a..d3cd10ed945c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -747,6 +747,25 @@ static inline int __phy_write(struct phy_device *phydev, u32 regnum, u16 val)
 			       val);
 }
 
+/**
+ * __phy_modify_changed() - Convenience function for modifying a PHY register
+ * @phydev: a pointer to a &struct phy_device
+ * @regnum: register number
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * Unlocked helper function which allows a PHY register to be modified as
+ * new register value = (old register value & ~mask) | set
+ *
+ * Returns negative errno, 0 if there was no change, and 1 in case of change
+ */
+static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
+				       u16 mask, u16 set)
+{
+	return __mdiobus_modify_changed(phydev->mdio.bus, phydev->mdio.addr,
+					regnum, mask, set);
+}
+
 /**
  * phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76EB1856BE
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgCOB3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:29:37 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgCOB3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U9+CqnMjzoMZlbJG3opWsiL82RATsUq8/MLxMjLo+UA=; b=S+dgg6RMa38ztXQvgUwq5TmNwY
        w5dMv1dGt1m37gceHkFXElFGHBkXVpRtxtV1ES8nfEnoE4boi4YQnUxl5bHg7lO480aGsqiFPdUxS
        fsqw7nRPjPuLR3umV3cqMGOy4n3Vh8NWdPiBuaD4vAEeMDWeKOQCSr5FKY1ZdbH9vHYxLlt4IImgD
        6ffirY4gjArwUqfj8XPK95PaB8INhMYdKj+6Y9EqZAcoUQEDVjmHpDFje6ViZpyLyDwtal+sCeP9k
        9pWnxqQlgN29rLOLawZCT7aJFAo1V18SBDnLTsJPp3fuDGf4XGyYZt289hQ+uBrULOONyHCpkdq9+
        vYKxIC9w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:41746 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD41a-0006I9-NN; Sat, 14 Mar 2020 10:28:10 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD41a-0006Js-6h; Sat, 14 Mar 2020 10:28:10 +0000
In-Reply-To: <20200314102721.GG25745@shell.armlinux.org.uk>
References: <20200314102721.GG25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/5] net: mdiobus: add APIs for modifying a MDIO
 device register
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jD41a-0006Js-6h@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Mar 2020 10:28:10 +0000
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
index 7a08023bdbc5..c56166487036 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -750,6 +750,25 @@ static inline int __phy_write(struct phy_device *phydev, u32 regnum, u16 val)
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


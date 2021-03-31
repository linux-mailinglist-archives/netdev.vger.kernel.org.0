Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1199350206
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbhCaOSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235758AbhCaOSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 10:18:08 -0400
X-Greylist: delayed 152 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 Mar 2021 07:18:07 PDT
Received: from hs01.dk-develop.de (hs01.dk-develop.de [IPv6:2a02:c207:3002:6234::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FEDC061574;
        Wed, 31 Mar 2021 07:18:07 -0700 (PDT)
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     linux@armlinux.org.uk, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeremy.linton@arm.com,
        Danilo Krummrich <danilokrummrich@dk-develop.de>
Subject: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Date:   Wed, 31 Mar 2021 16:17:55 +0200
Message-Id: <20210331141755.126178-3-danilokrummrich@dk-develop.de>
In-Reply-To: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are still a lot of mdio controllers which don't support the clause
45 frame format as well as drivers for mdio controllers which don't
implement the cause 45 mode of the controller even if natively supported
by the hardware. Therefore it makes sense to support clause 45 peripherals
on busses that support clause 22 transfers only by indirect access.

In order to do so we can use the capabilitiy field of the struct mii_bus
to distinguish between busses that natively support clause 45 and those
who don't. Based on that the mdiobus_c45_*() functions can either issue
a MII_ADDR_C45 flagged request to the bus driver or perform an indirect
access.

The indirect access is performed by the introduced mdiobus_*_mmd()
functions. While performing the indirect access sequence in
mdiobus_indirect_mmd() we check for potential errors occurring in the
sequence, which was not done previously and just assumed to be
successful.

Signed-off-by: Danilo Krummrich <danilokrummrich@dk-develop.de>
---
 drivers/net/phy/mdio_bus.c | 265 ++++++++++++++++++++++++++++++++++++-
 drivers/net/phy/phy-core.c |  46 ++-----
 drivers/net/phy/phy.c      |  19 ++-
 include/linux/mdio.h       |  36 ++---
 4 files changed, 298 insertions(+), 68 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index d03e40a0fbae..c80ed65666ac 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -670,19 +670,21 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 	struct phy_device *phydev = ERR_PTR(-ENODEV);
 	int err;
 
+	/* In case of NO_CAP and C22 only, we still can try to scan for C45
+	 * devices, since indirect access will be used for busses that are not
+	 * capable of C45 frame format.
+	 */
 	switch (bus->capabilities) {
 	case MDIOBUS_NO_CAP:
 	case MDIOBUS_C22:
-		phydev = get_phy_device(bus, addr, false);
-		break;
-	case MDIOBUS_C45:
-		phydev = get_phy_device(bus, addr, true);
-		break;
 	case MDIOBUS_C22_C45:
 		phydev = get_phy_device(bus, addr, false);
 		if (IS_ERR(phydev))
 			phydev = get_phy_device(bus, addr, true);
 		break;
+	case MDIOBUS_C45:
+		phydev = get_phy_device(bus, addr, true);
+		break;
 	}
 
 	if (IS_ERR(phydev))
@@ -903,6 +905,259 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(mdiobus_write);
 
+/**
+ * mdiobus_indirect_mmd - Prepares MMD indirect access
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: the device address
+ * @regnum: register number to read
+ *
+ * Prepares indirect MMD access, such that only the MII_MMD_DATA register is
+ * left to be read or written. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+static int mdiobus_indirect_mmd(struct mii_bus *bus, int addr, u16 devad, u32 regnum)
+{
+	int err;
+
+	/* Write the desired MMD Devad */
+	err = __mdiobus_write(bus, addr, MII_MMD_CTRL, devad);
+	if (err)
+		goto out;
+
+	/* Write the desired MMD register address */
+	err = __mdiobus_write(bus, addr, MII_MMD_DATA, regnum);
+	if (err)
+		goto out;
+
+	/* Select the Function : DATA with no post increment */
+	err = __mdiobus_write(bus, addr, MII_MMD_CTRL,
+			      devad | MII_MMD_CTRL_NOINCR);
+
+out:
+	return err;
+}
+
+/**
+ * __mdiobus_read_mmd - Unlocked version of the mdiobus_read_mmd function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: the device address
+ * @regnum: register number to read
+ *
+ * Read a MDIO bus register. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_read_mmd(struct mii_bus *bus, int addr, u16 devad, u32 regnum)
+{
+	int retval;
+
+	retval = mdiobus_indirect_mmd(bus, addr, devad, regnum);
+	if (retval)
+		goto out;
+
+	/* Read the content of the MMD's selected register */
+	retval = __mdiobus_read(bus, addr, MII_MMD_DATA);
+
+out:
+	return retval;
+}
+EXPORT_SYMBOL(__mdiobus_read_mmd);
+
+/**
+ * __mdiobus_write_mmd - Unlocked version of the mdiobus_write_mmd function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: the device address
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * Write a MDIO bus register. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_write_mmd(struct mii_bus *bus, int addr, u16 devad, u32 regnum,
+			u16 val)
+{
+	int err;
+
+	err = mdiobus_indirect_mmd(bus, addr, devad, regnum);
+	if (err)
+		goto out;
+
+	/* Write the data into MMD's selected register */
+	err = __mdiobus_write(bus, addr, MII_MMD_DATA, val);
+
+out:
+	return err;
+}
+EXPORT_SYMBOL(__mdiobus_write_mmd);
+
+/**
+ * mdiobus_read_mmd - Convenience function for indirect MMD reads
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: the device address
+ * @regnum: register number to read
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_read_mmd(struct mii_bus *bus, int addr, u16 devad, u32 regnum)
+{
+	int retval;
+
+	mutex_lock(&bus->mdio_lock);
+	retval = __mdiobus_read_mmd(bus, addr, devad, regnum);
+	mutex_unlock(&bus->mdio_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(mdiobus_read_mmd);
+
+/**
+ * mdiobus_write_mmd - Convenience function for indirect MMD writes
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: the device address
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_write_mmd(struct mii_bus *bus, int addr, u16 devad, u32 regnum,
+		      u16 val)
+{
+	int err;
+
+	mutex_lock(&bus->mdio_lock);
+	err = __mdiobus_write_mmd(bus, addr, devad, regnum, val);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(mdiobus_write_mmd);
+
+/**
+ * __mdiobus_c45_read - Unlocked version of the mdiobus_c45_read function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: the device address
+ * @regnum: register number to read
+ *
+ * Read a MDIO bus register. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum)
+{
+	int ret = -EOPNOTSUPP;
+
+	switch (bus->capabilities) {
+	case MDIOBUS_NO_CAP:
+	case MDIOBUS_C22:
+		ret =  __mdiobus_read_mmd(bus, addr, devad, regnum);
+		break;
+	case MDIOBUS_C45:
+	case MDIOBUS_C22_C45:
+		ret =  __mdiobus_read(bus, addr,
+				      mdiobus_c45_addr(devad, regnum));
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(__mdiobus_c45_read);
+
+/**
+ * __mdiobus_c45_write - Unlocked version of the mdiobus_c45_write function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: the device address
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * Write a MDIO bus register. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_c45_write(struct mii_bus *bus, int addr, int devad, u32 regnum,
+			u16 val)
+{
+	int ret = -EOPNOTSUPP;
+
+	switch (bus->capabilities) {
+	case MDIOBUS_NO_CAP:
+	case MDIOBUS_C22:
+		ret = __mdiobus_write_mmd(bus, addr, devad, regnum, val);
+		break;
+	case MDIOBUS_C45:
+	case MDIOBUS_C22_C45:
+		ret = __mdiobus_write(bus, addr,
+				      mdiobus_c45_addr(devad, regnum), val);
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(__mdiobus_c45_write);
+
+/**
+ * mdiobus_c45_read - Convenience function for clause 45 reads
+ * The read is either performed by clause 45 frame format or by an indirect
+ * access, depending on the capabilities of the bus.
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: the device address
+ * @regnum: register number to read
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum)
+{
+	int retval;
+
+	mutex_lock(&bus->mdio_lock);
+	retval = __mdiobus_c45_read(bus, addr, devad, regnum);
+	mutex_unlock(&bus->mdio_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(mdiobus_c45_read);
+
+/**
+ * mdiobus_c45_write - Convenience function for clause 45 writes
+ * The write is either performed by clause 45 frame format or by an indirect
+ * access, depending on the capabilities of the bus.
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: the device address
+ * @regnum: register number to read
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_c45_write(struct mii_bus *bus, int addr, int devad, u32 regnum,
+		      u16 val)
+{
+	int err;
+
+	mutex_lock(&bus->mdio_lock);
+	err = __mdiobus_c45_write(bus, addr, devad, regnum, val);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(mdiobus_c45_write);
+
 /**
  * mdiobus_modify - Convenience function for modifying a given mdio device
  *	register
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 8d333d3084ed..5f1601e12162 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -442,20 +442,6 @@ int phy_speed_down_core(struct phy_device *phydev)
 	return __set_linkmode_max_speed(min_common_speed, phydev->advertising);
 }
 
-static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
-			     u16 regnum)
-{
-	/* Write the desired MMD Devad */
-	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL, devad);
-
-	/* Write the desired MMD register address */
-	__mdiobus_write(bus, phy_addr, MII_MMD_DATA, regnum);
-
-	/* Select the Function : DATA with no post increment */
-	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL,
-			devad | MII_MMD_CTRL_NOINCR);
-}
-
 /**
  * __phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
@@ -472,20 +458,15 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 	if (regnum > (u16)~0 || devad > 32)
 		return -EINVAL;
 
-	if (phydev->drv && phydev->drv->read_mmd) {
+	if (phydev->drv && phydev->drv->read_mmd)
 		val = phydev->drv->read_mmd(phydev, devad, regnum);
-	} else if (phydev->is_c45) {
+	else if (phydev->is_c45)
 		val = __mdiobus_c45_read(phydev->mdio.bus, phydev->mdio.addr,
 					 devad, regnum);
-	} else {
-		struct mii_bus *bus = phydev->mdio.bus;
-		int phy_addr = phydev->mdio.addr;
-
-		mmd_phy_indirect(bus, phy_addr, devad, regnum);
+	else
+		val = __mdiobus_read_mmd(phydev->mdio.bus, phydev->mdio.addr,
+					 devad, regnum);
 
-		/* Read the content of the MMD's selected register */
-		val = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
-	}
 	return val;
 }
 EXPORT_SYMBOL(__phy_read_mmd);
@@ -528,22 +509,15 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 	if (regnum > (u16)~0 || devad > 32)
 		return -EINVAL;
 
-	if (phydev->drv && phydev->drv->write_mmd) {
+	if (phydev->drv && phydev->drv->write_mmd)
 		ret = phydev->drv->write_mmd(phydev, devad, regnum, val);
-	} else if (phydev->is_c45) {
+	else if (phydev->is_c45)
 		ret = __mdiobus_c45_write(phydev->mdio.bus, phydev->mdio.addr,
 					  devad, regnum, val);
-	} else {
-		struct mii_bus *bus = phydev->mdio.bus;
-		int phy_addr = phydev->mdio.addr;
-
-		mmd_phy_indirect(bus, phy_addr, devad, regnum);
-
-		/* Write the data into MMD's selected register */
-		__mdiobus_write(bus, phy_addr, MII_MMD_DATA, val);
+	else
+		ret = __mdiobus_write_mmd(phydev->mdio.bus, phydev->mdio.addr,
+					  devad, regnum, val);
 
-		ret = 0;
-	}
 	return ret;
 }
 EXPORT_SYMBOL(__phy_write_mmd);
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index fc2e7cb5b2e5..fb07832f378a 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -346,20 +346,23 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
 			prtad = mdio_phy_id_prtad(mii_data->phy_id);
 			devad = mdio_phy_id_devad(mii_data->phy_id);
-			devad = mdiobus_c45_addr(devad, mii_data->reg_num);
+
+			mii_data->val_out = mdiobus_c45_read(phydev->mdio.bus,
+							     prtad, devad,
+							     mii_data->reg_num);
 		} else {
 			prtad = mii_data->phy_id;
 			devad = mii_data->reg_num;
+
+			mii_data->val_out = mdiobus_read(phydev->mdio.bus,
+							 prtad, devad);
 		}
-		mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
-						 devad);
 		return 0;
 
 	case SIOCSMIIREG:
 		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
 			prtad = mdio_phy_id_prtad(mii_data->phy_id);
 			devad = mdio_phy_id_devad(mii_data->phy_id);
-			devad = mdiobus_c45_addr(devad, mii_data->reg_num);
 		} else {
 			prtad = mii_data->phy_id;
 			devad = mii_data->reg_num;
@@ -403,7 +406,13 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 			}
 		}
 
-		mdiobus_write(phydev->mdio.bus, prtad, devad, val);
+		if (mdio_phy_id_is_c45(mii_data->phy_id))
+			mii_data->val_out = mdiobus_c45_write(phydev->mdio.bus,
+							      prtad, devad,
+							      mii_data->reg_num,
+							      val);
+		else
+			mdiobus_write(phydev->mdio.bus, prtad, devad, val);
 
 		if (prtad == phydev->mdio.addr &&
 		    devad == MII_BMCR &&
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index ffb787d5ebde..7bcd76914154 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -347,35 +347,27 @@ int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 		   u16 set);
 
+int __mdiobus_read_mmd(struct mii_bus *bus, int addr, u16 devad, u32 regnum);
+int __mdiobus_write_mmd(struct mii_bus *bus, int addr, u16 devad, u32 regnum,
+			u16 val);
+
+int mdiobus_read_mmd(struct mii_bus *bus, int addr, u16 devad, u32 regnum);
+int mdiobus_write_mmd(struct mii_bus *bus, int addr, u16 devad, u32 regnum,
+		      u16 val);
+
 static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
 {
 	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
 }
 
-static inline int __mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
-				     u16 regnum)
-{
-	return __mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
-}
+int __mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum);
+int __mdiobus_c45_write(struct mii_bus *bus, int addr, int devad, u32 regnum,
+			u16 val);
 
-static inline int __mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
-				      u16 regnum, u16 val)
-{
-	return __mdiobus_write(bus, prtad, mdiobus_c45_addr(devad, regnum),
-			       val);
-}
+int mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum);
 
-static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
-				   u16 regnum)
-{
-	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
-}
-
-static inline int mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
-				    u16 regnum, u16 val)
-{
-	return mdiobus_write(bus, prtad, mdiobus_c45_addr(devad, regnum), val);
-}
+int mdiobus_c45_write(struct mii_bus *bus, int addr, int devad, u32 regnum,
+		      u16 val);
 
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
-- 
2.31.0


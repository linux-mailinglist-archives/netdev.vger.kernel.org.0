Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20E051EE9C
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbiEHPfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbiEHPfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714C2E03F
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pE2DaKok91+5xBviW/S3pxXjM6UV8Qcfg1ndB6av3mY=; b=JAbV1JYom+n93x/U53C8YaPwJR
        cikONhONX/hKwEucgCjSIMpn+YfVFXot/6+JFVLBbENEipmOrMZ16DYXAAf/vAiIXQmfJ+eo0NHXz
        WpCflHk04CdrukCGdMOc7vu11cxtZylfz/9OHkOOeeqqUIj5NElpnfAL+f1l+RcCYNjo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisJ-001n9e-0n; Sun, 08 May 2022 17:31:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: [PATCH net-next 01/10] net: mdio: Add dedicated C45 API to MDIO bus drivers
Date:   Sun,  8 May 2022 17:30:40 +0200
Message-Id: <20220508153049.427227-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220508153049.427227-1-andrew@lunn.ch>
References: <20220508153049.427227-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently C22 and C45 transactions are mixed over a combined API calls
which make use of a special bit in the reg address to indicate if a
C45 transaction should be performed. This makes it impossible to know
if the bus driver actually supports C45. Additionally, many C22 only
drivers don't return -EOPNOTSUPP when asked to perform a C45
transaction, they mistaking perform a C22 transaction.

This is the first step to cleanly separate C22 from C45. To maintain
backwards compatibility until all drivers which are capable of
performing C45 are converted to this new API, the helper functions
will fall back to the older API if the new API is not
supported. Eventually this fallback will be removed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/mdio_bus.c | 166 +++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  33 ++------
 include/linux/phy.h        |   5 ++
 3 files changed, 179 insertions(+), 25 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 58d602985877..46a03c0b45e3 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -826,6 +826,100 @@ int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 }
 EXPORT_SYMBOL_GPL(__mdiobus_modify_changed);
 
+/**
+ * __mdiobus_c45_read - Unlocked version of the mdiobus_c45_read function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to read
+ *
+ * Read a MDIO bus register. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum)
+{
+	int retval;
+
+	lockdep_assert_held_once(&bus->mdio_lock);
+
+	if (bus->read_c45)
+		retval = bus->read_c45(bus, addr, devad, regnum);
+	else
+		retval = bus->read(bus, addr, mdiobus_c45_addr(devad, regnum));
+
+	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
+	mdiobus_stats_acct(&bus->stats[addr], true, retval);
+
+	return retval;
+}
+EXPORT_SYMBOL(__mdiobus_c45_read);
+
+/**
+ * __mdiobus_c45_write - Unlocked version of the mdiobus_write function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
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
+	int err;
+
+	lockdep_assert_held_once(&bus->mdio_lock);
+
+	if (bus->write_c45)
+		err = bus->write_c45(bus, addr, devad, regnum, val);
+	else
+		err = bus->write(bus, addr, mdiobus_c45_addr(devad, regnum),
+				 val);
+
+	trace_mdio_access(bus, 0, addr, regnum, val, err);
+	mdiobus_stats_acct(&bus->stats[addr], false, err);
+
+	return err;
+}
+EXPORT_SYMBOL(__mdiobus_c45_write);
+
+/**
+ * __mdiobus_c45_modify_changed - Unlocked version of the mdiobus_modify function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to modify
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * Read, modify, and if any change, write the register value back to the
+ * device. Any error returns a negative number.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+static int __mdiobus_c45_modify_changed(struct mii_bus *bus, int addr,
+					int devad, u32 regnum, u16 mask,
+					u16 set)
+{
+	int new, ret;
+
+	ret = __mdiobus_c45_read(bus, addr, devad, regnum);
+	if (ret < 0)
+		return ret;
+
+	new = (ret & ~mask) | set;
+	if (new == ret)
+		return 0;
+
+	ret = __mdiobus_c45_write(bus, addr, devad, regnum, new);
+
+	return ret < 0 ? ret : 1;
+}
+
 /**
  * mdiobus_read_nested - Nested version of the mdiobus_read function
  * @bus: the mii_bus struct
@@ -873,6 +967,29 @@ int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 }
 EXPORT_SYMBOL(mdiobus_read);
 
+/**
+ * mdiobus_c45_read - Convenience function for reading a given MII mgmt register
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
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
 /**
  * mdiobus_write_nested - Nested version of the mdiobus_write function
  * @bus: the mii_bus struct
@@ -922,6 +1039,31 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(mdiobus_write);
 
+/**
+ * mdiobus_c45_write - Convenience function for writing a given MII mgmt register
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to write
+ * @val: value to write to @regnum
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
@@ -943,6 +1085,30 @@ int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask, u16 set)
 }
 EXPORT_SYMBOL_GPL(mdiobus_modify);
 
+/**
+ * mdiobus_c45_modify - Convenience function for modifying a given mdio device
+ *	register
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to write
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ */
+int mdiobus_c45_modify(struct mii_bus *bus, int addr, int devad, u32 regnum,
+		       u16 mask, u16 set)
+{
+	int err;
+
+	mutex_lock(&bus->mdio_lock);
+	err = __mdiobus_c45_modify_changed(bus, addr, devad, regnum,
+					   mask, set);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err < 0 ? err : 0;
+}
+EXPORT_SYMBOL_GPL(mdiobus_c45_modify);
+
 /**
  * mdiobus_modify_changed - Convenience function for modifying a given mdio
  *	device register and returning if it changed
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 00177567cfef..d89b0879692e 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -423,6 +423,14 @@ int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 		   u16 set);
 int mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 			   u16 mask, u16 set);
+int __mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum);
+int mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum);
+int __mdiobus_c45_write(struct mii_bus *bus, int addr,  int devad, u32 regnum,
+			u16 val);
+int mdiobus_c45_write(struct mii_bus *bus, int addr,  int devad, u32 regnum,
+		      u16 val);
+int mdiobus_c45_modify(struct mii_bus *bus, int addr, int devad, u32 regnum,
+		       u16 mask, u16 set);
 
 static inline int mdiodev_read(struct mdio_device *mdiodev, u32 regnum)
 {
@@ -463,31 +471,6 @@ static inline u16 mdiobus_c45_devad(u32 regnum)
 	return FIELD_GET(MII_DEVADDR_C45_MASK, regnum);
 }
 
-static inline int __mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
-				     u16 regnum)
-{
-	return __mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
-}
-
-static inline int __mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
-				      u16 regnum, u16 val)
-{
-	return __mdiobus_write(bus, prtad, mdiobus_c45_addr(devad, regnum),
-			       val);
-}
-
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
-
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2d12054932ba..895b2bfae688 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -357,6 +357,11 @@ struct mii_bus {
 	int (*read)(struct mii_bus *bus, int addr, int regnum);
 	/** @write: Perform a write transfer on the bus */
 	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
+	/** @read: Perform a C45 read transfer on the bus */
+	int (*read_c45)(struct mii_bus *bus, int addr, int devnum, int regnum);
+	/** @write: Perform a C45 write transfer on the bus */
+	int (*write_c45)(struct mii_bus *bus, int addr, int devnum,
+			 int regnum, u16 val);
 	/** @reset: Perform a reset of the bus */
 	int (*reset)(struct mii_bus *bus);
 
-- 
2.36.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E39124D94
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfLRQ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:29:39 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46975 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfLRQ3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:29:39 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihcCg-0007nw-1w; Wed, 18 Dec 2019 17:29:38 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihcCf-0002rs-00; Wed, 18 Dec 2019 17:29:37 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH] mdio-bitbang: add support for lowlevel mdio read/write
Date:   Wed, 18 Dec 2019 17:29:19 +0100
Message-Id: <20191218162919.5293-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191107154201.GF7344@lunn.ch>
References: <20191107154201.GF7344@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some phys support special opcode handling when communicating via mdio.
This patch introduces mdio_ll_read/write which makes it possible to set
the opcode. It implements these functions in the gpio-bitbang driver,
which is capable of setting the opcode on read and write.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
Hi Andrew,

I worked on your suggestion moving the proprietary call to
mdio-ksz88x3.c which does not seem to work out very well.
I still end up having an MII_ADDR_SMI???? define in linux/phy.h.

Instead of having to support this special case in one extra file
what do you think of adding mdiobus_lowlevel_write/read to mdio_bus.
This way it would be possible to add the opcode directly as user.

Other controllers which have the possibility to set the op code in hardware
will also profit from that and can implement these functions.

Regards,
Michael

 drivers/net/phy/mdio-bitbang.c |  41 +++++++++---
 drivers/net/phy/mdio_bus.c     | 110 +++++++++++++++++++++++++++++++++
 include/linux/mdio.h           |   6 ++
 include/linux/phy.h            |   3 +
 4 files changed, 150 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
index 5136275c8e739..77fbc7eaadf51 100644
--- a/drivers/net/phy/mdio-bitbang.c
+++ b/drivers/net/phy/mdio-bitbang.c
@@ -149,16 +149,12 @@ static int mdiobb_cmd_addr(struct mdiobb_ctrl *ctrl, int phy, u32 addr)
 	return dev_addr;
 }
 
-static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
+static int mdiobb_ll_read(struct mii_bus *bus, int op, int phy, int reg)
 {
 	struct mdiobb_ctrl *ctrl = bus->priv;
 	int ret, i;
 
-	if (reg & MII_ADDR_C45) {
-		reg = mdiobb_cmd_addr(ctrl, phy, reg);
-		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
-	} else
-		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
+	mdiobb_cmd(ctrl, op, phy, reg);
 
 	ctrl->ops->set_mdio_dir(ctrl, 0);
 
@@ -181,15 +177,25 @@ static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 	return ret;
 }
 
-static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
+static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 {
 	struct mdiobb_ctrl *ctrl = bus->priv;
+	int op = MDIO_READ;
 
 	if (reg & MII_ADDR_C45) {
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
-		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
-	} else
-		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
+		op = MDIO_C45_READ;
+	}
+
+	return mdiobb_ll_read(bus, op, phy, reg);
+}
+
+static int mdiobb_ll_write(struct mii_bus *bus, int op, int phy,
+			   int reg, u16 val)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
+
+	mdiobb_cmd(ctrl, op, phy, reg);
 
 	/* send the turnaround (10) */
 	mdiobb_send_bit(ctrl, 1);
@@ -202,6 +208,19 @@ static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
 	return 0;
 }
 
+static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
+	int op = MDIO_WRITE;
+
+	if (reg & MII_ADDR_C45) {
+		reg = mdiobb_cmd_addr(ctrl, phy, reg);
+		op = MDIO_C45_WRITE;
+	}
+
+	return mdiobb_ll_write(bus, op, phy, reg, val);
+}
+
 struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
 {
 	struct mii_bus *bus;
@@ -213,7 +232,9 @@ struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
 	__module_get(ctrl->ops->owner);
 
 	bus->read = mdiobb_read;
+	bus->ll_read = mdiobb_ll_read;
 	bus->write = mdiobb_write;
+	bus->ll_write = mdiobb_ll_write;
 	bus->priv = ctrl;
 
 	return bus;
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 229e480179ff1..57f4b7b9ce39a 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -560,6 +560,34 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 }
 EXPORT_SYMBOL(__mdiobus_read);
 
+/**
+ * __mdiobus_ll_read - Unlocked version of the mdiobus_read function
+ * @bus: the mii_bus struct
+ * @op: opcode to use on transfer
+ * @addr: the phy address
+ * @regnum: register number to read
+ *
+ * Read a MDIO bus register. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_ll_read(struct mii_bus *bus, int op, int addr, u32 regnum)
+{
+	int retval;
+
+	if (!bus->ll_write)
+		return -ENODEV;
+
+	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
+
+	retval = bus->ll_read(bus, op, addr, regnum);
+
+	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
+
+	return retval;
+}
+EXPORT_SYMBOL(__mdiobus_ll_read);
+
 /**
  * __mdiobus_write - Unlocked version of the mdiobus_write function
  * @bus: the mii_bus struct
@@ -585,6 +613,36 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(__mdiobus_write);
 
+/**
+ * __mdiobus_ll_write - Unlocked version of the mdiobus_write function
+ * @bus: the mii_bus struct
+ * @op: opcode to use on transfer
+ * @addr: the phy address
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * Write a MDIO bus register. Caller must hold the mdio bus lock.
+ *
+ * NOTE: MUST NOT be called from interrupt context.
+ */
+int __mdiobus_ll_write(struct mii_bus *bus, int op, int addr,
+		       u32 regnum, u16 val)
+{
+	int err;
+
+	if (!bus->ll_write)
+		return -ENODEV;
+
+	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
+
+	err = bus->ll_write(bus, op, addr, regnum, val);
+
+	trace_mdio_access(bus, 0, addr, regnum, val, err);
+
+	return err;
+}
+EXPORT_SYMBOL(__mdiobus_ll_write);
+
 /**
  * mdiobus_read_nested - Nested version of the mdiobus_read function
  * @bus: the mii_bus struct
@@ -636,6 +694,31 @@ int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 }
 EXPORT_SYMBOL(mdiobus_read);
 
+/**
+ * mdiobus_ll_read - Convenience function for reading a given MII mgmt register
+ * @bus: the mii_bus struct
+ * @op: opcode to use on transfer
+ * @addr: the phy address
+ * @regnum: register number to read
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_ll_read(struct mii_bus *bus, int op, int addr, u32 regnum)
+{
+	int retval;
+
+	BUG_ON(in_interrupt());
+
+	mutex_lock(&bus->mdio_lock);
+	retval = __mdiobus_ll_read(bus, op, addr, regnum);
+	mutex_unlock(&bus->mdio_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(mdiobus_ll_read);
+
 /**
  * mdiobus_write_nested - Nested version of the mdiobus_write function
  * @bus: the mii_bus struct
@@ -689,6 +772,33 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 }
 EXPORT_SYMBOL(mdiobus_write);
 
+/**
+ * mdiobus_ll_write - Convenience function for writing a given MII mgmt register
+ * @bus: the mii_bus struct
+ * @op: opcode to use on transfer
+ * @addr: the phy address
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_ll_write(struct mii_bus *bus, int op, int addr,
+		     u32 regnum, u16 val)
+{
+	int err;
+
+	BUG_ON(in_interrupt());
+
+	mutex_lock(&bus->mdio_lock);
+	err = __mdiobus_ll_write(bus, op, addr, regnum, val);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(mdiobus_ll_write);
+
 /**
  * mdio_bus_match - determine if given MDIO driver supports the given
  *		    MDIO device
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index a7604248777b7..aafd24eb6d393 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -315,11 +315,17 @@ static inline void mii_10gbt_stat_mod_linkmode_lpa_t(unsigned long *advertising,
 }
 
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
+int __mdiobus_ll_read(struct mii_bus *bus, int op, int addr, u32 regnum);
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
+int __mdiobus_ll_write(struct mii_bus *bus, int op, int addr,
+		       u32 regnum, u16 val);
 
 int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
+int mdiobus_ll_read(struct mii_bus *bus, int op, int addr, u32 regnum);
 int mdiobus_read_nested(struct mii_bus *bus, int addr, u32 regnum);
 int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
+int mdiobus_ll_write(struct mii_bus *bus, int op, int addr,
+		     u32 regnum, u16 val);
 int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 
 int mdiobus_register_device(struct mdio_device *mdiodev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5032d453ac66a..3bb802cb03a8a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -218,6 +218,9 @@ struct mii_bus {
 	void *priv;
 	int (*read)(struct mii_bus *bus, int addr, int regnum);
 	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
+	int (*ll_read)(struct mii_bus *bus, int op, int addr, int regnum);
+	int (*ll_write)(struct mii_bus *bus, int op, int addr,
+			int regnum, u16 val);
 	int (*reset)(struct mii_bus *bus);
 
 	/*
-- 
2.24.0


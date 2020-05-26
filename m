Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75981E2574
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgEZP3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgEZP3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:29:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C22CC03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cC34JE3PMg3gcgzzBPdPiDLpBdgPeLfaEKUwJzlgzeY=; b=jdkOFBKOxd3KD5W7rxKTMKAlbf
        BoLs7rA6g4bfs7F4F2AfU2ZbUFEXR49d9c0KV/FH//NFIJu0DMrr3wibrl7uvw6UncR8l8kSmB2DP
        ad7jboYUVFu68j3llELvFRkr+9rr4ckluKUAbhiIAyHbWCQKWxPaRhugj2yR9BVdDVV2TQHpS8AY5
        3AGfQV9/USDdTR4xEOrvcdzYsCtkPyuN0cuTkj3w5fC4JDAo0zI8nR+igspLmHt5SSQIbjIWZnScu
        6koxstz3ggc5TpycI296Zwi6nxkJlKj+zBADdiBbDbzE0jJRVPoM15SQGWm2Q9BDJMfKANOmLl6Sr
        X8uSWsFg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:48230 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdbWL-0008Ah-EI; Tue, 26 May 2020 16:29:37 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdbWK-00083w-Ot; Tue, 26 May 2020 16:29:36 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH net-next] net: mdiobus: add clause 45 mdiobus accessors
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdbWK-00083w-Ot@rmk-PC.armlinux.org.uk>
Date:   Tue, 26 May 2020 16:29:36 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a recurring pattern throughout some of the PHY code converting
a devad and regnum to our packed clause 45 representation. Rather than
having this scattered around the code, let's put a common translation
function in mdio.h, and provide some register accessors.

Convert the phylib core, phylink, bcm87xx and cortina to use these.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/bcm87xx.c    |  2 +-
 drivers/net/phy/cortina.c    |  3 +--
 drivers/net/phy/phy-core.c   | 11 ++++-------
 drivers/net/phy/phy.c        |  4 ++--
 drivers/net/phy/phy_device.c | 20 ++++++++------------
 drivers/net/phy/phylink.c    | 11 +++++------
 include/linux/mdio.h         | 31 +++++++++++++++++++++++++++++++
 include/linux/phy.h          |  6 ------
 8 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
index f6dce6850850..df360e1c5069 100644
--- a/drivers/net/phy/bcm87xx.c
+++ b/drivers/net/phy/bcm87xx.c
@@ -55,7 +55,7 @@ static int bcm87xx_of_reg_init(struct phy_device *phydev)
 		u16 mask	= be32_to_cpup(paddr++);
 		u16 val_bits	= be32_to_cpup(paddr++);
 		int val;
-		u32 regnum = MII_ADDR_C45 | (devid << 16) | reg;
+		u32 regnum = mdiobus_c45_addr(devid, reg);
 		val = 0;
 		if (mask) {
 			val = phy_read(phydev, regnum);
diff --git a/drivers/net/phy/cortina.c b/drivers/net/phy/cortina.c
index aac51362c0fe..40514a94e6ff 100644
--- a/drivers/net/phy/cortina.c
+++ b/drivers/net/phy/cortina.c
@@ -17,8 +17,7 @@
 
 static int cortina_read_reg(struct phy_device *phydev, u16 regnum)
 {
-	return mdiobus_read(phydev->mdio.bus, phydev->mdio.addr,
-			    MII_ADDR_C45 | regnum);
+	return mdiobus_c45_read(phydev->mdio.bus, phydev->mdio.addr, 0, regnum);
 }
 
 static int cortina_read_status(struct phy_device *phydev)
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 66b8c61ca74c..46bd68e9ecfa 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -428,9 +428,8 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 	if (phydev->drv && phydev->drv->read_mmd) {
 		val = phydev->drv->read_mmd(phydev, devad, regnum);
 	} else if (phydev->is_c45) {
-		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
-
-		val = __mdiobus_read(phydev->mdio.bus, phydev->mdio.addr, addr);
+		val = __mdiobus_c45_read(phydev->mdio.bus, phydev->mdio.addr,
+					 devad, regnum);
 	} else {
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
@@ -485,10 +484,8 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 	if (phydev->drv && phydev->drv->write_mmd) {
 		ret = phydev->drv->write_mmd(phydev, devad, regnum, val);
 	} else if (phydev->is_c45) {
-		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
-
-		ret = __mdiobus_write(phydev->mdio.bus, phydev->mdio.addr,
-				      addr, val);
+		ret = __mdiobus_c45_write(phydev->mdio.bus, phydev->mdio.addr,
+					  devad, regnum, val);
 	} else {
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d584701187db..27da0c94818f 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -361,7 +361,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
 			prtad = mdio_phy_id_prtad(mii_data->phy_id);
 			devad = mdio_phy_id_devad(mii_data->phy_id);
-			devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
+			devad = mdiobus_c45_addr(devad, mii_data->reg_num);
 		} else {
 			prtad = mii_data->phy_id;
 			devad = mii_data->reg_num;
@@ -374,7 +374,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
 			prtad = mdio_phy_id_prtad(mii_data->phy_id);
 			devad = mdio_phy_id_devad(mii_data->phy_id);
-			devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
+			devad = mdiobus_c45_addr(devad, mii_data->reg_num);
 		} else {
 			prtad = mii_data->phy_id;
 			devad = mii_data->reg_num;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6b30d205642f..04946de74fa0 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -675,16 +675,14 @@ EXPORT_SYMBOL(phy_device_create);
 static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
 				   u32 *devices_in_package)
 {
-	int phy_reg, reg_addr;
+	int phy_reg;
 
-	reg_addr = MII_ADDR_C45 | dev_addr << 16 | MDIO_DEVS2;
-	phy_reg = mdiobus_read(bus, addr, reg_addr);
+	phy_reg = mdiobus_c45_read(bus, addr, dev_addr, MDIO_DEVS2);
 	if (phy_reg < 0)
 		return -EIO;
 	*devices_in_package = phy_reg << 16;
 
-	reg_addr = MII_ADDR_C45 | dev_addr << 16 | MDIO_DEVS1;
-	phy_reg = mdiobus_read(bus, addr, reg_addr);
+	phy_reg = mdiobus_c45_read(bus, addr, dev_addr, MDIO_DEVS1);
 	if (phy_reg < 0)
 		return -EIO;
 	*devices_in_package |= phy_reg;
@@ -709,11 +707,11 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
  *
  */
 static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
-			   struct phy_c45_device_ids *c45_ids) {
-	int phy_reg;
-	int i, reg_addr;
+			   struct phy_c45_device_ids *c45_ids)
+{
 	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
 	u32 *devs = &c45_ids->devices_in_package;
+	int i, phy_reg;
 
 	/* Find first non-zero Devices In package. Device zero is reserved
 	 * for 802.3 c45 complied PHYs, so don't probe it at first.
@@ -747,14 +745,12 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 		if (!(c45_ids->devices_in_package & (1 << i)))
 			continue;
 
-		reg_addr = MII_ADDR_C45 | i << 16 | MII_PHYSID1;
-		phy_reg = mdiobus_read(bus, addr, reg_addr);
+		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
 		if (phy_reg < 0)
 			return -EIO;
 		c45_ids->device_ids[i] = phy_reg << 16;
 
-		reg_addr = MII_ADDR_C45 | i << 16 | MII_PHYSID2;
-		phy_reg = mdiobus_read(bus, addr, reg_addr);
+		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID2);
 		if (phy_reg < 0)
 			return -EIO;
 		c45_ids->device_ids[i] |= phy_reg;
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b6b1f77bba58..0ab65fb75258 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1631,7 +1631,7 @@ static int phylink_phy_read(struct phylink *pl, unsigned int phy_id,
 	if (mdio_phy_id_is_c45(phy_id)) {
 		prtad = mdio_phy_id_prtad(phy_id);
 		devad = mdio_phy_id_devad(phy_id);
-		devad = MII_ADDR_C45 | devad << 16 | reg;
+		devad = mdiobus_c45_addr(devad, reg);
 	} else if (phydev->is_c45) {
 		switch (reg) {
 		case MII_BMCR:
@@ -1654,7 +1654,7 @@ static int phylink_phy_read(struct phylink *pl, unsigned int phy_id,
 			return -EINVAL;
 		}
 		prtad = phy_id;
-		devad = MII_ADDR_C45 | devad << 16 | reg;
+		devad = mdiobus_c45_addr(devad, reg);
 	} else {
 		prtad = phy_id;
 		devad = reg;
@@ -1671,7 +1671,7 @@ static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
 	if (mdio_phy_id_is_c45(phy_id)) {
 		prtad = mdio_phy_id_prtad(phy_id);
 		devad = mdio_phy_id_devad(phy_id);
-		devad = MII_ADDR_C45 | devad << 16 | reg;
+		devad = mdiobus_c45_addr(devad, reg);
 	} else if (phydev->is_c45) {
 		switch (reg) {
 		case MII_BMCR:
@@ -1694,7 +1694,7 @@ static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
 			return -EINVAL;
 		}
 		prtad = phy_id;
-		devad = MII_ADDR_C45 | devad << 16 | reg;
+		devad = mdiobus_c45_addr(devad, reg);
 	} else {
 		prtad = phy_id;
 		devad = reg;
@@ -2292,7 +2292,6 @@ void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs)
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_an_restart);
 
-#define C45_ADDR(d,a)	(MII_ADDR_C45 | (d) << 16 | (a))
 void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state)
 {
@@ -2300,7 +2299,7 @@ void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
 	int addr = pcs->addr;
 	int stat;
 
-	stat = mdiobus_read(bus, addr, C45_ADDR(MDIO_MMD_PCS, MDIO_STAT1));
+	stat = mdiobus_c45_read(bus, addr, MDIO_MMD_PCS, MDIO_STAT1);
 	if (stat < 0) {
 		state->link = false;
 		return;
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 917e4bb2ed71..36d2e0673d03 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -9,6 +9,13 @@
 #include <uapi/linux/mdio.h>
 #include <linux/mod_devicetable.h>
 
+/* Or MII_ADDR_C45 into regnum for read/write on mii_bus to enable the 21 bit
+ * IEEE 802.3ae clause 45 addressing mode used by 10GIGE phy chips.
+ */
+#define MII_ADDR_C45		(1<<30)
+#define MII_DEVADDR_C45_SHIFT	16
+#define MII_REGADDR_C45_MASK	GENMASK(15, 0)
+
 struct gpio_desc;
 struct mii_bus;
 
@@ -326,6 +333,30 @@ int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 		   u16 set);
 
+static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
+{
+	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
+}
+
+static inline int __mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
+				     u16 regnum)
+{
+	return __mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
+}
+
+static inline int __mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
+				      u16 regnum, u16 val)
+{
+	return __mdiobus_write(bus, prtad, mdiobus_c45_addr(devad, regnum),
+			       val);
+}
+
+static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
+				   u16 regnum)
+{
+	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
+}
+
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2bcdf19ed3b4..6d256e720a66 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -209,12 +209,6 @@ static inline const char *phy_modes(phy_interface_t interface)
 
 #define MII_BUS_ID_SIZE	61
 
-/* Or MII_ADDR_C45 into regnum for read/write on mii_bus to enable the 21 bit
-   IEEE 802.3ae clause 45 addressing mode used by 10GIGE phy chips. */
-#define MII_ADDR_C45 (1<<30)
-#define MII_DEVADDR_C45_SHIFT	16
-#define MII_REGADDR_C45_MASK	GENMASK(15, 0)
-
 struct device;
 struct phylink;
 struct sfp_bus;
-- 
2.20.1


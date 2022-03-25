Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842FA4E7D28
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbiCYVh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiCYVhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:37:08 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D1B4AE3A;
        Fri, 25 Mar 2022 14:35:31 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9C9172241C;
        Fri, 25 Mar 2022 22:35:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648244127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mPH6790GNyiuiOcJCQW3dZLBMey7AqxT2Pa16Pswx7g=;
        b=QLuLOe8JzgdE7ZDWJA3zerR0MYJT8vp1FsPVC3RqU+5VdvWgQe2VhbVn2CRZJRbcFdEors
        OstRN9JReIj5lG5swd8qQQjQopB97Dzdryi8M8gLqqm51VcuWbXg6KPgpaoj3y1R0ytJZE
        UtNVgraiQsFPB7mWXmbtCPMKOwHjERc=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 6/8] net: phy: add support for C45-over-C22 transfers
Date:   Fri, 25 Mar 2022 22:35:16 +0100
Message-Id: <20220325213518.2668832-7-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325213518.2668832-1-michael@walle.cc>
References: <20220325213518.2668832-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an MDIO bus is only capable of doing C22 transfers we can use
indirect accesses to C45 registers over C22 registers. This was already
the intention of the GPY215 driver. The author described their use case
as follows:

  Our product supports both C22 and C45.

  In the real system, we found C22 was used by customers (with indirect
  access to C45 registers when necessary).

In its probe function phy_get_c45_ids() is called but this will always
do C45 accesses and thus will fail on a C22-only bus. With the current
code we only have the is_c45 property which is used to indicate a C45
but also used to choose the transfer mode. With C45-over-C22 we need to
split these two properties.

Drop the is_c45 and instead introduce two new properties, has_c45 and
c45_over_c22. has_c45 is set to true if this is a C45 PHY and
c45_over_c22 is true if we need to do indirect accesses using the C22
registers.

c45_over_c22 will always be set by just looking at the bus capabilities.
It will be set to true if a bus is C22-only, regardless if the PHY would
support indirect access. Firstly, it is a reasonable assumption that C45
PHYs will support this access and secondly, there is really not much we
can do otherwise.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  4 ++--
 drivers/net/phy/bcm84881.c                    |  2 +-
 drivers/net/phy/marvell10g.c                  |  2 +-
 drivers/net/phy/mxl-gpy.c                     |  3 ++-
 drivers/net/phy/phy-core.c                    |  4 ++--
 drivers/net/phy/phy.c                         |  6 ++---
 drivers/net/phy/phy_device.c                  | 24 +++++++++++++++----
 drivers/net/phy/phylink.c                     |  8 +++----
 include/linux/phy.h                           |  8 ++++---
 9 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 54faf0f2d1d8..ec683cdc99d7 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -919,7 +919,7 @@ static void hns_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 					hns_nic_test_strs[MAC_INTERNALLOOP_MAC]);
 		ethtool_sprintf(&buff,
 				hns_nic_test_strs[MAC_INTERNALLOOP_SERDES]);
-		if ((netdev->phydev) && (!netdev->phydev->is_c45))
+		if (netdev->phydev && !netdev->phydev->has_c45)
 			ethtool_sprintf(&buff,
 					hns_nic_test_strs[MAC_INTERNALLOOP_PHY]);
 
@@ -979,7 +979,7 @@ static int hns_get_sset_count(struct net_device *netdev, int stringset)
 		if (priv->ae_handle->phy_if == PHY_INTERFACE_MODE_XGMII)
 			cnt--;
 
-		if ((!netdev->phydev) || (netdev->phydev->is_c45))
+		if (!netdev->phydev || netdev->phydev->has_c45)
 			cnt--;
 
 		return cnt;
diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 9717a1626f3f..d9131d5284c1 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -47,7 +47,7 @@ static int bcm84881_probe(struct phy_device *phydev)
 	/* This driver requires PMAPMD and AN blocks */
 	const u32 mmd_mask = MDIO_DEVS_PMAPMD | MDIO_DEVS_AN;
 
-	if (!phydev->is_c45 ||
+	if (!phydev->has_c45 ||
 	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
 		return -ENODEV;
 
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b6fea119fe13..4e4ede9af159 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -491,7 +491,7 @@ static int mv3310_probe(struct phy_device *phydev)
 	u32 mmd_mask = MDIO_DEVS_PMAPMD | MDIO_DEVS_AN;
 	int ret;
 
-	if (!phydev->is_c45 ||
+	if (!phydev->has_c45 ||
 	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
 		return -ENODEV;
 
diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 5ce1bf03bbd7..2a19905984fc 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -98,7 +98,8 @@ static int gpy_probe(struct phy_device *phydev)
 {
 	int ret;
 
-	if (!phydev->is_c45) {
+	if (!phydev->has_c45) {
+		phydev->has_c45 = true;
 		ret = phy_get_c45_ids(phydev);
 		if (ret < 0)
 			return ret;
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 2a300c58d1e5..72b8741ca4de 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -487,7 +487,7 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 
 	if (phydev->drv && phydev->drv->read_mmd) {
 		val = phydev->drv->read_mmd(phydev, devad, regnum);
-	} else if (phydev->is_c45) {
+	} else if (phydev->has_c45 && !phydev->c45_over_c22) {
 		val = __mdiobus_c45_read(phydev->mdio.bus, phydev->mdio.addr,
 					 devad, regnum);
 	} else {
@@ -546,7 +546,7 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 
 	if (phydev->drv && phydev->drv->write_mmd) {
 		ret = phydev->drv->write_mmd(phydev, devad, regnum, val);
-	} else if (phydev->is_c45) {
+	} else if (phydev->has_c45 && !phydev->c45_over_c22) {
 		ret = __mdiobus_c45_write(phydev->mdio.bus, phydev->mdio.addr,
 					  devad, regnum, val);
 	} else {
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index beb2b66da132..f3adbe9af6d9 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -140,7 +140,7 @@ int phy_restart_aneg(struct phy_device *phydev)
 {
 	int ret;
 
-	if (phydev->is_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
+	if (phydev->has_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
 		ret = genphy_c45_restart_aneg(phydev);
 	else
 		ret = genphy_restart_aneg(phydev);
@@ -161,7 +161,7 @@ int phy_aneg_done(struct phy_device *phydev)
 {
 	if (phydev->drv && phydev->drv->aneg_done)
 		return phydev->drv->aneg_done(phydev);
-	else if (phydev->is_c45)
+	else if (phydev->has_c45)
 		return genphy_c45_aneg_done(phydev);
 	else
 		return genphy_aneg_done(phydev);
@@ -657,7 +657,7 @@ int phy_config_aneg(struct phy_device *phydev)
 	/* Clause 45 PHYs that don't implement Clause 22 registers are not
 	 * allowed to call genphy_config_aneg()
 	 */
-	if (phydev->is_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
+	if (phydev->has_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
 		return genphy_c45_config_aneg(phydev);
 
 	return genphy_config_aneg(phydev);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 95cd12680e02..920bc8859069 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -468,7 +468,7 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
 	if (phydrv->match_phy_device)
 		return phydrv->match_phy_device(phydev);
 
-	if (phydev->is_c45) {
+	if (phydev->has_c45) {
 		for (i = 1; i < num_ids; i++) {
 			if (phydev->c45_ids.device_ids[i] == 0xffffffff)
 				continue;
@@ -599,7 +599,23 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 
 	dev->autoneg = AUTONEG_ENABLE;
 
-	dev->is_c45 = is_c45;
+	/* Depending on the bus capabilities, we have to use C45-over-C22
+	 * register access. We have the following cases:
+	 *
+	 * 1) bus can only do c45.
+	 * 2) bus can only do c22.
+	 * 3) bus can do c22 and c45.
+	 *
+	 * 1) and 3) are easy, because we can just use c45 transfers. For 2) we
+	 * don't have any other choice but to use c22 transfers. Even if the
+	 * PHY wouldn't support it we cannot do any better.
+	 *
+	 * Set this for C22 PHYs, too, because the PHY driver might promote it
+	 * to C45.
+	 */
+	dev->c45_over_c22 = bus->probe_capabilities == MDIOBUS_C22;
+
+	dev->has_c45 = is_c45;
 	dev->phy_id = phy_id;
 	if (c45_ids)
 		dev->c45_ids = *c45_ids;
@@ -1406,7 +1422,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	 * exist, and we should use the genphy driver.
 	 */
 	if (!d->driver) {
-		if (phydev->is_c45)
+		if (phydev->has_c45)
 			d->driver = &genphy_c45_driver.mdiodrv.driver;
 		else
 			d->driver = &genphy_driver.mdiodrv.driver;
@@ -3059,7 +3075,7 @@ static int phy_probe(struct device *dev)
 		linkmode_copy(phydev->supported, phydrv->features);
 	else if (phydrv->get_features)
 		err = phydrv->get_features(phydev);
-	else if (phydev->is_c45)
+	else if (phydev->has_c45)
 		err = genphy_c45_pma_read_abilities(phydev);
 	else
 		err = genphy_read_abilities(phydev);
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 06943889d747..964f74d9eca7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1369,7 +1369,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	 * speeds. We really need to know which interface modes the PHY and
 	 * MAC supports to properly work out which linkmodes can be supported.
 	 */
-	if (phy->is_c45 &&
+	if (phy->has_c45 &&
 	    interface != PHY_INTERFACE_MODE_RXAUI &&
 	    interface != PHY_INTERFACE_MODE_XAUI &&
 	    interface != PHY_INTERFACE_MODE_USXGMII)
@@ -2302,7 +2302,7 @@ static int phylink_phy_read(struct phylink *pl, unsigned int phy_id,
 		prtad = mdio_phy_id_prtad(phy_id);
 		devad = mdio_phy_id_devad(phy_id);
 		devad = mdiobus_c45_addr(devad, reg);
-	} else if (phydev->is_c45) {
+	} else if (phydev->has_c45 && !phydev->c45_over_c22) {
 		switch (reg) {
 		case MII_BMCR:
 		case MII_BMSR:
@@ -2342,7 +2342,7 @@ static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
 		prtad = mdio_phy_id_prtad(phy_id);
 		devad = mdio_phy_id_devad(phy_id);
 		devad = mdiobus_c45_addr(devad, reg);
-	} else if (phydev->is_c45) {
+	} else if (phydev->has_c45 && !phydev->c45_over_c22) {
 		switch (reg) {
 		case MII_BMCR:
 		case MII_BMSR:
@@ -2717,7 +2717,7 @@ static void phylink_sfp_link_up(void *upstream)
  */
 static bool phylink_phy_no_inband(struct phy_device *phy)
 {
-	return phy->is_c45 &&
+	return phy->has_c45 &&
 		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
 }
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c81c209d4abd..64f2dff2f125 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -523,8 +523,9 @@ struct macsec_ops;
  * @mdio: MDIO bus this PHY is on
  * @drv: Pointer to the driver for this PHY instance
  * @phy_id: UID for this device found during discovery
- * @c45_ids: 802.3-c45 Device Identifiers if is_c45.
- * @is_c45:  Set to true if this PHY uses clause 45 addressing.
+ * @c45_ids: 802.3-c45 Device Identifiers if has_c45.
+ * @has_c45:  Set to true if this PHY has clause 45 address space.
+ * @c45_over_c22:  Set to true if c45-over-c22 addressing is used.
  * @is_internal: Set to true if this PHY is internal to a MAC.
  * @is_pseudo_fixed_link: Set to true if this PHY is an Ethernet switch, etc.
  * @is_gigabit_capable: Set to true if PHY supports 1000Mbps
@@ -605,7 +606,8 @@ struct phy_device {
 	u32 phy_id;
 
 	struct phy_c45_device_ids c45_ids;
-	unsigned is_c45:1;
+	unsigned has_c45:1;
+	unsigned c45_over_c22:1;
 	unsigned is_internal:1;
 	unsigned is_pseudo_fixed_link:1;
 	unsigned is_gigabit_capable:1;
-- 
2.30.2


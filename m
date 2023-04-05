Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AB56D7854
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237606AbjDEJbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237745AbjDEJab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:30:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5E15B88
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:29:53 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzQ2-0004pA-Bz; Wed, 05 Apr 2023 11:27:06 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Date:   Wed, 05 Apr 2023 11:26:55 +0200
Subject: [PATCH 04/12] net: phy: unify get_phy_device and phy_device_create
 parameter list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-4-7e5329f08002@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
X-Mailer: b4 0.12.1
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently these two public APIs are used to create a 'struct phy_device'
device. In addition to that the device get_phy_device() can adapt the
is_c45 parameter as well if supprted by the mii bus.

Both APIs do have a different set of parameters which can be unified to
upcoming API extension. For this the 'struct phy_device_config' is
introduced which is the only parameter for both functions. This new
mechnism also adds the possiblity to read the configuration back within
the driver for possible validation checks.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/net/ethernet/adi/adin1110.c               |  6 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c       |  8 +++-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 11 +++--
 drivers/net/ethernet/socionext/netsec.c           |  7 ++-
 drivers/net/mdio/fwnode_mdio.c                    | 13 +++---
 drivers/net/mdio/mdio-xgene.c                     |  6 ++-
 drivers/net/phy/fixed_phy.c                       |  6 ++-
 drivers/net/phy/mdio_bus.c                        |  7 ++-
 drivers/net/phy/nxp-tja11xx.c                     | 23 +++++-----
 drivers/net/phy/phy_device.c                      | 55 ++++++++++++-----------
 drivers/net/phy/sfp.c                             |  7 ++-
 include/linux/phy.h                               | 29 +++++++++---
 12 files changed, 121 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 3f316a0f4158..01b0c2a3a294 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1565,6 +1565,9 @@ static int adin1110_probe_netdevs(struct adin1110_priv *priv)
 {
 	struct device *dev = &priv->spidev->dev;
 	struct adin1110_port_priv *port_priv;
+	struct phy_device_config config = {
+		.mii_bus = priv->mii_bus,
+	};
 	struct net_device *netdev;
 	int ret;
 	int i;
@@ -1599,7 +1602,8 @@ static int adin1110_probe_netdevs(struct adin1110_priv *priv)
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 		netdev->features |= NETIF_F_NETNS_LOCAL;
 
-		port_priv->phydev = get_phy_device(priv->mii_bus, i + 1, false);
+		config.phy_addr = i + 1;
+		port_priv->phydev = get_phy_device(&config);
 		if (IS_ERR(port_priv->phydev)) {
 			netdev_err(netdev, "Could not find PHY with device address: %d.\n", i);
 			return PTR_ERR(port_priv->phydev);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 16e7fb2c0dae..27ba903bbd0a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1056,6 +1056,10 @@ static int xgbe_phy_find_phy_device(struct xgbe_prv_data *pdata)
 {
 	struct ethtool_link_ksettings *lks = &pdata->phy.lks;
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
+	struct phy_device_config config = {
+		.mii_bus = phy_data->mii,
+		.phy_addr = phy_data->mdio_addr,
+	};
 	struct phy_device *phydev;
 	int ret;
 
@@ -1086,8 +1090,8 @@ static int xgbe_phy_find_phy_device(struct xgbe_prv_data *pdata)
 	}
 
 	/* Create and connect to the PHY device */
-	phydev = get_phy_device(phy_data->mii, phy_data->mdio_addr,
-				(phy_data->phydev_mode == XGBE_MDIO_MODE_CL45));
+	config.is_c45 = phy_data->phydev_mode == XGBE_MDIO_MODE_CL45;
+	phydev = get_phy_device(&config);
 	if (IS_ERR(phydev)) {
 		netdev_err(pdata->netdev, "get_phy_device failed\n");
 		return -ENODEV;
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index 928d934cb21a..3c41c4db5d9b 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -687,9 +687,12 @@ static int
 hns_mac_register_phydev(struct mii_bus *mdio, struct hns_mac_cb *mac_cb,
 			u32 addr)
 {
+	struct phy_device_config config = {
+		.mii_bus = mdio,
+		.phy_addr = addr,
+	};
 	struct phy_device *phy;
 	const char *phy_type;
-	bool is_c45;
 	int rc;
 
 	rc = fwnode_property_read_string(mac_cb->fw_port,
@@ -698,13 +701,13 @@ hns_mac_register_phydev(struct mii_bus *mdio, struct hns_mac_cb *mac_cb,
 		return rc;
 
 	if (!strcmp(phy_type, phy_modes(PHY_INTERFACE_MODE_XGMII)))
-		is_c45 = true;
+		config.is_c45 = true;
 	else if (!strcmp(phy_type, phy_modes(PHY_INTERFACE_MODE_SGMII)))
-		is_c45 = false;
+		config.is_c45 = false;
 	else
 		return -ENODATA;
 
-	phy = get_phy_device(mdio, addr, is_c45);
+	phy = get_phy_device(&config);
 	if (!phy || IS_ERR(phy))
 		return -EIO;
 
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 2d7347b71c41..a0786dfb827a 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1948,6 +1948,11 @@ static int netsec_register_mdio(struct netsec_priv *priv, u32 phy_addr)
 			return ret;
 		}
 	} else {
+		struct phy_device_config config = {
+			.mii_bus = bus,
+			.phy_addr = phy_addr,
+		};
+
 		/* Mask out all PHYs from auto probing. */
 		bus->phy_mask = ~0;
 		ret = mdiobus_register(bus);
@@ -1956,7 +1961,7 @@ static int netsec_register_mdio(struct netsec_priv *priv, u32 phy_addr)
 			return ret;
 		}
 
-		priv->phydev = get_phy_device(bus, phy_addr, false);
+		priv->phydev = get_phy_device(&config);
 		if (IS_ERR(priv->phydev)) {
 			ret = PTR_ERR(priv->phydev);
 			dev_err(priv->dev, "get_phy_device err(%d)\n", ret);
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1183ef5e203e..47ef702d4ffd 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -112,10 +112,13 @@ EXPORT_SYMBOL(fwnode_mdiobus_phy_device_register);
 int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr)
 {
+	struct phy_device_config config = {
+		.mii_bus = bus,
+		.phy_addr = addr,
+	};
 	struct mii_timestamper *mii_ts = NULL;
 	struct pse_control *psec = NULL;
 	struct phy_device *phy;
-	bool is_c45;
 	u32 phy_id;
 	int rc;
 
@@ -129,11 +132,11 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		goto clean_pse;
 	}
 
-	is_c45 = fwnode_device_is_compatible(child, "ethernet-phy-ieee802.3-c45");
-	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
-		phy = get_phy_device(bus, addr, is_c45);
+	config.is_c45 = fwnode_device_is_compatible(child, "ethernet-phy-ieee802.3-c45");
+	if (config.is_c45 || fwnode_get_phy_id(child, &config.phy_id))
+		phy = get_phy_device(&config);
 	else
-		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
+		phy = phy_device_create(&config);
 	if (IS_ERR(phy)) {
 		rc = PTR_ERR(phy);
 		goto clean_mii_ts;
diff --git a/drivers/net/mdio/mdio-xgene.c b/drivers/net/mdio/mdio-xgene.c
index 7aafc221b5cf..6754c35aa6c3 100644
--- a/drivers/net/mdio/mdio-xgene.c
+++ b/drivers/net/mdio/mdio-xgene.c
@@ -262,9 +262,13 @@ static int xgene_xfi_mdio_read(struct mii_bus *bus, int phy_id, int reg)
 
 struct phy_device *xgene_enet_phy_register(struct mii_bus *bus, int phy_addr)
 {
+	struct phy_device_config config = {
+		.mii_bus = bus,
+		.phy_addr = phy_addr,
+	};
 	struct phy_device *phy_dev;
 
-	phy_dev = get_phy_device(bus, phy_addr, false);
+	phy_dev = get_phy_device(&config);
 	if (!phy_dev || IS_ERR(phy_dev))
 		return NULL;
 
diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index aef739c20ac4..d217301a71d1 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -229,6 +229,9 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 					       struct gpio_desc *gpiod)
 {
 	struct fixed_mdio_bus *fmb = &platform_fmb;
+	struct phy_device_config config = {
+		.mii_bus = fmb->mii_bus,
+	};
 	struct phy_device *phy;
 	int phy_addr;
 	int ret;
@@ -254,7 +257,8 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 		return ERR_PTR(ret);
 	}
 
-	phy = get_phy_device(fmb->mii_bus, phy_addr, false);
+	config.phy_addr = phy_addr;
+	phy = get_phy_device(&config);
 	if (IS_ERR(phy)) {
 		fixed_phy_del(phy_addr);
 		return ERR_PTR(-EINVAL);
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 389f33a12534..8390db7ae4bc 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -516,9 +516,14 @@ static int mdiobus_create_device(struct mii_bus *bus,
 static struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr, bool c45)
 {
 	struct phy_device *phydev = ERR_PTR(-ENODEV);
+	struct phy_device_config config = {
+		.mii_bus = bus,
+		.phy_addr = addr,
+		.is_c45 = c45,
+	};
 	int err;
 
-	phydev = get_phy_device(bus, addr, c45);
+	phydev = get_phy_device(&config);
 	if (IS_ERR(phydev))
 		return phydev;
 
diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index ec91e671f8aa..b5e03d66b7f5 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -554,17 +554,20 @@ static void tja1102_p1_register(struct work_struct *work)
 	struct device *dev = &phydev_phy0->mdio.dev;
 	struct device_node *np = dev->of_node;
 	struct device_node *child;
-	int ret;
 
 	for_each_available_child_of_node(np, child) {
+		struct phy_device_config config = {
+			.mii_bus = bus,
+			/* Real PHY ID of Port 1 is 0 */
+			.phy_id = PHY_ID_TJA1102,
+		};
 		struct phy_device *phy;
-		int addr;
 
-		addr = of_mdio_parse_addr(dev, child);
-		if (addr < 0) {
+		config.phy_addr = of_mdio_parse_addr(dev, child);
+		if (config.phy_addr < 0) {
 			dev_err(dev, "Can't parse addr\n");
 			continue;
-		} else if (addr != phydev_phy0->mdio.addr + 1) {
+		} else if (config.phy_addr != phydev_phy0->mdio.addr + 1) {
 			/* Currently we care only about double PHY chip TJA1102.
 			 * If some day NXP will decide to bring chips with more
 			 * PHYs, this logic should be reworked.
@@ -574,16 +577,15 @@ static void tja1102_p1_register(struct work_struct *work)
 			continue;
 		}
 
-		if (mdiobus_is_registered_device(bus, addr)) {
+		if (mdiobus_is_registered_device(bus, config.phy_addr)) {
 			dev_err(dev, "device is already registered\n");
 			continue;
 		}
 
-		/* Real PHY ID of Port 1 is 0 */
-		phy = phy_device_create(bus, addr, PHY_ID_TJA1102, false, NULL);
+		phy = phy_device_create(&config);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "Can't create PHY device for Port 1: %i\n",
-				addr);
+				config.phy_addr);
 			continue;
 		}
 
@@ -592,7 +594,8 @@ static void tja1102_p1_register(struct work_struct *work)
 		 */
 		phy->mdio.dev.parent = dev;
 
-		ret = of_mdiobus_phy_device_register(bus, phy, child, addr);
+		ret = of_mdiobus_phy_device_register(bus, phy, child,
+						     config.phy_addr);
 		if (ret) {
 			/* All resources needed for Port 1 should be already
 			 * available for Port 0. Both ports use the same
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e4d08dcfed70..bb465a324eef 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -629,8 +629,10 @@ static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
 	return 0;
 }
 
-static struct phy_device *phy_device_alloc(struct mii_bus *bus, int addr)
+static struct phy_device *phy_device_alloc(struct phy_device_config *config)
 {
+	struct mii_bus *bus = config->mii_bus;
+	int addr = config->phy_addr;
 	struct phy_device *dev;
 	struct mdio_device *mdiodev;
 
@@ -656,9 +658,15 @@ static struct phy_device *phy_device_alloc(struct mii_bus *bus, int addr)
 	return dev;
 }
 
-static int phy_device_init(struct phy_device *dev, u32 phy_id, bool is_c45,
-			   struct phy_c45_device_ids *c45_ids)
+static int phy_device_init(struct phy_device *dev,
+			   struct phy_device_config *config)
 {
+	struct phy_c45_device_ids *c45_ids = &config->c45_ids;
+	struct mii_bus *bus = config->mii_bus;
+	bool is_c45 = config->is_c45;
+	u32 phy_id = config->phy_id;
+	int addr = config->phy_addr;
+
 	dev->speed = SPEED_UNKNOWN;
 	dev->duplex = DUPLEX_UNKNOWN;
 	dev->pause = 0;
@@ -711,18 +719,16 @@ static int phy_device_init(struct phy_device *dev, u32 phy_id, bool is_c45,
 	return phy_request_driver_module(dev, phy_id);
 }
 
-struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
-				     bool is_c45,
-				     struct phy_c45_device_ids *c45_ids)
+struct phy_device *phy_device_create(struct phy_device_config *config)
 {
 	struct phy_device *dev;
 	int ret;
 
-	dev = phy_device_alloc(bus, addr);
+	dev = phy_device_alloc(config);
 	if (IS_ERR(dev))
 		return dev;
 
-	ret = phy_device_init(dev, phy_id, is_c45, c45_ids);
+	ret = phy_device_init(dev, config);
 	if (ret) {
 		put_device(&dev->mdio.dev);
 		dev = ERR_PTR(ret);
@@ -954,12 +960,16 @@ int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
 }
 EXPORT_SYMBOL(fwnode_get_phy_id);
 
-static int phy_device_detect(struct mii_bus *bus, int addr, bool *is_c45,
-			     u32 *phy_id, struct phy_c45_device_ids *c45_ids)
+static int phy_device_detect(struct phy_device_config *config)
 {
+	struct phy_c45_device_ids *c45_ids = &config->c45_ids;
+	struct mii_bus *bus = config->mii_bus;
+	u32 *phy_id = &config->phy_id;
+	bool is_c45 = config->is_c45;
+	int addr = config->phy_addr;
 	int r;
 
-	if (*is_c45)
+	if (is_c45)
 		r = get_phy_c45_ids(bus, addr, c45_ids);
 	else
 		r = get_phy_c22_id(bus, addr, phy_id);
@@ -972,8 +982,8 @@ static int phy_device_detect(struct mii_bus *bus, int addr, bool *is_c45,
 	 * probe with C45 to see if we're able to get a valid PHY ID in the C45
 	 * space, if successful, create the C45 PHY device.
 	 */
-	if (!*is_c45 && *phy_id == 0 && bus->read_c45) {
-		*is_c45 = true;
+	if (!is_c45 && *phy_id == 0 && bus->read_c45) {
+		config->is_c45 = true;
 		return get_phy_c45_ids(bus, addr, c45_ids);
 	}
 
@@ -983,11 +993,9 @@ static int phy_device_detect(struct mii_bus *bus, int addr, bool *is_c45,
 /**
  * get_phy_device - reads the specified PHY device and returns its @phy_device
  *		    struct
- * @bus: the target MII bus
- * @addr: PHY address on the MII bus
- * @is_c45: If true the PHY uses the 802.3 clause 45 protocol
+ * @config: The PHY device config
  *
- * Probe for a PHY at @addr on @bus.
+ * Use the @config parameters to probe for a PHY.
  *
  * When probing for a clause 22 PHY, then read the ID registers. If we find
  * a valid ID, allocate and return a &struct phy_device.
@@ -999,21 +1007,18 @@ static int phy_device_detect(struct mii_bus *bus, int addr, bool *is_c45,
  * Returns an allocated &struct phy_device on success, %-ENODEV if there is
  * no PHY present, or %-EIO on bus access error.
  */
-struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
+struct phy_device *get_phy_device(struct phy_device_config *config)
 {
-	struct phy_c45_device_ids c45_ids;
-	u32 phy_id = 0;
+	struct phy_c45_device_ids *c45_ids = &config->c45_ids;
 	int r;
 
-	c45_ids.devices_in_package = 0;
-	c45_ids.mmds_present = 0;
-	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
+	memset(c45_ids->device_ids, 0xff, sizeof(c45_ids->device_ids));
 
-	r = phy_device_detect(bus, addr, &is_c45, &phy_id, &c45_ids);
+	r = phy_device_detect(config);
 	if (r)
 		return ERR_PTR(r);
 
-	return phy_device_create(bus, addr, phy_id, is_c45, &c45_ids);
+	return phy_device_create(config);
 }
 EXPORT_SYMBOL(get_phy_device);
 
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index f0fcb06fbe82..8fb0a1a49aaf 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1635,10 +1635,15 @@ static void sfp_sm_phy_detach(struct sfp *sfp)
 
 static int sfp_sm_probe_phy(struct sfp *sfp, int addr, bool is_c45)
 {
+	struct phy_device_config config = {
+		.mii_bus = sfp->i2c_mii,
+		.phy_addr = addr,
+		.is_c45 = is_c45,
+	};
 	struct phy_device *phy;
 	int err;
 
-	phy = get_phy_device(sfp->i2c_mii, addr, is_c45);
+	phy = get_phy_device(&config);
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c17a98712555..498f4dc7669d 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -756,6 +756,27 @@ static inline struct phy_device *to_phy_device(const struct device *dev)
 	return container_of(to_mdio_device(dev), struct phy_device, mdio);
 }
 
+/**
+ * struct phy_device_config - Configuration of a PHY
+ *
+ * @mii_bus: The target MII bus the PHY is connected to
+ * @phy_addr: PHY address on the MII bus
+ * @phy_id: UID for this device found during discovery
+ * @c45_ids: 802.3-c45 Device Identifiers if is_c45.
+ * @is_c45: If true the PHY uses the 802.3 clause 45 protocol
+ *
+ * The struct contain possible configuration parameters for a PHY device which
+ * are used to setup the struct phy_device.
+ */
+
+struct phy_device_config {
+	struct mii_bus *mii_bus;
+	int phy_addr;
+	u32 phy_id;
+	struct phy_c45_device_ids c45_ids;
+	bool is_c45;
+};
+
 /**
  * struct phy_tdr_config - Configuration of a TDR raw test
  *
@@ -1538,9 +1559,7 @@ int phy_modify_paged_changed(struct phy_device *phydev, int page, u32 regnum,
 int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
 		     u16 mask, u16 set);
 
-struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
-				     bool is_c45,
-				     struct phy_c45_device_ids *c45_ids);
+struct phy_device *phy_device_create(struct phy_device_config *config);
 void phy_device_set_miits(struct phy_device *phydev,
 			  struct mii_timestamper *mii_ts);
 #if IS_ENABLED(CONFIG_PHYLIB)
@@ -1549,7 +1568,7 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
 struct fwnode_handle *fwnode_get_phy_node(const struct fwnode_handle *fwnode);
-struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
+struct phy_device *get_phy_device(struct phy_device_config *config);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
@@ -1581,7 +1600,7 @@ struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
 }
 
 static inline
-struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
+struct phy_device *get_phy_device(struct phy_device_config *config)
 {
 	return NULL;
 }

-- 
2.39.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1532D692520
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbjBJSPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjBJSPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:15:17 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D931CAFE;
        Fri, 10 Feb 2023 10:15:14 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2F08360007;
        Fri, 10 Feb 2023 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676052913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tTUAR28+MY/6foEGTUqoAcJGOwBT/oCIxXOYIL4qZww=;
        b=BLoN2a+8AwuuGpdmMudBHUW4mBsBVO3xX9iOLEMVnaFDqv8O9UK/jEPheGri/WiAgkY6jX
        4UiIddj+mA/LUgCVVGCzmFWMctsKs0l6Bazepq2rle+73emD2nTA85TDKzH0DZMgPfkPla
        1VAFS0BDItAlh5Gfl/ero6WwRq9ZdTqYU4TYNT/Qq90Lgjl8VP/EA7Gm8WZ7Ji4WVAr3En
        c79/HE+DwgWGKtlD9/1H6vhbaPsficG8aFVhdu8PI9FHvS73qCWAsiu73zM1nkKT39r2uu
        vc6DOwjMXDlFgXCAQVWEqrzxYQSd3N7TclVqTWfLN2XGJ/XKBdB7rstas+lzFQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] net: pcs: tse: port to pcs-lynx
Date:   Fri, 10 Feb 2023 20:09:49 +0100
Message-Id: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When submitting the initial driver for the Altera TSE PCS, Russell King
noted that the register layout for the TSE PCS is very similar to the
Lynx PCS. The main difference being that TSE PCS's register space is
memory-mapped, whereas Lynx's is exposed over MDIO.

Convert the TSE PCS to reuse the whole logic from Lynx, by allowing
the creation of a dummy MDIO bus, and a dummy MDIO device located at
address 0 on that bus. The MAC driver that uses this PCS must provide
callbacks to read/write the MMIO.

Also convert the Altera TSE MAC driver to this new way of using the TSE
PCS.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/altera/altera_tse.h      |   2 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  50 ++++-
 drivers/net/pcs/Kconfig                       |   4 +
 drivers/net/pcs/pcs-altera-tse.c              | 194 +++++++-----------
 include/linux/pcs-altera-tse.h                |  22 +-
 5 files changed, 142 insertions(+), 130 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index db5eed06e92d..f4e3fddb639a 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -476,7 +476,7 @@ struct altera_tse_private {
 
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
-	struct phylink_pcs *pcs;
+	struct altera_tse_pcs *pcs;
 };
 
 /* Function prototypes
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 66e3af73ec41..109b7ed90c6e 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -87,6 +87,36 @@ static inline u32 tse_tx_avail(struct altera_tse_private *priv)
 	return priv->tx_cons + priv->tx_ring_size - priv->tx_prod - 1;
 }
 
+static int altera_tse_pcs_read(void *priv, int regnum)
+{
+	struct altera_tse_private *tse = priv;
+
+	if (tse->pcs_base)
+		return readw(tse->pcs_base + (regnum * 2));
+	else
+		return readl(tse->mac_dev + tse_csroffs(mdio_phy0) +
+			     (regnum * 4));
+	return 0;
+}
+
+static int altera_tse_pcs_write(void *priv, int regnum, u16 value)
+{
+	struct altera_tse_private *tse = priv;
+
+	if (tse->pcs_base)
+		writew(value, tse->pcs_base + (regnum * 2));
+	else
+		writel(value, tse->mac_dev + tse_csroffs(mdio_phy0) +
+			(regnum * 4));
+
+	return 0;
+}
+
+static struct altera_tse_pcs_ops tse_ops = {
+	.read = altera_tse_pcs_read,
+	.write = altera_tse_pcs_write,
+};
+
 /* MDIO specific functions
  */
 static int altera_tse_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
@@ -1090,7 +1120,7 @@ static struct phylink_pcs *alt_tse_select_pcs(struct phylink_config *config,
 
 	if (interface == PHY_INTERFACE_MODE_SGMII ||
 	    interface == PHY_INTERFACE_MODE_1000BASEX)
-		return priv->pcs;
+		return altera_tse_pcs_to_phylink_pcs(priv->pcs);
 	else
 		return NULL;
 }
@@ -1143,7 +1173,6 @@ static int altera_tse_probe(struct platform_device *pdev)
 	struct resource *pcs_res;
 	struct net_device *ndev;
 	void __iomem *descmap;
-	int pcs_reg_width = 2;
 	int ret = -ENODEV;
 
 	ndev = alloc_etherdev(sizeof(struct altera_tse_private));
@@ -1262,10 +1291,6 @@ static int altera_tse_probe(struct platform_device *pdev)
 	 */
 	ret = request_and_map(pdev, "pcs", &pcs_res,
 			      &priv->pcs_base);
-	if (ret) {
-		priv->pcs_base = priv->mac_dev + tse_csroffs(mdio_phy0);
-		pcs_reg_width = 4;
-	}
 
 	/* Rx IRQ */
 	priv->rx_irq = platform_get_irq_byname(pdev, "rx_irq");
@@ -1389,7 +1414,11 @@ static int altera_tse_probe(struct platform_device *pdev)
 			 (unsigned long) control_port->start, priv->rx_irq,
 			 priv->tx_irq);
 
-	priv->pcs = alt_tse_pcs_create(ndev, priv->pcs_base, pcs_reg_width);
+	priv->pcs = alt_tse_pcs_create(ndev, &tse_ops, priv);
+	if (!priv->pcs) {
+		ret = -ENODEV;
+		goto err_init_phy;
+	}
 
 	priv->phylink_config.dev = &ndev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
@@ -1412,11 +1441,12 @@ static int altera_tse_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->phylink)) {
 		dev_err(&pdev->dev, "failed to create phylink\n");
 		ret = PTR_ERR(priv->phylink);
-		goto err_init_phy;
+		goto err_pcs;
 	}
 
 	return 0;
-
+err_pcs:
+	alt_tse_pcs_destroy(priv->pcs);
 err_init_phy:
 	unregister_netdev(ndev);
 err_register_netdev:
@@ -1438,6 +1468,8 @@ static int altera_tse_remove(struct platform_device *pdev)
 	altera_tse_mdio_destroy(ndev);
 	unregister_netdev(ndev);
 	phylink_destroy(priv->phylink);
+	alt_tse_pcs_destroy(priv->pcs);
+
 	free_netdev(ndev);
 
 	return 0;
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 6e7e6c346a3e..768e8cefe17c 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -28,8 +28,12 @@ config PCS_RZN1_MIIC
 
 config PCS_ALTERA_TSE
 	tristate
+	select PCS_LYNX
 	help
 	  This module provides helper functions for the Altera Triple Speed
 	  Ethernet SGMII PCS, that can be found on the Intel Socfpga family.
+	  This PCS appears to be a Lynx PCS exposed over mmio instead of a
+	  mdio device, so the core logic from Lynx PCS is re-used and wrapped
+	  around a virtual mii bus and mdio device.
 
 endmenu
diff --git a/drivers/net/pcs/pcs-altera-tse.c b/drivers/net/pcs/pcs-altera-tse.c
index d616749761f4..3adf6b1c0823 100644
--- a/drivers/net/pcs/pcs-altera-tse.c
+++ b/drivers/net/pcs/pcs-altera-tse.c
@@ -9,151 +9,109 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <linux/pcs-altera-tse.h>
+#include <linux/pcs-lynx.h>
 
-/* SGMII PCS register addresses
- */
-#define SGMII_PCS_LINK_TIMER_0	0x12
-#define SGMII_PCS_LINK_TIMER_1	0x13
-#define SGMII_PCS_IF_MODE	0x14
-#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
-#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
-#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
-#define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5)
-#define SGMII_PCS_SW_RESET_TIMEOUT 100 /* usecs */
-
-struct altera_tse_pcs {
-	struct phylink_pcs pcs;
-	void __iomem *base;
-	int reg_width;
-};
-
-static struct altera_tse_pcs *phylink_pcs_to_tse_pcs(struct phylink_pcs *pcs)
+static int altera_tse_pcs_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
+				     u16 value)
 {
-	return container_of(pcs, struct altera_tse_pcs, pcs);
-}
+	struct altera_tse_pcs *tse_pcs = bus->priv;
 
-static u16 tse_pcs_read(struct altera_tse_pcs *tse_pcs, int regnum)
-{
-	if (tse_pcs->reg_width == 4)
-		return readl(tse_pcs->base + regnum * 4);
-	else
-		return readw(tse_pcs->base + regnum * 2);
+	return tse_pcs->ops->write(tse_pcs->priv, regnum, value);
 }
 
-static void tse_pcs_write(struct altera_tse_pcs *tse_pcs, int regnum,
-			  u16 value)
+static int altera_tse_pcs_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 {
-	if (tse_pcs->reg_width == 4)
-		writel(value, tse_pcs->base + regnum * 4);
-	else
-		writew(value, tse_pcs->base + regnum * 2);
-}
+	struct altera_tse_pcs *tse_pcs = bus->priv;
 
-static int tse_pcs_reset(struct altera_tse_pcs *tse_pcs)
-{
-	u16 bmcr;
-
-	/* Reset PCS block */
-	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
-	bmcr |= BMCR_RESET;
-	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
+	if (mii_id != 0)
+		return 0;
 
-	return read_poll_timeout(tse_pcs_read, bmcr, (bmcr & BMCR_RESET),
-				 10, SGMII_PCS_SW_RESET_TIMEOUT, 1,
-				 tse_pcs, MII_BMCR);
+	return tse_pcs->ops->read(tse_pcs->priv, regnum);
 }
 
-static int alt_tse_pcs_validate(struct phylink_pcs *pcs,
-				unsigned long *supported,
-				const struct phylink_link_state *state)
+static struct altera_tse_pcs *
+altera_tse_pcs_mdio_create(struct net_device *dev,
+			   struct altera_tse_pcs_ops *ops,
+			   void *priv)
 {
-	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
-	    state->interface == PHY_INTERFACE_MODE_1000BASEX)
-		return 1;
-
-	return -EINVAL;
-}
-
-static int alt_tse_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-			      phy_interface_t interface,
-			      const unsigned long *advertising,
-			      bool permit_pause_to_mac)
-{
-	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
-	u32 ctrl, if_mode;
-
-	ctrl = tse_pcs_read(tse_pcs, MII_BMCR);
-	if_mode = tse_pcs_read(tse_pcs, SGMII_PCS_IF_MODE);
-
-	/* Set link timer to 1.6ms, as per the MegaCore Function User Guide */
-	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0, 0x0D40);
-	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1, 0x03);
-
-	if (interface == PHY_INTERFACE_MODE_SGMII) {
-		if_mode |= PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA;
-	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
-		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA);
+	struct altera_tse_pcs *tse_pcs;
+	struct mii_bus *mii_bus;
+	int ret;
+
+	tse_pcs = kzalloc(sizeof(*tse_pcs), GFP_KERNEL);
+	if (IS_ERR(tse_pcs))
+		return NULL;
+
+	tse_pcs->ops = ops;
+	tse_pcs->priv = priv;
+
+	mii_bus = mdiobus_alloc();
+	if (!mii_bus)
+		goto out_free_pcs;
+
+	mii_bus->name = "Altera TSE PCS MDIO";
+	mii_bus->read = &altera_tse_pcs_mdio_read;
+	mii_bus->write = &altera_tse_pcs_mdio_write;
+	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s-%s", mii_bus->name,
+		 dev->name);
+
+	mii_bus->priv = tse_pcs;
+	mii_bus->parent = &dev->dev;
+
+	ret = mdiobus_register(mii_bus);
+	if (ret)
+		goto out_free_mdio;
+
+	tse_pcs->mii_bus = mii_bus;
+	tse_pcs->mdiodev = mdio_device_create(mii_bus, 0);
+	if (IS_ERR(tse_pcs->mdiodev)) {
+		ret = PTR_ERR(tse_pcs->mdiodev);
+		goto out_unregister_mdio;
 	}
 
-	ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
-
-	tse_pcs_write(tse_pcs, MII_BMCR, ctrl);
-	tse_pcs_write(tse_pcs, SGMII_PCS_IF_MODE, if_mode);
+	return tse_pcs;
 
-	return tse_pcs_reset(tse_pcs);
+out_unregister_mdio:
+	mdiobus_unregister(mii_bus);
+out_free_mdio:
+	mdiobus_free(mii_bus);
+out_free_pcs:
+	kfree(tse_pcs);
+	return NULL;
 }
 
-static void alt_tse_pcs_get_state(struct phylink_pcs *pcs,
-				  struct phylink_link_state *state)
+void alt_tse_pcs_destroy(struct altera_tse_pcs *tse_pcs)
 {
-	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
-	u16 bmsr, lpa;
-
-	bmsr = tse_pcs_read(tse_pcs, MII_BMSR);
-	lpa = tse_pcs_read(tse_pcs, MII_LPA);
-
-	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
+	mdio_device_free(tse_pcs->mdiodev);
+	mdiobus_unregister(tse_pcs->mii_bus);
+	mdiobus_free(tse_pcs->mii_bus);
+	kfree(tse_pcs);
 }
 
-static void alt_tse_pcs_an_restart(struct phylink_pcs *pcs)
+struct altera_tse_pcs *alt_tse_pcs_create(struct net_device *dev,
+					  struct altera_tse_pcs_ops *ops,
+					  void *priv)
 {
-	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
-	u16 bmcr;
-
-	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
-	bmcr |= BMCR_ANRESTART;
-	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
-
-	/* This PCS seems to require a soft reset to re-sync the AN logic */
-	tse_pcs_reset(tse_pcs);
-}
+	struct altera_tse_pcs *tse_pcs;
+	struct phylink_pcs *pcs;
 
-static const struct phylink_pcs_ops alt_tse_pcs_ops = {
-	.pcs_validate = alt_tse_pcs_validate,
-	.pcs_get_state = alt_tse_pcs_get_state,
-	.pcs_config = alt_tse_pcs_config,
-	.pcs_an_restart = alt_tse_pcs_an_restart,
-};
+	tse_pcs = altera_tse_pcs_mdio_create(dev, ops, priv);
+	if (!tse_pcs)
+		return NULL;
 
-struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
-				       void __iomem *pcs_base, int reg_width)
-{
-	struct altera_tse_pcs *tse_pcs;
+	pcs = lynx_pcs_create(tse_pcs->mdiodev);
+	if (!pcs)
+		goto out_free_mdio;
 
-	if (reg_width != 4 && reg_width != 2)
-		return ERR_PTR(-EINVAL);
+	tse_pcs->pcs = pcs;
 
-	tse_pcs = devm_kzalloc(&ndev->dev, sizeof(*tse_pcs), GFP_KERNEL);
-	if (!tse_pcs)
-		return ERR_PTR(-ENOMEM);
+	return tse_pcs;
 
-	tse_pcs->pcs.ops = &alt_tse_pcs_ops;
-	tse_pcs->base = pcs_base;
-	tse_pcs->reg_width = reg_width;
+out_free_mdio:
+	alt_tse_pcs_destroy(tse_pcs);
 
-	return &tse_pcs->pcs;
+	return NULL;
 }
-EXPORT_SYMBOL_GPL(alt_tse_pcs_create);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Altera TSE PCS driver");
diff --git a/include/linux/pcs-altera-tse.h b/include/linux/pcs-altera-tse.h
index 92ab9f08e835..67be242a468e 100644
--- a/include/linux/pcs-altera-tse.h
+++ b/include/linux/pcs-altera-tse.h
@@ -11,7 +11,25 @@
 struct phylink_pcs;
 struct net_device;
 
-struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
-				       void __iomem *pcs_base, int reg_width);
+struct altera_tse_pcs_ops {
+	int (*read)(void *priv, int regnum);
+	int (*write)(void *priv, int regnum, u16 value);
+};
+
+struct altera_tse_pcs {
+	struct phylink_pcs *pcs;
+	struct altera_tse_pcs_ops *ops;
+	struct mii_bus *mii_bus;
+	struct mdio_device *mdiodev;
+	void *priv;
+};
+
+#define altera_tse_pcs_to_phylink_pcs(tse_pcs)	((tse_pcs)->pcs)
+
+struct altera_tse_pcs *alt_tse_pcs_create(struct net_device *ndev,
+					  struct altera_tse_pcs_ops *ops,
+					  void *priv);
+
+void alt_tse_pcs_destroy(struct altera_tse_pcs *tse_pcs);
 
 #endif /* __LINUX_PCS_ALTERA_TSE_H */
-- 
2.39.1


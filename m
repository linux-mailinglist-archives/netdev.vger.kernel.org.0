Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26766ED716
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 02:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbfKDBlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 20:41:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728391AbfKDBlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Nov 2019 20:41:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Zn39gtwN5c9rJPJeo4WK+WmgTNWIapZzW0i2kL3Rspw=; b=HmOCCA8R26W23Om0Zsj8paUJN3
        mlrQJcoUHSxctEUdavVy4wQW5U6TN5YybP0IWnFrZZ3wA6s9/k6G6se8gaqliNTCj7B/5YPFRGc4/
        5HHvbRw26wmsE21tfNm3pvIvq8x9iKIBJiEIGi+4kuI4AQJvTTaUz+f5rIPEFGsZXsCU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRRMI-0001pa-14; Mon, 04 Nov 2019 02:40:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, dan.carpenter@oracle.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3] net: of_get_phy_mode: Change API to solve int/unit warnings
Date:   Mon,  4 Nov 2019 02:40:33 +0100
Message-Id: <20191104014033.6987-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this change of_get_phy_mode() returned an enum,
phy_interface_t. On error, -ENODEV etc, is returned. If the result of
the function is stored in a variable of type phy_interface_t, and the
compiler has decided to represent this as an unsigned int, comparision
with -ENODEV etc, is a signed vs unsigned comparision.

Fix this problem by changing the API. Make the function return an
error, or 0 on success, and pass a pointer, of type phy_interface_t,
where the phy mode should be stored.

v2:
Return with *interface set to PHY_INTERFACE_MODE_NA on error.
Add error checks to all users of of_get_phy_mode()
Fixup a few reverse christmas tree errors
Fixup a few slightly malformed reverse christmas trees

v3:
Fix 0-day reported errors.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/bcm_sf2.c                        |  7 ++++---
 drivers/net/dsa/microchip/ksz_common.c           |  7 ++++---
 drivers/net/dsa/mt7530.c                         |  8 ++++++--
 drivers/net/dsa/qca8k.c                          |  9 +++++----
 drivers/net/dsa/sja1105/sja1105_main.c           |  7 ++++---
 drivers/net/ethernet/altera/altera_tse_main.c    |  6 +++---
 drivers/net/ethernet/arc/emac_arc.c              | 15 ++++++++++-----
 drivers/net/ethernet/arc/emac_rockchip.c         |  7 +++++--
 drivers/net/ethernet/atheros/ag71xx.c            |  5 ++---
 drivers/net/ethernet/aurora/nb8800.c             |  4 ++--
 drivers/net/ethernet/aurora/nb8800.h             |  2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c       |  4 ++--
 drivers/net/ethernet/broadcom/genet/bcmmii.c     |  8 ++++----
 drivers/net/ethernet/cadence/macb_main.c         |  7 ++++---
 drivers/net/ethernet/faraday/ftgmac100.c         |  6 +++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c |  7 ++++---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c  |  4 ++--
 drivers/net/ethernet/freescale/fec_main.c        |  7 ++++---
 drivers/net/ethernet/freescale/fman/mac.c        |  6 +++---
 drivers/net/ethernet/freescale/gianfar.c         |  7 ++++---
 drivers/net/ethernet/hisilicon/hip04_eth.c       |  7 +++----
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c    |  5 ++---
 drivers/net/ethernet/ibm/emac/core.c             |  5 +++--
 drivers/net/ethernet/marvell/mv643xx_eth.c       |  7 ++++---
 drivers/net/ethernet/marvell/mvneta.c            |  7 +++----
 drivers/net/ethernet/marvell/pxa168_eth.c        |  4 +++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c      |  8 ++++----
 drivers/net/ethernet/mscc/ocelot_board.c         | 12 ++++++------
 drivers/net/ethernet/ni/nixge.c                  |  5 ++---
 drivers/net/ethernet/renesas/ravb_main.c         |  4 +++-
 drivers/net/ethernet/renesas/sh_eth.c            |  7 ++++---
 .../net/ethernet/samsung/sxgbe/sxgbe_platform.c  |  5 ++++-
 drivers/net/ethernet/socionext/sni_ave.c         |  6 +++---
 .../net/ethernet/stmicro/stmmac/dwmac-anarion.c  | 10 +++++++---
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c  |  5 +++--
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c |  9 +++++----
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c  |  5 ++---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c   |  4 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c  |  9 +++++++--
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c    |  7 ++++---
 .../net/ethernet/stmicro/stmmac/dwmac-sunxi.c    |  8 ++++++--
 .../ethernet/stmicro/stmmac/stmmac_platform.c    |  6 +++---
 drivers/net/ethernet/ti/cpsw.c                   |  5 ++---
 drivers/net/ethernet/ti/cpsw_priv.h              |  2 +-
 drivers/net/ethernet/ti/netcp_ethss.c            |  5 +++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c    |  6 ++----
 drivers/of/of_mdio.c                             |  4 ++--
 drivers/of/of_net.c                              | 16 +++++++++++-----
 include/linux/of_net.h                           |  7 +++++--
 include/linux/stmmac.h                           |  3 ++-
 include/linux/sxgbe_platform.h                   |  4 +++-
 net/dsa/port.c                                   | 13 +++++++------
 net/dsa/slave.c                                  |  7 ++++---
 53 files changed, 201 insertions(+), 149 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 9add84c79dd6..67125a5487e1 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -381,8 +381,9 @@ static void bcm_sf2_identify_ports(struct bcm_sf2_priv *priv,
 				   struct device_node *dn)
 {
 	struct device_node *port;
-	int mode;
 	unsigned int port_num;
+	phy_interface_t mode;
+	int err;
 
 	priv->moca_port = -1;
 
@@ -395,8 +396,8 @@ static void bcm_sf2_identify_ports(struct bcm_sf2_priv *priv,
 		 * has completed, since they might be turned off at that
 		 * time
 		 */
-		mode = of_get_phy_mode(port);
-		if (mode < 0)
+		err = of_get_phy_mode(port, &mode);
+		if (err)
 			continue;
 
 		if (mode == PHY_INTERFACE_MODE_INTERNAL)
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5d08e4430824..d8fda4a02640 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -422,6 +422,7 @@ EXPORT_SYMBOL(ksz_switch_alloc);
 int ksz_switch_register(struct ksz_device *dev,
 			const struct ksz_dev_ops *ops)
 {
+	phy_interface_t interface;
 	int ret;
 
 	if (dev->pdata)
@@ -456,9 +457,9 @@ int ksz_switch_register(struct ksz_device *dev,
 	 * device tree.
 	 */
 	if (dev->dev->of_node) {
-		ret = of_get_phy_mode(dev->dev->of_node);
-		if (ret >= 0)
-			dev->interface = ret;
+		ret = of_get_phy_mode(dev->dev->of_node, &interface);
+		if (ret == 0)
+			dev->interface = interface;
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
 	}
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index add9e4279176..ed1ec10ec62b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1340,7 +1340,9 @@ mt7530_setup(struct dsa_switch *ds)
 
 	if (!dsa_is_unused_port(ds, 5)) {
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-		interface = of_get_phy_mode(dsa_to_port(ds, 5)->dn);
+		ret = of_get_phy_mode(dsa_to_port(ds, 5)->dn, &interface);
+		if (ret && ret != -ENODEV)
+			return ret;
 	} else {
 		/* Scan the ethernet nodes. look for GMAC1, lookup used phy */
 		for_each_child_of_node(dn, mac_np) {
@@ -1354,7 +1356,9 @@ mt7530_setup(struct dsa_switch *ds)
 
 			phy_node = of_parse_phandle(mac_np, "phy-handle", 0);
 			if (phy_node->parent == priv->dev->of_node->parent) {
-				interface = of_get_phy_mode(mac_np);
+				ret = of_get_phy_mode(mac_np, &interface);
+				if (ret && ret != -ENODEV)
+					return ret;
 				id = of_mdio_parse_addr(ds->dev, phy_node);
 				if (id == 0)
 					priv->p5_intf_sel = P5_INTF_SEL_PHY_P0;
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 36c6ed98f8e7..e548289df31e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -639,7 +639,8 @@ static int
 qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int ret, i, phy_mode = -1;
+	phy_interface_t phy_mode = PHY_INTERFACE_MODE_NA;
+	int ret, i;
 	u32 mask;
 
 	/* Make sure that port 0 is the cpu port */
@@ -661,10 +662,10 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Initialize CPU port pad mode (xMII type, delays...) */
-	phy_mode = of_get_phy_mode(dsa_to_port(ds, QCA8K_CPU_PORT)->dn);
-	if (phy_mode < 0) {
+	ret = of_get_phy_mode(dsa_to_port(ds, QCA8K_CPU_PORT)->dn, &phy_mode);
+	if (ret) {
 		pr_err("Can't find phy-mode for master device\n");
-		return phy_mode;
+		return ret;
 	}
 	ret = qca8k_set_pad_ctrl(priv, QCA8K_CPU_PORT, phy_mode);
 	if (ret < 0)
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2ae84a9dea59..d5dfda335aa1 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -584,8 +584,9 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 
 	for_each_child_of_node(ports_node, child) {
 		struct device_node *phy_node;
-		int phy_mode;
+		phy_interface_t phy_mode;
 		u32 index;
+		int err;
 
 		/* Get switch port number from DT */
 		if (of_property_read_u32(child, "reg", &index) < 0) {
@@ -596,8 +597,8 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 		}
 
 		/* Get PHY mode from DT */
-		phy_mode = of_get_phy_mode(child);
-		if (phy_mode < 0) {
+		err = of_get_phy_mode(child, &phy_mode);
+		if (err) {
 			dev_err(dev, "Failed to read phy-mode or "
 				"phy-interface-type property for port %d\n",
 				index);
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index bb032be7fe31..4cd53fc338b5 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -730,12 +730,12 @@ static int altera_tse_phy_get_addr_mdio_create(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
 	struct device_node *np = priv->device->of_node;
-	int ret = 0;
+	int ret;
 
-	priv->phy_iface = of_get_phy_mode(np);
+	ret = of_get_phy_mode(np, &priv->phy_iface);
 
 	/* Avoid get phy addr and create mdio if no phy is present */
-	if (!priv->phy_iface)
+	if (ret)
 		return 0;
 
 	/* try to get PHY address from device tree, use PHY autodetection if
diff --git a/drivers/net/ethernet/arc/emac_arc.c b/drivers/net/ethernet/arc/emac_arc.c
index 78e52d217e56..539166112993 100644
--- a/drivers/net/ethernet/arc/emac_arc.c
+++ b/drivers/net/ethernet/arc/emac_arc.c
@@ -20,9 +20,10 @@
 static int emac_arc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct net_device *ndev;
 	struct arc_emac_priv *priv;
-	int interface, err;
+	phy_interface_t interface;
+	struct net_device *ndev;
+	int err;
 
 	if (!dev->of_node)
 		return -ENODEV;
@@ -37,9 +38,13 @@ static int emac_arc_probe(struct platform_device *pdev)
 	priv->drv_name = DRV_NAME;
 	priv->drv_version = DRV_VERSION;
 
-	interface = of_get_phy_mode(dev->of_node);
-	if (interface < 0)
-		interface = PHY_INTERFACE_MODE_MII;
+	err = of_get_phy_mode(dev->of_node, &interface);
+	if (err) {
+		if (err == -ENODEV)
+			interface = PHY_INTERFACE_MODE_MII;
+		else
+			goto out_netdev;
+	}
 
 	priv->clk = devm_clk_get(dev, "hclk");
 	if (IS_ERR(priv->clk)) {
diff --git a/drivers/net/ethernet/arc/emac_rockchip.c b/drivers/net/ethernet/arc/emac_rockchip.c
index 664d664e0925..aae231c5224f 100644
--- a/drivers/net/ethernet/arc/emac_rockchip.c
+++ b/drivers/net/ethernet/arc/emac_rockchip.c
@@ -97,8 +97,9 @@ static int emac_rockchip_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	struct rockchip_priv_data *priv;
 	const struct of_device_id *match;
+	phy_interface_t interface;
 	u32 data;
-	int err, interface;
+	int err;
 
 	if (!pdev->dev.of_node)
 		return -ENODEV;
@@ -114,7 +115,9 @@ static int emac_rockchip_probe(struct platform_device *pdev)
 	priv->emac.drv_version = DRV_VERSION;
 	priv->emac.set_mac_speed = emac_rockchip_set_mac_speed;
 
-	interface = of_get_phy_mode(dev->of_node);
+	err = of_get_phy_mode(dev->of_node, &interface);
+	if (err)
+		goto out_netdev;
 
 	/* RK3036/RK3066/RK3188 SoCs only support RMII */
 	if (interface != PHY_INTERFACE_MODE_RMII) {
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 1b1a09095c0d..8f5021091eee 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1744,10 +1744,9 @@ static int ag71xx_probe(struct platform_device *pdev)
 		eth_random_addr(ndev->dev_addr);
 	}
 
-	ag->phy_if_mode = of_get_phy_mode(np);
-	if (ag->phy_if_mode < 0) {
+	err = of_get_phy_mode(np, ag->phy_if_mode);
+	if (err) {
 		netif_err(ag, probe, ndev, "missing phy-mode property in DT\n");
-		err = ag->phy_if_mode;
 		goto err_free;
 	}
 
diff --git a/drivers/net/ethernet/aurora/nb8800.c b/drivers/net/ethernet/aurora/nb8800.c
index 37752d9514e7..30b455013bf3 100644
--- a/drivers/net/ethernet/aurora/nb8800.c
+++ b/drivers/net/ethernet/aurora/nb8800.c
@@ -1371,8 +1371,8 @@ static int nb8800_probe(struct platform_device *pdev)
 	priv = netdev_priv(dev);
 	priv->base = base;
 
-	priv->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-	if (priv->phy_mode < 0)
+	ret = of_get_phy_mode(pdev->dev.of_node, &priv->phy_mode);
+	if (ret)
 		priv->phy_mode = PHY_INTERFACE_MODE_RGMII;
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
diff --git a/drivers/net/ethernet/aurora/nb8800.h b/drivers/net/ethernet/aurora/nb8800.h
index aacc3cce2cc0..40941fb6065b 100644
--- a/drivers/net/ethernet/aurora/nb8800.h
+++ b/drivers/net/ethernet/aurora/nb8800.h
@@ -287,7 +287,7 @@ struct nb8800_priv {
 	struct device_node		*phy_node;
 
 	/* PHY connection type from DT */
-	int				phy_mode;
+	phy_interface_t			phy_mode;
 
 	/* Current link status */
 	int				speed;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index a977a459bd20..825af709708e 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2479,9 +2479,9 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	priv->netdev = dev;
 	priv->pdev = pdev;
 
-	priv->phy_interface = of_get_phy_mode(dn);
+	ret = of_get_phy_mode(dn, &priv->phy_interface);
 	/* Default to GMII interface mode */
-	if ((int)priv->phy_interface < 0)
+	if (ret)
 		priv->phy_interface = PHY_INTERFACE_MODE_GMII;
 
 	/* In the case of a fixed PHY, the DT node associated
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 17bb8d60a157..b797a7e59a53 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -436,7 +436,7 @@ static int bcmgenet_mii_of_init(struct bcmgenet_priv *priv)
 	struct device_node *dn = priv->pdev->dev.of_node;
 	struct device *kdev = &priv->pdev->dev;
 	struct phy_device *phydev;
-	int phy_mode;
+	phy_interface_t phy_mode;
 	int ret;
 
 	/* Fetch the PHY phandle */
@@ -454,10 +454,10 @@ static int bcmgenet_mii_of_init(struct bcmgenet_priv *priv)
 	}
 
 	/* Get the link mode */
-	phy_mode = of_get_phy_mode(dn);
-	if (phy_mode < 0) {
+	ret = of_get_phy_mode(dn, &phy_mode);
+	if (ret) {
 		dev_err(kdev, "invalid PHY mode property\n");
-		return phy_mode;
+		return ret;
 	}
 
 	priv->phy_interface = phy_mode;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1e1b774e1953..b884cf7f339b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4182,6 +4182,7 @@ static int macb_probe(struct platform_device *pdev)
 	unsigned int queue_mask, num_queues;
 	bool native_io;
 	struct phy_device *phydev;
+	phy_interface_t interface;
 	struct net_device *dev;
 	struct resource *regs;
 	void __iomem *mem;
@@ -4308,12 +4309,12 @@ static int macb_probe(struct platform_device *pdev)
 		macb_get_hwaddr(bp);
 	}
 
-	err = of_get_phy_mode(np);
-	if (err < 0)
+	err = of_get_phy_mode(np, &interface);
+	if (err)
 		/* not found in DT, MII by default */
 		bp->phy_interface = PHY_INTERFACE_MODE_MII;
 	else
-		bp->phy_interface = err;
+		bp->phy_interface = interface;
 
 	/* IP specific init */
 	err = init(pdev);
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index da0c506349d1..a6f2063f1475 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1612,7 +1612,7 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
 	struct platform_device *pdev = to_platform_device(priv->dev);
-	int phy_intf = PHY_INTERFACE_MODE_RGMII;
+	phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
 	struct device_node *np = pdev->dev.of_node;
 	int i, err = 0;
 	u32 reg;
@@ -1637,8 +1637,8 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
 	/* Get PHY mode from device-tree */
 	if (np) {
 		/* Default to RGMII. It's a gigabit part after all */
-		phy_intf = of_get_phy_mode(np);
-		if (phy_intf < 0)
+		err = of_get_phy_mode(np, &phy_intf);
+		if (err)
 			phy_intf = PHY_INTERFACE_MODE_RGMII;
 
 		/* Aspeed only supports these. I don't know about other IP
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index fea388d86f20..b713739f4804 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -44,10 +44,11 @@ static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
 static int dpaa2_mac_get_if_mode(struct device_node *node,
 				 struct dpmac_attr attr)
 {
-	int if_mode;
+	phy_interface_t if_mode;
+	int err;
 
-	if_mode = of_get_phy_mode(node);
-	if (if_mode >= 0)
+	err = of_get_phy_mode(node, &if_mode);
+	if (!err)
 		return if_mode;
 
 	if_mode = phy_mode(attr.eth_if);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index b73421c3e25b..7da79b816416 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -784,8 +784,8 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 		}
 	}
 
-	priv->if_mode = of_get_phy_mode(np);
-	if ((int)priv->if_mode < 0) {
+	err = of_get_phy_mode(np, &priv->if_mode);
+	if (err) {
 		dev_err(priv->dev, "missing phy type\n");
 		of_node_put(priv->phy_node);
 		if (of_phy_is_fixed_link(np))
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 7d37ba9f6819..d4d6c2e941f1 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3393,6 +3393,7 @@ fec_probe(struct platform_device *pdev)
 {
 	struct fec_enet_private *fep;
 	struct fec_platform_data *pdata;
+	phy_interface_t interface;
 	struct net_device *ndev;
 	int i, irq, ret = 0;
 	const struct of_device_id *of_id;
@@ -3465,15 +3466,15 @@ fec_probe(struct platform_device *pdev)
 	}
 	fep->phy_node = phy_node;
 
-	ret = of_get_phy_mode(pdev->dev.of_node);
-	if (ret < 0) {
+	ret = of_get_phy_mode(pdev->dev.of_node, &interface);
+	if (ret) {
 		pdata = dev_get_platdata(&pdev->dev);
 		if (pdata)
 			fep->phy_interface = pdata->phy;
 		else
 			fep->phy_interface = PHY_INTERFACE_MODE_MII;
 	} else {
-		fep->phy_interface = ret;
+		fep->phy_interface = interface;
 	}
 
 	fep->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 7ab8095db192..f0806ace1ae2 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -608,7 +608,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	const u8		*mac_addr;
 	u32			 val;
 	u8			fman_id;
-	int			phy_if;
+	phy_interface_t          phy_if;
 
 	dev = &_of_dev->dev;
 	mac_node = dev->of_node;
@@ -776,8 +776,8 @@ static int mac_probe(struct platform_device *_of_dev)
 	}
 
 	/* Get the PHY connection type */
-	phy_if = of_get_phy_mode(mac_node);
-	if (phy_if < 0) {
+	err = of_get_phy_mode(mac_node, &phy_if);
+	if (err) {
 		dev_warn(dev,
 			 "of_get_phy_mode() for %pOF failed. Defaulting to SGMII\n",
 			 mac_node);
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 51ad86417cb1..72868a28b621 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -641,6 +641,7 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	const char *model;
 	const void *mac_addr;
 	int err = 0, i;
+	phy_interface_t interface;
 	struct net_device *dev = NULL;
 	struct gfar_private *priv = NULL;
 	struct device_node *np = ofdev->dev.of_node;
@@ -805,9 +806,9 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	 * rgmii-id really needs to be specified. Other types can be
 	 * detected by hardware
 	 */
-	err = of_get_phy_mode(np);
-	if (err >= 0)
-		priv->interface = err;
+	err = of_get_phy_mode(np, &interface);
+	if (!err)
+		priv->interface = interface;
 	else
 		priv->interface = gfar_get_interface(dev);
 
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 4606a7e4a6d1..3e9b6d543c77 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -211,7 +211,7 @@ struct hip04_priv {
 #if defined(CONFIG_HI13X1_GMAC)
 	void __iomem *sysctrl_base;
 #endif
-	int phy_mode;
+	phy_interface_t phy_mode;
 	int chan;
 	unsigned int port;
 	unsigned int group;
@@ -961,10 +961,9 @@ static int hip04_mac_probe(struct platform_device *pdev)
 		goto init_fail;
 	}
 
-	priv->phy_mode = of_get_phy_mode(node);
-	if (priv->phy_mode < 0) {
+	ret = of_get_phy_mode(node, &priv->phy_mode);
+	if (ret) {
 		dev_warn(d, "not find phy-mode\n");
-		ret = -EINVAL;
 		goto init_fail;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index c41b19c760f8..247de9105d10 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1193,10 +1193,9 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_free_mdio;
 
-	priv->phy_mode = of_get_phy_mode(node);
-	if ((int)priv->phy_mode < 0) {
+	ret = of_get_phy_mode(node, &priv->phy_mode);
+	if (ret) {
 		netdev_err(ndev, "not find phy-mode\n");
-		ret = -EINVAL;
 		goto err_mdiobus;
 	}
 
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 9e43c9ace9c2..2e40425d8a34 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2849,6 +2849,7 @@ static int emac_init_config(struct emac_instance *dev)
 {
 	struct device_node *np = dev->ofdev->dev.of_node;
 	const void *p;
+	int err;
 
 	/* Read config from device-tree */
 	if (emac_read_uint_prop(np, "mal-device", &dev->mal_ph, 1))
@@ -2897,8 +2898,8 @@ static int emac_init_config(struct emac_instance *dev)
 		dev->mal_burst_size = 256;
 
 	/* PHY mode needs some decoding */
-	dev->phy_mode = of_get_phy_mode(np);
-	if (dev->phy_mode < 0)
+	err = of_get_phy_mode(np, &dev->phy_mode);
+	if (err)
 		dev->phy_mode = PHY_INTERFACE_MODE_NA;
 
 	/* Check EMAC version */
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 82ea55ae5053..d5b644131cff 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2959,15 +2959,16 @@ static void set_params(struct mv643xx_eth_private *mp,
 static int get_phy_mode(struct mv643xx_eth_private *mp)
 {
 	struct device *dev = mp->dev->dev.parent;
-	int iface = -1;
+	phy_interface_t iface;
+	int err;
 
 	if (dev->of_node)
-		iface = of_get_phy_mode(dev->of_node);
+		err = of_get_phy_mode(dev->of_node, &iface);
 
 	/* Historical default if unspecified. We could also read/write
 	 * the interface state in the PSC1
 	 */
-	if (iface < 0)
+	if (!dev->of_node || err)
 		iface = PHY_INTERFACE_MODE_GMII;
 	return iface;
 }
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 8f9df6efda61..274ac39c0f0f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4797,9 +4797,9 @@ static int mvneta_probe(struct platform_device *pdev)
 	struct phy *comphy;
 	const char *dt_mac_addr;
 	char hw_mac_addr[ETH_ALEN];
+	phy_interface_t phy_mode;
 	const char *mac_from;
 	int tx_csum_limit;
-	int phy_mode;
 	int err;
 	int cpu;
 
@@ -4812,10 +4812,9 @@ static int mvneta_probe(struct platform_device *pdev)
 	if (dev->irq == 0)
 		return -EINVAL;
 
-	phy_mode = of_get_phy_mode(dn);
-	if (phy_mode < 0) {
+	err = of_get_phy_mode(dn, &phy_mode);
+	if (err) {
 		dev_err(&pdev->dev, "incorrect phy-mode\n");
-		err = -EINVAL;
 		goto err_free_irq;
 	}
 
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 51b77c2de400..3fb7ee3d4d13 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1489,8 +1489,10 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 			goto err_netdev;
 		}
 		of_property_read_u32(np, "reg", &pep->phy_addr);
-		pep->phy_intf = of_get_phy_mode(pdev->dev.of_node);
 		of_node_put(np);
+		err = of_get_phy_mode(pdev->dev.of_node, &pep->phy_intf);
+		if (err && err != -ENODEV)
+			goto err_netdev;
 	}
 
 	/* Hardware supports only 3 ports */
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 703adb96429e..385a4ab9ec99 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2758,9 +2758,10 @@ static const struct net_device_ops mtk_netdev_ops = {
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 {
 	const __be32 *_id = of_get_property(np, "reg", NULL);
+	phy_interface_t phy_mode;
 	struct phylink *phylink;
-	int phy_mode, id, err;
 	struct mtk_mac *mac;
+	int id, err;
 
 	if (!_id) {
 		dev_err(eth->dev, "missing mac id\n");
@@ -2805,10 +2806,9 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	mac->hw_stats->reg_offset = id * MTK_STAT_OFFSET;
 
 	/* phylink create */
-	phy_mode = of_get_phy_mode(np);
-	if (phy_mode < 0) {
+	err = of_get_phy_mode(np, &phy_mode);
+	if (err) {
 		dev_err(eth->dev, "incorrect phy-mode\n");
-		err = -EINVAL;
 		goto free_netdev;
 	}
 
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index aac115136720..723724bdc139 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -364,12 +364,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	for_each_available_child_of_node(ports, portnp) {
 		struct device_node *phy_node;
+		phy_interface_t phy_mode;
 		struct phy_device *phy;
 		struct resource *res;
 		struct phy *serdes;
 		void __iomem *regs;
 		char res_name[8];
-		int phy_mode;
 		u32 port;
 
 		if (of_property_read_u32(portnp, "reg", &port))
@@ -398,11 +398,11 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 			goto out_put_ports;
 		}
 
-		phy_mode = of_get_phy_mode(portnp);
-		if (phy_mode < 0)
-			ocelot->ports[port]->phy_mode = PHY_INTERFACE_MODE_NA;
-		else
-			ocelot->ports[port]->phy_mode = phy_mode;
+		err = of_get_phy_mode(portnp, &phy_mode);
+		if (err && err != -ENODEV)
+			goto out_put_ports;
+
+		ocelot->ports[port]->phy_mode = phy_mode;
 
 		switch (ocelot->ports[port]->phy_mode) {
 		case PHY_INTERFACE_MODE_NA:
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 2761f3a3ae50..49c7987c2abd 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1346,10 +1346,9 @@ static int nixge_probe(struct platform_device *pdev)
 		}
 	}
 
-	priv->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-	if ((int)priv->phy_mode < 0) {
+	err = of_get_phy_mode(pdev->dev.of_node, &priv->phy_mode);
+	if (err) {
 		netdev_err(ndev, "not find \"phy-mode\" property\n");
-		err = -EINVAL;
 		goto unregister_mdio;
 	}
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index de9aa8c47f1c..5ea14b5fbed8 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2046,7 +2046,9 @@ static int ravb_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->lock);
 	INIT_WORK(&priv->work, ravb_tx_timeout_work);
 
-	priv->phy_interface = of_get_phy_mode(np);
+	error = of_get_phy_mode(np, &priv->phy_interface);
+	if (error && error != -ENODEV)
+		goto out_release;
 
 	priv->no_avb_link = of_property_read_bool(np, "renesas,no-ether-link");
 	priv->avb_link_active_low =
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 7ba35a0bdb29..e19b49c4013e 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3183,6 +3183,7 @@ static struct sh_eth_plat_data *sh_eth_parse_dt(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
 	struct sh_eth_plat_data *pdata;
+	phy_interface_t interface;
 	const char *mac_addr;
 	int ret;
 
@@ -3190,10 +3191,10 @@ static struct sh_eth_plat_data *sh_eth_parse_dt(struct device *dev)
 	if (!pdata)
 		return NULL;
 
-	ret = of_get_phy_mode(np);
-	if (ret < 0)
+	ret = of_get_phy_mode(np, &interface);
+	if (ret)
 		return NULL;
-	pdata->phy_interface = ret;
+	pdata->phy_interface = interface;
 
 	mac_addr = of_get_mac_address(np);
 	if (!IS_ERR(mac_addr))
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
index 2412c87561e0..33f79402850d 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
@@ -30,12 +30,15 @@ static int sxgbe_probe_config_dt(struct platform_device *pdev,
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct sxgbe_dma_cfg *dma_cfg;
+	int err;
 
 	if (!np)
 		return -ENODEV;
 
 	*mac = of_get_mac_address(np);
-	plat->interface = of_get_phy_mode(np);
+	err = of_get_phy_mode(np, &plat->interface);
+	if (err && err != -ENODEV)
+		return err;
 
 	plat->bus_id = of_alias_get_id(np, "ethernet");
 	if (plat->bus_id < 0)
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 6e984d5a729f..f7e927ad67fa 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1565,10 +1565,10 @@ static int ave_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	np = dev->of_node;
-	phy_mode = of_get_phy_mode(np);
-	if ((int)phy_mode < 0) {
+	ret = of_get_phy_mode(np, &phy_mode);
+	if (ret) {
 		dev_err(dev, "phy-mode not found\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	irq = platform_get_irq(pdev, 0);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
index 527f93320a5a..d0d2d0fc5f0a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
@@ -61,9 +61,10 @@ static void anarion_gmac_exit(struct platform_device *pdev, void *priv)
 
 static struct anarion_gmac *anarion_config_dt(struct platform_device *pdev)
 {
-	int phy_mode;
-	void __iomem *ctl_block;
 	struct anarion_gmac *gmac;
+	phy_interface_t phy_mode;
+	void __iomem *ctl_block;
+	int err;
 
 	ctl_block = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(ctl_block)) {
@@ -78,7 +79,10 @@ static struct anarion_gmac *anarion_config_dt(struct platform_device *pdev)
 
 	gmac->ctl_block = (uintptr_t)ctl_block;
 
-	phy_mode = of_get_phy_mode(pdev->dev.of_node);
+	err = of_get_phy_mode(pdev->dev.of_node, &phy_mode);
+	if (err)
+		return ERR_PTR(err);
+
 	switch (phy_mode) {
 	case PHY_INTERFACE_MODE_RGMII:		/* Fall through */
 	case PHY_INTERFACE_MODE_RGMII_ID	/* Fall through */:
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 0d21082ceb93..6ae13dc19510 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -189,9 +189,10 @@ static int ipq806x_gmac_set_speed(struct ipq806x_gmac *gmac, unsigned int speed)
 static int ipq806x_gmac_of_parse(struct ipq806x_gmac *gmac)
 {
 	struct device *dev = &gmac->pdev->dev;
+	int ret;
 
-	gmac->phy_mode = of_get_phy_mode(dev->of_node);
-	if ((int)gmac->phy_mode < 0) {
+	ret = of_get_phy_mode(dev->of_node, &gmac->phy_mode);
+	if (ret) {
 		dev_err(dev, "missing phy mode property\n");
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index cea7a0c7ce68..bdb80421acac 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -54,7 +54,7 @@ struct mediatek_dwmac_plat_data {
 	struct device_node *np;
 	struct regmap *peri_regmap;
 	struct device *dev;
-	int phy_mode;
+	phy_interface_t phy_mode;
 	bool rmii_rxc;
 };
 
@@ -243,6 +243,7 @@ static int mediatek_dwmac_config_dt(struct mediatek_dwmac_plat_data *plat)
 {
 	struct mac_delay_struct *mac_delay = &plat->mac_delay;
 	u32 tx_delay_ps, rx_delay_ps;
+	int err;
 
 	plat->peri_regmap = syscon_regmap_lookup_by_phandle(plat->np, "mediatek,pericfg");
 	if (IS_ERR(plat->peri_regmap)) {
@@ -250,10 +251,10 @@ static int mediatek_dwmac_config_dt(struct mediatek_dwmac_plat_data *plat)
 		return PTR_ERR(plat->peri_regmap);
 	}
 
-	plat->phy_mode = of_get_phy_mode(plat->np);
-	if (plat->phy_mode < 0) {
+	err = of_get_phy_mode(plat->np, &plat->phy_mode);
+	if (err) {
 		dev_err(plat->dev, "not find phy-mode\n");
-		return -EINVAL;
+		return err;
 	}
 
 	if (!of_property_read_u32(plat->np, "mediatek,tx-delay-ps", &tx_delay_ps)) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 306da8f6b7d5..bd6c01004913 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -338,10 +338,9 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 	}
 
 	dwmac->dev = &pdev->dev;
-	dwmac->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-	if ((int)dwmac->phy_mode < 0) {
+	ret = of_get_phy_mode(pdev->dev.of_node, &dwmac->phy_mode);
+	if (ret) {
 		dev_err(&pdev->dev, "missing phy-mode property\n");
-		ret = -EINVAL;
 		goto err_remove_config_dt;
 	}
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index e2e469c37a4d..dc50ba13a746 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -37,7 +37,7 @@ struct rk_gmac_ops {
 
 struct rk_priv_data {
 	struct platform_device *pdev;
-	int phy_iface;
+	phy_interface_t phy_iface;
 	struct regulator *regulator;
 	bool suspended;
 	const struct rk_gmac_ops *ops;
@@ -1224,7 +1224,7 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 	if (!bsp_priv)
 		return ERR_PTR(-ENOMEM);
 
-	bsp_priv->phy_iface = of_get_phy_mode(dev->of_node);
+	of_get_phy_mode(dev->of_node, &bsp_priv->phy_iface);
 	bsp_priv->ops = ops;
 
 	bsp_priv->regulator = devm_regulator_get_optional(dev, "phy");
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
index e9fd661f7995..e1b63df6f96f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
@@ -116,7 +116,7 @@
 #define ETH_PHY_SEL_MII		0x0
 
 struct sti_dwmac {
-	int interface;		/* MII interface */
+	phy_interface_t interface;	/* MII interface */
 	bool ext_phyclk;	/* Clock from external PHY */
 	u32 tx_retime_src;	/* TXCLK Retiming*/
 	struct clk *clk;	/* PHY clock */
@@ -269,7 +269,12 @@ static int sti_dwmac_parse_data(struct sti_dwmac *dwmac,
 		return err;
 	}
 
-	dwmac->interface = of_get_phy_mode(np);
+	err = of_get_phy_mode(np, &dwmac->interface);
+	if (err && err != -ENODEV) {
+		dev_err(dev, "Can't get phy-mode\n");
+		return err;
+	}
+
 	dwmac->regmap = regmap;
 	dwmac->gmac_en = of_property_read_bool(np, "st,gmac_en");
 	dwmac->ext_phyclk = of_property_read_bool(np, "st,ext-phyclk");
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index ddcc191febdb..eefb06d918c8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1105,6 +1105,7 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	struct stmmac_resources stmmac_res;
 	struct sunxi_priv_data *gmac;
 	struct device *dev = &pdev->dev;
+	phy_interface_t interface;
 	int ret;
 	struct stmmac_priv *priv;
 	struct net_device *ndev;
@@ -1178,10 +1179,10 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = of_get_phy_mode(dev->of_node);
-	if (ret < 0)
+	ret = of_get_phy_mode(dev->of_node, &interface);
+	if (ret)
 		return -EINVAL;
-	plat_dat->interface = ret;
+	plat_dat->interface = interface;
 
 	/* platform data specifying hardware features and callbacks.
 	 * hardware features were copied from Allwinner drivers.
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
index a299da3971b4..26353ef616b8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -18,7 +18,7 @@
 #include "stmmac_platform.h"
 
 struct sunxi_priv_data {
-	int interface;
+	phy_interface_t interface;
 	int clk_enabled;
 	struct clk *tx_clk;
 	struct regulator *regulator;
@@ -118,7 +118,11 @@ static int sun7i_gmac_probe(struct platform_device *pdev)
 		goto err_remove_config_dt;
 	}
 
-	gmac->interface = of_get_phy_mode(dev->of_node);
+	ret = of_get_phy_mode(dev->of_node, &gmac->interface);
+	if (ret && ret != -ENODEV) {
+		dev_err(dev, "Can't get phy-mode\n");
+		goto err_remove_config_dt;
+	}
 
 	gmac->tx_clk = devm_clk_get(dev, "allwinner_gmac_tx");
 	if (IS_ERR(gmac->tx_clk)) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 170c3a052b14..bedaff0c13bd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -412,9 +412,9 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		*mac = NULL;
 	}
 
-	plat->phy_interface = of_get_phy_mode(np);
-	if (plat->phy_interface < 0)
-		return ERR_PTR(plat->phy_interface);
+	rc = of_get_phy_mode(np, &plat->phy_interface);
+	if (rc)
+		return ERR_PTR(rc);
 
 	plat->interface = stmmac_of_get_mac_mode(np);
 	if (plat->interface < 0)
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index f298d714efd6..329671e66fe4 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2619,11 +2619,10 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 				i);
 			goto no_phy_slave;
 		}
-		slave_data->phy_if = of_get_phy_mode(slave_node);
-		if (slave_data->phy_if < 0) {
+		ret = of_get_phy_mode(slave_node, &slave_data->phy_if);
+		if (ret) {
 			dev_err(&pdev->dev, "Missing or malformed slave[%d] phy-mode property\n",
 				i);
-			ret = slave_data->phy_if;
 			goto err_node_put;
 		}
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 362c5a986869..8bfa761fa552 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -275,7 +275,7 @@ struct cpsw_slave_data {
 	struct device_node *slave_node;
 	struct device_node *phy_node;
 	char		phy_id[MII_BUS_ID_SIZE];
-	int		phy_if;
+	phy_interface_t	phy_if;
 	u8		mac_addr[ETH_ALEN];
 	u16		dual_emac_res_vlan;	/* Reserved VLAN for DualEMAC */
 	struct phy	*ifphy;
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 2c1fac33136c..86a3f42a3dcc 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -2291,6 +2291,7 @@ static int gbe_slave_open(struct gbe_intf *gbe_intf)
 	struct gbe_slave *slave = gbe_intf->slave;
 	phy_interface_t phy_mode;
 	bool has_phy = false;
+	int err;
 
 	void (*hndlr)(struct net_device *) = gbe_adjust_link;
 
@@ -2320,11 +2321,11 @@ static int gbe_slave_open(struct gbe_intf *gbe_intf)
 		slave->phy_port_t = PORT_MII;
 	} else if (slave->link_interface == RGMII_LINK_MAC_PHY) {
 		has_phy = true;
-		phy_mode = of_get_phy_mode(slave->node);
+		err = of_get_phy_mode(slave->node, &phy_mode);
 		/* if phy-mode is not present, default to
 		 * PHY_INTERFACE_MODE_RGMII
 		 */
-		if (phy_mode < 0)
+		if (err)
 			phy_mode = PHY_INTERFACE_MODE_RGMII;
 
 		if (!phy_interface_mode_is_rgmii(phy_mode)) {
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 676006f32f91..867726d696e2 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1761,11 +1761,9 @@ static int axienet_probe(struct platform_device *pdev)
 			goto free_netdev;
 		}
 	} else {
-		lp->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-		if ((int)lp->phy_mode < 0) {
-			ret = -EINVAL;
+		ret = of_get_phy_mode(pdev->dev.of_node, &lp->phy_mode);
+		if (ret)
 			goto free_netdev;
-		}
 	}
 
 	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index bd6129db6417..c6b87ce2b0cc 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -361,8 +361,8 @@ struct phy_device *of_phy_get_and_connect(struct net_device *dev,
 	struct phy_device *phy;
 	int ret;
 
-	iface = of_get_phy_mode(np);
-	if ((int)iface < 0)
+	ret = of_get_phy_mode(np, &iface);
+	if (ret)
 		return NULL;
 	if (of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index b02734aff8c1..6e411821583e 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -15,16 +15,20 @@
 /**
  * of_get_phy_mode - Get phy mode for given device_node
  * @np:	Pointer to the given device_node
+ * @interface: Pointer to the result
  *
  * The function gets phy interface string from property 'phy-mode' or
- * 'phy-connection-type', and return its index in phy_modes table, or errno in
- * error case.
+ * 'phy-connection-type'. The index in phy_modes table is set in
+ * interface and 0 returned. In case of error interface is set to
+ * PHY_INTERFACE_MODE_NA and an errno is returned, e.g. -ENODEV.
  */
-int of_get_phy_mode(struct device_node *np)
+int of_get_phy_mode(struct device_node *np, phy_interface_t *interface)
 {
 	const char *pm;
 	int err, i;
 
+	*interface = PHY_INTERFACE_MODE_NA;
+
 	err = of_property_read_string(np, "phy-mode", &pm);
 	if (err < 0)
 		err = of_property_read_string(np, "phy-connection-type", &pm);
@@ -32,8 +36,10 @@ int of_get_phy_mode(struct device_node *np)
 		return err;
 
 	for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++)
-		if (!strcasecmp(pm, phy_modes(i)))
-			return i;
+		if (!strcasecmp(pm, phy_modes(i))) {
+			*interface = i;
+			return 0;
+		}
 
 	return -ENODEV;
 }
diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index 6aeaea1775e6..71bbfcf3adcd 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -6,15 +6,18 @@
 #ifndef __LINUX_OF_NET_H
 #define __LINUX_OF_NET_H
 
+#include <linux/phy.h>
+
 #ifdef CONFIG_OF_NET
 #include <linux/of.h>
 
 struct net_device;
-extern int of_get_phy_mode(struct device_node *np);
+extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
 extern const void *of_get_mac_address(struct device_node *np);
 extern struct net_device *of_find_net_device_by_node(struct device_node *np);
 #else
-static inline int of_get_phy_mode(struct device_node *np)
+static inline int of_get_phy_mode(struct device_node *np,
+				  phy_interface_t *interface)
 {
 	return -ENODEV;
 }
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 86f9464c3f5d..d4bcd9387136 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -13,6 +13,7 @@
 #define __STMMAC_PLATFORM_DATA
 
 #include <linux/platform_device.h>
+#include <linux/phy.h>
 
 #define MTL_MAX_RX_QUEUES	8
 #define MTL_MAX_TX_QUEUES	8
@@ -132,7 +133,7 @@ struct plat_stmmacenet_data {
 	int bus_id;
 	int phy_addr;
 	int interface;
-	int phy_interface;
+	phy_interface_t phy_interface;
 	struct stmmac_mdio_bus_data *mdio_bus_data;
 	struct device_node *phy_node;
 	struct device_node *phylink_node;
diff --git a/include/linux/sxgbe_platform.h b/include/linux/sxgbe_platform.h
index 267369110584..85ec745767bd 100644
--- a/include/linux/sxgbe_platform.h
+++ b/include/linux/sxgbe_platform.h
@@ -10,6 +10,8 @@
 #ifndef __SXGBE_PLATFORM_H__
 #define __SXGBE_PLATFORM_H__
 
+#include <linux/phy.h>
+
 /* MDC Clock Selection define*/
 #define SXGBE_CSR_100_150M	0x0	/* MDC = clk_scr_i/62 */
 #define SXGBE_CSR_150_250M	0x1	/* MDC = clk_scr_i/102 */
@@ -38,7 +40,7 @@ struct sxgbe_plat_data {
 	char *phy_bus_name;
 	int bus_id;
 	int phy_addr;
-	int interface;
+	phy_interface_t interface;
 	struct sxgbe_mdio_bus_data *mdio_bus_data;
 	struct sxgbe_dma_cfg *dma_cfg;
 	int clk_csr;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 9b54e5a76297..6e93c36bf0c0 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -561,7 +561,7 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 	struct dsa_switch *ds = dp->ds;
 	struct phy_device *phydev;
 	int port = dp->index;
-	int mode;
+	phy_interface_t mode;
 	int err;
 
 	err = of_phy_register_fixed_link(dn);
@@ -574,8 +574,8 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 
 	phydev = of_phy_find_device(dn);
 
-	mode = of_get_phy_mode(dn);
-	if (mode < 0)
+	err = of_get_phy_mode(dn, &mode);
+	if (err)
 		mode = PHY_INTERFACE_MODE_NA;
 	phydev->interface = mode;
 
@@ -593,10 +593,11 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *port_dn = dp->dn;
-	int mode, err;
+	phy_interface_t mode;
+	int err;
 
-	mode = of_get_phy_mode(port_dn);
-	if (mode < 0)
+	err = of_get_phy_mode(port_dn, &mode);
+	if (err)
 		mode = PHY_INTERFACE_MODE_NA;
 
 	dp->pl_config.dev = ds->dev;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d18761649754..78ffc87dc25e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1313,11 +1313,12 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
 	struct device_node *port_dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
+	phy_interface_t mode;
 	u32 phy_flags = 0;
-	int mode, ret;
+	int ret;
 
-	mode = of_get_phy_mode(port_dn);
-	if (mode < 0)
+	ret = of_get_phy_mode(port_dn, &mode);
+	if (ret)
 		mode = PHY_INTERFACE_MODE_NA;
 
 	dp->pl_config.dev = &slave_dev->dev;
-- 
2.24.0.rc0


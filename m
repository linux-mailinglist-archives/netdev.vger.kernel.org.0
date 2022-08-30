Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7D95A5FFB
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiH3J5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiH3J4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:56:19 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04E4A926E;
        Tue, 30 Aug 2022 02:56:02 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1F3581BF20C;
        Tue, 30 Aug 2022 09:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661853360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z9hJpFFT1cAizsFGV/S1JG/Ff376zbaCyZ64c7pYykU=;
        b=EI7oLTLVmhdYtdZ+D2awau6KH1369UXNQvfWevaPLdh4Q+HtCRuP2gnZ7N/2i59CLK++/o
        uES1HiQi0H0P6wUySkoYi/SrecXAsq5t5RRnCi5U2uqSOUikHpbOIjqMzhAtSl6QdoNzIc
        gEQfK/CQlL72mD3048CkuTjVIqkUpl5rra7ZivV4ROD9R4J8AVYjnPADbBX4YWX3eXGD1h
        /+FDHBwOJOnq1qvrl1GKjiHHgmE7TYx/kU7h9obqPnRGBOY5hJwsgCbNFqzr0paPq13/5p
        cMjZoBhXmVvYwRQ2f5ZtQ4aKFWgOeXeVJRq3o63R/E7HZ0ONYK7lhuwAjS/oyg==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v2 4/5] net: altera: tse: convert to phylink
Date:   Tue, 30 Aug 2022 11:55:48 +0200
Message-Id: <20220830095549.120625-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
References: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit converts the Altera Triple Speed Ethernet Controller to
phylink. This controller supports MII, GMII and RGMII with its MAC, and
SGMII + 1000BaseX through a small embedded PCS.

The PCS itself has a register set very similar to what is found in a
typical 802.3 ethernet PHY, but this register set memory-mapped instead
of lying on an mdio bus.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V1->V2 : Removed stray DT makefile patching that had nothing to do with
this patch

 drivers/net/ethernet/altera/Kconfig           |   2 +
 drivers/net/ethernet/altera/altera_tse.h      |  19 +-
 .../net/ethernet/altera/altera_tse_ethtool.c  |  20 +-
 drivers/net/ethernet/altera/altera_tse_main.c | 414 +++++-------------
 4 files changed, 141 insertions(+), 314 deletions(-)

diff --git a/drivers/net/ethernet/altera/Kconfig b/drivers/net/ethernet/altera/Kconfig
index 914e56b91467..dd7fd41ccde5 100644
--- a/drivers/net/ethernet/altera/Kconfig
+++ b/drivers/net/ethernet/altera/Kconfig
@@ -3,6 +3,8 @@ config ALTERA_TSE
 	tristate "Altera Triple-Speed Ethernet MAC support"
 	depends on HAS_DMA
 	select PHYLIB
+	select PHYLINK
+	select PCS_ALTERA_TSE
 	help
 	  This driver supports the Altera Triple-Speed (TSE) Ethernet MAC.
 
diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index f17acfb579a0..db5eed06e92d 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -27,6 +27,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/phy.h>
+#include <linux/phylink.h>
 
 #define ALTERA_TSE_SW_RESET_WATCHDOG_CNTR	10000
 #define ALTERA_TSE_MAC_FIFO_WIDTH		4	/* TX/RX FIFO width in
@@ -109,17 +110,6 @@
 #define MAC_CMDCFG_DISABLE_READ_TIMEOUT_GET(v)	GET_BIT_VALUE(v, 27)
 #define MAC_CMDCFG_CNT_RESET_GET(v)		GET_BIT_VALUE(v, 31)
 
-/* SGMII PCS register addresses
- */
-#define SGMII_PCS_SCRATCH	0x10
-#define SGMII_PCS_REV		0x11
-#define SGMII_PCS_LINK_TIMER_0	0x12
-#define SGMII_PCS_LINK_TIMER_1	0x13
-#define SGMII_PCS_IF_MODE	0x14
-#define SGMII_PCS_DIS_READ_TO	0x15
-#define SGMII_PCS_READ_TO	0x16
-#define SGMII_PCS_SW_RESET_TIMEOUT 100 /* usecs */
-
 /* MDIO registers within MAC register Space
  */
 struct altera_tse_mdio {
@@ -423,6 +413,9 @@ struct altera_tse_private {
 	void __iomem *tx_dma_csr;
 	void __iomem *tx_dma_desc;
 
+	/* SGMII PCS address space */
+	void __iomem *pcs_base;
+
 	/* Rx buffers queue */
 	struct tse_buffer *rx_ring;
 	u32 rx_cons;
@@ -480,6 +473,10 @@ struct altera_tse_private {
 	u32 msg_enable;
 
 	struct altera_dmaops *dmaops;
+
+	struct phylink *phylink;
+	struct phylink_config phylink_config;
+	struct phylink_pcs *pcs;
 };
 
 /* Function prototypes
diff --git a/drivers/net/ethernet/altera/altera_tse_ethtool.c b/drivers/net/ethernet/altera/altera_tse_ethtool.c
index f0b11a278644..81313c85833e 100644
--- a/drivers/net/ethernet/altera/altera_tse_ethtool.c
+++ b/drivers/net/ethernet/altera/altera_tse_ethtool.c
@@ -221,6 +221,22 @@ static void tse_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 		buf[i] = csrrd32(priv->mac_dev, i * 4);
 }
 
+static int tse_ethtool_set_link_ksettings(struct net_device *dev,
+					  const struct ethtool_link_ksettings *cmd)
+{
+	struct altera_tse_private *priv = netdev_priv(dev);
+
+	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
+}
+
+static int tse_ethtool_get_link_ksettings(struct net_device *dev,
+					  struct ethtool_link_ksettings *cmd)
+{
+	struct altera_tse_private *priv = netdev_priv(dev);
+
+	return phylink_ethtool_ksettings_get(priv->phylink, cmd);
+}
+
 static const struct ethtool_ops tse_ethtool_ops = {
 	.get_drvinfo = tse_get_drvinfo,
 	.get_regs_len = tse_reglen,
@@ -231,8 +247,8 @@ static const struct ethtool_ops tse_ethtool_ops = {
 	.get_ethtool_stats = tse_fill_stats,
 	.get_msglevel = tse_get_msglevel,
 	.set_msglevel = tse_set_msglevel,
-	.get_link_ksettings = phy_ethtool_get_link_ksettings,
-	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_link_ksettings = tse_ethtool_get_link_ksettings,
+	.set_link_ksettings = tse_ethtool_set_link_ksettings,
 	.get_ts_info = ethtool_op_get_ts_info,
 };
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 930afc9ec833..89ae6d1623aa 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -32,6 +32,7 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
+#include <linux/pcs-altera-tse.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/skbuff.h>
@@ -86,27 +87,6 @@ static inline u32 tse_tx_avail(struct altera_tse_private *priv)
 	return priv->tx_cons + priv->tx_ring_size - priv->tx_prod - 1;
 }
 
-/* PCS Register read/write functions
- */
-static u16 sgmii_pcs_read(struct altera_tse_private *priv, int regnum)
-{
-	return csrrd32(priv->mac_dev,
-		       tse_csroffs(mdio_phy0) + regnum * 4) & 0xffff;
-}
-
-static void sgmii_pcs_write(struct altera_tse_private *priv, int regnum,
-				u16 value)
-{
-	csrwr32(value, priv->mac_dev, tse_csroffs(mdio_phy0) + regnum * 4);
-}
-
-/* Check PCS scratch memory */
-static int sgmii_pcs_scratch_test(struct altera_tse_private *priv, u16 value)
-{
-	sgmii_pcs_write(priv, SGMII_PCS_SCRATCH, value);
-	return (sgmii_pcs_read(priv, SGMII_PCS_SCRATCH) == value);
-}
-
 /* MDIO specific functions
  */
 static int altera_tse_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
@@ -620,117 +600,6 @@ static netdev_tx_t tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
-/* Called every time the controller might need to be made
- * aware of new link state.  The PHY code conveys this
- * information through variables in the phydev structure, and this
- * function converts those variables into the appropriate
- * register values, and can bring down the device if needed.
- */
-static void altera_tse_adjust_link(struct net_device *dev)
-{
-	struct altera_tse_private *priv = netdev_priv(dev);
-	struct phy_device *phydev = dev->phydev;
-	int new_state = 0;
-
-	/* only change config if there is a link */
-	spin_lock(&priv->mac_cfg_lock);
-	if (phydev->link) {
-		/* Read old config */
-		u32 cfg_reg = ioread32(&priv->mac_dev->command_config);
-
-		/* Check duplex */
-		if (phydev->duplex != priv->oldduplex) {
-			new_state = 1;
-			if (!(phydev->duplex))
-				cfg_reg |= MAC_CMDCFG_HD_ENA;
-			else
-				cfg_reg &= ~MAC_CMDCFG_HD_ENA;
-
-			netdev_dbg(priv->dev, "%s: Link duplex = 0x%x\n",
-				   dev->name, phydev->duplex);
-
-			priv->oldduplex = phydev->duplex;
-		}
-
-		/* Check speed */
-		if (phydev->speed != priv->oldspeed) {
-			new_state = 1;
-			switch (phydev->speed) {
-			case 1000:
-				cfg_reg |= MAC_CMDCFG_ETH_SPEED;
-				cfg_reg &= ~MAC_CMDCFG_ENA_10;
-				break;
-			case 100:
-				cfg_reg &= ~MAC_CMDCFG_ETH_SPEED;
-				cfg_reg &= ~MAC_CMDCFG_ENA_10;
-				break;
-			case 10:
-				cfg_reg &= ~MAC_CMDCFG_ETH_SPEED;
-				cfg_reg |= MAC_CMDCFG_ENA_10;
-				break;
-			default:
-				if (netif_msg_link(priv))
-					netdev_warn(dev, "Speed (%d) is not 10/100/1000!\n",
-						    phydev->speed);
-				break;
-			}
-			priv->oldspeed = phydev->speed;
-		}
-		iowrite32(cfg_reg, &priv->mac_dev->command_config);
-
-		if (!priv->oldlink) {
-			new_state = 1;
-			priv->oldlink = 1;
-		}
-	} else if (priv->oldlink) {
-		new_state = 1;
-		priv->oldlink = 0;
-		priv->oldspeed = 0;
-		priv->oldduplex = -1;
-	}
-
-	if (new_state && netif_msg_link(priv))
-		phy_print_status(phydev);
-
-	spin_unlock(&priv->mac_cfg_lock);
-}
-static struct phy_device *connect_local_phy(struct net_device *dev)
-{
-	struct altera_tse_private *priv = netdev_priv(dev);
-	char phy_id_fmt[MII_BUS_ID_SIZE + 3];
-	struct phy_device *phydev = NULL;
-
-	if (priv->phy_addr != POLL_PHY) {
-		snprintf(phy_id_fmt, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
-			 priv->mdio->id, priv->phy_addr);
-
-		netdev_dbg(dev, "trying to attach to %s\n", phy_id_fmt);
-
-		phydev = phy_connect(dev, phy_id_fmt, &altera_tse_adjust_link,
-				     priv->phy_iface);
-		if (IS_ERR(phydev)) {
-			netdev_err(dev, "Could not attach to PHY\n");
-			phydev = NULL;
-		}
-
-	} else {
-		int ret;
-		phydev = phy_find_first(priv->mdio);
-		if (phydev == NULL) {
-			netdev_err(dev, "No PHY found\n");
-			return phydev;
-		}
-
-		ret = phy_connect_direct(dev, phydev, &altera_tse_adjust_link,
-				priv->phy_iface);
-		if (ret != 0) {
-			netdev_err(dev, "Could not attach to PHY\n");
-			phydev = NULL;
-		}
-	}
-	return phydev;
-}
-
 static int altera_tse_phy_get_addr_mdio_create(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
@@ -769,91 +638,6 @@ static int altera_tse_phy_get_addr_mdio_create(struct net_device *dev)
 	return 0;
 }
 
-/* Initialize driver's PHY state, and attach to the PHY
- */
-static int init_phy(struct net_device *dev)
-{
-	struct altera_tse_private *priv = netdev_priv(dev);
-	struct device_node *phynode;
-	struct phy_device *phydev;
-	bool fixed_link = false;
-	int rc = 0;
-
-	/* Avoid init phy in case of no phy present */
-	if (!priv->phy_iface)
-		return 0;
-
-	priv->oldlink = 0;
-	priv->oldspeed = 0;
-	priv->oldduplex = -1;
-
-	phynode = of_parse_phandle(priv->device->of_node, "phy-handle", 0);
-
-	if (!phynode) {
-		/* check if a fixed-link is defined in device-tree */
-		if (of_phy_is_fixed_link(priv->device->of_node)) {
-			rc = of_phy_register_fixed_link(priv->device->of_node);
-			if (rc < 0) {
-				netdev_err(dev, "cannot register fixed PHY\n");
-				return rc;
-			}
-
-			/* In the case of a fixed PHY, the DT node associated
-			 * to the PHY is the Ethernet MAC DT node.
-			 */
-			phynode = of_node_get(priv->device->of_node);
-			fixed_link = true;
-
-			netdev_dbg(dev, "fixed-link detected\n");
-			phydev = of_phy_connect(dev, phynode,
-						&altera_tse_adjust_link,
-						0, priv->phy_iface);
-		} else {
-			netdev_dbg(dev, "no phy-handle found\n");
-			if (!priv->mdio) {
-				netdev_err(dev, "No phy-handle nor local mdio specified\n");
-				return -ENODEV;
-			}
-			phydev = connect_local_phy(dev);
-		}
-	} else {
-		netdev_dbg(dev, "phy-handle found\n");
-		phydev = of_phy_connect(dev, phynode,
-			&altera_tse_adjust_link, 0, priv->phy_iface);
-	}
-	of_node_put(phynode);
-
-	if (!phydev) {
-		netdev_err(dev, "Could not find the PHY\n");
-		if (fixed_link)
-			of_phy_deregister_fixed_link(priv->device->of_node);
-		return -ENODEV;
-	}
-
-	/* Stop Advertising 1000BASE Capability if interface is not GMII
-	 */
-	if ((priv->phy_iface == PHY_INTERFACE_MODE_MII) ||
-	    (priv->phy_iface == PHY_INTERFACE_MODE_RMII))
-		phy_set_max_speed(phydev, SPEED_100);
-
-	/* Broken HW is sometimes missing the pull-up resistor on the
-	 * MDIO line, which results in reads to non-existent devices returning
-	 * 0 rather than 0xffff. Catch this here and treat 0 as a non-existent
-	 * device as well. If a fixed-link is used the phy_id is always 0.
-	 * Note: phydev->phy_id is the result of reading the UID PHY registers.
-	 */
-	if ((phydev->phy_id == 0) && !fixed_link) {
-		netdev_err(dev, "Bad PHY UID 0x%08x\n", phydev->phy_id);
-		phy_disconnect(phydev);
-		return -ENODEV;
-	}
-
-	netdev_dbg(dev, "attached to PHY %d UID 0x%08x Link = %d\n",
-		   phydev->mdio.addr, phydev->phy_id, phydev->link);
-
-	return 0;
-}
-
 static void tse_update_mac_addr(struct altera_tse_private *priv, const u8 *addr)
 {
 	u32 msb;
@@ -1088,66 +872,6 @@ static void tse_set_rx_mode(struct net_device *dev)
 	spin_unlock(&priv->mac_cfg_lock);
 }
 
-/* Initialise (if necessary) the SGMII PCS component
- */
-static int init_sgmii_pcs(struct net_device *dev)
-{
-	struct altera_tse_private *priv = netdev_priv(dev);
-	int n;
-	unsigned int tmp_reg = 0;
-
-	if (priv->phy_iface != PHY_INTERFACE_MODE_SGMII)
-		return 0; /* Nothing to do, not in SGMII mode */
-
-	/* The TSE SGMII PCS block looks a little like a PHY, it is
-	 * mapped into the zeroth MDIO space of the MAC and it has
-	 * ID registers like a PHY would.  Sadly this is often
-	 * configured to zeroes, so don't be surprised if it does
-	 * show 0x00000000.
-	 */
-
-	if (sgmii_pcs_scratch_test(priv, 0x0000) &&
-		sgmii_pcs_scratch_test(priv, 0xffff) &&
-		sgmii_pcs_scratch_test(priv, 0xa5a5) &&
-		sgmii_pcs_scratch_test(priv, 0x5a5a)) {
-		netdev_info(dev, "PCS PHY ID: 0x%04x%04x\n",
-				sgmii_pcs_read(priv, MII_PHYSID1),
-				sgmii_pcs_read(priv, MII_PHYSID2));
-	} else {
-		netdev_err(dev, "SGMII PCS Scratch memory test failed.\n");
-		return -ENOMEM;
-	}
-
-	/* Starting on page 5-29 of the MegaCore Function User Guide
-	 * Set SGMII Link timer to 1.6ms
-	 */
-	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_0, 0x0D40);
-	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_1, 0x03);
-
-	/* Enable SGMII Interface and Enable SGMII Auto Negotiation */
-	sgmii_pcs_write(priv, SGMII_PCS_IF_MODE, 0x3);
-
-	/* Enable Autonegotiation */
-	tmp_reg = sgmii_pcs_read(priv, MII_BMCR);
-	tmp_reg |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
-	sgmii_pcs_write(priv, MII_BMCR, tmp_reg);
-
-	/* Reset PCS block */
-	tmp_reg |= BMCR_RESET;
-	sgmii_pcs_write(priv, MII_BMCR, tmp_reg);
-	for (n = 0; n < SGMII_PCS_SW_RESET_TIMEOUT; n++) {
-		if (!(sgmii_pcs_read(priv, MII_BMCR) & BMCR_RESET)) {
-			netdev_info(dev, "SGMII PCS block initialised OK\n");
-			return 0;
-		}
-		udelay(1);
-	}
-
-	/* We failed to reset the block, return a timeout */
-	netdev_err(dev, "SGMII PCS block reset failed.\n");
-	return -ETIMEDOUT;
-}
-
 /* Open and initialize the interface
  */
 static int tse_open(struct net_device *dev)
@@ -1172,14 +896,6 @@ static int tse_open(struct net_device *dev)
 		netdev_warn(dev, "TSE revision %x\n", priv->revision);
 
 	spin_lock(&priv->mac_cfg_lock);
-	/* no-op if MAC not operating in SGMII mode*/
-	ret = init_sgmii_pcs(dev);
-	if (ret) {
-		netdev_err(dev,
-			   "Cannot init the SGMII PCS (error: %d)\n", ret);
-		spin_unlock(&priv->mac_cfg_lock);
-		goto phy_error;
-	}
 
 	ret = reset_mac(priv);
 	/* Note that reset_mac will fail if the clocks are gated by the PHY
@@ -1237,8 +953,12 @@ static int tse_open(struct net_device *dev)
 
 	spin_unlock_irqrestore(&priv->rxdma_irq_lock, flags);
 
-	if (dev->phydev)
-		phy_start(dev->phydev);
+	ret = phylink_of_phy_connect(priv->phylink, priv->device->of_node, 0);
+	if (ret) {
+		netdev_err(dev, "could not connect phylink (%d)\n", ret);
+		goto tx_request_irq_error;
+	}
+	phylink_start(priv->phylink);
 
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
@@ -1269,10 +989,7 @@ static int tse_shutdown(struct net_device *dev)
 	unsigned long int flags;
 	int ret;
 
-	/* Stop the PHY */
-	if (dev->phydev)
-		phy_stop(dev->phydev);
-
+	phylink_stop(priv->phylink);
 	netif_stop_queue(dev);
 	napi_disable(&priv->napi);
 
@@ -1318,6 +1035,74 @@ static struct net_device_ops altera_tse_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+static void alt_tse_mac_an_restart(struct phylink_config *config)
+{
+}
+
+static void alt_tse_mac_config(struct phylink_config *config, unsigned int mode,
+			       const struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct altera_tse_private *priv = netdev_priv(ndev);
+
+	spin_lock(&priv->mac_cfg_lock);
+	reset_mac(priv);
+	tse_set_mac(priv, true);
+	spin_unlock(&priv->mac_cfg_lock);
+}
+
+static void alt_tse_mac_link_down(struct phylink_config *config,
+				  unsigned int mode, phy_interface_t interface)
+{
+}
+
+static void alt_tse_mac_link_up(struct phylink_config *config,
+				struct phy_device *phy, unsigned int mode,
+				phy_interface_t interface, int speed,
+				int duplex, bool tx_pause, bool rx_pause)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct altera_tse_private *priv = netdev_priv(ndev);
+	u32 ctrl;
+
+	ctrl = csrrd32(priv->mac_dev, tse_csroffs(command_config));
+	ctrl &= ~(MAC_CMDCFG_ENA_10 | MAC_CMDCFG_ETH_SPEED | MAC_CMDCFG_HD_ENA);
+
+	if (duplex == DUPLEX_HALF)
+		ctrl |= MAC_CMDCFG_HD_ENA;
+
+	if (speed == SPEED_1000)
+		ctrl |= MAC_CMDCFG_ETH_SPEED;
+	else if (speed == SPEED_10)
+		ctrl |= MAC_CMDCFG_ENA_10;
+
+	spin_lock(&priv->mac_cfg_lock);
+	csrwr32(ctrl, priv->mac_dev, tse_csroffs(command_config));
+	spin_unlock(&priv->mac_cfg_lock);
+}
+
+static struct phylink_pcs *alt_tse_select_pcs(struct phylink_config *config,
+					      phy_interface_t interface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct altera_tse_private *priv = netdev_priv(ndev);
+
+	if (interface == PHY_INTERFACE_MODE_SGMII ||
+	    interface == PHY_INTERFACE_MODE_1000BASEX)
+		return priv->pcs;
+	else
+		return NULL;
+}
+
+static const struct phylink_mac_ops alt_tse_phylink_ops = {
+	.validate = phylink_generic_validate,
+	.mac_an_restart = alt_tse_mac_an_restart,
+	.mac_config = alt_tse_mac_config,
+	.mac_link_down = alt_tse_mac_link_down,
+	.mac_link_up = alt_tse_mac_link_up,
+	.mac_select_pcs = alt_tse_select_pcs,
+};
+
 static int request_and_map(struct platform_device *pdev, const char *name,
 			   struct resource **res, void __iomem **ptr)
 {
@@ -1355,8 +1140,10 @@ static int altera_tse_probe(struct platform_device *pdev)
 	struct altera_tse_private *priv;
 	struct resource *control_port;
 	struct resource *dma_res;
+	struct resource *pcs_res;
 	struct net_device *ndev;
 	void __iomem *descmap;
+	int pcs_reg_width = 2;
 	int ret = -ENODEV;
 
 	ndev = alloc_etherdev(sizeof(struct altera_tse_private));
@@ -1468,6 +1255,17 @@ static int altera_tse_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_free_netdev;
 
+	/* SGMII PCS address space. The location can vary depending on how the
+	 * IP is integrated. We can have a resource dedicated to it at a specific
+	 * address space, but if it's not the case, we fallback to the mdiophy0
+	 * from the MAC's address space
+	 */
+	ret = request_and_map(pdev, "pcs", &pcs_res,
+			      &priv->pcs_base);
+	if (ret) {
+		priv->pcs_base = priv->mac_dev + tse_csroffs(mdio_phy0);
+		pcs_reg_width = 4;
+	}
 
 	/* Rx IRQ */
 	priv->rx_irq = platform_get_irq_byname(pdev, "rx_irq");
@@ -1591,11 +1389,31 @@ static int altera_tse_probe(struct platform_device *pdev)
 			 (unsigned long) control_port->start, priv->rx_irq,
 			 priv->tx_irq);
 
-	ret = init_phy(ndev);
-	if (ret != 0) {
-		netdev_err(ndev, "Cannot attach to PHY (error: %d)\n", ret);
+	priv->pcs = alt_tse_pcs_create(ndev, priv->pcs_base, pcs_reg_width);
+
+	priv->phylink_config.dev = &ndev->dev;
+	priv->phylink_config.type = PHYLINK_NETDEV;
+	priv->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 |
+						MAC_100 | MAC_1000FD;
+
+	phy_interface_set_rgmii(priv->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_MII,
+		  priv->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_GMII,
+		  priv->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_SGMII,
+		  priv->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+		  priv->phylink_config.supported_interfaces);
+
+	priv->phylink = phylink_create(&priv->phylink_config,
+				       of_fwnode_handle(priv->device->of_node),
+				       priv->phy_iface, &alt_tse_phylink_ops);
+	if (IS_ERR(priv->phylink)) {
+		dev_err(&pdev->dev, "failed to create phylink\n");
 		goto err_init_phy;
 	}
+
 	return 0;
 
 err_init_phy:
@@ -1615,16 +1433,10 @@ static int altera_tse_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct altera_tse_private *priv = netdev_priv(ndev);
 
-	if (ndev->phydev) {
-		phy_disconnect(ndev->phydev);
-
-		if (of_phy_is_fixed_link(priv->device->of_node))
-			of_phy_deregister_fixed_link(priv->device->of_node);
-	}
-
 	platform_set_drvdata(pdev, NULL);
 	altera_tse_mdio_destroy(ndev);
 	unregister_netdev(ndev);
+	phylink_destroy(priv->phylink);
 	free_netdev(ndev);
 
 	return 0;
-- 
2.37.2


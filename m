Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71C22BBB3
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfE0VXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:23:01 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50844 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfE0VW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:22:56 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3AFDA200C5E;
        Mon, 27 May 2019 23:22:51 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2B3ED200C59;
        Mon, 27 May 2019 23:22:51 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9119F2060A;
        Mon, 27 May 2019 23:22:50 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 06/11] net: phylink: Add struct phylink_config to PHYLINK API
Date:   Tue, 28 May 2019 00:22:02 +0300
Message-Id: <1558992127-26008-7-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phylink_config structure will encapsulate a pointer to a struct
device and the operation type requested for this instance of PHYLINK.
This patch does not make any functional changes, it just transitions the
PHYLINK internals and all its users to the new API.

A pointer to a phylink_config structure will be passed to
phylink_create() instead of the net_device directly. Also, the same
phylink_config pointer will be passed back to all phylink_mac_ops
callbacks instead of the net_device. Using this mechanism, a PHYLINK
user can get the original net_device using a structure such as
'to_net_dev(config->dev)' or directly the structure containing the
phylink_config using a container_of call.

At the moment, only the PHYLINK_NETDEV is defined as a valid operation
type for PHYLINK. In this mode, a valid reference to a struct device
linked to the original net_device should be passed to PHYLINK through
the phylink_config structure.

This API changes is mainly driven by the necessity of adding a new
operation type in PHYLINK that disconnects the phy_device from the
net_device and also works when the net_device is lacking.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/networking/sfp-phylink.rst      |  5 +-
 drivers/net/ethernet/marvell/mvneta.c         | 36 ++++++++----
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  1 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 43 ++++++++------
 drivers/net/phy/phylink.c                     | 26 ++++++---
 include/linux/phylink.h                       | 56 ++++++++++++-------
 include/net/dsa.h                             |  2 +
 net/dsa/slave.c                               | 31 +++++-----
 8 files changed, 128 insertions(+), 72 deletions(-)

diff --git a/Documentation/networking/sfp-phylink.rst b/Documentation/networking/sfp-phylink.rst
index 5bd26cb07244..91446b431b70 100644
--- a/Documentation/networking/sfp-phylink.rst
+++ b/Documentation/networking/sfp-phylink.rst
@@ -98,6 +98,7 @@ this documentation.
 4. Add::
 
 	struct phylink *phylink;
+	struct phylink_config phylink_config;
 
    to the driver's private data structure.  We shall refer to the
    driver's private data pointer as ``priv`` below, and the driver's
@@ -223,8 +224,10 @@ this documentation.
    .. code-block:: c
 
 	struct phylink *phylink;
+	priv->phylink_config.dev = &dev.dev;
+	priv->phylink_config.type = PHYLINK_NETDEV;
 
-	phylink = phylink_create(dev, node, phy_mode, &phylink_ops);
+	phylink = phylink_create(&priv->phylink_config, node, phy_mode, &phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
 		fail probe;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e758650b2c26..adbbcdde73e6 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -437,6 +437,7 @@ struct mvneta_port {
 	struct device_node *dn;
 	unsigned int tx_csum_limit;
 	struct phylink *phylink;
+	struct phylink_config phylink_config;
 	struct phy *comphy;
 
 	struct mvneta_bm *bm_priv;
@@ -3356,9 +3357,11 @@ static int mvneta_set_mac_addr(struct net_device *dev, void *addr)
 	return 0;
 }
 
-static void mvneta_validate(struct net_device *ndev, unsigned long *supported,
+static void mvneta_validate(struct phylink_config *config,
+			    unsigned long *supported,
 			    struct phylink_link_state *state)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
 	struct mvneta_port *pp = netdev_priv(ndev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
@@ -3408,9 +3411,10 @@ static void mvneta_validate(struct net_device *ndev, unsigned long *supported,
 	phylink_helper_basex_speed(state);
 }
 
-static int mvneta_mac_link_state(struct net_device *ndev,
+static int mvneta_mac_link_state(struct phylink_config *config,
 				 struct phylink_link_state *state)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
 	struct mvneta_port *pp = netdev_priv(ndev);
 	u32 gmac_stat;
 
@@ -3438,8 +3442,9 @@ static int mvneta_mac_link_state(struct net_device *ndev,
 	return 1;
 }
 
-static void mvneta_mac_an_restart(struct net_device *ndev)
+static void mvneta_mac_an_restart(struct phylink_config *config)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
 	struct mvneta_port *pp = netdev_priv(ndev);
 	u32 gmac_an = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
 
@@ -3449,9 +3454,10 @@ static void mvneta_mac_an_restart(struct net_device *ndev)
 		    gmac_an & ~MVNETA_GMAC_INBAND_RESTART_AN);
 }
 
-static void mvneta_mac_config(struct net_device *ndev, unsigned int mode,
-	const struct phylink_link_state *state)
+static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
+			      const struct phylink_link_state *state)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
 	struct mvneta_port *pp = netdev_priv(ndev);
 	u32 new_ctrl0, gmac_ctrl0 = mvreg_read(pp, MVNETA_GMAC_CTRL_0);
 	u32 new_ctrl2, gmac_ctrl2 = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
@@ -3581,9 +3587,10 @@ static void mvneta_set_eee(struct mvneta_port *pp, bool enable)
 	mvreg_write(pp, MVNETA_LPI_CTRL_1, lpi_ctl1);
 }
 
-static void mvneta_mac_link_down(struct net_device *ndev, unsigned int mode,
-				 phy_interface_t interface)
+static void mvneta_mac_link_down(struct phylink_config *config,
+				 unsigned int mode, phy_interface_t interface)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
 	struct mvneta_port *pp = netdev_priv(ndev);
 	u32 val;
 
@@ -3600,10 +3607,11 @@ static void mvneta_mac_link_down(struct net_device *ndev, unsigned int mode,
 	mvneta_set_eee(pp, false);
 }
 
-static void mvneta_mac_link_up(struct net_device *ndev, unsigned int mode,
+static void mvneta_mac_link_up(struct phylink_config *config, unsigned int mode,
 			       phy_interface_t interface,
 			       struct phy_device *phy)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
 	struct mvneta_port *pp = netdev_priv(ndev);
 	u32 val;
 
@@ -4500,8 +4508,14 @@ static int mvneta_probe(struct platform_device *pdev)
 		comphy = NULL;
 	}
 
-	phylink = phylink_create(dev, pdev->dev.fwnode, phy_mode,
-				 &mvneta_phylink_ops);
+	pp = netdev_priv(dev);
+	spin_lock_init(&pp->lock);
+
+	pp->phylink_config.dev = &dev->dev;
+	pp->phylink_config.type = PHYLINK_NETDEV;
+
+	phylink = phylink_create(&pp->phylink_config, pdev->dev.fwnode,
+				 phy_mode, &mvneta_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
 		goto err_free_irq;
@@ -4513,8 +4527,6 @@ static int mvneta_probe(struct platform_device *pdev)
 
 	dev->ethtool_ops = &mvneta_eth_tool_ops;
 
-	pp = netdev_priv(dev);
-	spin_lock_init(&pp->lock);
 	pp->phylink = phylink;
 	pp->comphy = comphy;
 	pp->phy_interface = phy_mode;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 18ae8d06b692..d67c970f02e5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -915,6 +915,7 @@ struct mvpp2_port {
 
 	phy_interface_t phy_interface;
 	struct phylink *phylink;
+	struct phylink_config phylink_config;
 	struct phy *comphy;
 
 	struct mvpp2_bm_pool *pool_long;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 3ed713b8dea5..757f8e31645e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -56,9 +56,9 @@ static struct {
 /* The prototype is added here to be used in start_dev when using ACPI. This
  * will be removed once phylink is used for all modes (dt+ACPI).
  */
-static void mvpp2_mac_config(struct net_device *dev, unsigned int mode,
+static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 			     const struct phylink_link_state *state);
-static void mvpp2_mac_link_up(struct net_device *dev, unsigned int mode,
+static void mvpp2_mac_link_up(struct phylink_config *config, unsigned int mode,
 			      phy_interface_t interface, struct phy_device *phy);
 
 /* Queue modes */
@@ -3239,9 +3239,9 @@ static void mvpp2_start_dev(struct mvpp2_port *port)
 		struct phylink_link_state state = {
 			.interface = port->phy_interface,
 		};
-		mvpp2_mac_config(port->dev, MLO_AN_INBAND, &state);
-		mvpp2_mac_link_up(port->dev, MLO_AN_INBAND, port->phy_interface,
-				  NULL);
+		mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
+		mvpp2_mac_link_up(&port->phylink_config, MLO_AN_INBAND,
+				  port->phy_interface, NULL);
 	}
 
 	netif_tx_start_all_queues(port->dev);
@@ -4463,11 +4463,12 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 	eth_hw_addr_random(dev);
 }
 
-static void mvpp2_phylink_validate(struct net_device *dev,
+static void mvpp2_phylink_validate(struct phylink_config *config,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
+					       phylink_config);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	/* Invalid combinations */
@@ -4591,10 +4592,11 @@ static void mvpp2_gmac_link_state(struct mvpp2_port *port,
 		state->pause |= MLO_PAUSE_TX;
 }
 
-static int mvpp2_phylink_mac_link_state(struct net_device *dev,
+static int mvpp2_phylink_mac_link_state(struct phylink_config *config,
 					struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
+					       phylink_config);
 
 	if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
 		u32 mode = readl(port->base + MVPP22_XLG_CTRL3_REG);
@@ -4610,9 +4612,10 @@ static int mvpp2_phylink_mac_link_state(struct net_device *dev,
 	return 1;
 }
 
-static void mvpp2_mac_an_restart(struct net_device *dev)
+static void mvpp2_mac_an_restart(struct phylink_config *config)
 {
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
+					       phylink_config);
 	u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
 
 	writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
@@ -4797,9 +4800,10 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 	}
 }
 
-static void mvpp2_mac_config(struct net_device *dev, unsigned int mode,
+static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
+	struct net_device *dev = to_net_dev(config->dev);
 	struct mvpp2_port *port = netdev_priv(dev);
 	bool change_interface = port->phy_interface != state->interface;
 
@@ -4839,9 +4843,10 @@ static void mvpp2_mac_config(struct net_device *dev, unsigned int mode,
 	mvpp2_port_enable(port);
 }
 
-static void mvpp2_mac_link_up(struct net_device *dev, unsigned int mode,
+static void mvpp2_mac_link_up(struct phylink_config *config, unsigned int mode,
 			      phy_interface_t interface, struct phy_device *phy)
 {
+	struct net_device *dev = to_net_dev(config->dev);
 	struct mvpp2_port *port = netdev_priv(dev);
 	u32 val;
 
@@ -4866,9 +4871,10 @@ static void mvpp2_mac_link_up(struct net_device *dev, unsigned int mode,
 	netif_tx_wake_all_queues(dev);
 }
 
-static void mvpp2_mac_link_down(struct net_device *dev, unsigned int mode,
-				phy_interface_t interface)
+static void mvpp2_mac_link_down(struct phylink_config *config,
+				unsigned int mode, phy_interface_t interface)
 {
+	struct net_device *dev = to_net_dev(config->dev);
 	struct mvpp2_port *port = netdev_priv(dev);
 	u32 val;
 
@@ -5125,8 +5131,11 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 
 	/* Phylink isn't used w/ ACPI as of now */
 	if (port_node) {
-		phylink = phylink_create(dev, port_fwnode, phy_mode,
-					 &mvpp2_phylink_ops);
+		port->phylink_config.dev = &dev->dev;
+		port->phylink_config.type = PHYLINK_NETDEV;
+
+		phylink = phylink_create(&port->phylink_config, port_fwnode,
+					 phy_mode, &mvpp2_phylink_ops);
 		if (IS_ERR(phylink)) {
 			err = PTR_ERR(phylink);
 			goto err_free_port_pcpu;
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 83ab83c3edba..5a283bf9d402 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -41,6 +41,7 @@ struct phylink {
 	/* private: */
 	struct net_device *netdev;
 	const struct phylink_mac_ops *ops;
+	struct phylink_config *config;
 
 	unsigned long phylink_disable_state; /* bitmask of disables */
 	struct phy_device *phydev;
@@ -111,7 +112,7 @@ static const char *phylink_an_mode_str(unsigned int mode)
 static int phylink_validate(struct phylink *pl, unsigned long *supported,
 			    struct phylink_link_state *state)
 {
-	pl->ops->validate(pl->netdev, supported, state);
+	pl->ops->validate(pl->config, supported, state);
 
 	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
 }
@@ -299,7 +300,7 @@ static void phylink_mac_config(struct phylink *pl,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
 		   state->pause, state->link, state->an_enabled);
 
-	pl->ops->mac_config(pl->netdev, pl->link_an_mode, state);
+	pl->ops->mac_config(pl->config, pl->link_an_mode, state);
 }
 
 static void phylink_mac_config_up(struct phylink *pl,
@@ -313,12 +314,11 @@ static void phylink_mac_an_restart(struct phylink *pl)
 {
 	if (pl->link_config.an_enabled &&
 	    phy_interface_mode_is_8023z(pl->link_config.interface))
-		pl->ops->mac_an_restart(pl->netdev);
+		pl->ops->mac_an_restart(pl->config);
 }
 
 static int phylink_get_mac_state(struct phylink *pl, struct phylink_link_state *state)
 {
-	struct net_device *ndev = pl->netdev;
 
 	linkmode_copy(state->advertising, pl->link_config.advertising);
 	linkmode_zero(state->lp_advertising);
@@ -330,7 +330,7 @@ static int phylink_get_mac_state(struct phylink *pl, struct phylink_link_state *
 	state->an_complete = 0;
 	state->link = 1;
 
-	return pl->ops->mac_link_state(ndev, state);
+	return pl->ops->mac_link_state(pl->config, state);
 }
 
 /* The fixed state is... fixed except for the link state,
@@ -400,7 +400,7 @@ static void phylink_mac_link_up(struct phylink *pl,
 {
 	struct net_device *ndev = pl->netdev;
 
-	pl->ops->mac_link_up(ndev, pl->link_an_mode,
+	pl->ops->mac_link_up(pl->config, pl->link_an_mode,
 			     pl->phy_state.interface,
 			     pl->phydev);
 
@@ -418,7 +418,7 @@ static void phylink_mac_link_down(struct phylink *pl)
 	struct net_device *ndev = pl->netdev;
 
 	netif_carrier_off(ndev);
-	pl->ops->mac_link_down(ndev, pl->link_an_mode,
+	pl->ops->mac_link_down(pl->config, pl->link_an_mode,
 			       pl->phy_state.interface);
 	netdev_info(ndev, "Link is Down\n");
 }
@@ -553,7 +553,7 @@ static int phylink_register_sfp(struct phylink *pl,
  * Returns a pointer to a &struct phylink, or an error-pointer value. Users
  * must use IS_ERR() to check for errors from this function.
  */
-struct phylink *phylink_create(struct net_device *ndev,
+struct phylink *phylink_create(struct phylink_config *config,
 			       struct fwnode_handle *fwnode,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *ops)
@@ -567,7 +567,15 @@ struct phylink *phylink_create(struct net_device *ndev,
 
 	mutex_init(&pl->state_mutex);
 	INIT_WORK(&pl->resolve, phylink_resolve);
-	pl->netdev = ndev;
+
+	pl->config = config;
+	if (config->type == PHYLINK_NETDEV) {
+		pl->netdev = to_net_dev(config->dev);
+	} else {
+		kfree(pl);
+		return ERR_PTR(-EINVAL);
+	}
+
 	pl->phy_state.interface = iface;
 	pl->link_interface = iface;
 	if (iface == PHY_INTERFACE_MODE_MOCA)
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6411c624f63a..67f35f07ac4b 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -54,6 +54,20 @@ struct phylink_link_state {
 	unsigned int an_complete:1;
 };
 
+enum phylink_op_type {
+	PHYLINK_NETDEV = 0,
+};
+
+/**
+ * struct phylink_config - PHYLINK configuration structure
+ * @dev: a pointer to a struct device associated with the MAC
+ * @type: operation type of PHYLINK instance
+ */
+struct phylink_config {
+	struct device *dev;
+	enum phylink_op_type type;
+};
+
 /**
  * struct phylink_mac_ops - MAC operations structure.
  * @validate: Validate and update the link configuration.
@@ -66,16 +80,17 @@ struct phylink_link_state {
  * The individual methods are described more fully below.
  */
 struct phylink_mac_ops {
-	void (*validate)(struct net_device *ndev, unsigned long *supported,
+	void (*validate)(struct phylink_config *config,
+			 unsigned long *supported,
 			 struct phylink_link_state *state);
-	int (*mac_link_state)(struct net_device *ndev,
+	int (*mac_link_state)(struct phylink_config *config,
 			      struct phylink_link_state *state);
-	void (*mac_config)(struct net_device *ndev, unsigned int mode,
+	void (*mac_config)(struct phylink_config *config, unsigned int mode,
 			   const struct phylink_link_state *state);
-	void (*mac_an_restart)(struct net_device *ndev);
-	void (*mac_link_down)(struct net_device *ndev, unsigned int mode,
+	void (*mac_an_restart)(struct phylink_config *config);
+	void (*mac_link_down)(struct phylink_config *config, unsigned int mode,
 			      phy_interface_t interface);
-	void (*mac_link_up)(struct net_device *ndev, unsigned int mode,
+	void (*mac_link_up)(struct phylink_config *config, unsigned int mode,
 			    phy_interface_t interface,
 			    struct phy_device *phy);
 };
@@ -83,7 +98,7 @@ struct phylink_mac_ops {
 #if 0 /* For kernel-doc purposes only. */
 /**
  * validate - Validate and update the link configuration
- * @ndev: a pointer to a &struct net_device for the MAC.
+ * @config: a pointer to a &struct phylink_config.
  * @supported: ethtool bitmask for supported link modes.
  * @state: a pointer to a &struct phylink_link_state.
  *
@@ -100,12 +115,12 @@ struct phylink_mac_ops {
  * based on @state->advertising and/or @state->speed and update
  * @state->interface accordingly.
  */
-void validate(struct net_device *ndev, unsigned long *supported,
+void validate(struct phylink_config *config, unsigned long *supported,
 	      struct phylink_link_state *state);
 
 /**
  * mac_link_state() - Read the current link state from the hardware
- * @ndev: a pointer to a &struct net_device for the MAC.
+ * @config: a pointer to a &struct phylink_config.
  * @state: a pointer to a &struct phylink_link_state.
  *
  * Read the current link state from the MAC, reporting the current
@@ -114,12 +129,12 @@ void validate(struct net_device *ndev, unsigned long *supported,
  * negotiation completion state in @state->an_complete, and link
  * up state in @state->link.
  */
-int mac_link_state(struct net_device *ndev,
+int mac_link_state(struct phylink_config *config,
 		   struct phylink_link_state *state);
 
 /**
  * mac_config() - configure the MAC for the selected mode and state
- * @ndev: a pointer to a &struct net_device for the MAC.
+ * @config: a pointer to a &struct phylink_config.
  * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
  * @state: a pointer to a &struct phylink_link_state.
  *
@@ -157,18 +172,18 @@ int mac_link_state(struct net_device *ndev,
  * down.  This "update" behaviour is critical to avoid bouncing the
  * link up status.
  */
-void mac_config(struct net_device *ndev, unsigned int mode,
+void mac_config(struct phylink_config *config, unsigned int mode,
 		const struct phylink_link_state *state);
 
 /**
  * mac_an_restart() - restart 802.3z BaseX autonegotiation
- * @ndev: a pointer to a &struct net_device for the MAC.
+ * @config: a pointer to a &struct phylink_config.
  */
-void mac_an_restart(struct net_device *ndev);
+void mac_an_restart(struct phylink_config *config);
 
 /**
  * mac_link_down() - take the link down
- * @ndev: a pointer to a &struct net_device for the MAC.
+ * @config: a pointer to a &struct phylink_config.
  * @mode: link autonegotiation mode
  * @interface: link &typedef phy_interface_t mode
  *
@@ -177,12 +192,12 @@ void mac_an_restart(struct net_device *ndev);
  * Energy Efficient Ethernet MAC configuration. Interface type
  * selection must be done in mac_config().
  */
-void mac_link_down(struct net_device *ndev, unsigned int mode,
+void mac_link_down(struct phylink_config *config, unsigned int mode,
 		   phy_interface_t interface);
 
 /**
  * mac_link_up() - allow the link to come up
- * @ndev: a pointer to a &struct net_device for the MAC.
+ * @config: a pointer to a &struct phylink_config.
  * @mode: link autonegotiation mode
  * @interface: link &typedef phy_interface_t mode
  * @phy: any attached phy
@@ -193,13 +208,14 @@ void mac_link_down(struct net_device *ndev, unsigned int mode,
  * phy_init_eee() and perform appropriate MAC configuration for EEE.
  * Interface type selection must be done in mac_config().
  */
-void mac_link_up(struct net_device *ndev, unsigned int mode,
+void mac_link_up(struct phylink_config *config, unsigned int mode,
 		 phy_interface_t interface,
 		 struct phy_device *phy);
 #endif
 
-struct phylink *phylink_create(struct net_device *, struct fwnode_handle *,
-	phy_interface_t iface, const struct phylink_mac_ops *ops);
+struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
+			       phy_interface_t iface,
+			       const struct phylink_mac_ops *ops);
 void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 685294817712..a7f36219904f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -22,6 +22,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/platform_data/dsa.h>
+#include <linux/phylink.h>
 #include <net/devlink.h>
 #include <net/switchdev.h>
 
@@ -193,6 +194,7 @@ struct dsa_port {
 	struct net_device	*bridge_dev;
 	struct devlink_port	devlink_port;
 	struct phylink		*pl;
+	struct phylink_config	pl_config;
 
 	struct work_struct	xmit_work;
 	struct sk_buff_head	xmit_queue;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9892ca1f6859..48e017637d4f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1164,11 +1164,11 @@ static struct device_type dsa_type = {
 	.name	= "dsa",
 };
 
-static void dsa_slave_phylink_validate(struct net_device *dev,
+static void dsa_slave_phylink_validate(struct phylink_config *config,
 				       unsigned long *supported,
 				       struct phylink_link_state *state)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_validate)
@@ -1177,10 +1177,10 @@ static void dsa_slave_phylink_validate(struct net_device *dev,
 	ds->ops->phylink_validate(ds, dp->index, supported, state);
 }
 
-static int dsa_slave_phylink_mac_link_state(struct net_device *dev,
+static int dsa_slave_phylink_mac_link_state(struct phylink_config *config,
 					    struct phylink_link_state *state)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
 
 	/* Only called for SGMII and 802.3z */
@@ -1190,11 +1190,11 @@ static int dsa_slave_phylink_mac_link_state(struct net_device *dev,
 	return ds->ops->phylink_mac_link_state(ds, dp->index, state);
 }
 
-static void dsa_slave_phylink_mac_config(struct net_device *dev,
+static void dsa_slave_phylink_mac_config(struct phylink_config *config,
 					 unsigned int mode,
 					 const struct phylink_link_state *state)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_mac_config)
@@ -1203,9 +1203,9 @@ static void dsa_slave_phylink_mac_config(struct net_device *dev,
 	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
 }
 
-static void dsa_slave_phylink_mac_an_restart(struct net_device *dev)
+static void dsa_slave_phylink_mac_an_restart(struct phylink_config *config)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_mac_an_restart)
@@ -1214,11 +1214,12 @@ static void dsa_slave_phylink_mac_an_restart(struct net_device *dev)
 	ds->ops->phylink_mac_an_restart(ds, dp->index);
 }
 
-static void dsa_slave_phylink_mac_link_down(struct net_device *dev,
+static void dsa_slave_phylink_mac_link_down(struct phylink_config *config,
 					    unsigned int mode,
 					    phy_interface_t interface)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct net_device *dev = dp->slave;
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_mac_link_down) {
@@ -1230,12 +1231,13 @@ static void dsa_slave_phylink_mac_link_down(struct net_device *dev,
 	ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
 }
 
-static void dsa_slave_phylink_mac_link_up(struct net_device *dev,
+static void dsa_slave_phylink_mac_link_up(struct phylink_config *config,
 					  unsigned int mode,
 					  phy_interface_t interface,
 					  struct phy_device *phydev)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct net_device *dev = dp->slave;
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_mac_link_up) {
@@ -1303,7 +1305,10 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	if (mode < 0)
 		mode = PHY_INTERFACE_MODE_NA;
 
-	dp->pl = phylink_create(slave_dev, of_fwnode_handle(port_dn), mode,
+	dp->pl_config.dev = &slave_dev->dev;
+	dp->pl_config.type = PHYLINK_NETDEV;
+
+	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn), mode,
 				&dsa_slave_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
 		netdev_err(slave_dev,
-- 
2.21.0


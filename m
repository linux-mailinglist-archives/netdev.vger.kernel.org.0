Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 389CCEA7AC
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfJ3XTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:19:35 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60440 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbfJ3XTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 19:19:34 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 93D8B1A04B0;
        Thu, 31 Oct 2019 00:19:29 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 842BA1A01D8;
        Thu, 31 Oct 2019 00:19:29 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 25AC0205E9;
        Thu, 31 Oct 2019 00:19:29 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@armlinux.org.uk, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support through phylink
Date:   Thu, 31 Oct 2019 01:18:31 +0200
Message-Id: <1572477512-4618-5-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa2-eth driver now has support for connecting to its associated
PHY device found through standard OF bindings.

This happens when the DPNI object (that the driver probes on) gets
connected to a DPMAC. When that happens, the device tree is looked up by
the DPMAC ID, and the associated PHY bindings are found.

The old logic of handling the net device's link state by hand still
needs to be kept, as the DPNI can be connected to other devices on the
bus than a DPMAC: other DPNI, DPSW ports, etc. This logic is only
engaged when there is no DPMAC (and therefore no phylink instance)
attached.

The MC firmware support multiple type of DPMAC links: TYPE_FIXED,
TYPE_PHY. The TYPE_FIXED mode does not require any DPMAC management from
Linux side, and as such, the driver will not handle such a DPMAC.

Although PHYLINK typically handles SFP cages and in-band AN modes, for
the moment the driver only supports the RGMII interfaces found on the
LX2160A. Support for other modes will come later.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v2:
 - move the locks to rtnl outside of dpaa2_eth_[dis]connect_mac functions
 - remove setting supported/advertised from .validate()
Changes in v3:
 - removed an unused variable
Changes in v4:
 - use IS_ERR() instead of checking for NULL

 MAINTAINERS                                        |   2 +
 drivers/net/ethernet/freescale/dpaa2/Makefile      |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 119 ++++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |   3 +
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  25 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   | 301 +++++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |  32 +++
 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h   |  62 +++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.c       | 149 ++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h       | 144 ++++++++++
 10 files changed, 818 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c25441edb274..541c9e04ded1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5053,7 +5053,9 @@ M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-eth*
+F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-mac*
 F:	drivers/net/ethernet/freescale/dpaa2/dpni*
+F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
 F:	drivers/net/ethernet/freescale/dpaa2/dpkg.h
 F:	drivers/net/ethernet/freescale/dpaa2/Makefile
 F:	drivers/net/ethernet/freescale/dpaa2/Kconfig
diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
index d1e78cdd512f..69184ca3b7b9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -6,7 +6,7 @@
 obj-$(CONFIG_FSL_DPAA2_ETH)		+= fsl-dpaa2-eth.o
 obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+= fsl-dpaa2-ptp.o
 
-fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o
+fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
 fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 602d5118e928..c26c0a7cbb6b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016-2017 NXP
+ * Copyright 2016-2019 NXP
  */
 #include <linux/init.h>
 #include <linux/module.h>
@@ -1276,6 +1276,12 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 		   !!(state.options & DPNI_LINK_OPT_ASYM_PAUSE);
 	dpaa2_eth_set_rx_taildrop(priv, !tx_pause);
 
+	/* When we manage the MAC/PHY using phylink there is no need
+	 * to manually update the netif_carrier.
+	 */
+	if (priv->mac)
+		goto out;
+
 	/* Chech link state; speed / duplex changes are not treated yet */
 	if (priv->link_state.up == state.up)
 		goto out;
@@ -1312,17 +1318,21 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 			   priv->dpbp_dev->obj_desc.id, priv->bpid);
 	}
 
-	/* We'll only start the txqs when the link is actually ready; make sure
-	 * we don't race against the link up notification, which may come
-	 * immediately after dpni_enable();
-	 */
-	netif_tx_stop_all_queues(net_dev);
+	if (!priv->mac) {
+		/* We'll only start the txqs when the link is actually ready;
+		 * make sure we don't race against the link up notification,
+		 * which may come immediately after dpni_enable();
+		 */
+		netif_tx_stop_all_queues(net_dev);
+
+		/* Also, explicitly set carrier off, otherwise
+		 * netif_carrier_ok() will return true and cause 'ip link show'
+		 * to report the LOWER_UP flag, even though the link
+		 * notification wasn't even received.
+		 */
+		netif_carrier_off(net_dev);
+	}
 	enable_ch_napi(priv);
-	/* Also, explicitly set carrier off, otherwise netif_carrier_ok() will
-	 * return true and cause 'ip link show' to report the LOWER_UP flag,
-	 * even though the link notification wasn't even received.
-	 */
-	netif_carrier_off(net_dev);
 
 	err = dpni_enable(priv->mc_io, 0, priv->mc_token);
 	if (err < 0) {
@@ -1330,13 +1340,17 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 		goto enable_err;
 	}
 
-	/* If the DPMAC object has already processed the link up interrupt,
-	 * we have to learn the link state ourselves.
-	 */
-	err = link_state_update(priv);
-	if (err < 0) {
-		netdev_err(net_dev, "Can't update link state\n");
-		goto link_state_err;
+	if (!priv->mac) {
+		/* If the DPMAC object has already processed the link up
+		 * interrupt, we have to learn the link state ourselves.
+		 */
+		err = link_state_update(priv);
+		if (err < 0) {
+			netdev_err(net_dev, "Can't update link state\n");
+			goto link_state_err;
+		}
+	} else {
+		phylink_start(priv->mac->phylink);
 	}
 
 	return 0;
@@ -1411,8 +1425,12 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 	int dpni_enabled = 0;
 	int retries = 10;
 
-	netif_tx_stop_all_queues(net_dev);
-	netif_carrier_off(net_dev);
+	if (!priv->mac) {
+		netif_tx_stop_all_queues(net_dev);
+		netif_carrier_off(net_dev);
+	} else {
+		phylink_stop(priv->mac->phylink);
+	}
 
 	/* On dpni_disable(), the MC firmware will:
 	 * - stop MAC Rx and wait for all Rx frames to be enqueued to software
@@ -3342,12 +3360,56 @@ static int poll_link_state(void *arg)
 	return 0;
 }
 
+static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
+{
+	struct fsl_mc_device *dpni_dev, *dpmac_dev;
+	struct dpaa2_mac *mac;
+	int err;
+
+	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
+	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
+	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
+		return 0;
+
+	if (dpaa2_mac_is_type_fixed(dpmac_dev, priv->mc_io))
+		return 0;
+
+	mac = kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);
+	if (!mac)
+		return -ENOMEM;
+
+	mac->mc_dev = dpmac_dev;
+	mac->mc_io = priv->mc_io;
+	mac->net_dev = priv->net_dev;
+
+	err = dpaa2_mac_connect(mac);
+	if (err) {
+		netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
+		kfree(mac);
+		return err;
+	}
+	priv->mac = mac;
+
+	return 0;
+}
+
+static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
+{
+	if (!priv->mac)
+		return;
+
+	dpaa2_mac_disconnect(priv->mac);
+	kfree(priv->mac);
+	priv->mac = NULL;
+}
+
 static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 {
 	u32 status = ~0;
 	struct device *dev = (struct device *)arg;
 	struct fsl_mc_device *dpni_dev = to_fsl_mc_device(dev);
 	struct net_device *net_dev = dev_get_drvdata(dev);
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	int err;
 
 	err = dpni_get_irq_status(dpni_dev->mc_io, 0, dpni_dev->mc_handle,
@@ -3363,6 +3425,13 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {
 		set_mac_addr(netdev_priv(net_dev));
 		update_tx_fqids(priv);
+
+		rtnl_lock();
+		if (priv->mac)
+			dpaa2_eth_disconnect_mac(priv);
+		else
+			dpaa2_eth_connect_mac(priv);
+		rtnl_unlock();
 	}
 
 	return IRQ_HANDLED;
@@ -3539,6 +3608,10 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		priv->do_link_poll = true;
 	}
 
+	err = dpaa2_eth_connect_mac(priv);
+	if (err)
+		goto err_connect_mac;
+
 	err = register_netdev(net_dev);
 	if (err < 0) {
 		dev_err(dev, "register_netdev() failed\n");
@@ -3553,6 +3626,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	return 0;
 
 err_netdev_reg:
+	dpaa2_eth_disconnect_mac(priv);
+err_connect_mac:
 	if (priv->do_link_poll)
 		kthread_stop(priv->poll_thread);
 	else
@@ -3595,6 +3670,10 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 #ifdef CONFIG_DEBUG_FS
 	dpaa2_dbg_remove(priv);
 #endif
+	rtnl_lock();
+	dpaa2_eth_disconnect_mac(priv);
+	rtnl_unlock();
+
 	unregister_netdev(net_dev);
 
 	if (priv->do_link_poll)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 686b651edcb2..7635db3ef903 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -17,6 +17,7 @@
 
 #include "dpaa2-eth-trace.h"
 #include "dpaa2-eth-debugfs.h"
+#include "dpaa2-mac.h"
 
 #define DPAA2_WRIOP_VERSION(x, y, z) ((x) << 10 | (y) << 5 | (z) << 0)
 
@@ -415,6 +416,8 @@ struct dpaa2_eth_priv {
 #ifdef CONFIG_DEBUG_FS
 	struct dpaa2_debugfs dbg;
 #endif
+
+	struct dpaa2_mac *mac;
 };
 
 #define DPAA2_RXH_SUPPORTED	(RXH_L2DA | RXH_VLAN | RXH_L3_PROTO \
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index dc9a6c36cac0..0883620631b8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -85,6 +85,10 @@ static void dpaa2_eth_get_drvinfo(struct net_device *net_dev,
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
+	if (priv->mac)
+		return phylink_ethtool_ksettings_get(priv->mac->phylink,
+						     link_settings);
+
 	link_settings->base.autoneg = AUTONEG_DISABLE;
 	if (!(priv->link_state.options & DPNI_LINK_OPT_HALF_DUPLEX))
 		link_settings->base.duplex = DUPLEX_FULL;
@@ -93,12 +97,29 @@ static void dpaa2_eth_get_drvinfo(struct net_device *net_dev,
 	return 0;
 }
 
+static int
+dpaa2_eth_set_link_ksettings(struct net_device *net_dev,
+			     const struct ethtool_link_ksettings *link_settings)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+
+	if (!priv->mac)
+		return -ENOTSUPP;
+
+	return phylink_ethtool_ksettings_set(priv->mac->phylink, link_settings);
+}
+
 static void dpaa2_eth_get_pauseparam(struct net_device *net_dev,
 				     struct ethtool_pauseparam *pause)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	u64 link_options = priv->link_state.options;
 
+	if (priv->mac) {
+		phylink_ethtool_get_pauseparam(priv->mac->phylink, pause);
+		return;
+	}
+
 	pause->rx_pause = !!(link_options & DPNI_LINK_OPT_PAUSE);
 	pause->tx_pause = pause->rx_pause ^
 			  !!(link_options & DPNI_LINK_OPT_ASYM_PAUSE);
@@ -118,6 +139,9 @@ static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
 		return -EOPNOTSUPP;
 	}
 
+	if (priv->mac)
+		return phylink_ethtool_set_pauseparam(priv->mac->phylink,
+						      pause);
 	if (pause->autoneg)
 		return -EOPNOTSUPP;
 
@@ -728,6 +752,7 @@ static int dpaa2_eth_get_ts_info(struct net_device *dev,
 	.get_drvinfo = dpaa2_eth_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_link_ksettings = dpaa2_eth_get_link_ksettings,
+	.set_link_ksettings = dpaa2_eth_set_link_ksettings,
 	.get_pauseparam = dpaa2_eth_get_pauseparam,
 	.set_pauseparam = dpaa2_eth_set_pauseparam,
 	.get_sset_count = dpaa2_eth_get_sset_count,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
new file mode 100644
index 000000000000..fea388d86f20
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -0,0 +1,301 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2019 NXP */
+
+#include "dpaa2-eth.h"
+#include "dpaa2-mac.h"
+
+#define phylink_to_dpaa2_mac(config) \
+	container_of((config), struct dpaa2_mac, phylink_config)
+
+static phy_interface_t phy_mode(enum dpmac_eth_if eth_if)
+{
+	switch (eth_if) {
+	case DPMAC_ETH_IF_RGMII:
+		return PHY_INTERFACE_MODE_RGMII;
+	default:
+		return -EINVAL;
+	}
+}
+
+/* Caller must call of_node_put on the returned value */
+static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
+{
+	struct device_node *dpmacs, *dpmac = NULL;
+	u32 id;
+	int err;
+
+	dpmacs = of_find_node_by_name(NULL, "dpmacs");
+	if (!dpmacs)
+		return NULL;
+
+	while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
+		err = of_property_read_u32(dpmac, "reg", &id);
+		if (err)
+			continue;
+		if (id == dpmac_id)
+			break;
+	}
+
+	of_node_put(dpmacs);
+
+	return dpmac;
+}
+
+static int dpaa2_mac_get_if_mode(struct device_node *node,
+				 struct dpmac_attr attr)
+{
+	int if_mode;
+
+	if_mode = of_get_phy_mode(node);
+	if (if_mode >= 0)
+		return if_mode;
+
+	if_mode = phy_mode(attr.eth_if);
+	if (if_mode >= 0)
+		return if_mode;
+
+	return -ENODEV;
+}
+
+static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_mac *mac,
+					phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		return (interface != mac->if_mode);
+	default:
+		return true;
+	}
+}
+
+static void dpaa2_mac_validate(struct phylink_config *config,
+			       unsigned long *supported,
+			       struct phylink_link_state *state)
+{
+	struct dpaa2_mac *mac = phylink_to_dpaa2_mac(config);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    dpaa2_mac_phy_mode_mismatch(mac, state->interface)) {
+		goto empty_set;
+	}
+
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseT_Full);
+		break;
+	default:
+		goto empty_set;
+	}
+
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
+
+	return;
+
+empty_set:
+	linkmode_zero(supported);
+}
+
+static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
+			     const struct phylink_link_state *state)
+{
+	struct dpaa2_mac *mac = phylink_to_dpaa2_mac(config);
+	struct dpmac_link_state *dpmac_state = &mac->state;
+	int err;
+
+	if (state->speed != SPEED_UNKNOWN)
+		dpmac_state->rate = state->speed;
+
+	if (state->duplex != DUPLEX_UNKNOWN) {
+		if (!state->duplex)
+			dpmac_state->options |= DPMAC_LINK_OPT_HALF_DUPLEX;
+		else
+			dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
+	}
+
+	if (state->an_enabled)
+		dpmac_state->options |= DPMAC_LINK_OPT_AUTONEG;
+	else
+		dpmac_state->options &= ~DPMAC_LINK_OPT_AUTONEG;
+
+	if (state->pause & MLO_PAUSE_RX)
+		dpmac_state->options |= DPMAC_LINK_OPT_PAUSE;
+	else
+		dpmac_state->options &= ~DPMAC_LINK_OPT_PAUSE;
+
+	if (!!(state->pause & MLO_PAUSE_RX) ^ !!(state->pause & MLO_PAUSE_TX))
+		dpmac_state->options |= DPMAC_LINK_OPT_ASYM_PAUSE;
+	else
+		dpmac_state->options &= ~DPMAC_LINK_OPT_ASYM_PAUSE;
+
+	err = dpmac_set_link_state(mac->mc_io, 0,
+				   mac->mc_dev->mc_handle, dpmac_state);
+	if (err)
+		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n", err);
+}
+
+static void dpaa2_mac_link_up(struct phylink_config *config, unsigned int mode,
+			      phy_interface_t interface, struct phy_device *phy)
+{
+	struct dpaa2_mac *mac = phylink_to_dpaa2_mac(config);
+	struct dpmac_link_state *dpmac_state = &mac->state;
+	int err;
+
+	dpmac_state->up = 1;
+	err = dpmac_set_link_state(mac->mc_io, 0,
+				   mac->mc_dev->mc_handle, dpmac_state);
+	if (err)
+		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n", err);
+}
+
+static void dpaa2_mac_link_down(struct phylink_config *config,
+				unsigned int mode,
+				phy_interface_t interface)
+{
+	struct dpaa2_mac *mac = phylink_to_dpaa2_mac(config);
+	struct dpmac_link_state *dpmac_state = &mac->state;
+	int err;
+
+	dpmac_state->up = 0;
+	err = dpmac_set_link_state(mac->mc_io, 0,
+				   mac->mc_dev->mc_handle, dpmac_state);
+	if (err)
+		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n", err);
+}
+
+static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
+	.validate = dpaa2_mac_validate,
+	.mac_config = dpaa2_mac_config,
+	.mac_link_up = dpaa2_mac_link_up,
+	.mac_link_down = dpaa2_mac_link_down,
+};
+
+bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
+			     struct fsl_mc_io *mc_io)
+{
+	struct dpmac_attr attr;
+	bool fixed = false;
+	u16 mc_handle = 0;
+	int err;
+
+	err = dpmac_open(mc_io, 0, dpmac_dev->obj_desc.id,
+			 &mc_handle);
+	if (err || !mc_handle)
+		return false;
+
+	err = dpmac_get_attributes(mc_io, 0, mc_handle, &attr);
+	if (err)
+		goto out;
+
+	if (attr.link_type == DPMAC_LINK_TYPE_FIXED)
+		fixed = true;
+
+out:
+	dpmac_close(mc_io, 0, mc_handle);
+
+	return fixed;
+}
+
+int dpaa2_mac_connect(struct dpaa2_mac *mac)
+{
+	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
+	struct net_device *net_dev = mac->net_dev;
+	struct device_node *dpmac_node;
+	struct phylink *phylink;
+	struct dpmac_attr attr;
+	int err;
+
+	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
+			 &dpmac_dev->mc_handle);
+	if (err || !dpmac_dev->mc_handle) {
+		netdev_err(net_dev, "dpmac_open() = %d\n", err);
+		return -ENODEV;
+	}
+
+	err = dpmac_get_attributes(mac->mc_io, 0, dpmac_dev->mc_handle, &attr);
+	if (err) {
+		netdev_err(net_dev, "dpmac_get_attributes() = %d\n", err);
+		goto err_close_dpmac;
+	}
+
+	dpmac_node = dpaa2_mac_get_node(attr.id);
+	if (!dpmac_node) {
+		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
+		err = -ENODEV;
+		goto err_close_dpmac;
+	}
+
+	err = dpaa2_mac_get_if_mode(dpmac_node, attr);
+	if (err < 0) {
+		err = -EINVAL;
+		goto err_put_node;
+	}
+	mac->if_mode = err;
+
+	/* The MAC does not have the capability to add RGMII delays so
+	 * error out if the interface mode requests them and there is no PHY
+	 * to act upon them
+	 */
+	if (of_phy_is_fixed_link(dpmac_node) &&
+	    (mac->if_mode == PHY_INTERFACE_MODE_RGMII_ID ||
+	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
+	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
+		netdev_err(net_dev, "RGMII delay not supported\n");
+		err = -EINVAL;
+		goto err_put_node;
+	}
+
+	mac->phylink_config.dev = &net_dev->dev;
+	mac->phylink_config.type = PHYLINK_NETDEV;
+
+	phylink = phylink_create(&mac->phylink_config,
+				 of_fwnode_handle(dpmac_node), mac->if_mode,
+				 &dpaa2_mac_phylink_ops);
+	if (IS_ERR(phylink)) {
+		err = PTR_ERR(phylink);
+		goto err_put_node;
+	}
+	mac->phylink = phylink;
+
+	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
+	if (err) {
+		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
+		goto err_phylink_destroy;
+	}
+
+	of_node_put(dpmac_node);
+
+	return 0;
+
+err_phylink_destroy:
+	phylink_destroy(mac->phylink);
+err_put_node:
+	of_node_put(dpmac_node);
+err_close_dpmac:
+	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
+	return err;
+}
+
+void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
+{
+	if (!mac->phylink)
+		return;
+
+	phylink_disconnect_phy(mac->phylink);
+	phylink_destroy(mac->phylink);
+	dpmac_close(mac->mc_io, 0, mac->mc_dev->mc_handle);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
new file mode 100644
index 000000000000..8634d0de7ef3
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2019 NXP */
+#ifndef DPAA2_MAC_H
+#define DPAA2_MAC_H
+
+#include <linux/of.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/phylink.h>
+
+#include "dpmac.h"
+#include "dpmac-cmd.h"
+
+struct dpaa2_mac {
+	struct fsl_mc_device *mc_dev;
+	struct dpmac_link_state state;
+	struct net_device *net_dev;
+	struct fsl_mc_io *mc_io;
+
+	struct phylink_config phylink_config;
+	struct phylink *phylink;
+	phy_interface_t if_mode;
+};
+
+bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
+			     struct fsl_mc_io *mc_io);
+
+int dpaa2_mac_connect(struct dpaa2_mac *mac);
+
+void dpaa2_mac_disconnect(struct dpaa2_mac *mac);
+
+#endif /* DPAA2_MAC_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
new file mode 100644
index 000000000000..96a9b0d0992e
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2013-2016 Freescale Semiconductor Inc.
+ * Copyright 2019 NXP
+ */
+#ifndef _FSL_DPMAC_CMD_H
+#define _FSL_DPMAC_CMD_H
+
+/* DPMAC Version */
+#define DPMAC_VER_MAJOR				4
+#define DPMAC_VER_MINOR				4
+#define DPMAC_CMD_BASE_VERSION			1
+#define DPMAC_CMD_2ND_VERSION			2
+#define DPMAC_CMD_ID_OFFSET			4
+
+#define DPMAC_CMD(id)	(((id) << DPMAC_CMD_ID_OFFSET) | DPMAC_CMD_BASE_VERSION)
+#define DPMAC_CMD_V2(id) (((id) << DPMAC_CMD_ID_OFFSET) | DPMAC_CMD_2ND_VERSION)
+
+/* Command IDs */
+#define DPMAC_CMDID_CLOSE		DPMAC_CMD(0x800)
+#define DPMAC_CMDID_OPEN		DPMAC_CMD(0x80c)
+
+#define DPMAC_CMDID_GET_ATTR		DPMAC_CMD(0x004)
+#define DPMAC_CMDID_SET_LINK_STATE	DPMAC_CMD_V2(0x0c3)
+
+/* Macros for accessing command fields smaller than 1byte */
+#define DPMAC_MASK(field)        \
+	GENMASK(DPMAC_##field##_SHIFT + DPMAC_##field##_SIZE - 1, \
+		DPMAC_##field##_SHIFT)
+
+#define dpmac_set_field(var, field, val) \
+	((var) |= (((val) << DPMAC_##field##_SHIFT) & DPMAC_MASK(field)))
+#define dpmac_get_field(var, field)      \
+	(((var) & DPMAC_MASK(field)) >> DPMAC_##field##_SHIFT)
+
+struct dpmac_cmd_open {
+	__le32 dpmac_id;
+};
+
+struct dpmac_rsp_get_attributes {
+	u8 eth_if;
+	u8 link_type;
+	__le16 id;
+	__le32 max_rate;
+};
+
+#define DPMAC_STATE_SIZE	1
+#define DPMAC_STATE_SHIFT	0
+#define DPMAC_STATE_VALID_SIZE	1
+#define DPMAC_STATE_VALID_SHIFT	1
+
+struct dpmac_cmd_set_link_state {
+	__le64 options;
+	__le32 rate;
+	__le32 pad0;
+	/* from lsb: up:1, state_valid:1 */
+	u8 state;
+	u8 pad1[7];
+	__le64 supported;
+	__le64 advertising;
+};
+
+#endif /* _FSL_DPMAC_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
new file mode 100644
index 000000000000..b75189deffb1
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2013-2016 Freescale Semiconductor Inc.
+ * Copyright 2019 NXP
+ */
+#include <linux/fsl/mc.h>
+#include "dpmac.h"
+#include "dpmac-cmd.h"
+
+/**
+ * dpmac_open() - Open a control session for the specified object.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @dpmac_id:	DPMAC unique ID
+ * @token:	Returned token; use in subsequent API calls
+ *
+ * This function can be used to open a control session for an
+ * already created object; an object may have been declared in
+ * the DPL or by calling the dpmac_create function.
+ * This function returns a unique authentication token,
+ * associated with the specific object ID and the specific MC
+ * portal; this token must be used in all subsequent commands for
+ * this specific object
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmac_open(struct fsl_mc_io *mc_io,
+	       u32 cmd_flags,
+	       int dpmac_id,
+	       u16 *token)
+{
+	struct dpmac_cmd_open *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_OPEN,
+					  cmd_flags,
+					  0);
+	cmd_params = (struct dpmac_cmd_open *)cmd.params;
+	cmd_params->dpmac_id = cpu_to_le32(dpmac_id);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*token = mc_cmd_hdr_read_token(&cmd);
+
+	return err;
+}
+
+/**
+ * dpmac_close() - Close the control session of the object
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPMAC object
+ *
+ * After this function is called, no further operations are
+ * allowed on the object without opening a new control session.
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmac_close(struct fsl_mc_io *mc_io,
+		u32 cmd_flags,
+		u16 token)
+{
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_CLOSE, cmd_flags,
+					  token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpmac_get_attributes - Retrieve DPMAC attributes.
+ *
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPMAC object
+ * @attr:	Returned object's attributes
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmac_get_attributes(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 struct dpmac_attr *attr)
+{
+	struct dpmac_rsp_get_attributes *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_GET_ATTR,
+					  cmd_flags,
+					  token);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	rsp_params = (struct dpmac_rsp_get_attributes *)cmd.params;
+	attr->eth_if = rsp_params->eth_if;
+	attr->link_type = rsp_params->link_type;
+	attr->id = le16_to_cpu(rsp_params->id);
+	attr->max_rate = le32_to_cpu(rsp_params->max_rate);
+
+	return 0;
+}
+
+/**
+ * dpmac_set_link_state() - Set the Ethernet link status
+ * @mc_io:      Pointer to opaque I/O object
+ * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:      Token of DPMAC object
+ * @link_state: Link state configuration
+ *
+ * Return:      '0' on Success; Error code otherwise.
+ */
+int dpmac_set_link_state(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 struct dpmac_link_state *link_state)
+{
+	struct dpmac_cmd_set_link_state *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_SET_LINK_STATE,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpmac_cmd_set_link_state *)cmd.params;
+	cmd_params->options = cpu_to_le64(link_state->options);
+	cmd_params->rate = cpu_to_le32(link_state->rate);
+	dpmac_set_field(cmd_params->state, STATE, link_state->up);
+	dpmac_set_field(cmd_params->state, STATE_VALID,
+			link_state->state_valid);
+	cmd_params->supported = cpu_to_le64(link_state->supported);
+	cmd_params->advertising = cpu_to_le64(link_state->advertising);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.h b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
new file mode 100644
index 000000000000..4efc410a479e
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
@@ -0,0 +1,144 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2013-2016 Freescale Semiconductor Inc.
+ * Copyright 2019 NXP
+ */
+#ifndef __FSL_DPMAC_H
+#define __FSL_DPMAC_H
+
+/* Data Path MAC API
+ * Contains initialization APIs and runtime control APIs for DPMAC
+ */
+
+struct fsl_mc_io;
+
+int dpmac_open(struct fsl_mc_io *mc_io,
+	       u32 cmd_flags,
+	       int dpmac_id,
+	       u16 *token);
+
+int dpmac_close(struct fsl_mc_io *mc_io,
+		u32 cmd_flags,
+		u16 token);
+
+/**
+ * enum dpmac_link_type -  DPMAC link type
+ * @DPMAC_LINK_TYPE_NONE: No link
+ * @DPMAC_LINK_TYPE_FIXED: Link is fixed type
+ * @DPMAC_LINK_TYPE_PHY: Link by PHY ID
+ * @DPMAC_LINK_TYPE_BACKPLANE: Backplane link type
+ */
+enum dpmac_link_type {
+	DPMAC_LINK_TYPE_NONE,
+	DPMAC_LINK_TYPE_FIXED,
+	DPMAC_LINK_TYPE_PHY,
+	DPMAC_LINK_TYPE_BACKPLANE
+};
+
+/**
+ * enum dpmac_eth_if - DPMAC Ethrnet interface
+ * @DPMAC_ETH_IF_MII: MII interface
+ * @DPMAC_ETH_IF_RMII: RMII interface
+ * @DPMAC_ETH_IF_SMII: SMII interface
+ * @DPMAC_ETH_IF_GMII: GMII interface
+ * @DPMAC_ETH_IF_RGMII: RGMII interface
+ * @DPMAC_ETH_IF_SGMII: SGMII interface
+ * @DPMAC_ETH_IF_QSGMII: QSGMII interface
+ * @DPMAC_ETH_IF_XAUI: XAUI interface
+ * @DPMAC_ETH_IF_XFI: XFI interface
+ * @DPMAC_ETH_IF_CAUI: CAUI interface
+ * @DPMAC_ETH_IF_1000BASEX: 1000BASEX interface
+ * @DPMAC_ETH_IF_USXGMII: USXGMII interface
+ */
+enum dpmac_eth_if {
+	DPMAC_ETH_IF_MII,
+	DPMAC_ETH_IF_RMII,
+	DPMAC_ETH_IF_SMII,
+	DPMAC_ETH_IF_GMII,
+	DPMAC_ETH_IF_RGMII,
+	DPMAC_ETH_IF_SGMII,
+	DPMAC_ETH_IF_QSGMII,
+	DPMAC_ETH_IF_XAUI,
+	DPMAC_ETH_IF_XFI,
+	DPMAC_ETH_IF_CAUI,
+	DPMAC_ETH_IF_1000BASEX,
+	DPMAC_ETH_IF_USXGMII,
+};
+
+/**
+ * struct dpmac_attr - Structure representing DPMAC attributes
+ * @id:		DPMAC object ID
+ * @max_rate:	Maximum supported rate - in Mbps
+ * @eth_if:	Ethernet interface
+ * @link_type:	link type
+ */
+struct dpmac_attr {
+	u16 id;
+	u32 max_rate;
+	enum dpmac_eth_if eth_if;
+	enum dpmac_link_type link_type;
+};
+
+int dpmac_get_attributes(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 struct dpmac_attr *attr);
+
+/**
+ * DPMAC link configuration/state options
+ */
+
+/**
+ * Enable auto-negotiation
+ */
+#define DPMAC_LINK_OPT_AUTONEG			BIT_ULL(0)
+/**
+ * Enable half-duplex mode
+ */
+#define DPMAC_LINK_OPT_HALF_DUPLEX		BIT_ULL(1)
+/**
+ * Enable pause frames
+ */
+#define DPMAC_LINK_OPT_PAUSE			BIT_ULL(2)
+/**
+ * Enable a-symmetric pause frames
+ */
+#define DPMAC_LINK_OPT_ASYM_PAUSE		BIT_ULL(3)
+
+/**
+ * Advertised link speeds
+ */
+#define DPMAC_ADVERTISED_10BASET_FULL		BIT_ULL(0)
+#define DPMAC_ADVERTISED_100BASET_FULL		BIT_ULL(1)
+#define DPMAC_ADVERTISED_1000BASET_FULL		BIT_ULL(2)
+#define DPMAC_ADVERTISED_10000BASET_FULL	BIT_ULL(4)
+#define DPMAC_ADVERTISED_2500BASEX_FULL		BIT_ULL(5)
+
+/**
+ * Advertise auto-negotiation enable
+ */
+#define DPMAC_ADVERTISED_AUTONEG		BIT_ULL(3)
+
+/**
+ * struct dpmac_link_state - DPMAC link configuration request
+ * @rate: Rate in Mbps
+ * @options: Enable/Disable DPMAC link cfg features (bitmap)
+ * @up: Link state
+ * @state_valid: Ignore/Update the state of the link
+ * @supported: Speeds capability of the phy (bitmap)
+ * @advertising: Speeds that are advertised for autoneg (bitmap)
+ */
+struct dpmac_link_state {
+	u32 rate;
+	u64 options;
+	int up;
+	int state_valid;
+	u64 supported;
+	u64 advertising;
+};
+
+int dpmac_set_link_state(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 struct dpmac_link_state *link_state);
+
+#endif /* __FSL_DPMAC_H */
-- 
1.9.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD282BBB5
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfE0VXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:23:04 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36716 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfE0VWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:22:54 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 764301A003D;
        Mon, 27 May 2019 23:22:52 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6880A1A0CB9;
        Mon, 27 May 2019 23:22:52 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DB5DF2060A;
        Mon, 27 May 2019 23:22:51 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 08/11] net: phylink: Add phylink_{printk,err,warn,info,dbg} macros
Date:   Tue, 28 May 2019 00:22:04 +0300
Message-Id: <1558992127-26008-9-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the latest addition to the PHYLINK infrastructure, we are faced
with a decision on when to print necessary info using the struct
net_device and when with the struct device.

Add a series of macros that encapsulate this decision and replace all
uses of netdev_err&co with phylink_err.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/phy/phylink.c | 137 +++++++++++++++++++++-----------------
 1 file changed, 77 insertions(+), 60 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5f6120f3fa3f..68d0a89c52be 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -68,6 +68,23 @@ struct phylink {
 	struct sfp_bus *sfp_bus;
 };
 
+#define phylink_printk(level, pl, fmt, ...) \
+	do { \
+		if ((pl)->config->type == PHYLINK_NETDEV) \
+			netdev_printk(level, (pl)->netdev, fmt, ##__VA_ARGS__); \
+		else if ((pl)->config->type == PHYLINK_DEV) \
+			dev_printk(level, (pl)->dev, fmt, ##__VA_ARGS__); \
+	} while (0)
+
+#define phylink_err(pl, fmt, ...) \
+	phylink_printk(KERN_ERR, pl, fmt, ##__VA_ARGS__)
+#define phylink_warn(pl, fmt, ...) \
+	phylink_printk(KERN_WARNING, pl, fmt, ##__VA_ARGS__)
+#define phylink_info(pl, fmt, ...) \
+	phylink_printk(KERN_INFO, pl, fmt, ##__VA_ARGS__)
+#define phylink_dbg(pl, fmt, ...) \
+	phylink_printk(KERN_DEBUG, pl, fmt, ##__VA_ARGS__)
+
 /**
  * phylink_set_port_modes() - set the port type modes in the ethtool mask
  * @mask: ethtool link mode mask
@@ -164,7 +181,7 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 		ret = fwnode_property_read_u32_array(fwnode, "fixed-link",
 						     NULL, 0);
 		if (ret != ARRAY_SIZE(prop)) {
-			netdev_err(pl->netdev, "broken fixed-link?\n");
+			phylink_err(pl, "broken fixed-link?\n");
 			return -EINVAL;
 		}
 
@@ -183,8 +200,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 
 	if (pl->link_config.speed > SPEED_1000 &&
 	    pl->link_config.duplex != DUPLEX_FULL)
-		netdev_warn(pl->netdev, "fixed link specifies half duplex for %dMbps link?\n",
-			    pl->link_config.speed);
+		phylink_warn(pl, "fixed link specifies half duplex for %dMbps link?\n",
+			     pl->link_config.speed);
 
 	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	linkmode_copy(pl->link_config.advertising, pl->supported);
@@ -197,9 +214,9 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 	if (s) {
 		__set_bit(s->bit, pl->supported);
 	} else {
-		netdev_warn(pl->netdev, "fixed link %s duplex %dMbps not recognised\n",
-			    pl->link_config.duplex == DUPLEX_FULL ? "full" : "half",
-			    pl->link_config.speed);
+		phylink_warn(pl, "fixed link %s duplex %dMbps not recognised\n",
+			     pl->link_config.duplex == DUPLEX_FULL ? "full" : "half",
+			     pl->link_config.speed);
 	}
 
 	linkmode_and(pl->link_config.advertising, pl->link_config.advertising,
@@ -224,8 +241,8 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 	if (fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
 	    strcmp(managed, "in-band-status") == 0) {
 		if (pl->link_an_mode == MLO_AN_FIXED) {
-			netdev_err(pl->netdev,
-				   "can't use both fixed-link and in-band-status\n");
+			phylink_err(pl,
+				    "can't use both fixed-link and in-band-status\n");
 			return -EINVAL;
 		}
 
@@ -272,17 +289,17 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			break;
 
 		default:
-			netdev_err(pl->netdev,
-				   "incorrect link mode %s for in-band status\n",
-				   phy_modes(pl->link_config.interface));
+			phylink_err(pl,
+				    "incorrect link mode %s for in-band status\n",
+				    phy_modes(pl->link_config.interface));
 			return -EINVAL;
 		}
 
 		linkmode_copy(pl->link_config.advertising, pl->supported);
 
 		if (phylink_validate(pl, pl->supported, &pl->link_config)) {
-			netdev_err(pl->netdev,
-				   "failed to validate link configuration for in-band status\n");
+			phylink_err(pl,
+				    "failed to validate link configuration for in-band status\n");
 			return -EINVAL;
 		}
 	}
@@ -293,14 +310,14 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 static void phylink_mac_config(struct phylink *pl,
 			       const struct phylink_link_state *state)
 {
-	netdev_dbg(pl->netdev,
-		   "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
-		   __func__, phylink_an_mode_str(pl->link_an_mode),
-		   phy_modes(state->interface),
-		   phy_speed_to_str(state->speed),
-		   phy_duplex_to_str(state->duplex),
-		   __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
-		   state->pause, state->link, state->an_enabled);
+	phylink_dbg(pl,
+		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
+		    __func__, phylink_an_mode_str(pl->link_an_mode),
+		    phy_modes(state->interface),
+		    phy_speed_to_str(state->speed),
+		    phy_duplex_to_str(state->duplex),
+		    __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
+		    state->pause, state->link, state->an_enabled);
 
 	pl->ops->mac_config(pl->config, pl->link_an_mode, state);
 }
@@ -409,11 +426,11 @@ static void phylink_mac_link_up(struct phylink *pl,
 	if (ndev)
 		netif_carrier_on(ndev);
 
-	netdev_info(ndev,
-		    "Link is Up - %s/%s - flow control %s\n",
-		    phy_speed_to_str(link_state.speed),
-		    phy_duplex_to_str(link_state.duplex),
-		    phylink_pause_to_str(link_state.pause));
+	phylink_info(pl,
+		     "Link is Up - %s/%s - flow control %s\n",
+		     phy_speed_to_str(link_state.speed),
+		     phy_duplex_to_str(link_state.duplex),
+		     phylink_pause_to_str(link_state.pause));
 }
 
 static void phylink_mac_link_down(struct phylink *pl)
@@ -424,7 +441,7 @@ static void phylink_mac_link_down(struct phylink *pl)
 		netif_carrier_off(ndev);
 	pl->ops->mac_link_down(pl->config, pl->link_an_mode,
 			       pl->phy_state.interface);
-	netdev_info(ndev, "Link is Down\n");
+	phylink_info(pl, "Link is Down\n");
 }
 
 static void phylink_resolve(struct work_struct *w)
@@ -537,8 +554,8 @@ static int phylink_register_sfp(struct phylink *pl,
 		if (ret == -ENOENT)
 			return 0;
 
-		netdev_err(pl->netdev, "unable to parse \"sfp\" node: %d\n",
-			   ret);
+		phylink_err(pl, "unable to parse \"sfp\" node: %d\n",
+			    ret);
 		return ret;
 	}
 
@@ -670,10 +687,10 @@ static void phylink_phy_change(struct phy_device *phydev, bool up,
 
 	phylink_run_resolve(pl);
 
-	netdev_dbg(pl->netdev, "phy link %s %s/%s/%s\n", up ? "up" : "down",
-		   phy_modes(phydev->interface),
-		   phy_speed_to_str(phydev->speed),
-		   phy_duplex_to_str(phydev->duplex));
+	phylink_dbg(pl, "phy link %s %s/%s/%s\n", up ? "up" : "down",
+		    phy_modes(phydev->interface),
+		    phy_speed_to_str(phydev->speed),
+		    phy_duplex_to_str(phydev->duplex));
 }
 
 static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
@@ -706,9 +723,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	phy->phylink = pl;
 	phy->phy_link_change = phylink_phy_change;
 
-	netdev_info(pl->netdev,
-		    "PHY [%s] driver [%s]\n", dev_name(&phy->mdio.dev),
-		    phy->drv->name);
+	phylink_info(pl,
+		     "PHY [%s] driver [%s]\n", dev_name(&phy->mdio.dev),
+		     phy->drv->name);
 
 	mutex_lock(&phy->lock);
 	mutex_lock(&pl->state_mutex);
@@ -721,10 +738,10 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	mutex_unlock(&pl->state_mutex);
 	mutex_unlock(&phy->lock);
 
-	netdev_dbg(pl->netdev,
-		   "phy: setting supported %*pb advertising %*pb\n",
-		   __ETHTOOL_LINK_MODE_MASK_NBITS, pl->supported,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS, phy->advertising);
+	phylink_dbg(pl,
+		    "phy: setting supported %*pb advertising %*pb\n",
+		    __ETHTOOL_LINK_MODE_MASK_NBITS, pl->supported,
+		    __ETHTOOL_LINK_MODE_MASK_NBITS, phy->advertising);
 
 	if (phy_interrupt_is_valid(phy))
 		phy_request_interrupt(phy);
@@ -902,7 +919,7 @@ void phylink_mac_change(struct phylink *pl, bool up)
 	if (!up)
 		pl->mac_link_dropped = true;
 	phylink_run_resolve(pl);
-	netdev_dbg(pl->netdev, "mac link %s\n", up ? "up" : "down");
+	phylink_dbg(pl, "mac link %s\n", up ? "up" : "down");
 }
 EXPORT_SYMBOL_GPL(phylink_mac_change);
 
@@ -918,9 +935,9 @@ void phylink_start(struct phylink *pl)
 {
 	ASSERT_RTNL();
 
-	netdev_info(pl->netdev, "configuring for %s/%s link mode\n",
-		    phylink_an_mode_str(pl->link_an_mode),
-		    phy_modes(pl->link_config.interface));
+	phylink_info(pl, "configuring for %s/%s link mode\n",
+		     phylink_an_mode_str(pl->link_an_mode),
+		     phy_modes(pl->link_config.interface));
 
 	/* Always set the carrier off */
 	if (pl->netdev)
@@ -1631,33 +1648,33 @@ static int phylink_sfp_module_insert(void *upstream,
 	/* Ignore errors if we're expecting a PHY to attach later */
 	ret = phylink_validate(pl, support, &config);
 	if (ret) {
-		netdev_err(pl->netdev, "validation with support %*pb failed: %d\n",
-			   __ETHTOOL_LINK_MODE_MASK_NBITS, support, ret);
+		phylink_err(pl, "validation with support %*pb failed: %d\n",
+			    __ETHTOOL_LINK_MODE_MASK_NBITS, support, ret);
 		return ret;
 	}
 
 	iface = sfp_select_interface(pl->sfp_bus, id, config.advertising);
 	if (iface == PHY_INTERFACE_MODE_NA) {
-		netdev_err(pl->netdev,
-			   "selection of interface failed, advertisement %*pb\n",
-			   __ETHTOOL_LINK_MODE_MASK_NBITS, config.advertising);
+		phylink_err(pl,
+			    "selection of interface failed, advertisement %*pb\n",
+			    __ETHTOOL_LINK_MODE_MASK_NBITS, config.advertising);
 		return -EINVAL;
 	}
 
 	config.interface = iface;
 	ret = phylink_validate(pl, support, &config);
 	if (ret) {
-		netdev_err(pl->netdev, "validation of %s/%s with support %*pb failed: %d\n",
-			   phylink_an_mode_str(MLO_AN_INBAND),
-			   phy_modes(config.interface),
-			   __ETHTOOL_LINK_MODE_MASK_NBITS, support, ret);
+		phylink_err(pl, "validation of %s/%s with support %*pb failed: %d\n",
+			    phylink_an_mode_str(MLO_AN_INBAND),
+			    phy_modes(config.interface),
+			    __ETHTOOL_LINK_MODE_MASK_NBITS, support, ret);
 		return ret;
 	}
 
-	netdev_dbg(pl->netdev, "requesting link mode %s/%s with support %*pb\n",
-		   phylink_an_mode_str(MLO_AN_INBAND),
-		   phy_modes(config.interface),
-		   __ETHTOOL_LINK_MODE_MASK_NBITS, support);
+	phylink_dbg(pl, "requesting link mode %s/%s with support %*pb\n",
+		    phylink_an_mode_str(MLO_AN_INBAND),
+		    phy_modes(config.interface),
+		    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
 
 	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
 		return -EINVAL;
@@ -1676,9 +1693,9 @@ static int phylink_sfp_module_insert(void *upstream,
 
 		changed = true;
 
-		netdev_info(pl->netdev, "switched to %s/%s link mode\n",
-			    phylink_an_mode_str(MLO_AN_INBAND),
-			    phy_modes(config.interface));
+		phylink_info(pl, "switched to %s/%s link mode\n",
+			     phylink_an_mode_str(MLO_AN_INBAND),
+			     phy_modes(config.interface));
 	}
 
 	pl->link_port = port;
-- 
2.21.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740DC45CB74
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349977AbhKXR4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349953AbhKXR4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:56:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FC5C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0WaH98lUbxJJzIavEW9RaCZPKtgYN4OPLnKtjvJNeLA=; b=yQOOtdWlu2T3HvASP6KAxxj76s
        Jw2cVrDqtVLCEbOdi6xrz9k87POFFVTt9pjhLCPxpxlLLEjqsYrPjq3CAOAKL/KXQ+YhwQe2nlsvm
        8w6Yt8lYOzD9miTDn8IfF112vKD223WvSntuzV8n9OVuiEuTYvkmM0Y9VweIm3LxM6Z+CwyS3CIId
        cX4W0Kfh8KjH+VInzOp/3TJuOxMhcYoQpN5xhLK3u6JGiVqi/mt/2umka8Ds1xO2fH/NAIChoUVCa
        fLLThm1RNW+pXTPvtLXZiLKusg6C72qKPNQwfIQxIcbVcCrFLUVKfsecC/zwiQeDNYT+4g8RThmBd
        O7NOd7lg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49534 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwSD-0000yH-N7; Wed, 24 Nov 2021 17:53:09 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwSD-00D8Ln-88; Wed, 24 Nov 2021 17:53:09 +0000
In-Reply-To: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH RFC net-next 09/12] net: dsa: ocelot: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwSD-00D8Ln-88@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:53:09 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the Ocelot
DSA switches and remove the old validate implementation to allow DSA to
use phylink_generic_validate() for this switch driver.

The felix_vsc9959 and seville_vsc9953 sub-drivers only supports a
single interface mode, defined by ocelot_port->phy_mode, so we indicate
only this interface mode to phylink. Since phylink restricts the
ethtool link modes based on interface, we do not need to make the MAC
capabilities dependent on the interface mode.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/ocelot/felix.c           | 11 ++++---
 drivers/net/dsa/ocelot/felix.h           |  5 ++--
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 37 +++++-------------------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 34 +++++-----------------
 4 files changed, 21 insertions(+), 66 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e487143709da..26529db951fc 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -801,15 +801,14 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 	return ocelot_vlan_del(ocelot, port, vlan->vid);
 }
 
-static void felix_phylink_validate(struct dsa_switch *ds, int port,
-				   unsigned long *supported,
-				   struct phylink_link_state *state)
+static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
+				   struct phylink_config *config)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 
-	if (felix->info->phylink_validate)
-		felix->info->phylink_validate(ocelot, port, supported, state);
+	if (felix->info->phylink_get_caps)
+		felix->info->phylink_get_caps(ocelot, port, config);
 }
 
 static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
@@ -1644,7 +1643,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.get_ethtool_stats		= felix_get_ethtool_stats,
 	.get_sset_count			= felix_get_sset_count,
 	.get_ts_info			= felix_get_ts_info,
-	.phylink_validate		= felix_phylink_validate,
+	.phylink_get_caps		= felix_phylink_get_caps,
 	.phylink_mac_config		= felix_phylink_mac_config,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
 	.phylink_mac_link_up		= felix_phylink_mac_link_up,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index dfe08dddd262..1060add151de 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -43,9 +43,8 @@ struct felix_info {
 
 	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
 	void	(*mdio_bus_free)(struct ocelot *ocelot);
-	void	(*phylink_validate)(struct ocelot *ocelot, int port,
-				    unsigned long *supported,
-				    struct phylink_link_state *state);
+	void	(*phylink_get_caps)(struct ocelot *ocelot, int port,
+				    struct phylink_config *config);
 	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
 					phy_interface_t phy_mode);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 42ac1952b39a..091d33a52e41 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -938,39 +938,16 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
-				     unsigned long *supported,
-				     struct phylink_link_state *state)
+static void vsc9959_phylink_get_caps(struct ocelot *ocelot, int port,
+				     struct phylink_config *config)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != ocelot_port->phy_mode) {
-		linkmode_zero(supported);
-		return;
-	}
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 1000baseT_Half);
-	phylink_set(mask, 1000baseT_Full);
-
-	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
-	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
-	    state->interface == PHY_INTERFACE_MODE_USXGMII) {
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-	}
+	__set_bit(ocelot_port->phy_mode,
+		  config->supported_interfaces);
 
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000 | MAC_2500FD;
 }
 
 static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
@@ -2161,7 +2138,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
-	.phylink_validate	= vsc9959_phylink_validate,
+	.phylink_get_caps	= vsc9959_phylink_get_caps,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 899b98193b4a..37759853e1b2 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -994,36 +994,16 @@ static int vsc9953_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
-				     unsigned long *supported,
-				     struct phylink_link_state *state)
+static void vsc9953_phylink_get_caps(struct ocelot *ocelot, int port,
+				     struct phylink_config *config)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != ocelot_port->phy_mode) {
-		linkmode_zero(supported);
-		return;
-	}
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 1000baseT_Full);
-
-	if (state->interface == PHY_INTERFACE_MODE_INTERNAL) {
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-	}
+	__set_bit(ocelot_port->phy_mode,
+		  config->supported_interfaces);
 
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000FD | MAC_2500FD;
 }
 
 static int vsc9953_prevalidate_phy_mode(struct ocelot *ocelot, int port,
@@ -1185,7 +1165,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.num_tx_queues		= OCELOT_NUM_TC,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
-	.phylink_validate	= vsc9953_phylink_validate,
+	.phylink_get_caps	= vsc9953_phylink_get_caps,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
 };
 
-- 
2.30.2


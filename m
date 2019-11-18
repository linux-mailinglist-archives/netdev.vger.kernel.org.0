Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E395100B30
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfKRSNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:13:36 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52928 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfKRSNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 13:13:35 -0500
Received: by mail-wm1-f65.google.com with SMTP id l1so278395wme.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 10:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ruQsRQl01m3B5vpe/VQeexY4FBengYqNOOSqVcMMaIk=;
        b=naO2itAY7+ChX3kqOkDf7gYHN2psm/C5YZLORwUdleZyJiT8qRlf16rt1OQ8s9skcm
         BmMNfn8Hmh/2BHyV7J4AQG41KTECr/aeksMKmoEh00cAAq4I6BpDLhHNLXGLclDKyupn
         cjULwNVKwNahI+e58hfs41mbt0Ky+WL/GVlaiyBtqjBCjTGBn4BuFOK9d9pgfiwKeHIB
         HKbmVcKXyIlb4AmlaX0z0NhG6/PA0T4ddaj0A8yIc2t2kYcirymMCqTjWBdG4+g0Z3pI
         2C+oWX/H0Exi2e8s1vQXfRS8iI7NXUnr2R2sKmK5ntXbwFOGXwUInRp60z86g3l3vfHh
         Dj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ruQsRQl01m3B5vpe/VQeexY4FBengYqNOOSqVcMMaIk=;
        b=XIH7BfxvXYTU0jM/KImDhyEgoL7cc+tw3pSNhpq1IFsWdYezdccgZsscABm3E0tl40
         WPBf1Ab5BUDU00U8xLj3goI1UGHQyt5YUgYiOSn4Xk3STh/3jiPWA7j/vSASpjZ9CdUf
         ME8WQd/11fw5xoeUOVGODgAlG67OTJ7SgQNmWqsS01wdHzbUb+b8Iww0pPgNzmJ9z+hD
         BL2UNIiiMmbphD5KGk6w94GPlODNWdPQcu9xvnm/FRWlTv5dppzDTIWHoKAFxfHjO7Zj
         9iq8zXKKnc6+rsWkCgHT5LxM4MWBoTj5soPRCj46ZIB0yWiCnY8Zku12cpn+R58tAeAM
         s/pA==
X-Gm-Message-State: APjAAAWjvQoy2x1pX1jm2IH5nDqHCBWZpzE7RUax0X095VVppmEn6Bo6
        eLVSNTVmV5Z1/nGxacLKqpU=
X-Google-Smtp-Source: APXvYqz0/xICKqqDEa7p8TyIP78nOCqM52smTakYEFISUqMEy9jyVJNR1XXKVT3EGHRoTnp+cY3G3Q==
X-Received: by 2002:a1c:4606:: with SMTP id t6mr403042wma.73.1574100810011;
        Mon, 18 Nov 2019 10:13:30 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id w7sm23341302wru.62.2019.11.18.10.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 10:13:29 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, linux@armlinux.org.uk,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/2] net: mscc: ocelot: convert to PHYLINK
Date:   Mon, 18 Nov 2019 20:10:30 +0200
Message-Id: <20191118181030.23921-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191118181030.23921-1-olteanv@gmail.com>
References: <20191118181030.23921-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch reworks ocelot_board.c (aka the MIPS on the VSC7514) to
register a PHYLINK instance for each port. The registration code is
local to the VSC7514, but the PHYLINK callback implementation is common
so that the Felix DSA front-end can use it as well (but DSA does its own
registration).

Now Felix can use native PHYLINK callbacks instead of the PHYLIB
adaptation layer in DSA, which had issues supporting fixed-link slave
ports (no struct phy_device to pass to the adjust_link callback), as
well as fixed-link CPU port at 2.5Gbps.

The old code from ocelot_port_enable and ocelot_port_disable has been
moved into ocelot_phylink_mac_link_up and ocelot_phylink_mac_link_down.

The PHY connect operation has been moved from ocelot_port_open to
mscc_ocelot_probe in ocelot_board.c.

The phy_set_mode_ext() call for the SerDes PHY has also been moved into
mscc_ocelot_probe from ocelot_port_open, and since that was the only
reason why a reference to it was kept in ocelot_port_private, that
reference was removed.

Again, the usage of phy_interface_t phy_mode is now local to
mscc_ocelot_probe only, after moving the PHY connect operation.
So it was also removed from ocelot_port_private.
*Maybe* in the future, it can be added back to the common struct
ocelot_port, with the purpose of validating mismatches between
state->phy_interface and ocelot_port->phy_mode in PHYLINK callbacks.
But at the moment that is not critical, since other DSA drivers are not
doing that either. No SFP+ modules are in use with Felix/Ocelot yet, to
my knowledge.

In-band AN is not yet supported, due to the fact that this is a mostly
mechanical patch for the moment. The mac_an_restart PHYLINK operation
needs to be implemented, as well as mac_link_state. Both are SerDes
specific, and Felix does not have its PCS configured yet (it works just
by virtue of U-Boot initialization at the moment).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           |  65 +++++++---
 drivers/net/ethernet/mscc/Kconfig        |   2 +-
 drivers/net/ethernet/mscc/ocelot.c       | 152 ++++++++++++-----------
 drivers/net/ethernet/mscc/ocelot.h       |  13 +-
 drivers/net/ethernet/mscc/ocelot_board.c | 151 +++++++++++++++++++---
 include/soc/mscc/ocelot.h                |  21 +++-
 6 files changed, 284 insertions(+), 120 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 05e3f2898bf6..d73c38c6cbcf 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -25,14 +25,6 @@ static int felix_set_ageing_time(struct dsa_switch *ds,
 	return 0;
 }
 
-static void felix_adjust_link(struct dsa_switch *ds, int port,
-			      struct phy_device *phydev)
-{
-	struct ocelot *ocelot = ds->priv;
-
-	ocelot_adjust_link(ocelot, port, phydev);
-}
-
 static int felix_fdb_dump(struct dsa_switch *ds, int port,
 			  dsa_fdb_dump_cb_t *cb, void *data)
 {
@@ -137,21 +129,57 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int felix_port_enable(struct dsa_switch *ds, int port,
-			     struct phy_device *phy)
+static void felix_phylink_validate(struct dsa_switch *ds, int port,
+				   unsigned long *supported,
+				   struct phylink_link_state *state)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_enable(ocelot, port, phy);
+	ocelot_phylink_validate(ocelot, port, supported, state);
+}
 
-	return 0;
+static int felix_phylink_mac_link_state(struct dsa_switch *ds, int port,
+					struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_phylink_mac_link_state(ocelot, port, state);
+}
+
+static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
+				     unsigned int link_an_mode,
+				     const struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_phylink_mac_config(ocelot, port, link_an_mode, state);
+}
+
+static void felix_phylink_mac_an_restart(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_phylink_mac_an_restart(ocelot, port);
+}
+
+static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
+					unsigned int link_an_mode,
+					phy_interface_t interface)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface);
 }
 
-static void felix_port_disable(struct dsa_switch *ds, int port)
+static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
+				      unsigned int link_an_mode,
+				      phy_interface_t interface,
+				      struct phy_device *phydev)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_disable(ocelot, port);
+	ocelot_phylink_mac_link_up(ocelot, port, link_an_mode, interface,
+				   phydev);
 }
 
 static void felix_get_strings(struct dsa_switch *ds, int port,
@@ -312,9 +340,12 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.get_ethtool_stats	= felix_get_ethtool_stats,
 	.get_sset_count		= felix_get_sset_count,
 	.get_ts_info		= felix_get_ts_info,
-	.adjust_link		= felix_adjust_link,
-	.port_enable		= felix_port_enable,
-	.port_disable		= felix_port_disable,
+	.phylink_validate	= felix_phylink_validate,
+	.phylink_mac_link_state	= felix_phylink_mac_link_state,
+	.phylink_mac_config	= felix_phylink_mac_config,
+	.phylink_mac_an_restart	= felix_phylink_mac_an_restart,
+	.phylink_mac_link_down	= felix_phylink_mac_link_down,
+	.phylink_mac_link_up	= felix_phylink_mac_link_up,
 	.port_fdb_dump		= felix_fdb_dump,
 	.port_fdb_add		= felix_fdb_add,
 	.port_fdb_del		= felix_fdb_del,
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index bcec0587cf61..c89dfce529de 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -15,7 +15,7 @@ config MSCC_OCELOT_SWITCH
 	tristate "Ocelot switch driver"
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
-	select PHYLIB
+	select PHYLINK
 	select REGMAP_MMIO
 	help
 	  This driver supports the Ocelot network switch device.
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7fd85767aa8e..a0f918262220 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -13,7 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/skbuff.h>
 #include <linux/iopoll.h>
@@ -406,13 +406,56 @@ static u16 ocelot_wm_enc(u16 value)
 	return value;
 }
 
-void ocelot_adjust_link(struct ocelot *ocelot, int port,
-			struct phy_device *phydev)
+void ocelot_phylink_validate(struct ocelot *ocelot, int port,
+			     unsigned long *supported,
+			     struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	/* No half-duplex. */
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, MII);
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 2500baseT_Full);
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+EXPORT_SYMBOL(ocelot_phylink_validate);
+
+int ocelot_phylink_mac_link_state(struct ocelot *ocelot, int port,
+				  struct phylink_link_state *state)
+{
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(ocelot_phylink_mac_link_state);
+
+void ocelot_phylink_mac_an_restart(struct ocelot *ocelot, int port)
+{
+	/* Not supported */
+}
+EXPORT_SYMBOL(ocelot_phylink_mac_an_restart);
+
+void ocelot_phylink_mac_config(struct ocelot *ocelot, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	int speed, mode = 0;
+	int speed, mac_mode = 0;
+	u32 mac_fc_cfg;
 
-	switch (phydev->speed) {
+	if (link_an_mode == MLO_AN_INBAND) {
+		dev_err(ocelot->dev, "In-band AN not supported!\n");
+		return;
+	}
+
+	switch (state->speed) {
 	case SPEED_UNKNOWN:
 	case SPEED_10:
 		speed = OCELOT_SPEED_10;
@@ -422,26 +465,24 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 		break;
 	case SPEED_1000:
 		speed = OCELOT_SPEED_1000;
-		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
+		mac_mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
 		break;
 	case SPEED_2500:
 		speed = OCELOT_SPEED_2500;
-		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
+		mac_mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
 		break;
 	default:
 		dev_err(ocelot->dev, "Unsupported PHY speed on port %d: %d\n",
-			port, phydev->speed);
+			port, state->speed);
 		return;
 	}
 
-	phy_print_status(phydev);
-
-	if (!phydev->link)
+	if (!state->link)
 		return;
 
 	/* Only full duplex supported for now */
 	ocelot_port_writel(ocelot_port, DEV_MAC_MODE_CFG_FDX_ENA |
-			   mode, DEV_MAC_MODE_CFG);
+			   mac_mode, DEV_MAC_MODE_CFG);
 
 	if (ocelot->ops->pcs_init)
 		ocelot->ops->pcs_init(ocelot, port);
@@ -466,27 +507,36 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			 QSYS_SWITCH_PORT_MODE, port);
 
 	/* Flow control */
-	ocelot_write_rix(ocelot, SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
-			 SYS_MAC_FC_CFG_RX_FC_ENA | SYS_MAC_FC_CFG_TX_FC_ENA |
-			 SYS_MAC_FC_CFG_ZERO_PAUSE_ENA |
-			 SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
-			 SYS_MAC_FC_CFG_FC_LINK_SPEED(speed),
-			 SYS_MAC_FC_CFG, port);
+	mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(speed);
+	if (state->pause & MLO_PAUSE_RX)
+		mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
+	if (state->pause & MLO_PAUSE_TX)
+		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
+			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
+			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
+			      SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
+	ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
+
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
 }
-EXPORT_SYMBOL(ocelot_adjust_link);
+EXPORT_SYMBOL(ocelot_phylink_mac_config);
 
-static void ocelot_port_adjust_link(struct net_device *dev)
+void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
+				  unsigned int link_an_mode,
+				  phy_interface_t interface)
 {
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
-	ocelot_adjust_link(ocelot, port, dev->phydev);
+	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
+	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
+		       QSYS_SWITCH_PORT_MODE, port);
 }
+EXPORT_SYMBOL(ocelot_phylink_mac_link_down);
 
-void ocelot_port_enable(struct ocelot *ocelot, int port,
-			struct phy_device *phy)
+void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
+				unsigned int link_an_mode,
+				phy_interface_t interface,
+				struct phy_device *phy)
 {
 	/* Enable receiving frames on the port, and activate auto-learning of
 	 * MAC addresses.
@@ -496,62 +546,22 @@ void ocelot_port_enable(struct ocelot *ocelot, int port,
 			 ANA_PORT_PORT_CFG_PORTID_VAL(port),
 			 ANA_PORT_PORT_CFG, port);
 }
-EXPORT_SYMBOL(ocelot_port_enable);
+EXPORT_SYMBOL(ocelot_phylink_mac_link_up);
 
 static int ocelot_port_open(struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-	int err;
-
-	if (priv->serdes) {
-		err = phy_set_mode_ext(priv->serdes, PHY_MODE_ETHERNET,
-				       priv->phy_mode);
-		if (err) {
-			netdev_err(dev, "Could not set mode of SerDes\n");
-			return err;
-		}
-	}
 
-	err = phy_connect_direct(dev, priv->phy, &ocelot_port_adjust_link,
-				 priv->phy_mode);
-	if (err) {
-		netdev_err(dev, "Could not attach to PHY\n");
-		return err;
-	}
-
-	dev->phydev = priv->phy;
-
-	phy_attached_info(priv->phy);
-	phy_start(priv->phy);
-
-	ocelot_port_enable(ocelot, port, priv->phy);
+	phylink_start(priv->phylink);
 
 	return 0;
 }
 
-void ocelot_port_disable(struct ocelot *ocelot, int port)
-{
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
-	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
-	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
-		       QSYS_SWITCH_PORT_MODE, port);
-}
-EXPORT_SYMBOL(ocelot_port_disable);
-
 static int ocelot_port_stop(struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	phy_disconnect(priv->phy);
-
-	dev->phydev = NULL;
 
-	ocelot_port_disable(ocelot, port);
+	phylink_stop(priv->phylink);
 
 	return 0;
 }
@@ -2183,8 +2193,7 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 EXPORT_SYMBOL(ocelot_init_port);
 
 int ocelot_probe_port(struct ocelot *ocelot, u8 port,
-		      void __iomem *regs,
-		      struct phy_device *phy)
+		      void __iomem *regs)
 {
 	struct ocelot_port_private *priv;
 	struct ocelot_port *ocelot_port;
@@ -2197,7 +2206,6 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 	SET_NETDEV_DEV(dev, ocelot->dev);
 	priv = netdev_priv(dev);
 	priv->dev = dev;
-	priv->phy = phy;
 	priv->chip_port = port;
 	ocelot_port = &priv->port;
 	ocelot_port->ocelot = ocelot;
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 32fef4f495aa..14d760f7a1b7 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -12,8 +12,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/net_tstamp.h>
-#include <linux/phy.h>
-#include <linux/phy/phy.h>
+#include <linux/phylink.h>
 #include <linux/platform_device.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/regmap.h>
@@ -63,14 +62,12 @@ struct ocelot_multicast {
 struct ocelot_port_private {
 	struct ocelot_port port;
 	struct net_device *dev;
-	struct phy_device *phy;
+	struct phylink *phylink;
+	struct phylink_config phylink_config;
 	u8 chip_port;
 
 	u8 vlan_aware;
 
-	phy_interface_t phy_mode;
-	struct phy *serdes;
-
 	struct ocelot_port_tc tc;
 };
 
@@ -87,9 +84,7 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 #define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
 
 int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops);
-int ocelot_probe_port(struct ocelot *ocelot, u8 port,
-		      void __iomem *regs,
-		      struct phy_device *phy);
+int ocelot_probe_port(struct ocelot *ocelot, u8 port, void __iomem *regs);
 
 void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
 			 enum ocelot_tag_prefix injection,
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 5541ec26f953..aecaf4ef6ef4 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -13,6 +13,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/skbuff.h>
 #include <net/switchdev.h>
+#include <linux/phy/phy.h>
 
 #include "ocelot.h"
 
@@ -305,6 +306,88 @@ static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 };
 
+static void ocelot_port_phylink_validate(struct phylink_config *config,
+					 unsigned long *supported,
+					 struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_phylink_validate(ocelot, port, supported, state);
+}
+
+static int ocelot_port_phylink_mac_link_state(struct phylink_config *config,
+					      struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_phylink_mac_link_state(ocelot, port, state);
+}
+
+static void ocelot_port_phylink_mac_an_restart(struct phylink_config *config)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_phylink_mac_an_restart(ocelot, port);
+}
+
+static void
+ocelot_port_phylink_mac_config(struct phylink_config *config,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_phylink_mac_config(ocelot, port, link_an_mode, state);
+}
+
+static void ocelot_port_phylink_mac_link_down(struct phylink_config *config,
+					      unsigned int link_an_mode,
+					      phy_interface_t interface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_phylink_mac_link_down(ocelot, port, link_an_mode,
+					    interface);
+}
+
+static void ocelot_port_phylink_mac_link_up(struct phylink_config *config,
+					    unsigned int link_an_mode,
+					    phy_interface_t interface,
+					    struct phy_device *phy)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_phylink_mac_link_up(ocelot, port, link_an_mode,
+					  interface, phy);
+}
+
+static const struct phylink_mac_ops ocelot_phylink_ops = {
+	.validate		= ocelot_port_phylink_validate,
+	.mac_link_state		= ocelot_port_phylink_mac_link_state,
+	.mac_an_restart		= ocelot_port_phylink_mac_an_restart,
+	.mac_config		= ocelot_port_phylink_mac_config,
+	.mac_link_down		= ocelot_port_phylink_mac_link_down,
+	.mac_link_up		= ocelot_port_phylink_mac_link_up,
+};
+
 static int mscc_ocelot_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -412,9 +495,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	for_each_available_child_of_node(ports, portnp) {
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
-		struct device_node *phy_node;
 		phy_interface_t phy_mode;
-		struct phy_device *phy;
 		struct resource *res;
 		struct phy *serdes;
 		void __iomem *regs;
@@ -432,16 +513,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		if (IS_ERR(regs))
 			continue;
 
-		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
-		if (!phy_node)
-			continue;
-
-		phy = of_phy_find_device(phy_node);
-		of_node_put(phy_node);
-		if (!phy)
-			continue;
-
-		err = ocelot_probe_port(ocelot, port, regs, phy);
+		err = ocelot_probe_port(ocelot, port, regs);
 		if (err) {
 			of_node_put(portnp);
 			goto out_put_ports;
@@ -453,9 +525,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 		of_get_phy_mode(portnp, &phy_mode);
 
-		priv->phy_mode = phy_mode;
-
-		switch (priv->phy_mode) {
+		switch (phy_mode) {
 		case PHY_INTERFACE_MODE_NA:
 			continue;
 		case PHY_INTERFACE_MODE_SGMII:
@@ -492,7 +562,41 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 			goto out_put_ports;
 		}
 
-		priv->serdes = serdes;
+		if (serdes) {
+			err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
+					       phy_mode);
+			if (err) {
+				dev_err(ocelot->dev,
+					"Could not set mode of SerDes\n");
+				of_node_put(portnp);
+				goto out_put_ports;
+			}
+		}
+
+		priv->phylink_config.dev = &priv->dev->dev;
+		priv->phylink_config.type = PHYLINK_NETDEV;
+
+		priv->phylink = phylink_create(&priv->phylink_config,
+					       of_fwnode_handle(portnp),
+					       phy_mode, &ocelot_phylink_ops);
+		if (IS_ERR(priv->phylink)) {
+			dev_err(ocelot->dev,
+				"Could not create a phylink instance (%ld)\n",
+				PTR_ERR(priv->phylink));
+			err = PTR_ERR(priv->phylink);
+			priv->phylink = NULL;
+			of_node_put(portnp);
+			goto out_put_ports;
+		}
+
+		err = phylink_of_phy_connect(priv->phylink, portnp, 0);
+		if (err) {
+			dev_err(ocelot->dev, "Could not connect to PHY: %d\n",
+				err);
+			phylink_destroy(priv->phylink);
+			of_node_put(portnp);
+			goto out_put_ports;
+		}
 	}
 
 	register_netdevice_notifier(&ocelot_netdevice_nb);
@@ -509,12 +613,27 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 static int mscc_ocelot_remove(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
+	int port;
 
 	ocelot_deinit(ocelot);
 	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 	unregister_switchdev_notifier(&ocelot_switchdev_nb);
 	unregister_netdevice_notifier(&ocelot_netdevice_nb);
 
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port_private *priv;
+
+		priv = container_of(ocelot->ports[port],
+				    struct ocelot_port_private,
+				    port);
+
+		if (priv->phylink) {
+			rtnl_lock();
+			phylink_destroy(priv->phylink);
+			rtnl_unlock();
+		}
+	}
+
 	return 0;
 }
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index a836afe8f68e..52c7b53e842f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -506,17 +506,12 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 
 /* DSA callbacks */
-void ocelot_port_enable(struct ocelot *ocelot, int port,
-			struct phy_device *phy);
-void ocelot_port_disable(struct ocelot *ocelot, int port);
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
 int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset);
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info);
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
-void ocelot_adjust_link(struct ocelot *ocelot, int port,
-			struct phy_device *phydev);
 void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 				bool vlan_aware);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
@@ -535,5 +530,21 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
 int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts);
+void ocelot_phylink_validate(struct ocelot *ocelot, int port,
+			     unsigned long *supported,
+			     struct phylink_link_state *state);
+int ocelot_phylink_mac_link_state(struct ocelot *ocelot, int port,
+				  struct phylink_link_state *state);
+void ocelot_phylink_mac_an_restart(struct ocelot *ocelot, int port);
+void ocelot_phylink_mac_config(struct ocelot *ocelot, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state);
+void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
+				  unsigned int link_an_mode,
+				  phy_interface_t interface);
+void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
+				unsigned int link_an_mode,
+				phy_interface_t interface,
+				struct phy_device *phy);
 
 #endif
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4F21FF146
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgFRMJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:09:23 -0400
Received: from inva020.nxp.com ([92.121.34.13]:34974 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727793AbgFRMJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 08:09:13 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 31CC21A0F43;
        Thu, 18 Jun 2020 14:09:08 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 209951A0F3B;
        Thu, 18 Jun 2020 14:09:08 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A5D3D2048B;
        Thu, 18 Jun 2020 14:09:07 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/5] net: dsa: felix: use the Lynx PCS helpers
Date:   Thu, 18 Jun 2020 15:08:37 +0300
Message-Id: <20200618120837.27089-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200618120837.27089-1-ioana.ciornei@nxp.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the helper functions introduced by the newly added
Lynx PCS MDIO module.

Instead of representing the PCS as a phy_device, a mdio_device structure
will be passed to the Lynx module which is now actually implementing all
the PCS configuration and status reporting.

All code previously used for PCS momnitoring and runtime configuration
is removed and replaced will calls to the Lynx PCS operations.

Tested on the following SERDES protocols of LS1028A: 0x7777
(2500Base-X), 0x85bb (QSGMII), 0x9999 (SGMII) and 0x13bb (USXGMII).

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig         |   1 +
 drivers/net/dsa/ocelot/felix.c         |   5 +
 drivers/net/dsa/ocelot/felix.h         |   7 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 385 +++----------------------
 include/linux/fsl/enetc_mdio.h         |  21 --
 5 files changed, 52 insertions(+), 367 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index a5b7cca03d09..d6bdb511aac5 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -7,6 +7,7 @@ config NET_DSA_MSCC_FELIX
 	select MSCC_OCELOT_SWITCH
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
+	select MDIO_LYNX_PCS
 	help
 	  This driver supports the VSC9959 network switch, which is a member of
 	  the Vitesse / Microsemi / Microchip Ocelot family of switching cores.
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 66648986e6e3..7995695fae0a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -277,6 +277,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct felix *felix = ocelot_to_felix(ocelot);
 
 	/* Enable MAC module */
 	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
@@ -295,6 +296,10 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
 			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
 			 QSYS_SWITCH_PORT_MODE, port);
+
+	if (felix->info->pcs_link_up)
+		felix->info->pcs_link_up(ocelot, port, link_an_mode, interface,
+					 speed, duplex);
 }
 
 static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index a891736ca006..81d93bfee23b 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -4,6 +4,8 @@
 #ifndef _MSCC_FELIX_H
 #define _MSCC_FELIX_H
 
+#include <linux/mdio-lynx-pcs.h>
+
 #define ocelot_to_felix(o)		container_of((o), struct felix, ocelot)
 #define FELIX_NUM_TC			8
 
@@ -34,6 +36,9 @@ struct felix_info {
 	void	(*pcs_an_restart)(struct ocelot *ocelot, int port);
 	void	(*pcs_link_state)(struct ocelot *ocelot, int port,
 				  struct phylink_link_state *state);
+	void	(*pcs_link_up)(struct ocelot *ocelot, int port,
+			       unsigned int mode, phy_interface_t interface,
+			       int speed, int duplex);
 	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
 					phy_interface_t phy_mode);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
@@ -55,7 +60,7 @@ struct felix {
 	struct felix_info		*info;
 	struct ocelot			ocelot;
 	struct mii_bus			*imdio;
-	struct phy_device		**pcs;
+	struct mdio_lynx_pcs		**pcs;
 };
 
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1dd9e348152d..6f18fd4ea44a 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -17,19 +17,6 @@
 #define VSC9959_VCAP_IS2_ENTRY_WIDTH	376
 #define VSC9959_VCAP_PORT_CNT		6
 
-/* TODO: should find a better place for these */
-#define USXGMII_BMCR_RESET		BIT(15)
-#define USXGMII_BMCR_AN_EN		BIT(12)
-#define USXGMII_BMCR_RST_AN		BIT(9)
-#define USXGMII_BMSR_LNKS(status)	(((status) & GENMASK(2, 2)) >> 2)
-#define USXGMII_BMSR_AN_CMPL(status)	(((status) & GENMASK(5, 5)) >> 5)
-#define USXGMII_ADVERTISE_LNKS(x)	(((x) << 15) & BIT(15))
-#define USXGMII_ADVERTISE_FDX		BIT(12)
-#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
-#define USXGMII_LPA_LNKS(lpa)		((lpa) >> 15)
-#define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >> 12)
-#define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
-
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
 
 enum usxgmii_speed {
@@ -728,181 +715,15 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-static void vsc9959_pcs_an_restart_sgmii(struct phy_device *pcs)
-{
-	phy_set_bits(pcs, MII_BMCR, BMCR_ANRESTART);
-}
-
-static void vsc9959_pcs_an_restart_usxgmii(struct phy_device *pcs)
-{
-	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_BMCR,
-		      USXGMII_BMCR_RESET |
-		      USXGMII_BMCR_AN_EN |
-		      USXGMII_BMCR_RST_AN);
-}
-
 static void vsc9959_pcs_an_restart(struct ocelot *ocelot, int port)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
-	struct phy_device *pcs = felix->pcs[port];
+	struct mdio_lynx_pcs *pcs = felix->pcs[port];
 
 	if (!pcs)
 		return;
 
-	switch (pcs->interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		vsc9959_pcs_an_restart_sgmii(pcs);
-		break;
-	case PHY_INTERFACE_MODE_USXGMII:
-		vsc9959_pcs_an_restart_usxgmii(pcs);
-		break;
-	default:
-		dev_err(ocelot->dev, "Invalid PCS interface type %s\n",
-			phy_modes(pcs->interface));
-		break;
-	}
-}
-
-/* We enable SGMII AN only when the PHY has managed = "in-band-status" in the
- * device tree. If we are in MLO_AN_PHY mode, we program directly state->speed
- * into the PCS, which is retrieved out-of-band over MDIO. This also has the
- * benefit of working with SGMII fixed-links, like downstream switches, where
- * both link partners attempt to operate as AN slaves and therefore AN never
- * completes.  But it also has the disadvantage that some PHY chips don't pass
- * traffic if SGMII AN is enabled but not completed (acknowledged by us), so
- * setting MLO_AN_INBAND is actually required for those.
- */
-static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
-				   unsigned int link_an_mode,
-				   const struct phylink_link_state *state)
-{
-	if (link_an_mode == MLO_AN_INBAND) {
-		int bmsr, bmcr;
-
-		/* Some PHYs like VSC8234 don't like it when AN restarts on
-		 * their system  side and they restart line side AN too, going
-		 * into an endless link up/down loop.  Don't restart PCS AN if
-		 * link is up already.
-		 * We do check that AN is enabled just in case this is the 1st
-		 * call, PCS detects a carrier but AN is disabled from power on
-		 * or by boot loader.
-		 */
-		bmcr = phy_read(pcs, MII_BMCR);
-		if (bmcr < 0)
-			return;
-
-		bmsr = phy_read(pcs, MII_BMSR);
-		if (bmsr < 0)
-			return;
-
-		if ((bmcr & BMCR_ANENABLE) && (bmsr & BMSR_LSTATUS))
-			return;
-
-		/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
-		 * for the MAC PCS in order to acknowledge the AN.
-		 */
-		phy_write(pcs, MII_ADVERTISE, ADVERTISE_SGMII |
-					      ADVERTISE_LPACK);
-
-		phy_write(pcs, ENETC_PCS_IF_MODE,
-			  ENETC_PCS_IF_MODE_SGMII_EN |
-			  ENETC_PCS_IF_MODE_USE_SGMII_AN);
-
-		/* Adjust link timer for SGMII */
-		phy_write(pcs, ENETC_PCS_LINK_TIMER1,
-			  ENETC_PCS_LINK_TIMER1_VAL);
-		phy_write(pcs, ENETC_PCS_LINK_TIMER2,
-			  ENETC_PCS_LINK_TIMER2_VAL);
-
-		phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
-	} else {
-		int speed;
-
-		if (state->duplex == DUPLEX_HALF) {
-			phydev_err(pcs, "Half duplex not supported\n");
-			return;
-		}
-		switch (state->speed) {
-		case SPEED_1000:
-			speed = ENETC_PCS_SPEED_1000;
-			break;
-		case SPEED_100:
-			speed = ENETC_PCS_SPEED_100;
-			break;
-		case SPEED_10:
-			speed = ENETC_PCS_SPEED_10;
-			break;
-		case SPEED_UNKNOWN:
-			/* Silently don't do anything */
-			return;
-		default:
-			phydev_err(pcs, "Invalid PCS speed %d\n", state->speed);
-			return;
-		}
-
-		phy_write(pcs, ENETC_PCS_IF_MODE,
-			  ENETC_PCS_IF_MODE_SGMII_EN |
-			  ENETC_PCS_IF_MODE_SGMII_SPEED(speed));
-
-		/* Yes, not a mistake: speed is given by IF_MODE. */
-		phy_write(pcs, MII_BMCR, BMCR_RESET |
-					 BMCR_SPEED1000 |
-					 BMCR_FULLDPLX);
-	}
-}
-
-/* 2500Base-X is SerDes protocol 7 on Felix and 6 on ENETC. It is a SerDes lane
- * clocked at 3.125 GHz which encodes symbols with 8b/10b and does not have
- * auto-negotiation of any link parameters. Electrically it is compatible with
- * a single lane of XAUI.
- * The hardware reference manual wants to call this mode SGMII, but it isn't
- * really, since the fundamental features of SGMII:
- * - Downgrading the link speed by duplicating symbols
- * - Auto-negotiation
- * are not there.
- * The speed is configured at 1000 in the IF_MODE and BMCR MDIO registers
- * because the clock frequency is actually given by a PLL configured in the
- * Reset Configuration Word (RCW).
- * Since there is no difference between fixed speed SGMII w/o AN and 802.3z w/o
- * AN, we call this PHY interface type 2500Base-X. In case a PHY negotiates a
- * lower link speed on line side, the system-side interface remains fixed at
- * 2500 Mbps and we do rate adaptation through pause frames.
- */
-static void vsc9959_pcs_init_2500basex(struct phy_device *pcs,
-				       unsigned int link_an_mode,
-				       const struct phylink_link_state *state)
-{
-	if (link_an_mode == MLO_AN_INBAND) {
-		phydev_err(pcs, "AN not supported on 3.125GHz SerDes lane\n");
-		return;
-	}
-
-	phy_write(pcs, ENETC_PCS_IF_MODE,
-		  ENETC_PCS_IF_MODE_SGMII_EN |
-		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
-
-	phy_write(pcs, MII_BMCR, BMCR_SPEED1000 |
-				 BMCR_FULLDPLX |
-				 BMCR_RESET);
-}
-
-static void vsc9959_pcs_init_usxgmii(struct phy_device *pcs,
-				     unsigned int link_an_mode,
-				     const struct phylink_link_state *state)
-{
-	if (link_an_mode != MLO_AN_INBAND) {
-		phydev_err(pcs, "USXGMII only supports in-band AN for now\n");
-		return;
-	}
-
-	/* Configure device ability for the USXGMII Replicator */
-	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_ADVERTISE,
-		      USXGMII_ADVERTISE_SPEED(USXGMII_SPEED_2500) |
-		      USXGMII_ADVERTISE_LNKS(1) |
-		      ADVERTISE_SGMII |
-		      ADVERTISE_LPACK |
-		      USXGMII_ADVERTISE_FDX);
+	pcs->an_restart(pcs, ocelot->ports[port]->phy_mode);
 }
 
 static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
@@ -910,178 +731,37 @@ static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
 			     const struct phylink_link_state *state)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
-	struct phy_device *pcs = felix->pcs[port];
+	struct mdio_lynx_pcs *pcs = felix->pcs[port];
 
 	if (!pcs)
 		return;
 
-	/* The PCS does not implement the BMSR register fully, so capability
-	 * detection via genphy_read_abilities does not work. Since we can get
-	 * the PHY config word from the LPA register though, there is still
-	 * value in using the generic phy_resolve_aneg_linkmode function. So
-	 * populate the supported and advertising link modes manually here.
-	 */
-	linkmode_set_bit_array(phy_basic_ports_array,
-			       ARRAY_SIZE(phy_basic_ports_array),
-			       pcs->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, pcs->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, pcs->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, pcs->supported);
-	if (pcs->interface == PHY_INTERFACE_MODE_2500BASEX ||
-	    pcs->interface == PHY_INTERFACE_MODE_USXGMII)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
-				 pcs->supported);
-	if (pcs->interface != PHY_INTERFACE_MODE_2500BASEX)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-				 pcs->supported);
-	phy_advertise_supported(pcs);
-
-	switch (pcs->interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		vsc9959_pcs_init_sgmii(pcs, link_an_mode, state);
-		break;
-	case PHY_INTERFACE_MODE_2500BASEX:
-		vsc9959_pcs_init_2500basex(pcs, link_an_mode, state);
-		break;
-	case PHY_INTERFACE_MODE_USXGMII:
-		vsc9959_pcs_init_usxgmii(pcs, link_an_mode, state);
-		break;
-	default:
-		dev_err(ocelot->dev, "Unsupported link mode %s\n",
-			phy_modes(pcs->interface));
-	}
-}
-
-static void vsc9959_pcs_link_state_resolve(struct phy_device *pcs,
-					   struct phylink_link_state *state)
-{
-	state->an_complete = pcs->autoneg_complete;
-	state->an_enabled = pcs->autoneg;
-	state->link = pcs->link;
-	state->duplex = pcs->duplex;
-	state->speed = pcs->speed;
-	/* SGMII AN does not negotiate flow control, but that's ok,
-	 * since phylink already knows that, and does:
-	 *	link_state.pause |= pl->phy_state.pause;
-	 */
-	state->pause = MLO_PAUSE_NONE;
-
-	phydev_dbg(pcs,
-		   "mode=%s/%s/%s adv=%*pb lpa=%*pb link=%u an_enabled=%u an_complete=%u\n",
-		   phy_modes(pcs->interface),
-		   phy_speed_to_str(pcs->speed),
-		   phy_duplex_to_str(pcs->duplex),
-		   __ETHTOOL_LINK_MODE_MASK_NBITS, pcs->advertising,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS, pcs->lp_advertising,
-		   pcs->link, pcs->autoneg, pcs->autoneg_complete);
+	pcs->config(pcs, link_an_mode, state->interface, state->advertising);
 }
 
-static void vsc9959_pcs_link_state_sgmii(struct phy_device *pcs,
-					 struct phylink_link_state *state)
-{
-	int err;
-
-	err = genphy_update_link(pcs);
-	if (err < 0)
-		return;
-
-	if (pcs->autoneg_complete) {
-		u16 lpa = phy_read(pcs, MII_LPA);
-
-		mii_lpa_to_linkmode_lpa_sgmii(pcs->lp_advertising, lpa);
-
-		phy_resolve_aneg_linkmode(pcs);
-	}
-}
-
-static void vsc9959_pcs_link_state_2500basex(struct phy_device *pcs,
-					     struct phylink_link_state *state)
+static void vsc9959_pcs_link_state(struct ocelot *ocelot, int port,
+				   struct phylink_link_state *state)
 {
-	int err;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct mdio_lynx_pcs *pcs = felix->pcs[port];
 
-	err = genphy_update_link(pcs);
-	if (err < 0)
+	if (!pcs)
 		return;
 
-	pcs->speed = SPEED_2500;
-	pcs->asym_pause = true;
-	pcs->pause = true;
+	pcs->get_state(pcs, ocelot->ports[port]->phy_mode, state);
 }
 
-static void vsc9959_pcs_link_state_usxgmii(struct phy_device *pcs,
-					   struct phylink_link_state *state)
-{
-	int status, lpa;
-
-	status = phy_read_mmd(pcs, MDIO_MMD_VEND2, MII_BMSR);
-	if (status < 0)
-		return;
-
-	pcs->autoneg = true;
-	pcs->autoneg_complete = USXGMII_BMSR_AN_CMPL(status);
-	pcs->link = USXGMII_BMSR_LNKS(status);
-
-	if (!pcs->link || !pcs->autoneg_complete)
-		return;
-
-	lpa = phy_read_mmd(pcs, MDIO_MMD_VEND2, MII_LPA);
-	if (lpa < 0)
-		return;
-
-	switch (USXGMII_LPA_SPEED(lpa)) {
-	case USXGMII_SPEED_10:
-		pcs->speed = SPEED_10;
-		break;
-	case USXGMII_SPEED_100:
-		pcs->speed = SPEED_100;
-		break;
-	case USXGMII_SPEED_1000:
-		pcs->speed = SPEED_1000;
-		break;
-	case USXGMII_SPEED_2500:
-		pcs->speed = SPEED_2500;
-		break;
-	default:
-		break;
-	}
-
-	if (USXGMII_LPA_DUPLEX(lpa))
-		pcs->duplex = DUPLEX_FULL;
-	else
-		pcs->duplex = DUPLEX_HALF;
-}
-
-static void vsc9959_pcs_link_state(struct ocelot *ocelot, int port,
-				   struct phylink_link_state *state)
+static void vsc9959_pcs_link_up(struct ocelot *ocelot, int port,
+				unsigned int mode, phy_interface_t interface,
+				int speed, int duplex)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
-	struct phy_device *pcs = felix->pcs[port];
+	struct mdio_lynx_pcs *pcs = felix->pcs[port];
 
 	if (!pcs)
 		return;
 
-	pcs->speed = SPEED_UNKNOWN;
-	pcs->duplex = DUPLEX_UNKNOWN;
-	pcs->pause = 0;
-	pcs->asym_pause = 0;
-
-	switch (pcs->interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		vsc9959_pcs_link_state_sgmii(pcs, state);
-		break;
-	case PHY_INTERFACE_MODE_2500BASEX:
-		vsc9959_pcs_link_state_2500basex(pcs, state);
-		break;
-	case PHY_INTERFACE_MODE_USXGMII:
-		vsc9959_pcs_link_state_usxgmii(pcs, state);
-		break;
-	default:
-		return;
-	}
-
-	vsc9959_pcs_link_state_resolve(pcs, state);
+	pcs->link_up(pcs, mode, interface, speed, duplex);
 }
 
 static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
@@ -1130,6 +810,14 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		return -ENOMEM;
 	}
 
+	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
+				  sizeof(struct mdio_lynx_pcs *),
+				  GFP_KERNEL);
+	if (!felix->pcs) {
+		dev_err(dev, "failed to allocate array for Lynx PCS devices\n");
+		return -ENOMEM;
+	}
+
 	imdio_base = pci_resource_start(felix->pdev,
 					felix->info->imdio_pci_bar);
 
@@ -1177,18 +865,23 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
-		struct phy_device *pcs;
-		bool is_c45 = false;
+		struct mdio_device *pcs_mdio;
 
-		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_USXGMII)
-			is_c45 = true;
+		if (dsa_is_unused_port(felix->ds, port))
+			continue;
+
+		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
+			continue;
 
-		pcs = get_phy_device(felix->imdio, port, is_c45);
-		if (IS_ERR(pcs))
+		pcs_mdio = mdio_device_create(felix->imdio, port);
+		if (IS_ERR(pcs_mdio))
 			continue;
 
-		pcs->interface = ocelot_port->phy_mode;
-		felix->pcs[port] = pcs;
+		felix->pcs[port] = mdio_lynx_pcs_create(pcs_mdio);
+		if (!felix->pcs[port]) {
+			mdio_device_free(pcs_mdio);
+			continue;
+		}
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
 	}
@@ -1202,12 +895,13 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct phy_device *pcs = felix->pcs[port];
+		struct mdio_lynx_pcs *pcs = felix->pcs[port];
 
 		if (!pcs)
 			continue;
 
-		put_device(&pcs->mdio.dev);
+		mdio_device_free(pcs->dev);
+		mdio_lynx_pcs_free(pcs);
 	}
 	mdiobus_unregister(felix->imdio);
 }
@@ -1415,6 +1109,7 @@ struct felix_info felix_info_vsc9959 = {
 	.pcs_init		= vsc9959_pcs_init,
 	.pcs_an_restart		= vsc9959_pcs_an_restart,
 	.pcs_link_state		= vsc9959_pcs_link_state,
+	.pcs_link_up		= vsc9959_pcs_link_up,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc          = vsc9959_port_setup_tc,
 	.port_sched_speed_set   = vsc9959_sched_speed_set,
diff --git a/include/linux/fsl/enetc_mdio.h b/include/linux/fsl/enetc_mdio.h
index 4875dd38af7e..483679f53a91 100644
--- a/include/linux/fsl/enetc_mdio.h
+++ b/include/linux/fsl/enetc_mdio.h
@@ -6,27 +6,6 @@
 
 #include <linux/phy.h>
 
-/* PCS registers */
-#define ENETC_PCS_LINK_TIMER1			0x12
-#define ENETC_PCS_LINK_TIMER1_VAL		0x06a0
-#define ENETC_PCS_LINK_TIMER2			0x13
-#define ENETC_PCS_LINK_TIMER2_VAL		0x0003
-#define ENETC_PCS_IF_MODE			0x14
-#define ENETC_PCS_IF_MODE_SGMII_EN		BIT(0)
-#define ENETC_PCS_IF_MODE_USE_SGMII_AN		BIT(1)
-#define ENETC_PCS_IF_MODE_SGMII_SPEED(x)	(((x) << 2) & GENMASK(3, 2))
-
-/* Not a mistake, the SerDes PLL needs to be set at 3.125 GHz by Reset
- * Configuration Word (RCW, outside Linux control) for 2.5G SGMII mode. The PCS
- * still thinks it's at gigabit.
- */
-enum enetc_pcs_speed {
-	ENETC_PCS_SPEED_10	= 0,
-	ENETC_PCS_SPEED_100	= 1,
-	ENETC_PCS_SPEED_1000	= 2,
-	ENETC_PCS_SPEED_2500	= 2,
-};
-
 struct enetc_hw;
 
 struct enetc_mdio_priv {
-- 
2.25.1


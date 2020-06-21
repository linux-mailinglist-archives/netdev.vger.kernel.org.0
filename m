Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3969202D92
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 00:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730888AbgFUW4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 18:56:12 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36666 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730823AbgFUW4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 18:56:07 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1CEFA1A08BE;
        Mon, 22 Jun 2020 00:56:03 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0E5981A08B9;
        Mon, 22 Jun 2020 00:56:03 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8B6A820414;
        Mon, 22 Jun 2020 00:56:02 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 9/9] net: dsa: felix: use the Lynx PCS helpers
Date:   Mon, 22 Jun 2020 01:54:51 +0300
Message-Id: <20200621225451.12435-10-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200621225451.12435-1-ioana.ciornei@nxp.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
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
Changes in v2:
 * make the necessary adjustments for calling directly the exported Lynx
 functions
 * fixed a memory leakage in the Felix driver (the pcs structure was
 allocated twice)

Changes in v3:
 * use the DSA PCS operations

 drivers/net/dsa/ocelot/Kconfig         |   1 +
 drivers/net/dsa/ocelot/felix.c         |  46 ++-
 drivers/net/dsa/ocelot/felix.h         |  16 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 385 +++----------------------
 include/linux/fsl/enetc_mdio.h         |  21 --
 5 files changed, 76 insertions(+), 393 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 3d3c2a6fb0c0..4dd4d2742cda 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -9,6 +9,7 @@ config NET_DSA_MSCC_FELIX
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
+	select PCS_LYNX
 	help
 	  This driver supports the VSC9959 network switch, which is a member of
 	  the Vitesse / Microsemi / Microchip Ocelot family of switching cores.
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f6a7e0839bb5..275d2d5d9709 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -193,30 +193,32 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static int felix_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
-					   struct phylink_link_state *state)
+static void felix_phylink_pcs_get_state(struct dsa_switch *ds, int port,
+					struct phylink_link_state *state)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 
-	if (felix->info->pcs_link_state)
-		felix->info->pcs_link_state(ocelot, port, state);
-
-	return 0;
+	if (felix->info->pcs_get_state)
+		felix->info->pcs_get_state(ocelot, port, state);
 }
 
-static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
-				     unsigned int link_an_mode,
-				     const struct phylink_link_state *state)
+static int felix_phylink_pcs_config(struct dsa_switch *ds, int port,
+				    unsigned int link_an_mode,
+				    phy_interface_t interface,
+				    const unsigned long *advertising)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 
-	if (felix->info->pcs_init)
-		felix->info->pcs_init(ocelot, port, link_an_mode, state);
+	if (felix->info->pcs_config)
+		return felix->info->pcs_config(ocelot, port, link_an_mode,
+					       interface, advertising);
+
+	return 0;
 }
 
-static void felix_phylink_mac_an_restart(struct dsa_switch *ds, int port)
+static void felix_phylink_pcs_an_restart(struct dsa_switch *ds, int port)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
@@ -320,6 +322,19 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		felix->info->port_sched_speed_set(ocelot, port, speed);
 }
 
+static void felix_phylink_pcs_link_up(struct dsa_switch *ds, int port,
+				      unsigned int link_an_mode,
+				      phy_interface_t interface,
+				      int speed, int duplex)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->pcs_link_up)
+		felix->info->pcs_link_up(ocelot, port, link_an_mode, interface,
+					 speed, duplex);
+}
+
 static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
 {
 	int i;
@@ -783,10 +798,11 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.get_ethtool_stats	= felix_get_ethtool_stats,
 	.get_sset_count		= felix_get_sset_count,
 	.get_ts_info		= felix_get_ts_info,
+	.phylink_pcs_config	= felix_phylink_pcs_config,
+	.phylink_pcs_link_up	= felix_phylink_pcs_link_up,
+	.phylink_pcs_get_state	= felix_phylink_pcs_get_state,
+	.phylink_pcs_an_restart	= felix_phylink_pcs_an_restart,
 	.phylink_validate	= felix_phylink_validate,
-	.phylink_mac_link_state	= felix_phylink_mac_pcs_get_state,
-	.phylink_mac_config	= felix_phylink_mac_config,
-	.phylink_mac_an_restart	= felix_phylink_mac_an_restart,
 	.phylink_mac_link_down	= felix_phylink_mac_link_down,
 	.phylink_mac_link_up	= felix_phylink_mac_link_up,
 	.port_enable		= felix_port_enable,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index a891736ca006..e30266c32db5 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -28,12 +28,16 @@ struct felix_info {
 	int				imdio_pci_bar;
 	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
 	void	(*mdio_bus_free)(struct ocelot *ocelot);
-	void	(*pcs_init)(struct ocelot *ocelot, int port,
-			    unsigned int link_an_mode,
-			    const struct phylink_link_state *state);
+	int	(*pcs_config)(struct ocelot *ocelot, int port,
+			      unsigned int link_an_mode,
+			      phy_interface_t interface,
+			      const unsigned long *advertising);
 	void	(*pcs_an_restart)(struct ocelot *ocelot, int port);
-	void	(*pcs_link_state)(struct ocelot *ocelot, int port,
-				  struct phylink_link_state *state);
+	void	(*pcs_get_state)(struct ocelot *ocelot, int port,
+				 struct phylink_link_state *state);
+	void	(*pcs_link_up)(struct ocelot *ocelot, int port,
+			       unsigned int mode, phy_interface_t interface,
+			       int speed, int duplex);
 	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
 					phy_interface_t phy_mode);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
@@ -55,7 +59,7 @@ struct felix {
 	struct felix_info		*info;
 	struct ocelot			ocelot;
 	struct mii_bus			*imdio;
-	struct phy_device		**pcs;
+	struct mdio_device		**pcs;
 };
 
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2067776773f7..a1df55b26a79 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -8,6 +8,7 @@
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
+#include <linux/pcs-lynx.h>
 #include <net/pkt_sched.h>
 #include <linux/iopoll.h>
 #include <linux/pci.h>
@@ -17,19 +18,6 @@
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
@@ -728,360 +716,54 @@ static int vsc9959_reset(struct ocelot *ocelot)
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
+	struct mdio_device *pcs = felix->pcs[port];
 
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
+	lynx_pcs_an_restart(pcs, ocelot->ports[port]->phy_mode);
 }
 
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
-}
-
-static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
-			     unsigned int link_an_mode,
-			     const struct phylink_link_state *state)
+static int vsc9959_pcs_config(struct ocelot *ocelot, int port,
+			      unsigned int link_an_mode,
+			      phy_interface_t interface,
+			      const unsigned long *advertising)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
-	struct phy_device *pcs = felix->pcs[port];
+	struct mdio_device *pcs = felix->pcs[port];
 
 	if (!pcs)
-		return;
-
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
-}
-
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
-{
-	int err;
-
-	err = genphy_update_link(pcs);
-	if (err < 0)
-		return;
+		return 0;
 
-	pcs->speed = SPEED_2500;
-	pcs->asym_pause = true;
-	pcs->pause = true;
+	return lynx_pcs_config(pcs, link_an_mode, interface, advertising);
 }
 
-static void vsc9959_pcs_link_state_usxgmii(struct phy_device *pcs,
-					   struct phylink_link_state *state)
+static void vsc9959_pcs_get_state(struct ocelot *ocelot, int port,
+				  struct phylink_link_state *state)
 {
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
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct mdio_device *pcs = felix->pcs[port];
 
-	lpa = phy_read_mmd(pcs, MDIO_MMD_VEND2, MII_LPA);
-	if (lpa < 0)
+	if (!pcs)
 		return;
 
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
+	lynx_pcs_get_state(pcs, ocelot->ports[port]->phy_mode, state);
 }
 
-static void vsc9959_pcs_link_state(struct ocelot *ocelot, int port,
-				   struct phylink_link_state *state)
+static void vsc9959_pcs_link_up(struct ocelot *ocelot, int port,
+				unsigned int mode, phy_interface_t interface,
+				int speed, int duplex)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
-	struct phy_device *pcs = felix->pcs[port];
+	struct mdio_device *pcs = felix->pcs[port];
 
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
+	lynx_pcs_link_up(pcs, mode, interface, speed, duplex);
 }
 
 static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
@@ -1123,7 +805,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct phy_device *),
+				  sizeof(struct mdio_device *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1177,17 +859,17 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
-		struct phy_device *pcs;
-		bool is_c45 = false;
+		struct mdio_device *pcs;
 
-		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_USXGMII)
-			is_c45 = true;
+		if (dsa_is_unused_port(felix->ds, port))
+			continue;
 
-		pcs = get_phy_device(felix->imdio, port, is_c45);
-		if (IS_ERR(pcs))
+		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		pcs->interface = ocelot_port->phy_mode;
+		pcs = mdio_device_create(felix->imdio, port);
+		if (IS_ERR(pcs))
+			continue;
 		felix->pcs[port] = pcs;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
@@ -1202,12 +884,12 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct phy_device *pcs = felix->pcs[port];
+		struct mdio_device *pcs = felix->pcs[port];
 
 		if (!pcs)
 			continue;
 
-		put_device(&pcs->mdio.dev);
+		mdio_device_free(pcs);
 	}
 	mdiobus_unregister(felix->imdio);
 }
@@ -1412,9 +1094,10 @@ struct felix_info felix_info_vsc9959 = {
 	.imdio_pci_bar		= 0,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
-	.pcs_init		= vsc9959_pcs_init,
+	.pcs_config		= vsc9959_pcs_config,
 	.pcs_an_restart		= vsc9959_pcs_an_restart,
-	.pcs_link_state		= vsc9959_pcs_link_state,
+	.pcs_get_state		= vsc9959_pcs_get_state,
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


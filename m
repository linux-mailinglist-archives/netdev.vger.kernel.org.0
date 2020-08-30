Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CD8256CD7
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 10:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgH3Iey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 04:34:54 -0400
Received: from inva020.nxp.com ([92.121.34.13]:57204 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728653AbgH3Iej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 04:34:39 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2A2DC1A0511;
        Sun, 30 Aug 2020 10:34:37 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 19C881A050F;
        Sun, 30 Aug 2020 10:34:37 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A90B520306;
        Sun, 30 Aug 2020 10:34:36 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        andrew@lunn.ch, linux@armlinux.org.uk, f.fainelli@gmail.com,
        olteanv@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 5/5] net: dsa: ocelot: use the Lynx PCS helpers in Felix and Seville
Date:   Sun, 30 Aug 2020 11:34:02 +0300
Message-Id: <20200830083402.11047-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200830083402.11047-1-ioana.ciornei@nxp.com>
References: <20200830083402.11047-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the helper functions introduced by the newly added
Lynx PCS MDIO module in the Felix VSC9959 and Seville VSC9953.

Instead of representing the PCS as a phy_device, a mdio_device structure
will be passed to the Lynx module which is now actually implementing all
the PCS configuration and status reporting.

All code previously used for PCS monitoring and runtime configuration
is removed and replaced will calls to the Lynx PCS operations.

Tested on the following SERDES protocols of LS1028A: 0x7777
(2500Base-X), 0x85bb (QSGMII), 0x9999 (SGMII) and 0x13bb (USXGMII).

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v5:
 - none

 drivers/net/dsa/ocelot/Kconfig           |   1 +
 drivers/net/dsa/ocelot/felix.c           |  28 +-
 drivers/net/dsa/ocelot/felix.h           |  20 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 374 ++---------------------
 drivers/net/dsa/ocelot/seville_vsc9953.c |  21 +-
 5 files changed, 40 insertions(+), 404 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 2d23ccef7d0e..e19718d4a7d4 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -8,6 +8,7 @@ config NET_DSA_MSCC_FELIX
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
+	select PCS_LYNX
 	help
 	  This driver supports network switches from the Vitesse /
 	  Microsemi / Microchip Ocelot family of switching cores that are
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c69d9592a2b7..ccc0427faf02 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -19,6 +19,7 @@
 #include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <linux/pcs-lynx.h>
 #include <net/pkt_sched.h>
 #include <net/dsa.h>
 #include "felix.h"
@@ -196,27 +197,16 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
 		felix->info->phylink_validate(ocelot, port, supported, state);
 }
 
-static int felix_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
-					   struct phylink_link_state *state)
-{
-	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
-
-	if (felix->info->pcs_link_state)
-		felix->info->pcs_link_state(ocelot, port, state);
-
-	return 0;
-}
-
 static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 				     unsigned int link_an_mode,
 				     const struct phylink_link_state *state)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->info->pcs_config)
-		felix->info->pcs_config(ocelot, port, link_an_mode, state);
+	if (felix->pcs[port])
+		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
 static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
@@ -306,10 +296,6 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	ocelot_fields_write(ocelot, port,
 			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
 
-	if (felix->info->pcs_link_up)
-		felix->info->pcs_link_up(ocelot, port, link_an_mode, interface,
-					 speed, duplex);
-
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
 }
@@ -626,11 +612,6 @@ static int felix_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
-	/* It looks like the MAC/PCS interrupt register - PM0_IEVENT (0x8040)
-	 * isn't instantiated for the Felix PF.
-	 * In-band AN may take a few ms to complete, so we need to poll.
-	 */
-	ds->pcs_poll = true;
 
 	return 0;
 }
@@ -786,7 +767,6 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.get_sset_count		= felix_get_sset_count,
 	.get_ts_info		= felix_get_ts_info,
 	.phylink_validate	= felix_phylink_validate,
-	.phylink_mac_link_state	= felix_phylink_mac_pcs_get_state,
 	.phylink_mac_config	= felix_phylink_mac_config,
 	.phylink_mac_link_down	= felix_phylink_mac_link_down,
 	.phylink_mac_link_up	= felix_phylink_mac_link_up,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 98f14621ac23..9bceb994b7db 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -28,15 +28,6 @@ struct felix_info {
 	int				imdio_pci_bar;
 	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
 	void	(*mdio_bus_free)(struct ocelot *ocelot);
-	void	(*pcs_config)(struct ocelot *ocelot, int port,
-			      unsigned int link_an_mode,
-			      const struct phylink_link_state *state);
-	void	(*pcs_link_up)(struct ocelot *ocelot, int port,
-			       unsigned int link_an_mode,
-			       phy_interface_t interface,
-			       int speed, int duplex);
-	void	(*pcs_link_state)(struct ocelot *ocelot, int port,
-				  struct phylink_link_state *state);
 	void	(*phylink_validate)(struct ocelot *ocelot, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
@@ -59,20 +50,11 @@ struct felix {
 	const struct felix_info		*info;
 	struct ocelot			ocelot;
 	struct mii_bus			*imdio;
-	struct phy_device		**pcs;
+	struct lynx_pcs			**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
 };
 
-void vsc9959_pcs_link_state(struct ocelot *ocelot, int port,
-			    struct phylink_link_state *state);
-void vsc9959_pcs_config(struct ocelot *ocelot, int port,
-			unsigned int link_an_mode,
-			const struct phylink_link_state *state);
-void vsc9959_pcs_link_up(struct ocelot *ocelot, int port,
-			 unsigned int link_an_mode,
-			 phy_interface_t interface,
-			 int speed, int duplex);
 void vsc9959_mdio_bus_free(struct ocelot *ocelot);
 
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9b720c8ddfc3..126a53a811f7 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -9,6 +9,7 @@
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/packing.h>
+#include <linux/pcs-lynx.h>
 #include <net/pkt_sched.h>
 #include <linux/iopoll.h>
 #include <linux/mdio.h>
@@ -766,347 +767,6 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-/* We enable SGMII AN only when the PHY has managed = "in-band-status" in the
- * device tree. If we are in MLO_AN_PHY mode, we program directly state->speed
- * into the PCS, which is retrieved out-of-band over MDIO. This also has the
- * benefit of working with SGMII fixed-links, like downstream switches, where
- * both link partners attempt to operate as AN slaves and therefore AN never
- * completes.  But it also has the disadvantage that some PHY chips don't pass
- * traffic if SGMII AN is enabled but not completed (acknowledged by us), so
- * setting MLO_AN_INBAND is actually required for those.
- */
-static void vsc9959_pcs_config_sgmii(struct phy_device *pcs,
-				     unsigned int link_an_mode,
-				     const struct phylink_link_state *state)
-{
-	int bmsr, bmcr;
-
-	/* Some PHYs like VSC8234 don't like it when AN restarts on
-	 * their system  side and they restart line side AN too, going
-	 * into an endless link up/down loop.  Don't restart PCS AN if
-	 * link is up already.
-	 * We do check that AN is enabled just in case this is the 1st
-	 * call, PCS detects a carrier but AN is disabled from power on
-	 * or by boot loader.
-	 */
-	bmcr = phy_read(pcs, MII_BMCR);
-	if (bmcr < 0)
-		return;
-
-	bmsr = phy_read(pcs, MII_BMSR);
-	if (bmsr < 0)
-		return;
-
-	if ((bmcr & BMCR_ANENABLE) && (bmsr & BMSR_LSTATUS))
-		return;
-
-	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
-	 * for the MAC PCS in order to acknowledge the AN.
-	 */
-	phy_write(pcs, MII_ADVERTISE, ADVERTISE_SGMII |
-				      ADVERTISE_LPACK);
-
-	phy_write(pcs, ENETC_PCS_IF_MODE,
-		  ENETC_PCS_IF_MODE_SGMII_EN |
-		  ENETC_PCS_IF_MODE_USE_SGMII_AN);
-
-	/* Adjust link timer for SGMII */
-	phy_write(pcs, ENETC_PCS_LINK_TIMER1,
-		  ENETC_PCS_LINK_TIMER1_VAL);
-	phy_write(pcs, ENETC_PCS_LINK_TIMER2,
-		  ENETC_PCS_LINK_TIMER2_VAL);
-
-	phy_set_bits(pcs, MII_BMCR, BMCR_ANENABLE);
-}
-
-static void vsc9959_pcs_config_usxgmii(struct phy_device *pcs,
-				       unsigned int link_an_mode,
-				       const struct phylink_link_state *state)
-{
-	/* Configure device ability for the USXGMII Replicator */
-	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_ADVERTISE,
-		      MDIO_USXGMII_2500FULL |
-		      MDIO_USXGMII_LINK |
-		      ADVERTISE_SGMII |
-		      ADVERTISE_LPACK);
-}
-
-void vsc9959_pcs_config(struct ocelot *ocelot, int port,
-			unsigned int link_an_mode,
-			const struct phylink_link_state *state)
-{
-	struct felix *felix = ocelot_to_felix(ocelot);
-	struct phy_device *pcs = felix->pcs[port];
-
-	if (!pcs)
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
-	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, pcs->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, pcs->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, pcs->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, pcs->supported);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, pcs->supported);
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
-	if (!phylink_autoneg_inband(link_an_mode))
-		return;
-
-	switch (pcs->interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		vsc9959_pcs_config_sgmii(pcs, link_an_mode, state);
-		break;
-	case PHY_INTERFACE_MODE_2500BASEX:
-		phydev_err(pcs, "AN not supported on 3.125GHz SerDes lane\n");
-		break;
-	case PHY_INTERFACE_MODE_USXGMII:
-		vsc9959_pcs_config_usxgmii(pcs, link_an_mode, state);
-		break;
-	default:
-		dev_err(ocelot->dev, "Unsupported link mode %s\n",
-			phy_modes(pcs->interface));
-	}
-}
-
-static void vsc9959_pcs_link_up_sgmii(struct phy_device *pcs,
-				      unsigned int link_an_mode,
-				      int speed, int duplex)
-{
-	u16 if_mode = ENETC_PCS_IF_MODE_SGMII_EN;
-
-	switch (speed) {
-	case SPEED_1000:
-		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_1000);
-		break;
-	case SPEED_100:
-		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_100);
-		break;
-	case SPEED_10:
-		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_10);
-		break;
-	default:
-		phydev_err(pcs, "Invalid PCS speed %d\n", speed);
-		return;
-	}
-
-	if (duplex == DUPLEX_HALF)
-		if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
-
-	phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
-	phy_clear_bits(pcs, MII_BMCR, BMCR_ANENABLE);
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
-static void vsc9959_pcs_link_up_2500basex(struct phy_device *pcs,
-					  unsigned int link_an_mode,
-					  int speed, int duplex)
-{
-	u16 if_mode = ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500) |
-		      ENETC_PCS_IF_MODE_SGMII_EN;
-
-	if (duplex == DUPLEX_HALF)
-		if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
-
-	phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
-	phy_clear_bits(pcs, MII_BMCR, BMCR_ANENABLE);
-}
-
-void vsc9959_pcs_link_up(struct ocelot *ocelot, int port,
-			 unsigned int link_an_mode,
-			 phy_interface_t interface,
-			 int speed, int duplex)
-{
-	struct felix *felix = ocelot_to_felix(ocelot);
-	struct phy_device *pcs = felix->pcs[port];
-
-	if (!pcs)
-		return;
-
-	if (phylink_autoneg_inband(link_an_mode))
-		return;
-
-	switch (interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-		vsc9959_pcs_link_up_sgmii(pcs, link_an_mode, speed, duplex);
-		break;
-	case PHY_INTERFACE_MODE_2500BASEX:
-		vsc9959_pcs_link_up_2500basex(pcs, link_an_mode, speed,
-					      duplex);
-		break;
-	case PHY_INTERFACE_MODE_USXGMII:
-		phydev_err(pcs, "USXGMII only supports in-band AN for now\n");
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
-
-	pcs->speed = SPEED_2500;
-	pcs->asym_pause = true;
-	pcs->pause = true;
-}
-
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
-	pcs->autoneg_complete = !!(status & BMSR_ANEGCOMPLETE);
-	pcs->link = !!(status & BMSR_LSTATUS);
-
-	if (!pcs->link || !pcs->autoneg_complete)
-		return;
-
-	lpa = phy_read_mmd(pcs, MDIO_MMD_VEND2, MII_LPA);
-	if (lpa < 0)
-		return;
-
-	switch (lpa & MDIO_USXGMII_SPD_MASK) {
-	case MDIO_USXGMII_10:
-		pcs->speed = SPEED_10;
-		break;
-	case MDIO_USXGMII_100:
-		pcs->speed = SPEED_100;
-		break;
-	case MDIO_USXGMII_1000:
-		pcs->speed = SPEED_1000;
-		break;
-	case MDIO_USXGMII_2500:
-		pcs->speed = SPEED_2500;
-		break;
-	default:
-		break;
-	}
-
-	if (lpa & MDIO_USXGMII_FULL_DUPLEX)
-		pcs->duplex = DUPLEX_FULL;
-	else
-		pcs->duplex = DUPLEX_HALF;
-}
-
-void vsc9959_pcs_link_state(struct ocelot *ocelot, int port,
-			    struct phylink_link_state *state)
-{
-	struct felix *felix = ocelot_to_felix(ocelot);
-	struct phy_device *pcs = felix->pcs[port];
-
-	if (!pcs)
-		return;
-
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
-}
-
 static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
 				     unsigned long *supported,
 				     struct phylink_link_state *state)
@@ -1195,7 +855,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct phy_device *),
+				  sizeof(struct lynx_pcs *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1246,18 +906,26 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
-		struct phy_device *pcs;
-		bool is_c45 = false;
+		struct mdio_device *pcs;
+		struct lynx_pcs *lynx;
+
+		if (dsa_is_unused_port(felix->ds, port))
+			continue;
 
-		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_USXGMII)
-			is_c45 = true;
+		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
+			continue;
 
-		pcs = get_phy_device(felix->imdio, port, is_c45);
+		pcs = mdio_device_create(felix->imdio, port);
 		if (IS_ERR(pcs))
 			continue;
 
-		pcs->interface = ocelot_port->phy_mode;
-		felix->pcs[port] = pcs;
+		lynx = lynx_pcs_create(pcs);
+		if (!lynx) {
+			mdio_device_free(pcs);
+			continue;
+		}
+
+		felix->pcs[port] = lynx;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
 	}
@@ -1271,12 +939,13 @@ void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct phy_device *pcs = felix->pcs[port];
+		struct lynx_pcs *pcs = felix->pcs[port];
 
 		if (!pcs)
 			continue;
 
-		put_device(&pcs->mdio.dev);
+		mdio_device_free(pcs->mdio);
+		lynx_pcs_destroy(pcs);
 	}
 	mdiobus_unregister(felix->imdio);
 }
@@ -1499,9 +1168,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.imdio_pci_bar		= 0,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
-	.pcs_config		= vsc9959_pcs_config,
-	.pcs_link_up		= vsc9959_pcs_link_up,
-	.pcs_link_state		= vsc9959_pcs_link_state,
 	.phylink_validate	= vsc9959_phylink_validate,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc          = vsc9959_port_setup_tc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 625b1891d955..2d6a5f5758f8 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -7,6 +7,7 @@
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/of_platform.h>
+#include <linux/pcs-lynx.h>
 #include <linux/packing.h>
 #include <linux/iopoll.h>
 #include "felix.h"
@@ -960,18 +961,27 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
-		struct phy_device *pcs;
 		int addr = port + 4;
+		struct mdio_device *pcs;
+		struct lynx_pcs *lynx;
+
+		if (dsa_is_unused_port(felix->ds, port))
+			continue;
 
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		pcs = get_phy_device(felix->imdio, addr, false);
+		pcs = mdio_device_create(felix->imdio, addr);
 		if (IS_ERR(pcs))
 			continue;
 
-		pcs->interface = ocelot_port->phy_mode;
-		felix->pcs[port] = pcs;
+		lynx = lynx_pcs_create(pcs);
+		if (!lynx) {
+			mdio_device_free(pcs);
+			continue;
+		}
+
+		felix->pcs[port] = lynx;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
 	}
@@ -1013,9 +1023,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.num_ports		= 10,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
-	.pcs_config		= vsc9959_pcs_config,
-	.pcs_link_up		= vsc9959_pcs_link_up,
-	.pcs_link_state		= vsc9959_pcs_link_state,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
 	.xmit_template_populate	= vsc9953_xmit_template_populate,
-- 
2.25.1


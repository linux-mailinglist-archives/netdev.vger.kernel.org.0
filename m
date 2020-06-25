Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D6620A1D7
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405834AbgFYPYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgFYPYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:24:11 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06E6C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:24:10 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so6319598ejg.12
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=USObexE/hT/6mGpzrbUQp+guMgeFe65PHGORji2BxTU=;
        b=kEQWhpvFfju0nUKOSs28c0DCuRreiW7NJqmIDBpsfEins+C0JH3oA1VOFP94o3ZdlY
         kbRmntg8tmXX4tpRlc0wJ7E+z3quMIVlly8KLfB135PoGv2xF0HshenG+Qci8iSB7Xv+
         CGZrR8vf77f3vAj0ycMiORd2xHE6V5EmO50YvzQ44yk06v1QDIkU2fwmD7AxgrEUfPx8
         B0fjkdbk+VIAoisA8XMRWHjmwOExaOzhyU/EdxQwsmSc64H9f3mx//RBNY9lM9uHtvSn
         f1wYHqZHAcq9roH9dDVluy+I1s+XzilYDLSPpkF/CN0A6ePUGZ9t93fcpuSJKp5TY8tA
         rnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=USObexE/hT/6mGpzrbUQp+guMgeFe65PHGORji2BxTU=;
        b=DcACfnASG9Ror+2IUQDS/T7gEfNU49N1PI1J2FZqVHfkvbDlf97OtekUySCL42H0BT
         e9mJeMz5uhkJ29Vm/1q+ZL0Edf1OCoSuRnuPAB5zO1YWQvPzN744kXsB84h/fuHVfm68
         EFN/c7V/XlfWbpWyN3LXZ1VJudDYiaBWPSj/t6QgnuDmMLY7/Imxk4UNFzeS3T2uPI6P
         rXRRl3ooO6csmT61bAw7liq2c3WWEmMWob5fws+/YZ4+wyvYROPz7YyA28f/PyqD5QWp
         1q/mGG7YkWcMwePFNipLRwai10m3VMTsV4QZGzwaP5IF6bbOnSY9BS8KGQUhWjpLc0xj
         U8iw==
X-Gm-Message-State: AOAM531nRUfH31fuAo85Cc4pxmEmX4Ecjt/Q7huHgNoZiD1OWEOqLQ7z
        ExZuFbUKgNonef27VG/JUfI=
X-Google-Smtp-Source: ABdhPJyiShgecJqQZkqG5jyipbQ1K8rv98BUUT5+pMCszxqMkBpaENuPdduRVsGWJpX85mvpZJkQCQ==
X-Received: by 2002:a17:906:9394:: with SMTP id l20mr21380848ejx.467.1593098649231;
        Thu, 25 Jun 2020 08:24:09 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o17sm9102898ejb.105.2020.06.25.08.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:24:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH net-next 7/7] net: dsa: felix: use resolved link config in mac_link_up()
Date:   Thu, 25 Jun 2020 18:23:31 +0300
Message-Id: <20200625152331.3784018-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625152331.3784018-1-olteanv@gmail.com>
References: <20200625152331.3784018-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

PHYLINK now requires that parameters established through
auto-negotiation be written into the MAC at the time of the
mac_link_up() callback. In the case of felix, that means taking the port
out of reset, setting the correct timers for PAUSE frames, and
enabling/disabling TX flow control.

This patch also splits the inband and noinband configuration of the
vsc9959 PCS (currently found in a function called "init") into 2
different functions, which have a nomenclature closer to PHYLINK:
"config", for inband setup, and "link_up", for noinband (forced) setup.
This is necessary as a preparation step for giving up control of the PCS
to PHYLINK, which will be done in further patches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  76 ++++----
 drivers/net/dsa/ocelot/felix.h         |  10 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 258 ++++++++++++++-----------
 3 files changed, 187 insertions(+), 157 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4ec05090121c..0ac875ac1d65 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -233,6 +233,32 @@ static int felix_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
 static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 				     unsigned int link_an_mode,
 				     const struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->pcs_config)
+		felix->info->pcs_config(ocelot, port, link_an_mode, state);
+}
+
+static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
+					unsigned int link_an_mode,
+					phy_interface_t interface)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
+	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
+		       QSYS_SWITCH_PORT_MODE, port);
+}
+
+static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
+				      unsigned int link_an_mode,
+				      phy_interface_t interface,
+				      struct phy_device *phydev,
+				      int speed, int duplex,
+				      bool tx_pause, bool rx_pause)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -250,7 +276,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
 			   DEV_CLOCK_CFG);
 
-	switch (state->speed) {
+	switch (speed) {
 	case SPEED_10:
 		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
 		break;
@@ -261,12 +287,9 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	case SPEED_2500:
 		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
 		break;
-	case SPEED_UNKNOWN:
-		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(0);
-		break;
 	default:
 		dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
-			port, state->speed);
+			port, speed);
 		return;
 	}
 
@@ -275,7 +298,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	 */
 	mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
 
-	if (state->pause & MLO_PAUSE_TX)
+	if (tx_pause)
 		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
 			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
 			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
@@ -288,37 +311,9 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
 
-	if (felix->info->pcs_init)
-		felix->info->pcs_init(ocelot, port, link_an_mode, state);
-
-	if (felix->info->port_sched_speed_set)
-		felix->info->port_sched_speed_set(ocelot, port,
-						  state->speed);
-}
-
-static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
-					unsigned int link_an_mode,
-					phy_interface_t interface)
-{
-	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
-	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
-	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
-		       QSYS_SWITCH_PORT_MODE, port);
-}
-
-static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
-				      unsigned int link_an_mode,
-				      phy_interface_t interface,
-				      struct phy_device *phydev,
-				      int speed, int duplex,
-				      bool tx_pause, bool rx_pause)
-{
-	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
-	/* Enable MAC module */
+	/* Undo the effects of felix_phylink_mac_link_down:
+	 * enable MAC module
+	 */
 	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
 			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
 
@@ -335,6 +330,13 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
 			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
 			 QSYS_SWITCH_PORT_MODE, port);
+
+	if (felix->info->pcs_link_up)
+		felix->info->pcs_link_up(ocelot, port, link_an_mode, interface,
+					 speed, duplex);
+
+	if (felix->info->port_sched_speed_set)
+		felix->info->port_sched_speed_set(ocelot, port, speed);
 }
 
 static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4a4cebcf04a7..00137b64132b 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -28,9 +28,13 @@ struct felix_info {
 	int				imdio_pci_bar;
 	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
 	void	(*mdio_bus_free)(struct ocelot *ocelot);
-	void	(*pcs_init)(struct ocelot *ocelot, int port,
-			    unsigned int link_an_mode,
-			    const struct phylink_link_state *state);
+	void	(*pcs_config)(struct ocelot *ocelot, int port,
+			      unsigned int link_an_mode,
+			      const struct phylink_link_state *state);
+	void	(*pcs_link_up)(struct ocelot *ocelot, int port,
+			       unsigned int link_an_mode,
+			       phy_interface_t interface,
+			       int speed, int duplex);
 	void	(*pcs_link_state)(struct ocelot *ocelot, int port,
 				  struct phylink_link_state *state);
 	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index dba62c609efc..f9ddac7f48ae 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -737,125 +737,54 @@ static int vsc9959_reset(struct ocelot *ocelot)
  * traffic if SGMII AN is enabled but not completed (acknowledged by us), so
  * setting MLO_AN_INBAND is actually required for those.
  */
-static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
-				   unsigned int link_an_mode,
-				   const struct phylink_link_state *state)
+static void vsc9959_pcs_config_sgmii(struct phy_device *pcs,
+				     unsigned int link_an_mode,
+				     const struct phylink_link_state *state)
 {
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
-		u16 if_mode = ENETC_PCS_IF_MODE_SGMII_EN;
-		int speed;
-
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
-		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(speed);
-		if (state->duplex == DUPLEX_HALF)
-			if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
-
-		phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
-		phy_write(pcs, MII_BMCR, 0);
-	}
-}
+	int bmsr, bmcr;
+
+	/* Some PHYs like VSC8234 don't like it when AN restarts on
+	 * their system  side and they restart line side AN too, going
+	 * into an endless link up/down loop.  Don't restart PCS AN if
+	 * link is up already.
+	 * We do check that AN is enabled just in case this is the 1st
+	 * call, PCS detects a carrier but AN is disabled from power on
+	 * or by boot loader.
+	 */
+	bmcr = phy_read(pcs, MII_BMCR);
+	if (bmcr < 0)
+		return;
 
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
-	u16 if_mode = ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500) |
-		      ENETC_PCS_IF_MODE_SGMII_EN;
+	bmsr = phy_read(pcs, MII_BMSR);
+	if (bmsr < 0)
+		return;
 
-	if (link_an_mode == MLO_AN_INBAND) {
-		phydev_err(pcs, "AN not supported on 3.125GHz SerDes lane\n");
+	if ((bmcr & BMCR_ANENABLE) && (bmsr & BMSR_LSTATUS))
 		return;
-	}
 
-	if (state->duplex == DUPLEX_HALF)
-		if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
+	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
+	 * for the MAC PCS in order to acknowledge the AN.
+	 */
+	phy_write(pcs, MII_ADVERTISE, ADVERTISE_SGMII |
+				      ADVERTISE_LPACK);
 
-	phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
-	phy_write(pcs, MII_BMCR, 0);
+	phy_write(pcs, ENETC_PCS_IF_MODE,
+		  ENETC_PCS_IF_MODE_SGMII_EN |
+		  ENETC_PCS_IF_MODE_USE_SGMII_AN);
+
+	/* Adjust link timer for SGMII */
+	phy_write(pcs, ENETC_PCS_LINK_TIMER1,
+		  ENETC_PCS_LINK_TIMER1_VAL);
+	phy_write(pcs, ENETC_PCS_LINK_TIMER2,
+		  ENETC_PCS_LINK_TIMER2_VAL);
+
+	phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
 }
 
-static void vsc9959_pcs_init_usxgmii(struct phy_device *pcs,
-				     unsigned int link_an_mode,
-				     const struct phylink_link_state *state)
+static void vsc9959_pcs_config_usxgmii(struct phy_device *pcs,
+				       unsigned int link_an_mode,
+				       const struct phylink_link_state *state)
 {
-	if (link_an_mode != MLO_AN_INBAND) {
-		phydev_err(pcs, "USXGMII only supports in-band AN for now\n");
-		return;
-	}
-
 	/* Configure device ability for the USXGMII Replicator */
 	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_ADVERTISE,
 		      USXGMII_ADVERTISE_SPEED(USXGMII_SPEED_2500) |
@@ -865,9 +794,9 @@ static void vsc9959_pcs_init_usxgmii(struct phy_device *pcs,
 		      USXGMII_ADVERTISE_FDX);
 }
 
-static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
-			     unsigned int link_an_mode,
-			     const struct phylink_link_state *state)
+static void vsc9959_pcs_config(struct ocelot *ocelot, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct phy_device *pcs = felix->pcs[port];
@@ -899,16 +828,110 @@ static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
 				 pcs->supported);
 	phy_advertise_supported(pcs);
 
+	if (!phylink_autoneg_inband(link_an_mode))
+		return;
+
 	switch (pcs->interface) {
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
-		vsc9959_pcs_init_sgmii(pcs, link_an_mode, state);
+		vsc9959_pcs_config_sgmii(pcs, link_an_mode, state);
 		break;
 	case PHY_INTERFACE_MODE_2500BASEX:
-		vsc9959_pcs_init_2500basex(pcs, link_an_mode, state);
+		phydev_err(pcs, "AN not supported on 3.125GHz SerDes lane\n");
 		break;
 	case PHY_INTERFACE_MODE_USXGMII:
-		vsc9959_pcs_init_usxgmii(pcs, link_an_mode, state);
+		vsc9959_pcs_config_usxgmii(pcs, link_an_mode, state);
+		break;
+	default:
+		dev_err(ocelot->dev, "Unsupported link mode %s\n",
+			phy_modes(pcs->interface));
+	}
+}
+
+static void vsc9959_pcs_link_up_sgmii(struct phy_device *pcs,
+				      unsigned int link_an_mode,
+				      int speed, int duplex)
+{
+	u16 if_mode = ENETC_PCS_IF_MODE_SGMII_EN;
+
+	switch (speed) {
+	case SPEED_1000:
+		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_1000);
+		break;
+	case SPEED_100:
+		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_100);
+		break;
+	case SPEED_10:
+		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_10);
+		break;
+	default:
+		phydev_err(pcs, "Invalid PCS speed %d\n", speed);
+		return;
+	}
+
+	if (duplex == DUPLEX_HALF)
+		if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
+
+	phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
+	phy_write(pcs, MII_BMCR, 0);
+}
+
+/* 2500Base-X is SerDes protocol 7 on Felix and 6 on ENETC. It is a SerDes lane
+ * clocked at 3.125 GHz which encodes symbols with 8b/10b and does not have
+ * auto-negotiation of any link parameters. Electrically it is compatible with
+ * a single lane of XAUI.
+ * The hardware reference manual wants to call this mode SGMII, but it isn't
+ * really, since the fundamental features of SGMII:
+ * - Downgrading the link speed by duplicating symbols
+ * - Auto-negotiation
+ * are not there.
+ * The speed is configured at 1000 in the IF_MODE and BMCR MDIO registers
+ * because the clock frequency is actually given by a PLL configured in the
+ * Reset Configuration Word (RCW).
+ * Since there is no difference between fixed speed SGMII w/o AN and 802.3z w/o
+ * AN, we call this PHY interface type 2500Base-X. In case a PHY negotiates a
+ * lower link speed on line side, the system-side interface remains fixed at
+ * 2500 Mbps and we do rate adaptation through pause frames.
+ */
+static void vsc9959_pcs_link_up_2500basex(struct phy_device *pcs,
+					  unsigned int link_an_mode,
+					  int speed, int duplex)
+{
+	u16 if_mode = ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500) |
+		      ENETC_PCS_IF_MODE_SGMII_EN;
+
+	if (duplex == DUPLEX_HALF)
+		if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
+
+	phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
+	phy_write(pcs, MII_BMCR, 0);
+}
+
+static void vsc9959_pcs_link_up(struct ocelot *ocelot, int port,
+				unsigned int link_an_mode,
+				phy_interface_t interface,
+				int speed, int duplex)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct phy_device *pcs = felix->pcs[port];
+
+	if (!pcs)
+		return;
+
+	if (phylink_autoneg_inband(link_an_mode))
+		return;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		vsc9959_pcs_link_up_sgmii(pcs, link_an_mode, speed, duplex);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		vsc9959_pcs_link_up_2500basex(pcs, link_an_mode, speed,
+					      duplex);
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		phydev_err(pcs, "USXGMII only supports in-band AN for now\n");
 		break;
 	default:
 		dev_err(ocelot->dev, "Unsupported link mode %s\n",
@@ -1375,7 +1398,8 @@ struct felix_info felix_info_vsc9959 = {
 	.imdio_pci_bar		= 0,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
-	.pcs_init		= vsc9959_pcs_init,
+	.pcs_config		= vsc9959_pcs_config,
+	.pcs_link_up		= vsc9959_pcs_link_up,
 	.pcs_link_state		= vsc9959_pcs_link_state,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc          = vsc9959_port_setup_tc,
-- 
2.25.1


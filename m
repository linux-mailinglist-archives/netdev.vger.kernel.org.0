Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDDD4FB7FD
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344694AbiDKJsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344693AbiDKJsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:48:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558DD3C71F
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PBUozL5TIxonaPPm3Nh+ChnOYojhIraEKu/Zpweidq8=; b=M6dCV8CgL0eONW2rbti+oomK6B
        GWDu2gkXKPxrycr//b8wvGNCUpHZB4kCvBFpsnZ5L4KNzPVsPYt7oQPgVX2Aw/0aFT5yGF8wNQfnr
        8ya53a/jeyDy8eV2C6eux15IJmGI0ZKP+dfeukJQnBLxFCvCBaWBFb9mxeY3AiahOBstUAyx6NLWy
        vQWaWJhxpVUn1f/KLUvAxpsQFOwubsBCYzQVIScSqydRLrj/swPF86rk2CTPXo6HIUKIPqwVV8rpu
        uTE+pDVH7hHKyWfihTMfYdT45s9YsWvp1TjkmDnO5IZNKVBL8IyjtHG9Ax4HaQxCUB2S0BpC73Z1N
        R19SC6Ew==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52870 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ndqcu-0000HW-A2; Mon, 11 Apr 2022 10:46:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ndqct-0055RO-Da; Mon, 11 Apr 2022 10:46:27 +0100
In-Reply-To: <YlP4vGKVrlIJUUHK@shell.armlinux.org.uk>
References: <YlP4vGKVrlIJUUHK@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next v2 7/9] net: dsa: mt7530: partially convert to
 phylink_pcs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ndqct-0055RO-Da@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 11 Apr 2022 10:46:27 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Partially convert the mt7530 driver to use phylink's PCS support. This
is a partial implementation as we don't move anything into the
pcs_config method yet - this driver supports SGMII or 1000BASE-X
without in-band.

Tested-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 144 +++++++++++++++++++++++----------------
 drivers/net/dsa/mt7530.h |  21 +++---
 2 files changed, 95 insertions(+), 70 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index aa7f21683a07..1c0d931973e5 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -24,6 +24,11 @@
 
 #include "mt7530.h"
 
+static struct mt753x_pcs *pcs_to_mt753x_pcs(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct mt753x_pcs, pcs);
+}
+
 /* String, offset, and register size in bytes if different from 4 bytes */
 static const struct mt7530_mib_desc mt7530_mib[] = {
 	MIB_DESC(1, 0x00, "TxDrop"),
@@ -2521,12 +2526,11 @@ static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
 	return 0;
 }
 
-static void
-mt7531_sgmii_link_up_force(struct dsa_switch *ds, int port,
-			   unsigned int mode, phy_interface_t interface,
-			   int speed, int duplex)
+static void mt7531_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+			       phy_interface_t interface, int speed, int duplex)
 {
-	struct mt7530_priv *priv = ds->priv;
+	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
+	int port = pcs_to_mt753x_pcs(pcs)->port;
 	unsigned int val;
 
 	/* For adjusting speed and duplex of SGMII force mode. */
@@ -2552,6 +2556,9 @@ mt7531_sgmii_link_up_force(struct dsa_switch *ds, int port,
 
 	/* MT7531 SGMII 1G force mode can only work in full duplex mode,
 	 * no matter MT7531_SGMII_FORCE_HALF_DUPLEX is set or not.
+	 *
+	 * The speed check is unnecessary as the MAC capabilities apply
+	 * this restriction. --rmk
 	 */
 	if ((speed == SPEED_10 || speed == SPEED_100) &&
 	    duplex != DUPLEX_FULL)
@@ -2627,9 +2634,10 @@ static int mt7531_sgmii_setup_mode_an(struct mt7530_priv *priv, int port,
 	return 0;
 }
 
-static void mt7531_sgmii_restart_an(struct dsa_switch *ds, int port)
+static void mt7531_pcs_an_restart(struct phylink_pcs *pcs)
 {
-	struct mt7530_priv *priv = ds->priv;
+	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
+	int port = pcs_to_mt753x_pcs(pcs)->port;
 	u32 val;
 
 	/* Only restart AN when AN is enabled */
@@ -2686,6 +2694,24 @@ mt753x_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	return priv->info->mac_port_config(ds, port, mode, state->interface);
 }
 
+static struct phylink_pcs *
+mt753x_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
+			      phy_interface_t interface)
+{
+	struct mt7530_priv *priv = ds->priv;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_TRGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return &priv->pcs[port].pcs;
+
+	default:
+		return NULL;
+	}
+}
+
 static void
 mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			  const struct phylink_link_state *state)
@@ -2747,17 +2773,6 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		mt7530_write(priv, MT7530_PMCR_P(port), mcr_new);
 }
 
-static void
-mt753x_phylink_mac_an_restart(struct dsa_switch *ds, int port)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	if (!priv->info->mac_pcs_an_restart)
-		return;
-
-	priv->info->mac_pcs_an_restart(ds, port);
-}
-
 static void mt753x_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					 unsigned int mode,
 					 phy_interface_t interface)
@@ -2767,16 +2782,13 @@ static void mt753x_phylink_mac_link_down(struct dsa_switch *ds, int port,
 	mt7530_clear(priv, MT7530_PMCR_P(port), PMCR_LINK_SETTINGS_MASK);
 }
 
-static void mt753x_mac_pcs_link_up(struct dsa_switch *ds, int port,
-				   unsigned int mode, phy_interface_t interface,
-				   int speed, int duplex)
+static void mt753x_phylink_pcs_link_up(struct phylink_pcs *pcs,
+				       unsigned int mode,
+				       phy_interface_t interface,
+				       int speed, int duplex)
 {
-	struct mt7530_priv *priv = ds->priv;
-
-	if (!priv->info->mac_pcs_link_up)
-		return;
-
-	priv->info->mac_pcs_link_up(ds, port, mode, interface, speed, duplex);
+	if (pcs->ops->pcs_link_up)
+		pcs->ops->pcs_link_up(pcs, mode, interface, speed, duplex);
 }
 
 static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -2789,8 +2801,6 @@ static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	struct mt7530_priv *priv = ds->priv;
 	u32 mcr;
 
-	mt753x_mac_pcs_link_up(ds, port, mode, interface, speed, duplex);
-
 	mcr = PMCR_RX_EN | PMCR_TX_EN | PMCR_FORCE_LNK;
 
 	/* MT753x MAC works in 1G full duplex mode for all up-clocked
@@ -2870,6 +2880,8 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 		return ret;
 	mt7530_write(priv, MT7530_PMCR_P(port),
 		     PMCR_CPU_PORT_SETTING(priv->id));
+	mt753x_phylink_pcs_link_up(&priv->pcs[port].pcs, MLO_AN_FIXED,
+				   interface, speed, DUPLEX_FULL);
 	mt753x_phylink_mac_link_up(ds, port, MLO_AN_FIXED, interface, NULL,
 				   speed, DUPLEX_FULL, true, true);
 
@@ -2909,16 +2921,13 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 	linkmode_and(state->advertising, state->advertising, mask);
 }
 
-static int
-mt7530_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			      struct phylink_link_state *state)
+static void mt7530_pcs_get_state(struct phylink_pcs *pcs,
+				 struct phylink_link_state *state)
 {
-	struct mt7530_priv *priv = ds->priv;
+	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
+	int port = pcs_to_mt753x_pcs(pcs)->port;
 	u32 pmsr;
 
-	if (port < 0 || port >= MT7530_NUM_PORTS)
-		return -EINVAL;
-
 	pmsr = mt7530_read(priv, MT7530_PMSR_P(port));
 
 	state->link = (pmsr & PMSR_LINK);
@@ -2945,8 +2954,6 @@ mt7530_phylink_mac_link_state(struct dsa_switch *ds, int port,
 		state->pause |= MLO_PAUSE_RX;
 	if (pmsr & PMSR_TX_FC)
 		state->pause |= MLO_PAUSE_TX;
-
-	return 1;
 }
 
 static int
@@ -2988,32 +2995,49 @@ mt7531_sgmii_pcs_get_state_an(struct mt7530_priv *priv, int port,
 	return 0;
 }
 
-static int
-mt7531_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			      struct phylink_link_state *state)
+static void mt7531_pcs_get_state(struct phylink_pcs *pcs,
+				 struct phylink_link_state *state)
 {
-	struct mt7530_priv *priv = ds->priv;
+	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
+	int port = pcs_to_mt753x_pcs(pcs)->port;
 
 	if (state->interface == PHY_INTERFACE_MODE_SGMII)
-		return mt7531_sgmii_pcs_get_state_an(priv, port, state);
-
-	return -EOPNOTSUPP;
+		mt7531_sgmii_pcs_get_state_an(priv, port, state);
+	else
+		state->link = false;
 }
 
-static int
-mt753x_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			      struct phylink_link_state *state)
+static int mt753x_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			     phy_interface_t interface,
+			     const unsigned long *advertising,
+			     bool permit_pause_to_mac)
 {
-	struct mt7530_priv *priv = ds->priv;
+	return 0;
+}
 
-	return priv->info->mac_port_get_state(ds, port, state);
+static void mt7530_pcs_an_restart(struct phylink_pcs *pcs)
+{
 }
 
+static const struct phylink_pcs_ops mt7530_pcs_ops = {
+	.pcs_get_state = mt7530_pcs_get_state,
+	.pcs_config = mt753x_pcs_config,
+	.pcs_an_restart = mt7530_pcs_an_restart,
+};
+
+static const struct phylink_pcs_ops mt7531_pcs_ops = {
+	.pcs_get_state = mt7531_pcs_get_state,
+	.pcs_config = mt753x_pcs_config,
+	.pcs_an_restart = mt7531_pcs_an_restart,
+	.pcs_link_up = mt7531_pcs_link_up,
+};
+
 static int
 mt753x_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret = priv->info->sw_setup(ds);
+	int i;
 
 	if (ret)
 		return ret;
@@ -3026,6 +3050,13 @@ mt753x_setup(struct dsa_switch *ds)
 	if (ret && priv->irq)
 		mt7530_free_irq_common(priv);
 
+	/* Initialise the PCS devices */
+	for (i = 0; i < priv->ds->num_ports; i++) {
+		priv->pcs[i].pcs.ops = priv->info->pcs_ops;
+		priv->pcs[i].priv = priv;
+		priv->pcs[i].port = i;
+	}
+
 	return ret;
 }
 
@@ -3087,9 +3118,8 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_mirror_del	= mt753x_port_mirror_del,
 	.phylink_get_caps	= mt753x_phylink_get_caps,
 	.phylink_validate	= mt753x_phylink_validate,
-	.phylink_mac_link_state	= mt753x_phylink_mac_link_state,
+	.phylink_mac_select_pcs	= mt753x_phylink_mac_select_pcs,
 	.phylink_mac_config	= mt753x_phylink_mac_config,
-	.phylink_mac_an_restart	= mt753x_phylink_mac_an_restart,
 	.phylink_mac_link_down	= mt753x_phylink_mac_link_down,
 	.phylink_mac_link_up	= mt753x_phylink_mac_link_up,
 	.get_mac_eee		= mt753x_get_mac_eee,
@@ -3099,36 +3129,34 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 static const struct mt753x_info mt753x_table[] = {
 	[ID_MT7621] = {
 		.id = ID_MT7621,
+		.pcs_ops = &mt7530_pcs_ops,
 		.sw_setup = mt7530_setup,
 		.phy_read = mt7530_phy_read,
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
 	},
 	[ID_MT7530] = {
 		.id = ID_MT7530,
+		.pcs_ops = &mt7530_pcs_ops,
 		.sw_setup = mt7530_setup,
 		.phy_read = mt7530_phy_read,
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
 	},
 	[ID_MT7531] = {
 		.id = ID_MT7531,
+		.pcs_ops = &mt7531_pcs_ops,
 		.sw_setup = mt7531_setup,
 		.phy_read = mt7531_ind_phy_read,
 		.phy_write = mt7531_ind_phy_write,
 		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
-		.mac_port_get_state = mt7531_phylink_mac_link_state,
 		.mac_port_config = mt7531_mac_config,
-		.mac_pcs_an_restart = mt7531_sgmii_restart_an,
-		.mac_pcs_link_up = mt7531_sgmii_link_up_force,
 	},
 };
 
@@ -3186,7 +3214,7 @@ mt7530_probe(struct mdio_device *mdiodev)
 	if (!priv->info->sw_setup || !priv->info->pad_setup ||
 	    !priv->info->phy_read || !priv->info->phy_write ||
 	    !priv->info->mac_port_get_caps ||
-	    !priv->info->mac_port_get_state || !priv->info->mac_port_config)
+	    !priv->info->mac_port_config)
 		return -EINVAL;
 
 	priv->id = priv->info->id;
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 73cfd29fbb17..71e36b69b96d 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -741,6 +741,12 @@ static const char *p5_intf_modes(unsigned int p5_interface)
 
 struct mt7530_priv;
 
+struct mt753x_pcs {
+	struct phylink_pcs pcs;
+	struct mt7530_priv *priv;
+	int port;
+};
+
 /* struct mt753x_info -	This is the main data structure for holding the specific
  *			part for each supported device
  * @sw_setup:		Holding the handler to a device initialization
@@ -752,18 +758,14 @@ struct mt7530_priv;
  *			port
  * @mac_port_validate:	Holding the way to set addition validate type for a
  *			certan MAC port
- * @mac_port_get_state: Holding the way getting the MAC/PCS state for a certain
- *			MAC port
  * @mac_port_config:	Holding the way setting up the PHY attribute to a
  *			certain MAC port
- * @mac_pcs_an_restart	Holding the way restarting PCS autonegotiation for a
- *			certain MAC port
- * @mac_pcs_link_up:	Holding the way setting up the PHY attribute to the pcs
- *			of the certain MAC port
  */
 struct mt753x_info {
 	enum mt753x_id id;
 
+	const struct phylink_pcs_ops *pcs_ops;
+
 	int (*sw_setup)(struct dsa_switch *ds);
 	int (*phy_read)(struct mt7530_priv *priv, int port, int regnum);
 	int (*phy_write)(struct mt7530_priv *priv, int port, int regnum, u16 val);
@@ -774,15 +776,9 @@ struct mt753x_info {
 	void (*mac_port_validate)(struct dsa_switch *ds, int port,
 				  phy_interface_t interface,
 				  unsigned long *supported);
-	int (*mac_port_get_state)(struct dsa_switch *ds, int port,
-				  struct phylink_link_state *state);
 	int (*mac_port_config)(struct dsa_switch *ds, int port,
 			       unsigned int mode,
 			       phy_interface_t interface);
-	void (*mac_pcs_an_restart)(struct dsa_switch *ds, int port);
-	void (*mac_pcs_link_up)(struct dsa_switch *ds, int port,
-				unsigned int mode, phy_interface_t interface,
-				int speed, int duplex);
 };
 
 /* struct mt7530_priv -	This is the main data structure for holding the state
@@ -824,6 +820,7 @@ struct mt7530_priv {
 	u8			mirror_tx;
 
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
+	struct mt753x_pcs	pcs[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
 	struct mutex reg_mutex;
 	int irq;
-- 
2.30.2


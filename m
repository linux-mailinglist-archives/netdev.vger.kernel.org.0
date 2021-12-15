Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD02475BE8
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243967AbhLOPek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243965AbhLOPej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:34:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1D9C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kXGOTJmSxHgJw62kEtw4SsEffjedFwUxVCpKrSpWs4g=; b=IEJssqk9J40wM1HU0NSWbotsQl
        IgdSc0DlRWg7wNxA8YFQD+s7Bu/Ow/Enc27PVL82cf3hfioDwCYlR5/VbIjVo5zi3/YEB1q2BS69p
        OIBblq1nYo1gRG99m5B6Y6ve6x8y6spIkOLC9+FpCjAqkeEKg2mRzBbKNEfwCkcCsOFz2DOS5t1oK
        XRxn/Nbxp1kWdA8GUs1SS19NG0Ch+YlcN7YkVyKoRdXE7a3b63KW5wWzaMQ75x/MIB/rIFlG5LMk4
        t7ZpLvd5N1IAeiJOn5VNdRUWMnvY1vAq4s4quNDRsbo2Pvz7kUBBaJJoOPYAxYZq7dbiwFfgE1TEy
        qUVZsh7A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43826 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWIe-0006a2-1u; Wed, 15 Dec 2021 15:34:36 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWId-00GPib-JY; Wed, 15 Dec 2021 15:34:35 +0000
In-Reply-To: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
References: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 net-next 5/7] net: mvneta: convert to use
 mac_prepare()/mac_finish()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxWId-00GPib-JY@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 15 Dec 2021 15:34:35 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvneta to use the mac_prepare() and mac_finish() methods in
preparation to converting mvneta to split-PCS support.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 103 +++++++++++++++++---------
 1 file changed, 68 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e3c5d64ba340..e59952c65a3c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3905,6 +3905,40 @@ static void mvneta_mac_an_restart(struct phylink_config *config)
 		    gmac_an & ~MVNETA_GMAC_INBAND_RESTART_AN);
 }
 
+static int mvneta_mac_prepare(struct phylink_config *config, unsigned int mode,
+			      phy_interface_t interface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct mvneta_port *pp = netdev_priv(ndev);
+	u32 val;
+
+	if (pp->phy_interface != interface ||
+	    phylink_autoneg_inband(mode)) {
+		/* Force the link down when changing the interface or if in
+		 * in-band mode. According to Armada 370 documentation, we
+		 * can only change the port mode and in-band enable when the
+		 * link is down.
+		 */
+		val = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
+		val &= ~MVNETA_GMAC_FORCE_LINK_PASS;
+		val |= MVNETA_GMAC_FORCE_LINK_DOWN;
+		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
+	}
+
+	if (pp->phy_interface != interface)
+		WARN_ON(phy_power_off(pp->comphy));
+
+	/* Enable the 1ms clock */
+	if (phylink_autoneg_inband(mode)) {
+		unsigned long rate = clk_get_rate(pp->clk);
+
+		mvreg_write(pp, MVNETA_GMAC_CLOCK_DIVIDER,
+			    MVNETA_GMAC_1MS_CLOCK_ENABLE | (rate / 1000));
+	}
+
+	return 0;
+}
+
 static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 			      const struct phylink_link_state *state)
 {
@@ -3913,14 +3947,12 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	u32 new_ctrl0, gmac_ctrl0 = mvreg_read(pp, MVNETA_GMAC_CTRL_0);
 	u32 new_ctrl2, gmac_ctrl2 = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
 	u32 new_ctrl4, gmac_ctrl4 = mvreg_read(pp, MVNETA_GMAC_CTRL_4);
-	u32 new_clk, gmac_clk = mvreg_read(pp, MVNETA_GMAC_CLOCK_DIVIDER);
 	u32 new_an, gmac_an = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
 
 	new_ctrl0 = gmac_ctrl0 & ~MVNETA_GMAC0_PORT_1000BASE_X;
 	new_ctrl2 = gmac_ctrl2 & ~(MVNETA_GMAC2_INBAND_AN_ENABLE |
 				   MVNETA_GMAC2_PORT_RESET);
 	new_ctrl4 = gmac_ctrl4 & ~(MVNETA_GMAC4_SHORT_PREAMBLE_ENABLE);
-	new_clk = gmac_clk & ~MVNETA_GMAC_1MS_CLOCK_ENABLE;
 	new_an = gmac_an & ~(MVNETA_GMAC_INBAND_AN_ENABLE |
 			     MVNETA_GMAC_INBAND_RESTART_AN |
 			     MVNETA_GMAC_AN_SPEED_EN |
@@ -3948,10 +3980,7 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
 		/* SGMII mode receives the state from the PHY */
 		new_ctrl2 |= MVNETA_GMAC2_INBAND_AN_ENABLE;
-		new_clk = MVNETA_GMAC_1MS_CLOCK_ENABLE;
-		new_an = (new_an & ~(MVNETA_GMAC_FORCE_LINK_DOWN |
-				     MVNETA_GMAC_FORCE_LINK_PASS |
-				     MVNETA_GMAC_CONFIG_MII_SPEED |
+		new_an = (new_an & ~(MVNETA_GMAC_CONFIG_MII_SPEED |
 				     MVNETA_GMAC_CONFIG_GMII_SPEED |
 				     MVNETA_GMAC_CONFIG_FULL_DUPLEX)) |
 			 MVNETA_GMAC_INBAND_AN_ENABLE |
@@ -3960,10 +3989,7 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	} else {
 		/* 802.3z negotiation - only 1000base-X */
 		new_ctrl0 |= MVNETA_GMAC0_PORT_1000BASE_X;
-		new_clk = MVNETA_GMAC_1MS_CLOCK_ENABLE;
-		new_an = (new_an & ~(MVNETA_GMAC_FORCE_LINK_DOWN |
-				     MVNETA_GMAC_FORCE_LINK_PASS |
-				     MVNETA_GMAC_CONFIG_MII_SPEED)) |
+		new_an = (new_an & ~MVNETA_GMAC_CONFIG_MII_SPEED) |
 			 MVNETA_GMAC_INBAND_AN_ENABLE |
 			 MVNETA_GMAC_CONFIG_GMII_SPEED |
 			 /* The MAC only supports FD mode */
@@ -3973,43 +3999,18 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 			new_an |= MVNETA_GMAC_AN_FLOW_CTRL_EN;
 	}
 
-	/* Set the 1ms clock divisor */
-	if (new_clk == MVNETA_GMAC_1MS_CLOCK_ENABLE)
-		new_clk |= clk_get_rate(pp->clk) / 1000;
-
-	/* Armada 370 documentation says we can only change the port mode
-	 * and in-band enable when the link is down, so force it down
-	 * while making these changes. We also do this for GMAC_CTRL2
-	 */
-	if ((new_ctrl0 ^ gmac_ctrl0) & MVNETA_GMAC0_PORT_1000BASE_X ||
-	    (new_ctrl2 ^ gmac_ctrl2) & MVNETA_GMAC2_INBAND_AN_ENABLE ||
-	    (new_an  ^ gmac_an) & MVNETA_GMAC_INBAND_AN_ENABLE) {
-		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG,
-			    (gmac_an & ~MVNETA_GMAC_FORCE_LINK_PASS) |
-			    MVNETA_GMAC_FORCE_LINK_DOWN);
-	}
-
-
 	/* When at 2.5G, the link partner can send frames with shortened
 	 * preambles.
 	 */
 	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
 		new_ctrl4 |= MVNETA_GMAC4_SHORT_PREAMBLE_ENABLE;
 
-	if (pp->phy_interface != state->interface) {
-		if (pp->comphy)
-			WARN_ON(phy_power_off(pp->comphy));
-		WARN_ON(mvneta_config_interface(pp, state->interface));
-	}
-
 	if (new_ctrl0 != gmac_ctrl0)
 		mvreg_write(pp, MVNETA_GMAC_CTRL_0, new_ctrl0);
 	if (new_ctrl2 != gmac_ctrl2)
 		mvreg_write(pp, MVNETA_GMAC_CTRL_2, new_ctrl2);
 	if (new_ctrl4 != gmac_ctrl4)
 		mvreg_write(pp, MVNETA_GMAC_CTRL_4, new_ctrl4);
-	if (new_clk != gmac_clk)
-		mvreg_write(pp, MVNETA_GMAC_CLOCK_DIVIDER, new_clk);
 	if (new_an != gmac_an)
 		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, new_an);
 
@@ -4020,6 +4021,36 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	}
 }
 
+static int mvneta_mac_finish(struct phylink_config *config, unsigned int mode,
+			     phy_interface_t interface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct mvneta_port *pp = netdev_priv(ndev);
+	u32 val, clk;
+
+	/* Disable 1ms clock if not in in-band mode */
+	if (!phylink_autoneg_inband(mode)) {
+		clk = mvreg_read(pp, MVNETA_GMAC_CLOCK_DIVIDER);
+		clk &= ~MVNETA_GMAC_1MS_CLOCK_ENABLE;
+		mvreg_write(pp, MVNETA_GMAC_CLOCK_DIVIDER, clk);
+	}
+
+	if (pp->phy_interface != interface)
+		/* Enable the Serdes PHY */
+		WARN_ON(mvneta_config_interface(pp, interface));
+
+	/* Allow the link to come up if in in-band mode, otherwise the
+	 * link is forced via mac_link_down()/mac_link_up()
+	 */
+	if (phylink_autoneg_inband(mode)) {
+		val = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
+		val &= ~MVNETA_GMAC_FORCE_LINK_DOWN;
+		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
+	}
+
+	return 0;
+}
+
 static void mvneta_set_eee(struct mvneta_port *pp, bool enable)
 {
 	u32 lpi_ctl1;
@@ -4109,7 +4140,9 @@ static const struct phylink_mac_ops mvneta_phylink_ops = {
 	.validate = mvneta_validate,
 	.mac_pcs_get_state = mvneta_mac_pcs_get_state,
 	.mac_an_restart = mvneta_mac_an_restart,
+	.mac_prepare = mvneta_mac_prepare,
 	.mac_config = mvneta_mac_config,
+	.mac_finish = mvneta_mac_finish,
 	.mac_link_down = mvneta_mac_link_down,
 	.mac_link_up = mvneta_mac_link_up,
 };
-- 
2.30.2


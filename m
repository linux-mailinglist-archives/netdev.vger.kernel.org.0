Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070B416FC16
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 11:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgBZK01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 05:26:27 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45800 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgBZK01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 05:26:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MvXRdKBQwWqpifCLpYCrvOQkEY6QAL9CbEYBlFLaB2Y=; b=KmVgZMAe1fxE5Zxf2Nc/df2ey4
        2APSIzPFVDdLPw8mC7f86bqQM/c5D3hECwLr91/OCaBMXKuXU7OETLtn4B8KAS3bXa3WQc0786zns
        sEDKiLsCh/nsIDeIqunmIMx4pcSY4NQ5Z+NqyyJa+a8m1C0IACnoe9+t4YVe5eWjbrItewvVGhX9f
        gYf/U+8ty23700lBYbzNDK+VcEuOoi98zHiUmmW17IVFBKh99vK/ErW1DfEU3uggDYZLZdjozZyFS
        4M7n23vNcTnrJ3xBiBvIyi1qbmpI6TZUm+09R1W5jxY00P3KaZvFx2nHdsxgKK9AMwb/879NluvDD
        E9xSSyRQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41412 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6trX-0006sO-Gc; Wed, 26 Feb 2020 10:24:20 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6trQ-0003Gu-1G; Wed, 26 Feb 2020 10:24:12 +0000
In-Reply-To: <20200226102312.GX25745@shell.armlinux.org.uk>
References: <20200226102312.GX25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 7/8] net: mvneta: use resolved link config in
 mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j6trQ-0003Gu-1G@rmk-PC.armlinux.org.uk>
Date:   Wed, 26 Feb 2020 10:24:12 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Marvell mvneta ethernet driver to use the finalised link
parameters in mac_link_up() rather than the parameters in mac_config().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 55 ++++++++++++++++++---------
 1 file changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 9af3f8d5b289..b22eeb5f8700 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3830,13 +3830,9 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	new_clk = gmac_clk & ~MVNETA_GMAC_1MS_CLOCK_ENABLE;
 	new_an = gmac_an & ~(MVNETA_GMAC_INBAND_AN_ENABLE |
 			     MVNETA_GMAC_INBAND_RESTART_AN |
-			     MVNETA_GMAC_CONFIG_MII_SPEED |
-			     MVNETA_GMAC_CONFIG_GMII_SPEED |
 			     MVNETA_GMAC_AN_SPEED_EN |
 			     MVNETA_GMAC_ADVERT_SYM_FLOW_CTRL |
-			     MVNETA_GMAC_CONFIG_FLOW_CTRL |
 			     MVNETA_GMAC_AN_FLOW_CTRL_EN |
-			     MVNETA_GMAC_CONFIG_FULL_DUPLEX |
 			     MVNETA_GMAC_AN_DUPLEX_EN);
 
 	/* Even though it might look weird, when we're configured in
@@ -3851,24 +3847,20 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 
 	if (phylink_test(state->advertising, Pause))
 		new_an |= MVNETA_GMAC_ADVERT_SYM_FLOW_CTRL;
-	if (state->pause & MLO_PAUSE_TXRX_MASK)
-		new_an |= MVNETA_GMAC_CONFIG_FLOW_CTRL;
 
 	if (!phylink_autoneg_inband(mode)) {
-		/* Phy or fixed speed */
-		if (state->duplex)
-			new_an |= MVNETA_GMAC_CONFIG_FULL_DUPLEX;
-
-		if (state->speed == SPEED_1000 || state->speed == SPEED_2500)
-			new_an |= MVNETA_GMAC_CONFIG_GMII_SPEED;
-		else if (state->speed == SPEED_100)
-			new_an |= MVNETA_GMAC_CONFIG_MII_SPEED;
+		/* Phy or fixed speed - nothing to do, leave the
+		 * configured speed, duplex and flow control as-is.
+		 */
 	} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
 		/* SGMII mode receives the state from the PHY */
 		new_ctrl2 |= MVNETA_GMAC2_INBAND_AN_ENABLE;
 		new_clk |= MVNETA_GMAC_1MS_CLOCK_ENABLE;
 		new_an = (new_an & ~(MVNETA_GMAC_FORCE_LINK_DOWN |
-				     MVNETA_GMAC_FORCE_LINK_PASS)) |
+				     MVNETA_GMAC_FORCE_LINK_PASS |
+				     MVNETA_GMAC_CONFIG_MII_SPEED |
+				     MVNETA_GMAC_CONFIG_GMII_SPEED |
+				     MVNETA_GMAC_CONFIG_FULL_DUPLEX)) |
 			 MVNETA_GMAC_INBAND_AN_ENABLE |
 			 MVNETA_GMAC_AN_SPEED_EN |
 			 MVNETA_GMAC_AN_DUPLEX_EN;
@@ -3877,7 +3869,8 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 		new_ctrl0 |= MVNETA_GMAC0_PORT_1000BASE_X;
 		new_clk |= MVNETA_GMAC_1MS_CLOCK_ENABLE;
 		new_an = (new_an & ~(MVNETA_GMAC_FORCE_LINK_DOWN |
-				     MVNETA_GMAC_FORCE_LINK_PASS)) |
+				     MVNETA_GMAC_FORCE_LINK_PASS |
+				     MVNETA_GMAC_CONFIG_MII_SPEED)) |
 			 MVNETA_GMAC_INBAND_AN_ENABLE |
 			 MVNETA_GMAC_CONFIG_GMII_SPEED |
 			 /* The MAC only supports FD mode */
@@ -3977,8 +3970,36 @@ static void mvneta_mac_link_up(struct phylink_config *config,
 
 	if (!phylink_autoneg_inband(mode)) {
 		val = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
-		val &= ~MVNETA_GMAC_FORCE_LINK_DOWN;
+		val &= ~(MVNETA_GMAC_FORCE_LINK_DOWN |
+			 MVNETA_GMAC_CONFIG_MII_SPEED |
+			 MVNETA_GMAC_CONFIG_GMII_SPEED |
+			 MVNETA_GMAC_CONFIG_FLOW_CTRL |
+			 MVNETA_GMAC_CONFIG_FULL_DUPLEX);
 		val |= MVNETA_GMAC_FORCE_LINK_PASS;
+
+		if (speed == SPEED_1000 || speed == SPEED_2500)
+			val |= MVNETA_GMAC_CONFIG_GMII_SPEED;
+		else if (speed == SPEED_100)
+			val |= MVNETA_GMAC_CONFIG_MII_SPEED;
+
+		if (duplex == DUPLEX_FULL)
+			val |= MVNETA_GMAC_CONFIG_FULL_DUPLEX;
+
+		if (tx_pause || rx_pause)
+			val |= MVNETA_GMAC_CONFIG_FLOW_CTRL;
+
+		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
+	} else {
+		/* When inband doesn't cover flow control or flow control is
+		 * disabled, we need to manually configure it. This bit will
+		 * only have effect if MVNETA_GMAC_AN_FLOW_CTRL_EN is unset.
+		 */
+		val = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
+		val &= ~MVNETA_GMAC_CONFIG_FLOW_CTRL;
+
+		if (tx_pause || rx_pause)
+			val |= MVNETA_GMAC_CONFIG_FLOW_CTRL;
+
 		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
 	}
 
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A1C2022D0
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 11:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgFTJVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 05:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgFTJVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 05:21:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B12C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 02:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pUnUrmwF+iwxz9Hg+peC9oIodVcsMh1eP0I0a1afw5I=; b=0f97lBmNFHzII3HbVMu3i3mVZs
        T6TADcwMGNdkec4V3w7NmoYOMJUBc777p7++DgnlMEkCpfzfqvW/ZlLw3KQljTBbMhx10IiLbVJ8J
        T1PHnukRI0cDmDN2Im2xAaKPXZnJFEAUsGARbohRtN9FhOj7w/Jv3hArZ2eSPUIoctHfveJzjPUvR
        6tkjACTO07sXCXeVrjdwuYHFzhLd0iFmEiiEGNyQ66uioMX48Tjv6LcSKv/YWqXcY6qD3rU2l4bKs
        1RAa6Ol9IlqUdhR2te8Nlbk4/gB1cV/2sG5+zdXpyRBVruRjhCkbVwH0uGD+0RnMoZx4qCON+wrfM
        hbOxoE7Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49226 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jmZgv-0007OY-D6; Sat, 20 Jun 2020 10:21:37 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jmZgv-0001UT-62; Sat, 20 Jun 2020 10:21:37 +0100
In-Reply-To: <20200620092047.GR1551@shell.armlinux.org.uk>
References: <20200620092047.GR1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] net: mvpp2: add register modification helper
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jmZgv-0001UT-62@rmk-PC.armlinux.org.uk>
Date:   Sat, 20 Jun 2020 10:21:37 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to read-modify-write a register, and use it in the phylink
helpers.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 88 ++++++++++---------
 1 file changed, 46 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 313f5a60a605..375e3c657162 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1132,6 +1132,17 @@ static bool mvpp2_is_xlg(phy_interface_t interface)
 	       interface == PHY_INTERFACE_MODE_XAUI;
 }
 
+static void mvpp2_modify(void __iomem *ptr, u32 mask, u32 set)
+{
+	u32 old, val;
+
+	old = val = readl(ptr);
+	val &= ~mask;
+	val |= set;
+	if (old != val)
+		writel(val, ptr);
+}
+
 static void mvpp22_gop_init_rgmii(struct mvpp2_port *port)
 {
 	struct mvpp2 *priv = port->priv;
@@ -4946,38 +4957,29 @@ static void mvpp2_mac_an_restart(struct phylink_config *config)
 static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
-	u32 old_ctrl0, ctrl0;
-	u32 old_ctrl4, ctrl4;
-
-	old_ctrl0 = ctrl0 = readl(port->base + MVPP22_XLG_CTRL0_REG);
-	old_ctrl4 = ctrl4 = readl(port->base + MVPP22_XLG_CTRL4_REG);
-
-	ctrl0 |= MVPP22_XLG_CTRL0_MAC_RESET_DIS;
+	u32 val;
 
+	val = MVPP22_XLG_CTRL0_MAC_RESET_DIS;
 	if (state->pause & MLO_PAUSE_TX)
-		ctrl0 |= MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN;
-	else
-		ctrl0 &= ~MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN;
+		val |= MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN;
 
 	if (state->pause & MLO_PAUSE_RX)
-		ctrl0 |= MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN;
-	else
-		ctrl0 &= ~MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN;
-
-	ctrl4 &= ~(MVPP22_XLG_CTRL4_MACMODSELECT_GMAC |
-		   MVPP22_XLG_CTRL4_EN_IDLE_CHECK);
-	ctrl4 |= MVPP22_XLG_CTRL4_FWD_FC | MVPP22_XLG_CTRL4_FWD_PFC;
-
-	if (old_ctrl0 != ctrl0)
-		writel(ctrl0, port->base + MVPP22_XLG_CTRL0_REG);
-	if (old_ctrl4 != ctrl4)
-		writel(ctrl4, port->base + MVPP22_XLG_CTRL4_REG);
-
-	if (!(old_ctrl0 & MVPP22_XLG_CTRL0_MAC_RESET_DIS)) {
-		while (!(readl(port->base + MVPP22_XLG_CTRL0_REG) &
-			 MVPP22_XLG_CTRL0_MAC_RESET_DIS))
-			continue;
-	}
+		val |= MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN;
+
+	mvpp2_modify(port->base + MVPP22_XLG_CTRL0_REG,
+		     MVPP22_XLG_CTRL0_MAC_RESET_DIS |
+		     MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN |
+		     MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN, val);
+	mvpp2_modify(port->base + MVPP22_XLG_CTRL4_REG,
+		     MVPP22_XLG_CTRL4_MACMODSELECT_GMAC |
+		     MVPP22_XLG_CTRL4_EN_IDLE_CHECK |
+		     MVPP22_XLG_CTRL4_FWD_FC | MVPP22_XLG_CTRL4_FWD_PFC,
+		     MVPP22_XLG_CTRL4_FWD_FC | MVPP22_XLG_CTRL4_FWD_PFC);
+
+	/* Wait for reset to deassert */
+	do {
+		val = readl(port->base + MVPP22_XLG_CTRL0_REG);
+	} while (!(val & MVPP22_XLG_CTRL0_MAC_RESET_DIS));
 }
 
 static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
@@ -5157,19 +5159,14 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 
 	if (mvpp2_is_xlg(interface)) {
 		if (!phylink_autoneg_inband(mode)) {
-			val = readl(port->base + MVPP22_XLG_CTRL0_REG);
-			val &= ~MVPP22_XLG_CTRL0_FORCE_LINK_DOWN;
-			val |= MVPP22_XLG_CTRL0_FORCE_LINK_PASS;
-			writel(val, port->base + MVPP22_XLG_CTRL0_REG);
+			mvpp2_modify(port->base + MVPP22_XLG_CTRL0_REG,
+				     MVPP22_XLG_CTRL0_FORCE_LINK_DOWN |
+				     MVPP22_XLG_CTRL0_FORCE_LINK_PASS,
+				     MVPP22_XLG_CTRL0_FORCE_LINK_PASS);
 		}
 	} else {
 		if (!phylink_autoneg_inband(mode)) {
-			val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
-			val &= ~(MVPP2_GMAC_FORCE_LINK_DOWN |
-				 MVPP2_GMAC_CONFIG_MII_SPEED |
-				 MVPP2_GMAC_CONFIG_GMII_SPEED |
-				 MVPP2_GMAC_CONFIG_FULL_DUPLEX);
-			val |= MVPP2_GMAC_FORCE_LINK_PASS;
+			val = MVPP2_GMAC_FORCE_LINK_PASS;
 
 			if (speed == SPEED_1000 || speed == SPEED_2500)
 				val |= MVPP2_GMAC_CONFIG_GMII_SPEED;
@@ -5179,20 +5176,27 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 			if (duplex == DUPLEX_FULL)
 				val |= MVPP2_GMAC_CONFIG_FULL_DUPLEX;
 
-			writel(val, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+			mvpp2_modify(port->base + MVPP2_GMAC_AUTONEG_CONFIG,
+				     MVPP2_GMAC_FORCE_LINK_DOWN |
+				     MVPP2_GMAC_FORCE_LINK_PASS |
+				     MVPP2_GMAC_CONFIG_MII_SPEED |
+				     MVPP2_GMAC_CONFIG_GMII_SPEED |
+				     MVPP2_GMAC_CONFIG_FULL_DUPLEX, val);
 		}
 
 		/* We can always update the flow control enable bits;
 		 * these will only be effective if flow control AN
 		 * (MVPP2_GMAC_FLOW_CTRL_AUTONEG) is disabled.
 		 */
-		val = readl(port->base + MVPP22_GMAC_CTRL_4_REG);
-		val &= ~(MVPP22_CTRL4_RX_FC_EN | MVPP22_CTRL4_TX_FC_EN);
+		val = 0;
 		if (tx_pause)
 			val |= MVPP22_CTRL4_TX_FC_EN;
 		if (rx_pause)
 			val |= MVPP22_CTRL4_RX_FC_EN;
-		writel(val, port->base + MVPP22_GMAC_CTRL_4_REG);
+
+		mvpp2_modify(port->base + MVPP22_GMAC_CTRL_4_REG,
+			     MVPP22_CTRL4_RX_FC_EN | MVPP22_CTRL4_TX_FC_EN,
+			     val);
 	}
 
 	mvpp2_port_enable(port);
-- 
2.20.1


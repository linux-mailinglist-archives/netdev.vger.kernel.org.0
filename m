Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841DE258F72
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgIANth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728278AbgIANsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:48:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C6CC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 06:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fsvICyP0hgnI32FrhKlD1y/Ir7xwkp+AhFVukUloi9s=; b=zIGfGDx0bOmZ9nrU6Pk6e7K3+b
        8xuP/SL8KEArZ9n0kAkA0TmHOXCbxNBNdlfhCoBPDBk92SDaBcSRzgH937VcPlP5ZctCKvJn4L5qI
        +fJNFrG+IA1kwUwVe+hBYAQILlkG+VueD5KUtDWBF4F/FfqiV0w6NdgKKhzdlGvKSohvlJSpn2BOt
        jREdhhd1W7TFr2+H88nbiWCAsu3qc3OiRIC5pjazBGkLjENJDUfX5HXtss+U/Y583Yuu6ng71PO1l
        RC+H7/7W63db9sUbO3N/CY7wWr8GPzRNwHdcoe035VN07XcVf8+Q1nPe7ebOrJ3p46uA5p7xQiBMC
        /3OK52FA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36086 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6eB-0002Yi-TO; Tue, 01 Sep 2020 14:48:27 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6eB-0007LL-MK; Tue, 01 Sep 2020 14:48:27 +0100
In-Reply-To: <20200901134746.GM1551@shell.armlinux.org.uk>
References: <20200901134746.GM1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/6] net: mvpp2: move GMAC reset handling into
 mac_prepare()/mac_finish()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kD6eB-0007LL-MK@rmk-PC.armlinux.org.uk>
Date:   Tue, 01 Sep 2020 14:48:27 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the GMAC reset handling into mac_prepare() / mac_finish()

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 53 ++++++++-----------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 1f5f8416cec0..58df72088fba 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5585,8 +5585,7 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 		MVPP2_GMAC_AN_DUPLEX_EN | MVPP2_GMAC_IN_BAND_AUTONEG |
 		MVPP2_GMAC_IN_BAND_AUTONEG_BYPASS);
 	ctrl0 &= ~MVPP2_GMAC_PORT_TYPE_MASK;
-	ctrl2 &= ~(MVPP2_GMAC_INBAND_AN_MASK | MVPP2_GMAC_PORT_RESET_MASK |
-		   MVPP2_GMAC_PCS_ENABLE_MASK);
+	ctrl2 &= ~(MVPP2_GMAC_INBAND_AN_MASK | MVPP2_GMAC_PCS_ENABLE_MASK);
 
 	/* Configure port type */
 	if (phy_interface_mode_is_8023z(state->interface)) {
@@ -5646,26 +5645,6 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 			an |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
 	}
 
-/* Some fields of the auto-negotiation register require the port to be down when
- * their value is updated.
- */
-#define MVPP2_GMAC_AN_PORT_DOWN_MASK	\
-		(MVPP2_GMAC_IN_BAND_AUTONEG | \
-		 MVPP2_GMAC_IN_BAND_AUTONEG_BYPASS | \
-		 MVPP2_GMAC_CONFIG_MII_SPEED | MVPP2_GMAC_CONFIG_GMII_SPEED | \
-		 MVPP2_GMAC_AN_SPEED_EN | MVPP2_GMAC_CONFIG_FULL_DUPLEX | \
-		 MVPP2_GMAC_AN_DUPLEX_EN)
-
-	if ((old_ctrl0 ^ ctrl0) & MVPP2_GMAC_PORT_TYPE_MASK ||
-	    (old_ctrl2 ^ ctrl2) & MVPP2_GMAC_INBAND_AN_MASK ||
-	    (old_an ^ an) & MVPP2_GMAC_AN_PORT_DOWN_MASK) {
-		/* Set the GMAC in a reset state - do this in a way that
-		 * ensures we clear it below.
-		 */
-		old_ctrl2 |= MVPP2_GMAC_PORT_RESET_MASK;
-		writel(old_ctrl2, port->base + MVPP2_GMAC_CTRL_2_REG);
-	}
-
 	if (old_ctrl0 != ctrl0)
 		writel(ctrl0, port->base + MVPP2_GMAC_CTRL_0_REG);
 	if (old_ctrl2 != ctrl2)
@@ -5674,12 +5653,6 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 		writel(ctrl4, port->base + MVPP22_GMAC_CTRL_4_REG);
 	if (old_an != an)
 		writel(an, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
-
-	if (old_ctrl2 & MVPP2_GMAC_PORT_RESET_MASK) {
-		while (readl(port->base + MVPP2_GMAC_CTRL_2_REG) &
-		       MVPP2_GMAC_PORT_RESET_MASK)
-			continue;
-	}
 }
 
 static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
@@ -5716,11 +5689,17 @@ static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
 	/* Make sure the port is disabled when reconfiguring the mode */
 	mvpp2_port_disable(port);
 
-	if (port->priv->hw_version == MVPP22 &&
-	    port->phy_interface != interface) {
-		mvpp22_gop_mask_irq(port);
+	if (port->phy_interface != interface) {
+		/* Place GMAC into reset */
+		mvpp2_modify(port->base + MVPP2_GMAC_CTRL_2_REG,
+			     MVPP2_GMAC_PORT_RESET_MASK,
+			     MVPP2_GMAC_PORT_RESET_MASK);
+
+		if (port->priv->hw_version == MVPP22) {
+			mvpp22_gop_mask_irq(port);
 
-		phy_power_off(port->comphy);
+			phy_power_off(port->comphy);
+		}
 	}
 
 	return 0;
@@ -5759,6 +5738,16 @@ static int mvpp2_mac_finish(struct phylink_config *config, unsigned int mode,
 		mvpp22_gop_unmask_irq(port);
 	}
 
+	if (!mvpp2_is_xlg(interface)) {
+		/* Release GMAC reset and wait */
+		mvpp2_modify(port->base + MVPP2_GMAC_CTRL_2_REG,
+			     MVPP2_GMAC_PORT_RESET_MASK, 0);
+
+		while (readl(port->base + MVPP2_GMAC_CTRL_2_REG) &
+		       MVPP2_GMAC_PORT_RESET_MASK)
+			continue;
+	}
+
 	mvpp2_port_enable(port);
 
 	/* Allow the link to come up if in in-band mode, otherwise the
-- 
2.20.1


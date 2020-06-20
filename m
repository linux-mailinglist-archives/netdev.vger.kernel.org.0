Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3972022CE
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgFTJVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 05:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgFTJV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 05:21:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E685DC06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 02:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rzWWNg3h1Xz0TTVqufDgiaWGw4knoP6uHMp2mYENTIY=; b=MXFIhlhygJw0Biz6ZKzw0ypEqM
        m6UxCXVYzYC/fkD1+N5UVC1//+BAuTmwj25+XmjcJlPfnIc1yd/Du0cBspTkN99MbavLMv3nR209f
        4y8ywe8YxqokERvy1AKRlZF2IwIsK/yYMJvugforC9u5YEihES9KBBWrjzOmDCQbfI4wqihfm4jak
        g1A+tWEvEmz/PQKGEMsDPHp/zOzGp2jRP/zSZAusebpCIETvdAZxcLAFzA06tyCq1Ewm+TBtpRnzo
        MHKMKCKbNrNMpRSbpX6dvXYL/qycPqrrddypQt5fmp7lvPJKBnqOfDDZbtKFew7NUgbVUj7hX6FN7
        /JCRjr8g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49222 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jmZgl-0007OE-4F; Sat, 20 Jun 2020 10:21:27 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jmZgk-0001Tt-T3; Sat, 20 Jun 2020 10:21:26 +0100
In-Reply-To: <20200620092047.GR1551@shell.armlinux.org.uk>
References: <20200620092047.GR1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: mvpp2: add port support helpers
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jmZgk-0001Tt-T3@rmk-PC.armlinux.org.uk>
Date:   Sat, 20 Jun 2020 10:21:26 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mvpp2 code has tests scattered amongst the code to determine
whether the port supports the XLG, and whether the port supports
RGMII mode.

Rather than having these tests scattered, provide a couple of helper
functions, so that future additions can ensure that they get these
tests correct.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 43 ++++++++++++-------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 24f4d8e0da98..7653277d03b7 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1114,6 +1114,17 @@ mvpp2_shared_interrupt_mask_unmask(struct mvpp2_port *port, bool mask)
 	}
 }
 
+/* Only GOP port 0 has an XLG MAC */
+static bool mvpp2_port_supports_xlg(struct mvpp2_port *port)
+{
+	return port->gop_id == 0;
+}
+
+static bool mvpp2_port_supports_rgmii(struct mvpp2_port *port)
+{
+	return !(port->priv->hw_version == MVPP22 && port->gop_id == 0);
+}
+
 /* Port configuration routines */
 static bool mvpp2_is_xlg(phy_interface_t interface)
 {
@@ -1194,7 +1205,7 @@ static int mvpp22_gop_init(struct mvpp2_port *port)
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (port->gop_id == 0)
+		if (!mvpp2_port_supports_rgmii(port))
 			goto invalid_conf;
 		mvpp22_gop_init_rgmii(port);
 		break;
@@ -1204,7 +1215,7 @@ static int mvpp22_gop_init(struct mvpp2_port *port)
 		mvpp22_gop_init_sgmii(port);
 		break;
 	case PHY_INTERFACE_MODE_10GBASER:
-		if (port->gop_id != 0)
+		if (!mvpp2_port_supports_xlg(port))
 			goto invalid_conf;
 		mvpp22_gop_init_10gkr(port);
 		break;
@@ -1246,7 +1257,7 @@ static void mvpp22_gop_unmask_irq(struct mvpp2_port *port)
 		writel(val, port->base + MVPP22_GMAC_INT_SUM_MASK);
 	}
 
-	if (port->gop_id == 0) {
+	if (mvpp2_port_supports_xlg(port)) {
 		/* Enable the XLG/GIG irqs for this port */
 		val = readl(port->base + MVPP22_XLG_EXT_INT_MASK);
 		if (mvpp2_is_xlg(port->phy_interface))
@@ -1261,7 +1272,7 @@ static void mvpp22_gop_mask_irq(struct mvpp2_port *port)
 {
 	u32 val;
 
-	if (port->gop_id == 0) {
+	if (mvpp2_port_supports_xlg(port)) {
 		val = readl(port->base + MVPP22_XLG_EXT_INT_MASK);
 		val &= ~(MVPP22_XLG_EXT_INT_MASK_XLG |
 			 MVPP22_XLG_EXT_INT_MASK_GIG);
@@ -1290,7 +1301,7 @@ static void mvpp22_gop_setup_irq(struct mvpp2_port *port)
 		writel(val, port->base + MVPP22_GMAC_INT_MASK);
 	}
 
-	if (port->gop_id == 0) {
+	if (mvpp2_port_supports_xlg(port)) {
 		val = readl(port->base + MVPP22_XLG_INT_MASK);
 		val |= MVPP22_XLG_INT_MASK_LINK;
 		writel(val, port->base + MVPP22_XLG_INT_MASK);
@@ -1328,8 +1339,8 @@ static void mvpp2_port_enable(struct mvpp2_port *port)
 {
 	u32 val;
 
-	/* Only GOP port 0 has an XLG MAC */
-	if (port->gop_id == 0 && mvpp2_is_xlg(port->phy_interface)) {
+	if (mvpp2_port_supports_xlg(port) &&
+	    mvpp2_is_xlg(port->phy_interface)) {
 		val = readl(port->base + MVPP22_XLG_CTRL0_REG);
 		val |= MVPP22_XLG_CTRL0_PORT_EN;
 		val &= ~MVPP22_XLG_CTRL0_MIB_CNT_DIS;
@@ -1346,8 +1357,8 @@ static void mvpp2_port_disable(struct mvpp2_port *port)
 {
 	u32 val;
 
-	/* Only GOP port 0 has an XLG MAC */
-	if (port->gop_id == 0 && mvpp2_is_xlg(port->phy_interface)) {
+	if (mvpp2_port_supports_xlg(port) &&
+	    mvpp2_is_xlg(port->phy_interface)) {
 		val = readl(port->base + MVPP22_XLG_CTRL0_REG);
 		val &= ~MVPP22_XLG_CTRL0_PORT_EN;
 		writel(val, port->base + MVPP22_XLG_CTRL0_REG);
@@ -2740,7 +2751,8 @@ static irqreturn_t mvpp2_link_status_isr(int irq, void *dev_id)
 
 	mvpp22_gop_mask_irq(port);
 
-	if (port->gop_id == 0 && mvpp2_is_xlg(port->phy_interface)) {
+	if (mvpp2_port_supports_xlg(port) &&
+	    mvpp2_is_xlg(port->phy_interface)) {
 		val = readl(port->base + MVPP22_XLG_INT_STAT);
 		if (val & MVPP22_XLG_INT_STAT_LINK) {
 			event = true;
@@ -3430,8 +3442,7 @@ static void mvpp22_mode_reconfigure(struct mvpp2_port *port)
 
 	mvpp22_pcs_reset_deassert(port);
 
-	/* Only GOP port 0 has an XLG MAC */
-	if (port->gop_id == 0) {
+	if (mvpp2_port_supports_xlg(port)) {
 		ctrl3 = readl(port->base + MVPP22_XLG_CTRL3_REG);
 		ctrl3 &= ~MVPP22_XLG_CTRL3_MACMODESELECT_MASK;
 
@@ -3443,7 +3454,7 @@ static void mvpp22_mode_reconfigure(struct mvpp2_port *port)
 		writel(ctrl3, port->base + MVPP22_XLG_CTRL3_REG);
 	}
 
-	if (port->gop_id == 0 && mvpp2_is_xlg(port->phy_interface))
+	if (mvpp2_port_supports_xlg(port) && mvpp2_is_xlg(port->phy_interface))
 		mvpp2_xlg_max_rx_size_set(port);
 	else
 		mvpp2_gmac_max_rx_size_set(port);
@@ -4768,14 +4779,14 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_XAUI:
-		if (port->gop_id != 0)
+		if (!mvpp2_port_supports_xlg(port))
 			goto empty_set;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (port->priv->hw_version == MVPP22 && port->gop_id == 0)
+		if (!mvpp2_port_supports_rgmii(port))
 			goto empty_set;
 		break;
 	default:
@@ -4791,7 +4802,7 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_XAUI:
 	case PHY_INTERFACE_MODE_NA:
-		if (port->gop_id == 0) {
+		if (mvpp2_port_supports_xlg(port)) {
 			phylink_set(mask, 10000baseT_Full);
 			phylink_set(mask, 10000baseCR_Full);
 			phylink_set(mask, 10000baseSR_Full);
-- 
2.20.1


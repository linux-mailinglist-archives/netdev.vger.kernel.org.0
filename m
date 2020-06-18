Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2701FF709
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731530AbgFRPjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgFRPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 11:38:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88239C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 08:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c9c753uMBDtd4YHM4EHPlSFtRMRG4lbqO/7BXwoAeS8=; b=SEd2tCX/vcf+CBtqfr5M1FHNnQ
        u/BLOn+6id8KtwV7553ZPC3APBmRW0YKYJccrxi/ijQM4t/0VdpnisG3RmCORi0uzXcpT/WciSHgQ
        ET3FsP91v8FoD4W1lOszczf59mIxnlSOZheJaQInrKRdz/4BkMaE53jf/hMxUgSoTIwtTIRT40sY5
        oiK2kBsCY0GfIuTQAmNHPcpEmCJhRmH4bDEm9t0ECVsQe+H0PA2uGn94eElSplkYrqNxHINhICHxA
        pR/HREwIoPRAUXclDavlvrGds0+UxxxuVsX/AfsPbfKVyMb3POEpuTGbeMRhiU8rLwzr+AthVjKZg
        wPbQh5gw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38268 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlwcz-0005IJ-12; Thu, 18 Jun 2020 16:38:57 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlwcy-0005Hw-IR; Thu, 18 Jun 2020 16:38:56 +0100
In-Reply-To: <20200618153818.GD1551@shell.armlinux.org.uk>
References: <20200618153818.GD1551@shell.armlinux.org.uk>
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
Message-Id: <E1jlwcy-0005Hw-IR@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 16:38:56 +0100
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
index 8c8314715efd..9edd8fbf18a6 100644
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
@@ -4947,38 +4958,29 @@ static void mvpp2_mac_an_restart(struct phylink_config *config)
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
@@ -5158,19 +5160,14 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 
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
@@ -5180,20 +5177,27 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
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


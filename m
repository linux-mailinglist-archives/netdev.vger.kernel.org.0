Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0CA317DB26
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCIIhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:37:31 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42398 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726071AbgCIIgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:36:45 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F18A9C04C2;
        Mon,  9 Mar 2020 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583743004; bh=B4fi+wGhWTrFTQp3mAnhu+p1yjvs3nFstYvqGhSlpYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=gCGuSu0cHw9XWnuyfdn+0l3N2bLAY+tmOgeWAy5/AQnbPVPm7n1PdsPDqUrhOUS3y
         KVMo96VC4UpMu7/Tz4j+IRkrIdxVLF0M+k52AN6GuxkCtlAf/10V8LeyqtNY3xeq1Z
         PTamDuAkNWBS/Gyqd0PgHDtwyAhl/WUhq8OibxirzKLyDuBhW6JptArTvbEo1sTuOJ
         z1uKsMZUpb9Q9thG7bqQZp/0Py5csGuToy7gnPG59WPMajXrNCGMHbp0x5s33sxJFY
         AbqlAA9apRHuOe3NZv32Z8odwJX3HjN6WV+CyyqHBJgTGxt6uYf0HhZqLSv8hUsJ+s
         w1SZCczazTlgQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 54EA7A006D;
        Mon,  9 Mar 2020 08:36:41 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/8] net: stmmac: Use resolved link config in mac_link_up()
Date:   Mon,  9 Mar 2020 09:36:23 +0100
Message-Id: <8841e003101a27c97f59f9f1fe8c044a2807dcdb.1583742615.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the stmmac ethernet driver to use the finalised link parameters
in mac_link_up() rather than the parameters in mac_config().

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 66 +++++++++++------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8e555f4e82d7..3a190cf250e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -874,14 +874,39 @@ static void stmmac_mac_pcs_get_state(struct phylink_config *config,
 static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
 			      const struct phylink_link_state *state)
 {
+	/* Nothing for now. */
+}
+
+static void stmmac_mac_an_restart(struct phylink_config *config)
+{
+	/* Not Supported */
+}
+
+static void stmmac_mac_link_down(struct phylink_config *config,
+				 unsigned int mode, phy_interface_t interface)
+{
+	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
+
+	stmmac_mac_set(priv, priv->ioaddr, false);
+	priv->eee_active = false;
+	stmmac_eee_init(priv);
+	stmmac_set_eee_pls(priv, priv->hw, false);
+}
+
+static void stmmac_mac_link_up(struct phylink_config *config,
+			       struct phy_device *phy,
+			       unsigned int mode, phy_interface_t interface,
+			       int speed, int duplex,
+			       bool tx_pause, bool rx_pause)
+{
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	u32 ctrl;
 
 	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl &= ~priv->hw->link.speed_mask;
 
-	if (state->interface == PHY_INTERFACE_MODE_USXGMII) {
-		switch (state->speed) {
+	if (interface == PHY_INTERFACE_MODE_USXGMII) {
+		switch (speed) {
 		case SPEED_10000:
 			ctrl |= priv->hw->link.xgmii.speed10000;
 			break;
@@ -895,7 +920,7 @@ static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
 			return;
 		}
 	} else {
-		switch (state->speed) {
+		switch (speed) {
 		case SPEED_2500:
 			ctrl |= priv->hw->link.speed2500;
 			break;
@@ -913,46 +938,21 @@ static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
 		}
 	}
 
-	priv->speed = state->speed;
+	priv->speed = speed;
 
 	if (priv->plat->fix_mac_speed)
-		priv->plat->fix_mac_speed(priv->plat->bsp_priv, state->speed);
+		priv->plat->fix_mac_speed(priv->plat->bsp_priv, speed);
 
-	if (!state->duplex)
+	if (!duplex)
 		ctrl &= ~priv->hw->link.duplex;
 	else
 		ctrl |= priv->hw->link.duplex;
 
 	/* Flow Control operation */
-	if (state->pause)
-		stmmac_mac_flow_ctrl(priv, state->duplex);
+	if (tx_pause && rx_pause)
+		stmmac_mac_flow_ctrl(priv, duplex);
 
 	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
-}
-
-static void stmmac_mac_an_restart(struct phylink_config *config)
-{
-	/* Not Supported */
-}
-
-static void stmmac_mac_link_down(struct phylink_config *config,
-				 unsigned int mode, phy_interface_t interface)
-{
-	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-
-	stmmac_mac_set(priv, priv->ioaddr, false);
-	priv->eee_active = false;
-	stmmac_eee_init(priv);
-	stmmac_set_eee_pls(priv, priv->hw, false);
-}
-
-static void stmmac_mac_link_up(struct phylink_config *config,
-			       struct phy_device *phy,
-			       unsigned int mode, phy_interface_t interface,
-			       int speed, int duplex,
-			       bool tx_pause, bool rx_pause)
-{
-	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
-- 
2.7.4


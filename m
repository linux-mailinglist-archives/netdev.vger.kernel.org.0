Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B336D1473
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCaA4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjCaAzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26676C67E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3oqIOsKued46J4FItnxZj5LSJdU4+2L8Wb6tyVTV4FQ=; b=s+CcrWBV+d88+pWQ2rN0Mef14z
        lEBsDUgva4UVsVlQs5NuLbxGQD87cg3dGCKBCLNxF+4GnikQz3/v1TEuEKg6BrwHIx+3nT7KWR3QV
        luHmQY+Pul8S8hqsKWMO4ae1YayE8+QphvlaPSLUwTtoJsTt3d3oRY+opGvpySKTZTrI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xKv-OV; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 13/24] net: genet: Fixup EEE
Date:   Fri, 31 Mar 2023 02:55:07 +0200
Message-Id: <20230331005518.2134652-14-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enabling/disabling of EEE in the MAC should happen as a result of
auto negotiation. So move the enable/disable into bcmgenet_mii_setup()
which gets called by phylib when there is a change in link status.

bcmgenet_set_eee() now just writes the LTI timer value to the
hardware.  Everything else is passed to phylib, so it can correctly
setup the PHY.

bcmgenet_get_eee() relies on phylib doing most of the work, the MAC
driver just adds the LTI timer value from hardware.

The call to bcmgenet_eee_enable_set() in the resume function has been
removed. There is both unconditional calls to phy_init_hw() and
genphy_config_aneg, and a call to phy_resume(). As a result, the PHY
is going to perform auto-neg, and then it completes
bcmgenet_mii_setup() will be called, which will set the hardware to
the correct EEE mode.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 42 +++++--------------
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  3 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c  |  1 +
 3 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d937daa8ee88..035486304e31 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1272,19 +1272,21 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
-static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
+void bcmgenet_eee_enable_set(struct net_device *dev, bool eee_active)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	u32 off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
+	u32 off;
 	u32 reg;
 
-	if (enable && !priv->clk_eee_enabled) {
+	off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
+
+	if (eee_active && !priv->clk_eee_enabled) {
 		clk_prepare_enable(priv->clk_eee);
 		priv->clk_eee_enabled = true;
 	}
 
 	reg = bcmgenet_umac_readl(priv, UMAC_EEE_CTRL);
-	if (enable)
+	if (eee_active)
 		reg |= EEE_EN;
 	else
 		reg &= ~EEE_EN;
@@ -1292,7 +1294,7 @@ static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
 
 	/* Enable EEE and switch to a 27Mhz clock automatically */
 	reg = bcmgenet_readl(priv->base + off);
-	if (enable)
+	if (eee_active)
 		reg |= TBUF_EEE_EN | TBUF_PM_EN;
 	else
 		reg &= ~(TBUF_EEE_EN | TBUF_PM_EN);
@@ -1300,25 +1302,21 @@ static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
 
 	/* Do the same for thing for RBUF */
 	reg = bcmgenet_rbuf_readl(priv, RBUF_ENERGY_CTRL);
-	if (enable)
+	if (eee_active)
 		reg |= RBUF_EEE_EN | RBUF_PM_EN;
 	else
 		reg &= ~(RBUF_EEE_EN | RBUF_PM_EN);
 	bcmgenet_rbuf_writel(priv, reg, RBUF_ENERGY_CTRL);
 
-	if (!enable && priv->clk_eee_enabled) {
+	if (!eee_active && priv->clk_eee_enabled) {
 		clk_disable_unprepare(priv->clk_eee);
 		priv->clk_eee_enabled = false;
 	}
-
-	priv->eee.eee_enabled = enable;
-	priv->eee.eee_active = enable;
 }
 
 static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	struct ethtool_eee *p = &priv->eee;
 
 	if (GENET_IS_V1(priv))
 		return -EOPNOTSUPP;
@@ -1326,8 +1324,6 @@ static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
 	if (!dev->phydev)
 		return -ENODEV;
 
-	e->eee_enabled = p->eee_enabled;
-	e->eee_active = p->eee_active;
 	e->tx_lpi_timer = bcmgenet_umac_readl(priv, UMAC_EEE_LPI_TIMER);
 
 	return phy_ethtool_get_eee(dev->phydev, e);
@@ -1336,8 +1332,6 @@ static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
 static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	struct ethtool_eee *p = &priv->eee;
-	int ret = 0;
 
 	if (GENET_IS_V1(priv))
 		return -EOPNOTSUPP;
@@ -1345,20 +1339,7 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
 	if (!dev->phydev)
 		return -ENODEV;
 
-	p->eee_enabled = e->eee_enabled;
-
-	if (!p->eee_enabled) {
-		bcmgenet_eee_enable_set(dev, false);
-	} else {
-		ret = phy_init_eee(dev->phydev, false);
-		if (ret) {
-			netif_err(priv, hw, dev, "EEE initialization failed\n");
-			return ret;
-		}
-
-		bcmgenet_umac_writel(priv, e->tx_lpi_timer, UMAC_EEE_LPI_TIMER);
-		bcmgenet_eee_enable_set(dev, true);
-	}
+	bcmgenet_umac_writel(priv, e->tx_lpi_timer, UMAC_EEE_LPI_TIMER);
 
 	return phy_ethtool_set_eee(dev->phydev, e);
 }
@@ -4278,9 +4259,6 @@ static int bcmgenet_resume(struct device *d)
 	if (!device_may_wakeup(d))
 		phy_resume(dev->phydev);
 
-	if (priv->eee.eee_enabled)
-		bcmgenet_eee_enable_set(dev, true);
-
 	bcmgenet_netif_start(dev);
 
 	netif_device_attach(dev);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 946f6e283c4e..8c9643ec738c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -644,8 +644,6 @@ struct bcmgenet_priv {
 	bool wol_active;
 
 	struct bcmgenet_mib_counters mib;
-
-	struct ethtool_eee eee;
 };
 
 #define GENET_IO_MACRO(name, offset)					\
@@ -703,4 +701,5 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 			       enum bcmgenet_power_mode mode);
 
+void bcmgenet_eee_enable_set(struct net_device *dev, bool eee_active);
 #endif /* __BCMGENET_H__ */
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index be042905ada2..6c39839762a7 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -100,6 +100,7 @@ void bcmgenet_mii_setup(struct net_device *dev)
 
 	if (phydev->link) {
 		bcmgenet_mac_config(dev);
+		bcmgenet_eee_enable_set(dev, phydev->eee_active);
 	} else {
 		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
 		reg &= ~RGMII_LINK;
-- 
2.40.0


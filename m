Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95BE69A481
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjBQDnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjBQDm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE72CA0A
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8Ih7+tI9YF4CFVQwfqKaCqSy8PwUxM+IhBYOL5o9cjA=; b=qnHhoJh9Tt79nSxuzIDHgXMGAQ
        2m6KyiqZk0vcFqetOd/xioaRY132XIX2PHGyQA6P6WRWYd0ccl1WNFfNnNz02JuTUoGDrcLQPc2i/
        J6gYn5DfM4Ma4J3+1kuasxVPHsPrMp3Zt0AbS7ROSGpZQDmtokOkc7NAt0XFRPPbjt2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F6Z-7Y; Fri, 17 Feb 2023 04:42:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 09/18] net: genet: Fixup EEE
Date:   Fri, 17 Feb 2023 04:42:21 +0100
Message-Id: <20230217034230.1249661-10-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230217034230.1249661-1-andrew@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enabling/disabling of EEE in the MAC should happen as a result of
auto negotiation. So move the enable/disable into bcmgenet_mii_setup()
which gets called by phylib when there is a change in link status.

bcmgenet_set_eee() now just writes the LTI timer value to the hardware
and stores if TX LPI should be enabled. Everything else is passed to
phylib, so it can correctly setup the PHY.

bcmgenet_get_eee() relies on phylib doing most of the work, the MAC
driver just adds the LTI timer value from hardware and the stored
tx_lpi_enabled.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 31 ++++++-------------
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c  |  1 +
 3 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d937daa8ee88..2793d94ed32c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1272,12 +1272,17 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
-static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
+void bcmgenet_eee_enable_set(struct net_device *dev, bool eee_active)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	u32 off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
+	struct ethtool_eee *p = &priv->eee;
+	bool enable;
+	u32 off;
 	u32 reg;
 
+	off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
+	enable = eee_active && p->tx_lpi_enabled;
+
 	if (enable && !priv->clk_eee_enabled) {
 		clk_prepare_enable(priv->clk_eee);
 		priv->clk_eee_enabled = true;
@@ -1310,9 +1315,6 @@ static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
 		clk_disable_unprepare(priv->clk_eee);
 		priv->clk_eee_enabled = false;
 	}
-
-	priv->eee.eee_enabled = enable;
-	priv->eee.eee_active = enable;
 }
 
 static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
@@ -1326,8 +1328,7 @@ static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
 	if (!dev->phydev)
 		return -ENODEV;
 
-	e->eee_enabled = p->eee_enabled;
-	e->eee_active = p->eee_active;
+	e->tx_lpi_enabled = p->tx_lpi_enabled;
 	e->tx_lpi_timer = bcmgenet_umac_readl(priv, UMAC_EEE_LPI_TIMER);
 
 	return phy_ethtool_get_eee(dev->phydev, e);
@@ -1337,7 +1338,6 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct ethtool_eee *p = &priv->eee;
-	int ret = 0;
 
 	if (GENET_IS_V1(priv))
 		return -EOPNOTSUPP;
@@ -1345,20 +1345,9 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
 	if (!dev->phydev)
 		return -ENODEV;
 
-	p->eee_enabled = e->eee_enabled;
+	p->tx_lpi_enabled = e->tx_lpi_enabled;
 
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
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 946f6e283c4e..7458a62afc2c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -703,4 +703,5 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 			       enum bcmgenet_power_mode mode);
 
+void bcmgenet_eee_enable_set(struct net_device *dev, bool eee_active);
 #endif /* __BCMGENET_H__ */
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index b615176338b2..eb1747503c2e 100644
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
2.39.1


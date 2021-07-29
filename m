Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAC63DB009
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 01:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhG2Xvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 19:51:55 -0400
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:45804 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbhG2Xvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 19:51:54 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jul 2021 19:51:54 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=7288; q=dns/txt; s=iport;
  t=1627602710; x=1628812310;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/Ap9mbPXpL2l+I0gCWzJlCwjSQrqoLRXRbu/ViyjT8A=;
  b=YAwUwPJX+8Zvr6umXiDLN/gmM+2vp82QcP8yiKABunvdzTtW+ZfZOMPT
   w99HAr19Nj2WW34DL+488VJagL0+/oHGNQ1A+MKglhcTONDT0kIwlS/di
   UsQswd6EbpxWUcbouQfOSuEe4Rz8o58OzRruDajfKOrU9S05ceDGgrowH
   s=;
X-IronPort-AV: E=Sophos;i="5.84,280,1620691200"; 
   d="scan'208";a="899786753"
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 29 Jul 2021 23:44:44 +0000
Received: from zorba.cisco.com ([10.24.25.127])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTP id 16TNihvU032246;
        Thu, 29 Jul 2021 23:44:43 GMT
From:   Daniel Walker <danielwa@cisco.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Balamurugan Selvarajan <balamsel@cisco.com>,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC-PATCH] net: stmmac: Add KR port support.
Date:   Thu, 29 Jul 2021 16:44:42 -0700
Message-Id: <20210729234443.1713722-1-danielwa@cisco.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.24.25.127, [10.24.25.127]
X-Outbound-Node: rcdn-core-6.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Balamurugan Selvarajan <balamsel@cisco.com>

For KR port the mii interface is a chip-to-chip
interface without a mechanical connector. So PHY
inits are not applicable. In this case MAC is
configured to operate at forced speed(1000Mbps)
and full duplex. Modified driver to accommodate
PHY and NON-PHY mode.

Cc: xe-linux-external@cisco.com
Signed-off-by: Balamurugan Selvarajan <balamsel@cisco.com>
Signed-off-by: Daniel Walker <danielwa@cisco.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  2 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 89 +++++++++++++------
 2 files changed, 65 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 5fecc83f175b..6458ce5ec0bd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -435,6 +435,8 @@ struct dma_features {
 #define MAC_CTRL_REG		0x00000000	/* MAC Control */
 #define MAC_ENABLE_TX		0x00000008	/* Transmitter Enable */
 #define MAC_ENABLE_RX		0x00000004	/* Receiver Enable */
+#define MAC_FULL_DUPLEX		0x00000800
+#define MAC_PORT_SELECT		0x00008000
 
 /* Default LPI timers */
 #define STMMAC_DEFAULT_LIT_LS	0x3E8
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7b8404a21544..0b31aae65f3a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3212,6 +3212,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	bool sph_en;
 	u32 chan;
 	int ret;
+	int speed;
 
 	/* DMA initialization and SW reset */
 	ret = stmmac_init_dma_engine(priv);
@@ -3226,7 +3227,9 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 
 	/* PS and related bits will be programmed according to the speed */
 	if (priv->hw->pcs) {
-		int speed = priv->plat->mac_port_sel_speed;
+		speed = priv->plat->mac_port_sel_speed;
+		if (priv->plat->phy_interface == PHY_INTERFACE_MODE_NA)
+			speed = SPEED_1000;
 
 		if ((speed == SPEED_10) || (speed == SPEED_100) ||
 		    (speed == SPEED_1000)) {
@@ -3256,6 +3259,17 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	/* Enable the MAC Rx/Tx */
 	stmmac_mac_set(priv, priv->ioaddr, true);
 
+	if (priv->plat->phy_interface == PHY_INTERFACE_MODE_NA) {
+		/*
+		 * Force MAC PORT SPEED to 1000Mbps and Full Duplex.
+		 */
+		u32 ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
+		ctrl |= MAC_FULL_DUPLEX;
+		ctrl &= ~(MAC_PORT_SELECT);
+		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+	}
+
+
 	/* Set the HW DMA mode and the COE */
 	stmmac_dma_operation_mode(priv);
 
@@ -3291,8 +3305,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 		}
 	}
 
-	if (priv->hw->pcs)
-		stmmac_pcs_ctrl_ane(priv, priv->ioaddr, 1, priv->hw->ps, 0);
+	if (priv->hw->pcs) {
+		if (priv->plat->phy_interface != PHY_INTERFACE_MODE_NA) {
+			stmmac_pcs_ctrl_ane(priv, priv->ioaddr, 1, priv->hw->ps, 0);
+		} else {
+			/* Disable Autoneg */
+			writel(0x0, priv->ioaddr + GMAC_PCS_BASE);
+		}
+	}
 
 	/* set TX and RX rings length */
 	stmmac_set_rings_length(priv);
@@ -3644,12 +3664,14 @@ int stmmac_open(struct net_device *dev)
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
 	    (!priv->hw->xpcs ||
 	     xpcs_get_an_mode(priv->hw->xpcs, mode) != DW_AN_C73)) {
-		ret = stmmac_init_phy(dev);
-		if (ret) {
-			netdev_err(priv->dev,
-				   "%s: Cannot attach to PHY (error: %d)\n",
-				   __func__, ret);
-			goto init_phy_error;
+		if (priv->plat->phy_interface != PHY_INTERFACE_MODE_NA) {
+			ret = stmmac_init_phy(dev);
+			if (ret) {
+				netdev_err(priv->dev,
+					   "%s: Cannot attach to PHY (error: %d)\n",
+					   __func__, ret);
+				goto init_phy_error;
+			}
 		}
 	}
 
@@ -3705,7 +3727,8 @@ int stmmac_open(struct net_device *dev)
 
 	stmmac_init_coalesce(priv);
 
-	phylink_start(priv->phylink);
+	if (priv->plat->phy_interface != PHY_INTERFACE_MODE_NA)
+		phylink_start(priv->phylink);
 	/* We may have called phylink_speed_down before */
 	phylink_speed_up(priv->phylink);
 
@@ -3716,10 +3739,14 @@ int stmmac_open(struct net_device *dev)
 	stmmac_enable_all_queues(priv);
 	netif_tx_start_all_queues(priv->dev);
 
+	if (priv->plat->phy_interface == PHY_INTERFACE_MODE_NA)
+		netif_carrier_on(dev);
+
 	return 0;
 
 irq_error:
-	phylink_stop(priv->phylink);
+	if (priv->plat->phy_interface != PHY_INTERFACE_MODE_NA)
+		phylink_stop(priv->phylink);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
@@ -3728,7 +3755,8 @@ int stmmac_open(struct net_device *dev)
 init_error:
 	free_dma_desc_resources(priv);
 dma_desc_error:
-	phylink_disconnect_phy(priv->phylink);
+	if (priv->plat->phy_interface != PHY_INTERFACE_MODE_NA)
+		phylink_disconnect_phy(priv->phylink);
 init_phy_error:
 	pm_runtime_put(priv->device);
 	return ret;
@@ -3758,8 +3786,10 @@ int stmmac_release(struct net_device *dev)
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
-	phylink_stop(priv->phylink);
-	phylink_disconnect_phy(priv->phylink);
+	if (priv->plat->phy_interface != PHY_INTERFACE_MODE_NA) {
+		phylink_stop(priv->phylink);
+		phylink_disconnect_phy(priv->phylink);
+	}
 
 	stmmac_disable_all_queues(priv);
 
@@ -6986,12 +7016,15 @@ int stmmac_dvr_probe(struct device *device,
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
 		/* MDIO bus Registration */
-		ret = stmmac_mdio_register(ndev);
-		if (ret < 0) {
-			dev_err(priv->device,
-				"%s: MDIO bus (id: %d) registration failed",
-				__func__, priv->plat->bus_id);
-			goto error_mdio_register;
+
+		if (priv->plat->phy_interface != PHY_INTERFACE_MODE_NA) {
+			ret = stmmac_mdio_register(ndev);
+			if (ret < 0) {
+				dev_err(priv->device,
+					"%s: MDIO bus (id: %d) registration failed",
+					__func__, priv->plat->bus_id);
+				goto error_mdio_register;
+			}
 		}
 	}
 
@@ -7004,10 +7037,12 @@ int stmmac_dvr_probe(struct device *device,
 			goto error_xpcs_setup;
 	}
 
-	ret = stmmac_phy_setup(priv);
-	if (ret) {
-		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
-		goto error_phy_setup;
+	if (priv->plat->phy_interface != PHY_INTERFACE_MODE_NA) {
+		ret = stmmac_phy_setup(priv);
+		if (ret) {
+			netdev_err(ndev, "failed to setup phy (%d)\n", ret);
+			goto error_phy_setup;
+		}
 	}
 
 	ret = register_netdev(ndev);
@@ -7039,11 +7074,13 @@ int stmmac_dvr_probe(struct device *device,
 error_serdes_powerup:
 	unregister_netdev(ndev);
 error_netdev_register:
-	phylink_destroy(priv->phylink);
+	if (priv->plat->phy_interface != PHY_INTERFACE_MODE_NA)
+		phylink_destroy(priv->phylink);
 error_xpcs_setup:
 error_phy_setup:
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
-	    priv->hw->pcs != STMMAC_PCS_RTBI)
+	    priv->hw->pcs != STMMAC_PCS_RTBI &&
+	    priv->plat->phy_interface != PHY_INTERFACE_MODE_NA)
 		stmmac_mdio_unregister(ndev);
 error_mdio_register:
 	stmmac_napi_del(ndev);
-- 
2.25.1


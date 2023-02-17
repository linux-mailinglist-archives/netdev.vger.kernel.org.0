Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6309F69A485
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjBQDnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjBQDm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1235B1630A
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ARW6GOF5TfQOrkWA0JF4PugCqoKViikleVVTg3syvS4=; b=SLifKbAUNJxJYaumuaxGUI8/DK
        8qz3ik4zPnNse9bMN4g2TgsykfbGz+j3zSdi7FIjUI7QV4rfiPiQb/jwshOJ5g/L9LC8gXmA/jlIE
        2olUruRctuJLwGDICIUdQm5UfRzSbdepYtxZ3cg4FoePC2Mmv+e+ypoGjkIpSDEPbH5g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F6d-92; Fri, 17 Feb 2023 04:42:44 +0100
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
Subject: [PATCH RFC 10/18] net: sxgdb: Fixup EEE
Date:   Fri, 17 Feb 2023 04:42:22 +0100
Message-Id: <20230217034230.1249661-11-andrew@lunn.ch>
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
auto negotiation. So rework sxgbe_eee_adjust() to take the result of
negotiation into account.

sxgbe_set_eee() now just stores LTI timer value and
tx_lpi_enabled. Everything else is passed to phylib, so it can
correctly setup the PHY.

sxgbe_get_eee() relies on phylib doing most of the work, the MAC
driver just adds the LTI timer value and tx_lpi_enabled.

The hw_cap.eee is now used to control timers, rather than eee_enabled,
which was wrongly being set based on the value of phy_init_eee()
before auto-neg even completed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 .../net/ethernet/samsung/sxgbe/sxgbe_common.h |  4 +-
 .../ethernet/samsung/sxgbe/sxgbe_ethtool.c    | 23 ++----------
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   | 37 ++++++-------------
 3 files changed, 16 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
index 0f45107db8dd..6860369ca88f 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
@@ -502,9 +502,8 @@ struct sxgbe_priv_data {
 	struct timer_list eee_ctrl_timer;
 	bool tx_path_in_lpi_mode;
 	int lpi_irq;
-	int eee_enabled;
-	int eee_active;
 	int tx_lpi_timer;
+	bool tx_lpi_enabled;
 };
 
 /* Function prototypes */
@@ -528,5 +527,4 @@ int sxgbe_restore(struct net_device *ndev);
 const struct sxgbe_mtl_ops *sxgbe_get_mtl_ops(void);
 
 void sxgbe_disable_eee_mode(struct sxgbe_priv_data * const priv);
-bool sxgbe_eee_init(struct sxgbe_priv_data * const priv);
 #endif /* __SXGBE_COMMON_H__ */
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
index 8ba017ec9849..0ec523b24df9 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
@@ -140,8 +140,7 @@ static int sxgbe_get_eee(struct net_device *dev,
 	if (!priv->hw_cap.eee)
 		return -EOPNOTSUPP;
 
-	edata->eee_enabled = priv->eee_enabled;
-	edata->eee_active = priv->eee_active;
+	edata->tx_lpi_enabled = priv->tx_lpi_enabled;
 	edata->tx_lpi_timer = priv->tx_lpi_timer;
 
 	return phy_ethtool_get_eee(dev->phydev, edata);
@@ -152,22 +151,8 @@ static int sxgbe_set_eee(struct net_device *dev,
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 
-	priv->eee_enabled = edata->eee_enabled;
-
-	if (!priv->eee_enabled) {
-		sxgbe_disable_eee_mode(priv);
-	} else {
-		/* We are asking for enabling the EEE but it is safe
-		 * to verify all by invoking the eee_init function.
-		 * In case of failure it will return an error.
-		 */
-		priv->eee_enabled = sxgbe_eee_init(priv);
-		if (!priv->eee_enabled)
-			return -EOPNOTSUPP;
-
-		/* Do not change tx_lpi_timer in case of failure */
-		priv->tx_lpi_timer = edata->tx_lpi_timer;
-	}
+	priv->tx_lpi_timer = edata->tx_lpi_timer;
+	priv->tx_lpi_enabled = edata->tx_lpi_enabled;
 
 	return phy_ethtool_set_eee(dev->phydev, edata);
 }
@@ -230,7 +215,7 @@ static void sxgbe_get_ethtool_stats(struct net_device *dev,
 	int i;
 	char *p;
 
-	if (priv->eee_enabled) {
+	if (dev->phydev->eee_active) {
 		int val = phy_get_eee_err(dev->phydev);
 
 		if (val)
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 9664f029fa16..f9ad232133a4 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -119,18 +119,10 @@ static void sxgbe_eee_ctrl_timer(struct timer_list *t)
  *  phy can also manage EEE, so enable the LPI state and start the timer
  *  to verify if the tx path can enter in LPI state.
  */
-bool sxgbe_eee_init(struct sxgbe_priv_data * const priv)
+static void sxgbe_eee_init(struct sxgbe_priv_data * const priv)
 {
-	struct net_device *ndev = priv->dev;
-	bool ret = false;
-
 	/* MAC core supports the EEE feature. */
 	if (priv->hw_cap.eee) {
-		/* Check if the PHY supports EEE */
-		if (phy_init_eee(ndev->phydev, true))
-			return false;
-
-		priv->eee_active = 1;
 		timer_setup(&priv->eee_ctrl_timer, sxgbe_eee_ctrl_timer, 0);
 		priv->eee_ctrl_timer.expires = SXGBE_LPI_TIMER(eee_timer);
 		add_timer(&priv->eee_ctrl_timer);
@@ -140,23 +132,16 @@ bool sxgbe_eee_init(struct sxgbe_priv_data * const priv)
 					     priv->tx_lpi_timer);
 
 		pr_info("Energy-Efficient Ethernet initialized\n");
-
-		ret = true;
 	}
-
-	return ret;
 }
 
-static void sxgbe_eee_adjust(const struct sxgbe_priv_data *priv)
+static void sxgbe_eee_adjust(const struct sxgbe_priv_data *priv,
+			     bool eee_active)
 {
-	struct net_device *ndev = priv->dev;
-
-	/* When the EEE has been already initialised we have to
-	 * modify the PLS bit in the LPI ctrl & status reg according
-	 * to the PHY link status. For this reason.
-	 */
-	if (priv->eee_enabled)
-		priv->hw->mac->set_eee_pls(priv->ioaddr, ndev->phydev->link);
+	if (priv->hw_cap.eee)
+		priv->hw->mac->set_eee_pls(priv->ioaddr,
+					   eee_active && priv->tx_lpi_enabled);
+	phy_eee_clk_stop_enable(priv->dev->phydev);
 }
 
 /**
@@ -250,7 +235,7 @@ static void sxgbe_adjust_link(struct net_device *dev)
 		phy_print_status(phydev);
 
 	/* Alter the MAC settings for EEE */
-	sxgbe_eee_adjust(priv);
+	sxgbe_eee_adjust(priv, phydev->eee_active);
 }
 
 /**
@@ -803,7 +788,7 @@ static void sxgbe_tx_all_clean(struct sxgbe_priv_data * const priv)
 		sxgbe_tx_queue_clean(tqueue);
 	}
 
-	if ((priv->eee_enabled) && (!priv->tx_path_in_lpi_mode)) {
+	if (priv->hw_cap.eee && !priv->tx_path_in_lpi_mode) {
 		sxgbe_enable_eee_mode(priv);
 		mod_timer(&priv->eee_ctrl_timer, SXGBE_LPI_TIMER(eee_timer));
 	}
@@ -1181,7 +1166,7 @@ static int sxgbe_open(struct net_device *dev)
 	}
 
 	priv->tx_lpi_timer = SXGBE_DEFAULT_LPI_TIMER;
-	priv->eee_enabled = sxgbe_eee_init(priv);
+	sxgbe_eee_init(priv);
 
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
@@ -1208,7 +1193,7 @@ static int sxgbe_release(struct net_device *dev)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 
-	if (priv->eee_enabled)
+	if (priv->hw_cap.eee)
 		del_timer_sync(&priv->eee_ctrl_timer);
 
 	/* Stop and disconnect the PHY */
-- 
2.39.1


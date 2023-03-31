Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1526D1468
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCaAzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCaAzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319B4FF2F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zMnNz2bNP9Kii6W3Q1KSVFWIPvSi1Jj5giEJItJf5cM=; b=xTLXvTMB6MiIzX1h89ZjXjnMZ/
        JXSMHQgXsIf6SimXzuHZXRn4dMZFrF2/wfSSO4eLrIBYZeDc5fsIHdYMMHkXWphxgY7YfC/Gbd+5x
        0dJgWuVpmEAu0ZiXIoE6rcYfWTDWjXvKToiWwq/7gALMnn87NVRDt97O/w68feGMggGM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xKz-Pf; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 14/24] net: sxgdb: Fixup EEE
Date:   Fri, 31 Mar 2023 02:55:08 +0200
Message-Id: <20230331005518.2134652-15-andrew@lunn.ch>
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
auto negotiation. So rework sxgbe_eee_adjust() to take the result of
negotiation into account.

sxgbe_set_eee() now just stores LTI timer value. Everything else is
passed to phylib, so it can correctly setup the PHY.

sxgbe_get_eee() relies on phylib doing most of the work, the MAC
driver just adds the LTI timer value.

The hw_cap.eee is now used to control timers, rather than eee_enabled,
which was wrongly being set based on the value of phy_init_eee()
before auto-neg even completed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 .../net/ethernet/samsung/sxgbe/sxgbe_common.h |  3 --
 .../ethernet/samsung/sxgbe/sxgbe_ethtool.c    | 21 ++---------
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   | 36 ++++++-------------
 3 files changed, 12 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
index 0f45107db8dd..c25588b90a13 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
@@ -502,8 +502,6 @@ struct sxgbe_priv_data {
 	struct timer_list eee_ctrl_timer;
 	bool tx_path_in_lpi_mode;
 	int lpi_irq;
-	int eee_enabled;
-	int eee_active;
 	int tx_lpi_timer;
 };
 
@@ -528,5 +526,4 @@ int sxgbe_restore(struct net_device *ndev);
 const struct sxgbe_mtl_ops *sxgbe_get_mtl_ops(void);
 
 void sxgbe_disable_eee_mode(struct sxgbe_priv_data * const priv);
-bool sxgbe_eee_init(struct sxgbe_priv_data * const priv);
 #endif /* __SXGBE_COMMON_H__ */
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
index 8ba017ec9849..e7128864a3ef 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
@@ -140,8 +140,6 @@ static int sxgbe_get_eee(struct net_device *dev,
 	if (!priv->hw_cap.eee)
 		return -EOPNOTSUPP;
 
-	edata->eee_enabled = priv->eee_enabled;
-	edata->eee_active = priv->eee_active;
 	edata->tx_lpi_timer = priv->tx_lpi_timer;
 
 	return phy_ethtool_get_eee(dev->phydev, edata);
@@ -152,22 +150,7 @@ static int sxgbe_set_eee(struct net_device *dev,
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
 
 	return phy_ethtool_set_eee(dev->phydev, edata);
 }
@@ -230,7 +213,7 @@ static void sxgbe_get_ethtool_stats(struct net_device *dev,
 	int i;
 	char *p;
 
-	if (priv->eee_enabled) {
+	if (dev->phydev->eee_active) {
 		int val = phy_get_eee_err(dev->phydev);
 
 		if (val)
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 9664f029fa16..cf549a524674 100644
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
@@ -140,23 +132,15 @@ bool sxgbe_eee_init(struct sxgbe_priv_data * const priv)
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
+		priv->hw->mac->set_eee_pls(priv->ioaddr, eee_active);
+	phy_eee_clk_stop_enable(priv->dev->phydev);
 }
 
 /**
@@ -250,7 +234,7 @@ static void sxgbe_adjust_link(struct net_device *dev)
 		phy_print_status(phydev);
 
 	/* Alter the MAC settings for EEE */
-	sxgbe_eee_adjust(priv);
+	sxgbe_eee_adjust(priv, phydev->eee_active);
 }
 
 /**
@@ -803,7 +787,7 @@ static void sxgbe_tx_all_clean(struct sxgbe_priv_data * const priv)
 		sxgbe_tx_queue_clean(tqueue);
 	}
 
-	if ((priv->eee_enabled) && (!priv->tx_path_in_lpi_mode)) {
+	if (priv->hw_cap.eee && !priv->tx_path_in_lpi_mode) {
 		sxgbe_enable_eee_mode(priv);
 		mod_timer(&priv->eee_ctrl_timer, SXGBE_LPI_TIMER(eee_timer));
 	}
@@ -1181,7 +1165,7 @@ static int sxgbe_open(struct net_device *dev)
 	}
 
 	priv->tx_lpi_timer = SXGBE_DEFAULT_LPI_TIMER;
-	priv->eee_enabled = sxgbe_eee_init(priv);
+	sxgbe_eee_init(priv);
 
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
@@ -1208,7 +1192,7 @@ static int sxgbe_release(struct net_device *dev)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 
-	if (priv->eee_enabled)
+	if (priv->hw_cap.eee)
 		del_timer_sync(&priv->eee_ctrl_timer);
 
 	/* Stop and disconnect the PHY */
-- 
2.40.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316774185F1
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 05:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhIZDXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 23:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhIZDXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 23:23:16 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723FDC061714;
        Sat, 25 Sep 2021 20:21:41 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h3so14193584pgb.7;
        Sat, 25 Sep 2021 20:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W+gjZ7DIM9qIoqsNh7P6QbYmL99Dx4SZ04LaWgjboGM=;
        b=ogfKjn6oaRBFj59/jYlvOHn/F3mFr9jPVAPp8OmbEKEucunSZX4D2h7xxJrvNXiYzr
         64kvDzJ8dU0gNDU1AYD6esFgDh+rigJ2gnsYpllkFUk5CGGhhAywzwJVxnwxxA+rAJyW
         FhCkM4skIyMKMzSU2fPEnMvHTj1UIE77iOxSZ+kcVxS/iskkJm3326K3eWKE0dMSvt8E
         9gWGMC2oB8zza2PXUDUJqLhy7xbFKIcXE7Pp4e2mnVGRlzSr1IM7UXqKsKWimDYhJQ7p
         UU8Bei4mhyYPfZEjjwzvf2ZVLX5FR6fdzDIxz6IniQoIXVZ/A3Skpom8tSfS1fMKILdS
         P7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W+gjZ7DIM9qIoqsNh7P6QbYmL99Dx4SZ04LaWgjboGM=;
        b=qTwPdSzcRFDHUGCm6ziBfwCadjnwj82umuW/0psUEpJnytR5yLTW2W9TMeis0pD9CV
         RkrxQMwZJnEGutTuxTaAQqJUlCMgNvKNG2YL8wF6R+TEArMXYthdcQPQbEVgQbWy4y8o
         x0olyYzp+Mp7gDMaSC9NocSc1ZePl99aJxfTS8809KLRZcDO2OkkgODxgTB4UZMEit6L
         JMFXs+2ekSVdzjF2PwktQnzR3FqfHzRSh5dSwBHcMuQbSFXqoIBNQ6eQBmlygA0L8q73
         hfsh9uK/JDGJTlWDeTYVQKdnSuVTl+d5xFmwVUZxz8pj3ZCQHZPa0MgEiKepRXwq/ks+
         nE2Q==
X-Gm-Message-State: AOAM530cM4Quq7DGuK6k4QyON3cXS/xg9iUxdHOgzg1KZFGcLSpr/cI8
        MUgMrwvv3/9uN4bfYZW4UU+Ba0S96a8=
X-Google-Smtp-Source: ABdhPJyD3KYoaJxSPBtZRTNViWtBg0A4DxjbZBFZD0ACaJAG7OLsmyheYe5gtRQrscnLPzjuXJ2bXw==
X-Received: by 2002:aa7:9e49:0:b0:44b:2a06:715e with SMTP id z9-20020aa79e49000000b0044b2a06715emr17070447pfq.78.1632626500615;
        Sat, 25 Sep 2021 20:21:40 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r13sm14205312pgl.90.2021.09.25.20.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 20:21:40 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 4/4] net: bcmgenet: add support for ethtool flow control
Date:   Sat, 25 Sep 2021 20:21:14 -0700
Message-Id: <20210926032114.1785872-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210926032114.1785872-1-f.fainelli@gmail.com>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

This commit extends the supported ethtool operations to allow MAC
level flow control to be configured for the bcmgenet driver.

The ethtool utility can be used to change the configuration of
auto-negotiated symmetric and asymmetric modes as well as manually
configuring support for RX and TX Pause frames individually.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 51 +++++++++++++++++++
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  4 ++
 drivers/net/ethernet/broadcom/genet/bcmmii.c  | 44 +++++++++++++---
 3 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 3427f9ed7eb9..6a8234bc9428 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -935,6 +935,48 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
 	return 0;
 }
 
+static void bcmgenet_get_pauseparam(struct net_device *dev,
+				    struct ethtool_pauseparam *epause)
+{
+	struct bcmgenet_priv *priv;
+	u32 umac_cmd;
+
+	priv = netdev_priv(dev);
+
+	epause->autoneg = priv->autoneg_pause;
+
+	if (netif_carrier_ok(dev)) {
+		/* report active state when link is up */
+		umac_cmd = bcmgenet_umac_readl(priv, UMAC_CMD);
+		epause->tx_pause = !(umac_cmd & CMD_TX_PAUSE_IGNORE);
+		epause->rx_pause = !(umac_cmd & CMD_RX_PAUSE_IGNORE);
+	} else {
+		/* otherwise report stored settings */
+		epause->tx_pause = priv->tx_pause;
+		epause->rx_pause = priv->rx_pause;
+	}
+}
+
+static int bcmgenet_set_pauseparam(struct net_device *dev,
+				   struct ethtool_pauseparam *epause)
+{
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+
+	if (!dev->phydev)
+		return -ENODEV;
+
+	if (!phy_validate_pause(dev->phydev, epause))
+		return -EINVAL;
+
+	priv->autoneg_pause = !!epause->autoneg;
+	priv->tx_pause = !!epause->tx_pause;
+	priv->rx_pause = !!epause->rx_pause;
+
+	bcmgenet_phy_pause_set(dev, priv->rx_pause, priv->tx_pause);
+
+	return 0;
+}
+
 /* standard ethtool support functions. */
 enum bcmgenet_stat_type {
 	BCMGENET_STAT_NETDEV = -1,
@@ -1587,6 +1629,8 @@ static const struct ethtool_ops bcmgenet_ethtool_ops = {
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_rxnfc		= bcmgenet_get_rxnfc,
 	.set_rxnfc		= bcmgenet_set_rxnfc,
+	.get_pauseparam		= bcmgenet_get_pauseparam,
+	.set_pauseparam		= bcmgenet_set_pauseparam,
 };
 
 /* Power down the unimac, based on mode. */
@@ -3364,6 +3408,8 @@ static int bcmgenet_open(struct net_device *dev)
 		goto err_irq1;
 	}
 
+	bcmgenet_phy_pause_set(dev, priv->rx_pause, priv->tx_pause);
+
 	bcmgenet_netif_start(dev);
 
 	netif_tx_start_all_queues(dev);
@@ -3945,6 +3991,11 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	spin_lock_init(&priv->lock);
 
+	/* Set default pause parameters */
+	priv->autoneg_pause = 1;
+	priv->tx_pause = 1;
+	priv->rx_pause = 1;
+
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	dev_set_drvdata(&pdev->dev, dev);
 	dev->watchdog_timeo = 2 * HZ;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 406249bc9fe5..1cc2838e52c6 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -594,6 +594,9 @@ struct bcmgenet_priv {
 
 	/* other misc variables */
 	struct bcmgenet_hw_params *hw_params;
+	unsigned autoneg_pause:1;
+	unsigned tx_pause:1;
+	unsigned rx_pause:1;
 
 	/* MDIO bus variables */
 	wait_queue_head_t wq;
@@ -686,6 +689,7 @@ int bcmgenet_mii_init(struct net_device *dev);
 int bcmgenet_mii_config(struct net_device *dev, bool init);
 int bcmgenet_mii_probe(struct net_device *dev);
 void bcmgenet_mii_exit(struct net_device *dev);
+void bcmgenet_phy_pause_set(struct net_device *dev, bool rx, bool tx);
 void bcmgenet_phy_power_set(struct net_device *dev, bool enable);
 void bcmgenet_mii_setup(struct net_device *dev);
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 789ca6212817..ad56f54eda0a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -41,12 +41,29 @@ static void bcmgenet_mac_config(struct net_device *dev)
 	cmd_bits <<= CMD_SPEED_SHIFT;
 
 	/* duplex */
-	if (phydev->duplex != DUPLEX_FULL)
-		cmd_bits |= CMD_HD_EN;
+	if (phydev->duplex != DUPLEX_FULL) {
+		cmd_bits |= CMD_HD_EN |
+			CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
+	} else {
+		/* pause capability defaults to Symmetric */
+		if (priv->autoneg_pause) {
+			bool tx_pause = 0, rx_pause = 0;
+
+			if (phydev->autoneg)
+				phy_get_pause(phydev, &tx_pause, &rx_pause);
 
-	/* pause capability */
-	if (!phydev->pause)
-		cmd_bits |= CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
+			if (!tx_pause)
+				cmd_bits |= CMD_TX_PAUSE_IGNORE;
+			if (!rx_pause)
+				cmd_bits |= CMD_RX_PAUSE_IGNORE;
+		}
+
+		/* Manual override */
+		if (!priv->rx_pause)
+			cmd_bits |= CMD_RX_PAUSE_IGNORE;
+		if (!priv->tx_pause)
+			cmd_bits |= CMD_TX_PAUSE_IGNORE;
+	}
 
 	/* Program UMAC and RGMII block based on established
 	 * link speed, duplex, and pause. The speed set in
@@ -101,6 +118,21 @@ static int bcmgenet_fixed_phy_link_update(struct net_device *dev,
 	return 0;
 }
 
+void bcmgenet_phy_pause_set(struct net_device *dev, bool rx, bool tx)
+{
+	struct phy_device *phydev = dev->phydev;
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising, rx);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising,
+			 rx | tx);
+	phy_start_aneg(phydev);
+
+	mutex_lock(&phydev->lock);
+	if (phydev->link)
+		bcmgenet_mac_config(dev);
+	mutex_unlock(&phydev->lock);
+}
+
 void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -351,8 +383,6 @@ int bcmgenet_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
-	linkmode_copy(phydev->advertising, phydev->supported);
-
 	/* The internal PHY has its link interrupts routed to the
 	 * Ethernet MAC ISRs. On GENETv5 there is a hardware issue
 	 * that prevents the signaling of link UP interrupts when
-- 
2.25.1


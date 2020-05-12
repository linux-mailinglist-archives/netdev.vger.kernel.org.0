Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA061CE99A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgELAYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728364AbgELAYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:24:47 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598B5C061A0C;
        Mon, 11 May 2020 17:24:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f23so4657390pgj.4;
        Mon, 11 May 2020 17:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J9kUQB+k3+XGjn0wMeufDmZ4vC8oUJ+gakCH9JxrVOk=;
        b=o+Til2CM6RkUeHHEqfcr5aAF5HLW2tagWHn4QnOlGliB34dPqwjXyxtRJvdNUyvpuF
         VkhMUSIChLuSbgXT67jvrzurZwS7uWcHHKCwJ8G0VfkVS1tOUgj9RF72WERM0cfY/nJR
         h136YoF2Dn4TeWT6IlJHR6+EeJoA1b47/LL8ikF+6rGJfmznGlCh+6A2kfVP/N990xxI
         t+Jr7tol0Jk710udRRYJoPJe0x8bCBSl5vjKNKVxQl/o5Ro5nGgYTDoJ+q07nCqtrbk0
         XBhdAxHKCHzo3DhKzWzNHTXTIpJl0Np2s/uC05IW4sbyEHZ7SjlVPvR+AVinmStS/GL9
         8+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J9kUQB+k3+XGjn0wMeufDmZ4vC8oUJ+gakCH9JxrVOk=;
        b=aJhf0irhSNBSchjWIQ/SJtZrZZR8pLat2I9J8pa4T3/4F5V8DWIO/8cKfLE6I4rfa5
         mMDYkVyXb+b41xYQjjxSjoH3yUb2amy1qPMqJsp2lV81NYgOYJ2DA0jXaV6A4NCELk8/
         XggGUslHg+wNDDVcv0ed7O5yLsVi+orelKUOJIQ9Kr2tWJW0FpYKbgmr5uYmG1r36jVe
         0HYLbo1+aHqbGDTl6b5izpi97V5oYHX2km+eHDCf9IzzTXNuRrmH2xBMQwO4+1Uuixnq
         7lTed7L/JPJ/PG3ivCORGe30O5TgbN9QJL5Xf6TaGOCIxgllaUuX1M6XU0AeSA1KQAZP
         DmEA==
X-Gm-Message-State: AGi0PuaHPaS3KCJZu0HugQ5YT+ey8IUBzwIwCjR1W+Jrpp3qzM8UkoY8
        AKpV835IzxvzfRw5x9xEnkg=
X-Google-Smtp-Source: APiQypLYCtEhleqQxhCPmoB/c7KjyU4fPXcwT2ryIV457yB3xk1gEJF217VqJNcZRLXdredWSQOQ2A==
X-Received: by 2002:a63:a101:: with SMTP id b1mr17151238pgf.292.1589243086886;
        Mon, 11 May 2020 17:24:46 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 23sm9062112pgm.18.2020.05.11.17.24.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:24:46 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 4/4] net: bcmgenet: add support for ethtool flow control
Date:   Mon, 11 May 2020 17:24:10 -0700
Message-Id: <1589243050-18217-5-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit extends the supported ethtool operations to allow MAC
level flow control to be configured for the bcmgenet driver. It
provides an example of how the new phy_set_pause function and the
phy_validate_pause function can be used to configure the desired
PHY advertising as well as how the phy_get_pause function can be
used for resolving negotiated pause modes which may be overridden
by the MAC.

The ethtool utility can be used to change the configuration to enable
auto-negotiated symmetric and asymmetric modes as well as manually
enabling support for RX and TX Pause frames individually.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 54 ++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |  4 ++
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 38 ++++++++++++++----
 3 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ff31da0ed846..c0e22da7ac53 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1017,6 +1017,53 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
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
+	if (priv->old_link > 0) {
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
+	/* Restart the PHY */
+	if (netif_running(dev))
+		priv->old_link = -1;
+
+	phy_set_pause(dev->phydev, priv->rx_pause, priv->tx_pause,
+		      priv->autoneg_pause);
+
+	return 0;
+}
+
 /* standard ethtool support functions. */
 enum bcmgenet_stat_type {
 	BCMGENET_STAT_NETDEV = -1,
@@ -1670,6 +1717,8 @@ static const struct ethtool_ops bcmgenet_ethtool_ops = {
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_rxnfc		= bcmgenet_get_rxnfc,
 	.set_rxnfc		= bcmgenet_set_rxnfc,
+	.get_pauseparam		= bcmgenet_get_pauseparam,
+	.set_pauseparam		= bcmgenet_set_pauseparam,
 };
 
 /* Power down the unimac, based on mode. */
@@ -4018,6 +4067,11 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
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
index a12cb59298f4..e44830b3aa4a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -683,6 +683,10 @@ struct bcmgenet_priv {
 	/* HW descriptors/checksum variables */
 	bool crc_fwd_en;
 
+	unsigned autoneg_pause:1;
+	unsigned tx_pause:1;
+	unsigned rx_pause:1;
+
 	u32 dma_max_burst_length;
 
 	u32 msg_enable;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 511d553a4d11..788da1ecea0c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -25,6 +25,21 @@
 
 #include "bcmgenet.h"
 
+static u32 _flow_control_autoneg(struct phy_device *phydev)
+{
+	bool tx_pause, rx_pause;
+	u32 cmd_bits = 0;
+
+	phy_get_pause(phydev, &tx_pause, &rx_pause);
+
+	if (!tx_pause)
+		cmd_bits |= CMD_TX_PAUSE_IGNORE;
+	if (!rx_pause)
+		cmd_bits |= CMD_RX_PAUSE_IGNORE;
+
+	return cmd_bits;
+}
+
 /* setup netdev link state when PHY link status change and
  * update UMAC and RGMII block when link up
  */
@@ -71,12 +86,20 @@ void bcmgenet_mii_setup(struct net_device *dev)
 		cmd_bits <<= CMD_SPEED_SHIFT;
 
 		/* duplex */
-		if (phydev->duplex != DUPLEX_FULL)
-			cmd_bits |= CMD_HD_EN;
-
-		/* pause capability */
-		if (!phydev->pause)
-			cmd_bits |= CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
+		if (phydev->duplex != DUPLEX_FULL) {
+			cmd_bits |= CMD_HD_EN |
+				CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
+		} else {
+			/* pause capability defaults to Symmetric */
+			if (phydev->autoneg && priv->autoneg_pause)
+				cmd_bits |= _flow_control_autoneg(phydev);
+
+			/* Manual override */
+			if (!priv->rx_pause)
+				cmd_bits |= CMD_RX_PAUSE_IGNORE;
+			if (!priv->tx_pause)
+				cmd_bits |= CMD_TX_PAUSE_IGNORE;
+		}
 
 		/*
 		 * Program UMAC and RGMII block based on established
@@ -350,7 +373,8 @@ int bcmgenet_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
-	linkmode_copy(phydev->advertising, phydev->supported);
+	phy_support_asym_pause(phydev);
+	phy_advertise_supported(phydev);
 
 	/* The internal PHY has its link interrupts routed to the
 	 * Ethernet MAC ISRs. On GENETv5 there is a hardware issue
-- 
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B514CDA1F6
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437883AbfJPXHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:07:33 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53377 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437421AbfJPXHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:07:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id i16so500545wmd.3;
        Wed, 16 Oct 2019 16:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ReX8/fGhBpUVFkNB1V6hI1YfDcLKICGJvdT4qS170f0=;
        b=c8WFd98CYHOQ4v6Bsbvfx1atelo/DWgEeksNyC1BZcsSMZRLhkSMRD84pdzGRP6N40
         7l/jofcCeKiVLsPADlqdepGW6dxDe/ppG9xQZHjNuD1jnRXKMARaALsZIKvP5Z+rqyOE
         YI++jhftnJiu2JVL905aJpDpACJ3MnIW8nNYkh9PRBHdT/K9dNsmtnr2kexEGcx91gCl
         zq7pVe87nC7d9fiw3S8eSeaHRr2xWeC2zHL4okWizPR5spSk1mGMiMJBxKT6f6It0PD5
         tM1k7L5dVhTVOx/Om6eWEg4JVKwrZyNJIHHPgar9w6+KEbasdgjx31dUDoiambvC7wv8
         bBHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ReX8/fGhBpUVFkNB1V6hI1YfDcLKICGJvdT4qS170f0=;
        b=V/15rpJ89iDJeAg4banqGZZKt3T20FZTlWrFhC8Lb1pgUANyKFYQOBYmghEZ1GcaxV
         GWUZ80C+chE7pXDRXhLVF4LxHAqp0TN8/OrxioVZwhrOX2hbcpnj3vIHUV4rabNpIxJF
         j3Y6mPLJdeISRmzZ/QDRmvO1GRBVcj9MP+qXfbMirgSlhgi98a92NXZNjokQJU1966Su
         t5VcZQtlOH1yA+7iKaYTBePRJZAnwtLtJNzJ1Mv2VDuGNuBScWRAQUtiG+uQjjoPmWKN
         4gqr91zldchpzPUMg3TMlk191cRwPB8kv6AqkP9bM2I1764Uz0j5IIFpMCA6KRj4tbez
         JnUg==
X-Gm-Message-State: APjAAAUL+ULxDdyvU7JWeUzEMWZ+Rk3hqr30iy0+6Sx+FudZk/UcJRUL
        AbTw8KhjJ4YRMKiuck/8Aa8=
X-Google-Smtp-Source: APXvYqyJjfEBgWUtHZKRJqgA3yphfPO7CKZe6FDKpfM6EjUmzkXMeTkxX9LE6crXv4wA25LJzzRHBg==
X-Received: by 2002:a05:600c:143:: with SMTP id w3mr92430wmm.35.1571267248666;
        Wed, 16 Oct 2019 16:07:28 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l9sm297071wme.45.2019.10.16.16.07.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Oct 2019 16:07:28 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 3/4] net: bcmgenet: soft reset 40nm EPHYs before MAC init
Date:   Wed, 16 Oct 2019 16:06:31 -0700
Message-Id: <1571267192-16720-4-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
References: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It turns out that the "Workaround for putting the PHY in IDDQ mode"
used by the internal EPHYs on 40nm Set-Top Box chips when powering
down puts the interface to the GENET MAC in a state that can cause
subsequent MAC resets to be incomplete.

Rather than restore the forced soft reset when powering up internal
PHYs, this commit moves the invocation of phy_init_hw earlier in
the MAC initialization sequence to just before the MAC reset in the
open and resume functions. This allows the interface to be stable
and allows the MAC resets to be successful.

The bcmgenet_mii_probe() function is split in two to accommodate
this. The new function bcmgenet_mii_connect() handles the first
half of the functionality before the MAC initialization, and the
bcmgenet_mii_config() function is extended to provide the remaining
PHY configuration following the MAC initialization.

Fixes: 484bfa1507bf ("Revert "net: bcmgenet: Software reset EPHY after power on"")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |  28 ++++---
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 112 +++++++++++--------------
 3 files changed, 69 insertions(+), 73 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 10d68017ff6c..f0937c650e3c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2872,6 +2872,12 @@ static int bcmgenet_open(struct net_device *dev)
 	if (priv->internal_phy)
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
+	ret = bcmgenet_mii_connect(dev);
+	if (ret) {
+		netdev_err(dev, "failed to connect to PHY\n");
+		goto err_clk_disable;
+	}
+
 	/* take MAC out of reset */
 	bcmgenet_umac_reset(priv);
 
@@ -2881,6 +2887,12 @@ static int bcmgenet_open(struct net_device *dev)
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	priv->crc_fwd_en = !!(reg & CMD_CRC_FWD);
 
+	ret = bcmgenet_mii_config(dev, true);
+	if (ret) {
+		netdev_err(dev, "unsupported PHY\n");
+		goto err_disconnect_phy;
+	}
+
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
 	if (priv->internal_phy) {
@@ -2896,7 +2908,7 @@ static int bcmgenet_open(struct net_device *dev)
 	ret = bcmgenet_init_dma(priv);
 	if (ret) {
 		netdev_err(dev, "failed to initialize DMA\n");
-		goto err_clk_disable;
+		goto err_disconnect_phy;
 	}
 
 	/* Always enable ring 16 - descriptor ring */
@@ -2919,25 +2931,19 @@ static int bcmgenet_open(struct net_device *dev)
 		goto err_irq0;
 	}
 
-	ret = bcmgenet_mii_probe(dev);
-	if (ret) {
-		netdev_err(dev, "failed to connect to PHY\n");
-		goto err_irq1;
-	}
-
 	bcmgenet_netif_start(dev);
 
 	netif_tx_start_all_queues(dev);
 
 	return 0;
 
-err_irq1:
-	free_irq(priv->irq1, priv);
 err_irq0:
 	free_irq(priv->irq0, priv);
 err_fini_dma:
 	bcmgenet_dma_teardown(priv);
 	bcmgenet_fini_dma(priv);
+err_disconnect_phy:
+	phy_disconnect(dev->phydev);
 err_clk_disable:
 	if (priv->internal_phy)
 		bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
@@ -3618,6 +3624,8 @@ static int bcmgenet_resume(struct device *d)
 	if (priv->internal_phy)
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
+	phy_init_hw(dev->phydev);
+
 	bcmgenet_umac_reset(priv);
 
 	init_umac(priv);
@@ -3626,8 +3634,6 @@ static int bcmgenet_resume(struct device *d)
 	if (priv->wolopts)
 		clk_disable_unprepare(priv->clk_wol);
 
-	phy_init_hw(dev->phydev);
-
 	/* Speed settings must be restored */
 	bcmgenet_mii_config(priv->dev, false);
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index dbc69d8fa05f..7fbf573d8d52 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -720,8 +720,8 @@ GENET_IO_MACRO(rbuf, GENET_RBUF_OFF);
 
 /* MDIO routines */
 int bcmgenet_mii_init(struct net_device *dev);
+int bcmgenet_mii_connect(struct net_device *dev);
 int bcmgenet_mii_config(struct net_device *dev, bool init);
-int bcmgenet_mii_probe(struct net_device *dev);
 void bcmgenet_mii_exit(struct net_device *dev);
 void bcmgenet_phy_power_set(struct net_device *dev, bool enable);
 void bcmgenet_mii_setup(struct net_device *dev);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index e7c291bf4ed1..17bb8d60a157 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -173,6 +173,46 @@ static void bcmgenet_moca_phy_setup(struct bcmgenet_priv *priv)
 					  bcmgenet_fixed_phy_link_update);
 }
 
+int bcmgenet_mii_connect(struct net_device *dev)
+{
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct device_node *dn = priv->pdev->dev.of_node;
+	struct phy_device *phydev;
+	u32 phy_flags = 0;
+	int ret;
+
+	/* Communicate the integrated PHY revision */
+	if (priv->internal_phy)
+		phy_flags = priv->gphy_rev;
+
+	/* Initialize link state variables that bcmgenet_mii_setup() uses */
+	priv->old_link = -1;
+	priv->old_speed = -1;
+	priv->old_duplex = -1;
+	priv->old_pause = -1;
+
+	if (dn) {
+		phydev = of_phy_connect(dev, priv->phy_dn, bcmgenet_mii_setup,
+					phy_flags, priv->phy_interface);
+		if (!phydev) {
+			pr_err("could not attach to PHY\n");
+			return -ENODEV;
+		}
+	} else {
+		phydev = dev->phydev;
+		phydev->dev_flags = phy_flags;
+
+		ret = phy_connect_direct(dev, phydev, bcmgenet_mii_setup,
+					 priv->phy_interface);
+		if (ret) {
+			pr_err("could not attach to PHY\n");
+			return -ENODEV;
+		}
+	}
+
+	return 0;
+}
+
 int bcmgenet_mii_config(struct net_device *dev, bool init)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -266,71 +306,21 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 	}
 
-	if (init)
-		dev_info(kdev, "configuring instance for %s\n", phy_name);
-
-	return 0;
-}
+	if (init) {
+		linkmode_copy(phydev->advertising, phydev->supported);
 
-int bcmgenet_mii_probe(struct net_device *dev)
-{
-	struct bcmgenet_priv *priv = netdev_priv(dev);
-	struct device_node *dn = priv->pdev->dev.of_node;
-	struct phy_device *phydev;
-	u32 phy_flags = 0;
-	int ret;
-
-	/* Communicate the integrated PHY revision */
-	if (priv->internal_phy)
-		phy_flags = priv->gphy_rev;
-
-	/* Initialize link state variables that bcmgenet_mii_setup() uses */
-	priv->old_link = -1;
-	priv->old_speed = -1;
-	priv->old_duplex = -1;
-	priv->old_pause = -1;
-
-	if (dn) {
-		phydev = of_phy_connect(dev, priv->phy_dn, bcmgenet_mii_setup,
-					phy_flags, priv->phy_interface);
-		if (!phydev) {
-			pr_err("could not attach to PHY\n");
-			return -ENODEV;
-		}
-	} else {
-		phydev = dev->phydev;
-		phydev->dev_flags = phy_flags;
-
-		ret = phy_connect_direct(dev, phydev, bcmgenet_mii_setup,
-					 priv->phy_interface);
-		if (ret) {
-			pr_err("could not attach to PHY\n");
-			return -ENODEV;
-		}
-	}
+		/* The internal PHY has its link interrupts routed to the
+		 * Ethernet MAC ISRs. On GENETv5 there is a hardware issue
+		 * that prevents the signaling of link UP interrupts when
+		 * the link operates at 10Mbps, so fallback to polling for
+		 * those versions of GENET.
+		 */
+		if (priv->internal_phy && !GENET_IS_V5(priv))
+			phydev->irq = PHY_IGNORE_INTERRUPT;
 
-	/* Configure port multiplexer based on what the probed PHY device since
-	 * reading the 'max-speed' property determines the maximum supported
-	 * PHY speed which is needed for bcmgenet_mii_config() to configure
-	 * things appropriately.
-	 */
-	ret = bcmgenet_mii_config(dev, true);
-	if (ret) {
-		phy_disconnect(dev->phydev);
-		return ret;
+		dev_info(kdev, "configuring instance for %s\n", phy_name);
 	}
 
-	linkmode_copy(phydev->advertising, phydev->supported);
-
-	/* The internal PHY has its link interrupts routed to the
-	 * Ethernet MAC ISRs. On GENETv5 there is a hardware issue
-	 * that prevents the signaling of link UP interrupts when
-	 * the link operates at 10Mbps, so fallback to polling for
-	 * those versions of GENET.
-	 */
-	if (priv->internal_phy && !GENET_IS_V5(priv))
-		dev->phydev->irq = PHY_IGNORE_INTERRUPT;
-
 	return 0;
 }
 
-- 
2.7.4


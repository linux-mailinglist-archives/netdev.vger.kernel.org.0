Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE5616B49C
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgBXWyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:54:16 -0500
Received: from foss.arm.com ([217.140.110.172]:43916 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbgBXWyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 17:54:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F1B431B;
        Mon, 24 Feb 2020 14:54:13 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3E32B3F534;
        Mon, 24 Feb 2020 14:54:13 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH v2 5/6] net: bcmgenet: Fetch MAC address from the adapter
Date:   Mon, 24 Feb 2020 16:54:02 -0600
Message-Id: <20200224225403.1650656-6-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224225403.1650656-1-jeremy.linton@arm.com>
References: <20200224225403.1650656-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARM/ACPI machines should utilize self describing hardware
when possible. The MAC address on the BCMGENET can be
read from the adapter if a full featured firmware has already
programmed it. Lets try using the address already programmed,
if it appears to be valid.

It should be noted that while we move the macaddr logic below
the clock and power logic in the driver, none of that code will
ever be active in an ACPI environment as the device will be
attached to the acpi power domain, and brought to full power
with all clocks enabled immediately before the device probe
routine is called.

One side effect of the above tweak is that while its now
possible to read the MAC address via _DSD properties, it should
be avoided.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 39 +++++++++++++------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 179855171918..412156745b5c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2772,6 +2772,21 @@ static void bcmgenet_set_hw_addr(struct bcmgenet_priv *priv,
 	bcmgenet_umac_writel(priv, (addr[4] << 8) | addr[5], UMAC_MAC1);
 }
 
+static void bcmgenet_get_hw_addr(struct bcmgenet_priv *priv,
+				 unsigned char *addr)
+{
+	u32 addr_tmp;
+
+	addr_tmp = bcmgenet_umac_readl(priv, UMAC_MAC0);
+	addr[0] = addr_tmp >> 24;
+	addr[1] = (addr_tmp >> 16) & 0xff;
+	addr[2] = (addr_tmp >>	8) & 0xff;
+	addr[3] = addr_tmp & 0xff;
+	addr_tmp = bcmgenet_umac_readl(priv, UMAC_MAC1);
+	addr[4] = (addr_tmp >> 8) & 0xff;
+	addr[5] = addr_tmp & 0xff;
+}
+
 /* Returns a reusable dma control register value */
 static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
 {
@@ -3467,7 +3482,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	const struct bcmgenet_plat_data *pdata;
 	struct bcmgenet_priv *priv;
 	struct net_device *dev;
-	const void *macaddr = NULL;
 	unsigned int i;
 	int err = -EIO;
 
@@ -3498,11 +3512,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	}
 	priv->wol_irq = platform_get_irq_optional(pdev, 2);
 
-	if (dn)
-		macaddr = of_get_mac_address(dn);
-	else if (pd)
-		macaddr = pd->mac_address;
-
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
 		err = PTR_ERR(priv->base);
@@ -3513,12 +3522,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	dev_set_drvdata(&pdev->dev, dev);
-	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
-		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
-		eth_hw_addr_random(dev);
-	} else {
-		ether_addr_copy(dev->dev_addr, macaddr);
-	}
 	dev->watchdog_timeo = 2 * HZ;
 	dev->ethtool_ops = &bcmgenet_ethtool_ops;
 	dev->netdev_ops = &bcmgenet_netdev_ops;
@@ -3599,6 +3602,18 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (device_get_phy_mode(&pdev->dev) == PHY_INTERFACE_MODE_INTERNAL)
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
+	if ((pd) && (!IS_ERR_OR_NULL(pd->mac_address)))
+		ether_addr_copy(dev->dev_addr, pd->mac_address);
+	else
+		if (!device_get_mac_address(&pdev->dev, dev->dev_addr, ETH_ALEN))
+			if (has_acpi_companion(&pdev->dev))
+				bcmgenet_get_hw_addr(priv, dev->dev_addr);
+
+	if (!is_valid_ether_addr(dev->dev_addr)) {
+		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
+		eth_hw_addr_random(dev);
+	}
+
 	reset_umac(priv);
 
 	err = bcmgenet_mii_init(dev);
-- 
2.24.1


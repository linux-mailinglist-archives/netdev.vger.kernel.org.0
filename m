Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14DC11461CE
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgAWGIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:08:42 -0500
Received: from foss.arm.com ([217.140.110.172]:35378 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgAWGIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:08:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8225CFEC;
        Wed, 22 Jan 2020 22:08:36 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 71E073F68E;
        Wed, 22 Jan 2020 22:08:36 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 2/2] net: bcmgenet: Fetch MAC address from the adapter
Date:   Thu, 23 Jan 2020 00:08:23 -0600
Message-Id: <20200123060823.1902366-3-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123060823.1902366-1-jeremy.linton@arm.com>
References: <20200123060823.1902366-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARM/ACPI machines should utilize self describing hardware
when possible. The MAC address on the BCM GENET can be
read from the adapter if a full featured firmware has already
programmed it. Lets try using the address already programmed,
if it appears to be valid.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 47 ++++++++++++++-----
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index c736700f829e..6782bb0a24bd 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2779,6 +2779,27 @@ static void bcmgenet_set_hw_addr(struct bcmgenet_priv *priv,
 	bcmgenet_umac_writel(priv, (addr[4] << 8) | addr[5], UMAC_MAC1);
 }
 
+static void bcmgenet_get_hw_addr(struct bcmgenet_priv *priv,
+				 unsigned char *addr)
+{
+	u32 addr_tmp;
+	bool acpi_mode = has_acpi_companion(&priv->pdev->dev);
+
+	/* UEFI/ACPI machines and possibly others will preprogram the MAC */
+	if (acpi_mode) {
+		addr_tmp = bcmgenet_umac_readl(priv, UMAC_MAC0);
+		addr[0] = addr_tmp >> 24;
+		addr[1] = (addr_tmp >> 16) & 0xff;
+		addr[2] = (addr_tmp >>	8) & 0xff;
+		addr[3] = addr_tmp & 0xff;
+		addr_tmp = bcmgenet_umac_readl(priv, UMAC_MAC1);
+		addr[4] = (addr_tmp >> 8) & 0xff;
+		addr[5] = addr_tmp & 0xff;
+	} else {
+		memset(addr, 0, ETH_ALEN);
+	}
+}
+
 /* Returns a reusable dma control register value */
 static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
 {
@@ -3509,11 +3530,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
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
@@ -3524,12 +3540,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
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
@@ -3601,6 +3611,21 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	    !strcasecmp(phy_mode_str, "internal"))
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
+	if (dn)
+		macaddr = of_get_mac_address(dn);
+	else if (pd)
+		macaddr = pd->mac_address;
+
+	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
+		bcmgenet_get_hw_addr(priv, dev->dev_addr);
+		if (!is_valid_ether_addr(dev->dev_addr)) {
+			dev_warn(&pdev->dev, "using random Ethernet MAC\n");
+			eth_hw_addr_random(dev);
+		}
+	} else {
+		ether_addr_copy(dev->dev_addr, macaddr);
+	}
+
 	reset_umac(priv);
 
 	err = bcmgenet_mii_init(dev);
-- 
2.24.1


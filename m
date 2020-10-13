Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6BC28CE99
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 14:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgJMMoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 08:44:38 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39630 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727959AbgJMMof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 08:44:35 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E8E85412EB;
        Tue, 13 Oct 2020 12:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1602592579; x=1604406980; bh=zVhD6lUNMQlctSn+NLlY9tSIYRxPl0V3drX
        /ojOm4RM=; b=UYtfeyXiCO69TIis32Rr/PaD1pBBZCZcUzzXbFVxqRgb+ax/ULV
        zPcMrFn3cOhIcddAc3OV8v6JElEXz/JTFzxryOq80ijQstzPyPPyNQjKXzOwSU9A
        Ti4+5UbkRmRVZPC0XvSM+K+Ejqri8ScNNZhP4gKYqw6dqSACCk3n4OE4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4Bwg6O1ei_0M; Tue, 13 Oct 2020 15:36:19 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 553C5412CF;
        Tue, 13 Oct 2020 15:36:16 +0300 (MSK)
Received: from localhost.dev.yadro.com (10.199.1.110) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 13 Oct 2020 15:36:15 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <openbmc@lists.ozlabs.org>
Subject: [PATCH 1/1] net: ftgmac100: add handling of mdio/phy nodes for ast2400/2500
Date:   Tue, 13 Oct 2020 15:40:14 +0300
Message-ID: <20201013124014.2989-2-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201013124014.2989-1-i.mikhaylov@yadro.com>
References: <20201013124014.2989-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.1.110]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy-handle can't be handled well for ast2400/2500 which has an embedded
MDIO controller. Add ftgmac100_mdio_setup for ast2400/2500 and initialize
PHYs from mdio child node with of_mdiobus_register.

Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 114 ++++++++++++++---------
 1 file changed, 69 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 87236206366f..e32066519ec1 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1044,11 +1044,47 @@ static void ftgmac100_adjust_link(struct net_device *netdev)
 	schedule_work(&priv->reset_task);
 }
 
-static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
+static int ftgmac100_mii_probe(struct net_device *netdev)
 {
-	struct net_device *netdev = priv->netdev;
+	struct ftgmac100 *priv = netdev_priv(netdev);
+	struct platform_device *pdev = to_platform_device(priv->dev);
+	struct device_node *np = pdev->dev.of_node;
+	phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
 	struct phy_device *phydev;
 
+	/* Get PHY mode from device-tree */
+	if (np) {
+		/* Default to RGMII. It's a gigabit part after all */
+		phy_intf = of_get_phy_mode(np, &phy_intf);
+		if (phy_intf < 0)
+			phy_intf = PHY_INTERFACE_MODE_RGMII;
+
+		/* Aspeed only supports these. I don't know about other IP
+		 * block vendors so I'm going to just let them through for
+		 * now. Note that this is only a warning if for some obscure
+		 * reason the DT really means to lie about it or it's a newer
+		 * part we don't know about.
+		 *
+		 * On the Aspeed SoC there are additionally straps and SCU
+		 * control bits that could tell us what the interface is
+		 * (or allow us to configure it while the IP block is held
+		 * in reset). For now I chose to keep this driver away from
+		 * those SoC specific bits and assume the device-tree is
+		 * right and the SCU has been configured properly by pinmux
+		 * or the firmware.
+		 */
+		if (priv->is_aspeed &&
+		    phy_intf != PHY_INTERFACE_MODE_RMII &&
+		    phy_intf != PHY_INTERFACE_MODE_RGMII &&
+		    phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
+		    phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
+		    phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {
+			netdev_warn(netdev,
+				    "Unsupported PHY mode %s !\n",
+				    phy_modes(phy_intf));
+		}
+	}
+
 	phydev = phy_find_first(priv->mii_bus);
 	if (!phydev) {
 		netdev_info(netdev, "%s: no PHY found\n", netdev->name);
@@ -1056,7 +1092,7 @@ static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
 	}
 
 	phydev = phy_connect(netdev, phydev_name(phydev),
-			     &ftgmac100_adjust_link, intf);
+			     &ftgmac100_adjust_link, phy_intf);
 
 	if (IS_ERR(phydev)) {
 		netdev_err(netdev, "%s: Could not attach to PHY\n", netdev->name);
@@ -1601,8 +1637,8 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
 	struct platform_device *pdev = to_platform_device(priv->dev);
-	phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
 	struct device_node *np = pdev->dev.of_node;
+	struct device_node *mdio_np;
 	int i, err = 0;
 	u32 reg;
 
@@ -1623,39 +1659,6 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
 		iowrite32(reg, priv->base + FTGMAC100_OFFSET_REVR);
 	}
 
-	/* Get PHY mode from device-tree */
-	if (np) {
-		/* Default to RGMII. It's a gigabit part after all */
-		err = of_get_phy_mode(np, &phy_intf);
-		if (err)
-			phy_intf = PHY_INTERFACE_MODE_RGMII;
-
-		/* Aspeed only supports these. I don't know about other IP
-		 * block vendors so I'm going to just let them through for
-		 * now. Note that this is only a warning if for some obscure
-		 * reason the DT really means to lie about it or it's a newer
-		 * part we don't know about.
-		 *
-		 * On the Aspeed SoC there are additionally straps and SCU
-		 * control bits that could tell us what the interface is
-		 * (or allow us to configure it while the IP block is held
-		 * in reset). For now I chose to keep this driver away from
-		 * those SoC specific bits and assume the device-tree is
-		 * right and the SCU has been configured properly by pinmux
-		 * or the firmware.
-		 */
-		if (priv->is_aspeed &&
-		    phy_intf != PHY_INTERFACE_MODE_RMII &&
-		    phy_intf != PHY_INTERFACE_MODE_RGMII &&
-		    phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
-		    phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
-		    phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {
-			netdev_warn(netdev,
-				   "Unsupported PHY mode %s !\n",
-				   phy_modes(phy_intf));
-		}
-	}
-
 	priv->mii_bus->name = "ftgmac100_mdio";
 	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%d",
 		 pdev->name, pdev->id);
@@ -1667,22 +1670,22 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
 	for (i = 0; i < PHY_MAX_ADDR; i++)
 		priv->mii_bus->irq[i] = PHY_POLL;
 
-	err = mdiobus_register(priv->mii_bus);
+	mdio_np = of_get_child_by_name(np, "mdio");
+	if (mdio_np)
+		err = of_mdiobus_register(priv->mii_bus, mdio_np);
+	else
+		err = mdiobus_register(priv->mii_bus);
+
 	if (err) {
 		dev_err(priv->dev, "Cannot register MDIO bus!\n");
 		goto err_register_mdiobus;
 	}
 
-	err = ftgmac100_mii_probe(priv, phy_intf);
-	if (err) {
-		dev_err(priv->dev, "MII Probe failed!\n");
-		goto err_mii_probe;
-	}
+	if (mdio_np)
+		of_node_put(mdio_np);
 
 	return 0;
 
-err_mii_probe:
-	mdiobus_unregister(priv->mii_bus);
 err_register_mdiobus:
 	mdiobus_free(priv->mii_bus);
 	return err;
@@ -1836,10 +1839,23 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	} else if (np && of_get_property(np, "phy-handle", NULL)) {
 		struct phy_device *phy;
 
+		/* Support "mdio"/"phy" child nodes for ast2400/2500 with
+		 * an embedded MDIO controller. Automatically scan the DTS for
+		 * available PHYs and register them.
+		 */
+		if (of_device_is_compatible(np, "aspeed,ast2400-mac") ||
+		    of_device_is_compatible(np, "aspeed,ast2500-mac")) {
+			err = ftgmac100_setup_mdio(netdev);
+			if (err)
+				goto err_setup_mdio;
+		}
+
 		phy = of_phy_get_and_connect(priv->netdev, np,
 					     &ftgmac100_adjust_link);
 		if (!phy) {
 			dev_err(&pdev->dev, "Failed to connect to phy\n");
+			if (priv->mii_bus)
+				mdiobus_unregister(priv->mii_bus);
 			goto err_setup_mdio;
 		}
 
@@ -1860,6 +1876,14 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		err = ftgmac100_setup_mdio(netdev);
 		if (err)
 			goto err_setup_mdio;
+
+		err = ftgmac100_mii_probe(netdev);
+		if (err) {
+			dev_err(priv->dev, "MII probe failed!\n");
+			mdiobus_unregister(priv->mii_bus);
+			goto err_setup_mdio;
+		}
+
 	}
 
 	if (priv->is_aspeed) {
-- 
2.21.1


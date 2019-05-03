Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5E612B8F
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfECKhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:37:04 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:8549 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfECKhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:37:03 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,425,1549954800"; 
   d="scan'208";a="31493303"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 03 May 2019 03:37:02 -0700
Received: from tenerife.corp.atmel.com (10.10.76.4) by
 chn-sv-exch06.mchp-main.com (10.10.76.107) with Microsoft SMTP Server id
 14.3.352.0; Fri, 3 May 2019 03:37:02 -0700
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <michal.simek@xilinx.com>, <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH] net: macb: shrink macb_platform_data structure
Date:   Fri, 3 May 2019 12:36:58 +0200
Message-ID: <20190503103658.17237-1-nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This structure was used intensively for machine specific values
when DT was not used. Since the removal of AVR32 from the kernel,
this structure is only used for passing clocks from PCI macb wrapper, all
other fields being 0.
All other known platforms use DT.

Remove the leftovers but make sure that PCI macb still works as
expected by using default values:
- phydev->irq is set to PHY_POLL by mdiobus_alloc()
- mii_bus->phy_mask is cleared while allocating it
- bp->phy_interface is set to PHY_INTERFACE_MODE_MII if mode not found
in DT.

This simplifies driver probe path and particularly phy handling.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 59 +++++-------------------
 include/linux/platform_data/macb.h       |  9 ----
 2 files changed, 11 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 59531adcbb42..bd6a62f4bd7d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -285,34 +285,22 @@ static void macb_set_hwaddr(struct macb *bp)
 
 static void macb_get_hwaddr(struct macb *bp)
 {
-	struct macb_platform_data *pdata;
 	u32 bottom;
 	u16 top;
 	u8 addr[6];
 	int i;
 
-	pdata = dev_get_platdata(&bp->pdev->dev);
-
 	/* Check all 4 address register for valid address */
 	for (i = 0; i < 4; i++) {
 		bottom = macb_or_gem_readl(bp, SA1B + i * 8);
 		top = macb_or_gem_readl(bp, SA1T + i * 8);
 
-		if (pdata && pdata->rev_eth_addr) {
-			addr[5] = bottom & 0xff;
-			addr[4] = (bottom >> 8) & 0xff;
-			addr[3] = (bottom >> 16) & 0xff;
-			addr[2] = (bottom >> 24) & 0xff;
-			addr[1] = top & 0xff;
-			addr[0] = (top & 0xff00) >> 8;
-		} else {
-			addr[0] = bottom & 0xff;
-			addr[1] = (bottom >> 8) & 0xff;
-			addr[2] = (bottom >> 16) & 0xff;
-			addr[3] = (bottom >> 24) & 0xff;
-			addr[4] = top & 0xff;
-			addr[5] = (top >> 8) & 0xff;
-		}
+		addr[0] = bottom & 0xff;
+		addr[1] = (bottom >> 8) & 0xff;
+		addr[2] = (bottom >> 16) & 0xff;
+		addr[3] = (bottom >> 24) & 0xff;
+		addr[4] = top & 0xff;
+		addr[5] = (top >> 8) & 0xff;
 
 		if (is_valid_ether_addr(addr)) {
 			memcpy(bp->dev->dev_addr, addr, sizeof(addr));
@@ -510,12 +498,10 @@ static void macb_handle_link_change(struct net_device *dev)
 static int macb_mii_probe(struct net_device *dev)
 {
 	struct macb *bp = netdev_priv(dev);
-	struct macb_platform_data *pdata;
 	struct phy_device *phydev;
 	struct device_node *np;
-	int phy_irq, ret, i;
+	int ret, i;
 
-	pdata = dev_get_platdata(&bp->pdev->dev);
 	np = bp->pdev->dev.of_node;
 	ret = 0;
 
@@ -557,19 +543,6 @@ static int macb_mii_probe(struct net_device *dev)
 			return -ENXIO;
 		}
 
-		if (pdata) {
-			if (gpio_is_valid(pdata->phy_irq_pin)) {
-				ret = devm_gpio_request(&bp->pdev->dev,
-							pdata->phy_irq_pin, "phy int");
-				if (!ret) {
-					phy_irq = gpio_to_irq(pdata->phy_irq_pin);
-					phydev->irq = (phy_irq < 0) ? PHY_POLL : phy_irq;
-				}
-			} else {
-				phydev->irq = PHY_POLL;
-			}
-		}
-
 		/* attach the mac to the phy */
 		ret = phy_connect_direct(dev, phydev, &macb_handle_link_change,
 					 bp->phy_interface);
@@ -598,7 +571,6 @@ static int macb_mii_probe(struct net_device *dev)
 
 static int macb_mii_init(struct macb *bp)
 {
-	struct macb_platform_data *pdata;
 	struct device_node *np;
 	int err = -ENXIO;
 
@@ -618,7 +590,6 @@ static int macb_mii_init(struct macb *bp)
 		 bp->pdev->name, bp->pdev->id);
 	bp->mii_bus->priv = bp;
 	bp->mii_bus->parent = &bp->pdev->dev;
-	pdata = dev_get_platdata(&bp->pdev->dev);
 
 	dev_set_drvdata(&bp->dev->dev, bp->mii_bus);
 
@@ -632,9 +603,6 @@ static int macb_mii_init(struct macb *bp)
 
 		err = mdiobus_register(bp->mii_bus);
 	} else {
-		if (pdata)
-			bp->mii_bus->phy_mask = pdata->phy_mask;
-
 		err = of_mdiobus_register(bp->mii_bus, np);
 	}
 
@@ -4050,7 +4018,6 @@ static int macb_probe(struct platform_device *pdev)
 	struct clk *pclk, *hclk = NULL, *tx_clk = NULL, *rx_clk = NULL;
 	struct clk *tsu_clk = NULL;
 	unsigned int queue_mask, num_queues;
-	struct macb_platform_data *pdata;
 	bool native_io;
 	struct phy_device *phydev;
 	struct net_device *dev;
@@ -4182,15 +4149,11 @@ static int macb_probe(struct platform_device *pdev)
 	}
 
 	err = of_get_phy_mode(np);
-	if (err < 0) {
-		pdata = dev_get_platdata(&pdev->dev);
-		if (pdata && pdata->is_rmii)
-			bp->phy_interface = PHY_INTERFACE_MODE_RMII;
-		else
-			bp->phy_interface = PHY_INTERFACE_MODE_MII;
-	} else {
+	if (err < 0)
+		/* not found in DT, MII by default */
+		bp->phy_interface = PHY_INTERFACE_MODE_MII;
+	else
 		bp->phy_interface = err;
-	}
 
 	/* IP specific init */
 	err = init(pdev);
diff --git a/include/linux/platform_data/macb.h b/include/linux/platform_data/macb.h
index 7815d50c26ff..2bc51b822956 100644
--- a/include/linux/platform_data/macb.h
+++ b/include/linux/platform_data/macb.h
@@ -12,19 +12,10 @@
 
 /**
  * struct macb_platform_data - platform data for MACB Ethernet
- * @phy_mask:		phy mask passed when register the MDIO bus
- *			within the driver
- * @phy_irq_pin:	PHY IRQ
- * @is_rmii:		using RMII interface?
- * @rev_eth_addr:	reverse Ethernet address byte order
  * @pclk:		platform clock
  * @hclk:		AHB clock
  */
 struct macb_platform_data {
-	u32		phy_mask;
-	int		phy_irq_pin;
-	u8		is_rmii;
-	u8		rev_eth_addr;
 	struct clk	*pclk;
 	struct clk	*hclk;
 };
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C618411225
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhITJwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:52:51 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:39035 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbhITJwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131477; x=1663667477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vLPXuzc49sx/gA5stoXpDQug7nsLIUub/azXcaJOa7U=;
  b=dU5tX2mJ/6AP3g9uqLHL6scIFPvDGdd+vSk3Oi+En/llU0Yu9ReZjozC
   ySRk6jsFXNQivHPsjZml2c7b+/IeThoeRFr6pBqh3IZuG1fPvaVGE4oCX
   Q5Z1ne9n0NrHyG/qBm1INYsBm3Il8LIfYVAO3FbrSlAnCFjMKS/VkD4Wn
   lib6Ow0kbP1JmZvjjtE8S1JLZq5SP/h00HWyy6viJqny60QcGAa8aBsdS
   Q0W1gpuWSpdT43M0B/4ofMxqUZ07d3IN4+hzItps0+cIgBbmyBBRyCF8m
   9wpr8deGVcBI2fRBhWyKJUTpOrHvWxYspZYrMiUTv5K9kxBMOIbVNgFme
   Q==;
IronPort-SDR: RvL5tJO8cV5cETkjkdzfqC52IULYir7rkvJzZ+H6vH6OyeGtb2uILxjgKqf+/0gPaO6dUMKFA0
 gNNSP5grgRl9P9rWOPPtaNg2dWqKUqZWmnCJEwE2fp/sfTrPYg1HfVLRIOLc2NYBYdPTCHJq8g
 P0npY5r3jVmEHqwDzHMufbehbtD97yK+mYLtsmlGPrhYyQR3dDxSWOcww/rYVoVvN7jNko3epy
 OUEwak+78/X5IkH5bW3QbKDAS5HFAi/YgrrehIPGoK5wF0D4pVZMaY4J5U+XOOeWzNY37QCP+n
 MKBKgc4R7QFBmgSfzWHCXppQ
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="69899282"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:15 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:12 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 01/12] net: mdio: mscc-miim: Fix the mdio controller
Date:   Mon, 20 Sep 2021 11:52:07 +0200
Message-ID: <20210920095218.1108151-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the documentation the second resource is optional. But the
blamed commit ignores that and if the resource is not there it just
fails.

This patch reverts that to still allow the second resource to be
optional because other SoC have the some MDIO controller and doesn't
need to second resource.

Fixes: 672a1c394950 ("net: mdio: mscc-miim: Make use of the helper function devm_platform_ioremap_resource()")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 1ee592d3eae4..bef026a80074 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -134,8 +134,9 @@ static int mscc_miim_reset(struct mii_bus *bus)
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
-	struct mii_bus *bus;
 	struct mscc_miim_dev *dev;
+	struct resource *res;
+	struct mii_bus *bus;
 	int ret;
 
 	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
@@ -156,10 +157,13 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->regs);
 	}
 
-	dev->phy_regs = devm_platform_ioremap_resource(pdev, 1);
-	if (IS_ERR(dev->phy_regs)) {
-		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
-		return PTR_ERR(dev->phy_regs);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (res) {
+		dev->phy_regs = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(dev->phy_regs)) {
+			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+			return PTR_ERR(dev->phy_regs);
+		}
 	}
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
-- 
2.31.1


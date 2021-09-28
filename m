Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D3141A984
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239252AbhI1HSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:18:13 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:9096 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239245AbhI1HSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 03:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632813393; x=1664349393;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xXCIVQDnetEHeFFxpR+nvBzDPhzGLim6VbAA+zaEjU8=;
  b=s/b1PAoONP0XT+SAeZnsPJZK92qWl4B0RqJLmGgvhgtb6nip2GBurjSQ
   KZWWGTyhbJd3kijADKIymlsOYHediaQUO+srZ62Bdb7nR+bNQWYWQpZAP
   IvtPd4DIv3OKr7djjHCSHCIw53sajjZnuHrVqNdR7Uq9jsxi030pwzQR9
   XCpZiD6N5qHmr6NypAfTSXnMLNAPeOQRMi78QYwdQjH1AWiVqbfDEZQsH
   55hd27e9WOaWX49CbqEM2dmMP8WusNmrREaP3mC1YHagYgGbbS3816UMN
   3/K/o2/G782VHxQcKmW8dLYTewPidAANog4dtnKpebCFqO/lz5OEKyrxG
   A==;
IronPort-SDR: azQGqGBwIxIsuPQ51hmc/vLqBfbYKff+RaAfPJZgJM9HHxr9vOK5kB/pab3lz10YFHW9K+t1//
 uce1EdTIuSkRo3LJpjjiG7xm5SsJlOFr1T257PKf4umT8mgYk0n7rIYtq6dsflbg7OifzVsZFz
 bXtLAiBAtJCyRBh50wgquzu8Fqo++mR5nVwM4DUlXPMMPQyoNvSzEsE9THMIRRUs012hrAALwP
 BZNGak8qCr1dcAn3Mo2SPcpQDGiyhqiiGapMJVpLRzo97EeLENrcz/Sivf9Qc30wPb7cNzqC8Z
 r6Lms7kQ3wdOdOrw2DMeZoQC
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="70883936"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 00:16:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 00:16:28 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 28 Sep 2021 00:16:26 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <caihuoqing@baidu.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: mdio: mscc-miim: Fix the mdio controller
Date:   Tue, 28 Sep 2021 09:17:20 +0200
Message-ID: <20210928071720.2084666-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
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
 drivers/net/mdio/mdio-mscc-miim.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 1ee592d3eae4..17f98f609ec8 100644
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
@@ -156,10 +157,14 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->regs);
 	}
 
-	dev->phy_regs = devm_platform_ioremap_resource(pdev, 1);
-	if (IS_ERR(dev->phy_regs)) {
-		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
-		return PTR_ERR(dev->phy_regs);
+	/* This resource is optional */
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
2.33.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202C51E6E94
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437012AbgE1WWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436937AbgE1WWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:22:13 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2596C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:22:12 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Y2Hk3sTrz1rtZP;
        Fri, 29 May 2020 00:22:10 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Y2Hk3CHrz1qsqG;
        Fri, 29 May 2020 00:22:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id c-E-9qZJcx7w; Fri, 29 May 2020 00:22:09 +0200 (CEST)
X-Auth-Info: 4gZZHBumCQEAvB5Ed44us0Zj74pzsOgEgqaNnfxdpfI=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 29 May 2020 00:22:09 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V7 05/19] net: ks8851: Use devm_alloc_etherdev()
Date:   Fri, 29 May 2020 00:21:32 +0200
Message-Id: <20200528222146.348805-6-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528222146.348805-1-marex@denx.de>
References: <20200528222146.348805-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use device managed version of alloc_etherdev() to simplify the code.
No functional change intended.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: Add RB from Andrew
V3: No change
V4: No change
V5: No change
V6: No change
V7: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 582092a95afc..86bfe55f346d 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1421,7 +1421,7 @@ static int ks8851_probe(struct spi_device *spi)
 	unsigned cider;
 	int gpio;
 
-	netdev = alloc_etherdev(sizeof(struct ks8851_net));
+	netdev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net));
 	if (!netdev)
 		return -ENOMEM;
 
@@ -1434,10 +1434,8 @@ static int ks8851_probe(struct spi_device *spi)
 	ks->tx_space = 6144;
 
 	gpio = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0, NULL);
-	if (gpio == -EPROBE_DEFER) {
-		ret = gpio;
-		goto err_gpio;
-	}
+	if (gpio == -EPROBE_DEFER)
+		return gpio;
 
 	ks->gpio = gpio;
 	if (gpio_is_valid(gpio)) {
@@ -1445,7 +1443,7 @@ static int ks8851_probe(struct spi_device *spi)
 					    GPIOF_OUT_INIT_LOW, "ks8851_rst_n");
 		if (ret) {
 			dev_err(dev, "reset gpio request failed\n");
-			goto err_gpio;
+			return ret;
 		}
 	}
 
@@ -1564,8 +1562,6 @@ static int ks8851_probe(struct spi_device *spi)
 err_reg:
 	regulator_disable(ks->vdd_io);
 err_reg_io:
-err_gpio:
-	free_netdev(netdev);
 	return ret;
 }
 
@@ -1582,7 +1578,6 @@ static int ks8851_remove(struct spi_device *spi)
 		gpio_set_value(priv->gpio, 0);
 	regulator_disable(priv->vdd_reg);
 	regulator_disable(priv->vdd_io);
-	free_netdev(priv->netdev);
 
 	return 0;
 }
-- 
2.25.1


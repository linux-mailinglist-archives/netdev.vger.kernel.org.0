Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18A21D236F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732978AbgENAIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:08:25 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45154 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732932AbgENAIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 20:08:18 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49MsLz3bpDz1rtM5;
        Thu, 14 May 2020 02:08:09 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49MsLx378Zz1qql9;
        Thu, 14 May 2020 02:08:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id W8HgA3clB7PL; Thu, 14 May 2020 02:08:08 +0200 (CEST)
X-Auth-Info: wLHyfuCNc9awP0B3BR7GekJlf/OjggUYG78Bq+I8q70=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 14 May 2020 02:08:08 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V5 05/19] net: ks8851: Use devm_alloc_etherdev()
Date:   Thu, 14 May 2020 02:07:33 +0200
Message-Id: <20200514000747.159320-6-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200514000747.159320-1-marex@denx.de>
References: <20200514000747.159320-1-marex@denx.de>
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
---
 drivers/net/ethernet/micrel/ks8851.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 942e694c750a..f0b70b79e7ed 100644
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


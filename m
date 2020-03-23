Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB389190210
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgCWXnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:43:32 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:39554 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgCWXna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:43:30 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mWCy5ytnz1rwZx;
        Tue, 24 Mar 2020 00:43:26 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mWCy5kY1z1qyDk;
        Tue, 24 Mar 2020 00:43:26 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id vZlB2NJwrkbK; Tue, 24 Mar 2020 00:43:25 +0100 (CET)
X-Auth-Info: Hg50pBtDUd/3BHMs/sbP8TtdCTZpiMRnw9LqEG4Wv1k=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 00:43:25 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 04/14] net: ks8851: Use devm_alloc_etherdev()
Date:   Tue, 24 Mar 2020 00:42:53 +0100
Message-Id: <20200323234303.526748-5-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323234303.526748-1-marex@denx.de>
References: <20200323234303.526748-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use device managed version of alloc_etherdev() to simplify the code.
No functional change intended.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/micrel/ks8851.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 601a74d750b2..cc1137be3d8f 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1421,7 +1421,7 @@ static int ks8851_probe(struct spi_device *spi)
 	unsigned cider;
 	int gpio;
 
-	ndev = alloc_etherdev(sizeof(struct ks8851_net));
+	ndev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net));
 	if (!ndev)
 		return -ENOMEM;
 
@@ -1435,10 +1435,8 @@ static int ks8851_probe(struct spi_device *spi)
 
 	gpio = of_get_named_gpio_flags(dev->of_node, "reset-gpios",
 				       0, NULL);
-	if (gpio == -EPROBE_DEFER) {
-		ret = gpio;
-		goto err_gpio;
-	}
+	if (gpio == -EPROBE_DEFER)
+		return gpio;
 
 	ks->gpio = gpio;
 	if (gpio_is_valid(gpio)) {
@@ -1446,7 +1444,7 @@ static int ks8851_probe(struct spi_device *spi)
 					    GPIOF_OUT_INIT_LOW, "ks8851_rst_n");
 		if (ret) {
 			dev_err(dev, "reset gpio request failed\n");
-			goto err_gpio;
+			return ret;
 		}
 	}
 
@@ -1567,8 +1565,6 @@ static int ks8851_probe(struct spi_device *spi)
 err_reg:
 	regulator_disable(ks->vdd_io);
 err_reg_io:
-err_gpio:
-	free_netdev(ndev);
 	return ret;
 }
 
@@ -1585,7 +1581,6 @@ static int ks8851_remove(struct spi_device *spi)
 		gpio_set_value(priv->gpio, 0);
 	regulator_disable(priv->vdd_reg);
 	regulator_disable(priv->vdd_io);
-	free_netdev(priv->netdev);
 
 	return 0;
 }
-- 
2.25.1


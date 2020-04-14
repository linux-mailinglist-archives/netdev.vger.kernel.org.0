Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F5E1A8928
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503819AbgDNSVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:21:53 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56986 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503785AbgDNSVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:21:13 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 491v1q4mJ4z1qrgH;
        Tue, 14 Apr 2020 20:21:01 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 491v1n26fPz1qtwZ;
        Tue, 14 Apr 2020 20:21:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ebQEllUiSFpP; Tue, 14 Apr 2020 20:21:00 +0200 (CEST)
X-Auth-Info: q82z7aKY7WVJ92nr37qy12O7ALXdGeeUOgYrGdNABZ0=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 14 Apr 2020 20:20:59 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V4 01/19] net: ks8851: Factor out spi->dev in probe()/remove()
Date:   Tue, 14 Apr 2020 20:20:11 +0200
Message-Id: <20200414182029.183594-2-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414182029.183594-1-marex@denx.de>
References: <20200414182029.183594-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pull out the spi->dev into one common place in the function instead of
having it repeated over and over again. This is done in preparation for
unifying ks8851 and ks8851-mll drivers. No functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: Unwrap function calls that are shorter than 80 chars
V3: No change
V4: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 29 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 33305c9c5a62..e32ef9403803 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1413,6 +1413,7 @@ static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
 
 static int ks8851_probe(struct spi_device *spi)
 {
+	struct device *dev = &spi->dev;
 	struct net_device *ndev;
 	struct ks8851_net *ks;
 	int ret;
@@ -1431,8 +1432,7 @@ static int ks8851_probe(struct spi_device *spi)
 	ks->spidev = spi;
 	ks->tx_space = 6144;
 
-	gpio = of_get_named_gpio_flags(spi->dev.of_node, "reset-gpios",
-				       0, NULL);
+	gpio = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0, NULL);
 	if (gpio == -EPROBE_DEFER) {
 		ret = gpio;
 		goto err_gpio;
@@ -1440,15 +1440,15 @@ static int ks8851_probe(struct spi_device *spi)
 
 	ks->gpio = gpio;
 	if (gpio_is_valid(gpio)) {
-		ret = devm_gpio_request_one(&spi->dev, gpio,
+		ret = devm_gpio_request_one(dev, gpio,
 					    GPIOF_OUT_INIT_LOW, "ks8851_rst_n");
 		if (ret) {
-			dev_err(&spi->dev, "reset gpio request failed\n");
+			dev_err(dev, "reset gpio request failed\n");
 			goto err_gpio;
 		}
 	}
 
-	ks->vdd_io = devm_regulator_get(&spi->dev, "vdd-io");
+	ks->vdd_io = devm_regulator_get(dev, "vdd-io");
 	if (IS_ERR(ks->vdd_io)) {
 		ret = PTR_ERR(ks->vdd_io);
 		goto err_reg_io;
@@ -1456,12 +1456,11 @@ static int ks8851_probe(struct spi_device *spi)
 
 	ret = regulator_enable(ks->vdd_io);
 	if (ret) {
-		dev_err(&spi->dev, "regulator vdd_io enable fail: %d\n",
-			ret);
+		dev_err(dev, "regulator vdd_io enable fail: %d\n", ret);
 		goto err_reg_io;
 	}
 
-	ks->vdd_reg = devm_regulator_get(&spi->dev, "vdd");
+	ks->vdd_reg = devm_regulator_get(dev, "vdd");
 	if (IS_ERR(ks->vdd_reg)) {
 		ret = PTR_ERR(ks->vdd_reg);
 		goto err_reg;
@@ -1469,8 +1468,7 @@ static int ks8851_probe(struct spi_device *spi)
 
 	ret = regulator_enable(ks->vdd_reg);
 	if (ret) {
-		dev_err(&spi->dev, "regulator vdd enable fail: %d\n",
-			ret);
+		dev_err(dev, "regulator vdd enable fail: %d\n", ret);
 		goto err_reg;
 	}
 
@@ -1509,7 +1507,7 @@ static int ks8851_probe(struct spi_device *spi)
 	ks->mii.mdio_read	= ks8851_phy_read;
 	ks->mii.mdio_write	= ks8851_phy_write;
 
-	dev_info(&spi->dev, "message enable is %d\n", msg_enable);
+	dev_info(dev, "message enable is %d\n", msg_enable);
 
 	/* set the default message enable */
 	ks->msg_enable = netif_msg_init(msg_enable, (NETIF_MSG_DRV |
@@ -1519,7 +1517,7 @@ static int ks8851_probe(struct spi_device *spi)
 	skb_queue_head_init(&ks->txq);
 
 	ndev->ethtool_ops = &ks8851_ethtool_ops;
-	SET_NETDEV_DEV(ndev, &spi->dev);
+	SET_NETDEV_DEV(ndev, dev);
 
 	spi_set_drvdata(spi, ks);
 
@@ -1534,7 +1532,7 @@ static int ks8851_probe(struct spi_device *spi)
 	/* simple check for a valid chip being connected to the bus */
 	cider = ks8851_rdreg16(ks, KS_CIDER);
 	if ((cider & ~CIDER_REV_MASK) != CIDER_ID) {
-		dev_err(&spi->dev, "failed to read device ID\n");
+		dev_err(dev, "failed to read device ID\n");
 		ret = -ENODEV;
 		goto err_id;
 	}
@@ -1547,7 +1545,7 @@ static int ks8851_probe(struct spi_device *spi)
 
 	ret = register_netdev(ndev);
 	if (ret) {
-		dev_err(&spi->dev, "failed to register network device\n");
+		dev_err(dev, "failed to register network device\n");
 		goto err_netdev;
 	}
 
@@ -1573,9 +1571,10 @@ static int ks8851_probe(struct spi_device *spi)
 static int ks8851_remove(struct spi_device *spi)
 {
 	struct ks8851_net *priv = spi_get_drvdata(spi);
+	struct device *dev = &spi->dev;
 
 	if (netif_msg_drv(priv))
-		dev_info(&spi->dev, "remove\n");
+		dev_info(dev, "remove\n");
 
 	unregister_netdev(priv->netdev);
 	if (gpio_is_valid(priv->gpio))
-- 
2.25.1


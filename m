Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4424619627A
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgC1AcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:32:24 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:51342 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbgC1AcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:32:22 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48q06X5qy5z1rpF7;
        Sat, 28 Mar 2020 01:32:20 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48q06X5g7Pz1qv4G;
        Sat, 28 Mar 2020 01:32:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id wwKUKh2_rTPU; Sat, 28 Mar 2020 01:32:19 +0100 (CET)
X-Auth-Info: FC1w/pzDCNEPVoHTfM49Rln6ph06Nu7LcrwKyEqAX2M=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 28 Mar 2020 01:32:19 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V3 13/18] net: ks8851: Split out SPI specific code from probe() and remove()
Date:   Sat, 28 Mar 2020 01:31:43 +0100
Message-Id: <20200328003148.498021-14-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200328003148.498021-1-marex@denx.de>
References: <20200328003148.498021-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out common code into ks8851_probe_common() and
ks8851_remove_common() to permit both SPI and parallel
bus driver variants to use the common code path for
both probing and removal.

There should be no functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: - Add RB from Andrew
    - Rework on top of locking patches, drop RB
V3: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 77 ++++++++++++++++------------
 1 file changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 1487ca135658..dc7ff857b53c 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1431,27 +1431,14 @@ static int ks8851_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
 
-static int ks8851_probe(struct spi_device *spi)
+static int ks8851_probe_common(struct net_device *netdev, struct device *dev)
 {
-	struct device *dev = &spi->dev;
-	struct ks8851_net_spi *kss;
-	struct net_device *netdev;
-	struct ks8851_net *ks;
-	int ret;
+	struct ks8851_net *ks = netdev_priv(netdev);
 	unsigned cider;
 	int gpio;
-
-	netdev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net_spi));
-	if (!netdev)
-		return -ENOMEM;
-
-	spi->bits_per_word = 8;
-
-	ks = netdev_priv(netdev);
-	kss = to_ks8851_spi(ks);
+	int ret;
 
 	ks->netdev = netdev;
-	kss->spidev = spi;
 	ks->tx_space = 6144;
 
 	gpio = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0, NULL);
@@ -1497,23 +1484,11 @@ static int ks8851_probe(struct spi_device *spi)
 		gpio_set_value(gpio, 1);
 	}
 
-	mutex_init(&kss->lock);
 	spin_lock_init(&ks->statelock);
 
-	INIT_WORK(&kss->tx_work, ks8851_tx_work);
 	INIT_WORK(&ks->rxctrl_work, ks8851_rxctrl_work);
 
-	/* initialise pre-made spi transfer messages */
-
-	spi_message_init(&kss->spi_msg1);
-	spi_message_add_tail(&kss->spi_xfer1, &kss->spi_msg1);
-
-	spi_message_init(&kss->spi_msg2);
-	spi_message_add_tail(&kss->spi_xfer2[0], &kss->spi_msg2);
-	spi_message_add_tail(&kss->spi_xfer2[1], &kss->spi_msg2);
-
 	/* setup EEPROM state */
-
 	ks->eeprom.data = ks;
 	ks->eeprom.width = PCI_EEPROM_WIDTH_93C46;
 	ks->eeprom.register_read = ks8851_eeprom_regread;
@@ -1544,7 +1519,6 @@ static int ks8851_probe(struct spi_device *spi)
 	netif_carrier_off(ks->netdev);
 	netdev->if_port = IF_PORT_100BASET;
 	netdev->netdev_ops = &ks8851_netdev_ops;
-	netdev->irq = spi->irq;
 
 	/* issue a global soft reset to reset the device. */
 	ks8851_soft_reset(ks, GRR_GSR);
@@ -1586,12 +1560,9 @@ static int ks8851_probe(struct spi_device *spi)
 	return ret;
 }
 
-static int ks8851_remove(struct spi_device *spi)
+static int ks8851_remove_common(struct device *dev)
 {
-	struct device *dev = &spi->dev;
-	struct ks8851_net *priv;
-
-	priv = dev_get_drvdata(dev);
+	struct ks8851_net *priv = dev_get_drvdata(dev);
 
 	if (netif_msg_drv(priv))
 		dev_info(dev, "remove\n");
@@ -1605,6 +1576,44 @@ static int ks8851_remove(struct spi_device *spi)
 	return 0;
 }
 
+static int ks8851_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct ks8851_net_spi *kss;
+	struct net_device *netdev;
+	struct ks8851_net *ks;
+
+	netdev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net_spi));
+	if (!netdev)
+		return -ENOMEM;
+
+	spi->bits_per_word = 8;
+
+	ks = netdev_priv(netdev);
+	kss = to_ks8851_spi(ks);
+
+	kss->spidev = spi;
+	mutex_init(&kss->lock);
+	INIT_WORK(&kss->tx_work, ks8851_tx_work);
+
+	/* initialise pre-made spi transfer messages */
+	spi_message_init(&kss->spi_msg1);
+	spi_message_add_tail(&kss->spi_xfer1, &kss->spi_msg1);
+
+	spi_message_init(&kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[0], &kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[1], &kss->spi_msg2);
+
+	netdev->irq = spi->irq;
+
+	return ks8851_probe_common(netdev, dev);
+}
+
+static int ks8851_remove(struct spi_device *spi)
+{
+	return ks8851_remove_common(&spi->dev);
+}
+
 static const struct of_device_id ks8851_match_table[] = {
 	{ .compatible = "micrel,ks8851" },
 	{ }
-- 
2.25.1


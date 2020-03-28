Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC99196275
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgC1AcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:32:13 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:42530 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgC1AcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:32:13 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48q06M2rggz1qrGS;
        Sat, 28 Mar 2020 01:32:11 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48q06M2hRfz1qv4G;
        Sat, 28 Mar 2020 01:32:11 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id u29gL3f4Wh94; Sat, 28 Mar 2020 01:32:10 +0100 (CET)
X-Auth-Info: Cx4nP5LmBs7iASxueFSxXmwjxVXsfjZSwYAw3HOXF+Y=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 28 Mar 2020 01:32:10 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V3 06/18] net: ks8851: Use dev_{get,set}_drvdata()
Date:   Sat, 28 Mar 2020 01:31:36 +0100
Message-Id: <20200328003148.498021-7-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200328003148.498021-1-marex@denx.de>
References: <20200328003148.498021-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace spi_{get,set}_drvdata() with dev_{get,set}_drvdata(), which
works for both SPI and platform drivers. This is done in preparation
for unifying the KS8851 SPI and parallel bus drivers.

There should be no functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: Reverse xmas tree.
V3: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index f0b70b79e7ed..c2f381a7b3f3 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1518,7 +1518,7 @@ static int ks8851_probe(struct spi_device *spi)
 	netdev->ethtool_ops = &ks8851_ethtool_ops;
 	SET_NETDEV_DEV(netdev, dev);
 
-	spi_set_drvdata(spi, ks);
+	dev_set_drvdata(dev, ks);
 
 	netif_carrier_off(ks->netdev);
 	netdev->if_port = IF_PORT_100BASET;
@@ -1567,8 +1567,10 @@ static int ks8851_probe(struct spi_device *spi)
 
 static int ks8851_remove(struct spi_device *spi)
 {
-	struct ks8851_net *priv = spi_get_drvdata(spi);
 	struct device *dev = &spi->dev;
+	struct ks8851_net *priv;
+
+	priv = dev_get_drvdata(dev);
 
 	if (netif_msg_drv(priv))
 		dev_info(dev, "remove\n");
-- 
2.25.1


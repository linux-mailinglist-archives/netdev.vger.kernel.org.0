Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351D61A8950
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503889AbgDNSY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:24:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58157 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503786AbgDNSV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:21:28 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 491v1z37NTz1rsY2;
        Tue, 14 Apr 2020 20:21:07 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 491v1v3HWLz1qqkS;
        Tue, 14 Apr 2020 20:21:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id BC9TYbBqDuYT; Tue, 14 Apr 2020 20:21:06 +0200 (CEST)
X-Auth-Info: gg/mFbfpOXNkjvwRrGi2qJOoxaEqfCtLxNrVXFWUJAo=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 14 Apr 2020 20:21:06 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V4 06/19] net: ks8851: Use dev_{get,set}_drvdata()
Date:   Tue, 14 Apr 2020 20:20:16 +0200
Message-Id: <20200414182029.183594-7-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414182029.183594-1-marex@denx.de>
References: <20200414182029.183594-1-marex@denx.de>
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
V4: No change
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


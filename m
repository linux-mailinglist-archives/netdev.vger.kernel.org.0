Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A0A1E6E97
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437025AbgE1WWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:22:32 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45126 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436991AbgE1WWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:22:16 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Y2Hl5Y1mz1rtZb;
        Fri, 29 May 2020 00:22:11 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Y2Hl5LDtz1qsqG;
        Fri, 29 May 2020 00:22:11 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id fmgvgK45-_m7; Fri, 29 May 2020 00:22:10 +0200 (CEST)
X-Auth-Info: k0hCrGwm53aufhC4LOqqG0ERbaQFlzig/S5ZUigrKEY=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 29 May 2020 00:22:10 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V7 06/19] net: ks8851: Use dev_{get,set}_drvdata()
Date:   Fri, 29 May 2020 00:21:33 +0200
Message-Id: <20200528222146.348805-7-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528222146.348805-1-marex@denx.de>
References: <20200528222146.348805-1-marex@denx.de>
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

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: Reverse xmas tree.
V3: No change
V4: No change
V5: No change
V6: No change
V7: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 86bfe55f346d..fe2037e166dc 100644
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


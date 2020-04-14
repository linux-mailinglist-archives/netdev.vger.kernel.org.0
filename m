Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33511A8929
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503821AbgDNSWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:22:05 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56986 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503794AbgDNSVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:21:20 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 491v1s1gnYz1qs0p;
        Tue, 14 Apr 2020 20:21:05 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 491v1s1Nwtz1qqkS;
        Tue, 14 Apr 2020 20:21:05 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 3AuxOM7PXem4; Tue, 14 Apr 2020 20:21:04 +0200 (CEST)
X-Auth-Info: l5+VYTan8SfDwy+J2Po0AifuW2P5XBk2Yz7XtgxjJgw=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 14 Apr 2020 20:21:04 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V4 04/19] net: ks8851: Pass device node into ks8851_init_mac()
Date:   Tue, 14 Apr 2020 20:20:14 +0200
Message-Id: <20200414182029.183594-5-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414182029.183594-1-marex@denx.de>
References: <20200414182029.183594-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver probe function already has a struct device *dev pointer
and can easily derive of_node pointer from it, pass the of_node pointer as
a parameter to ks8851_init_mac() to avoid fishing it out from ks->spidev.
This is the only reference to spidev in the function, so get rid of it.
This is done in preparation for unifying the KS8851 SPI and parallel bus
drivers.

No functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: Pass in of_node instead of the entire device pointer
V3: No change
V4: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 0088df970ad6..942e694c750a 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -409,6 +409,7 @@ static void ks8851_read_mac_addr(struct net_device *dev)
 /**
  * ks8851_init_mac - initialise the mac address
  * @ks: The device structure
+ * @ddev: The device structure pointer
  *
  * Get or create the initial mac address for the device and then set that
  * into the station address register. A mac address supplied in the device
@@ -416,12 +417,12 @@ static void ks8851_read_mac_addr(struct net_device *dev)
  * we try that. If no valid mac address is found we use eth_random_addr()
  * to create a new one.
  */
-static void ks8851_init_mac(struct ks8851_net *ks)
+static void ks8851_init_mac(struct ks8851_net *ks, struct device_node *np)
 {
 	struct net_device *dev = ks->netdev;
 	const u8 *mac_addr;
 
-	mac_addr = of_get_mac_address(ks->spidev->dev.of_node);
+	mac_addr = of_get_mac_address(np);
 	if (!IS_ERR(mac_addr)) {
 		ether_addr_copy(dev->dev_addr, mac_addr);
 		ks8851_write_mac_addr(dev);
@@ -1541,7 +1542,7 @@ static int ks8851_probe(struct spi_device *spi)
 	ks->rc_ccr = ks8851_rdreg16(ks, KS_CCR);
 
 	ks8851_read_selftest(ks);
-	ks8851_init_mac(ks);
+	ks8851_init_mac(ks, dev->of_node);
 
 	ret = register_netdev(netdev);
 	if (ret) {
-- 
2.25.1


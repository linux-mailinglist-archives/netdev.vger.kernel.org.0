Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53560363826
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 00:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbhDRWUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 18:20:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:38308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235484AbhDRWUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 18:20:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31F10B143;
        Sun, 18 Apr 2021 22:19:53 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH v6 net-next 06/10] net: korina: Only pass mac address via platform data
Date:   Mon, 19 Apr 2021 00:19:44 +0200
Message-Id: <20210418221949.130779-7-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210418221949.130779-1-tsbogend@alpha.franken.de>
References: <20210418221949.130779-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of access to struct korina_device by just passing the mac
address via platform data and use drvdata for passing netdev to remove
function.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 arch/mips/rb532/devices.c     |  5 +++--
 drivers/net/ethernet/korina.c | 11 ++++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
index dd34f1b32b79..5fc3c8ee4f31 100644
--- a/arch/mips/rb532/devices.c
+++ b/arch/mips/rb532/devices.c
@@ -105,6 +105,9 @@ static struct platform_device korina_dev0 = {
 	.name = "korina",
 	.resource = korina_dev0_res,
 	.num_resources = ARRAY_SIZE(korina_dev0_res),
+	.dev = {
+		.platform_data = &korina_dev0_data.mac,
+	}
 };
 
 static struct resource cf_slot0_res[] = {
@@ -299,8 +302,6 @@ static int __init plat_setup_devices(void)
 	/* set the uart clock to the current cpu frequency */
 	rb532_uart_res[0].uartclk = idt_cpu_freq;
 
-	dev_set_drvdata(&korina_dev0.dev, &korina_dev0_data);
-
 	gpiod_add_lookup_table(&cf_slot0_gpio_table);
 	return platform_add_devices(rb532_devs, ARRAY_SIZE(rb532_devs));
 }
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 44fad9e924ca..d6dbbdd43d7c 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1055,7 +1055,7 @@ static const struct net_device_ops korina_netdev_ops = {
 
 static int korina_probe(struct platform_device *pdev)
 {
-	struct korina_device *bif = platform_get_drvdata(pdev);
+	u8 *mac_addr = dev_get_platdata(&pdev->dev);
 	struct korina_private *lp;
 	struct net_device *dev;
 	void __iomem *p;
@@ -1068,8 +1068,7 @@ static int korina_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	lp = netdev_priv(dev);
 
-	bif->dev = dev;
-	memcpy(dev->dev_addr, bif->mac, ETH_ALEN);
+	memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
 
 	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
 	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
@@ -1123,6 +1122,8 @@ static int korina_probe(struct platform_device *pdev)
 	lp->mii_if.phy_id_mask = 0x1f;
 	lp->mii_if.reg_num_mask = 0x1f;
 
+	platform_set_drvdata(pdev, dev);
+
 	rc = register_netdev(dev);
 	if (rc < 0) {
 		printk(KERN_ERR DRV_NAME
@@ -1140,9 +1141,9 @@ static int korina_probe(struct platform_device *pdev)
 
 static int korina_remove(struct platform_device *pdev)
 {
-	struct korina_device *bif = platform_get_drvdata(pdev);
+	struct net_device *dev = platform_get_drvdata(pdev);
 
-	unregister_netdev(bif->dev);
+	unregister_netdev(dev);
 
 	return 0;
 }
-- 
2.29.2


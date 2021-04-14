Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071E935F7D7
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352385AbhDNPah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:30:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:33238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352324AbhDNPaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:30:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 226D2B03C;
        Wed, 14 Apr 2021 15:29:50 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 7/9] net: korina: Add support for device tree
Date:   Wed, 14 Apr 2021 17:29:43 +0200
Message-Id: <20210414152946.12517-8-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414152946.12517-1-tsbogend@alpha.franken.de>
References: <20210414152946.12517-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is no mac address passed via platform data try to get it via
device tree and fall back to a random mac address, if all fail.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/korina.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 69c8baa87a6e..c4590b2c65aa 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -42,6 +42,8 @@
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/in.h>
+#include <linux/of_device.h>
+#include <linux/of_net.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/delay.h>
@@ -1056,7 +1058,7 @@ static const struct net_device_ops korina_netdev_ops = {
 
 static int korina_probe(struct platform_device *pdev)
 {
-	u8 *mac_addr = dev_get_platdata(&pdev->dev);
+	const u8 *mac_addr = dev_get_platdata(&pdev->dev);
 	struct korina_private *lp;
 	struct net_device *dev;
 	void __iomem *p;
@@ -1069,7 +1071,15 @@ static int korina_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	lp = netdev_priv(dev);
 
-	memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
+	if (mac_addr) {
+		ether_addr_copy(dev->dev_addr, mac_addr);
+	} else {
+		mac_addr = of_get_mac_address(pdev->dev.of_node);
+		if (!IS_ERR(mac_addr))
+			ether_addr_copy(dev->dev_addr, mac_addr);
+		else
+			eth_hw_addr_random(dev);
+	}
 
 	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
 	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
@@ -1149,8 +1159,21 @@ static int korina_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id korina_match[] = {
+	{
+		.compatible = "korina",
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, korina_match);
+#endif
+
 static struct platform_driver korina_driver = {
-	.driver.name = "korina",
+	.driver = {
+		.name = "korina",
+		.of_match_table = of_match_ptr(korina_match),
+	},
 	.probe = korina_probe,
 	.remove = korina_remove,
 };
-- 
2.29.2


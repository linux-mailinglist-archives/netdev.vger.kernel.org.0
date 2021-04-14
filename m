Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90A635FE2A
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhDNXHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:07:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:55842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234363AbhDNXHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:07:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4538CB11A;
        Wed, 14 Apr 2021 23:06:52 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 07/10] net: korina: Add support for device tree
Date:   Thu, 15 Apr 2021 01:06:44 +0200
Message-Id: <20210414230648.76129-8-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414230648.76129-1-tsbogend@alpha.franken.de>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is no mac address passed via platform data try to get it via
device tree and fall back to a random mac address, if all fail.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/korina.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 1d7dead17ac3..7646ccc9d7e8 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -43,6 +43,8 @@
 #include <linux/ioport.h>
 #include <linux/iopoll.h>
 #include <linux/in.h>
+#include <linux/of_device.h>
+#include <linux/of_net.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/delay.h>
@@ -1066,7 +1068,16 @@ static int korina_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	lp = netdev_priv(dev);
 
-	memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
+	if (mac_addr) {
+		ether_addr_copy(dev->dev_addr, mac_addr);
+	} else {
+		u8 ofmac[ETH_ALEN];
+
+		if (of_get_mac_address(pdev->dev.of_node, ofmac) == 0)
+			ether_addr_copy(dev->dev_addr, ofmac);
+		else
+			eth_hw_addr_random(dev);
+	}
 
 	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
 	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
@@ -1146,8 +1157,21 @@ static int korina_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id korina_match[] = {
+	{
+		.compatible = "idt,3243x-emac",
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


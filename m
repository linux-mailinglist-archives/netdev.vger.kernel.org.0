Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21421A8941
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503853AbgDNSX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:23:29 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58157 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503807AbgDNSVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:21:39 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 491v2640l8z1rqr6;
        Tue, 14 Apr 2020 20:21:18 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 491v263SCbz1qqkS;
        Tue, 14 Apr 2020 20:21:18 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id TVmDQBh1iZEO; Tue, 14 Apr 2020 20:21:17 +0200 (CEST)
X-Auth-Info: H4CU7Z5/JQBU/oTH0qG0qYjBZb/Wyp91UX208lxZifM=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 14 Apr 2020 20:21:17 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V4 14/19] net: ks8851: Factor out TX work flush function
Date:   Tue, 14 Apr 2020 20:20:24 +0200
Message-Id: <20200414182029.183594-15-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414182029.183594-1-marex@denx.de>
References: <20200414182029.183594-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the SPI version of the KS8851 requires a TX worker thread to pump
data via SPI, the parallel bus version can write data into the TX FIFO
directly in .ndo_start_xmit, as the parallel bus access is much faster
and does not sleep. Factor out this TX work flush part, so it can be
overridden by the parallel bus driver.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V3: New patch
V4: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 5dbbde5929d0..0e69b9bcd6ab 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -781,6 +781,17 @@ static void ks8851_tx_work(struct work_struct *work)
 	ks8851_unlock(ks, &flags);
 }
 
+/**
+ * ks8851_flush_tx_work - flush outstanding TX work
+ * @ks: The device state
+ */
+static void ks8851_flush_tx_work(struct ks8851_net *ks)
+{
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+
+	flush_work(&kss->tx_work);
+}
+
 /**
  * ks8851_net_open - open network device
  * @dev: The network device being opened.
@@ -880,11 +891,8 @@ static int ks8851_net_open(struct net_device *dev)
 static int ks8851_net_stop(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
-	struct ks8851_net_spi *kss;
 	unsigned long flags;
 
-	kss = to_ks8851_spi(ks);
-
 	netif_info(ks, ifdown, dev, "shutting down\n");
 
 	netif_stop_queue(dev);
@@ -896,7 +904,7 @@ static int ks8851_net_stop(struct net_device *dev)
 	ks8851_unlock(ks, &flags);
 
 	/* stop any outstanding work */
-	flush_work(&kss->tx_work);
+	ks8851_flush_tx_work(ks);
 	flush_work(&ks->rxctrl_work);
 
 	ks8851_lock(ks, &flags);
-- 
2.25.1


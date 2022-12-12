Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE3C649D88
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiLLLYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiLLLYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:24:05 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19B6F4;
        Mon, 12 Dec 2022 03:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670844218; x=1702380218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4hyjin04xcLN2c4aQwMYUFRysfBo+OuGNZ4sZbmy7iY=;
  b=JMp47GQvRETmeC+FBbsA7kdC7NNXbHechA4zaW6WGEJ4k4POLpM6fh8P
   tR9voUcrl2HeLUwYUszFbbjCaqtq09xAy7ft+dENyjCWTfphUojT4HKDn
   mHYwMCZrfKDjuJvdZTrT3fpilAhFSt/3ccnF3q/eDQxKW1xDY4dLZlZpk
   7Abr8ezx/pTbHvpvJbw6k9brh0CNiGiRdWWzcjzOwyw4QH6+Q6xUqk/Zh
   xkKrALvOnrRsNm4yiEmICZuuLW3Ds2j08kUoYNxoRPQw4bQYRUt/prQ1b
   8kj2eZ+glSjl6d/VTxkzyPoSXIxq0hrCVcN9AzY9XKEiZ9EvPsRrEZM66
   g==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="127662353"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 04:23:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 04:23:38 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 04:23:35 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <sergiu.moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 2/2] net: macb: use phylink_suspend()/phylink_resume()
Date:   Mon, 12 Dec 2022 13:28:45 +0200
Message-ID: <20221212112845.73290-3-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221212112845.73290-1-claudiu.beznea@microchip.com>
References: <20221212112845.73290-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use phylink_suspend() and phylink_resume() for macb driver instead
of phylink_start()/phylink_stop(). This helps on fixing
commit bf0ad1893442 ("net: macb: Specify PHY PM management done by MAC").

Commit bf0ad1893442 ("net: macb: Specify PHY PM management done by MAC")
signals to PHY layer that the PHY PM management is done by the MAC driver
itself. In case this is done the mdio_bus_phy_suspend() and
mdio_bus_phy_resume() will return just at its beginning letting the MAC
driver to handle the PHY power management.

AT91 devices (e.g. SAMA7G5, SAMA5D2) has a special power saving mode
called backup and self-refresh where most of the SoCs parts are shutdown
on suspend and RAM is switched to self-refresh. The rail powering the
on-board ethernet PHY could also be closed.

For scenarios where backup and self-refresh is used the MACB driver needs
to re-initialize the PHY device itself when resuming. Otherwise there is
poor or missing connectivity (e.g. SAMA7G5-EK uses KSZ9131 in RGMII mode
which needs its DLL settings to satisfy RGMII timings). For this call
phylink_suspend()/phylink_resume() on suspend/resume path.

The patch has been tested on SAMA7G5EK (with KSZ9131 and KSZ8081 PHYs)
and SAM9X60EK (with KSZ8081 PHY) boards.

Fixes: bf0ad1893442 ("net: macb: Specify PHY PM management done by MAC")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---

This patch depends on patch 1/2 from this series. For proper backporting
to older kernel (in case this series is integrated as is) please add the
Depends-on tag on this patch after patch 1/2 is integrated in networking
tree.

Thank you,
Claudiu Beznea

 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 95667b979fab..bcd394093d1c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5142,9 +5142,13 @@ static int __maybe_unused macb_suspend(struct device *dev)
 		napi_disable(&queue->napi_tx);
 	}
 
-	if (!(bp->wol & MACB_WOL_ENABLED)) {
+	if (bp->wol & MACB_WOL_ENABLED) {
 		rtnl_lock();
-		phylink_stop(bp->phylink);
+		phylink_suspend(bp->phylink, true);
+		rtnl_unlock();
+	} else {
+		rtnl_lock();
+		phylink_suspend(bp->phylink, false);
 		phy_exit(bp->sgmii_phy);
 		rtnl_unlock();
 		spin_lock_irqsave(&bp->lock, flags);
@@ -5209,13 +5213,6 @@ static int __maybe_unused macb_resume(struct device *dev)
 		spin_unlock_irqrestore(&bp->lock, flags);
 
 		disable_irq_wake(bp->queues[0].irq);
-
-		/* Now make sure we disable phy before moving
-		 * to common restore path
-		 */
-		rtnl_lock();
-		phylink_stop(bp->phylink);
-		rtnl_unlock();
 	}
 
 	for (q = 0, queue = bp->queues; q < bp->num_queues;
@@ -5238,7 +5235,7 @@ static int __maybe_unused macb_resume(struct device *dev)
 	if (!device_may_wakeup(&bp->dev->dev))
 		phy_init(bp->sgmii_phy);
 
-	phylink_start(bp->phylink);
+	phylink_resume(bp->phylink);
 	rtnl_unlock();
 
 	netif_device_attach(netdev);
-- 
2.34.1


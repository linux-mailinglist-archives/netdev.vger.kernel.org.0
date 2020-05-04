Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36101C3BA4
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgEDNrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:47:17 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:21383 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728315AbgEDNrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 09:47:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588600034; x=1620136034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mzrqr3G8iZcqzNlVDE8Bp5RQaqxIcZQVI/t/Po77lqo=;
  b=Dzvo488rFJa9UZTXw3ieACa6lO5TM2ZkVNSbdGR1fefCydRi8+djJAbB
   iJ+GQyxgwlzDFFvAUJDXJbU4wpRhnUnW2ZsOi5AKFWwoePSJqh0pRJqXz
   ontKjKxTPcqzTqncKyA5AXYUbBoit4VDR/+FWKzofCXtUQC0UpOIBIFK3
   lI+eEoTO1+kgpo2WS2O9NVuZKwF3LMn0DKyHoVjh3Af3iNXHlC41Hv9gi
   xwBOmvKERyCl5v6cXMIxgWAIxp6CJx/Keid8sRpMmhWUrP0c5/EScQ3lk
   PgP43FFx+9ZEIzHFW0jnB2yppPvlu18vIbl9u/UQ3w/volzMPYIj23fC4
   A==;
IronPort-SDR: LeACB26FaamIcb3cWCu14cDkh7tkabI+Vn9g6mb3xiWVIhmhOIFGRmrVEaPdZYcyRxphPIvZDb
 bCeBfPdHJzJ0mmMOQ7lZSLepDazjBEc+AEMm66TG9HDNtrHpg1Bc8t/HUg8+hCagAZzOAvj6QU
 3cqm82Tuq0a13UI//9/vdtaT394pfxcMM137Qx4Q9u8655KKUIgbHJdjK/RjqgX6dr5ZoEvLZ/
 a3Yn0ml1wP7PlX8eqixy+x2euT/aUdRWeSDJl/5jCUS4Fp4k/3ZSZdy05ydRkTnBECJwQItQlb
 VYE=
X-IronPort-AV: E=Sophos;i="5.73,352,1583218800"; 
   d="scan'208";a="74135784"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2020 06:46:46 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 May 2020 06:46:47 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 4 May 2020 06:46:43 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Sergio Prado <sergio.prado@e-labworks.com>
Subject: [PATCH v3 5/7] net: macb: fix call to pm_runtime in the suspend/resume functions
Date:   Mon, 4 May 2020 15:44:20 +0200
Message-ID: <e985e9247478205d66507cd1bd74b6f8fb6c829f.1588597759.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1588597759.git.nicolas.ferre@microchip.com>
References: <cover.1588597759.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

The calls to pm_runtime_force_suspend/resume() functions are only
relevant if the device is not configured to act as a WoL wakeup source.
Add the device_may_wakeup() test before calling them.

Fixes: 3e2a5e153906 ("net: macb: add wake-on-lan support via magic packet")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Sergio Prado <sergio.prado@e-labworks.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Changes in v3:
 - remove the parenthesis around device_may_wakeup()
Changes in v2:
- new in v2 serries

 drivers/net/ethernet/cadence/macb_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 72b8983a763a..b42831966ffa 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4564,7 +4564,8 @@ static int __maybe_unused macb_suspend(struct device *dev)
 
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(netdev);
-	pm_runtime_force_suspend(dev);
+	if (!device_may_wakeup(dev))
+		pm_runtime_force_suspend(dev);
 
 	return 0;
 }
@@ -4579,7 +4580,8 @@ static int __maybe_unused macb_resume(struct device *dev)
 	if (!netif_running(netdev))
 		return 0;
 
-	pm_runtime_force_resume(dev);
+	if (!device_may_wakeup(dev))
+		pm_runtime_force_resume(dev);
 
 	if (bp->wol & MACB_WOL_ENABLED) {
 		macb_writel(bp, IDR, MACB_BIT(WOL));
-- 
2.26.2


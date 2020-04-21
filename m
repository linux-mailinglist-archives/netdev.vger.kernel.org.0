Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662661B240D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgDUKlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:41:53 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:49903 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728510AbgDUKlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 06:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587465713; x=1619001713;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TztiFxj6Z+X7Jvou8xEXYwVYRRAwnN1c+02Sl4F7ae8=;
  b=qECgxPjIG5HiYltm7TD1wDKR6+xpmy/jSmu8048xE1EQJZW0y4Aa0wlv
   KeYDZKqETURL8Hau7UQ8zuS1omvCxl2jUyUzzPRVUeqanZRS6TSDq1glt
   rRLts+eM/ctsXd1zvccAT/z5jul34AgHQdYNB7Fwgx+0QpT98w6OLX7T9
   CfGQCqDdRsRfnrkqV1ahBEmH4vqYxq+BDEHMtK7VONtDkz1VxqA+LO9Zq
   A98Oet/ps1UXaflIF+HAld/KVfqNmAhTQ0Lp3eHa4AK6cyqbjNjjlPGXh
   0MAveJG82yhFzMKMYRX2eBU0EYro42JFR5gCqyro64cZ0OiLxGTw4hUH9
   g==;
IronPort-SDR: 8n0nT7x0fnPmC3HBXMsPZGR9y8V2byVNe++dtzsAvZovsV35htCiHqk/1VyUCChy136/NkiNyN
 RiqQBbUcGU3It9C2y/P3pGyUlkhhOC1Ew7p1hioUqsIzJgfu/XZ929qw8O1CsgStqrBhAZzPZ2
 R7gSavMtdKvuolQ9e6c6LdES7tA6A8/cvp0dw8h8hmOGRBde9iH2cs6P5h9q/DkaEKfN4m05VZ
 n16/kNMAIqIC0QwUXUcCBtZKNM8lV1rNsNNfQBUEBy+fgn2J2Sy7TQqWOL+8hwfB27N8fcqvED
 ipg=
X-IronPort-AV: E=Sophos;i="5.72,410,1580799600"; 
   d="scan'208";a="73257510"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2020 03:41:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 03:41:54 -0700
Received: from ness.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 21 Apr 2020 03:41:49 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <sergio.prado@e-labworks.com>, <antoine.tenart@bootlin.com>,
        <f.fainelli@gmail.com>, <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v2 5/7] net: macb: fix call to pm_runtime in the suspend/resume functions
Date:   Tue, 21 Apr 2020 12:41:02 +0200
Message-ID: <1c537d1287aaf57b8b20a923686dbb551e1727f0.1587463802.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1587463802.git.nicolas.ferre@microchip.com>
References: <cover.1587463802.git.nicolas.ferre@microchip.com>
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
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Changes in v2:
- new in v2 serries

 drivers/net/ethernet/cadence/macb_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 72b8983a763a..8cf8e21fbb07 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4564,7 +4564,8 @@ static int __maybe_unused macb_suspend(struct device *dev)
 
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(netdev);
-	pm_runtime_force_suspend(dev);
+	if (!(device_may_wakeup(dev)))
+		pm_runtime_force_suspend(dev);
 
 	return 0;
 }
@@ -4579,7 +4580,8 @@ static int __maybe_unused macb_resume(struct device *dev)
 	if (!netif_running(netdev))
 		return 0;
 
-	pm_runtime_force_resume(dev);
+	if (!(device_may_wakeup(dev)))
+		pm_runtime_force_resume(dev);
 
 	if (bp->wol & MACB_WOL_ENABLED) {
 		macb_writel(bp, IDR, MACB_BIT(WOL));
-- 
2.20.1


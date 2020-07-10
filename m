Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7511521B56A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgGJMrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:47:47 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:50564 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgGJMrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594385259; x=1625921259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F198PHt3CmmrCPyBEGbcvHM9j1ntyqNfdwfITtlue5c=;
  b=ThsXM2K90MFFuEGtgYxvZ07M8KLSRku348/7A1WtorNpHn3DET3x7wYP
   rthbetdaWbhS2JbCFIF4Bdkmc4/y6h2kiMczev1YxDEc9S0dqf6VqO2zF
   st68rL3ArmY8GDGGi/mHa9KYnGlxYL/vhir8kuetLucqJmtf8zXQfJzO0
   y9kMeVX4B4qXkaOVts6Djp88jaKw07LkKn7BvbhngZupBtl7AvktMLpUP
   0o86j13aXtueOBoZ9GbnPQM5dpjKRd/NjF7TwcnkF9O38FtlNSjmrouA8
   8x4wInunZ3lHQrUVFLkSSFI2pL7zm66p69NJQzOQemFy5EP+7uGuMNnMN
   A==;
IronPort-SDR: HBrMMwKuQf6Di2FjkopmR62P4XsHGDVVK0EcV4Qycn5uxTjsqfSMYOw02a3/ONXxVGifaPQGNr
 ZJCEgKFg3nPdEC4lIOCIimu1j438AkraRJ79I2NB/i1xEmbzlHs2dX7M2PhYcJheq0MohvDVnR
 TMMsPcTnNfqAMnoF7RrtsSNWW8sOySK4GbCTy17m/1wmfGd+Bx8fa2lbscmjD/lW+q9/JJ5RK2
 P+g/oIfXZwj01BfvX5/DPFRRnQabec5l9WkvDAU4OpWvfRxswus0RT2WEhBzDWO++Y6wEIfimW
 zjQ=
X-IronPort-AV: E=Sophos;i="5.75,335,1589266800"; 
   d="scan'208";a="83305801"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jul 2020 05:47:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 10 Jul 2020 05:47:39 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 10 Jul 2020 05:47:35 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux@armlinux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sergio Prado <sergio.prado@e-labworks.com>
Subject: [PATCH v5 5/5] net: macb: fix call to pm_runtime in the suspend/resume functions
Date:   Fri, 10 Jul 2020 14:46:45 +0200
Message-ID: <5d36a9f6956fb4fb55778cabd2c21bbfc3670cf5.1594384335.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1594384335.git.nicolas.ferre@microchip.com>
References: <cover.1594384335.git.nicolas.ferre@microchip.com>
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
index 548815255e22..f1f0976e7669 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4606,7 +4606,8 @@ static int __maybe_unused macb_suspend(struct device *dev)
 
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(netdev);
-	pm_runtime_force_suspend(dev);
+	if (!device_may_wakeup(dev))
+		pm_runtime_force_suspend(dev);
 
 	return 0;
 }
@@ -4621,7 +4622,8 @@ static int __maybe_unused macb_resume(struct device *dev)
 	if (!netif_running(netdev))
 		return 0;
 
-	pm_runtime_force_resume(dev);
+	if (!device_may_wakeup(dev))
+		pm_runtime_force_resume(dev);
 
 	if (bp->wol & MACB_WOL_ENABLED) {
 		macb_writel(bp, IDR, MACB_BIT(WOL));
-- 
2.27.0


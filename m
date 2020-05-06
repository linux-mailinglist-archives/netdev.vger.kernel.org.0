Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67DF1C6F83
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgEFLmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:42:18 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:59009 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgEFLmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588765335; x=1620301335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rNIeyGDtU/ObatCtRK8/2BrcAEK4nBJLJd7TnqPJUmc=;
  b=qfr429YkEiv0TNHeWlt6l3wCC8YSTzrVqWSj3XJeU3PG1BzHFtkpTa8P
   saSUJzU2Y0jNRPJdX0FUZU9+UNa9f/PcAKcGzT5E1VJ8OLOtU/WIgoNxQ
   VRHp6S+l3eHrBE1Gz5YhkC3U31WsAHAwcqLoydT16BYLZOf4ACNyMDOCo
   gEcJpdAzjKsnFTTYIZQ0stA74kbFG3H8CIdIT7LwnyzLp6b8hPob6JHRl
   a9/k4MEraDcOZ8YcggeHQIuqYwlYBmLZdbdAK+a+JOpcDBI2oujBdFupz
   DgK6Xtn4+BqsbetaFnR1agK5/8CeW/0405q3jue2WgbbNXwHeZ76A0X8T
   g==;
IronPort-SDR: Il0T3scwtTKFf3RazNpNV6QZOoRnf34El2f2q5I7L6wzLDqMeUHQE2D7gxrYQvMiChTk8QRa/U
 sIqWsbdvySFQaeRX77yPbI5rq91NNWjH0Jb6pMu095vjFrpWDIDh3XChqwT7QV3r49D4iFAwHM
 gozXyHi64oDnaioMCZnrwEO/uaZFnaqNDe7UWakhTJMAk2iHxRy4eTTyHd2YDm0GE3JRLmCPlq
 1TYUCiWOkmr9+FGtz5lV9TT6lkctr1xZ7uSZapQ7u3OdZTys8eR3cilC5ejvqCaX+9zPLZXv3a
 X4k=
X-IronPort-AV: E=Sophos;i="5.73,358,1583218800"; 
   d="scan'208";a="72599461"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 May 2020 04:42:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 May 2020 04:42:13 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 6 May 2020 04:42:09 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sergio Prado <sergio.prado@e-labworks.com>
Subject: [PATCH v4 5/5] net: macb: fix call to pm_runtime in the suspend/resume functions
Date:   Wed, 6 May 2020 13:37:41 +0200
Message-ID: <c7c517840ce8c166c83f45e66169e40c1614323f.1588763703.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1588763703.git.nicolas.ferre@microchip.com>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
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
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Sergio Prado <sergio.prado@e-labworks.com>
---
Changes in v3:
 - remove the parenthesis around device_may_wakeup()
Changes in v2:
- new in v2 serries

 drivers/net/ethernet/cadence/macb_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index ebc57cd5d286..f01b9831b219 100644
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


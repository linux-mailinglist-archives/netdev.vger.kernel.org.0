Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03081210BC8
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbgGANJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:09:08 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:19142 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730656AbgGANJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593608945; x=1625144945;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=XzCEHryWqOM5CL+btlhdGuzPRS8MM+9xlY7gzr5UCZE=;
  b=kR+sTApWuNADAsAsYtrJKvC0DlNf25MD83qPI4/Jx4JRAoWNHolY2W8g
   U7Ny9rV6MXSVmwAuQXbWHzGnVoDs9M4MS9zHtRloGFkHGk+fePFGTa0le
   l3G5K9uSvGPFTQiCS0fAJkDM7ie34TJssYxMnHXy8+9AXG8M/PXPOGUea
   FZxlXOERamkhDDJT48vFfOPV3S1iGTNM5Qy55PLsS2p5FblphtBkVE8St
   B42gUpwjzqML88HkZBHeefJVjl9Rfu9FxFM0VSkyFW8CLZigWZxqf3dXp
   BeBCFb+mHxDPWi/e6LrsoBlwqwUEe3WWKgSFvzI0dixTToWFFEI2BqU/J
   A==;
IronPort-SDR: Ph9bDs0MmLYfgNTOtupzXCfFlSYUyJG3aHxlcZbtjoMvW/bEPUheGixMLiWC+y2UNnENXfiozI
 W79bSBwIzFb/SEIbDuBnMUVFDRSJCFXfJHe3Y+w5W4hxmagk0tuAXtZnKrDYqvoQI9QjEZ7Jqh
 FQUHYEdlblaOm0ytzi6ifo12swZmJttOmK8BElDG8GANxCdIixrZDNtwysordHQLL3mCsgV6df
 zLSfc41ZopWDJ0/AMXxeqpwFZ7dsO5M5uW+IyePMgyXbLJvN8klcbK/q0Mqvuv1HuinZh/1m0I
 G4I=
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="78416751"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2020 06:09:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 06:09:03 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 1 Jul 2020 06:09:01 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH net-next 2/4] net: macb: use hweight_long() to count set bits in queue_mask
Date:   Wed, 1 Jul 2020 16:08:49 +0300
Message-ID: <1593608931-3718-3-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593608931-3718-1-git-send-email-claudiu.beznea@microchip.com>
References: <1593608931-3718-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use hweight_long() to count set bits in queue_mask.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1bc2810f3dc4..a84fb0ec53f0 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3482,8 +3482,6 @@ static void macb_probe_queues(void __iomem *mem,
 			      unsigned int *queue_mask,
 			      unsigned int *num_queues)
 {
-	unsigned int hw_q;
-
 	*queue_mask = 0x1;
 	*num_queues = 1;
 
@@ -3498,10 +3496,7 @@ static void macb_probe_queues(void __iomem *mem,
 
 	/* bit 0 is never set but queue 0 always exists */
 	*queue_mask |= readl_relaxed(mem + GEM_DCFG6) & 0xff;
-
-	for (hw_q = 1; hw_q < MACB_MAX_QUEUES; ++hw_q)
-		if (*queue_mask & (1 << hw_q))
-			(*num_queues)++;
+	*num_queues = hweight_long(*queue_mask);
 }
 
 static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
-- 
2.7.4


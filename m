Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BFC211F6D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgGBJGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:06:18 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:36970 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728007AbgGBJGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:06:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593680773; x=1625216773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=hdBxsJpIMlUAhERIUrk8OUIJLTgTJN06lLiI6/LIGnQ=;
  b=Z0doXzHl5ANoVPTCPg0SwFXFaYSmQXUc3/H8jdPaSxIyPlMyUGCqaYpu
   /cx1xO0uQKTkxm20SVsExREuSjAAi86GaHFSRS0zkyC3StpXX96bSBR1m
   ia55ML/UFQUP5P35sInRaJHl4EUxT9j+iudqnRu7zU/gv++xGf9XL9TnJ
   GGCsGlRck34hOfCiQiA/npv5C01Ww7om8LPCpGWE9Utm/yE6Tnmc3m9Nj
   FMIbqIUItTZXaB+sUiGjQPKFE6UpW1MmRwMYWsx4Vp+TyQYZHO3/H13na
   qhRNMVRgqJCso8815AqSIN8NpdV2oFrUhQA6hRPw0Frybe07mq3k2o5r7
   Q==;
IronPort-SDR: x4PBH9a9causajG2RrU2lSZfac+1j6BfVbut7tPSf8Cz0nPODmzcodFWswr8Tosee5SPkEbB0Y
 NNFtsmGwKzvp/zVK7hta2As+Q13iW+YKFIqWQr4eepInx88IoxUELJnXEGfFX7Tn2YqI2owXBt
 BP7d1q6+NbTstvODrn7rcfPOvUeOUX+43IjKGNDjuDTincH/pcANCy2Li3+lAb2720oWV3Nxp7
 Sf5EN7FJhBvc6LxPhkGfsbMZBXPz7TwGL+CN/EL+XGqGWYLtm7v4R0Co+3sMgm7Mf8U6yQC7hx
 ksc=
X-IronPort-AV: E=Sophos;i="5.75,303,1589266800"; 
   d="scan'208";a="80473465"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 02:06:12 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 02:06:12 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 02:06:09 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH net-next v2 2/4] net: macb: use hweight32() to count set bits in queue_mask
Date:   Thu, 2 Jul 2020 12:05:59 +0300
Message-ID: <1593680761-11427-3-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
References: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use hweight32() to count set bits in queue_mask.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1bc2810f3dc4..7668b6ae8822 100644
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
+	*num_queues = hweight32(*queue_mask);
 }
 
 static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
-- 
2.7.4


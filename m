Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9EC2CEE2D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388208AbgLDMgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:36:22 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5291 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388195AbgLDMgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607085381; x=1638621381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ZYRrAJmxsOLG1C4vggyXLYq/gsMVkhtO66yVO0ElffY=;
  b=DIn2pJOwlrqlsBCoUTMQNCJUKvHL/n5gJqxprTJT7BnZY4s/YuYnF03B
   Hk6vMjivPVZL+NvjdfK0OfCfx2I/F9BNvs7CCJj8INFxiixShUSgCepRl
   NOqIA5DuF2AqX6WQ5PIQN27Impx7oXyq5wiaS+Zick0UjjIdCD9Bfwt2W
   56lABJitiCn9kSAUDhA+yAW57wD+xRW7tF3GhrbE6ybfSVXlwdo1PPacn
   Vhqc65TQ+/JmKqAeXzxx29zMs910L7I9bhuSXEWXq3V79aTkLAtg8dV17
   UBRJjViXBglkpf51yGwbLGgeGqzidJvlAYzuS7L3qw3XKdL7h7IAHxn7y
   A==;
IronPort-SDR: 4AgOSzrzKBHkNPgP4TDvpq/4MMDbEvMfa3ctVdWJtakul0osZdMjb+zVwKWIiNNrFbzI9gkAJO
 umP64wCuPfZhOB2sNZepGIbCzxP58WCy7dbGMgkm/JngK3qXPhHfyrO55PDJ4dkIBCzN81YoW7
 46nx8e5US0pZVDZPISgMh6coklxQGZeV0eJqPHEggAC5GvRAFeTXvEbjNiW3dz8IKvAVs60Bto
 Ke54RAUK0aF0JW3Zf6qVFSN7JCR/QuMSQD1LCVct8xbGMpYICNdIBxb9KiHnmmzCyG8URFuzfj
 k1c=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="36120031"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 05:34:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 05:34:52 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Dec 2020 05:34:48 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 3/7] net: macb: unprepare clocks in case of failure
Date:   Fri, 4 Dec 2020 14:34:17 +0200
Message-ID: <1607085261-25255-4-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unprepare clocks in case of any failure in fu540_c000_clk_init().

Fixes: c218ad559020 ("macb: Add support for SiFive FU540-C000")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b23e986ac6dc..29d144690b3b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4406,8 +4406,10 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
 		return err;
 
 	mgmt = devm_kzalloc(&pdev->dev, sizeof(*mgmt), GFP_KERNEL);
-	if (!mgmt)
-		return -ENOMEM;
+	if (!mgmt) {
+		err = -ENOMEM;
+		goto err_disable_clocks;
+	}
 
 	init.name = "sifive-gemgxl-mgmt";
 	init.ops = &fu540_c000_ops;
@@ -4418,16 +4420,29 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
 	mgmt->hw.init = &init;
 
 	*tx_clk = devm_clk_register(&pdev->dev, &mgmt->hw);
-	if (IS_ERR(*tx_clk))
-		return PTR_ERR(*tx_clk);
+	if (IS_ERR(*tx_clk)) {
+		err = PTR_ERR(*tx_clk);
+		goto err_disable_clocks;
+	}
 
 	err = clk_prepare_enable(*tx_clk);
-	if (err)
+	if (err) {
 		dev_err(&pdev->dev, "failed to enable tx_clk (%u)\n", err);
-	else
+		goto err_disable_clocks;
+	} else {
 		dev_info(&pdev->dev, "Registered clk switch '%s'\n", init.name);
+	}
 
 	return 0;
+
+err_disable_clocks:
+	clk_disable_unprepare(*tx_clk);
+	clk_disable_unprepare(*hclk);
+	clk_disable_unprepare(*pclk);
+	clk_disable_unprepare(*rx_clk);
+	clk_disable_unprepare(*tsu_clk);
+
+	return err;
 }
 
 static int fu540_c000_init(struct platform_device *pdev)
-- 
2.7.4


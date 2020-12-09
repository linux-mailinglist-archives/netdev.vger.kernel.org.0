Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643742D42C2
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgLINF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:05:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:14921 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732010AbgLINFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:05:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607519140; x=1639055140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=2gtmPImZJqTqAOcYnnKg5lBBYuivMfmwZUbTvhVYNjo=;
  b=tCfcW0pteTcBYK4Duy7ME1BB0l8ZPRV0Tfa25slHwAwJdbf3EMSEh8wG
   DMeVSnPrf8hsiEr+Przk2oF4SMbCkv9vG3cgGPb1utGdziMYrJgqz06ze
   0sRKSQWhsBr+faYus1dSZ1mSChTDMwXQk5kk3DCFMgbcTuOIbqCrZAUpM
   KPhBW9mp6IrB5yHGoZUfoqWwNyGiqZmPzYu+TS49ZilWcVZHgZ5/JqYq6
   4GpiONiD+HgnVJ6T48L8syB3E/jArdQRlb3R+aPUNNzL9ritAuU7GwYCp
   Ue1Eynu3cY/87OeYy3/eNFOk4wZcu/JPJni2l1iyfLHRKgOidZOcSL0bg
   w==;
IronPort-SDR: vFiTbQfk6J4iqVIOgnonrgxCYXxmuQVOL8Za41LC9NtBkiTZHXjCPRDE9B8H4SRPXOCreQHHVm
 BQ+0It/ump/RY8XjC028FQkuWbOF8EGKyoCu4pevo7Q3+l+XcV2VMqQBrt0BXmZGzKR+CC1H1B
 tE9syZqKNIQRPKdgz7bHbNK88Y/imOUDnUy+UH8TGuKpDMfg48m5x06nhxe0yjfamwpktEWrck
 z0/0+1guZwFSvyw8TvtDwjMrBU1jTPdXUMj43KXPapSdJKEIDfF6xASy/Cq5ac3gHs+nB+5iNg
 VI8=
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="36780711"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2020 06:04:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 06:04:10 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 9 Dec 2020 06:04:04 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <natechancellor@gmail.com>, <ndesaulniers@google.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        <clang-built-linux@googlegroups.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v3 4/8] net: macb: unprepare clocks in case of failure
Date:   Wed, 9 Dec 2020 15:03:35 +0200
Message-ID: <1607519019-19103-5-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unprepare clocks in case of any failure in fu540_c000_clk_init().

Fixes: c218ad559020 ("macb: Add support for SiFive FU540-C000")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 81704985a79b..11bf4f8d32e1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4420,8 +4420,10 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
 		return err;
 
 	mgmt = devm_kzalloc(&pdev->dev, sizeof(*mgmt), GFP_KERNEL);
-	if (!mgmt)
-		return -ENOMEM;
+	if (!mgmt) {
+		err = -ENOMEM;
+		goto err_disable_clks;
+	}
 
 	init.name = "sifive-gemgxl-mgmt";
 	init.ops = &fu540_c000_ops;
@@ -4432,16 +4434,26 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
 	mgmt->hw.init = &init;
 
 	*tx_clk = devm_clk_register(&pdev->dev, &mgmt->hw);
-	if (IS_ERR(*tx_clk))
-		return PTR_ERR(*tx_clk);
+	if (IS_ERR(*tx_clk)) {
+		err = PTR_ERR(*tx_clk);
+		goto err_disable_clks;
+	}
 
 	err = clk_prepare_enable(*tx_clk);
-	if (err)
+	if (err) {
 		dev_err(&pdev->dev, "failed to enable tx_clk (%u)\n", err);
-	else
+		*tx_clk = NULL;
+		goto err_disable_clks;
+	} else {
 		dev_info(&pdev->dev, "Registered clk switch '%s'\n", init.name);
+	}
 
 	return 0;
+
+err_disable_clks:
+	macb_clks_disable(*pclk, *hclk, *tx_clk, *rx_clk, *tsu_clk);
+
+	return err;
 }
 
 static int fu540_c000_init(struct platform_device *pdev)
-- 
2.7.4


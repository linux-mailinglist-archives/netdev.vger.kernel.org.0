Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DE92D1065
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgLGMRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:17:49 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39664 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbgLGMRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343467; x=1638879467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=TJec6laP3U2dQpM29pTaje0RjHN/42bGkpbwVNqFEHE=;
  b=HIXzNJmrJFrRwPV5uSffpW72zwU2ma2ZJNXtbBkLEhQ6UZkfVlrC6W6d
   pJod2HMF8jPFtslz8e1pgwir4yI4tosTNH/5mFkLCGLExL41gWWY5Mq+G
   +d4P5IgkElWkUO/3yudvQR3JVmqKOklLhbj48UaBwmUEL/WAVvO3jDs14
   YrgKQFvqOITILctxCKi33WkShIRGZkoIXmqRmtq3cXmCxN37rNUdktLXT
   /UlVIpH/+unPQbS7OaKf6f6eWLQattOPxLk2yLC6fRc7GjETRD8lybANK
   Un8LbTKmvZ6/5kVcZFlT1fSI908nw7gALuyRgoGegRbxVYmdQKi76VX3Q
   w==;
IronPort-SDR: G3xpn1h0+A4rL9uuIK8v9diM/D/BJQWjlAyN+8NgcvJC4w+ywqBGCRHufMiyB/2Aauxh/yUpIR
 n0j6/khuLgBSKcb0bL2cvmcwM6Jek14caEp2I3OwxpelBv/IuPB6LLbR9GeBOBED6drom7Iaea
 BriKCeKLI7oqLVX4t6u0iwqqGVV/Ml2UIAMn0FwR9TmxZmSij4YVmgYVdXe9w7qAkYlm8tkzan
 pxve9DTxV8kmE8KeWixVOd6miH1PaTUpr7FlIP2q4nrUKF6KLMDRWCH/QMCwrGPwQ+V4e9eUyX
 84w=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="106497470"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:16:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:16:14 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:16:08 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 4/8] net: macb: unprepare clocks in case of failure
Date:   Mon, 7 Dec 2020 14:15:29 +0200
Message-ID: <1607343333-26552-5-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
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
index 6b8e1109dfd3..deb232801edb 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4413,8 +4413,10 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
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
@@ -4425,16 +4427,26 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
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


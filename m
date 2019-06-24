Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C905020F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfFXGTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:19:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46875 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFXGTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:19:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id v9so6504744pgr.13
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 23:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding:cc:from:to;
        bh=OcP6hj7tVdb00oOalvGnDuFnDJEpeIxlfew5BWx3zwY=;
        b=Y65Xlw6SwHErNxqD4SLZMS9FzDPxjcRRZwkgxPl9fUZtrxwQiE1GmvYexVyysrdr1C
         8rwZeN5CAexdyKoHFH9py2HKuJ6BHaE2fxXFZdCP+c5fagd/eaWno5U1ZimG7cva0oU+
         QrswyR/DBVEziUUXgJ01hhow2nBOsGju4cF3svLuBvagiUKpwVU0aC2k9+rvQaxiqz0W
         b96rPQr2fV13kxU4WLoo1Mj0S7mR/XDaZN10UV9QiAtsJN3L6Pz3lKxWfXDN2EemrCCS
         Sb09jUnUnufybnjh+SH8NXxoNHnYcg2EPMZe/Aw3+0PxIXoXqFSwaEOdKVzRkWZ0mRgR
         bzoQ==
X-Gm-Message-State: APjAAAUin/mc3TV5+WNP7LxAkI2WC5J0Et/5K32dnrev3n+uSLc4rXOT
        0T2BUiV6T1mnFeGQlZUD8sUC8w==
X-Google-Smtp-Source: APXvYqxWxk+Q0WrIX6NTYBGF225V5ZWdIzzl0Uym4Egmm1b+5SGq545NIDUFJBCReAQK7uY/4Rfo6Q==
X-Received: by 2002:a65:5889:: with SMTP id d9mr18651598pgu.39.1561357146792;
        Sun, 23 Jun 2019 23:19:06 -0700 (PDT)
Received: from localhost (220-132-236-182.HINET-IP.hinet.net. [220.132.236.182])
        by smtp.gmail.com with ESMTPSA id x128sm17083946pfd.17.2019.06.23.23.19.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 23:19:06 -0700 (PDT)
Subject: [PATCH 1/2] net: macb: Fix compilation on systems without COMMON_CLK
Date:   Sun, 23 Jun 2019 23:16:02 -0700
Message-Id: <20190624061603.1704-2-palmer@sifive.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190624061603.1704-1-palmer@sifive.com>
References: <20190624061603.1704-1-palmer@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>
From:   Palmer Dabbelt <palmer@sifive.com>
To:     davem@davemloft.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch to add support for the FU540-C000 added a dependency on
COMMON_CLK, but didn't express that via Kconfig.  This fixes the build
failure by adding CONFIG_MACB_FU540, which depends on COMMON_CLK and
conditionally enables the FU540-C000 support.

I've built this with a powerpc allyesconfig (which pointed out the bug)
and on RISC-V, manually checking to ensure the code was built.  I
haven't even booted the resulting kernels.

Fixes: c218ad559020 ("macb: Add support for SiFive FU540-C000")
Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
---
 drivers/net/ethernet/cadence/Kconfig     | 11 +++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 12 ++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 1766697c9c5a..74ee2bfd2369 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -40,6 +40,17 @@ config MACB_USE_HWSTAMP
 	---help---
 	  Enable IEEE 1588 Precision Time Protocol (PTP) support for MACB.
 
+config MACB_FU540
+	bool "Enable support for the SiFive FU540 clock controller"
+	depends on MACB && COMMON_CLK
+	default y
+	---help---
+	  Enable support for the MACB/GEM clock controller on the SiFive
+	  FU540-C000.  This device is necessary for switching between 10/100
+	  and gigabit modes on the FU540-C000 SoC, without which it is only
+	  possible to bring up the Ethernet link in whatever mode the
+	  bootloader probed.
+
 config MACB_PCI
 	tristate "Cadence PCI MACB/GEM support"
 	depends on MACB && PCI && COMMON_CLK
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c545c5b435d8..a903dfdd4183 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -41,6 +41,7 @@
 #include <linux/pm_runtime.h>
 #include "macb.h"
 
+#ifdef CONFIG_MACB_FU540
 /* This structure is only used for MACB on SiFive FU540 devices */
 struct sifive_fu540_macb_mgmt {
 	void __iomem *reg;
@@ -49,6 +50,7 @@ struct sifive_fu540_macb_mgmt {
 };
 
 static struct sifive_fu540_macb_mgmt *mgmt;
+#endif
 
 #define MACB_RX_BUFFER_SIZE	128
 #define RX_BUFFER_MULTIPLE	64  /* bytes */
@@ -3956,6 +3958,7 @@ static int at91ether_init(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_MACB_FU540
 static unsigned long fu540_macb_tx_recalc_rate(struct clk_hw *hw,
 					       unsigned long parent_rate)
 {
@@ -4056,7 +4059,9 @@ static int fu540_c000_init(struct platform_device *pdev)
 
 	return macb_init(pdev);
 }
+#endif
 
+#ifdef CONFIG_MACB_FU540
 static const struct macb_config fu540_c000_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_JUMBO |
 		MACB_CAPS_GEM_HAS_PTP,
@@ -4065,6 +4070,7 @@ static const struct macb_config fu540_c000_config = {
 	.init = fu540_c000_init,
 	.jumbo_max_len = 10240,
 };
+#endif
 
 static const struct macb_config at91sam9260_config = {
 	.caps = MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII,
@@ -4155,7 +4161,9 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,emac", .data = &emac_config },
 	{ .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config},
 	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
+#ifdef CONFIG_MACB_FU540
 	{ .compatible = "sifive,fu540-macb", .data = &fu540_c000_config },
+#endif
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
@@ -4363,7 +4371,9 @@ static int macb_probe(struct platform_device *pdev)
 
 err_disable_clocks:
 	clk_disable_unprepare(tx_clk);
+#ifdef CONFIG_MACB_FU540
 	clk_unregister(tx_clk);
+#endif
 	clk_disable_unprepare(hclk);
 	clk_disable_unprepare(pclk);
 	clk_disable_unprepare(rx_clk);
@@ -4398,7 +4408,9 @@ static int macb_remove(struct platform_device *pdev)
 		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		if (!pm_runtime_suspended(&pdev->dev)) {
 			clk_disable_unprepare(bp->tx_clk);
+#ifdef CONFIG_MACB_FU540
 			clk_unregister(bp->tx_clk);
+#endif
 			clk_disable_unprepare(bp->hclk);
 			clk_disable_unprepare(bp->pclk);
 			clk_disable_unprepare(bp->rx_clk);
-- 
2.21.0


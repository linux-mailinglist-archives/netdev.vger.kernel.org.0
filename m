Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817CC27AB95
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 12:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgI1KMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 06:12:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:54519 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbgI1KMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 06:12:18 -0400
IronPort-SDR: r1iBsign+/aMU1hcAbRI+HFjYCxU+XvTFx1pF2ZuADE/JG12+pcPo1B9tLMQ9PDMEkS+VN4epZ
 ANaVsMri/9DQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="162854842"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="162854842"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 03:12:16 -0700
IronPort-SDR: 4/5R8Z+uJ6S8nnQ01H23JPefZtrf3oqoGNaJwBGJ/sU/nbwup0LCSALwLyYFweNcD7i3z6Xx6g
 LJbEFcEP671A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="311725475"
Received: from climb.png.intel.com ([10.221.118.165])
  by orsmga006.jf.intel.com with ESMTP; 28 Sep 2020 03:12:13 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH v1 net-next] stmmac: intel: Adding ref clock 1us tic for LPI cntr
Date:   Mon, 28 Sep 2020 18:12:12 +0800
Message-Id: <20200928101212.12274-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rusaimi Amira Ruslan <rusaimi.amira.rusaimi@intel.com>

Adding reference clock (1us tic) for all LPI timer on Intel platforms.
The reference clock is derived from ptp clk. This also enables all LPI
counter.

Signed-off-by: Rusaimi Amira Ruslan <rusaimi.amira.rusaimi@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 9 +++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c      | 9 +++++++++
 include/linux/stmmac.h                                 | 1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index b1323d5c95b5..f61cb997a8f6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 #include <linux/stmmac.h>
 
+#include "dwmac4.h"
 #include "stmmac.h"
 #include "stmmac_platform.h"
 
@@ -146,6 +147,14 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 	}
 
 	plat_dat->bsp_priv = dwmac;
+	plat_dat->eee_usecs_rate = plat_dat->clk_ptp_rate;
+
+	if (plat_dat->eee_usecs_rate > 0) {
+		u32 tx_lpi_usec;
+
+		tx_lpi_usec = (plat_dat->eee_usecs_rate / 1000000) - 1;
+		writel(tx_lpi_usec, stmmac_res.addr + GMAC_1US_TIC_COUNTER);
+	}
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index ab0a81e0fea1..2af9458be95f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -6,6 +6,7 @@
 #include <linux/pci.h>
 #include <linux/dmi.h>
 #include "dwmac-intel.h"
+#include "dwmac4.h"
 #include "stmmac.h"
 
 struct intel_priv_data {
@@ -295,6 +296,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->axi->axi_blen[2] = 16;
 
 	plat->ptp_max_adj = plat->clk_ptp_rate;
+	plat->eee_usecs_rate = plat->clk_ptp_rate;
 
 	/* Set system clock */
 	plat->stmmac_clk = clk_register_fixed_rate(&pdev->dev,
@@ -623,6 +625,13 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
+	if (plat->eee_usecs_rate > 0) {
+		u32 tx_lpi_usec;
+
+		tx_lpi_usec = (plat->eee_usecs_rate / 1000000) - 1;
+		writel(tx_lpi_usec, res.addr + GMAC_1US_TIC_COUNTER);
+	}
+
 	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
 	if (ret < 0)
 		return ret;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 00e83c877496..628e28903b8b 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -200,5 +200,6 @@ struct plat_stmmacenet_data {
 	int has_xgmac;
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
+	unsigned int eee_usecs_rate;
 };
 #endif
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD52C1BE014
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgD2OEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:04:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:59789 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgD2OEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:04:53 -0400
IronPort-SDR: 2oz/HhmBYCsrMIjoBlDNMAn3XIHOTjUNyBcBCcAFI3nK4o/FYWb+qBry/L9YoZBXVENbSHrg1s
 8sdRQ2bc+j0A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 07:04:52 -0700
IronPort-SDR: 7DX+UZdQUXxb7LFDz6Jhol+tCePZnpBEIwj7mZPJC8W60iTnn9ZqeQe5cbI1L611SyT7UQUk9H
 2xRFw+sBWT1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="405046935"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 29 Apr 2020 07:04:50 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 97FD3166; Wed, 29 Apr 2020 17:04:49 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/5] stmmac: intel: Check return value of clk_prepare_enable()
Date:   Wed, 29 Apr 2020 17:04:45 +0300
Message-Id: <20200429140449.9484-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clk_prepare_enable() might fail, we have to check its returned value.

While at it, remove leftover in stmmac_pci, also remove unneeded condition
for NULL-aware clk_unregister_fixed_rate() call and call it when
stmmac_dvr_probe() fails.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c  | 18 ++++++++++++++----
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c   |  3 ---
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 2e4aaedb93f580..5975c1e850425e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -252,6 +252,7 @@ static void common_default_data(struct plat_stmmacenet_data *plat)
 static int intel_mgbe_common_data(struct pci_dev *pdev,
 				  struct plat_stmmacenet_data *plat)
 {
+	int ret;
 	int i;
 
 	plat->clk_csr = 5;
@@ -324,7 +325,12 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 		dev_warn(&pdev->dev, "Fail to register stmmac-clk\n");
 		plat->stmmac_clk = NULL;
 	}
-	clk_prepare_enable(plat->stmmac_clk);
+
+	ret = clk_prepare_enable(plat->stmmac_clk);
+	if (ret) {
+		clk_unregister_fixed_rate(plat->stmmac_clk);
+		return ret;
+	}
 
 	/* Set default value for multicast hash bins */
 	plat->multicast_filter_bins = HASH_TABLE_SIZE;
@@ -657,7 +663,12 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	res.wol_irq = pdev->irq;
 	res.irq = pdev->irq;
 
-	return stmmac_dvr_probe(&pdev->dev, plat, &res);
+	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (ret) {
+		clk_unregister_fixed_rate(plat->stmmac_clk);
+	}
+
+	return ret;
 }
 
 /**
@@ -675,8 +686,7 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
-	if (priv->plat->stmmac_clk)
-		clk_unregister_fixed_rate(priv->plat->stmmac_clk);
+	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 3fb21f7ac9fbee..cf6b8f382e504f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -223,9 +223,6 @@ static void stmmac_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
-	if (priv->plat->stmmac_clk)
-		clk_unregister_fixed_rate(priv->plat->stmmac_clk);
-
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
 			continue;
-- 
2.26.2


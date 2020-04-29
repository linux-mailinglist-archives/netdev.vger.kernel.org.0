Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5AE1BE1BB
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgD2Owm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:52:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:47530 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgD2Owi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:52:38 -0400
IronPort-SDR: vvFul0CyZKY4A0kbOZCTDYlgPbp8MA9gqmnV8OBSo46285ci2Fzg4pvshMe5E3KEzWBE06s5xz
 fn3KUBWSVK8Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 07:52:38 -0700
IronPort-SDR: fa9ocvhpmgviQd9uOcOrfNT1RIFhxwSbxaLD3WpmgwWPoG+w/4qKjPtf7hA83zr68UQ9Kw2K8x
 Ti9RMIiuKasw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="246868468"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 29 Apr 2020 07:52:35 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6BF5715C; Wed, 29 Apr 2020 17:52:34 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/6] stmmac: intel: Fix clock handling on error and remove paths
Date:   Wed, 29 Apr 2020 17:52:28 +0300
Message-Id: <20200429145233.81943-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clk_prepare_enable() might fail, we have to check its returned value.
Besides that we have to call clk_disable_unprepare() on the error and
remove paths. Do above in the dwmac-intel driver.

While at it, remove leftover in stmmac_pci and remove unneeded condition
for NULL-aware clk_unregister_fixed_rate() call.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: properly disable and unprepare clock on error path and remove
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 20 +++++++++++++++----
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  |  5 -----
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 2e4aaedb93f580..d163c4b43da0fd 100644
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
@@ -657,7 +663,13 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	res.wol_irq = pdev->irq;
 	res.irq = pdev->irq;
 
-	return stmmac_dvr_probe(&pdev->dev, plat, &res);
+	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (ret) {
+		clk_disable_unprepare(plat->stmmac_clk);
+		clk_unregister_fixed_rate(plat->stmmac_clk);
+	}
+
+	return ret;
 }
 
 /**
@@ -675,8 +687,8 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
-	if (priv->plat->stmmac_clk)
-		clk_unregister_fixed_rate(priv->plat->stmmac_clk);
+	clk_disable_unprepare(priv->plat->stmmac_clk);
+	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 3fb21f7ac9fbee..272cb47af9f2ea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -217,15 +217,10 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
  */
 static void stmmac_pci_remove(struct pci_dev *pdev)
 {
-	struct net_device *ndev = dev_get_drvdata(&pdev->dev);
-	struct stmmac_priv *priv = netdev_priv(ndev);
 	int i;
 
 	stmmac_dvr_remove(&pdev->dev);
 
-	if (priv->plat->stmmac_clk)
-		clk_unregister_fixed_rate(priv->plat->stmmac_clk);
-
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
 			continue;
-- 
2.26.2


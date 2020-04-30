Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E6A1BFF79
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgD3PDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:03:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:23192 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgD3PC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 11:02:59 -0400
IronPort-SDR: jJEpDsbM55D+8r6eQCZF25xdm0J3wrWRW3D/IAdQiY1ptgl6cX8imyMm46jjITdpQF4Dcf9BcQ
 pMqryKgVn74A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 08:02:58 -0700
IronPort-SDR: FWOsYAIC2NRGWTwjoW5xbGC8jQ1ujwb62GmdlZGtfWmPeaMnpfWu+Mu5z3eLyDa3eqLvAleZU2
 sbmWnC/QwUWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,336,1583222400"; 
   d="scan'208";a="368167922"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 30 Apr 2020 08:02:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 71F1E15C; Thu, 30 Apr 2020 18:02:55 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH v3 3/7] stmmac: intel: Remove unnecessary loop for PCI BARs
Date:   Thu, 30 Apr 2020 18:02:50 +0300
Message-Id: <20200430150254.34565-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
References: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Copy'n'paste without thinking is not a good idea and in this case it brought
unnecessary loop over PCI BAR resources which was needed to workaround one of
STMicro RVP boards. Remove unnecessary loops from Intel driver.

Fixes: 58da0cfa6cf1 ("net: stmmac: create dwmac-intel.c to contain all Intel platform")
Cc: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 23 ++++---------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index d163c4b43da0fd..e9f94855949959 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -606,7 +606,6 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	struct intel_priv_data *intel_priv;
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_resources res;
-	int i;
 	int ret;
 
 	intel_priv = devm_kzalloc(&pdev->dev, sizeof(*intel_priv),
@@ -637,15 +636,9 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 		return ret;
 	}
 
-	/* Get the base address of device */
-	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
-		if (pci_resource_len(pdev, i) == 0)
-			continue;
-		ret = pcim_iomap_regions(pdev, BIT(i), pci_name(pdev));
-		if (ret)
-			return ret;
-		break;
-	}
+	ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
+	if (ret)
+		return ret;
 
 	pci_set_master(pdev);
 
@@ -659,7 +652,7 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	pci_enable_msi(pdev);
 
 	memset(&res, 0, sizeof(res));
-	res.addr = pcim_iomap_table(pdev)[i];
+	res.addr = pcim_iomap_table(pdev)[0];
 	res.wol_irq = pdev->irq;
 	res.irq = pdev->irq;
 
@@ -683,19 +676,13 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 {
 	struct net_device *ndev = dev_get_drvdata(&pdev->dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
-	int i;
 
 	stmmac_dvr_remove(&pdev->dev);
 
 	clk_disable_unprepare(priv->plat->stmmac_clk);
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
-	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
-		if (pci_resource_len(pdev, i) == 0)
-			continue;
-		pcim_iounmap_regions(pdev, BIT(i));
-		break;
-	}
+	pcim_iounmap_regions(pdev, BIT(0));
 
 	pci_disable_device(pdev);
 }
-- 
2.26.2


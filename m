Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97BA1BE1B7
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgD2Owi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:52:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:48784 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2Owi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:52:38 -0400
IronPort-SDR: 01RSFYdpz1+3W4/GfVYxEi5LmibaNWICMDtCLPT8pO+G51YPRC0GotwBe0VDiiKIZd/N9uGi/F
 OI9xa2Icjy8w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 07:52:37 -0700
IronPort-SDR: NZvEwlTyqRQ0Fzkl7Q/Dl0Q0QgrPmJMj2fg1jG9915vVIEIpaXZ+raolK8EFCVOBjqnS/BwwOl
 QjWxqPVnlBCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="432582652"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2020 07:52:35 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 7B68A43; Wed, 29 Apr 2020 17:52:34 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/6] stmmac: intel: Remove unnecessary loop for PCI BARs
Date:   Wed, 29 Apr 2020 17:52:29 +0300
Message-Id: <20200429145233.81943-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429145233.81943-1-andriy.shevchenko@linux.intel.com>
References: <20200429145233.81943-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Copy'n'paste without thinking is not a good idea and in this case it brought
unnecessary loop over PCI BAR resources which was needed to workaround one of
STMicro RVP boards. Remove unnecessary loops from Intel driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: no changes
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


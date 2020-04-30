Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285A81BFF81
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgD3PDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:03:01 -0400
Received: from mga07.intel.com ([134.134.136.100]:16558 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgD3PDA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 11:03:00 -0400
IronPort-SDR: 7LjWGRflOn9F6v8+EJCoVrMZLQ6Y2xTdjFdxDxuQvWuGqkxMya4gEnDoxY1BFLpfNLkpOM8kcs
 mCUK9Mnw2UDQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 08:02:58 -0700
IronPort-SDR: Jv10Lorl3VCf6kXCOl/0MNaUiHFoiyVTxs9pqTy0WOH0iFk/j4hiPMaTHJbSV8KkZrYyfqmVsZ
 twuk0g7VGvlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,336,1583222400"; 
   d="scan'208";a="294534199"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 30 Apr 2020 08:02:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 7717617F; Thu, 30 Apr 2020 18:02:55 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 4/7] stmmac: intel: Convert to use pci_alloc_irq_vectors() API
Date:   Thu, 30 Apr 2020 18:02:51 +0300
Message-Id: <20200430150254.34565-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
References: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_enable_msi() is deprecated API, thus, switch to modern
pci_alloc_irq_vectors().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index e9f94855949959..bb8bf31c1259ef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -649,15 +649,18 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
-	pci_enable_msi(pdev);
+	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (ret < 0)
+		return ret;
 
 	memset(&res, 0, sizeof(res));
 	res.addr = pcim_iomap_table(pdev)[0];
-	res.wol_irq = pdev->irq;
-	res.irq = pdev->irq;
+	res.wol_irq = pci_irq_vector(pdev, 0);
+	res.irq = pci_irq_vector(pdev, 0);
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
 	if (ret) {
+		pci_free_irq_vectors(pdev);
 		clk_disable_unprepare(plat->stmmac_clk);
 		clk_unregister_fixed_rate(plat->stmmac_clk);
 	}
@@ -679,6 +682,8 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
+	pci_free_irq_vectors(pdev);
+
 	clk_disable_unprepare(priv->plat->stmmac_clk);
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5576C1BE015
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgD2OEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:04:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:59791 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbgD2OEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:04:53 -0400
IronPort-SDR: UMe38SFktzIVQqjv4pn+6qgVTD1oqJn+DKkAl2eFRr7rFuT/wcdE1y7eD4jrQH0SWf5AeQMR/v
 I8fA5eU9inbg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 07:04:52 -0700
IronPort-SDR: tl6CWAPx+/XcLBREN+hOokqB9e/ui6QIaIhe16VZKzgRhS3bL/sF7OGmNn9JnMDIPB0aSPDt9d
 S3kfgWZHtgcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="459205135"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2020 07:04:50 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B14A317F; Wed, 29 Apr 2020 17:04:49 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/5] stmmac: intel: Convert to use pci_alloc_irq_vectors() API
Date:   Wed, 29 Apr 2020 17:04:47 +0300
Message-Id: <20200429140449.9484-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429140449.9484-1-andriy.shevchenko@linux.intel.com>
References: <20200429140449.9484-1-andriy.shevchenko@linux.intel.com>
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
index 87743036df78b3..46e3e4d6a34ac8 100644
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
 		clk_unregister_fixed_rate(plat->stmmac_clk);
 	}
 
@@ -678,6 +681,8 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
+	pci_free_irq_vectors(pdev);
+
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	pcim_iounmap_regions(pdev, BIT(0));
-- 
2.26.2


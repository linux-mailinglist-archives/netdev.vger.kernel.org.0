Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8937A29E74D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 10:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgJ2JaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 05:30:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:64315 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgJ2JaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 05:30:02 -0400
IronPort-SDR: j3Ndt9KB/yDQyh9z3sdeGyLTz3YAvpsZwYqhTnpW9ArY7oaHFZrqR+4B7t2Oe3XWqWbg832OaQ
 B0WQyKOmOWZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9788"; a="147685399"
X-IronPort-AV: E=Sophos;i="5.77,429,1596524400"; 
   d="scan'208";a="147685399"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 02:30:02 -0700
IronPort-SDR: 9oMmPxJXPcUFT7rZNSb9AZfddF6HpV8s3RhFRzTKzoNHY2ikDC5AYif1R0PrcA7xx3FCUthsSV
 Ude9/FVyp/bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,429,1596524400"; 
   d="scan'208";a="424996821"
Received: from glass.png.intel.com ([172.30.181.98])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2020 02:29:59 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net 1/1] stmmac: intel: Fix kernel panic on pci probe
Date:   Thu, 29 Oct 2020 17:32:28 +0800
Message-Id: <20201029093228.1741-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit "stmmac: intel: Adding ref clock 1us tic for LPI cntr"
introduced a regression which leads to the kernel panic duing loading
of the dwmac_intel module.

Move the code block after pci resources is obtained.

Fixes: b4c5f83ae3f3 ("stmmac: intel: Adding ref clock 1us tic for LPI cntr")
Cc: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index b6e5e3e36b63..81ee0a071b4e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -625,13 +625,6 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
-	if (plat->eee_usecs_rate > 0) {
-		u32 tx_lpi_usec;
-
-		tx_lpi_usec = (plat->eee_usecs_rate / 1000000) - 1;
-		writel(tx_lpi_usec, res.addr + GMAC_1US_TIC_COUNTER);
-	}
-
 	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
 	if (ret < 0)
 		return ret;
@@ -641,6 +634,13 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	res.wol_irq = pci_irq_vector(pdev, 0);
 	res.irq = pci_irq_vector(pdev, 0);
 
+	if (plat->eee_usecs_rate > 0) {
+		u32 tx_lpi_usec;
+
+		tx_lpi_usec = (plat->eee_usecs_rate / 1000000) - 1;
+		writel(tx_lpi_usec, res.addr + GMAC_1US_TIC_COUNTER);
+	}
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
 	if (ret) {
 		pci_free_irq_vectors(pdev);
-- 
2.17.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0170932C45B
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbhCDANU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:39544 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383667AbhCCPdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:33:09 -0500
IronPort-SDR: TgtUxkbMxZ1dh0WH32V7Oh4xNJT+Z7bK9s83ygX+P2SHmPtLUZF0/nHfpKnzt9Y5EzzuQzPFuN
 6uLinTNLKKYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="186564160"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="186564160"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 07:28:12 -0800
IronPort-SDR: Tw0kM0Mp78KL1G/SMweMkdai7/sHhdSBmTDh8T3YcN/dpmcDBTiVvn2123XMKhXpp5j41EE7Cv
 nChdjlYIKRCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="399758616"
Received: from climb.png.intel.com ([10.221.118.165])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 07:28:09 -0800
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
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH v1 net-next 4/5] stmmac: intel: add support for multi-vector msi and msi-x
Date:   Wed,  3 Mar 2021 23:27:56 +0800
Message-Id: <20210303152757.18959-5-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210303152757.18959-1-weifeng.voon@intel.com>
References: <20210303152757.18959-1-weifeng.voon@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

Intel mgbe controller supports multi-vector interrupts:
msi_rx_vec	0,2,4,6,8,10,12,14
msi_tx_vec	1,3,5,7,9,11,13,15
msi_sfty_ue_vec	26
msi_sfty_ce_vec	27
msi_lpi_vec	28
msi_mac_vec	29

During probe(), the driver will starts with request allocation for
multi-vector interrupts. If it fails, then it will automatically fallback
to request allocation for single interrupts.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Co-developed-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 112 +++++++++++++++++-
 1 file changed, 106 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 751dfdeec41c..316428bb6a01 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -330,6 +330,14 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	/* Use the last Rx queue */
 	plat->vlan_fail_q = plat->rx_queues_to_use - 1;
 
+	/* Setup MSI vector offset specific to Intel mGbE controller */
+	plat->msi_mac_vec = 29;
+	plat->msi_lpi_vec = 28;
+	plat->msi_sfty_ce_vec = 27;
+	plat->msi_sfty_ue_vec = 26;
+	plat->msi_rx_base_vec = 0;
+	plat->msi_tx_base_vec = 1;
+
 	return 0;
 }
 
@@ -578,6 +586,79 @@ static const struct stmmac_pci_info quark_info = {
 	.setup = quark_default_data,
 };
 
+static int stmmac_config_single_msi(struct pci_dev *pdev,
+				    struct plat_stmmacenet_data *plat,
+				    struct stmmac_resources *res)
+{
+	int ret;
+
+	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (ret < 0) {
+		dev_info(&pdev->dev, "%s: Single IRQ enablement failed\n",
+			 __func__);
+		return ret;
+	}
+
+	res->irq = pci_irq_vector(pdev, 0);
+	res->wol_irq = res->irq;
+	plat->multi_msi_en = 0;
+	dev_info(&pdev->dev, "%s: Single IRQ enablement successful\n",
+		 __func__);
+
+	return 0;
+}
+
+static int stmmac_config_multi_msi(struct pci_dev *pdev,
+				   struct plat_stmmacenet_data *plat,
+				   struct stmmac_resources *res)
+{
+	int ret;
+	int i;
+
+	ret = pci_alloc_irq_vectors(pdev, 2, STMMAC_MSI_VEC_MAX,
+				    PCI_IRQ_MSI | PCI_IRQ_MSIX);
+	if (ret < 0) {
+		dev_info(&pdev->dev, "%s: multi MSI enablement failed\n",
+			 __func__);
+		return ret;
+	}
+
+	if (plat->msi_rx_base_vec >= STMMAC_MSI_VEC_MAX ||
+	    plat->msi_tx_base_vec >= STMMAC_MSI_VEC_MAX) {
+		dev_info(&pdev->dev, "%s: Invalid RX & TX vector defined\n",
+			 __func__);
+		return -1;
+	}
+
+	/* For RX MSI */
+	for (i = 0; i < plat->rx_queues_to_use; i++) {
+		res->rx_irq[i] = pci_irq_vector(pdev,
+						plat->msi_rx_base_vec + i * 2);
+	}
+
+	/* For TX MSI */
+	for (i = 0; i < plat->tx_queues_to_use; i++) {
+		res->tx_irq[i] = pci_irq_vector(pdev,
+						plat->msi_tx_base_vec + i * 2);
+	}
+
+	if (plat->msi_mac_vec < STMMAC_MSI_VEC_MAX)
+		res->irq = pci_irq_vector(pdev, plat->msi_mac_vec);
+	if (plat->msi_wol_vec < STMMAC_MSI_VEC_MAX)
+		res->wol_irq = pci_irq_vector(pdev, plat->msi_wol_vec);
+	if (plat->msi_lpi_vec < STMMAC_MSI_VEC_MAX)
+		res->lpi_irq = pci_irq_vector(pdev, plat->msi_lpi_vec);
+	if (plat->msi_sfty_ce_vec < STMMAC_MSI_VEC_MAX)
+		res->sfty_ce_irq = pci_irq_vector(pdev, plat->msi_sfty_ce_vec);
+	if (plat->msi_sfty_ue_vec < STMMAC_MSI_VEC_MAX)
+		res->sfty_ue_irq = pci_irq_vector(pdev, plat->msi_sfty_ue_vec);
+
+	plat->multi_msi_en = 1;
+	dev_info(&pdev->dev, "%s: multi MSI enablement successful\n", __func__);
+
+	return 0;
+}
+
 /**
  * intel_eth_pci_probe
  *
@@ -635,18 +716,24 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	plat->bsp_priv = intel_priv;
 	intel_priv->mdio_adhoc_addr = 0x15;
 
+	/* Initialize all MSI vectors to invalid so that it can be set
+	 * according to platform data settings below.
+	 * Note: MSI vector takes value from 0 upto 31 (STMMAC_MSI_VEC_MAX)
+	 */
+	plat->msi_mac_vec = STMMAC_MSI_VEC_MAX;
+	plat->msi_wol_vec = STMMAC_MSI_VEC_MAX;
+	plat->msi_lpi_vec = STMMAC_MSI_VEC_MAX;
+	plat->msi_sfty_ce_vec = STMMAC_MSI_VEC_MAX;
+	plat->msi_sfty_ue_vec = STMMAC_MSI_VEC_MAX;
+	plat->msi_rx_base_vec = STMMAC_MSI_VEC_MAX;
+	plat->msi_tx_base_vec = STMMAC_MSI_VEC_MAX;
+
 	ret = info->setup(pdev, plat);
 	if (ret)
 		return ret;
 
-	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
-	if (ret < 0)
-		return ret;
-
 	memset(&res, 0, sizeof(res));
 	res.addr = pcim_iomap_table(pdev)[0];
-	res.wol_irq = pci_irq_vector(pdev, 0);
-	res.irq = pci_irq_vector(pdev, 0);
 
 	if (plat->eee_usecs_rate > 0) {
 		u32 tx_lpi_usec;
@@ -655,6 +742,19 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 		writel(tx_lpi_usec, res.addr + GMAC_1US_TIC_COUNTER);
 	}
 
+	ret = stmmac_config_multi_msi(pdev, plat, &res);
+	if (!ret)
+		goto msi_done;
+
+	ret = stmmac_config_single_msi(pdev, plat, &res);
+	if (ret) {
+		dev_err(&pdev->dev, "%s: ERROR: failed to enable IRQ\n",
+			__func__);
+		return ret;
+	}
+
+msi_done:
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
 	if (ret) {
 		pci_free_irq_vectors(pdev);
-- 
2.17.1


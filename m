Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70E79D511
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733289AbfHZRjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:39:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:54763 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733078AbfHZRjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 13:39:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 10:39:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="355499049"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga005.jf.intel.com with ESMTP; 26 Aug 2019 10:39:04 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH v1 net-next 1/4] net: stmmac: add EHL SGMII 1Gbps PCI info and PCI ID
Date:   Tue, 27 Aug 2019 09:38:08 +0800
Message-Id: <1566869891-29239-2-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
References: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added EHL SGMII 1Gbps PCI ID. Different MII and speed will have
different PCI ID.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 107 +++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index d5d08e11c353..f6930e02f578 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -108,6 +108,111 @@ static int stmmac_default_data(struct pci_dev *pdev,
 	.setup = stmmac_default_data,
 };
 
+static int intel_mgbe_common_data(struct pci_dev *pdev,
+				  struct plat_stmmacenet_data *plat)
+{
+	int i;
+
+	plat->clk_csr = 5;
+	plat->has_gmac = 0;
+	plat->has_gmac4 = 1;
+	plat->force_sf_dma_mode = 0;
+	plat->tso_en = 1;
+
+	plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
+
+	for (i = 0; i < plat->rx_queues_to_use; i++) {
+		plat->rx_queues_cfg[i].mode_to_use = MTL_QUEUE_DCB;
+		plat->rx_queues_cfg[i].chan = i;
+
+		/* Disable Priority config by default */
+		plat->rx_queues_cfg[i].use_prio = false;
+
+		/* Disable RX queues routing by default */
+		plat->rx_queues_cfg[i].pkt_route = 0x0;
+	}
+
+	for (i = 0; i < plat->tx_queues_to_use; i++) {
+		plat->tx_queues_cfg[i].mode_to_use = MTL_QUEUE_DCB;
+
+		/* Disable Priority config by default */
+		plat->tx_queues_cfg[i].use_prio = false;
+	}
+
+	/* FIFO size is 4096 bytes for 1 tx/rx queue */
+	plat->tx_fifo_size = plat->tx_queues_to_use * 4096;
+	plat->rx_fifo_size = plat->rx_queues_to_use * 4096;
+
+	plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WRR;
+	plat->tx_queues_cfg[0].weight = 0x09;
+	plat->tx_queues_cfg[1].weight = 0x0A;
+	plat->tx_queues_cfg[2].weight = 0x0B;
+	plat->tx_queues_cfg[3].weight = 0x0C;
+	plat->tx_queues_cfg[4].weight = 0x0D;
+	plat->tx_queues_cfg[5].weight = 0x0E;
+	plat->tx_queues_cfg[6].weight = 0x0F;
+	plat->tx_queues_cfg[7].weight = 0x10;
+
+	plat->mdio_bus_data->phy_mask = 0;
+
+	plat->dma_cfg->pbl = 32;
+	plat->dma_cfg->pblx8 = true;
+	plat->dma_cfg->fixed_burst = 0;
+	plat->dma_cfg->mixed_burst = 0;
+	plat->dma_cfg->aal = 0;
+
+	plat->axi = devm_kzalloc(&pdev->dev, sizeof(*plat->axi),
+				 GFP_KERNEL);
+	if (!plat->axi)
+		return -ENOMEM;
+
+	plat->axi->axi_lpi_en = 0;
+	plat->axi->axi_xit_frm = 0;
+	plat->axi->axi_wr_osr_lmt = 1;
+	plat->axi->axi_rd_osr_lmt = 1;
+	plat->axi->axi_blen[0] = 4;
+	plat->axi->axi_blen[1] = 8;
+	plat->axi->axi_blen[2] = 16;
+
+	/* Set default value for multicast hash bins */
+	plat->multicast_filter_bins = HASH_TABLE_SIZE;
+
+	/* Set default value for unicast filter entries */
+	plat->unicast_filter_entries = 1;
+
+	/* Set the maxmtu to a default of JUMBO_LEN */
+	plat->maxmtu = JUMBO_LEN;
+
+	return 0;
+}
+
+static int ehl_common_data(struct pci_dev *pdev,
+			   struct plat_stmmacenet_data *plat)
+{
+	int ret;
+
+	plat->rx_queues_to_use = 8;
+	plat->tx_queues_to_use = 8;
+	ret = intel_mgbe_common_data(pdev, plat);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ehl_sgmii_data(struct pci_dev *pdev,
+			  struct plat_stmmacenet_data *plat)
+{
+	plat->bus_id = 1;
+	plat->phy_addr = 0;
+	plat->interface = PHY_INTERFACE_MODE_SGMII;
+	return ehl_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info ehl_sgmii1g_pci_info = {
+	.setup = ehl_sgmii_data,
+};
+
 static const struct stmmac_pci_func_data galileo_stmmac_func_data[] = {
 	{
 		.func = 6,
@@ -349,6 +454,7 @@ static int __maybe_unused stmmac_pci_resume(struct device *dev)
 
 #define STMMAC_QUARK_ID  0x0937
 #define STMMAC_DEVICE_ID 0x1108
+#define STMMAC_EHL_SGMII1G_ID	0x4b31
 
 #define STMMAC_DEVICE(vendor_id, dev_id, info)	{	\
 	PCI_VDEVICE(vendor_id, dev_id),			\
@@ -359,6 +465,7 @@ static int __maybe_unused stmmac_pci_resume(struct device *dev)
 	STMMAC_DEVICE(STMMAC, STMMAC_DEVICE_ID, stmmac_pci_info),
 	STMMAC_DEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_MAC, stmmac_pci_info),
 	STMMAC_DEVICE(INTEL, STMMAC_QUARK_ID, quark_pci_info),
+	STMMAC_DEVICE(INTEL, STMMAC_EHL_SGMII1G_ID, ehl_sgmii1g_pci_info),
 	{}
 };
 
-- 
1.9.1


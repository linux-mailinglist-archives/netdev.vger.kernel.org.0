Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBE8276FF
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbfEWHcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:32:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:36471 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730103AbfEWHcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 03:32:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 00:32:31 -0700
X-ExtLoop1: 1
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by fmsmga005.fm.intel.com with ESMTP; 23 May 2019 00:32:27 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH net-next v2 5/5] net: stmmac: add EHL SGMII 1Gbps PCI info and PCI ID
Date:   Thu, 23 May 2019 23:32:47 +0800
Message-Id: <1558625567-21653-6-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558625567-21653-1-git-send-email-weifeng.voon@intel.com>
References: <1558625567-21653-1-git-send-email-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added EHL SGMII 1Gbps PCI ID. Different MII and speed will have
different PCI ID.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 111 +++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 7cbc01f316fa..f2225c1eafc2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -23,6 +23,7 @@
 #include <linux/dmi.h>
 
 #include "stmmac.h"
+#include "dwxpcs.h"
 
 /*
  * This struct is used to associate PCI Function of MAC controller on a board,
@@ -118,6 +119,113 @@ static int stmmac_default_data(struct pci_dev *pdev,
 	.setup = stmmac_default_data,
 };
 
+static int ehl_common_data(struct pci_dev *pdev,
+			   struct plat_stmmacenet_data *plat)
+{
+	int i;
+
+	plat->bus_id = 1;
+	plat->phy_addr = 0;
+	plat->clk_csr = 5;
+	plat->has_gmac = 0;
+	plat->has_gmac4 = 1;
+	plat->xpcs_phy_addr = 0x16;
+	plat->pcs_mode = AN_CTRL_PCS_MD_C37_SGMII;
+	plat->force_sf_dma_mode = 0;
+	plat->tso_en = 1;
+
+	plat->rx_queues_to_use = 8;
+	plat->tx_queues_to_use = 8;
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
+	plat->mdio_bus_data->phy_reset = NULL;
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
+	plat->axi->axi_lpi_en = 0;
+	plat->axi->axi_xit_frm = 0;
+	plat->axi->axi_wr_osr_lmt = 0;
+	plat->axi->axi_rd_osr_lmt = 2;
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
+	/* Set 32KB fifo size as the advertised fifo size in
+	 * the HW features is not the same as the HW implementation
+	 */
+	plat->tx_fifo_size = 32768;
+	plat->rx_fifo_size = 32768;
+
+	return 0;
+}
+
+static int ehl_sgmii1g_data(struct pci_dev *pdev,
+			    struct plat_stmmacenet_data *plat)
+{
+	int ret;
+
+	/* Set common default data first */
+	ret = ehl_common_data(pdev, plat);
+
+	if (ret)
+		return ret;
+
+	plat->interface = PHY_INTERFACE_MODE_SGMII;
+	plat->has_xpcs = 1;
+
+	return 0;
+}
+
+static struct stmmac_pci_info ehl_sgmii1g_pci_info = {
+	.setup = ehl_sgmii1g_data,
+};
+
 static const struct stmmac_pci_func_data galileo_stmmac_func_data[] = {
 	{
 		.func = 6,
@@ -290,6 +398,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 	res.addr = pcim_iomap_table(pdev)[i];
 	res.wol_irq = pdev->irq;
 	res.irq = pdev->irq;
+	res.xpcs_irq = 0;
 
 	return stmmac_dvr_probe(&pdev->dev, plat, &res);
 }
@@ -359,6 +468,7 @@ static int __maybe_unused stmmac_pci_resume(struct device *dev)
 
 #define STMMAC_QUARK_ID  0x0937
 #define STMMAC_DEVICE_ID 0x1108
+#define STMMAC_EHL_SGMII1G_ID   0x4b31
 
 #define STMMAC_DEVICE(vendor_id, dev_id, info)	{	\
 	PCI_VDEVICE(vendor_id, dev_id),			\
@@ -369,6 +479,7 @@ static int __maybe_unused stmmac_pci_resume(struct device *dev)
 	STMMAC_DEVICE(STMMAC, STMMAC_DEVICE_ID, stmmac_pci_info),
 	STMMAC_DEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_MAC, stmmac_pci_info),
 	STMMAC_DEVICE(INTEL, STMMAC_QUARK_ID, quark_pci_info),
+	STMMAC_DEVICE(INTEL, STMMAC_EHL_SGMII1G_ID, ehl_sgmii1g_pci_info),
 	{}
 };
 
-- 
1.9.1


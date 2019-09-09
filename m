Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBDE4ADD92
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 18:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391242AbfIIQyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 12:54:33 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:43714 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727866AbfIIQyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 12:54:32 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EB2B7C0196;
        Mon,  9 Sep 2019 16:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568048072; bh=ztU5cXLi0V4K5mhBVrPh5y1if4Ams78t+OFbPXBvR9E=;
        h=From:To:Cc:Subject:Date:From;
        b=RIpsg1ujBISZCK6V15inoKksfPMnzSXgBKiCvP3SBoKcYo2tSiaqiVXAVjoTKz6LT
         G2nTzlz5HF9Dia7IQ96oqJRA/DqBbUKFmFimUb3oR/vkGLI8reJf5sopl3bGe0y8+c
         c6O6+lqyAEsU71J2Fe0cRvbCZUXLvCquZiQsrYpaUPpKdLMQnRt2MvvolBHpJ40IhS
         el/Mfq+W4iXG77c7vqT+VdG4edAdoOwcBRdf6RaW5oNhOYscLkA6piuVMhfFh+iCG4
         8KGA2iGbImOqqih0IfeNIY4Flp4QNjhfAXoNs3OvOWmS8cC/wuGWz+ZOJ97EEgdrmw
         M97Tz76vpaUcw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id E1219A0057;
        Mon,  9 Sep 2019 16:54:28 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: pci: Add HAPS support using GMAC5
Date:   Mon,  9 Sep 2019 18:54:26 +0200
Message-Id: <c37a55225e1ef66233b47c02b1441b91abeb3b76.1568047994.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the support for Synopsys HAPS board that uses GMAC5.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 71 ++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 20906287b6d4..292045f4581f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -375,6 +375,75 @@ static const struct stmmac_pci_info quark_pci_info = {
 	.setup = quark_default_data,
 };
 
+static int snps_gmac5_default_data(struct pci_dev *pdev,
+				   struct plat_stmmacenet_data *plat)
+{
+	int i;
+
+	plat->clk_csr = 5;
+	plat->has_gmac4 = 1;
+	plat->force_sf_dma_mode = 1;
+	plat->tso_en = 1;
+	plat->pmt = 1;
+
+	plat->mdio_bus_data->phy_mask = 0;
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
+	/* Set default number of RX and TX queues to use */
+	plat->tx_queues_to_use = 4;
+	plat->rx_queues_to_use = 4;
+
+	plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WRR;
+	for (i = 0; i < plat->tx_queues_to_use; i++) {
+		plat->tx_queues_cfg[i].use_prio = false;
+		plat->tx_queues_cfg[i].mode_to_use = MTL_QUEUE_DCB;
+		plat->tx_queues_cfg[i].weight = 25;
+	}
+
+	plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
+	for (i = 0; i < plat->rx_queues_to_use; i++) {
+		plat->rx_queues_cfg[i].use_prio = false;
+		plat->rx_queues_cfg[i].mode_to_use = MTL_QUEUE_DCB;
+		plat->rx_queues_cfg[i].pkt_route = 0x0;
+		plat->rx_queues_cfg[i].chan = i;
+	}
+
+	plat->bus_id = 1;
+	plat->phy_addr = -1;
+	plat->interface = PHY_INTERFACE_MODE_GMII;
+
+	plat->dma_cfg->pbl = 32;
+	plat->dma_cfg->pblx8 = true;
+
+	/* Axi Configuration */
+	plat->axi = devm_kzalloc(&pdev->dev, sizeof(*plat->axi), GFP_KERNEL);
+	if (!plat->axi)
+		return -ENOMEM;
+
+	plat->axi->axi_wr_osr_lmt = 31;
+	plat->axi->axi_rd_osr_lmt = 31;
+
+	plat->axi->axi_fb = false;
+	plat->axi->axi_blen[0] = 4;
+	plat->axi->axi_blen[1] = 8;
+	plat->axi->axi_blen[2] = 16;
+	plat->axi->axi_blen[3] = 32;
+
+	return 0;
+}
+
+static const struct stmmac_pci_info snps_gmac5_pci_info = {
+	.setup = snps_gmac5_default_data,
+};
+
 /**
  * stmmac_pci_probe
  *
@@ -518,6 +587,7 @@ static SIMPLE_DEV_PM_OPS(stmmac_pm_ops, stmmac_pci_suspend, stmmac_pci_resume);
 #define STMMAC_EHL_RGMII1G_ID	0x4b30
 #define STMMAC_EHL_SGMII1G_ID	0x4b31
 #define STMMAC_TGL_SGMII1G_ID	0xa0ac
+#define STMMAC_GMAC5_ID		0x7102
 
 #define STMMAC_DEVICE(vendor_id, dev_id, info)	{	\
 	PCI_VDEVICE(vendor_id, dev_id),			\
@@ -531,6 +601,7 @@ static const struct pci_device_id stmmac_id_table[] = {
 	STMMAC_DEVICE(INTEL, STMMAC_EHL_RGMII1G_ID, ehl_rgmii1g_pci_info),
 	STMMAC_DEVICE(INTEL, STMMAC_EHL_SGMII1G_ID, ehl_sgmii1g_pci_info),
 	STMMAC_DEVICE(INTEL, STMMAC_TGL_SGMII1G_ID, tgl_sgmii1g_pci_info),
+	STMMAC_DEVICE(SYNOPSYS, STMMAC_GMAC5_ID, snps_gmac5_pci_info),
 	{}
 };
 
-- 
2.7.4


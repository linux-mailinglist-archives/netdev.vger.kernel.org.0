Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D961E39748C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhFANto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:49:44 -0400
Received: from mga18.intel.com ([134.134.136.126]:58104 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233797AbhFANto (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 09:49:44 -0400
IronPort-SDR: +ue3s7fvNmo4nAOlYjezZI1QTzWdPFQ6L0rt6FSGr2Oj8WWkKfAFjP5XT4BfcH+OxUOQMnj5HW
 ITI07JP4J/4Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="190902616"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="190902616"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 06:48:01 -0700
IronPort-SDR: Ei6ATOpnOMSCKz1rYHltb3cv108G1SvmRv7Aav7lF8hxvHdI1zAzohevjDixeDFqasr+H3mAx/
 5ZJa4GXgaTWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="399607816"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 01 Jun 2021 06:48:01 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id AC429580932;
        Tue,  1 Jun 2021 06:47:58 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/1] net: stmmac: enable platform specific safety features
Date:   Tue,  1 Jun 2021 21:52:35 +0800
Message-Id: <20210601135235.1058841-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Intel platforms, not all safety features are enabled on the hardware.
The current implementation enable all safety features by default. This
will cause mass error and warning printouts after the module is loaded.

Introduce platform specific safety features flag to enable or disable
each safety features.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 26 ++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c  | 30 ++++++++++++-------
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h  |  3 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_core.c   |  4 ++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  | 16 ++++++++++
 include/linux/stmmac.h                        | 13 ++++++++
 8 files changed, 84 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index e36a8cc59ad0..2ecf93c84b9d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -568,6 +568,16 @@ static int ehl_common_data(struct pci_dev *pdev,
 	plat->tx_queues_to_use = 8;
 	plat->clk_ptp_rate = 200000000;
 
+	plat->safety_feat_cfg->tsoee = 1;
+	plat->safety_feat_cfg->mrxpee = 1;
+	plat->safety_feat_cfg->mestee = 1;
+	plat->safety_feat_cfg->mrxee = 1;
+	plat->safety_feat_cfg->mtxee = 1;
+	plat->safety_feat_cfg->epsi = 0;
+	plat->safety_feat_cfg->edpp = 0;
+	plat->safety_feat_cfg->prtyen = 0;
+	plat->safety_feat_cfg->tmouten = 0;
+
 	return intel_mgbe_common_data(pdev, plat);
 }
 
@@ -683,6 +693,16 @@ static int tgl_common_data(struct pci_dev *pdev,
 	plat->tx_queues_to_use = 4;
 	plat->clk_ptp_rate = 200000000;
 
+	plat->safety_feat_cfg->tsoee = 1;
+	plat->safety_feat_cfg->mrxpee = 0;
+	plat->safety_feat_cfg->mestee = 1;
+	plat->safety_feat_cfg->mrxee = 1;
+	plat->safety_feat_cfg->mtxee = 1;
+	plat->safety_feat_cfg->epsi = 0;
+	plat->safety_feat_cfg->edpp = 0;
+	plat->safety_feat_cfg->prtyen = 0;
+	plat->safety_feat_cfg->tmouten = 0;
+
 	return intel_mgbe_common_data(pdev, plat);
 }
 
@@ -959,6 +979,12 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	if (!plat->dma_cfg)
 		return -ENOMEM;
 
+	plat->safety_feat_cfg = devm_kzalloc(&pdev->dev,
+					     sizeof(*plat->safety_feat_cfg),
+					     GFP_KERNEL);
+	if (!plat->safety_feat_cfg)
+		return -ENOMEM;
+
 	/* Enable pci device */
 	ret = pcim_enable_device(pdev);
 	if (ret) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index d8c6ff725237..9c2d40f853ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -183,7 +183,8 @@ static void dwmac5_handle_dma_err(struct net_device *ndev,
 			STAT_OFF(dma_errors), stats);
 }
 
-int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp)
+int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp,
+			      struct stmmac_safety_feature_cfg *safety_feat_cfg)
 {
 	u32 value;
 
@@ -193,11 +194,16 @@ int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp)
 	/* 1. Enable Safety Features */
 	value = readl(ioaddr + MTL_ECC_CONTROL);
 	value |= MEEAO; /* MTL ECC Error Addr Status Override */
-	value |= TSOEE; /* TSO ECC */
-	value |= MRXPEE; /* MTL RX Parser ECC */
-	value |= MESTEE; /* MTL EST ECC */
-	value |= MRXEE; /* MTL RX FIFO ECC */
-	value |= MTXEE; /* MTL TX FIFO ECC */
+	if (safety_feat_cfg->tsoee)
+		value |= TSOEE; /* TSO ECC */
+	if (safety_feat_cfg->mrxpee)
+		value |= MRXPEE; /* MTL RX Parser ECC */
+	if (safety_feat_cfg->mestee)
+		value |= MESTEE; /* MTL EST ECC */
+	if (safety_feat_cfg->mrxee)
+		value |= MRXEE; /* MTL RX FIFO ECC */
+	if (safety_feat_cfg->mtxee)
+		value |= MTXEE; /* MTL TX FIFO ECC */
 	writel(value, ioaddr + MTL_ECC_CONTROL);
 
 	/* 2. Enable MTL Safety Interrupts */
@@ -219,13 +225,16 @@ int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp)
 
 	/* 5. Enable Parity and Timeout for FSM */
 	value = readl(ioaddr + MAC_FSM_CONTROL);
-	value |= PRTYEN; /* FSM Parity Feature */
-	value |= TMOUTEN; /* FSM Timeout Feature */
+	if (safety_feat_cfg->prtyen)
+		value |= PRTYEN; /* FSM Parity Feature */
+	if (safety_feat_cfg->tmouten)
+		value |= TMOUTEN; /* FSM Timeout Feature */
 	writel(value, ioaddr + MAC_FSM_CONTROL);
 
 	/* 4. Enable Data Parity Protection */
 	value = readl(ioaddr + MTL_DPP_CONTROL);
-	value |= EDPP;
+	if (safety_feat_cfg->edpp)
+		value |= EDPP;
 	writel(value, ioaddr + MTL_DPP_CONTROL);
 
 	/*
@@ -235,7 +244,8 @@ int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp)
 	if (asp <= 0x2)
 		return 0;
 
-	value |= EPSI;
+	if (safety_feat_cfg->epsi)
+		value |= EPSI;
 	writel(value, ioaddr + MTL_DPP_CONTROL);
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index 6b2fd37b29ad..53c138d0ff48 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -137,7 +137,8 @@
 
 #define GMAC_INT_FPE_EN			BIT(17)
 
-int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp);
+int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp,
+			      struct stmmac_safety_feature_cfg *safety_cfg);
 int dwmac5_safety_feat_irq_status(struct net_device *ndev,
 		void __iomem *ioaddr, unsigned int asp,
 		struct stmmac_safety_stats *stats);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index ad4df9bddcf3..c4d78fa93663 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -801,7 +801,9 @@ static void dwxgmac3_handle_dma_err(struct net_device *ndev,
 			   dwxgmac3_dma_errors, STAT_OFF(dma_errors), stats);
 }
 
-static int dwxgmac3_safety_feat_config(void __iomem *ioaddr, unsigned int asp)
+static int
+dwxgmac3_safety_feat_config(void __iomem *ioaddr, unsigned int asp,
+			    struct stmmac_safety_feature_cfg *safety_cfg)
 {
 	u32 value;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 75a8b90c202a..dbafedb24290 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -348,7 +348,8 @@ struct stmmac_ops {
 	void (*pcs_rane)(void __iomem *ioaddr, bool restart);
 	void (*pcs_get_adv_lp)(void __iomem *ioaddr, struct rgmii_adv *adv);
 	/* Safety Features */
-	int (*safety_feat_config)(void __iomem *ioaddr, unsigned int asp);
+	int (*safety_feat_config)(void __iomem *ioaddr, unsigned int asp,
+				  struct stmmac_safety_feature_cfg *safety_cfg);
 	int (*safety_feat_irq_status)(struct net_device *ndev,
 			void __iomem *ioaddr, unsigned int asp,
 			struct stmmac_safety_stats *stats);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9962a1041d35..13720bf6f6ff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3172,7 +3172,8 @@ static void stmmac_safety_feat_configuration(struct stmmac_priv *priv)
 {
 	if (priv->dma_cap.asp) {
 		netdev_info(priv->dev, "Enabling Safety Features\n");
-		stmmac_safety_feat_config(priv, priv->ioaddr, priv->dma_cap.asp);
+		stmmac_safety_feat_config(priv, priv->ioaddr, priv->dma_cap.asp,
+					  priv->plat->safety_feat_cfg);
 	} else {
 		netdev_info(priv->dev, "No Safety Features support found\n");
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 95e0e4d6f74d..fcf17d8a0494 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -174,6 +174,12 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 	if (!plat->dma_cfg)
 		return -ENOMEM;
 
+	plat->safety_feat_cfg = devm_kzalloc(&pdev->dev,
+					     sizeof(*plat->safety_feat_cfg),
+					     GFP_KERNEL);
+	if (!plat->safety_feat_cfg)
+		return -ENOMEM;
+
 	/* Enable pci device */
 	ret = pci_enable_device(pdev);
 	if (ret) {
@@ -203,6 +209,16 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 	res.wol_irq = pdev->irq;
 	res.irq = pdev->irq;
 
+	plat->safety_feat_cfg->tsoee = 1;
+	plat->safety_feat_cfg->mrxpee = 1;
+	plat->safety_feat_cfg->mestee = 1;
+	plat->safety_feat_cfg->mrxee = 1;
+	plat->safety_feat_cfg->mtxee = 1;
+	plat->safety_feat_cfg->epsi = 1;
+	plat->safety_feat_cfg->edpp = 1;
+	plat->safety_feat_cfg->prtyen = 1;
+	plat->safety_feat_cfg->tmouten = 1;
+
 	return stmmac_dvr_probe(&pdev->dev, plat, &res);
 }
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index e14a12df381b..e55a4807e3ea 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -172,6 +172,18 @@ struct stmmac_fpe_cfg {
 	enum stmmac_fpe_state lo_fpe_state;	/* Local station FPE state */
 };
 
+struct stmmac_safety_feature_cfg {
+	u32 tsoee;
+	u32 mrxpee;
+	u32 mestee;
+	u32 mrxee;
+	u32 mtxee;
+	u32 epsi;
+	u32 edpp;
+	u32 prtyen;
+	u32 tmouten;
+};
+
 struct plat_stmmacenet_data {
 	int bus_id;
 	int phy_addr;
@@ -184,6 +196,7 @@ struct plat_stmmacenet_data {
 	struct stmmac_dma_cfg *dma_cfg;
 	struct stmmac_est *est;
 	struct stmmac_fpe_cfg *fpe_cfg;
+	struct stmmac_safety_feature_cfg *safety_feat_cfg;
 	int clk_csr;
 	int has_gmac;
 	int enh_desc;
-- 
2.25.1


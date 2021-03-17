Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C368333E627
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhCQB3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:29:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:17068 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhCQB25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 21:28:57 -0400
IronPort-SDR: lw6sdQoFQKGBxziYOU+CFvYnCLTecWcNd3sg7QXJnuBICiXk8g1u5DZY4i8SgdM2gS561Cgp57
 499mjeSKACJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="189413705"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="189413705"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 18:28:57 -0700
IronPort-SDR: 10heXnmyaXTKIcQmg8yRrk6bk6kmEg2xGAoG15nqwBWuBVKhNZ8E57Tb8mLUAryd/Xi4NyRYkI
 7LS5Qd27UpAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="605493944"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2021 18:28:53 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next 1/1] stmmac: intel: Add PSE and PCH PTP clock source selection
Date:   Wed, 17 Mar 2021 09:32:47 +0800
Message-Id: <20210317013247.25131-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317013247.25131-1-boon.leong.ong@intel.com>
References: <20210317013247.25131-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Wong, Vee Khee" <vee.khee.wong@intel.com>

Intel mGbE variant implemented in EHL and TGL can be set to select
different clock frequency based on GPO bits in MAC_GPIO_STATUS register.

We introduce a new "void (*ptp_clk_freq_config)(void *priv)" in platform
data so that if a platform is required to configure the frequency of clock
source, in this case Intel mGBE does, the platform-specific configuration
of the PTP clock setting is done when stmmac_ptp_register() is called.

Signed-off-by: Wong, Vee Khee <vee.khee.wong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Co-developed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 46 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  7 +++
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  3 ++
 include/linux/stmmac.h                        |  1 +
 4 files changed, 57 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index c49646773871..763b549e3c2d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -12,8 +12,18 @@
 #define INTEL_MGBE_ADHOC_ADDR	0x15
 #define INTEL_MGBE_XPCS_ADDR	0x16
 
+/* Selection for PTP Clock Freq belongs to PSE & PCH GbE */
+#define PSE_PTP_CLK_FREQ_MASK		(GMAC_GPO0 | GMAC_GPO3)
+#define PSE_PTP_CLK_FREQ_19_2MHZ	(GMAC_GPO0)
+#define PSE_PTP_CLK_FREQ_200MHZ		(GMAC_GPO0 | GMAC_GPO3)
+#define PSE_PTP_CLK_FREQ_256MHZ		(0)
+#define PCH_PTP_CLK_FREQ_MASK		(GMAC_GPO0)
+#define PCH_PTP_CLK_FREQ_19_2MHZ	(GMAC_GPO0)
+#define PCH_PTP_CLK_FREQ_200MHZ		(0)
+
 struct intel_priv_data {
 	int mdio_adhoc_addr;	/* mdio address for serdes & etc */
+	bool is_pse;
 };
 
 /* This struct is used to associate PCI Function of MAC controller on a board,
@@ -204,6 +214,32 @@ static void intel_serdes_powerdown(struct net_device *ndev, void *intel_data)
 	}
 }
 
+/* Program PTP Clock Frequency for different variant of
+ * Intel mGBE that has slightly different GPO mapping
+ */
+static void intel_mgbe_ptp_clk_freq_config(void *npriv)
+{
+	struct stmmac_priv *priv = (struct stmmac_priv *)npriv;
+	struct intel_priv_data *intel_priv;
+	u32 gpio_value;
+
+	intel_priv = (struct intel_priv_data *)priv->plat->bsp_priv;
+
+	gpio_value = readl(priv->ioaddr + GMAC_GPIO_STATUS);
+
+	if (intel_priv->is_pse) {
+		/* For PSE GbE, use 200MHz */
+		gpio_value &= ~PSE_PTP_CLK_FREQ_MASK;
+		gpio_value |= PSE_PTP_CLK_FREQ_200MHZ;
+	} else {
+		/* For PCH GbE, use 200MHz */
+		gpio_value &= ~PCH_PTP_CLK_FREQ_MASK;
+		gpio_value |= PCH_PTP_CLK_FREQ_200MHZ;
+	}
+
+	writel(gpio_value, priv->ioaddr + GMAC_GPIO_STATUS);
+}
+
 static void common_default_data(struct plat_stmmacenet_data *plat)
 {
 	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
@@ -322,6 +358,8 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 		return ret;
 	}
 
+	plat->ptp_clk_freq_config = intel_mgbe_ptp_clk_freq_config;
+
 	/* Set default value for multicast hash bins */
 	plat->multicast_filter_bins = HASH_TABLE_SIZE;
 
@@ -391,8 +429,12 @@ static struct stmmac_pci_info ehl_rgmii1g_info = {
 static int ehl_pse0_common_data(struct pci_dev *pdev,
 				struct plat_stmmacenet_data *plat)
 {
+	struct intel_priv_data *intel_priv = plat->bsp_priv;
+
+	intel_priv->is_pse = true;
 	plat->bus_id = 2;
 	plat->addr64 = 32;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -423,8 +465,12 @@ static struct stmmac_pci_info ehl_pse0_sgmii1g_info = {
 static int ehl_pse1_common_data(struct pci_dev *pdev,
 				struct plat_stmmacenet_data *plat)
 {
+	struct intel_priv_data *intel_priv = plat->bsp_priv;
+
+	intel_priv->is_pse = true;
 	plat->bus_id = 3;
 	plat->addr64 = 32;
+
 	return ehl_common_data(pdev, plat);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 82df91c130f7..ef8502d2b6e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -42,6 +42,7 @@
 #define GMAC_HW_FEATURE3		0x00000128
 #define GMAC_MDIO_ADDR			0x00000200
 #define GMAC_MDIO_DATA			0x00000204
+#define GMAC_GPIO_STATUS		0x0000020C
 #define GMAC_ARP_ADDR			0x00000210
 #define GMAC_ADDR_HIGH(reg)		(0x300 + reg * 8)
 #define GMAC_ADDR_LOW(reg)		(0x304 + reg * 8)
@@ -278,6 +279,12 @@ enum power_event {
 #define GMAC_HW_FEAT_DVLAN		BIT(5)
 #define GMAC_HW_FEAT_NRVF		GENMASK(2, 0)
 
+/* GMAC GPIO Status reg */
+#define GMAC_GPO0			BIT(16)
+#define GMAC_GPO1			BIT(17)
+#define GMAC_GPO2			BIT(18)
+#define GMAC_GPO3			BIT(19)
+
 /* MAC HW ADDR regs */
 #define GMAC_HI_DCS			GENMASK(18, 16)
 #define GMAC_HI_DCS_SHIFT		16
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 0989e2bb6ee3..8b10fd10446f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -192,6 +192,9 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 {
 	int i;
 
+	if (priv->plat->ptp_clk_freq_config)
+		priv->plat->ptp_clk_freq_config(priv);
+
 	for (i = 0; i < priv->dma_cap.pps_out_num; i++) {
 		if (i >= STMMAC_PPS_MAX)
 			break;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 51004ebd0540..10abc80b601e 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -181,6 +181,7 @@ struct plat_stmmacenet_data {
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
 	int (*serdes_powerup)(struct net_device *ndev, void *priv);
 	void (*serdes_powerdown)(struct net_device *ndev, void *priv);
+	void (*ptp_clk_freq_config)(void *priv);
 	int (*init)(struct platform_device *pdev, void *priv);
 	void (*exit)(struct platform_device *pdev, void *priv);
 	struct mac_device_info *(*setup)(void *priv);
-- 
2.25.1


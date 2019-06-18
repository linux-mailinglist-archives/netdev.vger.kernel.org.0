Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5C94A26C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbfFRNgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:36:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:21689 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRNgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:36:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 06:36:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,389,1557212400"; 
   d="scan'208";a="164705608"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga006.jf.intel.com with ESMTP; 18 Jun 2019 06:36:10 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [RFC net-next 2/5] net: stmmac: gcl errors reporting and its interrupt handling
Date:   Wed, 19 Jun 2019 05:36:15 +0800
Message-Id: <1560893778-6838-3-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
References: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enabled interrupt for Constant Gate Control Error (CGCE), Head-of-Line
Blocking due to scheduling error (HLBS) and Head-of-Line Blocking due to
frame size error (HLBF).

CGCE should not happen as the driver has already implemented a check
before applying the settings. CGCE handling is added as a safety
check so that we can catch it if there is such error being fired. For
HLBS, the user will get the info of all the queues that shows this
error. For HLBF, the user will get the info of all the queue with the
latest frame size which causes the error. Frame size 0 indicates no
error.

This patch also added functionality to get and clear the gcl errors.

The ISR handling takes place when EST feature is enabled by user.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |   4 +
 drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c  | 123 ++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.h  |  45 ++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |   3 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |   9 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   7 ++
 6 files changed, 191 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index ad9e9368535d..9723b0a12110 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -407,6 +407,9 @@ struct mii_regs {
 	unsigned int clk_csr_mask;
 };
 
+/* tsn capability,  meant for mac_device_info->tsn_cap */
+#define TSN_CAP_EST			BIT(0)
+
 struct mac_device_info {
 	const struct stmmac_ops *mac;
 	const struct stmmac_desc_ops *desc;
@@ -425,6 +428,7 @@ struct mac_device_info {
 	unsigned int pcs;
 	unsigned int pmt;
 	unsigned int ps;
+	u32 tsn_cap;
 };
 
 struct stmmac_rx_routing {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c b/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c
index cba27c604cb1..f14e86fcc93c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c
@@ -11,6 +11,7 @@
 static bool dw_tsn_feat_en[TSN_FEAT_ID_MAX];
 static unsigned int dw_tsn_hwtunable[TSN_HWTUNA_MAX];
 static struct est_gc_config dw_est_gc_config;
+static struct tsn_err_stat dw_err_stat;
 
 static unsigned int est_get_gcl_depth(unsigned int hw_cap)
 {
@@ -295,6 +296,24 @@ void dwmac_tsn_init(void *ioaddr)
 		 gcl_depth, ti_wid, tils_max, cap->txqcnt);
 }
 
+/* dwmac_tsn_setup is called within stmmac_hw_setup() after
+ * stmmac_init_dma_engine() which resets MAC controller.
+ * This is so-that MAC registers are not cleared.
+ */
+void dwmac_tsn_setup(void *ioaddr)
+{
+	struct tsn_hw_cap *cap = &dw_tsn_hwcap;
+	unsigned int value;
+
+	if (cap->est_support) {
+		/* Enable EST interrupts */
+		value = (MTL_EST_INT_EN_CGCE | MTL_EST_INT_EN_IEHS |
+			 MTL_EST_INT_EN_IEHF | MTL_EST_INT_EN_IEBE |
+			 MTL_EST_INT_EN_IECC);
+		TSN_WR32(value, ioaddr + MTL_EST_INT_EN);
+	}
+}
+
 void dwmac_get_tsn_hwcap(struct tsn_hw_cap **tsn_hwcap)
 {
 	*tsn_hwcap = &dw_tsn_hwcap;
@@ -788,3 +807,107 @@ int dwmac_get_est_gcc(void *ioaddr,
 
 	return 0;
 }
+
+int dwmac_est_irq_status(void *ioaddr)
+{
+	struct tsn_err_stat *err_stat = &dw_err_stat;
+	struct tsn_hw_cap *cap = &dw_tsn_hwcap;
+	unsigned int txqcnt_mask = 0;
+	unsigned int status = 0;
+	unsigned int value = 0;
+	unsigned int feqn = 0;
+	unsigned int hbfq = 0;
+	unsigned int hbfs = 0;
+
+	txqcnt_mask = (1 << cap->txqcnt) - 1;
+	status = TSN_RD32(ioaddr + MTL_EST_STATUS);
+
+	value = (MTL_EST_STATUS_CGCE | MTL_EST_STATUS_HLBS |
+		 MTL_EST_STATUS_HLBF | MTL_EST_STATUS_BTRE |
+		 MTL_EST_STATUS_SWLC);
+
+	/* Return if there is no error */
+	if (!(status & value))
+		return 0;
+
+	/* spin_lock() is not needed here because of BTRE and SWLC
+	 * bit will not be altered. Both of the bit will be
+	 * polled in dwmac_set_est_gcrr_times()
+	 */
+	if (status & MTL_EST_STATUS_CGCE) {
+		/* Clear Interrupt */
+		TSN_WR32(MTL_EST_STATUS_CGCE, ioaddr + MTL_EST_STATUS);
+
+		err_stat->cgce_n++;
+	}
+
+	if (status & MTL_EST_STATUS_HLBS) {
+		value = TSN_RD32(ioaddr + MTL_EST_SCH_ERR);
+		value &= txqcnt_mask;
+
+		/* Clear Interrupt */
+		TSN_WR32(value, ioaddr + MTL_EST_SCH_ERR);
+
+		/* Collecting info to shows all the queues that has HLBS */
+		/* issue. The only way to clear this is to clear the     */
+		/* statistic  */
+		err_stat->hlbs_q |= value;
+	}
+
+	if (status & MTL_EST_STATUS_HLBF) {
+		value = TSN_RD32(ioaddr + MTL_EST_FRM_SZ_ERR);
+		feqn = value & txqcnt_mask;
+
+		value = TSN_RD32(ioaddr + MTL_EST_FRM_SZ_CAP);
+		hbfq = (value & MTL_EST_FRM_SZ_CAP_HBFQ_MASK(cap->txqcnt))
+			>> MTL_EST_FRM_SZ_CAP_HBFQ_SHIFT;
+		hbfs = value & MTL_EST_FRM_SZ_CAP_HBFS_MASK;
+
+		/* Clear Interrupt */
+		TSN_WR32(feqn, ioaddr + MTL_EST_FRM_SZ_ERR);
+
+		err_stat->hlbf_sz[hbfq] = hbfs;
+	}
+
+	if (status & MTL_EST_STATUS_BTRE) {
+		if ((status & MTL_EST_STATUS_BTRL) ==
+		    MTL_EST_STATUS_BTRL_MAX)
+			err_stat->btre_max_n++;
+		else
+			err_stat->btre_n++;
+
+		err_stat->btrl = (status & MTL_EST_STATUS_BTRL) >>
+					MTL_EST_STATUS_BTRL_SHIFT;
+
+		TSN_WR32(MTL_EST_STATUS_BTRE, ioaddr +
+		       MTL_EST_STATUS);
+	}
+
+	if (status & MTL_EST_STATUS_SWLC) {
+		TSN_WR32(MTL_EST_STATUS_SWLC, ioaddr +
+			 MTL_EST_STATUS);
+		TSN_INFO_NA("SWOL has been switched\n");
+	}
+
+	return status;
+}
+
+int dwmac_get_est_err_stat(struct tsn_err_stat **err_stat)
+{
+	if (!dw_tsn_feat_en[TSN_FEAT_ID_EST])
+		return -ENOTSUPP;
+
+	*err_stat = &dw_err_stat;
+
+	return 0;
+}
+
+int dwmac_clr_est_err_stat(void *ioaddr)
+{
+	if (!dw_tsn_feat_en[TSN_FEAT_ID_EST])
+		return -ENOTSUPP;
+
+	memset(&dw_err_stat, 0, sizeof(dw_err_stat));
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.h b/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.h
index feb71f7e7031..fa9a06c51a04 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.h
@@ -37,9 +37,30 @@
 #define MTL_EST_STATUS_BTRL_MAX		(0xF << 8)
 #define MTL_EST_STATUS_SWOL		BIT(7)	/* SW owned list */
 #define MTL_EST_STATUS_SWOL_SHIFT	7
+#define MTL_EST_STATUS_CGCE		BIT(4)	/* Constant gate ctrl err */
+#define MTL_EST_STATUS_HLBS		BIT(3)	/* HLB due to scheduling */
+#define MTL_EST_STATUS_HLBF		BIT(2)	/* HLB due to frame size */
 #define MTL_EST_STATUS_BTRE		BIT(1)	/* BTR Error */
 #define MTL_EST_STATUS_SWLC		BIT(0)	/* Switch to SWOL complete */
 
+/* MTL EST Scheduling error */
+#define MTL_EST_SCH_ERR			0x00000c60
+#define MTL_EST_FRM_SZ_ERR		0x00000c64
+#define MTL_EST_FRM_SZ_CAP		0x00000c68
+#define MTL_EST_FRM_SZ_CAP_HBFS_MASK	GENMASK(14, 0)
+#define MTL_EST_FRM_SZ_CAP_HBFQ_SHIFT	16
+#define MTL_EST_FRM_SZ_CAP_HBFQ_MASK(x)	(x > 4 ? GENMASK(18, 16) : \
+						 x > 2 ? GENMASK(17, 16) : \
+						 BIT(16))
+
+/* MTL EST interrupt enable */
+#define MTL_EST_INT_EN			0x00000c70
+#define MTL_EST_INT_EN_CGCE		BIT(4)
+#define MTL_EST_INT_EN_IEHS		BIT(3)
+#define MTL_EST_INT_EN_IEHF		BIT(2)
+#define MTL_EST_INT_EN_IEBE		BIT(1)
+#define MTL_EST_INT_EN_IECC		BIT(0)
+
 /* MTL EST GCL control register */
 #define MTL_EST_GCL_CTRL		0x00000c80
 #define MTL_EST_GCL_CTRL_ADDR		GENMASK(10, 8)	/* GCL Address */
@@ -118,6 +139,26 @@ struct tsn_hw_cap {
 	unsigned int ext_max;		/* Max time extension */
 };
 
+/* TSN Error Status */
+struct tsn_err_stat {
+	unsigned int cgce_n;			/* Constant gate error
+						 * count.
+						 */
+	unsigned int hlbs_q;			/* Queue with HLB due to
+						 * Scheduling
+						 */
+	unsigned int hlbf_sz[MTL_MAX_TX_QUEUES];/* Frame size that causes
+						 * HLB
+						 */
+	unsigned int btre_n;			/* BTR error with BTR
+						 * renewal
+						 */
+	unsigned int btre_max_n;		/* BTR error with BTR
+						 * renewal fail count
+						 */
+	unsigned int btrl;			/* BTR error loop count */
+};
+
 /* EST Gate Control Entry */
 struct est_gc_entry {
 	unsigned int gates;		/* gate control: 0: closed,
@@ -150,6 +191,7 @@ struct est_gc_config {
 
 /* TSN functions */
 void dwmac_tsn_init(void *ioaddr);
+void dwmac_tsn_setup(void *ioaddr);
 void dwmac_get_tsn_hwcap(struct tsn_hw_cap **tsn_hwcap);
 void dwmac_set_est_gcb(struct est_gc_entry *gcl, unsigned int bank);
 void dwmac_set_tsn_feat(enum tsn_feat_id featid, bool enable);
@@ -170,4 +212,7 @@ int dwmac_set_est_gcrr_times(void *ioaddr,
 int dwmac_set_est_enable(void *ioaddr, bool enable);
 int dwmac_get_est_gcc(void *ioaddr,
 		      struct est_gc_config **gcc, bool frmdrv);
+int dwmac_est_irq_status(void *ioaddr);
+int dwmac_get_est_err_stat(struct tsn_err_stat **err_stat);
+int dwmac_clr_est_err_stat(void *ioaddr);
 #endif /* __DW_TSN_LIB_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 1361807fe802..39a35f7eb91d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -830,6 +830,9 @@ static void dwmac4_set_mac_loopback(void __iomem *ioaddr, bool enable)
 	.set_est_gcrr_times = dwmac_set_est_gcrr_times,
 	.set_est_enable = dwmac_set_est_enable,
 	.get_est_gcc = dwmac_get_est_gcc,
+	.est_irq_status = dwmac_est_irq_status,
+	.get_est_err_stat = dwmac_get_est_err_stat,
+	.clr_est_err_stat = dwmac_clr_est_err_stat,
 	.safety_feat_config = dwmac5_safety_feat_config,
 	.safety_feat_irq_status = dwmac5_safety_feat_irq_status,
 	.safety_feat_dump = dwmac5_safety_feat_dump,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 518a72805185..dec9b1f5c557 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -337,6 +337,9 @@ struct stmmac_ops {
 	int (*set_est_enable)(void __iomem *ioaddr, bool enable);
 	int (*get_est_gcc)(void __iomem *ioaddr,
 			   struct est_gc_config **gcc, bool frmdrv);
+	int (*est_irq_status)(void __iomem *ioaddr);
+	int (*get_est_err_stat)(struct tsn_err_stat **err_stat);
+	int (*clr_est_err_stat)(void __iomem *ioaddr);
 	/* Safety Features */
 	int (*safety_feat_config)(void __iomem *ioaddr, unsigned int asp);
 	int (*safety_feat_irq_status)(struct net_device *ndev,
@@ -437,6 +440,12 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, set_est_enable, __args)
 #define stmmac_get_est_gcc(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, get_est_gcc, __args)
+#define stmmac_est_irq_status(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, est_irq_status, __args)
+#define stmmac_get_est_err_stat(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, get_est_err_stat, __args)
+#define stmmac_clr_est_err_stat(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, clr_est_err_stat, __args)
 #define stmmac_safety_feat_config(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, safety_feat_config, __args)
 #define stmmac_safety_feat_irq_status(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 91213cd3a668..c28b5e69f2cd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2530,6 +2530,9 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	/* Start the ball rolling... */
 	stmmac_start_all_dma(priv);
 
+	/* Setup for TSN capability */
+	dwmac_tsn_setup(priv->ioaddr);
+
 	return 0;
 }
 
@@ -3693,6 +3696,9 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 						       queue);
 		}
 
+		if (priv->hw->tsn_cap & TSN_CAP_EST)
+			stmmac_est_irq_status(priv, priv->ioaddr);
+
 		/* PCS link status */
 		if (priv->hw->pcs) {
 			if (priv->xstats.pcs_link)
@@ -4297,6 +4303,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_get_tsn_hwcap(priv, &tsn_hwcap);
 	if (tsn_hwcap && tsn_hwcap->est_support && priv->plat->tsn_est_en) {
 		stmmac_set_tsn_feat(priv, TSN_FEAT_ID_EST, true);
+		priv->hw->tsn_cap |= TSN_CAP_EST;
 		dev_info(priv->device, "EST feature enabled\n");
 	}
 
-- 
1.9.1


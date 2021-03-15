Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F4B33C931
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 23:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhCOWPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 18:15:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:14823 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhCOWPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 18:15:05 -0400
IronPort-SDR: N5olcwQ+r6NGUDW8KqxgBc+vWJVn+QaUjjDW5aVsh0T22TJ76F5AoEjrjwR3OvBB/hlqvBcS90
 nMeJ8zjIBekQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="185802463"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="185802463"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 15:15:05 -0700
IronPort-SDR: EymrEj7j7npaaLlHFcEtSF2WpiX9GS+HRZfz6Xo9EzHfqJlBWdajPUXVF4+JRXURC5xvrpC5as
 4MJys40vuWSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="410807087"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga007.jf.intel.com with ESMTP; 15 Mar 2021 15:15:01 -0700
From:   mohammad.athari.ismail@intel.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, vee.khee.wong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net-next 1/2] net: stmmac: EST interrupts handling and error reporting
Date:   Tue, 16 Mar 2021 06:14:08 +0800
Message-Id: <20210315221409.3867-2-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210315221409.3867-1-mohammad.athari.ismail@intel.com>
References: <20210315221409.3867-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

Enabled EST related interrupts as below:
1) Constant Gate Control Error (CGCE)
2) Head-of-Line Blocking due to Scheduling (HLBS)
3) Head-of-Line Blocking due to Frame Size (HLBF).
4) Base Time Register error (BTRE)
5) Switch to S/W owned list Complete (SWLC)

For HLBS, the user will get the info of all the queues that shows this
error. For HLBF, the user will get the info of all the queue with the
latest frame size which causes the error. Frame size 0 indicates no
error.

The ISR handling takes place when EST feature is enabled by user.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Co-developed-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c  | 77 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h  | 32 ++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  4 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  3 +
 4 files changed, 116 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 8f7ac24545ef..b47190fc8d83 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -595,9 +595,86 @@ int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 		ctrl &= ~EEST;
 
 	writel(ctrl, ioaddr + MTL_EST_CONTROL);
+
+	/* Configure EST interrupt */
+	if (cfg->enable)
+		ctrl = (IECGCE | IEHS | IEHF | IEBE | IECC);
+	else
+		ctrl = 0;
+
+	writel(ctrl, ioaddr + MTL_EST_INT_EN);
+
 	return 0;
 }
 
+int dwmac5_est_irq_status(void __iomem *ioaddr, struct net_device *dev,
+			  u32 txqcnt)
+{
+	u32 status, value, feqn, hbfq, hbfs, btrl;
+	u32 txqcnt_mask = (1 << txqcnt) - 1;
+
+	status = readl(ioaddr + MTL_EST_STATUS);
+
+	value = (CGCE | HLBS | HLBF | BTRE | SWLC);
+
+	/* Return if there is no error */
+	if (!(status & value))
+		return 0;
+
+	if (status & CGCE) {
+		/* Clear Interrupt */
+		writel(CGCE, ioaddr + MTL_EST_STATUS);
+	}
+
+	if (status & HLBS) {
+		value = readl(ioaddr + MTL_EST_SCH_ERR);
+		value &= txqcnt_mask;
+
+		/* Clear Interrupt */
+		writel(value, ioaddr + MTL_EST_SCH_ERR);
+
+		/* Collecting info to shows all the queues that has HLBS
+		 * issue. The only way to clear this is to clear the
+		 * statistic
+		 */
+		if (net_ratelimit())
+			netdev_err(dev, "EST: HLB(sched) Queue %u\n", value);
+	}
+
+	if (status & HLBF) {
+		value = readl(ioaddr + MTL_EST_FRM_SZ_ERR);
+		feqn = value & txqcnt_mask;
+
+		value = readl(ioaddr + MTL_EST_FRM_SZ_CAP);
+		hbfq = (value & SZ_CAP_HBFQ_MASK(txqcnt)) >> SZ_CAP_HBFQ_SHIFT;
+		hbfs = value & SZ_CAP_HBFS_MASK;
+
+		/* Clear Interrupt */
+		writel(feqn, ioaddr + MTL_EST_FRM_SZ_ERR);
+
+		if (net_ratelimit())
+			netdev_err(dev, "EST: HLB(size) Queue %u Size %u\n",
+				   hbfq, hbfs);
+	}
+
+	if (status & BTRE) {
+		btrl = (status & BTRL) >> BTRL_SHIFT;
+
+		if (net_ratelimit())
+			netdev_info(dev, "EST: BTR Error Loop Count %u\n",
+				    btrl);
+
+		writel(BTRE, ioaddr + MTL_EST_STATUS);
+	}
+
+	if (status & SWLC) {
+		writel(SWLC, ioaddr + MTL_EST_STATUS);
+		netdev_info(dev, "EST: SWOL has been switched\n");
+	}
+
+	return status;
+}
+
 void dwmac5_fpe_configure(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
 			  bool enable)
 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index 56b0762c1276..51d9ed24622f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -38,6 +38,36 @@
 #define PTOV_SHIFT			24
 #define SSWL				BIT(1)
 #define EEST				BIT(0)
+
+#define MTL_EST_STATUS			0x00000c58
+#define BTRL				GENMASK(11, 8)
+#define BTRL_SHIFT			8
+#define BTRL_MAX			(0xF << BTRL_SHIFT)
+#define SWOL				BIT(7)
+#define SWOL_SHIFT			7
+#define CGCE				BIT(4)
+#define HLBS				BIT(3)
+#define HLBF				BIT(2)
+#define BTRE				BIT(1)
+#define SWLC				BIT(0)
+
+#define MTL_EST_SCH_ERR			0x00000c60
+#define MTL_EST_FRM_SZ_ERR		0x00000c64
+#define MTL_EST_FRM_SZ_CAP		0x00000c68
+#define SZ_CAP_HBFS_MASK		GENMASK(14, 0)
+#define SZ_CAP_HBFQ_SHIFT		16
+#define SZ_CAP_HBFQ_MASK(_val)		({ typeof(_val) (val) = (_val);	\
+					((val) > 4 ? GENMASK(18, 16) :	\
+					 (val) > 2 ? GENMASK(17, 16) :	\
+					 BIT(16)); })
+
+#define MTL_EST_INT_EN			0x00000c70
+#define IECGCE				CGCE
+#define IEHS				HLBS
+#define IEHF				HLBF
+#define IEBE				BTRE
+#define IECC				SWLC
+
 #define MTL_EST_GCL_CONTROL		0x00000c80
 #define BTR_LOW				0x0
 #define BTR_HIGH			0x1
@@ -111,6 +141,8 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 			   u32 sub_second_inc, u32 systime_flags);
 int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 			 unsigned int ptp_rate);
+int dwmac5_est_irq_status(void __iomem *ioaddr, struct net_device *dev,
+			  u32 txqcnt);
 void dwmac5_fpe_configure(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
 			  bool enable);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 979ac9fca23c..78a677a86914 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -393,6 +393,8 @@ struct stmmac_ops {
 	void (*set_arp_offload)(struct mac_device_info *hw, bool en, u32 addr);
 	int (*est_configure)(void __iomem *ioaddr, struct stmmac_est *cfg,
 			     unsigned int ptp_rate);
+	int (*est_irq_status)(void __iomem *ioaddr, struct net_device *dev,
+			      u32 txqcnt);
 	void (*fpe_configure)(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
 			      bool enable);
 };
@@ -491,6 +493,8 @@ struct stmmac_ops {
 	stmmac_do_void_callback(__priv, mac, set_arp_offload, __args)
 #define stmmac_est_configure(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, est_configure, __args)
+#define stmmac_est_irq_status(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, est_irq_status, __args)
 #define stmmac_fpe_configure(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, fpe_configure, __args)
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 208cae344ffa..24b9212c7566 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4241,6 +4241,9 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	if (stmmac_safety_feat_interrupt(priv))
 		return IRQ_HANDLED;
 
+	if (priv->dma_cap.estsel)
+		stmmac_est_irq_status(priv, priv->ioaddr, priv->dev, tx_cnt);
+
 	/* To handle GMAC own interrupts */
 	if ((priv->plat->has_gmac) || xmac) {
 		int status = stmmac_host_irq_status(priv, priv->hw, &priv->xstats);
-- 
2.17.1


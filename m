Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BDB357290
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 19:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354435AbhDGRAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 13:00:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:33367 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354431AbhDGRAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 13:00:34 -0400
IronPort-SDR: cOmY7ebg2lTdz9Ze98ABv1Ajqf6gquJ554WMVoxz/axB9tIC98VW5ijHoPWas/4eOb/cRx/vPH
 ba3DLax9P50w==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="257340689"
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="257340689"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 10:00:22 -0700
IronPort-SDR: 3/bj8c0xfcYJbwVPBg+Xi+ubXdWqACKUNBeivkTS0z13Up6awuyCRJVwVCGlwzVrsFLfHhFbgP
 vUhYzSxSAsnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="449205762"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2021 10:00:18 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 9D0EA5808F7;
        Wed,  7 Apr 2021 10:00:15 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/1] net: stmmac: Add support for external trigger timestamping
Date:   Thu,  8 Apr 2021 01:04:42 +0800
Message-Id: <20210407170442.1641-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Tee Min <tee.min.tan@intel.com>

The Synopsis MAC controller supports auxiliary snapshot feature that
allows user to store a snapshot of the system time based on an external
event.

This patch add supports to the above mentioned feature. Users will be
able to triggered capturing the time snapshot from user-space using
application such as testptp or any other applications that uses the
PTP_EXTTS_REQUEST ioctl request.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Tan Tee Min <tee.min.tan@intel.com>
Co-developed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
v1 -> v2:
Changed from pr_info() to netdev_dbg().

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 11 +++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  5 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 ++
 .../ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 40 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 39 +++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.h  |  1 +
 include/linux/stmmac.h                        |  2 +
 8 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 8ba87c0be976..aee3e0b5fb46 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -286,6 +286,13 @@ static int intel_crosststamp(ktime_t *device,
 
 	intel_priv = priv->plat->bsp_priv;
 
+	/* Both internal crosstimestamping and external triggered event
+	 * timestamping cannot be run concurrently.
+	 */
+	if (priv->plat->ext_snapshot_en)
+		return -EBUSY;
+
+	mutex_lock(&priv->aux_ts_lock);
 	/* Enable Internal snapshot trigger */
 	acr_value = readl(ptpaddr + PTP_ACR);
 	acr_value &= ~PTP_ACR_MASK;
@@ -311,6 +318,7 @@ static int intel_crosststamp(ktime_t *device,
 	acr_value = readl(ptpaddr + PTP_ACR);
 	acr_value |= PTP_ACR_ATSFC;
 	writel(acr_value, ptpaddr + PTP_ACR);
+	mutex_unlock(&priv->aux_ts_lock);
 
 	/* Trigger Internal snapshot signal
 	 * Create a rising edge by just toggle the GPO1 to low
@@ -345,6 +353,8 @@ static int intel_crosststamp(ktime_t *device,
 		*system = convert_art_to_tsc(art_time);
 	}
 
+	/* Release the mutex */
+	mutex_unlock(&priv->aux_ts_lock);
 	system->cycles *= intel_priv->crossts_adj;
 
 	return 0;
@@ -510,6 +520,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->mdio_bus_data->phy_mask |= 1 << INTEL_MGBE_XPCS_ADDR;
 
 	plat->int_snapshot_num = AUX_SNAPSHOT1;
+	plat->ext_snapshot_num = AUX_SNAPSHOT0;
 
 	plat->has_crossts = true;
 	plat->crosststamp = intel_crosststamp;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 2b5022ef1e52..2cc91759b91f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -504,6 +504,8 @@ struct stmmac_ops {
 #define stmmac_fpe_irq_status(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, fpe_irq_status, __args)
 
+struct stmmac_priv;
+
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
 	void (*config_hw_tstamping) (void __iomem *ioaddr, u32 data);
@@ -515,6 +517,7 @@ struct stmmac_hwtimestamp {
 			       int add_sub, int gmac4);
 	void (*get_systime) (void __iomem *ioaddr, u64 *systime);
 	void (*get_ptptime)(void __iomem *ioaddr, u64 *ptp_time);
+	void (*timestamp_interrupt)(struct stmmac_priv *priv);
 };
 
 #define stmmac_config_hw_tstamping(__priv, __args...) \
@@ -531,6 +534,8 @@ struct stmmac_hwtimestamp {
 	stmmac_do_void_callback(__priv, ptp, get_systime, __args)
 #define stmmac_get_ptptime(__priv, __args...) \
 	stmmac_do_void_callback(__priv, ptp, get_ptptime, __args)
+#define stmmac_timestamp_interrupt(__priv, __args...) \
+	stmmac_do_void_callback(__priv, ptp, timestamp_interrupt, __args)
 
 /* Helpers to manage the descriptors for chain and ring modes */
 struct stmmac_mode_ops {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index c49debb62b05..abadcd8cdc41 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -239,6 +239,9 @@ struct stmmac_priv {
 	int use_riwt;
 	int irq_wake;
 	spinlock_t ptp_lock;
+	/* Mutex lock for Auxiliary Snapshots */
+	struct mutex aux_ts_lock;
+
 	void __iomem *mmcaddr;
 	void __iomem *ptpaddr;
 	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 113c51bcc0b5..ec7ec926f27c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -12,8 +12,11 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/delay.h>
+#include <linux/ptp_clock_kernel.h>
 #include "common.h"
 #include "stmmac_ptp.h"
+#include "dwmac4.h"
+#include "stmmac.h"
 
 static void config_hw_tstamping(void __iomem *ioaddr, u32 data)
 {
@@ -163,6 +166,42 @@ static void get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)
 	*ptp_time = ns;
 }
 
+static void timestamp_interrupt(struct stmmac_priv *priv)
+{
+	struct ptp_clock_event event;
+	unsigned long flags;
+	u32 num_snapshot;
+	u32 ts_status;
+	u32 tsync_int;
+	u64 ptp_time;
+	int i;
+
+	tsync_int = readl(priv->ioaddr + GMAC_INT_STATUS) & GMAC_INT_TSIE;
+
+	if (!tsync_int)
+		return;
+
+	/* Read timestamp status to clear interrupt from either external
+	 * timestamp or start/end of PPS.
+	 */
+	ts_status = readl(priv->ioaddr + GMAC_TIMESTAMP_STATUS);
+
+	if (priv->plat->ext_snapshot_en) {
+		num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
+			       GMAC_TIMESTAMP_ATSNS_SHIFT;
+
+		for (i = 0; i < num_snapshot; i++) {
+			spin_lock_irqsave(&priv->ptp_lock, flags);
+			get_ptptime(priv->ptpaddr, &ptp_time);
+			spin_unlock_irqrestore(&priv->ptp_lock, flags);
+			event.type = PTP_CLOCK_EXTTS;
+			event.index = 0;
+			event.timestamp = ptp_time;
+			ptp_clock_event(priv->ptp_clock, &event);
+		}
+	}
+}
+
 const struct stmmac_hwtimestamp stmmac_ptp = {
 	.config_hw_tstamping = config_hw_tstamping,
 	.init_systime = init_systime,
@@ -171,4 +210,5 @@ const struct stmmac_hwtimestamp stmmac_ptp = {
 	.adjust_systime = adjust_systime,
 	.get_systime = get_systime,
 	.get_ptptime = get_ptptime,
+	.timestamp_interrupt = timestamp_interrupt,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 77285646c5fc..9e57bc3d00a3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4989,6 +4989,8 @@ static void stmmac_common_interrupt(struct stmmac_priv *priv)
 			else
 				netif_carrier_off(priv->dev);
 		}
+
+		stmmac_timestamp_interrupt(priv, priv);
 	}
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index b164ae22e35f..d668c33a0746 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -135,9 +135,13 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 {
 	struct stmmac_priv *priv =
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
+	void __iomem *ptpaddr = priv->ptpaddr;
+	void __iomem *ioaddr = priv->hw->pcsr;
 	struct stmmac_pps_cfg *cfg;
 	int ret = -EOPNOTSUPP;
 	unsigned long flags;
+	u32 intr_value;
+	u32 acr_value;
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
@@ -159,6 +163,37 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 					     priv->systime_flags);
 		spin_unlock_irqrestore(&priv->ptp_lock, flags);
 		break;
+	case PTP_CLK_REQ_EXTTS:
+		priv->plat->ext_snapshot_en = on;
+		mutex_lock(&priv->aux_ts_lock);
+		acr_value = readl(ptpaddr + PTP_ACR);
+		acr_value &= ~PTP_ACR_MASK;
+		if (on) {
+			/* Enable External snapshot trigger */
+			acr_value |= priv->plat->ext_snapshot_num;
+			acr_value |= PTP_ACR_ATSFC;
+			netdev_dbg(priv->dev, "Auxiliary Snapshot %d enabled.\n",
+				   priv->plat->ext_snapshot_num >>
+				   PTP_ACR_ATSEN_SHIFT);
+			/* Enable Timestamp Interrupt */
+			intr_value = readl(ioaddr + GMAC_INT_EN);
+			intr_value |= GMAC_INT_TSIE;
+			writel(intr_value, ioaddr + GMAC_INT_EN);
+
+		} else {
+			netdev_dbg(priv->dev, "Auxiliary Snapshot %d disabled.\n",
+				   priv->plat->ext_snapshot_num >>
+				   PTP_ACR_ATSEN_SHIFT);
+			/* Disable Timestamp Interrupt */
+			intr_value = readl(ioaddr + GMAC_INT_EN);
+			intr_value &= ~GMAC_INT_TSIE;
+			writel(intr_value, ioaddr + GMAC_INT_EN);
+		}
+		writel(acr_value, ptpaddr + PTP_ACR);
+		mutex_unlock(&priv->aux_ts_lock);
+		ret = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -202,7 +237,7 @@ static struct ptp_clock_info stmmac_ptp_clock_ops = {
 	.name = "stmmac ptp",
 	.max_adj = 62500000,
 	.n_alarm = 0,
-	.n_ext_ts = 0,
+	.n_ext_ts = 0, /* will be overwritten in stmmac_ptp_register */
 	.n_per_out = 0, /* will be overwritten in stmmac_ptp_register */
 	.n_pins = 0,
 	.pps = 0,
@@ -237,8 +272,10 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 		stmmac_ptp_clock_ops.max_adj = priv->plat->ptp_max_adj;
 
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
+	stmmac_ptp_clock_ops.n_ext_ts = priv->dma_cap.aux_snapshot_n;
 
 	spin_lock_init(&priv->ptp_lock);
+	mutex_init(&priv->aux_ts_lock);
 	priv->ptp_clock_ops = stmmac_ptp_clock_ops;
 
 	priv->ptp_clock = ptp_clock_register(&priv->ptp_clock_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
index f88727ce4d30..53172a439810 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
@@ -73,6 +73,7 @@
 #define	PTP_ACR_ATSEN1		BIT(5)	/* Auxiliary Snapshot 1 Enable */
 #define	PTP_ACR_ATSEN2		BIT(6)	/* Auxiliary Snapshot 2 Enable */
 #define	PTP_ACR_ATSEN3		BIT(7)	/* Auxiliary Snapshot 3 Enable */
+#define	PTP_ACR_ATSEN_SHIFT	5	/* Auxiliary Snapshot shift */
 #define	PTP_ACR_MASK		GENMASK(7, 4)	/* Aux Snapshot Mask */
 #define	PMC_ART_VALUE0		0x01	/* PMC_ART[15:0] timer value */
 #define	PMC_ART_VALUE1		0x02	/* PMC_ART[31:16] timer value */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index e338ef7abc00..97edb31d6310 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -238,6 +238,8 @@ struct plat_stmmacenet_data {
 	struct pci_dev *pdev;
 	bool has_crossts;
 	int int_snapshot_num;
+	int ext_snapshot_num;
+	bool ext_snapshot_en;
 	bool multi_msi_en;
 	int msi_mac_vec;
 	int msi_wol_vec;
-- 
2.25.1


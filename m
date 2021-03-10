Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396CD333438
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 05:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhCJEHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 23:07:03 -0500
Received: from mga12.intel.com ([192.55.52.136]:25451 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229673AbhCJEGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 23:06:32 -0500
IronPort-SDR: MEn6ePwzKqCksvrAC9E+DCQU//RqNDxDIU23xK+Vx/63FZ1O76XMZXRFBdVdJm4l2epLh/zUAh
 eGyUHYcuPD6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="167653849"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="167653849"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 20:06:31 -0800
IronPort-SDR: 6Aq6Jf0t8qLermoraF7g3Ka4hT+NHlmejKIH6plQw7gWy72dgbKx0Yl9OtcSbC3ZtN0j3yPHpF
 uFWDJWuSPBnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="438158836"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Mar 2021 20:06:28 -0800
From:   mohammad.athari.ismail@intel.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [RFC net-next] net: stmmac: support FPE link partner hand-shaking procedure
Date:   Wed, 10 Mar 2021 12:05:46 +0800
Message-Id: <20210310040546.15809-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

In order to discover whether remote station supports frame preemption,
local station sends verify mPacket and expects response mPacket in return
from the remote station.

So, we add the functions to send and handle event when verify mPacket and
response mPacket are exchanged between the networked stations.

The mechanism to handle different FPE states between local and remote
station (link partner) is implemented using workqueue which starts a task
each time there is some sign of verify & response mPacket exchange as
check in FPE IRQ event. The task retries couple of times to try to spot
the states that both stations are ready to enter FPE ON. This allows
different end points to enable FPE at different time and verify-response
mPacket can happen asynchronously. Ultimately, the task will only turn FPE
ON when local station have both exchange response in both directions.

Thanks to Voon Weifeng for implementing the core functions for detecting
FPE events and send mPacket and phylink related change.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Co-developed-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Co-developed-by: Tan Tee Min <tee.min.tan@intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@intel.com>
Co-developed-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |   7 +
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |   8 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c  |  49 +++++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h  |  11 ++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   7 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   7 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 179 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  28 ++-
 include/linux/stmmac.h                        |  27 +++
 9 files changed, 316 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 6f271c46368d..fdb744b55932 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -309,6 +309,13 @@ enum dma_irq_status {
 #define	CORE_IRQ_RX_PATH_IN_LPI_MODE	(1 << 2)
 #define	CORE_IRQ_RX_PATH_EXIT_LPI_MODE	(1 << 3)
 
+/* FPE defines */
+#define FPE_EVENT_UNKNOWN		0
+#define FPE_EVENT_TRSP			BIT(0)
+#define FPE_EVENT_TVER			BIT(1)
+#define FPE_EVENT_RRSP			BIT(2)
+#define FPE_EVENT_RVER			BIT(3)
+
 #define CORE_IRQ_MTL_RX_OVERFLOW	BIT(8)
 
 /* Physical Coding Sublayer */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 29f765a246a0..95864f014ffa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -53,6 +53,10 @@ static void dwmac4_core_init(struct mac_device_info *hw,
 	if (hw->pcs)
 		value |= GMAC_PCS_IRQ_DEFAULT;
 
+	/* Enable FPE interrupt */
+	if ((GMAC_HW_FEAT_FPESEL & readl(ioaddr + GMAC_HW_FEATURE3)) >> 26)
+		value |= GMAC_INT_FPE_EN;
+
 	writel(value, ioaddr + GMAC_INT_EN);
 }
 
@@ -1245,6 +1249,8 @@ const struct stmmac_ops dwmac410_ops = {
 	.config_l4_filter = dwmac4_config_l4_filter,
 	.est_configure = dwmac5_est_configure,
 	.fpe_configure = dwmac5_fpe_configure,
+	.fpe_send_mpacket = dwmac5_fpe_send_mpacket,
+	.fpe_irq_status = dwmac5_fpe_irq_status,
 	.add_hw_vlan_rx_fltr = dwmac4_add_hw_vlan_rx_fltr,
 	.del_hw_vlan_rx_fltr = dwmac4_del_hw_vlan_rx_fltr,
 	.restore_hw_vlan_rx_fltr = dwmac4_restore_hw_vlan_rx_fltr,
@@ -1294,6 +1300,8 @@ const struct stmmac_ops dwmac510_ops = {
 	.config_l4_filter = dwmac4_config_l4_filter,
 	.est_configure = dwmac5_est_configure,
 	.fpe_configure = dwmac5_fpe_configure,
+	.fpe_send_mpacket = dwmac5_fpe_send_mpacket,
+	.fpe_irq_status = dwmac5_fpe_irq_status,
 	.add_hw_vlan_rx_fltr = dwmac4_add_hw_vlan_rx_fltr,
 	.del_hw_vlan_rx_fltr = dwmac4_del_hw_vlan_rx_fltr,
 	.restore_hw_vlan_rx_fltr = dwmac4_restore_hw_vlan_rx_fltr,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 8f7ac24545ef..5b0a7216527e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -621,3 +621,52 @@ void dwmac5_fpe_configure(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
 	value |= EFPE;
 	writel(value, ioaddr + MAC_FPE_CTRL_STS);
 }
+
+int dwmac5_fpe_irq_status(void __iomem *ioaddr, struct net_device *dev)
+{
+	u32 value;
+	int status;
+
+	status = FPE_EVENT_UNKNOWN;
+
+	value = readl(ioaddr + MAC_FPE_CTRL_STS);
+
+	if (value & TRSP) {
+		status |= FPE_EVENT_TRSP;
+		netdev_info(dev, "FPE: Respond mPacket is transmitted\n");
+	}
+
+	if (value & TVER) {
+		status |= FPE_EVENT_TVER;
+		netdev_info(dev, "FPE: Verify mPacket is transmitted\n");
+	}
+
+	if (value & RRSP) {
+		status |= FPE_EVENT_RRSP;
+		netdev_info(dev, "FPE: Respond mPacket is received\n");
+	}
+
+	if (value & RVER) {
+		status |= FPE_EVENT_RVER;
+		netdev_info(dev, "FPE: Verify mPacket is received\n");
+	}
+
+	return status;
+}
+
+void dwmac5_fpe_send_mpacket(void __iomem *ioaddr, enum stmmac_mpacket_type type)
+{
+	u32 value;
+
+	value = readl(ioaddr + MAC_FPE_CTRL_STS);
+
+	if (type == MPACKET_VERIFY) {
+		value &= ~SRSP;
+		value |= SVER;
+	} else {
+		value &= ~SVER;
+		value |= SRSP;
+	}
+
+	writel(value, ioaddr + MAC_FPE_CTRL_STS);
+}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index 56b0762c1276..79fe84c90e53 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -12,6 +12,12 @@
 #define TMOUTEN				BIT(0)
 
 #define MAC_FPE_CTRL_STS		0x00000234
+#define TRSP				BIT(19)
+#define TVER				BIT(18)
+#define RRSP				BIT(17)
+#define RVER				BIT(16)
+#define SRSP				BIT(2)
+#define SVER				BIT(1)
 #define EFPE				BIT(0)
 
 #define MAC_PPS_CONTROL			0x00000b70
@@ -98,6 +104,8 @@
 #define GMAC_RXQCTRL_VFFQ_SHIFT		17
 #define GMAC_RXQCTRL_VFFQE		BIT(16)
 
+#define GMAC_INT_FPE_EN			BIT(17)
+
 int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp);
 int dwmac5_safety_feat_irq_status(struct net_device *ndev,
 		void __iomem *ioaddr, unsigned int asp,
@@ -113,5 +121,8 @@ int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 			 unsigned int ptp_rate);
 void dwmac5_fpe_configure(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
 			  bool enable);
+void dwmac5_fpe_send_mpacket(void __iomem *ioaddr,
+			     enum stmmac_mpacket_type type);
+int dwmac5_fpe_irq_status(void __iomem *ioaddr, struct net_device *dev);
 
 #endif /* __DWMAC5_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 979ac9fca23c..6a36ac4a0a00 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -395,6 +395,9 @@ struct stmmac_ops {
 			     unsigned int ptp_rate);
 	void (*fpe_configure)(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
 			      bool enable);
+	void (*fpe_send_mpacket)(void __iomem *ioaddr,
+				 enum stmmac_mpacket_type type);
+	int (*fpe_irq_status)(void __iomem *ioaddr, struct net_device *dev);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -493,6 +496,10 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, est_configure, __args)
 #define stmmac_fpe_configure(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, fpe_configure, __args)
+#define stmmac_fpe_send_mpacket(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, fpe_send_mpacket, __args)
+#define stmmac_fpe_irq_status(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, fpe_irq_status, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index e553b9a1f785..081245b25536 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -234,6 +234,12 @@ struct stmmac_priv {
 	struct workqueue_struct *wq;
 	struct work_struct service_task;
 
+	/* Workqueue for handling FPE hand-shaking */
+	unsigned long fpe_task_state;
+	struct workqueue_struct *fpe_wq;
+	struct work_struct fpe_task;
+	char wq_name[IFNAMSIZ + 4];
+
 	/* TC Handling */
 	unsigned int tc_entries_max;
 	unsigned int tc_off_max;
@@ -272,6 +278,7 @@ void stmmac_disable_eee_mode(struct stmmac_priv *priv);
 bool stmmac_eee_init(struct stmmac_priv *priv);
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
 int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
+void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable);
 
 #if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
 void stmmac_selftest_run(struct net_device *dev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 208cae344ffa..39f8e1a2affa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -922,6 +922,21 @@ static void stmmac_mac_an_restart(struct phylink_config *config)
 	/* Not Supported */
 }
 
+void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
+{
+	struct stmmac_fpe_cfg *fpe_cfg = &priv->plat->fpe_cfg;
+	enum stmmac_fpe_state *lo_state = &fpe_cfg->lo_fpe_state;
+	enum stmmac_fpe_state *lp_state = &fpe_cfg->lp_fpe_state;
+	bool *hs_enable = &fpe_cfg->hs_enable;
+
+	if (is_up && *hs_enable) {
+		stmmac_fpe_send_mpacket(priv, priv->ioaddr, MPACKET_VERIFY);
+	} else {
+		*lo_state = FPE_EVENT_UNKNOWN;
+		*lp_state = FPE_EVENT_UNKNOWN;
+	}
+}
+
 static void stmmac_mac_link_down(struct phylink_config *config,
 				 unsigned int mode, phy_interface_t interface)
 {
@@ -932,6 +947,8 @@ static void stmmac_mac_link_down(struct phylink_config *config,
 	priv->tx_lpi_enabled = false;
 	stmmac_eee_init(priv);
 	stmmac_set_eee_pls(priv, priv->hw, false);
+
+	stmmac_fpe_link_state_handle(priv, false);
 }
 
 static void stmmac_mac_link_up(struct phylink_config *config,
@@ -1030,6 +1047,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 		priv->tx_lpi_enabled = priv->eee_enabled;
 		stmmac_set_eee_pls(priv, priv->hw, true);
 	}
+
+	stmmac_fpe_link_state_handle(priv, true);
 }
 
 static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
@@ -2737,6 +2756,26 @@ static void stmmac_safety_feat_configuration(struct stmmac_priv *priv)
 	}
 }
 
+static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
+{
+	char *name;
+
+	clear_bit(__FPE_TASK_SCHED, &priv->fpe_task_state);
+
+	name = priv->wq_name;
+	sprintf(name, "%s-fpe", priv->dev->name);
+
+	priv->fpe_wq = create_singlethread_workqueue(name);
+	if (!priv->fpe_wq) {
+		netdev_err(priv->dev, "%s: Failed to create workqueue\n", name);
+
+		return -ENOMEM;
+	}
+	netdev_info(priv->dev, "FPE workqueue start");
+
+	return 0;
+}
+
 /**
  * stmmac_hw_setup - setup mac in a usable state.
  *  @dev : pointer to the device structure.
@@ -2868,6 +2907,13 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	/* Start the ball rolling... */
 	stmmac_start_all_dma(priv);
 
+	if (priv->dma_cap.fpesel) {
+		stmmac_fpe_start_wq(priv);
+
+		if (priv->plat->fpe_cfg.enable)
+			stmmac_fpe_handshake(priv, true);
+	}
+
 	return 0;
 }
 
@@ -3021,6 +3067,16 @@ static int stmmac_open(struct net_device *dev)
 	return ret;
 }
 
+static void stmmac_fpe_stop_wq(struct stmmac_priv *priv)
+{
+	set_bit(__FPE_REMOVING, &priv->fpe_task_state);
+
+	if (priv->fpe_wq)
+		destroy_workqueue(priv->fpe_wq);
+
+	netdev_info(priv->dev, "FPE workqueue stop");
+}
+
 /**
  *  stmmac_release - close entry point of the driver
  *  @dev : device pointer.
@@ -3068,6 +3124,9 @@ static int stmmac_release(struct net_device *dev)
 
 	stmmac_release_ptp(priv);
 
+	if (priv->dma_cap.fpesel)
+		stmmac_fpe_stop_wq(priv);
+
 	return 0;
 }
 
@@ -4207,6 +4266,48 @@ static int stmmac_set_features(struct net_device *netdev,
 	return 0;
 }
 
+void stmmac_fpe_event_status(struct stmmac_priv *priv, int status)
+{
+	struct stmmac_fpe_cfg *fpe_cfg = &priv->plat->fpe_cfg;
+	enum stmmac_fpe_state *lo_state = &fpe_cfg->lo_fpe_state;
+	enum stmmac_fpe_state *lp_state = &fpe_cfg->lp_fpe_state;
+	bool *hs_enable = &fpe_cfg->hs_enable;
+
+	if (status == FPE_EVENT_UNKNOWN || !*hs_enable)
+		return;
+
+	/* If LP has sent verify mPacket, LP is FPE capable */
+	if ((status & FPE_EVENT_RVER) == FPE_EVENT_RVER) {
+		if (*lp_state < FPE_STATE_CAPABLE)
+			*lp_state = FPE_STATE_CAPABLE;
+
+		/* If user has requested FPE enable, quickly response */
+		if (*hs_enable)
+			stmmac_fpe_send_mpacket(priv, priv->ioaddr,
+						MPACKET_RESPONSE);
+	}
+
+	/* If Local has sent verify mPacket, Local is FPE capable */
+	if ((status & FPE_EVENT_TVER) == FPE_EVENT_TVER) {
+		if (*lo_state < FPE_STATE_CAPABLE)
+			*lo_state = FPE_STATE_CAPABLE;
+	}
+
+	/* If LP has sent response mPacket, LP is entering FPE ON */
+	if ((status & FPE_EVENT_RRSP) == FPE_EVENT_RRSP)
+		*lp_state = FPE_STATE_ENTERING_ON;
+
+	/* If Local has sent response mPacket, Local is entering FPE ON */
+	if ((status & FPE_EVENT_TRSP) == FPE_EVENT_TRSP)
+		*lo_state = FPE_STATE_ENTERING_ON;
+
+	if (!test_bit(__FPE_REMOVING, &priv->fpe_task_state) &&
+	    !test_and_set_bit(__FPE_TASK_SCHED, &priv->fpe_task_state) &&
+	    priv->fpe_wq) {
+		queue_work(priv->fpe_wq, &priv->fpe_task);
+	}
+}
+
 /**
  *  stmmac_interrupt - main ISR
  *  @irq: interrupt number.
@@ -4241,6 +4342,12 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	if (stmmac_safety_feat_interrupt(priv))
 		return IRQ_HANDLED;
 
+	if (priv->dma_cap.fpesel) {
+		int status = stmmac_fpe_irq_status(priv, priv->ioaddr, priv->dev);
+
+		stmmac_fpe_event_status(priv, status);
+	}
+
 	/* To handle GMAC own interrupts */
 	if ((priv->plat->has_gmac) || xmac) {
 		int status = stmmac_host_irq_status(priv, priv->hw, &priv->xstats);
@@ -4977,6 +5084,65 @@ int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size)
 	return ret;
 }
 
+#define SEND_VERIFY_MPAKCET_FMT "Send Verify mPacket lo_state=%d lp_state=%d\n"
+static void stmmac_fpe_lp_task(struct work_struct *work)
+{
+	struct stmmac_priv *priv = container_of(work, struct stmmac_priv,
+						fpe_task);
+	struct stmmac_fpe_cfg *fpe_cfg = &priv->plat->fpe_cfg;
+	enum stmmac_fpe_state *lo_state = &fpe_cfg->lo_fpe_state;
+	enum stmmac_fpe_state *lp_state = &fpe_cfg->lp_fpe_state;
+	bool *hs_enable = &fpe_cfg->hs_enable;
+	bool *enable = &fpe_cfg->enable;
+	int retries = 20;
+
+	while (retries-- > 0) {
+		/* Bail out immediately if FPE handshake is OFF */
+		if (*lo_state == FPE_STATE_OFF || !*hs_enable)
+			break;
+
+		if (*lo_state == FPE_STATE_ENTERING_ON &&
+		    *lp_state == FPE_STATE_ENTERING_ON) {
+			stmmac_fpe_configure(priv, priv->ioaddr,
+					     priv->plat->tx_queues_to_use,
+					     priv->plat->rx_queues_to_use,
+					     *enable);
+
+			netdev_info(priv->dev, "configured FPE\n");
+
+			*lo_state = FPE_STATE_ON;
+			*lp_state = FPE_STATE_ON;
+			netdev_info(priv->dev, "!!! BOTH FPE stations ON\n");
+			break;
+		}
+
+		if ((*lo_state == FPE_STATE_CAPABLE ||
+		     *lo_state == FPE_STATE_ENTERING_ON) &&
+		    *lp_state != FPE_STATE_ON) {
+			netdev_info(priv->dev, SEND_VERIFY_MPAKCET_FMT,
+				    *lo_state, *lp_state);
+			stmmac_fpe_send_mpacket(priv, priv->ioaddr,
+						MPACKET_VERIFY);
+		}
+		/* Sleep then retry */
+		msleep(500);
+	}
+
+	clear_bit(__FPE_TASK_SCHED, &priv->fpe_task_state);
+}
+
+void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
+{
+	if (priv->plat->fpe_cfg.hs_enable != enable) {
+		if (enable)
+			stmmac_fpe_send_mpacket(priv, priv->ioaddr, MPACKET_VERIFY);
+		else
+			priv->plat->fpe_cfg.lo_fpe_state = FPE_STATE_OFF;
+
+		priv->plat->fpe_cfg.hs_enable = enable;
+	}
+}
+
 /**
  * stmmac_dvr_probe
  * @device: device pointer
@@ -5034,6 +5200,9 @@ int stmmac_dvr_probe(struct device *device,
 
 	INIT_WORK(&priv->service_task, stmmac_service_task);
 
+	/* Initialize Link Partner FPE workqueue */
+	INIT_WORK(&priv->fpe_task, stmmac_fpe_lp_task);
+
 	/* Override with kernel parameters if supplied XXX CRS XXX
 	 * this needs to have multiple instances
 	 */
@@ -5335,8 +5504,18 @@ int stmmac_suspend(struct device *dev)
 		clk_disable_unprepare(priv->plat->pclk);
 		clk_disable_unprepare(priv->plat->stmmac_clk);
 	}
+
 	mutex_unlock(&priv->lock);
 
+	if (priv->dma_cap.fpesel) {
+		/* Disable FPE */
+		stmmac_fpe_configure(priv, priv->ioaddr,
+				     priv->plat->tx_queues_to_use,
+				     priv->plat->rx_queues_to_use, false);
+
+		stmmac_fpe_handshake(priv, false);
+	}
+
 	priv->speed = SPEED_UNKNOWN;
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 44bb133c3000..ed245dde2cb8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -748,13 +748,10 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	if (fpe && !priv->dma_cap.fpesel)
 		return -EOPNOTSUPP;
 
-	ret = stmmac_fpe_configure(priv, priv->ioaddr,
-				   priv->plat->tx_queues_to_use,
-				   priv->plat->rx_queues_to_use, fpe);
-	if (ret && fpe) {
-		netdev_err(priv->dev, "failed to enable Frame Preemption\n");
-		return ret;
-	}
+	/* Actual FPE register configuration will be done after FPE handshake
+	 * is success.
+	 */
+	priv->plat->fpe_cfg.enable = fpe;
 
 	ret = stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 				   priv->plat->clk_ptp_rate);
@@ -764,12 +761,29 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	}
 
 	netdev_info(priv->dev, "configured EST\n");
+
+	if (fpe) {
+		stmmac_fpe_handshake(priv, true);
+		netdev_info(priv->dev, "start FPE handshake\n");
+	}
+
 	return 0;
 
 disable:
 	priv->plat->est->enable = false;
 	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 			     priv->plat->clk_ptp_rate);
+
+	priv->plat->fpe_cfg.enable = false;
+	stmmac_fpe_configure(priv, priv->ioaddr,
+			     priv->plat->tx_queues_to_use,
+			     priv->plat->rx_queues_to_use,
+			     false);
+	netdev_info(priv->dev, "disabled FPE\n");
+
+	stmmac_fpe_handshake(priv, false);
+	netdev_info(priv->dev, "stop FPE handshake\n");
+
 	return ret;
 }
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a302982de2d7..69a8f860b1a8 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -143,6 +143,32 @@ struct stmmac_txq_cfg {
 	int tbs_en;
 };
 
+/* FPE link state */
+enum stmmac_fpe_state {
+	FPE_STATE_OFF = 0,
+	FPE_STATE_CAPABLE = 1,
+	FPE_STATE_ENTERING_ON = 2,
+	FPE_STATE_ON = 3,
+};
+
+/* FPE link-partner hand-shaking mPacket type */
+enum stmmac_mpacket_type {
+	MPACKET_VERIFY = 0,
+	MPACKET_RESPONSE = 1,
+};
+
+enum stmmac_fpe_task_state_t {
+	__FPE_REMOVING,
+	__FPE_TASK_SCHED,
+};
+
+struct stmmac_fpe_cfg {
+	bool enable;				/* FPE enable */
+	bool hs_enable;				/* FPE handshake enable */
+	enum stmmac_fpe_state lp_fpe_state;	/* Link Partner FPE state */
+	enum stmmac_fpe_state lo_fpe_state;	/* Local station FPE state */
+};
+
 struct plat_stmmacenet_data {
 	int bus_id;
 	int phy_addr;
@@ -154,6 +180,7 @@ struct plat_stmmacenet_data {
 	struct device_node *mdio_node;
 	struct stmmac_dma_cfg *dma_cfg;
 	struct stmmac_est *est;
+	struct stmmac_fpe_cfg fpe_cfg;
 	int clk_csr;
 	int has_gmac;
 	int enh_desc;
-- 
2.17.1


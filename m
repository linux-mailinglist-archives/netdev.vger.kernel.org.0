Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F692CB41D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387447AbgLBEzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:55:11 -0500
Received: from mga04.intel.com ([192.55.52.120]:43354 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgLBEzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 23:55:11 -0500
IronPort-SDR: DTo1w9M8BJbaNbKqgD+FqMufj7OiiwS6hl1rGM2z9StfnOwe4oIZ1W2NcN3StRMDbC8pjwpZYl
 qqP6BaeaVtKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="170387541"
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="170387541"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:50 -0800
IronPort-SDR: rYUp127OH8oYvnRV0YdH6/h1SyukH2t94dtaN7SS2+Ixo1rftRlp2fYhiHga7bHczd9e3Xsbun
 QOwucY+P+STg==
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="549888392"
Received: from shivanif-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.152.222])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:50 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v1 9/9] igc: Separate TSN configurations that can be updated
Date:   Tue,  1 Dec 2020 20:53:25 -0800
Message-Id: <20201202045325.3254757-10-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202045325.3254757-1-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some TSN features can be enabled during runtime, but most of the
features need an adapter reset to be disabled.

To better keep track of this, separate the process into an "_apply"
and a "reset" functions, "_apply" will run with the adapter in
potencially "dirty" state, and if necessary will request an adapter
reset, so "_reset" always run with a "clean" adapter.

The idea is to make the process easier to follow.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c |  21 ++--
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 140 +++++++++++++++-------
 drivers/net/ethernet/intel/igc/igc_tsn.h  |   1 +
 3 files changed, 103 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 763f39082f91..76999fe05926 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -107,7 +107,7 @@ void igc_reset(struct igc_adapter *adapter)
 	igc_ptp_reset(adapter);
 
 	/* Re-enable TSN offloading, where applicable. */
-	igc_tsn_offload_apply(adapter);
+	igc_tsn_reset(adapter);
 
 	igc_get_phy_info(hw);
 }
@@ -4823,6 +4823,11 @@ static int igc_save_frame_preemption(struct igc_adapter *adapter,
 	u32 preempt;
 	int i;
 
+	/* What we want here is just to save the configuration, so
+	 * when frame preemption is enabled via ethtool, which queues
+	 * are marked as preemptible is saved.
+	 */
+
 	preempt = qopt->preemptible_queues;
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
@@ -4850,18 +4855,6 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
 	return igc_tsn_offload_apply(adapter);
 }
 
-static int igc_tsn_enable_frame_preemption(struct igc_adapter *adapter,
-					   struct tc_preempt_qopt_offload *qopt)
-{
-	int err;
-
-	err = igc_save_frame_preemption(adapter, qopt);
-	if (err)
-		return err;
-
-	return igc_tsn_offload_apply(adapter);
-}
-
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			void *type_data)
 {
@@ -4875,7 +4868,7 @@ static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		return igc_tsn_enable_launchtime(adapter, type_data);
 
 	case TC_SETUP_PREEMPT:
-		return igc_tsn_enable_frame_preemption(adapter, type_data);
+		return igc_save_frame_preemption(adapter, type_data);
 
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 76272f62bb69..caf8510ad6be 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -18,8 +18,24 @@ static bool is_any_launchtime(struct igc_adapter *adapter)
 	return false;
 }
 
+static unsigned int igc_tsn_new_flags(struct igc_adapter *adapter)
+{
+	unsigned int new_flags = adapter->flags & ~IGC_FLAG_TSN_ANY_ENABLED;
+
+	if (adapter->base_time)
+		new_flags |= IGC_FLAG_TSN_QBV_ENABLED;
+
+	if (is_any_launchtime(adapter))
+		new_flags |= IGC_FLAG_TSN_QBV_ENABLED;
+
+	if (adapter->frame_preemption_active)
+		new_flags |= IGC_FLAG_TSN_PREEMPT_ENABLED;
+
+	return new_flags;
+}
+
 /* Returns the TSN specific registers to their default values after
- * TSN offloading is disabled.
+ * the adapter is reset.
  */
 static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 {
@@ -27,11 +43,9 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 	u32 tqavctrl, rxpbs;
 	int i;
 
-	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED))
-		return 0;
-
 	adapter->cycle_time = 0;
 	adapter->frame_preemption_active = false;
+	adapter->base_time = 0;
 
 	wr32(IGC_TXPBS, I225_TXPBSIZE_DEFAULT);
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_DEFAULT);
@@ -63,37 +77,24 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 	wr32(IGC_QBVCYCLET_S, NSEC_PER_MSEC);
 	wr32(IGC_QBVCYCLET, NSEC_PER_MSEC);
 
-	adapter->flags &= ~IGC_FLAG_TSN_QBV_ENABLED;
+	adapter->flags &= ~IGC_FLAG_TSN_ANY_ENABLED;
 
 	return 0;
 }
 
-static int igc_tsn_enable_offload(struct igc_adapter *adapter)
+static int igc_tsn_update_params(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
-	u32 tqavctrl, baset_l, baset_h;
-	u32 sec, nsec, cycle, rxpbs;
-	ktime_t base_time, systim;
+	u32 tqavctrl;
+	unsigned int flags;
 	int i;
 
-	if (adapter->flags & IGC_FLAG_TSN_QBV_ENABLED)
+	flags = igc_tsn_new_flags(adapter) & IGC_FLAG_TSN_ANY_ENABLED;
+	if (!flags)
 		return 0;
 
-	cycle = adapter->cycle_time;
-	base_time = adapter->base_time;
-
-	wr32(IGC_TSAUXC, 0);
-	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_TSN);
-	wr32(IGC_TXPBS, IGC_TXPBSIZE_TSN);
-
-	rxpbs = rd32(IGC_RXPBS) & ~IGC_RXPBSIZE_SIZE_MASK;
-	rxpbs |= IGC_RXPBSIZE_TSN;
-
-	wr32(IGC_RXPBS, rxpbs);
-
 	tqavctrl = rd32(IGC_TQAVCTRL) &
 		~(IGC_TQAVCTRL_MIN_FRAG_MASK | IGC_TQAVCTRL_PREEMPT_ENA);
-	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
 
 	if (adapter->frame_preemption_active)
 		tqavctrl |= IGC_TQAVCTRL_PREEMPT_ENA;
@@ -102,9 +103,6 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
-	wr32(IGC_QBVCYCLET_S, cycle);
-	wr32(IGC_QBVCYCLET, cycle);
-
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		struct igc_ring *ring = adapter->tx_ring[i];
 		u32 txqctl = 0;
@@ -125,12 +123,47 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		if (ring->launchtime_enable)
 			txqctl |= IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
 
-		if (ring->preemptible)
+		if (adapter->frame_preemption_active && ring->preemptible)
 			txqctl |= IGC_TXQCTL_PREEMPTABLE;
 
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
+	adapter->flags = igc_tsn_new_flags(adapter);
+
+	return 0;
+}
+
+static int igc_tsn_enable_offload(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 baset_l, baset_h, tqavctrl;
+	u32 sec, nsec, cycle, rxpbs;
+	ktime_t base_time, systim;
+
+	tqavctrl = rd32(IGC_TQAVCTRL);
+	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
+
+	wr32(IGC_TQAVCTRL, tqavctrl);
+
+	wr32(IGC_TSAUXC, 0);
+	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_TSN);
+	wr32(IGC_TXPBS, IGC_TXPBSIZE_TSN);
+
+	rxpbs = rd32(IGC_RXPBS) & ~IGC_RXPBSIZE_SIZE_MASK;
+	rxpbs |= IGC_RXPBSIZE_TSN;
+
+	wr32(IGC_RXPBS, rxpbs);
+
+	if (!adapter->base_time)
+		goto done;
+
+	cycle = adapter->cycle_time;
+	base_time = adapter->base_time;
+
+	wr32(IGC_QBVCYCLET_S, cycle);
+	wr32(IGC_QBVCYCLET, cycle);
+
 	nsec = rd32(IGC_SYSTIML);
 	sec = rd32(IGC_SYSTIMH);
 
@@ -148,34 +181,51 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	wr32(IGC_BASET_H, baset_h);
 	wr32(IGC_BASET_L, baset_l);
 
-	adapter->flags |= IGC_FLAG_TSN_QBV_ENABLED;
+done:
+	igc_tsn_update_params(adapter);
 
 	return 0;
 }
 
+int igc_tsn_reset(struct igc_adapter *adapter)
+{
+	unsigned int new_flags;
+	int err = 0;
+
+	new_flags = igc_tsn_new_flags(adapter);
+
+	if (!(new_flags & IGC_FLAG_TSN_ANY_ENABLED))
+		return igc_tsn_disable_offload(adapter);
+
+	err = igc_tsn_enable_offload(adapter);
+	if (err < 0)
+		return err;
+
+	adapter->flags = new_flags;
+
+	return err;
+}
+
 int igc_tsn_offload_apply(struct igc_adapter *adapter)
 {
-	bool is_any_enabled = adapter->base_time ||
-		is_any_launchtime(adapter) || adapter->frame_preemption_active;
+	unsigned int new_flags, old_flags;
 
-	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED) && !is_any_enabled)
-		return 0;
+	old_flags = adapter->flags;
+	new_flags = igc_tsn_new_flags(adapter);
 
-	if (!is_any_enabled) {
-		int err = igc_tsn_disable_offload(adapter);
+	if (old_flags == new_flags)
+		return igc_tsn_update_params(adapter);
 
-		if (err < 0)
-			return err;
+	/* Enabling features work without resetting the adapter */
+	if (new_flags > old_flags)
+		return igc_tsn_enable_offload(adapter);
 
-		/* The BASET registers aren't cleared when writing
-		 * into them, force a reset if the interface is
-		 * running.
-		 */
-		if (netif_running(adapter->netdev))
-			schedule_work(&adapter->reset_task);
+	adapter->flags = new_flags;
 
-		return 0;
-	}
+	if (!netif_running(adapter->netdev))
+		return igc_tsn_enable_offload(adapter);
 
-	return igc_tsn_enable_offload(adapter);
+	schedule_work(&adapter->reset_task);
+
+	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.h b/drivers/net/ethernet/intel/igc/igc_tsn.h
index f76bc86ddccd..1512307f5a52 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.h
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.h
@@ -5,5 +5,6 @@
 #define _IGC_TSN_H_
 
 int igc_tsn_offload_apply(struct igc_adapter *adapter);
+int igc_tsn_reset(struct igc_adapter *adapter);
 
 #endif /* _IGC_BASE_H */
-- 
2.29.2


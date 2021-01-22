Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDFB301053
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbhAVWv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:51:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:1524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728757AbhAVWrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:47:43 -0500
IronPort-SDR: eTjdKn8Srhy/tBFaiShrJqkvqw5li7AaVbFA8lhMo7WraCIeBiDK2P0owAaWGn4C7Z56XdjEoj
 ysImOSrWb7ow==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="166619684"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="166619684"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:23 -0800
IronPort-SDR: SB5zhQzkLPXxjV5gUiGot9gWUbr938m1I6OUgZpDiUfdfCs0XyqSC6R29PWOkIrqN7gc27GuBJ
 nJ0OhEf2EqcA==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="355390570"
Received: from apalur-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.155.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:22 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v3 6/8] igc: Add support for tuning frame preemption via ethtool
Date:   Fri, 22 Jan 2021 14:44:51 -0800
Message-Id: <20210122224453.4161729-7-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122224453.4161729-1-vinicius.gomes@intel.com>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tc subsystem sets which queues are marked as preemptible, it's the
role of ethtool to control more hardware specific parameters. These
parameters include:

 - enabling the frame preemption hardware: As enabling frame
 preemption may have other requirements before it can be enabled, it's
 exposed via the ethtool API;

 - mininum fragment size multiplier: expressed in usually in the form
 of (1 + N)*64, this number indicates what's the size of the minimum
 fragment that can be preempted.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         | 12 +++++
 drivers/net/ethernet/intel/igc/igc_defines.h |  4 ++
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 53 ++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 25 +++++++--
 4 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 35baae900c1f..1067c46e0bc2 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -87,6 +87,7 @@ struct igc_ring {
 	u8 queue_index;                 /* logical index of the ring*/
 	u8 reg_idx;                     /* physical index of the ring */
 	bool launchtime_enable;         /* true if LaunchTime is enabled */
+	bool preemptible;		/* true if not express */
 
 	u32 start_time;
 	u32 end_time;
@@ -165,6 +166,8 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
+	bool frame_preemption_active;
+	u8 add_frag_size;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
@@ -262,6 +265,10 @@ extern char igc_driver_name[];
 #define IGC_FLAG_VLAN_PROMISC		BIT(15)
 #define IGC_FLAG_RX_LEGACY		BIT(16)
 #define IGC_FLAG_TSN_QBV_ENABLED	BIT(17)
+#define IGC_FLAG_TSN_PREEMPT_ENABLED	BIT(18)
+
+#define IGC_FLAG_TSN_ANY_ENABLED \
+	(IGC_FLAG_TSN_QBV_ENABLED | IGC_FLAG_TSN_PREEMPT_ENABLED)
 
 #define IGC_FLAG_RSS_FIELD_IPV4_UDP	BIT(6)
 #define IGC_FLAG_RSS_FIELD_IPV6_UDP	BIT(7)
@@ -310,6 +317,11 @@ extern char igc_driver_name[];
 #define IGC_I225_RX_LATENCY_1000	300
 #define IGC_I225_RX_LATENCY_2500	1485
 
+/* From the datasheet section 8.12.4 Tx Qav Control TQAVCTRL,
+ * MIN_FRAG initial value.
+ */
+#define IGC_I225_MIN_FRAG_SIZE_DEFAULT	68
+
 /* RX and TX descriptor control thresholds.
  * PTHRESH - MAC will consider prefetch if it has fewer than this number of
  *           descriptors available in its onboard memory.
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 0e78abfd99ee..c2155d109bd6 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -410,10 +410,14 @@
 /* Transmit Scheduling */
 #define IGC_TQAVCTRL_TRANSMIT_MODE_TSN	0x00000001
 #define IGC_TQAVCTRL_ENHANCED_QAV	0x00000008
+#define IGC_TQAVCTRL_PREEMPT_ENA	0x00000002
+#define IGC_TQAVCTRL_MIN_FRAG_MASK	0x0000C000
+#define IGC_TQAVCTRL_MIN_FRAG_SHIFT	14
 
 #define IGC_TXQCTL_QUEUE_MODE_LAUNCHT	0x00000001
 #define IGC_TXQCTL_STRICT_CYCLE		0x00000002
 #define IGC_TXQCTL_STRICT_END		0x00000004
+#define IGC_TXQCTL_PREEMPTABLE		0x00000008
 
 /* Receive Checksum Control */
 #define IGC_RXCSUM_CRCOFL	0x00000800   /* CRC32 offload enable */
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 61d331ce38cd..e71edbbe08b4 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -8,6 +8,7 @@
 
 #include "igc.h"
 #include "igc_diag.h"
+#include "igc_tsn.h"
 
 /* forward declaration */
 struct igc_stats {
@@ -1636,6 +1637,56 @@ static int igc_ethtool_set_eee(struct net_device *netdev,
 	return 0;
 }
 
+static int igc_ethtool_get_preempt(struct net_device *netdev,
+				   struct ethtool_fp *fpcmd)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	fpcmd->enabled = adapter->frame_preemption_active;
+	fpcmd->add_frag_size = adapter->add_frag_size;
+
+	return 0;
+}
+
+static int igc_ethtool_set_preempt(struct net_device *netdev,
+				   struct ethtool_fp *fpcmd,
+				   struct netlink_ext_ack *extack)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	int i;
+
+	if (fpcmd->add_frag_size < 68 || fpcmd->add_frag_size > 260) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid value for add-frag-size");
+		return -EINVAL;
+	}
+
+	adapter->frame_preemption_active = fpcmd->enabled;
+	adapter->add_frag_size = fpcmd->add_frag_size;
+
+	if (!adapter->frame_preemption_active)
+		goto done;
+
+	/* Enabling frame preemption requires TSN mode to be enabled,
+	 * which requires a schedule to be active. So, if there isn't
+	 * a schedule already configured, configure a simple one, with
+	 * all queues open, with 1ms cycle time.
+	 */
+	if (adapter->base_time)
+		goto done;
+
+	adapter->cycle_time = NSEC_PER_MSEC;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+
+		ring->start_time = 0;
+		ring->end_time = NSEC_PER_MSEC;
+	}
+
+done:
+	return igc_tsn_offload_apply(adapter);
+}
+
 static int igc_ethtool_begin(struct net_device *netdev)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
@@ -1915,6 +1966,8 @@ static const struct ethtool_ops igc_ethtool_ops = {
 	.get_ts_info		= igc_ethtool_get_ts_info,
 	.get_channels		= igc_ethtool_get_channels,
 	.set_channels		= igc_ethtool_set_channels,
+	.get_preempt		= igc_ethtool_get_preempt,
+	.set_preempt		= igc_ethtool_set_preempt,
 	.get_priv_flags		= igc_ethtool_get_priv_flags,
 	.set_priv_flags		= igc_ethtool_set_priv_flags,
 	.get_eee		= igc_ethtool_get_eee,
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index f5a5527adb21..31aa9eed3ae3 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -30,7 +30,10 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED))
 		return 0;
 
+	adapter->base_time = 0;
 	adapter->cycle_time = 0;
+	adapter->frame_preemption_active = false;
+	adapter->add_frag_size = IGC_I225_MIN_FRAG_SIZE_DEFAULT;
 
 	wr32(IGC_TXPBS, I225_TXPBSIZE_DEFAULT);
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_DEFAULT);
@@ -42,7 +45,8 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 
 	tqavctrl = rd32(IGC_TQAVCTRL);
 	tqavctrl &= ~(IGC_TQAVCTRL_TRANSMIT_MODE_TSN |
-		      IGC_TQAVCTRL_ENHANCED_QAV);
+		      IGC_TQAVCTRL_ENHANCED_QAV | IGC_TQAVCTRL_PREEMPT_ENA |
+		      IGC_TQAVCTRL_MIN_FRAG_MASK);
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
@@ -51,6 +55,7 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 		ring->start_time = 0;
 		ring->end_time = 0;
 		ring->launchtime_enable = false;
+		ring->preemptible = false;
 
 		wr32(IGC_TXQCTL(i), 0);
 		wr32(IGC_STQT(i), 0);
@@ -71,6 +76,7 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	u32 tqavctrl, baset_l, baset_h;
 	u32 sec, nsec, cycle, rxpbs;
 	ktime_t base_time, systim;
+	u8 frag_size_mult;
 	int i;
 
 	if (adapter->flags & IGC_FLAG_TSN_QBV_ENABLED)
@@ -83,13 +89,22 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_TSN);
 	wr32(IGC_TXPBS, IGC_TXPBSIZE_TSN);
 
-	tqavctrl = rd32(IGC_TQAVCTRL);
 	rxpbs = rd32(IGC_RXPBS) & ~IGC_RXPBSIZE_SIZE_MASK;
 	rxpbs |= IGC_RXPBSIZE_TSN;
 
 	wr32(IGC_RXPBS, rxpbs);
 
+	tqavctrl = rd32(IGC_TQAVCTRL) &
+		~(IGC_TQAVCTRL_MIN_FRAG_MASK | IGC_TQAVCTRL_PREEMPT_ENA);
 	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
+
+	if (adapter->frame_preemption_active)
+		tqavctrl |= IGC_TQAVCTRL_PREEMPT_ENA;
+
+	frag_size_mult = ethtool_frag_size_to_mult(adapter->add_frag_size);
+
+	tqavctrl |= frag_size_mult << IGC_TQAVCTRL_MIN_FRAG_SHIFT;
+
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	wr32(IGC_QBVCYCLET_S, cycle);
@@ -115,6 +130,9 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		if (ring->launchtime_enable)
 			txqctl |= IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
 
+		if (ring->preemptible)
+			txqctl |= IGC_TXQCTL_PREEMPTABLE;
+
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
@@ -142,7 +160,8 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 
 int igc_tsn_offload_apply(struct igc_adapter *adapter)
 {
-	bool is_any_enabled = adapter->base_time || is_any_launchtime(adapter);
+	bool is_any_enabled = adapter->base_time ||
+		is_any_launchtime(adapter) || adapter->frame_preemption_active;
 
 	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED) && !is_any_enabled)
 		return 0;
-- 
2.30.0


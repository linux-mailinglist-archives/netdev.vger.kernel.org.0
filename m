Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCD62CB417
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgLBEyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:54:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:43298 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgLBEya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 23:54:30 -0500
IronPort-SDR: iOXzMat1CnazP5g7rbO0UDVqSwRdSsb3aEH/QrYRIzHpRSUxMWtqZUFKqd3UVbmf4GQ9K5UIeH
 +D0yFI0o19RQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="170387537"
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="170387537"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:49 -0800
IronPort-SDR: cqUaIDTnTCQtZ4uNYdkNoxo2VUGgfASFXCpkHXzzRyESEfUYv3LL01ThJeoApkTGNTvnNWx5dQ
 BVdtNvt2xe/g==
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="549888381"
Received: from shivanif-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.152.222])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:49 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v1 6/9] igc: Add support for tuning frame preemption via ethtool
Date:   Tue,  1 Dec 2020 20:53:22 -0800
Message-Id: <20201202045325.3254757-7-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202045325.3254757-1-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
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
 drivers/net/ethernet/intel/igc/igc.h         | 10 ++++
 drivers/net/ethernet/intel/igc/igc_defines.h |  4 ++
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 55 ++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 20 +++++--
 4 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 35baae900c1f..35c2dc4ad810 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -87,6 +87,7 @@ struct igc_ring {
 	u8 queue_index;                 /* logical index of the ring*/
 	u8 reg_idx;                     /* physical index of the ring */
 	bool launchtime_enable;         /* true if LaunchTime is enabled */
+	bool preemptible;		/* true if not express */
 
 	u32 start_time;
 	u32 end_time;
@@ -165,6 +166,11 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
+	bool frame_preemption_active;
+	/* Frame preemption minimum fragment size, this the X in
+	 * (1 + X)*64 + 4
+	 */
+	u8 min_frag_size_mult;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
@@ -262,6 +268,10 @@ extern char igc_driver_name[];
 #define IGC_FLAG_VLAN_PROMISC		BIT(15)
 #define IGC_FLAG_RX_LEGACY		BIT(16)
 #define IGC_FLAG_TSN_QBV_ENABLED	BIT(17)
+#define IGC_FLAG_TSN_PREEMPT_ENABLED	BIT(18)
+
+#define IGC_FLAG_TSN_ANY_ENABLED \
+	(IGC_FLAG_TSN_QBV_ENABLED | IGC_FLAG_TSN_PREEMPT_ENABLED)
 
 #define IGC_FLAG_RSS_FIELD_IPV4_UDP	BIT(6)
 #define IGC_FLAG_RSS_FIELD_IPV6_UDP	BIT(7)
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
index 61d331ce38cd..492c6592c150 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -8,6 +8,7 @@
 
 #include "igc.h"
 #include "igc_diag.h"
+#include "igc_tsn.h"
 
 /* forward declaration */
 struct igc_stats {
@@ -1636,6 +1637,58 @@ static int igc_ethtool_set_eee(struct net_device *netdev,
 	return 0;
 }
 
+static int igc_ethtool_get_preempt(struct net_device *netdev,
+				   struct ethtool_fp *fpcmd)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	fpcmd->enabled = adapter->frame_preemption_active;
+	fpcmd->min_frag_size_mult = adapter->min_frag_size_mult;
+
+	return 0;
+}
+
+static int igc_ethtool_set_preempt(struct net_device *netdev,
+				   struct ethtool_fp *fpcmd)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	int i;
+
+	/* The formula is (Section 8.12.4 of the datasheet):
+	 *   MIN_FRAG_SIZE = 4 + (1 + MIN_FRAG)*64
+	 * MIN_FRAG is represented by two bits, so we can only have
+	 * min_frag_size between 68 and 260.
+	 */
+	if (fpcmd->min_frag_size_mult > 3)
+		return -EINVAL;
+
+	adapter->frame_preemption_active = fpcmd->enabled;
+	adapter->min_frag_size_mult = fpcmd->min_frag_size_mult;
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
@@ -1915,6 +1968,8 @@ static const struct ethtool_ops igc_ethtool_ops = {
 	.get_ts_info		= igc_ethtool_get_ts_info,
 	.get_channels		= igc_ethtool_get_channels,
 	.set_channels		= igc_ethtool_set_channels,
+	.get_preempt		= igc_ethtool_get_preempt,
+	.set_preempt		= igc_ethtool_set_preempt,
 	.get_priv_flags		= igc_ethtool_get_priv_flags,
 	.set_priv_flags		= igc_ethtool_set_priv_flags,
 	.get_eee		= igc_ethtool_get_eee,
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index f5a5527adb21..76272f62bb69 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -31,6 +31,7 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 		return 0;
 
 	adapter->cycle_time = 0;
+	adapter->frame_preemption_active = false;
 
 	wr32(IGC_TXPBS, I225_TXPBSIZE_DEFAULT);
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_DEFAULT);
@@ -42,7 +43,8 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 
 	tqavctrl = rd32(IGC_TQAVCTRL);
 	tqavctrl &= ~(IGC_TQAVCTRL_TRANSMIT_MODE_TSN |
-		      IGC_TQAVCTRL_ENHANCED_QAV);
+		      IGC_TQAVCTRL_ENHANCED_QAV | IGC_TQAVCTRL_PREEMPT_ENA |
+		      IGC_TQAVCTRL_MIN_FRAG_MASK);
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
@@ -51,6 +53,7 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 		ring->start_time = 0;
 		ring->end_time = 0;
 		ring->launchtime_enable = false;
+		ring->preemptible = false;
 
 		wr32(IGC_TXQCTL(i), 0);
 		wr32(IGC_STQT(i), 0);
@@ -83,13 +86,20 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
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
+	tqavctrl |= adapter->min_frag_size_mult << IGC_TQAVCTRL_MIN_FRAG_SHIFT;
+
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	wr32(IGC_QBVCYCLET_S, cycle);
@@ -115,6 +125,9 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		if (ring->launchtime_enable)
 			txqctl |= IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
 
+		if (ring->preemptible)
+			txqctl |= IGC_TXQCTL_PREEMPTABLE;
+
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
@@ -142,7 +155,8 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 
 int igc_tsn_offload_apply(struct igc_adapter *adapter)
 {
-	bool is_any_enabled = adapter->base_time || is_any_launchtime(adapter);
+	bool is_any_enabled = adapter->base_time ||
+		is_any_launchtime(adapter) || adapter->frame_preemption_active;
 
 	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED) && !is_any_enabled)
 		return 0;
-- 
2.29.2


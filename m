Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192261D5DA1
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 03:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgEPBaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 21:30:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:60902 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgEPBaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 21:30:03 -0400
IronPort-SDR: luYyEnzAq2NsBflOaYZCRr9Nskun4lo6Sa6B6dLxXcWmn5D9isimbkNuYNFEi6wU+ihQyf3diU
 uutnFzTf3RKQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 18:30:02 -0700
IronPort-SDR: Dr1MVGAADYj10JA/nSbB+WQzcOH/8riix7vvHPIusm2lehVYcar6t22/z+UvVGkcoVAUkIf/Y0
 TxmfxB0+eeXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,397,1583222400"; 
   d="scan'208";a="307569171"
Received: from wkbertra-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.131.129])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2020 18:30:02 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: [next-queue RFC 3/4] igc: Add support for configuring frame preemption
Date:   Fri, 15 May 2020 18:29:47 -0700
Message-Id: <20200516012948.3173993-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516012948.3173993-1-vinicius.gomes@intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WIP

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  3 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  6 ++
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 68 ++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 46 +++++++++++--
 4 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 5dbc5a1..963ac98 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -87,6 +87,7 @@ struct igc_ring {
 	u8 queue_index;                 /* logical index of the ring*/
 	u8 reg_idx;                     /* physical index of the ring */
 	bool launchtime_enable;         /* true if LaunchTime is enabled */
+	bool preemptible;		/* true if not express */
 
 	u32 start_time;
 	u32 end_time;
@@ -162,6 +163,8 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
+	bool frame_preemption_active;
+	u32 min_frag_size; /* Frame preemption minimum fragment size */
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 80b664e..fa823c3 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -364,6 +364,8 @@
 #define IGC_RXPBS_CFG_TS_EN	0x80000000 /* Timestamp in Rx buffer */
 
 #define IGC_TXPBSIZE_TSN	0x04145145 /* 5k bytes buffer for each queue */
+#define IGC_RXPBSIZE_TSN	0x00010090 /* 16KB for EXP + 16KB for BE + 2KB for BMC */
+#define IGC_RXPBSIZE_SIZE_MASK	0x0001FFFF
 
 #define IGC_DTXMXPKTSZ_TSN	0x19 /* 1600 bytes of max TX DMA packet size */
 #define IGC_DTXMXPKTSZ_DEFAULT	0x98 /* 9728-byte Jumbo frames */
@@ -422,10 +424,14 @@
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
index 2214a5d..48d5d18 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -7,6 +7,7 @@
 
 #include "igc.h"
 #include "igc_diag.h"
+#include "igc_tsn.h"
 
 /* forward declaration */
 struct igc_stats {
@@ -1549,6 +1550,71 @@ static int igc_ethtool_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 	return 0;
 }
 
+static int igc_ethtool_get_preempt(struct net_device *netdev,
+				   struct ethtool_fp *fpcmd)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	int i;
+
+	fpcmd->fp_supported = 1;
+	fpcmd->fp_enabled = adapter->frame_preemption_active;
+	fpcmd->min_frag_size = adapter->min_frag_size;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+
+		fpcmd->supported_queues_mask |= BIT(i);
+
+		if (ring->preemptible)
+			fpcmd->preemptible_queues_mask |= BIT(i);
+	}
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
+	if (fpcmd->min_frag_size < 68 || fpcmd->min_frag_size > 260)
+		return -EINVAL;
+
+	fpcmd->fp_supported = 1;
+
+	adapter->frame_preemption_active = fpcmd->fp_enabled;
+	adapter->min_frag_size = fpcmd->min_frag_size;
+
+	/* We need to setup a dummy Qbv cycle for frame preemption to
+	 * work, but we only need to set it up if none is set. This
+	 * same check below exists for the same purpose.
+	 */
+	if (!adapter->base_time)
+		adapter->cycle_time = NSEC_PER_SEC;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+		bool preemptible = fpcmd->preemptible_queues_mask & BIT(i);
+
+		fpcmd->fp_supported |= BIT(i);
+		ring->preemptible = preemptible;
+
+		if (adapter->base_time)
+			continue;
+
+		ring->start_time = 0;
+		ring->end_time = NSEC_PER_SEC;
+	}
+
+	return igc_tsn_offload_apply(adapter);
+}
+
 static int igc_ethtool_begin(struct net_device *netdev)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
@@ -1828,6 +1894,8 @@ static const struct ethtool_ops igc_ethtool_ops = {
 	.get_ts_info		= igc_ethtool_get_ts_info,
 	.get_channels		= igc_ethtool_get_channels,
 	.set_channels		= igc_ethtool_set_channels,
+	.get_preempt		= igc_ethtool_get_preempt,
+	.set_preempt		= igc_ethtool_set_preempt,
 	.get_priv_flags		= igc_ethtool_get_priv_flags,
 	.set_priv_flags		= igc_ethtool_set_priv_flags,
 	.begin			= igc_ethtool_begin,
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 174103c..1bebe1c 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -18,26 +18,45 @@ static bool is_any_launchtime(struct igc_adapter *adapter)
 	return false;
 }
 
+static u32 igc_min_frag_size_to_tqavctrl(u32 min_frag)
+{
+	u32 tqavctrl;
+
+	tqavctrl = DIV_ROUND_UP((min_frag - 4), 64);
+	tqavctrl -= 1;
+
+	tqavctrl <<= IGC_TQAVCTRL_MIN_FRAG_SHIFT;
+
+	return tqavctrl;
+}
+
 /* Returns the TSN specific registers to their default values after
  * TSN offloading is disabled.
  */
 static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
-	u32 tqavctrl;
+	u32 tqavctrl, rxpbs;
 	int i;
 
 	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED))
 		return 0;
 
 	adapter->cycle_time = 0;
+	adapter->frame_preemption_active = false;
+	adapter->min_frag_size = 68;
 
 	wr32(IGC_TXPBS, I225_TXPBSIZE_DEFAULT);
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_DEFAULT);
 
+	rxpbs = rd32(IGC_RXPBS) & ~IGC_RXPBSIZE_SIZE_MASK;
+	rxpbs |= I225_RXPBSIZE_DEFAULT;
+
+	wr32(IGC_RXPBS, rxpbs);
+
 	tqavctrl = rd32(IGC_TQAVCTRL);
 	tqavctrl &= ~(IGC_TQAVCTRL_TRANSMIT_MODE_TSN |
-		      IGC_TQAVCTRL_ENHANCED_QAV);
+		      IGC_TQAVCTRL_ENHANCED_QAV | IGC_TQAVCTRL_PREEMPT_ENA);
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
@@ -46,6 +65,7 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 		ring->start_time = 0;
 		ring->end_time = 0;
 		ring->launchtime_enable = false;
+		ring->preemptible = false;
 
 		wr32(IGC_TXQCTL(i), 0);
 		wr32(IGC_STQT(i), 0);
@@ -64,7 +84,7 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
 	u32 tqavctrl, baset_l, baset_h;
-	u32 sec, nsec, cycle;
+	u32 sec, nsec, cycle, rxpbs;
 	ktime_t base_time, systim;
 	int i;
 
@@ -78,8 +98,20 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_TSN);
 	wr32(IGC_TXPBS, IGC_TXPBSIZE_TSN);
 
-	tqavctrl = rd32(IGC_TQAVCTRL);
+	rxpbs = rd32(IGC_RXPBS) & ~IGC_RXPBSIZE_SIZE_MASK;
+	rxpbs |= IGC_RXPBSIZE_TSN;
+
+	wr32(IGC_RXPBS, rxpbs);
+
+	tqavctrl = rd32(IGC_TQAVCTRL) &
+		~(IGC_TQAVCTRL_MIN_FRAG_MASK | IGC_TQAVCTRL_PREEMPT_ENA);
 	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
+
+	if (adapter->frame_preemption_active)
+		tqavctrl |= IGC_TQAVCTRL_PREEMPT_ENA;
+
+	tqavctrl |= igc_min_frag_size_to_tqavctrl(adapter->min_frag_size);
+
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	wr32(IGC_QBVCYCLET_S, cycle);
@@ -105,6 +137,9 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		if (ring->launchtime_enable)
 			txqctl |= IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
 
+		if (ring->preemptible)
+			txqctl |= IGC_TXQCTL_PREEMPTABLE;
+
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
@@ -132,7 +167,8 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 
 int igc_tsn_offload_apply(struct igc_adapter *adapter)
 {
-	bool is_any_enabled = adapter->base_time || is_any_launchtime(adapter);
+	bool is_any_enabled = adapter->base_time ||
+		is_any_launchtime(adapter) || adapter->frame_preemption_active;
 
 	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED) && !is_any_enabled)
 		return 0;
-- 
2.26.2


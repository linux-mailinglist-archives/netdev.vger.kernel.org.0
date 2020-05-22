Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFF31DE061
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgEVG4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:18662 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgEVG4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:11 -0400
IronPort-SDR: tllnGIPyBhQHkgwQEIpbrIT+fjayf3fZOzyaqPL33PITMqyVtWofqHyJbA0g2nmysLDtE/RY83
 UvqbcjkftYjw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:09 -0700
IronPort-SDR: DiB6BnbBMpybXi8LoABPermObGyKxW9gMb1K4kW/9yuMHr+eR5/Mb7WBN5U1CuQi2k77qyBxjz
 ll30rNh2EKAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017745"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Avinash JD <avinash.dayanand@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/17] ice: Don't reset and rebuild for Tx timeout on PFC enabled queue
Date:   Thu, 21 May 2020 23:55:54 -0700
Message-Id: <20200522065607.1680050-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avinash JD <avinash.dayanand@intel.com>

When there's a Tx timeout for a queue which belongs to a PFC enabled TC,
then it's not because the queue is hung but because PFC is in action.

In PFC, peer sends a pause frame for a specified period of time when its
buffer threshold is exceeded (due to congestion). Netdev on the other
hand checks if ACK is received within a specified time for a TX packet, if
not, it'll invoke the tx_timeout routine.

Signed-off-by: Avinash JD <avinash.dayanand@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 58 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  | 23 ++++++++
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 10 ++++
 drivers/net/ethernet/intel/ice/ice_type.h     |  2 +
 5 files changed, 94 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 7bea09363b42..448b7d2fb808 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -62,6 +62,64 @@ u8 ice_dcb_get_ena_tc(struct ice_dcbx_cfg *dcbcfg)
 	return ena_tc;
 }
 
+/**
+ * ice_is_pfc_causing_hung_q
+ * @pf: pointer to PF structure
+ * @txqueue: Tx queue which is supposedly hung queue
+ *
+ * find if PFC is causing the hung queue, if yes return true else false
+ */
+bool ice_is_pfc_causing_hung_q(struct ice_pf *pf, unsigned int txqueue)
+{
+	u8 num_tcs = 0, i, tc, up_mapped_tc, up_in_tc = 0;
+	u64 ref_prio_xoff[ICE_MAX_UP];
+	struct ice_vsi *vsi;
+	u32 up2tc;
+
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi)
+		return false;
+
+	ice_for_each_traffic_class(i)
+		if (vsi->tc_cfg.ena_tc & BIT(i))
+			num_tcs++;
+
+	/* first find out the TC to which the hung queue belongs to */
+	for (tc = 0; tc < num_tcs - 1; tc++)
+		if (ice_find_q_in_range(vsi->tc_cfg.tc_info[tc].qoffset,
+					vsi->tc_cfg.tc_info[tc + 1].qoffset,
+					txqueue))
+			break;
+
+	/* Build a bit map of all UPs associated to the suspect hung queue TC,
+	 * so that we check for its counter increment.
+	 */
+	up2tc = rd32(&pf->hw, PRTDCB_TUP2TC);
+	for (i = 0; i < ICE_MAX_UP; i++) {
+		up_mapped_tc = (up2tc >> (i * 3)) & 0x7;
+		if (up_mapped_tc == tc)
+			up_in_tc |= BIT(i);
+	}
+
+	/* Now that we figured out that hung queue is PFC enabled, still the
+	 * Tx timeout can be legitimate. So to make sure Tx timeout is
+	 * absolutely caused by PFC storm, check if the counters are
+	 * incrementing.
+	 */
+	for (i = 0; i < ICE_MAX_UP; i++)
+		if (up_in_tc & BIT(i))
+			ref_prio_xoff[i] = pf->stats.priority_xoff_rx[i];
+
+	ice_update_dcb_stats(pf);
+
+	for (i = 0; i < ICE_MAX_UP; i++)
+		if (up_in_tc & BIT(i))
+			if (pf->stats.priority_xoff_rx[i] > ref_prio_xoff[i])
+				return true;
+
+	return false;
+}
+
 /**
  * ice_dcb_get_mode - gets the DCB mode
  * @port_info: pointer to port info structure
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 37680e815b02..7c42324494d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -17,6 +17,8 @@
 void ice_dcb_rebuild(struct ice_pf *pf);
 u8 ice_dcb_get_ena_tc(struct ice_dcbx_cfg *dcbcfg);
 u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg *dcbcfg);
+void ice_vsi_set_dcb_tc_cfg(struct ice_vsi *vsi);
+bool ice_is_pfc_causing_hung_q(struct ice_pf *pf, unsigned int txqueue);
 u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index);
 int
 ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked);
@@ -32,6 +34,20 @@ void
 ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 				    struct ice_rq_event_info *event);
 void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc);
+
+/**
+ * ice_find_q_in_range
+ * @low: start of queue range for a TC i.e. offset of TC
+ * @high: start of queue for next TC
+ * @tx_q: hung_queue/tx_queue
+ *
+ * finds if queue 'tx_q' falls between the two offsets of any given TC
+ */
+static inline bool ice_find_q_in_range(u16 low, u16 high, unsigned int tx_q)
+{
+	return (tx_q >= low) && (tx_q < high);
+}
+
 static inline void
 ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, struct ice_ring *ring)
 {
@@ -79,6 +95,13 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
 	return 0;
 }
 
+static inline bool
+ice_is_pfc_causing_hung_q(struct ice_pf __always_unused *pf,
+			  unsigned int __always_unused txqueue)
+{
+	return false;
+}
+
 #define ice_update_dcb_stats(pf) do {} while (0)
 #define ice_pf_dcb_recfg(pf) do {} while (0)
 #define ice_vsi_cfg_dcb_rings(vsi) do {} while (0)
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 1d37a9f02c1c..bc48eda67c81 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -58,6 +58,7 @@
 #define PRTDCB_GENS				0x00083020
 #define PRTDCB_GENS_DCBX_STATUS_S		0
 #define PRTDCB_GENS_DCBX_STATUS_M		ICE_M(0x7, 0)
+#define PRTDCB_TUP2TC				0x001D26C0 /* Reset Source: CORER */
 #define GL_PREEXT_L2_PMASK0(_i)			(0x0020F0FC + ((_i) * 4))
 #define GL_PREEXT_L2_PMASK1(_i)			(0x0020F108 + ((_i) * 4))
 #define GLFLXP_RXDID_FLX_WRD_0(_i)		(0x0045c800 + ((_i) * 4))
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 44ff4fe45a56..8c792ecc6550 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5114,6 +5114,16 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 
 	pf->tx_timeout_count++;
 
+	/* Check if PFC is enabled for the TC to which the queue belongs
+	 * to. If yes then Tx timeout is not caused by a hung queue, no
+	 * need to reset and rebuild
+	 */
+	if (ice_is_pfc_causing_hung_q(pf, txqueue)) {
+		dev_info(ice_pf_to_dev(pf), "Fake Tx hang detected on queue %u, timeout caused by PFC storm\n",
+			 txqueue);
+		return;
+	}
+
 	/* now that we have an index, find the tx_ring struct */
 	for (i = 0; i < vsi->num_txq; i++)
 		if (vsi->tx_rings[i] && vsi->tx_rings[i]->desc)
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index c56b2e77a48c..4f5345a7c15d 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -607,6 +607,8 @@ struct ice_eth_stats {
 	u64 tx_errors;			/* tepc */
 };
 
+#define ICE_MAX_UP	8
+
 /* Statistics collected by the MAC */
 struct ice_hw_port_stats {
 	/* eth stats collected by the port */
-- 
2.26.2


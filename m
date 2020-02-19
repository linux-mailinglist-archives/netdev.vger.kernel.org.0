Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD1216521D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBSWHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:07:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:51315 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgBSWG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:06:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824803"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/13] ice: update malicious driver detection event handling
Date:   Wed, 19 Feb 2020 14:06:41 -0800
Message-Id: <20200219220652.2255171-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Update the PF VFs MDD event message to rate limit once per second and
report the total number Rx|Tx event count. Add support to print pending
MDD events that occur during the rate limit. The use of net_ratelimit did
not allow for per VF Rx|Tx granularity.

Additional PF MDD log messages are guarded by netif_msg_[rx|tx]_err().

Since VF RX MDD events disable the queue, add ethtool private flag
mdd-auto-reset-vf to configure VF reset to re-enable the queue.

Disable anti-spoof detection interrupt to prevent spurious events
during a function reset.

To avoid race condition do not make PF MDD register reads conditional
on global MDD result.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   4 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   1 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 126 ++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  56 +++++++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  20 ++-
 6 files changed, 150 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index cb10abb14e11..2d51ceaa2c8c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -212,6 +212,7 @@ enum ice_state {
 	__ICE_SERVICE_SCHED,
 	__ICE_SERVICE_DIS,
 	__ICE_OICR_INTR_DIS,		/* Global OICR interrupt disabled */
+	__ICE_MDD_VF_PRINT_PENDING,	/* set when MDD event handle */
 	__ICE_STATE_NBITS		/* must be last */
 };
 
@@ -340,6 +341,7 @@ enum ice_pf_flags {
 	ICE_FLAG_FW_LLDP_AGENT,
 	ICE_FLAG_ETHTOOL_CTXT,		/* set when ethtool holds RTNL lock */
 	ICE_FLAG_LEGACY_RX,
+	ICE_FLAG_MDD_AUTO_RESET_VF,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
@@ -363,6 +365,8 @@ struct ice_pf {
 	u16 num_vfs_supported;		/* num VFs supported for this PF */
 	u16 num_vf_qps;			/* num queue pairs per VF */
 	u16 num_vf_msix;		/* num vectors per VF */
+	/* used to ratelimit the MDD event logging */
+	unsigned long last_printed_mdd_jiffies;
 	DECLARE_BITMAP(state, __ICE_STATE_NBITS);
 	DECLARE_BITMAP(flags, ICE_PF_FLAGS_NBITS);
 	unsigned long *avail_txqs;	/* bitmap to track PF Tx queue usage */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 583e07fffd5f..63a69ea02d22 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -157,6 +157,7 @@ struct ice_priv_flag {
 static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
 	ICE_PRIV_FLAG("link-down-on-close", ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA),
 	ICE_PRIV_FLAG("fw-lldp-agent", ICE_FLAG_FW_LLDP_AGENT),
+	ICE_PRIV_FLAG("mdd-auto-reset-vf", ICE_FLAG_MDD_AUTO_RESET_VF),
 	ICE_PRIV_FLAG("legacy-rx", ICE_FLAG_LEGACY_RX),
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index b99ebfefe06b..43e4efbccd8e 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -217,6 +217,8 @@
 #define VPLAN_TX_QBASE_VFNUMQ_M			ICE_M(0xFF, 16)
 #define VPLAN_TXQ_MAPENA(_VF)			(0x00073800 + ((_VF) * 4))
 #define VPLAN_TXQ_MAPENA_TX_ENA_M		BIT(0)
+#define GL_MDCK_TX_TDPU				0x00049348
+#define GL_MDCK_TX_TDPU_RCU_ANTISPOOF_ITR_DIS_M BIT(1)
 #define GL_MDET_RX				0x00294C00
 #define GL_MDET_RX_QNUM_S			0
 #define GL_MDET_RX_QNUM_M			ICE_M(0x7FFF, 0)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 255317e4b1f3..f11e0934dc03 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1187,20 +1187,28 @@ static void ice_service_timer(struct timer_list *t)
  * ice_handle_mdd_event - handle malicious driver detect event
  * @pf: pointer to the PF structure
  *
- * Called from service task. OICR interrupt handler indicates MDD event
+ * Called from service task. OICR interrupt handler indicates MDD event.
+ * VF MDD logging is guarded by net_ratelimit. Additional PF and VF log
+ * messages are wrapped by netif_msg_[rx|tx]_err. Since VF Rx MDD events
+ * disable the queue, the PF can be configured to reset the VF using ethtool
+ * private flag mdd-auto-reset-vf.
  */
 static void ice_handle_mdd_event(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
-	bool mdd_detected = false;
 	u32 reg;
 	int i;
 
-	if (!test_and_clear_bit(__ICE_MDD_EVENT_PENDING, pf->state))
+	if (!test_and_clear_bit(__ICE_MDD_EVENT_PENDING, pf->state)) {
+		/* Since the VF MDD event logging is rate limited, check if
+		 * there are pending MDD events.
+		 */
+		ice_print_vfs_mdd_events(pf);
 		return;
+	}
 
-	/* find what triggered the MDD event */
+	/* find what triggered an MDD event */
 	reg = rd32(hw, GL_MDET_TX_PQM);
 	if (reg & GL_MDET_TX_PQM_VALID_M) {
 		u8 pf_num = (reg & GL_MDET_TX_PQM_PF_NUM_M) >>
@@ -1216,7 +1224,6 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 			dev_info(dev, "Malicious Driver Detection event %d on TX queue %d PF# %d VF# %d\n",
 				 event, queue, pf_num, vf_num);
 		wr32(hw, GL_MDET_TX_PQM, 0xffffffff);
-		mdd_detected = true;
 	}
 
 	reg = rd32(hw, GL_MDET_TX_TCLAN);
@@ -1234,7 +1241,6 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 			dev_info(dev, "Malicious Driver Detection event %d on TX queue %d PF# %d VF# %d\n",
 				 event, queue, pf_num, vf_num);
 		wr32(hw, GL_MDET_TX_TCLAN, 0xffffffff);
-		mdd_detected = true;
 	}
 
 	reg = rd32(hw, GL_MDET_RX);
@@ -1252,85 +1258,85 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 			dev_info(dev, "Malicious Driver Detection event %d on RX queue %d PF# %d VF# %d\n",
 				 event, queue, pf_num, vf_num);
 		wr32(hw, GL_MDET_RX, 0xffffffff);
-		mdd_detected = true;
 	}
 
-	if (mdd_detected) {
-		bool pf_mdd_detected = false;
-
-		reg = rd32(hw, PF_MDET_TX_PQM);
-		if (reg & PF_MDET_TX_PQM_VALID_M) {
-			wr32(hw, PF_MDET_TX_PQM, 0xFFFF);
-			dev_info(dev, "TX driver issue detected, PF reset issued\n");
-			pf_mdd_detected = true;
-		}
+	/* check to see if this PF caused an MDD event */
+	reg = rd32(hw, PF_MDET_TX_PQM);
+	if (reg & PF_MDET_TX_PQM_VALID_M) {
+		wr32(hw, PF_MDET_TX_PQM, 0xFFFF);
+		if (netif_msg_tx_err(pf))
+			dev_info(dev, "Malicious Driver Detection event TX_PQM detected on PF\n");
+	}
 
-		reg = rd32(hw, PF_MDET_TX_TCLAN);
-		if (reg & PF_MDET_TX_TCLAN_VALID_M) {
-			wr32(hw, PF_MDET_TX_TCLAN, 0xFFFF);
-			dev_info(dev, "TX driver issue detected, PF reset issued\n");
-			pf_mdd_detected = true;
-		}
+	reg = rd32(hw, PF_MDET_TX_TCLAN);
+	if (reg & PF_MDET_TX_TCLAN_VALID_M) {
+		wr32(hw, PF_MDET_TX_TCLAN, 0xFFFF);
+		if (netif_msg_tx_err(pf))
+			dev_info(dev, "Malicious Driver Detection event TX_TCLAN detected on PF\n");
+	}
 
-		reg = rd32(hw, PF_MDET_RX);
-		if (reg & PF_MDET_RX_VALID_M) {
-			wr32(hw, PF_MDET_RX, 0xFFFF);
-			dev_info(dev, "RX driver issue detected, PF reset issued\n");
-			pf_mdd_detected = true;
-		}
-		/* Queue belongs to the PF initiate a reset */
-		if (pf_mdd_detected) {
-			set_bit(__ICE_NEEDS_RESTART, pf->state);
-			ice_service_task_schedule(pf);
-		}
+	reg = rd32(hw, PF_MDET_RX);
+	if (reg & PF_MDET_RX_VALID_M) {
+		wr32(hw, PF_MDET_RX, 0xFFFF);
+		if (netif_msg_rx_err(pf))
+			dev_info(dev, "Malicious Driver Detection event RX detected on PF\n");
 	}
 
-	/* check to see if one of the VFs caused the MDD */
+	/* Check to see if one of the VFs caused an MDD event, and then
+	 * increment counters and set print pending
+	 */
 	ice_for_each_vf(pf, i) {
 		struct ice_vf *vf = &pf->vf[i];
 
-		bool vf_mdd_detected = false;
-
 		reg = rd32(hw, VP_MDET_TX_PQM(i));
 		if (reg & VP_MDET_TX_PQM_VALID_M) {
 			wr32(hw, VP_MDET_TX_PQM(i), 0xFFFF);
-			vf_mdd_detected = true;
-			dev_info(dev, "TX driver issue detected on VF %d\n",
-				 i);
+			vf->mdd_tx_events.count++;
+			set_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state);
+			if (netif_msg_tx_err(pf))
+				dev_info(dev, "Malicious Driver Detection event TX_PQM detected on VF %d\n",
+					 i);
 		}
 
 		reg = rd32(hw, VP_MDET_TX_TCLAN(i));
 		if (reg & VP_MDET_TX_TCLAN_VALID_M) {
 			wr32(hw, VP_MDET_TX_TCLAN(i), 0xFFFF);
-			vf_mdd_detected = true;
-			dev_info(dev, "TX driver issue detected on VF %d\n",
-				 i);
+			vf->mdd_tx_events.count++;
+			set_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state);
+			if (netif_msg_tx_err(pf))
+				dev_info(dev, "Malicious Driver Detection event TX_TCLAN detected on VF %d\n",
+					 i);
 		}
 
 		reg = rd32(hw, VP_MDET_TX_TDPU(i));
 		if (reg & VP_MDET_TX_TDPU_VALID_M) {
 			wr32(hw, VP_MDET_TX_TDPU(i), 0xFFFF);
-			vf_mdd_detected = true;
-			dev_info(dev, "TX driver issue detected on VF %d\n",
-				 i);
+			vf->mdd_tx_events.count++;
+			set_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state);
+			if (netif_msg_tx_err(pf))
+				dev_info(dev, "Malicious Driver Detection event TX_TDPU detected on VF %d\n",
+					 i);
 		}
 
 		reg = rd32(hw, VP_MDET_RX(i));
 		if (reg & VP_MDET_RX_VALID_M) {
 			wr32(hw, VP_MDET_RX(i), 0xFFFF);
-			vf_mdd_detected = true;
-			dev_info(dev, "RX driver issue detected on VF %d\n",
-				 i);
-		}
-
-		if (vf_mdd_detected) {
-			vf->num_mdd_events++;
-			if (vf->num_mdd_events &&
-			    vf->num_mdd_events <= ICE_MDD_EVENTS_THRESHOLD)
-				dev_info(dev, "VF %d has had %llu MDD events since last boot, Admin might need to reload AVF driver with this number of events\n",
-					 i, vf->num_mdd_events);
+			vf->mdd_rx_events.count++;
+			set_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state);
+			if (netif_msg_rx_err(pf))
+				dev_info(dev, "Malicious Driver Detection event RX detected on VF %d\n",
+					 i);
+
+			/* Since the queue is disabled on VF Rx MDD events, the
+			 * PF can be configured to reset the VF through ethtool
+			 * private flag mdd-auto-reset-vf.
+			 */
+			if (test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags))
+				ice_reset_vf(&pf->vf[i], false);
 		}
 	}
+
+	ice_print_vfs_mdd_events(pf);
 }
 
 /**
@@ -1995,6 +2001,14 @@ static void ice_ena_misc_vector(struct ice_pf *pf)
 	struct ice_hw *hw = &pf->hw;
 	u32 val;
 
+	/* Disable anti-spoof detection interrupt to prevent spurious event
+	 * interrupts during a function reset. Anti-spoof functionally is
+	 * still supported.
+	 */
+	val = rd32(hw, GL_MDCK_TX_TDPU);
+	val |= GL_MDCK_TX_TDPU_RCU_ANTISPOOF_ITR_DIS_M;
+	wr32(hw, GL_MDCK_TX_TDPU, val);
+
 	/* clear things first */
 	wr32(hw, PFINT_OICR_ENA, 0);	/* disable all */
 	rd32(hw, PFINT_OICR);		/* read to clear */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a21f9d2edbbb..e5c99bb8529e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -171,6 +171,11 @@ static void ice_free_vf_res(struct ice_vf *vf)
 	}
 
 	last_vector_idx = vf->first_vector_idx + pf->num_vf_msix - 1;
+
+	/* clear VF MDD event information */
+	memset(&vf->mdd_tx_events, 0, sizeof(vf->mdd_tx_events));
+	memset(&vf->mdd_rx_events, 0, sizeof(vf->mdd_rx_events));
+
 	/* Disable interrupts so that VF starts in a known state */
 	for (i = vf->first_vector_idx; i <= last_vector_idx; i++) {
 		wr32(&pf->hw, GLINT_DYN_CTL(i), GLINT_DYN_CTL_CLEARPBA_M);
@@ -1175,7 +1180,7 @@ static bool ice_is_vf_disabled(struct ice_vf *vf)
  *
  * Returns true if the VF is reset, false otherwise.
  */
-static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
+bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 {
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
@@ -3529,3 +3534,52 @@ int ice_get_vf_stats(struct net_device *netdev, int vf_id,
 
 	return 0;
 }
+
+/**
+ * ice_print_vfs_mdd_event - print VFs malicious driver detect event
+ * @pf: pointer to the PF structure
+ *
+ * Called from ice_handle_mdd_event to rate limit and print VFs MDD events.
+ */
+void ice_print_vfs_mdd_events(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	int i;
+
+	/* check that there are pending MDD events to print */
+	if (!test_and_clear_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state))
+		return;
+
+	/* VF MDD event logs are rate limited to one second intervals */
+	if (time_is_after_jiffies(pf->last_printed_mdd_jiffies + HZ * 1))
+		return;
+
+	pf->last_printed_mdd_jiffies = jiffies;
+
+	ice_for_each_vf(pf, i) {
+		struct ice_vf *vf = &pf->vf[i];
+
+		/* only print Rx MDD event message if there are new events */
+		if (vf->mdd_rx_events.count != vf->mdd_rx_events.last_printed) {
+			vf->mdd_rx_events.last_printed =
+							vf->mdd_rx_events.count;
+
+			dev_info(dev, "%d Rx Malicious Driver Detection events detected on PF %d VF %d MAC %pM. mdd-auto-reset-vfs=%s\n",
+				 vf->mdd_rx_events.count, hw->pf_id, i,
+				 vf->dflt_lan_addr.addr,
+				 test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags)
+					  ? "on" : "off");
+		}
+
+		/* only print Tx MDD event message if there are new events */
+		if (vf->mdd_tx_events.count != vf->mdd_tx_events.last_printed) {
+			vf->mdd_tx_events.last_printed =
+							vf->mdd_tx_events.count;
+
+			dev_info(dev, "%d Tx Malicious Driver Detection events detected on PF %d VF %d MAC %pM.\n",
+				 vf->mdd_tx_events.count, hw->pf_id, i,
+				 vf->dflt_lan_addr.addr);
+		}
+	}
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 474b2613f09c..656f1909b38f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -55,6 +55,13 @@ enum ice_virtchnl_cap {
 	ICE_VIRTCHNL_VF_CAP_PRIVILEGE,
 };
 
+/* VF MDD events print structure */
+struct ice_mdd_vf_events {
+	u16 count;			/* total count of Rx|Tx events */
+	/* count number of the last printed event */
+	u16 last_printed;
+};
+
 /* VF information structure */
 struct ice_vf {
 	struct ice_pf *pf;
@@ -83,13 +90,14 @@ struct ice_vf {
 	unsigned int tx_rate;		/* Tx bandwidth limit in Mbps */
 	DECLARE_BITMAP(vf_states, ICE_VF_STATES_NBITS);	/* VF runtime states */
 
-	u64 num_mdd_events;		/* number of MDD events detected */
 	u64 num_inval_msgs;		/* number of continuous invalid msgs */
 	u64 num_valid_msgs;		/* number of valid msgs detected */
 	unsigned long vf_caps;		/* VF's adv. capabilities */
 	u8 num_req_qs;			/* num of queue pairs requested by VF */
 	u16 num_mac;
 	u16 num_vf_qs;			/* num of queue configured per VF */
+	struct ice_mdd_vf_events mdd_rx_events;
+	struct ice_mdd_vf_events mdd_tx_events;
 };
 
 #ifdef CONFIG_PCI_IOV
@@ -104,6 +112,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event);
 void ice_vc_notify_link_state(struct ice_pf *pf);
 void ice_vc_notify_reset(struct ice_pf *pf);
 bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr);
+bool ice_reset_vf(struct ice_vf *vf, bool is_vflr);
 
 int
 ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
@@ -123,7 +132,7 @@ ice_get_vf_stats(struct net_device *netdev, int vf_id,
 		 struct ifla_vf_stats *vf_stats);
 void
 ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event);
-
+void ice_print_vfs_mdd_events(struct ice_pf *pf);
 #else /* CONFIG_PCI_IOV */
 #define ice_process_vflr_event(pf) do {} while (0)
 #define ice_free_vfs(pf) do {} while (0)
@@ -132,6 +141,7 @@ ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event);
 #define ice_vc_notify_reset(pf) do {} while (0)
 #define ice_set_vf_state_qs_dis(vf) do {} while (0)
 #define ice_vf_lan_overflow_event(pf, event) do {} while (0)
+#define ice_print_vfs_mdd_events(pf) do {} while (0)
 
 static inline bool
 ice_reset_all_vfs(struct ice_pf __always_unused *pf,
@@ -140,6 +150,12 @@ ice_reset_all_vfs(struct ice_pf __always_unused *pf,
 	return true;
 }
 
+static inline bool
+ice_reset_vf(struct ice_vf __always_unused *vf, bool __always_unused is_vflr)
+{
+	return true;
+}
+
 static inline int
 ice_sriov_configure(struct pci_dev __always_unused *pdev,
 		    int __always_unused num_vfs)
-- 
2.24.1


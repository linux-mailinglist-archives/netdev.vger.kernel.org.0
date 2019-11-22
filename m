Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BC1107A96
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfKVW3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:29:19 -0500
Received: from mga07.intel.com ([134.134.136.100]:7937 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbfKVW3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:29:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:29:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409027375"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:29:11 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 13/15] ice: Implement ethtool ops for channels
Date:   Fri, 22 Nov 2019 14:29:03 -0800
Message-Id: <20191122222905.670858-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
References: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

Add code to query and set the number of channels on the primary VSI for a
PF. This is accessed from the 'ethtool -l' and 'ethtool -L' commands,
respectively.  Though the ice driver supports asymmetric queues report an
IRQ vector that has both Rx and Tx queues attached and is counted as a
'combined' channel.

Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Co-developed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
v2: added netif_is_rxfh_configured() to the check if RSS has been
    configured by the user, if so, do not overwrite that configuration
    Also remove the code in the default RSS configuration function to
    not overwrite the RSS configuration

 drivers/net/ethernet/intel/ice/ice.h         |   4 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h |   2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 185 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.c     |  70 +++++--
 drivers/net/ethernet/intel/ice/ice_lib.h     |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    |  87 ++++++++-
 7 files changed, 335 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index cb7259c27353..f972dce8aebb 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -285,6 +285,8 @@ struct ice_vsi {
 	u16 num_txq;			 /* Used Tx queues */
 	u16 alloc_rxq;			 /* Allocated Rx queues */
 	u16 num_rxq;			 /* Used Rx queues */
+	u16 req_txq;			 /* User requested Tx queues */
+	u16 req_rxq;			 /* User requested Rx queues */
 	u16 num_rx_desc;
 	u16 num_tx_desc;
 	struct ice_tc_cfg tc_cfg;
@@ -491,6 +493,7 @@ void ice_set_ethtool_ops(struct net_device *netdev);
 void ice_set_ethtool_safe_mode_ops(struct net_device *netdev);
 u16 ice_get_avail_txq_count(struct ice_pf *pf);
 u16 ice_get_avail_rxq_count(struct ice_pf *pf);
+int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx);
 void ice_update_vsi_stats(struct ice_vsi *vsi);
 void ice_update_pf_stats(struct ice_pf *pf);
 int ice_up(struct ice_vsi *vsi);
@@ -505,6 +508,7 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
+int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 int ice_open(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 20b63443237c..d3d3ec29def9 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -4,8 +4,6 @@
 #include "ice_dcb_lib.h"
 #include "ice_dcb_nl.h"
 
-static void ice_pf_dcb_recfg(struct ice_pf *pf);
-
 /**
  * ice_vsi_cfg_netdev_tc - Setup the netdev TC configuration
  * @vsi: the VSI being configured
@@ -535,7 +533,7 @@ static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
  * calling this function. Reconfiguring DCB based on
  * local_dcbx_cfg.
  */
-static void ice_pf_dcb_recfg(struct ice_pf *pf)
+void ice_pf_dcb_recfg(struct ice_pf *pf)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
 	u8 tc_map = 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index c81d7f69d5c4..f15e5776f287 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -20,6 +20,7 @@ u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg *dcbcfg);
 u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index);
 int
 ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked);
+void ice_pf_dcb_recfg(struct ice_pf *pf);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
@@ -78,6 +79,7 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
 }
 
 #define ice_update_dcb_stats(pf) do {} while (0)
+#define ice_pf_dcb_recfg(pf) do {} while (0)
 #define ice_vsi_cfg_dcb_rings(vsi) do {} while (0)
 #define ice_dcb_process_lldp_set_mib_change(pf, event) do {} while (0)
 #define ice_set_cgd_num(tlan_ctx, ring) do {} while (0)
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 5b229f3703b5..aec3c6c379df 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3142,6 +3142,188 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
 	return 0;
 }
 
+/**
+ * ice_get_max_txq - return the maximum number of Tx queues for in a PF
+ * @pf: PF structure
+ */
+static int ice_get_max_txq(struct ice_pf *pf)
+{
+	return min_t(int, num_online_cpus(),
+		     pf->hw.func_caps.common_cap.num_txq);
+}
+
+/**
+ * ice_get_max_rxq - return the maximum number of Rx queues for in a PF
+ * @pf: PF structure
+ */
+static int ice_get_max_rxq(struct ice_pf *pf)
+{
+	return min_t(int, num_online_cpus(),
+		     pf->hw.func_caps.common_cap.num_rxq);
+}
+
+/**
+ * ice_get_combined_cnt - return the current number of combined channels
+ * @vsi: PF VSI pointer
+ *
+ * Go through all queue vectors and count ones that have both Rx and Tx ring
+ * attached
+ */
+static u32 ice_get_combined_cnt(struct ice_vsi *vsi)
+{
+	u32 combined = 0;
+	int q_idx;
+
+	ice_for_each_q_vector(vsi, q_idx) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[q_idx];
+
+		if (q_vector->rx.ring && q_vector->tx.ring)
+			combined++;
+	}
+
+	return combined;
+}
+
+/**
+ * ice_get_channels - get the current and max supported channels
+ * @dev: network interface device structure
+ * @ch: ethtool channel data structure
+ */
+static void
+ice_get_channels(struct net_device *dev, struct ethtool_channels *ch)
+{
+	struct ice_netdev_priv *np = netdev_priv(dev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+
+	/* check to see if VSI is active */
+	if (test_bit(__ICE_DOWN, vsi->state))
+		return;
+
+	/* report maximum channels */
+	ch->max_rx = ice_get_max_rxq(pf);
+	ch->max_tx = ice_get_max_txq(pf);
+	ch->max_combined = min_t(int, ch->max_rx, ch->max_tx);
+
+	/* report current channels */
+	ch->combined_count = ice_get_combined_cnt(vsi);
+	ch->rx_count = vsi->num_rxq - ch->combined_count;
+	ch->tx_count = vsi->num_txq - ch->combined_count;
+}
+
+/**
+ * ice_vsi_set_dflt_rss_lut - set default RSS LUT with requested RSS size
+ * @vsi: VSI to reconfigure RSS LUT on
+ * @req_rss_size: requested range of queue numbers for hashing
+ *
+ * Set the VSI's RSS parameters, configure the RSS LUT based on these.
+ */
+static int ice_vsi_set_dflt_rss_lut(struct ice_vsi *vsi, int req_rss_size)
+{
+	struct ice_pf *pf = vsi->back;
+	enum ice_status status;
+	struct device *dev;
+	struct ice_hw *hw;
+	int err = 0;
+	u8 *lut;
+
+	dev = ice_pf_to_dev(pf);
+	hw = &pf->hw;
+
+	if (!req_rss_size)
+		return -EINVAL;
+
+	lut = kzalloc(vsi->rss_table_size, GFP_KERNEL);
+	if (!lut)
+		return -ENOMEM;
+
+	/* set RSS LUT parameters */
+	if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
+		vsi->rss_size = 1;
+	} else {
+		struct ice_hw_common_caps *caps = &hw->func_caps.common_cap;
+
+		vsi->rss_size = min_t(int, req_rss_size,
+				      BIT(caps->rss_table_entry_width));
+	}
+
+	/* create/set RSS LUT */
+	ice_fill_rss_lut(lut, vsi->rss_table_size, vsi->rss_size);
+	status = ice_aq_set_rss_lut(hw, vsi->idx, vsi->rss_lut_type, lut,
+				    vsi->rss_table_size);
+	if (status) {
+		dev_err(dev, "Cannot set RSS lut, err %d aq_err %d\n",
+			status, hw->adminq.rq_last_status);
+		err = -EIO;
+	}
+
+	kfree(lut);
+	return err;
+}
+
+/**
+ * ice_set_channels - set the number channels
+ * @dev: network interface device structure
+ * @ch: ethtool channel data structure
+ */
+static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
+{
+	struct ice_netdev_priv *np = netdev_priv(dev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+	int new_rx = 0, new_tx = 0;
+	u32 curr_combined;
+
+	/* do not support changing channels in Safe Mode */
+	if (ice_is_safe_mode(pf)) {
+		netdev_err(dev, "Changing channel in Safe Mode is not supported\n");
+		return -EOPNOTSUPP;
+	}
+	/* do not support changing other_count */
+	if (ch->other_count)
+		return -EINVAL;
+
+	curr_combined = ice_get_combined_cnt(vsi);
+
+	/* these checks are for cases where user didn't specify a particular
+	 * value on cmd line but we get non-zero value anyway via
+	 * get_channels(); look at ethtool.c in ethtool repository (the user
+	 * space part), particularly, do_schannels() routine
+	 */
+	if (ch->rx_count == vsi->num_rxq - curr_combined)
+		ch->rx_count = 0;
+	if (ch->tx_count == vsi->num_txq - curr_combined)
+		ch->tx_count = 0;
+	if (ch->combined_count == curr_combined)
+		ch->combined_count = 0;
+
+	if (!(ch->combined_count || (ch->rx_count && ch->tx_count))) {
+		netdev_err(dev, "Please specify at least 1 Rx and 1 Tx channel\n");
+		return -EINVAL;
+	}
+
+	new_rx = ch->combined_count + ch->rx_count;
+	new_tx = ch->combined_count + ch->tx_count;
+
+	if (new_rx > ice_get_max_rxq(pf)) {
+		netdev_err(dev, "Maximum allowed Rx channels is %d\n",
+			   ice_get_max_rxq(pf));
+		return -EINVAL;
+	}
+	if (new_tx > ice_get_max_txq(pf)) {
+		netdev_err(dev, "Maximum allowed Tx channels is %d\n",
+			   ice_get_max_txq(pf));
+		return -EINVAL;
+	}
+
+	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
+
+	if (new_rx && !netif_is_rxfh_configured(dev))
+		return ice_vsi_set_dflt_rss_lut(vsi, new_rx);
+
+	return 0;
+}
+
 enum ice_container_type {
 	ICE_RX_CONTAINER,
 	ICE_TX_CONTAINER,
@@ -3631,6 +3813,8 @@ static const struct ethtool_ops ice_ethtool_ops = {
 	.get_rxfh_indir_size	= ice_get_rxfh_indir_size,
 	.get_rxfh		= ice_get_rxfh,
 	.set_rxfh		= ice_set_rxfh,
+	.get_channels		= ice_get_channels,
+	.set_channels		= ice_set_channels,
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_per_queue_coalesce = ice_get_per_q_coalesce,
 	.set_per_queue_coalesce = ice_set_per_q_coalesce,
@@ -3656,6 +3840,7 @@ static const struct ethtool_ops ice_ethtool_safe_mode_ops = {
 	.get_ringparam		= ice_get_ringparam,
 	.set_ringparam		= ice_set_ringparam,
 	.nway_reset		= ice_nway_reset,
+	.get_channels		= ice_get_channels,
 };
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b546c69a4bbc..e7449248fab4 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -142,15 +142,24 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 	case ICE_VSI_PF:
 		vsi->alloc_txq = min_t(int, ice_get_avail_txq_count(pf),
 				       num_online_cpus());
+		if (vsi->req_txq) {
+			vsi->alloc_txq = vsi->req_txq;
+			vsi->num_txq = vsi->req_txq;
+		}
 
 		pf->num_lan_tx = vsi->alloc_txq;
 
 		/* only 1 Rx queue unless RSS is enabled */
-		if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags))
+		if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
 			vsi->alloc_rxq = 1;
-		else
+		} else {
 			vsi->alloc_rxq = min_t(int, ice_get_avail_rxq_count(pf),
 					       num_online_cpus());
+			if (vsi->req_rxq) {
+				vsi->alloc_rxq = vsi->req_rxq;
+				vsi->num_rxq = vsi->req_rxq;
+			}
+		}
 
 		pf->num_lan_rx = vsi->alloc_rxq;
 
@@ -639,7 +648,9 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 			else
 				max_rss = ICE_MAX_SMALL_RSS_QS;
 			qcount_rx = min_t(int, rx_numq_tc, max_rss);
-			qcount_rx = min_t(int, qcount_rx, vsi->rss_size);
+			if (!vsi->req_rxq)
+				qcount_rx = min_t(int, qcount_rx,
+						  vsi->rss_size);
 		}
 	}
 
@@ -746,17 +757,20 @@ static void ice_set_rss_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
 /**
  * ice_vsi_init - Create and initialize a VSI
  * @vsi: the VSI being configured
+ * @init_vsi: is this call creating a VSI
  *
  * This initializes a VSI context depending on the VSI type to be added and
  * passes it down to the add_vsi aq command to create a new VSI.
  */
-static int ice_vsi_init(struct ice_vsi *vsi)
+static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	struct ice_vsi_ctx *ctxt;
+	struct device *dev;
 	int ret = 0;
 
+	dev = ice_pf_to_dev(pf);
 	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
 	if (!ctxt)
 		return -ENOMEM;
@@ -784,11 +798,24 @@ static int ice_vsi_init(struct ice_vsi *vsi)
 		ctxt->info.sw_flags |= ICE_AQ_VSI_SW_FLAG_ALLOW_LB;
 
 	/* Set LUT type and HASH type if RSS is enabled */
-	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
+	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
 		ice_set_rss_vsi_ctx(ctxt, vsi);
+		/* if updating VSI context, make sure to set valid_section:
+		 * to indicate which section of VSI context being updated
+		 */
+		if (!init_vsi)
+			ctxt->info.valid_sections |=
+				cpu_to_le16(ICE_AQ_VSI_PROP_Q_OPT_VALID);
+	}
 
 	ctxt->info.sw_id = vsi->port_info->sw_id;
 	ice_vsi_setup_q_map(vsi, ctxt);
+	if (!init_vsi) /* means VSI being updated */
+		/* must to indicate which section of VSI context are
+		 * being modified
+		 */
+		ctxt->info.valid_sections |=
+			cpu_to_le16(ICE_AQ_VSI_PROP_RXQ_MAP_VALID);
 
 	/* Enable MAC Antispoof with new VSI being initialized or updated */
 	if (vsi->type == ICE_VSI_VF && pf->vf[vsi->vf_id].spoofchk) {
@@ -805,11 +832,20 @@ static int ice_vsi_init(struct ice_vsi *vsi)
 			cpu_to_le16(ICE_AQ_VSI_PROP_SECURITY_VALID);
 	}
 
-	ret = ice_add_vsi(hw, vsi->idx, ctxt, NULL);
-	if (ret) {
-		dev_err(ice_pf_to_dev(pf), "Add VSI failed, err %d\n", ret);
-		ret = -EIO;
-		goto out;
+	if (init_vsi) {
+		ret = ice_add_vsi(hw, vsi->idx, ctxt, NULL);
+		if (ret) {
+			dev_err(dev, "Add VSI failed, err %d\n", ret);
+			ret = -EIO;
+			goto out;
+		}
+	} else {
+		ret = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+		if (ret) {
+			dev_err(dev, "Update VSI failed, err %d\n", ret);
+			ret = -EIO;
+			goto out;
+		}
 	}
 
 	/* keep context for update VSI operations */
@@ -1835,7 +1871,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	ice_vsi_set_tc_cfg(vsi);
 
 	/* create the VSI */
-	ret = ice_vsi_init(vsi);
+	ret = ice_vsi_init(vsi, true);
 	if (ret)
 		goto unroll_get_qs;
 
@@ -2368,10 +2404,11 @@ int ice_vsi_release(struct ice_vsi *vsi)
 /**
  * ice_vsi_rebuild - Rebuild VSI after reset
  * @vsi: VSI to be rebuild
+ * @init_vsi: is this an initialization or a reconfigure of the VSI
  *
  * Returns 0 on success and negative value on failure
  */
-int ice_vsi_rebuild(struct ice_vsi *vsi)
+int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct ice_vf *vf = NULL;
@@ -2423,7 +2460,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	ice_vsi_set_tc_cfg(vsi);
 
 	/* Initialize VSI struct elements and create VSI in FW */
-	ret = ice_vsi_init(vsi);
+	ret = ice_vsi_init(vsi, init_vsi);
 	if (ret < 0)
 		goto err_vsi;
 
@@ -2491,7 +2528,12 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 		dev_err(ice_pf_to_dev(pf),
 			"VSI %d failed lan queue config, error %d\n",
 			vsi->vsi_num, status);
-		goto err_vectors;
+		if (init_vsi) {
+			ret = -EIO;
+			goto err_vectors;
+		} else {
+			return ice_schedule_reset(pf, ICE_RESET_PFR);
+		}
 	}
 	return 0;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index e86aa60c0254..6e31e30aba39 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -73,7 +73,7 @@ int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id);
 int
 ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id);
 
-int ice_vsi_rebuild(struct ice_vsi *vsi);
+int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi);
 
 bool ice_is_reset_in_progress(unsigned long *state);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d282eb05c2e0..69bff085acf7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -44,6 +44,7 @@ MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
 static struct workqueue_struct *ice_wq;
 static const struct net_device_ops ice_netdev_safe_mode_ops;
 static const struct net_device_ops ice_netdev_ops;
+static int ice_vsi_open(struct ice_vsi *vsi);
 
 static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type);
 
@@ -1524,6 +1525,44 @@ static void ice_set_ctrlq_len(struct ice_hw *hw)
 	hw->mailboxq.sq_buf_size = ICE_MBXQ_MAX_BUF_LEN;
 }
 
+/**
+ * ice_schedule_reset - schedule a reset
+ * @pf: board private structure
+ * @reset: reset being requested
+ */
+int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+
+	/* bail out if earlier reset has failed */
+	if (test_bit(__ICE_RESET_FAILED, pf->state)) {
+		dev_dbg(dev, "earlier reset has failed\n");
+		return -EIO;
+	}
+	/* bail if reset/recovery already in progress */
+	if (ice_is_reset_in_progress(pf->state)) {
+		dev_dbg(dev, "Reset already in progress\n");
+		return -EBUSY;
+	}
+
+	switch (reset) {
+	case ICE_RESET_PFR:
+		set_bit(__ICE_PFR_REQ, pf->state);
+		break;
+	case ICE_RESET_CORER:
+		set_bit(__ICE_CORER_REQ, pf->state);
+		break;
+	case ICE_RESET_GLOBR:
+		set_bit(__ICE_GLOBR_REQ, pf->state);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ice_service_task_schedule(pf);
+	return 0;
+}
+
 /**
  * ice_irq_affinity_notify - Callback for affinity changes
  * @notify: context as to what irq was changed
@@ -2808,6 +2847,52 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_vsi_recfg_qs - Change the number of queues on a VSI
+ * @vsi: VSI being changed
+ * @new_rx: new number of Rx queues
+ * @new_tx: new number of Tx queues
+ *
+ * Only change the number of queues if new_tx, or new_rx is non-0.
+ *
+ * Returns 0 on success.
+ */
+int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
+{
+	struct ice_pf *pf = vsi->back;
+	int err = 0, timeout = 50;
+
+	if (!new_rx && !new_tx)
+		return -EINVAL;
+
+	while (test_and_set_bit(__ICE_CFG_BUSY, pf->state)) {
+		timeout--;
+		if (!timeout)
+			return -EBUSY;
+		usleep_range(1000, 2000);
+	}
+
+	if (new_tx)
+		vsi->req_txq = new_tx;
+	if (new_rx)
+		vsi->req_rxq = new_rx;
+
+	/* set for the next time the netdev is started */
+	if (!netif_running(vsi->netdev)) {
+		ice_vsi_rebuild(vsi, false);
+		dev_dbg(ice_pf_to_dev(pf), "Link is down, queue count change happens when link is brought up\n");
+		goto done;
+	}
+
+	ice_vsi_close(vsi);
+	ice_vsi_rebuild(vsi, false);
+	ice_pf_dcb_recfg(pf);
+	ice_vsi_open(vsi);
+done:
+	clear_bit(__ICE_CFG_BUSY, pf->state);
+	return err;
+}
+
 /**
  * ice_log_pkg_init - log result of DDP package load
  * @hw: pointer to hardware info
@@ -4482,7 +4567,7 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 			continue;
 
 		/* rebuild the VSI */
-		err = ice_vsi_rebuild(vsi);
+		err = ice_vsi_rebuild(vsi, true);
 		if (err) {
 			dev_err(dev,
 				"rebuild VSI failed, err %d, VSI index %d, type %s\n",
-- 
2.23.0


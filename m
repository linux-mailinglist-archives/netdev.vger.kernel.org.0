Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2958827F
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436545AbfHISbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:31:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:55686 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfHISbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 14:31:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 11:31:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="175229884"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2019 11:31:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ice: Implement ethtool ops for channels
Date:   Fri,  9 Aug 2019 11:31:25 -0700
Message-Id: <20190809183139.30871-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
References: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

Add code to query and set the number of queues on the primary
VSI for a PF. This is accessed from the 'ethtool -l' and 'ethtool -L'
commands, respectively.

Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  4 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  9 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h |  2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 85 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.c     | 52 ++++++++---
 drivers/net/ethernet/intel/ice/ice_lib.h     |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 91 +++++++++++++++++++-
 7 files changed, 230 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 794d97460fc7..07950ac4869f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -298,6 +298,8 @@ struct ice_vsi {
 	u16 num_txq;			 /* Used Tx queues */
 	u16 alloc_rxq;			 /* Allocated Rx queues */
 	u16 num_rxq;			 /* Used Rx queues */
+	u16 req_txq;			 /* User requested Tx queues */
+	u16 req_rxq;			 /* User requested Rx queues */
 	u16 num_rx_desc;
 	u16 num_tx_desc;
 	struct ice_tc_cfg tc_cfg;
@@ -455,6 +457,7 @@ ice_find_vsi_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 int ice_vsi_setup_tx_rings(struct ice_vsi *vsi);
 int ice_vsi_setup_rx_rings(struct ice_vsi *vsi);
 void ice_set_ethtool_ops(struct net_device *netdev);
+int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx);
 int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
 int ice_vsi_cfg(struct ice_vsi *vsi);
@@ -462,6 +465,7 @@ struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
 int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
+int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 #ifdef CONFIG_DCB
 int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index fe88b127ca42..f80628a13f2a 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -85,11 +85,16 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
 			break;
 
 		qoffset = vsi->tc_cfg.tc_info[n].qoffset;
+
 		qcount = vsi->tc_cfg.tc_info[n].qcount_tx;
 		for (i = qoffset; i < (qoffset + qcount); i++) {
 			tx_ring = vsi->tx_rings[i];
-			rx_ring = vsi->rx_rings[i];
 			tx_ring->dcb_tc = n;
+		}
+
+		qcount = vsi->tc_cfg.tc_info[n].qcount_rx;
+		for (i = qoffset; i < (qoffset + qcount); i++) {
+			rx_ring = vsi->rx_rings[i];
 			rx_ring->dcb_tc = n;
 		}
 	}
@@ -103,7 +108,7 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
  * calling this function. Reconfiguring DCB based on
  * local_dcbx_cfg.
  */
-static void ice_pf_dcb_recfg(struct ice_pf *pf)
+void ice_pf_dcb_recfg(struct ice_pf *pf)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
 	u8 tc_map = 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 819081053ff5..be2ab6f20b21 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -13,6 +13,7 @@
 void ice_dcb_rebuild(struct ice_pf *pf);
 u8 ice_dcb_get_ena_tc(struct ice_dcbx_cfg *dcbcfg);
 u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg *dcbcfg);
+void ice_pf_dcb_recfg(struct ice_pf *pf);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
@@ -55,6 +56,7 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
 }
 
 #define ice_update_dcb_stats(pf) do {} while (0)
+#define ice_pf_dcb_recfg(pf) do {} while (0)
 #define ice_vsi_cfg_dcb_rings(vsi) do {} while (0)
 #define ice_dcb_process_lldp_set_mib_change(pf, event) do {} while (0)
 #define ice_set_cgd_num(tlan_ctx, ring) do {} while (0)
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index d3ba535bd65a..1fe048cfb737 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3083,6 +3083,89 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
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
+
+	/* report current channels */
+	ch->rx_count = vsi->num_rxq;
+	ch->tx_count = vsi->num_txq;
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
+
+	/* do not support changing other_count */
+	if (ch->other_count)
+		return -EINVAL;
+
+	/* verify request for a valid number of channels */
+	if (ch->rx_count > ice_get_max_rxq(pf) ||
+	    ch->tx_count > ice_get_max_txq(pf))
+		return -EINVAL;
+
+	/* Use new Rx value only if changed */
+	if (ch->rx_count != vsi->num_rxq)
+		new_rx = ch->rx_count;
+
+	/* Use new Tx value only if changed */
+	if (ch->tx_count != vsi->num_txq)
+		new_tx = ch->tx_count;
+
+	/* verify that we have a valid request */
+	if (!new_rx && !new_tx)
+		return -EINVAL;
+
+	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
+
+	return 0;
+}
+
 enum ice_container_type {
 	ICE_RX_CONTAINER,
 	ICE_TX_CONTAINER,
@@ -3429,6 +3512,8 @@ static const struct ethtool_ops ice_ethtool_ops = {
 	.get_rxfh_indir_size	= ice_get_rxfh_indir_size,
 	.get_rxfh		= ice_get_rxfh,
 	.set_rxfh		= ice_set_rxfh,
+	.get_channels		= ice_get_channels,
+	.set_channels		= ice_set_channels,
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_per_queue_coalesce = ice_get_per_q_coalesce,
 	.set_per_queue_coalesce = ice_set_per_q_coalesce,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6e34c40e7840..a62496a74a69 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -313,6 +313,14 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 	case ICE_VSI_PF:
 		vsi->alloc_txq = pf->num_lan_tx;
 		vsi->alloc_rxq = pf->num_lan_rx;
+		if (vsi->req_txq) {
+			vsi->alloc_txq = vsi->req_txq;
+			vsi->num_txq = vsi->req_txq;
+		}
+		if (vsi->req_rxq) {
+			vsi->alloc_rxq = vsi->req_rxq;
+			vsi->num_rxq = vsi->req_rxq;
+		}
 		vsi->num_q_vectors = max_t(int, pf->num_lan_rx, pf->num_lan_tx);
 		break;
 	case ICE_VSI_VF:
@@ -855,7 +863,9 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 			else
 				max_rss = ICE_MAX_SMALL_RSS_QS;
 			qcount_rx = min_t(int, rx_numq_tc, max_rss);
-			qcount_rx = min_t(int, qcount_rx, vsi->rss_size);
+			if (!vsi->req_rxq)
+				qcount_rx = min_t(int, qcount_rx,
+						  vsi->rss_size);
 		}
 	}
 
@@ -959,11 +969,12 @@ static void ice_set_rss_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
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
@@ -1010,11 +1021,20 @@ static int ice_vsi_init(struct ice_vsi *vsi)
 			ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF;
 	}
 
-	ret = ice_add_vsi(hw, vsi->idx, ctxt, NULL);
-	if (ret) {
-		dev_err(&pf->pdev->dev,
-			"Add VSI failed, err %d\n", ret);
-		return -EIO;
+	if (init_vsi) {
+		ret = ice_add_vsi(hw, vsi->idx, ctxt, NULL);
+		if (ret) {
+			dev_err(&pf->pdev->dev,
+				"Add VSI failed, err %d\n", ret);
+			return -EIO;
+		}
+	} else {
+		ret = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+		if (ret) {
+			dev_err(&pf->pdev->dev,
+				"Update VSI failed, err %d\n", ret);
+			return -EIO;
+		}
 	}
 
 	/* keep context for update VSI operations */
@@ -2435,7 +2455,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	ice_vsi_set_tc_cfg(vsi);
 
 	/* create the VSI */
-	ret = ice_vsi_init(vsi);
+	ret = ice_vsi_init(vsi, true);
 	if (ret)
 		goto unroll_get_qs;
 
@@ -2911,10 +2931,11 @@ int ice_vsi_release(struct ice_vsi *vsi)
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
@@ -2947,14 +2968,18 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	ice_vsi_clear_rings(vsi);
 	ice_vsi_free_arrays(vsi);
 	ice_dev_onetime_setup(&pf->hw);
+	if (vsi->req_txq || vsi->req_rxq)
+		ice_vsi_put_qs(vsi);
 	if (vsi->type == ICE_VSI_VF)
 		ice_vsi_set_num_qs(vsi, vf->vf_id);
 	else
 		ice_vsi_set_num_qs(vsi, ICE_INVAL_VFID);
+	if (vsi->req_txq || vsi->req_rxq)
+		ice_vsi_get_qs(vsi);
 	ice_vsi_set_tc_cfg(vsi);
 
 	/* Initialize VSI struct elements and create VSI in FW */
-	ret = ice_vsi_init(vsi);
+	ret = ice_vsi_init(vsi, init_vsi);
 	if (ret < 0)
 		goto err_vsi;
 
@@ -3018,7 +3043,12 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 		dev_err(&pf->pdev->dev,
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
index 6e43ef03bfc3..7409a69f631d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -70,7 +70,7 @@ int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id);
 int
 ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id);
 
-int ice_vsi_rebuild(struct ice_vsi *vsi);
+int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi);
 
 bool ice_is_reset_in_progress(unsigned long *state);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c26e6a102dac..f9f81307dac8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1513,6 +1513,42 @@ static void ice_set_ctrlq_len(struct ice_hw *hw)
 	hw->mailboxq.sq_buf_size = ICE_MBXQ_MAX_BUF_LEN;
 }
 
+/**
+ * ice_schedule_reset - schedule a reset
+ * @pf: board private structure
+ * @reset: reset being requested
+ */
+int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset)
+{
+	/* bail out if earlier reset has failed */
+	if (test_bit(__ICE_RESET_FAILED, pf->state)) {
+		dev_dbg(&pf->pdev->dev, "earlier reset has failed\n");
+		return -EIO;
+	}
+	/* bail if reset/recovery already in progress */
+	if (ice_is_reset_in_progress(pf->state)) {
+		dev_dbg(&pf->pdev->dev, "Reset already in progress\n");
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
@@ -3745,7 +3781,7 @@ static int ice_vsi_rebuild_all(struct ice_pf *pf)
 		if (!pf->vsi[i])
 			continue;
 
-		err = ice_vsi_rebuild(pf->vsi[i]);
+		err = ice_vsi_rebuild(pf->vsi[i], true);
 		if (err) {
 			dev_err(&pf->pdev->dev,
 				"VSI at index %d rebuild failed\n",
@@ -3907,6 +3943,59 @@ static void ice_rebuild(struct ice_pf *pf)
 	dev_err(dev, "Rebuild failed, unload and reload driver\n");
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
+	/* set for the next time the netdev is started */
+	if (!netif_running(vsi->netdev)) {
+		if (new_tx)
+			vsi->req_txq = new_tx;
+		if (new_rx)
+			vsi->req_rxq = new_rx;
+
+		dev_dbg(&pf->pdev->dev, "Link is down, queue count change happens when link is brought up\n");
+		goto done;
+	}
+
+	ice_vsi_close(vsi);
+
+	if (new_tx)
+		vsi->req_txq = new_tx;
+
+	if (new_rx)
+		vsi->req_rxq = new_rx;
+
+	ice_vsi_rebuild(vsi, false);
+	ice_pf_dcb_recfg(pf);
+
+	ice_vsi_open(vsi);
+done:
+	clear_bit(__ICE_CFG_BUSY, pf->state);
+	return err;
+}
+
 /**
  * ice_change_mtu - NDO callback to change the MTU
  * @netdev: network interface device structure
-- 
2.21.0


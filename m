Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C452F3B3B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbfKGWQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:16:12 -0500
Received: from mga07.intel.com ([134.134.136.100]:16680 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbfKGWOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 17:14:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 14:14:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,279,1569308400"; 
   d="scan'208";a="233420887"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 07 Nov 2019 14:14:40 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Usha Ketineni <usha.k.ketineni@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tarun Singh <tarun.k.singh@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] ice: Add NDO callback to set the maximum per-queue bitrate
Date:   Thu,  7 Nov 2019 14:14:25 -0800
Message-Id: <20191107221438.17994-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
References: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Usha Ketineni <usha.k.ketineni@intel.com>

Allow for rate limiting Tx queues. Bitrate is set in
Mbps(megabits per second).

Mbps max-rate is set for the queue via sysfs:
/sys/class/net/<iface>/queues/tx-<queue>/tx_maxrate
ex: echo 100 >/sys/class/net/ens7/queues/tx-0/tx_maxrate
    echo 200 >/sys/class/net/ens7/queues/tx-1/tx_maxrate
Note: A value of zero for tx_maxrate means disabled,
default is disabled.

Signed-off-by: Usha Ketineni <usha.k.ketineni@intel.com>
Co-developed-by: Tarun Singh <tarun.k.singh@intel.com>
Signed-off-by: Tarun Singh <tarun.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   46 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   10 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |    2 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   10 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    8 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   43 +
 drivers/net/ethernet/intel/ice/ice_sched.c    | 1264 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_sched.h    |   39 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |    5 -
 drivers/net/ethernet/intel/ice/ice_type.h     |   63 +-
 10 files changed, 1480 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 622c666399fd..5421fc413f94 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -742,6 +742,10 @@ struct ice_aqc_add_elem {
 	struct ice_aqc_txsched_elem_data generic[1];
 };
 
+struct ice_aqc_conf_elem {
+	struct ice_aqc_txsched_elem_data generic[1];
+};
+
 struct ice_aqc_get_elem {
 	struct ice_aqc_txsched_elem_data generic[1];
 };
@@ -783,6 +787,44 @@ struct ice_aqc_port_ets_elem {
 	__le32 tc_node_teid[8]; /* Used for response, reserved in command */
 };
 
+/* Rate limiting profile for
+ * Add RL profile (indirect 0x0410)
+ * Query RL profile (indirect 0x0411)
+ * Remove RL profile (indirect 0x0415)
+ * These indirect commands acts on single or multiple
+ * RL profiles with specified data.
+ */
+struct ice_aqc_rl_profile {
+	__le16 num_profiles;
+	__le16 num_processed; /* Only for response. Reserved in Command. */
+	u8 reserved[4];
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+struct ice_aqc_rl_profile_elem {
+	u8 level;
+	u8 flags;
+#define ICE_AQC_RL_PROFILE_TYPE_S	0x0
+#define ICE_AQC_RL_PROFILE_TYPE_M	(0x3 << ICE_AQC_RL_PROFILE_TYPE_S)
+#define ICE_AQC_RL_PROFILE_TYPE_CIR	0
+#define ICE_AQC_RL_PROFILE_TYPE_EIR	1
+#define ICE_AQC_RL_PROFILE_TYPE_SRL	2
+/* The following flag is used for Query RL Profile Data */
+#define ICE_AQC_RL_PROFILE_INVAL_S	0x7
+#define ICE_AQC_RL_PROFILE_INVAL_M	(0x1 << ICE_AQC_RL_PROFILE_INVAL_S)
+
+	__le16 profile_id;
+	__le16 max_burst_size;
+	__le16 rl_multiply;
+	__le16 wake_up_calc;
+	__le16 rl_encode;
+};
+
+struct ice_aqc_rl_profile_generic_elem {
+	struct ice_aqc_rl_profile_elem generic[1];
+};
+
 /* Query Scheduler Resource Allocation (indirect 0x0412)
  * This indirect command retrieves the scheduler resources allocated by
  * EMP Firmware to the given PF.
@@ -1657,6 +1699,7 @@ struct ice_aq_desc {
 		struct ice_aqc_sched_elem_cmd sched_elem_cmd;
 		struct ice_aqc_query_txsched_res query_sched_res;
 		struct ice_aqc_query_port_ets port_ets;
+		struct ice_aqc_rl_profile rl_profile;
 		struct ice_aqc_nvm nvm;
 		struct ice_aqc_nvm_checksum nvm_checksum;
 		struct ice_aqc_pf_vf_msg virt;
@@ -1758,12 +1801,15 @@ enum ice_adminq_opc {
 	/* transmit scheduler commands */
 	ice_aqc_opc_get_dflt_topo			= 0x0400,
 	ice_aqc_opc_add_sched_elems			= 0x0401,
+	ice_aqc_opc_cfg_sched_elems			= 0x0403,
 	ice_aqc_opc_get_sched_elems			= 0x0404,
 	ice_aqc_opc_suspend_sched_elems			= 0x0409,
 	ice_aqc_opc_resume_sched_elems			= 0x040A,
 	ice_aqc_opc_query_port_ets			= 0x040E,
 	ice_aqc_opc_delete_sched_elems			= 0x040F,
+	ice_aqc_opc_add_rl_profiles			= 0x0410,
 	ice_aqc_opc_query_sched_res			= 0x0412,
+	ice_aqc_opc_remove_rl_profiles			= 0x0415,
 
 	/* PHY commands */
 	ice_aqc_opc_get_phy_caps			= 0x0600,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 9972929053aa..3e0d50c1bc7a 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -855,6 +855,9 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 		goto err_unroll_sched;
 	}
 	INIT_LIST_HEAD(&hw->agg_list);
+	/* Initialize max burst size */
+	if (!hw->max_burst_size)
+		ice_cfg_rl_burst_size(hw, ICE_SCHED_DFLT_BURST_SIZE);
 
 	status = ice_init_fltr_mgmt_struct(hw);
 	if (status)
@@ -3260,7 +3263,7 @@ ice_set_ctx(u8 *src_ctx, u8 *dest_ctx, const struct ice_ctx_ele *ce_info)
  * @tc: TC number
  * @q_handle: software queue handle
  */
-static struct ice_q_ctx *
+struct ice_q_ctx *
 ice_get_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 q_handle)
 {
 	struct ice_vsi_ctx *vsi;
@@ -3357,9 +3360,12 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
 	node.node_teid = buf->txqs[0].q_teid;
 	node.data.elem_type = ICE_AQC_ELEM_TYPE_LEAF;
 	q_ctx->q_handle = q_handle;
+	q_ctx->q_teid = le32_to_cpu(node.node_teid);
 
-	/* add a leaf node into schduler tree queue layer */
+	/* add a leaf node into scheduler tree queue layer */
 	status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1, &node);
+	if (!status)
+		status = ice_sched_replay_q_bw(pi, q_ctx);
 
 ena_txq_exit:
 	mutex_unlock(&pi->sched_lock);
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index db9a2d48202f..5a52f3b3e688 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -141,6 +141,8 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
 enum ice_status ice_replay_vsi(struct ice_hw *hw, u16 vsi_handle);
 void ice_replay_post(struct ice_hw *hw);
 void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf);
+struct ice_q_ctx *
+ice_get_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 q_handle);
 void
 ice_stat_update40(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index baea28c712ee..c00c68bacadb 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -101,6 +101,16 @@ u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg *dcbcfg)
 	return ret;
 }
 
+/**
+ * ice_dcb_get_tc - Get the TC associated with the queue
+ * @vsi: ptr to the VSI
+ * @queue_index: queue number associated with VSI
+ */
+u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index)
+{
+	return vsi->tx_rings[queue_index]->dcb_tc;
+}
+
 /**
  * ice_vsi_cfg_dcb_rings - Update rings to reflect DCB TC
  * @vsi: VSI owner of rings being updated
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index d11a0aab01ac..59e40cf2dd73 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -14,6 +14,7 @@
 void ice_dcb_rebuild(struct ice_pf *pf);
 u8 ice_dcb_get_ena_tc(struct ice_dcbx_cfg *dcbcfg);
 u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg *dcbcfg);
+u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
@@ -42,6 +43,13 @@ static inline u8 ice_dcb_get_num_tc(struct ice_dcbx_cfg __always_unused *dcbcfg)
 	return 1;
 }
 
+static inline u8
+ice_dcb_get_tc(struct ice_vsi __always_unused *vsi,
+	       int __always_unused queue_index)
+{
+	return 0;
+}
+
 static inline int
 ice_init_pf_dcb(struct ice_pf *pf, bool __always_unused locked)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5f3a692f28e6..cacbe2103b28 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3648,6 +3648,48 @@ static void ice_set_rx_mode(struct net_device *netdev)
 	ice_service_task_schedule(vsi->back);
 }
 
+/**
+ * ice_set_tx_maxrate - NDO callback to set the maximum per-queue bitrate
+ * @netdev: network interface device structure
+ * @queue_index: Queue ID
+ * @maxrate: maximum bandwidth in Mbps
+ */
+static int
+ice_set_tx_maxrate(struct net_device *netdev, int queue_index, u32 maxrate)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	enum ice_status status;
+	u16 q_handle;
+	u8 tc;
+
+	/* Validate maxrate requested is within permitted range */
+	if (maxrate && (maxrate > (ICE_SCHED_MAX_BW / 1000))) {
+		netdev_err(netdev,
+			   "Invalid max rate %d specified for the queue %d\n",
+			   maxrate, queue_index);
+		return -EINVAL;
+	}
+
+	q_handle = vsi->tx_rings[queue_index]->q_handle;
+	tc = ice_dcb_get_tc(vsi, queue_index);
+
+	/* Set BW back to default, when user set maxrate to 0 */
+	if (!maxrate)
+		status = ice_cfg_q_bw_dflt_lmt(vsi->port_info, vsi->idx, tc,
+					       q_handle, ICE_MAX_BW);
+	else
+		status = ice_cfg_q_bw_lmt(vsi->port_info, vsi->idx, tc,
+					  q_handle, ICE_MAX_BW, maxrate * 1000);
+	if (status) {
+		netdev_err(netdev,
+			   "Unable to set Tx max rate, error %d\n", status);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /**
  * ice_fdb_add - add an entry to the hardware database
  * @ndm: the input from the stack
@@ -5159,6 +5201,7 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_change_mtu = ice_change_mtu,
 	.ndo_get_stats64 = ice_get_stats64,
+	.ndo_set_tx_maxrate = ice_set_tx_maxrate,
 	.ndo_set_vf_spoofchk = ice_set_vf_spoofchk,
 	.ndo_set_vf_mac = ice_set_vf_mac,
 	.ndo_get_vf_config = ice_get_vf_cfg,
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index fc624b73d05d..6f8a83f92c8d 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -410,6 +410,27 @@ ice_aq_add_sched_elems(struct ice_hw *hw, u16 grps_req,
 					   grps_added, cd);
 }
 
+/**
+ * ice_aq_cfg_sched_elems - configures scheduler elements
+ * @hw: pointer to the HW struct
+ * @elems_req: number of elements to configure
+ * @buf: pointer to buffer
+ * @buf_size: buffer size in bytes
+ * @elems_cfgd: returns total number of elements configured
+ * @cd: pointer to command details structure or NULL
+ *
+ * Configure scheduling elements (0x0403)
+ */
+static enum ice_status
+ice_aq_cfg_sched_elems(struct ice_hw *hw, u16 elems_req,
+		       struct ice_aqc_conf_elem *buf, u16 buf_size,
+		       u16 *elems_cfgd, struct ice_sq_cd *cd)
+{
+	return ice_aqc_send_sched_elem_cmd(hw, ice_aqc_opc_cfg_sched_elems,
+					   elems_req, (void *)buf, buf_size,
+					   elems_cfgd, cd);
+}
+
 /**
  * ice_aq_suspend_sched_elems - suspend scheduler elements
  * @hw: pointer to the HW struct
@@ -556,6 +577,149 @@ ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
 	return 0;
 }
 
+/**
+ * ice_aq_rl_profile - performs a rate limiting task
+ * @hw: pointer to the HW struct
+ * @opcode:opcode for add, query, or remove profile(s)
+ * @num_profiles: the number of profiles
+ * @buf: pointer to buffer
+ * @buf_size: buffer size in bytes
+ * @num_processed: number of processed add or remove profile(s) to return
+ * @cd: pointer to command details structure
+ *
+ * RL profile function to add, query, or remove profile(s)
+ */
+static enum ice_status
+ice_aq_rl_profile(struct ice_hw *hw, enum ice_adminq_opc opcode,
+		  u16 num_profiles, struct ice_aqc_rl_profile_generic_elem *buf,
+		  u16 buf_size, u16 *num_processed, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_rl_profile *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	cmd = &desc.params.rl_profile;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, opcode);
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+	cmd->num_profiles = cpu_to_le16(num_profiles);
+	status = ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
+	if (!status && num_processed)
+		*num_processed = le16_to_cpu(cmd->num_processed);
+	return status;
+}
+
+/**
+ * ice_aq_add_rl_profile - adds rate limiting profile(s)
+ * @hw: pointer to the HW struct
+ * @num_profiles: the number of profile(s) to be add
+ * @buf: pointer to buffer
+ * @buf_size: buffer size in bytes
+ * @num_profiles_added: total number of profiles added to return
+ * @cd: pointer to command details structure
+ *
+ * Add RL profile (0x0410)
+ */
+static enum ice_status
+ice_aq_add_rl_profile(struct ice_hw *hw, u16 num_profiles,
+		      struct ice_aqc_rl_profile_generic_elem *buf,
+		      u16 buf_size, u16 *num_profiles_added,
+		      struct ice_sq_cd *cd)
+{
+	return ice_aq_rl_profile(hw, ice_aqc_opc_add_rl_profiles,
+				 num_profiles, buf,
+				 buf_size, num_profiles_added, cd);
+}
+
+/**
+ * ice_aq_remove_rl_profile - removes RL profile(s)
+ * @hw: pointer to the HW struct
+ * @num_profiles: the number of profile(s) to remove
+ * @buf: pointer to buffer
+ * @buf_size: buffer size in bytes
+ * @num_profiles_removed: total number of profiles removed to return
+ * @cd: pointer to command details structure or NULL
+ *
+ * Remove RL profile (0x0415)
+ */
+static enum ice_status
+ice_aq_remove_rl_profile(struct ice_hw *hw, u16 num_profiles,
+			 struct ice_aqc_rl_profile_generic_elem *buf,
+			 u16 buf_size, u16 *num_profiles_removed,
+			 struct ice_sq_cd *cd)
+{
+	return ice_aq_rl_profile(hw, ice_aqc_opc_remove_rl_profiles,
+				 num_profiles, buf,
+				 buf_size, num_profiles_removed, cd);
+}
+
+/**
+ * ice_sched_del_rl_profile - remove RL profile
+ * @hw: pointer to the HW struct
+ * @rl_info: rate limit profile information
+ *
+ * If the profile ID is not referenced anymore, it removes profile ID with
+ * its associated parameters from HW DB,and locally. The caller needs to
+ * hold scheduler lock.
+ */
+static enum ice_status
+ice_sched_del_rl_profile(struct ice_hw *hw,
+			 struct ice_aqc_rl_profile_info *rl_info)
+{
+	struct ice_aqc_rl_profile_generic_elem *buf;
+	u16 num_profiles_removed;
+	enum ice_status status;
+	u16 num_profiles = 1;
+
+	if (rl_info->prof_id_ref != 0)
+		return ICE_ERR_IN_USE;
+
+	/* Safe to remove profile ID */
+	buf = (struct ice_aqc_rl_profile_generic_elem *)
+		&rl_info->profile;
+	status = ice_aq_remove_rl_profile(hw, num_profiles, buf, sizeof(*buf),
+					  &num_profiles_removed, NULL);
+	if (status || num_profiles_removed != num_profiles)
+		return ICE_ERR_CFG;
+
+	/* Delete stale entry now */
+	list_del(&rl_info->list_entry);
+	devm_kfree(ice_hw_to_dev(hw), rl_info);
+	return status;
+}
+
+/**
+ * ice_sched_clear_rl_prof - clears RL prof entries
+ * @pi: port information structure
+ *
+ * This function removes all RL profile from HW as well as from SW DB.
+ */
+static void ice_sched_clear_rl_prof(struct ice_port_info *pi)
+{
+	u16 ln;
+
+	for (ln = 0; ln < pi->hw->num_tx_sched_layers; ln++) {
+		struct ice_aqc_rl_profile_info *rl_prof_elem;
+		struct ice_aqc_rl_profile_info *rl_prof_tmp;
+
+		list_for_each_entry_safe(rl_prof_elem, rl_prof_tmp,
+					 &pi->rl_prof_list[ln], list_entry) {
+			struct ice_hw *hw = pi->hw;
+			enum ice_status status;
+
+			rl_prof_elem->prof_id_ref = 0;
+			status = ice_sched_del_rl_profile(hw, rl_prof_elem);
+			if (status) {
+				ice_debug(hw, ICE_DBG_SCHED,
+					  "Remove rl profile failed\n");
+				/* On error, free mem required */
+				list_del(&rl_prof_elem->list_entry);
+				devm_kfree(ice_hw_to_dev(hw), rl_prof_elem);
+			}
+		}
+	}
+}
+
 /**
  * ice_sched_clear_agg - clears the aggregator related information
  * @hw: pointer to the hardware structure
@@ -592,6 +756,8 @@ static void ice_sched_clear_tx_topo(struct ice_port_info *pi)
 {
 	if (!pi)
 		return;
+	/* remove RL profiles related lists */
+	ice_sched_clear_rl_prof(pi);
 	if (pi->root) {
 		ice_free_sched_node(pi, pi->root);
 		pi->root = NULL;
@@ -1014,6 +1180,8 @@ enum ice_status ice_sched_init_port(struct ice_port_info *pi)
 	/* initialize the port for handling the scheduler tree */
 	pi->port_state = ICE_SCHED_PORT_STATE_READY;
 	mutex_init(&pi->sched_lock);
+	for (i = 0; i < ICE_AQC_TOPO_MAX_LEVEL_NUM; i++)
+		INIT_LIST_HEAD(&pi->rl_prof_list[i]);
 
 err_init_port:
 	if (status && pi->root) {
@@ -1062,8 +1230,8 @@ enum ice_status ice_sched_query_res_alloc(struct ice_hw *hw)
 	 * and so on. This array will be populated from root (index 0) to
 	 * qgroup layer 7. Leaf node has no children.
 	 */
-	for (i = 0; i < hw->num_tx_sched_layers; i++) {
-		max_sibl = buf->layer_props[i].max_sibl_grp_sz;
+	for (i = 0; i < hw->num_tx_sched_layers - 1; i++) {
+		max_sibl = buf->layer_props[i + 1].max_sibl_grp_sz;
 		hw->max_children[i] = le16_to_cpu(max_sibl);
 	}
 
@@ -1670,3 +1838,1095 @@ enum ice_status ice_rm_vsi_lan_cfg(struct ice_port_info *pi, u16 vsi_handle)
 {
 	return ice_sched_rm_vsi_cfg(pi, vsi_handle, ICE_SCHED_NODE_OWNER_LAN);
 }
+
+/**
+ * ice_sched_rm_unused_rl_prof - remove unused RL profile
+ * @pi: port information structure
+ *
+ * This function removes unused rate limit profiles from the HW and
+ * SW DB. The caller needs to hold scheduler lock.
+ */
+static void ice_sched_rm_unused_rl_prof(struct ice_port_info *pi)
+{
+	u16 ln;
+
+	for (ln = 0; ln < pi->hw->num_tx_sched_layers; ln++) {
+		struct ice_aqc_rl_profile_info *rl_prof_elem;
+		struct ice_aqc_rl_profile_info *rl_prof_tmp;
+
+		list_for_each_entry_safe(rl_prof_elem, rl_prof_tmp,
+					 &pi->rl_prof_list[ln], list_entry) {
+			if (!ice_sched_del_rl_profile(pi->hw, rl_prof_elem))
+				ice_debug(pi->hw, ICE_DBG_SCHED,
+					  "Removed rl profile\n");
+		}
+	}
+}
+
+/**
+ * ice_sched_update_elem - update element
+ * @hw: pointer to the HW struct
+ * @node: pointer to node
+ * @info: node info to update
+ *
+ * It updates the HW DB, and local SW DB of node. It updates the scheduling
+ * parameters of node from argument info data buffer (Info->data buf) and
+ * returns success or error on config sched element failure. The caller
+ * needs to hold scheduler lock.
+ */
+static enum ice_status
+ice_sched_update_elem(struct ice_hw *hw, struct ice_sched_node *node,
+		      struct ice_aqc_txsched_elem_data *info)
+{
+	struct ice_aqc_conf_elem buf;
+	enum ice_status status;
+	u16 elem_cfgd = 0;
+	u16 num_elems = 1;
+
+	buf.generic[0] = *info;
+	/* Parent TEID is reserved field in this aq call */
+	buf.generic[0].parent_teid = 0;
+	/* Element type is reserved field in this aq call */
+	buf.generic[0].data.elem_type = 0;
+	/* Flags is reserved field in this aq call */
+	buf.generic[0].data.flags = 0;
+
+	/* Update HW DB */
+	/* Configure element node */
+	status = ice_aq_cfg_sched_elems(hw, num_elems, &buf, sizeof(buf),
+					&elem_cfgd, NULL);
+	if (status || elem_cfgd != num_elems) {
+		ice_debug(hw, ICE_DBG_SCHED, "Config sched elem error\n");
+		return ICE_ERR_CFG;
+	}
+
+	/* Config success case */
+	/* Now update local SW DB */
+	/* Only copy the data portion of info buffer */
+	node->info.data = info->data;
+	return status;
+}
+
+/**
+ * ice_sched_cfg_node_bw_alloc - configure node BW weight/alloc params
+ * @hw: pointer to the HW struct
+ * @node: sched node to configure
+ * @rl_type: rate limit type CIR, EIR, or shared
+ * @bw_alloc: BW weight/allocation
+ *
+ * This function configures node element's BW allocation.
+ */
+static enum ice_status
+ice_sched_cfg_node_bw_alloc(struct ice_hw *hw, struct ice_sched_node *node,
+			    enum ice_rl_type rl_type, u8 bw_alloc)
+{
+	struct ice_aqc_txsched_elem_data buf;
+	struct ice_aqc_txsched_elem *data;
+	enum ice_status status;
+
+	buf = node->info;
+	data = &buf.data;
+	if (rl_type == ICE_MIN_BW) {
+		data->valid_sections |= ICE_AQC_ELEM_VALID_CIR;
+		data->cir_bw.bw_alloc = cpu_to_le16(bw_alloc);
+	} else if (rl_type == ICE_MAX_BW) {
+		data->valid_sections |= ICE_AQC_ELEM_VALID_EIR;
+		data->eir_bw.bw_alloc = cpu_to_le16(bw_alloc);
+	} else {
+		return ICE_ERR_PARAM;
+	}
+
+	/* Configure element */
+	status = ice_sched_update_elem(hw, node, &buf);
+	return status;
+}
+
+/**
+ * ice_set_clear_cir_bw - set or clear CIR BW
+ * @bw_t_info: bandwidth type information structure
+ * @bw: bandwidth in Kbps - Kilo bits per sec
+ *
+ * Save or clear CIR bandwidth (BW) in the passed param bw_t_info.
+ */
+static void
+ice_set_clear_cir_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
+{
+	if (bw == ICE_SCHED_DFLT_BW) {
+		clear_bit(ICE_BW_TYPE_CIR, bw_t_info->bw_t_bitmap);
+		bw_t_info->cir_bw.bw = 0;
+	} else {
+		/* Save type of BW information */
+		set_bit(ICE_BW_TYPE_CIR, bw_t_info->bw_t_bitmap);
+		bw_t_info->cir_bw.bw = bw;
+	}
+}
+
+/**
+ * ice_set_clear_eir_bw - set or clear EIR BW
+ * @bw_t_info: bandwidth type information structure
+ * @bw: bandwidth in Kbps - Kilo bits per sec
+ *
+ * Save or clear EIR bandwidth (BW) in the passed param bw_t_info.
+ */
+static void
+ice_set_clear_eir_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
+{
+	if (bw == ICE_SCHED_DFLT_BW) {
+		clear_bit(ICE_BW_TYPE_EIR, bw_t_info->bw_t_bitmap);
+		bw_t_info->eir_bw.bw = 0;
+	} else {
+		/* EIR BW and Shared BW profiles are mutually exclusive and
+		 * hence only one of them may be set for any given element.
+		 * First clear earlier saved shared BW information.
+		 */
+		clear_bit(ICE_BW_TYPE_SHARED, bw_t_info->bw_t_bitmap);
+		bw_t_info->shared_bw = 0;
+		/* save EIR BW information */
+		set_bit(ICE_BW_TYPE_EIR, bw_t_info->bw_t_bitmap);
+		bw_t_info->eir_bw.bw = bw;
+	}
+}
+
+/**
+ * ice_set_clear_shared_bw - set or clear shared BW
+ * @bw_t_info: bandwidth type information structure
+ * @bw: bandwidth in Kbps - Kilo bits per sec
+ *
+ * Save or clear shared bandwidth (BW) in the passed param bw_t_info.
+ */
+static void
+ice_set_clear_shared_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
+{
+	if (bw == ICE_SCHED_DFLT_BW) {
+		clear_bit(ICE_BW_TYPE_SHARED, bw_t_info->bw_t_bitmap);
+		bw_t_info->shared_bw = 0;
+	} else {
+		/* EIR BW and Shared BW profiles are mutually exclusive and
+		 * hence only one of them may be set for any given element.
+		 * First clear earlier saved EIR BW information.
+		 */
+		clear_bit(ICE_BW_TYPE_EIR, bw_t_info->bw_t_bitmap);
+		bw_t_info->eir_bw.bw = 0;
+		/* save shared BW information */
+		set_bit(ICE_BW_TYPE_SHARED, bw_t_info->bw_t_bitmap);
+		bw_t_info->shared_bw = bw;
+	}
+}
+
+/**
+ * ice_sched_calc_wakeup - calculate RL profile wakeup parameter
+ * @bw: bandwidth in Kbps
+ *
+ * This function calculates the wakeup parameter of RL profile.
+ */
+static u16 ice_sched_calc_wakeup(s32 bw)
+{
+	s64 bytes_per_sec, wakeup_int, wakeup_a, wakeup_b, wakeup_f;
+	s32 wakeup_f_int;
+	u16 wakeup = 0;
+
+	/* Get the wakeup integer value */
+	bytes_per_sec = div64_long(((s64)bw * 1000), BITS_PER_BYTE);
+	wakeup_int = div64_long(ICE_RL_PROF_FREQUENCY, bytes_per_sec);
+	if (wakeup_int > 63) {
+		wakeup = (u16)((1 << 15) | wakeup_int);
+	} else {
+		/* Calculate fraction value up to 4 decimals
+		 * Convert Integer value to a constant multiplier
+		 */
+		wakeup_b = (s64)ICE_RL_PROF_MULTIPLIER * wakeup_int;
+		wakeup_a = div64_long((s64)ICE_RL_PROF_MULTIPLIER *
+					   ICE_RL_PROF_FREQUENCY,
+				      bytes_per_sec);
+
+		/* Get Fraction value */
+		wakeup_f = wakeup_a - wakeup_b;
+
+		/* Round up the Fractional value via Ceil(Fractional value) */
+		if (wakeup_f > div64_long(ICE_RL_PROF_MULTIPLIER, 2))
+			wakeup_f += 1;
+
+		wakeup_f_int = (s32)div64_long(wakeup_f * ICE_RL_PROF_FRACTION,
+					       ICE_RL_PROF_MULTIPLIER);
+		wakeup |= (u16)(wakeup_int << 9);
+		wakeup |= (u16)(0x1ff & wakeup_f_int);
+	}
+
+	return wakeup;
+}
+
+/**
+ * ice_sched_bw_to_rl_profile - convert BW to profile parameters
+ * @bw: bandwidth in Kbps
+ * @profile: profile parameters to return
+ *
+ * This function converts the BW to profile structure format.
+ */
+static enum ice_status
+ice_sched_bw_to_rl_profile(u32 bw, struct ice_aqc_rl_profile_elem *profile)
+{
+	enum ice_status status = ICE_ERR_PARAM;
+	s64 bytes_per_sec, ts_rate, mv_tmp;
+	bool found = false;
+	s32 encode = 0;
+	s64 mv = 0;
+	s32 i;
+
+	/* Bw settings range is from 0.5Mb/sec to 100Gb/sec */
+	if (bw < ICE_SCHED_MIN_BW || bw > ICE_SCHED_MAX_BW)
+		return status;
+
+	/* Bytes per second from Kbps */
+	bytes_per_sec = div64_long(((s64)bw * 1000), BITS_PER_BYTE);
+
+	/* encode is 6 bits but really useful are 5 bits */
+	for (i = 0; i < 64; i++) {
+		u64 pow_result = BIT_ULL(i);
+
+		ts_rate = div64_long((s64)ICE_RL_PROF_FREQUENCY,
+				     pow_result * ICE_RL_PROF_TS_MULTIPLIER);
+		if (ts_rate <= 0)
+			continue;
+
+		/* Multiplier value */
+		mv_tmp = div64_long(bytes_per_sec * ICE_RL_PROF_MULTIPLIER,
+				    ts_rate);
+
+		/* Round to the nearest ICE_RL_PROF_MULTIPLIER */
+		mv = round_up_64bit(mv_tmp, ICE_RL_PROF_MULTIPLIER);
+
+		/* First multiplier value greater than the given
+		 * accuracy bytes
+		 */
+		if (mv > ICE_RL_PROF_ACCURACY_BYTES) {
+			encode = i;
+			found = true;
+			break;
+		}
+	}
+	if (found) {
+		u16 wm;
+
+		wm = ice_sched_calc_wakeup(bw);
+		profile->rl_multiply = cpu_to_le16(mv);
+		profile->wake_up_calc = cpu_to_le16(wm);
+		profile->rl_encode = cpu_to_le16(encode);
+		status = 0;
+	} else {
+		status = ICE_ERR_DOES_NOT_EXIST;
+	}
+
+	return status;
+}
+
+/**
+ * ice_sched_add_rl_profile - add RL profile
+ * @pi: port information structure
+ * @rl_type: type of rate limit BW - min, max, or shared
+ * @bw: bandwidth in Kbps - Kilo bits per sec
+ * @layer_num: specifies in which layer to create profile
+ *
+ * This function first checks the existing list for corresponding BW
+ * parameter. If it exists, it returns the associated profile otherwise
+ * it creates a new rate limit profile for requested BW, and adds it to
+ * the HW DB and local list. It returns the new profile or null on error.
+ * The caller needs to hold the scheduler lock.
+ */
+static struct ice_aqc_rl_profile_info *
+ice_sched_add_rl_profile(struct ice_port_info *pi,
+			 enum ice_rl_type rl_type, u32 bw, u8 layer_num)
+{
+	struct ice_aqc_rl_profile_generic_elem *buf;
+	struct ice_aqc_rl_profile_info *rl_prof_elem;
+	u16 profiles_added = 0, num_profiles = 1;
+	enum ice_status status;
+	struct ice_hw *hw;
+	u8 profile_type;
+
+	if (layer_num >= ICE_AQC_TOPO_MAX_LEVEL_NUM)
+		return NULL;
+	switch (rl_type) {
+	case ICE_MIN_BW:
+		profile_type = ICE_AQC_RL_PROFILE_TYPE_CIR;
+		break;
+	case ICE_MAX_BW:
+		profile_type = ICE_AQC_RL_PROFILE_TYPE_EIR;
+		break;
+	case ICE_SHARED_BW:
+		profile_type = ICE_AQC_RL_PROFILE_TYPE_SRL;
+		break;
+	default:
+		return NULL;
+	}
+
+	if (!pi)
+		return NULL;
+	hw = pi->hw;
+	list_for_each_entry(rl_prof_elem, &pi->rl_prof_list[layer_num],
+			    list_entry)
+		if (rl_prof_elem->profile.flags == profile_type &&
+		    rl_prof_elem->bw == bw)
+			/* Return existing profile ID info */
+			return rl_prof_elem;
+
+	/* Create new profile ID */
+	rl_prof_elem = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*rl_prof_elem),
+				    GFP_KERNEL);
+
+	if (!rl_prof_elem)
+		return NULL;
+
+	status = ice_sched_bw_to_rl_profile(bw, &rl_prof_elem->profile);
+	if (status)
+		goto exit_add_rl_prof;
+
+	rl_prof_elem->bw = bw;
+	/* layer_num is zero relative, and fw expects level from 1 to 9 */
+	rl_prof_elem->profile.level = layer_num + 1;
+	rl_prof_elem->profile.flags = profile_type;
+	rl_prof_elem->profile.max_burst_size = cpu_to_le16(hw->max_burst_size);
+
+	/* Create new entry in HW DB */
+	buf = (struct ice_aqc_rl_profile_generic_elem *)
+		&rl_prof_elem->profile;
+	status = ice_aq_add_rl_profile(hw, num_profiles, buf, sizeof(*buf),
+				       &profiles_added, NULL);
+	if (status || profiles_added != num_profiles)
+		goto exit_add_rl_prof;
+
+	/* Good entry - add in the list */
+	rl_prof_elem->prof_id_ref = 0;
+	list_add(&rl_prof_elem->list_entry, &pi->rl_prof_list[layer_num]);
+	return rl_prof_elem;
+
+exit_add_rl_prof:
+	devm_kfree(ice_hw_to_dev(hw), rl_prof_elem);
+	return NULL;
+}
+
+/**
+ * ice_sched_cfg_node_bw_lmt - configure node sched params
+ * @hw: pointer to the HW struct
+ * @node: sched node to configure
+ * @rl_type: rate limit type CIR, EIR, or shared
+ * @rl_prof_id: rate limit profile ID
+ *
+ * This function configures node element's BW limit.
+ */
+static enum ice_status
+ice_sched_cfg_node_bw_lmt(struct ice_hw *hw, struct ice_sched_node *node,
+			  enum ice_rl_type rl_type, u16 rl_prof_id)
+{
+	struct ice_aqc_txsched_elem_data buf;
+	struct ice_aqc_txsched_elem *data;
+
+	buf = node->info;
+	data = &buf.data;
+	switch (rl_type) {
+	case ICE_MIN_BW:
+		data->valid_sections |= ICE_AQC_ELEM_VALID_CIR;
+		data->cir_bw.bw_profile_idx = cpu_to_le16(rl_prof_id);
+		break;
+	case ICE_MAX_BW:
+		/* EIR BW and Shared BW profiles are mutually exclusive and
+		 * hence only one of them may be set for any given element
+		 */
+		if (data->valid_sections & ICE_AQC_ELEM_VALID_SHARED)
+			return ICE_ERR_CFG;
+		data->valid_sections |= ICE_AQC_ELEM_VALID_EIR;
+		data->eir_bw.bw_profile_idx = cpu_to_le16(rl_prof_id);
+		break;
+	case ICE_SHARED_BW:
+		/* Check for removing shared BW */
+		if (rl_prof_id == ICE_SCHED_NO_SHARED_RL_PROF_ID) {
+			/* remove shared profile */
+			data->valid_sections &= ~ICE_AQC_ELEM_VALID_SHARED;
+			data->srl_id = 0; /* clear SRL field */
+
+			/* enable back EIR to default profile */
+			data->valid_sections |= ICE_AQC_ELEM_VALID_EIR;
+			data->eir_bw.bw_profile_idx =
+				cpu_to_le16(ICE_SCHED_DFLT_RL_PROF_ID);
+			break;
+		}
+		/* EIR BW and Shared BW profiles are mutually exclusive and
+		 * hence only one of them may be set for any given element
+		 */
+		if ((data->valid_sections & ICE_AQC_ELEM_VALID_EIR) &&
+		    (le16_to_cpu(data->eir_bw.bw_profile_idx) !=
+			    ICE_SCHED_DFLT_RL_PROF_ID))
+			return ICE_ERR_CFG;
+		/* EIR BW is set to default, disable it */
+		data->valid_sections &= ~ICE_AQC_ELEM_VALID_EIR;
+		/* Okay to enable shared BW now */
+		data->valid_sections |= ICE_AQC_ELEM_VALID_SHARED;
+		data->srl_id = cpu_to_le16(rl_prof_id);
+		break;
+	default:
+		/* Unknown rate limit type */
+		return ICE_ERR_PARAM;
+	}
+
+	/* Configure element */
+	return ice_sched_update_elem(hw, node, &buf);
+}
+
+/**
+ * ice_sched_get_node_rl_prof_id - get node's rate limit profile ID
+ * @node: sched node
+ * @rl_type: rate limit type
+ *
+ * If existing profile matches, it returns the corresponding rate
+ * limit profile ID, otherwise it returns an invalid ID as error.
+ */
+static u16
+ice_sched_get_node_rl_prof_id(struct ice_sched_node *node,
+			      enum ice_rl_type rl_type)
+{
+	u16 rl_prof_id = ICE_SCHED_INVAL_PROF_ID;
+	struct ice_aqc_txsched_elem *data;
+
+	data = &node->info.data;
+	switch (rl_type) {
+	case ICE_MIN_BW:
+		if (data->valid_sections & ICE_AQC_ELEM_VALID_CIR)
+			rl_prof_id = le16_to_cpu(data->cir_bw.bw_profile_idx);
+		break;
+	case ICE_MAX_BW:
+		if (data->valid_sections & ICE_AQC_ELEM_VALID_EIR)
+			rl_prof_id = le16_to_cpu(data->eir_bw.bw_profile_idx);
+		break;
+	case ICE_SHARED_BW:
+		if (data->valid_sections & ICE_AQC_ELEM_VALID_SHARED)
+			rl_prof_id = le16_to_cpu(data->srl_id);
+		break;
+	default:
+		break;
+	}
+
+	return rl_prof_id;
+}
+
+/**
+ * ice_sched_get_rl_prof_layer - selects rate limit profile creation layer
+ * @pi: port information structure
+ * @rl_type: type of rate limit BW - min, max, or shared
+ * @layer_index: layer index
+ *
+ * This function returns requested profile creation layer.
+ */
+static u8
+ice_sched_get_rl_prof_layer(struct ice_port_info *pi, enum ice_rl_type rl_type,
+			    u8 layer_index)
+{
+	struct ice_hw *hw = pi->hw;
+
+	if (layer_index >= hw->num_tx_sched_layers)
+		return ICE_SCHED_INVAL_LAYER_NUM;
+	switch (rl_type) {
+	case ICE_MIN_BW:
+		if (hw->layer_info[layer_index].max_cir_rl_profiles)
+			return layer_index;
+		break;
+	case ICE_MAX_BW:
+		if (hw->layer_info[layer_index].max_eir_rl_profiles)
+			return layer_index;
+		break;
+	case ICE_SHARED_BW:
+		/* if current layer doesn't support SRL profile creation
+		 * then try a layer up or down.
+		 */
+		if (hw->layer_info[layer_index].max_srl_profiles)
+			return layer_index;
+		else if (layer_index < hw->num_tx_sched_layers - 1 &&
+			 hw->layer_info[layer_index + 1].max_srl_profiles)
+			return layer_index + 1;
+		else if (layer_index > 0 &&
+			 hw->layer_info[layer_index - 1].max_srl_profiles)
+			return layer_index - 1;
+		break;
+	default:
+		break;
+	}
+	return ICE_SCHED_INVAL_LAYER_NUM;
+}
+
+/**
+ * ice_sched_get_srl_node - get shared rate limit node
+ * @node: tree node
+ * @srl_layer: shared rate limit layer
+ *
+ * This function returns SRL node to be used for shared rate limit purpose.
+ * The caller needs to hold scheduler lock.
+ */
+static struct ice_sched_node *
+ice_sched_get_srl_node(struct ice_sched_node *node, u8 srl_layer)
+{
+	if (srl_layer > node->tx_sched_layer)
+		return node->children[0];
+	else if (srl_layer < node->tx_sched_layer)
+		/* Node can't be created without a parent. It will always
+		 * have a valid parent except root node.
+		 */
+		return node->parent;
+	else
+		return node;
+}
+
+/**
+ * ice_sched_rm_rl_profile - remove RL profile ID
+ * @pi: port information structure
+ * @layer_num: layer number where profiles are saved
+ * @profile_type: profile type like EIR, CIR, or SRL
+ * @profile_id: profile ID to remove
+ *
+ * This function removes rate limit profile from layer 'layer_num' of type
+ * 'profile_type' and profile ID as 'profile_id'. The caller needs to hold
+ * scheduler lock.
+ */
+static enum ice_status
+ice_sched_rm_rl_profile(struct ice_port_info *pi, u8 layer_num, u8 profile_type,
+			u16 profile_id)
+{
+	struct ice_aqc_rl_profile_info *rl_prof_elem;
+	enum ice_status status = 0;
+
+	if (layer_num >= ICE_AQC_TOPO_MAX_LEVEL_NUM)
+		return ICE_ERR_PARAM;
+	/* Check the existing list for RL profile */
+	list_for_each_entry(rl_prof_elem, &pi->rl_prof_list[layer_num],
+			    list_entry)
+		if (rl_prof_elem->profile.flags == profile_type &&
+		    le16_to_cpu(rl_prof_elem->profile.profile_id) ==
+		    profile_id) {
+			if (rl_prof_elem->prof_id_ref)
+				rl_prof_elem->prof_id_ref--;
+
+			/* Remove old profile ID from database */
+			status = ice_sched_del_rl_profile(pi->hw, rl_prof_elem);
+			if (status && status != ICE_ERR_IN_USE)
+				ice_debug(pi->hw, ICE_DBG_SCHED,
+					  "Remove rl profile failed\n");
+			break;
+		}
+	if (status == ICE_ERR_IN_USE)
+		status = 0;
+	return status;
+}
+
+/**
+ * ice_sched_set_node_bw_dflt - set node's bandwidth limit to default
+ * @pi: port information structure
+ * @node: pointer to node structure
+ * @rl_type: rate limit type min, max, or shared
+ * @layer_num: layer number where RL profiles are saved
+ *
+ * This function configures node element's BW rate limit profile ID of
+ * type CIR, EIR, or SRL to default. This function needs to be called
+ * with the scheduler lock held.
+ */
+static enum ice_status
+ice_sched_set_node_bw_dflt(struct ice_port_info *pi,
+			   struct ice_sched_node *node,
+			   enum ice_rl_type rl_type, u8 layer_num)
+{
+	enum ice_status status;
+	struct ice_hw *hw;
+	u8 profile_type;
+	u16 rl_prof_id;
+	u16 old_id;
+
+	hw = pi->hw;
+	switch (rl_type) {
+	case ICE_MIN_BW:
+		profile_type = ICE_AQC_RL_PROFILE_TYPE_CIR;
+		rl_prof_id = ICE_SCHED_DFLT_RL_PROF_ID;
+		break;
+	case ICE_MAX_BW:
+		profile_type = ICE_AQC_RL_PROFILE_TYPE_EIR;
+		rl_prof_id = ICE_SCHED_DFLT_RL_PROF_ID;
+		break;
+	case ICE_SHARED_BW:
+		profile_type = ICE_AQC_RL_PROFILE_TYPE_SRL;
+		/* No SRL is configured for default case */
+		rl_prof_id = ICE_SCHED_NO_SHARED_RL_PROF_ID;
+		break;
+	default:
+		return ICE_ERR_PARAM;
+	}
+	/* Save existing RL prof ID for later clean up */
+	old_id = ice_sched_get_node_rl_prof_id(node, rl_type);
+	/* Configure BW scheduling parameters */
+	status = ice_sched_cfg_node_bw_lmt(hw, node, rl_type, rl_prof_id);
+	if (status)
+		return status;
+
+	/* Remove stale RL profile ID */
+	if (old_id == ICE_SCHED_DFLT_RL_PROF_ID ||
+	    old_id == ICE_SCHED_INVAL_PROF_ID)
+		return 0;
+
+	return ice_sched_rm_rl_profile(pi, layer_num, profile_type, old_id);
+}
+
+/**
+ * ice_sched_set_eir_srl_excl - set EIR/SRL exclusiveness
+ * @pi: port information structure
+ * @node: pointer to node structure
+ * @layer_num: layer number where rate limit profiles are saved
+ * @rl_type: rate limit type min, max, or shared
+ * @bw: bandwidth value
+ *
+ * This function prepares node element's bandwidth to SRL or EIR exclusively.
+ * EIR BW and Shared BW profiles are mutually exclusive and hence only one of
+ * them may be set for any given element. This function needs to be called
+ * with the scheduler lock held.
+ */
+static enum ice_status
+ice_sched_set_eir_srl_excl(struct ice_port_info *pi,
+			   struct ice_sched_node *node,
+			   u8 layer_num, enum ice_rl_type rl_type, u32 bw)
+{
+	if (rl_type == ICE_SHARED_BW) {
+		/* SRL node passed in this case, it may be different node */
+		if (bw == ICE_SCHED_DFLT_BW)
+			/* SRL being removed, ice_sched_cfg_node_bw_lmt()
+			 * enables EIR to default. EIR is not set in this
+			 * case, so no additional action is required.
+			 */
+			return 0;
+
+		/* SRL being configured, set EIR to default here.
+		 * ice_sched_cfg_node_bw_lmt() disables EIR when it
+		 * configures SRL
+		 */
+		return ice_sched_set_node_bw_dflt(pi, node, ICE_MAX_BW,
+						  layer_num);
+	} else if (rl_type == ICE_MAX_BW &&
+		   node->info.data.valid_sections & ICE_AQC_ELEM_VALID_SHARED) {
+		/* Remove Shared profile. Set default shared BW call
+		 * removes shared profile for a node.
+		 */
+		return ice_sched_set_node_bw_dflt(pi, node,
+						  ICE_SHARED_BW,
+						  layer_num);
+	}
+	return 0;
+}
+
+/**
+ * ice_sched_set_node_bw - set node's bandwidth
+ * @pi: port information structure
+ * @node: tree node
+ * @rl_type: rate limit type min, max, or shared
+ * @bw: bandwidth in Kbps - Kilo bits per sec
+ * @layer_num: layer number
+ *
+ * This function adds new profile corresponding to requested BW, configures
+ * node's RL profile ID of type CIR, EIR, or SRL, and removes old profile
+ * ID from local database. The caller needs to hold scheduler lock.
+ */
+static enum ice_status
+ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
+		      enum ice_rl_type rl_type, u32 bw, u8 layer_num)
+{
+	struct ice_aqc_rl_profile_info *rl_prof_info;
+	enum ice_status status = ICE_ERR_PARAM;
+	struct ice_hw *hw = pi->hw;
+	u16 old_id, rl_prof_id;
+
+	rl_prof_info = ice_sched_add_rl_profile(pi, rl_type, bw, layer_num);
+	if (!rl_prof_info)
+		return status;
+
+	rl_prof_id = le16_to_cpu(rl_prof_info->profile.profile_id);
+
+	/* Save existing RL prof ID for later clean up */
+	old_id = ice_sched_get_node_rl_prof_id(node, rl_type);
+	/* Configure BW scheduling parameters */
+	status = ice_sched_cfg_node_bw_lmt(hw, node, rl_type, rl_prof_id);
+	if (status)
+		return status;
+
+	/* New changes has been applied */
+	/* Increment the profile ID reference count */
+	rl_prof_info->prof_id_ref++;
+
+	/* Check for old ID removal */
+	if ((old_id == ICE_SCHED_DFLT_RL_PROF_ID && rl_type != ICE_SHARED_BW) ||
+	    old_id == ICE_SCHED_INVAL_PROF_ID || old_id == rl_prof_id)
+		return 0;
+
+	return ice_sched_rm_rl_profile(pi, layer_num,
+				       rl_prof_info->profile.flags,
+				       old_id);
+}
+
+/**
+ * ice_sched_set_node_bw_lmt - set node's BW limit
+ * @pi: port information structure
+ * @node: tree node
+ * @rl_type: rate limit type min, max, or shared
+ * @bw: bandwidth in Kbps - Kilo bits per sec
+ *
+ * It updates node's BW limit parameters like BW RL profile ID of type CIR,
+ * EIR, or SRL. The caller needs to hold scheduler lock.
+ */
+static enum ice_status
+ice_sched_set_node_bw_lmt(struct ice_port_info *pi, struct ice_sched_node *node,
+			  enum ice_rl_type rl_type, u32 bw)
+{
+	struct ice_sched_node *cfg_node = node;
+	enum ice_status status;
+
+	struct ice_hw *hw;
+	u8 layer_num;
+
+	if (!pi)
+		return ICE_ERR_PARAM;
+	hw = pi->hw;
+	/* Remove unused RL profile IDs from HW and SW DB */
+	ice_sched_rm_unused_rl_prof(pi);
+	layer_num = ice_sched_get_rl_prof_layer(pi, rl_type,
+						node->tx_sched_layer);
+	if (layer_num >= hw->num_tx_sched_layers)
+		return ICE_ERR_PARAM;
+
+	if (rl_type == ICE_SHARED_BW) {
+		/* SRL node may be different */
+		cfg_node = ice_sched_get_srl_node(node, layer_num);
+		if (!cfg_node)
+			return ICE_ERR_CFG;
+	}
+	/* EIR BW and Shared BW profiles are mutually exclusive and
+	 * hence only one of them may be set for any given element
+	 */
+	status = ice_sched_set_eir_srl_excl(pi, cfg_node, layer_num, rl_type,
+					    bw);
+	if (status)
+		return status;
+	if (bw == ICE_SCHED_DFLT_BW)
+		return ice_sched_set_node_bw_dflt(pi, cfg_node, rl_type,
+						  layer_num);
+	return ice_sched_set_node_bw(pi, cfg_node, rl_type, bw, layer_num);
+}
+
+/**
+ * ice_sched_set_node_bw_dflt_lmt - set node's BW limit to default
+ * @pi: port information structure
+ * @node: pointer to node structure
+ * @rl_type: rate limit type min, max, or shared
+ *
+ * This function configures node element's BW rate limit profile ID of
+ * type CIR, EIR, or SRL to default. This function needs to be called
+ * with the scheduler lock held.
+ */
+static enum ice_status
+ice_sched_set_node_bw_dflt_lmt(struct ice_port_info *pi,
+			       struct ice_sched_node *node,
+			       enum ice_rl_type rl_type)
+{
+	return ice_sched_set_node_bw_lmt(pi, node, rl_type,
+					 ICE_SCHED_DFLT_BW);
+}
+
+/**
+ * ice_sched_validate_srl_node - Check node for SRL applicability
+ * @node: sched node to configure
+ * @sel_layer: selected SRL layer
+ *
+ * This function checks if the SRL can be applied to a selected layer node on
+ * behalf of the requested node (first argument). This function needs to be
+ * called with scheduler lock held.
+ */
+static enum ice_status
+ice_sched_validate_srl_node(struct ice_sched_node *node, u8 sel_layer)
+{
+	/* SRL profiles are not available on all layers. Check if the
+	 * SRL profile can be applied to a node above or below the
+	 * requested node. SRL configuration is possible only if the
+	 * selected layer's node has single child.
+	 */
+	if (sel_layer == node->tx_sched_layer ||
+	    ((sel_layer == node->tx_sched_layer + 1) &&
+	    node->num_children == 1) ||
+	    ((sel_layer == node->tx_sched_layer - 1) &&
+	    (node->parent && node->parent->num_children == 1)))
+		return 0;
+
+	return ICE_ERR_CFG;
+}
+
+/**
+ * ice_sched_save_q_bw - save queue node's BW information
+ * @q_ctx: queue context structure
+ * @rl_type: rate limit type min, max, or shared
+ * @bw: bandwidth in Kbps - Kilo bits per sec
+ *
+ * Save BW information of queue type node for post replay use.
+ */
+static enum ice_status
+ice_sched_save_q_bw(struct ice_q_ctx *q_ctx, enum ice_rl_type rl_type, u32 bw)
+{
+	switch (rl_type) {
+	case ICE_MIN_BW:
+		ice_set_clear_cir_bw(&q_ctx->bw_t_info, bw);
+		break;
+	case ICE_MAX_BW:
+		ice_set_clear_eir_bw(&q_ctx->bw_t_info, bw);
+		break;
+	case ICE_SHARED_BW:
+		ice_set_clear_shared_bw(&q_ctx->bw_t_info, bw);
+		break;
+	default:
+		return ICE_ERR_PARAM;
+	}
+	return 0;
+}
+
+/**
+ * ice_sched_set_q_bw_lmt - sets queue BW limit
+ * @pi: port information structure
+ * @vsi_handle: sw VSI handle
+ * @tc: traffic class
+ * @q_handle: software queue handle
+ * @rl_type: min, max, or shared
+ * @bw: bandwidth in Kbps
+ *
+ * This function sets BW limit of queue scheduling node.
+ */
+static enum ice_status
+ice_sched_set_q_bw_lmt(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
+		       u16 q_handle, enum ice_rl_type rl_type, u32 bw)
+{
+	enum ice_status status = ICE_ERR_PARAM;
+	struct ice_sched_node *node;
+	struct ice_q_ctx *q_ctx;
+
+	if (!ice_is_vsi_valid(pi->hw, vsi_handle))
+		return ICE_ERR_PARAM;
+	mutex_lock(&pi->sched_lock);
+	q_ctx = ice_get_lan_q_ctx(pi->hw, vsi_handle, tc, q_handle);
+	if (!q_ctx)
+		goto exit_q_bw_lmt;
+	node = ice_sched_find_node_by_teid(pi->root, q_ctx->q_teid);
+	if (!node) {
+		ice_debug(pi->hw, ICE_DBG_SCHED, "Wrong q_teid\n");
+		goto exit_q_bw_lmt;
+	}
+
+	/* Return error if it is not a leaf node */
+	if (node->info.data.elem_type != ICE_AQC_ELEM_TYPE_LEAF)
+		goto exit_q_bw_lmt;
+
+	/* SRL bandwidth layer selection */
+	if (rl_type == ICE_SHARED_BW) {
+		u8 sel_layer; /* selected layer */
+
+		sel_layer = ice_sched_get_rl_prof_layer(pi, rl_type,
+							node->tx_sched_layer);
+		if (sel_layer >= pi->hw->num_tx_sched_layers) {
+			status = ICE_ERR_PARAM;
+			goto exit_q_bw_lmt;
+		}
+		status = ice_sched_validate_srl_node(node, sel_layer);
+		if (status)
+			goto exit_q_bw_lmt;
+	}
+
+	if (bw == ICE_SCHED_DFLT_BW)
+		status = ice_sched_set_node_bw_dflt_lmt(pi, node, rl_type);
+	else
+		status = ice_sched_set_node_bw_lmt(pi, node, rl_type, bw);
+
+	if (!status)
+		status = ice_sched_save_q_bw(q_ctx, rl_type, bw);
+
+exit_q_bw_lmt:
+	mutex_unlock(&pi->sched_lock);
+	return status;
+}
+
+/**
+ * ice_cfg_q_bw_lmt - configure queue BW limit
+ * @pi: port information structure
+ * @vsi_handle: sw VSI handle
+ * @tc: traffic class
+ * @q_handle: software queue handle
+ * @rl_type: min, max, or shared
+ * @bw: bandwidth in Kbps
+ *
+ * This function configures BW limit of queue scheduling node.
+ */
+enum ice_status
+ice_cfg_q_bw_lmt(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
+		 u16 q_handle, enum ice_rl_type rl_type, u32 bw)
+{
+	return ice_sched_set_q_bw_lmt(pi, vsi_handle, tc, q_handle, rl_type,
+				      bw);
+}
+
+/**
+ * ice_cfg_q_bw_dflt_lmt - configure queue BW default limit
+ * @pi: port information structure
+ * @vsi_handle: sw VSI handle
+ * @tc: traffic class
+ * @q_handle: software queue handle
+ * @rl_type: min, max, or shared
+ *
+ * This function configures BW default limit of queue scheduling node.
+ */
+enum ice_status
+ice_cfg_q_bw_dflt_lmt(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
+		      u16 q_handle, enum ice_rl_type rl_type)
+{
+	return ice_sched_set_q_bw_lmt(pi, vsi_handle, tc, q_handle, rl_type,
+				      ICE_SCHED_DFLT_BW);
+}
+
+/**
+ * ice_cfg_rl_burst_size - Set burst size value
+ * @hw: pointer to the HW struct
+ * @bytes: burst size in bytes
+ *
+ * This function configures/set the burst size to requested new value. The new
+ * burst size value is used for future rate limit calls. It doesn't change the
+ * existing or previously created RL profiles.
+ */
+enum ice_status ice_cfg_rl_burst_size(struct ice_hw *hw, u32 bytes)
+{
+	u16 burst_size_to_prog;
+
+	if (bytes < ICE_MIN_BURST_SIZE_ALLOWED ||
+	    bytes > ICE_MAX_BURST_SIZE_ALLOWED)
+		return ICE_ERR_PARAM;
+	if (ice_round_to_num(bytes, 64) <=
+	    ICE_MAX_BURST_SIZE_64_BYTE_GRANULARITY) {
+		/* 64 byte granularity case */
+		/* Disable MSB granularity bit */
+		burst_size_to_prog = ICE_64_BYTE_GRANULARITY;
+		/* round number to nearest 64 byte granularity */
+		bytes = ice_round_to_num(bytes, 64);
+		/* The value is in 64 byte chunks */
+		burst_size_to_prog |= (u16)(bytes / 64);
+	} else {
+		/* k bytes granularity case */
+		/* Enable MSB granularity bit */
+		burst_size_to_prog = ICE_KBYTE_GRANULARITY;
+		/* round number to nearest 1024 granularity */
+		bytes = ice_round_to_num(bytes, 1024);
+		/* check rounding doesn't go beyond allowed */
+		if (bytes > ICE_MAX_BURST_SIZE_KBYTE_GRANULARITY)
+			bytes = ICE_MAX_BURST_SIZE_KBYTE_GRANULARITY;
+		/* The value is in k bytes */
+		burst_size_to_prog |= (u16)(bytes / 1024);
+	}
+	hw->max_burst_size = burst_size_to_prog;
+	return 0;
+}
+
+/**
+ * ice_sched_replay_node_prio - re-configure node priority
+ * @hw: pointer to the HW struct
+ * @node: sched node to configure
+ * @priority: priority value
+ *
+ * This function configures node element's priority value. It
+ * needs to be called with scheduler lock held.
+ */
+static enum ice_status
+ice_sched_replay_node_prio(struct ice_hw *hw, struct ice_sched_node *node,
+			   u8 priority)
+{
+	struct ice_aqc_txsched_elem_data buf;
+	struct ice_aqc_txsched_elem *data;
+	enum ice_status status;
+
+	buf = node->info;
+	data = &buf.data;
+	data->valid_sections |= ICE_AQC_ELEM_VALID_GENERIC;
+	data->generic = priority;
+
+	/* Configure element */
+	status = ice_sched_update_elem(hw, node, &buf);
+	return status;
+}
+
+/**
+ * ice_sched_replay_node_bw - replay node(s) BW
+ * @hw: pointer to the HW struct
+ * @node: sched node to configure
+ * @bw_t_info: BW type information
+ *
+ * This function restores node's BW from bw_t_info. The caller needs
+ * to hold the scheduler lock.
+ */
+static enum ice_status
+ice_sched_replay_node_bw(struct ice_hw *hw, struct ice_sched_node *node,
+			 struct ice_bw_type_info *bw_t_info)
+{
+	struct ice_port_info *pi = hw->port_info;
+	enum ice_status status = ICE_ERR_PARAM;
+	u16 bw_alloc;
+
+	if (!node)
+		return status;
+	if (bitmap_empty(bw_t_info->bw_t_bitmap, ICE_BW_TYPE_CNT))
+		return 0;
+	if (test_bit(ICE_BW_TYPE_PRIO, bw_t_info->bw_t_bitmap)) {
+		status = ice_sched_replay_node_prio(hw, node,
+						    bw_t_info->generic);
+		if (status)
+			return status;
+	}
+	if (test_bit(ICE_BW_TYPE_CIR, bw_t_info->bw_t_bitmap)) {
+		status = ice_sched_set_node_bw_lmt(pi, node, ICE_MIN_BW,
+						   bw_t_info->cir_bw.bw);
+		if (status)
+			return status;
+	}
+	if (test_bit(ICE_BW_TYPE_CIR_WT, bw_t_info->bw_t_bitmap)) {
+		bw_alloc = bw_t_info->cir_bw.bw_alloc;
+		status = ice_sched_cfg_node_bw_alloc(hw, node, ICE_MIN_BW,
+						     bw_alloc);
+		if (status)
+			return status;
+	}
+	if (test_bit(ICE_BW_TYPE_EIR, bw_t_info->bw_t_bitmap)) {
+		status = ice_sched_set_node_bw_lmt(pi, node, ICE_MAX_BW,
+						   bw_t_info->eir_bw.bw);
+		if (status)
+			return status;
+	}
+	if (test_bit(ICE_BW_TYPE_EIR_WT, bw_t_info->bw_t_bitmap)) {
+		bw_alloc = bw_t_info->eir_bw.bw_alloc;
+		status = ice_sched_cfg_node_bw_alloc(hw, node, ICE_MAX_BW,
+						     bw_alloc);
+		if (status)
+			return status;
+	}
+	if (test_bit(ICE_BW_TYPE_SHARED, bw_t_info->bw_t_bitmap))
+		status = ice_sched_set_node_bw_lmt(pi, node, ICE_SHARED_BW,
+						   bw_t_info->shared_bw);
+	return status;
+}
+
+/**
+ * ice_sched_replay_q_bw - replay queue type node BW
+ * @pi: port information structure
+ * @q_ctx: queue context structure
+ *
+ * This function replays queue type node bandwidth. This function needs to be
+ * called with scheduler lock held.
+ */
+enum ice_status
+ice_sched_replay_q_bw(struct ice_port_info *pi, struct ice_q_ctx *q_ctx)
+{
+	struct ice_sched_node *q_node;
+
+	/* Following also checks the presence of node in tree */
+	q_node = ice_sched_find_node_by_teid(pi->root, q_ctx->q_teid);
+	if (!q_node)
+		return ICE_ERR_PARAM;
+	return ice_sched_replay_node_bw(pi->hw, q_node, &q_ctx->bw_t_info);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.h b/drivers/net/ethernet/intel/ice/ice_sched.h
index 3902a8ad3025..f0593cfb6521 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.h
+++ b/drivers/net/ethernet/intel/ice/ice_sched.h
@@ -8,6 +8,36 @@
 
 #define ICE_QGRP_LAYER_OFFSET	2
 #define ICE_VSI_LAYER_OFFSET	4
+#define ICE_SCHED_INVAL_LAYER_NUM	0xFF
+/* Burst size is a 12 bits register that is configured while creating the RL
+ * profile(s). MSB is a granularity bit and tells the granularity type
+ * 0 - LSB bits are in 64 bytes granularity
+ * 1 - LSB bits are in 1K bytes granularity
+ */
+#define ICE_64_BYTE_GRANULARITY			0
+#define ICE_KBYTE_GRANULARITY			BIT(11)
+#define ICE_MIN_BURST_SIZE_ALLOWED		64 /* In Bytes */
+#define ICE_MAX_BURST_SIZE_ALLOWED \
+	((BIT(11) - 1) * 1024) /* In Bytes */
+#define ICE_MAX_BURST_SIZE_64_BYTE_GRANULARITY \
+	((BIT(11) - 1) * 64) /* In Bytes */
+#define ICE_MAX_BURST_SIZE_KBYTE_GRANULARITY	ICE_MAX_BURST_SIZE_ALLOWED
+
+#define ICE_RL_PROF_FREQUENCY 446000000
+#define ICE_RL_PROF_ACCURACY_BYTES 128
+#define ICE_RL_PROF_MULTIPLIER 10000
+#define ICE_RL_PROF_TS_MULTIPLIER 32
+#define ICE_RL_PROF_FRACTION 512
+
+/* BW rate limit profile parameters list entry along
+ * with bandwidth maintained per layer in port info
+ */
+struct ice_aqc_rl_profile_info {
+	struct ice_aqc_rl_profile_elem profile;
+	struct list_head list_entry;
+	u32 bw;			/* requested */
+	u16 prof_id_ref;	/* profile ID to node association ref count */
+};
 
 struct ice_sched_agg_vsi_info {
 	struct list_head list_entry;
@@ -48,4 +78,13 @@ enum ice_status
 ice_sched_cfg_vsi(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 maxqs,
 		  u8 owner, bool enable);
 enum ice_status ice_rm_vsi_lan_cfg(struct ice_port_info *pi, u16 vsi_handle);
+enum ice_status
+ice_cfg_q_bw_lmt(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
+		 u16 q_handle, enum ice_rl_type rl_type, u32 bw);
+enum ice_status
+ice_cfg_q_bw_dflt_lmt(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
+		      u16 q_handle, enum ice_rl_type rl_type);
+enum ice_status ice_cfg_rl_burst_size(struct ice_hw *hw, u32 bytes);
+enum ice_status
+ice_sched_replay_q_bw(struct ice_port_info *pi, struct ice_q_ctx *q_ctx);
 #endif /* _ICE_SCHED_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index cb123fbe30be..fa14b9545dab 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -14,11 +14,6 @@
 #define ICE_VSI_INVAL_ID 0xffff
 #define ICE_INVAL_Q_HANDLE 0xFFFF
 
-/* VSI queue context structure */
-struct ice_q_ctx {
-	u16  q_handle;
-};
-
 /* VSI context structure for add/get/update/free operations */
 struct ice_vsi_ctx {
 	u16 vsi_num;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 08fe3e5e72d4..d3d7049c97f0 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -19,6 +19,17 @@ static inline bool ice_is_tc_ena(unsigned long bitmap, u8 tc)
 	return test_bit(tc, &bitmap);
 }
 
+static inline u64 round_up_64bit(u64 a, u32 b)
+{
+	return div64_long(((a) + (b) / 2), (b));
+}
+
+static inline u32 ice_round_to_num(u32 N, u32 R)
+{
+	return ((((N) % (R)) < ((R) / 2)) ? (((N) / (R)) * (R)) :
+		((((N) + (R) - 1) / (R)) * (R)));
+}
+
 /* Driver always calls main vsi_handle first */
 #define ICE_MAIN_VSI_HANDLE		0
 
@@ -272,10 +283,56 @@ enum ice_agg_type {
 	ICE_AGG_TYPE_QG
 };
 
+/* Rate limit types */
+enum ice_rl_type {
+	ICE_UNKNOWN_BW = 0,
+	ICE_MIN_BW,		/* for CIR profile */
+	ICE_MAX_BW,		/* for EIR profile */
+	ICE_SHARED_BW		/* for shared profile */
+};
+
+#define ICE_SCHED_MIN_BW		500		/* in Kbps */
+#define ICE_SCHED_MAX_BW		100000000	/* in Kbps */
+#define ICE_SCHED_DFLT_BW		0xFFFFFFFF	/* unlimited */
 #define ICE_SCHED_DFLT_RL_PROF_ID	0
+#define ICE_SCHED_NO_SHARED_RL_PROF_ID	0xFFFF
 #define ICE_SCHED_DFLT_BW_WT		1
+#define ICE_SCHED_INVAL_PROF_ID		0xFFFF
+#define ICE_SCHED_DFLT_BURST_SIZE	(15 * 1024)	/* in bytes (15k) */
 
-/* VSI type list entry to locate corresponding VSI/ag nodes */
+ /* Data structure for saving BW information */
+enum ice_bw_type {
+	ICE_BW_TYPE_PRIO,
+	ICE_BW_TYPE_CIR,
+	ICE_BW_TYPE_CIR_WT,
+	ICE_BW_TYPE_EIR,
+	ICE_BW_TYPE_EIR_WT,
+	ICE_BW_TYPE_SHARED,
+	ICE_BW_TYPE_CNT		/* This must be last */
+};
+
+struct ice_bw {
+	u32 bw;
+	u16 bw_alloc;
+};
+
+struct ice_bw_type_info {
+	DECLARE_BITMAP(bw_t_bitmap, ICE_BW_TYPE_CNT);
+	u8 generic;
+	struct ice_bw cir_bw;
+	struct ice_bw eir_bw;
+	u32 shared_bw;
+};
+
+/* VSI queue context structure for given TC */
+struct ice_q_ctx {
+	u16  q_handle;
+	u32  q_teid;
+	/* bw_t_info saves queue BW information */
+	struct ice_bw_type_info bw_t_info;
+};
+
+/* VSI type list entry to locate corresponding VSI/aggregator nodes */
 struct ice_sched_vsi_info {
 	struct ice_sched_node *vsi_node[ICE_MAX_TRAFFIC_CLASS];
 	struct ice_sched_node *ag_node[ICE_MAX_TRAFFIC_CLASS];
@@ -364,6 +421,8 @@ struct ice_port_info {
 	struct mutex sched_lock;	/* protect access to TXSched tree */
 	struct ice_sched_node *
 		sib_head[ICE_MAX_TRAFFIC_CLASS][ICE_AQC_TOPO_MAX_LEVEL_NUM];
+	/* List contain profile ID(s) and other params per layer */
+	struct list_head rl_prof_list[ICE_AQC_TOPO_MAX_LEVEL_NUM];
 	struct ice_dcbx_cfg local_dcbx_cfg;	/* Oper/Local Cfg */
 	/* DCBX info */
 	struct ice_dcbx_cfg remote_dcbx_cfg;	/* Peer Cfg */
@@ -415,6 +474,8 @@ struct ice_hw {
 
 	u8 pf_id;		/* device profile info */
 
+	u16 max_burst_size;	/* driver sets this value */
+
 	/* Tx Scheduler values */
 	u16 num_tx_sched_layers;
 	u16 num_tx_sched_phys_layers;
-- 
2.21.0


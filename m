Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52350426035
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbhJGXKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:15520 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233231AbhJGXKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226340357"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="226340357"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344323"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@resnulli.us, ivecera@redhat.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 04/12] ice: allow process VF opcodes in different ways
Date:   Thu,  7 Oct 2021 16:06:12 -0700
Message-Id: <20211007230620.3413290-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
References: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

In switchdev driver shouldn't add MAC, VLAN and promisc
filters on iavf demand but should return success to not
break normal iavf flow.

Achieve that by creating table of functions pointer with
default functions used to parse iavf command. While parse
iavf command, call correct function from table instead of
calling function direct.

When port representors are being created change functions
in table to new one that behaves correctly for switchdev
puprose (ignoring new filters).

Change back to default ops when representors are being
removed.

Co-developed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_repr.c     |  23 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 207 +++++++++++++++---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  32 +++
 3 files changed, 225 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 479da3d020a7..d7fa1ff487a5 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -228,15 +228,24 @@ int ice_repr_add_for_all_vfs(struct ice_pf *pf)
 	int i;
 
 	ice_for_each_vf(pf, i) {
-		err = ice_repr_add(&pf->vf[i]);
+		struct ice_vf *vf = &pf->vf[i];
+
+		err = ice_repr_add(vf);
 		if (err)
 			goto err;
+
+		ice_vc_change_ops_to_repr(&vf->vc_ops);
 	}
+
 	return 0;
 
 err:
-	for (i = i - 1; i >= 0; i--)
-		ice_repr_rem(&pf->vf[i]);
+	for (i = i - 1; i >= 0; i--) {
+		struct ice_vf *vf = &pf->vf[i];
+
+		ice_repr_rem(vf);
+		ice_vc_set_dflt_vf_ops(&vf->vc_ops);
+	}
 
 	return err;
 }
@@ -249,6 +258,10 @@ void ice_repr_rem_from_all_vfs(struct ice_pf *pf)
 {
 	int i;
 
-	ice_for_each_vf(pf, i)
-		ice_repr_rem(&pf->vf[i]);
+	ice_for_each_vf(pf, i) {
+		struct ice_vf *vf = &pf->vf[i];
+
+		ice_repr_rem(vf);
+		ice_vc_set_dflt_vf_ops(&vf->vc_ops);
+	}
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ec0fefa619dc..0b80b5a52e8a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1894,6 +1894,8 @@ static void ice_set_dflt_settings_vfs(struct ice_pf *pf)
 		 */
 		ice_vf_ctrl_invalidate_vsi(vf);
 		ice_vf_fdir_init(vf);
+
+		ice_vc_set_dflt_vf_ops(&vf->vc_ops);
 	}
 }
 
@@ -3801,6 +3803,26 @@ static bool ice_is_legacy_umac_expired(struct ice_time_mac *last_added_umac)
 				      ICE_LEGACY_VF_MAC_CHANGE_EXPIRE_TIME);
 }
 
+/**
+ * ice_update_legacy_cached_mac - update cached hardware MAC for legacy VF
+ * @vf: VF to update
+ * @vc_ether_addr: structure from VIRTCHNL with MAC to check
+ *
+ * only update cached hardware MAC for legacy VF drivers on delete
+ * because we cannot guarantee order/type of MAC from the VF driver
+ */
+static void
+ice_update_legacy_cached_mac(struct ice_vf *vf,
+			     struct virtchnl_ether_addr *vc_ether_addr)
+{
+	if (!ice_is_vc_addr_legacy(vc_ether_addr) ||
+	    ice_is_legacy_umac_expired(&vf->legacy_last_added_umac))
+		return;
+
+	ether_addr_copy(vf->dev_lan_addr.addr, vf->legacy_last_added_umac.addr);
+	ether_addr_copy(vf->hw_lan_addr.addr, vf->legacy_last_added_umac.addr);
+}
+
 /**
  * ice_vfhw_mac_del - update the VF's cached hardware MAC if allowed
  * @vf: VF to update
@@ -3822,16 +3844,7 @@ ice_vfhw_mac_del(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
 	 */
 	eth_zero_addr(vf->dev_lan_addr.addr);
 
-	/* only update cached hardware MAC for legacy VF drivers on delete
-	 * because we cannot guarantee order/type of MAC from the VF driver
-	 */
-	if (ice_is_vc_addr_legacy(vc_ether_addr) &&
-	    !ice_is_legacy_umac_expired(&vf->legacy_last_added_umac)) {
-		ether_addr_copy(vf->dev_lan_addr.addr,
-				vf->legacy_last_added_umac.addr);
-		ether_addr_copy(vf->hw_lan_addr.addr,
-				vf->legacy_last_added_umac.addr);
-	}
+	ice_update_legacy_cached_mac(vf, vc_ether_addr);
 }
 
 /**
@@ -4400,6 +4413,133 @@ static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
 		return ice_vsi_manage_vlan_stripping(vsi, false);
 }
 
+static struct ice_vc_vf_ops ice_vc_vf_dflt_ops = {
+	.get_ver_msg = ice_vc_get_ver_msg,
+	.get_vf_res_msg = ice_vc_get_vf_res_msg,
+	.reset_vf = ice_vc_reset_vf_msg,
+	.add_mac_addr_msg = ice_vc_add_mac_addr_msg,
+	.del_mac_addr_msg = ice_vc_del_mac_addr_msg,
+	.cfg_qs_msg = ice_vc_cfg_qs_msg,
+	.ena_qs_msg = ice_vc_ena_qs_msg,
+	.dis_qs_msg = ice_vc_dis_qs_msg,
+	.request_qs_msg = ice_vc_request_qs_msg,
+	.cfg_irq_map_msg = ice_vc_cfg_irq_map_msg,
+	.config_rss_key = ice_vc_config_rss_key,
+	.config_rss_lut = ice_vc_config_rss_lut,
+	.get_stats_msg = ice_vc_get_stats_msg,
+	.cfg_promiscuous_mode_msg = ice_vc_cfg_promiscuous_mode_msg,
+	.add_vlan_msg = ice_vc_add_vlan_msg,
+	.remove_vlan_msg = ice_vc_remove_vlan_msg,
+	.ena_vlan_stripping = ice_vc_ena_vlan_stripping,
+	.dis_vlan_stripping = ice_vc_dis_vlan_stripping,
+	.handle_rss_cfg_msg = ice_vc_handle_rss_cfg,
+	.add_fdir_fltr_msg = ice_vc_add_fdir_fltr,
+	.del_fdir_fltr_msg = ice_vc_del_fdir_fltr,
+};
+
+void ice_vc_set_dflt_vf_ops(struct ice_vc_vf_ops *ops)
+{
+	*ops = ice_vc_vf_dflt_ops;
+}
+
+static int
+ice_vc_repr_no_action_msg(struct ice_vf __always_unused *vf,
+			  u8 __always_unused *msg)
+{
+	return 0;
+}
+
+/**
+ * ice_vc_repr_add_mac
+ * @vf: pointer to VF
+ * @msg: virtchannel message
+ *
+ * When port representors are created, we do not add MAC rule
+ * to firmware, we store it so that PF could report same
+ * MAC as VF.
+ */
+static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
+{
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct virtchnl_ether_addr_list *al =
+	    (struct virtchnl_ether_addr_list *)msg;
+	struct ice_vsi *vsi;
+	struct ice_pf *pf;
+	int i;
+
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
+	    !ice_vc_isvalid_vsi_id(vf, al->vsi_id)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto handle_mac_exit;
+	}
+
+	pf = vf->pf;
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto handle_mac_exit;
+	}
+
+	for (i = 0; i < al->num_elements; i++) {
+		u8 *mac_addr = al->list[i].addr;
+
+		if (!is_unicast_ether_addr(mac_addr) ||
+		    ether_addr_equal(mac_addr, vf->hw_lan_addr.addr))
+			continue;
+
+		if (vf->pf_set_mac) {
+			dev_err(ice_pf_to_dev(pf), "VF attempting to override administratively set MAC address\n");
+			v_ret = VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
+			goto handle_mac_exit;
+		}
+
+		ice_vfhw_mac_add(vf, &al->list[i]);
+		vf->num_mac++;
+		break;
+	}
+
+handle_mac_exit:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				     v_ret, NULL, 0);
+}
+
+/**
+ * ice_vc_repr_del_mac - response with success for deleting MAC
+ * @vf: pointer to VF
+ * @msg: virtchannel message
+ *
+ * Respond with success to not break normal VF flow.
+ * For legacy VF driver try to update cached MAC address.
+ */
+static int
+ice_vc_repr_del_mac(struct ice_vf __always_unused *vf, u8 __always_unused *msg)
+{
+	struct virtchnl_ether_addr_list *al =
+		(struct virtchnl_ether_addr_list *)msg;
+
+	ice_update_legacy_cached_mac(vf, &al->list[0]);
+
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
+				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+}
+
+static int ice_vc_repr_no_action(struct ice_vf __always_unused *vf)
+{
+	return 0;
+}
+
+void ice_vc_change_ops_to_repr(struct ice_vc_vf_ops *ops)
+{
+	ops->add_mac_addr_msg = ice_vc_repr_add_mac;
+	ops->del_mac_addr_msg = ice_vc_repr_del_mac;
+	ops->add_vlan_msg = ice_vc_repr_no_action_msg;
+	ops->remove_vlan_msg = ice_vc_repr_no_action_msg;
+	ops->ena_vlan_stripping = ice_vc_repr_no_action;
+	ops->dis_vlan_stripping = ice_vc_repr_no_action;
+	ops->cfg_promiscuous_mode_msg = ice_vc_repr_no_action_msg;
+}
+
 /**
  * ice_vc_process_vf_msg - Process request from VF
  * @pf: pointer to the PF structure
@@ -4413,6 +4553,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
 	s16 vf_id = le16_to_cpu(event->desc.retval);
 	u16 msglen = event->msg_len;
+	struct ice_vc_vf_ops *ops;
 	u8 *msg = event->msg_buf;
 	struct ice_vf *vf = NULL;
 	struct device *dev;
@@ -4436,6 +4577,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		goto error_handler;
 	}
 
+	ops = &vf->vc_ops;
+
 	/* Perform basic checks on the msg */
 	err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg, msglen);
 	if (err) {
@@ -4463,75 +4606,75 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 
 	switch (v_opcode) {
 	case VIRTCHNL_OP_VERSION:
-		err = ice_vc_get_ver_msg(vf, msg);
+		err = ops->get_ver_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_GET_VF_RESOURCES:
-		err = ice_vc_get_vf_res_msg(vf, msg);
+		err = ops->get_vf_res_msg(vf, msg);
 		if (ice_vf_init_vlan_stripping(vf))
 			dev_err(dev, "Failed to initialize VLAN stripping for VF %d\n",
 				vf->vf_id);
 		ice_vc_notify_vf_link_state(vf);
 		break;
 	case VIRTCHNL_OP_RESET_VF:
-		ice_vc_reset_vf_msg(vf);
+		ops->reset_vf(vf);
 		break;
 	case VIRTCHNL_OP_ADD_ETH_ADDR:
-		err = ice_vc_add_mac_addr_msg(vf, msg);
+		err = ops->add_mac_addr_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_DEL_ETH_ADDR:
-		err = ice_vc_del_mac_addr_msg(vf, msg);
+		err = ops->del_mac_addr_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_CONFIG_VSI_QUEUES:
-		err = ice_vc_cfg_qs_msg(vf, msg);
+		err = ops->cfg_qs_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_ENABLE_QUEUES:
-		err = ice_vc_ena_qs_msg(vf, msg);
+		err = ops->ena_qs_msg(vf, msg);
 		ice_vc_notify_vf_link_state(vf);
 		break;
 	case VIRTCHNL_OP_DISABLE_QUEUES:
-		err = ice_vc_dis_qs_msg(vf, msg);
+		err = ops->dis_qs_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_REQUEST_QUEUES:
-		err = ice_vc_request_qs_msg(vf, msg);
+		err = ops->request_qs_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_CONFIG_IRQ_MAP:
-		err = ice_vc_cfg_irq_map_msg(vf, msg);
+		err = ops->cfg_irq_map_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_CONFIG_RSS_KEY:
-		err = ice_vc_config_rss_key(vf, msg);
+		err = ops->config_rss_key(vf, msg);
 		break;
 	case VIRTCHNL_OP_CONFIG_RSS_LUT:
-		err = ice_vc_config_rss_lut(vf, msg);
+		err = ops->config_rss_lut(vf, msg);
 		break;
 	case VIRTCHNL_OP_GET_STATS:
-		err = ice_vc_get_stats_msg(vf, msg);
+		err = ops->get_stats_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE:
-		err = ice_vc_cfg_promiscuous_mode_msg(vf, msg);
+		err = ops->cfg_promiscuous_mode_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_ADD_VLAN:
-		err = ice_vc_add_vlan_msg(vf, msg);
+		err = ops->add_vlan_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_DEL_VLAN:
-		err = ice_vc_remove_vlan_msg(vf, msg);
+		err = ops->remove_vlan_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
-		err = ice_vc_ena_vlan_stripping(vf);
+		err = ops->ena_vlan_stripping(vf);
 		break;
 	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
-		err = ice_vc_dis_vlan_stripping(vf);
+		err = ops->dis_vlan_stripping(vf);
 		break;
 	case VIRTCHNL_OP_ADD_FDIR_FILTER:
-		err = ice_vc_add_fdir_fltr(vf, msg);
+		err = ops->add_fdir_fltr_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_DEL_FDIR_FILTER:
-		err = ice_vc_del_fdir_fltr(vf, msg);
+		err = ops->del_fdir_fltr_msg(vf, msg);
 		break;
 	case VIRTCHNL_OP_ADD_RSS_CFG:
-		err = ice_vc_handle_rss_cfg(vf, msg, true);
+		err = ops->handle_rss_cfg_msg(vf, msg, true);
 		break;
 	case VIRTCHNL_OP_DEL_RSS_CFG:
-		err = ice_vc_handle_rss_cfg(vf, msg, false);
+		err = ops->handle_rss_cfg_msg(vf, msg, false);
 		break;
 	case VIRTCHNL_OP_UNKNOWN:
 	default:
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index b3fa8dd5539b..6bad277d16fc 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -70,6 +70,32 @@ struct ice_mdd_vf_events {
 	u16 last_printed;
 };
 
+struct ice_vf;
+
+struct ice_vc_vf_ops {
+	int (*get_ver_msg)(struct ice_vf *vf, u8 *msg);
+	int (*get_vf_res_msg)(struct ice_vf *vf, u8 *msg);
+	void (*reset_vf)(struct ice_vf *vf);
+	int (*add_mac_addr_msg)(struct ice_vf *vf, u8 *msg);
+	int (*del_mac_addr_msg)(struct ice_vf *vf, u8 *msg);
+	int (*cfg_qs_msg)(struct ice_vf *vf, u8 *msg);
+	int (*ena_qs_msg)(struct ice_vf *vf, u8 *msg);
+	int (*dis_qs_msg)(struct ice_vf *vf, u8 *msg);
+	int (*request_qs_msg)(struct ice_vf *vf, u8 *msg);
+	int (*cfg_irq_map_msg)(struct ice_vf *vf, u8 *msg);
+	int (*config_rss_key)(struct ice_vf *vf, u8 *msg);
+	int (*config_rss_lut)(struct ice_vf *vf, u8 *msg);
+	int (*get_stats_msg)(struct ice_vf *vf, u8 *msg);
+	int (*cfg_promiscuous_mode_msg)(struct ice_vf *vf, u8 *msg);
+	int (*add_vlan_msg)(struct ice_vf *vf, u8 *msg);
+	int (*remove_vlan_msg)(struct ice_vf *vf, u8 *msg);
+	int (*ena_vlan_stripping)(struct ice_vf *vf);
+	int (*dis_vlan_stripping)(struct ice_vf *vf);
+	int (*handle_rss_cfg_msg)(struct ice_vf *vf, u8 *msg, bool add);
+	int (*add_fdir_fltr_msg)(struct ice_vf *vf, u8 *msg);
+	int (*del_fdir_fltr_msg)(struct ice_vf *vf, u8 *msg);
+};
+
 /* VF information structure */
 struct ice_vf {
 	struct ice_pf *pf;
@@ -114,6 +140,8 @@ struct ice_vf {
 
 	struct ice_repr *repr;
 
+	struct ice_vc_vf_ops vc_ops;
+
 	/* devlink port data */
 	struct devlink_port devlink_port;
 };
@@ -131,6 +159,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event);
 void ice_vc_notify_link_state(struct ice_pf *pf);
 void ice_vc_notify_reset(struct ice_pf *pf);
 void ice_vc_notify_vf_link_state(struct ice_vf *vf);
+void ice_vc_change_ops_to_repr(struct ice_vc_vf_ops *ops);
+void ice_vc_set_dflt_vf_ops(struct ice_vc_vf_ops *ops);
 bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr);
 bool ice_reset_vf(struct ice_vf *vf, bool is_vflr);
 void ice_restore_all_vfs_msi_state(struct pci_dev *pdev);
@@ -172,6 +202,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event) {
 static inline void ice_vc_notify_link_state(struct ice_pf *pf) { }
 static inline void ice_vc_notify_reset(struct ice_pf *pf) { }
 static inline void ice_vc_notify_vf_link_state(struct ice_vf *vf) { }
+static inline void ice_vc_change_ops_to_repr(struct ice_vc_vf_ops *ops) { }
+static inline void ice_vc_set_dflt_vf_ops(struct ice_vc_vf_ops *ops) { }
 static inline void ice_set_vf_state_qs_dis(struct ice_vf *vf) { }
 static inline
 void ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event) { }
-- 
2.31.1


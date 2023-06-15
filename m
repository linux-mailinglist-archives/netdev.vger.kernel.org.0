Return-Path: <netdev+bounces-11177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6C5731DCF
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00B5028149E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53381ACBB;
	Thu, 15 Jun 2023 16:28:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F461ACB8
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 16:28:00 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761172943
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686846477; x=1718382477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dCdP1vQjWGSm10e4LnKIpFltWDv5kJCQ1spRdddfhEA=;
  b=Y8CY7jxP5LlXeQd3WnTwtk+SIsnnd6cKImBEvCYvBp8hE6BkpfdML3eg
   LiTF92rcoDiZzw1S4z3pm2YAFqtc3D00GMJrZyr2r50smAG74gbIVt0S7
   pJ3EIBY0rl4FEHcs1Lt88juN/bosby2lshOocvWN1CkOCGQYHvMHOwz/l
   h7x1yaD00p9XAmm9qS0tNltmt38vTbAZZN7CnGYNOV6YCiYnVxz8nikjB
   4EU3l6Woi/aFyt5PNh+OkONBMWQ/B6k1ikFNaRB8Ulk1pB56lb0hRPaB/
   WU6woWAbBJrPV/+pC4JwkxuDOrf8UnkzverwdNS6lASY7HGY2XYMO4lWh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445336185"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="445336185"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 09:27:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="712513717"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="712513717"
Received: from dmert-dev.jf.intel.com ([10.166.241.14])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 09:27:52 -0700
From: Dave Ertman <david.m.ertman@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	daniel.machon@microchip.com,
	simon.horman@corigine.com,
	bcreeley@amd.com
Subject: [PATCH iwl-next v5 06/10] ice: Flesh out implementation of support for SRIOV on bonded interface
Date: Thu, 15 Jun 2023 09:29:28 -0700
Message-Id: <20230615162932.762756-7-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615162932.762756-1-david.m.ertman@intel.com>
References: <20230615162932.762756-1-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add in the functions that will allow a VF created on the primary interface
of a bond to "fail-over" to another PF interface in the bond and continue
to Tx and Rx.

Add in an ordered take-down path for the bonded interface.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 823 ++++++++++++++++++++++-
 1 file changed, 813 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 79f9503908d4..c70b2e11b835 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -10,6 +10,11 @@
 #define ICE_LAG_RES_SHARED	BIT(14)
 #define ICE_LAG_RES_VALID	BIT(15)
 
+#define LACP_TRAIN_PKT_LEN		16
+static const u8 lacp_train_pkt[LACP_TRAIN_PKT_LEN] = { 0, 0, 0, 0, 0, 0,
+						       0, 0, 0, 0, 0, 0,
+						       0x88, 0x09, 0, 0 };
+
 #define ICE_RECIPE_LEN			64
 static const u8 ice_dflt_vsi_rcp[ICE_RECIPE_LEN] = {
 	0x05, 0, 0, 0, 0x20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
@@ -57,6 +62,39 @@ static void ice_lag_set_backup(struct ice_lag *lag)
 	lag->role = ICE_LAG_BACKUP;
 }
 
+/**
+ * netif_is_same_ice - determine if netdev is on the same ice NIC as local PF
+ * @pf: local PF struct
+ * @netdev: netdev we are evaluating
+ */
+static bool netif_is_same_ice(struct ice_pf *pf, struct net_device *netdev)
+{
+	struct ice_netdev_priv *np;
+	struct ice_pf *test_pf;
+	struct ice_vsi *vsi;
+
+	if (!netif_is_ice(netdev))
+		return false;
+
+	np = netdev_priv(netdev);
+	if (!np)
+		return false;
+
+	vsi = np->vsi;
+	if (!vsi)
+		return false;
+
+	test_pf = vsi->back;
+	if (!test_pf)
+		return false;
+
+	if (pf->pdev->bus != test_pf->pdev->bus ||
+	    pf->pdev->slot != test_pf->pdev->slot)
+		return false;
+
+	return true;
+}
+
 /**
  * ice_netdev_to_lag - return pointer to associated lag struct from netdev
  * @netdev: pointer to net_device struct to query
@@ -80,6 +118,38 @@ static struct ice_lag *ice_netdev_to_lag(struct net_device *netdev)
 	return vsi->back->lag;
 }
 
+/**
+ * ice_lag_find_hw_by_lport - return an hw struct from bond members lport
+ * @lag: lag struct
+ * @lport: lport value to search for
+ */
+static struct ice_hw *
+ice_lag_find_hw_by_lport(struct ice_lag *lag, u8 lport)
+{
+	struct ice_lag_netdev_list *entry;
+	struct net_device *tmp_netdev;
+	struct ice_netdev_priv *np;
+	struct list_head *tmp;
+	struct ice_hw *hw;
+
+	list_for_each(tmp, lag->netdev_head) {
+		entry = list_entry(tmp, struct ice_lag_netdev_list, node);
+		tmp_netdev = entry->netdev;
+		if (!tmp_netdev || !netif_is_ice(tmp_netdev))
+			continue;
+
+		np = netdev_priv(tmp_netdev);
+		if (!np || !np->vsi)
+			continue;
+
+		hw = &np->vsi->back->hw;
+		if (hw->port_info->lport == lport)
+			return hw;
+	}
+
+	return NULL;
+}
+
 /**
  * ice_lag_find_primary - returns pointer to primary interfaces lag struct
  * @lag: local interfaces lag struct
@@ -233,6 +303,119 @@ static void ice_display_lag_info(struct ice_lag *lag)
 		upper, role, primary);
 }
 
+/**
+ * ice_lag_qbuf_recfg - generate a buffer of queues for a reconfigure command
+ * @hw: HW struct that contains the queue contexts
+ * @qbuf: pointer to buffer to populate
+ * @vsi_num: index of the VSI in PF space
+ * @numq: number of queues to search for
+ * @tc: traffic class that contains the queues
+ *
+ * function returns the number of valid queues in buffer
+ */
+static u16
+ice_lag_qbuf_recfg(struct ice_hw *hw, struct ice_aqc_cfg_txqs_buf *qbuf,
+		   u16 vsi_num, u16 numq, u8 tc)
+{
+	struct ice_q_ctx *q_ctx;
+	u16 qid, count = 0;
+	struct ice_pf *pf;
+	int i;
+
+	pf = hw->back;
+	for (i = 0; i < numq; i++) {
+		q_ctx = ice_get_lan_q_ctx(hw, vsi_num, tc, i);
+		if (q_ctx->q_teid == ICE_INVAL_TEID) {
+			dev_dbg(ice_hw_to_dev(hw), "%s queue %d INVAL TEID\n",
+				__func__, i);
+			continue;
+		}
+
+		if (!q_ctx || q_ctx->q_handle == ICE_INVAL_Q_HANDLE) {
+			dev_dbg(ice_hw_to_dev(hw), "%s queue %d %s\n", __func__, i,
+				q_ctx ? "INVAL Q HANDLE" : "NO Q CONTEXT");
+			continue;
+		}
+
+		qid = pf->vsi[vsi_num]->txq_map[q_ctx->q_handle];
+		qbuf->queue_info[count].q_handle = cpu_to_le16(qid);
+		qbuf->queue_info[count].tc = tc;
+		qbuf->queue_info[count].q_teid = cpu_to_le32(q_ctx->q_teid);
+		count++;
+	}
+
+	return count;
+}
+
+/**
+ * ice_lag_get_sched_parent - locate or create a sched node parent
+ * @hw: HW struct for getting parent in
+ * @tc: traffic class on parent/node
+ */
+static struct ice_sched_node *
+ice_lag_get_sched_parent(struct ice_hw *hw, u8 tc)
+{
+	struct ice_sched_node *tc_node, *aggnode, *parent = NULL;
+	u16 num_nodes[ICE_AQC_TOPO_MAX_LEVEL_NUM] = { 0 };
+	struct ice_port_info *pi = hw->port_info;
+	struct device *dev;
+	u8 aggl, vsil;
+	int n;
+
+	dev = ice_hw_to_dev(hw);
+
+	tc_node = ice_sched_get_tc_node(pi, tc);
+	if (!tc_node) {
+		dev_warn(dev, "Failure to find TC node for LAG move\n");
+		return parent;
+	}
+
+	aggnode = ice_sched_get_agg_node(pi, tc_node, ICE_DFLT_AGG_ID);
+	if (!aggnode) {
+		dev_warn(dev, "Failure to find aggregate node for LAG move\n");
+		return parent;
+	}
+
+	aggl = ice_sched_get_agg_layer(hw);
+	vsil = ice_sched_get_vsi_layer(hw);
+
+	for (n = aggl + 1; n < vsil; n++)
+		num_nodes[n] = 1;
+
+	for (n = 0; n < aggnode->num_children; n++) {
+		parent = ice_sched_get_free_vsi_parent(hw, aggnode->children[n],
+						       num_nodes);
+		if (parent)
+			return parent;
+	}
+
+	/* if free parent not found - add one */
+	parent = aggnode;
+	for (n = aggl + 1; n < vsil; n++) {
+		u16 num_nodes_added;
+		u32 first_teid;
+		int err;
+
+		err = ice_sched_add_nodes_to_layer(pi, tc_node, parent, n,
+						   num_nodes[n], &first_teid,
+						   &num_nodes_added);
+		if (err || num_nodes[n] != num_nodes_added)
+			return NULL;
+
+		if (num_nodes_added)
+			parent = ice_sched_find_node_by_teid(tc_node,
+							     first_teid);
+		else
+			parent = parent->children[0];
+		if (!parent) {
+			dev_warn(dev, "Failure to add new parent for LAG move\n");
+			return parent;
+		}
+	}
+
+	return parent;
+}
+
 /**
  * ice_lag_move_vf_node_tc - move scheduling nodes for one VF on one TC
  * @lag: lag info struct
@@ -245,6 +428,110 @@ static void
 ice_lag_move_vf_node_tc(struct ice_lag *lag, u8 oldport, u8 newport,
 			u16 vsi_num, u8 tc)
 {
+	u16 numq, valq, buf_size, num_moved, qbuf_size;
+	struct device *dev = ice_pf_to_dev(lag->pf);
+	struct ice_aqc_cfg_txqs_buf *qbuf;
+	struct ice_aqc_move_elem *buf;
+	struct ice_sched_node *n_prt;
+	struct ice_hw *new_hw = NULL;
+	__le32 teid, parent_teid;
+	struct ice_vsi_ctx *ctx;
+	u32 tmp_teid;
+
+	ctx = ice_get_vsi_ctx(&lag->pf->hw, vsi_num);
+	if (!ctx) {
+		dev_warn(dev, "Unable to locate VSI context for LAG failover\n");
+		return;
+	}
+
+	/* check to see if this VF is enabled on this TC */
+	if (!ctx->sched.vsi_node[tc])
+		return;
+
+	/* locate HW struct for destination port */
+	new_hw = ice_lag_find_hw_by_lport(lag, newport);
+	if (!new_hw) {
+		dev_warn(dev, "Unable to locate HW struct for LAG node destination\n");
+		return;
+	}
+
+	numq = ctx->num_lan_q_entries[tc];
+	teid = ctx->sched.vsi_node[tc]->info.node_teid;
+	tmp_teid = le32_to_cpu(teid);
+	parent_teid = ctx->sched.vsi_node[tc]->info.parent_teid;
+	/* if no teid assigned or numq == 0, then this TC is not active */
+	if (!tmp_teid || !numq)
+		return;
+
+	/* suspend VSI subtree for Traffic Class "tc" on
+	 * this VF's VSI
+	 */
+	if (ice_sched_suspend_resume_elems(&lag->pf->hw, 1, &tmp_teid, true))
+		dev_dbg(dev, "Problem suspending traffic for LAG node move\n");
+
+	/* reconfigure all VF's queues on this Traffic Class
+	 * to new port
+	 */
+	qbuf_size = struct_size(qbuf, queue_info, numq);
+	qbuf = kzalloc(qbuf_size, GFP_KERNEL);
+	if (!qbuf) {
+		dev_warn(dev, "Failure allocating memory for VF queue recfg buffer\n");
+		goto resume_traffic;
+	}
+
+	/* add the per queue info for the reconfigure command buffer */
+	valq = ice_lag_qbuf_recfg(&lag->pf->hw, qbuf, vsi_num, numq, tc);
+	if (!valq) {
+		dev_dbg(dev, "No valid queues found for LAG failover\n");
+		goto qbuf_none;
+	}
+
+	if (ice_aq_cfg_lan_txq(&lag->pf->hw, qbuf, qbuf_size, valq, oldport,
+			       newport, NULL)) {
+		dev_warn(dev, "Failure to configure queues for LAG failover\n");
+		goto qbuf_err;
+	}
+
+qbuf_none:
+	kfree(qbuf);
+
+	/* find new parent in destination port's tree for VF VSI node on this
+	 * Traffic Class
+	 */
+	n_prt = ice_lag_get_sched_parent(new_hw, tc);
+	if (!n_prt)
+		goto resume_traffic;
+
+	/* Move Vf's VSI node for this TC to newport's scheduler tree */
+	buf_size = struct_size(buf, teid, 1);
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf) {
+		dev_warn(dev, "Failure to alloc memory for VF node failover\n");
+		goto resume_traffic;
+	}
+
+	buf->hdr.src_parent_teid = parent_teid;
+	buf->hdr.dest_parent_teid = n_prt->info.node_teid;
+	buf->hdr.num_elems = cpu_to_le16(1);
+	buf->hdr.mode = ICE_AQC_MOVE_ELEM_MODE_KEEP_OWN;
+	buf->teid[0] = teid;
+
+	if (ice_aq_move_sched_elems(&lag->pf->hw, 1, buf, buf_size, &num_moved,
+				    NULL))
+		dev_warn(dev, "Failure to move VF nodes for failover\n");
+	else
+		ice_sched_update_parent(n_prt, ctx->sched.vsi_node[tc]);
+
+	kfree(buf);
+	goto resume_traffic;
+
+qbuf_err:
+	kfree(qbuf);
+
+resume_traffic:
+	/* restart traffic for VSI node */
+	if (ice_sched_suspend_resume_elems(&lag->pf->hw, 1, &tmp_teid, false))
+		dev_dbg(dev, "Problem restarting traffic for LAG node move\n");
 }
 
 /**
@@ -274,6 +561,66 @@ ice_lag_move_single_vf_nodes(struct ice_lag *lag, u8 oldport, u8 newport,
  */
 void ice_lag_move_new_vf_nodes(struct ice_vf *vf)
 {
+	struct ice_lag_netdev_list ndlist;
+	struct list_head *tmp, *n;
+	u8 pri_port, act_port;
+	struct ice_lag *lag;
+	struct ice_vsi *vsi;
+	struct ice_pf *pf;
+
+	vsi = ice_get_vf_vsi(vf);
+
+	if (WARN_ON(!vsi))
+		return;
+
+	if (WARN_ON(vsi->type != ICE_VSI_VF))
+		return;
+
+	pf = vf->pf;
+	lag = pf->lag;
+
+	mutex_lock(&pf->lag_mutex);
+	if (!lag->bonded)
+		goto new_vf_unlock;
+
+	pri_port = pf->hw.port_info->lport;
+	act_port = lag->active_port;
+
+	if (lag->upper_netdev) {
+		struct ice_lag_netdev_list *nl;
+		struct net_device *tmp_nd;
+
+		INIT_LIST_HEAD(&ndlist.node);
+		rcu_read_lock();
+		for_each_netdev_in_bond_rcu(lag->upper_netdev, tmp_nd) {
+			nl = kzalloc(sizeof(*nl), GFP_KERNEL);
+			if (!nl)
+				break;
+
+			nl->netdev = tmp_nd;
+			list_add(&nl->node, &ndlist.node);
+		}
+		rcu_read_unlock();
+	}
+
+	lag->netdev_head = &ndlist.node;
+
+	if (ice_is_feature_supported(pf, ICE_F_SRIOV_LAG) &&
+	    lag->bonded && lag->primary && pri_port != act_port &&
+	    !list_empty(lag->netdev_head))
+		ice_lag_move_single_vf_nodes(lag, pri_port, act_port, vsi->idx);
+
+	list_for_each_safe(tmp, n, &ndlist.node) {
+		struct ice_lag_netdev_list *entry;
+
+		entry = list_entry(tmp, struct ice_lag_netdev_list, node);
+		list_del(&entry->node);
+		kfree(entry);
+	}
+	lag->netdev_head = NULL;
+
+new_vf_unlock:
+	mutex_unlock(&pf->lag_mutex);
 }
 
 /**
@@ -308,6 +655,50 @@ static void ice_lag_move_vf_nodes(struct ice_lag *lag, u8 oldport, u8 newport)
 static void
 ice_lag_cfg_cp_fltr(struct ice_lag *lag, bool add)
 {
+	struct ice_sw_rule_lkup_rx_tx *s_rule = NULL;
+	struct ice_vsi *vsi;
+	u16 buf_len, opc;
+
+	vsi = lag->pf->vsi[0];
+
+	buf_len = ICE_SW_RULE_RX_TX_HDR_SIZE(s_rule,
+					     ICE_LAG_SRIOV_TRAIN_PKT_LEN);
+	s_rule = kzalloc(buf_len, GFP_KERNEL);
+	if (!s_rule) {
+		netdev_warn(lag->netdev, "-ENOMEM error configuring CP filter\n");
+		return;
+	}
+
+	if (add) {
+		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
+		s_rule->recipe_id = cpu_to_le16(ICE_LAG_SRIOV_CP_RECIPE);
+		s_rule->src = cpu_to_le16(vsi->port_info->lport);
+		s_rule->act = cpu_to_le32(ICE_FWD_TO_VSI |
+					  ICE_SINGLE_ACT_LAN_ENABLE |
+					  ICE_SINGLE_ACT_VALID_BIT |
+					  ((vsi->vsi_num <<
+					    ICE_SINGLE_ACT_VSI_ID_S) &
+					   ICE_SINGLE_ACT_VSI_ID_M));
+		s_rule->hdr_len = cpu_to_le16(ICE_LAG_SRIOV_TRAIN_PKT_LEN);
+		memcpy(s_rule->hdr_data, lacp_train_pkt, LACP_TRAIN_PKT_LEN);
+		opc = ice_aqc_opc_add_sw_rules;
+	} else {
+		opc = ice_aqc_opc_remove_sw_rules;
+		s_rule->index = cpu_to_le16(lag->cp_rule_idx);
+	}
+	if (ice_aq_sw_rules(&lag->pf->hw, s_rule, buf_len, 1, opc, NULL)) {
+		netdev_warn(lag->netdev, "Error %s CP rule for fail-over\n",
+			    add ? "ADDING" : "REMOVING");
+		goto cp_free;
+	}
+
+	if (add)
+		lag->cp_rule_idx = le16_to_cpu(s_rule->index);
+	else
+		lag->cp_rule_idx = 0;
+
+cp_free:
+	kfree(s_rule);
 }
 
 /**
@@ -362,6 +753,100 @@ static void
 ice_lag_reclaim_vf_tc(struct ice_lag *lag, struct ice_hw *src_hw, u16 vsi_num,
 		      u8 tc)
 {
+	u16 numq, valq, buf_size, num_moved, qbuf_size;
+	struct device *dev = ice_pf_to_dev(lag->pf);
+	struct ice_aqc_cfg_txqs_buf *qbuf;
+	struct ice_aqc_move_elem *buf;
+	struct ice_sched_node *n_prt;
+	__le32 teid, parent_teid;
+	struct ice_vsi_ctx *ctx;
+	struct ice_hw *hw;
+	u32 tmp_teid;
+
+	hw = &lag->pf->hw;
+	ctx = ice_get_vsi_ctx(hw, vsi_num);
+	if (!ctx) {
+		dev_warn(dev, "Unable to locate VSI context for LAG reclaim\n");
+		return;
+	}
+
+	/* check to see if this VF is enabled on this TC */
+	if (!ctx->sched.vsi_node[tc])
+		return;
+
+	numq = ctx->num_lan_q_entries[tc];
+	teid = ctx->sched.vsi_node[tc]->info.node_teid;
+	tmp_teid = le32_to_cpu(teid);
+	parent_teid = ctx->sched.vsi_node[tc]->info.parent_teid;
+
+	/* if !teid or !numq, then this TC is not active */
+	if (!tmp_teid || !numq)
+		return;
+
+	/* suspend traffic */
+	if (ice_sched_suspend_resume_elems(hw, 1, &tmp_teid, true))
+		dev_dbg(dev, "Problem suspending traffic for LAG node move\n");
+
+	/* reconfig queues for new port */
+	qbuf_size = struct_size(qbuf, queue_info, numq);
+	qbuf = kzalloc(qbuf_size, GFP_KERNEL);
+	if (!qbuf) {
+		dev_warn(dev, "Failure allocating memory for VF queue recfg buffer\n");
+		goto resume_reclaim;
+	}
+
+	/* add the per queue info for the reconfigure command buffer */
+	valq = ice_lag_qbuf_recfg(hw, qbuf, vsi_num, numq, tc);
+	if (!valq) {
+		dev_dbg(dev, "No valid queues found for LAG reclaim\n");
+		goto reclaim_none;
+	}
+
+	if (ice_aq_cfg_lan_txq(hw, qbuf, qbuf_size, numq,
+			       src_hw->port_info->lport, hw->port_info->lport,
+			       NULL)) {
+		dev_warn(dev, "Failure to configure queues for LAG failover\n");
+		goto reclaim_qerr;
+	}
+
+reclaim_none:
+	kfree(qbuf);
+
+	/* find parent in primary tree */
+	n_prt = ice_lag_get_sched_parent(hw, tc);
+	if (!n_prt)
+		goto resume_reclaim;
+
+	/* Move node to new parent */
+	buf_size = struct_size(buf, teid, 1);
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf) {
+		dev_warn(dev, "Failure to alloc memory for VF node failover\n");
+		goto resume_reclaim;
+	}
+
+	buf->hdr.src_parent_teid = parent_teid;
+	buf->hdr.dest_parent_teid = n_prt->info.node_teid;
+	buf->hdr.num_elems = cpu_to_le16(1);
+	buf->hdr.mode = ICE_AQC_MOVE_ELEM_MODE_KEEP_OWN;
+	buf->teid[0] = teid;
+
+	if (ice_aq_move_sched_elems(&lag->pf->hw, 1, buf, buf_size, &num_moved,
+				    NULL))
+		dev_warn(dev, "Failure to move VF nodes for LAG reclaim\n");
+	else
+		ice_sched_update_parent(n_prt, ctx->sched.vsi_node[tc]);
+
+	kfree(buf);
+	goto resume_reclaim;
+
+reclaim_qerr:
+	kfree(qbuf);
+
+resume_reclaim:
+	/* restart traffic */
+	if (ice_sched_suspend_resume_elems(hw, 1, &tmp_teid, false))
+		dev_warn(dev, "Problem restarting traffic for LAG node reclaim\n");
 }
 
 /**
@@ -476,6 +961,65 @@ static void
 ice_lag_set_swid(u16 primary_swid, struct ice_lag *local_lag,
 		 bool link)
 {
+	struct ice_aqc_alloc_free_res_elem *buf;
+	struct ice_aqc_set_port_params *cmd;
+	struct ice_aq_desc desc;
+	u16 buf_len, swid;
+	int status;
+
+	buf_len = struct_size(buf, elem, 1);
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf) {
+		dev_err(ice_pf_to_dev(local_lag->pf), "-ENOMEM error setting SWID\n");
+		return;
+	}
+
+	buf->num_elems = cpu_to_le16(1);
+	buf->res_type = cpu_to_le16(ICE_AQC_RES_TYPE_SWID);
+	/* if unlinnking need to free the shared resource */
+	if (!link && local_lag->bond_swid) {
+		buf->elem[0].e.sw_resp = cpu_to_le16(local_lag->bond_swid);
+		status = ice_aq_alloc_free_res(&local_lag->pf->hw, 1, buf,
+					       buf_len, ice_aqc_opc_free_res,
+					       NULL);
+		if (status)
+			dev_err(ice_pf_to_dev(local_lag->pf), "Error freeing SWID during LAG unlink\n");
+		local_lag->bond_swid = 0;
+	}
+
+	if (link) {
+		buf->res_type |=  cpu_to_le16(ICE_LAG_RES_SHARED |
+					      ICE_LAG_RES_VALID);
+		/* store the primary's SWID in case it leaves bond first */
+		local_lag->bond_swid = primary_swid;
+		buf->elem[0].e.sw_resp = cpu_to_le16(local_lag->bond_swid);
+	} else {
+		buf->elem[0].e.sw_resp =
+			cpu_to_le16(local_lag->pf->hw.port_info->sw_id);
+	}
+
+	status = ice_aq_alloc_free_res(&local_lag->pf->hw, 1, buf, buf_len,
+				       ice_aqc_opc_alloc_res, NULL);
+	if (status)
+		dev_err(ice_pf_to_dev(local_lag->pf), "Error subscribing to SWID 0x%04X\n",
+			local_lag->bond_swid);
+
+	kfree(buf);
+
+	/* Configure port param SWID to correct value */
+	if (link)
+		swid = primary_swid;
+	else
+		swid = local_lag->pf->hw.port_info->sw_id;
+
+	cmd = &desc.params.set_port_params;
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_port_params);
+
+	cmd->swid = cpu_to_le16(ICE_AQC_PORT_SWID_VALID | swid);
+	status = ice_aq_send_cmd(&local_lag->pf->hw, &desc, NULL, 0, NULL);
+	if (status)
+		dev_err(ice_pf_to_dev(local_lag->pf), "Error setting SWID in port params %d\n",
+			status);
 }
 
 /**
@@ -504,6 +1048,38 @@ static void ice_lag_primary_swid(struct ice_lag *lag, bool link)
  */
 static void ice_lag_add_prune_list(struct ice_lag *lag, struct ice_pf *event_pf)
 {
+	u16 num_vsi, rule_buf_sz, vsi_list_id, event_vsi_num, prim_vsi_idx;
+	struct ice_sw_rule_vsi_list *s_rule = NULL;
+	struct device *dev;
+
+	num_vsi = 1;
+
+	dev = ice_pf_to_dev(lag->pf);
+	event_vsi_num = event_pf->vsi[0]->vsi_num;
+	prim_vsi_idx = lag->pf->vsi[0]->idx;
+
+	if (!ice_find_vsi_list_entry(&lag->pf->hw, ICE_SW_LKUP_VLAN,
+				     prim_vsi_idx, &vsi_list_id)) {
+		dev_warn(dev, "Could not locate prune list when setting up SRIOV LAG\n");
+		return;
+	}
+
+	rule_buf_sz = (u16)ICE_SW_RULE_VSI_LIST_SIZE(s_rule, num_vsi);
+	s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
+	if (!s_rule) {
+		dev_warn(dev, "Error allocating space for prune list when configuring SRIOV LAG\n");
+		return;
+	}
+
+	s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_PRUNE_LIST_SET);
+	s_rule->index = cpu_to_le16(vsi_list_id);
+	s_rule->number_vsi = cpu_to_le16(num_vsi);
+	s_rule->vsi[0] = cpu_to_le16(event_vsi_num);
+
+	if (ice_aq_sw_rules(&event_pf->hw, s_rule, rule_buf_sz, 1,
+			    ice_aqc_opc_update_sw_rules, NULL))
+		dev_warn(dev, "Error adding VSI prune list\n");
+	kfree(s_rule);
 }
 
 /**
@@ -513,6 +1089,39 @@ static void ice_lag_add_prune_list(struct ice_lag *lag, struct ice_pf *event_pf)
  */
 static void ice_lag_del_prune_list(struct ice_lag *lag, struct ice_pf *event_pf)
 {
+	u16 num_vsi, vsi_num, vsi_idx, rule_buf_sz, vsi_list_id;
+	struct ice_sw_rule_vsi_list *s_rule = NULL;
+	struct device *dev;
+
+	num_vsi = 1;
+
+	dev = ice_pf_to_dev(lag->pf);
+	vsi_num = event_pf->vsi[0]->vsi_num;
+	vsi_idx = lag->pf->vsi[0]->idx;
+
+	if (!ice_find_vsi_list_entry(&lag->pf->hw, ICE_SW_LKUP_VLAN,
+				     vsi_idx, &vsi_list_id)) {
+		dev_warn(dev, "Could not locate prune list when unwinding SRIOV LAG\n");
+		return;
+	}
+
+	rule_buf_sz = (u16)ICE_SW_RULE_VSI_LIST_SIZE(s_rule, num_vsi);
+	s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
+	if (!s_rule) {
+		dev_warn(dev, "Error allocating prune list when unwinding SRIOV LAG\n");
+		return;
+	}
+
+	s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_PRUNE_LIST_CLEAR);
+	s_rule->index = cpu_to_le16(vsi_list_id);
+	s_rule->number_vsi = cpu_to_le16(num_vsi);
+	s_rule->vsi[0] = cpu_to_le16(vsi_num);
+
+	if (ice_aq_sw_rules(&event_pf->hw, (struct ice_aqc_sw_rules *)s_rule,
+			    rule_buf_sz, 1, ice_aqc_opc_update_sw_rules, NULL))
+		dev_warn(dev, "Error clearing VSI prune list\n");
+
+	kfree(s_rule);
 }
 
 /**
@@ -539,8 +1148,6 @@ static void ice_lag_init_feature_support_flag(struct ice_pf *pf)
  * ice_lag_changeupper_event - handle LAG changeupper event
  * @lag: LAG info struct
  * @ptr: opaque pointer data
- *
- * ptr is to be cast into netdev_notifier_changeupper_info
  */
 static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
 {
@@ -600,6 +1207,40 @@ static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
  */
 static void ice_lag_monitor_link(struct ice_lag *lag, void *ptr)
 {
+	struct netdev_notifier_changeupper_info *info;
+	struct ice_hw *prim_hw, *active_hw;
+	struct net_device *event_netdev;
+	struct ice_pf *pf;
+	u8 prim_port;
+
+	if (!lag->primary)
+		return;
+
+	event_netdev = netdev_notifier_info_to_dev(ptr);
+	if (!netif_is_same_ice(lag->pf, event_netdev))
+		return;
+
+	pf = lag->pf;
+	prim_hw = &pf->hw;
+	prim_port = prim_hw->port_info->lport;
+
+	info = (struct netdev_notifier_changeupper_info *)ptr;
+	if (info->upper_dev != lag->upper_netdev)
+		return;
+
+	if (!info->linking) {
+		/* Since there are only two interfaces allowed in SRIOV+LAG, if
+		 * one port is leaving, then nodes need to be on primary
+		 * interface.
+		 */
+		if (prim_port != lag->active_port &&
+		    lag->active_port != ICE_LAG_INVALID_PORT) {
+			active_hw = ice_lag_find_hw_by_lport(lag,
+							     lag->active_port);
+			ice_lag_reclaim_vf_nodes(lag, active_hw);
+			lag->active_port = ICE_LAG_INVALID_PORT;
+		}
+	}
 }
 
 /**
@@ -612,6 +1253,67 @@ static void ice_lag_monitor_link(struct ice_lag *lag, void *ptr)
  */
 static void ice_lag_monitor_active(struct ice_lag *lag, void *ptr)
 {
+	struct net_device *event_netdev, *event_upper;
+	struct netdev_notifier_bonding_info *info;
+	struct netdev_bonding_info *bonding_info;
+	struct ice_netdev_priv *event_np;
+	struct ice_pf *pf, *event_pf;
+	u8 prim_port, event_port;
+
+	if (!lag->primary)
+		return;
+
+	pf = lag->pf;
+	if (!pf)
+		return;
+
+	event_netdev = netdev_notifier_info_to_dev(ptr);
+	rcu_read_lock();
+	event_upper = netdev_master_upper_dev_get_rcu(event_netdev);
+	rcu_read_unlock();
+	if (!netif_is_ice(event_netdev) || event_upper != lag->upper_netdev)
+		return;
+
+	event_np = netdev_priv(event_netdev);
+	event_pf = event_np->vsi->back;
+	event_port = event_pf->hw.port_info->lport;
+	prim_port = pf->hw.port_info->lport;
+
+	info = (struct netdev_notifier_bonding_info *)ptr;
+	bonding_info = &info->bonding_info;
+
+	if (!bonding_info->slave.state) {
+		/* if no port is currently active, then nodes and filters exist
+		 * on primary port, check if we need to move them
+		 */
+		if (lag->active_port == ICE_LAG_INVALID_PORT) {
+			if (event_port != prim_port)
+				ice_lag_move_vf_nodes(lag, prim_port,
+						      event_port);
+			lag->active_port = event_port;
+			return;
+		}
+
+		/* active port is already set and is current event port */
+		if (lag->active_port == event_port)
+			return;
+		/* new active port */
+		ice_lag_move_vf_nodes(lag, lag->active_port, event_port);
+		lag->active_port = event_port;
+	} else {
+		/* port not set as currently active (e.g. new active port
+		 * has already claimed the nodes and filters
+		 */
+		if (lag->active_port != event_port)
+			return;
+		/* This is the case when neither port is active (both link down)
+		 * Link down on the bond - set active port to invalid and move
+		 * nodes and filters back to primary if not already there
+		 */
+		if (event_port != prim_port)
+			ice_lag_move_vf_nodes(lag, event_port, prim_port);
+		lag->active_port = ICE_LAG_INVALID_PORT;
+	}
 }
 
 /**
@@ -622,6 +1324,69 @@ static void ice_lag_monitor_active(struct ice_lag *lag, void *ptr)
 static bool
 ice_lag_chk_comp(struct ice_lag *lag, void *ptr)
 {
+	struct net_device *event_netdev, *event_upper;
+	struct netdev_notifier_bonding_info *info;
+	struct netdev_bonding_info *bonding_info;
+	struct list_head *tmp;
+	int count = 0;
+
+	if (!lag->primary)
+		return true;
+
+	event_netdev = netdev_notifier_info_to_dev(ptr);
+	rcu_read_lock();
+	event_upper = netdev_master_upper_dev_get_rcu(event_netdev);
+	rcu_read_unlock();
+	if (event_upper != lag->upper_netdev)
+		return true;
+
+	info = (struct netdev_notifier_bonding_info *)ptr;
+	bonding_info = &info->bonding_info;
+	lag->bond_mode = bonding_info->master.bond_mode;
+	if (lag->bond_mode != BOND_MODE_ACTIVEBACKUP) {
+		netdev_info(lag->netdev, "Bond Mode not ACTIVE-BACKUP\n");
+		return false;
+	}
+
+	list_for_each(tmp, lag->netdev_head) {
+		struct ice_dcbx_cfg *dcb_cfg, *peer_dcb_cfg;
+		struct ice_lag_netdev_list *entry;
+		struct ice_netdev_priv *peer_np;
+		struct net_device *peer_netdev;
+		struct ice_vsi *vsi, *peer_vsi;
+
+		entry = list_entry(tmp, struct ice_lag_netdev_list, node);
+		peer_netdev = entry->netdev;
+		if (!netif_is_ice(peer_netdev)) {
+			netdev_info(lag->netdev, "Found non-ice netdev in LAG\n");
+			return false;
+		}
+
+		count++;
+		if (count > 2) {
+			netdev_info(lag->netdev, "Found more than two netdevs in LAG\n");
+			return false;
+		}
+
+		peer_np = netdev_priv(peer_netdev);
+		vsi = ice_get_main_vsi(lag->pf);
+		peer_vsi = peer_np->vsi;
+		if (lag->pf->pdev->bus != peer_vsi->back->pdev->bus ||
+		    lag->pf->pdev->slot != peer_vsi->back->pdev->slot) {
+			netdev_info(lag->netdev, "Found netdev on different device in LAG\n");
+			return false;
+		}
+
+		dcb_cfg = &vsi->port_info->qos_cfg.local_dcbx_cfg;
+		peer_dcb_cfg = &peer_vsi->port_info->qos_cfg.local_dcbx_cfg;
+		if (memcmp(dcb_cfg, peer_dcb_cfg,
+			   sizeof(struct ice_dcbx_cfg))) {
+			netdev_info(lag->netdev, "Found netdev with different DCB config in LAG\n");
+			return false;
+		}
+
+	}
+
 	return true;
 }
 
@@ -857,17 +1622,40 @@ static void ice_unregister_lag_handler(struct ice_lag *lag)
 /**
  * ice_create_lag_recipe
  * @hw: pointer to HW struct
+ * @rid: pointer to u16 to pass back recipe index
  * @base_recipe: recipe to base the new recipe on
  * @prio: priority for new recipe
  *
  * function returns 0 on error
  */
-static u16 ice_create_lag_recipe(struct ice_hw *hw, const u8 *base_recipe,
-				 u8 prio)
+static int ice_create_lag_recipe(struct ice_hw *hw, u16 *rid,
+				 const u8 *base_recipe, u8 prio)
 {
-	u16 rid = 0;
+	struct ice_aqc_recipe_data_elem *new_rcp;
+	int err;
+
+	err = ice_alloc_recipe(hw, rid);
+	if (err)
+		return err;
+
+	new_rcp = kzalloc(ICE_RECIPE_LEN * ICE_MAX_NUM_RECIPES, GFP_KERNEL);
+	if (!new_rcp)
+		return -ENOMEM;
+
+	memcpy(new_rcp, base_recipe, ICE_RECIPE_LEN);
+	new_rcp->content.act_ctrl_fwd_priority = prio;
+	new_rcp->content.rid = *rid | ICE_AQ_RECIPE_ID_IS_ROOT;
+	new_rcp->recipe_indx = *rid;
+	bitmap_zero((unsigned long *)new_rcp->recipe_bitmap,
+		    ICE_MAX_NUM_RECIPES);
+	set_bit(*rid, (unsigned long *)new_rcp->recipe_bitmap);
 
-	return rid;
+	err = ice_aq_add_recipe(hw, new_rcp, 1, NULL);
+	if (err)
+		*rid = 0;
+
+	kfree(new_rcp);
+	return err;
 }
 
 /**
@@ -882,7 +1670,8 @@ int ice_init_lag(struct ice_pf *pf)
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_lag *lag;
 	struct ice_vsi *vsi;
-	int err;
+	u64 recipe_bits = 0;
+	int n, err;
 
 	ice_lag_init_feature_support_flag(pf);
 
@@ -901,6 +1690,7 @@ int ice_init_lag(struct ice_pf *pf)
 	lag->pf = pf;
 	lag->netdev = vsi->netdev;
 	lag->role = ICE_LAG_NONE;
+	lag->active_port = ICE_LAG_INVALID_PORT;
 	lag->bonded = false;
 	lag->upper_netdev = NULL;
 	lag->notif_block.notifier_call = NULL;
@@ -911,10 +1701,23 @@ int ice_init_lag(struct ice_pf *pf)
 		goto lag_error;
 	}
 
-	lag->pf_recipe = ice_create_lag_recipe(&pf->hw, ice_dflt_vsi_rcp, 1);
-	if (!lag->pf_recipe) {
-		err = -EINVAL;
+	err = ice_create_lag_recipe(&pf->hw, &lag->pf_recipe, ice_dflt_vsi_rcp,
+				    1);
+	if (err)
 		goto lag_error;
+
+	/* associate recipes to profiles */
+	for (n = 0; n < ICE_PROFID_IPV6_GTPU_IPV6_TCP_INNER; n++) {
+		err = ice_aq_get_recipe_to_profile(&pf->hw, n,
+						   (u8 *)&recipe_bits, NULL);
+		if (err)
+			continue;
+
+		if (recipe_bits & BIT(ICE_SW_LKUP_DFLT)) {
+			recipe_bits |= BIT(lag->pf_recipe);
+			ice_aq_map_recipe_to_profile(&pf->hw, n,
+						     (u8 *)&recipe_bits, NULL);
+		}
 	}
 
 	ice_display_lag_info(lag);
-- 
2.40.1



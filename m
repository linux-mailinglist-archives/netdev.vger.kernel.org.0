Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098AB565404
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 13:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiGDLpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 07:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiGDLpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 07:45:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC4311455
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 04:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656935121; x=1688471121;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Hsl4o7a8lGZ47UI58kpx07aYSa6ttNKXfvrqUCmRKX0=;
  b=QBD1NkRknRsty7dT+oOdflcIFQp041B6ikXymsaXYc13We4gdqISGIKj
   69nex+tllEdnjbtfCq+dO/sfFL60x2ssPQ9VsYcAJYet9QJgrCrL8URXk
   nd1PWGYU/r2A4zsz8XfmVD2nqXyBs79tsIJuHQiCrFeZZxFt4OaD9kYIU
   tmJkOLlbHBDbVoxHx1wh0O1dOwDawuWDxsMSJTY5SxrXgqPHB9RMnAGfu
   2qpDMat1iory91y0VxFPTxvqJxvlQlMpSoisdsAAlAD6oh0gRGfP+65dd
   b0M5Xvx7cByflioGn9A8HxOed3eLWLW5qBpeHtIMJVaPxp2I6UAliTxfG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="266134450"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="266134450"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 04:45:21 -0700
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="567200692"
Received: from moradin.igk.intel.com ([10.123.220.12])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 04:45:20 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [RFC] ice: Reconfigure tx scheduling for SR-IOV
Date:   Mon,  4 Jul 2022 13:45:13 +0200
Message-Id: <20220704114513.2958937-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're trying to find a way to reconfigure tx scheduling in hardware using
linux tc-htb tool. To accomplish that use of tc-htb offload mechanism is
proposed. It was introduced in this commit to the linux kernel:
commit d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")

Example configuration:

tc qdisc replace dev ens785 root handle 1: htb offload
tc class add dev ens785 parent 1: classid 1:2 htb rate 1000 ceil 2000
tc class add dev ens785 parent 1:2 classid 1:3 htb rate 1000 ceil 2000
tc class add dev ens785 parent 1:2 classid 1:4 htb rate 1000 ceil 2000
tc class add dev ens785 parent 1:3 classid 1:5 htb rate 1000 ceil 2000
tc class add dev ens785 parent 1:4 classid 1:6 htb rate 1000 ceil 2000
tc qdisc add dev ens785 parent 1:6 handle 9: pfifo

After each tc command ice_setup_tc() is called. This way parameters can be
received from user space.

Kernel thinks that this is supposed to create a following tree:

                  1:    <-- root qdisc
                  |
                 1:2
                 / \
                /   \
              1:3   1:4
               |     |
               |     |
              1:5   1:6
               |     |
              QID   QID   <---- here we'll have PFIFO qdiscs

For each node rate and ceil parameters are set. Thanks to that algorithm
knows how to prioritize traffic. As shown on the picture on the leaf
nodes there are queues present.
If we were to follow normal flow, we would now use tc-filter family of
commands to direct types of interesting traffic to the correct nodes.
That is NOT the case in this implementation. In this POC, meaningful
classid number identifies scheduling node. Number of qdisc handle is a
queue number in a PF space. Reason for this - we want to support ALL
queues on the card including SR-IOV ones that are assigned to VF
netdevs.

Unfortunately this leaves us with a situation where we have to provide
queues to the kernel, which will never be used.

So the tree in hardware would look like this:

                 Root            Layer 0
                  ||
                  TC             Layer 1
                  ||
                 1:2             Layer 2
                 / \
              1:3   1:4          Layer 3
               |     |
               |     |
              1:5   1:6          Layer 4
                     |
                 Queue nr 9

We can have up to 5, or 9 layers. According to HAS there is no
obligation to create all 5 or 9 layers. Extra pass-through layers will
be created in the firmware. Also single TC node is left, cause we can't
really remove this in the software. It is treated as our root node.

So usual flow for this implementations goes like this:

1. tc-htb command replace root qdisc
   a) Queue metadata is saved to an array (which I will replace as a
list in real implementation). Reason for this - AQ 0x0C32 (Move /
Reconfigure TX queue) requires this to successfully reconfigure queue
later.

   b) Whole tree is deleted from the software. Queues still remain in
the firmware, but they are in the orphaned state. (I wonder if I should
suspend them through AQ command).

2. tc-htb adds new class
   a) New scheduling node is added through AQ 0x0401 (Add Scheduling
Elements). Also node is added to SW DB. New BW profiles are created
through AQ 0x0410 (Add RL profiles) and attached to the scheduling node.
   b) Most controversially, as was stated before there is a need to
provide linux kernel with a correct queue id. The queue also has to be
brand new without qdisc attached to it, cause HTB would like to create it's
own PFIFO qdisc. I had to work around this by resizing number of queues
using netif_set_real_num_tx_queues() and providing htb with qid of newly
allocated queue. If this is accepted, it needs some further work to
align it with our vsi/queue rebuilds mechanism in the driver.

3. tc-htb adds qdisc to the leaf class
   a) AQ 0x0C32 (Move /Reconfigure TX queue) is executed to change queue
position. Metadata for the AQ call is taken from orphaned array.

There are still a lot of holes in the implementation. What works for now
as ususally for POC's is a single 'happy path' that aligns with my
testing. Almost no error handling is implemented yet, there will be also
some further changes need to data structures.

I'm mostly hoping for some feedback regarding general direction of
changes.

TL;DR

There is a mellanox implementation of tc-htb offload mechanism,
unfortunately it doesn't support SR-IOV queues, only PF queues. We're
wondering how we could enable SR-IOV queues for the tc-htb.
Alternatively we're looking for other possible ways of handling this
problem, any feedback will be greatly appreciated.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  38 ++
 drivers/net/ethernet/intel/ice/ice_common.c   |  62 +++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   8 +
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 332 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_sched.c    |  15 +-
 drivers/net/ethernet/intel/ice/ice_sched.h    |  16 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 9 files changed, 468 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 60453b3b8d23..fb00ad364b2a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -319,6 +319,8 @@ struct ice_vsi {
 
 	u64 tx_linearize;
 	DECLARE_BITMAP(state, ICE_VSI_STATE_NBITS);
+	DECLARE_BITMAP(avail_qos_qids, 1024);
+	u32 num_qos_tx;
 	unsigned int current_netdev_flags;
 	u32 tx_restart;
 	u32 tx_busy;
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 05cb9dd7035a..8f5c1b9d72f2 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1854,6 +1854,41 @@ struct ice_aqc_dis_txq_item {
 	__le16 q_id[];
 } __packed;
 
+struct ice_aqc_move_txqs {
+	u8 cmd_type;
+#define ICE_AQC_Q_CMD_TYPE_S		0
+#define ICE_AQC_Q_CMD_TYPE_M		(0x3 << ICE_AQC_Q_CMD_TYPE_S)
+#define ICE_AQC_Q_CMD_TYPE_MOVE		1
+#define ICE_AQC_Q_CMD_TYPE_TC_CHANGE	2
+#define ICE_AQC_Q_CMD_TYPE_MOVE_AND_TC	3
+#define ICE_AQC_Q_CMD_SUBSEQ_CALL	BIT(2)
+#define ICE_AQC_Q_CMD_FLUSH_PIPE	BIT(3)
+	u8 num_qs;
+	u8 rsvd;
+	u8 timeout;
+#define ICE_AQC_Q_CMD_TIMEOUT_S		2
+#define ICE_AQC_Q_CMD_TIMEOUT_M		(0x3F << ICE_AQC_Q_CMD_TIMEOUT_S)
+	__le32 blocked_cgds;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+struct ice_aqc_move_txqs_elem {
+	__le16 txq_id;
+	u8 q_cgd;
+	u8 rsvd;
+#ifndef EXTERNAL_RELEASE
+	/* EAS1.1 has 2 byte TEID, but it is 4-bytes. Moved for alignment */
+#endif /* EXTERNAL_RELEASE */
+	__le32 q_teid;
+};
+
+struct ice_aqc_move_txqs_data {
+	__le32 src_teid;
+	__le32 dest_teid;
+	struct ice_aqc_move_txqs_elem txqs[1];
+};
+
 /* Add Tx RDMA Queue Set (indirect 0x0C33) */
 struct ice_aqc_add_rdma_qset {
 	u8 num_qset_grps;
@@ -2090,6 +2125,7 @@ struct ice_aq_desc {
 		struct ice_aqc_get_topo get_topo;
 		struct ice_aqc_sched_elem_cmd sched_elem_cmd;
 		struct ice_aqc_query_txsched_res query_sched_res;
+		struct ice_aqc_move_txqs move_txqs;
 		struct ice_aqc_query_port_ets port_ets;
 		struct ice_aqc_rl_profile rl_profile;
 		struct ice_aqc_nvm nvm;
@@ -2149,6 +2185,7 @@ enum ice_aq_err {
 	ICE_AQ_RC_OK		= 0,  /* Success */
 	ICE_AQ_RC_EPERM		= 1,  /* Operation not permitted */
 	ICE_AQ_RC_ENOENT	= 2,  /* No such element */
+	ICE_AQ_RC_EAGAIN	= 8,  /* Try again */
 	ICE_AQ_RC_ENOMEM	= 9,  /* Out of memory */
 	ICE_AQ_RC_EBUSY		= 12, /* Device or resource busy */
 	ICE_AQ_RC_EEXIST	= 13, /* Object already exists */
@@ -2281,6 +2318,7 @@ enum ice_adminq_opc {
 	/* Tx queue handling commands/events */
 	ice_aqc_opc_add_txqs				= 0x0C30,
 	ice_aqc_opc_dis_txqs				= 0x0C31,
+	ice_aqc_opc_move_recfg_txqs			= 0x0C32,
 	ice_aqc_opc_add_rdma_qset			= 0x0C33,
 
 	/* package commands */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 9619bdb9e49a..138e05c7a06b 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3932,6 +3932,63 @@ ice_aq_dis_lan_txq(struct ice_hw *hw, u8 num_qgrps,
 	return status;
 }
 
+int
+ice_aq_move_recfg_lan_txq(struct ice_hw *hw, u8 num_qs, bool is_move,
+			  bool is_tc_change, bool subseq_call, bool flush_pipe,
+			  u8 timeout, u32 *blocked_cgds,
+			  struct ice_aqc_move_txqs_data *buf, u16 buf_size,
+			  u8 *txqs_moved, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_move_txqs *cmd;
+	struct ice_aq_desc desc;
+	int status;
+
+	cmd = &desc.params.move_txqs;
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_move_recfg_txqs);
+
+#ifndef EXTERNAL_RELEASE
+	/* from CPK HAS 1.5 table 10-40 */
+#endif /* !EXTERNAL_RELEASE */
+#define ICE_LAN_TXQ_MOVE_TIMEOUT_MAX 50
+	if (timeout > ICE_LAN_TXQ_MOVE_TIMEOUT_MAX)
+		return -EINVAL;
+
+	if (is_tc_change && !flush_pipe && !blocked_cgds)
+		return -EINVAL;
+
+	if (!is_move && !is_tc_change)
+		return -EINVAL;
+
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	if (is_move)
+		cmd->cmd_type |= ICE_AQC_Q_CMD_TYPE_MOVE;
+
+	if (is_tc_change)
+		cmd->cmd_type |= ICE_AQC_Q_CMD_TYPE_TC_CHANGE;
+
+	if (subseq_call)
+		cmd->cmd_type |= ICE_AQC_Q_CMD_SUBSEQ_CALL;
+
+	if (flush_pipe)
+		cmd->cmd_type |= ICE_AQC_Q_CMD_FLUSH_PIPE;
+
+	cmd->num_qs = num_qs;
+	cmd->timeout = ((timeout << ICE_AQC_Q_CMD_TIMEOUT_S) &
+			ICE_AQC_Q_CMD_TIMEOUT_M);
+
+	status = ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
+
+	if (!status && txqs_moved)
+		*txqs_moved = cmd->num_qs;
+
+	if (hw->adminq.sq_last_status == ICE_AQ_RC_EAGAIN &&
+	    is_tc_change && !flush_pipe)
+		*blocked_cgds = le32_to_cpu(cmd->blocked_cgds);
+
+	return status;
+}
+
 /**
  * ice_aq_add_rdma_qsets
  * @hw: pointer to the hardware structure
@@ -4325,7 +4382,8 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
 	q_ctx->q_teid = le32_to_cpu(node.node_teid);
 
 	/* add a leaf node into scheduler tree queue layer */
-	status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1, &node);
+	status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1, &node,
+				    buf->txqs[0].txq_id);
 	if (!status)
 		status = ice_sched_replay_q_bw(pi, q_ctx);
 
@@ -4560,7 +4618,7 @@ ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 	for (i = 0; i < num_qsets; i++) {
 		node.node_teid = buf->rdma_qsets[i].qset_teid;
 		ret = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1,
-					 &node);
+					 &node, 0);
 		if (ret)
 			break;
 		qset_teid[i] = le32_to_cpu(node.node_teid);
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 872ea7d2332d..d5bc3316b258 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -176,6 +176,14 @@ int
 ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
 		u8 num_qgrps, struct ice_aqc_add_tx_qgrp *buf, u16 buf_size,
 		struct ice_sq_cd *cd);
+
+int
+ice_aq_move_recfg_lan_txq(struct ice_hw *hw, u8 num_qs, bool is_move,
+			  bool is_tc_change, bool subseq_call, bool flush_pipe,
+			  u8 timeout, u32 *blocked_cgds,
+			  struct ice_aqc_move_txqs_data *buf, u16 buf_size,
+			  u8 *txqs_moved, struct ice_sq_cd *cd);
+
 int ice_replay_vsi(struct ice_hw *hw, u16 vsi_handle);
 void ice_replay_post(struct ice_hw *hw);
 void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 0b146a0d4205..1b0dcd4c0323 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -1580,7 +1580,7 @@ ice_update_port_tc_tree_cfg(struct ice_port_info *pi,
 		/* new TC */
 		status = ice_sched_query_elem(pi->hw, teid2, &elem);
 		if (!status)
-			status = ice_sched_add_node(pi, 1, &elem);
+			status = ice_sched_add_node(pi, 1, &elem, 0);
 		if (status)
 			break;
 		/* update the TC number */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c1ac2f746714..ef78256009b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -7251,6 +7251,8 @@ const char *ice_aq_str(enum ice_aq_err aq_err)
 	switch (aq_err) {
 	case ICE_AQ_RC_OK:
 		return "OK";
+	case ICE_AQ_RC_EAGAIN:
+		return "ICE_AQ_RC_EAGAIN";
 	case ICE_AQ_RC_EPERM:
 		return "ICE_AQ_RC_EPERM";
 	case ICE_AQ_RC_ENOENT:
@@ -8588,6 +8590,332 @@ static int ice_setup_tc_mqprio_qdisc(struct net_device *netdev, void *type_data)
 	return ret;
 }
 
+#define INTEL_QOS_QID_INNER 0xffff
+#define INTEL_HTB_CLASSID_ROOT 0xffffffff
+
+/* this will become a list in final implementation */
+static struct ice_sched_node orphaned_leaf_nodes[1024];
+static u32 nr_of_orphaned_leaf_nodes;
+
+static u16 ice_get_free_qid(struct net_device *netdev, struct ice_vsi *vsi)
+{
+	int i;
+
+	for (i = 0; i < vsi->num_qos_tx; i++) {
+		if (!test_bit(i, vsi->avail_qos_qids)) {
+			/* currently freeing qid's is not implemented yet */
+			set_bit(i, vsi->avail_qos_qids);
+			return vsi->num_qos_tx + i;
+		}
+	}
+	set_bit(vsi->num_qos_tx, vsi->avail_qos_qids);
+	vsi->num_qos_tx++;
+
+	netif_set_real_num_tx_queues(netdev, vsi->num_txq + vsi->num_qos_tx);
+	return vsi->num_txq + vsi->num_qos_tx - 1;
+}
+
+static struct ice_sched_node *ice_look_for_classid(struct ice_sched_node *node, u16 classid)
+{
+	struct ice_sched_node *tmp;
+	int i;
+
+	if (node->classid == classid)
+		return node;
+
+	for (i = 0; i < node->num_children; i++) {
+		tmp = ice_look_for_classid(node->children[i], classid);
+		if (tmp)
+			return tmp;
+	}
+
+	return NULL;
+}
+
+static struct ice_sched_node *ice_look_for_pf_queue_id(struct ice_sched_node *node, u16 pf_queue_id)
+{
+	struct ice_sched_node *tmp;
+	int i;
+
+	if (node->info.data.elem_type == ICE_AQC_ELEM_TYPE_LEAF) {
+		if (node->pf_queue_id == pf_queue_id)
+			return node;
+	}
+
+	for (i = 0; i < node->num_children; i++) {
+		tmp = ice_look_for_pf_queue_id(node->children[i], pf_queue_id);
+		if (tmp)
+			return tmp;
+	}
+
+	return NULL;
+}
+
+static struct ice_sched_node *ice_look_for_orphaned_queue_id(u16 pf_queue_id)
+{
+	int i;
+
+	for (i = 0; i < nr_of_orphaned_leaf_nodes; i++) {
+		if (pf_queue_id == orphaned_leaf_nodes[i].pf_queue_id)
+			return &orphaned_leaf_nodes[i];
+	}
+
+	return NULL;
+}
+
+static int ice_reassign_leaf_node(struct ice_port_info *pi, struct ice_hw *hw,
+				  struct ice_sched_node *src_node,
+				  struct ice_sched_node *dst_node)
+{
+	struct ice_aqc_move_txqs_data *buf;
+	u32 blocked_cgds;
+	u8 txqs_moved;
+	u16 buf_size;
+	int status;
+
+	buf_size = struct_size(buf, txqs, 1);
+	buf = kzalloc(buf_size, GFP_KERNEL);
+
+	buf->src_teid = src_node->info.parent_teid;
+	buf->dest_teid = dst_node->info.node_teid;
+	buf->txqs[0].txq_id = src_node->pf_queue_id;
+	buf->txqs[0].q_cgd = 0;
+	buf->txqs[0].q_teid = src_node->info.node_teid;
+
+	status = ice_aq_move_recfg_lan_txq(hw, 1, true, false, false, false, 50,
+					   &blocked_cgds, buf, buf_size, &txqs_moved, NULL);
+
+	if (!status) {
+		struct ice_aqc_txsched_elem_data info;
+
+		info = src_node->info;
+		info.parent_teid = dst_node->info.node_teid;
+
+		status = ice_sched_add_node(pi, dst_node->tx_sched_layer + 1, &info,
+					    buf->txqs[0].txq_id);
+	}
+
+	kfree(buf);
+
+	return status;
+}
+
+int ice_add_node_to_topology(struct ice_vsi *vsi, struct ice_sched_node *tc_node,
+			     struct ice_port_info *pi, u32 parent_classid, u16 classid,
+			     u64 rate, u64 ceil, bool alloc_new_qid)
+{
+	struct net_device *netdev = vsi->netdev;
+	struct ice_sched_node *parent_node;
+	struct ice_sched_node *new_node;
+	u16 num_nodes_added;
+	u32 first_node_teid;
+	int status;
+
+	rate = rate * 8;
+	ceil = ceil * 8;
+
+	if (rate < ICE_SCHED_MIN_BW || rate > ICE_SCHED_MAX_BW)
+		return -EINVAL;
+
+	if (ceil < ICE_SCHED_MIN_BW || ceil > ICE_SCHED_MAX_BW)
+		return -EINVAL;
+
+	parent_node = ice_look_for_classid(tc_node, parent_classid);
+	if (!parent_node)
+		return -EINVAL;
+
+	status = ice_sched_add_elems(pi, tc_node, parent_node, parent_node->tx_sched_layer + 1,
+				     1, &num_nodes_added, &first_node_teid);
+
+	if (status) {
+		netdev_err(netdev, "Can't insert element to topology status %d\n", status);
+		return -ENOENT;
+	}
+
+	new_node = ice_sched_find_node_by_teid(parent_node, first_node_teid);
+
+	if (alloc_new_qid) {
+		new_node->qid = ice_get_free_qid(netdev, vsi);
+	} else {
+		new_node->qid = parent_node->qid;
+		parent_node->qid = INTEL_QOS_QID_INNER;
+	}
+
+	new_node->classid = classid;
+
+	mutex_lock(&pi->sched_lock);
+	status = ice_sched_set_node_bw_lmt(pi, new_node, ICE_MIN_BW, rate);
+
+	if (status) {
+		netdev_err(netdev, "Can't set scheduling node rate, status %d\n", status);
+		mutex_unlock(&pi->sched_lock);
+		return -ENOENT;
+	}
+
+	status = ice_sched_set_node_bw_lmt(pi, new_node, ICE_MAX_BW, ceil);
+
+	if (status) {
+		netdev_err(netdev, "Can't set scheduling node ceil, status %d\n", status);
+		mutex_unlock(&pi->sched_lock);
+		return -ENOENT;
+	}
+
+	mutex_unlock(&pi->sched_lock);
+
+	return 0;
+}
+
+static void ice_save_orphaned_nodes(struct ice_sched_node *node)
+{
+	int i;
+
+	if (node->info.data.elem_type == ICE_AQC_ELEM_TYPE_LEAF) {
+		memcpy(&orphaned_leaf_nodes[nr_of_orphaned_leaf_nodes],
+		       node, sizeof(struct ice_sched_node));
+		nr_of_orphaned_leaf_nodes++;
+		return;
+	}
+
+	for (i = 0; i < node->num_children; i++)
+		ice_save_orphaned_nodes(node->children[i]);
+}
+
+static int ice_setup_tc_fifo(struct ice_netdev_priv *np, struct tc_fifo_qopt_offload *fifo)
+{
+	struct ice_port_info *pi = np->vsi->port_info;
+	struct net_device *netdev = np->vsi->netdev;
+	struct ice_sched_node *src_node;
+	struct ice_sched_node *dst_node;
+	struct ice_sched_node *tc_node;
+	struct ice_hw *hw  = pi->hw;
+	u32 handle, parent;
+	int status;
+
+	tc_node = pi->root->children[0];
+
+	/* we only care about major number so let's just shift minor left */
+	handle = fifo->handle >> 16;
+
+	/* we care about minor here so take first 16 bits only */
+	parent = fifo->parent & 0xFFFF;
+
+	switch (fifo->command) {
+	case TC_FIFO_REPLACE:
+		dst_node = ice_look_for_classid(tc_node, parent);
+
+		if (!dst_node)
+			return -EINVAL;
+
+		/* first look among orphaned queues */
+		src_node = ice_look_for_orphaned_queue_id(handle);
+
+		/* normally we would also look among non-orphaned nodes
+		 * but we can skip that for the purpose of the RFC
+		 *
+		 * if (src_node == NULL) {
+		 *
+		 * src_node = ice_look_for_pf_queue_id(tc_node, handle);
+		 * }
+		 */
+		if (!src_node)
+			return -EINVAL;
+
+		status = ice_reassign_leaf_node(pi, hw, src_node, dst_node);
+
+		if (status) {
+			netdev_err(netdev, "Failed to reassign queue\n");
+			return -ENOENT;
+		}
+
+		break;
+
+	default:
+		return -ENOENT;
+	}
+	return 0;
+}
+
+static int ice_setup_tc_htb(struct ice_netdev_priv *np, struct tc_htb_qopt_offload *htb)
+{
+	struct ice_port_info *pi = np->vsi->port_info;
+	struct net_device *netdev = np->vsi->netdev;
+	struct ice_pf *pf = np->vsi->back;
+	struct ice_sched_node *tc_node;
+	struct ice_sched_node *node;
+	struct ice_hw *hw  = pi->hw;
+	int err = 0;
+	int i;
+
+	tc_node = pi->root->children[0];
+
+	switch (htb->command) {
+	case TC_HTB_CREATE:
+		if (pi->root->num_children != 1) {
+			netdev_err(netdev, "Tree should contain only one TC before configuring HTB\n");
+			return -EINVAL;
+		}
+
+		if (ice_is_adq_active(pf)) {
+			netdev_err(netdev, "HTB is mutally exclusive with ADQ\n");
+			return -EINVAL;
+		}
+
+		tc_node = pi->root->children[0];
+		tc_node->classid = INTEL_HTB_CLASSID_ROOT;
+		tc_node->qid = INTEL_QOS_QID_INNER;
+
+		for (i = 0; i < tc_node->num_children; i++) {
+			ice_save_orphaned_nodes(tc_node->children[i]);
+			ice_free_sched_node(pi, tc_node->children[i]);
+		}
+
+	break;
+
+	case TC_HTB_DESTROY:
+	/* in this case we need to restore tree structure from the NVM */
+	/* try to schedule a CORER from here */
+		ice_schedule_reset(np->vsi->back, ICE_RESET_CORER);
+	break;
+
+	case TC_HTB_LEAF_TO_INNER:
+		return ice_add_node_to_topology(np->vsi, tc_node, pi, htb->parent_classid,
+						htb->classid, htb->rate, htb->ceil, false);
+	break;
+
+	case TC_HTB_LEAF_ALLOC_QUEUE:
+		tc_node = pi->root->children[0];
+
+		err = ice_add_node_to_topology(np->vsi, tc_node, pi, htb->parent_classid,
+					       htb->classid, htb->rate, htb->ceil, true);
+		if (err)
+			return err;
+
+		node = ice_look_for_classid(tc_node, htb->classid);
+		htb->qid = node->qid;
+	break;
+
+	case TC_HTB_LEAF_DEL:
+		node = ice_look_for_classid(tc_node, htb->classid);
+		ice_free_sched_node(pi, node);
+	break;
+
+	case TC_HTB_LEAF_DEL_LAST:
+		node = ice_look_for_classid(tc_node, htb->classid);
+		ice_free_sched_node(pi, node);
+	break;
+
+	case TC_HTB_LEAF_QUERY_QUEUE:
+		node = ice_look_for_classid(tc_node, htb->classid);
+		htb->qid = node->qid;
+	break;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static LIST_HEAD(ice_block_cb_list);
 
 static int
@@ -8610,6 +8938,10 @@ ice_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 		err = ice_setup_tc_mqprio_qdisc(netdev, type_data);
 		mutex_unlock(&pf->tc_mutex);
 		return err;
+	case TC_SETUP_QDISC_HTB:
+		return ice_setup_tc_htb(np, type_data);
+	case TC_SETUP_QDISC_FIFO:
+		return ice_setup_tc_fifo(np, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 7947223536e3..ff5d0e1af13c 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -147,7 +147,7 @@ ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
  */
 int
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
-		   struct ice_aqc_txsched_elem_data *info)
+		   struct ice_aqc_txsched_elem_data *info, u16 txq_id)
 {
 	struct ice_aqc_txsched_elem_data elem;
 	struct ice_sched_node *parent;
@@ -190,6 +190,9 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 		}
 	}
 
+	if (info->data.elem_type == ICE_AQC_ELEM_TYPE_LEAF)
+		node->pf_queue_id = txq_id;
+
 	node->in_use = true;
 	node->parent = parent;
 	node->tx_sched_layer = layer;
@@ -875,7 +878,7 @@ void ice_sched_cleanup_all(struct ice_hw *hw)
  *
  * This function add nodes to HW as well as to SW DB for a given layer
  */
-static int
+int
 ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 		    struct ice_sched_node *parent, u8 layer, u16 num_nodes,
 		    u16 *num_nodes_added, u32 *first_node_teid)
@@ -924,7 +927,7 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 	*num_nodes_added = num_nodes;
 	/* add nodes to the SW DB */
 	for (i = 0; i < num_nodes; i++) {
-		status = ice_sched_add_node(pi, layer, &buf->generic[i]);
+		status = ice_sched_add_node(pi, layer, &buf->generic[i], 0);
 		if (status) {
 			ice_debug(hw, ICE_DBG_SCHED, "add nodes in SW DB failed status =%d\n",
 				  status);
@@ -1268,7 +1271,7 @@ int ice_sched_init_port(struct ice_port_info *pi)
 			    ICE_AQC_ELEM_TYPE_ENTRY_POINT)
 				hw->sw_entry_point_layer = j;
 
-			status = ice_sched_add_node(pi, j, &buf[i].generic[j]);
+			status = ice_sched_add_node(pi, j, &buf[i].generic[j], 0);
 			if (status)
 				goto err_init_port;
 		}
@@ -3560,7 +3563,7 @@ ice_sched_set_eir_srl_excl(struct ice_port_info *pi,
  * node's RL profile ID of type CIR, EIR, or SRL, and removes old profile
  * ID from local database. The caller needs to hold scheduler lock.
  */
-static int
+int
 ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
 		      enum ice_rl_type rl_type, u32 bw, u8 layer_num)
 {
@@ -3606,7 +3609,7 @@ ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
  * It updates node's BW limit parameters like BW RL profile ID of type CIR,
  * EIR, or SRL. The caller needs to hold scheduler lock.
  */
-static int
+int
 ice_sched_set_node_bw_lmt(struct ice_port_info *pi, struct ice_sched_node *node,
 			  enum ice_rl_type rl_type, u32 bw)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.h b/drivers/net/ethernet/intel/ice/ice_sched.h
index 4f91577fed56..b906ec1b8563 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.h
+++ b/drivers/net/ethernet/intel/ice/ice_sched.h
@@ -69,6 +69,20 @@ int
 ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
 			 struct ice_aqc_txsched_elem_data *buf, u16 buf_size,
 			 u16 *elems_ret, struct ice_sq_cd *cd);
+
+int
+ice_sched_set_node_bw_lmt(struct ice_port_info *pi, struct ice_sched_node *node,
+			  enum ice_rl_type rl_type, u32 bw);
+
+int
+ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
+		      enum ice_rl_type rl_type, u32 bw, u8 layer_num);
+
+int
+ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
+		    struct ice_sched_node *parent, u8 layer, u16 num_nodes,
+		    u16 *num_nodes_added, u32 *first_node_teid);
+
 int ice_sched_init_port(struct ice_port_info *pi);
 int ice_sched_query_res_alloc(struct ice_hw *hw);
 void ice_sched_get_psm_clk_freq(struct ice_hw *hw);
@@ -81,7 +95,7 @@ struct ice_sched_node *
 ice_sched_find_node_by_teid(struct ice_sched_node *start_node, u32 teid);
 int
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
-		   struct ice_aqc_txsched_elem_data *info);
+		   struct ice_aqc_txsched_elem_data *info, u16 txq_id);
 void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node);
 struct ice_sched_node *ice_sched_get_tc_node(struct ice_port_info *pi, u8 tc);
 struct ice_sched_node *
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index f2a518a1fd94..d6191b343dc0 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -523,7 +523,10 @@ struct ice_sched_node {
 	struct ice_sched_node **children;
 	struct ice_aqc_txsched_elem_data info;
 	u32 agg_id;			/* aggregator group ID */
+	u32 pf_queue_id;
 	u16 vsi_handle;
+	u32 classid;
+	u16 qid;
 	u8 in_use;			/* suspended or in use */
 	u8 tx_sched_layer;		/* Logical Layer (1-9) */
 	u8 num_children;
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BBE23229D
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgG2QYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:42161 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgG2QYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:17 -0400
IronPort-SDR: P9tMeyueUK3C/adXKMPz08Tp/wZqQOqakp89ADtfa5yvI2PqlRj0Ayt9UVqtkgnhsjOgfSppAZ
 K01I6vW9px+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982339"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982339"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:15 -0700
IronPort-SDR: uk1sy4PT4DVH4+AagVmwhfinmxolhSkVDyuETtUVDmkLyRXPI8zxPES93FfSVY5cmLGopAD1UN
 2hdRtdNe1m2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087582"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Victor Raj <victor.raj@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 09/15] ice: distribute Tx queues evenly
Date:   Wed, 29 Jul 2020 09:23:59 -0700
Message-Id: <20200729162405.1596435-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Raj <victor.raj@intel.com>

Distribute the Tx queues evenly across all queue groups. This will
help the queues to get more equal sharing among the queues when all
are in use.

In the previous algorithm, the next queue group node will be picked up
only after the previous one filled with max children.
For example: if VSI is configured with 9 queues, the first 8 queues
will be assigned to queue group 1 and the 9th queue will be assigned to
queue group 2.

The 2 queue groups split the bandwidth between them equally (50:50).
The first queue group node will share the 50% bandwidth with all of
its children (8 queues). And the second queue group node will share
the entire 50% bandwidth with its only children.

The new algorithm will fix this issue.

Signed-off-by: Victor Raj <victor.raj@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 55 ++++++++++++++++++++--
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index ac5b05bb978f..355f727563e4 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1275,6 +1275,53 @@ ice_sched_find_node_in_subtree(struct ice_hw *hw, struct ice_sched_node *base,
 	return false;
 }
 
+/**
+ * ice_sched_get_free_qgrp - Scan all queue group siblings and find a free node
+ * @pi: port information structure
+ * @vsi_node: software VSI handle
+ * @qgrp_node: first queue group node identified for scanning
+ * @owner: LAN or RDMA
+ *
+ * This function retrieves a free LAN or RDMA queue group node by scanning
+ * qgrp_node and its siblings for the queue group with the fewest number
+ * of queues currently assigned.
+ */
+static struct ice_sched_node *
+ice_sched_get_free_qgrp(struct ice_port_info *pi,
+			struct ice_sched_node *vsi_node,
+			struct ice_sched_node *qgrp_node, u8 owner)
+{
+	struct ice_sched_node *min_qgrp;
+	u8 min_children;
+
+	if (!qgrp_node)
+		return qgrp_node;
+	min_children = qgrp_node->num_children;
+	if (!min_children)
+		return qgrp_node;
+	min_qgrp = qgrp_node;
+	/* scan all queue groups until find a node which has less than the
+	 * minimum number of children. This way all queue group nodes get
+	 * equal number of shares and active. The bandwidth will be equally
+	 * distributed across all queues.
+	 */
+	while (qgrp_node) {
+		/* make sure the qgroup node is part of the VSI subtree */
+		if (ice_sched_find_node_in_subtree(pi->hw, vsi_node, qgrp_node))
+			if (qgrp_node->num_children < min_children &&
+			    qgrp_node->owner == owner) {
+				/* replace the new min queue group node */
+				min_qgrp = qgrp_node;
+				min_children = min_qgrp->num_children;
+				/* break if it has no children, */
+				if (!min_children)
+					break;
+			}
+		qgrp_node = qgrp_node->sibling;
+	}
+	return min_qgrp;
+}
+
 /**
  * ice_sched_get_free_qparent - Get a free LAN or RDMA queue group node
  * @pi: port information structure
@@ -1288,7 +1335,7 @@ struct ice_sched_node *
 ice_sched_get_free_qparent(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 			   u8 owner)
 {
-	struct ice_sched_node *vsi_node, *qgrp_node = NULL;
+	struct ice_sched_node *vsi_node, *qgrp_node;
 	struct ice_vsi_ctx *vsi_ctx;
 	u16 max_children;
 	u8 qgrp_layer;
@@ -1302,7 +1349,7 @@ ice_sched_get_free_qparent(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 	vsi_node = vsi_ctx->sched.vsi_node[tc];
 	/* validate invalid VSI ID */
 	if (!vsi_node)
-		goto lan_q_exit;
+		return NULL;
 
 	/* get the first queue group node from VSI sub-tree */
 	qgrp_node = ice_sched_get_first_node(pi, vsi_node, qgrp_layer);
@@ -1315,8 +1362,8 @@ ice_sched_get_free_qparent(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 		qgrp_node = qgrp_node->sibling;
 	}
 
-lan_q_exit:
-	return qgrp_node;
+	/* Select the best queue group */
+	return ice_sched_get_free_qgrp(pi, vsi_node, qgrp_node, owner);
 }
 
 /**
-- 
2.26.2


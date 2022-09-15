Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062325B9C35
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiIONoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiIONoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:44:22 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAFC97504
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663249450; x=1694785450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xA2tByeQTY570d5g+NpWN4w+wbKadSWLlAHl42SSvHc=;
  b=O/MXqx1VQc2QPgK8lwLofgE5WxzZY8Yjh1EtQ2QHGUJcexf8rvakx0aV
   WTcPFBZKN3S5FfcBY9+pv4+NsICMMVD4Ho+vXnOobgnxRI5bJRhT5lSZC
   tHFo4vW+RsqDlvJRCb/NiFyBQRknSanoz838vzNvxhqdX7+cAA9tZD8Ih
   WuAVDs99zO/kwXZC/1dCIoLWJtZSGksQCdPL3LEJszvwKqnnbZE5ZZWEx
   LOVP3f2AQsFYKaULSJFs1L9CgO/hzdYXowHSpbptLccNzgYjtNqbnZILN
   SjetnixgrCtNsr+RTCqcbwzu/eyj6s+HiISSCBt/mB5SwwEAEJ46S74hb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="279100054"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="279100054"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:44:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="617279023"
Received: from unknown (HELO DCG-LAB-MODULE2.gar.corp.intel.com) ([10.123.220.6])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:44:07 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [RFC PATCH net-next v4 6/6] ice: Prevent ADQ, DCB and RDMA coexistence with Custom Tx scheduler
Date:   Thu, 15 Sep 2022 15:42:39 +0200
Message-Id: <20220915134239.1935604-7-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220915134239.1935604-1-michal.wilczynski@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ADQ, DCB and RDMA might interfere with Custom Tx Scheduler changes
that user might introduce using devlink-rate API.

Check if ADQ, DCB or RDMA is active, when user tries to change any
setting in exported Tx scheduler tree.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  4 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 87 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc.c     |  5 ++
 drivers/net/ethernet/intel/ice/ice_type.h    |  1 +
 4 files changed, 97 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index add90e75f05c..8d7fc76f49af 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -364,6 +364,10 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	/* Enable DCB tagging only when more than one TC */
 	if (ice_dcb_get_num_tc(new_cfg) > 1) {
 		dev_dbg(dev, "DCB tagging enabled (num TC > 1)\n");
+		if (pf->hw.port_info->is_custom_tx_enabled) {
+			dev_err(dev, "Custom Tx scheduler feature enabled, can't configure DCB\n");
+			return -EBUSY;
+		}
 		set_bit(ICE_FLAG_DCB_ENA, pf->flags);
 	} else {
 		dev_dbg(dev, "DCB tagging disabled (num TC = 1)\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 925283605b59..5530d8809a42 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -8,6 +8,7 @@
 #include "ice_devlink.h"
 #include "ice_eswitch.h"
 #include "ice_fw_update.h"
+#include "ice_dcb_lib.h"
 
 static int ice_active_port_option = -1;
 
@@ -713,6 +714,44 @@ ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
 	return ice_devlink_port_split(devlink, port, 1, extack);
 }
 
+/**
+ * ice_enable_custom_tx - try to enable custom Tx feature
+ * @pf: devlink struct
+ * @extack: extended netdev ack structure
+ *
+ * This function tries to enabled custom Tx feature,
+ * it's not possible to enable it, if ADQ or DCB is active.
+ */
+static bool ice_enable_custom_tx(struct ice_pf *pf, struct netlink_ext_ack *extack)
+{
+	struct ice_port_info *pi = ice_get_main_vsi(pf)->port_info;
+	struct device *dev = ice_pf_to_dev(pf);
+
+	if (pi->is_custom_tx_enabled)
+		/* already enabled, return true */
+		return true;
+
+	if (ice_is_adq_active(pf)) {
+		dev_err(dev, "ADQ active, can't modify Tx scheduler tree\n");
+		return false;
+	}
+
+	if (ice_is_dcb_active(pf)) {
+		dev_err(dev, "DCB active, can't modify Tx scheduler tree\n");
+		return false;
+	}
+
+	/* check if auxiliary bus is plugged */
+	if (pf->adev) {
+		dev_err(dev, "RDMA active, can't modify Tx scheduler tree\n");
+		return false;
+	}
+
+	pi->is_custom_tx_enabled = true;
+
+	return true;
+}
+
 /**
  * ice_traverse_tx_tree - traverse Tx scheduler tree
  * @devlink: devlink struct
@@ -885,6 +924,9 @@ static struct ice_port_info *ice_get_pi_from_dev_rate(struct devlink_rate *rate_
 static int ice_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv,
 				     struct netlink_ext_ack *extack)
 {
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	return 0;
 }
 
@@ -898,6 +940,9 @@ static int ice_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 	tc_node = pi->root->children[0];
 	node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!rate_node->parent || !node || tc_node == node)
 		return 0;
 
@@ -917,6 +962,9 @@ static int ice_devlink_rate_vport_tx_max_set(struct devlink_rate *rate_vport, vo
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_vport->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -930,6 +978,9 @@ static int ice_devlink_rate_vport_tx_share_set(struct devlink_rate *rate_vport,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_vport->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -943,6 +994,9 @@ static int ice_devlink_rate_vport_tx_priority_set(struct devlink_rate *rate_vpor
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_vport->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -956,6 +1010,9 @@ static int ice_devlink_rate_vport_tx_weight_set(struct devlink_rate *rate_vport,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_vport->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -969,6 +1026,9 @@ static int ice_devlink_rate_node_tx_max_set(struct devlink_rate *rate_node, void
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -982,6 +1042,9 @@ static int ice_devlink_rate_node_tx_share_set(struct devlink_rate *rate_node, vo
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -995,6 +1058,9 @@ static int ice_devlink_rate_node_tx_priority_set(struct devlink_rate *rate_node,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1008,6 +1074,9 @@ static int ice_devlink_rate_node_tx_weight_set(struct devlink_rate *rate_node, v
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1021,6 +1090,9 @@ static int ice_devlink_rate_queue_tx_max_set(struct devlink_rate *rate_queue, vo
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_queue->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1034,6 +1106,9 @@ static int ice_devlink_rate_queue_tx_share_set(struct devlink_rate *rate_queue,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_queue->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1047,6 +1122,9 @@ static int ice_devlink_rate_queue_tx_priority_set(struct devlink_rate *rate_queu
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_queue->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1060,6 +1138,9 @@ static int ice_devlink_rate_queue_tx_weight_set(struct devlink_rate *rate_queue,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_queue->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1083,6 +1164,9 @@ static int ice_devlink_set_parent(struct devlink_rate *devlink_rate,
 	tc_node = pi->root->children[0];
 	node = *priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(devlink_rate->devlink), extack))
+		return -EBUSY;
+
 	if (!parent) {
 		if (!node || tc_node == node ||
 		    node->info.data.elem_type == ICE_AQC_ELEM_TYPE_LEAF) {
@@ -1185,6 +1269,9 @@ static int ice_devlink_rate_queue_parent_set(struct devlink_rate *devlink_rate,
 	struct ice_sched_node *node, *prev_parent, *next_parent;
 	struct ice_port_info *pi;
 
+	if (!ice_enable_custom_tx(devlink_priv(devlink_rate->devlink), extack))
+		return -EBUSY;
+
 	if (!parent)
 		return -EINVAL;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 895c32bcc8b5..f702bd5272f2 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -273,6 +273,11 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 	if (!ice_is_rdma_ena(pf))
 		return 0;
 
+	if (pf->hw.port_info->is_custom_tx_enabled) {
+		dev_err(ice_pf_to_dev(pf), "Custom Tx scheduler enabled, it's mutually exclusive with RDMA\n");
+		return -EBUSY;
+	}
+
 	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
 	if (!iadev)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index dc3a675c988f..1a45bc51480c 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -713,6 +713,7 @@ struct ice_port_info {
 	struct ice_qos_cfg qos_cfg;
 	struct ida sched_node_ids;
 	u8 is_vf:1;
+	u8 is_custom_tx_enabled:1;
 };
 
 struct ice_switch_info {
-- 
2.37.2


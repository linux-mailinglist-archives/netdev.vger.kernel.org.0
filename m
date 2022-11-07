Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B4761FD1B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiKGSQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbiKGSPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:15:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4B21F2D4
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667844865; x=1699380865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eWeN6tdyToVPviZL9Vz5ElveFJAqMigzxX+cqY65chs=;
  b=ZfvfLFdcXe1GIr1J2fIDTo5uxc1YbwKbKZYD2il+irNs58QcSdiJ+tkl
   5B6tWSXQEkdrwZNLMA79hwxmLaaHwfCWQuivwJGNZbQEhkMcXCy9jjoLH
   QZAr6ZO4ZwEN7L6/sDYadoYLwEMLlrBDyfBx0oKE11rl6RWgx12o2ZZiM
   Ea1WVbGTOM0EAFg6jMbMvlhaXfa6oXhBZ1so6SASdyxe3n3Sr7owRdQc/
   tI/J5ZfyubXNGML79vq0qAlAqxAD5i6PvYNj9xAa6NRlk1XizaRuYRLhg
   SlwVJt1rL3CWLUcZmdZFLxFGwnM1U1EXWDxrR7WrkFbGwWRDxCLHaIdD4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293852058"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293852058"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="613962817"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="613962817"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:22 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v10 09/10] ice: Prevent ADQ, DCB coexistence with Custom Tx scheduler
Date:   Mon,  7 Nov 2022 19:13:25 +0100
Message-Id: <20221107181327.379007-10-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221107181327.379007-1-michal.wilczynski@intel.com>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ADQ, DCB might interfere with Custom Tx Scheduler changes that user
might introduce using devlink-rate API.

Check if ADQ, DCB is active, when user tries to change any setting
in exported Tx scheduler tree. If any of those are active block the user
from doing so, and log an appropriate message.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  4 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c | 65 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_type.h    |  1 +
 3 files changed, 70 insertions(+)

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
index 00ed3883c492..6fe2dd95578f 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -8,6 +8,7 @@
 #include "ice_devlink.h"
 #include "ice_eswitch.h"
 #include "ice_fw_update.h"
+#include "ice_dcb_lib.h"
 
 static int ice_active_port_option = -1;
 
@@ -713,6 +714,37 @@ ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
 	return ice_devlink_port_split(devlink, port, 1, extack);
 }
 
+/**
+ * ice_enable_custom_tx - try to enable custom Tx feature
+ * @pf: devlink struct
+ *
+ * This function tries to enabled custom Tx feature,
+ * it's not possible to enable it, if DCB is active.
+ */
+static bool ice_enable_custom_tx(struct ice_pf *pf)
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
+	pi->is_custom_tx_enabled = true;
+
+	return true;
+}
+
 /**
  * ice_traverse_tx_tree - traverse Tx scheduler tree
  * @devlink: devlink struct
@@ -906,6 +938,9 @@ static int ice_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv
 
 	pi = ice_get_pi_from_dev_rate(rate_node);
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	/* preallocate memory for ice_sched_node */
 	node = devm_kzalloc(ice_hw_to_dev(pi->hw), sizeof(*node), GFP_KERNEL);
 	*priv = node;
@@ -926,6 +961,9 @@ static int ice_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 	if (!rate_node->parent || !node || tc_node == node || !extack)
 		return 0;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	/* can't allow to delete a node with children */
 	if (node->num_children)
 		return -EINVAL;
@@ -942,6 +980,9 @@ static int ice_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -955,6 +996,9 @@ static int ice_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, vo
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -968,6 +1012,9 @@ static int ice_devlink_rate_leaf_tx_priority_set(struct devlink_rate *rate_leaf,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -981,6 +1028,9 @@ static int ice_devlink_rate_leaf_tx_weight_set(struct devlink_rate *rate_leaf, v
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -994,6 +1044,9 @@ static int ice_devlink_rate_node_tx_max_set(struct devlink_rate *rate_node, void
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1007,6 +1060,9 @@ static int ice_devlink_rate_node_tx_share_set(struct devlink_rate *rate_node, vo
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1020,6 +1076,9 @@ static int ice_devlink_rate_node_tx_priority_set(struct devlink_rate *rate_node,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1033,6 +1092,9 @@ static int ice_devlink_rate_node_tx_weight_set(struct devlink_rate *rate_node, v
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1059,6 +1121,9 @@ static int ice_devlink_set_parent(struct devlink_rate *devlink_rate,
 	if (!extack)
 		return 0;
 
+	if (!ice_enable_custom_tx(devlink_priv(devlink_rate->devlink)))
+		return -EBUSY;
+
 	if (!parent) {
 		if (!node || tc_node == node || node->num_children)
 			return -EINVAL;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index c93f2449d3c3..089c90f66ef6 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -715,6 +715,7 @@ struct ice_port_info {
 	struct ice_qos_cfg qos_cfg;
 	struct xarray sched_node_ids;
 	u8 is_vf:1;
+	u8 is_custom_tx_enabled:1;
 };
 
 struct ice_switch_info {
-- 
2.37.2


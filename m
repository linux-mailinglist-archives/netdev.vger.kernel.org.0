Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1714F62963F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238360AbiKOKtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238407AbiKOKti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:49:38 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5E025C69
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668509352; x=1700045352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+ql8pVWj0wbBty/J0WWqIu/9amWAkFYhgaVeQn4K/pg=;
  b=ZSI8Jz9jQ11bwEe3/yOUiFo8vOVk3wt2HLiUpoZstVPJ3tsXRvbZHjiZ
   QbRNeBJo4EIVXUX/Aljq6WXElouq2RfF9uxM58P3MLsaeIISCCDu8P6y9
   ezn5WrehT9w3p88h5XePPnPzQh8r4FooChhlrJgi3ZoV0KqV9c/VC1/Fw
   lCF8EoMJY+BOFj6/LhjHN0/Ql6qIaEooptzcrOFYWGRn8g7TERhJSjeys
   3cgIxo/Gi/qBvwNs7x23S8l6a3ORZuWRZMmngx6D/HKMHreTFwZdnCrmn
   bw1VYYKa5f897ZFZBmqUVguwe843hH6q0w5ER8PDLfdMbnmGNfGbrG6uA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376489529"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="376489529"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:49:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="633193493"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="633193493"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:49:09 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v12 09/11] ice: Prevent ADQ, DCB coexistence with Custom Tx scheduler
Date:   Tue, 15 Nov 2022 11:48:23 +0100
Message-Id: <20221115104825.172668-10-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221115104825.172668-1-michal.wilczynski@intel.com>
References: <20221115104825.172668-1-michal.wilczynski@intel.com>
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

ADQ, DCB might interfere with Custom Tx Scheduler changes that user
might introduce using devlink-rate API.

Check if ADQ, DCB is active, when user tries to change any setting
in exported Tx scheduler tree. If any of those are active block the user
from doing so, and log an appropriate message.

Remove the exported hierarchy if user enable ADQ or DCB.
Prevent ADQ or DCB from getting configured if user already made some
changes using devlink-rate API.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  7 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c | 91 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c    |  6 ++
 drivers/net/ethernet/intel/ice/ice_repr.c    |  5 ++
 drivers/net/ethernet/intel/ice/ice_type.h    |  1 +
 6 files changed, 111 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index add90e75f05c..9defb9d0fe88 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -3,6 +3,7 @@
 
 #include "ice_dcb_lib.h"
 #include "ice_dcb_nl.h"
+#include "ice_devlink.h"
 
 /**
  * ice_dcb_get_ena_tc - return bitmap of enabled TCs
@@ -364,6 +365,12 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	/* Enable DCB tagging only when more than one TC */
 	if (ice_dcb_get_num_tc(new_cfg) > 1) {
 		dev_dbg(dev, "DCB tagging enabled (num TC > 1)\n");
+		if (pf->hw.port_info->is_custom_tx_enabled) {
+			dev_err(dev, "Custom Tx scheduler feature enabled, can't configure DCB\n");
+			return -EBUSY;
+		}
+		ice_tear_down_devlink_rate_tree(pf);
+
 		set_bit(ICE_FLAG_DCB_ENA, pf->flags);
 	} else {
 		dev_dbg(dev, "DCB tagging disabled (num TC = 1)\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 46f5b587b1c8..1d638216484d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -8,6 +8,7 @@
 #include "ice_devlink.h"
 #include "ice_eswitch.h"
 #include "ice_fw_update.h"
+#include "ice_dcb_lib.h"
 
 static int ice_active_port_option = -1;
 
@@ -713,6 +714,63 @@ ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
 	return ice_devlink_port_split(devlink, port, 1, extack);
 }
 
+/**
+ * ice_tear_down_devlink_rate_tree - removes devlink-rate exported tree
+ * @pf: pf struct
+ *
+ * This function tears down tree exported during VF's creation.
+ */
+void ice_tear_down_devlink_rate_tree(struct ice_pf *pf)
+{
+	struct devlink *devlink;
+	struct ice_vf *vf;
+	unsigned int bkt;
+
+	devlink = priv_to_devlink(pf);
+
+	devl_lock(devlink);
+	mutex_lock(&pf->vfs.table_lock);
+	ice_for_each_vf(pf, bkt, vf) {
+		if (vf->devlink_port.devlink_rate)
+			devl_rate_leaf_destroy(&vf->devlink_port);
+	}
+	mutex_unlock(&pf->vfs.table_lock);
+
+	devl_rate_nodes_destroy(devlink);
+	devl_unlock(devlink);
+}
+
+/**
+ * ice_enable_custom_tx - try to enable custom Tx feature
+ * @pf: pf struct
+ *
+ * This function tries to enable custom Tx feature,
+ * it's not possible to enable it, if DCB or ADQ is active.
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
@@ -914,6 +972,9 @@ static int ice_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv
 
 	pi = ice_get_pi_from_dev_rate(rate_node);
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	/* preallocate memory for ice_sched_node */
 	node = devm_kzalloc(ice_hw_to_dev(pi->hw), sizeof(*node), GFP_KERNEL);
 	*priv = node;
@@ -934,6 +995,9 @@ static int ice_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 	if (!rate_node->parent || !node || tc_node == node || !extack)
 		return 0;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	/* can't allow to delete a node with children */
 	if (node->num_children)
 		return -EINVAL;
@@ -950,6 +1014,9 @@ static int ice_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -962,6 +1029,9 @@ static int ice_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, vo
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -974,6 +1044,9 @@ static int ice_devlink_rate_leaf_tx_priority_set(struct devlink_rate *rate_leaf,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -986,6 +1059,9 @@ static int ice_devlink_rate_leaf_tx_weight_set(struct devlink_rate *rate_leaf, v
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -998,6 +1074,9 @@ static int ice_devlink_rate_node_tx_max_set(struct devlink_rate *rate_node, void
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1010,6 +1089,9 @@ static int ice_devlink_rate_node_tx_share_set(struct devlink_rate *rate_node, vo
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1022,6 +1104,9 @@ static int ice_devlink_rate_node_tx_priority_set(struct devlink_rate *rate_node,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1034,6 +1119,9 @@ static int ice_devlink_rate_node_tx_weight_set(struct devlink_rate *rate_node, v
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink)))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1059,6 +1147,9 @@ static int ice_devlink_set_parent(struct devlink_rate *devlink_rate,
 	if (!extack)
 		return 0;
 
+	if (!ice_enable_custom_tx(devlink_priv(devlink_rate->devlink)))
+		return -EBUSY;
+
 	if (!parent) {
 		if (!node || tc_node == node || node->num_children)
 			return -EINVAL;
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.h b/drivers/net/ethernet/intel/ice/ice_devlink.h
index 8bfed9ee2c4c..6ec96779f52e 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.h
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -19,5 +19,6 @@ void ice_devlink_init_regions(struct ice_pf *pf);
 void ice_devlink_destroy_regions(struct ice_pf *pf);
 
 int ice_devlink_rate_init_tx_topology(struct devlink *devlink, struct ice_vsi *vsi);
+void ice_tear_down_devlink_rate_tree(struct ice_pf *pf);
 
 #endif /* _ICE_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a9fc89aebebe..d6f460ff1b72 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8580,6 +8580,12 @@ static int ice_setup_tc_mqprio_qdisc(struct net_device *netdev, void *type_data)
 	switch (mode) {
 	case TC_MQPRIO_MODE_CHANNEL:
 
+		if (pf->hw.port_info->is_custom_tx_enabled) {
+			dev_err(dev, "Custom Tx scheduler feature enabled, can't configure ADQ\n");
+			return -EBUSY;
+		}
+		ice_tear_down_devlink_rate_tree(pf);
+
 		ret = ice_validate_mqprio_qopt(vsi, mqprio_qopt);
 		if (ret) {
 			netdev_err(netdev, "failed to validate_mqprio_qopt(), ret %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 46f58d48318c..109761c8c858 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -6,6 +6,7 @@
 #include "ice_devlink.h"
 #include "ice_sriov.h"
 #include "ice_tc_lib.h"
+#include "ice_dcb_lib.h"
 
 /**
  * ice_repr_get_sw_port_id - get port ID associated with representor
@@ -426,6 +427,10 @@ int ice_repr_add_for_all_vfs(struct ice_pf *pf)
 			goto err;
 	}
 
+	/* only export if ADQ and DCB disabled */
+	if (ice_is_adq_active(pf) || ice_is_dcb_active(pf))
+		return 0;
+
 	devlink = priv_to_devlink(pf);
 	ice_devlink_rate_init_tx_topology(devlink, ice_get_main_vsi(pf));
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index daf86cf561bc..e3f622cad425 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99695602BDE
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiJRMgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiJRMgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:36:21 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103E2AC48E
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666096580; x=1697632580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IIxUeUcRBJaSGbVBm7zMAXdYsq5bnkEpaOcc1WWNr3o=;
  b=CodDxWVH5ItDNg49IJ1LmapHiDzUALUf/ZHkrSM203pNxLrtaH0CNinO
   lKKymZwXANiPwNvOvMMhzDdvZcfAD8jySA/k0WJTQ9utFz3mebpXBU32+
   WaeAorv3k8rW44ESdeP5MsZB0HIDdVK9P7zTfNfE07nuMb/NrJB5f011o
   bVe7Gj7cXUXs+MoPFY++uWiHK4GLC5/IlhuQZ0/3vlk6S0K3K3jvongaS
   Fpgi95B0+OMqUAGIt0x3lA2extvIfLHoHcdW9NhWmmXRkgaeSPYUrgQ8Z
   EAZKFmid9ScwvwBf16oDTSlcNwEgE1udODZxdWxF6nmemSwksuH+eZNV2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="304827836"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="304827836"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:36:19 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="771181267"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="771181267"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:36:17 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v6 4/4] ice: Prevent DCB coexistence with Custom Tx scheduler
Date:   Tue, 18 Oct 2022 14:35:42 +0200
Message-Id: <20221018123543.1210217-5-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221018123543.1210217-1-michal.wilczynski@intel.com>
References: <20221018123543.1210217-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DCB might interfere with Custom Tx Scheduler changes that user might
introduce using devlink-rate API.

Check if DCB is active, when user tries to change any setting in exported
Tx scheduler tree.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  4 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c | 61 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc.c     |  5 ++
 drivers/net/ethernet/intel/ice/ice_type.h    |  1 +
 4 files changed, 71 insertions(+)

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
index 9742ad75b72a..5eefccfe1934 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -8,6 +8,7 @@
 #include "ice_devlink.h"
 #include "ice_eswitch.h"
 #include "ice_fw_update.h"
+#include "ice_dcb_lib.h"
 
 static int ice_active_port_option = -1;
 
@@ -713,6 +714,33 @@ ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
 	return ice_devlink_port_split(devlink, port, 1, extack);
 }
 
+/**
+ * ice_enable_custom_tx - try to enable custom Tx feature
+ * @pf: devlink struct
+ * @extack: extended netdev ack structure
+ *
+ * This function tries to enabled custom Tx feature,
+ * it's not possible to enable it, if DCB is active.
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
@@ -892,6 +920,9 @@ static struct ice_port_info *ice_get_pi_from_dev_rate(struct devlink_rate *rate_
 static int ice_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv,
 				     struct netlink_ext_ack *extack)
 {
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	return 0;
 }
 
@@ -905,6 +936,9 @@ static int ice_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 	tc_node = pi->root->children[0];
 	node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!rate_node->parent || !node || tc_node == node || !extack)
 		return 0;
 
@@ -924,6 +958,9 @@ static int ice_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -937,6 +974,9 @@ static int ice_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, vo
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -950,6 +990,9 @@ static int ice_devlink_rate_leaf_tx_priority_set(struct devlink_rate *rate_leaf,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -963,6 +1006,9 @@ static int ice_devlink_rate_leaf_tx_weight_set(struct devlink_rate *rate_leaf, v
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_leaf->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -976,6 +1022,9 @@ static int ice_devlink_rate_node_tx_max_set(struct devlink_rate *rate_node, void
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -989,6 +1038,9 @@ static int ice_devlink_rate_node_tx_share_set(struct devlink_rate *rate_node, vo
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1002,6 +1054,9 @@ static int ice_devlink_rate_node_tx_priority_set(struct devlink_rate *rate_node,
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1015,6 +1070,9 @@ static int ice_devlink_rate_node_tx_weight_set(struct devlink_rate *rate_node, v
 {
 	struct ice_sched_node *node = priv;
 
+	if (!ice_enable_custom_tx(devlink_priv(rate_node->devlink), extack))
+		return -EBUSY;
+
 	if (!node)
 		return 0;
 
@@ -1041,6 +1099,9 @@ static int ice_devlink_set_parent(struct devlink_rate *devlink_rate,
 	if (!extack)
 		return 0;
 
+	if (!ice_enable_custom_tx(devlink_priv(devlink_rate->devlink), extack))
+		return -EBUSY;
+
 	if (!parent) {
 		if (!node || tc_node == node || node->num_children)
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
index 3b6d317371cd..05eb30f34871 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -714,6 +714,7 @@ struct ice_port_info {
 	struct ice_qos_cfg qos_cfg;
 	struct xarray sched_node_ids;
 	u8 is_vf:1;
+	u8 is_custom_tx_enabled:1;
 };
 
 struct ice_switch_info {
-- 
2.37.2


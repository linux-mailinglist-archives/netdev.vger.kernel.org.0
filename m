Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBA36280F5
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbiKNNM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236564AbiKNNMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:12:46 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E537C2B618
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668431561; x=1699967561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/CSUny8U47MerrLf+/3eVAxaY7Q88qyef3AfZpl/+Sc=;
  b=l4iv71jszU8lg9p+33fviqSMHGVHgK3r5CVZ8x1gBMIY792OqbGmFzHQ
   +7ZxZeWOJFL9AQ7MlL4DqSmT5U2WVuHYR7aYKwPICfdJb1wB/Lril0CM5
   yN0YWICOSJWWtbgT0qRSDddgiGUr30DnxziSxTQz/5e3zmLsduEDMWuZQ
   6NCKG0YOCvWhAc6CLIVn/7O5Dpjv5CW7D7B9+lygNWx4oIcA5fb0opvd4
   l5L5M0eUTccwX8PfXhUVmf4Ob4uF+muAHdbwi/7aQL5YwZttGg5hpF7g3
   08O9ssUrlVwa9i9E59gTljzRk6FOmYDEEzM9WyRiCJyztcuEmk08q5ImK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313110649"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="313110649"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:12:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616306051"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="616306051"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 05:12:37 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 10/13] ice: implement devlink reinit action
Date:   Mon, 14 Nov 2022 13:57:52 +0100
Message-Id: <20221114125755.13659-11-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call ice_unload() and ice_load() in driver reinit flow.

Block reinit when switchdev, ADQ or SRIOV is active. In reload path we
don't want to rebuild all features. Ask user to remove them instead of
quitely removing it in reload path.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 103 +++++++++++++++----
 1 file changed, 81 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 455489e9457d..8f73c4008a56 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -376,10 +376,7 @@ static int ice_devlink_info_get(struct devlink *devlink,
 
 /**
  * ice_devlink_reload_empr_start - Start EMP reset to activate new firmware
- * @devlink: pointer to the devlink instance to reload
- * @netns_change: if true, the network namespace is changing
- * @action: the action to perform. Must be DEVLINK_RELOAD_ACTION_FW_ACTIVATE
- * @limit: limits on what reload should do, such as not resetting
+ * @pf: pointer to the pf instance
  * @extack: netlink extended ACK structure
  *
  * Allow user to activate new Embedded Management Processor firmware by
@@ -392,12 +389,9 @@ static int ice_devlink_info_get(struct devlink *devlink,
  * any source.
  */
 static int
-ice_devlink_reload_empr_start(struct devlink *devlink, bool netns_change,
-			      enum devlink_reload_action action,
-			      enum devlink_reload_limit limit,
+ice_devlink_reload_empr_start(struct ice_pf *pf,
 			      struct netlink_ext_ack *extack)
 {
-	struct ice_pf *pf = devlink_priv(devlink);
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	u8 pending;
@@ -435,12 +429,52 @@ ice_devlink_reload_empr_start(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
+/**
+ * ice_devlink_reload_down - prepare for reload
+ * @devlink: pointer to the devlink instance to reload
+ * @netns_change: if true, the network namespace is changing
+ * @action: the action to perform
+ * @limit: limits on what reload should do, such as not resetting
+ * @extack: netlink extended ACK structure
+ */
+static int
+ice_devlink_reload_down(struct devlink *devlink, bool netns_change,
+			enum devlink_reload_action action,
+			enum devlink_reload_limit limit,
+			struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		if (ice_is_eswitch_mode_switchdev(pf)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Go to legacy mode before doing reinit\n");
+			return -EOPNOTSUPP;
+		}
+		if (ice_is_adq_active(pf)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Turn off ADQ before doing reinit\n");
+			return -EOPNOTSUPP;
+		}
+		if (ice_has_vfs(pf)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Remove all VFs before doing reinit\n");
+			return -EOPNOTSUPP;
+		}
+		ice_unload(pf);
+		return 0;
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		return ice_devlink_reload_empr_start(pf, extack);
+	default:
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+}
+
 /**
  * ice_devlink_reload_empr_finish - Wait for EMP reset to finish
- * @devlink: pointer to the devlink instance reloading
- * @action: the action requested
- * @limit: limits imposed by userspace, such as not resetting
- * @actions_performed: on return, indicate what actions actually performed
+ * @pf: pointer to the pf instance
  * @extack: netlink extended ACK structure
  *
  * Wait for driver to finish rebuilding after EMP reset is completed. This
@@ -448,17 +482,11 @@ ice_devlink_reload_empr_start(struct devlink *devlink, bool netns_change,
  * for the driver's rebuild to complete.
  */
 static int
-ice_devlink_reload_empr_finish(struct devlink *devlink,
-			       enum devlink_reload_action action,
-			       enum devlink_reload_limit limit,
-			       u32 *actions_performed,
+ice_devlink_reload_empr_finish(struct ice_pf *pf,
 			       struct netlink_ext_ack *extack)
 {
-	struct ice_pf *pf = devlink_priv(devlink);
 	int err;
 
-	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
-
 	err = ice_wait_for_reset(pf, 60 * HZ);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Device still resetting after 1 minute");
@@ -713,12 +741,43 @@ ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
 	return ice_devlink_port_split(devlink, port, 1, extack);
 }
 
+/**
+ * ice_devlink_reload_up - do reload up after reinit
+ * @devlink: pointer to the devlink instance reloading
+ * @action: the action requested
+ * @limit: limits imposed by userspace, such as not resetting
+ * @actions_performed: on return, indicate what actions actually performed
+ * @extack: netlink extended ACK structure
+ */
+static int
+ice_devlink_reload_up(struct devlink *devlink,
+		      enum devlink_reload_action action,
+		      enum devlink_reload_limit limit,
+		      u32 *actions_performed,
+		      struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
+		return ice_load(pf);
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		*actions_performed = BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
+		return ice_devlink_reload_empr_finish(pf, extack);
+	default:
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct devlink_ops ice_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
-	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	/* The ice driver currently does not support driver reinit */
-	.reload_down = ice_devlink_reload_empr_start,
-	.reload_up = ice_devlink_reload_empr_finish,
+	.reload_down = ice_devlink_reload_down,
+	.reload_up = ice_devlink_reload_up,
 	.port_split = ice_devlink_port_split,
 	.port_unsplit = ice_devlink_port_unsplit,
 	.eswitch_mode_get = ice_eswitch_mode_get,
-- 
2.36.1


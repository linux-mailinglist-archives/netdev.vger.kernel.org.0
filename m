Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3954241B9A9
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242984AbhI1Vzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:55:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:59509 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242917AbhI1Vzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 17:55:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224851566"
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="224851566"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 14:53:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="486701069"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Sep 2021 14:53:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/6] ice: Add feature bitmap, helpers and a check for DSCP
Date:   Tue, 28 Sep 2021 14:57:53 -0700
Message-Id: <20210928215757.3378414-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
References: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

DSCP a.k.a L3 QoS is only supported on certain devices. To enforce this,
this patch introduces a bitmap of features and helper functions.

The feature bitmap is set based on device IDs on driver init. Currently,
DSCP is the only feature in this bitmap, but there will be more in the
future. In the DCB netlink flow, check if the feature bit is set before
exercising DSCP.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h        |  6 +++
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c |  8 +++-
 drivers/net/ethernet/intel/ice/ice_lib.c    | 47 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h    |  2 +
 drivers/net/ethernet/intel/ice/ice_main.c   |  2 +
 5 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 3c4f08d20414..83413772b00c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -158,6 +158,11 @@
 
 #define ice_pf_to_dev(pf) (&((pf)->pdev->dev))
 
+enum ice_feature {
+	ICE_F_DSCP,
+	ICE_F_MAX
+};
+
 struct ice_txq_meta {
 	u32 q_teid;	/* Tx-scheduler element identifier */
 	u16 q_id;	/* Entry in VSI's txq_map bitmap */
@@ -443,6 +448,7 @@ struct ice_pf {
 	/* used to ratelimit the MDD event logging */
 	unsigned long last_printed_mdd_jiffies;
 	DECLARE_BITMAP(malvfs, ICE_MAX_VF_COUNT);
+	DECLARE_BITMAP(features, ICE_F_MAX);
 	DECLARE_BITMAP(state, ICE_STATE_NBITS);
 	DECLARE_BITMAP(flags, ICE_PF_FLAGS_NBITS);
 	unsigned long *avail_txqs;	/* bitmap to track PF Tx queue usage */
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 0121dbc62c8a..7fdeb411b6df 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -710,6 +710,9 @@ static int ice_dcbnl_setapp(struct net_device *netdev, struct dcb_app *app)
 	if (!(pf->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
 		return -EINVAL;
 
+	if (!ice_is_feature_supported(pf, ICE_F_DSCP))
+		return -EOPNOTSUPP;
+
 	if (app->protocol >= ICE_DSCP_NUM_VAL) {
 		netdev_err(netdev, "DSCP value 0x%04X out of range\n",
 			   app->protocol);
@@ -861,8 +864,9 @@ static int ice_dcbnl_delapp(struct net_device *netdev, struct dcb_app *app)
 		new_cfg->app[j].priority = old_cfg->app[j + 1].priority;
 	}
 
-	/* if not a DSCP APP TLV, then we are done */
-	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP) {
+	/* if not a DSCP APP TLV or DSCP is not supported, we are done */
+	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP ||
+	    !ice_is_feature_supported(pf, ICE_F_DSCP)) {
 		ret = ICE_DCB_HW_CHG;
 		goto delapp_out;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index dde9802c6c72..3adbd9a179a7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3573,3 +3573,50 @@ int ice_set_link(struct ice_vsi *vsi, bool ena)
 
 	return 0;
 }
+
+/**
+ * ice_is_feature_supported
+ * @pf: pointer to the struct ice_pf instance
+ * @f: feature enum to be checked
+ *
+ * returns true if feature is supported, false otherwise
+ */
+bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f)
+{
+	if (f < 0 || f >= ICE_F_MAX)
+		return false;
+
+	return test_bit(f, pf->features);
+}
+
+/**
+ * ice_set_feature_support
+ * @pf: pointer to the struct ice_pf instance
+ * @f: feature enum to set
+ */
+static void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f)
+{
+	if (f < 0 || f >= ICE_F_MAX)
+		return;
+
+	set_bit(f, pf->features);
+}
+
+/**
+ * ice_init_feature_support
+ * @pf: pointer to the struct ice_pf instance
+ *
+ * called during init to setup supported feature
+ */
+void ice_init_feature_support(struct ice_pf *pf)
+{
+	switch (pf->hw.device_id) {
+	case ICE_DEV_ID_E810C_BACKPLANE:
+	case ICE_DEV_ID_E810C_QSFP:
+	case ICE_DEV_ID_E810C_SFP:
+		ice_set_feature_support(pf, ICE_F_DSCP);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index d5a28bf0fc2c..4512c8513178 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -116,4 +116,6 @@ bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
 int ice_set_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
 
 int ice_clear_dflt_vsi(struct ice_sw *sw);
+bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
+void ice_init_feature_support(struct ice_pf *pf);
 #endif /* !_ICE_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7e477f117550..ab15862a66af 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4270,6 +4270,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_exit_unroll;
 	}
 
+	ice_init_feature_support(pf);
+
 	ice_request_fw(pf);
 
 	/* if ice_request_fw fails, ICE_FLAG_ADV_FEATURES bit won't be
-- 
2.26.2


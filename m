Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7767F426034
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhJGXK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:15518 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhJGXKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226340358"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="226340358"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344328"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@resnulli.us, ivecera@redhat.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 05/12] ice: manage VSI antispoof and destination override
Date:   Thu,  7 Oct 2021 16:06:13 -0700
Message-Id: <20211007230620.3413290-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
References: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Implement functions to make setting VSI security config easier.
Main function ice_update_security fills security section field and
checks against error in updating VSI. Reset functions are responsible
for correct filling config according to user expectations.

This helper is needed because destination override is located in
this section. Driver has to set this bit to allow strering Tx packet
on VSI based on value in Tx descriptors.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 61 ++++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h | 12 +++++
 2 files changed, 73 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index deff158dbae1..a689d9bec32e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3621,3 +3621,64 @@ void ice_init_feature_support(struct ice_pf *pf)
 		break;
 	}
 }
+
+/**
+ * ice_vsi_update_security - update security block in VSI
+ * @vsi: pointer to VSI structure
+ * @fill: function pointer to fill ctx
+ */
+int
+ice_vsi_update_security(struct ice_vsi *vsi, void (*fill)(struct ice_vsi_ctx *))
+{
+	struct ice_vsi_ctx ctx = { 0 };
+
+	ctx.info = vsi->info;
+	ctx.info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_SECURITY_VALID);
+	fill(&ctx);
+
+	if (ice_update_vsi(&vsi->back->hw, vsi->idx, &ctx, NULL))
+		return -ENODEV;
+
+	vsi->info = ctx.info;
+	return 0;
+}
+
+/**
+ * ice_vsi_ctx_set_antispoof - set antispoof function in VSI ctx
+ * @ctx: pointer to VSI ctx structure
+ */
+void ice_vsi_ctx_set_antispoof(struct ice_vsi_ctx *ctx)
+{
+	ctx->info.sec_flags |= ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF |
+			       (ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
+				ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S);
+}
+
+/**
+ * ice_vsi_ctx_clear_antispoof - clear antispoof function in VSI ctx
+ * @ctx: pointer to VSI ctx structure
+ */
+void ice_vsi_ctx_clear_antispoof(struct ice_vsi_ctx *ctx)
+{
+	ctx->info.sec_flags &= ~ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF &
+			       ~(ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
+				 ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S);
+}
+
+/**
+ * ice_vsi_ctx_set_allow_override - allow destination override on VSI
+ * @ctx: pointer to VSI ctx structure
+ */
+void ice_vsi_ctx_set_allow_override(struct ice_vsi_ctx *ctx)
+{
+	ctx->info.sec_flags |= ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD;
+}
+
+/**
+ * ice_vsi_ctx_clear_allow_override - turn off destination override on VSI
+ * @ctx: pointer to VSI ctx structure
+ */
+void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx)
+{
+	ctx->info.sec_flags &= ~ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 4512c8513178..3f3fef6551c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -116,6 +116,18 @@ bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
 int ice_set_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
 
 int ice_clear_dflt_vsi(struct ice_sw *sw);
+
+int
+ice_vsi_update_security(struct ice_vsi *vsi, void (*fill)(struct ice_vsi_ctx *));
+
+void ice_vsi_ctx_set_antispoof(struct ice_vsi_ctx *ctx);
+
+void ice_vsi_ctx_clear_antispoof(struct ice_vsi_ctx *ctx);
+
+void ice_vsi_ctx_set_allow_override(struct ice_vsi_ctx *ctx);
+
+void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx);
+
 bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
 void ice_init_feature_support(struct ice_pf *pf);
 #endif /* !_ICE_LIB_H_ */
-- 
2.31.1


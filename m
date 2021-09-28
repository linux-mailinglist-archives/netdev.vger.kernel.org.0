Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8754F41B9AA
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243001AbhI1Vzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:55:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:59511 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242956AbhI1Vzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 17:55:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224851568"
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="224851568"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 14:53:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="486701075"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Sep 2021 14:53:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 4/6] ice: refactor devlink getter/fallback functions to void
Date:   Tue, 28 Sep 2021 14:57:55 -0700
Message-Id: <20210928215757.3378414-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
References: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

After commit a8f89fa27773 ("ice: do not abort devlink info if board
identifier can't be found"), the getter/fallback() functions no longer
report an error. Convert the interface to a void so that it is no
longer possible to add a version field that is fatal. This makes
sense, because we should not fail to report other versions just
because one of the version pieces could not be found.

Finally, clean up the getter functions line wrapping so that none of
them take more than 80 columns, as is the usual style for networking
files.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 133 +++++++------------
 1 file changed, 50 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index ab3d876fa624..cae1cd97a1ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -22,7 +22,7 @@ struct ice_info_ctx {
  *
  * If a version does not exist, for example when attempting to get the
  * inactive version of flash when there is no pending update, the function
- * should leave the buffer in the ctx structure empty and return 0.
+ * should leave the buffer in the ctx structure empty.
  */
 
 static void ice_info_get_dsn(struct ice_pf *pf, struct ice_info_ctx *ctx)
@@ -35,7 +35,7 @@ static void ice_info_get_dsn(struct ice_pf *pf, struct ice_info_ctx *ctx)
 	snprintf(ctx->buf, sizeof(ctx->buf), "%8phD", dsn);
 }
 
-static int ice_info_pba(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_pba(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
@@ -45,148 +45,127 @@ static int ice_info_pba(struct ice_pf *pf, struct ice_info_ctx *ctx)
 		/* We failed to locate the PBA, so just skip this entry */
 		dev_dbg(ice_pf_to_dev(pf), "Failed to read Product Board Assembly string, status %s\n",
 			ice_stat_str(status));
-
-	return 0;
 }
 
-static int ice_info_fw_mgmt(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_fw_mgmt(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u", hw->fw_maj_ver, hw->fw_min_ver,
-		 hw->fw_patch);
-
-	return 0;
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u",
+		 hw->fw_maj_ver, hw->fw_min_ver, hw->fw_patch);
 }
 
-static int ice_info_fw_api(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_fw_api(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u", hw->api_maj_ver, hw->api_min_ver);
-
-	return 0;
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u",
+		 hw->api_maj_ver, hw->api_min_ver);
 }
 
-static int ice_info_fw_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_fw_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
 	snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", hw->fw_build);
-
-	return 0;
 }
 
-static int ice_info_orom_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_orom_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_orom_info *orom = &pf->hw.flash.orom;
 
-	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u", orom->major, orom->build, orom->patch);
-
-	return 0;
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u",
+		 orom->major, orom->build, orom->patch);
 }
 
-static int
-ice_info_pending_orom_ver(struct ice_pf __always_unused *pf, struct ice_info_ctx *ctx)
+static void
+ice_info_pending_orom_ver(struct ice_pf __always_unused *pf,
+			  struct ice_info_ctx *ctx)
 {
 	struct ice_orom_info *orom = &ctx->pending_orom;
 
 	if (ctx->dev_caps.common_cap.nvm_update_pending_orom)
 		snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u",
 			 orom->major, orom->build, orom->patch);
-
-	return 0;
 }
 
-static int ice_info_nvm_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_nvm_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_nvm_info *nvm = &pf->hw.flash.nvm;
 
 	snprintf(ctx->buf, sizeof(ctx->buf), "%x.%02x", nvm->major, nvm->minor);
-
-	return 0;
 }
 
-static int
-ice_info_pending_nvm_ver(struct ice_pf __always_unused *pf, struct ice_info_ctx *ctx)
+static void
+ice_info_pending_nvm_ver(struct ice_pf __always_unused *pf,
+			 struct ice_info_ctx *ctx)
 {
 	struct ice_nvm_info *nvm = &ctx->pending_nvm;
 
 	if (ctx->dev_caps.common_cap.nvm_update_pending_nvm)
-		snprintf(ctx->buf, sizeof(ctx->buf), "%x.%02x", nvm->major, nvm->minor);
-
-	return 0;
+		snprintf(ctx->buf, sizeof(ctx->buf), "%x.%02x",
+			 nvm->major, nvm->minor);
 }
 
-static int ice_info_eetrack(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_eetrack(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_nvm_info *nvm = &pf->hw.flash.nvm;
 
 	snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", nvm->eetrack);
-
-	return 0;
 }
 
-static int
-ice_info_pending_eetrack(struct ice_pf __always_unused *pf, struct ice_info_ctx *ctx)
+static void
+ice_info_pending_eetrack(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_nvm_info *nvm = &ctx->pending_nvm;
 
 	if (ctx->dev_caps.common_cap.nvm_update_pending_nvm)
 		snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", nvm->eetrack);
-
-	return 0;
 }
 
-static int ice_info_ddp_pkg_name(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_ddp_pkg_name(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
 	snprintf(ctx->buf, sizeof(ctx->buf), "%s", hw->active_pkg_name);
-
-	return 0;
 }
 
-static int ice_info_ddp_pkg_version(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void
+ice_info_ddp_pkg_version(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_pkg_ver *pkg = &pf->hw.active_pkg_ver;
 
-	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u.%u", pkg->major, pkg->minor, pkg->update,
-		 pkg->draft);
-
-	return 0;
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u.%u",
+		 pkg->major, pkg->minor, pkg->update, pkg->draft);
 }
 
-static int ice_info_ddp_pkg_bundle_id(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void
+ice_info_ddp_pkg_bundle_id(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", pf->hw.active_track_id);
-
-	return 0;
 }
 
-static int ice_info_netlist_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_netlist_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_netlist_info *netlist = &pf->hw.flash.netlist;
 
 	/* The netlist version fields are BCD formatted */
-	snprintf(ctx->buf, sizeof(ctx->buf), "%x.%x.%x-%x.%x.%x", netlist->major, netlist->minor,
-		 netlist->type >> 16, netlist->type & 0xFFFF, netlist->rev,
-		 netlist->cust_ver);
-
-	return 0;
+	snprintf(ctx->buf, sizeof(ctx->buf), "%x.%x.%x-%x.%x.%x",
+		 netlist->major, netlist->minor,
+		 netlist->type >> 16, netlist->type & 0xFFFF,
+		 netlist->rev, netlist->cust_ver);
 }
 
-static int ice_info_netlist_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
+static void ice_info_netlist_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_netlist_info *netlist = &pf->hw.flash.netlist;
 
 	snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", netlist->hash);
-
-	return 0;
 }
 
-static int
-ice_info_pending_netlist_ver(struct ice_pf __always_unused *pf, struct ice_info_ctx *ctx)
+static void
+ice_info_pending_netlist_ver(struct ice_pf __always_unused *pf,
+			     struct ice_info_ctx *ctx)
 {
 	struct ice_netlist_info *netlist = &ctx->pending_netlist;
 
@@ -194,21 +173,18 @@ ice_info_pending_netlist_ver(struct ice_pf __always_unused *pf, struct ice_info_
 	if (ctx->dev_caps.common_cap.nvm_update_pending_netlist)
 		snprintf(ctx->buf, sizeof(ctx->buf), "%x.%x.%x-%x.%x.%x",
 			 netlist->major, netlist->minor,
-			 netlist->type >> 16, netlist->type & 0xFFFF, netlist->rev,
-			 netlist->cust_ver);
-
-	return 0;
+			 netlist->type >> 16, netlist->type & 0xFFFF,
+			 netlist->rev, netlist->cust_ver);
 }
 
-static int
-ice_info_pending_netlist_build(struct ice_pf __always_unused *pf, struct ice_info_ctx *ctx)
+static void
+ice_info_pending_netlist_build(struct ice_pf __always_unused *pf,
+			       struct ice_info_ctx *ctx)
 {
 	struct ice_netlist_info *netlist = &ctx->pending_netlist;
 
 	if (ctx->dev_caps.common_cap.nvm_update_pending_netlist)
 		snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", netlist->hash);
-
-	return 0;
 }
 
 #define fixed(key, getter) { ICE_VERSION_FIXED, key, getter, NULL }
@@ -238,8 +214,8 @@ enum ice_version_type {
 static const struct ice_devlink_version {
 	enum ice_version_type type;
 	const char *key;
-	int (*getter)(struct ice_pf *pf, struct ice_info_ctx *ctx);
-	int (*fallback)(struct ice_pf *pf, struct ice_info_ctx *ctx);
+	void (*getter)(struct ice_pf *pf, struct ice_info_ctx *ctx);
+	void (*fallback)(struct ice_pf *pf, struct ice_info_ctx *ctx);
 } ice_devlink_versions[] = {
 	fixed(DEVLINK_INFO_VERSION_GENERIC_BOARD_ID, ice_info_pba),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, ice_info_fw_mgmt),
@@ -351,24 +327,15 @@ static int ice_devlink_info_get(struct devlink *devlink,
 
 		memset(ctx->buf, 0, sizeof(ctx->buf));
 
-		err = ice_devlink_versions[i].getter(pf, ctx);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack, "Unable to obtain version info");
-			goto out_free_ctx;
-		}
+		ice_devlink_versions[i].getter(pf, ctx);
 
 		/* If the default getter doesn't report a version, use the
 		 * fallback function. This is primarily useful in the case of
 		 * "stored" versions that want to report the same value as the
 		 * running version in the normal case of no pending update.
 		 */
-		if (ctx->buf[0] == '\0' && ice_devlink_versions[i].fallback) {
-			err = ice_devlink_versions[i].fallback(pf, ctx);
-			if (err) {
-				NL_SET_ERR_MSG_MOD(extack, "Unable to obtain version info");
-				goto out_free_ctx;
-			}
-		}
+		if (ctx->buf[0] == '\0' && ice_devlink_versions[i].fallback)
+			ice_devlink_versions[i].fallback(pf, ctx);
 
 		/* Do not report missing versions */
 		if (ctx->buf[0] == '\0')
-- 
2.26.2


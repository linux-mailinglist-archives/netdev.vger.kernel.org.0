Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC83311B12
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhBFEqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:46:06 -0500
Received: from mga18.intel.com ([134.134.136.126]:21757 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhBFEnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 23:43:40 -0500
IronPort-SDR: 8H8sRe5wYJaSwdYdF/iMzlwcAwMjFgiYZj0aQXiZ5MNVgjWSyixWj8fQ/GT8MhbcRUQFSE0Kfm
 40HCjDJsOfZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169194690"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169194690"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 20:40:12 -0800
IronPort-SDR: yDFANU68tgPxsFKoYElr+QfeBPksfqY4iIP05GwwK+cSa0CPkhv9f+huguLMfZ0TatkUhoXWnL
 T7nxtoLIPU9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434751045"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 05 Feb 2021 20:40:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next v2 03/11] ice: introduce context struct for info report
Date:   Fri,  5 Feb 2021 20:40:53 -0800
Message-Id: <20210206044101.636242-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
References: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice driver uses an array of structures which link an info name with
a function that formats the associated version data into a string.

All existing format functions simply format already captured static data
from the driver hw structure. Future changes will introduce format
functions for reporting the versions of flash sections stored but not
yet applied. This type of version data is not stored as a member of the
hw structure. This is because (a) it might not yet exist in the case
there is no pending flash update, and (b) even if it does, it might
change such as if an update is canceled or replaced by a new update
before finalizing.

We could simply have each format function gather its own data upon being
called. However, in some cases the raw binary version data is
a combination of multiple different reported fields. Additionally, the
current interface doesn't have a way for the function to indicate that
the version doesn't exist.

Refactor this function interface to take a new ice_info_ctx structure
instead of the buffer pointer and length. This context structure allows
for future extensions to pre-gather version data that is stored within
the context struct instead of the hw struct.

Allocate this context structure initially at the start of
ice_devlink_info_get. We use dynamic allocation instead of a local stack
variable in order to avoid using too much kernel stack once we extend it
with additional data structures.

Modify the main loop that drives the info reporting so that the version
buffer string is always cleared between each format. Explicitly check
that the format function actually filled in a version string of non-zero
length. If the string is not provided, simply skip this version without
reporting an error. This allows for introducing format functions of
versions which may or may not be present, such as the version of
a pending update that has not yet been activated.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 109 ++++++++++++-------
 1 file changed, 68 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 44b64524b1b8..4d5ae1d6fe1c 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -6,126 +6,141 @@
 #include "ice_devlink.h"
 #include "ice_fw_update.h"
 
-static void ice_info_get_dsn(struct ice_pf *pf, char *buf, size_t len)
+/* context for devlink info version reporting */
+struct ice_info_ctx {
+	char buf[128];
+};
+
+/* The following functions are used to format specific strings for various
+ * devlink info versions. The ctx parameter is used to provide the storage
+ * buffer, as well as any ancillary information calculated when the info
+ * request was made.
+ *
+ * If a version does not exist, for example when attempting to get the
+ * inactive version of flash when there is no pending update, the function
+ * should leave the buffer in the ctx structure empty and return 0.
+ */
+
+static void ice_info_get_dsn(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	u8 dsn[8];
 
 	/* Copy the DSN into an array in Big Endian format */
 	put_unaligned_be64(pci_get_dsn(pf->pdev), dsn);
 
-	snprintf(buf, len, "%8phD", dsn);
+	snprintf(ctx->buf, sizeof(ctx->buf), "%8phD", dsn);
 }
 
-static int ice_info_pba(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_pba(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
 
-	status = ice_read_pba_string(hw, (u8 *)buf, len);
+	status = ice_read_pba_string(hw, (u8 *)ctx->buf, sizeof(ctx->buf));
 	if (status)
 		return -EIO;
 
 	return 0;
 }
 
-static int ice_info_fw_mgmt(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_fw_mgmt(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	snprintf(buf, len, "%u.%u.%u", hw->fw_maj_ver, hw->fw_min_ver,
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u", hw->fw_maj_ver, hw->fw_min_ver,
 		 hw->fw_patch);
 
 	return 0;
 }
 
-static int ice_info_fw_api(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_fw_api(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	snprintf(buf, len, "%u.%u", hw->api_maj_ver, hw->api_min_ver);
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u", hw->api_maj_ver, hw->api_min_ver);
 
 	return 0;
 }
 
-static int ice_info_fw_build(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_fw_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	snprintf(buf, len, "0x%08x", hw->fw_build);
+	snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", hw->fw_build);
 
 	return 0;
 }
 
-static int ice_info_orom_ver(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_orom_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_orom_info *orom = &pf->hw.flash.orom;
 
-	snprintf(buf, len, "%u.%u.%u", orom->major, orom->build, orom->patch);
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u", orom->major, orom->build, orom->patch);
 
 	return 0;
 }
 
-static int ice_info_nvm_ver(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_nvm_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_nvm_info *nvm = &pf->hw.flash.nvm;
 
-	snprintf(buf, len, "%x.%02x", nvm->major, nvm->minor);
+	snprintf(ctx->buf, sizeof(ctx->buf), "%x.%02x", nvm->major, nvm->minor);
 
 	return 0;
 }
 
-static int ice_info_eetrack(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_eetrack(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_nvm_info *nvm = &pf->hw.flash.nvm;
 
-	snprintf(buf, len, "0x%08x", nvm->eetrack);
+	snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", nvm->eetrack);
 
 	return 0;
 }
 
-static int ice_info_ddp_pkg_name(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_ddp_pkg_name(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	snprintf(buf, len, "%s", hw->active_pkg_name);
+	snprintf(ctx->buf, sizeof(ctx->buf), "%s", hw->active_pkg_name);
 
 	return 0;
 }
 
-static int ice_info_ddp_pkg_version(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_ddp_pkg_version(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_pkg_ver *pkg = &pf->hw.active_pkg_ver;
 
-	snprintf(buf, len, "%u.%u.%u.%u", pkg->major, pkg->minor, pkg->update,
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u.%u", pkg->major, pkg->minor, pkg->update,
 		 pkg->draft);
 
 	return 0;
 }
 
-static int ice_info_ddp_pkg_bundle_id(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_ddp_pkg_bundle_id(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
-	snprintf(buf, len, "0x%08x", pf->hw.active_track_id);
+	snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", pf->hw.active_track_id);
 
 	return 0;
 }
 
-static int ice_info_netlist_ver(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_netlist_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_netlist_info *netlist = &pf->hw.flash.netlist;
 
 	/* The netlist version fields are BCD formatted */
-	snprintf(buf, len, "%x.%x.%x-%x.%x.%x", netlist->major, netlist->minor,
+	snprintf(ctx->buf, sizeof(ctx->buf), "%x.%x.%x-%x.%x.%x", netlist->major, netlist->minor,
 		 netlist->type >> 16, netlist->type & 0xFFFF, netlist->rev,
 		 netlist->cust_ver);
 
 	return 0;
 }
 
-static int ice_info_netlist_build(struct ice_pf *pf, char *buf, size_t len)
+static int ice_info_netlist_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_netlist_info *netlist = &pf->hw.flash.netlist;
 
-	snprintf(buf, len, "0x%08x", netlist->hash);
+	snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", netlist->hash);
 
 	return 0;
 }
@@ -142,7 +157,7 @@ enum ice_version_type {
 static const struct ice_devlink_version {
 	enum ice_version_type type;
 	const char *key;
-	int (*getter)(struct ice_pf *pf, char *buf, size_t len);
+	int (*getter)(struct ice_pf *pf, struct ice_info_ctx *ctx);
 } ice_devlink_versions[] = {
 	fixed(DEVLINK_INFO_VERSION_GENERIC_BOARD_ID, ice_info_pba),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, ice_info_fw_mgmt),
@@ -174,60 +189,72 @@ static int ice_devlink_info_get(struct devlink *devlink,
 				struct netlink_ext_ack *extack)
 {
 	struct ice_pf *pf = devlink_priv(devlink);
-	char buf[100];
+	struct ice_info_ctx *ctx;
 	size_t i;
 	int err;
 
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
 	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Unable to set driver name");
-		return err;
+		goto out_free_ctx;
 	}
 
-	ice_info_get_dsn(pf, buf, sizeof(buf));
+	ice_info_get_dsn(pf, ctx);
 
-	err = devlink_info_serial_number_put(req, buf);
+	err = devlink_info_serial_number_put(req, ctx->buf);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Unable to set serial number");
-		return err;
+		goto out_free_ctx;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(ice_devlink_versions); i++) {
 		enum ice_version_type type = ice_devlink_versions[i].type;
 		const char *key = ice_devlink_versions[i].key;
 
-		err = ice_devlink_versions[i].getter(pf, buf, sizeof(buf));
+		memset(ctx->buf, 0, sizeof(ctx->buf));
+
+		err = ice_devlink_versions[i].getter(pf, ctx);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack, "Unable to obtain version info");
-			return err;
+			goto out_free_ctx;
 		}
 
+		/* Do not report missing versions */
+		if (ctx->buf[0] == '\0')
+			continue;
+
 		switch (type) {
 		case ICE_VERSION_FIXED:
-			err = devlink_info_version_fixed_put(req, key, buf);
+			err = devlink_info_version_fixed_put(req, key, ctx->buf);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Unable to set fixed version");
-				return err;
+				goto out_free_ctx;
 			}
 			break;
 		case ICE_VERSION_RUNNING:
-			err = devlink_info_version_running_put(req, key, buf);
+			err = devlink_info_version_running_put(req, key, ctx->buf);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Unable to set running version");
-				return err;
+				goto out_free_ctx;
 			}
 			break;
 		case ICE_VERSION_STORED:
-			err = devlink_info_version_stored_put(req, key, buf);
+			err = devlink_info_version_stored_put(req, key, ctx->buf);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Unable to set stored version");
-				return err;
+				goto out_free_ctx;
 			}
 			break;
 		}
 	}
 
-	return 0;
+out_free_ctx:
+	kfree(ctx);
+	return err;
 }
 
 /**
-- 
2.26.2


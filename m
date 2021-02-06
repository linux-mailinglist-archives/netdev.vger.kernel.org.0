Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99007311B1A
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhBFEr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:47:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:21611 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231492AbhBFEpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 23:45:25 -0500
IronPort-SDR: DNSh7Cou3tzw40kiCr4CZTNKQ9OkYRlZ4rVEzK9snqSY8kq8V7Dcm9jttwwXF51lIggr7AfwUn
 2ZZaQZxoUzFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169194693"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169194693"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 20:40:12 -0800
IronPort-SDR: ejpfloZD7esslmEBZMgIQCeFlmFV8eXVeUrTZN/VG8g2bous4SfXsFDZ7qLkPVOyIurBWqlN0w
 us7QASdgXNtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434751056"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 05 Feb 2021 20:40:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next v2 06/11] ice: display some stored NVM versions via devlink info
Date:   Fri,  5 Feb 2021 20:40:56 -0800
Message-Id: <20210206044101.636242-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
References: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The devlink info interface supports drivers reporting "stored" versions.
These versions indicate the version of an update that has been
downloaded to the device, but is not yet active.

The code for extracting the NVM version recently changed to enable
support for reading from either the active or the inactive bank. Use
this to implement ice_get_inactive_nvm_ver, which will read the NVM
version data from the inactive section of flash.

When reporting the versions via devlink info, first read the device
capabilities. Determine if there is a pending flash update, and if so,
extract relevant version information from the inactive flash. Store
these within the info context structure.

When reporting "stored" firmware versions, devlink documentation
indicates that we ought to always report a stored value, even if there
is no pending update. In this common case, the stored version should
match the running version. This means that each stored version should by
default fallback to the same value as reported by the running handler.

To support this, modify the version structure to have both a "getter"
and a "fallback". Modify the control loop so that it will use the
"fallback" function if the "getter" function does not report a version.

To report versions for which we can read the stored value, use a new
"stored()" macro. This macro will insert two entries into the version
list. The first entry is the traditional running version. The second is
the stored version, implemented with a fallback to the active version.
This is a little tricky, but reduces the overall duplication of elements
in the entry list, and ensures that running and stored values remain
consistent.

To avoid some duplication, add a combined() macro that will insert both
the running and stored versions into the version entry list.

Using this new support, add pending version reporter functions for
"fw.psid.api" and "fw.bundle_id". This enables reporting the stored
values for some of versions in the NVM module of the flash.

Reporting management versions is not implemented by this patch. The
active management version is reported to the driver via the AdminQ
mailbox during load. Although the version must be in the firmware binary
somewhere, accessing this from the inactive firmware is not trivial and
has not been implemented in this change.

Future changes will introduce support for reading the UNDI Option ROM
version and the version associated with the Netlist module.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 82 +++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_nvm.c     | 14 ++++
 drivers/net/ethernet/intel/ice/ice_nvm.h     |  2 +
 3 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 4d5ae1d6fe1c..757f42aad30b 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -9,6 +9,8 @@
 /* context for devlink info version reporting */
 struct ice_info_ctx {
 	char buf[128];
+	struct ice_nvm_info pending_nvm;
+	struct ice_hw_dev_caps dev_caps;
 };
 
 /* The following functions are used to format specific strings for various
@@ -89,6 +91,17 @@ static int ice_info_nvm_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
 	return 0;
 }
 
+static int
+ice_info_pending_nvm_ver(struct ice_pf __always_unused *pf, struct ice_info_ctx *ctx)
+{
+	struct ice_nvm_info *nvm = &ctx->pending_nvm;
+
+	if (ctx->dev_caps.common_cap.nvm_update_pending_nvm)
+		snprintf(ctx->buf, sizeof(ctx->buf), "%x.%02x", nvm->major, nvm->minor);
+
+	return 0;
+}
+
 static int ice_info_eetrack(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_nvm_info *nvm = &pf->hw.flash.nvm;
@@ -98,6 +111,17 @@ static int ice_info_eetrack(struct ice_pf *pf, struct ice_info_ctx *ctx)
 	return 0;
 }
 
+static int
+ice_info_pending_eetrack(struct ice_pf __always_unused *pf, struct ice_info_ctx *ctx)
+{
+	struct ice_nvm_info *nvm = &ctx->pending_nvm;
+
+	if (ctx->dev_caps.common_cap.nvm_update_pending_nvm)
+		snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", nvm->eetrack);
+
+	return 0;
+}
+
 static int ice_info_ddp_pkg_name(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
@@ -145,8 +169,23 @@ static int ice_info_netlist_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
 	return 0;
 }
 
-#define fixed(key, getter) { ICE_VERSION_FIXED, key, getter }
-#define running(key, getter) { ICE_VERSION_RUNNING, key, getter }
+#define fixed(key, getter) { ICE_VERSION_FIXED, key, getter, NULL }
+#define running(key, getter) { ICE_VERSION_RUNNING, key, getter, NULL }
+#define stored(key, getter, fallback) { ICE_VERSION_STORED, key, getter, fallback }
+
+/* The combined() macro inserts both the running entry as well as a stored
+ * entry. The running entry will always report the version from the active
+ * handler. The stored entry will first try the pending handler, and fallback
+ * to the active handler if the pending function does not report a version.
+ * The pending handler should check the status of a pending update for the
+ * relevant flash component. It should only fill in the buffer in the case
+ * where a valid pending version is available. This ensures that the related
+ * stored and running versions remain in sync, and that stored versions are
+ * correctly reported as expected.
+ */
+#define combined(key, active, pending) \
+	running(key, active), \
+	stored(key, pending, active)
 
 enum ice_version_type {
 	ICE_VERSION_FIXED,
@@ -158,14 +197,15 @@ static const struct ice_devlink_version {
 	enum ice_version_type type;
 	const char *key;
 	int (*getter)(struct ice_pf *pf, struct ice_info_ctx *ctx);
+	int (*fallback)(struct ice_pf *pf, struct ice_info_ctx *ctx);
 } ice_devlink_versions[] = {
 	fixed(DEVLINK_INFO_VERSION_GENERIC_BOARD_ID, ice_info_pba),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, ice_info_fw_mgmt),
 	running("fw.mgmt.api", ice_info_fw_api),
 	running("fw.mgmt.build", ice_info_fw_build),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_UNDI, ice_info_orom_ver),
-	running("fw.psid.api", ice_info_nvm_ver),
-	running(DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID, ice_info_eetrack),
+	combined("fw.psid.api", ice_info_nvm_ver, ice_info_pending_nvm_ver),
+	combined(DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID, ice_info_eetrack, ice_info_pending_eetrack),
 	running("fw.app.name", ice_info_ddp_pkg_name),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_APP, ice_info_ddp_pkg_version),
 	running("fw.app.bundle_id", ice_info_ddp_pkg_bundle_id),
@@ -189,7 +229,10 @@ static int ice_devlink_info_get(struct devlink *devlink,
 				struct netlink_ext_ack *extack)
 {
 	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
 	struct ice_info_ctx *ctx;
+	enum ice_status status;
 	size_t i;
 	int err;
 
@@ -197,6 +240,24 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	if (!ctx)
 		return -ENOMEM;
 
+	/* discover capabilities first */
+	status = ice_discover_dev_caps(hw, &ctx->dev_caps);
+	if (status) {
+		err = -EIO;
+		goto out_free_ctx;
+	}
+
+	if (ctx->dev_caps.common_cap.nvm_update_pending_nvm) {
+		status = ice_get_inactive_nvm_ver(hw, &ctx->pending_nvm);
+		if (status) {
+			dev_dbg(dev, "Unable to read inactive NVM version data, status %s aq_err %s\n",
+				ice_stat_str(status), ice_aq_str(hw->adminq.sq_last_status));
+
+			/* disable display of pending Option ROM */
+			ctx->dev_caps.common_cap.nvm_update_pending_nvm = false;
+		}
+	}
+
 	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Unable to set driver name");
@@ -223,6 +284,19 @@ static int ice_devlink_info_get(struct devlink *devlink,
 			goto out_free_ctx;
 		}
 
+		/* If the default getter doesn't report a version, use the
+		 * fallback function. This is primarily useful in the case of
+		 * "stored" versions that want to report the same value as the
+		 * running version in the normal case of no pending update.
+		 */
+		if (ctx->buf[0] == '\0' && ice_devlink_versions[i].fallback) {
+			err = ice_devlink_versions[i].fallback(pf, ctx);
+			if (err) {
+				NL_SET_ERR_MSG_MOD(extack, "Unable to obtain version info");
+				goto out_free_ctx;
+			}
+		}
+
 		/* Do not report missing versions */
 		if (ctx->buf[0] == '\0')
 			continue;
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 2434b7a4626b..f26e5105d584 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -569,6 +569,20 @@ ice_get_nvm_ver_info(struct ice_hw *hw, enum ice_bank_select bank, struct ice_nv
 	return 0;
 }
 
+/**
+ * ice_get_inactive_nvm_ver - Read Option ROM version from the inactive bank
+ * @hw: pointer to the HW structure
+ * @nvm: storage for Option ROM version information
+ *
+ * Reads the NVM EETRACK ID, Map version, and security revision of the
+ * inactive NVM bank. Used to access version data for a pending update that
+ * has not yet been activated.
+ */
+enum ice_status ice_get_inactive_nvm_ver(struct ice_hw *hw, struct ice_nvm_info *nvm)
+{
+	return ice_get_nvm_ver_info(hw, ICE_INACTIVE_FLASH_BANK, nvm);
+}
+
 /**
  * ice_get_orom_ver_info - Read Option ROM version information
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index 8d430909f846..23843d9b126c 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -14,6 +14,8 @@ enum ice_status
 ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
 		       u16 module_type);
 enum ice_status
+ice_get_inactive_nvm_ver(struct ice_hw *hw, struct ice_nvm_info *nvm);
+enum ice_status
 ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
 enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data);
-- 
2.26.2


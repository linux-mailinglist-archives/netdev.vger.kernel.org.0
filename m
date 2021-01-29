Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C763082A9
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhA2Arx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:47:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:27157 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhA2Ap5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:45:57 -0500
IronPort-SDR: tLr8l4JaSi9TKiBxyhqCwYvj5gixGoTRR2eBYWPI0+OqHqzdolgipZh5c+j7vkr2tqyfBGUqr7
 kvvCBdBuRXHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="167438970"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="167438970"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 16:42:52 -0800
IronPort-SDR: rEPiD9BKsRGFHFXS0DDhbU5nj/mDcgyTLsF9Yz7JD37dyB3fqR/lhFYZZmE7yjNvJO5vYIXL8h
 Pc64pk0bk9Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="430778709"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2021 16:42:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 10/15] ice: display some stored NVM versions via devlink info
Date:   Thu, 28 Jan 2021 16:43:27 -0800
Message-Id: <20210129004332.3004826-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The devlink info interface supports drivers reporting "stored" versions.
These versions indicate the version of an update that has been
downloaded to the device, but is not yet active.

Add a new function to read some of the fw.mgmt version data from the
inactive flash section. This function, ice_get_inactive_nvm_ver, will
read the NVM version data from the inactive section of flash.

To avoid code duplication, we refactor ice_get_nvm_ver_info so that it
takes the bank parameter for specifying which flash bank to read from.
Instead of reading from the copy stored in the Shadow RAM, always read
from the copy of the specified flash bank.

Note that the start of the Shadow RAM copy is not directly following the
CSS header, but is actually aligned to the next 64-byte boundary. The
correct word offset must be rounded up to 32-bytes.

When reporting the versions via devlink info, first read the device
capabilities. If there is a pending flash update, use this new function
to extract the inactive flash versions. Add the stored fields to the
flash version map structure so that they will be displayed when
available.

It should be noted that it is not currently feasible to extract all of
the related versions for the management firmware. This patch adds
support for displaying "fw.mgmt.srev", "fw.psid.api", and
"fw.bundle_id". The management firmware versions are more difficult to
extract from the binary and have not been implemented in this change.

Future changes will introduce support for reading the UNDI Option ROM
version and the version associated with the Netlist module.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 60 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_nvm.c     | 44 ++++++++++++--
 drivers/net/ethernet/intel/ice/ice_nvm.h     |  2 +
 drivers/net/ethernet/intel/ice/ice_type.h    |  8 ++-
 4 files changed, 107 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 917fdbb20b7b..377095774ddb 100644
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
@@ -80,6 +82,17 @@ static int ice_info_fw_srev(struct ice_pf *pf, struct ice_info_ctx *ctx)
 	return 0;
 }
 
+static int
+ice_info_pending_fw_srev(struct ice_pf __always_unused *pf, struct ice_info_ctx *ctx)
+{
+	struct ice_nvm_info *nvm = &ctx->pending_nvm;
+
+	if (ctx->dev_caps.common_cap.nvm_update_pending_nvm)
+		snprintf(ctx->buf, sizeof(ctx->buf), "%u", nvm->srev);
+
+	return 0;
+}
+
 static int ice_info_orom_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_orom_info *orom = &pf->hw.flash.orom;
@@ -107,6 +120,17 @@ static int ice_info_nvm_ver(struct ice_pf *pf, struct ice_info_ctx *ctx)
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
@@ -116,6 +140,17 @@ static int ice_info_eetrack(struct ice_pf *pf, struct ice_info_ctx *ctx)
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
@@ -165,6 +200,7 @@ static int ice_info_netlist_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
 
 #define fixed(key, getter) { ICE_VERSION_FIXED, key, getter }
 #define running(key, getter) { ICE_VERSION_RUNNING, key, getter }
+#define stored(key, getter) { ICE_VERSION_STORED, key, getter }
 
 enum ice_version_type {
 	ICE_VERSION_FIXED,
@@ -182,10 +218,13 @@ static const struct ice_devlink_version {
 	running("fw.mgmt.api", ice_info_fw_api),
 	running("fw.mgmt.build", ice_info_fw_build),
 	running("fw.mgmt.srev", ice_info_fw_srev),
+	stored("fw.mgmt.srev", ice_info_pending_fw_srev),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_UNDI, ice_info_orom_ver),
 	running("fw.undi.srev", ice_info_orom_srev),
 	running("fw.psid.api", ice_info_nvm_ver),
+	stored("fw.psid.api", ice_info_pending_nvm_ver),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID, ice_info_eetrack),
+	stored(DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID, ice_info_pending_eetrack),
 	running("fw.app.name", ice_info_ddp_pkg_name),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_APP, ice_info_ddp_pkg_version),
 	running("fw.app.bundle_id", ice_info_ddp_pkg_bundle_id),
@@ -209,7 +248,10 @@ static int ice_devlink_info_get(struct devlink *devlink,
 				struct netlink_ext_ack *extack)
 {
 	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
 	struct ice_info_ctx *ctx;
+	enum ice_status status;
 	size_t i;
 	int err;
 
@@ -217,6 +259,24 @@ static int ice_devlink_info_get(struct devlink *devlink,
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
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index ff99815402d1..9613d24eaa06 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -367,6 +367,22 @@ ice_read_nvm_module(struct ice_hw *hw, enum ice_bank_select bank, u32 offset, u1
 	return status;
 }
 
+/**
+ * ice_read_nvm_sr_copy - Read a word from the Shadow RAM copy in the NVM bank
+ * @hw: pointer to the HW structure
+ * @bank: whether to read from the active or inactive NVM module
+ * @offset: offset into the Shadow RAM copy to read, in words
+ * @data: storage for returned word value
+ *
+ * Read the specified word from the copy of the Shadow RAM found in the
+ * specified NVM module.
+ */
+static enum ice_status
+ice_read_nvm_sr_copy(struct ice_hw *hw, enum ice_bank_select bank, u32 offset, u16 *data)
+{
+	return ice_read_nvm_module(hw, bank, ICE_NVM_SR_COPY_WORD_OFFSET + offset, data);
+}
+
 /**
  * ice_read_orom_module - Read from the active Option ROM module
  * @hw: pointer to the HW structure
@@ -568,31 +584,33 @@ static enum ice_status ice_get_nvm_srev(struct ice_hw *hw, enum ice_bank_select
 /**
  * ice_get_nvm_ver_info - Read NVM version information
  * @hw: pointer to the HW struct
+ * @bank: whether to read from the active or inactive flash bank
  * @nvm: pointer to NVM info structure
  *
  * Read the NVM EETRACK ID and map version of the main NVM image bank, filling
  * in the nvm info structure.
  */
 static enum ice_status
-ice_get_nvm_ver_info(struct ice_hw *hw, struct ice_nvm_info *nvm)
+ice_get_nvm_ver_info(struct ice_hw *hw, enum ice_bank_select bank, struct ice_nvm_info *nvm)
 {
 	u16 eetrack_lo, eetrack_hi, ver;
 	enum ice_status status;
 
-	status = ice_read_sr_word(hw, ICE_SR_NVM_DEV_STARTER_VER, &ver);
+	status = ice_read_nvm_sr_copy(hw, bank, ICE_SR_NVM_DEV_STARTER_VER, &ver);
 	if (status) {
 		ice_debug(hw, ICE_DBG_NVM, "Failed to read DEV starter version.\n");
 		return status;
 	}
+
 	nvm->major = (ver & ICE_NVM_VER_HI_MASK) >> ICE_NVM_VER_HI_SHIFT;
 	nvm->minor = (ver & ICE_NVM_VER_LO_MASK) >> ICE_NVM_VER_LO_SHIFT;
 
-	status = ice_read_sr_word(hw, ICE_SR_NVM_EETRACK_LO, &eetrack_lo);
+	status = ice_read_nvm_sr_copy(hw, bank, ICE_SR_NVM_EETRACK_LO, &eetrack_lo);
 	if (status) {
 		ice_debug(hw, ICE_DBG_NVM, "Failed to read EETRACK lo.\n");
 		return status;
 	}
-	status = ice_read_sr_word(hw, ICE_SR_NVM_EETRACK_HI, &eetrack_hi);
+	status = ice_read_nvm_sr_copy(hw, bank, ICE_SR_NVM_EETRACK_HI, &eetrack_hi);
 	if (status) {
 		ice_debug(hw, ICE_DBG_NVM, "Failed to read EETRACK hi.\n");
 		return status;
@@ -600,13 +618,27 @@ ice_get_nvm_ver_info(struct ice_hw *hw, struct ice_nvm_info *nvm)
 
 	nvm->eetrack = (eetrack_hi << 16) | eetrack_lo;
 
-	status = ice_get_nvm_srev(hw, ICE_ACTIVE_FLASH_BANK, &nvm->srev);
+	status = ice_get_nvm_srev(hw, bank, &nvm->srev);
 	if (status)
 		ice_debug(hw, ICE_DBG_NVM, "Failed to read NVM security revision.\n");
 
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
  * ice_get_orom_srev - Read the security revision from the OROM CSS header
  * @hw: pointer to the HW struct
@@ -1028,7 +1060,7 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 		return status;
 	}
 
-	status = ice_get_nvm_ver_info(hw, &flash->nvm);
+	status = ice_get_nvm_ver_info(hw, ICE_ACTIVE_FLASH_BANK, &flash->nvm);
 	if (status) {
 		ice_debug(hw, ICE_DBG_INIT, "Failed to read NVM info.\n");
 		return status;
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index 8cfb9b9ac638..c5c737b7b062 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -18,6 +18,8 @@ ice_get_nvm_minsrevs(struct ice_hw *hw, struct ice_minsrev_info *minsrevs);
 enum ice_status
 ice_update_nvm_minsrevs(struct ice_hw *hw, struct ice_minsrev_info *minsrevs);
 enum ice_status
+ice_get_inactive_nvm_ver(struct ice_hw *hw, struct ice_nvm_info *nvm);
+enum ice_status
 ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
 enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index c5a9a6ad2907..c2fc12681bb3 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -843,8 +843,14 @@ struct ice_hw_port_stats {
 #define ICE_NVM_CSS_SREV_L			0x14
 #define ICE_NVM_CSS_SREV_H			0x15
 
+/* Length of CSS header section in words */
+#define ICE_CSS_HEADER_LENGTH			330
+
+/* Offset of Shadow RAM copy in the NVM bank area. */
+#define ICE_NVM_SR_COPY_WORD_OFFSET		roundup(ICE_CSS_HEADER_LENGTH, 32)
+
 /* Size in bytes of Option ROM trailer */
-#define ICE_NVM_OROM_TRAILER_LENGTH		660
+#define ICE_NVM_OROM_TRAILER_LENGTH		(2 * ICE_CSS_HEADER_LENGTH)
 
 /* Auxiliary field, mask, and shift definition for Shadow RAM and NVM Flash */
 #define ICE_SR_CTRL_WORD_1_S		0x06
-- 
2.26.2


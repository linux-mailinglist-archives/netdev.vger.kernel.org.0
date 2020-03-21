Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B68318DEA4
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 09:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgCUIKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 04:10:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:33285 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbgCUIKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 04:10:35 -0400
IronPort-SDR: lYjJsCTWQlOpqzqW6usF7MrEbbG883C41AgXynwLTEOX6fuhjYGEcOrWagkeLQc/Q0lYZxtxmA
 MhwpXRGRg46g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 01:10:30 -0700
IronPort-SDR: tldpKgqzCXZQEjsn4MFgyTowyFRYAgo+2Jm6ciGoRNx/oKONWwLBclM8Nh61PeDnI/FRmQTYqO
 rdfhPqQrW89A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,287,1580803200"; 
   d="scan'208";a="234737955"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2020 01:10:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 3/9] ice: store NVM version info in extracted format
Date:   Sat, 21 Mar 2020 01:10:22 -0700
Message-Id: <20200321081028.2763550-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The NVM version and Option ROM version information is stored within the
struct ice_nvm_ver_info structure. The data for the NVM is stored as
a 2byte value with the major and minor versions each using one byte from
the field. The Option ROM is stored as a 4byte value that contains
a major, build, and patch number.

Modify the code to immediately extract the version values and store them
in a new struct ice_orom_info. Remove the now unnecessary
ice_get_nvm_version function.

Update ice_ethtool.c to use the new fields directly from the structured
data.

This reduces complexity of the code that prints these versions in
ice_ethtool.c

Update the macro definitions and variable names to use the term "orom"
instead of "oem" for the Option ROM version. This helps increase the
clarity of the Option ROM version code.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c  | 23 -----
 drivers/net/ethernet/intel/ice/ice_common.h  |  3 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 13 +--
 drivers/net/ethernet/intel/ice/ice_nvm.c     | 94 +++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_type.h    | 30 ++++---
 5 files changed, 88 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index e574a70fcc99..6691e45367b3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -614,29 +614,6 @@ static void ice_get_itr_intrl_gran(struct ice_hw *hw)
 	}
 }
 
-/**
- * ice_get_nvm_version - get cached NVM version data
- * @hw: pointer to the hardware structure
- * @oem_ver: 8 bit NVM version
- * @oem_build: 16 bit NVM build number
- * @oem_patch: 8 NVM patch number
- * @ver_hi: high 8 bits of the NVM version
- * @ver_lo: low 8 bits of the NVM version
- */
-void
-ice_get_nvm_version(struct ice_hw *hw, u8 *oem_ver, u16 *oem_build,
-		    u8 *oem_patch, u8 *ver_hi, u8 *ver_lo)
-{
-	struct ice_nvm_info *nvm = &hw->nvm;
-
-	*oem_ver = (u8)((nvm->oem_ver & ICE_OEM_VER_MASK) >> ICE_OEM_VER_SHIFT);
-	*oem_patch = (u8)(nvm->oem_ver & ICE_OEM_VER_PATCH_MASK);
-	*oem_build = (u16)((nvm->oem_ver & ICE_OEM_VER_BUILD_MASK) >>
-			   ICE_OEM_VER_BUILD_SHIFT);
-	*ver_hi = (nvm->ver & ICE_NVM_VER_HI_MASK) >> ICE_NVM_VER_HI_SHIFT;
-	*ver_lo = (nvm->ver & ICE_NVM_VER_LO_MASK) >> ICE_NVM_VER_LO_SHIFT;
-}
-
 /**
  * ice_init_hw - main hardware initialization routine
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index f9fc005d35a7..8fb29657e316 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -153,9 +153,6 @@ ice_stat_update40(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 void
 ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
-void
-ice_get_nvm_version(struct ice_hw *hw, u8 *oem_ver, u16 *oem_build,
-		    u8 *oem_patch, u8 *ver_hi, u8 *ver_lo);
 enum ice_status
 ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 		     struct ice_aqc_get_elem *buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index e3d148f12aac..75970bcfa6c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -167,11 +167,14 @@ static void
 ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	u8 oem_ver, oem_patch, nvm_ver_hi, nvm_ver_lo;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
-	u16 oem_build;
+	struct ice_orom_info *orom;
+	struct ice_nvm_info *nvm;
+
+	nvm = &hw->nvm;
+	orom = &nvm->orom;
 
 	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
 	strscpy(drvinfo->version, ice_drv_ver, sizeof(drvinfo->version));
@@ -179,11 +182,9 @@ ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	/* Display NVM version (from which the firmware version can be
 	 * determined) which contains more pertinent information.
 	 */
-	ice_get_nvm_version(hw, &oem_ver, &oem_build, &oem_patch,
-			    &nvm_ver_hi, &nvm_ver_lo);
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
-		 "%x.%02x 0x%x %d.%d.%d", nvm_ver_hi, nvm_ver_lo,
-		 hw->nvm.eetrack, oem_ver, oem_build, oem_patch);
+		 "%x.%02x 0x%x %d.%d.%d", nvm->major_ver, nvm->minor_ver,
+		 nvm->eetrack, orom->major, orom->build, orom->patch);
 
 	strscpy(drvinfo->bus_info, pci_name(pf->pdev),
 		sizeof(drvinfo->bus_info));
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 97aaf75379ae..ef68fa989a57 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -307,6 +307,62 @@ enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
 	return status;
 }
 
+/**
+ * ice_get_orom_ver_info - Read Option ROM version information
+ * @hw: pointer to the HW struct
+ *
+ * Read the Combo Image version data from the Boot Configuration TLV and fill
+ * in the option ROM version data.
+ */
+static enum ice_status ice_get_orom_ver_info(struct ice_hw *hw)
+{
+	u16 combo_hi, combo_lo, boot_cfg_tlv, boot_cfg_tlv_len;
+	struct ice_orom_info *orom = &hw->nvm.orom;
+	enum ice_status status;
+	u32 combo_ver;
+
+	status = ice_get_pfa_module_tlv(hw, &boot_cfg_tlv, &boot_cfg_tlv_len,
+					ICE_SR_BOOT_CFG_PTR);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Failed to read Boot Configuration Block TLV.\n");
+		return status;
+	}
+
+	/* Boot Configuration Block must have length at least 2 words
+	 * (Combo Image Version High and Combo Image Version Low)
+	 */
+	if (boot_cfg_tlv_len < 2) {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Invalid Boot Configuration Block TLV size.\n");
+		return ICE_ERR_INVAL_SIZE;
+	}
+
+	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OROM_VER_OFF),
+				  &combo_hi);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read OROM_VER hi.\n");
+		return status;
+	}
+
+	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OROM_VER_OFF + 1),
+				  &combo_lo);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read OROM_VER lo.\n");
+		return status;
+	}
+
+	combo_ver = ((u32)combo_hi << 16) | combo_lo;
+
+	orom->major = (u8)((combo_ver & ICE_OROM_VER_MASK) >>
+			   ICE_OROM_VER_SHIFT);
+	orom->patch = (u8)(combo_ver & ICE_OROM_VER_PATCH_MASK);
+	orom->build = (u16)((combo_ver & ICE_OROM_VER_BUILD_MASK) >>
+			    ICE_OROM_VER_BUILD_SHIFT);
+
+	return 0;
+}
+
 /**
  * ice_init_nvm - initializes NVM setting
  * @hw: pointer to the HW struct
@@ -316,9 +372,8 @@ enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
  */
 enum ice_status ice_init_nvm(struct ice_hw *hw)
 {
-	u16 oem_hi, oem_lo, boot_cfg_tlv, boot_cfg_tlv_len;
 	struct ice_nvm_info *nvm = &hw->nvm;
-	u16 eetrack_lo, eetrack_hi;
+	u16 eetrack_lo, eetrack_hi, ver;
 	enum ice_status status;
 	u32 fla, gens_stat;
 	u8 sr_size;
@@ -344,12 +399,14 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 		return ICE_ERR_NVM_BLANK_MODE;
 	}
 
-	status = ice_read_sr_word(hw, ICE_SR_NVM_DEV_STARTER_VER, &nvm->ver);
+	status = ice_read_sr_word(hw, ICE_SR_NVM_DEV_STARTER_VER, &ver);
 	if (status) {
 		ice_debug(hw, ICE_DBG_INIT,
 			  "Failed to read DEV starter version.\n");
 		return status;
 	}
+	nvm->major_ver = (ver & ICE_NVM_VER_HI_MASK) >> ICE_NVM_VER_HI_SHIFT;
+	nvm->minor_ver = (ver & ICE_NVM_VER_LO_MASK) >> ICE_NVM_VER_LO_SHIFT;
 
 	status = ice_read_sr_word(hw, ICE_SR_NVM_EETRACK_LO, &eetrack_lo);
 	if (status) {
@@ -390,39 +447,12 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 		break;
 	}
 
-	status = ice_get_pfa_module_tlv(hw, &boot_cfg_tlv, &boot_cfg_tlv_len,
-					ICE_SR_BOOT_CFG_PTR);
+	status = ice_get_orom_ver_info(hw);
 	if (status) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Failed to read Boot Configuration Block TLV.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read Option ROM info.\n");
 		return status;
 	}
 
-	/* Boot Configuration Block must have length at least 2 words
-	 * (Combo Image Version High and Combo Image Version Low)
-	 */
-	if (boot_cfg_tlv_len < 2) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Invalid Boot Configuration Block TLV size.\n");
-		return ICE_ERR_INVAL_SIZE;
-	}
-
-	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OEM_VER_OFF),
-				  &oem_hi);
-	if (status) {
-		ice_debug(hw, ICE_DBG_INIT, "Failed to read OEM_VER hi.\n");
-		return status;
-	}
-
-	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OEM_VER_OFF + 1),
-				  &oem_lo);
-	if (status) {
-		ice_debug(hw, ICE_DBG_INIT, "Failed to read OEM_VER lo.\n");
-		return status;
-	}
-
-	nvm->oem_ver = ((u32)oem_hi << 16) | oem_lo;
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index db0ef6ba907f..5bc94217778e 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -239,12 +239,20 @@ struct ice_fc_info {
 	enum ice_fc_mode req_mode;	/* FC mode requested by caller */
 };
 
+/* Option ROM version information */
+struct ice_orom_info {
+	u8 major;			/* Major version of OROM */
+	u8 patch;			/* Patch version of OROM */
+	u16 build;			/* Build version of OROM */
+};
+
 /* NVM Information */
 struct ice_nvm_info {
-	u32 eetrack;              /* NVM data version */
-	u32 oem_ver;              /* OEM version info */
-	u16 sr_words;             /* Shadow RAM size in words */
-	u16 ver;                  /* NVM package version */
+	struct ice_orom_info orom;	/* Option ROM version info */
+	u32 eetrack;			/* NVM data version */
+	u16 sr_words;			/* Shadow RAM size in words */
+	u8 major_ver;			/* major version of NVM package */
+	u8 minor_ver;			/* minor version of dev starter */
 	u8 blank_nvm_mode;        /* is NVM empty (no FW present) */
 };
 
@@ -626,7 +634,7 @@ struct ice_hw_port_stats {
 
 /* Checksum and Shadow RAM pointers */
 #define ICE_SR_BOOT_CFG_PTR		0x132
-#define ICE_NVM_OEM_VER_OFF		0x02
+#define ICE_NVM_OROM_VER_OFF		0x02
 #define ICE_SR_NVM_DEV_STARTER_VER	0x18
 #define ICE_SR_NVM_EETRACK_LO		0x2D
 #define ICE_SR_NVM_EETRACK_HI		0x2E
@@ -634,12 +642,12 @@ struct ice_hw_port_stats {
 #define ICE_NVM_VER_LO_MASK		(0xff << ICE_NVM_VER_LO_SHIFT)
 #define ICE_NVM_VER_HI_SHIFT		12
 #define ICE_NVM_VER_HI_MASK		(0xf << ICE_NVM_VER_HI_SHIFT)
-#define ICE_OEM_VER_PATCH_SHIFT		0
-#define ICE_OEM_VER_PATCH_MASK		(0xff << ICE_OEM_VER_PATCH_SHIFT)
-#define ICE_OEM_VER_BUILD_SHIFT		8
-#define ICE_OEM_VER_BUILD_MASK		(0xffff << ICE_OEM_VER_BUILD_SHIFT)
-#define ICE_OEM_VER_SHIFT		24
-#define ICE_OEM_VER_MASK		(0xff << ICE_OEM_VER_SHIFT)
+#define ICE_OROM_VER_PATCH_SHIFT	0
+#define ICE_OROM_VER_PATCH_MASK		(0xff << ICE_OROM_VER_PATCH_SHIFT)
+#define ICE_OROM_VER_BUILD_SHIFT	8
+#define ICE_OROM_VER_BUILD_MASK		(0xffff << ICE_OROM_VER_BUILD_SHIFT)
+#define ICE_OROM_VER_SHIFT		24
+#define ICE_OROM_VER_MASK		(0xff << ICE_OROM_VER_SHIFT)
 #define ICE_SR_PFA_PTR			0x40
 #define ICE_SR_SECTOR_SIZE_IN_WORDS	0x800
 #define ICE_SR_WORDS_IN_1KB		512
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207F215FA66
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgBNXXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:23:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:41445 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgBNXW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629280"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:26 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 05/22] ice: rename variables used for Option ROM version
Date:   Fri, 14 Feb 2020 15:22:04 -0800
Message-Id: <20200214232223.3442651-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ice_get_nvm_version reports data for both the NVM map
version and the version of the combined Option ROM. The version data for
the option ROM uses variables with the prefix "oem".

This causes confusion as it makes it difficult for a reviewer to
understand what the version actually represents.

Rename the variables to use the prefix "orom", and update the code
comments to mention that this is the combined Option ROM version. This
helps the code clarify what the version actually represents.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c  | 19 ++++++++++---------
 drivers/net/ethernet/intel/ice/ice_common.h  |  4 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_nvm.c     | 16 ++++++++--------
 drivers/net/ethernet/intel/ice/ice_type.h    | 16 ++++++++--------
 5 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 04d5db0a25bf..a74532520112 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -617,22 +617,23 @@ static void ice_get_itr_intrl_gran(struct ice_hw *hw)
 /**
  * ice_get_nvm_version - get cached NVM version data
  * @hw: pointer to the hardware structure
- * @oem_ver: 8 bit NVM version
- * @oem_build: 16 bit NVM build number
- * @oem_patch: 8 NVM patch number
+ * @orom_ver: 8 bit version of combined Option ROM
+ * @orom_build: 16 bit build number of combined Option ROM
+ * @orom_patch: 8 bit patch level of combined Option ROM
  * @ver_hi: high 16 bits of the NVM version
  * @ver_lo: low 16 bits of the NVM version
  */
 void
-ice_get_nvm_version(struct ice_hw *hw, u8 *oem_ver, u16 *oem_build,
-		    u8 *oem_patch, u8 *ver_hi, u8 *ver_lo)
+ice_get_nvm_version(struct ice_hw *hw, u8 *orom_ver, u16 *orom_build,
+		    u8 *orom_patch, u8 *ver_hi, u8 *ver_lo)
 {
 	struct ice_nvm_info *nvm = &hw->nvm;
 
-	*oem_ver = (u8)((nvm->oem_ver & ICE_OEM_VER_MASK) >> ICE_OEM_VER_SHIFT);
-	*oem_patch = (u8)(nvm->oem_ver & ICE_OEM_VER_PATCH_MASK);
-	*oem_build = (u16)((nvm->oem_ver & ICE_OEM_VER_BUILD_MASK) >>
-			   ICE_OEM_VER_BUILD_SHIFT);
+	*orom_ver = (u8)((nvm->orom_ver & ICE_OROM_VER_MASK) >>
+			 ICE_OROM_VER_SHIFT);
+	*orom_patch = (u8)(nvm->orom_ver & ICE_OROM_VER_PATCH_MASK);
+	*orom_build = (u16)((nvm->orom_ver & ICE_OROM_VER_BUILD_MASK) >>
+			   ICE_OROM_VER_BUILD_SHIFT);
 	*ver_hi = (nvm->ver & ICE_NVM_VER_HI_MASK) >> ICE_NVM_VER_HI_SHIFT;
 	*ver_lo = (nvm->ver & ICE_NVM_VER_LO_MASK) >> ICE_NVM_VER_LO_SHIFT;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 9d5e86c9f886..0f9aa1986cab 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -151,8 +151,8 @@ void
 ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
 void
-ice_get_nvm_version(struct ice_hw *hw, u8 *oem_ver, u16 *oem_build,
-		    u8 *oem_patch, u8 *ver_hi, u8 *ver_lo);
+ice_get_nvm_version(struct ice_hw *hw, u8 *orom_ver, u16 *orom_build,
+		    u8 *orom_patch, u8 *ver_hi, u8 *ver_lo);
 enum ice_status
 ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 		     struct ice_aqc_get_elem *buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 223e8e707dcb..af5e5d6fc29c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -166,11 +166,11 @@ static void
 ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	u8 oem_ver, oem_patch, nvm_ver_hi, nvm_ver_lo;
+	u8 orom_ver, orom_patch, nvm_ver_hi, nvm_ver_lo;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
-	u16 oem_build;
+	u16 orom_build;
 
 	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
 	strlcpy(drvinfo->version, ice_drv_ver, sizeof(drvinfo->version));
@@ -178,11 +178,11 @@ ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	/* Display NVM version (from which the firmware version can be
 	 * determined) which contains more pertinent information.
 	 */
-	ice_get_nvm_version(hw, &oem_ver, &oem_build, &oem_patch,
+	ice_get_nvm_version(hw, &orom_ver, &orom_build, &orom_patch,
 			    &nvm_ver_hi, &nvm_ver_lo);
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%x.%02x 0x%x %d.%d.%d", nvm_ver_hi, nvm_ver_lo,
-		 hw->nvm.eetrack, oem_ver, oem_build, oem_patch);
+		 hw->nvm.eetrack, orom_ver, orom_build, orom_patch);
 
 	strlcpy(drvinfo->bus_info, pci_name(pf->pdev),
 		sizeof(drvinfo->bus_info));
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index aaf5fd064725..7d5f2a6296c9 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -195,7 +195,7 @@ enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
  */
 enum ice_status ice_init_nvm(struct ice_hw *hw)
 {
-	u16 oem_hi, oem_lo, boot_cfg_tlv, boot_cfg_tlv_len;
+	u16 orom_hi, orom_lo, boot_cfg_tlv, boot_cfg_tlv_len;
 	struct ice_nvm_info *nvm = &hw->nvm;
 	u16 eetrack_lo, eetrack_hi;
 	enum ice_status status;
@@ -272,21 +272,21 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 		return ICE_ERR_INVAL_SIZE;
 	}
 
-	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OEM_VER_OFF),
-				  &oem_hi);
+	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OROM_VER_OFF),
+				  &orom_hi);
 	if (status) {
-		ice_debug(hw, ICE_DBG_INIT, "Failed to read OEM_VER hi.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read OROM_VER hi.\n");
 		return status;
 	}
 
-	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OEM_VER_OFF + 1),
-				  &oem_lo);
+	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OROM_VER_OFF + 1),
+				  &orom_lo);
 	if (status) {
-		ice_debug(hw, ICE_DBG_INIT, "Failed to read OEM_VER lo.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read OROM_VER lo.\n");
 		return status;
 	}
 
-	nvm->oem_ver = ((u32)oem_hi << 16) | oem_lo;
+	nvm->orom_ver = ((u32)orom_hi << 16) | orom_lo;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index db0ef6ba907f..1d9420cd53b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -242,7 +242,7 @@ struct ice_fc_info {
 /* NVM Information */
 struct ice_nvm_info {
 	u32 eetrack;              /* NVM data version */
-	u32 oem_ver;              /* OEM version info */
+	u32 orom_ver;             /* Combined Option ROM version info */
 	u16 sr_words;             /* Shadow RAM size in words */
 	u16 ver;                  /* NVM package version */
 	u8 blank_nvm_mode;        /* is NVM empty (no FW present) */
@@ -626,7 +626,7 @@ struct ice_hw_port_stats {
 
 /* Checksum and Shadow RAM pointers */
 #define ICE_SR_BOOT_CFG_PTR		0x132
-#define ICE_NVM_OEM_VER_OFF		0x02
+#define ICE_NVM_OROM_VER_OFF		0x02
 #define ICE_SR_NVM_DEV_STARTER_VER	0x18
 #define ICE_SR_NVM_EETRACK_LO		0x2D
 #define ICE_SR_NVM_EETRACK_HI		0x2E
@@ -634,12 +634,12 @@ struct ice_hw_port_stats {
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
2.25.0.368.g28a2d05eebfb


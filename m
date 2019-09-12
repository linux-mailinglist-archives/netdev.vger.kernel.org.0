Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AB7B1597
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 22:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfILUuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 16:50:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:59562 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbfILUuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 16:50:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 13:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="197345133"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 12 Sep 2019 13:50:04 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Lukasz Czapnik <lukasz.czapnik@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/6] ice: Fix FW version formatting in dmesg
Date:   Thu, 12 Sep 2019 13:49:58 -0700
Message-Id: <20190912205002.12159-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
References: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

The FW build id is currently being displayed as an int which doesn't make
sense. Instead display FW build id as a hex value. Also add other useful
information to the output such as NVM version, API patch info, and FW
build hash.

Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  1 -
 drivers/net/ethernet/intel/ice/ice_common.c  | 23 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h  |  3 +++
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 25 --------------------
 drivers/net/ethernet/intel/ice/ice_lib.c     | 19 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h     |  2 ++
 drivers/net/ethernet/intel/ice/ice_main.c    |  7 +++---
 drivers/net/ethernet/intel/ice/ice_type.h    |  2 ++
 8 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 4cdedcebb163..3a3e69a2bc5a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -53,7 +53,6 @@ extern const char ice_drv_ver[];
 
 #define ICE_DFLT_TRAFFIC_CLASS	BIT(0)
 #define ICE_INT_NAME_STR_LEN	(IFNAMSIZ + 16)
-#define ICE_ETHTOOL_FWVER_LEN	32
 #define ICE_AQ_LEN		64
 #define ICE_MBXSQ_LEN		64
 #define ICE_MBXRQ_LEN		512
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index db62cc748544..22d2a11ef41f 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -728,6 +728,29 @@ static void ice_get_itr_intrl_gran(struct ice_hw *hw)
 	}
 }
 
+/**
+ * ice_get_nvm_version - get cached NVM version data
+ * @hw: pointer to the hardware structure
+ * @oem_ver: 8 bit NVM version
+ * @oem_build: 16 bit NVM build number
+ * @oem_patch: 8 NVM patch number
+ * @ver_hi: high 16 bits of the NVM version
+ * @ver_lo: low 16 bits of the NVM version
+ */
+void
+ice_get_nvm_version(struct ice_hw *hw, u8 *oem_ver, u16 *oem_build,
+		    u8 *oem_patch, u8 *ver_hi, u8 *ver_lo)
+{
+	struct ice_nvm_info *nvm = &hw->nvm;
+
+	*oem_ver = (u8)((nvm->oem_ver & ICE_OEM_VER_MASK) >> ICE_OEM_VER_SHIFT);
+	*oem_patch = (u8)(nvm->oem_ver & ICE_OEM_VER_PATCH_MASK);
+	*oem_build = (u16)((nvm->oem_ver & ICE_OEM_VER_BUILD_MASK) >>
+			   ICE_OEM_VER_BUILD_SHIFT);
+	*ver_hi = (nvm->ver & ICE_NVM_VER_HI_MASK) >> ICE_NVM_VER_HI_SHIFT;
+	*ver_lo = (nvm->ver & ICE_NVM_VER_LO_MASK) >> ICE_NVM_VER_LO_SHIFT;
+}
+
 /**
  * ice_init_hw - main hardware initialization routine
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index e9d77370a17c..0525a051e05b 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -133,6 +133,9 @@ ice_stat_update40(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 void
 ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
+void
+ice_get_nvm_version(struct ice_hw *hw, u8 *oem_ver, u16 *oem_build,
+		    u8 *oem_patch, u8 *ver_hi, u8 *ver_lo);
 enum ice_status
 ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 		     struct ice_aqc_get_elem *buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index d5db1426d484..a16b461b46bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -160,31 +160,6 @@ static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
 
 #define ICE_PRIV_FLAG_ARRAY_SIZE	ARRAY_SIZE(ice_gstrings_priv_flags)
 
-/**
- * ice_nvm_version_str - format the NVM version strings
- * @hw: ptr to the hardware info
- */
-static char *ice_nvm_version_str(struct ice_hw *hw)
-{
-	static char buf[ICE_ETHTOOL_FWVER_LEN];
-	u8 ver, patch;
-	u32 full_ver;
-	u16 build;
-
-	full_ver = hw->nvm.oem_ver;
-	ver = (u8)((full_ver & ICE_OEM_VER_MASK) >> ICE_OEM_VER_SHIFT);
-	build = (u16)((full_ver & ICE_OEM_VER_BUILD_MASK) >>
-		      ICE_OEM_VER_BUILD_SHIFT);
-	patch = (u8)(full_ver & ICE_OEM_VER_PATCH_MASK);
-
-	snprintf(buf, sizeof(buf), "%x.%02x 0x%x %d.%d.%d",
-		 (hw->nvm.ver & ICE_NVM_VER_HI_MASK) >> ICE_NVM_VER_HI_SHIFT,
-		 (hw->nvm.ver & ICE_NVM_VER_LO_MASK) >> ICE_NVM_VER_LO_SHIFT,
-		 hw->nvm.eetrack, ver, build, patch);
-
-	return buf;
-}
-
 static void
 ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7cd8c5d13bcc..9680692bf27c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3275,6 +3275,25 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 }
 #endif /* CONFIG_DCB */
 
+/**
+ * ice_nvm_version_str - format the NVM version strings
+ * @hw: ptr to the hardware info
+ */
+char *ice_nvm_version_str(struct ice_hw *hw)
+{
+	u8 oem_ver, oem_patch, ver_hi, ver_lo;
+	static char buf[ICE_NVM_VER_LEN];
+	u16 oem_build;
+
+	ice_get_nvm_version(hw, &oem_ver, &oem_build, &oem_patch, &ver_hi,
+			    &ver_lo);
+
+	snprintf(buf, sizeof(buf), "%x.%02x 0x%x %d.%d.%d", ver_hi, ver_lo,
+		 hw->nvm.eetrack, oem_ver, oem_build, oem_patch);
+
+	return buf;
+}
+
 /**
  * ice_vsi_cfg_mac_fltr - Add or remove a MAC address filter for a VSI
  * @vsi: the VSI being configured MAC filter
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 7faf8db844f6..87f7f5422b46 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -120,6 +120,8 @@ int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
 
 u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran);
 
+char *ice_nvm_version_str(struct ice_hw *hw);
+
 enum ice_status
 ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c0988b74f007..ff295cb54cfd 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2558,9 +2558,10 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_exit_unroll;
 	}
 
-	dev_info(dev, "firmware %d.%d.%05d api %d.%d\n",
-		 hw->fw_maj_ver, hw->fw_min_ver, hw->fw_build,
-		 hw->api_maj_ver, hw->api_min_ver);
+	dev_info(dev, "firmware %d.%d.%d api %d.%d.%d nvm %s build 0x%08x\n",
+		 hw->fw_maj_ver, hw->fw_min_ver, hw->fw_patch,
+		 hw->api_maj_ver, hw->api_min_ver, hw->api_patch,
+		 ice_nvm_version_str(hw), hw->fw_build);
 
 	err = ice_init_pf(pf);
 	if (err) {
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index a2676003275a..7ec8a529b5cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -230,6 +230,8 @@ struct ice_nvm_info {
 	u8 blank_nvm_mode;        /* is NVM empty (no FW present) */
 };
 
+#define ICE_NVM_VER_LEN	32
+
 /* Max number of port to queue branches w.r.t topology */
 #define ICE_MAX_TRAFFIC_CLASS 8
 #define ICE_TXSCHED_MAX_BRANCHES ICE_MAX_TRAFFIC_CLASS
-- 
2.21.0


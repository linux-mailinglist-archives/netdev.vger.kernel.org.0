Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F64C350A8F
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhCaXHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:62995 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231544AbhCaXH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:27 -0400
IronPort-SDR: ywS1zUHHA9dH+LMaF3tbaXj9EupkaUftJPUNkr8xC3D1FCYs71gUaBwLN1QozqcGJvQFvz52ry
 eiVHHCw0RLcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587984"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587984"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:25 -0700
IronPort-SDR: t1Us+TQatWzokp93/JP0cqHmQZeNSbhu5D1skfJ3TA76l1mOk27370/npXuxKz82Da5uvj+obE
 fXYc4uV3+56A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680138"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 11/15] ice: Refactor get/set RSS LUT to use struct parameter
Date:   Wed, 31 Mar 2021 16:08:54 -0700
Message-Id: <20210331230858.782492-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Update ice_aq_get_rss_lut() and ice_aq_set_rss_lut() to take a new
structure ice_aq_get_set_rss_params instead of passing individual
parameters. This is done for 2 reasons:

1. Reduce the number of parameters passed to the functions.
2. Reduce the amount of change required if the arguments ever need to be
   updated in the future.

Also, reduce duplicate code that was checking for an invalid vsi_handle
and lut parameter by moving the checks to the lower level
__ice_aq_get_set_rss_lut().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c  | 54 +++++++++-----------
 drivers/net/ethernet/intel/ice/ice_common.h  |  6 +--
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  9 +++-
 drivers/net/ethernet/intel/ice/ice_lib.c     |  9 +++-
 drivers/net/ethernet/intel/ice/ice_main.c    | 18 +++++--
 drivers/net/ethernet/intel/ice/ice_type.h    |  8 +++
 6 files changed, 62 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index b906ca4dad36..54df00ee912b 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3206,23 +3206,33 @@ ice_aq_sff_eeprom(struct ice_hw *hw, u16 lport, u8 bus_addr,
 /**
  * __ice_aq_get_set_rss_lut
  * @hw: pointer to the hardware structure
- * @vsi_id: VSI FW index
- * @lut_type: LUT table type
- * @lut: pointer to the LUT buffer provided by the caller
- * @lut_size: size of the LUT buffer
- * @glob_lut_idx: global LUT index
+ * @params: RSS LUT parameters
  * @set: set true to set the table, false to get the table
  *
  * Internal function to get (0x0B05) or set (0x0B03) RSS look up table
  */
 static enum ice_status
-__ice_aq_get_set_rss_lut(struct ice_hw *hw, u16 vsi_id, u8 lut_type, u8 *lut,
-			 u16 lut_size, u8 glob_lut_idx, bool set)
+__ice_aq_get_set_rss_lut(struct ice_hw *hw, struct ice_aq_get_set_rss_lut_params *params, bool set)
 {
+	u16 flags = 0, vsi_id, lut_type, lut_size, glob_lut_idx, vsi_handle;
 	struct ice_aqc_get_set_rss_lut *cmd_resp;
 	struct ice_aq_desc desc;
 	enum ice_status status;
-	u16 flags = 0;
+	u8 *lut;
+
+	if (!params)
+		return ICE_ERR_PARAM;
+
+	vsi_handle = params->vsi_handle;
+	lut = params->lut;
+
+	if (!ice_is_vsi_valid(hw, vsi_handle) || !lut)
+		return ICE_ERR_PARAM;
+
+	lut_size = params->lut_size;
+	lut_type = params->lut_type;
+	glob_lut_idx = params->global_lut_id;
+	vsi_id = ice_get_hw_vsi_num(hw, vsi_handle);
 
 	cmd_resp = &desc.params.get_set_rss_lut;
 
@@ -3296,43 +3306,27 @@ __ice_aq_get_set_rss_lut(struct ice_hw *hw, u16 vsi_id, u8 lut_type, u8 *lut,
 /**
  * ice_aq_get_rss_lut
  * @hw: pointer to the hardware structure
- * @vsi_handle: software VSI handle
- * @lut_type: LUT table type
- * @lut: pointer to the LUT buffer provided by the caller
- * @lut_size: size of the LUT buffer
+ * @get_params: RSS LUT parameters used to specify which RSS LUT to get
  *
  * get the RSS lookup table, PF or VSI type
  */
 enum ice_status
-ice_aq_get_rss_lut(struct ice_hw *hw, u16 vsi_handle, u8 lut_type,
-		   u8 *lut, u16 lut_size)
+ice_aq_get_rss_lut(struct ice_hw *hw, struct ice_aq_get_set_rss_lut_params *get_params)
 {
-	if (!ice_is_vsi_valid(hw, vsi_handle) || !lut)
-		return ICE_ERR_PARAM;
-
-	return __ice_aq_get_set_rss_lut(hw, ice_get_hw_vsi_num(hw, vsi_handle),
-					lut_type, lut, lut_size, 0, false);
+	return __ice_aq_get_set_rss_lut(hw, get_params, false);
 }
 
 /**
  * ice_aq_set_rss_lut
  * @hw: pointer to the hardware structure
- * @vsi_handle: software VSI handle
- * @lut_type: LUT table type
- * @lut: pointer to the LUT buffer provided by the caller
- * @lut_size: size of the LUT buffer
+ * @set_params: RSS LUT parameters used to specify how to set the RSS LUT
  *
  * set the RSS lookup table, PF or VSI type
  */
 enum ice_status
-ice_aq_set_rss_lut(struct ice_hw *hw, u16 vsi_handle, u8 lut_type,
-		   u8 *lut, u16 lut_size)
+ice_aq_set_rss_lut(struct ice_hw *hw, struct ice_aq_get_set_rss_lut_params *set_params)
 {
-	if (!ice_is_vsi_valid(hw, vsi_handle) || !lut)
-		return ICE_ERR_PARAM;
-
-	return __ice_aq_get_set_rss_lut(hw, ice_get_hw_vsi_num(hw, vsi_handle),
-					lut_type, lut, lut_size, 0, true);
+	return __ice_aq_get_set_rss_lut(hw, set_params, true);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index baf4064fcbfe..81fd69cb1485 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -51,11 +51,9 @@ ice_write_rxq_ctx(struct ice_hw *hw, struct ice_rlan_ctx *rlan_ctx,
 		  u32 rxq_index);
 
 enum ice_status
-ice_aq_get_rss_lut(struct ice_hw *hw, u16 vsi_handle, u8 lut_type, u8 *lut,
-		   u16 lut_size);
+ice_aq_get_rss_lut(struct ice_hw *hw, struct ice_aq_get_set_rss_lut_params *get_params);
 enum ice_status
-ice_aq_set_rss_lut(struct ice_hw *hw, u16 vsi_handle, u8 lut_type, u8 *lut,
-		   u16 lut_size);
+ice_aq_set_rss_lut(struct ice_hw *hw, struct ice_aq_get_set_rss_lut_params *set_params);
 enum ice_status
 ice_aq_get_rss_key(struct ice_hw *hw, u16 vsi_handle,
 		   struct ice_aqc_get_set_rss_keys *keys);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 109dd6962b1d..0840fcf2f2cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3328,6 +3328,7 @@ static int ice_get_valid_rss_size(struct ice_hw *hw, int new_size)
  */
 static int ice_vsi_set_dflt_rss_lut(struct ice_vsi *vsi, int req_rss_size)
 {
+	struct ice_aq_get_set_rss_lut_params set_params = {};
 	struct ice_pf *pf = vsi->back;
 	enum ice_status status;
 	struct device *dev;
@@ -3353,8 +3354,12 @@ static int ice_vsi_set_dflt_rss_lut(struct ice_vsi *vsi, int req_rss_size)
 
 	/* create/set RSS LUT */
 	ice_fill_rss_lut(lut, vsi->rss_table_size, vsi->rss_size);
-	status = ice_aq_set_rss_lut(hw, vsi->idx, vsi->rss_lut_type, lut,
-				    vsi->rss_table_size);
+	set_params.vsi_handle = vsi->idx;
+	set_params.lut_size = vsi->rss_table_size;
+	set_params.lut_type = vsi->rss_lut_type;
+	set_params.lut = lut;
+	set_params.global_lut_id = 0;
+	status = ice_aq_set_rss_lut(hw, &set_params);
 	if (status) {
 		dev_err(dev, "Cannot set RSS lut, err %s aq_err %s\n",
 			ice_stat_str(status),
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index f2cf914cba69..22bcccd1073b 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1337,6 +1337,7 @@ int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
  */
 static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 {
+	struct ice_aq_get_set_rss_lut_params set_params = {};
 	struct ice_aqc_get_set_rss_keys *key;
 	struct ice_pf *pf = vsi->back;
 	enum ice_status status;
@@ -1356,8 +1357,12 @@ static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 	else
 		ice_fill_rss_lut(lut, vsi->rss_table_size, vsi->rss_size);
 
-	status = ice_aq_set_rss_lut(&pf->hw, vsi->idx, vsi->rss_lut_type, lut,
-				    vsi->rss_table_size);
+	set_params.vsi_handle = vsi->idx;
+	set_params.lut_size = vsi->rss_table_size;
+	set_params.lut_type = vsi->rss_lut_type;
+	set_params.lut = lut;
+	set_params.global_lut_id = 0;
+	status = ice_aq_set_rss_lut(&pf->hw, &set_params);
 
 	if (status) {
 		dev_err(dev, "set_rss_lut failed, error %s\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 336db16d0e12..8085f0ab2441 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6348,8 +6348,13 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 	}
 
 	if (lut) {
-		status = ice_aq_set_rss_lut(hw, vsi->idx, vsi->rss_lut_type,
-					    lut, lut_size);
+		struct ice_aq_get_set_rss_lut_params set_params = {
+			.vsi_handle = vsi->idx, .lut_size = lut_size,
+			.lut_type = vsi->rss_lut_type, .lut = lut,
+			.global_lut_id = 0
+		};
+
+		status = ice_aq_set_rss_lut(hw, &set_params);
 		if (status) {
 			dev_err(dev, "Cannot set RSS lut, err %s aq_err %s\n",
 				ice_stat_str(status),
@@ -6392,8 +6397,13 @@ int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 	}
 
 	if (lut) {
-		status = ice_aq_get_rss_lut(hw, vsi->idx, vsi->rss_lut_type,
-					    lut, lut_size);
+		struct ice_aq_get_set_rss_lut_params get_params = {
+			.vsi_handle = vsi->idx, .lut_size = lut_size,
+			.lut_type = vsi->rss_lut_type, .lut = lut,
+			.global_lut_id = 0
+		};
+
+		status = ice_aq_get_rss_lut(hw, &get_params);
 		if (status) {
 			dev_err(dev, "Cannot get RSS lut, err %s aq_err %s\n",
 				ice_stat_str(status),
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index ba157b383127..276ebcc309dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -827,6 +827,14 @@ struct ice_hw_port_stats {
 	u64 fd_sb_match;
 };
 
+struct ice_aq_get_set_rss_lut_params {
+	u16 vsi_handle;		/* software VSI handle */
+	u16 lut_size;		/* size of the LUT buffer */
+	u8 lut_type;		/* type of the LUT (i.e. VSI, PF, Global) */
+	u8 *lut;		/* input RSS LUT for set and output RSS LUT for get */
+	u8 global_lut_id;	/* only valid when lut_type is global */
+};
+
 /* Checksum and Shadow RAM pointers */
 #define ICE_SR_NVM_CTRL_WORD		0x00
 #define ICE_SR_BOOT_CFG_PTR		0x132
-- 
2.26.2


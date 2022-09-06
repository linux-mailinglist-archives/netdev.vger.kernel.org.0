Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC61F5AF6AD
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiIFVNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiIFVNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:13:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAE4B81FB
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662498788; x=1694034788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Akq2irF5tszgvMBXr+DQ7V7jouCVUpoXinqzAgZkzuY=;
  b=nCmTBFlPl8iri/jm5lc7uwqki0GSQGPM6N4ITEGh2AsFCHgSk4zIECGW
   hm+WpefWes8InAIYn+HokkHG4r1YUgNk1AkkBwF9kwUaRUrtsfqoQVZGi
   ETzSuNnQlC4CodS0F1j3s3RRmY1oB18s1QDdOvQ0brqkDX5Tn67QPKnMu
   K9zgcTALH9zJcBjMrrKYquUVAZhGFnhjs+bVonSadmJhn6XD8JJ+zvUs3
   Yij9HbmR/FeosKt+frd1ggss0i5Q6QkDpKYLbrMopzJUzb6IpmA6/bYeT
   weL+ZAlvIXXxgo06pROe7Dxu6wisDxt4SA0oaiFZ34rd3RVPnsLqhRq7d
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="295441850"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="295441850"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:13:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="591421365"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Sep 2022 14:13:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/5] ice: add helper function to check FW API version
Date:   Tue,  6 Sep 2022 14:13:00 -0700
Message-Id: <20220906211302.3501186-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
References: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Several functions in ice_common.c check the firmware API version to see if
the current API version meets some minimum requirement.

Improve the readability of these checks by introducing
ice_is_fw_api_min_ver, a helper function to perform that check.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 57 +++++++++++----------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 40e4c286649c..bec770e34f39 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -5286,26 +5286,41 @@ ice_aq_get_gpio(struct ice_hw *hw, u16 gpio_ctrl_handle, u8 pin_idx,
 }
 
 /**
- * ice_fw_supports_link_override
+ * ice_is_fw_api_min_ver
  * @hw: pointer to the hardware structure
+ * @maj: major version
+ * @min: minor version
+ * @patch: patch version
  *
- * Checks if the firmware supports link override
+ * Checks if the firmware API is minimum version
  */
-bool ice_fw_supports_link_override(struct ice_hw *hw)
+static bool ice_is_fw_api_min_ver(struct ice_hw *hw, u8 maj, u8 min, u8 patch)
 {
-	if (hw->api_maj_ver == ICE_FW_API_LINK_OVERRIDE_MAJ) {
-		if (hw->api_min_ver > ICE_FW_API_LINK_OVERRIDE_MIN)
+	if (hw->api_maj_ver == maj) {
+		if (hw->api_min_ver > min)
 			return true;
-		if (hw->api_min_ver == ICE_FW_API_LINK_OVERRIDE_MIN &&
-		    hw->api_patch >= ICE_FW_API_LINK_OVERRIDE_PATCH)
+		if (hw->api_min_ver == min && hw->api_patch >= patch)
 			return true;
-	} else if (hw->api_maj_ver > ICE_FW_API_LINK_OVERRIDE_MAJ) {
+	} else if (hw->api_maj_ver > maj) {
 		return true;
 	}
 
 	return false;
 }
 
+/**
+ * ice_fw_supports_link_override
+ * @hw: pointer to the hardware structure
+ *
+ * Checks if the firmware supports link override
+ */
+bool ice_fw_supports_link_override(struct ice_hw *hw)
+{
+	return ice_is_fw_api_min_ver(hw, ICE_FW_API_LINK_OVERRIDE_MAJ,
+				     ICE_FW_API_LINK_OVERRIDE_MIN,
+				     ICE_FW_API_LINK_OVERRIDE_PATCH);
+}
+
 /**
  * ice_get_link_default_override
  * @ldo: pointer to the link default override struct
@@ -5436,16 +5451,9 @@ bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw)
 	if (hw->mac_type != ICE_MAC_E810)
 		return false;
 
-	if (hw->api_maj_ver == ICE_FW_API_LLDP_FLTR_MAJ) {
-		if (hw->api_min_ver > ICE_FW_API_LLDP_FLTR_MIN)
-			return true;
-		if (hw->api_min_ver == ICE_FW_API_LLDP_FLTR_MIN &&
-		    hw->api_patch >= ICE_FW_API_LLDP_FLTR_PATCH)
-			return true;
-	} else if (hw->api_maj_ver > ICE_FW_API_LLDP_FLTR_MAJ) {
-		return true;
-	}
-	return false;
+	return ice_is_fw_api_min_ver(hw, ICE_FW_API_LLDP_FLTR_MAJ,
+				     ICE_FW_API_LLDP_FLTR_MIN,
+				     ICE_FW_API_LLDP_FLTR_PATCH);
 }
 
 /**
@@ -5482,14 +5490,7 @@ ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add)
  */
 bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
 {
-	if (hw->api_maj_ver == ICE_FW_API_REPORT_DFLT_CFG_MAJ) {
-		if (hw->api_min_ver > ICE_FW_API_REPORT_DFLT_CFG_MIN)
-			return true;
-		if (hw->api_min_ver == ICE_FW_API_REPORT_DFLT_CFG_MIN &&
-		    hw->api_patch >= ICE_FW_API_REPORT_DFLT_CFG_PATCH)
-			return true;
-	} else if (hw->api_maj_ver > ICE_FW_API_REPORT_DFLT_CFG_MAJ) {
-		return true;
-	}
-	return false;
+	return ice_is_fw_api_min_ver(hw, ICE_FW_API_REPORT_DFLT_CFG_MAJ,
+				     ICE_FW_API_REPORT_DFLT_CFG_MIN,
+				     ICE_FW_API_REPORT_DFLT_CFG_PATCH);
 }
-- 
2.35.1


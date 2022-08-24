Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030A25A0003
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbiHXRD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239763AbiHXRDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:03:52 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4713F335
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 10:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661360632; x=1692896632;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yBrY2EaxOLBldru5T5FhLqzoNLAyTm5L598d6C5EtSk=;
  b=WvycKjKReFhDHImy8M4UlRa9uqi7DsAoV2LE6GqZUnh6eV+/lny/WX3Q
   UOA7j21Ck7oadCAJvh3cdCUj2xf0m8mPddQhB0f+ifp+W1LF3Eyh0EC3c
   gGqdrRRKDA4TN5R7D8ggFB8AxvCLbBzShKZqgrotiLUVMAbI3YCTdQiVJ
   gahrjr38GphSOUSKjQeULAzU9MPzRX7s1L5PT7CDb6B0wvPNIxVg1UgKT
   u1yeghhsslSsfwPciWv0ko1Pb7CvYbKqmeTSXYu5lw+yF8nVQL4Q5z5yy
   55u4UdfOWjfefHwuGkGfqwVTtloxF5j5KyD9MVbcLFUGYZv5hMtTLkyJk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="280995450"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="280995450"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:03:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="937989114"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 24 Aug 2022 10:03:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/5] ice: Add additional flags to ice_nvm_write_activate
Date:   Wed, 24 Aug 2022 10:03:38 -0700
Message-Id: <20220824170340.207131-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
References: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_nvm_write_activate function is used to issue AdminQ command
0x0707 which sends a request to firmware to activate a flash bank. For
basic operations, this command takes an 8bit flag value which defines
the flags to control the activation process. There are some additional
flags that are stored in a second 8bit flag field.

We can simplify the interface by using a u16 cmd_flags variable. Split
this over the two bytes of flag storage in the structure.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |  6 ++++++
 drivers/net/ethernet/intel/ice/ice_nvm.c        | 13 +++++++++----
 drivers/net/ethernet/intel/ice/ice_nvm.h        |  2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index d3f8b4d1c70a..1bdc70aa979d 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1539,6 +1539,12 @@ struct ice_aqc_nvm {
 #define ICE_AQC_NVM_PERST_FLAG		1
 #define ICE_AQC_NVM_EMPR_FLAG		2
 #define ICE_AQC_NVM_EMPR_ENA		BIT(0) /* Write Activate reply only */
+	/* For Write Activate, several flags are sent as part of a separate
+	 * flags2 field using a separate byte. For simplicity of the software
+	 * interface, we pass the flags as a 16 bit value so these flags are
+	 * all offset by 8 bits
+	 */
+#define ICE_AQC_NVM_ACTIV_REQ_EMPR	BIT(8) /* NVM Write Activate only */
 	__le16 module_typeid;
 	__le16 length;
 #define ICE_AQC_NVM_ERASE_LEN	0xFFFF
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 13cdb5ea594d..c262dc886e6a 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -1114,14 +1114,18 @@ int ice_nvm_validate_checksum(struct ice_hw *hw)
  * Update the control word with the required banks' validity bits
  * and dumps the Shadow RAM to flash (0x0707)
  *
- * cmd_flags controls which banks to activate, and the preservation level to
- * use when activating the NVM bank.
+ * cmd_flags controls which banks to activate, the preservation level to use
+ * when activating the NVM bank, and whether an EMP reset is required for
+ * activation.
+ *
+ * Note that the 16bit cmd_flags value is split between two separate 1 byte
+ * flag values in the descriptor.
  *
  * On successful return of the firmware command, the response_flags variable
  * is updated with the flags reported by firmware indicating certain status,
  * such as whether EMP reset is enabled.
  */
-int ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags, u8 *response_flags)
+int ice_nvm_write_activate(struct ice_hw *hw, u16 cmd_flags, u8 *response_flags)
 {
 	struct ice_aqc_nvm *cmd;
 	struct ice_aq_desc desc;
@@ -1130,7 +1134,8 @@ int ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags, u8 *response_flags)
 	cmd = &desc.params.nvm;
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_write_activate);
 
-	cmd->cmd_flags = cmd_flags;
+	cmd->cmd_flags = (u8)(cmd_flags & 0xFF);
+	cmd->offset_high = (u8)((cmd_flags >> 8) & 0xFF);
 
 	err = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
 	if (!err && response_flags)
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index 856d1ad4398b..774c2317967d 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -34,7 +34,7 @@ ice_aq_update_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset,
 int
 ice_aq_erase_nvm(struct ice_hw *hw, u16 module_typeid, struct ice_sq_cd *cd);
 int ice_nvm_validate_checksum(struct ice_hw *hw);
-int ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags, u8 *response_flags);
+int ice_nvm_write_activate(struct ice_hw *hw, u16 cmd_flags, u8 *response_flags);
 int ice_aq_nvm_update_empr(struct ice_hw *hw);
 int
 ice_nvm_set_pkg_data(struct ice_hw *hw, bool del_pkg_data_flag, u8 *data,
-- 
2.35.1


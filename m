Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B722E57D4CA
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiGUUbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiGUUbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:31:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C7CB1EA
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 13:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658435508; x=1689971508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tvmvJXlVsXUw/Nvu5NHM1iHsP9EMoVgUTslEgSRRY6k=;
  b=B8xaU9HvWcpWjrHosQUQgokiCumgY8DUZeulSRNpUDkt1mQZnLiH7p4V
   xMIzJ1SGU05gol3IK5od80Feil6XouVmI2GJO3jDdTED5Byxs4GdFYNJL
   aMAPRWrzMAbq/i3PVHtgDinuiAp20m/VsfEAKwU88rd5mAB73Kf5fIqSH
   UH0tgdOTPJiPcj9FxJOBVwGLwSZlO6+OgGf7o/IJfh2myRhaidT3uDwxK
   GLuWX7BB1rSspaGzG0Tz3ppzRyvwVB2Qa0XXwCfQKiUza1ycqA5LXjiWc
   O6veaxS6UgbIxrmZDDeBe1RUDmOeZcYu/yItl8EKZORnYisXC4vhe8bfS
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="266941694"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="266941694"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 13:31:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="666432314"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jul 2022 13:31:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 1/2] ice: add i2c write command
Date:   Thu, 21 Jul 2022 13:28:41 -0700
Message-Id: <20220721202842.3276257-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220721202842.3276257-1-anthony.l.nguyen@intel.com>
References: <20220721202842.3276257-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

Add the possibility to write to connected i2c devices using the AQ
command. FW may reject the write if the device is not on allowlist.

Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  7 +--
 drivers/net/ethernet/intel/ice/ice_common.c   | 47 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |  4 ++
 3 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 05cb9dd7035a..9939238573a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1395,7 +1395,7 @@ struct ice_aqc_get_link_topo {
 	u8 rsvd[9];
 };
 
-/* Read I2C (direct, 0x06E2) */
+/* Read/Write I2C (direct, 0x06E2/0x06E3) */
 struct ice_aqc_i2c {
 	struct ice_aqc_link_topo_addr topo_addr;
 	__le16 i2c_addr;
@@ -1405,7 +1405,7 @@ struct ice_aqc_i2c {
 
 	u8 rsvd;
 	__le16 i2c_bus_addr;
-	u8 rsvd2[4];
+	u8 i2c_data[4]; /* Used only by write command, reserved in read. */
 };
 
 /* Read I2C Response (direct, 0x06E2) */
@@ -2124,7 +2124,7 @@ struct ice_aq_desc {
 		struct ice_aqc_get_link_status get_link_status;
 		struct ice_aqc_event_lan_overflow lan_overflow;
 		struct ice_aqc_get_link_topo get_link_topo;
-		struct ice_aqc_i2c read_i2c;
+		struct ice_aqc_i2c read_write_i2c;
 		struct ice_aqc_read_i2c_resp read_i2c_resp;
 	} params;
 };
@@ -2241,6 +2241,7 @@ enum ice_adminq_opc {
 	ice_aqc_opc_set_mac_lb				= 0x0620,
 	ice_aqc_opc_get_link_topo			= 0x06E0,
 	ice_aqc_opc_read_i2c				= 0x06E2,
+	ice_aqc_opc_write_i2c				= 0x06E3,
 	ice_aqc_opc_set_port_id_led			= 0x06E9,
 	ice_aqc_opc_set_gpio				= 0x06EC,
 	ice_aqc_opc_get_gpio				= 0x06ED,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 9619bdb9e49a..27d0cbbd29da 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4823,7 +4823,7 @@ ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
 	int status;
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_read_i2c);
-	cmd = &desc.params.read_i2c;
+	cmd = &desc.params.read_write_i2c;
 
 	if (!data)
 		return -EINVAL;
@@ -4850,6 +4850,51 @@ ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
 	return status;
 }
 
+/**
+ * ice_aq_write_i2c
+ * @hw: pointer to the hw struct
+ * @topo_addr: topology address for a device to communicate with
+ * @bus_addr: 7-bit I2C bus address
+ * @addr: I2C memory address (I2C offset) with up to 16 bits
+ * @params: I2C parameters: bit [4] - I2C address type, bits [3:0] - data size to write (0-7 bytes)
+ * @data: pointer to data (0 to 4 bytes) to be written to the I2C device
+ * @cd: pointer to command details structure or NULL
+ *
+ * Write I2C (0x06E3)
+ *
+ * * Return:
+ * * 0             - Successful write to the i2c device
+ * * -EINVAL       - Data size greater than 4 bytes
+ * * -EIO          - FW error
+ */
+int
+ice_aq_write_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
+		 u16 bus_addr, __le16 addr, u8 params, u8 *data,
+		 struct ice_sq_cd *cd)
+{
+	struct ice_aq_desc desc = { 0 };
+	struct ice_aqc_i2c *cmd;
+	u8 data_size;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_write_i2c);
+	cmd = &desc.params.read_write_i2c;
+
+	data_size = FIELD_GET(ICE_AQC_I2C_DATA_SIZE_M, params);
+
+	/* data_size limited to 4 */
+	if (data_size > 4)
+		return -EINVAL;
+
+	cmd->i2c_bus_addr = cpu_to_le16(bus_addr);
+	cmd->topo_addr = topo_addr;
+	cmd->i2c_params = params;
+	cmd->i2c_addr = addr;
+
+	memcpy(cmd->i2c_data, data, data_size);
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+}
+
 /**
  * ice_aq_set_driver_param - Set driver parameter to share via firmware
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 872ea7d2332d..61b7c60db689 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -214,5 +214,9 @@ int
 ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
 		u16 bus_addr, __le16 addr, u8 params, u8 *data,
 		struct ice_sq_cd *cd);
+int
+ice_aq_write_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
+		 u16 bus_addr, __le16 addr, u8 params, u8 *data,
+		 struct ice_sq_cd *cd);
 bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw);
 #endif /* _ICE_COMMON_H_ */
-- 
2.35.1


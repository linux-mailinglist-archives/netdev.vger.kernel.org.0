Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6DC2E4BB
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfE2Sr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:47:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:64223 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbfE2Srs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dan Nowlin <dan.nowlin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] ice: Add ice_get_fw_log_cfg to init FW logging
Date:   Wed, 29 May 2019 11:47:52 -0700
Message-Id: <20190529184754.12693-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Nowlin <dan.nowlin@intel.com>

In order to initialize the current status of the FW logging,
this patch adds ice_get_fw_log_cfg. The function retrieves
the current setting of the FW logging from HW and updates the
ice_hw structure accordingly.

Signed-off-by: Dan Nowlin <dan.nowlin@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c   | 48 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 99eeee930dfa..8680ee2ffa1b 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1694,6 +1694,7 @@ enum ice_adminq_opc {
 
 	/* debug commands */
 	ice_aqc_opc_fw_logging				= 0xFF09,
+	ice_aqc_opc_fw_logging_info			= 0xFF10,
 };
 
 #endif /* _ICE_ADMINQ_CMD_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index a377d5b3da34..16c694a1b076 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -472,6 +472,49 @@ static void ice_cleanup_fltr_mgmt_struct(struct ice_hw *hw)
 #define ICE_FW_LOG_DESC_SIZE_MAX	\
 	ICE_FW_LOG_DESC_SIZE(ICE_AQC_FW_LOG_ID_MAX)
 
+/**
+ * ice_get_fw_log_cfg - get FW logging configuration
+ * @hw: pointer to the HW struct
+ */
+static enum ice_status ice_get_fw_log_cfg(struct ice_hw *hw)
+{
+	struct ice_aqc_fw_logging_data *config;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+	u16 size;
+
+	size = ICE_FW_LOG_DESC_SIZE_MAX;
+	config = devm_kzalloc(ice_hw_to_dev(hw), size, GFP_KERNEL);
+	if (!config)
+		return ICE_ERR_NO_MEMORY;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_fw_logging_info);
+
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_BUF);
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	status = ice_aq_send_cmd(hw, &desc, config, size, NULL);
+	if (!status) {
+		u16 i;
+
+		/* Save fw logging information into the hw structure */
+		for (i = 0; i < ICE_AQC_FW_LOG_ID_MAX; i++) {
+			u16 v, m, flgs;
+
+			v = le16_to_cpu(config->entry[i]);
+			m = (v & ICE_AQC_FW_LOG_ID_M) >> ICE_AQC_FW_LOG_ID_S;
+			flgs = (v & ICE_AQC_FW_LOG_EN_M) >> ICE_AQC_FW_LOG_EN_S;
+
+			if (m < ICE_AQC_FW_LOG_ID_MAX)
+				hw->fw_log.evnts[m].cur = flgs;
+		}
+	}
+
+	devm_kfree(ice_hw_to_dev(hw), config);
+
+	return status;
+}
+
 /**
  * ice_cfg_fw_log - configure FW logging
  * @hw: pointer to the HW struct
@@ -526,6 +569,11 @@ static enum ice_status ice_cfg_fw_log(struct ice_hw *hw, bool enable)
 	    (!hw->fw_log.actv_evnts || !ice_check_sq_alive(hw, &hw->adminq)))
 		return 0;
 
+	/* Get current FW log settings */
+	status = ice_get_fw_log_cfg(hw);
+	if (status)
+		return status;
+
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_fw_logging);
 	cmd = &desc.params.fw_logging;
 
-- 
2.21.0


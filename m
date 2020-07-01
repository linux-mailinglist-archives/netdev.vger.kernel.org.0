Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EB92116D8
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgGAXxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:53:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:5613 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbgGAXxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 19:53:32 -0400
IronPort-SDR: SFm+FdDwE1M03StEwXu217RyllyzvE5Zpp/jV9AVpQREJO4VPQSpPLUm3p/eQ73AkJp0JgmsNF
 J44hEqmF9ITg==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126365940"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="126365940"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 16:53:31 -0700
IronPort-SDR: uyg/jqxl3kCxmmWATlJmAQzlVE/y7CUQNMwemtmBNPm7eJiIVvnokREKFi+4K0zcH0CAh6r7X8
 uDmP9OuBlFsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="481785440"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jul 2020 16:53:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 1/3] ice: implement snapshot for device capabilities
Date:   Wed,  1 Jul 2020 16:53:24 -0700
Message-Id: <20200701235326.3176037-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701235326.3176037-1-anthony.l.nguyen@intel.com>
References: <20200701235326.3176037-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Add a new devlink region used for capturing a snapshot of the device
capabilities buffer which is reported by the firmware over the AdminQ.
This information can useful in debugging driver and firmware
interactions.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c  | 64 ++++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_common.h  |  3 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 59 ++++++++++++++++++
 4 files changed, 114 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index a4cda8212e64..7486d010a619 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -373,6 +373,7 @@ struct ice_pf {
 	struct devlink_port devlink_port;
 
 	struct devlink_region *nvm_region;
+	struct devlink_region *devcaps_region;
 
 	/* OS reserved IRQ details */
 	struct msix_entry *msix_entries;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index bce0e1281168..e3cb7bd1ecab 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1823,20 +1823,27 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 }
 
 /**
- * ice_aq_discover_caps - query function/device capabilities
+ * ice_aq_list_caps - query function/device capabilities
  * @hw: pointer to the HW struct
- * @buf: a virtual buffer to hold the capabilities
- * @buf_size: Size of the virtual buffer
- * @cap_count: cap count needed if AQ err==ENOMEM
- * @opc: capabilities type to discover - pass in the command opcode
+ * @buf: a buffer to hold the capabilities
+ * @buf_size: size of the buffer
+ * @cap_count: if not NULL, set to the number of capabilities reported
+ * @opc: capabilities type to discover, device or function
  * @cd: pointer to command details structure or NULL
  *
- * Get the function(0x000a)/device(0x000b) capabilities description from
- * the firmware.
+ * Get the function (0x000A) or device (0x000B) capabilities description from
+ * firmware and store it in the buffer.
+ *
+ * If the cap_count pointer is not NULL, then it is set to the number of
+ * capabilities firmware will report. Note that if the buffer size is too
+ * small, it is possible the command will return ICE_AQ_ERR_ENOMEM. The
+ * cap_count will still be updated in this case. It is recommended that the
+ * buffer size be set to ICE_AQ_MAX_BUF_LEN (the largest possible buffer that
+ * firmware could return) to avoid this.
  */
-static enum ice_status
-ice_aq_discover_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
-		     enum ice_adminq_opc opc, struct ice_sq_cd *cd)
+enum ice_status
+ice_aq_list_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
+		 enum ice_adminq_opc opc, struct ice_sq_cd *cd)
 {
 	struct ice_aqc_list_caps *cmd;
 	struct ice_aq_desc desc;
@@ -1849,12 +1856,43 @@ ice_aq_discover_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
 		return ICE_ERR_PARAM;
 
 	ice_fill_dflt_direct_cmd_desc(&desc, opc);
-
 	status = ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
+
+	if (cap_count)
+		*cap_count = le32_to_cpu(cmd->count);
+
+	return status;
+}
+
+/**
+ * ice_aq_discover_caps - query function/device capabilities
+ * @hw: pointer to the HW struct
+ * @buf: a virtual buffer to hold the capabilities
+ * @buf_size: Size of the virtual buffer
+ * @cap_count: cap count needed if AQ err==ENOMEM
+ * @opc: capabilities type to discover - pass in the command opcode
+ * @cd: pointer to command details structure or NULL
+ *
+ * Get the function(0x000a)/device(0x000b) capabilities description from
+ * the firmware.
+ *
+ * NOTE: this function has the side effect of updating the hw->dev_caps or
+ * hw->func_caps by way of calling ice_parse_caps.
+ */
+static enum ice_status
+ice_aq_discover_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
+		     enum ice_adminq_opc opc, struct ice_sq_cd *cd)
+{
+	u32 local_cap_count = 0;
+	enum ice_status status;
+
+	status = ice_aq_list_caps(hw, buf, buf_size, &local_cap_count,
+				  opc, cd);
 	if (!status)
-		ice_parse_caps(hw, buf, le32_to_cpu(cmd->count), opc);
+		ice_parse_caps(hw, buf, local_cap_count, opc);
 	else if (hw->adminq.sq_last_status == ICE_AQ_RC_ENOMEM)
-		*cap_count = le32_to_cpu(cmd->count);
+		*cap_count = local_cap_count;
+
 	return status;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 9b9e50d2398b..e72529e9f022 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -87,6 +87,9 @@ enum ice_status
 ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 		    struct ice_aqc_get_phy_caps_data *caps,
 		    struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_list_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
+		 enum ice_adminq_opc opc, struct ice_sq_cd *cd);
 void
 ice_update_phy_type(u64 *phy_type_low, u64 *phy_type_high,
 		    u16 link_speeds_bitmap);
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index a73d06e06b5d..3ea470e8cfa2 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -397,12 +397,60 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 	return 0;
 }
 
+/**
+ * ice_devlink_devcaps_snapshot - Capture snapshot of device capabilities
+ * @devlink: the devlink instance
+ * @extack: extended ACK response structure
+ * @data: on exit points to snapshot data buffer
+ *
+ * This function is called in response to the DEVLINK_CMD_REGION_TRIGGER for
+ * the device-caps devlink region. It captures a snapshot of the device
+ * capabilities reported by firmware.
+ *
+ * @returns zero on success, and updates the data pointer. Returns a non-zero
+ * error code on failure.
+ */
+static int
+ice_devlink_devcaps_snapshot(struct devlink *devlink,
+			     struct netlink_ext_ack *extack, u8 **data)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	void *devcaps;
+
+	devcaps = vzalloc(ICE_AQ_MAX_BUF_LEN);
+	if (!devcaps)
+		return -ENOMEM;
+
+	status = ice_aq_list_caps(hw, devcaps, ICE_AQ_MAX_BUF_LEN, NULL,
+				  ice_aqc_opc_list_dev_caps, NULL);
+	if (status) {
+		dev_dbg(dev, "ice_aq_list_caps: failed to read device capabilities, err %d aq_err %d\n",
+			status, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to read device capabilities");
+		vfree(devcaps);
+		return -EIO;
+	}
+
+	*data = (u8 *)devcaps;
+
+	return 0;
+}
+
 static const struct devlink_region_ops ice_nvm_region_ops = {
 	.name = "nvm-flash",
 	.destructor = vfree,
 	.snapshot = ice_devlink_nvm_snapshot,
 };
 
+static const struct devlink_region_ops ice_devcaps_region_ops = {
+	.name = "device-caps",
+	.destructor = vfree,
+	.snapshot = ice_devlink_devcaps_snapshot,
+};
+
 /**
  * ice_devlink_init_regions - Initialize devlink regions
  * @pf: the PF device structure
@@ -424,6 +472,15 @@ void ice_devlink_init_regions(struct ice_pf *pf)
 			PTR_ERR(pf->nvm_region));
 		pf->nvm_region = NULL;
 	}
+
+	pf->devcaps_region = devlink_region_create(devlink,
+						   &ice_devcaps_region_ops, 10,
+						   ICE_AQ_MAX_BUF_LEN);
+	if (IS_ERR(pf->devcaps_region)) {
+		dev_err(dev, "failed to create device-caps devlink region, err %ld\n",
+			PTR_ERR(pf->devcaps_region));
+		pf->devcaps_region = NULL;
+	}
 }
 
 /**
@@ -436,4 +493,6 @@ void ice_devlink_destroy_regions(struct ice_pf *pf)
 {
 	if (pf->nvm_region)
 		devlink_region_destroy(pf->nvm_region);
+	if (pf->devcaps_region)
+		devlink_region_destroy(pf->devcaps_region);
 }
-- 
2.26.2


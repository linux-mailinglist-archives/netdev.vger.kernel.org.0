Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7BD62E7CD
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241199AbiKQWJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241189AbiKQWIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:08:48 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAA885EC3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668722904; x=1700258904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BTa6S1ik9ju7LAoD1tElqfENbs9d/yo/vtB90y51WIs=;
  b=CzkRBC7T1yD2cTu++2vXW/FmkE+fE+uVjGQe9KPAnhiETsIw0N8/cOTh
   tP7mKCl5pgN18RwITI3woD+wwPdDBoPG106xHI91QdW8Fjo7aSe2lSmkJ
   5SDn4I0iHofDfMj6VDfyIurDuFDmD77F6rlOeSk3DUBkvlXRWWnSajWS3
   Axb+BBEPkmKXSXGjbLJ/U7JHyMExyIn0I7rIiIdd9fZUdVs0A7BGbowtY
   uVX3SrMHQNfzZdLaVN+k+sdjpVRShd0jWNJEJx5UhAmntW+Q1gCXVlj6E
   AcZiGoG2OQgF3FGJAoUiV5EutbYbaeiebGHl4VJwL0Vn+mOFInwrxC6TK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="313001222"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="313001222"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="672975639"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="672975639"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:12 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 8/8] ice: implement direct read for NVM and Shadow RAM regions
Date:   Thu, 17 Nov 2022 14:08:03 -0800
Message-Id: <20221117220803.2773887-9-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221117220803.2773887-1-jacob.e.keller@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the .read handler for the NVM and Shadow RAM regions. This
enables user space to read a small chunk of the flash without needing the
overhead of creating a full snapshot.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 69 ++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 82680417b02e..8aec2f5fdf4a 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1185,6 +1185,73 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 	return 0;
 }
 
+/**
+ * ice_devlink_nvm_read - Read a portion of NVM flash contents
+ * @devlink: the devlink instance
+ * @ops: the devlink region to snapshot
+ * @extack: extended ACK response structure
+ * @offset: the offset to start at
+ * @size: the amount to read
+ * @data: the data buffer to read into
+ *
+ * This function is called in response to DEVLINK_CMD_REGION_READ to directly
+ * read a section of the NVM contents.
+ *
+ * It reads from either the nvm-flash or shadow-ram region contents.
+ *
+ * @returns zero on success, and updates the data pointer. Returns a non-zero
+ * error code on failure.
+ */
+static int ice_devlink_nvm_read(struct devlink *devlink,
+				const struct devlink_region_ops *ops,
+				struct netlink_ext_ack *extack,
+				u64 offset, u32 size, u8 *data)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	bool read_shadow_ram;
+	u64 nvm_size;
+	int status;
+
+	if (ops == &ice_nvm_region_ops) {
+		read_shadow_ram = false;
+		nvm_size = hw->flash.flash_size;
+	} else if (ops == &ice_sram_region_ops) {
+		read_shadow_ram = true;
+		nvm_size = hw->flash.sr_words * 2u;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unexpected region in snapshot function");
+		return -EOPNOTSUPP;
+	}
+
+	if (offset + size >= nvm_size) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot read beyond the region size");
+		return -ERANGE;
+	}
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status) {
+		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
+			status, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
+		return -EIO;
+	}
+
+	status = ice_read_flat_nvm(hw, (u32)offset, &size, data,
+				   read_shadow_ram);
+	if (status) {
+		dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
+			size, status, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to read NVM contents");
+		ice_release_nvm(hw);
+		return -EIO;
+	}
+	ice_release_nvm(hw);
+
+	return 0;
+}
+
 /**
  * ice_devlink_devcaps_snapshot - Capture snapshot of device capabilities
  * @devlink: the devlink instance
@@ -1233,12 +1300,14 @@ static const struct devlink_region_ops ice_nvm_region_ops = {
 	.name = "nvm-flash",
 	.destructor = vfree,
 	.snapshot = ice_devlink_nvm_snapshot,
+	.read = ice_devlink_nvm_read,
 };
 
 static const struct devlink_region_ops ice_sram_region_ops = {
 	.name = "shadow-ram",
 	.destructor = vfree,
 	.snapshot = ice_devlink_nvm_snapshot,
+	.read = ice_devlink_nvm_read,
 };
 
 static const struct devlink_region_ops ice_devcaps_region_ops = {
-- 
2.38.1.420.g319605f8f00e


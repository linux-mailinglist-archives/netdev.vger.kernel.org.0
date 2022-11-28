Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A8C63B362
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiK1UhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiK1UhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:37:05 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCDC2BB36
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669667824; x=1701203824;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lduvdUvH4AK2EBGQKfUCA76Ce0Pf6SemqNSsOX4ZLL4=;
  b=M85pU2S4iLtiaEvktQZpcmhmGlHVpJhkqWDdUA5xocywwPLkgeCecIz0
   mItOafEWWxY2xa+6Y0L2J6xONUbPzWeoOb50FwPHFzMn73qW/qdeka10m
   hJzIib2sKlMMF/5nM1BgEH5SVzPxdINx+pfYPBuLpOhwbC9x1ghiYgasH
   +T18wHcDj0vWeEzKsYl6i2b4iDZcEHIJ/msHUWRKBK0dn93xDwZdznPx8
   7EHPNLBGZYGh/QHhKVEgAMN/5IpdFF+YFccu2AX8Hm+82fXXd3q4Ovl/R
   Yut6j3bobZK7mTN4y1mm715T8o11EKhUyd4X6JGQnIzRxAPnAoF//Avb+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379205402"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379205402"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732286366"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732286366"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:59 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 9/9] ice: implement direct read for NVM and Shadow RAM regions
Date:   Mon, 28 Nov 2022 12:36:47 -0800
Message-Id: <20221128203647.1198669-10-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221128203647.1198669-1-jacob.e.keller@intel.com>
References: <20221128203647.1198669-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the .read handler for the NVM and Shadow RAM regions. This
enables user space to read a small chunk of the flash without needing the
overhead of creating a full snapshot.

Update the documentation for ice to detail which regions have direct read
support.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
No changes since v2.

 Documentation/networking/devlink/ice.rst     |  8 ++-
 drivers/net/ethernet/intel/ice/ice_devlink.c | 69 ++++++++++++++++++++
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index bcd4839fbf79..625efb3777d5 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -198,8 +198,12 @@ device data.
       - The contents of the device firmware's capabilities buffer. Useful to
         determine the current state and configuration of the device.
 
-Users can request an immediate capture of a snapshot via the
-``DEVLINK_CMD_REGION_NEW``
+Both the ``nvm-flash`` and ``shadow-ram`` regions can be accessed without a
+snapshot. The ``device-caps`` region requires a snapshot as the contents are
+sent by firmware and can't be split into separate reads.
+
+Users can request an immediate capture of a snapshot for all three regions
+via the ``DEVLINK_CMD_REGION_NEW`` command.
 
 .. code:: shell
 
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 9d3500291d2e..946d64e577c9 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1687,6 +1687,73 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
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
@@ -1735,12 +1802,14 @@ static const struct devlink_region_ops ice_nvm_region_ops = {
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


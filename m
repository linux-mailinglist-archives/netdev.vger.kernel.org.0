Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A4C14E5C7
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgA3W7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:51507 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbgA3W70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187827"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:24 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 14/15] ice: support direct read of the shadow ram region
Date:   Thu, 30 Jan 2020 14:59:09 -0800
Message-Id: <20200130225913.1671982-15-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the new .read region operation, implement support for directly
reading from the Shadow RAM region without a snapshot. This is useful
when the atomic guarantees provided by a snapshot aren't necessary and
userspace only wants to read a small portion of the region.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 48 ++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 9f6a0281fd6e..7bad237177a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -224,6 +224,53 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
 	devlink_port_unregister(&pf->devlink_port);
 }
 
+/**
+ * ice_devlink_sr_read - Read a portion of the shadow RAM
+ * @devlink: the devlink instance
+ * @curr_offset: offset to start at
+ * @data_size: portion of the region to read
+ * @data: buffer to store region contents
+ *
+ * This function is called to directly read from the shadow-ram region in
+ * response to a DEVLINK_CMD_REGION_READ without a snapshot id.
+ *
+ * @returns zero on success and updates the contents of the data region,
+ * otherwise returns a non-zero error code on failure.
+ */
+static int ice_devlink_sr_read(struct devlink *devlink, u64 curr_offset,
+			  u32 data_size, u8 *data)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+
+	if (!ice_is_primary_function(pf))
+		return -EACCES;
+
+	if (curr_offset + data_size > hw->nvm.sr_words * sizeof(u16))
+		return -ERANGE;
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status) {
+		dev_err(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
+			status, hw->adminq.sq_last_status);
+		return -EIO;
+	}
+
+	status = ice_read_flat_nvm(hw, curr_offset, &data_size, data, true);
+	if (status) {
+		dev_err(dev, "ice_read_flat_nvm failed, err %d aq_err %d\n",
+			status, hw->adminq.sq_last_status);
+		ice_release_nvm(hw);
+		return -EIO;
+	}
+
+	ice_release_nvm(hw);
+
+	return 0;
+}
+
 /**
  * ice_devlink_sr_snapshot - Capture a snapshot of the Shadow RAM contents
  * @devlink: the devlink instance
@@ -290,6 +337,7 @@ static int ice_devlink_sr_snapshot(struct devlink *devlink,
 static const struct devlink_region_ops ice_sr_region_ops = {
 	.name = "shadow-ram",
 	.snapshot = ice_devlink_sr_snapshot,
+	.read = ice_devlink_sr_read,
 };
 
 /**
-- 
2.25.0.rc1


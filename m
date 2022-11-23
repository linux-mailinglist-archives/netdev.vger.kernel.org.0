Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033EC636B5D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiKWUjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240335AbiKWUip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:38:45 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816A6B65
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669235924; x=1700771924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YWzCDXn9m33Td7ppVsC+YuP/LVBYEK5YMHHcE1j+38Q=;
  b=V7r+yyPesY97fe4XTaG3pu9QOJw1/k/+Myb6oKhVbTjbgPX5b2r6DC8P
   a5aEKN2ET7t0qnvxBGvlY+BmU7otvdkLmBrEcZR5HJz9Oy8Cc3M7VPSYT
   +tTCtUgIfwtChmTCZDl4tuVMnX8zkF3vXMZfR2SlRx3aPUaosCjA4atuV
   WMVJQG1sGGLYQclEvpZK69J53P3y0JanHi1PV6uYHwp9xY8l3enQ6i5O4
   uyHzAK/VXUtrcL/ebIm3g1OxrNvwprPonF24Mb6bxcaSPt2sD0XHOJeiY
   Vq9SH+zBt879+73LxIuxvmrnvb1ELxsvb496UpPFjc1km+uC2R63hzsuO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315307135"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315307135"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619756062"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619756062"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 7/9] ice: use same function to snapshot both NVM and Shadow RAM
Date:   Wed, 23 Nov 2022 12:38:32 -0800
Message-Id: <20221123203834.738606-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221123203834.738606-1-jacob.e.keller@intel.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ice driver supports a region for both the flat NVM contents as well as
the Shadow RAM which is a layer built on top of the flash during device
initialization.

These regions use an almost identical read function, except that the NVM
needs to set the direct flag when reading, while Shadow RAM needs to read
without the direct flag set. They each call ice_read_flat_nvm with the only
difference being whether to set the direct flash flag.

The NVM region read function also was fixed to read the NVM in blocks to
avoid a situation where the firmware reclaims the lock due to taking too
long.

Note that the region snapshot function takes the ops pointer so the
function can easily determine which region to read. Make use of this and
re-use the NVM snapshot function for both the NVM and Shadow RAM regions.
This makes Shadow RAM benefit from the same block approach as the NVM
region. It also reduces code in the ice driver.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
No changes since v1.

 drivers/net/ethernet/intel/ice/ice_devlink.c | 95 +++++---------------
 1 file changed, 23 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 1d638216484d..9d3500291d2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1596,21 +1596,22 @@ void ice_devlink_destroy_vf_port(struct ice_vf *vf)
 
 #define ICE_DEVLINK_READ_BLK_SIZE (1024 * 1024)
 
+static const struct devlink_region_ops ice_nvm_region_ops;
+static const struct devlink_region_ops ice_sram_region_ops;
+
 /**
  * ice_devlink_nvm_snapshot - Capture a snapshot of the NVM flash contents
  * @devlink: the devlink instance
- * @ops: the devlink region being snapshotted
+ * @ops: the devlink region to snapshot
  * @extack: extended ACK response structure
  * @data: on exit points to snapshot data buffer
  *
- * This function is called in response to the DEVLINK_CMD_REGION_TRIGGER for
- * the nvm-flash devlink region. It captures a snapshot of the full NVM flash
- * contents, including both banks of flash. This snapshot can later be viewed
- * via the devlink-region interface.
+ * This function is called in response to a DEVLINK_CMD_REGION_NEW for either
+ * the nvm-flash or shadow-ram region.
  *
- * It captures the flash using the FLASH_ONLY bit set when reading via
- * firmware, so it does not read the current Shadow RAM contents. For that,
- * use the shadow-ram region.
+ * It captures a snapshot of the NVM or Shadow RAM flash contents. This
+ * snapshot can then later be viewed via the DEVLINK_CMD_REGION_READ netlink
+ * interface.
  *
  * @returns zero on success, and updates the data pointer. Returns a non-zero
  * error code on failure.
@@ -1622,17 +1623,27 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 	struct ice_pf *pf = devlink_priv(devlink);
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
+	bool read_shadow_ram;
 	u8 *nvm_data, *tmp, i;
 	u32 nvm_size, left;
 	s8 num_blks;
 	int status;
 
-	nvm_size = hw->flash.flash_size;
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
 	nvm_data = vzalloc(nvm_size);
 	if (!nvm_data)
 		return -ENOMEM;
 
-
 	num_blks = DIV_ROUND_UP(nvm_size, ICE_DEVLINK_READ_BLK_SIZE);
 	tmp = nvm_data;
 	left = nvm_size;
@@ -1656,7 +1667,7 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 		}
 
 		status = ice_read_flat_nvm(hw, i * ICE_DEVLINK_READ_BLK_SIZE,
-					   &read_sz, tmp, false);
+					   &read_sz, tmp, read_shadow_ram);
 		if (status) {
 			dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
 				read_sz, status, hw->adminq.sq_last_status);
@@ -1676,66 +1687,6 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 	return 0;
 }
 
-/**
- * ice_devlink_sram_snapshot - Capture a snapshot of the Shadow RAM contents
- * @devlink: the devlink instance
- * @ops: the devlink region being snapshotted
- * @extack: extended ACK response structure
- * @data: on exit points to snapshot data buffer
- *
- * This function is called in response to the DEVLINK_CMD_REGION_TRIGGER for
- * the shadow-ram devlink region. It captures a snapshot of the shadow ram
- * contents. This snapshot can later be viewed via the devlink-region
- * interface.
- *
- * @returns zero on success, and updates the data pointer. Returns a non-zero
- * error code on failure.
- */
-static int
-ice_devlink_sram_snapshot(struct devlink *devlink,
-			  const struct devlink_region_ops __always_unused *ops,
-			  struct netlink_ext_ack *extack, u8 **data)
-{
-	struct ice_pf *pf = devlink_priv(devlink);
-	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_hw *hw = &pf->hw;
-	u8 *sram_data;
-	u32 sram_size;
-	int err;
-
-	sram_size = hw->flash.sr_words * 2u;
-	sram_data = vzalloc(sram_size);
-	if (!sram_data)
-		return -ENOMEM;
-
-	err = ice_acquire_nvm(hw, ICE_RES_READ);
-	if (err) {
-		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
-			err, hw->adminq.sq_last_status);
-		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
-		vfree(sram_data);
-		return err;
-	}
-
-	/* Read from the Shadow RAM, rather than directly from NVM */
-	err = ice_read_flat_nvm(hw, 0, &sram_size, sram_data, true);
-	if (err) {
-		dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
-			sram_size, err, hw->adminq.sq_last_status);
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Failed to read Shadow RAM contents");
-		ice_release_nvm(hw);
-		vfree(sram_data);
-		return err;
-	}
-
-	ice_release_nvm(hw);
-
-	*data = sram_data;
-
-	return 0;
-}
-
 /**
  * ice_devlink_devcaps_snapshot - Capture snapshot of device capabilities
  * @devlink: the devlink instance
@@ -1789,7 +1740,7 @@ static const struct devlink_region_ops ice_nvm_region_ops = {
 static const struct devlink_region_ops ice_sram_region_ops = {
 	.name = "shadow-ram",
 	.destructor = vfree,
-	.snapshot = ice_devlink_sram_snapshot,
+	.snapshot = ice_devlink_nvm_snapshot,
 };
 
 static const struct devlink_region_ops ice_devcaps_region_ops = {
-- 
2.38.1.420.g319605f8f00e


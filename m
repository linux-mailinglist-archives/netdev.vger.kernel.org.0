Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5777A47612D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344061AbhLOSze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:55:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:57351 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344058AbhLOSzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:55:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639594512; x=1671130512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hj+IdwCjJKv5r3AMFc4uTrpcyubDde0VACLTCX6CaWU=;
  b=EFSlsXtGrlR22jDR3p5uH1aygulp7UXAI6QcO6Udv8k4VBnOKbWaSdKi
   is3L76i4cYycosvtO8ZhqhuTYeV+Yo3wZTao2HrNPz6z0OV7hhakGAvMk
   wnSf+cYop1uxoCoED30WLT903BFntnr/OtvfvyLBc0cLEG+UWT3fTCDO9
   sPU/edr765HZySVsneqvzIeuXI1btNu7QrmKBECfw9pkWR18npoVYhhLY
   5Mm7FONXKsQ8k9YcSqzTEYaviklLfnfGXM7y8P9mUhZjkobQ3E605hVQ0
   bhlau+1lURt45mhEb0DzDmJRchFXqHGiIJzhi7GSaNOxghGekiRdkhFbM
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239533293"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="239533293"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 10:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465729932"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 10:54:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/9] ice: devlink: add shadow-ram region to snapshot Shadow RAM
Date:   Wed, 15 Dec 2021 10:53:47 -0800
Message-Id: <20211215185355.3249738-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
References: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

We have a region for reading the contents of the NVM flash as
a snapshot. This region does not allow reading the Shadow RAM, as it
always passes the FLASH_ONLY bit to the low level firmware interface.

Add a separate shadow-ram region which will allow snapshot of the
current contents of the Shadow RAM. This data is built from the NVM
contents but is distinct as the device builds up the Shadow RAM during
initialization, so being able to snapshot its contents can be useful
when attempting to debug flash related issues.

Fix the comment description of the nvm-flash region which incorrectly
stated that it filled the shadow-ram region, and add a comment
explaining that the nvm-flash region does not actually read the Shadow
RAM.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  1 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 93 ++++++++++++++++++--
 2 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 6be7bc87f70c..aafe3e443571 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -503,6 +503,7 @@ struct ice_pf {
 	struct pci_dev *pdev;
 
 	struct devlink_region *nvm_region;
+	struct devlink_region *sram_region;
 	struct devlink_region *devcaps_region;
 
 	/* devlink port data */
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 737ee23f5a87..d4173905fcab 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -739,16 +739,20 @@ void ice_devlink_destroy_vf_port(struct ice_vf *vf)
 }
 
 /**
- * ice_devlink_nvm_snapshot - Capture a snapshot of the Shadow RAM contents
+ * ice_devlink_nvm_snapshot - Capture a snapshot of the NVM flash contents
  * @devlink: the devlink instance
  * @ops: the devlink region being snapshotted
  * @extack: extended ACK response structure
  * @data: on exit points to snapshot data buffer
  *
  * This function is called in response to the DEVLINK_CMD_REGION_TRIGGER for
- * the shadow-ram devlink region. It captures a snapshot of the shadow ram
- * contents. This snapshot can later be viewed via the devlink-region
- * interface.
+ * the nvm-flash devlink region. It captures a snapshot of the full NVM flash
+ * contents, including both banks of flash. This snapshot can later be viewed
+ * via the devlink-region interface.
+ *
+ * It captures the flash using the FLASH_ONLY bit set when reading via
+ * firmware, so it does not read the current Shadow RAM contents. For that,
+ * use the shadow-ram region.
  *
  * @returns zero on success, and updates the data pointer. Returns a non-zero
  * error code on failure.
@@ -795,6 +799,66 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 	return 0;
 }
 
+/**
+ * ice_devlink_sram_snapshot - Capture a snapshot of the Shadow RAM contents
+ * @devlink: the devlink instance
+ * @ops: the devlink region being snapshotted
+ * @extack: extended ACK response structure
+ * @data: on exit points to snapshot data buffer
+ *
+ * This function is called in response to the DEVLINK_CMD_REGION_TRIGGER for
+ * the shadow-ram devlink region. It captures a snapshot of the shadow ram
+ * contents. This snapshot can later be viewed via the devlink-region
+ * interface.
+ *
+ * @returns zero on success, and updates the data pointer. Returns a non-zero
+ * error code on failure.
+ */
+static int
+ice_devlink_sram_snapshot(struct devlink *devlink,
+			  const struct devlink_region_ops __always_unused *ops,
+			  struct netlink_ext_ack *extack, u8 **data)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	u8 *sram_data;
+	u32 sram_size;
+	int err;
+
+	sram_size = hw->flash.sr_words * 2u;
+	sram_data = vzalloc(sram_size);
+	if (!sram_data)
+		return -ENOMEM;
+
+	err = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (err) {
+		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
+			err, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
+		vfree(sram_data);
+		return err;
+	}
+
+	/* Read from the Shadow RAM, rather than directly from NVM */
+	err = ice_read_flat_nvm(hw, 0, &sram_size, sram_data, true);
+	if (err) {
+		dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
+			sram_size, err, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to read Shadow RAM contents");
+		ice_release_nvm(hw);
+		vfree(sram_data);
+		return err;
+	}
+
+	ice_release_nvm(hw);
+
+	*data = sram_data;
+
+	return 0;
+}
+
 /**
  * ice_devlink_devcaps_snapshot - Capture snapshot of device capabilities
  * @devlink: the devlink instance
@@ -845,6 +909,12 @@ static const struct devlink_region_ops ice_nvm_region_ops = {
 	.snapshot = ice_devlink_nvm_snapshot,
 };
 
+static const struct devlink_region_ops ice_sram_region_ops = {
+	.name = "shadow-ram",
+	.destructor = vfree,
+	.snapshot = ice_devlink_sram_snapshot,
+};
+
 static const struct devlink_region_ops ice_devcaps_region_ops = {
 	.name = "device-caps",
 	.destructor = vfree,
@@ -862,7 +932,7 @@ void ice_devlink_init_regions(struct ice_pf *pf)
 {
 	struct devlink *devlink = priv_to_devlink(pf);
 	struct device *dev = ice_pf_to_dev(pf);
-	u64 nvm_size;
+	u64 nvm_size, sram_size;
 
 	nvm_size = pf->hw.flash.flash_size;
 	pf->nvm_region = devlink_region_create(devlink, &ice_nvm_region_ops, 1,
@@ -873,6 +943,15 @@ void ice_devlink_init_regions(struct ice_pf *pf)
 		pf->nvm_region = NULL;
 	}
 
+	sram_size = pf->hw.flash.sr_words * 2u;
+	pf->sram_region = devlink_region_create(devlink, &ice_sram_region_ops,
+						1, sram_size);
+	if (IS_ERR(pf->sram_region)) {
+		dev_err(dev, "failed to create shadow-ram devlink region, err %ld\n",
+			PTR_ERR(pf->sram_region));
+		pf->sram_region = NULL;
+	}
+
 	pf->devcaps_region = devlink_region_create(devlink,
 						   &ice_devcaps_region_ops, 10,
 						   ICE_AQ_MAX_BUF_LEN);
@@ -893,6 +972,10 @@ void ice_devlink_destroy_regions(struct ice_pf *pf)
 {
 	if (pf->nvm_region)
 		devlink_region_destroy(pf->nvm_region);
+
+	if (pf->sram_region)
+		devlink_region_destroy(pf->sram_region);
+
 	if (pf->devcaps_region)
 		devlink_region_destroy(pf->devcaps_region);
 }
-- 
2.31.1


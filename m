Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E226C14E5CF
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgA3W7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:44 -0500
Received: from mga12.intel.com ([192.55.52.136]:51507 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbgA3W7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187817"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:23 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 12/15] ice: add a devlink region to dump shadow RAM contents
Date:   Thu, 30 Jan 2020 14:59:07 -0800
Message-Id: <20200130225913.1671982-13-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a devlink region for exposing the device's Shadow RAM contents.
Support immediate snapshots by implementing the .snapshot callback.

Currently, no driver event triggers a snapshot automatically. Users must
request a snapshot via the new DEVLINK_CMD_REGION_TAKE_SNAPSHOT command.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |   2 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 120 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c    |   4 +
 4 files changed, 129 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index a195135f840f..43deda152dd3 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -350,6 +350,8 @@ struct ice_pf {
 	/* devlink port data */
 	struct devlink_port devlink_port;
 
+	struct devlink_region *sr_region;
+
 	/* OS reserved IRQ details */
 	struct msix_entry *msix_entries;
 	struct ice_res_tracker *irq_tracker;
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 3a98f241ccee..9f6a0281fd6e 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -5,6 +5,26 @@
 #include "ice_lib.h"
 #include "ice_devlink.h"
 
+/**
+ * ice_is_primary_devlink - Check if this is the primary devlink instance
+ * @pf: the PF device to check
+ *
+ * The ice hardware is represented by a multi-function PCIe device. This
+ * function is used to check whether this PF is function zero. Certain devlink
+ * features will call this function and only be enabled if it returns true.
+ */
+static bool ice_is_primary_function(struct ice_pf *pf)
+{
+	struct ice_hw *hw = &pf->hw;
+	u8 pf_id;
+
+	/* the hw->pf_id may not always be set when this function is called */
+	pf_id = (u8)(rd32(hw, PF_FUNC_RID) & PF_FUNC_RID_FUNC_NUM_M) >>
+		PF_FUNC_RID_FUNC_NUM_S;
+
+	return (pf_id == 0);
+}
+
 /**
  * ice_devlink_info_get - .info_get devlink handler
  * @devlink: devlink instance structure
@@ -203,3 +223,103 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
 	devlink_port_type_clear(&pf->devlink_port);
 	devlink_port_unregister(&pf->devlink_port);
 }
+
+/**
+ * ice_devlink_sr_snapshot - Capture a snapshot of the Shadow RAM contents
+ * @devlink: the devlink instance
+ * @region: pointer to the sr_region
+ * @extack: extended ACK response structure
+ *
+ * This function is called in response to the DEVLINK_CMD_REGION_TRIGGER for
+ * the shadow-ram devlink region. It captures a snapshot of the shadow ram
+ * contents. This snapshot can later be viewed via the devlink-region
+ * interface.
+ *
+ * @returns zero on success, and updates the data and destructor values.
+ * Returns a non-zero error code on failure.
+ */
+static int ice_devlink_sr_snapshot(struct devlink *devlink,
+			      struct netlink_ext_ack *extack,
+			      u8 **data,
+			      devlink_snapshot_data_dest_t **destructor)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	void *sr_data;
+	u32 sr_size;
+
+	if (!ice_is_primary_function(pf))
+		return -EACCES;
+
+	sr_size = hw->nvm.sr_words * sizeof(u16);
+	sr_data = kzalloc(sr_size, GFP_KERNEL);
+	if (!sr_data) {
+		NL_SET_ERR_MSG_MOD(extack, "Out of memory");
+		return -ENOMEM;
+	}
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status) {
+		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
+			status, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
+		kfree(sr_data);
+		return -EIO;
+	}
+
+	status = ice_read_flat_nvm(hw, 0, &sr_size, sr_data, true);
+	if (status) {
+		dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
+			sr_size, status, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to read Shadow RAM contents");
+		ice_release_nvm(hw);
+		kfree(sr_data);
+		return -EIO;
+	}
+
+	ice_release_nvm(hw);
+
+	*data = sr_data;
+	*destructor = kfree;
+
+	return 0;
+}
+
+static const struct devlink_region_ops ice_sr_region_ops = {
+	.name = "shadow-ram",
+	.snapshot = ice_devlink_sr_snapshot,
+};
+
+/**
+ * ice_devlink_regions_init - Initialize devlink regions
+ * @pf: the PF device structure
+ *
+ * Create devlink regions used to enable access to dump the contents of the
+ * flash memory on the device.
+ */
+void ice_devlink_regions_init(struct ice_pf *pf)
+{
+	struct devlink *devlink = priv_to_devlink(pf);
+	struct device *dev = ice_pf_to_dev(pf);
+	u64 shadow_ram_size;
+
+	/* Regions which should be exported by all functions should be added
+	 * above this check.
+	 */
+	if (!ice_is_primary_function(pf))
+		return;
+
+	shadow_ram_size = pf->hw.nvm.sr_words * sizeof(u16);
+	pf->sr_region = devlink_region_create(devlink, &ice_sr_region_ops, 1,
+					      shadow_ram_size);
+	if (IS_ERR(pf->sr_region))
+		dev_warn(dev, "failed to create shadow-ram devlink region, err %ld\n",
+			 PTR_ERR(pf->sr_region));
+}
+
+void ice_devlink_regions_destroy(struct ice_pf *pf)
+{
+	devlink_region_destroy(pf->sr_region);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.h b/drivers/net/ethernet/intel/ice/ice_devlink.h
index 5e34f6e1b57e..b1bacc922a5e 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.h
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -11,4 +11,7 @@ void ice_devlink_unregister(struct ice_pf *pf);
 int ice_devlink_create_port(struct ice_pf *pf);
 void ice_devlink_destroy_port(struct ice_pf *pf);
 
+void ice_devlink_regions_init(struct ice_pf *pf);
+void ice_devlink_regions_destroy(struct ice_pf *pf);
+
 #endif /* _ICE_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a1aa4a1b6870..c20a8e761ca8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3291,6 +3291,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_init_pf_unroll;
 	}
 
+	ice_devlink_regions_init(pf);
+
 	pf->num_alloc_vsi = hw->func_caps.guar_num_vsi;
 	if (!pf->num_alloc_vsi) {
 		err = -EIO;
@@ -3400,6 +3402,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	devm_kfree(dev, pf->vsi);
 err_init_pf_unroll:
 	ice_deinit_pf(pf);
+	ice_devlink_regions_destroy(pf);
 	ice_deinit_hw(hw);
 err_exit_unroll:
 	ice_devlink_unregister(pf);
@@ -3439,6 +3442,7 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_vsi_free_q_vectors(pf->vsi[i]);
 	}
 	ice_deinit_pf(pf);
+	ice_devlink_regions_destroy(pf);
 	ice_deinit_hw(&pf->hw);
 	ice_devlink_unregister(pf);
 
-- 
2.25.0.rc1


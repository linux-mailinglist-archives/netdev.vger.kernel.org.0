Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8040D15FA52
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgBNXWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:12667 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728236AbgBNXWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629338"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:29 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 22/22] ice: add a devlink region to dump shadow RAM contents
Date:   Fri, 14 Feb 2020 15:22:21 -0800
Message-Id: <20200214232223.3442651-23-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
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

The recently added .read region operation is also implemented, enabling
direct access to the Shadow RAM contents without a snapshot. This is
useful when the atomic guarantee of a full snapshot isn't necessary and
when userspace only wants to read a small portion of the region.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/ice.rst     |  28 ++++
 drivers/net/ethernet/intel/ice/ice.h         |   2 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 145 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c    |   4 +
 5 files changed, 182 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 10ec6c1900b0..452498fc0858 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -57,3 +57,31 @@ The ``ice`` driver reports the following versions
       - 0x80001709
       - Unique identifier of the NVM image contents, also known as the
         EETRACK id.
+
+Regions
+=======
+
+The ``ice`` driver enables access to the contents of the Shadow RAM portion
+of the flash chip via the ``shadow-ram`` region.
+
+Users can request an immediate capture of a snapshot via the
+``DEVLINK_CMD_REGION_TAKE_SNAPSHOT``
+
+.. code:: shell
+
+    $ devlink region snapshot pci/0000:01:00.0/shadow-ram
+    $ devlink region dump pci/0000:01:00.0/shadow-ram snapshot 1
+
+Directly reading a portion of the Shadow RAM without a snapshot is also
+supported
+
+.. code:: shell
+
+    $ devlink region dump pci/0000:01:00.0/shadow-ram
+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
+    0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
+    0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
+
+    $ devlink region read pci/0000:01:00.0/shadow-ram address 0 length 16
+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
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
index 1f755b98d785..b78687aed3c8 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -213,3 +213,148 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
 	devlink_port_type_clear(&pf->devlink_port);
 	devlink_port_unregister(&pf->devlink_port);
 }
+
+/**
+ * ice_devlink_sr_read - Read a portion of the shadow RAM
+ * @devlink: the devlink instance
+ * @extack: netlink extended ack structure
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
+static int
+ice_devlink_sr_read(struct devlink *devlink, struct netlink_ext_ack *extack,
+		    u64 curr_offset, u32 data_size, u8 *data)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+
+	if (curr_offset + data_size > hw->nvm.sr_words * sizeof(u16))
+		return -ERANGE;
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status) {
+		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
+			status, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
+		return -EIO;
+	}
+
+	status = ice_read_flat_nvm(hw, curr_offset, &data_size, data, true);
+	if (status) {
+		dev_dbg(dev, "ice_read_flat_nvm failed after reading %u data_size from offset %llu, err %d aq_err %d\n",
+			data_size, curr_offset, status, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to read Shadow RAM contents");
+		ice_release_nvm(hw);
+		return -EIO;
+	}
+
+	ice_release_nvm(hw);
+
+	return 0;
+}
+
+/**
+ * ice_devlink_sr_snapshot - Capture a snapshot of the Shadow RAM contents
+ * @devlink: the devlink instance
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
+ice_devlink_sr_snapshot(struct devlink *devlink, struct netlink_ext_ack *extack,
+			u8 **data)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	void *sr_data;
+	u32 sr_size;
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
+
+	return 0;
+}
+
+static const struct devlink_region_ops ice_sr_region_ops = {
+	.name = "shadow-ram",
+	.destructor = kfree,
+	.snapshot = ice_devlink_sr_snapshot,
+	.read = ice_devlink_sr_read,
+};
+
+/**
+ * ice_devlink_init_regions - Initialize devlink regions
+ * @pf: the PF device structure
+ *
+ * Create devlink regions used to enable access to dump the contents of the
+ * flash memory on the device.
+ */
+void ice_devlink_init_regions(struct ice_pf *pf)
+{
+	struct devlink *devlink = priv_to_devlink(pf);
+	struct device *dev = ice_pf_to_dev(pf);
+	u64 shadow_ram_size;
+
+	shadow_ram_size = pf->hw.nvm.sr_words * sizeof(u16);
+	pf->sr_region = devlink_region_create(devlink, &ice_sr_region_ops, 1,
+					      shadow_ram_size);
+	if (IS_ERR(pf->sr_region))
+		dev_warn(dev, "failed to create shadow-ram devlink region, err %ld\n",
+			 PTR_ERR(pf->sr_region));
+}
+
+/**
+ * ice_devlink_destroy_regions - Destroy devlink regions
+ * @pf: the PF device structure
+ *
+ * Remove previously created regions for this PF.
+ */
+void ice_devlink_destroy_regions(struct ice_pf *pf)
+{
+	devlink_region_destroy(pf->sr_region);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.h b/drivers/net/ethernet/intel/ice/ice_devlink.h
index f94dc93c24c5..6e806a08dc23 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.h
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -11,4 +11,7 @@ void ice_devlink_unregister(struct ice_pf *pf);
 int ice_devlink_create_port(struct ice_pf *pf);
 void ice_devlink_destroy_port(struct ice_pf *pf);
 
+void ice_devlink_init_regions(struct ice_pf *pf);
+void ice_devlink_destroy_regions(struct ice_pf *pf);
+
 #endif /* _ICE_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f2cca810977d..3d199596e17d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3245,6 +3245,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_init_pf_unroll;
 	}
 
+	ice_devlink_init_regions(pf);
+
 	pf->num_alloc_vsi = hw->func_caps.guar_num_vsi;
 	if (!pf->num_alloc_vsi) {
 		err = -EIO;
@@ -3359,6 +3361,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	devm_kfree(dev, pf->vsi);
 err_init_pf_unroll:
 	ice_deinit_pf(pf);
+	ice_devlink_destroy_regions(pf);
 	ice_deinit_hw(hw);
 err_exit_unroll:
 	ice_devlink_unregister(pf);
@@ -3398,6 +3401,7 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_vsi_free_q_vectors(pf->vsi[i]);
 	}
 	ice_deinit_pf(pf);
+	ice_devlink_destroy_regions(pf);
 	ice_deinit_hw(&pf->hw);
 	ice_devlink_unregister(pf);
 
-- 
2.25.0.368.g28a2d05eebfb


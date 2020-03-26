Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60F7193729
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCZDwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:52:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:29077 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbgCZDwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:52:17 -0400
IronPort-SDR: xwOGnW7etTyS0/nSi2JCUFyak/PJE0S+B/C3zE7LxRlZ6/osvJrbEl88Z6gniIN8mI5P1f1G95
 pVWNPWSMYloA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 20:52:16 -0700
IronPort-SDR: CCFAmXpBocjwFlrz/rBjBLeqGbT90njjsJF1+3ycgO/+koxlKb4OFGC/K4kb4pOuquhB4gT117
 yXlDoLDKG12Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="271028129"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 25 Mar 2020 20:52:14 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v2 11/11] ice: add a devlink region for dumping NVM contents
Date:   Wed, 25 Mar 2020 20:51:57 -0700
Message-Id: <20200326035157.2211090-12-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a devlink region for exposing the device's Non Volatime Memory flash
contents.

Support the recently added .snapshot operation, enabling userspace to
request a snapshot of the NVM contents via DEVLINK_CMD_REGION_NEW.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/ice.rst     | 26 +++++
 drivers/net/ethernet/intel/ice/ice.h         |  2 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 99 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h |  3 +
 drivers/net/ethernet/intel/ice/ice_main.c    |  4 +
 5 files changed, 134 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 37fbbd40a5e5..f3d6a3b50342 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -69,3 +69,29 @@ The ``ice`` driver reports the following versions
       - The version of the DDP package that is active in the device. Note
         that both the name (as reported by ``fw.app.name``) and version are
         required to uniquely identify the package.
+
+Regions
+=======
+
+The ``ice`` driver enables access to the contents of the Non Volatile Memory
+flash chip via the ``nvm-flash`` region.
+
+Users can request an immediate capture of a snapshot via the
+``DEVLINK_CMD_REGION_NEW``
+
+.. code:: shell
+
+    $ devlink region new pci/0000:01:00.0/nvm-flash snapshot 1
+    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
+
+    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
+    0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
+    0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
+
+    $ devlink region read pci/0000:01:00.0/nvm-flash snapshot 1 address 0
+        length 16
+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
+
+    $ devlink region delete pci/0000:01:00.0/nvm-flash snapshot 1
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 8ce3afcfeca0..5c11448bfbb3 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -351,6 +351,8 @@ struct ice_pf {
 	/* devlink port data */
 	struct devlink_port devlink_port;
 
+	struct devlink_region *nvm_region;
+
 	/* OS reserved IRQ details */
 	struct msix_entry *msix_entries;
 	struct ice_res_tracker *irq_tracker;
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 27c5034c039a..91edeffd73b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -318,3 +318,102 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
 	devlink_port_type_clear(&pf->devlink_port);
 	devlink_port_unregister(&pf->devlink_port);
 }
+
+/**
+ * ice_devlink_nvm_snapshot - Capture a snapshot of the Shadow RAM contents
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
+ice_devlink_nvm_snapshot(struct devlink *devlink, struct netlink_ext_ack *extack,
+			u8 **data)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	void *nvm_data;
+	u32 nvm_size;
+
+	nvm_size = hw->nvm.flash_size;
+	nvm_data = vzalloc(nvm_size);
+	if (!nvm_data) {
+		NL_SET_ERR_MSG_MOD(extack, "Out of memory");
+		return -ENOMEM;
+	}
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status) {
+		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
+			status, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
+		vfree(nvm_data);
+		return -EIO;
+	}
+
+	status = ice_read_flat_nvm(hw, 0, &nvm_size, nvm_data, false);
+	if (status) {
+		dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
+			nvm_size, status, hw->adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to read NVM contents");
+		ice_release_nvm(hw);
+		vfree(nvm_data);
+		return -EIO;
+	}
+
+	ice_release_nvm(hw);
+
+	*data = nvm_data;
+
+	return 0;
+}
+
+static const struct devlink_region_ops ice_nvm_region_ops = {
+	.name = "nvm-flash",
+	.destructor = vfree,
+	.snapshot = ice_devlink_nvm_snapshot,
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
+	u64 nvm_size;
+
+	nvm_size = pf->hw.nvm.flash_size;
+	pf->nvm_region = devlink_region_create(devlink, &ice_nvm_region_ops, 1,
+					       nvm_size);
+	if (IS_ERR(pf->nvm_region)) {
+		dev_err(dev, "failed to create NVM devlink region, err %ld\n",
+			PTR_ERR(pf->nvm_region));
+		pf->nvm_region = NULL;
+	}
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
+	if (pf->nvm_region)
+		devlink_region_destroy(pf->nvm_region);
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
index 359ff8544773..306a4e5b2320 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3276,6 +3276,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_init_pf_unroll;
 	}
 
+	ice_devlink_init_regions(pf);
+
 	pf->num_alloc_vsi = hw->func_caps.guar_num_vsi;
 	if (!pf->num_alloc_vsi) {
 		err = -EIO;
@@ -3385,6 +3387,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	devm_kfree(dev, pf->vsi);
 err_init_pf_unroll:
 	ice_deinit_pf(pf);
+	ice_devlink_destroy_regions(pf);
 	ice_deinit_hw(hw);
 err_exit_unroll:
 	ice_devlink_unregister(pf);
@@ -3427,6 +3430,7 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_vsi_free_q_vectors(pf->vsi[i]);
 	}
 	ice_deinit_pf(pf);
+	ice_devlink_destroy_regions(pf);
 	ice_deinit_hw(&pf->hw);
 	ice_devlink_unregister(pf);
 
-- 
2.24.1


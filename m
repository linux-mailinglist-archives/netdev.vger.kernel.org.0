Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7D43934D3
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 19:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbhE0RaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 13:30:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:44424 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236988AbhE0RaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 13:30:08 -0400
IronPort-SDR: EG8jZN3l4W2SKPn82ReDAJDtAZUIkTOnv8xMj3D7IPrQSGNA6IvZqrBZBbanMEJctd/TkW/9Sd
 VTYL42Xjz0YA==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="190164941"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="190164941"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 10:27:54 -0700
IronPort-SDR: 9iKNYgYI/chFNjMZ0ilpxnGiorjvj9rwPqKvs/ZD7W+uANviIQn4jZf8ePEBicGkBMLB+JUq6h
 A+Hrh9STjYpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="480682817"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 10:27:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@mellanox.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, anthony.l.nguyen@intel.com,
        shiraz.saleem@intel.com
Subject: [PATCH net-next v2 5/7] ice: Register auxiliary device to provide RDMA
Date:   Thu, 27 May 2021 10:30:12 -0700
Message-Id: <20210527173014.362216-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210527173014.362216-1-anthony.l.nguyen@intel.com>
References: <20210527173014.362216-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Register ice client auxiliary RDMA device on the auxiliary bus per
PCIe device function for the auxiliary driver (irdma) to attach to.
It allows to realize a single RDMA driver (irdma) capable of working with
multiple netdev drivers over multi-generation Intel HW supporting RDMA.
There is no load ordering dependencies between ice and irdma.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/Kconfig        |  1 +
 drivers/net/ethernet/intel/ice/ice.h      |  8 ++-
 drivers/net/ethernet/intel/ice/ice_idc.c  | 71 ++++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c | 11 +++-
 4 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index c1d155690341..d8a12da5c49a 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -294,6 +294,7 @@ config ICE
 	tristate "Intel(R) Ethernet Connection E800 Series Support"
 	default n
 	depends on PCI_MSI
+	select AUXILIARY_BUS
 	select DIMLIB
 	select NET_DEVLINK
 	select PLDMFW
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 225f8a55eb3f..228055e8f33b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -34,6 +34,7 @@
 #include <linux/if_bridge.h>
 #include <linux/ctype.h>
 #include <linux/bpf.h>
+#include <linux/auxiliary_bus.h>
 #include <linux/avf/virtchnl.h>
 #include <linux/cpu_rmap.h>
 #include <linux/dim.h>
@@ -647,6 +648,8 @@ int ice_get_rss_key(struct ice_vsi *vsi, u8 *seed);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
+int ice_plug_aux_dev(struct ice_pf *pf);
+void ice_unplug_aux_dev(struct ice_pf *pf);
 int ice_init_rdma(struct ice_pf *pf);
 const char *ice_stat_str(enum ice_status stat_err);
 const char *ice_aq_str(enum ice_aq_err aq_err);
@@ -678,8 +681,10 @@ void ice_service_task_schedule(struct ice_pf *pf);
  */
 static inline void ice_set_rdma_cap(struct ice_pf *pf)
 {
-	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix)
+	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
 		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+		ice_plug_aux_dev(pf);
+	}
 }
 
 /**
@@ -688,6 +693,7 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
  */
 static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
+	ice_unplug_aux_dev(pf);
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 }
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index ffca0d57c13b..e7bb8f650ae2 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -254,6 +254,71 @@ static int ice_reserve_rdma_qvector(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_adev_release - function to be mapped to AUX dev's release op
+ * @dev: pointer to device to free
+ */
+static void ice_adev_release(struct device *dev)
+{
+	struct iidc_auxiliary_dev *iadev;
+
+	iadev = container_of(dev, struct iidc_auxiliary_dev, adev.dev);
+	kfree(iadev);
+}
+
+/**
+ * ice_plug_aux_dev - allocate and register AUX device
+ * @pf: pointer to pf struct
+ */
+int ice_plug_aux_dev(struct ice_pf *pf)
+{
+	struct iidc_auxiliary_dev *iadev;
+	struct auxiliary_device *adev;
+	int ret;
+
+	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
+	if (!iadev)
+		return -ENOMEM;
+
+	adev = &iadev->adev;
+	pf->adev = adev;
+	iadev->pf = pf;
+
+	adev->id = pf->aux_idx;
+	adev->dev.release = ice_adev_release;
+	adev->dev.parent = &pf->pdev->dev;
+	adev->name = IIDC_RDMA_ROCE_NAME;
+
+	ret = auxiliary_device_init(adev);
+	if (ret) {
+		pf->adev = NULL;
+		kfree(iadev);
+		return ret;
+	}
+
+	ret = auxiliary_device_add(adev);
+	if (ret) {
+		pf->adev = NULL;
+		auxiliary_device_uninit(adev);
+		return ret;
+	}
+
+	return 0;
+}
+
+/* ice_unplug_aux_dev - unregister and free AUX device
+ * @pf: pointer to pf struct
+ */
+void ice_unplug_aux_dev(struct ice_pf *pf)
+{
+	if (!pf->adev)
+		return;
+
+	auxiliary_device_delete(pf->adev);
+	auxiliary_device_uninit(pf->adev);
+	pf->adev = NULL;
+}
+
 /**
  * ice_init_rdma - initializes PF for RDMA use
  * @pf: ptr to ice_pf
@@ -265,8 +330,10 @@ int ice_init_rdma(struct ice_pf *pf)
 
 	/* Reserve vector resources */
 	ret = ice_reserve_rdma_qvector(pf);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(dev, "failed to reserve vectors for RDMA\n");
+		return ret;
+	}
 
-	return ret;
+	return ice_plug_aux_dev(pf);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9d4570b862aa..254cfc14d6b4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -456,6 +456,8 @@ ice_prepare_for_reset(struct ice_pf *pf)
 	if (test_bit(ICE_PREPARED_FOR_RESET, pf->state))
 		return;
 
+	ice_unplug_aux_dev(pf);
+
 	/* Notify VFs of impending reset */
 	if (ice_check_sq_alive(hw, &hw->mailboxq))
 		ice_vc_notify_reset(pf);
@@ -2120,6 +2122,8 @@ int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset)
 		return -EBUSY;
 	}
 
+	ice_unplug_aux_dev(pf);
+
 	switch (reset) {
 	case ICE_RESET_PFR:
 		set_bit(ICE_PFR_REQ, pf->state);
@@ -4456,11 +4460,12 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_free_vfs(pf);
 	}
 
-	set_bit(ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
 
 	ice_aq_cancel_waiting_tasks(pf);
+	ice_unplug_aux_dev(pf);
 	ida_free(&ice_aux_ida, pf->aux_idx);
+	set_bit(ICE_DOWN, pf->state);
 
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	ice_deinit_lag(pf);
@@ -4616,6 +4621,8 @@ static int __maybe_unused ice_suspend(struct device *dev)
 	 */
 	disabled = ice_service_task_stop(pf);
 
+	ice_unplug_aux_dev(pf);
+
 	/* Already suspended?, then there is nothing to do */
 	if (test_and_set_bit(ICE_SUSPENDED, pf->state)) {
 		if (!disabled)
@@ -6286,6 +6293,8 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 
 	/* if we get here, reset flow is successful */
 	clear_bit(ICE_RESET_FAILED, pf->state);
+
+	ice_plug_aux_dev(pf);
 	return;
 
 err_vsi_rebuild:
-- 
2.26.2


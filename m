Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E2434EEB1
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhC3RA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:00:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:6360 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhC3RAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:00:09 -0400
IronPort-SDR: Bn9wwgullj/wAK1ka0TSzyjTRnhzCdxGJeFxe+4g0QGt6NPDEFJb/gqZUaHlyTpQxGT0TrOFh8
 5UL+JBDcpFjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="189569198"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="189569198"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 10:00:07 -0700
IronPort-SDR: 0fI44fkYGSpgTC7khk/wrc5tdl9pHO25JHFMJru4rzLOOTdaaVaizvikNHtbEZouG9nMMPtOsQ
 PAAzuyksCIzg==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="610174658"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.112.111])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 10:00:06 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v3 04/23] ice: Register auxiliary device to provide RDMA
Date:   Tue, 30 Mar 2021 11:59:03 -0500
Message-Id: <20210330165922.2006-5-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210330165922.2006-1-shiraz.saleem@intel.com>
References: <20210330165922.2006-1-shiraz.saleem@intel.com>
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
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/net/ethernet/intel/Kconfig        |   1 +
 drivers/net/ethernet/intel/ice/ice.h      |   8 +-
 drivers/net/ethernet/intel/ice/ice_idc.c  | 123 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_main.c |   9 +++
 4 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 5aa8631..cbc5968 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -294,6 +294,7 @@ config ICE
 	tristate "Intel(R) Ethernet Connection E800 Series Support"
 	default n
 	depends on PCI_MSI
+	select AUXILIARY_BUS
 	select NET_DEVLINK
 	select PLDMFW
 	help
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 561f8fd..41bae4d 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -34,6 +34,7 @@
 #include <linux/if_bridge.h>
 #include <linux/ctype.h>
 #include <linux/bpf.h>
+#include <linux/auxiliary_bus.h>
 #include <linux/avf/virtchnl.h>
 #include <linux/cpu_rmap.h>
 #include <net/devlink.h>
@@ -633,6 +634,8 @@ static inline void ice_clear_sriov_cap(struct ice_pf *pf)
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
+int ice_plug_aux_devs(struct ice_pf *pf);
+void ice_unplug_aux_devs(struct ice_pf *pf);
 int ice_init_aux_devices(struct ice_pf *pf);
 int
 ice_for_each_aux(struct ice_pf *pf, void *data,
@@ -667,8 +670,10 @@ int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
  */
 static inline void ice_set_rdma_cap(struct ice_pf *pf)
 {
-	if (pf->hw.func_caps.common_cap.iwarp && pf->num_rdma_msix)
+	if (pf->hw.func_caps.common_cap.iwarp && pf->num_rdma_msix) {
 		set_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+		ice_plug_aux_devs(pf);
+	}
 }
 
 /**
@@ -677,6 +682,7 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
  */
 static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
+	ice_unplug_aux_devs(pf);
 	clear_bit(ICE_FLAG_IWARP_ENA, pf->flags);
 }
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 9e3e237..5981cbd 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -586,6 +586,109 @@ int ice_cdev_info_update_vsi(struct iidc_core_dev_info *cdev_info, void *data)
 };
 
 /**
+ * ice_cdev_info_adev_release - function to be mapped to AUX dev's release op
+ * @dev: pointer to device to free
+ */
+static void ice_cdev_info_adev_release(struct device *dev)
+{
+	struct iidc_auxiliary_dev *iadev;
+
+	iadev = container_of(dev, struct iidc_auxiliary_dev, adev.dev);
+	kfree(iadev->adev.name);
+	kfree(iadev);
+}
+
+/**
+ * ice_plug_aux_devs - allocate and register one AUX dev per cdev_info in PF
+ * @pf: pointer to PF struct
+ */
+int ice_plug_aux_devs(struct ice_pf *pf)
+{
+	struct iidc_auxiliary_dev *iadev;
+	int ret, i;
+
+	if (!pf->cdev_infos)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(ice_cdev_ids); i++) {
+		struct iidc_core_dev_info *cdev_info;
+		struct auxiliary_device *adev;
+
+		cdev_info = pf->cdev_infos[i];
+		if (!cdev_info)
+			continue;
+
+		iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
+		if (!iadev)
+			return -ENOMEM;
+
+		adev = &iadev->adev;
+		cdev_info->adev = adev;
+		iadev->cdev_info = cdev_info;
+
+		if (ice_cdev_ids[i].id == IIDC_RDMA_ID) {
+			if (cdev_info->rdma_protocol ==
+			    IIDC_RDMA_PROTOCOL_IWARP)
+				adev->name = kasprintf(GFP_KERNEL, "%s_%s",
+						       ice_cdev_ids[i].name,
+						       "iwarp");
+			else
+				adev->name = kasprintf(GFP_KERNEL, "%s_%s",
+						       ice_cdev_ids[i].name,
+						       "roce");
+		} else {
+			adev->name = kasprintf(GFP_KERNEL, "%s",
+					       ice_cdev_ids[i].name);
+		}
+		adev->id = pf->aux_idx;
+		adev->dev.release = ice_cdev_info_adev_release;
+		adev->dev.parent = &cdev_info->pdev->dev;
+
+		ret = auxiliary_device_init(adev);
+		if (ret) {
+			cdev_info->adev = NULL;
+			kfree(adev->name);
+			kfree(iadev);
+			return ret;
+		}
+
+		ret = auxiliary_device_add(adev);
+		if (ret) {
+			cdev_info->adev = NULL;
+			auxiliary_device_uninit(adev);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * ice_unplug_aux_devs - unregister and free AUX devs
+ * @pf: pointer to PF struct
+ */
+void ice_unplug_aux_devs(struct ice_pf *pf)
+{
+	int i;
+
+	if (!pf->cdev_infos)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(ice_cdev_ids); i++) {
+		struct iidc_core_dev_info *cdev_info;
+
+		cdev_info = pf->cdev_infos[i];
+		/* if this AUX dev has already been unplugged move on */
+		if (!cdev_info->adev)
+			continue;
+
+		auxiliary_device_delete(cdev_info->adev);
+		auxiliary_device_uninit(cdev_info->adev);
+		cdev_info->adev = NULL;
+	}
+}
+
+/**
  * ice_init_aux_devices - initializes cdev_info objects and AUX devices
  * @pf: ptr to ice_pf
  */
@@ -617,6 +720,19 @@ int ice_init_aux_devices(struct ice_pf *pf)
 		struct msix_entry *entry = NULL;
 		int j;
 
+		/* structure layout needed for container_of's looks like:
+		 * iidc_auxiliary_dev (container_of super-struct for adev)
+		 * |--> auxiliary_device
+		 * |--> *iidc_core_dev_info (pointer from cdev_info struct)
+		 *
+		 * The iidc_auxiliary_device has a lifespan as long as it
+		 * is on the bus.  Once removed it will be freed and a new
+		 * one allocated if needed to re-add.
+		 *
+		 * The iidc_core_dev_info is tied to the life of the PF, and
+		 * will exist as long as the PF driver is loaded.  It will be
+		 * freed in the remove flow for the PF driver.
+		 */
 		cdev_info = kzalloc(sizeof(*cdev_info), GFP_KERNEL);
 		if (!cdev_info) {
 			ida_simple_remove(&ice_cdev_info_ida, pf->aux_idx);
@@ -668,5 +784,12 @@ int ice_init_aux_devices(struct ice_pf *pf)
 		cdev_info->msix_entries = entry;
 	}
 
+	ret = ice_plug_aux_devs(pf);
+	if (ret) {
+		ice_unplug_aux_devs(pf);
+		ice_for_each_aux(pf, NULL, ice_unroll_cdev_info);
+		ida_simple_remove(&ice_cdev_info_ida, pf->aux_idx);
+	}
+
 	return ret;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8baf3ac..3d750ba 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -466,6 +466,8 @@ static void ice_pf_dis_all_vsi(struct ice_pf *pf, bool locked)
 	if (test_bit(__ICE_PREPARED_FOR_RESET, pf->state))
 		return;
 
+	ice_unplug_aux_devs(pf);
+
 	/* Notify VFs of impending reset */
 	if (ice_check_sq_alive(hw, &hw->mailboxq))
 		ice_vc_notify_reset(pf);
@@ -2122,6 +2124,8 @@ int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset)
 		return -EBUSY;
 	}
 
+	ice_unplug_aux_devs(pf);
+
 	switch (reset) {
 	case ICE_RESET_PFR:
 		set_bit(__ICE_PFR_REQ, pf->state);
@@ -4463,6 +4467,7 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_service_task_stop(pf);
 
 	ice_aq_cancel_waiting_tasks(pf);
+	ice_unplug_aux_devs(pf);
 	ice_for_each_aux(pf, NULL, ice_unroll_cdev_info);
 	set_bit(__ICE_DOWN, pf->state);
 
@@ -4620,6 +4625,8 @@ static int __maybe_unused ice_suspend(struct device *dev)
 	 */
 	disabled = ice_service_task_stop(pf);
 
+	ice_unplug_aux_devs(pf);
+
 	/* Already suspended?, then there is nothing to do */
 	if (test_and_set_bit(__ICE_SUSPENDED, pf->state)) {
 		if (!disabled)
@@ -6193,6 +6200,8 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 
 	/* if we get here, reset flow is successful */
 	clear_bit(__ICE_RESET_FAILED, pf->state);
+
+	ice_plug_aux_devs(pf);
 	return;
 
 err_vsi_rebuild:
-- 
1.8.3.1


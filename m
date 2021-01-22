Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606E330112F
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbhAVXwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:52:17 -0500
Received: from mga05.intel.com ([192.55.52.43]:55257 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbhAVXvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:51:08 -0500
IronPort-SDR: srV0+I7Sj1LxxYqht3mJJMYiGc0uz223bla7MpRIB6qJN8yT8lLGYy1/qcWSR5+4Bn4AtwDD+F
 syr3GEbnHklg==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="264346862"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="264346862"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:09 -0800
IronPort-SDR: JAPLAKfU+M+4fHrmJ1OwgKGexV0yvGINZZL3+XkIk1pg1SKOaJILMefiMCergp3I2LHBJe8S+n
 1gSUbjfQxnPQ==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="574869419"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.251.4.95])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:08 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH 04/22] ice: Register auxiliary device to provide RDMA
Date:   Fri, 22 Jan 2021 17:48:09 -0600
Message-Id: <20210122234827.1353-5-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210122234827.1353-1-shiraz.saleem@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Register ice client auxiliary RDMA device on the auxiliary bus per
PCIe device function for the auxiliary driver (irdma) to attach to.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/Kconfig       |  1 +
 drivers/net/ethernet/intel/ice/ice.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c | 74 +++++++++++++++++++++++++++++++-
 3 files changed, 74 insertions(+), 2 deletions(-)

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
index b79ffdc..8bf16f4 100644
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
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index e7dd958..703c6bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -6,6 +6,8 @@
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
+static DEFINE_IDA(ice_peer_ida);
+
 static struct peer_obj_id ice_peers[] = ASSIGN_PEER_INFO;
 
 /**
@@ -484,6 +486,9 @@ static void ice_check_peer_drv_for_events(struct iidc_peer_obj *peer_obj)
 	if (!peer_obj_int)
 		return 0;
 
+	auxiliary_device_delete(peer_obj_int->peer_obj.adev);
+	auxiliary_device_uninit(peer_obj_int->peer_obj.adev);
+
 	peer_drv_int = peer_obj_int->peer_drv_int;
 
 	if (peer_obj_int->ice_peer_wq) {
@@ -1220,6 +1225,20 @@ int ice_peer_update_vsi(struct ice_peer_obj_int *peer_obj_int, void *data)
 };
 
 /**
+ * ice_peer_adev_release - function to map to aux device's release callback
+ * @dev: pointer to device to free
+ */
+static void ice_peer_adev_release(struct device *dev)
+{
+	struct iidc_auxiliary_object *abo;
+	struct auxiliary_device *adev;
+
+	adev = container_of(dev, struct auxiliary_device, dev);
+	abo = container_of(adev, struct iidc_auxiliary_object, adev);
+	kfree(abo);
+}
+
+/**
  * ice_init_peer_devices - initializes peer objects and aux devices
  * @pf: ptr to ice_pf
  *
@@ -1232,7 +1251,7 @@ int ice_init_peer_devices(struct ice_pf *pf)
 	struct pci_dev *pdev = pf->pdev;
 	struct device *dev = &pdev->dev;
 	unsigned int i;
-	int ret;
+	int id, ret;
 
 	/* Reserve vector resources */
 	ret = ice_reserve_peer_qvector(pf);
@@ -1241,12 +1260,21 @@ int ice_init_peer_devices(struct ice_pf *pf)
 		return ret;
 	}
 
+	/* This PFs auxiliary ID value */
+	id = ida_alloc(&ice_peer_ida, GFP_KERNEL);
+	if (id < 0) {
+		dev_err(dev, "failed to allocate device ID for peers\n");
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(ice_peers); i++) {
 		struct ice_peer_obj_int *peer_obj_int;
 		struct ice_peer_drv_int *peer_drv_int;
+		struct iidc_auxiliary_object *abo;
 		struct iidc_qos_params *qos_info;
 		struct msix_entry *entry = NULL;
 		struct iidc_peer_obj *peer_obj;
+		struct auxiliary_device *adev;
 		int j;
 
 		/* structure layout needed for container_of's looks like:
@@ -1254,20 +1282,37 @@ int ice_init_peer_devices(struct ice_pf *pf)
 		 * |--> iidc_peer_obj
 		 * |--> *ice_peer_drv_int
 		 *
+		 * iidc_auxiliary_object (container_of parent for adev)
+		 * |--> auxiliary_device
+		 * |--> *iidc_peer_obj (pointer from internal struct)
+		 *
 		 * ice_peer_drv_int (internal only peer_drv struct)
 		 */
 		peer_obj_int = kzalloc(sizeof(*peer_obj_int), GFP_KERNEL);
-		if (!peer_obj_int)
+		if (!peer_obj_int) {
+			ida_simple_remove(&ice_peer_ida, id);
 			return -ENOMEM;
+		}
+
+		abo = kzalloc(sizeof(*abo), GFP_KERNEL);
+		if (!abo) {
+			ida_simple_remove(&ice_peer_ida, id);
+			kfree(peer_obj_int);
+			return -ENOMEM;
+		}
 
 		peer_drv_int = kzalloc(sizeof(*peer_drv_int), GFP_KERNEL);
 		if (!peer_drv_int) {
+			ida_simple_remove(&ice_peer_ida, id);
 			kfree(peer_obj_int);
+			kfree(abo);
 			return -ENOMEM;
 		}
 
 		pf->peers[i] = peer_obj_int;
+		abo->peer_obj = ice_get_peer_obj(peer_obj_int);
 		peer_obj_int->peer_drv_int = peer_drv_int;
+		peer_obj_int->peer_obj.adev = &abo->adev;
 
 		/* Initialize driver values */
 		for (j = 0; j < IIDC_EVENT_NBITS; j++)
@@ -1289,8 +1334,10 @@ int ice_init_peer_devices(struct ice_pf *pf)
 			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
 						i);
 		if (!peer_obj_int->ice_peer_wq) {
+			ida_simple_remove(&ice_peer_ida, id);
 			kfree(peer_obj_int);
 			kfree(peer_drv_int);
+			kfree(abo);
 			return -ENOMEM;
 		}
 		INIT_WORK(&peer_obj_int->peer_close_task, ice_peer_close_task);
@@ -1342,6 +1389,27 @@ int ice_init_peer_devices(struct ice_pf *pf)
 		peer_obj->msix_entries = entry;
 		ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_INIT,
 				      false);
+
+		adev = &abo->adev;
+		adev->name = ice_peers[i].name;
+		adev->id = id;
+		adev->dev.release = ice_peer_adev_release;
+		adev->dev.parent = &pdev->dev;
+
+		ret = auxiliary_device_init(adev);
+		if (ret) {
+			ida_simple_remove(&ice_peer_ida, id);
+			kfree(peer_obj_int);
+			kfree(peer_drv_int);
+			adev = NULL;
+			return ret;
+		}
+
+		ret = auxiliary_device_add(adev);
+		if (ret) {
+			auxiliary_device_uninit(adev);
+			return ret;
+		}
 	}
 
 	return ret;
@@ -1357,4 +1425,6 @@ void ice_uninit_peer_devices(struct ice_pf *pf)
 		ice_for_each_peer(pf, NULL, ice_unreg_peer_obj);
 		devm_kfree(&pf->pdev->dev, pf->peers);
 	}
+
+	ida_destroy(&ice_peer_ida);
 }
-- 
1.8.3.1


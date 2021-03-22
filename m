Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3903F3450DD
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhCVUcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:32:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:5504 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230223AbhCVUbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:23 -0400
IronPort-SDR: lSHo2ZCNJQvfsbI16til7YbswlLft7ioErvuD5rbVPOPCClpW5GS4EYpk7/Gztanr4DStCGpT7
 JDoDO2XtBmng==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438223"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438223"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:18 -0700
IronPort-SDR: cOe93gEgVQZ1sQ0c8Tlm75LOKPoxmXsEyeT3EFmCoFBWL1OmdD5/QCw3SvixIiXpLEmaDMnFmK
 h9MNvNTJuhJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810621"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        qi.z.zhang@intel.com, Chen Bo <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 14/18] iavf: Add framework to enable ethtool ntuple filters
Date:   Mon, 22 Mar 2021 13:32:40 -0700
Message-Id: <20210322203244.2525310-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

Enable ethtool ntuple filter support on the VF driver using the virtchnl
interface to the PF driver and the Flow director functionality in the
hardware.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Chen Bo <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  12 ++
 drivers/net/ethernet/intel/iavf/iavf_fdir.h   |  33 ++++
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  29 ++-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 184 ++++++++++++++++++
 4 files changed, 257 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_fdir.h

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 8a65525a7c0d..bda2a900df8e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -37,6 +37,7 @@
 #include "iavf_type.h"
 #include <linux/avf/virtchnl.h>
 #include "iavf_txrx.h"
+#include "iavf_fdir.h"
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 #define PFX "iavf: "
@@ -300,6 +301,8 @@ struct iavf_adapter {
 #define IAVF_FLAG_AQ_DISABLE_CHANNELS		BIT(22)
 #define IAVF_FLAG_AQ_ADD_CLOUD_FILTER		BIT(23)
 #define IAVF_FLAG_AQ_DEL_CLOUD_FILTER		BIT(24)
+#define IAVF_FLAG_AQ_ADD_FDIR_FILTER		BIT(25)
+#define IAVF_FLAG_AQ_DEL_FDIR_FILTER		BIT(26)
 
 	/* OS defined structs */
 	struct net_device *netdev;
@@ -340,6 +343,8 @@ struct iavf_adapter {
 			  VIRTCHNL_VF_OFFLOAD_VLAN)
 #define ADV_LINK_SUPPORT(_a) ((_a)->vf_res->vf_cap_flags & \
 			      VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
+#define FDIR_FLTR_SUPPORT(_a) ((_a)->vf_res->vf_cap_flags & \
+			       VIRTCHNL_VF_OFFLOAD_FDIR_PF)
 	struct virtchnl_vf_resource *vf_res; /* incl. all VSIs */
 	struct virtchnl_vsi_resource *vsi_res; /* our LAN VSI */
 	struct virtchnl_version_info pf_version;
@@ -362,6 +367,11 @@ struct iavf_adapter {
 	/* lock to protect access to the cloud filter list */
 	spinlock_t cloud_filter_list_lock;
 	u16 num_cloud_filters;
+
+#define IAVF_MAX_FDIR_FILTERS 128	/* max allowed Flow Director filters */
+	u16 fdir_active_fltr;
+	struct list_head fdir_list_head;
+	spinlock_t fdir_fltr_lock;	/* protect the Flow Director filter list */
 };
 
 
@@ -432,6 +442,8 @@ void iavf_enable_channels(struct iavf_adapter *adapter);
 void iavf_disable_channels(struct iavf_adapter *adapter);
 void iavf_add_cloud_filter(struct iavf_adapter *adapter);
 void iavf_del_cloud_filter(struct iavf_adapter *adapter);
+void iavf_add_fdir_filter(struct iavf_adapter *adapter);
+void iavf_del_fdir_filter(struct iavf_adapter *adapter);
 struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 					const u8 *macaddr);
 #endif /* _IAVF_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.h b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
new file mode 100644
index 000000000000..4e6494b14016
--- /dev/null
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021, Intel Corporation. */
+
+#ifndef _IAVF_FDIR_H_
+#define _IAVF_FDIR_H_
+
+struct iavf_adapter;
+
+/* State of Flow Director filter */
+enum iavf_fdir_fltr_state_t {
+	IAVF_FDIR_FLTR_ADD_REQUEST,	/* User requests to add filter */
+	IAVF_FDIR_FLTR_ADD_PENDING,	/* Filter pending add by the PF */
+	IAVF_FDIR_FLTR_DEL_REQUEST,	/* User requests to delete filter */
+	IAVF_FDIR_FLTR_DEL_PENDING,	/* Filter pending delete by the PF */
+	IAVF_FDIR_FLTR_ACTIVE,		/* Filter is active */
+};
+
+/* bookkeeping of Flow Director filters */
+struct iavf_fdir_fltr {
+	enum iavf_fdir_fltr_state_t state;
+	struct list_head list;
+
+	u32 flow_id;
+
+	struct virtchnl_fdir_add vc_add_msg;
+};
+
+int iavf_fill_fdir_add_msg(struct iavf_adapter *adapter, struct iavf_fdir_fltr *fltr);
+void iavf_print_fdir_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *fltr);
+bool iavf_fdir_is_dup_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *fltr);
+void iavf_fdir_list_add_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *fltr);
+struct iavf_fdir_fltr *iavf_find_fdir_fltr_by_loc(struct iavf_adapter *adapter, u32 loc);
+#endif /* _IAVF_FDIR_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index dc5b3c06d1e0..d0c16117484f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -959,8 +959,9 @@ void iavf_down(struct iavf_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	struct iavf_vlan_filter *vlf;
-	struct iavf_mac_filter *f;
 	struct iavf_cloud_filter *cf;
+	struct iavf_fdir_fltr *fdir;
+	struct iavf_mac_filter *f;
 
 	if (adapter->state <= __IAVF_DOWN_PENDING)
 		return;
@@ -996,6 +997,13 @@ void iavf_down(struct iavf_adapter *adapter)
 	}
 	spin_unlock_bh(&adapter->cloud_filter_list_lock);
 
+	/* remove all Flow Director filters */
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+	list_for_each_entry(fdir, &adapter->fdir_list_head, list) {
+		fdir->state = IAVF_FDIR_FLTR_DEL_REQUEST;
+	}
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+
 	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) &&
 	    adapter->state != __IAVF_RESETTING) {
 		/* cancel any current operation */
@@ -1007,6 +1015,7 @@ void iavf_down(struct iavf_adapter *adapter)
 		adapter->aq_required = IAVF_FLAG_AQ_DEL_MAC_FILTER;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_VLAN_FILTER;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_CLOUD_FILTER;
+		adapter->aq_required |= IAVF_FLAG_AQ_DEL_FDIR_FILTER;
 		adapter->aq_required |= IAVF_FLAG_AQ_DISABLE_QUEUES;
 	}
 
@@ -1629,6 +1638,14 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
 		iavf_add_cloud_filter(adapter);
 		return 0;
 	}
+	if (adapter->aq_required & IAVF_FLAG_AQ_ADD_FDIR_FILTER) {
+		iavf_add_fdir_filter(adapter);
+		return IAVF_SUCCESS;
+	}
+	if (adapter->aq_required & IAVF_FLAG_AQ_DEL_FDIR_FILTER) {
+		iavf_del_fdir_filter(adapter);
+		return IAVF_SUCCESS;
+	}
 	return -EAGAIN;
 }
 
@@ -3738,10 +3755,12 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	spin_lock_init(&adapter->mac_vlan_list_lock);
 	spin_lock_init(&adapter->cloud_filter_list_lock);
+	spin_lock_init(&adapter->fdir_fltr_lock);
 
 	INIT_LIST_HEAD(&adapter->mac_filter_list);
 	INIT_LIST_HEAD(&adapter->vlan_filter_list);
 	INIT_LIST_HEAD(&adapter->cloud_filter_list);
+	INIT_LIST_HEAD(&adapter->fdir_list_head);
 
 	INIT_WORK(&adapter->reset_task, iavf_reset_task);
 	INIT_WORK(&adapter->adminq_task, iavf_adminq_task);
@@ -3845,6 +3864,7 @@ static void iavf_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct iavf_adapter *adapter = netdev_priv(netdev);
+	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
 	struct iavf_mac_filter *f, *ftmp;
 	struct iavf_cloud_filter *cf, *cftmp;
@@ -3926,6 +3946,13 @@ static void iavf_remove(struct pci_dev *pdev)
 	}
 	spin_unlock_bh(&adapter->cloud_filter_list_lock);
 
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+	list_for_each_entry_safe(fdir, fdirtmp, &adapter->fdir_list_head, list) {
+		list_del(&fdir->list);
+		kfree(fdir);
+	}
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+
 	free_netdev(netdev);
 
 	pci_disable_pcie_error_reporting(pdev);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 647e7fde11b4..9b8a5b700cff 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -140,6 +140,7 @@ int iavf_send_vf_config_msg(struct iavf_adapter *adapter)
 	       VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM |
 	       VIRTCHNL_VF_OFFLOAD_REQ_QUEUES |
 	       VIRTCHNL_VF_OFFLOAD_ADQ |
+	       VIRTCHNL_VF_OFFLOAD_FDIR_PF |
 	       VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
 
 	adapter->current_op = VIRTCHNL_OP_GET_VF_RESOURCES;
@@ -1197,6 +1198,101 @@ void iavf_del_cloud_filter(struct iavf_adapter *adapter)
 	kfree(f);
 }
 
+/**
+ * iavf_add_fdir_filter
+ * @adapter: the VF adapter structure
+ *
+ * Request that the PF add Flow Director filters as specified
+ * by the user via ethtool.
+ **/
+void iavf_add_fdir_filter(struct iavf_adapter *adapter)
+{
+	struct iavf_fdir_fltr *fdir;
+	struct virtchnl_fdir_add *f;
+	bool process_fltr = false;
+	int len;
+
+	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
+		/* bail because we already have a command pending */
+		dev_err(&adapter->pdev->dev, "Cannot add Flow Director filter, command %d pending\n",
+			adapter->current_op);
+		return;
+	}
+
+	len = sizeof(struct virtchnl_fdir_add);
+	f = kzalloc(len, GFP_KERNEL);
+	if (!f)
+		return;
+
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+	list_for_each_entry(fdir, &adapter->fdir_list_head, list) {
+		if (fdir->state == IAVF_FDIR_FLTR_ADD_REQUEST) {
+			process_fltr = true;
+			fdir->state = IAVF_FDIR_FLTR_ADD_PENDING;
+			memcpy(f, &fdir->vc_add_msg, len);
+			break;
+		}
+	}
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+
+	if (!process_fltr) {
+		/* prevent iavf_add_fdir_filter() from being called when there
+		 * are no filters to add
+		 */
+		adapter->aq_required &= ~IAVF_FLAG_AQ_ADD_FDIR_FILTER;
+		kfree(f);
+		return;
+	}
+	adapter->current_op = VIRTCHNL_OP_ADD_FDIR_FILTER;
+	iavf_send_pf_msg(adapter, VIRTCHNL_OP_ADD_FDIR_FILTER, (u8 *)f, len);
+	kfree(f);
+}
+
+/**
+ * iavf_del_fdir_filter
+ * @adapter: the VF adapter structure
+ *
+ * Request that the PF delete Flow Director filters as specified
+ * by the user via ethtool.
+ **/
+void iavf_del_fdir_filter(struct iavf_adapter *adapter)
+{
+	struct iavf_fdir_fltr *fdir;
+	struct virtchnl_fdir_del f;
+	bool process_fltr = false;
+	int len;
+
+	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
+		/* bail because we already have a command pending */
+		dev_err(&adapter->pdev->dev, "Cannot remove Flow Director filter, command %d pending\n",
+			adapter->current_op);
+		return;
+	}
+
+	len = sizeof(struct virtchnl_fdir_del);
+
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+	list_for_each_entry(fdir, &adapter->fdir_list_head, list) {
+		if (fdir->state == IAVF_FDIR_FLTR_DEL_REQUEST) {
+			process_fltr = true;
+			memset(&f, 0, len);
+			f.vsi_id = fdir->vc_add_msg.vsi_id;
+			f.flow_id = fdir->flow_id;
+			fdir->state = IAVF_FDIR_FLTR_DEL_PENDING;
+			break;
+		}
+	}
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+
+	if (!process_fltr) {
+		adapter->aq_required &= ~IAVF_FLAG_AQ_DEL_FDIR_FILTER;
+		return;
+	}
+
+	adapter->current_op = VIRTCHNL_OP_DEL_FDIR_FILTER;
+	iavf_send_pf_msg(adapter, VIRTCHNL_OP_DEL_FDIR_FILTER, (u8 *)&f, len);
+}
+
 /**
  * iavf_request_reset
  * @adapter: adapter structure
@@ -1357,6 +1453,48 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			}
 			}
 			break;
+		case VIRTCHNL_OP_ADD_FDIR_FILTER: {
+			struct iavf_fdir_fltr *fdir, *fdir_tmp;
+
+			spin_lock_bh(&adapter->fdir_fltr_lock);
+			list_for_each_entry_safe(fdir, fdir_tmp,
+						 &adapter->fdir_list_head,
+						 list) {
+				if (fdir->state == IAVF_FDIR_FLTR_ADD_PENDING) {
+					dev_info(&adapter->pdev->dev, "Failed to add Flow Director filter, error %s\n",
+						 iavf_stat_str(&adapter->hw,
+							       v_retval));
+					if (msglen)
+						dev_err(&adapter->pdev->dev,
+							"%s\n", msg);
+					list_del(&fdir->list);
+					kfree(fdir);
+					adapter->fdir_active_fltr--;
+				}
+			}
+			spin_unlock_bh(&adapter->fdir_fltr_lock);
+			}
+			break;
+		case VIRTCHNL_OP_DEL_FDIR_FILTER: {
+			struct iavf_fdir_fltr *fdir;
+
+			spin_lock_bh(&adapter->fdir_fltr_lock);
+			list_for_each_entry(fdir, &adapter->fdir_list_head,
+					    list) {
+				if (fdir->state == IAVF_FDIR_FLTR_DEL_PENDING) {
+					fdir->state = IAVF_FDIR_FLTR_ACTIVE;
+					dev_info(&adapter->pdev->dev, "Failed to del Flow Director filter, error %s\n",
+						 iavf_stat_str(&adapter->hw,
+							       v_retval));
+				}
+			}
+			spin_unlock_bh(&adapter->fdir_fltr_lock);
+			}
+			break;
+		case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
+		case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
+			dev_warn(&adapter->pdev->dev, "Changing VLAN Stripping is not allowed when Port VLAN is configured\n");
+			break;
 		default:
 			dev_err(&adapter->pdev->dev, "PF returned error %d (%s) to our request %d\n",
 				v_retval, iavf_stat_str(&adapter->hw, v_retval),
@@ -1490,6 +1628,52 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		}
 		}
 		break;
+	case VIRTCHNL_OP_ADD_FDIR_FILTER: {
+		struct virtchnl_fdir_add *add_fltr = (struct virtchnl_fdir_add *)msg;
+		struct iavf_fdir_fltr *fdir, *fdir_tmp;
+
+		spin_lock_bh(&adapter->fdir_fltr_lock);
+		list_for_each_entry_safe(fdir, fdir_tmp,
+					 &adapter->fdir_list_head,
+					 list) {
+			if (fdir->state == IAVF_FDIR_FLTR_ADD_PENDING) {
+				if (add_fltr->status == VIRTCHNL_FDIR_SUCCESS) {
+					fdir->state = IAVF_FDIR_FLTR_ACTIVE;
+					fdir->flow_id = add_fltr->flow_id;
+				} else {
+					dev_info(&adapter->pdev->dev, "Failed to add Flow Director filter with status: %d\n",
+						 add_fltr->status);
+					list_del(&fdir->list);
+					kfree(fdir);
+					adapter->fdir_active_fltr--;
+				}
+			}
+		}
+		spin_unlock_bh(&adapter->fdir_fltr_lock);
+		}
+		break;
+	case VIRTCHNL_OP_DEL_FDIR_FILTER: {
+		struct virtchnl_fdir_del *del_fltr = (struct virtchnl_fdir_del *)msg;
+		struct iavf_fdir_fltr *fdir, *fdir_tmp;
+
+		spin_lock_bh(&adapter->fdir_fltr_lock);
+		list_for_each_entry_safe(fdir, fdir_tmp, &adapter->fdir_list_head,
+					 list) {
+			if (fdir->state == IAVF_FDIR_FLTR_DEL_PENDING) {
+				if (del_fltr->status == VIRTCHNL_FDIR_SUCCESS) {
+					list_del(&fdir->list);
+					kfree(fdir);
+					adapter->fdir_active_fltr--;
+				} else {
+					fdir->state = IAVF_FDIR_FLTR_ACTIVE;
+					dev_info(&adapter->pdev->dev, "Failed to delete Flow Director filter with status: %d\n",
+						 del_fltr->status);
+				}
+			}
+		}
+		spin_unlock_bh(&adapter->fdir_fltr_lock);
+		}
+		break;
 	default:
 		if (adapter->current_op && (v_opcode != adapter->current_op))
 			dev_warn(&adapter->pdev->dev, "Expected response %d from PF, received %d\n",
-- 
2.26.2


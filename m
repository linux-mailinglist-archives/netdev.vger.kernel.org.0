Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AABC3685F0
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbhDVRad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:60043 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237414AbhDVRaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:15 -0400
IronPort-SDR: PT7VJsnWNlCO1DX9jDAPMeHGJu/rW5dL0vcZgXguz0YsfBRki7BshYuRJbUWI+XXVENL+Wmr6X
 uHOx4aUHl6mQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991485"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991485"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:36 -0700
IronPort-SDR: G75o1zMtf0IxhxrU1y3ioyYSfLPwIO16oGmHR+0PGJM0QA7l7dg0BLtTbY1QtUfnIDhqYbCcYs
 sjbuUnIzvF4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286286"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 09/12] iavf: Add framework to enable ethtool RSS config
Date:   Thu, 22 Apr 2021 10:31:27 -0700
Message-Id: <20210422173130.1143082-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

Add the virtchnl message interface to VF, so that VF can request RSS
input set(s) based on PF's capability.

This framework allows ethtool RSS config support on the VF driver.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  10 ++
 .../net/ethernet/intel/iavf/iavf_adv_rss.h    |  25 +++
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  27 ++++
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 152 ++++++++++++++++++
 4 files changed, 214 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_adv_rss.h

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index bda2a900df8e..e8bd04100ecd 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -38,6 +38,7 @@
 #include <linux/avf/virtchnl.h>
 #include "iavf_txrx.h"
 #include "iavf_fdir.h"
+#include "iavf_adv_rss.h"
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 #define PFX "iavf: "
@@ -303,6 +304,8 @@ struct iavf_adapter {
 #define IAVF_FLAG_AQ_DEL_CLOUD_FILTER		BIT(24)
 #define IAVF_FLAG_AQ_ADD_FDIR_FILTER		BIT(25)
 #define IAVF_FLAG_AQ_DEL_FDIR_FILTER		BIT(26)
+#define IAVF_FLAG_AQ_ADD_ADV_RSS_CFG		BIT(27)
+#define IAVF_FLAG_AQ_DEL_ADV_RSS_CFG		BIT(28)
 
 	/* OS defined structs */
 	struct net_device *netdev;
@@ -345,6 +348,8 @@ struct iavf_adapter {
 			      VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
 #define FDIR_FLTR_SUPPORT(_a) ((_a)->vf_res->vf_cap_flags & \
 			       VIRTCHNL_VF_OFFLOAD_FDIR_PF)
+#define ADV_RSS_SUPPORT(_a) ((_a)->vf_res->vf_cap_flags & \
+			     VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF)
 	struct virtchnl_vf_resource *vf_res; /* incl. all VSIs */
 	struct virtchnl_vsi_resource *vsi_res; /* our LAN VSI */
 	struct virtchnl_version_info pf_version;
@@ -372,6 +377,9 @@ struct iavf_adapter {
 	u16 fdir_active_fltr;
 	struct list_head fdir_list_head;
 	spinlock_t fdir_fltr_lock;	/* protect the Flow Director filter list */
+
+	struct list_head adv_rss_list_head;
+	spinlock_t adv_rss_lock;	/* protect the RSS management list */
 };
 
 
@@ -444,6 +452,8 @@ void iavf_add_cloud_filter(struct iavf_adapter *adapter);
 void iavf_del_cloud_filter(struct iavf_adapter *adapter);
 void iavf_add_fdir_filter(struct iavf_adapter *adapter);
 void iavf_del_fdir_filter(struct iavf_adapter *adapter);
+void iavf_add_adv_rss_cfg(struct iavf_adapter *adapter);
+void iavf_del_adv_rss_cfg(struct iavf_adapter *adapter);
 struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 					const u8 *macaddr);
 #endif /* _IAVF_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
new file mode 100644
index 000000000000..66262090e697
--- /dev/null
+++ b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021, Intel Corporation. */
+
+#ifndef _IAVF_ADV_RSS_H_
+#define _IAVF_ADV_RSS_H_
+
+struct iavf_adapter;
+
+/* State of advanced RSS configuration */
+enum iavf_adv_rss_state_t {
+	IAVF_ADV_RSS_ADD_REQUEST,	/* User requests to add RSS */
+	IAVF_ADV_RSS_ADD_PENDING,	/* RSS pending add by the PF */
+	IAVF_ADV_RSS_DEL_REQUEST,	/* Driver requests to delete RSS */
+	IAVF_ADV_RSS_DEL_PENDING,	/* RSS pending delete by the PF */
+	IAVF_ADV_RSS_ACTIVE,		/* RSS configuration is active */
+};
+
+/* bookkeeping of advanced RSS configuration */
+struct iavf_adv_rss {
+	enum iavf_adv_rss_state_t state;
+	struct list_head list;
+
+	struct virtchnl_rss_cfg cfg_msg;
+};
+#endif /* _IAVF_ADV_RSS_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 6cd6b9dfe5d4..7a81e7ceea65 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -962,6 +962,7 @@ void iavf_down(struct iavf_adapter *adapter)
 	struct iavf_cloud_filter *cf;
 	struct iavf_fdir_fltr *fdir;
 	struct iavf_mac_filter *f;
+	struct iavf_adv_rss *rss;
 
 	if (adapter->state <= __IAVF_DOWN_PENDING)
 		return;
@@ -1004,6 +1005,12 @@ void iavf_down(struct iavf_adapter *adapter)
 	}
 	spin_unlock_bh(&adapter->fdir_fltr_lock);
 
+	/* remove all advance RSS configuration */
+	spin_lock_bh(&adapter->adv_rss_lock);
+	list_for_each_entry(rss, &adapter->adv_rss_list_head, list)
+		rss->state = IAVF_ADV_RSS_DEL_REQUEST;
+	spin_unlock_bh(&adapter->adv_rss_lock);
+
 	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) &&
 	    adapter->state != __IAVF_RESETTING) {
 		/* cancel any current operation */
@@ -1016,6 +1023,7 @@ void iavf_down(struct iavf_adapter *adapter)
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_VLAN_FILTER;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_CLOUD_FILTER;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_FDIR_FILTER;
+		adapter->aq_required |= IAVF_FLAG_AQ_DEL_ADV_RSS_CFG;
 		adapter->aq_required |= IAVF_FLAG_AQ_DISABLE_QUEUES;
 	}
 
@@ -1646,6 +1654,14 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
 		iavf_del_fdir_filter(adapter);
 		return IAVF_SUCCESS;
 	}
+	if (adapter->aq_required & IAVF_FLAG_AQ_ADD_ADV_RSS_CFG) {
+		iavf_add_adv_rss_cfg(adapter);
+		return 0;
+	}
+	if (adapter->aq_required & IAVF_FLAG_AQ_DEL_ADV_RSS_CFG) {
+		iavf_del_adv_rss_cfg(adapter);
+		return 0;
+	}
 	return -EAGAIN;
 }
 
@@ -3758,11 +3774,13 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	spin_lock_init(&adapter->mac_vlan_list_lock);
 	spin_lock_init(&adapter->cloud_filter_list_lock);
 	spin_lock_init(&adapter->fdir_fltr_lock);
+	spin_lock_init(&adapter->adv_rss_lock);
 
 	INIT_LIST_HEAD(&adapter->mac_filter_list);
 	INIT_LIST_HEAD(&adapter->vlan_filter_list);
 	INIT_LIST_HEAD(&adapter->cloud_filter_list);
 	INIT_LIST_HEAD(&adapter->fdir_list_head);
+	INIT_LIST_HEAD(&adapter->adv_rss_list_head);
 
 	INIT_WORK(&adapter->reset_task, iavf_reset_task);
 	INIT_WORK(&adapter->adminq_task, iavf_adminq_task);
@@ -3868,6 +3886,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
+	struct iavf_adv_rss *rss, *rsstmp;
 	struct iavf_mac_filter *f, *ftmp;
 	struct iavf_cloud_filter *cf, *cftmp;
 	struct iavf_hw *hw = &adapter->hw;
@@ -3955,6 +3974,14 @@ static void iavf_remove(struct pci_dev *pdev)
 	}
 	spin_unlock_bh(&adapter->fdir_fltr_lock);
 
+	spin_lock_bh(&adapter->adv_rss_lock);
+	list_for_each_entry_safe(rss, rsstmp, &adapter->adv_rss_list_head,
+				 list) {
+		list_del(&rss->list);
+		kfree(rss);
+	}
+	spin_unlock_bh(&adapter->adv_rss_lock);
+
 	free_netdev(netdev);
 
 	pci_disable_pcie_error_reporting(pdev);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 9aaade0aae4c..54d2efe1732d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -142,6 +142,7 @@ int iavf_send_vf_config_msg(struct iavf_adapter *adapter)
 	       VIRTCHNL_VF_OFFLOAD_ADQ |
 	       VIRTCHNL_VF_OFFLOAD_USO |
 	       VIRTCHNL_VF_OFFLOAD_FDIR_PF |
+	       VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF |
 	       VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
 
 	adapter->current_op = VIRTCHNL_OP_GET_VF_RESOURCES;
@@ -1294,6 +1295,102 @@ void iavf_del_fdir_filter(struct iavf_adapter *adapter)
 	iavf_send_pf_msg(adapter, VIRTCHNL_OP_DEL_FDIR_FILTER, (u8 *)&f, len);
 }
 
+/**
+ * iavf_add_adv_rss_cfg
+ * @adapter: the VF adapter structure
+ *
+ * Request that the PF add RSS configuration as specified
+ * by the user via ethtool.
+ **/
+void iavf_add_adv_rss_cfg(struct iavf_adapter *adapter)
+{
+	struct virtchnl_rss_cfg *rss_cfg;
+	struct iavf_adv_rss *rss;
+	bool process_rss = false;
+	int len;
+
+	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
+		/* bail because we already have a command pending */
+		dev_err(&adapter->pdev->dev, "Cannot add RSS configuration, command %d pending\n",
+			adapter->current_op);
+		return;
+	}
+
+	len = sizeof(struct virtchnl_rss_cfg);
+	rss_cfg = kzalloc(len, GFP_KERNEL);
+	if (!rss_cfg)
+		return;
+
+	spin_lock_bh(&adapter->adv_rss_lock);
+	list_for_each_entry(rss, &adapter->adv_rss_list_head, list) {
+		if (rss->state == IAVF_ADV_RSS_ADD_REQUEST) {
+			process_rss = true;
+			rss->state = IAVF_ADV_RSS_ADD_PENDING;
+			memcpy(rss_cfg, &rss->cfg_msg, len);
+			break;
+		}
+	}
+	spin_unlock_bh(&adapter->adv_rss_lock);
+
+	if (process_rss) {
+		adapter->current_op = VIRTCHNL_OP_ADD_RSS_CFG;
+		iavf_send_pf_msg(adapter, VIRTCHNL_OP_ADD_RSS_CFG,
+				 (u8 *)rss_cfg, len);
+	} else {
+		adapter->aq_required &= ~IAVF_FLAG_AQ_ADD_ADV_RSS_CFG;
+	}
+
+	kfree(rss_cfg);
+}
+
+/**
+ * iavf_del_adv_rss_cfg
+ * @adapter: the VF adapter structure
+ *
+ * Request that the PF delete RSS configuration as specified
+ * by the user via ethtool.
+ **/
+void iavf_del_adv_rss_cfg(struct iavf_adapter *adapter)
+{
+	struct virtchnl_rss_cfg *rss_cfg;
+	struct iavf_adv_rss *rss;
+	bool process_rss = false;
+	int len;
+
+	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
+		/* bail because we already have a command pending */
+		dev_err(&adapter->pdev->dev, "Cannot remove RSS configuration, command %d pending\n",
+			adapter->current_op);
+		return;
+	}
+
+	len = sizeof(struct virtchnl_rss_cfg);
+	rss_cfg = kzalloc(len, GFP_KERNEL);
+	if (!rss_cfg)
+		return;
+
+	spin_lock_bh(&adapter->adv_rss_lock);
+	list_for_each_entry(rss, &adapter->adv_rss_list_head, list) {
+		if (rss->state == IAVF_ADV_RSS_DEL_REQUEST) {
+			process_rss = true;
+			rss->state = IAVF_ADV_RSS_DEL_PENDING;
+			memcpy(rss_cfg, &rss->cfg_msg, len);
+			break;
+		}
+	}
+	spin_unlock_bh(&adapter->adv_rss_lock);
+
+	if (process_rss) {
+		adapter->current_op = VIRTCHNL_OP_DEL_RSS_CFG;
+		iavf_send_pf_msg(adapter, VIRTCHNL_OP_DEL_RSS_CFG,
+				 (u8 *)rss_cfg, len);
+	} else {
+		adapter->aq_required &= ~IAVF_FLAG_AQ_DEL_ADV_RSS_CFG;
+	}
+
+	kfree(rss_cfg);
+}
+
 /**
  * iavf_request_reset
  * @adapter: adapter structure
@@ -1494,6 +1591,37 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			spin_unlock_bh(&adapter->fdir_fltr_lock);
 			}
 			break;
+		case VIRTCHNL_OP_ADD_RSS_CFG: {
+			struct iavf_adv_rss *rss, *rss_tmp;
+
+			spin_lock_bh(&adapter->adv_rss_lock);
+			list_for_each_entry_safe(rss, rss_tmp,
+						 &adapter->adv_rss_list_head,
+						 list) {
+				if (rss->state == IAVF_ADV_RSS_ADD_PENDING) {
+					list_del(&rss->list);
+					kfree(rss);
+				}
+			}
+			spin_unlock_bh(&adapter->adv_rss_lock);
+			}
+			break;
+		case VIRTCHNL_OP_DEL_RSS_CFG: {
+			struct iavf_adv_rss *rss;
+
+			spin_lock_bh(&adapter->adv_rss_lock);
+			list_for_each_entry(rss, &adapter->adv_rss_list_head,
+					    list) {
+				if (rss->state == IAVF_ADV_RSS_DEL_PENDING) {
+					rss->state = IAVF_ADV_RSS_ACTIVE;
+					dev_err(&adapter->pdev->dev, "Failed to delete RSS configuration, error %s\n",
+						iavf_stat_str(&adapter->hw,
+							      v_retval));
+				}
+			}
+			spin_unlock_bh(&adapter->adv_rss_lock);
+			}
+			break;
 		case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
 		case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
 			dev_warn(&adapter->pdev->dev, "Changing VLAN Stripping is not allowed when Port VLAN is configured\n");
@@ -1683,6 +1811,30 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		spin_unlock_bh(&adapter->fdir_fltr_lock);
 		}
 		break;
+	case VIRTCHNL_OP_ADD_RSS_CFG: {
+		struct iavf_adv_rss *rss;
+
+		spin_lock_bh(&adapter->adv_rss_lock);
+		list_for_each_entry(rss, &adapter->adv_rss_list_head, list)
+			if (rss->state == IAVF_ADV_RSS_ADD_PENDING)
+				rss->state = IAVF_ADV_RSS_ACTIVE;
+		spin_unlock_bh(&adapter->adv_rss_lock);
+		}
+		break;
+	case VIRTCHNL_OP_DEL_RSS_CFG: {
+		struct iavf_adv_rss *rss, *rss_tmp;
+
+		spin_lock_bh(&adapter->adv_rss_lock);
+		list_for_each_entry_safe(rss, rss_tmp,
+					 &adapter->adv_rss_list_head, list) {
+			if (rss->state == IAVF_ADV_RSS_DEL_PENDING) {
+				list_del(&rss->list);
+				kfree(rss);
+			}
+		}
+		spin_unlock_bh(&adapter->adv_rss_lock);
+		}
+		break;
 	default:
 		if (adapter->current_op && (v_opcode != adapter->current_op))
 			dev_warn(&adapter->pdev->dev, "Expected response %d from PF, received %d\n",
-- 
2.26.2


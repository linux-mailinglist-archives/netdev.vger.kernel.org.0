Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0454796D7
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhLQWHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:07:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:43080 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhLQWHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 17:07:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639778863; x=1671314863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VXXcKK8eLKuymdwwWEtgzNxnrwLnOhUwkVGmYf8D6cg=;
  b=MKd7z8xLrrolJwmy1SpTb9q99Q9+vB8IJJ5f+lVtDK1e3QRL6f6T7j05
   Y3kircK4FEpO8vDkNWOWzTSpLLHLJi0Nv2w+pbC3DAAoXY01khR8NC6QO
   +NxIlKS/jkgT0hVSSLQL/S0dLM2b/YZCHWPb/op2gHdbcVa2l2WukuCTT
   oJINOm1iFt9wyL5UXtIo51ab0yz2ZS8Ht27ItsMzCMTgeROkEddRyQHx9
   0rsjCh+GclRx2pr3ELbH/wIfUYw6ZKpfJAQG2/UeUyKGF9RguZ9+RVY9z
   UZk0JZmL4dSNFw8vDKjg529bo/mPDYlT8PHUe+KEgrRY/4xh3+b358049
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="239794451"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="239794451"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 14:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="519922250"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2021 14:07:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 2/6] iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 negotiation
Date:   Fri, 17 Dec 2021 14:06:43 -0800
Message-Id: <20211217220647.875246-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
References: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

In order to support the new VIRTCHNL_VF_OFFLOAD_VLAN_V2 capability the
VF driver needs to rework it's initialization state machine and reset
flow. This has to be done because successful negotiation of
VIRTCHNL_VF_OFFLOAD_VLAN_V2 requires the VF driver to perform a second
capability request via VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS before
configuring the adapter and its netdev.

Add the VIRTCHNL_VF_OFFLOAD_VLAN_V2 bit when sending the
VIRTHCNL_OP_GET_VF_RESOURECES message. The underlying PF will either
support VIRTCHNL_VF_OFFLOAD_VLAN or VIRTCHNL_VF_OFFLOAD_VLAN_V2 or
neither. Both of these offloads should never be supported together.

Based on this, add 2 new states to the initialization state machine:

__IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS
__IAVF_INIT_CONFIG_ADAPTER

The __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS state is used to request/store
the new VLAN capabilities if and only if VIRTCHNL_VLAN_OFFLOAD_VLAN_V2
was successfully negotiated in the __IAVF_INIT_GET_RESOURCES state.

The __IAVF_INIT_CONFIG_ADAPTER state is used to configure the
adapter/netdev after the resource requests have finished. The VF will
move into this state regardless of whether it successfully negotiated
VIRTCHNL_VF_OFFLOAD_VLAN or VIRTCHNL_VF_OFFLOAD_VLAN_V2.

Also, add a the new flag IAVF_FLAG_AQ_GET_OFFLOAD_VLAN_V2_CAPS and set
it during VF reset. If VIRTCHNL_VF_OFFLOAD_VLAN_V2 was successfully
negotiated then the VF will request its VLAN capabilities via
VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS during the reset. This is needed
because the PF may change/modify the VF's configuration during VF reset
(i.e. modifying the VF's port VLAN configuration).

This also, required the VF to call netdev_update_features() since its
VLAN features may change during VF reset. Make sure to call this under
rtnl_lock().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |   9 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 205 +++++++++++++-----
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  78 ++++++-
 3 files changed, 240 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index b5728bdbcf33..edb139834437 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -181,6 +181,8 @@ enum iavf_state_t {
 	__IAVF_REMOVE,		/* driver is being unloaded */
 	__IAVF_INIT_VERSION_CHECK,	/* aq msg sent, awaiting reply */
 	__IAVF_INIT_GET_RESOURCES,	/* aq msg sent, awaiting reply */
+	__IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS,
+	__IAVF_INIT_CONFIG_ADAPTER,
 	__IAVF_INIT_SW,		/* got resources, setting up structs */
 	__IAVF_INIT_FAILED,	/* init failed, restarting procedure */
 	__IAVF_RESETTING,		/* in reset */
@@ -310,6 +312,7 @@ struct iavf_adapter {
 #define IAVF_FLAG_AQ_ADD_ADV_RSS_CFG		BIT(27)
 #define IAVF_FLAG_AQ_DEL_ADV_RSS_CFG		BIT(28)
 #define IAVF_FLAG_AQ_REQUEST_STATS		BIT(29)
+#define IAVF_FLAG_AQ_GET_OFFLOAD_VLAN_V2_CAPS	BIT(30)
 
 	/* OS defined structs */
 	struct net_device *netdev;
@@ -349,6 +352,8 @@ struct iavf_adapter {
 			VIRTCHNL_VF_OFFLOAD_RSS_PF)))
 #define VLAN_ALLOWED(_a) ((_a)->vf_res->vf_cap_flags & \
 			  VIRTCHNL_VF_OFFLOAD_VLAN)
+#define VLAN_V2_ALLOWED(_a) ((_a)->vf_res->vf_cap_flags & \
+			     VIRTCHNL_VF_OFFLOAD_VLAN_V2)
 #define ADV_LINK_SUPPORT(_a) ((_a)->vf_res->vf_cap_flags & \
 			      VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
 #define FDIR_FLTR_SUPPORT(_a) ((_a)->vf_res->vf_cap_flags & \
@@ -360,6 +365,7 @@ struct iavf_adapter {
 	struct virtchnl_version_info pf_version;
 #define PF_IS_V11(_a) (((_a)->pf_version.major == 1) && \
 		       ((_a)->pf_version.minor == 1))
+	struct virtchnl_vlan_caps vlan_v2_caps;
 	u16 msg_enable;
 	struct iavf_eth_stats current_stats;
 	struct iavf_vsi vsi;
@@ -448,6 +454,7 @@ static inline void iavf_change_state(struct iavf_adapter *adapter,
 int iavf_up(struct iavf_adapter *adapter);
 void iavf_down(struct iavf_adapter *adapter);
 int iavf_process_config(struct iavf_adapter *adapter);
+int iavf_parse_vf_resource_msg(struct iavf_adapter *adapter);
 void iavf_schedule_reset(struct iavf_adapter *adapter);
 void iavf_schedule_request_stats(struct iavf_adapter *adapter);
 void iavf_reset(struct iavf_adapter *adapter);
@@ -466,6 +473,8 @@ int iavf_send_api_ver(struct iavf_adapter *adapter);
 int iavf_verify_api_ver(struct iavf_adapter *adapter);
 int iavf_send_vf_config_msg(struct iavf_adapter *adapter);
 int iavf_get_vf_config(struct iavf_adapter *adapter);
+int iavf_get_vf_vlan_v2_caps(struct iavf_adapter *adapter);
+int iavf_send_vf_offload_vlan_v2_msg(struct iavf_adapter *adapter);
 void iavf_irq_enable(struct iavf_adapter *adapter, bool flush);
 void iavf_configure_queues(struct iavf_adapter *adapter);
 void iavf_deconfigure_queues(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index aa5b8042b13d..b301da6c0a96 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1584,6 +1584,8 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
 {
 	if (adapter->aq_required & IAVF_FLAG_AQ_GET_CONFIG)
 		return iavf_send_vf_config_msg(adapter);
+	if (adapter->aq_required & IAVF_FLAG_AQ_GET_OFFLOAD_VLAN_V2_CAPS)
+		return iavf_send_vf_offload_vlan_v2_msg(adapter);
 	if (adapter->aq_required & IAVF_FLAG_AQ_DISABLE_QUEUES) {
 		iavf_disable_queues(adapter);
 		return 0;
@@ -1826,6 +1828,59 @@ static void iavf_init_version_check(struct iavf_adapter *adapter)
 	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
 
+/**
+ * iavf_parse_vf_resource_msg - parse response from VIRTCHNL_OP_GET_VF_RESOURCES
+ * @adapter: board private structure
+ */
+int iavf_parse_vf_resource_msg(struct iavf_adapter *adapter)
+{
+	int i, num_req_queues = adapter->num_req_queues;
+	struct iavf_vsi *vsi = &adapter->vsi;
+
+	for (i = 0; i < adapter->vf_res->num_vsis; i++) {
+		if (adapter->vf_res->vsi_res[i].vsi_type == VIRTCHNL_VSI_SRIOV)
+			adapter->vsi_res = &adapter->vf_res->vsi_res[i];
+	}
+	if (!adapter->vsi_res) {
+		dev_err(&adapter->pdev->dev, "No LAN VSI found\n");
+		return -ENODEV;
+	}
+
+	if (num_req_queues &&
+	    num_req_queues > adapter->vsi_res->num_queue_pairs) {
+		/* Problem.  The PF gave us fewer queues than what we had
+		 * negotiated in our request.  Need a reset to see if we can't
+		 * get back to a working state.
+		 */
+		dev_err(&adapter->pdev->dev,
+			"Requested %d queues, but PF only gave us %d.\n",
+			num_req_queues,
+			adapter->vsi_res->num_queue_pairs);
+		adapter->flags |= IAVF_FLAG_REINIT_ITR_NEEDED;
+		adapter->num_req_queues = adapter->vsi_res->num_queue_pairs;
+		iavf_schedule_reset(adapter);
+
+		return -EAGAIN;
+	}
+	adapter->num_req_queues = 0;
+	adapter->vsi.id = adapter->vsi_res->vsi_id;
+
+	adapter->vsi.back = adapter;
+	adapter->vsi.base_vector = 1;
+	adapter->vsi.work_limit = IAVF_DEFAULT_IRQ_WORK;
+	vsi->netdev = adapter->netdev;
+	vsi->qs_handle = adapter->vsi_res->qset_handle;
+	if (adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
+		adapter->rss_key_size = adapter->vf_res->rss_key_size;
+		adapter->rss_lut_size = adapter->vf_res->rss_lut_size;
+	} else {
+		adapter->rss_key_size = IAVF_HKEY_ARRAY_SIZE;
+		adapter->rss_lut_size = IAVF_HLUT_ARRAY_SIZE;
+	}
+
+	return 0;
+}
+
 /**
  * iavf_init_get_resources - third step of driver startup
  * @adapter: board private structure
@@ -1837,7 +1892,6 @@ static void iavf_init_version_check(struct iavf_adapter *adapter)
  **/
 static void iavf_init_get_resources(struct iavf_adapter *adapter)
 {
-	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
@@ -1855,7 +1909,7 @@ static void iavf_init_get_resources(struct iavf_adapter *adapter)
 	err = iavf_get_vf_config(adapter);
 	if (err == IAVF_ERR_ADMIN_QUEUE_NO_WORK) {
 		err = iavf_send_vf_config_msg(adapter);
-		goto err;
+		goto err_alloc;
 	} else if (err == IAVF_ERR_PARAM) {
 		/* We only get ERR_PARAM if the device is in a very bad
 		 * state or if we've been disabled for previous bad
@@ -1870,9 +1924,83 @@ static void iavf_init_get_resources(struct iavf_adapter *adapter)
 		goto err_alloc;
 	}
 
-	err = iavf_process_config(adapter);
+	err = iavf_parse_vf_resource_msg(adapter);
 	if (err)
 		goto err_alloc;
+
+	err = iavf_send_vf_offload_vlan_v2_msg(adapter);
+	if (err == -EOPNOTSUPP) {
+		/* underlying PF doesn't support VIRTCHNL_VF_OFFLOAD_VLAN_V2, so
+		 * go directly to finishing initialization
+		 */
+		iavf_change_state(adapter, __IAVF_INIT_CONFIG_ADAPTER);
+		return;
+	} else if (err) {
+		dev_err(&pdev->dev, "Unable to send offload vlan v2 request (%d)\n",
+			err);
+		goto err_alloc;
+	}
+
+	/* underlying PF supports VIRTCHNL_VF_OFFLOAD_VLAN_V2, so update the
+	 * state accordingly
+	 */
+	iavf_change_state(adapter, __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS);
+	return;
+
+err_alloc:
+	kfree(adapter->vf_res);
+	adapter->vf_res = NULL;
+err:
+	iavf_change_state(adapter, __IAVF_INIT_FAILED);
+}
+
+/**
+ * iavf_init_get_offload_vlan_v2_caps - part of driver startup
+ * @adapter: board private structure
+ *
+ * Function processes __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS driver state if the
+ * VF negotiates VIRTCHNL_VF_OFFLOAD_VLAN_V2. If VIRTCHNL_VF_OFFLOAD_VLAN_V2 is
+ * not negotiated, then this state will never be entered.
+ **/
+static void iavf_init_get_offload_vlan_v2_caps(struct iavf_adapter *adapter)
+{
+	int ret;
+
+	WARN_ON(adapter->state != __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS);
+
+	memset(&adapter->vlan_v2_caps, 0, sizeof(adapter->vlan_v2_caps));
+
+	ret = iavf_get_vf_vlan_v2_caps(adapter);
+	if (ret) {
+		if (ret == IAVF_ERR_ADMIN_QUEUE_NO_WORK)
+			iavf_send_vf_offload_vlan_v2_msg(adapter);
+		goto err;
+	}
+
+	iavf_change_state(adapter, __IAVF_INIT_CONFIG_ADAPTER);
+	return;
+err:
+	iavf_change_state(adapter, __IAVF_INIT_FAILED);
+}
+
+/**
+ * iavf_init_config_adapter - last part of driver startup
+ * @adapter: board private structure
+ *
+ * After all the supported capabilities are negotiated, then the
+ * __IAVF_INIT_CONFIG_ADAPTER state will finish driver initialization.
+ */
+static void iavf_init_config_adapter(struct iavf_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct pci_dev *pdev = adapter->pdev;
+	int err;
+
+	WARN_ON(adapter->state != __IAVF_INIT_CONFIG_ADAPTER);
+
+	if (iavf_process_config(adapter))
+		goto err;
+
 	adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 
 	adapter->flags |= IAVF_FLAG_RX_CSUM_ENABLED;
@@ -1962,9 +2090,6 @@ static void iavf_init_get_resources(struct iavf_adapter *adapter)
 	iavf_free_misc_irq(adapter);
 err_sw_init:
 	iavf_reset_interrupt_capability(adapter);
-err_alloc:
-	kfree(adapter->vf_res);
-	adapter->vf_res = NULL;
 err:
 	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
@@ -2013,6 +2138,18 @@ static void iavf_watchdog_task(struct work_struct *work)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
+	case __IAVF_INIT_GET_OFFLOAD_VLAN_V2_CAPS:
+		iavf_init_get_offload_vlan_v2_caps(adapter);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(1));
+		return;
+	case __IAVF_INIT_CONFIG_ADAPTER:
+		iavf_init_config_adapter(adapter);
+		mutex_unlock(&adapter->crit_lock);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(1));
+		return;
 	case __IAVF_INIT_FAILED:
 		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
 			dev_err(&adapter->pdev->dev,
@@ -2066,10 +2203,13 @@ static void iavf_watchdog_task(struct work_struct *work)
 				iavf_send_api_ver(adapter);
 			}
 		} else {
+			int ret = iavf_process_aq_command(adapter);
+
 			/* An error will be returned if no commands were
 			 * processed; use this opportunity to update stats
+			 * if the error isn't -ENOTSUPP
 			 */
-			if (iavf_process_aq_command(adapter) &&
+			if (ret && ret != -EOPNOTSUPP &&
 			    adapter->state == __IAVF_RUNNING)
 				iavf_request_stats(adapter);
 		}
@@ -2308,6 +2448,13 @@ static void iavf_reset_task(struct work_struct *work)
 	}
 
 	adapter->aq_required |= IAVF_FLAG_AQ_GET_CONFIG;
+	/* always set since VIRTCHNL_OP_GET_VF_RESOURCES has not been
+	 * sent/received yet, so VLAN_V2_ALLOWED() cannot is not reliable here,
+	 * however the VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS won't be sent until
+	 * VIRTCHNL_OP_GET_VF_RESOURCES and VIRTCHNL_VF_OFFLOAD_VLAN_V2 have
+	 * been successfully sent and negotiated
+	 */
+	adapter->aq_required |= IAVF_FLAG_AQ_GET_OFFLOAD_VLAN_V2_CAPS;
 	adapter->aq_required |= IAVF_FLAG_AQ_MAP_VECTORS;
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
@@ -3603,39 +3750,10 @@ static int iavf_check_reset_complete(struct iavf_hw *hw)
 int iavf_process_config(struct iavf_adapter *adapter)
 {
 	struct virtchnl_vf_resource *vfres = adapter->vf_res;
-	int i, num_req_queues = adapter->num_req_queues;
 	struct net_device *netdev = adapter->netdev;
-	struct iavf_vsi *vsi = &adapter->vsi;
 	netdev_features_t hw_enc_features;
 	netdev_features_t hw_features;
 
-	/* got VF config message back from PF, now we can parse it */
-	for (i = 0; i < vfres->num_vsis; i++) {
-		if (vfres->vsi_res[i].vsi_type == VIRTCHNL_VSI_SRIOV)
-			adapter->vsi_res = &vfres->vsi_res[i];
-	}
-	if (!adapter->vsi_res) {
-		dev_err(&adapter->pdev->dev, "No LAN VSI found\n");
-		return -ENODEV;
-	}
-
-	if (num_req_queues &&
-	    num_req_queues > adapter->vsi_res->num_queue_pairs) {
-		/* Problem.  The PF gave us fewer queues than what we had
-		 * negotiated in our request.  Need a reset to see if we can't
-		 * get back to a working state.
-		 */
-		dev_err(&adapter->pdev->dev,
-			"Requested %d queues, but PF only gave us %d.\n",
-			num_req_queues,
-			adapter->vsi_res->num_queue_pairs);
-		adapter->flags |= IAVF_FLAG_REINIT_ITR_NEEDED;
-		adapter->num_req_queues = adapter->vsi_res->num_queue_pairs;
-		iavf_schedule_reset(adapter);
-		return -ENODEV;
-	}
-	adapter->num_req_queues = 0;
-
 	hw_enc_features = NETIF_F_SG			|
 			  NETIF_F_IP_CSUM		|
 			  NETIF_F_IPV6_CSUM		|
@@ -3716,21 +3834,6 @@ int iavf_process_config(struct iavf_adapter *adapter)
 			netdev->features &= ~NETIF_F_GSO;
 	}
 
-	adapter->vsi.id = adapter->vsi_res->vsi_id;
-
-	adapter->vsi.back = adapter;
-	adapter->vsi.base_vector = 1;
-	adapter->vsi.work_limit = IAVF_DEFAULT_IRQ_WORK;
-	vsi->netdev = adapter->netdev;
-	vsi->qs_handle = adapter->vsi_res->qset_handle;
-	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
-		adapter->rss_key_size = vfres->rss_key_size;
-		adapter->rss_lut_size = vfres->rss_lut_size;
-	} else {
-		adapter->rss_key_size = IAVF_HKEY_ARRAY_SIZE;
-		adapter->rss_lut_size = IAVF_HLUT_ARRAY_SIZE;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index cfa1f0e0e2fe..1ebff8dc38ba 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -137,6 +137,7 @@ int iavf_send_vf_config_msg(struct iavf_adapter *adapter)
 	       VIRTCHNL_VF_OFFLOAD_WB_ON_ITR |
 	       VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2 |
 	       VIRTCHNL_VF_OFFLOAD_ENCAP |
+	       VIRTCHNL_VF_OFFLOAD_VLAN_V2 |
 	       VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM |
 	       VIRTCHNL_VF_OFFLOAD_REQ_QUEUES |
 	       VIRTCHNL_VF_OFFLOAD_ADQ |
@@ -155,6 +156,19 @@ int iavf_send_vf_config_msg(struct iavf_adapter *adapter)
 					NULL, 0);
 }
 
+int iavf_send_vf_offload_vlan_v2_msg(struct iavf_adapter *adapter)
+{
+	adapter->aq_required &= ~IAVF_FLAG_AQ_GET_OFFLOAD_VLAN_V2_CAPS;
+
+	if (!VLAN_V2_ALLOWED(adapter))
+		return -EOPNOTSUPP;
+
+	adapter->current_op = VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS;
+
+	return iavf_send_pf_msg(adapter, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
+				NULL, 0);
+}
+
 /**
  * iavf_validate_num_queues
  * @adapter: adapter structure
@@ -235,6 +249,45 @@ int iavf_get_vf_config(struct iavf_adapter *adapter)
 	return err;
 }
 
+int iavf_get_vf_vlan_v2_caps(struct iavf_adapter *adapter)
+{
+	struct iavf_hw *hw = &adapter->hw;
+	struct iavf_arq_event_info event;
+	enum virtchnl_ops op;
+	enum iavf_status err;
+	u16 len;
+
+	len =  sizeof(struct virtchnl_vlan_caps);
+	event.buf_len = len;
+	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
+	if (!event.msg_buf) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	while (1) {
+		/* When the AQ is empty, iavf_clean_arq_element will return
+		 * nonzero and this loop will terminate.
+		 */
+		err = iavf_clean_arq_element(hw, &event, NULL);
+		if (err)
+			goto out_alloc;
+		op = (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
+		if (op == VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS)
+			break;
+	}
+
+	err = (enum iavf_status)le32_to_cpu(event.desc.cookie_low);
+	if (err)
+		goto out_alloc;
+
+	memcpy(&adapter->vlan_v2_caps, event.msg_buf, min(event.msg_len, len));
+out_alloc:
+	kfree(event.msg_buf);
+out:
+	return err;
+}
+
 /**
  * iavf_configure_queues
  * @adapter: adapter structure
@@ -1759,6 +1812,26 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		}
 
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
+
+		iavf_parse_vf_resource_msg(adapter);
+
+		/* negotiated VIRTCHNL_VF_OFFLOAD_VLAN_V2, so wait for the
+		 * response to VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS to finish
+		 * configuration
+		 */
+		if (VLAN_V2_ALLOWED(adapter))
+			break;
+		/* fallthrough and finish config if VIRTCHNL_VF_OFFLOAD_VLAN_V2
+		 * wasn't successfully negotiated with the PF
+		 */
+		}
+		fallthrough;
+	case VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS: {
+		if (v_opcode == VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS)
+			memcpy(&adapter->vlan_v2_caps, msg,
+			       min_t(u16, msglen,
+				     sizeof(adapter->vlan_v2_caps)));
+
 		iavf_process_config(adapter);
 
 		/* unlock crit_lock before acquiring rtnl_lock as other
@@ -1766,8 +1839,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		 * crit_lock
 		 */
 		mutex_unlock(&adapter->crit_lock);
+		/* VLAN capabilities can change during VFR, so make sure to
+		 * update the netdev features with the new capabilities
+		 */
 		rtnl_lock();
-		netdev_update_features(adapter->netdev);
+		netdev_update_features(netdev);
 		rtnl_unlock();
 		if (iavf_lock_timeout(&adapter->crit_lock, 10000))
 			dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n",
-- 
2.31.1


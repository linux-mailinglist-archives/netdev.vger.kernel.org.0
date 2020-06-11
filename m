Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421381F709F
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgFKWvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:51:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:54985 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgFKWvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:51:03 -0400
IronPort-SDR: MUoPvv+vJzy9wYFH4nsB3FO+LqpF9uQSF5KCrXU7sipxUMscklhp+Qz7WfVgkA+oCY+hq9AbE8
 YUooaV8NSXyw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 15:51:02 -0700
IronPort-SDR: LPKhBebb/ROI0reqg7tkxUnC4X7NVwiZmyN2Ub1XlqAeSycioWqz/VWRJtQuw6HcPcrFOwFS03
 4woD4dNLXwyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="296755889"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jun 2020 15:51:02 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Sergey Nemov <sergey.nemov@intel.com>,
        Paul Greenwalt <paul.greenwalt@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 1/4] iavf: fix speed reporting over virtchnl
Date:   Thu, 11 Jun 2020 15:50:57 -0700
Message-Id: <20200611225100.326062-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
References: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Link speeds are communicated over virtchnl using an enum
virtchnl_link_speed. Currently, the highest link speed is 40Gbps which
leaves us unable to reflect some speeds that an ice VF is capable of.
This causes link speed to be misreported on the iavf driver.

Allow for communicating link speeds using Mbps so that the proper speed can
be reported for an ice VF. Moving away from the enum allows us to
communicate future speed changes without requiring a new enum to be added.

In order to support communicating link speeds over virtchnl in Mbps the
following functionality was added:
    - Added u32 link_speed_mbps in the iavf_adapter structure.
    - Added the macro ADV_LINK_SUPPORT(_a) to determine if the VF
      driver supports communicating link speeds in Mbps.
    - Added the function iavf_get_vpe_link_status() to fill the
      correct link_status in the event_data union based on the
      ADV_LINK_SUPPORT(_a) macro.
    - Added the function iavf_set_adapter_link_speed_from_vpe()
      to determine whether or not to fill the u32 link_speed_mbps or
      enum virtchnl_link_speed link_speed field in the iavf_adapter
      structure based on the ADV_LINK_SUPPORT(_a) macro.
    - Do not free vf_res in iavf_init_get_resources() as vf_res will be
      accessed in iavf_get_link_ksettings(); memset to 0 instead. This
      memory is subsequently freed in iavf_remove().

Fixes: 7c710869d64e ("ice: Add handlers for VF netdevice operations")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Sergey Nemov <sergey.nemov@intel.com>
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        | 14 +++
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 14 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 25 ++++--
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 88 ++++++++++++++++---
 4 files changed, 120 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index bcd11b4b29df..2d4ce6fdba1a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -87,6 +87,10 @@ struct iavf_vsi {
 #define IAVF_HLUT_ARRAY_SIZE ((IAVF_VFQF_HLUT_MAX_INDEX + 1) * 4)
 #define IAVF_MBPS_DIVISOR	125000 /* divisor to convert to Mbps */
 
+#define IAVF_VIRTCHNL_VF_RESOURCE_SIZE (sizeof(struct virtchnl_vf_resource) + \
+					(IAVF_MAX_VF_VSI * \
+					 sizeof(struct virtchnl_vsi_resource)))
+
 /* MAX_MSIX_Q_VECTORS of these are allocated,
  * but we only use one per queue-specific vector.
  */
@@ -306,6 +310,14 @@ struct iavf_adapter {
 	bool netdev_registered;
 	bool link_up;
 	enum virtchnl_link_speed link_speed;
+	/* This is only populated if the VIRTCHNL_VF_CAP_ADV_LINK_SPEED is set
+	 * in vf_res->vf_cap_flags. Use ADV_LINK_SUPPORT macro to determine if
+	 * this field is valid. This field should be used going forward and the
+	 * enum virtchnl_link_speed above should be considered the legacy way of
+	 * storing/communicating link speeds.
+	 */
+	u32 link_speed_mbps;
+
 	enum virtchnl_ops current_op;
 #define CLIENT_ALLOWED(_a) ((_a)->vf_res ? \
 			    (_a)->vf_res->vf_cap_flags & \
@@ -322,6 +334,8 @@ struct iavf_adapter {
 			VIRTCHNL_VF_OFFLOAD_RSS_PF)))
 #define VLAN_ALLOWED(_a) ((_a)->vf_res->vf_cap_flags & \
 			  VIRTCHNL_VF_OFFLOAD_VLAN)
+#define ADV_LINK_SUPPORT(_a) ((_a)->vf_res->vf_cap_flags & \
+			      VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
 	struct virtchnl_vf_resource *vf_res; /* incl. all VSIs */
 	struct virtchnl_vsi_resource *vsi_res; /* our LAN VSI */
 	struct virtchnl_version_info pf_version;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 2c39d46b6138..40a3fc7c5ea5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -278,7 +278,18 @@ static int iavf_get_link_ksettings(struct net_device *netdev,
 	ethtool_link_ksettings_zero_link_mode(cmd, supported);
 	cmd->base.autoneg = AUTONEG_DISABLE;
 	cmd->base.port = PORT_NONE;
-	/* Set speed and duplex */
+	cmd->base.duplex = DUPLEX_FULL;
+
+	if (ADV_LINK_SUPPORT(adapter)) {
+		if (adapter->link_speed_mbps &&
+		    adapter->link_speed_mbps < U32_MAX)
+			cmd->base.speed = adapter->link_speed_mbps;
+		else
+			cmd->base.speed = SPEED_UNKNOWN;
+
+		return 0;
+	}
+
 	switch (adapter->link_speed) {
 	case IAVF_LINK_SPEED_40GB:
 		cmd->base.speed = SPEED_40000;
@@ -306,7 +317,6 @@ static int iavf_get_link_ksettings(struct net_device *netdev,
 	default:
 		break;
 	}
-	cmd->base.duplex = DUPLEX_FULL;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2050649848ba..a21ae74bcd1b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1756,17 +1756,17 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
 	struct iavf_hw *hw = &adapter->hw;
-	int err = 0, bufsz;
+	int err;
 
 	WARN_ON(adapter->state != __IAVF_INIT_GET_RESOURCES);
 	/* aq msg sent, awaiting reply */
 	if (!adapter->vf_res) {
-		bufsz = sizeof(struct virtchnl_vf_resource) +
-			(IAVF_MAX_VF_VSI *
-			sizeof(struct virtchnl_vsi_resource));
-		adapter->vf_res = kzalloc(bufsz, GFP_KERNEL);
-		if (!adapter->vf_res)
+		adapter->vf_res = kzalloc(IAVF_VIRTCHNL_VF_RESOURCE_SIZE,
+					  GFP_KERNEL);
+		if (!adapter->vf_res) {
+			err = -ENOMEM;
 			goto err;
+		}
 	}
 	err = iavf_get_vf_config(adapter);
 	if (err == IAVF_ERR_ADMIN_QUEUE_NO_WORK) {
@@ -2036,7 +2036,7 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_queues(adapter);
 	iavf_free_q_vectors(adapter);
-	kfree(adapter->vf_res);
+	memset(adapter->vf_res, 0, IAVF_VIRTCHNL_VF_RESOURCE_SIZE);
 	iavf_shutdown_adminq(&adapter->hw);
 	adapter->netdev->flags &= ~IFF_UP;
 	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
@@ -2487,6 +2487,16 @@ static int iavf_validate_tx_bandwidth(struct iavf_adapter *adapter,
 {
 	int speed = 0, ret = 0;
 
+	if (ADV_LINK_SUPPORT(adapter)) {
+		if (adapter->link_speed_mbps < U32_MAX) {
+			speed = adapter->link_speed_mbps;
+			goto validate_bw;
+		} else {
+			dev_err(&adapter->pdev->dev, "Unknown link speed\n");
+			return -EINVAL;
+		}
+	}
+
 	switch (adapter->link_speed) {
 	case IAVF_LINK_SPEED_40GB:
 		speed = 40000;
@@ -2510,6 +2520,7 @@ static int iavf_validate_tx_bandwidth(struct iavf_adapter *adapter,
 		break;
 	}
 
+validate_bw:
 	if (max_tx_rate > speed) {
 		dev_err(&adapter->pdev->dev,
 			"Invalid tx rate specified\n");
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index d58374c2c33d..ca79bec4ebd9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -139,7 +139,8 @@ int iavf_send_vf_config_msg(struct iavf_adapter *adapter)
 	       VIRTCHNL_VF_OFFLOAD_ENCAP |
 	       VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM |
 	       VIRTCHNL_VF_OFFLOAD_REQ_QUEUES |
-	       VIRTCHNL_VF_OFFLOAD_ADQ;
+	       VIRTCHNL_VF_OFFLOAD_ADQ |
+	       VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
 
 	adapter->current_op = VIRTCHNL_OP_GET_VF_RESOURCES;
 	adapter->aq_required &= ~IAVF_FLAG_AQ_GET_CONFIG;
@@ -891,6 +892,8 @@ void iavf_disable_vlan_stripping(struct iavf_adapter *adapter)
 	iavf_send_pf_msg(adapter, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING, NULL, 0);
 }
 
+#define IAVF_MAX_SPEED_STRLEN	13
+
 /**
  * iavf_print_link_message - print link up or down
  * @adapter: adapter structure
@@ -900,37 +903,99 @@ void iavf_disable_vlan_stripping(struct iavf_adapter *adapter)
 static void iavf_print_link_message(struct iavf_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	char *speed = "Unknown ";
+	int link_speed_mbps;
+	char *speed;
 
 	if (!adapter->link_up) {
 		netdev_info(netdev, "NIC Link is Down\n");
 		return;
 	}
 
+	speed = kcalloc(1, IAVF_MAX_SPEED_STRLEN, GFP_KERNEL);
+	if (!speed)
+		return;
+
+	if (ADV_LINK_SUPPORT(adapter)) {
+		link_speed_mbps = adapter->link_speed_mbps;
+		goto print_link_msg;
+	}
+
 	switch (adapter->link_speed) {
 	case IAVF_LINK_SPEED_40GB:
-		speed = "40 G";
+		link_speed_mbps = SPEED_40000;
 		break;
 	case IAVF_LINK_SPEED_25GB:
-		speed = "25 G";
+		link_speed_mbps = SPEED_25000;
 		break;
 	case IAVF_LINK_SPEED_20GB:
-		speed = "20 G";
+		link_speed_mbps = SPEED_20000;
 		break;
 	case IAVF_LINK_SPEED_10GB:
-		speed = "10 G";
+		link_speed_mbps = SPEED_10000;
 		break;
 	case IAVF_LINK_SPEED_1GB:
-		speed = "1000 M";
+		link_speed_mbps = SPEED_1000;
 		break;
 	case IAVF_LINK_SPEED_100MB:
-		speed = "100 M";
+		link_speed_mbps = SPEED_100;
 		break;
 	default:
+		link_speed_mbps = SPEED_UNKNOWN;
 		break;
 	}
 
-	netdev_info(netdev, "NIC Link is Up %sbps Full Duplex\n", speed);
+print_link_msg:
+	if (link_speed_mbps > SPEED_1000) {
+		if (link_speed_mbps == SPEED_2500)
+			snprintf(speed, IAVF_MAX_SPEED_STRLEN, "2.5 Gbps");
+		else
+			/* convert to Gbps inline */
+			snprintf(speed, IAVF_MAX_SPEED_STRLEN, "%d %s",
+				 link_speed_mbps / 1000, "Gbps");
+	} else if (link_speed_mbps == SPEED_UNKNOWN) {
+		snprintf(speed, IAVF_MAX_SPEED_STRLEN, "%s", "Unknown Mbps");
+	} else {
+		snprintf(speed, IAVF_MAX_SPEED_STRLEN, "%u %s",
+			 link_speed_mbps, "Mbps");
+	}
+
+	netdev_info(netdev, "NIC Link is Up Speed is %s Full Duplex\n", speed);
+	kfree(speed);
+}
+
+/**
+ * iavf_get_vpe_link_status
+ * @adapter: adapter structure
+ * @vpe: virtchnl_pf_event structure
+ *
+ * Helper function for determining the link status
+ **/
+static bool
+iavf_get_vpe_link_status(struct iavf_adapter *adapter,
+			 struct virtchnl_pf_event *vpe)
+{
+	if (ADV_LINK_SUPPORT(adapter))
+		return vpe->event_data.link_event_adv.link_status;
+	else
+		return vpe->event_data.link_event.link_status;
+}
+
+/**
+ * iavf_set_adapter_link_speed_from_vpe
+ * @adapter: adapter structure for which we are setting the link speed
+ * @vpe: virtchnl_pf_event structure that contains the link speed we are setting
+ *
+ * Helper function for setting iavf_adapter link speed
+ **/
+static void
+iavf_set_adapter_link_speed_from_vpe(struct iavf_adapter *adapter,
+				     struct virtchnl_pf_event *vpe)
+{
+	if (ADV_LINK_SUPPORT(adapter))
+		adapter->link_speed_mbps =
+			vpe->event_data.link_event_adv.link_speed;
+	else
+		adapter->link_speed = vpe->event_data.link_event.link_speed;
 }
 
 /**
@@ -1160,12 +1225,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 	if (v_opcode == VIRTCHNL_OP_EVENT) {
 		struct virtchnl_pf_event *vpe =
 			(struct virtchnl_pf_event *)msg;
-		bool link_up = vpe->event_data.link_event.link_status;
+		bool link_up = iavf_get_vpe_link_status(adapter, vpe);
 
 		switch (vpe->event) {
 		case VIRTCHNL_EVENT_LINK_CHANGE:
-			adapter->link_speed =
-				vpe->event_data.link_event.link_speed;
+			iavf_set_adapter_link_speed_from_vpe(adapter, vpe);
 
 			/* we've already got the right link status, bail */
 			if (adapter->link_up == link_up)
-- 
2.26.2


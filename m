Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2C01FE339
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgFRBWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730689AbgFRBWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76F99221E8;
        Thu, 18 Jun 2020 01:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443334;
        bh=2rm5RcYbUb/j6LaDywUbdw/y6eC+GKGN8Q/dRzVkim8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MqZY1KYfdcCzInD7remNRO8OF1m/U0neQBi5RrB4fuxiFuuG2+HLliQAvljtSaGFw
         CmUGZZi3+JhClnD2BX8VBYmrpVLH0qi5zsKFDSgeA0//1G/7V2HrGO/v2cbkOVmv8k
         Azw2dX7XBji0BP89V8Uwh388+UV+Pju55LUnd3a0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>,
        Sergey Nemov <sergey.nemov@intel.com>,
        Paul Greenwalt <paul.greenwalt@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 265/266] iavf: fix speed reporting over virtchnl
Date:   Wed, 17 Jun 2020 21:16:30 -0400
Message-Id: <20200618011631.604574-265-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit e0ef26fbe2b0c62f42ba7667076dc38b693b6fb8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h        | 14 +++
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 14 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 25 ++++--
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 88 ++++++++++++++++---
 4 files changed, 120 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index bd1b1ed323f4..6b9117a350fa 100644
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
index dad3eec8ccd8..758bef02a2a8 100644
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
index 8e16be960e96..bacc5fb7eba2 100644
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
index 1ab9cb339acb..9655318803b7 100644
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
@@ -918,6 +919,8 @@ void iavf_disable_vlan_stripping(struct iavf_adapter *adapter)
 	iavf_send_pf_msg(adapter, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING, NULL, 0);
 }
 
+#define IAVF_MAX_SPEED_STRLEN	13
+
 /**
  * iavf_print_link_message - print link up or down
  * @adapter: adapter structure
@@ -927,37 +930,99 @@ void iavf_disable_vlan_stripping(struct iavf_adapter *adapter)
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
@@ -1187,12 +1252,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
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
2.25.1


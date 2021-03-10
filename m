Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10902333C6B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhCJMQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhCJMPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:45 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B54C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:45 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w9so27602849edt.13
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uo3MiB6S3znNUQN1HbSqxX3bGWL+iXLwVQkHk8+AOpo=;
        b=ewnao2iRF7laFNPODLNTrpb4ccwIn86SZInKRfSK22u0ReACa2DaiGExHyOg4axKbe
         FrAXo2afIxmzXs5rbM+xDzvHNjvXkuKkUmrqKTSSVqGBD+c6Gi+W2Rs7OGV6rpNQdliT
         RUsP52K9McrRUT5VcaUREfWCo2iu2mT7WNwRT3OFb3DpiRA3hCBUwvtq65dBM9X0ZxhR
         e/RTL6LN9monLMbNxY+Gt/3rHzyHmhy6HMAGVD5KZME+JuJGYjApnPkC+bFP4h5ismtw
         Tk5zf5kL+bj5zwv0GKWnlLkVxCtvvsQcNUaVtOYfqURAOCUKYw9jG0eX1kCFHio/tzOa
         Ut1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uo3MiB6S3znNUQN1HbSqxX3bGWL+iXLwVQkHk8+AOpo=;
        b=J+CwEsbiLExieUqx007Hglik4CCVhTKiX+liW6chmkRCtTGZrOohscupHoaIQgvO2G
         Z35ZPqlAcqyNU12DCgsTOgy5HNG8lXoxiyH6xnF72GUqPWJYYLZbYSmuHBiDw2P/Gkxb
         fr/vJPt21VCVLU0kR2Gc5xJAPdC78JVhz+6vdwXH5tIP//kFzRrS3bi4LSq/0KDJ4lUf
         Q3Gh6y8uhm5j7W02bCSGgNJdyUw39G+KvN3PyZV+ZgCKx3CevDJaFtjvT7G3vB3NMrK9
         RbSExOl03clbTlvLBSLL/wh85h8OZ6Q2B8R3g6gvZz5A5zMvx1ALuProLUAUj7V2xH5w
         LuqQ==
X-Gm-Message-State: AOAM533JBPir6yn0jS58f34u4cCR9ENXrwC+uOHWqILPhXHIlNG1x0tQ
        kbdsCBHVgqHcbhgSezyXef4=
X-Google-Smtp-Source: ABdhPJyEWNuA+cMGAXKGyjjk/VnoXKZAIcsJw65EfOkk2lWsa+Z7ZU04yMwYnEd/MN3JBXiUVnxHfw==
X-Received: by 2002:aa7:c346:: with SMTP id j6mr2889479edr.386.1615378543914;
        Wed, 10 Mar 2021 04:15:43 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:43 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 12/15] staging: dpaa2-switch: accept only vlan-aware upper devices
Date:   Wed, 10 Mar 2021 14:14:49 +0200
Message-Id: <20210310121452.552070-13-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The DPAA2 Switch is not capable to handle traffic in a VLAN unaware
fashion, thus the previous handling of both the accepted upper devices
and the SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING flag was wrong.

Fix this by checking if the bridge that we are joining is indeed VLAN
aware, if not return an error. Also, the RX VLAN filtering feature is
defined as 'on [fixed]' and the .ndo_vlan_rx_add_vid() and
.ndo_vlan_rx_kill_vid() callbacks are implemented just by recreating a
switchdev_obj_port_vlan object and then calling the same functions used
on the switchdev notifier path.
In addition, changing the vlan_filtering flag to 0 on a bridge under
which a DPAA2 switch interface is present is not supported, thus
rejected when SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING is received with
such a request.

This patch is also adding the use of the switchdev_handle_port_attr_set
function so that we can iterate through all the lower devices of the
bridge that the notification was received on and actually catch if the
user is trying to change the vlan_filtering state. Since on a VLAN
filtering change the net_device is the bridge, we also move the
dpaa2_switch_port_dev_check call so that we do not return NOTIFY_DONE
right away.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/staging/fsl-dpaa2/Kconfig       |  1 +
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 88 +++++++++++++++++++------
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h |  6 ++
 3 files changed, 76 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/Kconfig b/drivers/staging/fsl-dpaa2/Kconfig
index 244237bb068a..7cb005b6e7ab 100644
--- a/drivers/staging/fsl-dpaa2/Kconfig
+++ b/drivers/staging/fsl-dpaa2/Kconfig
@@ -12,6 +12,7 @@ config FSL_DPAA2
 
 config FSL_DPAA2_ETHSW
 	tristate "Freescale DPAA2 Ethernet Switch"
+	depends on BRIDGE || BRIDGE=n
 	depends on FSL_DPAA2
 	depends on NET_SWITCHDEV
 	help
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 1f8976898291..8058bc3ed467 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -800,6 +800,34 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 	return err;
 }
 
+static int dpaa2_switch_port_vlan_add(struct net_device *netdev, __be16 proto,
+				      u16 vid)
+{
+	struct switchdev_obj_port_vlan vlan = {
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
+		.vid = vid,
+		.obj.orig_dev = netdev,
+		/* This API only allows programming tagged, non-PVID VIDs */
+		.flags = 0,
+	};
+
+	return dpaa2_switch_port_vlans_add(netdev, &vlan);
+}
+
+static int dpaa2_switch_port_vlan_kill(struct net_device *netdev, __be16 proto,
+				       u16 vid)
+{
+	struct switchdev_obj_port_vlan vlan = {
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
+		.vid = vid,
+		.obj.orig_dev = netdev,
+		/* This API only allows programming tagged, non-PVID VIDs */
+		.flags = 0,
+	};
+
+	return dpaa2_switch_port_vlans_del(netdev, &vlan);
+}
+
 static int dpaa2_switch_port_set_mac_addr(struct ethsw_port_priv *port_priv)
 {
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
@@ -981,6 +1009,8 @@ static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_has_offload_stats	= dpaa2_switch_port_has_offload_stats,
 	.ndo_get_offload_stats	= dpaa2_switch_port_get_offload_stats,
 	.ndo_fdb_dump		= dpaa2_switch_port_fdb_dump,
+	.ndo_vlan_rx_add_vid	= dpaa2_switch_port_vlan_add,
+	.ndo_vlan_rx_kill_vid	= dpaa2_switch_port_vlan_kill,
 
 	.ndo_start_xmit		= dpaa2_switch_port_tx,
 	.ndo_get_port_parent_id	= dpaa2_switch_port_parent_id,
@@ -1114,7 +1144,8 @@ static int dpaa2_switch_port_attr_stp_state_set(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_attr_set(struct net_device *netdev,
-				      const struct switchdev_attr *attr)
+				      const struct switchdev_attr *attr,
+				      struct netlink_ext_ack *extack)
 {
 	int err = 0;
 
@@ -1124,7 +1155,11 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 							   attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		/* VLANs are supported by default  */
+		if (!attr->u.vlan_filtering) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "The DPAA2 switch does not support VLAN-unaware operation");
+			return -EOPNOTSUPP;
+		}
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -1134,8 +1169,8 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 	return err;
 }
 
-static int dpaa2_switch_port_vlans_add(struct net_device *netdev,
-				       const struct switchdev_obj_port_vlan *vlan)
+int dpaa2_switch_port_vlans_add(struct net_device *netdev,
+				const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
@@ -1303,8 +1338,8 @@ static int dpaa2_switch_port_del_vlan(struct ethsw_port_priv *port_priv, u16 vid
 	return 0;
 }
 
-static int dpaa2_switch_port_vlans_del(struct net_device *netdev,
-				       const struct switchdev_obj_port_vlan *vlan)
+int dpaa2_switch_port_vlans_del(struct net_device *netdev,
+				const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 
@@ -1356,14 +1391,13 @@ static int dpaa2_switch_port_obj_del(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_attr_set_event(struct net_device *netdev,
-					    struct switchdev_notifier_port_attr_info
-					    *port_attr_info)
+					    struct switchdev_notifier_port_attr_info *ptr)
 {
 	int err;
 
-	err = dpaa2_switch_port_attr_set(netdev, port_attr_info->attr);
-
-	port_attr_info->handled = true;
+	err = switchdev_handle_port_attr_set(netdev, ptr,
+					     dpaa2_switch_port_dev_check,
+					     dpaa2_switch_port_attr_set);
 	return notifier_from_errno(err);
 }
 
@@ -1517,14 +1551,24 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_notifier_changeupper_info *info = ptr;
+	struct netlink_ext_ack *extack;
 	struct net_device *upper_dev;
 	int err = 0;
 
 	if (!dpaa2_switch_port_dev_check(netdev))
 		return NOTIFY_DONE;
 
-	/* Handle just upper dev link/unlink for the moment */
-	if (event == NETDEV_CHANGEUPPER) {
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER:
+		upper_dev = info->upper_dev;
+		if (netif_is_bridge_master(upper_dev) && !br_vlan_enabled(upper_dev)) {
+			NL_SET_ERR_MSG_MOD(extack, "Cannot join a VLAN-unaware bridge");
+			err = -EOPNOTSUPP;
+		}
+		break;
+	case NETDEV_CHANGEUPPER:
 		upper_dev = info->upper_dev;
 		if (netif_is_bridge_master(upper_dev)) {
 			if (info->linking)
@@ -1532,6 +1576,7 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 			else
 				err = dpaa2_switch_port_bridge_leave(netdev);
 		}
+		break;
 	}
 
 	return notifier_from_errno(err);
@@ -1597,12 +1642,12 @@ static int dpaa2_switch_port_event(struct notifier_block *nb,
 	struct switchdev_notifier_fdb_info *fdb_info = ptr;
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 
-	if (!dpaa2_switch_port_dev_check(dev))
-		return NOTIFY_DONE;
-
 	if (event == SWITCHDEV_PORT_ATTR_SET)
 		return dpaa2_switch_port_attr_set_event(dev, ptr);
 
+	if (!dpaa2_switch_port_dev_check(dev))
+		return NOTIFY_DONE;
+
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (!switchdev_work)
 		return NOTIFY_BAD;
@@ -1646,6 +1691,9 @@ static int dpaa2_switch_port_obj_event(unsigned long event,
 {
 	int err = -EOPNOTSUPP;
 
+	if (!dpaa2_switch_port_dev_check(netdev))
+		return NOTIFY_DONE;
+
 	switch (event) {
 	case SWITCHDEV_PORT_OBJ_ADD:
 		err = dpaa2_switch_port_obj_add(netdev, port_obj_info->obj);
@@ -1664,9 +1712,6 @@ static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 
-	if (!dpaa2_switch_port_dev_check(dev))
-		return NOTIFY_DONE;
-
 	switch (event) {
 	case SWITCHDEV_PORT_OBJ_ADD:
 	case SWITCHDEV_PORT_OBJ_DEL:
@@ -2542,6 +2587,11 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	 */
 	ethsw->ports[port_idx] = port_priv;
 
+	/* The DPAA2 switch's ingress path depends on the VLAN table,
+	 * thus we are not able to disable VLAN filtering.
+	 */
+	port_netdev->features = NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER;
+
 	err = dpaa2_switch_port_init(port_priv, port_idx);
 	if (err)
 		goto err_port_probe;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index 0c228509fcd4..ac9335c83357 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -166,4 +166,10 @@ static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
 
 bool dpaa2_switch_port_dev_check(const struct net_device *netdev);
 
+int dpaa2_switch_port_vlans_add(struct net_device *netdev,
+				const struct switchdev_obj_port_vlan *vlan);
+
+int dpaa2_switch_port_vlans_del(struct net_device *netdev,
+				const struct switchdev_obj_port_vlan *vlan);
+
 #endif	/* __ETHSW_H */
-- 
2.30.0


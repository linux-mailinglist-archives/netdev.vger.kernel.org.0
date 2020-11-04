Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66DA2A6B36
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731858AbgKDQ54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731737AbgKDQ5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:42 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B41C0613D3;
        Wed,  4 Nov 2020 08:57:41 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id o18so23223174edq.4;
        Wed, 04 Nov 2020 08:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o9FF9knZ/AggymzgxAUUP5RVqKNvcccbw6oC4UAV1qA=;
        b=VVYHkG+R6ftkEAWlKpME0l9FaKfC0FsYNBeWc5UtF+LI9Srv7fg33+osciTSkxQICP
         vdU4RrzMEGTTcWfWEeq2CDjj16+s0biMairmrtryva5jBFIsJuHQr9VTgUZpGC0K3Hw9
         is5nzXaAIIBux8votMt4HAY7XXupFQY4jMN8DQ4YswMRjUs/QfFYcPfWj530YXmbIkQl
         mj5eZDGAlewGwiuXBG0TxsHj6XSBC9NJtM1S57PE0h7lc7SN5/dDCVsJKMxFlYPGX09O
         S/b9GI8j0TrmEuwF7jbhxNMIqn5xSfut5PwYfWAp/QHTcCWYJlZGAL9pOoynq0k2JlHa
         Mjsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o9FF9knZ/AggymzgxAUUP5RVqKNvcccbw6oC4UAV1qA=;
        b=jaesq2xTcnCZIh1QY5F86+AfAqjlACcQkBqC2KVprShfY7q8PUHaaOEErw46m0cKpN
         jGN/z4MYrUR8VQkoc302NPUKDPURL+tqRjtQP3ircqRE7qEONC27R5YULWpT1J9xeFAf
         v+Jv2A4UFZ5O0JDPtGUqhajN7f4ZGkpW2CnK3aVFT5JN6C9fxcDpcZ03kJM0Z5kWEnLv
         V+T1cRtTImcJ8peY18mbmoiX0uLJ5SjxmSMMa/arcUnMB0bbmYYz1UIV0EnYOGwEL+Dm
         ZmQVUsNFxoAYSWL+OV8FsR50v2HkSu8IxKyV6xbSpIxVoma8iU4OOND2kkbAJKPOmzUe
         namA==
X-Gm-Message-State: AOAM531dEcsqoEGPhYzJbed23bWhDag9ZeNxgC2Q/avvu7TISlQ75Pvy
        XFkyP4OW6SB0ukgpuJVS+XpOfS7OQUvVfA==
X-Google-Smtp-Source: ABdhPJy4FInzJrbBWst/EwXhpAc2yvY3C1dS/ppDLQ1IuTJE/zoAAQAPwNH9sHfr4RMuNHncCWHzxQ==
X-Received: by 2002:aa7:c955:: with SMTP id h21mr28375473edt.315.1604509059994;
        Wed, 04 Nov 2020 08:57:39 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:39 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 9/9] staging: dpaa2-switch: accept only vlan-aware upper devices
Date:   Wed,  4 Nov 2020 18:57:20 +0200
Message-Id: <20201104165720.2566399-10-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104165720.2566399-1-ciorneiioana@gmail.com>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/Kconfig       |  1 +
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 80 ++++++++++++++++++++++---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h |  7 +++
 3 files changed, 79 insertions(+), 9 deletions(-)

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
index 7a0d9a178cdc..4327c432a39f 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -814,6 +814,50 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 	return err;
 }
 
+static int dpaa2_switch_port_vlan_add(struct net_device *netdev, __be16 proto,
+				      u16 vid)
+{
+	struct switchdev_obj_port_vlan vlan = {
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
+		.vid_begin = vid,
+		.vid_end = vid,
+		/* This API only allows programming tagged, non-PVID VIDs */
+		.flags = 0,
+	};
+	struct switchdev_trans trans;
+	int err;
+
+	trans.ph_prepare = true;
+	err = dpaa2_switch_port_vlans_add(netdev, &vlan, &trans);
+	if (err)
+		return err;
+
+	trans.ph_prepare = false;
+	err = dpaa2_switch_port_vlans_add(netdev, &vlan, &trans);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int dpaa2_switch_port_vlan_kill(struct net_device *netdev, __be16 proto,
+				       u16 vid)
+{
+	struct switchdev_obj_port_vlan vlan = {
+		.vid_begin = vid,
+		.vid_end = vid,
+		/* This API only allows programming tagged, non-PVID VIDs */
+		.flags = 0,
+	};
+	int err;
+
+	err = dpaa2_switch_port_vlans_del(netdev, &vlan);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int dpaa2_switch_port_set_mac_addr(struct ethsw_port_priv *port_priv)
 {
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
@@ -996,6 +1040,8 @@ static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_fdb_add		= dpaa2_switch_port_fdb_add,
 	.ndo_fdb_del		= dpaa2_switch_port_fdb_del,
 	.ndo_fdb_dump		= dpaa2_switch_port_fdb_dump,
+	.ndo_vlan_rx_add_vid	= dpaa2_switch_port_vlan_add,
+	.ndo_vlan_rx_kill_vid	= dpaa2_switch_port_vlan_kill,
 
 	.ndo_start_xmit		= dpaa2_switch_port_tx,
 	.ndo_get_port_parent_id	= dpaa2_switch_port_parent_id,
@@ -1195,7 +1241,8 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 							  attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		/* VLANs are supported by default  */
+		if (!attr->u.vlan_filtering)
+			return -EOPNOTSUPP;
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -1205,9 +1252,9 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 	return err;
 }
 
-static int dpaa2_switch_port_vlans_add(struct net_device *netdev,
-				       const struct switchdev_obj_port_vlan *vlan,
-				       struct switchdev_trans *trans)
+int dpaa2_switch_port_vlans_add(struct net_device *netdev,
+				const struct switchdev_obj_port_vlan *vlan,
+				struct switchdev_trans *trans)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
@@ -1375,13 +1422,13 @@ static int dpaa2_switch_port_del_vlan(struct ethsw_port_priv *port_priv, u16 vid
 	return 0;
 }
 
-static int dpaa2_switch_port_vlans_del(struct net_device *netdev,
-				       const struct switchdev_obj_port_vlan *vlan)
+int dpaa2_switch_port_vlans_del(struct net_device *netdev,
+				const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	int vid, err = 0;
 
-	if (netif_is_bridge_master(vlan->obj.orig_dev))
+	if (vlan->obj.orig_dev && netif_is_bridge_master(vlan->obj.orig_dev))
 		return -EOPNOTSUPP;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
@@ -1575,14 +1622,23 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_notifier_changeupper_info *info = ptr;
+	struct netlink_ext_ack *extack;
 	struct net_device *upper_dev;
 	int err = 0;
 
 	if (!dpaa2_switch_port_dev_check(netdev, nb))
 		return NOTIFY_DONE;
 
-	/* Handle just upper dev link/unlink for the moment */
-	if (event == NETDEV_CHANGEUPPER) {
+	extack = netdev_notifier_info_to_extack(&info->info);
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER:
+		upper_dev = info->upper_dev;
+		if (netif_is_bridge_master(upper_dev) && !br_vlan_enabled(upper_dev)) {
+			NL_SET_ERR_MSG_MOD(extack, "Cannot join a vlan-unaware bridge");
+			err = -EOPNOTSUPP;
+		}
+		break;
+	case NETDEV_CHANGEUPPER:
 		upper_dev = info->upper_dev;
 		if (netif_is_bridge_master(upper_dev)) {
 			if (info->linking)
@@ -1590,6 +1646,7 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 			else
 				err = dpaa2_switch_port_bridge_leave(netdev);
 		}
+		break;
 	}
 
 	return notifier_from_errno(err);
@@ -2646,6 +2703,11 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	port_netdev->min_mtu = ETH_MIN_MTU;
 	port_netdev->max_mtu = ETHSW_MAX_FRAME_LENGTH;
 
+	/* The DPAA2 Switch's ingress path depends on the VLAN table,
+	 * thus we are not able to disable VLAN filtering.
+	 */
+	port_netdev->features = NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER;
+
 	err = dpaa2_switch_port_init(port_priv, port_idx);
 	if (err)
 		goto err_port_probe;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index f905acd18c67..3163dd2ab2ab 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -143,4 +143,11 @@ static inline bool dpaa2_switch_has_ctrl_if(struct ethsw_core *ethsw)
 bool dpaa2_switch_port_dev_check(const struct net_device *netdev,
 				 struct notifier_block *nb);
 
+int dpaa2_switch_port_vlans_add(struct net_device *netdev,
+				const struct switchdev_obj_port_vlan *vlan,
+				struct switchdev_trans *trans);
+
+int dpaa2_switch_port_vlans_del(struct net_device *netdev,
+				const struct switchdev_obj_port_vlan *vlan);
+
 #endif	/* __ETHSW_H */
-- 
2.28.0


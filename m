Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F63B31D255
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhBPVqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:46:45 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:31540 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhBPVp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613511959; x=1645047959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gp4caLKlfnoLVZRpF6jlM07fPL/2zmo4pnd4nWdMjJ0=;
  b=PaN0eJ2stgl1sFNr8kZuCr7F+KhZXKS8orh8sCky5fSJ5V4Se6gIxkCY
   h+YOBziW1cjvLZIr1Q9or4sFOP8YJLkacrMleBmzRbiKoHSkHbvYZeouA
   aaht7Divtn+wX5i1wvr8VjpQqSIx/Fbt7LB9C4Ygc6dRax7F6Mf7l0hoh
   tsDDLAxysoAZ7HLXu4SZP5eFbHJfPHNTFrBoc2J7WFWYy5XSQcAMmM2/Q
   8AR77OgWKKtntQD5U5ax/1But2ZedSEeP6LHgd5nWrP0JHjyAWWGp+Jqe
   jQ61TCGpDIz/ruyZzST4P6BJx+G8ExjeYIAOHhy32cjSwtbl6uH0xOfme
   w==;
IronPort-SDR: AYi1YPRFLf5chRfkxx/IRY1hD3qTT8SDzekiduiY5dIKaIdxlPXUBk1BHtBZit+s5UjBpHsjK9
 5wcUzbPQ6MoPF9bb6+Ksp0f51PQZFqkAEMmHY9hBIABJsPK5BumznccIlsCxLgwJ/24zz9BfDL
 WxzznHxBdzTWwm2kg4BGkN6cp/PCrB7IFN94Lr5RgQ4vDa0jZIl80vQW/WzlysZC8rk3OOjiPs
 Fqm0IyuXDX5+a4c/RxyXa0gK2+QMbX5py4MRws9zcrCI+26NBokMeyQN2Sx8BaDKVdREJocy8u
 Fhg=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="109421063"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 14:43:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 14:43:25 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 14:43:21 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <ivecera@redhat.com>, <nikolay@nvidia.com>,
        <roopa@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <rasmus.villemoes@prevas.dk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 7/8] net: dsa: add MRP support
Date:   Tue, 16 Feb 2021 22:42:04 +0100
Message-ID: <20210216214205.32385-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216214205.32385-1-horatiu.vultur@microchip.com>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading MRP in HW. Currently implement the switchdev
calls 'SWITCHDEV_OBJ_ID_MRP', 'SWITCHDEV_OBJ_ID_RING_ROLE_MRP',
to allow to create MRP instances and to set the role of these instances.

Add DSA_NOTIFIER_MRP_ADD/DEL and DSA_NOTIFIER_MRP_ADD/DEL_RING_ROLE
which calls to .port_mrp_add/del and .port_mrp_add/del_ring_role in the
DSA driver for the switch.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/dsa.h  |  12 ++++++
 net/dsa/dsa_priv.h |  26 +++++++++++
 net/dsa/port.c     |  48 +++++++++++++++++++++
 net/dsa/slave.c    |  22 ++++++++++
 net/dsa/switch.c   | 105 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 213 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 68f8159564a3..83a933e563fe 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -792,6 +792,18 @@ struct dsa_switch_ops {
 				 struct net_device *hsr);
 	int	(*port_hsr_leave)(struct dsa_switch *ds, int port,
 				  struct net_device *hsr);
+
+	/*
+	 * MRP integration
+	 */
+	int	(*port_mrp_add)(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_mrp *mrp);
+	int	(*port_mrp_del)(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_mrp *mrp);
+	int	(*port_mrp_add_ring_role)(struct dsa_switch *ds, int port,
+					  const struct switchdev_obj_ring_role_mrp *mrp);
+	int	(*port_mrp_del_ring_role)(struct dsa_switch *ds, int port,
+					  const struct switchdev_obj_ring_role_mrp *mrp);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index e9d1e76c42ba..2eeaa42f2e08 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -31,6 +31,10 @@ enum {
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
 	DSA_NOTIFIER_TAG_PROTO,
+	DSA_NOTIFIER_MRP_ADD,
+	DSA_NOTIFIER_MRP_DEL,
+	DSA_NOTIFIER_MRP_ADD_RING_ROLE,
+	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -91,6 +95,20 @@ struct dsa_notifier_tag_proto_info {
 	const struct dsa_device_ops *tag_ops;
 };
 
+/* DSA_NOTIFIER_MRP_* */
+struct dsa_notifier_mrp_info {
+	const struct switchdev_obj_mrp *mrp;
+	int sw_index;
+	int port;
+};
+
+/* DSA_NOTIFIER_MRP_* */
+struct dsa_notifier_mrp_ring_role_info {
+	const struct switchdev_obj_ring_role_mrp *mrp;
+	int sw_index;
+	int port;
+};
+
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
@@ -198,6 +216,14 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		      struct netlink_ext_ack *extack);
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
+int dsa_port_mrp_add(const struct dsa_port *dp,
+		     const struct switchdev_obj_mrp *mrp);
+int dsa_port_mrp_del(const struct dsa_port *dp,
+		     const struct switchdev_obj_mrp *mrp);
+int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
+			       const struct switchdev_obj_ring_role_mrp *mrp);
+int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
+			       const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 14a1d0d77657..c9c6d7ab3f47 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -564,6 +564,54 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
+int dsa_port_mrp_add(const struct dsa_port *dp,
+		     const struct switchdev_obj_mrp *mrp)
+{
+	struct dsa_notifier_mrp_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.mrp = mrp,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD, &info);
+}
+
+int dsa_port_mrp_del(const struct dsa_port *dp,
+		     const struct switchdev_obj_mrp *mrp)
+{
+	struct dsa_notifier_mrp_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.mrp = mrp,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL, &info);
+}
+
+int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
+			       const struct switchdev_obj_ring_role_mrp *mrp)
+{
+	struct dsa_notifier_mrp_ring_role_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.mrp = mrp,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD_RING_ROLE, &info);
+}
+
+int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
+			       const struct switchdev_obj_ring_role_mrp *mrp)
+{
+	struct dsa_notifier_mrp_ring_role_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.mrp = mrp,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL_RING_ROLE, &info);
+}
+
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5ecb43a1b6e0..491e3761b5f4 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -404,6 +404,17 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = dsa_slave_vlan_add(dev, obj, extack);
 		break;
+	case SWITCHDEV_OBJ_ID_MRP:
+		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+		err = dsa_port_mrp_add(dp, SWITCHDEV_OBJ_MRP(obj));
+		break;
+	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
+		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+		err = dsa_port_mrp_add_ring_role(dp,
+						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -461,6 +472,17 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = dsa_slave_vlan_del(dev, obj);
 		break;
+	case SWITCHDEV_OBJ_ID_MRP:
+		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+		err = dsa_port_mrp_del(dp, SWITCHDEV_OBJ_MRP(obj));
+		break;
+	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
+		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
+			return -EOPNOTSUPP;
+		err = dsa_port_mrp_del_ring_role(dp,
+						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index db2a9b221988..4b5da89dc27a 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -372,6 +372,99 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 	return 0;
 }
 
+static bool dsa_switch_mrp_match(struct dsa_switch *ds, int port,
+				 struct dsa_notifier_mrp_info *info)
+{
+	if (ds->index == info->sw_index && port == info->port)
+		return true;
+
+	if (dsa_is_dsa_port(ds, port))
+		return true;
+
+	return false;
+}
+
+static int dsa_switch_mrp_add(struct dsa_switch *ds,
+			      struct dsa_notifier_mrp_info *info)
+{
+	int err = 0;
+	int port;
+
+	if (!ds->ops->port_mrp_add)
+		return -EOPNOTSUPP;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_mrp_match(ds, port, info)) {
+			err = ds->ops->port_mrp_add(ds, port, info->mrp);
+			if (err)
+				break;
+		}
+	}
+
+	return err;
+}
+
+static int dsa_switch_mrp_del(struct dsa_switch *ds,
+			      struct dsa_notifier_mrp_info *info)
+{
+	if (!ds->ops->port_mrp_del)
+		return -EOPNOTSUPP;
+
+	if (ds->index == info->sw_index)
+		return ds->ops->port_mrp_del(ds, info->port, info->mrp);
+
+	return 0;
+}
+
+static bool
+dsa_switch_mrp_ring_role_match(struct dsa_switch *ds, int port,
+			       struct dsa_notifier_mrp_ring_role_info *info)
+{
+	if (ds->index == info->sw_index && port == info->port)
+		return true;
+
+	if (dsa_is_dsa_port(ds, port))
+		return true;
+
+	return false;
+}
+
+static int
+dsa_switch_mrp_add_ring_role(struct dsa_switch *ds,
+			     struct dsa_notifier_mrp_ring_role_info *info)
+{
+	int err = 0;
+	int port;
+
+	if (!ds->ops->port_mrp_add)
+		return -EOPNOTSUPP;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_mrp_ring_role_match(ds, port, info)) {
+			err = ds->ops->port_mrp_add_ring_role(ds, port,
+							      info->mrp);
+			if (err)
+				break;
+		}
+	}
+
+	return err;
+}
+
+static int
+dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
+			     struct dsa_notifier_mrp_ring_role_info *info)
+{
+	if (!ds->ops->port_mrp_del)
+		return -EOPNOTSUPP;
+
+	if (ds->index == info->sw_index)
+		return ds->ops->port_mrp_del_ring_role(ds, info->port,
+						       info->mrp);
+
+	return 0;
+}
+
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
@@ -427,6 +520,18 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_TAG_PROTO:
 		err = dsa_switch_change_tag_proto(ds, info);
 		break;
+	case DSA_NOTIFIER_MRP_ADD:
+		err = dsa_switch_mrp_add(ds, info);
+		break;
+	case DSA_NOTIFIER_MRP_DEL:
+		err = dsa_switch_mrp_del(ds, info);
+		break;
+	case DSA_NOTIFIER_MRP_ADD_RING_ROLE:
+		err = dsa_switch_mrp_add_ring_role(ds, info);
+		break;
+	case DSA_NOTIFIER_MRP_DEL_RING_ROLE:
+		err = dsa_switch_mrp_del_ring_role(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.27.0


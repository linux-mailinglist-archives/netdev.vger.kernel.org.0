Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED21B27FD77
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732207AbgJAKdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:33:31 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21343 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732150AbgJAKdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601548392; x=1633084392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v9RWNVkU7uOPL8JOS/0jPuHZ+/LWn2COnY2+d5vrWbk=;
  b=zNu/LRIz3r7/XGxFKicbeVxSgig7fH74fbgijiJ5ACoFG6VhK3sRBP6f
   MoryPrM3vfTnqMGy7SstTtMZ2xflHgwJmXGjhNQpBLwesBro9aAsJTRHp
   b+Lt8XWPvQddeqMuD4wNyneX+DABAW+nmfhxei9q7QkI2W5qrAWcl7xqM
   Cjq6Dq98PcMFy3Uv3JNsjoi19JCCD7wsIxFqB5/5dn5jrNqNCzqOMhsby
   3kQiZe021CXYMz1FaUwrwBSis+1CBGWjveRIHA0Ca/A4lK3SvZRxMkHAJ
   aN7McGkkUTJoQLOJQQMA+sflnvAPMIa9yUHdAWGDIY8GINx95kebOEIP6
   g==;
IronPort-SDR: /poEVgRSu8F080Sw4grlKb30E5vP8YR9O56R0+KF/PRLAUwHPbnwk+c6OGWWcKxCHFko4A5GUn
 hejm/Orjy1vgJLk9WpgV6Ef0LgWWh+EKa8/U9eRaU5+fobmQe84k1Qemyf7xH1OrCpxs/lRflG
 3wXMDd+g8G7QBd7/5fVYOQdqOgD+i0GgP/mWn7eci6ON7wOS5hzyV9sKJlYaqpWZLQV4HfLvsO
 wCy1WzqV2ReUTa22PfS/hE4FhK4ITZCddXWImpDVDMkbC48cQcRaGueKj/CqNJEU2SEZ8XU42S
 4Fg=
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="88772465"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Oct 2020 03:33:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 03:32:36 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 1 Oct 2020 03:32:34 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [net-next v2 10/11] bridge: switchdev: cfm: switchdev interface implementation
Date:   Thu, 1 Oct 2020 10:30:18 +0000
Message-ID: <20201001103019.1342470-11-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the definition of the CFM switchdev interface.

The interface consist of these objects:
    SWITCHDEV_OBJ_ID_MEP_CFM,
    SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM,
    SWITCHDEV_OBJ_ID_CC_CONFIG_CFM,
    SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM,
    SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM,
    SWITCHDEV_OBJ_ID_MEP_STATUS_CFM,
    SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM

MEP instance add/del
    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_MEP_CFM)
    switchdev_port_obj_del(SWITCHDEV_OBJ_ID_MEP_CFM)

MEP cofigure
    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM)

MEP CC cofigure
    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_CONFIG_CFM)

Peer MEP add/del
    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM)
    switchdev_port_obj_del(SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM)

Start/stop CCM transmission
    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM)

Get MEP status
	switchdev_port_obj_get(SWITCHDEV_OBJ_ID_MEP_STATUS_CFM)

Get Peer MEP status
	switchdev_port_obj_get(SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM)

Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
---
 include/linux/if_bridge.h |  13 +++++
 include/net/switchdev.h   | 115 ++++++++++++++++++++++++++++++++++++++
 net/switchdev/switchdev.c |  54 ++++++++++++++++++
 3 files changed, 182 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 556caed00258..5476880319ae 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -155,4 +155,17 @@ br_port_flag_is_set(const struct net_device *dev, unsigned long flag)
 }
 #endif
 
+#if IS_ENABLED(CONFIG_BRIDGE_CFM)
+#define BR_CFM_EVENT_CCM_DEFECT  (1<<0)
+
+struct br_cfm_notif_info {
+	u32 instance;
+	u32 peer_mep;
+	u32 events;
+};
+
+/* Function to be called from CFM switchdev driver to notify change in status */
+void br_cfm_notification(struct net_device *dev, const struct br_cfm_notif_info *const notif_info);
+#endif
+
 #endif
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 53e8b4994296..cd5194cd54d0 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -11,6 +11,9 @@
 #include <linux/notifier.h>
 #include <linux/list.h>
 #include <net/ip_fib.h>
+#include <uapi/linux/cfm_bridge.h>
+#include "../net/bridge/br_private.h"
+#include "../net/bridge/br_private_cfm.h"
 
 #define SWITCHDEV_F_NO_RECURSE		BIT(0)
 #define SWITCHDEV_F_SKIP_EOPNOTSUPP	BIT(1)
@@ -81,6 +84,15 @@ enum switchdev_obj_id {
 	SWITCHDEV_OBJ_ID_IN_STATE_MRP,
 
 #endif
+#if IS_ENABLED(CONFIG_BRIDGE_CFM)
+	SWITCHDEV_OBJ_ID_MEP_CFM,
+	SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM,
+	SWITCHDEV_OBJ_ID_CC_CONFIG_CFM,
+	SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM,
+	SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM,
+	SWITCHDEV_OBJ_ID_MEP_STATUS_CFM,
+	SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM
+#endif
 };
 
 struct switchdev_obj {
@@ -112,6 +124,97 @@ struct switchdev_obj_port_mdb {
 #define SWITCHDEV_OBJ_PORT_MDB(OBJ) \
 	container_of((OBJ), struct switchdev_obj_port_mdb, obj)
 
+#if IS_ENABLED(CONFIG_BRIDGE_CFM)
+/* SWITCHDEV_OBJ_ID_MEP_CFM */
+struct switchdev_obj_cfm_mep {
+	struct switchdev_obj obj;
+	u32 instance;
+	enum br_cfm_domain domain; /* Domain for this MEP */
+	enum br_cfm_mep_direction direction; /* Up or Down MEP direction */
+	struct net_device *port; /* Residence port */
+};
+
+#define SWITCHDEV_OBJ_CFM_MEP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_cfm_mep, obj)
+
+/* SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM */
+struct switchdev_obj_cfm_mep_config_set {
+	struct switchdev_obj obj;
+	u32 instance;
+	u32 mdlevel;
+	u32 mepid;
+	struct mac_addr unicast_mac;
+};
+
+#define SWITCHDEV_OBJ_CFM_MEP_CONFIG_SET(OBJ) \
+	container_of((OBJ), struct switchdev_obj_cfm_mep_config_set, obj)
+
+#define SWITCHDEV_CFM_MAID_LENGTH	48
+
+/* SWITCHDEV_OBJ_ID_CC_CONFIG_CFM */
+struct switchdev_obj_cfm_cc_config_set {
+	struct switchdev_obj obj;
+	u32 instance;
+	struct br_cfm_maid maid;
+	enum br_cfm_ccm_interval interval;
+	bool enable;
+};
+
+#define SWITCHDEV_OBJ_CFM_CC_CONFIG_SET(OBJ) \
+	container_of((OBJ), struct switchdev_obj_cfm_cc_config_set, obj)
+
+/* SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM */
+struct switchdev_obj_cfm_cc_peer_mep {
+	struct switchdev_obj obj;
+	u32 instance;
+	u32 peer_mep_id;
+};
+
+#define SWITCHDEV_OBJ_CFM_CC_PEER_MEP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_cfm_cc_peer_mep, obj)
+
+/* SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM */
+struct switchdev_obj_cfm_cc_ccm_tx {
+	struct switchdev_obj obj;
+	u32 instance;
+	u32 period;
+	struct sk_buff *skb;
+	enum br_cfm_ccm_interval interval;
+};
+
+#define SWITCHDEV_OBJ_CFM_CC_CCM_TX(OBJ) \
+	container_of((OBJ), struct switchdev_obj_cfm_cc_ccm_tx, obj)
+
+/* SWITCHDEV_OBJ_ID_MEP_STATUS_CFM */
+struct switchdev_obj_cfm_mep_status_get {
+	struct switchdev_obj obj;
+	u32 instance;
+	bool clear;
+	bool opcode_unexp_seen;
+	bool version_unexp_seen;
+	bool rx_level_low_seen;
+};
+
+#define SWITCHDEV_OBJ_CFM_MEP_STATUS_get(OBJ) \
+	container_of((OBJ), struct switchdev_obj_cfm_mep_status_get, obj)
+
+/* SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM */
+struct switchdev_obj_cfm_cc_peer_status_get {
+	struct switchdev_obj obj;
+	u32 instance;
+	bool clear;
+	u8 port_tlv_value;
+	u8 if_tlv_value;
+	bool ccm_defect;
+	bool rdi;
+	bool seen;
+	bool tlv_seen;
+	bool seq_unexp_seen;
+};
+#define SWITCHDEV_OBJ_CFM_CC_PEER_STATUS_get(OBJ) \
+	container_of((OBJ), struct switchdev_obj_cfm_cc_peer_status_get, obj)
+
+#endif
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 /* SWITCHDEV_OBJ_ID_MRP */
@@ -208,6 +311,7 @@ enum switchdev_notifier_type {
 	SWITCHDEV_PORT_OBJ_ADD, /* Blocking. */
 	SWITCHDEV_PORT_OBJ_DEL, /* Blocking. */
 	SWITCHDEV_PORT_ATTR_SET, /* May be blocking . */
+	SWITCHDEV_PORT_OBJ_GET, /* Blocking */
 
 	SWITCHDEV_VXLAN_FDB_ADD_TO_BRIDGE,
 	SWITCHDEV_VXLAN_FDB_DEL_TO_BRIDGE,
@@ -265,6 +369,9 @@ int switchdev_port_obj_add(struct net_device *dev,
 			   struct netlink_ext_ack *extack);
 int switchdev_port_obj_del(struct net_device *dev,
 			   const struct switchdev_obj *obj);
+int switchdev_port_obj_get(struct net_device *dev,
+			   const struct switchdev_obj *obj,
+			   struct netlink_ext_ack *extack);
 
 int register_switchdev_notifier(struct notifier_block *nb);
 int unregister_switchdev_notifier(struct notifier_block *nb);
@@ -326,6 +433,14 @@ static inline int switchdev_port_obj_del(struct net_device *dev,
 	return -EOPNOTSUPP;
 }
 
+int switchdev_port_obj_get(struct net_device *dev,
+			   const struct switchdev_obj *obj,
+			   struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+
 static inline int register_switchdev_notifier(struct notifier_block *nb)
 {
 	return 0;
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 865f3e037425..fefb05b885e0 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -372,6 +372,60 @@ int switchdev_port_obj_del(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(switchdev_port_obj_del);
 
+static int switchdev_port_obj_get_now(struct net_device *dev,
+				      const struct switchdev_obj *obj,
+				      struct netlink_ext_ack *extack)
+{
+	struct switchdev_trans trans;
+	int err;
+
+	/* Phase I: prepare for obj add. Driver/device should fail
+	 * here if there are going to be issues in the commit phase,
+	 * such as lack of resources or support.  The driver/device
+	 * should reserve resources needed for the commit phase here,
+	 * but should not commit the obj.
+	 */
+
+	trans.ph_prepare = true;
+	err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_GET,
+					dev, obj, &trans, extack);
+	if (err)
+		return err;
+
+	/* Phase II: commit obj add.  This cannot fail as a fault
+	 * of driver/device.  If it does, it's a bug in the driver/device
+	 * because the driver said everythings was OK in phase I.
+	 */
+
+	trans.ph_prepare = false;
+	err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_GET,
+					dev, obj, &trans, extack);
+	WARN(err, "%s: Commit of object (id=%d) failed.\n", dev->name, obj->id);
+
+	return err;
+}
+
+/**
+ *	switchdev_port_obj_get - Get information from a port object
+ *	It is expected that the driver fill in information in the
+ *	obj structure.
+ *
+ *	@dev: port device
+ *	@obj: object to get information from
+ *	@extack: netlink extended ack
+ *
+ *	Use a 2-phase prepare-commit transaction model to ensure
+ *	system is not left in a partially updated state due to
+ *	failure from driver/device.
+ */
+int switchdev_port_obj_get(struct net_device *dev,
+			   const struct switchdev_obj *obj,
+			   struct netlink_ext_ack *extack)
+{
+	return switchdev_port_obj_get_now(dev, obj, extack);
+}
+EXPORT_SYMBOL_GPL(switchdev_port_obj_get);
+
 static ATOMIC_NOTIFIER_HEAD(switchdev_notif_chain);
 static BLOCKING_NOTIFIER_HEAD(switchdev_blocking_notif_chain);
 
-- 
2.28.0


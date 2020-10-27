Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89D029A8F1
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896717AbgJ0KEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:04:30 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:55627 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896236AbgJ0KE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603793067; x=1635329067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qd49xAApZTkzYOVoxjm5LXJszDu4W4138Fr1owQ3+aM=;
  b=GIADznS0w7GAk3Tf2F9kuuEOpdtQfXlxHlBX/ZUGKyDv0Sgbw3YzAePQ
   ju4GUrYGlFvzc7w/W1zsNRtfsWKpYGIzr3GS1XoKO+JN3WfWWCwwRx8w5
   N3eJLLDCp0/GLFGKccaDeKYw81zyrgUbKAVoq7qWx6bhVF5ZdIkrjSLTK
   iA7JZ2fTXJ91F+kfufogNMyGnas1APSSOuVoRcZ8bmm4iU+O7MRFEpxDX
   tWe/80kKFV5wbLRzL4wwV5nQDcJjiUbxlEUlN7dSACBLPKNsNRgOIdOlr
   om4Z6idPxlPxGpbvbxsGzD+fBKn+mjgHJpiozJop9pVTBNh9BewjLRSBE
   A==;
IronPort-SDR: tDcYmkNFWzYL2EiLObMvwLRfOv7f1YMgEs+BeNu4l+5nUjdtLF2m8jhORz3M1/KCoCVxGtzyFu
 LiCNqLjdvuOsS1vswM72ANalwWkp75gDe6QIV06uthVKorP7dPqwmJ3sZHG7hba9D157j0U+rQ
 dZtGK1Oyq1oNqSvkdMRo9mWiappBZ2ZgBjyqxTJ+MPnNQG57R6UaZllYs2N/UPh2RtWgtwCi05
 000qxlCgbm4plcwaRBhpxLLgpv4g72bln05UQMhTBbo7IHho7Vott3Bmxy03q8nK7AZBoMMLo8
 DmI=
X-IronPort-AV: E=Sophos;i="5.77,423,1596524400"; 
   d="scan'208";a="91504959"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2020 03:04:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 27 Oct 2020 03:04:24 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 27 Oct 2020 03:04:22 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v7 04/10] bridge: cfm: Kernel space implementation of CFM. MEP create/delete.
Date:   Tue, 27 Oct 2020 10:02:45 +0000
Message-ID: <20201027100251.3241719-5-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
References: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first commit of the implementation of the CFM protocol
according to 802.1Q section 12.14.

It contains MEP instance create, delete and configuration.

Connectivity Fault Management (CFM) comprises capabilities for
detecting, verifying, and isolating connectivity failures in
Virtual Bridged Networks. These capabilities can be used in
networks operated by multiple independent organizations, each
with restricted management access to each others equipment.

CFM functions are partitioned as follows:
    - Path discovery
    - Fault detection
    - Fault verification and isolation
    - Fault notification
    - Fault recovery

Interface consists of these functions:
br_cfm_mep_create()
br_cfm_mep_delete()
br_cfm_mep_config_set()
br_cfm_cc_config_set()
br_cfm_cc_peer_mep_add()
br_cfm_cc_peer_mep_remove()

A MEP instance is created by br_cfm_mep_create()
    -It is the Maintenance association End Point
     described in 802.1Q section 19.2.
    -It is created on a specific level (1-7) and is assuring
     that no CFM frames are passing through this MEP on lower levels.
    -It initiates and validates CFM frames on its level.
    -It can only exist on a port that is related to a bridge.
    -Attributes given cannot be changed until the instance is
     deleted.

A MEP instance can be deleted by br_cfm_mep_delete().

A created MEP instance has attributes that can be
configured by br_cfm_mep_config_set().

A MEP Continuity Check feature can be configured by
br_cfm_cc_config_set()
    The Continuity Check Receiver state machine can be
    enabled and disabled.
    According to 802.1Q section 19.2.8

A MEP can have Peer MEPs added and removed by
br_cfm_cc_peer_mep_add() and br_cfm_cc_peer_mep_remove()
    The Continuity Check feature can maintain connectivity
    status on each added Peer MEP.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/cfm_bridge.h |  23 +++
 net/bridge/Makefile             |   2 +
 net/bridge/br_cfm.c             | 260 ++++++++++++++++++++++++++++++++
 net/bridge/br_if.c              |   1 +
 net/bridge/br_private.h         |  10 ++
 net/bridge/br_private_cfm.h     |  61 ++++++++
 6 files changed, 357 insertions(+)
 create mode 100644 include/uapi/linux/cfm_bridge.h
 create mode 100644 net/bridge/br_cfm.c
 create mode 100644 net/bridge/br_private_cfm.h

diff --git a/include/uapi/linux/cfm_bridge.h b/include/uapi/linux/cfm_bridge.h
new file mode 100644
index 000000000000..a262a8c0e085
--- /dev/null
+++ b/include/uapi/linux/cfm_bridge.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_CFM_BRIDGE_H_
+#define _UAPI_LINUX_CFM_BRIDGE_H_
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+
+#define CFM_MAID_LENGTH		48
+
+/* MEP domain */
+enum br_cfm_domain {
+	BR_CFM_PORT,
+	BR_CFM_VLAN,
+};
+
+/* MEP direction */
+enum br_cfm_mep_direction {
+	BR_CFM_MEP_DIRECTION_DOWN,
+	BR_CFM_MEP_DIRECTION_UP,
+};
+
+#endif
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index ccb394236fbd..ddc0a9192348 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -27,3 +27,5 @@ bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
 obj-$(CONFIG_NETFILTER) += netfilter/
 
 bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp_switchdev.o br_mrp.o br_mrp_netlink.o
+
+bridge-$(CONFIG_BRIDGE_CFM)	+= br_cfm.o
diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
new file mode 100644
index 000000000000..42f35109681a
--- /dev/null
+++ b/net/bridge/br_cfm.c
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/cfm_bridge.h>
+#include <uapi/linux/cfm_bridge.h>
+#include "br_private_cfm.h"
+
+static struct br_cfm_mep *br_mep_find(struct net_bridge *br, u32 instance)
+{
+	struct br_cfm_mep *mep;
+
+	hlist_for_each_entry(mep, &br->mep_list, head)
+		if (mep->instance == instance)
+			return mep;
+
+	return NULL;
+}
+
+static struct br_cfm_mep *br_mep_find_ifindex(struct net_bridge *br,
+					      u32 ifindex)
+{
+	struct br_cfm_mep *mep;
+
+	hlist_for_each_entry_rcu(mep, &br->mep_list, head,
+				 lockdep_rtnl_is_held())
+		if (mep->create.ifindex == ifindex)
+			return mep;
+
+	return NULL;
+}
+
+static struct br_cfm_peer_mep *br_peer_mep_find(struct br_cfm_mep *mep,
+						u32 mepid)
+{
+	struct br_cfm_peer_mep *peer_mep;
+
+	hlist_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head,
+				 lockdep_rtnl_is_held())
+		if (peer_mep->mepid == mepid)
+			return peer_mep;
+
+	return NULL;
+}
+
+static struct net_bridge_port *br_mep_get_port(struct net_bridge *br,
+					       u32 ifindex)
+{
+	struct net_bridge_port *port;
+
+	list_for_each_entry(port, &br->port_list, list)
+		if (port->dev->ifindex == ifindex)
+			return port;
+
+	return NULL;
+}
+
+int br_cfm_mep_create(struct net_bridge *br,
+		      const u32 instance,
+		      struct br_cfm_mep_create *const create,
+		      struct netlink_ext_ack *extack)
+{
+	struct net_bridge_port *p;
+	struct br_cfm_mep *mep;
+
+	ASSERT_RTNL();
+
+	if (create->domain == BR_CFM_VLAN) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "VLAN domain not supported");
+		return -EINVAL;
+	}
+	if (create->domain != BR_CFM_PORT) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid domain value");
+		return -EINVAL;
+	}
+	if (create->direction == BR_CFM_MEP_DIRECTION_UP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Up-MEP not supported");
+		return -EINVAL;
+	}
+	if (create->direction != BR_CFM_MEP_DIRECTION_DOWN) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid direction value");
+		return -EINVAL;
+	}
+	p = br_mep_get_port(br, create->ifindex);
+	if (!p) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port is not related to bridge");
+		return -EINVAL;
+	}
+	mep = br_mep_find(br, instance);
+	if (mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance already exists");
+		return -EEXIST;
+	}
+
+	/* In PORT domain only one instance can be created per port */
+	if (create->domain == BR_CFM_PORT) {
+		mep = br_mep_find_ifindex(br, create->ifindex);
+		if (mep) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only one Port MEP on a port allowed");
+			return -EINVAL;
+		}
+	}
+
+	mep = kzalloc(sizeof(*mep), GFP_KERNEL);
+	if (!mep)
+		return -ENOMEM;
+
+	mep->create = *create;
+	mep->instance = instance;
+	rcu_assign_pointer(mep->b_port, p);
+
+	INIT_HLIST_HEAD(&mep->peer_mep_list);
+
+	hlist_add_tail_rcu(&mep->head, &br->mep_list);
+
+	return 0;
+}
+
+static void mep_delete_implementation(struct net_bridge *br,
+				      struct br_cfm_mep *mep)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct hlist_node *n_store;
+
+	ASSERT_RTNL();
+
+	/* Empty and free peer MEP list */
+	hlist_for_each_entry_safe(peer_mep, n_store, &mep->peer_mep_list, head) {
+		hlist_del_rcu(&peer_mep->head);
+		kfree_rcu(peer_mep, rcu);
+	}
+
+	RCU_INIT_POINTER(mep->b_port, NULL);
+	hlist_del_rcu(&mep->head);
+	kfree_rcu(mep, rcu);
+}
+
+int br_cfm_mep_delete(struct net_bridge *br,
+		      const u32 instance,
+		      struct netlink_ext_ack *extack)
+{
+	struct br_cfm_mep *mep;
+
+	ASSERT_RTNL();
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance does not exists");
+		return -ENOENT;
+	}
+
+	mep_delete_implementation(br, mep);
+
+	return 0;
+}
+
+int br_cfm_mep_config_set(struct net_bridge *br,
+			  const u32 instance,
+			  const struct br_cfm_mep_config *const config,
+			  struct netlink_ext_ack *extack)
+{
+	struct br_cfm_mep *mep;
+
+	ASSERT_RTNL();
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance does not exists");
+		return -ENOENT;
+	}
+
+	mep->config = *config;
+
+	return 0;
+}
+
+int br_cfm_cc_peer_mep_add(struct net_bridge *br, const u32 instance,
+			   u32 mepid,
+			   struct netlink_ext_ack *extack)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct br_cfm_mep *mep;
+
+	ASSERT_RTNL();
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance does not exists");
+		return -ENOENT;
+	}
+
+	peer_mep = br_peer_mep_find(mep, mepid);
+	if (peer_mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Peer MEP-ID already exists");
+		return -EEXIST;
+	}
+
+	peer_mep = kzalloc(sizeof(*peer_mep), GFP_KERNEL);
+	if (!peer_mep)
+		return -ENOMEM;
+
+	peer_mep->mepid = mepid;
+	peer_mep->mep = mep;
+
+	hlist_add_tail_rcu(&peer_mep->head, &mep->peer_mep_list);
+
+	return 0;
+}
+
+int br_cfm_cc_peer_mep_remove(struct net_bridge *br, const u32 instance,
+			      u32 mepid,
+			      struct netlink_ext_ack *extack)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct br_cfm_mep *mep;
+
+	ASSERT_RTNL();
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance does not exists");
+		return -ENOENT;
+	}
+
+	peer_mep = br_peer_mep_find(mep, mepid);
+	if (!peer_mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Peer MEP-ID does not exists");
+		return -ENOENT;
+	}
+
+	hlist_del_rcu(&peer_mep->head);
+	kfree_rcu(peer_mep, rcu);
+
+	return 0;
+}
+
+/* Deletes the CFM instances on a specific bridge port
+ */
+void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *port)
+{
+	struct hlist_node *n_store;
+	struct br_cfm_mep *mep;
+
+	ASSERT_RTNL();
+
+	hlist_for_each_entry_safe(mep, n_store, &br->mep_list, head)
+		if (mep->create.ifindex == port->dev->ifindex)
+			mep_delete_implementation(br, mep);
+}
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a0e9a7937412..f7d2f472ae24 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -334,6 +334,7 @@ static void del_nbp(struct net_bridge_port *p)
 	spin_unlock_bh(&br->lock);
 
 	br_mrp_port_del(br, p);
+	br_cfm_port_del(br, p);
 
 	br_ifinfo_notify(RTM_DELLINK, NULL, p);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 90ead48fa762..f7c41380de4d 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1459,6 +1459,16 @@ static inline int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
 
 #endif
 
+/* br_mrp.c */
+#if IS_ENABLED(CONFIG_BRIDGE_CFM)
+void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *p);
+#else
+static inline void br_cfm_port_del(struct net_bridge *br,
+				   struct net_bridge_port *p)
+{
+}
+#endif
+
 /* br_netlink.c */
 extern struct rtnl_link_ops br_link_ops;
 int br_netlink_init(void);
diff --git a/net/bridge/br_private_cfm.h b/net/bridge/br_private_cfm.h
new file mode 100644
index 000000000000..40fe982added
--- /dev/null
+++ b/net/bridge/br_private_cfm.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _BR_PRIVATE_CFM_H_
+#define _BR_PRIVATE_CFM_H_
+
+#include "br_private.h"
+#include <uapi/linux/cfm_bridge.h>
+
+struct br_cfm_mep_create {
+	enum br_cfm_domain domain; /* Domain for this MEP */
+	enum br_cfm_mep_direction direction; /* Up or Down MEP direction */
+	u32 ifindex; /* Residence port */
+};
+
+int br_cfm_mep_create(struct net_bridge *br,
+		      const u32 instance,
+		      struct br_cfm_mep_create *const create,
+		      struct netlink_ext_ack *extack);
+
+int br_cfm_mep_delete(struct net_bridge *br,
+		      const u32 instance,
+		      struct netlink_ext_ack *extack);
+
+struct br_cfm_mep_config {
+	u32 mdlevel;
+	u32 mepid; /* MEPID for this MEP */
+	struct mac_addr unicast_mac; /* The MEP unicast MAC */
+};
+
+int br_cfm_mep_config_set(struct net_bridge *br,
+			  const u32 instance,
+			  const struct br_cfm_mep_config *const config,
+			  struct netlink_ext_ack *extack);
+
+int br_cfm_cc_peer_mep_add(struct net_bridge *br, const u32 instance,
+			   u32 peer_mep_id,
+			   struct netlink_ext_ack *extack);
+int br_cfm_cc_peer_mep_remove(struct net_bridge *br, const u32 instance,
+			      u32 peer_mep_id,
+			      struct netlink_ext_ack *extack);
+
+struct br_cfm_mep {
+	/* list header of MEP instances */
+	struct hlist_node		head;
+	u32				instance;
+	struct br_cfm_mep_create	create;
+	struct br_cfm_mep_config	config;
+	/* List of multiple peer MEPs */
+	struct hlist_head		peer_mep_list;
+	struct net_bridge_port __rcu	*b_port;
+	struct rcu_head			rcu;
+};
+
+struct br_cfm_peer_mep {
+	struct hlist_node		head;
+	struct br_cfm_mep		*mep;
+	u32				mepid;
+	struct rcu_head			rcu;
+};
+
+#endif /* _BR_PRIVATE_CFM_H_ */
-- 
2.28.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2158627FD63
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbgJAKcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:32:51 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21293 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601548367; x=1633084367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oLfBCs4DdRzs55Fk1booRQnUlW1iyD0RgKQUn1hsQw4=;
  b=mwYEJ6JPmVhtwJ6YAhgqB4YaQtIRFtiSXg86XzPqb6gvv4GRSZvQT7Aj
   IgGgkacPolFuV8dU27GXiBt56f8pUw1PF5/FDiDvPKPqBQ4WFmG3AzyNe
   /CruXA3EgPO7doMamtU8czj8hCP9FOkp/Piy49HeOdf2eK4Hw7C05zyn5
   O2mtJAqDeatxAjplyFcX3LPTK1FaooEbSUGYx9cEnzLmgph8OTQTEXtY/
   2dLBdXma2nUK6tpFWOGT6YN3f/fNdfdNUWetgjTJTfJLqSly6lNVZ02ZM
   kodPEew1cQn5j82QsUrDl2LVic34QDW4IFs++E5GIYV672v4DhJWJXrWk
   Q==;
IronPort-SDR: hlg+M5uU+atSbqmVWAYAXkPM00HiIChzjGMXdBRUSd3IRSwqWv41bxeYVLfTttIB/Rrc3wJU9n
 0RviX/AJjkRU8hgN7boVwrD39i/4XEOLmUD71wRXJJCiVNQl56kJj2vbTAaYdHZyaNYVNHnkyb
 7f3rweRVXo9bOSweyTZINmgTlrtZsS7t3DLI5ZeuIyyVnuVsS5UWA3ur0ObypvKAG7GUh/oVW2
 3PB04/QO3lvYVnj5z/9tGxgQBJlyUn0Z062ulC3tPkIbp4KexLCO+fR+s4mk0QsYt4Uhqt1DD+
 3yQ=
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="88772421"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Oct 2020 03:32:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 03:32:20 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 1 Oct 2020 03:32:18 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [net-next v2 04/11] bridge: cfm: Kernel space implementation of CFM.
Date:   Thu, 1 Oct 2020 10:30:12 +0000
Message-ID: <20201001103019.1342470-5-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first commit of the implementation of the CFM protocol
according to 802.1Q section 12.14.

Connectivity Fault Management (CFM) comprises capabilities for
detecting, verifying, and isolating connectivity failures in
Virtual Bridged Networks. These capabilities can be used in
networks operated by multiple independent organizations, each
with restricted management access to each other<E2><80><99>s equipment.

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

Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
---
 include/uapi/linux/cfm_bridge.h |  23 +++
 net/bridge/Makefile             |   2 +
 net/bridge/br_cfm.c             | 263 ++++++++++++++++++++++++++++++++
 net/bridge/br_private_cfm.h     |  61 ++++++++
 4 files changed, 349 insertions(+)
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
index 000000000000..86d6e7b73375
--- /dev/null
+++ b/net/bridge/br_cfm.c
@@ -0,0 +1,263 @@
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
+
+	ASSERT_RTNL();
+
+	/* Empty and free peer MEP list */
+	hlist_for_each_entry(peer_mep, &mep->peer_mep_list, head) {
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
+	if (config->mdlevel > 7) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MD level is invalid");
+		return -EINVAL;
+	}
+	/* The MEP-ID is a 13 bit field in the CCM PDU identifying the MEP */
+	if (config->mepid > 0x1FFF) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP-ID is invalid");
+		return -EINVAL;
+	}
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
+	/* The MEP-ID is a 13 bit field in the CCM PDU identifying the MEP */
+	if (mepid > 0x1FFF) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP-ID is invalid");
+		return -EINVAL;
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0911E3F2C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbgE0Kfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:35:45 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:17139 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgE0Kfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:35:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590575744; x=1622111744;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UePifC7rL+727FhEsO0WvS10foZBhExOhvkkRSihpkw=;
  b=B4aX0H3ZKvkfYdSPilTlAWPBXKE9t3E4zH19ZrjbJYDjiGMvhSFvoAoM
   v9XZlcQ0yLoWEfjgPq+zDAiRkLu0iSNQ6QTHQ6qQjiCdGcRm7X9bdnFGE
   ZH06m+ZxTodm5KWowidTqPo1rqPU1DeR4pf7EmfM+eRznnPRGTgl++H1U
   ewwvnl3uz6ejKEj2KeaNi5o+/znzCYTg5AT58Acha8wc7zw81YuPz68z2
   hxlH0UAo1v1HtMOTfU+wMHhdNL07k/AZyRPky2UAwlTEfS8MMKLEy+QSw
   57k+69EEF5MPniJnPwqkW5aKK34Q3+aN10cZQMjuuTOz/l+2jYREHpoxX
   g==;
IronPort-SDR: /6KI3JxrJyNnAsLNsnl+VGoMMnsukO+UQUFoVmJ7T+K1aUeocVcbSXI3LqwsjPwlPwP0zyuCiD
 PiXFym3UdT2Zjcn5lus8bmg1nob6RXVVi04jIFAJaiZalBTmr0qE0wea/BqT7SWLgESwOS0O+x
 GpL8DZ7EM30+b+rzJ3E6/Lj4wkgWJV4mJ5jAia5lO+N+K+R58g3U6rpEmHwl6wBSe7XH9EveJi
 PowpySml+yc7/5RlOo5WW5/avGpIWAnvx+Yrn6e2pVASWnrLlavxhme6EE4v3fwgHbgY9mOWqo
 BHQ=
X-IronPort-AV: E=Sophos;i="5.73,441,1583218800"; 
   d="scan'208";a="81178328"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 May 2020 03:35:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 May 2020 03:35:36 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 27 May 2020 03:35:43 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>, <mkubecek@suse.cz>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] bridge: mrp: Rework the MRP netlink interface
Date:   Wed, 27 May 2020 12:34:30 +0000
Message-ID: <20200527123430.616826-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch reworks the MRP netlink interface. Before, each attribute
represented a binary structure which made it hard to be extended.
Therefore update the MRP netlink interface such that each existing
attribute to be a nested attribute which contains the fields of the
binary structures.
In this way the MRP netlink interface can be extended without breaking
the backwards compatibility. It is also using strict checking for
attributes under the MRP top attribute.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---

v2:
 - make static br_mrp_*_parse functions
 - return meaningful error messages in case attributes are missing

---
 include/uapi/linux/if_bridge.h |  64 +++++++-
 net/bridge/br_mrp.c            |   8 +-
 net/bridge/br_mrp_netlink.c    | 266 ++++++++++++++++++++++++++++-----
 net/bridge/br_private_mrp.h    |   2 +-
 4 files changed, 290 insertions(+), 50 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index bd8c95488f161..5a43eb86c93bf 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -169,17 +169,69 @@ enum {
 	__IFLA_BRIDGE_MRP_MAX,
 };
 
+#define IFLA_BRIDGE_MRP_MAX (__IFLA_BRIDGE_MRP_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_MRP_INSTANCE_UNSPEC,
+	IFLA_BRIDGE_MRP_INSTANCE_RING_ID,
+	IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX,
+	IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX,
+	__IFLA_BRIDGE_MRP_INSTANCE_MAX,
+};
+
+#define IFLA_BRIDGE_MRP_INSTANCE_MAX (__IFLA_BRIDGE_MRP_INSTANCE_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_MRP_PORT_STATE_UNSPEC,
+	IFLA_BRIDGE_MRP_PORT_STATE_STATE,
+	__IFLA_BRIDGE_MRP_PORT_STATE_MAX,
+};
+
+#define IFLA_BRIDGE_MRP_PORT_STATE_MAX (__IFLA_BRIDGE_MRP_PORT_STATE_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_MRP_PORT_ROLE_UNSPEC,
+	IFLA_BRIDGE_MRP_PORT_ROLE_ROLE,
+	__IFLA_BRIDGE_MRP_PORT_ROLE_MAX,
+};
+
+#define IFLA_BRIDGE_MRP_PORT_ROLE_MAX (__IFLA_BRIDGE_MRP_PORT_ROLE_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_MRP_RING_STATE_UNSPEC,
+	IFLA_BRIDGE_MRP_RING_STATE_RING_ID,
+	IFLA_BRIDGE_MRP_RING_STATE_STATE,
+	__IFLA_BRIDGE_MRP_RING_STATE_MAX,
+};
+
+#define IFLA_BRIDGE_MRP_RING_STATE_MAX (__IFLA_BRIDGE_MRP_RING_STATE_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_MRP_RING_ROLE_UNSPEC,
+	IFLA_BRIDGE_MRP_RING_ROLE_RING_ID,
+	IFLA_BRIDGE_MRP_RING_ROLE_ROLE,
+	__IFLA_BRIDGE_MRP_RING_ROLE_MAX,
+};
+
+#define IFLA_BRIDGE_MRP_RING_ROLE_MAX (__IFLA_BRIDGE_MRP_RING_ROLE_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_MRP_START_TEST_UNSPEC,
+	IFLA_BRIDGE_MRP_START_TEST_RING_ID,
+	IFLA_BRIDGE_MRP_START_TEST_INTERVAL,
+	IFLA_BRIDGE_MRP_START_TEST_MAX_MISS,
+	IFLA_BRIDGE_MRP_START_TEST_PERIOD,
+	__IFLA_BRIDGE_MRP_START_TEST_MAX,
+};
+
+#define IFLA_BRIDGE_MRP_START_TEST_MAX (__IFLA_BRIDGE_MRP_START_TEST_MAX - 1)
+
 struct br_mrp_instance {
 	__u32 ring_id;
 	__u32 p_ifindex;
 	__u32 s_ifindex;
 };
 
-struct br_mrp_port_role {
-	__u32 ring_id;
-	__u32 role;
-};
-
 struct br_mrp_ring_state {
 	__u32 ring_id;
 	__u32 ring_state;
@@ -197,8 +249,6 @@ struct br_mrp_start_test {
 	__u32 period;
 };
 
-#define IFLA_BRIDGE_MRP_MAX (__IFLA_BRIDGE_MRP_MAX - 1)
-
 struct bridge_stp_xstats {
 	__u64 transition_blk;
 	__u64 transition_fwd;
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index 528d767eb026f..8ea59504ef47a 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -376,24 +376,24 @@ int br_mrp_set_port_state(struct net_bridge_port *p,
  * note: already called with rtnl_lock
  */
 int br_mrp_set_port_role(struct net_bridge_port *p,
-			 struct br_mrp_port_role *role)
+			 enum br_mrp_port_role_type role)
 {
 	struct br_mrp *mrp;
 
 	if (!p || !(p->flags & BR_MRP_AWARE))
 		return -EINVAL;
 
-	mrp = br_mrp_find_id(p->br, role->ring_id);
+	mrp = br_mrp_find_port(p->br, p);
 
 	if (!mrp)
 		return -EINVAL;
 
-	if (role->role == BR_MRP_PORT_ROLE_PRIMARY)
+	if (role == BR_MRP_PORT_ROLE_PRIMARY)
 		rcu_assign_pointer(mrp->p_port, p);
 	else
 		rcu_assign_pointer(mrp->s_port, p);
 
-	br_mrp_port_switchdev_set_role(p, role->role);
+	br_mrp_port_switchdev_set_role(p, role);
 
 	return 0;
 }
diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index 4a08a99519b04..d9de780d2ce06 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -8,19 +8,222 @@
 
 static const struct nla_policy br_mrp_policy[IFLA_BRIDGE_MRP_MAX + 1] = {
 	[IFLA_BRIDGE_MRP_UNSPEC]	= { .type = NLA_REJECT },
-	[IFLA_BRIDGE_MRP_INSTANCE]	= { .type = NLA_EXACT_LEN,
-				    .len = sizeof(struct br_mrp_instance)},
-	[IFLA_BRIDGE_MRP_PORT_STATE]	= { .type = NLA_U32 },
-	[IFLA_BRIDGE_MRP_PORT_ROLE]	= { .type = NLA_EXACT_LEN,
-				    .len = sizeof(struct br_mrp_port_role)},
-	[IFLA_BRIDGE_MRP_RING_STATE]	= { .type = NLA_EXACT_LEN,
-				    .len = sizeof(struct br_mrp_ring_state)},
-	[IFLA_BRIDGE_MRP_RING_ROLE]	= { .type = NLA_EXACT_LEN,
-				    .len = sizeof(struct br_mrp_ring_role)},
-	[IFLA_BRIDGE_MRP_START_TEST]	= { .type = NLA_EXACT_LEN,
-				    .len = sizeof(struct br_mrp_start_test)},
+	[IFLA_BRIDGE_MRP_INSTANCE]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_MRP_PORT_STATE]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_MRP_PORT_ROLE]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_MRP_RING_STATE]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_MRP_RING_ROLE]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_MRP_START_TEST]	= { .type = NLA_NESTED },
 };
 
+static const struct nla_policy
+br_mrp_instance_policy[IFLA_BRIDGE_MRP_INSTANCE_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_INSTANCE_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_INSTANCE_RING_ID]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]	= { .type = NLA_U32 },
+};
+
+static int br_mrp_instance_parse(struct net_bridge *br, struct nlattr *attr,
+				 int cmd, struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_INSTANCE_MAX + 1];
+	struct br_mrp_instance inst;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_INSTANCE_MAX, attr,
+			       br_mrp_instance_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MRP_INSTANCE_RING_ID] ||
+	    !tb[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX] ||
+	    !tb[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing attribute: RING_ID or P_IFINDEX or S_IFINDEX");
+		return -EINVAL;
+	}
+
+	memset(&inst, 0, sizeof(inst));
+
+	inst.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_RING_ID]);
+	inst.p_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]);
+	inst.s_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]);
+
+	if (cmd == RTM_SETLINK)
+		return br_mrp_add(br, &inst);
+	else
+		return br_mrp_del(br, &inst);
+
+	return 0;
+}
+
+static const struct nla_policy
+br_mrp_port_state_policy[IFLA_BRIDGE_MRP_PORT_STATE_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_PORT_STATE_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_PORT_STATE_STATE]	= { .type = NLA_U32 },
+};
+
+static int br_mrp_port_state_parse(struct net_bridge_port *p,
+				   struct nlattr *attr,
+				   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_PORT_STATE_MAX + 1];
+	enum br_mrp_port_state_type state;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_PORT_STATE_MAX, attr,
+			       br_mrp_port_state_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MRP_PORT_STATE_STATE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing attribute: STATE");
+		return -EINVAL;
+	}
+
+	state = nla_get_u32(tb[IFLA_BRIDGE_MRP_PORT_STATE_STATE]);
+
+	return br_mrp_set_port_state(p, state);
+}
+
+static const struct nla_policy
+br_mrp_port_role_policy[IFLA_BRIDGE_MRP_PORT_ROLE_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_PORT_ROLE_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_PORT_ROLE_ROLE]	= { .type = NLA_U32 },
+};
+
+static int br_mrp_port_role_parse(struct net_bridge_port *p,
+				  struct nlattr *attr,
+				  struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_PORT_ROLE_MAX + 1];
+	enum br_mrp_port_role_type role;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_PORT_ROLE_MAX, attr,
+			       br_mrp_port_role_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MRP_PORT_ROLE_ROLE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing attribute: ROLE");
+		return -EINVAL;
+	}
+
+	role = nla_get_u32(tb[IFLA_BRIDGE_MRP_PORT_ROLE_ROLE]);
+
+	return br_mrp_set_port_role(p, role);
+}
+
+static const struct nla_policy
+br_mrp_ring_state_policy[IFLA_BRIDGE_MRP_RING_STATE_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_RING_STATE_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_RING_STATE_RING_ID]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_RING_STATE_STATE]	= { .type = NLA_U32 },
+};
+
+static int br_mrp_ring_state_parse(struct net_bridge *br, struct nlattr *attr,
+				   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_RING_STATE_MAX + 1];
+	struct br_mrp_ring_state state;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_RING_STATE_MAX, attr,
+			       br_mrp_ring_state_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MRP_RING_STATE_RING_ID] ||
+	    !tb[IFLA_BRIDGE_MRP_RING_STATE_STATE]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing attribute: RING_ID or STATE");
+		return -EINVAL;
+	}
+
+	memset(&state, 0x0, sizeof(state));
+
+	state.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_RING_STATE_RING_ID]);
+	state.ring_state = nla_get_u32(tb[IFLA_BRIDGE_MRP_RING_STATE_STATE]);
+
+	return br_mrp_set_ring_state(br, &state);
+}
+
+static const struct nla_policy
+br_mrp_ring_role_policy[IFLA_BRIDGE_MRP_RING_ROLE_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_RING_ROLE_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_RING_ROLE_ROLE]	= { .type = NLA_U32 },
+};
+
+static int br_mrp_ring_role_parse(struct net_bridge *br, struct nlattr *attr,
+				  struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_RING_ROLE_MAX + 1];
+	struct br_mrp_ring_role role;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_RING_ROLE_MAX, attr,
+			       br_mrp_ring_role_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MRP_RING_ROLE_RING_ID] ||
+	    !tb[IFLA_BRIDGE_MRP_RING_ROLE_ROLE]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing attribute: RING_ID or ROLE");
+		return -EINVAL;
+	}
+
+	memset(&role, 0x0, sizeof(role));
+
+	role.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]);
+	role.ring_role = nla_get_u32(tb[IFLA_BRIDGE_MRP_RING_ROLE_ROLE]);
+
+	return br_mrp_set_ring_role(br, &role);
+}
+
+static const struct nla_policy
+br_mrp_start_test_policy[IFLA_BRIDGE_MRP_START_TEST_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_START_TEST_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_START_TEST_RING_ID]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_START_TEST_INTERVAL]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_START_TEST_MAX_MISS]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_START_TEST_PERIOD]	= { .type = NLA_U32 },
+};
+
+static int br_mrp_start_test_parse(struct net_bridge *br, struct nlattr *attr,
+				   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_START_TEST_MAX + 1];
+	struct br_mrp_start_test test;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_START_TEST_MAX, attr,
+			       br_mrp_start_test_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MRP_START_TEST_RING_ID] ||
+	    !tb[IFLA_BRIDGE_MRP_START_TEST_INTERVAL] ||
+	    !tb[IFLA_BRIDGE_MRP_START_TEST_MAX_MISS] ||
+	    !tb[IFLA_BRIDGE_MRP_START_TEST_PERIOD]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing attribute: RING_ID or INTERVAL or MAX_MISS or PERIOD");
+		return -EINVAL;
+	}
+
+	memset(&test, 0x0, sizeof(test));
+
+	test.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_RING_ID]);
+	test.interval = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_INTERVAL]);
+	test.max_miss = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_MAX_MISS]);
+	test.period = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_PERIOD]);
+
+	return br_mrp_start_test(br, &test);
+}
+
 int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
 {
@@ -44,58 +247,45 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 		return err;
 
 	if (tb[IFLA_BRIDGE_MRP_INSTANCE]) {
-		struct br_mrp_instance *instance =
-			nla_data(tb[IFLA_BRIDGE_MRP_INSTANCE]);
-
-		if (cmd == RTM_SETLINK)
-			err = br_mrp_add(br, instance);
-		else
-			err = br_mrp_del(br, instance);
+		err = br_mrp_instance_parse(br, tb[IFLA_BRIDGE_MRP_INSTANCE],
+					    cmd, extack);
 		if (err)
 			return err;
 	}
 
 	if (tb[IFLA_BRIDGE_MRP_PORT_STATE]) {
-		enum br_mrp_port_state_type state =
-			nla_get_u32(tb[IFLA_BRIDGE_MRP_PORT_STATE]);
-
-		err = br_mrp_set_port_state(p, state);
+		err = br_mrp_port_state_parse(p, tb[IFLA_BRIDGE_MRP_PORT_STATE],
+					      extack);
 		if (err)
 			return err;
 	}
 
 	if (tb[IFLA_BRIDGE_MRP_PORT_ROLE]) {
-		struct br_mrp_port_role *role =
-			nla_data(tb[IFLA_BRIDGE_MRP_PORT_ROLE]);
-
-		err = br_mrp_set_port_role(p, role);
+		err = br_mrp_port_role_parse(p, tb[IFLA_BRIDGE_MRP_PORT_ROLE],
+					     extack);
 		if (err)
 			return err;
 	}
 
 	if (tb[IFLA_BRIDGE_MRP_RING_STATE]) {
-		struct br_mrp_ring_state *state =
-			nla_data(tb[IFLA_BRIDGE_MRP_RING_STATE]);
-
-		err = br_mrp_set_ring_state(br, state);
+		err = br_mrp_ring_state_parse(br,
+					      tb[IFLA_BRIDGE_MRP_RING_STATE],
+					      extack);
 		if (err)
 			return err;
 	}
 
 	if (tb[IFLA_BRIDGE_MRP_RING_ROLE]) {
-		struct br_mrp_ring_role *role =
-			nla_data(tb[IFLA_BRIDGE_MRP_RING_ROLE]);
-
-		err = br_mrp_set_ring_role(br, role);
+		err = br_mrp_ring_role_parse(br, tb[IFLA_BRIDGE_MRP_RING_ROLE],
+					     extack);
 		if (err)
 			return err;
 	}
 
 	if (tb[IFLA_BRIDGE_MRP_START_TEST]) {
-		struct br_mrp_start_test *test =
-			nla_data(tb[IFLA_BRIDGE_MRP_START_TEST]);
-
-		err = br_mrp_start_test(br, test);
+		err = br_mrp_start_test_parse(br,
+					      tb[IFLA_BRIDGE_MRP_START_TEST],
+					      extack);
 		if (err)
 			return err;
 	}
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 2921a4b59f8e7..a0f53cc3ab85c 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -37,7 +37,7 @@ int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance);
 int br_mrp_set_port_state(struct net_bridge_port *p,
 			  enum br_mrp_port_state_type state);
 int br_mrp_set_port_role(struct net_bridge_port *p,
-			 struct br_mrp_port_role *role);
+			 enum br_mrp_port_role_type role);
 int br_mrp_set_ring_state(struct net_bridge *br,
 			  struct br_mrp_ring_state *state);
 int br_mrp_set_ring_role(struct net_bridge *br, struct br_mrp_ring_role *role);
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28D821EA55
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgGNHjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:39:31 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43825 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgGNHj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594712366; x=1626248366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BbeLW9UFW6nT1q3GYOn5N1tTxHNfvT3usXjhXTuBW6M=;
  b=bh9h2yWK1/DvipSeTHRjoTCeO6uRsg0V7LaiPv4UCQTrTR2fVAcHpiyV
   kDCEx2oj8YcQHdgKYjm+kYSa7fgeWTD2ObkTebkF/+RC1Za9XTnNEw0xE
   8XlftzJZhf+a+Ndx7Z3E9DiYssoJML7zpQ8DV1u6GeGa6q7GlMK0rHcsd
   FpEympzGzz+rOYbNR2fNdLojG//FKRPuJEAc1kORPdm/XYbCJMiZ7B4C+
   z5vNgCDcv1svtX4EjTWHIwxD82tlnab27It7yQr8sX1smRi2g+f0rC8YW
   Jk8XV7k7TsDSVKiHdFpk36uELM9Aud5u8a/wZqRjTcwuaFGFnc4h0e3Cu
   w==;
IronPort-SDR: 7sEV7XBHpZ5blYp6MZJNJMSnV/Bn2bnYpJ7kBh7zCV64oSw2jVxhQU0CLFdYwqw9lq8gfkebNK
 SdNhPJ65BKYFsqo9ZO3udOhdE2VFVaY7Mvnq0qiLAHu6ThNKdU0IftAEQqV5tC9QBmPah48n6h
 lZyh+kNpBVfK8VxuUbKEdTcQUna7v8VeAenOTxWbyErmioZVGOsHScZH8TRDmgE8iswcu4+ve9
 X2WIwB1QZAuI/6La0fs9RhR14AzDjVYh7MKLdr75BXS8T/l22hoioSB0eXuuhrOgOu6Pt7IYun
 Aw4=
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="19100009"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2020 00:39:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 00:39:26 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 14 Jul 2020 00:39:23 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 09/12] bridge: mrp: Extend MRP netlink interface for configuring MRP interconnect
Date:   Tue, 14 Jul 2020 09:34:55 +0200
Message-ID: <20200714073458.1939574-10-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the existing MRP netlink interface with the following
attributes: IFLA_BRIDGE_MRP_IN_ROLE, IFLA_BRIDGE_MRP_IN_STATE and
IFLA_BRIDGE_MRP_START_IN_TEST. These attributes are similar with their
ring attributes but they apply to the interconnect port.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_netlink.c | 140 ++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index 4bf7aaeb29152..a006e0771e8d3 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -14,6 +14,9 @@ static const struct nla_policy br_mrp_policy[IFLA_BRIDGE_MRP_MAX + 1] = {
 	[IFLA_BRIDGE_MRP_RING_STATE]	= { .type = NLA_NESTED },
 	[IFLA_BRIDGE_MRP_RING_ROLE]	= { .type = NLA_NESTED },
 	[IFLA_BRIDGE_MRP_START_TEST]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_MRP_IN_ROLE]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_MRP_IN_STATE]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_MRP_START_IN_TEST]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -235,6 +238,121 @@ static int br_mrp_start_test_parse(struct net_bridge *br, struct nlattr *attr,
 	return br_mrp_start_test(br, &test);
 }
 
+static const struct nla_policy
+br_mrp_in_state_policy[IFLA_BRIDGE_MRP_IN_STATE_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_IN_STATE_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_IN_STATE_IN_ID]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_IN_STATE_STATE]	= { .type = NLA_U32 },
+};
+
+static int br_mrp_in_state_parse(struct net_bridge *br, struct nlattr *attr,
+				 struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_IN_STATE_MAX + 1];
+	struct br_mrp_in_state state;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_IN_STATE_MAX, attr,
+			       br_mrp_in_state_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MRP_IN_STATE_IN_ID] ||
+	    !tb[IFLA_BRIDGE_MRP_IN_STATE_STATE]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing attribute: IN_ID or STATE");
+		return -EINVAL;
+	}
+
+	memset(&state, 0x0, sizeof(state));
+
+	state.in_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_IN_STATE_IN_ID]);
+	state.in_state = nla_get_u32(tb[IFLA_BRIDGE_MRP_IN_STATE_STATE]);
+
+	return br_mrp_set_in_state(br, &state);
+}
+
+static const struct nla_policy
+br_mrp_in_role_policy[IFLA_BRIDGE_MRP_IN_ROLE_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_IN_ROLE_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_IN_ROLE_RING_ID]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_IN_ROLE_IN_ID]		= { .type = NLA_U16 },
+	[IFLA_BRIDGE_MRP_IN_ROLE_ROLE]		= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_IN_ROLE_I_IFINDEX]	= { .type = NLA_U32 },
+};
+
+static int br_mrp_in_role_parse(struct net_bridge *br, struct nlattr *attr,
+				struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_IN_ROLE_MAX + 1];
+	struct br_mrp_in_role role;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_IN_ROLE_MAX, attr,
+			       br_mrp_in_role_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MRP_IN_ROLE_RING_ID] ||
+	    !tb[IFLA_BRIDGE_MRP_IN_ROLE_IN_ID] ||
+	    !tb[IFLA_BRIDGE_MRP_IN_ROLE_I_IFINDEX] ||
+	    !tb[IFLA_BRIDGE_MRP_IN_ROLE_ROLE]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing attribute: RING_ID or ROLE or IN_ID or I_IFINDEX");
+		return -EINVAL;
+	}
+
+	memset(&role, 0x0, sizeof(role));
+
+	role.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_IN_ROLE_RING_ID]);
+	role.in_id = nla_get_u16(tb[IFLA_BRIDGE_MRP_IN_ROLE_IN_ID]);
+	role.i_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_IN_ROLE_I_IFINDEX]);
+	role.in_role = nla_get_u32(tb[IFLA_BRIDGE_MRP_IN_ROLE_ROLE]);
+
+	return br_mrp_set_in_role(br, &role);
+}
+
+static const struct nla_policy
+br_mrp_start_in_test_policy[IFLA_BRIDGE_MRP_START_IN_TEST_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_START_IN_TEST_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_START_IN_TEST_IN_ID]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_START_IN_TEST_INTERVAL]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_START_IN_TEST_MAX_MISS]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_START_IN_TEST_PERIOD]	= { .type = NLA_U32 },
+};
+
+static int br_mrp_start_in_test_parse(struct net_bridge *br,
+				      struct nlattr *attr,
+				      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_START_IN_TEST_MAX + 1];
+	struct br_mrp_start_in_test test;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_START_IN_TEST_MAX, attr,
+			       br_mrp_start_in_test_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MRP_START_IN_TEST_IN_ID] ||
+	    !tb[IFLA_BRIDGE_MRP_START_IN_TEST_INTERVAL] ||
+	    !tb[IFLA_BRIDGE_MRP_START_IN_TEST_MAX_MISS] ||
+	    !tb[IFLA_BRIDGE_MRP_START_IN_TEST_PERIOD]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing attribute: RING_ID or INTERVAL or MAX_MISS or PERIOD");
+		return -EINVAL;
+	}
+
+	memset(&test, 0x0, sizeof(test));
+
+	test.in_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_IN_TEST_IN_ID]);
+	test.interval = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_IN_TEST_INTERVAL]);
+	test.max_miss = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_IN_TEST_MAX_MISS]);
+	test.period = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_IN_TEST_PERIOD]);
+
+	return br_mrp_start_in_test(br, &test);
+}
+
 int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
 {
@@ -301,6 +419,28 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 			return err;
 	}
 
+	if (tb[IFLA_BRIDGE_MRP_IN_STATE]) {
+		err = br_mrp_in_state_parse(br, tb[IFLA_BRIDGE_MRP_IN_STATE],
+					    extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_MRP_IN_ROLE]) {
+		err = br_mrp_in_role_parse(br, tb[IFLA_BRIDGE_MRP_IN_ROLE],
+					   extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_MRP_START_IN_TEST]) {
+		err = br_mrp_start_in_test_parse(br,
+						 tb[IFLA_BRIDGE_MRP_START_IN_TEST],
+						 extack);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
2.27.0


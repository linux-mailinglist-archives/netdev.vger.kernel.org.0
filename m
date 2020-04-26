Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D909D1B9087
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 15:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgDZNYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 09:24:18 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:33778 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgDZNYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 09:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587907454; x=1619443454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=k9KaHh1wytDLB+WV3B+kEFHBoC4RQFglGkDtd8z1bsE=;
  b=ioF489zMgabxii8daW5KkIV/elR/MQiDIGMdtfWuCwjBs8EJPIWsCOZV
   j2xErebWTIIKbC75r9GL/Qi8vbm7ORdAKrYaUtlty6j4IX6fgWsRlnCld
   Ts8OY5eikR0W1kjJ0kyxilBhM7N5GKitsmqurZahGT3RNmWVjxR177K90
   JtY/4PKuIqn2d/TSex/xWgiCLf8eiXG/xP/kyqtFSWQczQV5TVm04ZLBa
   45KH23YOlMcGGl7lyXiNaNUzOXt85HlpZhL/PnMXUEOXa/6ia4GcyFVfe
   3xD5R6JSNJQQSLPa9YRZ9FF2y2a6Ryg2WAXRTbQDqAQ6kpprwt0jcEec3
   A==;
IronPort-SDR: kl1YalHscL1Q1F1rZFZ1utRb9e889iWAoQY8vGhxZQemTPYmW/BQM7L0YZOzQF7jMHaR2di1ol
 ZptYoMRnUjAFX7pVco8JlLUgVaLUgAMCoLagZ61M4r6TCozhSCM3oAetKQ2ygr+JokUMI3uLJD
 CrWqpF3eugNctwnj5CzXNg2QVlvXw12sR765SREDPRKbGaPEfC09iApJp3zQdPZVpQPacuETKG
 l/aLmtGSY/vccwYxQccgOm03p9r4sKzptAh+8BQrsud7KMCj1cmOFv9vQYy3rt5wHOZ5Wr9//V
 Xek=
X-IronPort-AV: E=Sophos;i="5.73,320,1583218800"; 
   d="scan'208";a="74586843"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2020 06:24:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Apr 2020 06:24:13 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Sun, 26 Apr 2020 06:24:10 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 09/11] bridge: mrp: Implement netlink interface to configure MRP
Date:   Sun, 26 Apr 2020 15:22:06 +0200
Message-ID: <20200426132208.3232-10-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200426132208.3232-1-horatiu.vultur@microchip.com>
References: <20200426132208.3232-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement netlink interface to configure MRP. The implementation
will do sanity checks over the attributes and then eventually call the MRP
interface.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_netlink.c | 91 +++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index b982db14bbf4..503896638be0 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -6,6 +6,97 @@
 #include "br_private.h"
 #include "br_private_mrp.h"
 
+static const struct nla_policy br_mrp_policy[IFLA_BRIDGE_MRP_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_INSTANCE]	= { .type = NLA_EXACT_LEN,
+				    .len = sizeof(struct br_mrp_instance)},
+	[IFLA_BRIDGE_MRP_PORT_STATE]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_PORT_ROLE]	= { .type = NLA_EXACT_LEN,
+				    .len = sizeof(struct br_mrp_port_role)},
+	[IFLA_BRIDGE_MRP_RING_STATE]	= { .type = NLA_EXACT_LEN,
+				    .len = sizeof(struct br_mrp_ring_state)},
+	[IFLA_BRIDGE_MRP_RING_ROLE]	= { .type = NLA_EXACT_LEN,
+				    .len = sizeof(struct br_mrp_ring_role)},
+	[IFLA_BRIDGE_MRP_START_TEST]	= { .type = NLA_EXACT_LEN,
+				    .len = sizeof(struct br_mrp_start_test)},
+};
+
+int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
+		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_MAX + 1];
+	int err;
+
+	if (br->stp_enabled != BR_NO_STP) {
+		NL_SET_ERR_MSG_MOD(extack, "MRP can't be enabled if STP is already enabled\n");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_MAX, attr,
+			       br_mrp_policy, extack);
+	if (err)
+		return err;
+
+	if (tb[IFLA_BRIDGE_MRP_INSTANCE]) {
+		struct br_mrp_instance *instance =
+			nla_data(tb[IFLA_BRIDGE_MRP_INSTANCE]);
+
+		if (cmd == RTM_SETLINK)
+			err = br_mrp_add(br, instance);
+		else
+			err = br_mrp_del(br, instance);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_MRP_PORT_STATE]) {
+		enum br_mrp_port_state_type state =
+			nla_get_u32(tb[IFLA_BRIDGE_MRP_PORT_STATE]);
+
+		err = br_mrp_set_port_state(p, state);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_MRP_PORT_ROLE]) {
+		struct br_mrp_port_role *role =
+			nla_data(tb[IFLA_BRIDGE_MRP_PORT_ROLE]);
+
+		err = br_mrp_set_port_role(p, role);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_MRP_RING_STATE]) {
+		struct br_mrp_ring_state *state =
+			nla_data(tb[IFLA_BRIDGE_MRP_RING_STATE]);
+
+		err = br_mrp_set_ring_state(br, state);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_MRP_RING_ROLE]) {
+		struct br_mrp_ring_role *role =
+			nla_data(tb[IFLA_BRIDGE_MRP_RING_ROLE]);
+
+		err = br_mrp_set_ring_role(br, role);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_MRP_START_TEST]) {
+		struct br_mrp_start_test *test =
+			nla_data(tb[IFLA_BRIDGE_MRP_START_TEST]);
+
+		err = br_mrp_start_test(br, test);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int br_mrp_port_open(struct net_device *dev, u8 loc)
 {
 	struct net_bridge_port *p;
-- 
2.17.1


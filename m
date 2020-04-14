Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A781A7965
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439093AbgDNL2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:28:02 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:17753 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439070AbgDNL1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586863661; x=1618399661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DWPs3xrMyxo3okz3VMWs5x6ia6WwSmMa/+orZa96r/I=;
  b=QL4+TepN/8jtKQ9ey3+iAPBUi2JpQDJsdULoNJoXJS90qrK3nBMo7sOn
   BiChiksEir/FpWO6tTMzq6mtNJ2V4UCksuhtIDPsw4Cl8sJ2vR+82prw3
   nxcsa/Nb9UVKQLZlnu40OLrB5KAnmwrDRQL5jwVuIOnrsw1ztq41Vc6WB
   R8vdh8sQuS6mOHsTEPECJFpMJjKWokSOJQTpVEMH39RQdYAl6ERqRQF1O
   lzSsE4M0GBaWPw8JvLBvYNSWX9SwzRFnYy7H++g2pGy/7S3/gKdRgBPUH
   orpC/kxIcTeG71AFhcMXDu6HJt9B7z2tLSMDD8D3aLvhbfQx2XuA/z5iU
   Q==;
IronPort-SDR: WCInP7Qr5Sy1ud/Ldk3QOFTP183MTspilSHsloYl3SfCsQrszxOMezTOUjEYA9NEQFPbYIfdNx
 Y5eInCCoWl0X6w7puunL9bjBIcGC9TWIBYFoXS1XbLBzQgQf7vV/P1yyXGXz7fn1p1ZC2mrHZl
 fz2fjviciTPyLYy9t0GuOeEd4AFLHy7A4Fi+B3Y7J0xdW3XYmnqp5YgJ803cq+LyGqKHTr2/dT
 tTCLhBQBWD2fjDf4k7VWoWDz9C9ZDLE6sxXHhOerjl7WDTFZiPwCHFdUJy8IEmkD1c5POVdBnP
 Zgk=
X-IronPort-AV: E=Sophos;i="5.72,382,1580799600"; 
   d="scan'208";a="70264391"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2020 04:27:35 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Apr 2020 04:27:34 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 14 Apr 2020 04:27:31 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v5 8/9] bridge: mrp: Implement netlink interface to configure MRP
Date:   Tue, 14 Apr 2020 13:26:17 +0200
Message-ID: <20200414112618.3644-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414112618.3644-1-horatiu.vultur@microchip.com>
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
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
 net/bridge/br_mrp_netlink.c | 164 ++++++++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)
 create mode 100644 net/bridge/br_mrp_netlink.c

diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
new file mode 100644
index 000000000000..0d8253311595
--- /dev/null
+++ b/net/bridge/br_mrp_netlink.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <net/genetlink.h>
+
+#include <uapi/linux/mrp_bridge.h>
+#include "br_private.h"
+#include "br_private_mrp.h"
+
+static const struct nla_policy br_mrp_policy[IFLA_BRIDGE_MRP_MAX + 1] = {
+	[IFLA_BRIDGE_MRP_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_MRP_INSTANCE]	= { .type = NLA_EXACT_LEN,
+					    .len = sizeof(struct br_mrp_instance)},
+	[IFLA_BRIDGE_MRP_PORT_STATE]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_PORT_ROLE]	= { .type = NLA_EXACT_LEN,
+					    .len = sizeof(struct br_mrp_port_role)},
+	[IFLA_BRIDGE_MRP_RING_STATE]	= { .type = NLA_EXACT_LEN,
+					    .len = sizeof(struct br_mrp_ring_state)},
+	[IFLA_BRIDGE_MRP_RING_ROLE]	= { .type = NLA_EXACT_LEN,
+					    .len = sizeof(struct br_mrp_ring_role)},
+	[IFLA_BRIDGE_MRP_START_TEST]	= { .type = NLA_EXACT_LEN,
+					    .len = sizeof(struct br_mrp_start_test)},
+};
+
+int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
+		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MRP_MAX + 1];
+	int err;
+
+	if (br->stp_enabled != BR_NO_STP) {
+		br_warn(br, "MRP can't be enabled if STP is already enabled\n");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_MAX, attr,
+			       NULL, extack);
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
+static inline size_t br_mrp_nlmsg_size(void)
+{
+	return NLMSG_ALIGN(sizeof(struct ifinfomsg))
+		+ nla_total_size(4); /* IFLA_BRIDGE_MRP_RING_OPEN */
+}
+
+int br_mrp_port_open(struct net_device *dev, u8 loc)
+{
+	struct nlattr *af, *mrp;
+	struct ifinfomsg *hdr;
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+	struct net *net;
+
+	net = dev_net(dev);
+
+	skb = nlmsg_new(br_mrp_nlmsg_size(), GFP_ATOMIC);
+	if (!skb)
+		goto errout;
+
+	nlh = nlmsg_put(skb, 0, 0, RTM_NEWLINK, sizeof(*hdr), 0);
+	if (!nlh)
+		goto errout;
+
+	hdr = nlmsg_data(nlh);
+	hdr->ifi_family = AF_BRIDGE;
+	hdr->__ifi_pad = 0;
+	hdr->ifi_type = dev->type;
+	hdr->ifi_index = dev->ifindex;
+	hdr->ifi_flags = dev_get_flags(dev);
+	hdr->ifi_change = 0;
+
+	af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
+	if (!af) {
+		err = -EMSGSIZE;
+		goto nla_put_failure;
+	}
+
+	mrp = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP);
+	if (!mrp) {
+		err = -EMSGSIZE;
+		goto nla_put_failure;
+	}
+
+	err = nla_put_u32(skb, IFLA_BRIDGE_MRP_RING_OPEN, loc);
+	if (err)
+		goto nla_put_failure;
+
+	nla_nest_end(skb, mrp);
+	nla_nest_end(skb, af);
+	nlmsg_end(skb, nlh);
+
+	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
+	return 0;
+
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	kfree_skb(skb);
+
+errout:
+	rtnl_set_sk_err(net, RTNLGRP_LINK, err);
+	return err;
+}
+EXPORT_SYMBOL(br_mrp_port_open);
-- 
2.17.1


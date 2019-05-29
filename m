Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA1F2DABC
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfE2K3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:29:32 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:41127 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfE2K3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:29:30 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,526,1549954800"; 
   d="scan'208";a="33434201"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 May 2019 03:29:29 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by mx.microchip.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5; Wed, 29 May 2019
 03:29:25 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Paul Burton" <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-mips@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net-next v2 2/2] net: mscc: ocelot: Hardware ofload for tc flower filter
Date:   Wed, 29 May 2019 12:26:20 +0200
Message-ID: <1559125580-6375-3-git-send-email-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559125580-6375-1-git-send-email-horatiu.vultur@microchip.com>
References: <1559125580-6375-1-git-send-email-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware offload of port filtering are now supported via tc command using
flower filter. ACL rules are used to enable the hardware offload.
The following keys are supported:

vlan_id
vlan_prio
dst_mac/src_mac for non IP frames
dst_ip/src_ip
dst_port/src_port

The following actions are supported:
trap
drop

These filters are supported only on the ingress schedulare.

Add:
tc qdisc add dev eth3 ingress
tc filter ad dev eth3 parent ffff: ip_proto ip flower \
    ip_proto tcp dst_port 80 action drop

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/Makefile        |   2 +-
 drivers/net/ethernet/mscc/ocelot_ace.h    |   5 +
 drivers/net/ethernet/mscc/ocelot_flower.c | 360 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_tc.c     |  16 +-
 4 files changed, 376 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_flower.c

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index bf4a710..9a36c26 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: (GPL-2.0 OR MIT)
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
 mscc_ocelot_common-y := ocelot.o ocelot_io.o
-mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o
+mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_board.o
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index c84e608..d621683 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -224,4 +224,9 @@ int ocelot_ace_rule_stats_update(struct ocelot_ace_rule *rule);
 int ocelot_ace_init(struct ocelot *ocelot);
 void ocelot_ace_deinit(void);
 
+int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
+				      struct tc_block_offload *f);
+void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
+					 struct tc_block_offload *f);
+
 #endif /* _MSCC_OCELOT_ACE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
new file mode 100644
index 0000000..efbe008
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -0,0 +1,360 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Microsemi Ocelot Switch driver
+ * Copyright (c) 2019 Microsemi Corporation
+ */
+
+#include <net/pkt_cls.h>
+#include <net/tc_act/tc_gact.h>
+
+#include "ocelot_ace.h"
+
+struct ocelot_port_block {
+	struct ocelot_acl_block *block;
+	struct ocelot_port *port;
+};
+
+static u16 get_prio(u32 prio)
+{
+	/* prio starts from 0x1000 while the ids starts from 0 */
+	return prio >> 16;
+}
+
+static int ocelot_flower_parse_action(struct tc_cls_flower_offload *f,
+				      struct ocelot_ace_rule *rule)
+{
+	const struct flow_action_entry *a;
+	int i;
+
+	if (f->rule->action.num_entries != 1)
+		return -EOPNOTSUPP;
+
+	flow_action_for_each(i, a, &f->rule->action) {
+		switch (a->id) {
+		case FLOW_ACTION_DROP:
+			rule->action = OCELOT_ACL_ACTION_DROP;
+			break;
+		case FLOW_ACTION_TRAP:
+			rule->action = OCELOT_ACL_ACTION_TRAP;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
+static int ocelot_flower_parse(struct tc_cls_flower_offload *f,
+			       struct ocelot_ace_rule *ocelot_rule)
+{
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_dissector *dissector = rule->match.dissector;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS))) {
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_control(rule, &match);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+		u16 proto = ntohs(f->common.protocol);
+
+		/* The hw support mac matches only for MAC_ETYPE key,
+		 * therefore if other matches(port, tcp flags, etc) are added
+		 * then just bail out
+		 */
+		if ((dissector->used_keys &
+		    (BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+		     BIT(FLOW_DISSECTOR_KEY_BASIC) |
+		     BIT(FLOW_DISSECTOR_KEY_CONTROL))) !=
+		    (BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+		     BIT(FLOW_DISSECTOR_KEY_BASIC) |
+		     BIT(FLOW_DISSECTOR_KEY_CONTROL)))
+			return -EOPNOTSUPP;
+
+		if (proto == ETH_P_IP ||
+		    proto == ETH_P_IPV6 ||
+		    proto == ETH_P_ARP)
+			return -EOPNOTSUPP;
+
+		flow_rule_match_eth_addrs(rule, &match);
+		ocelot_rule->type = OCELOT_ACE_TYPE_ETYPE;
+		ether_addr_copy(ocelot_rule->frame.etype.dmac.value,
+				match.key->dst);
+		ether_addr_copy(ocelot_rule->frame.etype.smac.value,
+				match.key->src);
+		ether_addr_copy(ocelot_rule->frame.etype.dmac.mask,
+				match.mask->dst);
+		ether_addr_copy(ocelot_rule->frame.etype.smac.mask,
+				match.mask->src);
+		goto finished_key_parsing;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+		if (ntohs(match.key->n_proto) == ETH_P_IP) {
+			ocelot_rule->type = OCELOT_ACE_TYPE_IPV4;
+			ocelot_rule->frame.ipv4.proto.value[0] =
+				match.key->ip_proto;
+			ocelot_rule->frame.ipv4.proto.mask[0] =
+				match.mask->ip_proto;
+		}
+		if (ntohs(match.key->n_proto) == ETH_P_IPV6) {
+			ocelot_rule->type = OCELOT_ACE_TYPE_IPV6;
+			ocelot_rule->frame.ipv6.proto.value[0] =
+				match.key->ip_proto;
+			ocelot_rule->frame.ipv6.proto.mask[0] =
+				match.mask->ip_proto;
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS) &&
+	    ntohs(f->common.protocol) == ETH_P_IP) {
+		struct flow_match_ipv4_addrs match;
+		u8 *tmp;
+
+		flow_rule_match_ipv4_addrs(rule, &match);
+		tmp = &ocelot_rule->frame.ipv4.sip.value.addr[0];
+		memcpy(tmp, &match.key->src, 4);
+
+		tmp = &ocelot_rule->frame.ipv4.sip.mask.addr[0];
+		memcpy(tmp, &match.mask->src, 4);
+
+		tmp = &ocelot_rule->frame.ipv4.dip.value.addr[0];
+		memcpy(tmp, &match.key->dst, 4);
+
+		tmp = &ocelot_rule->frame.ipv4.dip.mask.addr[0];
+		memcpy(tmp, &match.mask->dst, 4);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS) &&
+	    ntohs(f->common.protocol) == ETH_P_IPV6) {
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(rule, &match);
+		ocelot_rule->frame.ipv4.sport.value = ntohs(match.key->src);
+		ocelot_rule->frame.ipv4.sport.mask = ntohs(match.mask->src);
+		ocelot_rule->frame.ipv4.dport.value = ntohs(match.key->dst);
+		ocelot_rule->frame.ipv4.dport.mask = ntohs(match.mask->dst);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		ocelot_rule->type = OCELOT_ACE_TYPE_ANY;
+		ocelot_rule->vlan.vid.value = match.key->vlan_id;
+		ocelot_rule->vlan.vid.mask = match.mask->vlan_id;
+		ocelot_rule->vlan.pcp.value[0] = match.key->vlan_priority;
+		ocelot_rule->vlan.pcp.mask[0] = match.mask->vlan_priority;
+	}
+
+finished_key_parsing:
+	ocelot_rule->prio = get_prio(f->common.prio);
+	ocelot_rule->id = f->cookie;
+	return ocelot_flower_parse_action(f, ocelot_rule);
+}
+
+static
+struct ocelot_ace_rule *ocelot_ace_rule_create(struct tc_cls_flower_offload *f,
+					       struct ocelot_port_block *block)
+{
+	struct ocelot_ace_rule *rule;
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return NULL;
+
+	rule->port = block->port;
+	rule->chip_port = block->port->chip_port;
+	return rule;
+}
+
+static int ocelot_flower_replace(struct tc_cls_flower_offload *f,
+				 struct ocelot_port_block *port_block)
+{
+	struct ocelot_ace_rule *rule;
+	int ret;
+
+	if (port_block->port->tc.block_shared)
+		return -EOPNOTSUPP;
+
+	rule = ocelot_ace_rule_create(f, port_block);
+	if (!rule)
+		return -ENOMEM;
+
+	ret = ocelot_flower_parse(f, rule);
+	if (ret) {
+		kfree(rule);
+		return ret;
+	}
+
+	ret = ocelot_ace_rule_offload_add(rule);
+	if (ret)
+		return ret;
+
+	port_block->port->tc.offload_cnt++;
+	return 0;
+}
+
+static int ocelot_flower_destroy(struct tc_cls_flower_offload *f,
+				 struct ocelot_port_block *port_block)
+{
+	struct ocelot_ace_rule rule;
+	int ret;
+
+	rule.prio = get_prio(f->common.prio);
+	rule.port = port_block->port;
+	rule.id = f->cookie;
+
+	ret = ocelot_ace_rule_offload_del(&rule);
+	if (ret)
+		return ret;
+
+	port_block->port->tc.offload_cnt--;
+	return 0;
+}
+
+static int ocelot_flower_stats_update(struct tc_cls_flower_offload *f,
+				      struct ocelot_port_block *port_block)
+{
+	struct ocelot_ace_rule rule;
+	int ret;
+
+	rule.prio = get_prio(f->common.prio);
+	rule.port = port_block->port;
+	rule.id = f->cookie;
+	ret = ocelot_ace_rule_stats_update(&rule);
+	if (ret)
+		return ret;
+
+	flow_stats_update(&f->stats, 0x0, rule.stats.pkts, 0x0);
+	return 0;
+}
+
+static int ocelot_setup_tc_cls_flower(struct tc_cls_flower_offload *f,
+				      struct ocelot_port_block *port_block)
+{
+	switch (f->command) {
+	case TC_CLSFLOWER_REPLACE:
+		return ocelot_flower_replace(f, port_block);
+	case TC_CLSFLOWER_DESTROY:
+		return ocelot_flower_destroy(f, port_block);
+	case TC_CLSFLOWER_STATS:
+		return ocelot_flower_stats_update(f, port_block);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ocelot_setup_tc_block_cb_flower(enum tc_setup_type type,
+					   void *type_data, void *cb_priv)
+{
+	struct ocelot_port_block *port_block = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(port_block->port->dev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return ocelot_setup_tc_cls_flower(type_data, cb_priv);
+	case TC_SETUP_CLSMATCHALL:
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static struct ocelot_port_block*
+ocelot_port_block_create(struct ocelot_port *port)
+{
+	struct ocelot_port_block *port_block;
+
+	port_block = kzalloc(sizeof(*port_block), GFP_KERNEL);
+	if (!port_block)
+		return NULL;
+
+	port_block->port = port;
+
+	return port_block;
+}
+
+static void ocelot_port_block_destroy(struct ocelot_port_block *block)
+{
+	kfree(block);
+}
+
+int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
+				      struct tc_block_offload *f)
+{
+	struct ocelot_port_block *port_block;
+	struct tcf_block_cb *block_cb;
+	int ret;
+
+	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+		return -EOPNOTSUPP;
+
+	block_cb = tcf_block_cb_lookup(f->block,
+				       ocelot_setup_tc_block_cb_flower, port);
+	if (!block_cb) {
+		port_block = ocelot_port_block_create(port);
+		if (!port_block)
+			return -ENOMEM;
+
+		block_cb =
+			__tcf_block_cb_register(f->block,
+						ocelot_setup_tc_block_cb_flower,
+						port, port_block, f->extack);
+		if (IS_ERR(block_cb)) {
+			ret = PTR_ERR(block_cb);
+			goto err_cb_register;
+		}
+	} else {
+		port_block = tcf_block_cb_priv(block_cb);
+	}
+
+	tcf_block_cb_incref(block_cb);
+	return 0;
+
+err_cb_register:
+	ocelot_port_block_destroy(port_block);
+
+	return ret;
+}
+
+void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
+					 struct tc_block_offload *f)
+{
+	struct ocelot_port_block *port_block;
+	struct tcf_block_cb *block_cb;
+
+	block_cb = tcf_block_cb_lookup(f->block,
+				       ocelot_setup_tc_block_cb_flower, port);
+	if (!block_cb)
+		return;
+
+	port_block = tcf_block_cb_priv(block_cb);
+	if (!tcf_block_cb_decref(block_cb)) {
+		tcf_block_cb_unregister(f->block,
+					ocelot_setup_tc_block_cb_flower, port);
+		ocelot_port_block_destroy(port_block);
+	}
+}
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index a0eaadc..7208430 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -6,6 +6,7 @@
 
 #include "ocelot_tc.h"
 #include "ocelot_police.h"
+#include "ocelot_ace.h"
 #include <net/pkt_cls.h>
 
 static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
@@ -101,10 +102,7 @@ static int ocelot_setup_tc_block_cb(enum tc_setup_type type,
 
 		return ocelot_setup_tc_cls_matchall(port, type_data, ingress);
 	case TC_SETUP_CLSFLOWER:
-		netdev_dbg(port->dev, "tc_block_cb: TC_SETUP_CLSFLOWER %s\n",
-			   ingress ? "ingress" : "egress");
-
-		return -EOPNOTSUPP;
+		return 0;
 	default:
 		netdev_dbg(port->dev, "tc_block_cb: type %d %s\n",
 			   type,
@@ -134,6 +132,7 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 				 struct tc_block_offload *f)
 {
 	tc_setup_cb_t *cb;
+	int ret;
 
 	netdev_dbg(port->dev, "tc_block command %d, binder_type %d\n",
 		   f->command, f->binder_type);
@@ -149,9 +148,14 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cb, port,
-					     port, f->extack);
+		ret = tcf_block_cb_register(f->block, cb, port,
+					    port, f->extack);
+		if (ret)
+			return ret;
+
+		return ocelot_setup_tc_block_flower_bind(port, f);
 	case TC_BLOCK_UNBIND:
+		ocelot_setup_tc_block_flower_unbind(port, f);
 		tcf_block_cb_unregister(f->block, cb, port);
 		return 0;
 	default:
-- 
2.7.4


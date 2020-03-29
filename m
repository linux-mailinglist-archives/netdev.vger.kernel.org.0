Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D22196A6D
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 01:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgC2AxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 20:53:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36981 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgC2AxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 20:53:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id w10so16671105wrm.4;
        Sat, 28 Mar 2020 17:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1eXwosAxsAYbVw+SEiEzG5vy5omo9S74F/WHi/DW3LI=;
        b=K8eX1Pef18Rmn9qFee4sFrKhTSoeZHnIv7lxE9G6vxTX4dljR66ohK7Eot98R1HM5E
         BNCsRgvfP0q4gsJFGdwzNGr+NfzfnBTIwDsaAFbLsx82Qku4s9Q6nCFdTKSpDdYR2P1m
         VMEbs0A0o6cmMEnRBw3lrCHJNSPN1lnKdn0H9m/NjU+r8NCqyOWvXG9dp0NYybKCFgjs
         xi5xwgR7sgjkZEz7+WDIi4ozcq2NMbXj43PhHKvFuIss5oZVCYTW7USCLOycOKdnxM0m
         EHFR2hs313UIJmhqsABZ218LQu+dIJ+XEAdgsFaJqW9SQXHHjPyf4BT0iDQKC1KaMmgh
         oDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1eXwosAxsAYbVw+SEiEzG5vy5omo9S74F/WHi/DW3LI=;
        b=fw6VVkcl3oSy3SEFEsMdz8LPLuV5ALZKTPby31W4jn6mQkKPzFJhO8J5Zccc4GYQOF
         EhDI6s31Dl1YBidClURXF70OvnayHimpG4U5h21wIQiGI0BZE1AUDlq1UHcLIBlemPXm
         idQ6S7KbRbrrWIGpOQ5Zh020lKj4haInc4nESgSE1oUsnQyqC1G2NbDvePhOfbkz7E/f
         CYsmRDTt8oJhVbd+Ku9tW0+lc3mwBcQlBqOnkhxH7k7BpQ2fOKXJWo5TYo4AvhoGh0PH
         zIBeWX0BicwRsTOiaLd1ucpX85D7b8TN2UIN211eIlgKx+apIyIDg+6TsfU4ZKrdGYvv
         B25w==
X-Gm-Message-State: ANhLgQ2oz/W56ixO67vfYoK1Blvi4HEspvkce8GTH+zj8I9eHx8OQ17r
        Qli2dEyc+fHs/HPsT2/1Bmg=
X-Google-Smtp-Source: ADFU+vtLxyiiPVvS7kHGMnfAOeKMUcT/ahdxyikSU/0BgDjnffQ+paPlvMCl+RhY1m6VG2/CrBUhog==
X-Received: by 2002:adf:afcb:: with SMTP id y11mr6898510wrd.141.1585443189842;
        Sat, 28 Mar 2020 17:53:09 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id l1sm8292652wme.14.2020.03.28.17.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 17:53:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com
Subject: [PATCH net-next 6/6] net: dsa: sja1105: add broadcast and per-traffic class policers
Date:   Sun, 29 Mar 2020 02:52:02 +0200
Message-Id: <20200329005202.17926-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329005202.17926-1-olteanv@gmail.com>
References: <20200329005202.17926-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch adds complete support for manipulating the L2 Policing Tables
from this switch. There are 45 table entries, one entry per each port
and traffic class, and one dedicated entry for broadcast traffic for
each ingress port.

Policing entries are shareable, and we use this functionality to support
shared block filters.

We are modeling broadcast policers as simple tc-flower matches on
dst_mac. As for the traffic class policers, the switch only deduces the
traffic class from the VLAN PCP field, so it makes sense to model this
as a tc-flower match on vlan_prio.

How to limit broadcast traffic coming from all front-panel ports to a
cumulated total of 10 Mbit/s:

tc qdisc add dev sw0p0 ingress_block 1 clsact
tc qdisc add dev sw0p1 ingress_block 1 clsact
tc qdisc add dev sw0p2 ingress_block 1 clsact
tc qdisc add dev sw0p3 ingress_block 1 clsact
tc filter add block 1 flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
	action police rate 10mbit burst 64k

How to limit traffic with VLAN PCP 0 (also includes untagged traffic) to
100 Mbit/s on port 0 only:

tc filter add dev sw0p0 ingress protocol 802.1Q flower skip_sw \
	vlan_prio 0 action police rate 100mbit burst 64k

The broadcast, VLAN PCP and port policers are compatible with one
another (can be installed at the same time on a port).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/Makefile         |   1 +
 drivers/net/dsa/sja1105/sja1105.h        |  40 +++
 drivers/net/dsa/sja1105/sja1105_flower.c | 340 +++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c   |   4 +
 4 files changed, 385 insertions(+)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_flower.c

diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index 66161e874344..8943d8d66f2b 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_NET_DSA_SJA1105) += sja1105.o
 sja1105-objs := \
     sja1105_spi.o \
     sja1105_main.o \
+    sja1105_flower.o \
     sja1105_ethtool.o \
     sja1105_clocking.o \
     sja1105_static_config.o \
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d97d4699104e..8b60dbd567f2 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -19,6 +19,7 @@
  * The passed parameter is in multiples of 1 ms.
  */
 #define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
+#define SJA1105_NUM_L2_POLICERS		45
 
 typedef enum {
 	SPI_READ = 0,
@@ -95,6 +96,36 @@ struct sja1105_info {
 	const char *name;
 };
 
+enum sja1105_rule_type {
+	SJA1105_RULE_BCAST_POLICER,
+	SJA1105_RULE_TC_POLICER,
+};
+
+struct sja1105_rule {
+	struct list_head list;
+	unsigned long cookie;
+	unsigned long port_mask;
+	enum sja1105_rule_type type;
+
+	union {
+		/* SJA1105_RULE_BCAST_POLICER */
+		struct {
+			int sharindx;
+		} bcast_pol;
+
+		/* SJA1105_RULE_TC_POLICER */
+		struct {
+			int sharindx;
+			int tc;
+		} tc_pol;
+	};
+};
+
+struct sja1105_flow_block {
+	struct list_head rules;
+	bool l2_policer_used[SJA1105_NUM_L2_POLICERS];
+};
+
 struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
@@ -103,6 +134,7 @@ struct sja1105_private {
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
+	struct sja1105_flow_block flow_block;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
 	/* Serializes transmission of management frames so that
 	 * the switch doesn't confuse them with one another.
@@ -222,4 +254,12 @@ size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
 size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
 					    enum packing_op op);
 
+/* From sja1105_flower.c */
+int sja1105_cls_flower_del(struct dsa_switch *ds, int port,
+			   struct flow_cls_offload *cls, bool ingress);
+int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
+			   struct flow_cls_offload *cls, bool ingress);
+void sja1105_flower_setup(struct dsa_switch *ds);
+void sja1105_flower_teardown(struct dsa_switch *ds);
+
 #endif
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
new file mode 100644
index 000000000000..5288a722e625
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020, NXP Semiconductors
+ */
+#include "sja1105.h"
+
+static struct sja1105_rule *sja1105_rule_find(struct sja1105_private *priv,
+					      unsigned long cookie)
+{
+	struct sja1105_rule *rule;
+
+	list_for_each_entry(rule, &priv->flow_block.rules, list)
+		if (rule->cookie == cookie)
+			return rule;
+
+	return NULL;
+}
+
+static int sja1105_find_free_l2_policer(struct sja1105_private *priv)
+{
+	int i;
+
+	for (i = 0; i < SJA1105_NUM_L2_POLICERS; i++)
+		if (!priv->flow_block.l2_policer_used[i])
+			return i;
+
+	return -1;
+}
+
+static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
+				       struct netlink_ext_ack *extack,
+				       unsigned long cookie, int port,
+				       u64 rate_bytes_per_sec,
+				       s64 burst)
+{
+	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
+	struct sja1105_l2_policing_entry *policing;
+	bool new_rule = false;
+	unsigned long p;
+	int rc;
+
+	if (!rule) {
+		rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+		if (!rule)
+			return -ENOMEM;
+
+		rule->cookie = cookie;
+		rule->type = SJA1105_RULE_BCAST_POLICER;
+		rule->bcast_pol.sharindx = sja1105_find_free_l2_policer(priv);
+		new_rule = true;
+	}
+
+	if (rule->bcast_pol.sharindx == -1) {
+		NL_SET_ERR_MSG_MOD(extack, "No more L2 policers free");
+		rc = -ENOSPC;
+		goto out;
+	}
+
+	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
+
+	if (policing[(SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port].sharindx != port) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port already has a broadcast policer");
+		rc = -EEXIST;
+		goto out;
+	}
+
+	rule->port_mask |= BIT(port);
+
+	/* Make the broadcast policers of all ports attached to this block
+	 * point to the newly allocated policer
+	 */
+	for_each_set_bit(p, &rule->port_mask, SJA1105_NUM_PORTS) {
+		int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + p;
+
+		policing[bcast].sharindx = rule->bcast_pol.sharindx;
+	}
+
+	policing[rule->bcast_pol.sharindx].rate = div_u64(rate_bytes_per_sec *
+							  512, 1000000);
+	policing[rule->bcast_pol.sharindx].smax = div_u64(rate_bytes_per_sec *
+							  PSCHED_NS2TICKS(burst),
+							  PSCHED_TICKS_PER_SEC);
+	/* TODO: support per-flow MTU */
+	policing[rule->bcast_pol.sharindx].maxlen = VLAN_ETH_FRAME_LEN +
+						    ETH_FCS_LEN;
+
+	rc = sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
+
+out:
+	if (rc == 0 && new_rule) {
+		priv->flow_block.l2_policer_used[rule->bcast_pol.sharindx] = true;
+		list_add(&rule->list, &priv->flow_block.rules);
+	} else if (new_rule) {
+		kfree(rule);
+	}
+
+	return rc;
+}
+
+static int sja1105_setup_tc_policer(struct sja1105_private *priv,
+				    struct netlink_ext_ack *extack,
+				    unsigned long cookie, int port, int tc,
+				    u64 rate_bytes_per_sec,
+				    s64 burst)
+{
+	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
+	struct sja1105_l2_policing_entry *policing;
+	bool new_rule = false;
+	unsigned long p;
+	int rc;
+
+	if (!rule) {
+		rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+		if (!rule)
+			return -ENOMEM;
+
+		rule->cookie = cookie;
+		rule->type = SJA1105_RULE_TC_POLICER;
+		rule->tc_pol.sharindx = sja1105_find_free_l2_policer(priv);
+		rule->tc_pol.tc = tc;
+		new_rule = true;
+	}
+
+	if (rule->tc_pol.sharindx == -1) {
+		NL_SET_ERR_MSG_MOD(extack, "No more L2 policers free");
+		rc = -ENOSPC;
+		goto out;
+	}
+
+	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
+
+	if (policing[(port * SJA1105_NUM_TC) + tc].sharindx != port) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port-TC pair already has an L2 policer");
+		rc = -EEXIST;
+		goto out;
+	}
+
+	rule->port_mask |= BIT(port);
+
+	/* Make the policers for traffic class @tc of all ports attached to
+	 * this block point to the newly allocated policer
+	 */
+	for_each_set_bit(p, &rule->port_mask, SJA1105_NUM_PORTS) {
+		int index = (p * SJA1105_NUM_TC) + tc;
+
+		policing[index].sharindx = rule->tc_pol.sharindx;
+	}
+
+	policing[rule->tc_pol.sharindx].rate = div_u64(rate_bytes_per_sec *
+						       512, 1000000);
+	policing[rule->tc_pol.sharindx].smax = div_u64(rate_bytes_per_sec *
+						       PSCHED_NS2TICKS(burst),
+						       PSCHED_TICKS_PER_SEC);
+	/* TODO: support per-flow MTU */
+	policing[rule->tc_pol.sharindx].maxlen = VLAN_ETH_FRAME_LEN +
+						 ETH_FCS_LEN;
+
+	rc = sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
+
+out:
+	if (rc == 0 && new_rule) {
+		priv->flow_block.l2_policer_used[rule->tc_pol.sharindx] = true;
+		list_add(&rule->list, &priv->flow_block.rules);
+	} else if (new_rule) {
+		kfree(rule);
+	}
+
+	return rc;
+}
+
+static int sja1105_flower_parse_policer(struct sja1105_private *priv, int port,
+					struct netlink_ext_ack *extack,
+					struct flow_cls_offload *cls,
+					u64 rate_bytes_per_sec,
+					s64 burst)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Unsupported keys used");
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+		if (match.key->n_proto) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Matching on protocol not supported");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		u8 bcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+		u8 null[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(rule, &match);
+
+		if (!ether_addr_equal_masked(match.key->src, null,
+					     match.mask->src)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Matching on source MAC not supported");
+			return -EOPNOTSUPP;
+		}
+
+		if (!ether_addr_equal_masked(match.key->dst, bcast,
+					     match.mask->dst)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only matching on broadcast DMAC is supported");
+			return -EOPNOTSUPP;
+		}
+
+		return sja1105_setup_bcast_policer(priv, extack, cls->cookie,
+						   port, rate_bytes_per_sec,
+						   burst);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+
+		if (match.key->vlan_id & match.mask->vlan_id) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Matching on VID is not supported");
+			return -EOPNOTSUPP;
+		}
+
+		if (match.mask->vlan_priority != 0x7) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Masked matching on PCP is not supported");
+			return -EOPNOTSUPP;
+		}
+
+		return sja1105_setup_tc_policer(priv, extack, cls->cookie, port,
+						match.key->vlan_priority,
+						rate_bytes_per_sec,
+						burst);
+	}
+
+	NL_SET_ERR_MSG_MOD(extack, "Not matching on any known key");
+	return -EOPNOTSUPP;
+}
+
+int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
+			   struct flow_cls_offload *cls, bool ingress)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct sja1105_private *priv = ds->priv;
+	const struct flow_action_entry *act;
+	int rc = -EOPNOTSUPP, i;
+
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_POLICE:
+			rc = sja1105_flower_parse_policer(priv, port, extack, cls,
+							  act->police.rate_bytes_ps,
+							  act->police.burst);
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Action not supported");
+			break;
+		}
+	}
+
+	return rc;
+}
+
+int sja1105_cls_flower_del(struct dsa_switch *ds, int port,
+			   struct flow_cls_offload *cls, bool ingress)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_rule *rule = sja1105_rule_find(priv, cls->cookie);
+	struct sja1105_l2_policing_entry *policing;
+	int old_sharindx;
+
+	if (!rule)
+		return 0;
+
+	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
+
+	if (rule->type == SJA1105_RULE_BCAST_POLICER) {
+		int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port;
+
+		old_sharindx = policing[bcast].sharindx;
+		policing[bcast].sharindx = port;
+	} else if (rule->type == SJA1105_RULE_TC_POLICER) {
+		int index = (port * SJA1105_NUM_TC) + rule->tc_pol.tc;
+
+		old_sharindx = policing[index].sharindx;
+		policing[index].sharindx = port;
+	} else {
+		return -EINVAL;
+	}
+
+	rule->port_mask &= ~BIT(port);
+	if (!rule->port_mask) {
+		priv->flow_block.l2_policer_used[old_sharindx] = false;
+		list_del(&rule->list);
+		kfree(rule);
+	}
+
+	return sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
+}
+
+void sja1105_flower_setup(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+	int port;
+
+	INIT_LIST_HEAD(&priv->flow_block.rules);
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++)
+		priv->flow_block.l2_policer_used[port] = true;
+}
+
+void sja1105_flower_teardown(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_rule *rule;
+	struct list_head *pos, *n;
+
+	list_for_each_safe(pos, n, &priv->flow_block.rules) {
+		rule = list_entry(pos, struct sja1105_rule, list);
+		list_del(&rule->list);
+		kfree(rule);
+	}
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 81d2e5e5ce96..472f4eb20c49 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2021,6 +2021,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 			kthread_destroy_worker(sp->xmit_worker);
 	}
 
+	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
 	sja1105_ptp_clock_unregister(ds);
 	sja1105_static_config_free(&priv->static_config);
@@ -2356,6 +2357,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_mirror_del	= sja1105_mirror_del,
 	.port_policer_add	= sja1105_port_policer_add,
 	.port_policer_del	= sja1105_port_policer_del,
+	.cls_flower_add		= sja1105_cls_flower_add,
+	.cls_flower_del		= sja1105_cls_flower_del,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
@@ -2459,6 +2462,7 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->mgmt_lock);
 
 	sja1105_tas_setup(ds);
+	sja1105_flower_setup(ds);
 
 	rc = dsa_register_switch(priv->ds);
 	if (rc)
-- 
2.17.1


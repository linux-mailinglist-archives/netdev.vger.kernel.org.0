Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2493368FB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhCKAg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:59 -0500
Received: from correo.us.es ([193.147.175.20]:50224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhCKAgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B4B4B12E83C
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A653ADA78F
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4775DA78A; Thu, 11 Mar 2021 01:36:30 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4C60DA78A;
        Thu, 11 Mar 2021 01:36:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7B0C842DC6E2;
        Thu, 11 Mar 2021 01:36:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 22/23] net: ethernet: mtk_eth_soc: add flow offloading support
Date:   Thu, 11 Mar 2021 01:36:03 +0100
Message-Id: <20210311003604.22199-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

This adds support for offloading IPv4 routed flows, including SNAT/DNAT,
one VLAN, PPPoE and DSA.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mediatek/Makefile        |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   5 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  10 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 485 ++++++++++++++++++
 4 files changed, 500 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_offload.c

diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index 871dc3e113e2..79d4cdbbcbf5 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -4,5 +4,5 @@
 #
 
 obj-$(CONFIG_NET_MEDIATEK_SOC) += mtk_eth.o
-mtk_eth-y := mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o mtk_ppe.o mtk_ppe_debugfs.o
+mtk_eth-y := mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o mtk_ppe.o mtk_ppe_debugfs.o mtk_ppe_offload.o
 obj-$(CONFIG_NET_MEDIATEK_STAR_EMAC) += mtk_star_emac.o
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b16b0ab7c7d0..2e6d79b2ff24 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2840,6 +2840,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= mtk_poll_controller,
 #endif
+	.ndo_setup_tc		= mtk_eth_setup_tc,
 };
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
@@ -3101,6 +3102,10 @@ static int mtk_probe(struct platform_device *pdev)
 				   eth->base + MTK_ETH_PPE_BASE, 2);
 		if (err)
 			goto err_free_dev;
+
+		err = mtk_eth_offload_init(eth);
+		if (err)
+			goto err_free_dev;
 	}
 
 	for (i = 0; i < MTK_MAX_DEVS; i++) {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 1db6c52ef256..72757977ccfb 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -15,6 +15,7 @@
 #include <linux/u64_stats_sync.h>
 #include <linux/refcount.h>
 #include <linux/phylink.h>
+#include <linux/rhashtable.h>
 #include "mtk_ppe.h"
 
 #define MTK_QDMA_PAGE_SIZE	2048
@@ -41,7 +42,8 @@
 				 NETIF_F_HW_VLAN_CTAG_RX | \
 				 NETIF_F_SG | NETIF_F_TSO | \
 				 NETIF_F_TSO6 | \
-				 NETIF_F_IPV6_CSUM)
+				 NETIF_F_IPV6_CSUM |\
+				 NETIF_F_HW_TC)
 #define MTK_HW_FEATURES_MT7628	(NETIF_F_SG | NETIF_F_RXCSUM)
 #define NEXT_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
 
@@ -912,6 +914,7 @@ struct mtk_eth {
 	int				ip_align;
 
 	struct mtk_ppe			ppe;
+	struct rhashtable		flow_table;
 };
 
 /* struct mtk_mac -	the structure that holds the info about the MACs of the
@@ -956,4 +959,9 @@ int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id);
 int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id);
 int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id);
 
+int mtk_eth_offload_init(struct mtk_eth *eth);
+int mtk_eth_setup_tc(struct net_device *dev, enum tc_setup_type type,
+		     void *type_data);
+
+
 #endif /* MTK_ETH_H */
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
new file mode 100644
index 000000000000..d0c46786571f
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -0,0 +1,485 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Copyright (C) 2020 Felix Fietkau <nbd@nbd.name>
+ */
+
+#include <linux/if_ether.h>
+#include <linux/rhashtable.h>
+#include <linux/if_ether.h>
+#include <linux/ip.h>
+#include <net/flow_offload.h>
+#include <net/pkt_cls.h>
+#include <net/dsa.h>
+#include "mtk_eth_soc.h"
+
+struct mtk_flow_data {
+	struct ethhdr eth;
+
+	union {
+		struct {
+			__be32 src_addr;
+			__be32 dst_addr;
+		} v4;
+	};
+
+	__be16 src_port;
+	__be16 dst_port;
+
+	struct {
+		u16 id;
+		__be16 proto;
+		u8 num;
+	} vlan;
+	struct {
+		u16 sid;
+		u8 num;
+	} pppoe;
+};
+
+struct mtk_flow_entry {
+	struct rhash_head node;
+	unsigned long cookie;
+	u16 hash;
+};
+
+static const struct rhashtable_params mtk_flow_ht_params = {
+	.head_offset = offsetof(struct mtk_flow_entry, node),
+	.head_offset = offsetof(struct mtk_flow_entry, cookie),
+	.key_len = sizeof(unsigned long),
+	.automatic_shrinking = true,
+};
+
+static u32
+mtk_eth_timestamp(struct mtk_eth *eth)
+{
+	return mtk_r32(eth, 0x0010) & MTK_FOE_IB1_BIND_TIMESTAMP;
+}
+
+static int
+mtk_flow_set_ipv4_addr(struct mtk_foe_entry *foe, struct mtk_flow_data *data,
+		       bool egress)
+{
+	return mtk_foe_entry_set_ipv4_tuple(foe, egress,
+					    data->v4.src_addr, data->src_port,
+					    data->v4.dst_addr, data->dst_port);
+}
+
+static void
+mtk_flow_offload_mangle_eth(const struct flow_action_entry *act, void *eth)
+{
+	void *dest = eth + act->mangle.offset;
+	const void *src = &act->mangle.val;
+
+	if (act->mangle.offset > 8)
+		return;
+
+	if (act->mangle.mask == 0xffff) {
+		src += 2;
+		dest += 2;
+	}
+
+	memcpy(dest, src, act->mangle.mask ? 2 : 4);
+}
+
+
+static int
+mtk_flow_mangle_ports(const struct flow_action_entry *act,
+		      struct mtk_flow_data *data)
+{
+	u32 val = ntohl(act->mangle.val);
+
+	switch (act->mangle.offset) {
+	case 0:
+		if (act->mangle.mask == ~htonl(0xffff))
+			data->dst_port = cpu_to_be16(val);
+		else
+			data->src_port = cpu_to_be16(val >> 16);
+		break;
+	case 2:
+		data->dst_port = cpu_to_be16(val);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+mtk_flow_mangle_ipv4(const struct flow_action_entry *act,
+		     struct mtk_flow_data *data)
+{
+	__be32 *dest;
+
+	switch (act->mangle.offset) {
+	case offsetof(struct iphdr, saddr):
+		dest = &data->v4.src_addr;
+		break;
+	case offsetof(struct iphdr, daddr):
+		dest = &data->v4.dst_addr;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	memcpy(dest, &act->mangle.val, sizeof(u32));
+
+	return 0;
+}
+
+static int
+mtk_flow_get_dsa_port(struct net_device **dev)
+{
+#if IS_ENABLED(CONFIG_NET_DSA)
+	struct dsa_port *dp;
+
+	dp = dsa_port_from_netdev(*dev);
+	if (IS_ERR(dp))
+		return -ENODEV;
+
+	if (dp->cpu_dp->tag_ops->proto != DSA_TAG_PROTO_MTK)
+		return -ENODEV;
+
+	*dev = dp->cpu_dp->master;
+
+	return dp->index;
+#else
+	return -ENODEV;
+#endif
+}
+
+static int
+mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
+			   struct net_device *dev)
+{
+	int pse_port, dsa_port;
+
+	dsa_port = mtk_flow_get_dsa_port(&dev);
+	if (dsa_port >= 0)
+		mtk_foe_entry_set_dsa(foe, dsa_port);
+
+	if (dev == eth->netdev[0])
+		pse_port = 1;
+	else if (dev == eth->netdev[1])
+		pse_port = 2;
+	else
+		return -EOPNOTSUPP;
+
+	mtk_foe_entry_set_pse_port(foe, pse_port);
+
+	return 0;
+}
+
+static int
+mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct flow_action_entry *act;
+	struct mtk_flow_data data = {};
+	struct mtk_foe_entry foe;
+	struct net_device *odev = NULL;
+	struct mtk_flow_entry *entry;
+	int offload_type = 0;
+	u16 addr_type = 0;
+	u32 timestamp;
+	u8 l4proto = 0;
+	int err = 0;
+	int hash;
+	int i;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META)) {
+		struct flow_match_meta match;
+
+		flow_rule_match_meta(rule, &match);
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_control(rule, &match);
+		addr_type = match.key->addr_type;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+		l4proto = match.key->ip_proto;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_MANGLE:
+			if (act->mangle.htype == FLOW_ACT_MANGLE_HDR_TYPE_ETH)
+				mtk_flow_offload_mangle_eth(act, &data.eth);
+			break;
+		case FLOW_ACTION_REDIRECT:
+			odev = act->dev;
+			break;
+		case FLOW_ACTION_CSUM:
+			break;
+		case FLOW_ACTION_VLAN_PUSH:
+			if (data.vlan.num == 1 ||
+			    act->vlan.proto != htons(ETH_P_8021Q))
+				return -EOPNOTSUPP;
+
+			data.vlan.id = act->vlan.vid;
+			data.vlan.proto = act->vlan.proto;
+			data.vlan.num++;
+			break;
+		case FLOW_ACTION_PPPOE_PUSH:
+			if (data.pppoe.num == 1)
+				return -EOPNOTSUPP;
+
+			data.pppoe.sid = act->pppoe.sid;
+			data.pppoe.num++;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+
+	switch (addr_type) {
+	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
+		offload_type = MTK_PPE_PKT_TYPE_IPV4_HNAPT;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (!is_valid_ether_addr(data.eth.h_source) ||
+	    !is_valid_ether_addr(data.eth.h_dest))
+		return -EINVAL;
+
+	err = mtk_foe_entry_prepare(&foe, offload_type, l4proto, 0,
+				    data.eth.h_source,
+				    data.eth.h_dest);
+	if (err)
+		return err;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports ports;
+
+		flow_rule_match_ports(rule, &ports);
+		data.src_port = ports.key->src;
+		data.dst_port = ports.key->dst;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		struct flow_match_ipv4_addrs addrs;
+
+		flow_rule_match_ipv4_addrs(rule, &addrs);
+
+		data.v4.src_addr = addrs.key->src;
+		data.v4.dst_addr = addrs.key->dst;
+
+		mtk_flow_set_ipv4_addr(&foe, &data, false);
+	}
+
+	flow_action_for_each(i, act, &rule->action) {
+		if (act->id != FLOW_ACTION_MANGLE)
+			continue;
+
+		switch (act->mangle.htype) {
+		case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
+		case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
+			err = mtk_flow_mangle_ports(act, &data);
+			break;
+		case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
+			err = mtk_flow_mangle_ipv4(act, &data);
+			break;
+		case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
+			/* handled earlier */
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+
+		if (err)
+			return err;
+	}
+
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		err = mtk_flow_set_ipv4_addr(&foe, &data, true);
+		if (err)
+			return err;
+	}
+
+	if (data.vlan.num == 1) {
+		if (data.vlan.proto != htons(ETH_P_8021Q))
+			return -EOPNOTSUPP;
+
+		mtk_foe_entry_set_vlan(&foe, data.vlan.id);
+	}
+	if (data.pppoe.num == 1)
+		mtk_foe_entry_set_pppoe(&foe, data.pppoe.sid);
+
+	err = mtk_flow_set_output_device(eth, &foe, odev);
+	if (err)
+		return err;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->cookie = f->cookie;
+	timestamp = mtk_eth_timestamp(eth);
+	hash = mtk_foe_entry_commit(&eth->ppe, &foe, timestamp);
+	if (hash < 0) {
+		err = hash;
+		goto free;
+	}
+
+	entry->hash = hash;
+	err = rhashtable_insert_fast(&eth->flow_table, &entry->node,
+				     mtk_flow_ht_params);
+	if (err < 0)
+		goto clear_flow;
+
+	return 0;
+clear_flow:
+	mtk_foe_entry_clear(&eth->ppe, hash);
+free:
+	kfree(entry);
+	return err;
+}
+
+static int
+mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
+{
+	struct mtk_flow_entry *entry;
+
+	entry = rhashtable_lookup(&eth->flow_table, &f->cookie,
+				  mtk_flow_ht_params);
+	if (!entry)
+		return -ENOENT;
+
+	mtk_foe_entry_clear(&eth->ppe, entry->hash);
+	rhashtable_remove_fast(&eth->flow_table, &entry->node,
+			       mtk_flow_ht_params);
+	kfree(entry);
+
+	return 0;
+}
+
+static int
+mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
+{
+	struct mtk_flow_entry *entry;
+	int timestamp;
+	u32 idle;
+
+	entry = rhashtable_lookup(&eth->flow_table, &f->cookie,
+				  mtk_flow_ht_params);
+	if (!entry)
+		return -ENOENT;
+
+	timestamp = mtk_foe_entry_timestamp(&eth->ppe, entry->hash);
+	if (timestamp < 0)
+		return -ETIMEDOUT;
+
+	idle = mtk_eth_timestamp(eth) - timestamp;
+	f->stats.lastused = jiffies - idle * HZ;
+
+	return 0;
+}
+
+static int
+mtk_eth_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+{
+	struct flow_cls_offload *cls = type_data;
+	struct net_device *dev = cb_priv;
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+
+	if (!tc_can_offload(dev))
+		return -EOPNOTSUPP;
+
+	if (type != TC_SETUP_CLSFLOWER)
+		return -EOPNOTSUPP;
+
+	switch (cls->command) {
+	case FLOW_CLS_REPLACE:
+		return mtk_flow_offload_replace(eth, cls);
+	case FLOW_CLS_DESTROY:
+		return mtk_flow_offload_destroy(eth, cls);
+	case FLOW_CLS_STATS:
+		return mtk_flow_offload_stats(eth, cls);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
+{
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
+	static LIST_HEAD(block_cb_list);
+	struct flow_block_cb *block_cb;
+	flow_setup_cb_t *cb;
+
+	if (!eth->ppe.foe_table)
+		return -EOPNOTSUPP;
+
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	cb = mtk_eth_setup_tc_block_cb;
+	f->driver_block_list = &block_cb_list;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		block_cb = flow_block_cb_lookup(f->block, cb, dev);
+		if (block_cb) {
+			flow_block_cb_incref(block_cb);
+			return 0;
+		}
+		block_cb = flow_block_cb_alloc(cb, dev, dev, NULL);
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
+
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &block_cb_list);
+		return 0;
+	case FLOW_BLOCK_UNBIND:
+		block_cb = flow_block_cb_lookup(f->block, cb, dev);
+		if (!block_cb)
+			return -ENOENT;
+
+		if (flow_block_cb_decref(block_cb)) {
+			flow_block_cb_remove(block_cb, f);
+			list_del(&block_cb->driver_list);
+		}
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+int mtk_eth_setup_tc(struct net_device *dev, enum tc_setup_type type,
+		     void *type_data)
+{
+	if (type == TC_SETUP_FT)
+		return mtk_eth_setup_tc_block(dev, type_data);
+
+	return -EOPNOTSUPP;
+}
+
+int mtk_eth_offload_init(struct mtk_eth *eth)
+{
+	if (!eth->ppe.foe_table)
+		return 0;
+
+	return rhashtable_init(&eth->flow_table, &mtk_flow_ht_params);
+}
-- 
2.20.1


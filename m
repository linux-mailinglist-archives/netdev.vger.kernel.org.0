Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B69B35E001
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345959AbhDMN0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345738AbhDMN0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:26:21 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F07CC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:26:02 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w8so5873639plg.9
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kV0nBeGD4juT23ScwjRlCjxpVKrz4wR66jJ5QfFJBQw=;
        b=cYrb3zPdQjxDzkZmMuIb2p3IFVRemc47H7OPoBjR4jXyyFcU0tZE1JHcgRtHG3cAyr
         UYXKTRkSaFhsZBwyWSCQLazqnH+nCmpM4dtw1KCHm5ec1g5qIceQ/OafQVosee8WT//v
         amAsxa++0pis2FxEA94yaL7GYqXDJbNC2d2i0u5zhXnKIlI0I5ob8YImsSbieYW2tdxJ
         Q1OD5i3nN/YTpJGEbmv09uIx7Ymduv6DWGkgpgmOLmweJng8VajrH6bgIspKgJTm95RD
         7LRb5OUd7yQSyyNJiHxJVBr+IiEe1kPXnp0fsPb64AzUnw5HQO1tgPyvp71BGOtVvuMN
         SQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kV0nBeGD4juT23ScwjRlCjxpVKrz4wR66jJ5QfFJBQw=;
        b=G5Gi6fPJU8xpzEQdSa8ydx7fSho/bPmIdwbbO14i+c1wTYdneskeomcbEAaaRFuvNK
         b5Q6vqhBBqa7fvVwolcQ/5oQ67LNiCUZrbiI+TbKawBjBdIt1vzN4LaL5FPTPGdK3TXI
         ZvtCvVlIsdfB/W1K6EROMYK9PZumnk9MnUBGFUe7EeRQ8pAW12UjI1WHl85lvPuITnHd
         gm/pWxFd2uTnpXZoz1NxS5vaLVsVvSkQtiKubyx3WjHCFXKGDo7LYvSMAe0AzT1JCbLu
         g1syLDb4vfwJ17AQDJUodlK8IvWMG/ORMJjPjEc/8Ysu7ePpNFEmRm7uDr4TQ3eCK+dv
         YLZg==
X-Gm-Message-State: AOAM533p2jblObCbGyQqyL6jNMwEron9WRJYii8IDsMeD4kj4Uoom+Tq
        cNW/bbRhatxwwKahHHPUsVqjg1nMdLq6hA==
X-Google-Smtp-Source: ABdhPJwYKsVLlz7iX5C76RlkWyJYuu2s1MNR8RpQp+3kV2tWqcfibK9g5gSmnYjrlL3ETFLFXnbZWg==
X-Received: by 2002:a17:90a:a10c:: with SMTP id s12mr26775pjp.166.1618320361490;
        Tue, 13 Apr 2021 06:26:01 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z18sm12417650pfa.39.2021.04.13.06.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:26:00 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/5] dpaa2-switch: add tc flower hardware offload on ingress traffic
Date:   Tue, 13 Apr 2021 16:24:46 +0300
Message-Id: <20210413132448.4141787-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210413132448.4141787-1-ciorneiioana@gmail.com>
References: <20210413132448.4141787-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch adds support for tc flower hardware offload on the ingress
path. Shared filter blocks are supported by sharing a single ACL table
between multiple ports.

The following flow keys are supported:
 - Ethernet: dst_mac/src_mac
 - IPv4: dst_ip/src_ip/ip_proto/tos
 - VLAN: vlan_id/vlan_prio/vlan_tpid/vlan_dei
 - L4: dst_port/src_port

As per flow actions, the following are supported:
 - drop
 - mirred egress redirect
 - trap
Each ACL entry (filter) can be setup with only one of the listed
actions.

A sorted single linked list is used to keep the ACL entries by their
order of priority. When adding a new filter, this enables us to quickly
ascertain if the new entry has the highest priority of the entire block
or if we should make some space in the ACL table by increasing the
priority of the filters already in the table.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
 .../freescale/dpaa2/dpaa2-switch-flower.c     | 436 ++++++++++++++++++
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 261 ++++++++++-
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  44 ++
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   |   1 +
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   |  35 ++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   |   3 +
 7 files changed, 768 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c

diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
index 644ef9ae02a3..c2ef74052ef8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -11,7 +11,7 @@ fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpa
 fsl-dpaa2-eth-${CONFIG_FSL_DPAA2_ETH_DCB} += dpaa2-eth-dcb.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
 fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
-fsl-dpaa2-switch-objs	:= dpaa2-switch.o dpaa2-switch-ethtool.o dpsw.o
+fsl-dpaa2-switch-objs	:= dpaa2-switch.o dpaa2-switch-ethtool.o dpsw.o dpaa2-switch-flower.o
 
 # Needed by the tracing framework
 CFLAGS_dpaa2-eth.o := -I$(src)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
new file mode 100644
index 000000000000..ee987fa02f0d
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -0,0 +1,436 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DPAA2 Ethernet Switch flower support
+ *
+ * Copyright 2021 NXP
+ *
+ */
+
+#include "dpaa2-switch.h"
+
+static int dpaa2_switch_flower_parse_key(struct flow_cls_offload *cls,
+					 struct dpsw_acl_key *acl_key)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct dpsw_acl_fields *acl_h, *acl_m;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
+	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_IP) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Unsupported keys used");
+		return -EOPNOTSUPP;
+	}
+
+	acl_h = &acl_key->match;
+	acl_m = &acl_key->mask;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+
+		flow_rule_match_basic(rule, &match);
+		acl_h->l3_protocol = match.key->ip_proto;
+		acl_h->l2_ether_type = be16_to_cpu(match.key->n_proto);
+		acl_m->l3_protocol = match.mask->ip_proto;
+		acl_m->l2_ether_type = be16_to_cpu(match.mask->n_proto);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(rule, &match);
+		ether_addr_copy(acl_h->l2_dest_mac, &match.key->dst[0]);
+		ether_addr_copy(acl_h->l2_source_mac, &match.key->src[0]);
+		ether_addr_copy(acl_m->l2_dest_mac, &match.mask->dst[0]);
+		ether_addr_copy(acl_m->l2_source_mac, &match.mask->src[0]);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		acl_h->l2_vlan_id = match.key->vlan_id;
+		acl_h->l2_tpid = be16_to_cpu(match.key->vlan_tpid);
+		acl_h->l2_pcp_dei = match.key->vlan_priority << 1 |
+				    match.key->vlan_dei;
+
+		acl_m->l2_vlan_id = match.mask->vlan_id;
+		acl_m->l2_tpid = be16_to_cpu(match.mask->vlan_tpid);
+		acl_m->l2_pcp_dei = match.mask->vlan_priority << 1 |
+				    match.mask->vlan_dei;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(rule, &match);
+		acl_h->l3_source_ip = be32_to_cpu(match.key->src);
+		acl_h->l3_dest_ip = be32_to_cpu(match.key->dst);
+		acl_m->l3_source_ip = be32_to_cpu(match.mask->src);
+		acl_m->l3_dest_ip = be32_to_cpu(match.mask->dst);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(rule, &match);
+		acl_h->l4_source_port = be16_to_cpu(match.key->src);
+		acl_h->l4_dest_port = be16_to_cpu(match.key->dst);
+		acl_m->l4_source_port = be16_to_cpu(match.mask->src);
+		acl_m->l4_dest_port = be16_to_cpu(match.mask->dst);
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+		struct flow_match_ip match;
+
+		flow_rule_match_ip(rule, &match);
+		if (match.mask->ttl != 0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Matching on TTL not supported");
+			return -EOPNOTSUPP;
+		}
+
+		if ((match.mask->tos & 0x3) != 0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Matching on ECN not supported, only DSCP");
+			return -EOPNOTSUPP;
+		}
+
+		acl_h->l3_dscp = match.key->tos >> 2;
+		acl_m->l3_dscp = match.mask->tos >> 2;
+	}
+
+	return 0;
+}
+
+static int dpaa2_switch_acl_entry_add(struct dpaa2_switch_acl_tbl *acl_tbl,
+				      struct dpaa2_switch_acl_entry *entry)
+{
+	struct dpsw_acl_entry_cfg *acl_entry_cfg = &entry->cfg;
+	struct ethsw_core *ethsw = acl_tbl->ethsw;
+	struct dpsw_acl_key *acl_key = &entry->key;
+	struct device *dev = ethsw->dev;
+	u8 *cmd_buff;
+	int err;
+
+	cmd_buff = kzalloc(DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE, GFP_KERNEL);
+	if (!cmd_buff)
+		return -ENOMEM;
+
+	dpsw_acl_prepare_entry_cfg(acl_key, cmd_buff);
+
+	acl_entry_cfg->key_iova = dma_map_single(dev, cmd_buff,
+						 DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE,
+						 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
+		dev_err(dev, "DMA mapping failed\n");
+		return -EFAULT;
+	}
+
+	err = dpsw_acl_add_entry(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				 acl_tbl->id, acl_entry_cfg);
+
+	dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
+			 DMA_TO_DEVICE);
+	if (err) {
+		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
+		return err;
+	}
+
+	kfree(cmd_buff);
+
+	return 0;
+}
+
+static int dpaa2_switch_acl_entry_remove(struct dpaa2_switch_acl_tbl *acl_tbl,
+					 struct dpaa2_switch_acl_entry *entry)
+{
+	struct dpsw_acl_entry_cfg *acl_entry_cfg = &entry->cfg;
+	struct dpsw_acl_key *acl_key = &entry->key;
+	struct ethsw_core *ethsw = acl_tbl->ethsw;
+	struct device *dev = ethsw->dev;
+	u8 *cmd_buff;
+	int err;
+
+	cmd_buff = kzalloc(DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE, GFP_KERNEL);
+	if (!cmd_buff)
+		return -ENOMEM;
+
+	dpsw_acl_prepare_entry_cfg(acl_key, cmd_buff);
+
+	acl_entry_cfg->key_iova = dma_map_single(dev, cmd_buff,
+						 DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE,
+						 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
+		dev_err(dev, "DMA mapping failed\n");
+		return -EFAULT;
+	}
+
+	err = dpsw_acl_remove_entry(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				    acl_tbl->id, acl_entry_cfg);
+
+	dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
+			 DMA_TO_DEVICE);
+	if (err) {
+		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
+		return err;
+	}
+
+	kfree(cmd_buff);
+
+	return 0;
+}
+
+static int
+dpaa2_switch_acl_entry_add_to_list(struct dpaa2_switch_acl_tbl *acl_tbl,
+				   struct dpaa2_switch_acl_entry *entry)
+{
+	struct dpaa2_switch_acl_entry *tmp;
+	struct list_head *pos, *n;
+	int index = 0;
+
+	if (list_empty(&acl_tbl->entries)) {
+		list_add(&entry->list, &acl_tbl->entries);
+		return index;
+	}
+
+	list_for_each_safe(pos, n, &acl_tbl->entries) {
+		tmp = list_entry(pos, struct dpaa2_switch_acl_entry, list);
+		if (entry->prio < tmp->prio)
+			break;
+		index++;
+	}
+	list_add(&entry->list, pos->prev);
+	return index;
+}
+
+static struct dpaa2_switch_acl_entry*
+dpaa2_switch_acl_entry_get_by_index(struct dpaa2_switch_acl_tbl *acl_tbl,
+				    int index)
+{
+	struct dpaa2_switch_acl_entry *tmp;
+	int i = 0;
+
+	list_for_each_entry(tmp, &acl_tbl->entries, list) {
+		if (i == index)
+			return tmp;
+		++i;
+	}
+
+	return NULL;
+}
+
+static int
+dpaa2_switch_acl_entry_set_precedence(struct dpaa2_switch_acl_tbl *acl_tbl,
+				      struct dpaa2_switch_acl_entry *entry,
+				      int precedence)
+{
+	int err;
+
+	err = dpaa2_switch_acl_entry_remove(acl_tbl, entry);
+	if (err)
+		return err;
+
+	entry->cfg.precedence = precedence;
+	return dpaa2_switch_acl_entry_add(acl_tbl, entry);
+}
+
+static int dpaa2_switch_acl_tbl_add_entry(struct dpaa2_switch_acl_tbl *acl_tbl,
+					  struct dpaa2_switch_acl_entry *entry)
+{
+	struct dpaa2_switch_acl_entry *tmp;
+	int index, i, precedence, err;
+
+	/* Add the new ACL entry to the linked list and get its index */
+	index = dpaa2_switch_acl_entry_add_to_list(acl_tbl, entry);
+
+	/* Move up in priority the ACL entries to make space
+	 * for the new filter.
+	 */
+	precedence = DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES - acl_tbl->num_rules - 1;
+	for (i = 0; i < index; i++) {
+		tmp = dpaa2_switch_acl_entry_get_by_index(acl_tbl, i);
+
+		err = dpaa2_switch_acl_entry_set_precedence(acl_tbl, tmp,
+							    precedence);
+		if (err)
+			return err;
+
+		precedence++;
+	}
+
+	/* Add the new entry to hardware */
+	entry->cfg.precedence = precedence;
+	err = dpaa2_switch_acl_entry_add(acl_tbl, entry);
+	acl_tbl->num_rules++;
+
+	return err;
+}
+
+static struct dpaa2_switch_acl_entry *
+dpaa2_switch_acl_tbl_find_entry_by_cookie(struct dpaa2_switch_acl_tbl *acl_tbl,
+					  unsigned long cookie)
+{
+	struct dpaa2_switch_acl_entry *tmp, *n;
+
+	list_for_each_entry_safe(tmp, n, &acl_tbl->entries, list) {
+		if (tmp->cookie == cookie)
+			return tmp;
+	}
+	return NULL;
+}
+
+static int
+dpaa2_switch_acl_entry_get_index(struct dpaa2_switch_acl_tbl *acl_tbl,
+				 struct dpaa2_switch_acl_entry *entry)
+{
+	struct dpaa2_switch_acl_entry *tmp, *n;
+	int index = 0;
+
+	list_for_each_entry_safe(tmp, n, &acl_tbl->entries, list) {
+		if (tmp->cookie == entry->cookie)
+			return index;
+		index++;
+	}
+	return -ENOENT;
+}
+
+static int
+dpaa2_switch_acl_tbl_remove_entry(struct dpaa2_switch_acl_tbl *acl_tbl,
+				  struct dpaa2_switch_acl_entry *entry)
+{
+	struct dpaa2_switch_acl_entry *tmp;
+	int index, i, precedence, err;
+
+	index = dpaa2_switch_acl_entry_get_index(acl_tbl, entry);
+
+	/* Remove from hardware the ACL entry */
+	err = dpaa2_switch_acl_entry_remove(acl_tbl, entry);
+	if (err)
+		return err;
+
+	acl_tbl->num_rules--;
+
+	/* Remove it from the list also */
+	list_del(&entry->list);
+
+	/* Move down in priority the entries over the deleted one */
+	precedence = entry->cfg.precedence;
+	for (i = index - 1; i >= 0; i--) {
+		tmp = dpaa2_switch_acl_entry_get_by_index(acl_tbl, i);
+		err = dpaa2_switch_acl_entry_set_precedence(acl_tbl, tmp,
+							    precedence);
+		if (err)
+			return err;
+
+		precedence--;
+	}
+
+	kfree(entry);
+
+	return 0;
+}
+
+static int dpaa2_switch_tc_parse_action(struct ethsw_core *ethsw,
+					struct flow_action_entry *cls_act,
+					struct dpsw_acl_result *dpsw_act,
+					struct netlink_ext_ack *extack)
+{
+	int err = 0;
+
+	switch (cls_act->id) {
+	case FLOW_ACTION_TRAP:
+		dpsw_act->action = DPSW_ACL_ACTION_REDIRECT_TO_CTRL_IF;
+		break;
+	case FLOW_ACTION_REDIRECT:
+		if (!dpaa2_switch_port_dev_check(cls_act->dev)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Destination not a DPAA2 switch port");
+			return -EOPNOTSUPP;
+		}
+
+		dpsw_act->if_id = dpaa2_switch_get_index(ethsw, cls_act->dev);
+		dpsw_act->action = DPSW_ACL_ACTION_REDIRECT;
+		break;
+	case FLOW_ACTION_DROP:
+		dpsw_act->action = DPSW_ACL_ACTION_DROP;
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Action not supported");
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+out:
+	return err;
+}
+
+int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
+				    struct flow_cls_offload *cls)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct ethsw_core *ethsw = acl_tbl->ethsw;
+	struct dpaa2_switch_acl_entry *acl_entry;
+	struct flow_action_entry *act;
+	int err;
+
+	if (!flow_offload_has_one_action(&rule->action)) {
+		NL_SET_ERR_MSG(extack, "Only singular actions are supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (dpaa2_switch_acl_tbl_is_full(acl_tbl)) {
+		NL_SET_ERR_MSG(extack, "Maximum filter capacity reached");
+		return -ENOMEM;
+	}
+
+	acl_entry = kzalloc(sizeof(*acl_entry), GFP_KERNEL);
+	if (!acl_entry)
+		return -ENOMEM;
+
+	err = dpaa2_switch_flower_parse_key(cls, &acl_entry->key);
+	if (err)
+		goto free_acl_entry;
+
+	act = &rule->action.entries[0];
+	err = dpaa2_switch_tc_parse_action(ethsw, act,
+					   &acl_entry->cfg.result, extack);
+	if (err)
+		goto free_acl_entry;
+
+	acl_entry->prio = cls->common.prio;
+	acl_entry->cookie = cls->cookie;
+
+	err = dpaa2_switch_acl_tbl_add_entry(acl_tbl, acl_entry);
+	if (err)
+		goto free_acl_entry;
+
+	return 0;
+
+free_acl_entry:
+	kfree(acl_entry);
+
+	return err;
+}
+
+int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
+				    struct flow_cls_offload *cls)
+{
+	struct dpaa2_switch_acl_entry *entry;
+
+	entry = dpaa2_switch_acl_tbl_find_entry_by_cookie(acl_tbl, cls->cookie);
+	if (!entry)
+		return 0;
+
+	return dpaa2_switch_acl_tbl_remove_entry(acl_tbl, entry);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index fc9e2eb0ad11..5080788c692b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/workqueue.h>
 #include <linux/iommu.h>
+#include <net/pkt_cls.h>
 
 #include <linux/fsl/mc.h>
 
@@ -1125,6 +1126,243 @@ static netdev_tx_t dpaa2_switch_port_tx(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int
+dpaa2_switch_setup_tc_cls_flower(struct dpaa2_switch_acl_tbl *acl_tbl,
+				 struct flow_cls_offload *f)
+{
+	switch (f->command) {
+	case FLOW_CLS_REPLACE:
+		return dpaa2_switch_cls_flower_replace(acl_tbl, f);
+	case FLOW_CLS_DESTROY:
+		return dpaa2_switch_cls_flower_destroy(acl_tbl, f);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int dpaa2_switch_port_setup_tc_block_cb_ig(enum tc_setup_type type,
+						  void *type_data,
+						  void *cb_priv)
+{
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return dpaa2_switch_setup_tc_cls_flower(cb_priv, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static LIST_HEAD(dpaa2_switch_block_cb_list);
+
+static int dpaa2_switch_port_acl_tbl_bind(struct ethsw_port_priv *port_priv,
+					  struct dpaa2_switch_acl_tbl *acl_tbl)
+{
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct net_device *netdev = port_priv->netdev;
+	struct dpsw_acl_if_cfg acl_if_cfg;
+	int err;
+
+	if (port_priv->acl_tbl)
+		return -EINVAL;
+
+	acl_if_cfg.if_id[0] = port_priv->idx;
+	acl_if_cfg.num_ifs = 1;
+	err = dpsw_acl_add_if(ethsw->mc_io, 0, ethsw->dpsw_handle,
+			      acl_tbl->id, &acl_if_cfg);
+	if (err) {
+		netdev_err(netdev, "dpsw_acl_add_if err %d\n", err);
+		return err;
+	}
+
+	acl_tbl->ports |= BIT(port_priv->idx);
+	port_priv->acl_tbl = acl_tbl;
+
+	return 0;
+}
+
+static int
+dpaa2_switch_port_acl_tbl_unbind(struct ethsw_port_priv *port_priv,
+				 struct dpaa2_switch_acl_tbl *acl_tbl)
+{
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct net_device *netdev = port_priv->netdev;
+	struct dpsw_acl_if_cfg acl_if_cfg;
+	int err;
+
+	if (port_priv->acl_tbl != acl_tbl)
+		return -EINVAL;
+
+	acl_if_cfg.if_id[0] = port_priv->idx;
+	acl_if_cfg.num_ifs = 1;
+	err = dpsw_acl_remove_if(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				 acl_tbl->id, &acl_if_cfg);
+	if (err) {
+		netdev_err(netdev, "dpsw_acl_add_if err %d\n", err);
+		return err;
+	}
+
+	acl_tbl->ports &= ~BIT(port_priv->idx);
+	port_priv->acl_tbl = NULL;
+	return 0;
+}
+
+static int dpaa2_switch_port_block_bind(struct ethsw_port_priv *port_priv,
+					struct dpaa2_switch_acl_tbl *acl_tbl)
+{
+	struct dpaa2_switch_acl_tbl *old_acl_tbl = port_priv->acl_tbl;
+	int err;
+
+	/* If the port is already bound to this ACL table then do nothing. This
+	 * can happen when this port is the first one to join a tc block
+	 */
+	if (port_priv->acl_tbl == acl_tbl)
+		return 0;
+
+	err = dpaa2_switch_port_acl_tbl_unbind(port_priv, old_acl_tbl);
+	if (err)
+		return err;
+
+	/* Mark the previous ACL table as being unused if this was the last
+	 * port that was using it.
+	 */
+	if (old_acl_tbl->ports == 0)
+		old_acl_tbl->in_use = false;
+
+	return dpaa2_switch_port_acl_tbl_bind(port_priv, acl_tbl);
+}
+
+static int dpaa2_switch_port_block_unbind(struct ethsw_port_priv *port_priv,
+					  struct dpaa2_switch_acl_tbl *acl_tbl)
+{
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpaa2_switch_acl_tbl *new_acl_tbl;
+	int err;
+
+	/* We are the last port that leaves a block (an ACL table).
+	 * We'll continue to use this table.
+	 */
+	if (acl_tbl->ports == BIT(port_priv->idx))
+		return 0;
+
+	err = dpaa2_switch_port_acl_tbl_unbind(port_priv, acl_tbl);
+	if (err)
+		return err;
+
+	if (acl_tbl->ports == 0)
+		acl_tbl->in_use = false;
+
+	new_acl_tbl = dpaa2_switch_acl_tbl_get_unused(ethsw);
+	new_acl_tbl->in_use = true;
+	return dpaa2_switch_port_acl_tbl_bind(port_priv, new_acl_tbl);
+}
+
+static int dpaa2_switch_setup_tc_block_bind(struct net_device *netdev,
+					    struct flow_block_offload *f)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpaa2_switch_acl_tbl *acl_tbl;
+	struct flow_block_cb *block_cb;
+	bool register_block = false;
+	int err;
+
+	block_cb = flow_block_cb_lookup(f->block,
+					dpaa2_switch_port_setup_tc_block_cb_ig,
+					ethsw);
+
+	if (!block_cb) {
+		/* If the ACL table is not already known, then this port must
+		 * be the first to join it. In this case, we can just continue
+		 * to use our private table
+		 */
+		acl_tbl = port_priv->acl_tbl;
+
+		block_cb = flow_block_cb_alloc(dpaa2_switch_port_setup_tc_block_cb_ig,
+					       ethsw, acl_tbl, NULL);
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
+
+		register_block = true;
+	} else {
+		acl_tbl = flow_block_cb_priv(block_cb);
+	}
+
+	flow_block_cb_incref(block_cb);
+	err = dpaa2_switch_port_block_bind(port_priv, acl_tbl);
+	if (err)
+		goto err_block_bind;
+
+	if (register_block) {
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list,
+			      &dpaa2_switch_block_cb_list);
+	}
+
+	return 0;
+
+err_block_bind:
+	if (!flow_block_cb_decref(block_cb))
+		flow_block_cb_free(block_cb);
+	return err;
+}
+
+static void dpaa2_switch_setup_tc_block_unbind(struct net_device *netdev,
+					       struct flow_block_offload *f)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpaa2_switch_acl_tbl *acl_tbl;
+	struct flow_block_cb *block_cb;
+	int err;
+
+	block_cb = flow_block_cb_lookup(f->block,
+					dpaa2_switch_port_setup_tc_block_cb_ig,
+					ethsw);
+	if (!block_cb)
+		return;
+
+	acl_tbl = flow_block_cb_priv(block_cb);
+	err = dpaa2_switch_port_block_unbind(port_priv, acl_tbl);
+	if (!err && !flow_block_cb_decref(block_cb)) {
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
+	}
+}
+
+static int dpaa2_switch_setup_tc_block(struct net_device *netdev,
+				       struct flow_block_offload *f)
+{
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	f->driver_block_list = &dpaa2_switch_block_cb_list;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		return dpaa2_switch_setup_tc_block_bind(netdev, f);
+	case FLOW_BLOCK_UNBIND:
+		dpaa2_switch_setup_tc_block_unbind(netdev, f);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int dpaa2_switch_port_setup_tc(struct net_device *netdev,
+				      enum tc_setup_type type,
+				      void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_BLOCK: {
+		return dpaa2_switch_setup_tc_block(netdev, type_data);
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_open		= dpaa2_switch_port_open,
 	.ndo_stop		= dpaa2_switch_port_stop,
@@ -1141,6 +1379,7 @@ static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_start_xmit		= dpaa2_switch_port_tx,
 	.ndo_get_port_parent_id	= dpaa2_switch_port_parent_id,
 	.ndo_get_phys_port_name = dpaa2_switch_port_get_phys_name,
+	.ndo_setup_tc		= dpaa2_switch_port_setup_tc,
 };
 
 bool dpaa2_switch_port_dev_check(const struct net_device *netdev)
@@ -2749,7 +2988,6 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct dpaa2_switch_acl_tbl *acl_tbl;
 	struct dpsw_fdb_cfg fdb_cfg = {0};
-	struct dpsw_acl_if_cfg acl_if_cfg;
 	struct dpsw_if_attr dpsw_if_attr;
 	struct dpaa2_switch_fdb *fdb;
 	struct dpsw_acl_cfg acl_cfg;
@@ -2803,21 +3041,16 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 		return err;
 	}
 
-	acl_if_cfg.if_id[0] = port_priv->idx;
-	acl_if_cfg.num_ifs = 1;
-	err = dpsw_acl_add_if(ethsw->mc_io, 0, ethsw->dpsw_handle,
-			      acl_tbl_id, &acl_if_cfg);
-	if (err) {
-		netdev_err(netdev, "dpsw_acl_add_if err %d\n", err);
-		dpsw_acl_remove(ethsw->mc_io, 0, ethsw->dpsw_handle,
-				acl_tbl_id);
-	}
-
 	acl_tbl = dpaa2_switch_acl_tbl_get_unused(ethsw);
+	acl_tbl->ethsw = ethsw;
 	acl_tbl->id = acl_tbl_id;
 	acl_tbl->in_use = true;
 	acl_tbl->num_rules = 0;
-	port_priv->acl_tbl = acl_tbl;
+	INIT_LIST_HEAD(&acl_tbl->entries);
+
+	err = dpaa2_switch_port_acl_tbl_bind(port_priv, acl_tbl);
+	if (err)
+		return err;
 
 	err = dpaa2_switch_port_trap_mac_addr(port_priv, stpa);
 	if (err)
@@ -2927,7 +3160,9 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	/* The DPAA2 switch's ingress path depends on the VLAN table,
 	 * thus we are not able to disable VLAN filtering.
 	 */
-	port_netdev->features = NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER;
+	port_netdev->features = NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_STAG_FILTER |
+				NETIF_F_HW_TC;
 
 	err = dpaa2_switch_port_init(port_priv, port_idx);
 	if (err)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index a2c0ff23c7e9..629186208b58 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -80,6 +80,8 @@
 	(DPAA2_SWITCH_TX_DATA_OFFSET + DPAA2_SWITCH_TX_BUF_ALIGN)
 
 #define DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES	16
+#define DPAA2_ETHSW_PORT_DEFAULT_TRAPS		1
+
 #define DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE	256
 
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
@@ -101,12 +103,34 @@ struct dpaa2_switch_fdb {
 	bool			in_use;
 };
 
+struct dpaa2_switch_acl_entry {
+	struct list_head	list;
+	u16			prio;
+	unsigned long		cookie;
+
+	struct dpsw_acl_entry_cfg cfg;
+	struct dpsw_acl_key	key;
+};
+
 struct dpaa2_switch_acl_tbl {
+	struct list_head	entries;
+	struct ethsw_core	*ethsw;
+	u64			ports;
+
 	u16			id;
 	u8			num_rules;
 	bool			in_use;
 };
 
+static inline bool
+dpaa2_switch_acl_tbl_is_full(struct dpaa2_switch_acl_tbl *acl_tbl)
+{
+	if ((acl_tbl->num_rules + DPAA2_ETHSW_PORT_DEFAULT_TRAPS) >=
+	    DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES)
+		return true;
+	return false;
+}
+
 /* Per port private data */
 struct ethsw_port_priv {
 	struct net_device	*netdev;
@@ -153,6 +177,18 @@ struct ethsw_core {
 	struct dpaa2_switch_acl_tbl	*acls;
 };
 
+static inline int dpaa2_switch_get_index(struct ethsw_core *ethsw,
+					 struct net_device *netdev)
+{
+	int i;
+
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
+		if (ethsw->ports[i]->netdev == netdev)
+			return ethsw->ports[i]->idx;
+
+	return -EINVAL;
+}
+
 static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
 {
 	if (ethsw->sw_attr.options & DPSW_OPT_CTRL_IF_DIS) {
@@ -189,4 +225,12 @@ int dpaa2_switch_port_vlans_del(struct net_device *netdev,
 typedef int dpaa2_switch_fdb_cb_t(struct ethsw_port_priv *port_priv,
 				  struct fdb_dump_entry *fdb_entry,
 				  void *data);
+
+/* TC offload */
+
+int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
+				    struct flow_cls_offload *cls);
+
+int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_acl_tbl *acl_tbl,
+				    struct flow_cls_offload *cls);
 #endif	/* __ETHSW_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
index 1747cee19a72..cb13e740f72b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
@@ -77,6 +77,7 @@
 #define DPSW_CMDID_ACL_ADD                  DPSW_CMD_ID(0x090)
 #define DPSW_CMDID_ACL_REMOVE               DPSW_CMD_ID(0x091)
 #define DPSW_CMDID_ACL_ADD_ENTRY            DPSW_CMD_ID(0x092)
+#define DPSW_CMDID_ACL_REMOVE_ENTRY         DPSW_CMD_ID(0x093)
 #define DPSW_CMDID_ACL_ADD_IF               DPSW_CMD_ID(0x094)
 #define DPSW_CMDID_ACL_REMOVE_IF            DPSW_CMD_ID(0x095)
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
index 6704efe89bc1..6352d6d1ecba 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
@@ -1544,3 +1544,38 @@ int dpsw_acl_add_entry(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpsw_acl_remove_entry() - Removes an entry from ACL.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @acl_id:	ACL ID
+ * @cfg:	Entry configuration
+ *
+ * warning: This function has to be called after dpsw_acl_set_entry_cfg()
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_acl_remove_entry(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			  u16 acl_id, const struct dpsw_acl_entry_cfg *cfg)
+{
+	struct dpsw_cmd_acl_entry *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_ACL_REMOVE_ENTRY,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_acl_entry *)cmd.params;
+	cmd_params->acl_id = cpu_to_le16(acl_id);
+	cmd_params->result_if_id = cpu_to_le16(cfg->result.if_id);
+	cmd_params->precedence = cpu_to_le32(cfg->precedence);
+	cmd_params->key_iova = cpu_to_le64(cfg->key_iova);
+	dpsw_set_field(cmd_params->result_action,
+		       RESULT_ACTION,
+		       cfg->result.action);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
index 08e37c475ae8..5ef221a25b02 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
@@ -749,4 +749,7 @@ void dpsw_acl_prepare_entry_cfg(const struct dpsw_acl_key *key,
 
 int dpsw_acl_add_entry(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 		       u16 acl_id, const struct dpsw_acl_entry_cfg *cfg);
+
+int dpsw_acl_remove_entry(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			  u16 acl_id, const struct dpsw_acl_entry_cfg *cfg);
 #endif /* __FSL_DPSW_H */
-- 
2.30.0


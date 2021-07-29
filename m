Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FE03DA9EB
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhG2RSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbhG2RSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:18:01 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EB5C061796;
        Thu, 29 Jul 2021 10:17:56 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x14so9163814edr.12;
        Thu, 29 Jul 2021 10:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5LzLTds65teZUEbmIei4xV2GMvPjinpMxIUAiqV/JN0=;
        b=MC0GgheTQnid7x9Sq6s8WQJraSt8u9zEUA2m1Iien4P2+nD/ul6xBqvMAOLVvRogIE
         QnPe1lvVSzT6PYw4N1Nts2tfxh4lAAKOjgWsANwi5Ua9qlWPJc+L0oUjHcZT+OFFP32j
         B/Ms0WDoEwEgM4E1yrabmPrQ/QTPogXfoFspYmACFaF17hfT2qahsqRqmWE88yVZH0/F
         L1PAunqYdTBx2AA3cmOfCPJAZncYbCdTd+FAnxcoZhj3yXeMEhceq1FEh/okig1qNUh8
         4MCcDVAN1/Zk5TdequR71nRPDGTOJXofRcqUT1aBj3U1VQ2JYXDl98u+qRyGcwrIko4p
         5IjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5LzLTds65teZUEbmIei4xV2GMvPjinpMxIUAiqV/JN0=;
        b=CH5vZpW0KvkCSvNxwNfR+/La58IToKgc/8tkc11knz//vc6lBJBNExEexwYaMK80/3
         Re401ViE9iiVgFpXvSmGrmczywR2TrIHjGuj4VKl/AAoLgiaSAUBvOSim/4P84xReXzB
         9VKmkm1Kq+VlyuN8J2z6iS3RPOFaMSRaKn3mC8HghVnDufzrGXsHwoZI9oMQPQy9jrMC
         T0HvEU8vFVS/MFry/nrbck0wUcxCuxNd2kR0NMhd/gUVQRwB5AVBEhJLr1X/jg/ayBNO
         UWwnupnTN2NQb7s1eH/5GhPP4NB/1SnjO6biCGJehmIYW7LYbtbP1aEctoVFW/nHWlMG
         ZcWA==
X-Gm-Message-State: AOAM530Bicw68xuST4RTx5LpwzmzN70ZHXLjPo16GMeN9V3EXBUVqnYL
        sGtjZ4u+kqRISYr/PF7b5lQ=
X-Google-Smtp-Source: ABdhPJww0J8xxDK6vo3k0epli+cH6XTiiTMeeZx46T17/gGx0xg0cnT5sSEitHjDVq82l9dxwKKiAA==
X-Received: by 2002:a05:6402:510:: with SMTP id m16mr5836918edv.280.1627579075347;
        Thu, 29 Jul 2021 10:17:55 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:55 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 7/9] dpaa2-switch: add VLAN based mirroring
Date:   Thu, 29 Jul 2021 20:18:59 +0300
Message-Id: <20210729171901.3211729-8-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729171901.3211729-1-ciorneiioana@gmail.com>
References: <20210729171901.3211729-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Using the infrastructure added in the previous patch, extend tc-flower
support with FLOW_ACTION_MIRRED based on VLAN.

Tested with:

tc qdisc add dev eth8 ingress_block 1 clsact
tc filter add block 1 ingress protocol 802.1q flower skip_sw \
	vlan_id 100 action mirred egress mirror dev eth6
tc filter del block 1 ingress pref 49152

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-flower.c     | 143 +++++++++++++++++-
 1 file changed, 138 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index efd6d58ca191..3c4f5ada12fd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -396,7 +396,9 @@ dpaa2_switch_block_add_mirror(struct dpaa2_switch_filter_block *block,
 {
 	unsigned long block_ports = block->ports;
 	struct ethsw_core *ethsw = block->ethsw;
+	struct ethsw_port_priv *port_priv;
 	unsigned long ports_added = 0;
+	u16 vlan = entry->cfg.vlan_id;
 	bool mirror_port_enabled;
 	int err, port;
 
@@ -414,6 +416,19 @@ dpaa2_switch_block_add_mirror(struct dpaa2_switch_filter_block *block,
 	 * ports that share the same filter block.
 	 */
 	for_each_set_bit(port, &block_ports, ethsw->sw_attr.num_ifs) {
+		port_priv = ethsw->ports[port];
+
+		/* We cannot add a per VLAN mirroring rule if the VLAN in
+		 * question is not installed on the switch port.
+		 */
+		if (entry->cfg.filter == DPSW_REFLECTION_FILTER_INGRESS_VLAN &&
+		    !(port_priv->vlans[vlan] & ETHSW_VLAN_MEMBER)) {
+			NL_SET_ERR_MSG(extack,
+				       "VLAN must be installed on the switch port");
+			err = -EINVAL;
+			goto err_remove_filters;
+		}
+
 		err = dpsw_if_add_reflection(ethsw->mc_io, 0,
 					     ethsw->dpsw_handle,
 					     port, &entry->cfg);
@@ -511,6 +526,112 @@ dpaa2_switch_cls_flower_replace_acl(struct dpaa2_switch_filter_block *block,
 	return err;
 }
 
+static int dpaa2_switch_flower_parse_mirror_key(struct flow_cls_offload *cls,
+						u16 *vlan)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	struct netlink_ext_ack *extack = cls->common.extack;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Mirroring is supported only per VLAN");
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+
+		if (match.mask->vlan_priority != 0 ||
+		    match.mask->vlan_dei != 0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only matching on VLAN ID supported");
+			return -EOPNOTSUPP;
+		}
+
+		if (match.mask->vlan_id != 0xFFF) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Masked matching not supported");
+			return -EOPNOTSUPP;
+		}
+
+		*vlan = (u16)match.key->vlan_id;
+	}
+
+	return 0;
+}
+
+static int
+dpaa2_switch_cls_flower_replace_mirror(struct dpaa2_switch_filter_block *block,
+				       struct flow_cls_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct dpaa2_switch_mirror_entry *mirror_entry;
+	struct ethsw_core *ethsw = block->ethsw;
+	struct dpaa2_switch_mirror_entry *tmp;
+	struct flow_action_entry *cls_act;
+	struct list_head *pos, *n;
+	bool mirror_port_enabled;
+	u16 if_id, vlan;
+	int err;
+
+	mirror_port_enabled = (ethsw->mirror_port != ethsw->sw_attr.num_ifs);
+	cls_act = &cls->rule->action.entries[0];
+
+	/* Offload rules only when the destination is a DPAA2 switch port */
+	if (!dpaa2_switch_port_dev_check(cls_act->dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Destination not a DPAA2 switch port");
+		return -EOPNOTSUPP;
+	}
+	if_id = dpaa2_switch_get_index(ethsw, cls_act->dev);
+
+	/* We have a single mirror port but can configure egress mirroring on
+	 * all the other switch ports. We need to allow mirroring rules only
+	 * when the destination port is the same.
+	 */
+	if (mirror_port_enabled && ethsw->mirror_port != if_id) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Multiple mirror ports not supported");
+		return -EBUSY;
+	}
+
+	/* Parse the key */
+	err = dpaa2_switch_flower_parse_mirror_key(cls, &vlan);
+	if (err)
+		return err;
+
+	/* Make sure that we don't already have a mirror rule with the same
+	 * configuration.
+	 */
+	list_for_each_safe(pos, n, &block->mirror_entries) {
+		tmp = list_entry(pos, struct dpaa2_switch_mirror_entry, list);
+
+		if (tmp->cfg.filter == DPSW_REFLECTION_FILTER_INGRESS_VLAN &&
+		    tmp->cfg.vlan_id == vlan) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "VLAN mirror filter already installed");
+			return -EBUSY;
+		}
+	}
+
+	mirror_entry = kzalloc(sizeof(*mirror_entry), GFP_KERNEL);
+	if (!mirror_entry)
+		return -ENOMEM;
+
+	mirror_entry->cfg.filter = DPSW_REFLECTION_FILTER_INGRESS_VLAN;
+	mirror_entry->cfg.vlan_id = vlan;
+	mirror_entry->cookie = cls->cookie;
+
+	return dpaa2_switch_block_add_mirror(block, mirror_entry, if_id,
+					     extack);
+}
+
 int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
 				    struct flow_cls_offload *cls)
 {
@@ -529,6 +650,8 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
 	case FLOW_ACTION_TRAP:
 	case FLOW_ACTION_DROP:
 		return dpaa2_switch_cls_flower_replace_acl(block, cls);
+	case FLOW_ACTION_MIRRED:
+		return dpaa2_switch_cls_flower_replace_mirror(block, cls);
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "Action not supported");
 		return -EOPNOTSUPP;
@@ -538,13 +661,23 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
 int dpaa2_switch_cls_flower_destroy(struct dpaa2_switch_filter_block *block,
 				    struct flow_cls_offload *cls)
 {
-	struct dpaa2_switch_acl_entry *entry;
+	struct dpaa2_switch_mirror_entry *mirror_entry;
+	struct dpaa2_switch_acl_entry *acl_entry;
 
-	entry = dpaa2_switch_acl_tbl_find_entry_by_cookie(block, cls->cookie);
-	if (!entry)
-		return 0;
+	/* If this filter is a an ACL one, remove it */
+	acl_entry = dpaa2_switch_acl_tbl_find_entry_by_cookie(block,
+							      cls->cookie);
+	if (acl_entry)
+		return dpaa2_switch_acl_tbl_remove_entry(block, acl_entry);
+
+	/* If not, then it has to be a mirror */
+	mirror_entry = dpaa2_switch_mirror_find_entry_by_cookie(block,
+								cls->cookie);
+	if (mirror_entry)
+		return dpaa2_switch_block_remove_mirror(block,
+							mirror_entry);
 
-	return dpaa2_switch_acl_tbl_remove_entry(block, entry);
+	return 0;
 }
 
 static int
-- 
2.31.1


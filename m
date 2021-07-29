Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87773DA9ED
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhG2RSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhG2RSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:18:00 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB017C061765;
        Thu, 29 Jul 2021 10:17:55 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id qk33so11870005ejc.12;
        Thu, 29 Jul 2021 10:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tVzKdmUZwVkwu3k+YR2JkQkJiJSX/PPc5zyc2L5U1ng=;
        b=qO1i8UhCaITC8E+vH63rpPPB8mMmaW7kP9m2dKHu6/Az79KQxIS3CmKEMgi71Xt8Kv
         LQFD+cPbduT8Ck1urVAa6gfB0PVjJu4anoZD1FrZsowh53C6LZOM+pAw+ZYUcHcLEgEX
         WqWezVzSr3T56CVLGJCTGSR1kIFebDtVLA8NiBN2L1ogjED8I04r+XtyWyd8GepMPDN4
         SWQ3l6fYB2jIxK0FzJbhDQhXXl5mYnFsUfMsMy5P+9Wh2yXSqIOa9Hw8rVa2j/BKe9nA
         5UQheZZFO1bbJNuFMCBiPtv4dIay2IG/QVaiB7v/GOhRZV6MgWxw5Fpo+w2bTGK3NsFu
         sORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tVzKdmUZwVkwu3k+YR2JkQkJiJSX/PPc5zyc2L5U1ng=;
        b=IRoSKgut/FdrJRCynvq9t6WbWRhI1f5GrS5Y37Y+Yu2pn7pwBvFw8iIJN+oPRaS54M
         efH/rV/KEmY64VE42oLTFXMsTNn2QE6FYi0gqJsjMHtz/OK+3/i+J1jOGR4M6wyfq+Wu
         /ZFV2pPjS8tmWFe8Z/7x4F+GxO02mtjleKQyC6OKVUmVzn/H978eEYsXL6nzO9Xx92qA
         PTl502XzyZDE6F2/56IZ4hAgyLpTF4426ygggcDoSbEJodgG4Yo2Nis0JfapE9SARoi8
         AgSOFpDMWWiQadj50fSvqHxWQf3JaTQ2AxT2drq7KvgyLTbPgHDMgb11bwuAFZ8W6I+u
         VhmQ==
X-Gm-Message-State: AOAM532MRNFwXCGm7jkEumDfiU/ozmIkIPqAEYS/X37XBbC96EIQJtwb
        VfOSBOWI1IGQyZBYV0myakty2W+HWgQ=
X-Google-Smtp-Source: ABdhPJzyVu4w/y264sGyTgv/icd3awPWhjLjOTmi1oNYZgnrfDTFLTa/Y9Srwg9p4XIQ/ktoNjifNQ==
X-Received: by 2002:a17:906:3193:: with SMTP id 19mr5865449ejy.433.1627579074224;
        Thu, 29 Jul 2021 10:17:54 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:53 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 6/9] dpaa2-switch: add support for port mirroring
Date:   Thu, 29 Jul 2021 20:18:58 +0300
Message-Id: <20210729171901.3211729-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729171901.3211729-1-ciorneiioana@gmail.com>
References: <20210729171901.3211729-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Add support for per port mirroring for the DPAA2 switch. We support
only single mirror port, therefore we allow mirroring rules only as long
as the destination port is always the same.

Unlike all the actions (drop, redirect, trap) already supported by the
dpaa2-switch driver, adding mirroring filters in shared blocks is not
achieved by a singular ACL entry added in a table shared by the ports.
This is why, when a new mirror filter is added in a block we have to got
through all the switch ports sharing it and configure the filter
individually on all.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-flower.c     | 171 +++++++++++++++++-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   6 +
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  10 +
 3 files changed, 182 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index 637291060fd5..efd6d58ca191 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -305,6 +305,19 @@ dpaa2_switch_acl_entry_get_index(struct dpaa2_switch_filter_block *block,
 	return -ENOENT;
 }
 
+static struct dpaa2_switch_mirror_entry *
+dpaa2_switch_mirror_find_entry_by_cookie(struct dpaa2_switch_filter_block *block,
+					 unsigned long cookie)
+{
+	struct dpaa2_switch_mirror_entry *tmp, *n;
+
+	list_for_each_entry_safe(tmp, n, &block->mirror_entries, list) {
+		if (tmp->cookie == cookie)
+			return tmp;
+	}
+	return NULL;
+}
+
 static int
 dpaa2_switch_acl_tbl_remove_entry(struct dpaa2_switch_filter_block *block,
 				  struct dpaa2_switch_acl_entry *entry)
@@ -376,6 +389,83 @@ static int dpaa2_switch_tc_parse_action_acl(struct ethsw_core *ethsw,
 	return err;
 }
 
+static int
+dpaa2_switch_block_add_mirror(struct dpaa2_switch_filter_block *block,
+			      struct dpaa2_switch_mirror_entry *entry,
+			      u16 to, struct netlink_ext_ack *extack)
+{
+	unsigned long block_ports = block->ports;
+	struct ethsw_core *ethsw = block->ethsw;
+	unsigned long ports_added = 0;
+	bool mirror_port_enabled;
+	int err, port;
+
+	/* Setup the mirroring port */
+	mirror_port_enabled = (ethsw->mirror_port != ethsw->sw_attr.num_ifs);
+	if (!mirror_port_enabled) {
+		err = dpsw_set_reflection_if(ethsw->mc_io, 0,
+					     ethsw->dpsw_handle, to);
+		if (err)
+			return err;
+		ethsw->mirror_port = to;
+	}
+
+	/* Setup the same egress mirroring configuration on all the switch
+	 * ports that share the same filter block.
+	 */
+	for_each_set_bit(port, &block_ports, ethsw->sw_attr.num_ifs) {
+		err = dpsw_if_add_reflection(ethsw->mc_io, 0,
+					     ethsw->dpsw_handle,
+					     port, &entry->cfg);
+		if (err)
+			goto err_remove_filters;
+
+		ports_added |= BIT(port);
+	}
+
+	list_add(&entry->list, &block->mirror_entries);
+
+	return 0;
+
+err_remove_filters:
+	for_each_set_bit(port, &ports_added, ethsw->sw_attr.num_ifs) {
+		dpsw_if_remove_reflection(ethsw->mc_io, 0, ethsw->dpsw_handle,
+					  port, &entry->cfg);
+	}
+
+	if (!mirror_port_enabled)
+		ethsw->mirror_port = ethsw->sw_attr.num_ifs;
+
+	return err;
+}
+
+static int
+dpaa2_switch_block_remove_mirror(struct dpaa2_switch_filter_block *block,
+				 struct dpaa2_switch_mirror_entry *entry)
+{
+	struct dpsw_reflection_cfg *cfg = &entry->cfg;
+	unsigned long block_ports = block->ports;
+	struct ethsw_core *ethsw = block->ethsw;
+	int port;
+
+	/* Remove this mirroring configuration from all the ports belonging to
+	 * the filter block.
+	 */
+	for_each_set_bit(port, &block_ports, ethsw->sw_attr.num_ifs)
+		dpsw_if_remove_reflection(ethsw->mc_io, 0, ethsw->dpsw_handle,
+					  port, cfg);
+
+	/* Also remove it from the list of mirror filters */
+	list_del(&entry->list);
+	kfree(entry);
+
+	/* If this was the last mirror filter, then unset the mirror port */
+	if (list_empty(&block->mirror_entries))
+		ethsw->mirror_port =  ethsw->sw_attr.num_ifs;
+
+	return 0;
+}
+
 static int
 dpaa2_switch_cls_flower_replace_acl(struct dpaa2_switch_filter_block *block,
 				    struct flow_cls_offload *cls)
@@ -497,6 +587,64 @@ dpaa2_switch_cls_matchall_replace_acl(struct dpaa2_switch_filter_block *block,
 	return err;
 }
 
+static int
+dpaa2_switch_cls_matchall_replace_mirror(struct dpaa2_switch_filter_block *block,
+					 struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct dpaa2_switch_mirror_entry *mirror_entry;
+	struct ethsw_core *ethsw = block->ethsw;
+	struct dpaa2_switch_mirror_entry *tmp;
+	struct flow_action_entry *cls_act;
+	struct list_head *pos, *n;
+	bool mirror_port_enabled;
+	u16 if_id;
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
+	/* Make sure that we don't already have a mirror rule with the same
+	 * configuration. One matchall rule per block is the maximum.
+	 */
+	list_for_each_safe(pos, n, &block->mirror_entries) {
+		tmp = list_entry(pos, struct dpaa2_switch_mirror_entry, list);
+
+		if (tmp->cfg.filter == DPSW_REFLECTION_FILTER_INGRESS_ALL) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Matchall mirror filter already installed");
+			return -EBUSY;
+		}
+	}
+
+	mirror_entry = kzalloc(sizeof(*mirror_entry), GFP_KERNEL);
+	if (!mirror_entry)
+		return -ENOMEM;
+
+	mirror_entry->cfg.filter = DPSW_REFLECTION_FILTER_INGRESS_ALL;
+	mirror_entry->cookie = cls->cookie;
+
+	return dpaa2_switch_block_add_mirror(block, mirror_entry, if_id,
+					     extack);
+}
+
 int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
 				      struct tc_cls_matchall_offload *cls)
 {
@@ -514,6 +662,8 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
 	case FLOW_ACTION_TRAP:
 	case FLOW_ACTION_DROP:
 		return dpaa2_switch_cls_matchall_replace_acl(block, cls);
+	case FLOW_ACTION_MIRRED:
+		return dpaa2_switch_cls_matchall_replace_mirror(block, cls);
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "Action not supported");
 		return -EOPNOTSUPP;
@@ -523,11 +673,22 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_filter_block *block,
 int dpaa2_switch_cls_matchall_destroy(struct dpaa2_switch_filter_block *block,
 				      struct tc_cls_matchall_offload *cls)
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
+		return dpaa2_switch_acl_tbl_remove_entry(block,
+							 acl_entry);
 
-	return  dpaa2_switch_acl_tbl_remove_entry(block, entry);
+	/* If not, then it has to be a mirror */
+	mirror_entry = dpaa2_switch_mirror_find_entry_by_cookie(block,
+								cls->cookie);
+	if (mirror_entry)
+		return dpaa2_switch_block_remove_mirror(block,
+							mirror_entry);
+
+	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 1806012f41d2..3857d9093623 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3067,6 +3067,7 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	filter_block->in_use = true;
 	filter_block->num_acl_rules = 0;
 	INIT_LIST_HEAD(&filter_block->acl_entries);
+	INIT_LIST_HEAD(&filter_block->mirror_entries);
 
 	err = dpaa2_switch_port_acl_tbl_bind(port_priv, filter_block);
 	if (err)
@@ -3284,6 +3285,11 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 	if (err)
 		goto err_stop;
 
+	/* By convention, if the mirror port is equal to the number of switch
+	 * interfaces, then mirroring of any kind is disabled.
+	 */
+	ethsw->mirror_port =  ethsw->sw_attr.num_ifs;
+
 	/* Register the netdev only when the entire setup is done and the
 	 * switch port interfaces are ready to receive traffic
 	 */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 296a09eb7a9a..79e8a40f97f7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -113,6 +113,13 @@ struct dpaa2_switch_acl_entry {
 	struct dpsw_acl_key	key;
 };
 
+struct dpaa2_switch_mirror_entry {
+	struct list_head	list;
+	struct dpsw_reflection_cfg cfg;
+	unsigned long		cookie;
+	u16 if_id;
+};
+
 struct dpaa2_switch_filter_block {
 	struct ethsw_core	*ethsw;
 	u64			ports;
@@ -121,6 +128,8 @@ struct dpaa2_switch_filter_block {
 	struct list_head	acl_entries;
 	u16			acl_id;
 	u8			num_acl_rules;
+
+	struct list_head	mirror_entries;
 };
 
 static inline bool
@@ -176,6 +185,7 @@ struct ethsw_core {
 
 	struct dpaa2_switch_fdb		*fdbs;
 	struct dpaa2_switch_filter_block *filter_blocks;
+	u16				mirror_port;
 };
 
 static inline int dpaa2_switch_get_index(struct ethsw_core *ethsw,
-- 
2.31.1


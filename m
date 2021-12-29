Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BD6481050
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbhL2GZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238952AbhL2GZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F68FC06173E
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 22:25:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A461F6142E
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFB6C36AEF;
        Wed, 29 Dec 2021 06:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759109;
        bh=FJs1Pb6kVvxyN6P9eMod9+A+18R9JXvzLLyHKJOPHRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLxxSVKEStlx+gqGwJ7aHJZKeoe5/3xI56N4LDXBfPHA2uxRlZPmOuYKDWlGdF4u1
         DqxLrG3sUYqmTxzUfi4Jv++pa0oTfyGscrhLqgfEodFMq6JgpI2cGPer25/qrhTjsK
         x3H5H1aSPgAOUIQyDORPos4DVzYyz2fUEsRLsyMl6Wcc4C3+tFGHgRxffASxG2Pded
         Rr53QYMIr52igFMdBALYPzFsWoNRmEpPxJzNMO2Yx9hAY6zZt8PivwyIUb4HyUSOoa
         PbFCe+ZpLUgDy+fHUVkq+2iKy2JCM7WR+/FnXHNMTVAGGMOr9OtwMALw+Dnrp4YotU
         LleZaddXoFQIg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Muhammad Sammar <muhammads@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  07/16] net/mlx5: DR, Add support for dumping steering info
Date:   Tue, 28 Dec 2021 22:24:53 -0800
Message-Id: <20211229062502.24111-8-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Sammar <muhammads@nvidia.com>

Extend mlx5 debugfs support to present Software Steering resources:
dr_domain including it's tables, matchers and rules.
The interface is read-only. While dump is being presented, new steering
rules cannot be inserted/deleted.

The steering information is dumped in the CSV form with the following
format:

    <object_type>,<object_ID>, <object_info>,...,<object_info>

This data can be read at the following path:

    /sys/kernel/debug/mlx5/<BDF>/steering/fdb/<domain_handle>

Example:

    # cat /sys/kernel/debug/mlx5/0000:82:00.0/steering/fdb/dmn_000018644
    3100,0x55caa4621c50,0xee802,4,65533
    3101,0x55caa4621c50,0xe0100008

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 .../mellanox/mlx5/core/steering/dr_dbg.c      | 668 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_dbg.h      |  15 +
 .../mellanox/mlx5/core/steering/dr_domain.c   |   3 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c  |   1 +
 .../mellanox/mlx5/core/steering/dr_rule.c     |   9 +-
 .../mellanox/mlx5/core/steering/dr_table.c    |   3 +
 .../mellanox/mlx5/core/steering/dr_types.h    |  13 +-
 8 files changed, 707 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index e592e0955c71..33904bc87efa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -104,7 +104,8 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_ste.o steering/dr_send.o \
 					steering/dr_ste_v0.o steering/dr_ste_v1.o \
 					steering/dr_cmd.o steering/dr_fw.o \
-					steering/dr_action.o steering/fs_dr.o
+					steering/dr_action.o steering/fs_dr.o \
+					steering/dr_dbg.o
 #
 # SF device
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
new file mode 100644
index 000000000000..31ce91f11339
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -0,0 +1,668 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include "dr_types.h"
+
+#define BUF_SIZE 512
+#define DR_DBG_PTR_TO_ID(p) ((u64)(uintptr_t)(p) & 0xFFFFFFFFULL)
+
+enum dr_dump_rec_type {
+	DR_DUMP_REC_TYPE_DOMAIN = 3000,
+	DR_DUMP_REC_TYPE_DOMAIN_INFO_FLEX_PARSER = 3001,
+	DR_DUMP_REC_TYPE_DOMAIN_INFO_DEV_ATTR = 3002,
+	DR_DUMP_REC_TYPE_DOMAIN_INFO_VPORT = 3003,
+	DR_DUMP_REC_TYPE_DOMAIN_INFO_CAPS = 3004,
+	DR_DUMP_REC_TYPE_DOMAIN_SEND_RING = 3005,
+
+	DR_DUMP_REC_TYPE_TABLE = 3100,
+	DR_DUMP_REC_TYPE_TABLE_RX = 3101,
+	DR_DUMP_REC_TYPE_TABLE_TX = 3102,
+
+	DR_DUMP_REC_TYPE_MATCHER = 3200,
+	DR_DUMP_REC_TYPE_MATCHER_MASK = 3201,
+	DR_DUMP_REC_TYPE_MATCHER_RX = 3202,
+	DR_DUMP_REC_TYPE_MATCHER_TX = 3203,
+	DR_DUMP_REC_TYPE_MATCHER_BUILDER = 3204,
+
+	DR_DUMP_REC_TYPE_RULE = 3300,
+	DR_DUMP_REC_TYPE_RULE_RX_ENTRY_V0 = 3301,
+	DR_DUMP_REC_TYPE_RULE_TX_ENTRY_V0 = 3302,
+	DR_DUMP_REC_TYPE_RULE_RX_ENTRY_V1 = 3303,
+	DR_DUMP_REC_TYPE_RULE_TX_ENTRY_V1 = 3304,
+
+	DR_DUMP_REC_TYPE_ACTION_ENCAP_L2 = 3400,
+	DR_DUMP_REC_TYPE_ACTION_ENCAP_L3 = 3401,
+	DR_DUMP_REC_TYPE_ACTION_MODIFY_HDR = 3402,
+	DR_DUMP_REC_TYPE_ACTION_DROP = 3403,
+	DR_DUMP_REC_TYPE_ACTION_QP = 3404,
+	DR_DUMP_REC_TYPE_ACTION_FT = 3405,
+	DR_DUMP_REC_TYPE_ACTION_CTR = 3406,
+	DR_DUMP_REC_TYPE_ACTION_TAG = 3407,
+	DR_DUMP_REC_TYPE_ACTION_VPORT = 3408,
+	DR_DUMP_REC_TYPE_ACTION_DECAP_L2 = 3409,
+	DR_DUMP_REC_TYPE_ACTION_DECAP_L3 = 3410,
+	DR_DUMP_REC_TYPE_ACTION_DEVX_TIR = 3411,
+	DR_DUMP_REC_TYPE_ACTION_PUSH_VLAN = 3412,
+	DR_DUMP_REC_TYPE_ACTION_POP_VLAN = 3413,
+	DR_DUMP_REC_TYPE_ACTION_SAMPLER = 3415,
+	DR_DUMP_REC_TYPE_ACTION_INSERT_HDR = 3420,
+	DR_DUMP_REC_TYPE_ACTION_REMOVE_HDR = 3421
+};
+
+void mlx5dr_dbg_tbl_add(struct mlx5dr_table *tbl)
+{
+	mutex_lock(&tbl->dmn->dump_info.dbg_mutex);
+	list_add_tail(&tbl->dbg_node, &tbl->dmn->dbg_tbl_list);
+	mutex_unlock(&tbl->dmn->dump_info.dbg_mutex);
+}
+
+void mlx5dr_dbg_tbl_del(struct mlx5dr_table *tbl)
+{
+	mutex_lock(&tbl->dmn->dump_info.dbg_mutex);
+	list_del(&tbl->dbg_node);
+	mutex_unlock(&tbl->dmn->dump_info.dbg_mutex);
+}
+
+void mlx5dr_dbg_rule_add(struct mlx5dr_rule *rule)
+{
+	struct mlx5dr_domain *dmn = rule->matcher->tbl->dmn;
+
+	mutex_lock(&dmn->dump_info.dbg_mutex);
+	list_add_tail(&rule->dbg_node, &rule->matcher->dbg_rule_list);
+	mutex_unlock(&dmn->dump_info.dbg_mutex);
+}
+
+void mlx5dr_dbg_rule_del(struct mlx5dr_rule *rule)
+{
+	struct mlx5dr_domain *dmn = rule->matcher->tbl->dmn;
+
+	mutex_lock(&dmn->dump_info.dbg_mutex);
+	list_del(&rule->dbg_node);
+	mutex_unlock(&dmn->dump_info.dbg_mutex);
+}
+
+static u64 dr_dump_icm_to_idx(u64 icm_addr)
+{
+	return (icm_addr >> 6) & 0xffffffff;
+}
+
+static void
+dr_dump_hex_print(char *dest, u32 dest_size, char *src, u32 src_size)
+{
+	int i;
+
+	if (dest_size < 2 * src_size)
+		return;
+
+	for (i = 0; i < src_size; i++)
+		snprintf(&dest[2 * i], BUF_SIZE, "%02x", (u8)src[i]);
+}
+
+static int
+dr_dump_rule_action_mem(struct seq_file *file, const u64 rule_id,
+			struct mlx5dr_rule_action_member *action_mem)
+{
+	struct mlx5dr_action *action = action_mem->action;
+	const u64 action_id = DR_DBG_PTR_TO_ID(action);
+
+	switch (action->action_type) {
+	case DR_ACTION_TYP_DROP:
+		seq_printf(file, "%d,0x%llx,0x%llx\n",
+			   DR_DUMP_REC_TYPE_ACTION_DROP, action_id, rule_id);
+		break;
+	case DR_ACTION_TYP_FT:
+		if (action->dest_tbl->is_fw_tbl)
+			seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+				   DR_DUMP_REC_TYPE_ACTION_FT, action_id,
+				   rule_id, action->dest_tbl->fw_tbl.id);
+		else
+			seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+				   DR_DUMP_REC_TYPE_ACTION_FT, action_id,
+				   rule_id, action->dest_tbl->tbl->table_id);
+
+		break;
+	case DR_ACTION_TYP_CTR:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_CTR, action_id, rule_id,
+			   action->ctr->ctr_id + action->ctr->offset);
+		break;
+	case DR_ACTION_TYP_TAG:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_TAG, action_id, rule_id,
+			   action->flow_tag->flow_tag);
+		break;
+	case DR_ACTION_TYP_MODIFY_HDR:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_MODIFY_HDR, action_id,
+			   rule_id, action->rewrite->index);
+		break;
+	case DR_ACTION_TYP_VPORT:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_VPORT, action_id, rule_id,
+			   action->vport->caps->num);
+		break;
+	case DR_ACTION_TYP_TNL_L2_TO_L2:
+		seq_printf(file, "%d,0x%llx,0x%llx\n",
+			   DR_DUMP_REC_TYPE_ACTION_DECAP_L2, action_id,
+			   rule_id);
+		break;
+	case DR_ACTION_TYP_TNL_L3_TO_L2:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_DECAP_L3, action_id,
+			   rule_id, action->rewrite->index);
+		break;
+	case DR_ACTION_TYP_L2_TO_TNL_L2:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_ENCAP_L2, action_id,
+			   rule_id, action->reformat->id);
+		break;
+	case DR_ACTION_TYP_L2_TO_TNL_L3:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_ENCAP_L3, action_id,
+			   rule_id, action->reformat->id);
+		break;
+	case DR_ACTION_TYP_POP_VLAN:
+		seq_printf(file, "%d,0x%llx,0x%llx\n",
+			   DR_DUMP_REC_TYPE_ACTION_POP_VLAN, action_id,
+			   rule_id);
+		break;
+	case DR_ACTION_TYP_PUSH_VLAN:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_PUSH_VLAN, action_id,
+			   rule_id, action->push_vlan->vlan_hdr);
+		break;
+	case DR_ACTION_TYP_INSERT_HDR:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x,0x%x,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_INSERT_HDR, action_id,
+			   rule_id, action->reformat->id,
+			   action->reformat->param_0,
+			   action->reformat->param_1);
+		break;
+	case DR_ACTION_TYP_REMOVE_HDR:
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x,0x%x,0x%x\n",
+			   DR_DUMP_REC_TYPE_ACTION_REMOVE_HDR, action_id,
+			   rule_id, action->reformat->id,
+			   action->reformat->param_0,
+			   action->reformat->param_1);
+		break;
+	case DR_ACTION_TYP_SAMPLER:
+		seq_printf(file,
+			   "%d,0x%llx,0x%llx,0x%x,0x%x,0x%x,0x%llx,0x%llx\n",
+			   DR_DUMP_REC_TYPE_ACTION_SAMPLER, action_id, rule_id,
+			   0, 0, action->sampler->sampler_id,
+			   action->sampler->rx_icm_addr,
+			   action->sampler->tx_icm_addr);
+		break;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
+static int
+dr_dump_rule_mem(struct seq_file *file, struct mlx5dr_ste *ste,
+		 bool is_rx, const u64 rule_id, u8 format_ver)
+{
+	char hw_ste_dump[BUF_SIZE] = {};
+	u32 mem_rec_type;
+
+	if (format_ver == MLX5_STEERING_FORMAT_CONNECTX_5) {
+		mem_rec_type = is_rx ? DR_DUMP_REC_TYPE_RULE_RX_ENTRY_V0 :
+				       DR_DUMP_REC_TYPE_RULE_TX_ENTRY_V0;
+	} else {
+		mem_rec_type = is_rx ? DR_DUMP_REC_TYPE_RULE_RX_ENTRY_V1 :
+				       DR_DUMP_REC_TYPE_RULE_TX_ENTRY_V1;
+	}
+
+	dr_dump_hex_print(hw_ste_dump, BUF_SIZE, (char *)ste->hw_ste,
+			  DR_STE_SIZE_REDUCED);
+
+	seq_printf(file, "%d,0x%llx,0x%llx,%s\n", mem_rec_type,
+		   dr_dump_icm_to_idx(mlx5dr_ste_get_icm_addr(ste)), rule_id,
+		   hw_ste_dump);
+
+	return 0;
+}
+
+static int
+dr_dump_rule_rx_tx(struct seq_file *file, struct mlx5dr_rule_rx_tx *rule_rx_tx,
+		   bool is_rx, const u64 rule_id, u8 format_ver)
+{
+	struct mlx5dr_ste *ste_arr[DR_RULE_MAX_STES + DR_ACTION_MAX_STES];
+	struct mlx5dr_ste *curr_ste = rule_rx_tx->last_rule_ste;
+	int ret, i;
+
+	if (mlx5dr_rule_get_reverse_rule_members(ste_arr, curr_ste, &i))
+		return 0;
+
+	while (i--) {
+		ret = dr_dump_rule_mem(file, ste_arr[i], is_rx, rule_id,
+				       format_ver);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int dr_dump_rule(struct seq_file *file, struct mlx5dr_rule *rule)
+{
+	struct mlx5dr_rule_action_member *action_mem;
+	const u64 rule_id = DR_DBG_PTR_TO_ID(rule);
+	struct mlx5dr_rule_rx_tx *rx = &rule->rx;
+	struct mlx5dr_rule_rx_tx *tx = &rule->tx;
+	u8 format_ver;
+	int ret;
+
+	format_ver = rule->matcher->tbl->dmn->info.caps.sw_format_ver;
+
+	seq_printf(file, "%d,0x%llx,0x%llx\n", DR_DUMP_REC_TYPE_RULE, rule_id,
+		   DR_DBG_PTR_TO_ID(rule->matcher));
+
+	if (rx->nic_matcher) {
+		ret = dr_dump_rule_rx_tx(file, rx, true, rule_id, format_ver);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (tx->nic_matcher) {
+		ret = dr_dump_rule_rx_tx(file, tx, false, rule_id, format_ver);
+		if (ret < 0)
+			return ret;
+	}
+
+	list_for_each_entry(action_mem, &rule->rule_actions_list, list) {
+		ret = dr_dump_rule_action_mem(file, rule_id, action_mem);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+dr_dump_matcher_mask(struct seq_file *file, struct mlx5dr_match_param *mask,
+		     u8 criteria, const u64 matcher_id)
+{
+	char dump[BUF_SIZE] = {};
+
+	seq_printf(file, "%d,0x%llx,", DR_DUMP_REC_TYPE_MATCHER_MASK,
+		   matcher_id);
+
+	if (criteria & DR_MATCHER_CRITERIA_OUTER) {
+		dr_dump_hex_print(dump, BUF_SIZE, (char *)&mask->outer,
+				  sizeof(mask->outer));
+		seq_printf(file, "%s,", dump);
+	} else {
+		seq_puts(file, ",");
+	}
+
+	if (criteria & DR_MATCHER_CRITERIA_INNER) {
+		dr_dump_hex_print(dump, BUF_SIZE, (char *)&mask->inner,
+				  sizeof(mask->inner));
+		seq_printf(file, "%s,", dump);
+	} else {
+		seq_puts(file, ",");
+	}
+
+	if (criteria & DR_MATCHER_CRITERIA_MISC) {
+		dr_dump_hex_print(dump, BUF_SIZE, (char *)&mask->misc,
+				  sizeof(mask->misc));
+		seq_printf(file, "%s,", dump);
+	} else {
+		seq_puts(file, ",");
+	}
+
+	if (criteria & DR_MATCHER_CRITERIA_MISC2) {
+		dr_dump_hex_print(dump, BUF_SIZE, (char *)&mask->misc2,
+				  sizeof(mask->misc2));
+		seq_printf(file, "%s,", dump);
+	} else {
+		seq_puts(file, ",");
+	}
+
+	if (criteria & DR_MATCHER_CRITERIA_MISC3) {
+		dr_dump_hex_print(dump, BUF_SIZE, (char *)&mask->misc3,
+				  sizeof(mask->misc3));
+		seq_printf(file, "%s\n", dump);
+	} else {
+		seq_puts(file, ",\n");
+	}
+
+	return 0;
+}
+
+static int
+dr_dump_matcher_builder(struct seq_file *file, struct mlx5dr_ste_build *builder,
+			u32 index, bool is_rx, const u64 matcher_id)
+{
+	seq_printf(file, "%d,0x%llx,%d,%d,0x%x\n",
+		   DR_DUMP_REC_TYPE_MATCHER_BUILDER, matcher_id, index, is_rx,
+		   builder->lu_type);
+
+	return 0;
+}
+
+static int
+dr_dump_matcher_rx_tx(struct seq_file *file, bool is_rx,
+		      struct mlx5dr_matcher_rx_tx *matcher_rx_tx,
+		      const u64 matcher_id)
+{
+	enum dr_dump_rec_type rec_type;
+	int i, ret;
+
+	rec_type = is_rx ? DR_DUMP_REC_TYPE_MATCHER_RX :
+			   DR_DUMP_REC_TYPE_MATCHER_TX;
+
+	seq_printf(file, "%d,0x%llx,0x%llx,%d,0x%llx,0x%llx\n",
+		   rec_type, DR_DBG_PTR_TO_ID(matcher_rx_tx),
+		   matcher_id, matcher_rx_tx->num_of_builders,
+		   dr_dump_icm_to_idx(matcher_rx_tx->s_htbl->chunk->icm_addr),
+		   dr_dump_icm_to_idx(matcher_rx_tx->e_anchor->chunk->icm_addr));
+
+	for (i = 0; i < matcher_rx_tx->num_of_builders; i++) {
+		ret = dr_dump_matcher_builder(file,
+					      &matcher_rx_tx->ste_builder[i],
+					      i, is_rx, matcher_id);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+dr_dump_matcher(struct seq_file *file, struct mlx5dr_matcher *matcher)
+{
+	struct mlx5dr_matcher_rx_tx *rx = &matcher->rx;
+	struct mlx5dr_matcher_rx_tx *tx = &matcher->tx;
+	u64 matcher_id;
+	int ret;
+
+	matcher_id = DR_DBG_PTR_TO_ID(matcher);
+
+	seq_printf(file, "%d,0x%llx,0x%llx,%d\n", DR_DUMP_REC_TYPE_MATCHER,
+		   matcher_id, DR_DBG_PTR_TO_ID(matcher->tbl), matcher->prio);
+
+	ret = dr_dump_matcher_mask(file, &matcher->mask,
+				   matcher->match_criteria, matcher_id);
+	if (ret < 0)
+		return ret;
+
+	if (rx->nic_tbl) {
+		ret = dr_dump_matcher_rx_tx(file, true, rx, matcher_id);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (tx->nic_tbl) {
+		ret = dr_dump_matcher_rx_tx(file, false, tx, matcher_id);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+dr_dump_matcher_all(struct seq_file *file, struct mlx5dr_matcher *matcher)
+{
+	struct mlx5dr_rule *rule;
+	int ret;
+
+	ret = dr_dump_matcher(file, matcher);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(rule, &matcher->dbg_rule_list, dbg_node) {
+		ret = dr_dump_rule(file, rule);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+dr_dump_table_rx_tx(struct seq_file *file, bool is_rx,
+		    struct mlx5dr_table_rx_tx *table_rx_tx,
+		    const u64 table_id)
+{
+	enum dr_dump_rec_type rec_type;
+
+	rec_type = is_rx ? DR_DUMP_REC_TYPE_TABLE_RX :
+			   DR_DUMP_REC_TYPE_TABLE_TX;
+
+	seq_printf(file, "%d,0x%llx,0x%llx\n", rec_type, table_id,
+		   dr_dump_icm_to_idx(table_rx_tx->s_anchor->chunk->icm_addr));
+
+	return 0;
+}
+
+static int dr_dump_table(struct seq_file *file, struct mlx5dr_table *table)
+{
+	struct mlx5dr_table_rx_tx *rx = &table->rx;
+	struct mlx5dr_table_rx_tx *tx = &table->tx;
+	int ret;
+
+	seq_printf(file, "%d,0x%llx,0x%llx,%d,%d\n", DR_DUMP_REC_TYPE_TABLE,
+		   DR_DBG_PTR_TO_ID(table), DR_DBG_PTR_TO_ID(table->dmn),
+		   table->table_type, table->level);
+
+	if (rx->nic_dmn) {
+		ret = dr_dump_table_rx_tx(file, true, rx,
+					  DR_DBG_PTR_TO_ID(table));
+		if (ret < 0)
+			return ret;
+	}
+
+	if (tx->nic_dmn) {
+		ret = dr_dump_table_rx_tx(file, false, tx,
+					  DR_DBG_PTR_TO_ID(table));
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static int dr_dump_table_all(struct seq_file *file, struct mlx5dr_table *tbl)
+{
+	struct mlx5dr_matcher *matcher;
+	int ret;
+
+	ret = dr_dump_table(file, tbl);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(matcher, &tbl->matcher_list, list_node) {
+		ret = dr_dump_matcher_all(file, matcher);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static int
+dr_dump_send_ring(struct seq_file *file, struct mlx5dr_send_ring *ring,
+		  const u64 domain_id)
+{
+	seq_printf(file, "%d,0x%llx,0x%llx,0x%x,0x%x\n",
+		   DR_DUMP_REC_TYPE_DOMAIN_SEND_RING, DR_DBG_PTR_TO_ID(ring),
+		   domain_id, ring->cq->mcq.cqn, ring->qp->qpn);
+	return 0;
+}
+
+static int
+dr_dump_domain_info_flex_parser(struct seq_file *file,
+				const char *flex_parser_name,
+				const u8 flex_parser_value,
+				const u64 domain_id)
+{
+	seq_printf(file, "%d,0x%llx,%s,0x%x\n",
+		   DR_DUMP_REC_TYPE_DOMAIN_INFO_FLEX_PARSER, domain_id,
+		   flex_parser_name, flex_parser_value);
+	return 0;
+}
+
+static int
+dr_dump_domain_info_caps(struct seq_file *file, struct mlx5dr_cmd_caps *caps,
+			 const u64 domain_id)
+{
+	struct mlx5dr_cmd_vport_cap *vport_caps;
+	unsigned long i, vports_num;
+
+	xa_for_each(&caps->vports.vports_caps_xa, vports_num, vport_caps)
+		; /* count the number of vports in xarray */
+
+	seq_printf(file, "%d,0x%llx,0x%x,0x%llx,0x%llx,0x%x,%lu,%d\n",
+		   DR_DUMP_REC_TYPE_DOMAIN_INFO_CAPS, domain_id, caps->gvmi,
+		   caps->nic_rx_drop_address, caps->nic_tx_drop_address,
+		   caps->flex_protocols, vports_num, caps->eswitch_manager);
+
+	xa_for_each(&caps->vports.vports_caps_xa, i, vport_caps) {
+		vport_caps = xa_load(&caps->vports.vports_caps_xa, i);
+
+		seq_printf(file, "%d,0x%llx,%lu,0x%x,0x%llx,0x%llx\n",
+			   DR_DUMP_REC_TYPE_DOMAIN_INFO_VPORT, domain_id, i,
+			   vport_caps->vport_gvmi, vport_caps->icm_address_rx,
+			   vport_caps->icm_address_tx);
+	}
+	return 0;
+}
+
+static int
+dr_dump_domain_info(struct seq_file *file, struct mlx5dr_domain_info *info,
+		    const u64 domain_id)
+{
+	int ret;
+
+	ret = dr_dump_domain_info_caps(file, &info->caps, domain_id);
+	if (ret < 0)
+		return ret;
+
+	ret = dr_dump_domain_info_flex_parser(file, "icmp_dw0",
+					      info->caps.flex_parser_id_icmp_dw0,
+					      domain_id);
+	if (ret < 0)
+		return ret;
+
+	ret = dr_dump_domain_info_flex_parser(file, "icmp_dw1",
+					      info->caps.flex_parser_id_icmp_dw1,
+					      domain_id);
+	if (ret < 0)
+		return ret;
+
+	ret = dr_dump_domain_info_flex_parser(file, "icmpv6_dw0",
+					      info->caps.flex_parser_id_icmpv6_dw0,
+					      domain_id);
+	if (ret < 0)
+		return ret;
+
+	ret = dr_dump_domain_info_flex_parser(file, "icmpv6_dw1",
+					      info->caps.flex_parser_id_icmpv6_dw1,
+					      domain_id);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int
+dr_dump_domain(struct seq_file *file, struct mlx5dr_domain *dmn)
+{
+	u64 domain_id = DR_DBG_PTR_TO_ID(dmn);
+	int ret;
+
+	seq_printf(file, "%d,0x%llx,%d,0%x,%d,%s\n", DR_DUMP_REC_TYPE_DOMAIN,
+		   domain_id, dmn->type, dmn->info.caps.gvmi,
+		   dmn->info.supp_sw_steering, pci_name(dmn->mdev->pdev));
+
+	ret = dr_dump_domain_info(file, &dmn->info, domain_id);
+	if (ret < 0)
+		return ret;
+
+	if (dmn->info.supp_sw_steering) {
+		ret = dr_dump_send_ring(file, dmn->send_ring, domain_id);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int dr_dump_domain_all(struct seq_file *file, struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_table *tbl;
+	int ret;
+
+	mutex_lock(&dmn->dump_info.dbg_mutex);
+	mlx5dr_domain_lock(dmn);
+
+	ret = dr_dump_domain(file, dmn);
+	if (ret < 0)
+		goto unlock_mutex;
+
+	list_for_each_entry(tbl, &dmn->dbg_tbl_list, dbg_node) {
+		ret = dr_dump_table_all(file, tbl);
+		if (ret < 0)
+			break;
+	}
+
+unlock_mutex:
+	mlx5dr_domain_unlock(dmn);
+	mutex_unlock(&dmn->dump_info.dbg_mutex);
+	return ret;
+}
+
+static int dr_dump_show(struct seq_file *file, void *priv)
+{
+	return dr_dump_domain_all(file, file->private);
+}
+DEFINE_SHOW_ATTRIBUTE(dr_dump);
+
+void mlx5dr_dbg_init_dump(struct mlx5dr_domain *dmn)
+{
+	struct mlx5_core_dev *dev = dmn->mdev;
+	char file_name[128];
+
+	if (dmn->type != MLX5DR_DOMAIN_TYPE_FDB) {
+		mlx5_core_warn(dev,
+			       "Steering dump is not supported for NIC RX/TX domains\n");
+		return;
+	}
+
+	if (!dmn->dump_info.steering_debugfs) {
+		dmn->dump_info.steering_debugfs = debugfs_create_dir("steering",
+								     dev->priv.dbg_root);
+		if (!dmn->dump_info.steering_debugfs)
+			return;
+	}
+
+	if (!dmn->dump_info.fdb_debugfs) {
+		dmn->dump_info.fdb_debugfs = debugfs_create_dir("fdb",
+								dmn->dump_info.steering_debugfs);
+		if (!dmn->dump_info.fdb_debugfs) {
+			debugfs_remove_recursive(dmn->dump_info.steering_debugfs);
+			dmn->dump_info.steering_debugfs = NULL;
+			return;
+		}
+	}
+
+	sprintf(file_name, "dmn_%p", dmn);
+	debugfs_create_file(file_name, 0444, dmn->dump_info.fdb_debugfs,
+			    dmn, &dr_dump_fops);
+
+	INIT_LIST_HEAD(&dmn->dbg_tbl_list);
+	mutex_init(&dmn->dump_info.dbg_mutex);
+}
+
+void mlx5dr_dbg_uninit_dump(struct mlx5dr_domain *dmn)
+{
+	debugfs_remove_recursive(dmn->dump_info.steering_debugfs);
+	mutex_destroy(&dmn->dump_info.dbg_mutex);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.h
new file mode 100644
index 000000000000..def6cf853eea
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+struct mlx5dr_dbg_dump_info {
+	struct mutex dbg_mutex; /* protect dbg lists */
+	struct dentry *steering_debugfs;
+	struct dentry *fdb_debugfs;
+};
+
+void mlx5dr_dbg_init_dump(struct mlx5dr_domain *dmn);
+void mlx5dr_dbg_uninit_dump(struct mlx5dr_domain *dmn);
+void mlx5dr_dbg_tbl_add(struct mlx5dr_table *tbl);
+void mlx5dr_dbg_tbl_del(struct mlx5dr_table *tbl);
+void mlx5dr_dbg_rule_add(struct mlx5dr_rule *rule);
+void mlx5dr_dbg_rule_del(struct mlx5dr_rule *rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 8cbd36c82b3b..b12b47394890 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -396,7 +396,7 @@ mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type type)
 	}
 
 	dr_domain_init_csum_recalc_fts(dmn);
-
+	mlx5dr_dbg_init_dump(dmn);
 	return dmn;
 
 uninit_caps:
@@ -437,6 +437,7 @@ int mlx5dr_domain_destroy(struct mlx5dr_domain *dmn)
 
 	/* make sure resources are not used by the hardware */
 	mlx5dr_cmd_sync_steering(dmn->mdev);
+	mlx5dr_dbg_uninit_dump(dmn);
 	dr_domain_uninit_csum_recalc_fts(dmn);
 	dr_domain_uninit_resources(dmn);
 	dr_domain_caps_uninit(dmn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index af2cbbb6ef95..88288c02d6ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -969,6 +969,7 @@ mlx5dr_matcher_create(struct mlx5dr_table *tbl,
 	matcher->match_criteria = match_criteria_enable;
 	refcount_set(&matcher->refcount, 1);
 	INIT_LIST_HEAD(&matcher->list_node);
+	INIT_LIST_HEAD(&matcher->dbg_rule_list);
 
 	mlx5dr_domain_lock(tbl->dmn);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 6a390e981b09..3b4cd3160c27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -5,11 +5,6 @@
 
 #define DR_RULE_MAX_STE_CHAIN (DR_RULE_MAX_STES + DR_ACTION_MAX_STES)
 
-struct mlx5dr_rule_action_member {
-	struct mlx5dr_action *action;
-	struct list_head list;
-};
-
 static int dr_rule_append_to_miss_list(struct mlx5dr_ste_ctx *ste_ctx,
 				       struct mlx5dr_ste *new_last_ste,
 				       struct list_head *miss_list,
@@ -1003,6 +998,8 @@ static int dr_rule_destroy_rule(struct mlx5dr_rule *rule)
 {
 	struct mlx5dr_domain *dmn = rule->matcher->tbl->dmn;
 
+	mlx5dr_dbg_rule_del(rule);
+
 	switch (dmn->type) {
 	case MLX5DR_DOMAIN_TYPE_NIC_RX:
 		dr_rule_destroy_rule_nic(rule, &rule->rx);
@@ -1257,6 +1254,8 @@ dr_rule_create_rule(struct mlx5dr_matcher *matcher,
 	if (ret)
 		goto remove_action_members;
 
+	INIT_LIST_HEAD(&rule->dbg_node);
+	mlx5dr_dbg_rule_add(rule);
 	return rule;
 
 remove_action_members:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 4c40178e7d1e..241ee49a24ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -266,6 +266,8 @@ struct mlx5dr_table *mlx5dr_table_create(struct mlx5dr_domain *dmn, u32 level, u
 	if (ret)
 		goto uninit_tbl;
 
+	INIT_LIST_HEAD(&tbl->dbg_node);
+	mlx5dr_dbg_tbl_add(tbl);
 	return tbl;
 
 uninit_tbl:
@@ -284,6 +286,7 @@ int mlx5dr_table_destroy(struct mlx5dr_table *tbl)
 	if (refcount_read(&tbl->refcount) > 1)
 		return -EBUSY;
 
+	mlx5dr_dbg_tbl_del(tbl);
 	ret = dr_table_destroy_sw_owned_tbl(tbl);
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 9f21a72e23b1..584d2b0eb016 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -11,6 +11,7 @@
 #include "lib/mlx5.h"
 #include "mlx5_ifc_dr.h"
 #include "mlx5dr.h"
+#include "dr_dbg.h"
 
 #define DR_RULE_MAX_STES 18
 #define DR_ACTION_MAX_STES 5
@@ -878,6 +879,8 @@ struct mlx5dr_domain {
 	struct mlx5dr_domain_info info;
 	struct xarray csum_fts_xa;
 	struct mlx5dr_ste_ctx *ste_ctx;
+	struct list_head dbg_tbl_list;
+	struct mlx5dr_dbg_dump_info dump_info;
 };
 
 struct mlx5dr_table_rx_tx {
@@ -897,6 +900,7 @@ struct mlx5dr_table {
 	struct list_head matcher_list;
 	struct mlx5dr_action *miss_action;
 	refcount_t refcount;
+	struct list_head dbg_node;
 };
 
 struct mlx5dr_matcher_rx_tx {
@@ -916,11 +920,12 @@ struct mlx5dr_matcher {
 	struct mlx5dr_table *tbl;
 	struct mlx5dr_matcher_rx_tx rx;
 	struct mlx5dr_matcher_rx_tx tx;
-	struct list_head list_node;
+	struct list_head list_node; /* Used for both matchers and dbg managing */
 	u32 prio;
 	struct mlx5dr_match_param mask;
 	u8 match_criteria;
 	refcount_t refcount;
+	struct list_head dbg_rule_list;
 };
 
 struct mlx5dr_ste_action_modify_field {
@@ -992,6 +997,11 @@ struct mlx5dr_action_flow_tag {
 	u32 flow_tag;
 };
 
+struct mlx5dr_rule_action_member {
+	struct mlx5dr_action *action;
+	struct list_head list;
+};
+
 struct mlx5dr_action {
 	enum mlx5dr_action_type action_type;
 	refcount_t refcount;
@@ -1032,6 +1042,7 @@ struct mlx5dr_rule {
 	struct mlx5dr_rule_rx_tx rx;
 	struct mlx5dr_rule_rx_tx tx;
 	struct list_head rule_actions_list;
+	struct list_head dbg_node;
 	u32 flow_source;
 };
 
-- 
2.33.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4152560E71
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiF3BAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 21:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiF3BAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:00:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22143403DD
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C200CB827CF
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8040CC341C8;
        Thu, 30 Jun 2022 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656550819;
        bh=Gj7K9f+N+fX2T6Hi2wSOVQvuvAVHf/GnX/NL5T5rAfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEB+B7SgJnyMJHtfIpXa+0J+8P9cWmPuOcA7IX5ef/WAy1ojKbYH1KyXlX+9MxfWd
         5w8jYHjEFQItuXKAs6UKT2umyWmtSgks1WWAfpsbBLD6wqGsNXxeEGrPrEIaeE9RnZ
         8flVSgkidO6V8AnR+5QhkgP2vW6plCYFoQci5GEpyMCWfI2EuXVg/1VDbV3IssXG0W
         EI0ZZkWDPsvjfDK3TiXPYYy+i9cE2Th9GtIgQYvTS8DY4pPU53fJeiJGaJ+squoRdy
         6+Ls2kFKdbrH3KkQTSkbCpgcR2Zsx+m7gTM/civMLpn8U9jqWV3unt0cL+H4+ZSaY9
         kjslFhrync9oQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Get or put meter by the index of tc police action
Date:   Wed, 29 Jun 2022 18:00:01 -0700
Message-Id: <20220630010005.145775-12-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630010005.145775-1-saeed@kernel.org>
References: <20220630010005.145775-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

Add functions to create and destroy flow meter aso object.
This object only supports the range allocation. 64 objects are
allocated at a time, and there are two meters in each object.
Usually only one meter is allocated for a flow, so bitmap is used
to manage these 128 meters.

TC police action is mapped to hardware meter. As the index is unique
for each police action, add APIs to allocate or free hardware meter by
the index. If the meter is already created, increment its refcnt,
otherwise create new one. If police action has different parameters,
update hardware meter accordingly.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c | 209 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/meter.h |  13 ++
 2 files changed, 222 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index cb65d36909ee..9b4de7f5ee03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -4,6 +4,7 @@
 #include "lib/aso.h"
 #include "en/tc/post_act.h"
 #include "meter.h"
+#include "en/tc_priv.h"
 
 #define MLX5_START_COLOR_SHIFT 28
 #define MLX5_METER_MODE_SHIFT 24
@@ -21,6 +22,14 @@
 #define MLX5_MAX_CBS ((0x100ULL << 0x1F) - 1)
 #define MLX5_MAX_HW_CBS 0x7FFFFFFF
 
+struct mlx5e_flow_meter_aso_obj {
+	struct list_head entry;
+	int base_id;
+	int total_meters;
+
+	unsigned long meters_map[0]; /* must be at the end of this struct */
+};
+
 struct mlx5e_flow_meters {
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5_aso *aso;
@@ -28,6 +37,12 @@ struct mlx5e_flow_meters {
 	int log_granularity;
 	u32 pdn;
 
+	DECLARE_HASHTABLE(hashtbl, 8);
+
+	struct mutex sync_lock; /* protect flow meter operations */
+	struct list_head partial_list;
+	struct list_head full_list;
+
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_post_act *post_act;
 };
@@ -177,6 +192,200 @@ mlx5e_tc_meter_modify(struct mlx5_core_dev *mdev,
 	return err;
 }
 
+static int
+mlx5e_flow_meter_create_aso_obj(struct mlx5e_flow_meters *flow_meters, int *obj_id)
+{
+	u32 in[MLX5_ST_SZ_DW(create_flow_meter_aso_obj_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	struct mlx5_core_dev *mdev = flow_meters->mdev;
+	void *obj;
+	int err;
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO);
+	MLX5_SET(general_obj_in_cmd_hdr, in, log_obj_range, flow_meters->log_granularity);
+
+	obj = MLX5_ADDR_OF(create_flow_meter_aso_obj_in, in, flow_meter_aso_obj);
+	MLX5_SET(flow_meter_aso_obj, obj, meter_aso_access_pd, flow_meters->pdn);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (!err) {
+		*obj_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+		mlx5_core_dbg(mdev, "flow meter aso obj(0x%x) created\n", *obj_id);
+	}
+
+	return err;
+}
+
+static void
+mlx5e_flow_meter_destroy_aso_obj(struct mlx5_core_dev *mdev, u32 obj_id)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, obj_id);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	mlx5_core_dbg(mdev, "flow meter aso obj(0x%x) destroyed\n", obj_id);
+}
+
+static struct mlx5e_flow_meter_handle *
+__mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters)
+{
+	struct mlx5_core_dev *mdev = flow_meters->mdev;
+	struct mlx5e_flow_meter_aso_obj *meters_obj;
+	struct mlx5e_flow_meter_handle *meter;
+	int err, pos, total;
+	u32 id;
+
+	meter = kzalloc(sizeof(*meter), GFP_KERNEL);
+	if (!meter)
+		return ERR_PTR(-ENOMEM);
+
+	meters_obj = list_first_entry_or_null(&flow_meters->partial_list,
+					      struct mlx5e_flow_meter_aso_obj,
+					      entry);
+	/* 2 meters in one object */
+	total = 1 << (flow_meters->log_granularity + 1);
+	if (!meters_obj) {
+		err = mlx5e_flow_meter_create_aso_obj(flow_meters, &id);
+		if (err) {
+			mlx5_core_err(mdev, "Failed to create flow meter ASO object\n");
+			goto err_create;
+		}
+
+		meters_obj = kzalloc(sizeof(*meters_obj) + BITS_TO_BYTES(total),
+				     GFP_KERNEL);
+		if (!meters_obj) {
+			err = -ENOMEM;
+			goto err_mem;
+		}
+
+		meters_obj->base_id = id;
+		meters_obj->total_meters = total;
+		list_add(&meters_obj->entry, &flow_meters->partial_list);
+		pos = 0;
+	} else {
+		pos = find_first_zero_bit(meters_obj->meters_map, total);
+		if (bitmap_weight(meters_obj->meters_map, total) == total - 1) {
+			list_del(&meters_obj->entry);
+			list_add(&meters_obj->entry, &flow_meters->full_list);
+		}
+	}
+
+	bitmap_set(meters_obj->meters_map, pos, 1);
+	meter->flow_meters = flow_meters;
+	meter->meters_obj = meters_obj;
+	meter->obj_id = meters_obj->base_id + pos / 2;
+	meter->idx = pos % 2;
+
+	mlx5_core_dbg(mdev, "flow meter allocated, obj_id=0x%x, index=%d\n",
+		      meter->obj_id, meter->idx);
+
+	return meter;
+
+err_mem:
+	mlx5e_flow_meter_destroy_aso_obj(mdev, id);
+err_create:
+	kfree(meter);
+	return ERR_PTR(err);
+}
+
+static void
+__mlx5e_flow_meter_free(struct mlx5e_flow_meter_handle *meter)
+{
+	struct mlx5e_flow_meters *flow_meters = meter->flow_meters;
+	struct mlx5_core_dev *mdev = flow_meters->mdev;
+	struct mlx5e_flow_meter_aso_obj *meters_obj;
+	int n, pos;
+
+	meters_obj = meter->meters_obj;
+	pos = (meter->obj_id - meters_obj->base_id) * 2 + meter->idx;
+	bitmap_clear(meters_obj->meters_map, pos, 1);
+	n = bitmap_weight(meters_obj->meters_map, meters_obj->total_meters);
+	if (n == 0) {
+		list_del(&meters_obj->entry);
+		mlx5e_flow_meter_destroy_aso_obj(mdev, meters_obj->base_id);
+		kfree(meters_obj);
+	} else if (n == meters_obj->total_meters - 1) {
+		list_del(&meters_obj->entry);
+		list_add(&meters_obj->entry, &flow_meters->partial_list);
+	}
+
+	mlx5_core_dbg(mdev, "flow meter freed, obj_id=0x%x, index=%d\n",
+		      meter->obj_id, meter->idx);
+	kfree(meter);
+}
+
+struct mlx5e_flow_meter_handle *
+mlx5e_tc_meter_get(struct mlx5_core_dev *mdev, struct mlx5e_flow_meter_params *params)
+{
+	struct mlx5e_flow_meters *flow_meters;
+	struct mlx5e_flow_meter_handle *meter;
+	int err;
+
+	flow_meters = mlx5e_get_flow_meters(mdev);
+	if (!flow_meters)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	mutex_lock(&flow_meters->sync_lock);
+	hash_for_each_possible(flow_meters->hashtbl, meter, hlist, params->index)
+		if (meter->params.index == params->index)
+			goto add_ref;
+
+	meter = __mlx5e_flow_meter_alloc(flow_meters);
+	if (IS_ERR(meter)) {
+		err = PTR_ERR(meter);
+		goto err_alloc;
+	}
+
+	hash_add(flow_meters->hashtbl, &meter->hlist, params->index);
+	meter->params.index = params->index;
+
+add_ref:
+	meter->refcnt++;
+
+	if (meter->params.mode != params->mode || meter->params.rate != params->rate ||
+	    meter->params.burst != params->burst) {
+		err = mlx5e_tc_meter_modify(mdev, meter, params);
+		if (err)
+			goto err_update;
+
+		meter->params.mode = params->mode;
+		meter->params.rate = params->rate;
+		meter->params.burst = params->burst;
+	}
+
+	mutex_unlock(&flow_meters->sync_lock);
+	return meter;
+
+err_update:
+	if (--meter->refcnt == 0) {
+		hash_del(&meter->hlist);
+		__mlx5e_flow_meter_free(meter);
+	}
+err_alloc:
+	mutex_unlock(&flow_meters->sync_lock);
+	return ERR_PTR(err);
+}
+
+void
+mlx5e_tc_meter_put(struct mlx5e_flow_meter_handle *meter)
+{
+	struct mlx5e_flow_meters *flow_meters = meter->flow_meters;
+
+	mutex_lock(&flow_meters->sync_lock);
+	if (--meter->refcnt == 0) {
+		hash_del(&meter->hlist);
+		__mlx5e_flow_meter_free(meter);
+	}
+	mutex_unlock(&flow_meters->sync_lock);
+}
+
 struct mlx5e_flow_meters *
 mlx5e_flow_meters_init(struct mlx5e_priv *priv,
 		       enum mlx5_flow_namespace_type ns_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
index 0153509e729e..36c8a417dd87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
@@ -4,6 +4,7 @@
 #ifndef __MLX5_EN_FLOW_METER_H__
 #define __MLX5_EN_FLOW_METER_H__
 
+struct mlx5e_flow_meter_aso_obj;
 struct mlx5e_flow_meters;
 
 enum mlx5e_flow_meter_mode {
@@ -13,14 +14,21 @@ enum mlx5e_flow_meter_mode {
 
 struct mlx5e_flow_meter_params {
 	enum mlx5e_flow_meter_mode mode;
+	 /* police action index */
+	u32 index;
 	u64 rate;
 	u64 burst;
 };
 
 struct mlx5e_flow_meter_handle {
 	struct mlx5e_flow_meters *flow_meters;
+	struct mlx5e_flow_meter_aso_obj *meters_obj;
 	u32 obj_id;
 	u8 idx;
+
+	int refcnt;
+	struct hlist_node hlist;
+	struct mlx5e_flow_meter_params params;
 };
 
 int
@@ -28,6 +36,11 @@ mlx5e_tc_meter_modify(struct mlx5_core_dev *mdev,
 		      struct mlx5e_flow_meter_handle *meter,
 		      struct mlx5e_flow_meter_params *meter_params);
 
+struct mlx5e_flow_meter_handle *
+mlx5e_tc_meter_get(struct mlx5_core_dev *mdev, struct mlx5e_flow_meter_params *params);
+void
+mlx5e_tc_meter_put(struct mlx5e_flow_meter_handle *meter);
+
 struct mlx5e_flow_meters *
 mlx5e_flow_meters_init(struct mlx5e_priv *priv,
 		       enum mlx5_flow_namespace_type ns_type,
-- 
2.36.1


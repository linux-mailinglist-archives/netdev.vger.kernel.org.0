Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE3A584762
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbiG1U5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiG1U5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69A478211
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77007B82595
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF2FC433D7;
        Thu, 28 Jul 2022 20:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041855;
        bh=Rt5QGOmc9TQ0O9kCUFoHWIha3SbUMlR3QgISUCfNI5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJIUcoxvUJDx84B0LjRjHriTP12tQgYPJiHkindNQ6kimWnwXycfw3b7iIeFz487A
         Sqcdso9u57r/RCNpYGgoDnkb89RVZZhcpryLBuPzZn4Ns7h0BgvQL5kw5tY4LYWccV
         nwLjv7jA2rzOHKRGcGu5vFKCn93PO9I5sc61BOL5REGjr2OZguuzHWaHmsf4DUJz+j
         mSMcSgceqbEvDiGCYqhTmVGHfXO9NpjkudNqfBIbHJ3WvgCiFet9gA8YlqHFvEqYCL
         +Diz+Gc2s5bBu5c85TGl5qVn3ueFIwac9p1aqvH+QgxaIPM8Pu+S/XUUj9GL0yXUvm
         rZFItw5+5vW3A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: TC, Separate get/update/replace meter functions
Date:   Thu, 28 Jul 2022 13:57:18 -0700
Message-Id: <20220728205728.143074-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728205728.143074-1-saeed@kernel.org>
References: <20220728205728.143074-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

mlx5e_tc_meter_get() to get an existing meter.
mlx5e_tc_meter_update() to update an existing meter without refcount.
mlx5e_tc_meter_replace() to get/create a meter and update if needed.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c | 132 ++++++++++++++----
 .../ethernet/mellanox/mlx5/core/en/tc/meter.h |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 3 files changed, 112 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index 6409e4fa16a1..17529cc07ff4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -344,69 +344,149 @@ __mlx5e_flow_meter_free(struct mlx5e_flow_meter_handle *meter)
 	kfree(meter);
 }
 
+static struct mlx5e_flow_meter_handle *
+__mlx5e_tc_meter_get(struct mlx5e_flow_meters *flow_meters, u32 index)
+{
+	struct mlx5e_flow_meter_handle *meter;
+
+	hash_for_each_possible(flow_meters->hashtbl, meter, hlist, index)
+		if (meter->params.index == index)
+			goto add_ref;
+
+	return ERR_PTR(-ENOENT);
+
+add_ref:
+	meter->refcnt++;
+
+	return meter;
+}
+
 struct mlx5e_flow_meter_handle *
 mlx5e_tc_meter_get(struct mlx5_core_dev *mdev, struct mlx5e_flow_meter_params *params)
 {
 	struct mlx5e_flow_meters *flow_meters;
 	struct mlx5e_flow_meter_handle *meter;
-	int err;
 
 	flow_meters = mlx5e_get_flow_meters(mdev);
 	if (!flow_meters)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&flow_meters->sync_lock);
-	hash_for_each_possible(flow_meters->hashtbl, meter, hlist, params->index)
-		if (meter->params.index == params->index)
-			goto add_ref;
+	meter = __mlx5e_tc_meter_get(flow_meters, params->index);
+	mutex_unlock(&flow_meters->sync_lock);
 
-	meter = __mlx5e_flow_meter_alloc(flow_meters);
-	if (IS_ERR(meter)) {
-		err = PTR_ERR(meter);
-		goto err_alloc;
+	return meter;
+}
+
+static void
+__mlx5e_tc_meter_put(struct mlx5e_flow_meter_handle *meter)
+{
+	if (--meter->refcnt == 0) {
+		hash_del(&meter->hlist);
+		__mlx5e_flow_meter_free(meter);
 	}
+}
+
+void
+mlx5e_tc_meter_put(struct mlx5e_flow_meter_handle *meter)
+{
+	struct mlx5e_flow_meters *flow_meters = meter->flow_meters;
+
+	mutex_lock(&flow_meters->sync_lock);
+	__mlx5e_tc_meter_put(meter);
+	mutex_unlock(&flow_meters->sync_lock);
+}
+
+static struct mlx5e_flow_meter_handle *
+mlx5e_tc_meter_alloc(struct mlx5e_flow_meters *flow_meters,
+		     struct mlx5e_flow_meter_params *params)
+{
+	struct mlx5e_flow_meter_handle *meter;
+
+	meter = __mlx5e_flow_meter_alloc(flow_meters);
+	if (IS_ERR(meter))
+		return meter;
 
 	hash_add(flow_meters->hashtbl, &meter->hlist, params->index);
 	meter->params.index = params->index;
-
-add_ref:
 	meter->refcnt++;
 
+	return meter;
+}
+
+static int
+__mlx5e_tc_meter_update(struct mlx5e_flow_meter_handle *meter,
+			struct mlx5e_flow_meter_params *params)
+{
+	struct mlx5_core_dev *mdev = meter->flow_meters->mdev;
+	int err = 0;
+
 	if (meter->params.mode != params->mode || meter->params.rate != params->rate ||
 	    meter->params.burst != params->burst) {
 		err = mlx5e_tc_meter_modify(mdev, meter, params);
 		if (err)
-			goto err_update;
+			goto out;
 
 		meter->params.mode = params->mode;
 		meter->params.rate = params->rate;
 		meter->params.burst = params->burst;
 	}
 
-	mutex_unlock(&flow_meters->sync_lock);
-	return meter;
+out:
+	return err;
+}
 
-err_update:
-	if (--meter->refcnt == 0) {
-		hash_del(&meter->hlist);
-		__mlx5e_flow_meter_free(meter);
-	}
-err_alloc:
+int
+mlx5e_tc_meter_update(struct mlx5e_flow_meter_handle *meter,
+		      struct mlx5e_flow_meter_params *params)
+{
+	struct mlx5_core_dev *mdev = meter->flow_meters->mdev;
+	struct mlx5e_flow_meters *flow_meters;
+	int err;
+
+	flow_meters = mlx5e_get_flow_meters(mdev);
+	if (!flow_meters)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&flow_meters->sync_lock);
+	err = __mlx5e_tc_meter_update(meter, params);
 	mutex_unlock(&flow_meters->sync_lock);
-	return ERR_PTR(err);
+	return err;
 }
 
-void
-mlx5e_tc_meter_put(struct mlx5e_flow_meter_handle *meter)
+struct mlx5e_flow_meter_handle *
+mlx5e_tc_meter_replace(struct mlx5_core_dev *mdev, struct mlx5e_flow_meter_params *params)
 {
-	struct mlx5e_flow_meters *flow_meters = meter->flow_meters;
+	struct mlx5e_flow_meters *flow_meters;
+	struct mlx5e_flow_meter_handle *meter;
+	int err;
+
+	flow_meters = mlx5e_get_flow_meters(mdev);
+	if (!flow_meters)
+		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&flow_meters->sync_lock);
-	if (--meter->refcnt == 0) {
-		hash_del(&meter->hlist);
-		__mlx5e_flow_meter_free(meter);
+	meter = __mlx5e_tc_meter_get(flow_meters, params->index);
+	if (IS_ERR(meter)) {
+		meter = mlx5e_tc_meter_alloc(flow_meters, params);
+		if (IS_ERR(meter)) {
+			err = PTR_ERR(meter);
+			goto err_get;
+		}
 	}
+
+	err = __mlx5e_tc_meter_update(meter, params);
+	if (err)
+		goto err_update;
+
 	mutex_unlock(&flow_meters->sync_lock);
+	return meter;
+
+err_update:
+	__mlx5e_tc_meter_put(meter);
+err_get:
+	mutex_unlock(&flow_meters->sync_lock);
+	return ERR_PTR(err);
 }
 
 enum mlx5_flow_namespace_type
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
index a73ebf94ad17..71ffa86e8965 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
@@ -51,6 +51,11 @@ struct mlx5e_flow_meter_handle *
 mlx5e_tc_meter_get(struct mlx5_core_dev *mdev, struct mlx5e_flow_meter_params *params);
 void
 mlx5e_tc_meter_put(struct mlx5e_flow_meter_handle *meter);
+int
+mlx5e_tc_meter_update(struct mlx5e_flow_meter_handle *meter,
+		      struct mlx5e_flow_meter_params *params);
+struct mlx5e_flow_meter_handle *
+mlx5e_tc_meter_replace(struct mlx5_core_dev *mdev, struct mlx5e_flow_meter_params *params);
 
 enum mlx5_flow_namespace_type
 mlx5e_tc_meter_get_namespace(struct mlx5e_flow_meters *flow_meters);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a38e1505bace..c3ec23f883cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -361,7 +361,7 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5e_flow_meter_handle *meter;
 
-	meter = mlx5e_tc_meter_get(priv->mdev, &attr->meter_attr.params);
+	meter = mlx5e_tc_meter_replace(priv->mdev, &attr->meter_attr.params);
 	if (IS_ERR(meter)) {
 		mlx5_core_err(priv->mdev, "Failed to get flow meter\n");
 		return PTR_ERR(meter);
-- 
2.37.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACCA3F2617
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhHTE4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232499AbhHTE4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0B0160FE7;
        Fri, 20 Aug 2021 04:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435324;
        bh=aizZDweIA/zKRPfrAdJlf9Z8ulaRiv5QZ9Z5OaNkrMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUcezU1LWFdZc+P9SoxHHnbOc8QWZNukFmiG/BZkXzy00QvsXNTlPgYVelsHr++ju
         PB3f1a+N68NW9lQpqy9T76SFDrBuNjp+i3T9hDBOZJlVuvf1Bh1ThW4Ju1ZOhGXPob
         tar2eabkqdc5DaREK/Vu4VmaquVrJhWolLs1hiCNG1G1ri4MBi/XVhKntgCcyLbZcg
         6slBbcfK0oB5R1Pwt3qrZtIPlYNr7yUwN1hpFCPilPM8SwtSiWczfgbFdc/jx4qoWP
         Ev2+JfpMCcX/56k86v5Qq1z6lJVOv6SmOYgi6azWGuTMpWlqXNTM8AeE0ppMGBPjXV
         7n5NMqluWPBHw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Remove mlx5e dependency from E-Switch sample
Date:   Thu, 19 Aug 2021 21:55:01 -0700
Message-Id: <20210820045515.265297-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

mlx5/esw/sample.c doesn't really need mlx5e_priv object, we can remove
this redundant dependency by passing the eswitch object directly to
the sample object constructor.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/esw/sample.c  | 25 +++++++++----------
 .../ethernet/mellanox/mlx5/core/esw/sample.h  |  4 +--
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9465a51b6e66..2257c1321385 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4976,7 +4976,7 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 					       MLX5_FLOW_NAMESPACE_FDB);
 
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
-	uplink_priv->esw_psample = mlx5_esw_sample_init(netdev_priv(priv->netdev));
+	uplink_priv->esw_psample = mlx5_esw_sample_init(esw);
 #endif
 
 	mapping_id = mlx5_query_nic_system_image_guid(esw->dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
index d3ad78aa9d45..34e1fd908686 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
@@ -18,7 +18,7 @@ static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_sample_ns = {
 };
 
 struct mlx5_esw_psample {
-	struct mlx5e_priv *priv;
+	struct mlx5_eswitch *esw;
 	struct mlx5_flow_table *termtbl;
 	struct mlx5_flow_handle *termtbl_rule;
 	DECLARE_HASHTABLE(hashtbl, 8);
@@ -55,10 +55,10 @@ struct mlx5_sample_restore {
 static int
 sampler_termtbl_create(struct mlx5_esw_psample *esw_psample)
 {
-	struct mlx5_core_dev *dev = esw_psample->priv->mdev;
-	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	struct mlx5_eswitch *esw = esw_psample->esw;
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_destination dest = {};
+	struct mlx5_core_dev *dev = esw->dev;
 	struct mlx5_flow_namespace *root_ns;
 	struct mlx5_flow_act act = {};
 	int err;
@@ -187,7 +187,7 @@ sampler_get(struct mlx5_esw_psample *esw_psample, u32 sample_ratio, u32 default_
 	sampler->default_table_id = default_table_id;
 	sampler->sample_ratio = sample_ratio;
 
-	err = sampler_obj_create(esw_psample->priv->mdev, sampler);
+	err = sampler_obj_create(esw_psample->esw->dev, sampler);
 	if (err)
 		goto err_create;
 
@@ -211,7 +211,7 @@ sampler_put(struct mlx5_esw_psample *esw_psample, struct mlx5_sampler *sampler)
 	mutex_lock(&esw_psample->ht_lock);
 	if (--sampler->count == 0) {
 		hash_del(&sampler->hlist);
-		sampler_obj_destroy(esw_psample->priv->mdev, sampler->sampler_id);
+		sampler_obj_destroy(esw_psample->esw->dev, sampler->sampler_id);
 		kfree(sampler);
 	}
 	mutex_unlock(&esw_psample->ht_lock);
@@ -249,8 +249,8 @@ sample_metadata_rule_get(struct mlx5_core_dev *mdev, u32 obj_id)
 static struct mlx5_sample_restore *
 sample_restore_get(struct mlx5_esw_psample *esw_psample, u32 obj_id)
 {
-	struct mlx5_core_dev *mdev = esw_psample->priv->mdev;
-	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+	struct mlx5_eswitch *esw = esw_psample->esw;
+	struct mlx5_core_dev *mdev = esw->dev;
 	struct mlx5_sample_restore *restore;
 	struct mlx5_modify_hdr *modify_hdr;
 	int err;
@@ -305,7 +305,7 @@ sample_restore_put(struct mlx5_esw_psample *esw_psample, struct mlx5_sample_rest
 
 	if (!restore->count) {
 		mlx5_del_flow_rules(restore->rule);
-		mlx5_modify_header_dealloc(esw_psample->priv->mdev, restore->modify_hdr);
+		mlx5_modify_header_dealloc(esw_psample->esw->dev, restore->modify_hdr);
 		kfree(restore);
 	}
 }
@@ -384,7 +384,7 @@ mlx5_esw_sample_offload(struct mlx5_esw_psample *esw_psample,
 	/* If slow path flag is set, eg. when the neigh is invalid for encap,
 	 * don't offload sample action.
 	 */
-	esw = esw_psample->priv->mdev->priv.eswitch;
+	esw = esw_psample->esw;
 	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
 		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 
@@ -522,7 +522,7 @@ mlx5_esw_sample_unoffload(struct mlx5_esw_psample *esw_psample,
 	/* If slow path flag is set, sample action is not offloaded.
 	 * No need to delete sample rule.
 	 */
-	esw = esw_psample->priv->mdev->priv.eswitch;
+	esw = esw_psample->esw;
 	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
 		mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
 		return;
@@ -531,7 +531,6 @@ mlx5_esw_sample_unoffload(struct mlx5_esw_psample *esw_psample,
 	sample_flow = esw_attr->sample->sample_flow;
 	pre_attr = sample_flow->pre_attr;
 	memset(pre_attr, 0, sizeof(*pre_attr));
-	esw = esw_psample->priv->mdev->priv.eswitch;
 	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule, pre_attr);
 	mlx5_eswitch_del_offloaded_rule(esw, sample_flow->rule, attr);
 
@@ -550,7 +549,7 @@ mlx5_esw_sample_unoffload(struct mlx5_esw_psample *esw_psample,
 }
 
 struct mlx5_esw_psample *
-mlx5_esw_sample_init(struct mlx5e_priv *priv)
+mlx5_esw_sample_init(struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_psample *esw_psample;
 	int err;
@@ -558,7 +557,7 @@ mlx5_esw_sample_init(struct mlx5e_priv *priv)
 	esw_psample = kzalloc(sizeof(*esw_psample), GFP_KERNEL);
 	if (!esw_psample)
 		return ERR_PTR(-ENOMEM);
-	esw_psample->priv = priv;
+	esw_psample->esw = esw;
 	err = sampler_termtbl_create(esw_psample);
 	if (err)
 		goto err_termtbl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
index 2a3f4be10030..c27525bd82d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
@@ -4,10 +4,8 @@
 #ifndef __MLX5_EN_TC_SAMPLE_H__
 #define __MLX5_EN_TC_SAMPLE_H__
 
-#include "en.h"
 #include "eswitch.h"
 
-struct mlx5e_priv;
 struct mlx5_flow_attr;
 struct mlx5_esw_psample;
 
@@ -34,7 +32,7 @@ mlx5_esw_sample_unoffload(struct mlx5_esw_psample *sample_priv,
 			  struct mlx5_flow_attr *attr);
 
 struct mlx5_esw_psample *
-mlx5_esw_sample_init(struct mlx5e_priv *priv);
+mlx5_esw_sample_init(struct mlx5_eswitch *esw);
 
 void
 mlx5_esw_sample_cleanup(struct mlx5_esw_psample *esw_psample);
-- 
2.31.1


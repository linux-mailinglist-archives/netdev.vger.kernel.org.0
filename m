Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1B448104F
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238955AbhL2GZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58262 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbhL2GZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8802EB81826
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE942C36AF1;
        Wed, 29 Dec 2021 06:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759107;
        bh=Nz+9g0yjccnfxGFjk1ftqaWNTlJdzgLcKt/ZIxSn00c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDvvWaNkM+tuc7fqwbce07orGyRHKBB8PnazIDLbVZVDd4HejMfqZwY83k1Ew6euV
         f2Wb8TXOC36pPuHTDVdWkhBN+Tp6Q+ma+AUSvcuW7aBcqk7BWYzJI/p06kfxKrK14A
         Yaf0un0MMjpi7WTKz/UnRvYaz2SwdhelSfRtxUOCgXxXALwx/k2m7k2ajTmJAX+vqU
         AXW9DPZ0TZ+l4hawLryUB4DtdZi7RY1l/yvdZeFb6hJ2fkqBMQK2COOYKY+v2DCkwJ
         nbnCGJgnRydIjYmVOGvroSarz3hfK/YJQTjo+PEO5ZKXVEtEgeR8UO5ihEyuMy3T39
         Iy3n0sF/oR1wQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  04/16] net/mlx5: DR, Rename list field in matcher struct to list_node
Date:   Tue, 28 Dec 2021 22:24:50 -0800
Message-Id: <20211229062502.24111-5-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

In dr_types structs, some list fields are list heads, and some
are just list nodes that are stored on the other structs' lists.
Rename the appropriate list field to reflect this distinction.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 26 +++++++++----------
 .../mellanox/mlx5/core/steering/dr_table.c    |  2 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +-
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 613074d50212..af2cbbb6ef95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -721,7 +721,7 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 	int ret;
 
 	next_matcher = NULL;
-	list_for_each_entry(tmp_matcher, &tbl->matcher_list, matcher_list) {
+	list_for_each_entry(tmp_matcher, &tbl->matcher_list, list_node) {
 		if (tmp_matcher->prio >= matcher->prio) {
 			next_matcher = tmp_matcher;
 			break;
@@ -731,11 +731,11 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 
 	prev_matcher = NULL;
 	if (next_matcher && !first)
-		prev_matcher = list_prev_entry(next_matcher, matcher_list);
+		prev_matcher = list_prev_entry(next_matcher, list_node);
 	else if (!first)
 		prev_matcher = list_last_entry(&tbl->matcher_list,
 					       struct mlx5dr_matcher,
-					       matcher_list);
+					       list_node);
 
 	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
 	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX) {
@@ -756,12 +756,12 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 	}
 
 	if (prev_matcher)
-		list_add(&matcher->matcher_list, &prev_matcher->matcher_list);
+		list_add(&matcher->list_node, &prev_matcher->list_node);
 	else if (next_matcher)
-		list_add_tail(&matcher->matcher_list,
-			      &next_matcher->matcher_list);
+		list_add_tail(&matcher->list_node,
+			      &next_matcher->list_node);
 	else
-		list_add(&matcher->matcher_list, &tbl->matcher_list);
+		list_add(&matcher->list_node, &tbl->matcher_list);
 
 	return 0;
 }
@@ -968,7 +968,7 @@ mlx5dr_matcher_create(struct mlx5dr_table *tbl,
 	matcher->prio = priority;
 	matcher->match_criteria = match_criteria_enable;
 	refcount_set(&matcher->refcount, 1);
-	INIT_LIST_HEAD(&matcher->matcher_list);
+	INIT_LIST_HEAD(&matcher->list_node);
 
 	mlx5dr_domain_lock(tbl->dmn);
 
@@ -1031,15 +1031,15 @@ static int dr_matcher_remove_from_tbl(struct mlx5dr_matcher *matcher)
 	struct mlx5dr_domain *dmn = tbl->dmn;
 	int ret = 0;
 
-	if (list_is_last(&matcher->matcher_list, &tbl->matcher_list))
+	if (list_is_last(&matcher->list_node, &tbl->matcher_list))
 		next_matcher = NULL;
 	else
-		next_matcher = list_next_entry(matcher, matcher_list);
+		next_matcher = list_next_entry(matcher, list_node);
 
-	if (matcher->matcher_list.prev == &tbl->matcher_list)
+	if (matcher->list_node.prev == &tbl->matcher_list)
 		prev_matcher = NULL;
 	else
-		prev_matcher = list_prev_entry(matcher, matcher_list);
+		prev_matcher = list_prev_entry(matcher, list_node);
 
 	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
 	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX) {
@@ -1059,7 +1059,7 @@ static int dr_matcher_remove_from_tbl(struct mlx5dr_matcher *matcher)
 			return ret;
 	}
 
-	list_del(&matcher->matcher_list);
+	list_del(&matcher->list_node);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 30ae3cda6d2e..4c40178e7d1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -19,7 +19,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 	if (!list_empty(&tbl->matcher_list))
 		last_matcher = list_last_entry(&tbl->matcher_list,
 					       struct mlx5dr_matcher,
-					       matcher_list);
+					       list_node);
 
 	if (tbl->dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX ||
 	    tbl->dmn->type == MLX5DR_DOMAIN_TYPE_FDB) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 75bfdd7890da..a19b40a6e813 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -881,7 +881,7 @@ struct mlx5dr_matcher {
 	struct mlx5dr_table *tbl;
 	struct mlx5dr_matcher_rx_tx rx;
 	struct mlx5dr_matcher_rx_tx tx;
-	struct list_head matcher_list;
+	struct list_head list_node;
 	u32 prio;
 	struct mlx5dr_match_param mask;
 	u8 match_criteria;
-- 
2.33.1


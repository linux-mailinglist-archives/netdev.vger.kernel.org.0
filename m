Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1082D4822B7
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242726AbhLaIUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239991AbhLaIUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F655C06173E
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:20:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB26617AB
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E6EC36AF2;
        Fri, 31 Dec 2021 08:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938845;
        bh=guQ7XJzMBnQ1IuuCU+GyqRIcpfx4EeX3DzhQ5m+m46s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axbjTfesjWJMnXrCmZo0jxUYTrfMl8kzpVucBGM63s5WVmGZpwUd5jxb3RF4iAtFC
         BbG1GGMXml74/usPf5Va3YwLkC6p7I222wJ2aUBm9XeGtrXcAnu26UaiNoEDdPErYT
         GxXr2YEfCysKV8XDJhjxhVhUHenlqBMMr1nSzYqXVhzPrBy0FYBN/smUrg11ivedNZ
         85lbs+XTk5kYKkjlc03ar1M0l26FAW9UPd1Y+zHcx3hGuVP+fB5E5ea3nvTsHc3URJ
         5DF2bfCvFNfUS674WV/MrwwdOnxkloiCozJjbap/hZuM0fE4LvWGDvKB5zcyIc6fGh
         D9k+tTpltrQ+A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 04/16] net/mlx5: DR, Rename list field in matcher struct to list_node
Date:   Fri, 31 Dec 2021 00:20:26 -0800
Message-Id: <20211231082038.106490-5-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
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


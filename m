Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BA1481055
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238971AbhL2GZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58284 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbhL2GZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC8F4B81827
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A03BC36AF1;
        Wed, 29 Dec 2021 06:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759109;
        bh=B+zYTST4K6YsW3TNN7HgtmAiLmVZDAj7LxryV1H+UMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJyJlql+HIk5ckOe0Vq/X+ji+vEAfTDzEnGgObOk3vnHnjLmK2C7piP9QopRDLBhl
         xdESQppXTxcKs3OvXPpl4oBYZIAsKEwe+IQLVCCHoKE4LmSkOcG0y8MK7M6NYZdrJ0
         fgXi9K4UzfKsEsFw0VSgmKNVAu6oqHVGbRdGDpsOFWVLeEQng+5k++BK+0CmbIIncG
         NKI3mHhTmSGjQUmuO0IAUjy/NIxt0tRyiPr9Iv96UyxcmHCcoC/6bfKWfkvDVdphln
         Z+IAIKUXPwwoy98D9uo5VnwegsSlC7DbUij1mHq5RYsei3va70bWcmTsA3BJ4FE1Dk
         VvqTYVOU8IA9g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  08/16] net/mlx5: DR, Add support for UPLINK destination type
Date:   Tue, 28 Dec 2021 22:24:54 -0800
Message-Id: <20211229062502.24111-9-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add support for a new destination type - UPLINK.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  3 ++-
 .../mellanox/mlx5/core/steering/dr_cmd.c      | 20 +++++++++++++------
 .../mellanox/mlx5/core/steering/fs_dr.c       | 18 +++++++++++++++--
 4 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 762b9730a897..dafe341358c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -451,7 +451,8 @@ static int mlx5_set_extended_dest(struct mlx5_core_dev *dev,
 	list_for_each_entry(dst, &fte->node.children, node.list) {
 		if (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
 			continue;
-		if (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_VPORT &&
+		if ((dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
+		     dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_UPLINK) &&
 		    dst->dest_attr.vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID)
 			num_encap++;
 		num_fwd_destinations++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index a8671d7b7ca8..cc76ceebd208 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1525,7 +1525,8 @@ static bool mlx5_flow_dests_cmp(struct mlx5_flow_destination *d1,
 				struct mlx5_flow_destination *d2)
 {
 	if (d1->type == d2->type) {
-		if ((d1->type == MLX5_FLOW_DESTINATION_TYPE_VPORT &&
+		if (((d1->type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
+		      d1->type == MLX5_FLOW_DESTINATION_TYPE_UPLINK) &&
 		     d1->vport.num == d2->vport.num &&
 		     d1->vport.flags == d2->vport.flags &&
 		     ((d1->vport.flags & MLX5_FLOW_DEST_VPORT_VHCA_ID) ?
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 0d7575b64ca4..e1a79eb66f3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -599,7 +599,8 @@ static int mlx5dr_cmd_set_extended_dest(struct mlx5_core_dev *dev,
 	for (i = 0; i < fte->dests_size; i++) {
 		if (fte->dest_arr[i].type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
 			continue;
-		if (fte->dest_arr[i].type == MLX5_FLOW_DESTINATION_TYPE_VPORT &&
+		if ((fte->dest_arr[i].type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
+		     fte->dest_arr[i].type == MLX5_FLOW_DESTINATION_TYPE_UPLINK) &&
 		    fte->dest_arr[i].vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID)
 			num_encap++;
 		num_fwd_destinations++;
@@ -724,12 +725,19 @@ int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 				id = fte->dest_arr[i].ft_id;
 				break;
+			case MLX5_FLOW_DESTINATION_TYPE_UPLINK:
 			case MLX5_FLOW_DESTINATION_TYPE_VPORT:
-				id = fte->dest_arr[i].vport.num;
-				MLX5_SET(dest_format_struct, in_dests,
-					 destination_eswitch_owner_vhca_id_valid,
-					 !!(fte->dest_arr[i].vport.flags &
-					    MLX5_FLOW_DEST_VPORT_VHCA_ID));
+				if (type == MLX5_FLOW_DESTINATION_TYPE_VPORT) {
+					id = fte->dest_arr[i].vport.num;
+					MLX5_SET(dest_format_struct, in_dests,
+						 destination_eswitch_owner_vhca_id_valid,
+						 !!(fte->dest_arr[i].vport.flags &
+						    MLX5_FLOW_DEST_VPORT_VHCA_ID));
+				} else {
+					id = 0;
+					MLX5_SET(dest_format_struct, in_dests,
+						 destination_eswitch_owner_vhca_id_valid, 1);
+				}
 				MLX5_SET(dest_format_struct, in_dests,
 					 destination_eswitch_owner_vhca_id,
 					 fte->dest_arr[i].vport.vhca_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 2632d5ae9bc0..a476da2424f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2019 Mellanox Technologies */
 
+#include <linux/mlx5/vport.h>
 #include "mlx5_core.h"
 #include "fs_core.h"
 #include "fs_cmd.h"
@@ -194,6 +195,15 @@ static struct mlx5dr_action *create_vport_action(struct mlx5dr_domain *domain,
 					       dest_attr->vport.vhca_id);
 }
 
+static struct mlx5dr_action *create_uplink_action(struct mlx5dr_domain *domain,
+						  struct mlx5_flow_rule *dst)
+{
+	struct mlx5_flow_destination *dest_attr = &dst->dest_attr;
+
+	return mlx5dr_action_create_dest_vport(domain, MLX5_VPORT_UPLINK, 1,
+					       dest_attr->vport.vhca_id);
+}
+
 static struct mlx5dr_action *create_ft_action(struct mlx5dr_domain *domain,
 					      struct mlx5_flow_rule *dst)
 {
@@ -218,7 +228,8 @@ static struct mlx5dr_action *create_action_push_vlan(struct mlx5dr_domain *domai
 
 static bool contain_vport_reformat_action(struct mlx5_flow_rule *dst)
 {
-	return dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_VPORT &&
+	return (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
+		dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_UPLINK) &&
 		dst->dest_attr.vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
 }
 
@@ -411,8 +422,11 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 				fs_dr_actions[fs_dr_num_actions++] = tmp_action;
 				term_actions[num_term_actions++].dest = tmp_action;
 				break;
+			case MLX5_FLOW_DESTINATION_TYPE_UPLINK:
 			case MLX5_FLOW_DESTINATION_TYPE_VPORT:
-				tmp_action = create_vport_action(domain, dst);
+				tmp_action = type == MLX5_FLOW_DESTINATION_TYPE_VPORT ?
+					     create_vport_action(domain, dst) :
+					     create_uplink_action(domain, dst);
 				if (!tmp_action) {
 					err = -ENOMEM;
 					goto free_actions;
-- 
2.33.1


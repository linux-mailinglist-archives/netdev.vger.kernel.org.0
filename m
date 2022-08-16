Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28B5595A08
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbiHPL0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiHPLZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C775E58
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCAD760B80
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37D5C433C1;
        Tue, 16 Aug 2022 10:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646435;
        bh=NwLQ/Wf2RPbzfHQqZh5UOB/6CTbP3seJcm8va7qP5js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNJ63LEc0bOw5REn7oL8R2C2zN1hyQiSXz1b9/3HRNs/o/C8cUhY+AZz3f0IKOjGO
         CwT6rPsQVQZnrVlUvTAwbj22Wpq9PQGh6Ft1FLu+f4owOU3cE2jTX41ZPJUSMnXy8S
         /pP1R3grUWdP4E2hNuC5mm8ltAWkIyxlLDEzj9POlWfQxXl3F5KQAYj749sV9ZpYdJ
         b447rosgXo3vYw5jSqDn3YrSJzYC3kcr0wKPFsjdz5XZm3dR601txJgLiHQEmjGwe3
         gPlxj9syOuE74+hvKdFfwOz7ho1pH5iJaKXIyCPDscFB8VIuNnmSTI7xrHyjW/M6vQ
         Ye/ygSx1D6mCQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 18/26] net/mlx5e: Generalize creation of default IPsec miss group and rule
Date:   Tue, 16 Aug 2022 13:38:06 +0300
Message-Id: <fe81ed1a5633a96919243e2de33e8553cb1b0a59.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Create general function that sets miss group and rule to forward all
not-matched traffic to the next table.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 48 +++++++++----------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 3443638453a9..b3827e024a1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -24,7 +24,6 @@ struct mlx5e_ipsec_miss {
 struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_ft ft;
 	struct mlx5e_ipsec_miss sa;
-	struct mlx5_flow_destination default_dest;
 	struct mlx5e_ipsec_rule status;
 };
 
@@ -64,7 +63,8 @@ static struct mlx5_flow_table *ipsec_ft_create(struct mlx5_core_dev *mdev,
 }
 
 static int ipsec_status_rule(struct mlx5_core_dev *mdev,
-			     struct mlx5e_ipsec_rx *rx)
+			     struct mlx5e_ipsec_rx *rx,
+			     struct mlx5_flow_destination *dest)
 {
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_flow_act flow_act = {};
@@ -99,8 +99,7 @@ static int ipsec_status_rule(struct mlx5_core_dev *mdev,
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
 			  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	flow_act.modify_hdr = modify_hdr;
-	fte = mlx5_add_flow_rules(rx->ft.status, spec, &flow_act,
-				  &rx->default_dest, 1);
+	fte = mlx5_add_flow_rules(rx->ft.status, spec, &flow_act, dest, 1);
 	if (IS_ERR(fte)) {
 		err = PTR_ERR(fte);
 		mlx5_core_err(mdev, "fail to add ipsec rx err copy rule err=%d\n", err);
@@ -119,12 +118,12 @@ static int ipsec_status_rule(struct mlx5_core_dev *mdev,
 	return err;
 }
 
-static int rx_fs_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
+static int ipsec_miss_create(struct mlx5_core_dev *mdev,
+			     struct mlx5_flow_table *ft,
+			     struct mlx5e_ipsec_miss *miss,
+			     struct mlx5_flow_destination *dest)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_flow_table *ft = rx->ft.sa;
-	struct mlx5_flow_group *miss_group;
-	struct mlx5_flow_handle *miss_rule;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_spec *spec;
 	u32 *flow_group_in;
@@ -140,24 +139,23 @@ static int rx_fs_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 	/* Create miss_group */
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ft->max_fte - 1);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ft->max_fte - 1);
-	miss_group = mlx5_create_flow_group(ft, flow_group_in);
-	if (IS_ERR(miss_group)) {
-		err = PTR_ERR(miss_group);
-		mlx5_core_err(mdev, "fail to create ipsec rx miss_group err=%d\n", err);
+	miss->group = mlx5_create_flow_group(ft, flow_group_in);
+	if (IS_ERR(miss->group)) {
+		err = PTR_ERR(miss->group);
+		mlx5_core_err(mdev, "fail to create IPsec miss_group err=%d\n",
+			      err);
 		goto out;
 	}
-	rx->sa.group = miss_group;
 
 	/* Create miss rule */
-	miss_rule =
-		mlx5_add_flow_rules(ft, spec, &flow_act, &rx->default_dest, 1);
-	if (IS_ERR(miss_rule)) {
-		mlx5_destroy_flow_group(rx->sa.group);
-		err = PTR_ERR(miss_rule);
-		mlx5_core_err(mdev, "fail to create ipsec rx miss_rule err=%d\n", err);
+	miss->rule = mlx5_add_flow_rules(ft, spec, &flow_act, dest, 1);
+	if (IS_ERR(miss->rule)) {
+		mlx5_destroy_flow_group(miss->group);
+		err = PTR_ERR(miss->rule);
+		mlx5_core_err(mdev, "fail to create IPsec miss_rule err=%d\n",
+			      err);
 		goto out;
 	}
-	rx->sa.rule = miss_rule;
 out:
 	kvfree(flow_group_in);
 	kvfree(spec);
@@ -178,12 +176,10 @@ static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		     struct mlx5e_ipsec_rx *rx, u32 family)
 {
+	struct mlx5_flow_destination dest;
 	struct mlx5_flow_table *ft;
 	int err;
 
-	rx->default_dest =
-		mlx5_ttc_get_default_dest(ipsec->fs->ttc, family2tt(family));
-
 	ft = ipsec_ft_create(mdev, ipsec->fs->ns,
 			     MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL, MLX5E_NIC_PRIO, 1,
 			     XFRM_DEV_OFFLOAD_IN);
@@ -191,7 +187,9 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		return PTR_ERR(ft);
 
 	rx->ft.status = ft;
-	err = ipsec_status_rule(mdev, rx);
+
+	dest = mlx5_ttc_get_default_dest(ipsec->fs->ttc, family2tt(family));
+	err = ipsec_status_rule(mdev, rx, &dest);
 	if (err)
 		goto err_add;
 
@@ -204,7 +202,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	}
 	rx->ft.sa = ft;
 
-	err = rx_fs_create(mdev, rx);
+	err = ipsec_miss_create(mdev, rx->ft.sa, &rx->sa, &dest);
 	if (err)
 		goto err_fs;
 
-- 
2.37.2


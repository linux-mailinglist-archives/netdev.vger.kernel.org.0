Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44637640EF6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiLBUMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbiLBUL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E90BF4EA3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F147E622E1
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DCAC433C1;
        Fri,  2 Dec 2022 20:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011910;
        bh=z6tjYnYlYMwilCDBM0iQtNINwEhd9cZdTOd9gi/Fw3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZJRRpSMdzY6Ch3s9YSQhkaHuDr8xXUnwGvw7GomiKbw0jLPlepk39r6on8L8v63b
         rJnXv/pwDAAKTQENCng+mpgFrqxaOoSamXsuaTKZWJk5OYUBhblfgegfnzbSxWfcHK
         7/X2ElactMr4utxg5n3g5iVG/YoodMaesiCNkEME2N/Hde02dMtfkFD0/W+KPIYvTZ
         tv6Mnd4xWfoqTMK+ZJFs+HtMVTgCF1z6ZXyztfrUE/CRB9GYMz+5rmyw5Ni742/AtV
         C4X4U9ccUgjk96s5/X83mweqO7ISz4zRWVW9jUYjJbPnWqL8+O8qS8lWqwTPH/j4a7
         RgjsnRaIv4RmQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 16/16] net/mlx5e: Generalize creation of default IPsec miss group and rule
Date:   Fri,  2 Dec 2022 22:10:37 +0200
Message-Id: <15efae1c06b71944c96036d89e0b8a6690c36d92.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Create general function that sets miss group and rule to forward all
not-matched traffic to the next table.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 47 +++++++++----------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index dfdda5ae2245..5bc6f9d1f5a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -24,7 +24,6 @@ struct mlx5e_ipsec_miss {
 struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_ft ft;
 	struct mlx5e_ipsec_miss sa;
-	struct mlx5_flow_destination default_dest;
 	struct mlx5e_ipsec_rule status;
 };
 
@@ -57,7 +56,8 @@ static struct mlx5_flow_table *ipsec_ft_create(struct mlx5_flow_namespace *ns,
 }
 
 static int ipsec_status_rule(struct mlx5_core_dev *mdev,
-			     struct mlx5e_ipsec_rx *rx)
+			     struct mlx5e_ipsec_rx *rx,
+			     struct mlx5_flow_destination *dest)
 {
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_flow_act flow_act = {};
@@ -92,8 +92,7 @@ static int ipsec_status_rule(struct mlx5_core_dev *mdev,
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
 			  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	flow_act.modify_hdr = modify_hdr;
-	fte = mlx5_add_flow_rules(rx->ft.status, spec, &flow_act,
-				  &rx->default_dest, 1);
+	fte = mlx5_add_flow_rules(rx->ft.status, spec, &flow_act, dest, 1);
 	if (IS_ERR(fte)) {
 		err = PTR_ERR(fte);
 		mlx5_core_err(mdev, "fail to add ipsec rx err copy rule err=%d\n", err);
@@ -112,12 +111,12 @@ static int ipsec_status_rule(struct mlx5_core_dev *mdev,
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
@@ -133,24 +132,23 @@ static int rx_fs_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
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
@@ -173,18 +171,19 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 {
 	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(ipsec->fs, false);
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
+	struct mlx5_flow_destination dest;
 	struct mlx5_flow_table *ft;
 	int err;
 
-	rx->default_dest = mlx5_ttc_get_default_dest(ttc, family2tt(family));
-
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
 			     MLX5E_NIC_PRIO, 1);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
 	rx->ft.status = ft;
-	err = ipsec_status_rule(mdev, rx);
+
+	dest = mlx5_ttc_get_default_dest(ttc, family2tt(family));
+	err = ipsec_status_rule(mdev, rx, &dest);
 	if (err)
 		goto err_add;
 
@@ -197,7 +196,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	}
 	rx->ft.sa = ft;
 
-	err = rx_fs_create(mdev, rx);
+	err = ipsec_miss_create(mdev, rx->ft.sa, &rx->sa, &dest);
 	if (err)
 		goto err_fs;
 
-- 
2.38.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C905E5959FC
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiHPLZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiHPLZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6A563F33
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E604ECE173F
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77021C433C1;
        Tue, 16 Aug 2022 10:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646373;
        bh=M5phlL+oGPr5470Srzl4gt0ZwODE97VdhS412ueli3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ua7eTmYK58EYuJue8eSmG92MUD5lfjrPzpyC9iiwupuxRjUKZQdqqxOcoebOAm9IS
         JoitMwZdjDJuX3Lb5ckVNKr5MYFuqMar59N7jjtM8/H4lGNpC2zAV6JEwuQPupihs+
         TYnK6ac7TG/htqcXXFNCkeWAPV/yTASvjALYQOm56BAcunxhJdixEs9sVcfv5Vy8UT
         nmzG5/apVlRrRZedksY+RwDnLuz4ZEodYNFOe6E7xNXN0DS6xAAM9jlaF5M9UgeNwc
         dsOU1AwLGrxa+jDEqwPTsq1QlC2Vj/K8xY2NZDfa5FhdWoVN20NNkQQ+pH5L5b0Epl
         q2vv5MO99J1+Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 13/26] net/mlx5e: Move IPsec flow table creation to separate function
Date:   Tue, 16 Aug 2022 13:38:01 +0300
Message-Id: <8493b543ac63b1cfeb0e4a888e23e5767843317f.1660641154.git.leonro@nvidia.com>
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

Even now, to support IPsec crypto, the RX and TX paths use same
logic to create flow tables. In the following patches, we will
add more tables to support IPsec full offload. So reuse existing
code and rewrite it to support IPsec full offload from the beginning.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 53 +++++++++++--------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index e732ce19e039..291533d55e2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -42,6 +42,28 @@ static enum mlx5_traffic_types family2tt(u32 family)
 	return MLX5_TT_IPV6_IPSEC_ESP;
 }
 
+static struct mlx5_flow_table *ipsec_ft_create(struct mlx5_core_dev *mdev,
+					       struct mlx5_flow_namespace *ns,
+					       int level, int prio,
+					       int max_num_groups, u8 dir)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+
+	ft_attr.autogroup.num_reserved_entries = 1;
+	ft_attr.autogroup.max_num_groups = max_num_groups;
+	ft_attr.max_fte = NUM_IPSEC_FTE;
+	ft_attr.level = level;
+	ft_attr.prio = prio;
+	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_FULL_OFFLOAD) {
+		ft_attr.flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
+
+		if (dir == XFRM_DEV_OFFLOAD_IN)
+			ft_attr.flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
+	}
+
+	return mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+}
+
 static int rx_err_add_rule(struct mlx5_core_dev *mdev,
 			   struct mlx5e_ipsec_rx *rx,
 			   struct mlx5e_ipsec_rx_err *rx_err)
@@ -158,18 +180,15 @@ static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		     struct mlx5e_ipsec_rx *rx, u32 family)
 {
-	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_table *ft;
 	int err;
 
 	rx->default_dest =
 		mlx5_ttc_get_default_dest(ipsec->fs->ttc, family2tt(family));
 
-	ft_attr.max_fte = 1;
-	ft_attr.autogroup.max_num_groups = 1;
-	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
-	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft = mlx5_create_auto_grouped_flow_table(ipsec->fs->ns, &ft_attr);
+	ft = ipsec_ft_create(mdev, ipsec->fs->ns,
+			     MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL, MLX5E_NIC_PRIO, 1,
+			     XFRM_DEV_OFFLOAD_IN);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
@@ -179,12 +198,8 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		goto err_add;
 
 	/* Create FT */
-	ft_attr.max_fte = NUM_IPSEC_FTE;
-	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_LEVEL;
-	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft_attr.autogroup.num_reserved_entries = 1;
-	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(ipsec->fs->ns, &ft_attr);
+	ft = ipsec_ft_create(mdev, ipsec->fs->ns, MLX5E_ACCEL_FS_ESP_FT_LEVEL,
+			     MLX5E_NIC_PRIO, 1, XFRM_DEV_OFFLOAD_IN);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_fs_ft;
@@ -270,18 +285,12 @@ static void rx_ft_put(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 /* IPsec TX flow steering */
 static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx)
 {
-	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_table *ft;
-	int err;
 
-	ft_attr.max_fte = NUM_IPSEC_FTE;
-	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(tx->ns, &ft_attr);
-	if (IS_ERR(ft)) {
-		err = PTR_ERR(ft);
-		mlx5_core_err(mdev, "fail to create ipsec tx ft err=%d\n", err);
-		return err;
-	}
+	ft = ipsec_ft_create(mdev, tx->ns, 0, 0, 1, XFRM_DEV_OFFLOAD_OUT);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
+
 	tx->ft.sa = ft;
 	return 0;
 }
-- 
2.37.2


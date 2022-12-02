Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E813640EEE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbiLBULu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiLBULd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2200DF1CC4
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD6EE622E0
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD70C433D7;
        Fri,  2 Dec 2022 20:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011886;
        bh=FxYRQnPqsWLxOrXu1p+qun82TQtXFu3goc3CPSYlDEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmrqpxYqyo8C2FleXYcGqkshSuqN/hfIh9CJjEWhLuFN9Q/FGwEZR2F+EqX1J5aTx
         7zlE3EotqsCnbFFLgUX2WuCmLXe7EZk5Kd+5JtpHH5PCSLroQmIB6PyYzbGqhsbTQ6
         MoweQYL4swrSuNxKA1hiERJSYV1mDw2HNixIVAu6tSSPFATEUJSC9D9XaW4bFhT1eY
         4vReZoMM5f8pQdpyz7knrl/RcsM/9xqyAs+tR40mdzNwjSHTGu16IIYIDDlDcXG3sy
         Z6zFLYI9CFZPFRY94L6mJg7WxdnjuN0Hp0oQhZyd2rSMScJHp2mmHmo62jOi2Uxghv
         U58HqRJem2WJw==
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
Subject: [PATCH xfrm-next 11/16] net/mlx5e: Move IPsec flow table creation to separate function
Date:   Fri,  2 Dec 2022 22:10:32 +0200
Message-Id: <9f1b2e1809aa97642f46c2a4a597e52702a1570f.1670011671.git.leonro@nvidia.com>
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

Even now, to support IPsec crypto, the RX and TX paths use same
logic to create flow tables. In the following patches, we will
add more tables to support IPsec packet offload. So reuse existing
code and rewrite it to support IPsec packet offload from the beginning.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 45 ++++++++++---------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 8e87d8d02511..f65a74e3d648 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -42,6 +42,21 @@ static enum mlx5_traffic_types family2tt(u32 family)
 	return MLX5_TT_IPV6_IPSEC_ESP;
 }
 
+static struct mlx5_flow_table *ipsec_ft_create(struct mlx5_flow_namespace *ns,
+					       int level, int prio,
+					       int max_num_groups)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+
+	ft_attr.autogroup.num_reserved_entries = 1;
+	ft_attr.autogroup.max_num_groups = max_num_groups;
+	ft_attr.max_fte = NUM_IPSEC_FTE;
+	ft_attr.level = level;
+	ft_attr.prio = prio;
+
+	return mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+}
+
 static int rx_err_add_rule(struct mlx5_core_dev *mdev,
 			   struct mlx5e_ipsec_rx *rx,
 			   struct mlx5e_ipsec_rx_err *rx_err)
@@ -160,17 +175,13 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 {
 	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(ipsec->fs, false);
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
-	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_table *ft;
 	int err;
 
 	rx->default_dest = mlx5_ttc_get_default_dest(ttc, family2tt(family));
 
-	ft_attr.max_fte = 1;
-	ft_attr.autogroup.max_num_groups = 1;
-	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
-	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
+			     MLX5E_NIC_PRIO, 1);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
@@ -180,12 +191,8 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		goto err_add;
 
 	/* Create FT */
-	ft_attr.max_fte = NUM_IPSEC_FTE;
-	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_LEVEL;
-	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft_attr.autogroup.num_reserved_entries = 1;
-	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_LEVEL, MLX5E_NIC_PRIO,
+			     1);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_fs_ft;
@@ -273,18 +280,12 @@ static void rx_ft_put(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
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
+	ft = ipsec_ft_create(tx->ns, 0, 0, 1);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
+
 	tx->ft.sa = ft;
 	return 0;
 }
-- 
2.38.1


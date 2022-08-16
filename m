Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A0F5959F8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiHPLZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiHPLZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17260101D20
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64BF1B8169E
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AAAC433C1;
        Tue, 16 Aug 2022 10:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646357;
        bh=qbwZXJBZSVwUph8IvHCoZcWroB9iVpdOp7A/yQkLo5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+iDt7w8jaVXt5U56/rc8uMjJagwyuCZulkYpMDUc3gJG89gR+VCqiFIGpwoLdneD
         HuXLYuVQhqh9KG1OFyQWt6IPQMY8/VD7OgRSby5ymhe3pRiSUqfjqoqcZHDXmPsGnc
         qHrU6ra5d1RB4YVlr7cqWpjLoj3s0wl3hkwslwVJjqTxFCmS9A5FF5DTWOuC+KMHaY
         o8v6t+m4weLC+BKLkghWTuxXL3Fvn6fKGS3YPqGgq/luXUAXYSCLg9I0CG60oPMyw+
         On54rnX5d7lSjZVraSwQu5a/X9hy21Y76NP+M3zA0AWiXfRpuswvE8RCcGPfFy/iIN
         ZzxRSEL63ws4Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 08/26] net/mlx5e: Use mlx5 print routines for low level IPsec code
Date:   Tue, 16 Aug 2022 13:37:56 +0300
Message-Id: <9ba6edfd108ae7a4aa9e33b946f17c230c5b7742.1660641154.git.leonro@nvidia.com>
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

Low level mlx5 code needs to use mlx5_core print routines and
not netdev ones, as the failures are relevant to the HW itself
and not to its netdev.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index fdc4517fa104..c9b93ea8eec5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -70,8 +70,8 @@ static int rx_err_add_rule(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
 
 	if (IS_ERR(modify_hdr)) {
 		err = PTR_ERR(modify_hdr);
-		netdev_err(priv->netdev,
-			   "fail to alloc ipsec copy modify_header_id err=%d\n", err);
+		mlx5_core_err(mdev,
+			      "fail to alloc ipsec copy modify_header_id err=%d\n", err);
 		goto out_spec;
 	}
 
@@ -83,7 +83,7 @@ static int rx_err_add_rule(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx,
 				  &rx->default_dest, 1);
 	if (IS_ERR(fte)) {
 		err = PTR_ERR(fte);
-		netdev_err(priv->netdev, "fail to add ipsec rx err copy rule err=%d\n", err);
+		mlx5_core_err(mdev, "fail to add ipsec rx err copy rule err=%d\n", err);
 		goto out;
 	}
 
@@ -103,6 +103,7 @@ static int rx_fs_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table *ft = rx->ft.sa;
+	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -123,7 +124,7 @@ static int rx_fs_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx)
 	miss_group = mlx5_create_flow_group(ft, flow_group_in);
 	if (IS_ERR(miss_group)) {
 		err = PTR_ERR(miss_group);
-		netdev_err(priv->netdev, "fail to create ipsec rx miss_group err=%d\n", err);
+		mlx5_core_err(mdev, "fail to create ipsec rx miss_group err=%d\n", err);
 		goto out;
 	}
 	rx->miss_group = miss_group;
@@ -134,7 +135,7 @@ static int rx_fs_create(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx *rx)
 	if (IS_ERR(miss_rule)) {
 		mlx5_destroy_flow_group(rx->miss_group);
 		err = PTR_ERR(miss_rule);
-		netdev_err(priv->netdev, "fail to create ipsec rx miss_rule err=%d\n", err);
+		mlx5_core_err(mdev, "fail to create ipsec rx miss_rule err=%d\n", err);
 		goto out;
 	}
 	rx->miss_rule = miss_rule;
@@ -270,6 +271,7 @@ static int tx_create(struct mlx5e_priv *priv)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5e_ipsec *ipsec = priv->ipsec;
+	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_flow_table *ft;
 	int err;
 
@@ -278,7 +280,7 @@ static int tx_create(struct mlx5e_priv *priv)
 	ft = mlx5_create_auto_grouped_flow_table(ipsec->tx->ns, &ft_attr);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
-		netdev_err(priv->netdev, "fail to create ipsec tx ft err=%d\n", err);
+		mlx5_core_err(mdev, "fail to create ipsec tx ft err=%d\n", err);
 		return err;
 	}
 	ipsec->tx->ft.sa = ft;
@@ -382,6 +384,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	u32 ipsec_obj_id = sa_entry->ipsec_obj_id;
 	struct mlx5_modify_hdr *modify_hdr = NULL;
 	struct mlx5_flow_destination dest = {};
@@ -415,8 +418,8 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 					      1, action);
 	if (IS_ERR(modify_hdr)) {
 		err = PTR_ERR(modify_hdr);
-		netdev_err(priv->netdev,
-			   "fail to alloc ipsec set modify_header_id err=%d\n", err);
+		mlx5_core_err(mdev,
+			      "fail to alloc ipsec set modify_header_id err=%d\n", err);
 		modify_hdr = NULL;
 		goto out_err;
 	}
@@ -430,8 +433,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev, "fail to add RX ipsec rule err=%d\n",
-			   err);
+		mlx5_core_err(mdev, "fail to add RX ipsec rule err=%d\n", err);
 		goto out_err;
 	}
 
@@ -452,6 +454,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 static int tx_add_rule(struct mlx5e_priv *priv,
 		       struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
@@ -483,8 +486,7 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, NULL, 0);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev, "fail to add TX ipsec rule err=%d\n",
-			   err);
+		mlx5_core_err(mdev, "fail to add TX ipsec rule err=%d\n", err);
 		goto out;
 	}
 
-- 
2.37.2


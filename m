Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018FE595A05
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiHPL0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiHPLZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6257D326D4
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 241D8B8169C
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87027C433C1;
        Tue, 16 Aug 2022 10:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646397;
        bh=m+3Kf8yNq/93PTVmmVuvOJb63e0bZnYKgIaiGcfhhEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggmajFFnmHfxrRtx05Gm89rJwfgrYhjbef4vdzKsLDZZbn8S2r/qG8U4BMaK3EY+e
         NKUYNJFx3lQqpn92ScHpByQvVaziDHcCIqFZHF4A3bl63ntPbEWdU5a8rBgcOk6X7j
         EG4TVpxaWFyEoTdU1ILvLbEwNgw3n+p3Nqc8AZNAly/0JFHi/T4LBzCQK4nxXkHYCx
         PdT+LFMzMQyENnl34DVxqwVbZB3VcJ28DiP5MtmdmYtStHeFgCr3O4VXEqQKnEomoI
         qjYmVaDbBxr/fSe49fo9NY9lDBZo8WgFj9z1UyrbWCv8ADYy4LOMndCXAahKBbewcy
         fc2U3TYHYo8dA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 16/26] net/mlx5e: Make clear what IPsec rx_err does
Date:   Tue, 16 Aug 2022 13:38:04 +0300
Message-Id: <dbb78db97047bef392581652e4c5803bede7603a.1660641154.git.leonro@nvidia.com>
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

Reuse existing struct what holds all information about modify
header pointer and rule. This helps to reduce ambiguity from the
name _err_ that doesn't describe the real purpose of that flow
table, rule and function - to copy status result from HW to
the stack.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 38 ++++++++-----------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 03b0ce7b09df..7d1b587a0a04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -9,15 +9,10 @@
 
 #define NUM_IPSEC_FTE BIT(15)
 
-struct mlx5e_ipsec_rx_err {
-	struct mlx5_flow_table *ft;
-	struct mlx5_flow_handle *rule;
-	struct mlx5_modify_hdr *copy_modify_hdr;
-};
-
 struct mlx5e_ipsec_ft {
 	struct mutex mutex; /* Protect changes to this struct */
 	struct mlx5_flow_table *sa;
+	struct mlx5_flow_table *status;
 	u32 refcnt;
 };
 
@@ -26,7 +21,7 @@ struct mlx5e_ipsec_rx {
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
 	struct mlx5_flow_destination default_dest;
-	struct mlx5e_ipsec_rx_err rx_err;
+	struct mlx5e_ipsec_rule status;
 };
 
 struct mlx5e_ipsec_tx {
@@ -64,9 +59,8 @@ static struct mlx5_flow_table *ipsec_ft_create(struct mlx5_core_dev *mdev,
 	return mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 }
 
-static int rx_err_add_rule(struct mlx5_core_dev *mdev,
-			   struct mlx5e_ipsec_rx *rx,
-			   struct mlx5e_ipsec_rx_err *rx_err)
+static int ipsec_status_rule(struct mlx5_core_dev *mdev,
+			     struct mlx5e_ipsec_rx *rx)
 {
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_flow_act flow_act = {};
@@ -101,7 +95,7 @@ static int rx_err_add_rule(struct mlx5_core_dev *mdev,
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
 			  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	flow_act.modify_hdr = modify_hdr;
-	fte = mlx5_add_flow_rules(rx_err->ft, spec, &flow_act,
+	fte = mlx5_add_flow_rules(rx->ft.status, spec, &flow_act,
 				  &rx->default_dest, 1);
 	if (IS_ERR(fte)) {
 		err = PTR_ERR(fte);
@@ -110,8 +104,8 @@ static int rx_err_add_rule(struct mlx5_core_dev *mdev,
 	}
 
 	kvfree(spec);
-	rx_err->rule = fte;
-	rx_err->copy_modify_hdr = modify_hdr;
+	rx->status.rule = fte;
+	rx->status.modify_hdr = modify_hdr;
 	return 0;
 
 out:
@@ -172,9 +166,9 @@ static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 	mlx5_destroy_flow_group(rx->miss_group);
 	mlx5_destroy_flow_table(rx->ft.sa);
 
-	mlx5_del_flow_rules(rx->rx_err.rule);
-	mlx5_modify_header_dealloc(mdev, rx->rx_err.copy_modify_hdr);
-	mlx5_destroy_flow_table(rx->rx_err.ft);
+	mlx5_del_flow_rules(rx->status.rule);
+	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
+	mlx5_destroy_flow_table(rx->ft.status);
 }
 
 static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
@@ -192,8 +186,8 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
-	rx->rx_err.ft = ft;
-	err = rx_err_add_rule(mdev, rx, &rx->rx_err);
+	rx->ft.status = ft;
+	err = ipsec_status_rule(mdev, rx);
 	if (err)
 		goto err_add;
 
@@ -215,10 +209,10 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 err_fs:
 	mlx5_destroy_flow_table(rx->ft.sa);
 err_fs_ft:
-	mlx5_del_flow_rules(rx->rx_err.rule);
-	mlx5_modify_header_dealloc(mdev, rx->rx_err.copy_modify_hdr);
+	mlx5_del_flow_rules(rx->status.rule);
+	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
 err_add:
-	mlx5_destroy_flow_table(rx->rx_err.ft);
+	mlx5_destroy_flow_table(rx->ft.status);
 	return err;
 }
 
@@ -481,7 +475,7 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			   MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = rx->rx_err.ft;
+	dest.ft = rx->ft.status;
 	rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-- 
2.37.2


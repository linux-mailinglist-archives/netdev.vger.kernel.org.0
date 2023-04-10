Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D27C6DC37C
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjDJGTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJGT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:19:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEA740D5
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 23:19:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A49E60B36
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12969C433EF;
        Mon, 10 Apr 2023 06:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681107566;
        bh=/OBLJg4d+ImitWZytGBxrpyE88uOiIDXyyg3cZ51kXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmxwfuHf+WNmySpqKir1kQzx4bYbbnw9q5Wsu8CuFzNKR5V9wtHwZzIQ+n4PfPMN3
         c4raj5yijVtLHvgYtLyJom6O+uW65lVXI5XBbaTy77Ou7EBfah3Khu5S+2J1mEWJBw
         dkSbBmP4v+ixwvyKPyTryVgRtvUPTJwLdD0TBq3jQ2BrfxpmSL2TlPqfmF7cMbBdbR
         EDmD3MUefnEm0bsE4rT2AVNvIaD3QVD7PabBHIC1FucwybEO9jqBHo5iWqfPN1gOeB
         RPyJv3L/SAFslZbXKK8eV54/LzoStH4kXNla9Cj+uFXTqpSiwWnMrGNYS3wmflmhiS
         CpyMtgjfcuKxA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 03/10] net/mlx5e: Configure IPsec SA tables to support tunnel mode
Date:   Mon, 10 Apr 2023 09:19:05 +0300
Message-Id: <6dd712b0868728fe08c3bce30d82f4dbb12638d5.1681106636.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681106636.git.leonro@nvidia.com>
References: <cover.1681106636.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Create SA flow steering tables both for RX and TX with tunnel reformat
property. This allows to add and delete extra headers needed for tunnel
mode.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 23 ++++++++++++-------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index b47794d4146e..060be020ca64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -118,7 +118,7 @@ static void ipsec_chains_put_table(struct mlx5_fs_chains *chains, u32 prio)
 
 static struct mlx5_flow_table *ipsec_ft_create(struct mlx5_flow_namespace *ns,
 					       int level, int prio,
-					       int max_num_groups)
+					       int max_num_groups, u32 flags)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 
@@ -127,6 +127,7 @@ static struct mlx5_flow_table *ipsec_ft_create(struct mlx5_flow_namespace *ns,
 	ft_attr.max_fte = NUM_IPSEC_FTE;
 	ft_attr.level = level;
 	ft_attr.prio = prio;
+	ft_attr.flags = flags;
 
 	return mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 }
@@ -267,6 +268,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	struct mlx5_flow_destination default_dest;
 	struct mlx5_flow_destination dest[2];
 	struct mlx5_flow_table *ft;
+	u32 flags = 0;
 	int err;
 
 	default_dest = mlx5_ttc_get_default_dest(ttc, family2tt(family));
@@ -277,7 +279,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		return err;
 
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
-			     MLX5E_NIC_PRIO, 1);
+			     MLX5E_NIC_PRIO, 1, 0);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_fs_ft_status;
@@ -300,8 +302,10 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		goto err_add;
 
 	/* Create FT */
-	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_LEVEL, MLX5E_NIC_PRIO,
-			     2);
+	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
+		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
+	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_LEVEL, MLX5E_NIC_PRIO, 2,
+			     flags);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_fs_ft;
@@ -327,7 +331,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	}
 
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_POL_FT_LEVEL, MLX5E_NIC_PRIO,
-			     2);
+			     2, 0);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_pol_ft;
@@ -511,9 +515,10 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 {
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_table *ft;
+	u32 flags = 0;
 	int err;
 
-	ft = ipsec_ft_create(tx->ns, 2, 0, 1);
+	ft = ipsec_ft_create(tx->ns, 2, 0, 1, 0);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 	tx->ft.status = ft;
@@ -522,7 +527,9 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 	if (err)
 		goto err_status_rule;
 
-	ft = ipsec_ft_create(tx->ns, 1, 0, 4);
+	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
+		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
+	ft = ipsec_ft_create(tx->ns, 1, 0, 4, flags);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_sa_ft;
@@ -541,7 +548,7 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 		goto connect_roce;
 	}
 
-	ft = ipsec_ft_create(tx->ns, 0, 0, 2);
+	ft = ipsec_ft_create(tx->ns, 0, 0, 2, 0);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_pol_ft;
-- 
2.39.2


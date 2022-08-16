Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A7D595A0A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbiHPL00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiHPLZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FBDE0960
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E11E60B80
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E71CC433D6;
        Tue, 16 Aug 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646417;
        bh=IoaphPGtVqCGepVJuN72E3cYlLISi8nqqhg2igu3xFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mm+9nMCQZR8KloKYG1/DLkEqCV2m5tJT1G9v5AzHQnsAQ91X6Ie3K8PqCGiKK/2OK
         c913QNkyua40Y5H/N9ycewwDcwCPeWOvi66Dw22ukdlcz2gWvEDzhDafu1rOpBivZy
         8+pRi29jBTr+AMIg0eHUOTSwXxe2ei1VFeQPZ0eBhtAyAlzsDiW+sVaOHYX53xGHgr
         f7vKUIkIIMaAByWZZdMCO5dzysxuHs5LeZVvxsy1MHYxJcRouLKTIGsm47WdxWfpkA
         Yv/ffIs1yOCOb0Tot5uSVXJ0C/rqYt6KCUxi+FgAqgEqYRnUMqYr1lOqeUf8wufS9o
         JEj6e7cNEE+TA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 19/26] net/mlx5e: Create IPsec policy offload tables
Date:   Tue, 16 Aug 2022 13:38:07 +0300
Message-Id: <086609fcbc5965d7d6c4c3ec48157d2cb68f6f8a.1660641154.git.leonro@nvidia.com>
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

Add empty table to be used for IPsec policy offload.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  3 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 53 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  6 +--
 3 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 9b8cdf2e68ad..6e155ed64d94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -78,7 +78,8 @@ enum {
 	MLX5E_ARFS_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 #endif
 #ifdef CONFIG_MLX5_EN_IPSEC
-	MLX5E_ACCEL_FS_ESP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
+	MLX5E_ACCEL_FS_POL_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
+	MLX5E_ACCEL_FS_ESP_FT_LEVEL,
 	MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
 #endif
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index b3827e024a1d..1878bca0121a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -11,6 +11,7 @@
 
 struct mlx5e_ipsec_ft {
 	struct mutex mutex; /* Protect changes to this struct */
+	struct mlx5_flow_table *pol;
 	struct mlx5_flow_table *sa;
 	struct mlx5_flow_table *status;
 	u32 refcnt;
@@ -23,12 +24,14 @@ struct mlx5e_ipsec_miss {
 
 struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_ft ft;
+	struct mlx5e_ipsec_miss pol;
 	struct mlx5e_ipsec_miss sa;
 	struct mlx5e_ipsec_rule status;
 };
 
 struct mlx5e_ipsec_tx {
 	struct mlx5e_ipsec_ft ft;
+	struct mlx5e_ipsec_miss pol;
 	struct mlx5_flow_namespace *ns;
 };
 
@@ -164,6 +167,10 @@ static int ipsec_miss_create(struct mlx5_core_dev *mdev,
 
 static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 {
+	mlx5_del_flow_rules(rx->pol.rule);
+	mlx5_destroy_flow_group(rx->pol.group);
+	mlx5_destroy_flow_table(rx->ft.pol);
+
 	mlx5_del_flow_rules(rx->sa.rule);
 	mlx5_destroy_flow_group(rx->sa.group);
 	mlx5_destroy_flow_table(rx->ft.sa);
@@ -206,8 +213,27 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (err)
 		goto err_fs;
 
+	ft = ipsec_ft_create(mdev, ipsec->fs->ns, MLX5E_ACCEL_FS_POL_FT_LEVEL,
+			     MLX5E_NIC_PRIO, 1, XFRM_DEV_OFFLOAD_IN);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_pol_ft;
+	}
+	rx->ft.pol = ft;
+	memset(&dest, 0x00, sizeof(dest));
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = rx->ft.sa;
+	err = ipsec_miss_create(mdev, rx->ft.pol, &rx->pol, &dest);
+	if (err)
+		goto err_pol_miss;
+
 	return 0;
 
+err_pol_miss:
+	mlx5_destroy_flow_table(rx->ft.pol);
+err_pol_ft:
+	mlx5_del_flow_rules(rx->sa.rule);
+	mlx5_destroy_flow_group(rx->sa.group);
 err_fs:
 	mlx5_destroy_flow_table(rx->ft.sa);
 err_fs_ft:
@@ -241,7 +267,7 @@ static struct mlx5e_ipsec_rx *rx_ft_get(struct mlx5_core_dev *mdev,
 
 	/* connect */
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = rx->ft.sa;
+	dest.ft = rx->ft.pol;
 	mlx5_ttc_fwd_dest(ipsec->fs->ttc, family2tt(family), &dest);
 
 skip:
@@ -281,14 +307,34 @@ static void rx_ft_put(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 /* IPsec TX flow steering */
 static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx)
 {
+	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_table *ft;
+	int err;
 
-	ft = ipsec_ft_create(mdev, tx->ns, 0, 0, 1, XFRM_DEV_OFFLOAD_OUT);
+	ft = ipsec_ft_create(mdev, tx->ns, 1, 0, 1, XFRM_DEV_OFFLOAD_OUT);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
 	tx->ft.sa = ft;
+
+	ft = ipsec_ft_create(mdev, tx->ns, 0, 0, 1, XFRM_DEV_OFFLOAD_OUT);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_pol_ft;
+	}
+	tx->ft.pol = ft;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = tx->ft.sa;
+	err = ipsec_miss_create(mdev, tx->ft.pol, &tx->pol, &dest);
+	if (err)
+		goto err_pol_miss;
 	return 0;
+
+err_pol_miss:
+	mlx5_destroy_flow_table(tx->ft.pol);
+err_pol_ft:
+	mlx5_destroy_flow_table(tx->ft.sa);
+	return err;
 }
 
 static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5_core_dev *mdev,
@@ -322,6 +368,9 @@ static void tx_ft_put(struct mlx5e_ipsec *ipsec)
 	if (tx->ft.refcnt)
 		goto out;
 
+	mlx5_del_flow_rules(tx->pol.rule);
+	mlx5_destroy_flow_group(tx->pol.group);
+	mlx5_destroy_flow_table(tx->ft.pol);
 	mlx5_destroy_flow_table(tx->ft.sa);
 out:
 	mutex_unlock(&tx->ft.mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index e3960cdf5131..bb7e8c6f299c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -107,8 +107,8 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}} */
-#define KERNEL_NIC_PRIO_NUM_LEVELS 7
+/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}}, IPsec policy */
+#define KERNEL_NIC_PRIO_NUM_LEVELS 8
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
@@ -129,7 +129,7 @@
 #define LAG_MIN_LEVEL (OFFLOADS_MIN_LEVEL + 1)
 
 #define KERNEL_TX_IPSEC_NUM_PRIOS  1
-#define KERNEL_TX_IPSEC_NUM_LEVELS 1
+#define KERNEL_TX_IPSEC_NUM_LEVELS 2
 #define KERNEL_TX_MIN_LEVEL        (KERNEL_TX_IPSEC_NUM_LEVELS)
 
 struct node_caps {
-- 
2.37.2


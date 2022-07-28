Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8015B584765
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbiG1U62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiG1U5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4A778582
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5AFEB82595
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D14C433D6;
        Thu, 28 Jul 2022 20:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041858;
        bh=uifKrjomxd/WYKYi3NCjICHyS13fBrfPuFLZH8A9s4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLOL23vsKoTc3/f0L2x892oTeDkCCKg11s/08whdBb5UMYEwSEgvmh0BK43gBxQbn
         eKGYiBrvpPctCSqXdz3hE8CavJuokF//cJaPjsIhEjQzYTeTMk1VWKMqc/5YqfMx0c
         U9P9juHaDSS3xBDzECETxHTyfeInagSqO5KoRP8fsDFl9ml886dg1LaJ8Ubi7Le5/0
         QdMg0sFpXdNz5M81xn6sViIzBe6gbebNaPIdjz4AHtzNcgqWnt5zCBjXU2vtWLCM7q
         x/80IpaJjt7N3avBdVeM26D0HV/9uFm5MqNkvuxnMdN+mV4WcITJDFtMAZFauvyORK
         i7hvmA0ynRtIA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Allocate VLAN and TC for featured profiles only
Date:   Thu, 28 Jul 2022 13:57:22 -0700
Message-Id: <20220728205728.143074-10-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728205728.143074-1-saeed@kernel.org>
References: <20220728205728.143074-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Introduce allocation and de-allocation functions for both flow steering
VLAN and TC as part of fs API.
Add allocations of VLAN and TC as nic profile feature, such that
fs_init() will allocate both VLAN and TC only if they're featured in
the profile. VLAN and TC are relevant for nic_profile only.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 52 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 3 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b07228f69b91..150a82af2072 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -987,6 +987,8 @@ enum mlx5e_profile_feature {
 	MLX5E_PROFILE_FEATURE_PTP_RX,
 	MLX5E_PROFILE_FEATURE_PTP_TX,
 	MLX5E_PROFILE_FEATURE_QOS_HTB,
+	MLX5E_PROFILE_FEATURE_FS_VLAN,
+	MLX5E_PROFILE_FEATURE_FS_TC,
 };
 
 struct mlx5e_profile {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 86c5533950f1..4d5b1e444cbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1343,27 +1343,57 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_ethtool_cleanup_steering(priv);
 }
 
+static int mlx5e_fs_vlan_alloc(struct mlx5e_flow_steering *fs)
+{
+	fs->vlan = kvzalloc(sizeof(*fs->vlan), GFP_KERNEL);
+	if (!fs->vlan)
+		return -ENOMEM;
+	return 0;
+}
+
+static void mlx5e_fs_vlan_free(struct mlx5e_flow_steering *fs)
+{
+	kvfree(fs->vlan);
+}
+
+static int mlx5e_fs_tc_alloc(struct mlx5e_flow_steering *fs)
+{
+	fs->tc = mlx5e_tc_table_alloc();
+	if (IS_ERR(fs->tc))
+		return -ENOMEM;
+	return 0;
+}
+
+static void mlx5e_fs_tc_free(struct mlx5e_flow_steering *fs)
+{
+	mlx5e_tc_table_free(fs->tc);
+}
+
 int mlx5e_fs_init(struct mlx5e_priv *priv)
 {
-	priv->fs.vlan = kvzalloc(sizeof(*priv->fs.vlan), GFP_KERNEL);
-	if (!priv->fs.vlan)
-		goto err;
+	int err;
 
-	priv->fs.tc = mlx5e_tc_table_alloc();
-	if (IS_ERR(priv->fs.tc))
-		goto err_free_vlan;
+	if (mlx5e_profile_feature_cap(priv->profile, FS_VLAN)) {
+		err = mlx5e_fs_vlan_alloc(&priv->fs);
+		if (err)
+			goto err;
+	}
+
+	if (mlx5e_profile_feature_cap(priv->profile, FS_TC)) {
+		err = mlx5e_fs_tc_alloc(&priv->fs);
+		if (err)
+			goto err_free_vlan;
+	}
 
 	return 0;
 err_free_vlan:
-	kvfree(priv->fs.vlan);
-	priv->fs.vlan = NULL;
+	mlx5e_fs_vlan_free(&priv->fs);
 err:
 	return -ENOMEM;
 }
 
 void mlx5e_fs_cleanup(struct mlx5e_priv *priv)
 {
-	mlx5e_tc_table_free(priv->fs.tc);
-	kvfree(priv->fs.vlan);
-	priv->fs.vlan = NULL;
+	mlx5e_fs_tc_free(&priv->fs);
+	mlx5e_fs_vlan_free(&priv->fs);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 180b2f418339..6305069badf5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5242,7 +5242,9 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 	.stats_grps_num	   = mlx5e_nic_stats_grps_num,
 	.features          = BIT(MLX5E_PROFILE_FEATURE_PTP_RX) |
 		BIT(MLX5E_PROFILE_FEATURE_PTP_TX) |
-		BIT(MLX5E_PROFILE_FEATURE_QOS_HTB),
+		BIT(MLX5E_PROFILE_FEATURE_QOS_HTB) |
+		BIT(MLX5E_PROFILE_FEATURE_FS_VLAN) |
+		BIT(MLX5E_PROFILE_FEATURE_FS_TC),
 };
 
 static int mlx5e_profile_max_num_channels(struct mlx5_core_dev *mdev,
-- 
2.37.1


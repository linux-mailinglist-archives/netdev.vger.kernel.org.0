Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50C059D0D2
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbiHWF4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240409AbiHWFzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D1B5F202
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10649B81B80
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D01C433B5;
        Tue, 23 Aug 2022 05:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234148;
        bh=6NH4D8lmqKgLgcN323d3p1/6TNJesW9SX8s4THLvRv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngNHJuVPaaBoxcw1AY9+F+BRgUNo7j9npA8OeyxjvoLZv6clfcUS5u8+9jgRHnJlt
         5wXLmosqV20tZF78gGG0whoxFeVp1zHqiPo9pbByJ50oUs+hVq66ziDfjVO2bjWDfJ
         wJTvCLQ/SkysgBNQXUKuRpJwl+dxLQRs67fku/8GFo8Kg6l5P/CNdNABowTZZlApJz
         5FUzKsr/VBvjiRjDrgcwZel1+2jFZooxk/cOjCKWUTZMQpS2KGV4wQg1HgVf/7iO3p
         tt5HwK8tbWv45lK9EqfVOJB+AHhaRc3LXQvPenHBQAAgeQ0WPLz7khALFtNsYopRYW
         DtDyxS26fHY1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Convert ethtool_steering member of flow_steering struct to pointer
Date:   Mon, 22 Aug 2022 22:55:23 -0700
Message-Id: <20220823055533.334471-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220823055533.334471-1-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org>
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

From: Lama Kayal <lkayal@nvidia.com>

Convert mlx5e_ethtool_steering member of mlx5e_flow_steering to a
pointer, and allocate dynamically for each profile at flow_steering
init.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 41 +++++++++++++++----
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index a84559b2bd92..eef674cf0f1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -50,7 +50,7 @@ struct mlx5e_flow_steering {
 	struct mlx5_flow_namespace      *ns;
 	struct mlx5_flow_namespace      *egress_ns;
 #ifdef CONFIG_MLX5_EN_RXNFC
-	struct mlx5e_ethtool_steering   ethtool;
+	struct mlx5e_ethtool_steering   *ethtool;
 #endif
 	struct mlx5e_tc_table           *tc;
 	struct mlx5e_promisc_table      promisc;
@@ -1407,6 +1407,31 @@ struct mlx5e_tc_table *mlx5e_fs_get_tc(struct mlx5e_flow_steering *fs)
 	return fs->tc;
 }
 
+#ifdef CONFIG_MLX5_EN_RXNFC
+static int mlx5e_fs_ethtool_alloc(struct mlx5e_flow_steering *fs)
+{
+	fs->ethtool = kvzalloc(sizeof(*fs->ethtool), GFP_KERNEL);
+
+	if (!fs->ethtool)
+		return -ENOMEM;
+	return 0;
+}
+
+static void mlx5e_fs_ethtool_free(struct mlx5e_flow_steering *fs)
+{
+	kvfree(fs->ethtool);
+}
+
+struct mlx5e_ethtool_steering *mlx5e_fs_get_ethtool(struct mlx5e_flow_steering *fs)
+{
+	return fs->ethtool;
+}
+#else
+static int mlx5e_fs_ethtool_alloc(struct mlx5e_flow_steering *fs)
+{ return 0; }
+static void mlx5e_fs_ethtool_free(struct mlx5e_flow_steering *fs) { }
+#endif
+
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
 					  bool state_destroy)
@@ -1432,7 +1457,13 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 			goto err_free_vlan;
 	}
 
+	err = mlx5e_fs_ethtool_alloc(fs);
+	if (err)
+		goto err_free_tc;
+
 	return fs;
+err_free_tc:
+	mlx5e_fs_tc_free(fs);
 err_free_fs:
 	kvfree(fs);
 err_free_vlan:
@@ -1443,6 +1474,7 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 
 void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs)
 {
+	mlx5e_fs_ethtool_free(fs);
 	mlx5e_fs_tc_free(fs);
 	mlx5e_fs_vlan_free(fs);
 	kvfree(fs);
@@ -1466,13 +1498,6 @@ void mlx5e_fs_set_ns(struct mlx5e_flow_steering *fs, struct mlx5_flow_namespace
 		fs->egress_ns = ns;
 }
 
-#ifdef CONFIG_MLX5_EN_RXNFC
-struct mlx5e_ethtool_steering *mlx5e_fs_get_ethtool(struct mlx5e_flow_steering *fs)
-{
-	return &fs->ethtool;
-}
-#endif
-
 struct mlx5_ttc_table *mlx5e_fs_get_ttc(struct mlx5e_flow_steering *fs, bool inner)
 {
 	return inner ? fs->inner_ttc : fs->ttc;
-- 
2.37.1


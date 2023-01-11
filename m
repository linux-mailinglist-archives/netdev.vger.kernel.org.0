Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C200C6653D8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjAKFjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjAKFiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA22210E8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:31:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78759B81A6B
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2110FC433EF;
        Wed, 11 Jan 2023 05:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415064;
        bh=fG56nfDX77g8TLaurEk921n6yS9KIX4trJBVaiprC2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgTJS+YI9xpcswo60Wps/Xq4dZlW/f4MyzLfkMR8LRXAlwCQwyRPL6i+H5EVogx32
         gAkloJnd8nR1ZRCGlqof2BysCU625h1yrU14dppvD2fA20fl+WbAE69mLhkkTGQJ5Z
         D4d84pB5cQcfOyG3m14L+nwRvlLWNyXR2PbhCLUe4elJCHG33Z0nGW0A3xXIiuRyfc
         yPyseyD43Uprw4mVa9n47NcvKQ6J8mfEslHJOli7/YJH5DxTyI3XEXDyjWvnRg/DFC
         wPgOes67ABSYNTn6rKYqHbKUcC8dth8TSVvE4CFOus/YAsRflvHoW+uMbxmZGh7/fJ
         1iualWxz1ZNZw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [net-next 15/15] net/mlx5e: Use kzalloc() in mlx5e_accel_fs_tcp_create()
Date:   Tue, 10 Jan 2023 21:30:45 -0800
Message-Id: <20230111053045.413133-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
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

From: YueHaibing <yuehaibing@huawei.com>

'accel_tcp' is allocted by kvzalloc() now, which is a small chunk.
Use kzalloc() directly instead of kvzalloc().

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index d7c020f72401..88a5aed9d678 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -365,7 +365,7 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
 		accel_fs_tcp_destroy_table(fs, i);
 
-	kvfree(accel_tcp);
+	kfree(accel_tcp);
 	mlx5e_fs_set_accel_tcp(fs, NULL);
 }
 
@@ -377,7 +377,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 	if (!MLX5_CAP_FLOWTABLE_NIC_RX(mlx5e_fs_get_mdev(fs), ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
-	accel_tcp = kvzalloc(sizeof(*accel_tcp), GFP_KERNEL);
+	accel_tcp = kzalloc(sizeof(*accel_tcp), GFP_KERNEL);
 	if (!accel_tcp)
 		return -ENOMEM;
 	mlx5e_fs_set_accel_tcp(fs, accel_tcp);
@@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 err_destroy_tables:
 	while (--i >= 0)
 		accel_fs_tcp_destroy_table(fs, i);
-	kvfree(accel_tcp);
+	kfree(accel_tcp);
 	mlx5e_fs_set_accel_tcp(fs, NULL);
 	return err;
 }
-- 
2.39.0


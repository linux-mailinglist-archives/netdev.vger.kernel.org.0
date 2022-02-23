Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EED4C200B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245032AbiBWXk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244867AbiBWXkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BDF5A0B9;
        Wed, 23 Feb 2022 15:39:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DAD6B82269;
        Wed, 23 Feb 2022 23:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3DDC340F0;
        Wed, 23 Feb 2022 23:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659581;
        bh=m6XO6tyCsQl/0mkgQVShucIMftO83qs12ofEEKGhrpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIQF5MUf6mLCEu75ERY14o3avyuvAGJckQQ1w1SOyzhc7hnRuZQiCxzQDWGOsvwUH
         Nmaw1QlP2JLVBggPIz8Gxov9YLJCzYrYx6PP6UOO+UTOFDUVhHXx+T1D8Ej0gd4DWJ
         HiAV+8S++oi3WsgcpVf4ouObG0yUjvvaTMEzs5MiATPYnIrlDpirQD/71djRjTKawk
         0jVPcBcqztuLZ9BoXoF06l/Zxxax+WCrkbUX4ofwUJSuKRaKWuov2pUh9ofWZXIddR
         XW2c338qxUQLEuSjSKNpXWn2u2lDQJJIodAbPQTjUXUgY2vmPLbhoXWOXa+TWz0XQB
         ziGixPyHhr9Jg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 06/17] net/mlx5: Lag, use local variable already defined to access E-Switch
Date:   Wed, 23 Feb 2022 15:39:19 -0800
Message-Id: <20220223233930.319301-7-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
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

From: Mark Bloch <mbloch@nvidia.com>

Use the local variable for dev0 (and add from dev1) instead of using
the devices stored in the ldev structure. Makes the code easier
to read.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4ddf6b330a44..0758a98a08d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -347,6 +347,7 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	bool roce_lag = __mlx5_lag_is_roce(ldev);
 	u8 flags = ldev->flags;
@@ -356,8 +357,8 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	mlx5_lag_mp_reset(ldev);
 
 	if (ldev->shared_fdb) {
-		mlx5_eswitch_offloads_destroy_single_fdb(ldev->pf[MLX5_LAG_P1].dev->priv.eswitch,
-							 ldev->pf[MLX5_LAG_P2].dev->priv.eswitch);
+		mlx5_eswitch_offloads_destroy_single_fdb(dev0->priv.eswitch,
+							 dev1->priv.eswitch);
 		ldev->shared_fdb = false;
 	}
 
-- 
2.35.1


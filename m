Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BB668A950
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbjBDKJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDKJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803E1196A4
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B63160BE9
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688A9C433EF;
        Sat,  4 Feb 2023 10:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505357;
        bh=w4G8ryB4bFZvfYssEShNgNL4CX5YQnPGrrDfwO5UIG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9Zam9if/6/ZguriqrFdyU0nB/ZMkIethqZ07Hkk41i/bwJn5GJNSxhGc66ARKKUV
         sMhf+JhwHtnytbpILrzJexaKwVzXD3NjAQrOYJ8SSIq/sk0OptCOl5E7jxO2omv6tg
         ERGy+dMnpuCbUQaDjFk9McHqPpOMn0Tjt9M/Zg7Wcdm8v55xeU1ZJDPhDv5+b0USLH
         HWCXhjSqKncmwd1rgUKki1EfVO1RfIwzDBSr5mdh+/P+e97IzpGgrIpaRF02JAjUT4
         RegDP+HJ+g86EXvmCsT6h8vWTln0nVH9gWC/rOYWOl2dIgFblqZ5MgH6HsPf39+R9n
         FfxJvlEl/r+GA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Lag, Remove redundant bool allocation on the stack
Date:   Sat,  4 Feb 2023 02:08:42 -0800
Message-Id: <20230204100854.388126-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

There is no need to allocate the bool variable and can just return the value.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c    | 8 ++------
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 4 +---
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index d9fcb9ed726f..d85a8dfc153d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -28,13 +28,9 @@ static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
 
 bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev)
 {
-	struct mlx5_lag *ldev;
-	bool res;
-
-	ldev = mlx5_lag_dev(dev);
-	res  = ldev && __mlx5_lag_is_multipath(ldev);
+	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 
-	return res;
+	return ldev && __mlx5_lag_is_multipath(ldev);
 }
 
 /**
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index d2fec7233df9..3799f89ed1a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -115,10 +115,8 @@ int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
 bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
-	bool ret;
 
-	ret = ldev && ldev->mode == MLX5_LAG_MODE_MPESW;
-	return ret;
+	return ldev && ldev->mode == MLX5_LAG_MODE_MPESW;
 }
 
 void mlx5_lag_mpesw_init(struct mlx5_lag *ldev)
-- 
2.39.1


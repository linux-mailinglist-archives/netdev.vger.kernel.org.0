Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05291331246
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCHPde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 10:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230150AbhCHPdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 10:33:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F28D56526A;
        Mon,  8 Mar 2021 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615217604;
        bh=UdgGpH5wigD4IDua1jI0Goj5nN066h+PRHihFx2waQY=;
        h=From:To:Cc:Subject:Date:From;
        b=q7OA0wqvAqQ/DPTVQ5yPBYKh3QOKEgYVJc/zfgupO+rvPAuhdHTnzdGOnmt73HJQ3
         gS2efyZ2zIvJ3j+fpB+2AHpFYtAQbntLL3hOh+h3RhjsuJEtycG5+8YqTOJ4SOVzZZ
         OfMJIOVDHXR38lFFE2hYCizVE53huLTBgO2KEkrkWnbad/CWlcXxifwSXwijz4xI/d
         J3b6Htz08n43ghbK3pmUnnAMwX0g3MoXSEbryI7Ex3BffKRY6Sb0oYKXzpjaxEB1G8
         1CVf/xYxuG8bDYhFcOJhKsEdXho9ka58QwILGAwT+EBRVMUUDmDofr/P0nh+UCy6kt
         ix8JOz166XrxA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Noam Stolero <noams@nvidia.com>, Tal Gilboa <talgi@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] net/mlx5e: allocate 'indirection_rqt' buffer dynamically
Date:   Mon,  8 Mar 2021 16:32:57 +0100
Message-Id: <20210308153318.2486939-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Increasing the size of the indirection_rqt array from 128 to 256 bytes
pushed the stack usage of the mlx5e_hairpin_fill_rqt_rqns() function
over the warning limit when building with clang and CONFIG_KASAN:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:970:1: error: stack frame size of 1180 bytes in function 'mlx5e_tc_add_nic_flow' [-Werror,-Wframe-larger-than=]

Using dynamic allocation here is safe because the caller does the
same, and it reduces the stack usage of the function to just a few
bytes.

Fixes: 1dd55ba2fb70 ("net/mlx5e: Increase indirection RQ table size to 256")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0da69b98f38f..66f98618dc13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -445,12 +445,16 @@ static void mlx5e_hairpin_destroy_transport(struct mlx5e_hairpin *hp)
 	mlx5_core_dealloc_transport_domain(hp->func_mdev, hp->tdn);
 }
 
-static void mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp, void *rqtc)
+static int mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp, void *rqtc)
 {
-	u32 indirection_rqt[MLX5E_INDIR_RQT_SIZE], rqn;
+	u32 *indirection_rqt, rqn;
 	struct mlx5e_priv *priv = hp->func_priv;
 	int i, ix, sz = MLX5E_INDIR_RQT_SIZE;
 
+	indirection_rqt = kzalloc(sz, GFP_KERNEL);
+	if (!indirection_rqt)
+		return -ENOMEM;
+
 	mlx5e_build_default_indir_rqt(indirection_rqt, sz,
 				      hp->num_channels);
 
@@ -462,6 +466,9 @@ static void mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp, void *rqtc)
 		rqn = hp->pair->rqn[ix];
 		MLX5_SET(rqtc, rqtc, rq_num[i], rqn);
 	}
+
+	kfree(indirection_rqt);
+	return 0;
 }
 
 static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
@@ -482,12 +489,15 @@ static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
 	MLX5_SET(rqtc, rqtc, rqt_actual_size, sz);
 	MLX5_SET(rqtc, rqtc, rqt_max_size, sz);
 
-	mlx5e_hairpin_fill_rqt_rqns(hp, rqtc);
+	err = mlx5e_hairpin_fill_rqt_rqns(hp, rqtc);
+	if (err)
+		goto out;
 
 	err = mlx5_core_create_rqt(mdev, in, inlen, &hp->indir_rqt.rqtn);
 	if (!err)
 		hp->indir_rqt.enabled = true;
 
+out:
 	kvfree(in);
 	return err;
 }
-- 
2.29.2


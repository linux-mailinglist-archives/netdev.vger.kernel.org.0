Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C138339A0F
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbhCLXj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:32824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235819AbhCLXjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:39:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA4DD64F86;
        Fri, 12 Mar 2021 23:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592340;
        bh=5vbNGNIpW0U1T4cAa0Kz7OG1MGTHxQR75AIrz2bHcng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjzWVzDZItlcnYN43gP+fVUW7stsfLGA+wZGaaB69q5Is9d+PRhPyQwqbmspxJBmR
         yixkeOe/XE1i/o6Ll06witCOqOa5lBtTBm+a4DpACEnX744ntw4fQlmP/4n7DDqibn
         a9nlWyKkB8IH8JwJXxk5vVeMtrqqsdYbfJWV6k8YIwvTEKvg54hiegyBr+h4tZWN6X
         2XeM/jLVgCydxKMYjoyf/N6zRy4ar0rzuOxsCsrsDUrBOKOp0+uq4e6QubsW/I/YlK
         99l8ZObCnw/giDy3a4z2Q8CdJAFsz1pKyE4CaH2iqmsP8erxiRA+1kwYmTEfTcDk0N
         lXPmRheIkwHvA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/13] net/mlx5e: allocate 'indirection_rqt' buffer dynamically
Date:   Fri, 12 Mar 2021 15:38:48 -0800
Message-Id: <20210312233851.494832-11-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index dc126389291d..c72725c3f53b 100644
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


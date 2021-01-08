Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8644F2EED09
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbhAHFbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:31:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbhAHFbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:31:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F99D23447;
        Fri,  8 Jan 2021 05:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083858;
        bh=F49kLDrCed6uyBjZ0IqYXQ53NkEM/zkekFsLsal6OB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tt57tPWoExRpz9XTHcBRxl+cHcjiJETWmeA096lrLNNxJ7jQXevKBSeSFtBD75Izw
         nfE4292Pkzp7kdDg/RbbY8E8VGAAakRh7/NtOgTD5tGJUraO29WbUQn+qe8yHzbg9s
         QVORrOdm360d+YU7weN8dmkoRBqEu6Kx7EzKR/se0FIpvaQfzyrg1UjY/6M2HqRXD9
         ITwh5VQqRkfs4zIyXD7286JZ/zp6Ln4HYqt2lneR1hVZeDwu3eo6OKFfUsdCMAgK3H
         6wDhdODK+Hc5aGVsw4X7e4OWmnvHfdOevZub4FVTrPipz0afZ34nEzK4BYonQEkeqJ
         88W1z5BjZztQA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: E-Switch, Offload all chain 0 priorities when modify header and forward action is not supported
Date:   Thu,  7 Jan 2021 21:30:43 -0800
Message-Id: <20210108053054.660499-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

Miss path handling of tc multi chain filters (i.e. filters that are
defined on chain > 0) requires the hardware to communicate to the
driver the last chain that was processed. This is possible only when
the hardware is capable of performing the combination of modify header
and forward to table actions. Currently, if the hardware is missing
this capability then the driver only offloads rules that are defined
on tc chain 0 prio 1. However, this restriction can be relaxed because
packets that miss from chain 0 are processed through all the
priorities by tc software.

Allow the offload of all the supported priorities for chain 0 even
when the hardware is not capable to perform modify header and goto
table actions.

Fixes: 0b3a8b6b5340 ("net/mlx5: E-Switch: Fix using fwd and modify when firmware doesn't support it")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c         | 6 ------
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 3 ---
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4cdf834fa74a..56aa39ac1a1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1317,12 +1317,6 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	int err = 0;
 	int out_index;
 
-	if (!mlx5_chains_prios_supported(esw_chains(esw)) && attr->prio != 1) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "E-switch priorities unsupported, upgrade FW");
-		return -EOPNOTSUPP;
-	}
-
 	/* We check chain range only for tc flows.
 	 * For ft flows, we checked attr->chain was originally 0 and set it to
 	 * FDB_FT_CHAIN which is outside tc range.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 947f346bdc2d..fa61d305990c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -141,9 +141,6 @@ u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains)
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
-	if (!mlx5_chains_prios_supported(chains))
-		return 1;
-
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 
-- 
2.26.2


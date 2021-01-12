Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE59F2F28BF
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391907AbhALHO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391883AbhALHO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:14:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD7A22D03;
        Tue, 12 Jan 2021 07:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435625;
        bh=F49kLDrCed6uyBjZ0IqYXQ53NkEM/zkekFsLsal6OB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzegXhfgkmpujb6RCLIHISYV3Pi9Zzv7cbYwitIWw56sODAPnnSWojk86pMvjuTF0
         GbdeD3WVISzJ3XPDqrOUbXIYBkJT7N2pZuXD/Etmf4NljMAuFPhhxx3KAQlN/gEzzs
         oWJWo4HnFTM9I5T2Ca0nrWnZzAdev65rNcgMIYWUV4CEIiiLH3wTTRww2P9yLvbhaP
         MN8nY91B5LCA2PXetY0Hi55CfVa8T27gG0VslDVPKEJOYIrVP+NbZp6dtxXL4yWOwr
         o5W2RvRYnH8/qq4gFSQ1KAAqVM09tBKrq1FnqnDqjpWiqei4HCoCvjAY7w7g6KbdRM
         Edd2NwjZI8uCQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 04/11] net/mlx5e: E-Switch, Offload all chain 0 priorities when modify header and forward action is not supported
Date:   Mon, 11 Jan 2021 23:05:27 -0800
Message-Id: <20210112070534.136841-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
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


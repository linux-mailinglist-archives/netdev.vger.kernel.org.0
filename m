Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6668A486ECB
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344180AbiAGAaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59142 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343753AbiAGAaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51CF861E70
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F14DC36AEF;
        Fri,  7 Jan 2022 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515410;
        bh=D4/ttu4F58nAXwBOlwUce9MQ9z4OM3GySTvl8zbd9pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqkadLIGlI1Tl8EbPGtq1RlxRRxD73NOQBjpmk2NytGrPMappGufMjhdGh2O+ib6c
         aHlnRAcmrrTnZyhlFJxnzcOePxAPpcAUKIfvN4mDI580F7K9NEAybNxt17OUkX7fdl
         Qu8GGPf6H2OPkcy7ouhk47mNpCqyrS/yJTLTEc81vqzTjpqJBXro+UqE+A50LkdrF/
         UCM5zlVT0uPCJJdOY3ScoqwjBCN2AJBsAiOpc1pA6FkfvbXVffpkOgOWcJVyfAqySl
         zcRkK3fTJCm64wNwqFOffYMAwAkiEEjRVUbgh+sA6EKiyeA2VcC1N96rSz1h0f4mfM
         5dCwMl//RJoKQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Wang Qing <wangqing@vivo.com>
Subject: [PATCH net-next 01/15] net/mlx5: mlx5e_hv_vhca_stats_create return type to void
Date:   Thu,  6 Jan 2022 16:29:42 -0800
Message-Id: <20220107002956.74849-2-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Callers of this functions ignore its return value, as reported by
Wang Qing, in one of the return paths, it returns positive values.

Since return value is ignored anyways, void out the return type of the
function.

Reported-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c  |  8 +++-----
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h  | 13 +++----------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index 074ffa4fa5af..b4f3bd7d346e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -120,14 +120,14 @@ static void mlx5e_hv_vhca_stats_cleanup(struct mlx5_hv_vhca_agent *agent)
 	cancel_delayed_work_sync(&priv->stats_agent.work);
 }
 
-int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
+void mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
 {
 	int buf_len = mlx5e_hv_vhca_stats_buf_size(priv);
 	struct mlx5_hv_vhca_agent *agent;
 
 	priv->stats_agent.buf = kvzalloc(buf_len, GFP_KERNEL);
 	if (!priv->stats_agent.buf)
-		return -ENOMEM;
+		return;
 
 	agent = mlx5_hv_vhca_agent_create(priv->mdev->hv_vhca,
 					  MLX5_HV_VHCA_AGENT_STATS,
@@ -142,13 +142,11 @@ int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
 				    PTR_ERR(agent));
 
 		kvfree(priv->stats_agent.buf);
-		return IS_ERR_OR_NULL(agent);
+		return;
 	}
 
 	priv->stats_agent.agent = agent;
 	INIT_DELAYED_WORK(&priv->stats_agent.work, mlx5e_hv_vhca_stats_work);
-
-	return 0;
 }
 
 void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h
index 664463faf77b..29c8c6d3260f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h
@@ -7,19 +7,12 @@
 
 #if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
 
-int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv);
+void mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv);
 void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *priv);
 
 #else
-
-static inline int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
-{
-	return 0;
-}
-
-static inline void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *priv)
-{
-}
+static inline void mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv) {}
+static inline void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *priv) {}
 #endif
 
 #endif /* __MLX5_EN_STATS_VHCA_H__ */
-- 
2.33.1


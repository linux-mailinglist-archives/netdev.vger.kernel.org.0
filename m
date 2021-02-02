Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029C830B865
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhBBHIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhBBHHy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 02:07:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15B1264EE6;
        Tue,  2 Feb 2021 07:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612249633;
        bh=VtjsyGeWH7k1gH7aSe59CuNAwUz00/GcQsmlRLS7eh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umGgLXyhnpJWC6IvVfoav6DzPA+l9R92O7U0WaNgUTM9fcXRvmAl2GTMi58n/64AG
         SbexRhlQvTH6LdETwC7YmOX1x/+5Ajxt7D7o6yqVEpvWYiX9w5ItF49P0ccQlqZsyT
         HkI5Hk58u4Yl1EmiiMz0daSfrluYGu/5YGFYZ+HUkxcPZvL/F+V1+hOHsd3b5K8Kyj
         v55HgdNP3FDzsfeXk+mVZXE/pZO+deDYHrwoIsd9LdY136FzlpZGke0/pnOUYzxz6W
         zAqT5PGHRFdOqbJ8LSRgYXQYfpq1iIRaVNp5wRGA7/7KMNbTKC+rP2R2i/p9Qgmr3h
         7b4aZfvYahmoA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/4] net/mlx5e: Update max_opened_tc also when channels are closed
Date:   Mon,  1 Feb 2021 23:07:02 -0800
Message-Id: <20210202070703.617251-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202070703.617251-1-saeed@kernel.org>
References: <20210202070703.617251-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

max_opened_tc is used for stats, so that potentially non-zero stats
won't disappear when num_tc decreases. However, mlx5e_setup_tc_mqprio
fails to update it in the flow where channels are closed.

This commit fixes it. The new value of priv->channels.params.num_tc is
always checked on exit. In case of errors it will just be the old value,
and in case of success it will be the updated value.

Fixes: 05909babce53 ("net/mlx5e: Avoid reset netdev stats on configuration changes")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a9d824a9cb05..3fc7d18ac868 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3627,12 +3627,10 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 
 	err = mlx5e_safe_switch_channels(priv, &new_channels,
 					 mlx5e_num_channels_changed_ctx, NULL);
-	if (err)
-		goto out;
 
-	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
-				    new_channels.params.num_tc);
 out:
+	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
+				    priv->channels.params.num_tc);
 	mutex_unlock(&priv->state_lock);
 	return err;
 }
-- 
2.29.2


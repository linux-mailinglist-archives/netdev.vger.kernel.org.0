Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC09356240
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhDGEGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhDGEGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:06:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F17F8613BD;
        Wed,  7 Apr 2021 04:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617768401;
        bh=8OtrnYvibHCbkYxyO53xoiq9KibnqIAJho0Jf35eHnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIMUjWkBEHtGdLer+6tc3m/6pJtakhufz2vioXh6P6r8JnJn9xkfukseYxK7AAWxl
         8mg+BxOGl1Dl28EZ3pU/H4Pa0Bad5nPRxYrBDwLMWgagZ0RvOX0gY3pV6BQ6h2k+Nj
         Lc8qCr44FY1OWrPaSY/Nvc7uBRdxfCqCqwC0vKGI0bOZalFcW5AE53sYxJwpPrt+WI
         1ipdhhBKCOU1952YShexmmFoNfPpKJCkcsLFaPRzeKkc2yzIRAK8lTZI1fBcxrmRdB
         pbMFyQUHz/KBdaee48HhrafpvTw438YjAcOoJ/LQfjW3DfdLfzLGxNKIk1wIzuwxFh
         pCN2mGv2FfKdQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/5] net/mlx5: Fix HW spec violation configuring uplink
Date:   Tue,  6 Apr 2021 21:06:16 -0700
Message-Id: <20210407040620.96841-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407040620.96841-1-saeed@kernel.org>
References: <20210407040620.96841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Make sure to modify uplink port to follow only if the uplink_follow
capability is set as required by the HW spec. Failure to do so causes
traffic to the uplink representor net device to cease after switching to
switchdev mode.

Fixes: 7d0314b11cdd ("net/mlx5e: Modify uplink state on interface up/down")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a132fff7a980..8d39bfee84a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1107,8 +1107,9 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 
 	mlx5e_rep_tc_enable(priv);
 
-	mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
-				      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
+	if (MLX5_CAP_GEN(mdev, uplink_follow))
+		mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
+					      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
 	mlx5_lag_add(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
 	mlx5_notifier_register(mdev, &priv->events_nb);
-- 
2.30.2


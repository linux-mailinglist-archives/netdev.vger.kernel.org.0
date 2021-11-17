Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE1F453F8D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhKQEhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233103AbhKQEhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CB7661BE2;
        Wed, 17 Nov 2021 04:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123649;
        bh=UC3JFjTqCdAL69z/iGsEJgpz+jx33KnBfQMWLIUn+sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJrkZ3KFAo4UArK+/RLWvzzLtNDVv6bE6dAlLLeLqxsxRJ+xddoeMEvMkRGwQnHyr
         GqYRyUs1X4TX75NPIDz1aG3MRBn0L1p6a9hvJ2m7C7lSDQNJbc8wtPUmVjWmu9hry2
         Na6k1SStoq19C83F/ew9PjiaaTWqtnxk9N1PMRN4dB2h3rl8IiOCkmYoDP7Sxdw+vO
         0NNfrth2wKRZEqo2uPxiB+5ECBCqRTYteVQMkUwW2I6Q8aOfLCsxImqHmG2b7xSWEJ
         B/t5dGh3iUyLGzoD3qYX2gCyA+qervaHND6IGeruryVc+nW8tyKFGE28Rl5Fy9BCLo
         VThH4Q47QFRDw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 07/15] net/mlx5e: TC, Destroy nic flow counter if exists
Date:   Tue, 16 Nov 2021 20:33:49 -0800
Message-Id: <20211117043357.345072-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Counter is only added if counter flag exists.
So check the counter fag exists for deleting the counter.
This is the same as in add/del fdb flow.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e620100eabe0..3e542b030fc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1133,7 +1133,8 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
 
-	mlx5_fc_destroy(priv->mdev, attr->counter);
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
+		mlx5_fc_destroy(priv->mdev, attr->counter);
 
 	if (flow_flag_test(flow, HAIRPIN))
 		mlx5e_hairpin_flow_del(priv, flow);
-- 
2.31.1


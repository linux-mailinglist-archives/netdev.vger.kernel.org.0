Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B2E443232
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 17:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhKBQCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 12:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232033AbhKBQCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 12:02:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E0C6112F;
        Tue,  2 Nov 2021 15:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635868798;
        bh=3ZS5mCVCdcd/UUx8m1rfRgUDrgS+eOrFiaND2hEsvUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBFbi9+4Luk2PYoC1/bEoNs4eZzJZ6a9h6UhsmQ/ddHfelrX3Scd79yDOeK540NxZ
         BcRG0YM7yYc+0zUXxNLOjaJR55ryu5pluHWSX+kACN2bo9ZKbnPyCIIV03PTlvFwyl
         e2b40WXaHtnxmCsHTwGE6IkWQRUhtpHD8Mv6l7OujWS0r9bn3VtUeQqtjrIajzf2ta
         PwsKQbgAOkk6B5mFlGZhY7uZWGPMZdFYSxZC+BsgNJRxKEeUvhVjG+V/jzpkoZjkBt
         nNSXcAkDqkwJye1FW86DCw+VuRqKWgFrT+6KD1lZd6MLVNOJpwVLEf3i+XHVxD2nTe
         X1M3HN7LNo4Og==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 3/7] net/mlx5e: TC, Destroy nic flow counter if exists
Date:   Tue,  2 Nov 2021 08:59:44 -0700
Message-Id: <20211102155948.1143487-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102155948.1143487-1-saeed@kernel.org>
References: <20211102155948.1143487-1-saeed@kernel.org>
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
index 835caa1c7b74..50424998b5c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1137,7 +1137,8 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
 
-	mlx5_fc_destroy(priv->mdev, attr->counter);
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
+		mlx5_fc_destroy(priv->mdev, attr->counter);
 
 	if (flow_flag_test(flow, HAIRPIN))
 		mlx5e_hairpin_flow_del(priv, flow);
-- 
2.31.1


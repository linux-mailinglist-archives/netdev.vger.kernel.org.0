Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B924424BE
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 01:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhKBAbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 20:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhKBAbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 20:31:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 177F660FD9;
        Tue,  2 Nov 2021 00:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635812958;
        bh=3ZS5mCVCdcd/UUx8m1rfRgUDrgS+eOrFiaND2hEsvUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlvHIM8f/VTbVYWKVOV8puqJx/rmULZhCGrIkn274HUaP8FotsPzjaIwgMByUXQS8
         00kKrQnaQWsAJLdS6gAX6YnCrc3TRZ+mTVig48Pl7njt68f7STo6ihruPzKjc2E655
         0YvutA64mtrCS0Ws+ITs0+i7iTlTlJp0o/PB3rcHHQL112FJXIwjXcMNEDwFXGMOe6
         MMPcYWZyoiqRSrgdmjyGd3eXrOT29lwScdn4SSyW8VTvAaD3CFBe8Zu3AQYDJ6P26V
         fBweOhSEAbyfkXgLc+u5rJZo1ncDISIYxui2x0Rj8f15M7ici1L6ywFTw/2ZBUzSed
         gyvxfm6TXRSKQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 3/7] net/mlx5e: TC, Destroy nic flow counter if exists
Date:   Mon,  1 Nov 2021 17:29:10 -0700
Message-Id: <20211102002914.1052888-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102002914.1052888-1-saeed@kernel.org>
References: <20211102002914.1052888-1-saeed@kernel.org>
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


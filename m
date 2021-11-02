Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29AD4424BF
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 01:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhKBAbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 20:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhKBAbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 20:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 891A261077;
        Tue,  2 Nov 2021 00:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635812958;
        bh=bnlR8aUsJrv3XxCt8B1mF2JlTDKlIZoMgdzGDPZjI28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ci7PD/dvmckq3utAiuFM2avgBrn/l+sfxEwR7mWc1V1JzKC0esUvNpZcKIp1WrjCI
         JrAiUD0n2bV/EBu7JrLQOvNO1T7zUgR7j3mdIKQCGRBKMUm6Hwkq7x4uCJ24HpTfaw
         UJR6janX8XnbSiETJczVdUFDvVbbF6Pv6k/uK8haFFkRJGDAmDycAIhuC0XKRbPrQ+
         Y4tmstGy1C12W+QjEsEDab+OLsaVcjjvE0B+RYH9iEfvQFGf3gdnxMrcXIgblr2+JB
         ZMiwpiaZm+dw2qL3GxK+C/00vfiFZ7HKVDfv/Kye5GNJIXH1vXi+meuL5gGhXemG4t
         CYVP+PsWrW41Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 4/7] net/mlx5e: TC, Move kfree() calls after destroying all resources
Date:   Mon,  1 Nov 2021 17:29:11 -0700
Message-Id: <20211102002914.1052888-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102002914.1052888-1-saeed@kernel.org>
References: <20211102002914.1052888-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

When deleting fdb/nic flow rules first release all resources
and then call the kfree() calls instead of sparse them around
the function.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 50424998b5c8..5122e5b6200d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1132,8 +1132,6 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	}
 	mutex_unlock(&priv->fs.tc.t_lock);
 
-	kvfree(attr->parse_attr);
-
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
 
@@ -1143,6 +1141,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	if (flow_flag_test(flow, HAIRPIN))
 		mlx5e_hairpin_flow_del(priv, flow);
 
+	kvfree(attr->parse_attr);
 	kfree(flow->attr);
 }
 
@@ -1630,9 +1629,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		else
 			mlx5e_detach_mod_hdr(priv, flow);
 	}
-	kfree(attr->sample_attr);
-	kvfree(attr->parse_attr);
-	kvfree(attr->esw_attr->rx_tun_attr);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(esw_attr->counter_dev, attr->counter);
@@ -1646,6 +1642,9 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
 
+	kfree(attr->sample_attr);
+	kvfree(attr->esw_attr->rx_tun_attr);
+	kvfree(attr->parse_attr);
 	kfree(flow->attr);
 }
 
-- 
2.31.1


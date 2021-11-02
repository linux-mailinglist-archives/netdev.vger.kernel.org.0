Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A05F443233
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 17:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhKBQCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 12:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231725AbhKBQCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 12:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10DBD61154;
        Tue,  2 Nov 2021 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635868799;
        bh=bnlR8aUsJrv3XxCt8B1mF2JlTDKlIZoMgdzGDPZjI28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b203DPs31LKhYbEFuQxgBdykSns3vA2tEuTd1E4I2DuTujotM+i5t6k4WMPSfyW/n
         0H7+ZIvd8en0m4GGJNeyzSn72LuSeTyZ6ExgC7jFgXdXvx0ZIP0hEOLtVqBnxsNHgg
         6JJbQ2H0Z0vcCcuGhynJYgs8vRiDA8qUyiE5iC8GeKxpSmd4ivQanY0XvwOzp0JSCi
         f2skJXxULbI3rTITIUQmYdgVitTR24GiMmOokhr3gUkO8/hr2SmY1Eu2LzyhKdCsGI
         mlpVCFlbqnDnCaVzxSlBdfARCZ5GdOjVvQmYZRPaDeL96W/lmlRmmzK5mXvesNYH1j
         WTu7Q3oZsti4A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 4/7] net/mlx5e: TC, Move kfree() calls after destroying all resources
Date:   Tue,  2 Nov 2021 08:59:45 -0700
Message-Id: <20211102155948.1143487-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102155948.1143487-1-saeed@kernel.org>
References: <20211102155948.1143487-1-saeed@kernel.org>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F32453F8C
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhKQEhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233037AbhKQEhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAE7561875;
        Wed, 17 Nov 2021 04:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123650;
        bh=mdqhvsW4CQOlR6VXHaUi1T12dLm9N+o8AE/ZyoJRAbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSFayc/rlf2MZOciG5ifQtOJzKZzQACvqpjEOXUH/eF6JpBQ2kEyWay3SZxcdosh1
         Ko6sTwCf/xUd1+RSeY6MyQ4PCIvtJLfQF/UepEt/Dqu1NKQAxApFgP6WziiyA4iSnG
         T2hwiNNdHiV2Ql+ebUv+A5RVXkM4QMPigwGwQijaHLk2Q3Q1xX5cXRFeTzBDZohygW
         CgBIqLzbKfrGzB4LB53bAuZ3qF6N5ikYqrBgkliM/eMkVfaX3ohgdT0jRvgYNHvm1R
         jfb2Kc2LSZhW6//hPuwZSo7FgMZkS3gGldwKgE6IdtFRqPxMJ5qKwpOLJHVrjicS+c
         s5ZcO06YsMF2w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 08/15] net/mlx5e: TC, Move kfree() calls after destroying all resources
Date:   Tue, 16 Nov 2021 20:33:50 -0800
Message-Id: <20211117043357.345072-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
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
index 3e542b030fc1..aa4da8d1e252 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1128,8 +1128,6 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	}
 	mutex_unlock(&priv->fs.tc.t_lock);
 
-	kvfree(attr->parse_attr);
-
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
 
@@ -1139,6 +1137,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	if (flow_flag_test(flow, HAIRPIN))
 		mlx5e_hairpin_flow_del(priv, flow);
 
+	kvfree(attr->parse_attr);
 	kfree(flow->attr);
 }
 
@@ -1626,9 +1625,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		else
 			mlx5e_detach_mod_hdr(priv, flow);
 	}
-	kfree(attr->sample_attr);
-	kvfree(attr->parse_attr);
-	kvfree(attr->esw_attr->rx_tun_attr);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(esw_attr->counter_dev, attr->counter);
@@ -1642,6 +1638,9 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
 
+	kfree(attr->sample_attr);
+	kvfree(attr->esw_attr->rx_tun_attr);
+	kvfree(attr->parse_attr);
 	kfree(flow->attr);
 }
 
-- 
2.31.1


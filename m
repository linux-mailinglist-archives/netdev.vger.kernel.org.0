Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B94453AE2
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhKPU0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhKPU0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B285F61AFD;
        Tue, 16 Nov 2021 20:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094216;
        bh=xxNhZ71oKuwKXZcqyx8ANvl0B08imxAnHlGz+bKNHLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qovmFdbARa44+vubYMUJnfUNmhKELNTyn4HH27Tbbfu75y/b4LSBiVAcbDxCNemRP
         jQ0rtKYi8Rp5GA1zYkPKv4SITUBrwdjH/sOpgMvu9yBmJWRnQ0s7Ngsxv93ycCp2WI
         /VJ5d/7mk9/ISLpFbonGRsbNV+KuYiaOEWpOQAjGIYIMqucvYWiKaUTjvefX7mkatw
         F4aetO7+c5ueRp2mbkCHq9YDvfKHbgSOsLqYeo8pzKQ4tfqm1Zsvwjb9PjJLfHYPDX
         ESUMcAv118JxGLgGtOP0JmBI0WBuseDuH9oCPHF0ZqyQOr5JZO6q9hOmCcVv7jVAmi
         BP/PeHqVOfdgw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/12] net/mlx5e: Wait for concurrent flow deletion during neigh/fib events
Date:   Tue, 16 Nov 2021 12:23:11 -0800
Message-Id: <20211116202321.283874-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Function mlx5e_take_tmp_flow() skips flows with zero reference count. This
can cause syndrome 0x179e84 when the called from neigh or route update code
and the skipped flow is not removed from the hardware by the time
underlying encap/decap resource is deleted. Add new completion
'del_hw_done' that is completed when flow is unoffloaded. This is safe to
do because flow with reference count zero needs to be detached from
encap/decap entry before its memory is deallocated, which requires taking
the encap_tbl_lock mutex that is held by the event handlers code.

Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c           | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 8f64f2c8895a..b689701ac7d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -102,6 +102,7 @@ struct mlx5e_tc_flow {
 	refcount_t refcnt;
 	struct rcu_head rcu_head;
 	struct completion init_done;
+	struct completion del_hw_done;
 	int tunnel_id; /* the mapped tunnel id of this flow */
 	struct mlx5_flow_attr *attr;
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 660cca73c36c..042b1abe1437 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -245,8 +245,14 @@ static void mlx5e_take_tmp_flow(struct mlx5e_tc_flow *flow,
 				struct list_head *flow_list,
 				int index)
 {
-	if (IS_ERR(mlx5e_flow_get(flow)))
+	if (IS_ERR(mlx5e_flow_get(flow))) {
+		/* Flow is being deleted concurrently. Wait for it to be
+		 * unoffloaded from hardware, otherwise deleting encap will
+		 * fail.
+		 */
+		wait_for_completion(&flow->del_hw_done);
 		return;
+	}
 	wait_for_completion(&flow->init_done);
 
 	flow->tmp_entry_index = index;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 835caa1c7b74..cb76c41fe163 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1600,6 +1600,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		else
 			mlx5e_tc_unoffload_fdb_rules(esw, flow, attr);
 	}
+	complete_all(&flow->del_hw_done);
 
 	if (mlx5_flow_has_geneve_opt(flow))
 		mlx5_geneve_tlv_option_del(priv->mdev->geneve);
@@ -4465,6 +4466,7 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	INIT_LIST_HEAD(&flow->l3_to_l2_reformat);
 	refcount_set(&flow->refcnt, 1);
 	init_completion(&flow->init_done);
+	init_completion(&flow->del_hw_done);
 
 	*__flow = flow;
 	*__parse_attr = parse_attr;
-- 
2.31.1


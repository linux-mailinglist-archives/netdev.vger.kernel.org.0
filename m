Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3813A27B137
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgI1Pwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:52:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60527 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgI1Pwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 11:52:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kMvS9-0000Eo-SX; Mon, 28 Sep 2020 15:52:37 +0000
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: fix dereference on pointer flow before null check
Date:   Mon, 28 Sep 2020 16:52:37 +0100
Message-Id: <20200928155237.130739-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently pointer flow is being dereferenced before it is being
null checked. Fix this by adding a null check for flow and parse_attr
earlier.  Also change the err_free path to explicitly return -ENOMEM
and remove the need for the err return variable.

Addresses-Coverity: ("Dereference before null")
Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes structure")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f815b0c60a6c..a2fa2d22d695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4534,20 +4534,20 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr;
 	struct mlx5e_tc_flow *flow;
-	int out_index, err;
+	int out_index;
 
 	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
 	parse_attr = kvzalloc(sizeof(*parse_attr), GFP_KERNEL);
+	if (!parse_attr || !flow)
+		goto err_free;
 
 	flow->flags = flow_flags;
 	flow->cookie = f->cookie;
 	flow->priv = priv;
 
 	attr = mlx5_alloc_flow_attr(get_flow_name_space(flow));
-	if (!parse_attr || !flow || !attr) {
-		err = -ENOMEM;
-		goto err_free;
-	}
+	if (!attr)
+		goto err_free_flow;
 	flow->attr = attr;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
@@ -4562,11 +4562,12 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 
 	return 0;
 
-err_free:
+err_free_flow:
 	kfree(flow);
+err_free:
 	kvfree(parse_attr);
 	kfree(attr);
-	return err;
+	return -ENOMEM;
 }
 
 static void
-- 
2.27.0


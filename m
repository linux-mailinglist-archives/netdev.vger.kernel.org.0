Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31692B2CF3
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 12:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgKNLtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 06:49:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7239 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgKNLtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 06:49:32 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CYDBw02d8zkhZw;
        Sat, 14 Nov 2020 19:49:12 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Sat, 14 Nov 2020
 19:49:23 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <lariel@mellanox.com>, <roid@mellanox.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net/mlx5: fix error return code in mlx5e_tc_nic_init()
Date:   Sat, 14 Nov 2020 19:52:23 +0800
Message-ID: <20201114115223.39505-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: aedd133d17bc ("net/mlx5e: Support CT offload for tc nic flows")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e3a968e9e2a0..c7ad5db84f78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5227,8 +5227,10 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 
 	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &priv->fs.tc.mod_hdr,
 				 MLX5_FLOW_NAMESPACE_KERNEL);
-	if (IS_ERR(tc->ct))
+	if (IS_ERR(tc->ct)) {
+		err = PTR_ERR(tc->ct);
 		goto err_ct;
+	}
 
 	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
 	err = register_netdevice_notifier_dev_net(priv->netdev,
-- 
2.17.1


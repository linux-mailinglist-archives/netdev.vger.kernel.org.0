Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A24E621509
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbiKHOHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbiKHOHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:07:33 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C1A748C1;
        Tue,  8 Nov 2022 06:07:32 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N69096sZQzRp4C;
        Tue,  8 Nov 2022 22:07:21 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 22:07:29 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <borisp@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lkayal@nvidia.com>, <tariqt@nvidia.com>,
        <markzhang@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2] net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
Date:   Tue, 8 Nov 2022 22:06:14 +0800
Message-ID: <20221108140614.12968-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'accel_tcp' is allocted by kvzalloc(), which should freed by kvfree().

Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: fix the same issue in mlx5e_accel_fs_tcp_destroy() and a commit log typo
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 285d32d2fd08..d7c020f72401 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -365,7 +365,7 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
 		accel_fs_tcp_destroy_table(fs, i);
 
-	kfree(accel_tcp);
+	kvfree(accel_tcp);
 	mlx5e_fs_set_accel_tcp(fs, NULL);
 }
 
@@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 err_destroy_tables:
 	while (--i >= 0)
 		accel_fs_tcp_destroy_table(fs, i);
-	kfree(accel_tcp);
+	kvfree(accel_tcp);
 	mlx5e_fs_set_accel_tcp(fs, NULL);
 	return err;
 }
-- 
2.17.1


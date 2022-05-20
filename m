Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CAC52E655
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346512AbiETHgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238923AbiETHgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:36:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0601338A3;
        Fri, 20 May 2022 00:36:09 -0700 (PDT)
Received: from kwepemi100015.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L4JNl5R78zQkB3;
        Fri, 20 May 2022 15:33:11 +0800 (CST)
Received: from kwepemm600012.china.huawei.com (7.193.23.74) by
 kwepemi100015.china.huawei.com (7.221.188.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 20 May 2022 15:36:07 +0800
Received: from ubuntu1804.huawei.com (10.67.175.29) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 20 May 2022 15:36:01 +0800
From:   Guan Jing <guanjing6@huawei.com>
To:     <davem@davemloft.net>
CC:     <saeedm@nvidia.com>, <leon@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guan Jing <guanjing6@huawei.com>
Subject: [PATCH -next] net/mlx5: Fix build error of multiple definition
Date:   Fri, 20 May 2022 15:34:23 +0800
Message-ID: <20220520073423.35556-1-guanjing6@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.29]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600012.china.huawei.com (7.193.23.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some errors like:

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.o:
In function `mlx5_lag_mpesw_init':
lag.c:(.text+0xb70): multiple definition of `mlx5_lag_mpesw_init'
drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.o:debugfs.c:(.text+0x440):
first defined here
drivers/net/ethernet/mellanox/mlx5/core/lag/lag.o: In function `mlx5_lag_mpesw_cleanup':
lag.c:(.text+0xb80): multiple definition of `mlx5_lag_mpesw_cleanup'
drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.o:debugfs.c:(.text+0x450):
first defined here

So, add 'static inline' on the defineation of these functions.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
Signed-off-by: Guan Jing <guanjing6@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index d39a02280e29..be4abcb8fcd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -19,8 +19,8 @@ bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev);
 void mlx5_lag_mpesw_init(struct mlx5_lag *ldev);
 void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev);
 #else
-void mlx5_lag_mpesw_init(struct mlx5_lag *ldev) {}
-void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev) {}
+static inline void mlx5_lag_mpesw_init(struct mlx5_lag *ldev) {}
+static inline void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev) {}
 #endif
 
 #endif /* __MLX5_LAG_MPESW_H__ */
-- 
2.17.1


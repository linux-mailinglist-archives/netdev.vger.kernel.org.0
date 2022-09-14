Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC63B5B8987
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 15:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiINNxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 09:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiINNxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 09:53:49 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4378D63F36;
        Wed, 14 Sep 2022 06:53:48 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MSMFW4tP9zHnr0;
        Wed, 14 Sep 2022 21:51:43 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 14 Sep 2022 21:53:45 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 14 Sep
 2022 21:53:45 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
CC:     <saeedm@nvidia.com>, <liorna@nvidia.com>, <raeds@nvidia.com>,
        <davem@davemloft.net>
Subject: [PATCH -next v2 1/2] net/mlx5e: add missing error code in error path
Date:   Wed, 14 Sep 2022 22:00:59 +0800
Message-ID: <20220914140100.3795545-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing error code when mlx5e_macsec_fs_add_rule() or
mlx5e_macsec_fs_init() fails. mlx5e_macsec_fs_init() don't
return ERR_PTR(), so replace IS_ERR_OR_NULL() check with
NULL pointer check.

Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  Replace IS_ERR_OR_NULL() check with NULL pointer check.
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index d9d18b039d8c..100e03eb740b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -194,8 +194,10 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 				      MLX5_ACCEL_MACSEC_ACTION_DECRYPT;
 
 	macsec_rule = mlx5e_macsec_fs_add_rule(macsec->macsec_fs, ctx, &rule_attrs, &sa->fs_id);
-	if (IS_ERR_OR_NULL(macsec_rule))
+	if (!macsec_rule) {
+		err = -ENOMEM;
 		goto destroy_macsec_object;
+	}
 
 	sa->macsec_rule = macsec_rule;
 
@@ -1294,8 +1296,10 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 	macsec->mdev = mdev;
 
 	macsec_fs = mlx5e_macsec_fs_init(mdev, priv->netdev);
-	if (IS_ERR_OR_NULL(macsec_fs))
+	if (!macsec_fs) {
+		err = -ENOMEM;
 		goto err_out;
+	}
 
 	macsec->macsec_fs = macsec_fs;
 
-- 
2.25.1


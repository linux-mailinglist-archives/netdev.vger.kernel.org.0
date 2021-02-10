Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D651316023
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhBJHiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:38:24 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12890 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbhBJHiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:38:21 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DbBQS00GXz7jRK;
        Wed, 10 Feb 2021 15:36:15 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:37:32 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "Leon Romanovsky" <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
Subject: [PATCH net-next] net/mlx5e: Fix error return code in mlx5e_tc_esw_init()
Date:   Wed, 10 Feb 2021 07:46:05 +0000
Message-ID: <20210210074605.867456-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return negative error code from the mlx5e_tc_tun_init() error
handling case instead of 0, as done elsewhere in this function.

This commit also using 0 instead of 'ret' when success since it is
always equal to 0.

Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index db142ee96510..9f126054d371 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4750,10 +4750,12 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	lockdep_set_class(&tc_ht->mutex, &tc_ht_lock_key);
 
 	uplink_priv->encap = mlx5e_tc_tun_init(priv);
-	if (IS_ERR(uplink_priv->encap))
+	if (IS_ERR(uplink_priv->encap)) {
+		err = PTR_ERR(uplink_priv->encap);
 		goto err_register_fib_notifier;
+	}
 
-	return err;
+	return 0;
 
 err_register_fib_notifier:
 	rhashtable_destroy(tc_ht);


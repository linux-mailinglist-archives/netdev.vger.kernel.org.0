Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004CC25C09E
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 13:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgICLvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 07:51:22 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50722 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728725AbgICLtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 07:49:43 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E6620A509112187F4BE1;
        Thu,  3 Sep 2020 19:49:36 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Sep 2020 19:49:27 +0800
From:   Wei Xu <xuwei5@hisilicon.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <xuwei5@hisilicon.com>, <linuxarm@huawei.com>,
        <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>, <john.garry@huawei.com>,
        <salil.mehta@huawei.com>, <shiju.jose@huawei.com>,
        <jinying@hisilicon.com>, <zhangyi.ac@huawei.com>,
        <liguozhu@hisilicon.com>, <tangkunshan@huawei.com>,
        <huangdaode@hisilicon.com>, Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/mlx5e: kTLS, Fix GFP_KERNEL in spinlock context
Date:   Thu, 3 Sep 2020 19:45:34 +0800
Message-ID: <1599133539-175203-1-git-send-email-xuwei5@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace GFP_KERNEL with GFP_ATOMIC while resync_post_get_progress_params
is invoked in a spinlock context.
This code was detected with the help of Coccinelle.

Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index acf6d80..1a32435 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -247,7 +247,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	int err;
 	u16 pi;
 
-	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_ATOMIC);
 	if (unlikely(!buf)) {
 		err = -ENOMEM;
 		goto err_out;
-- 
2.8.1


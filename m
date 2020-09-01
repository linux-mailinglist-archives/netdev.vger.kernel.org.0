Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05212590A0
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgIAOgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:36:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37240 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728353AbgIAOfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 10:35:52 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B61022C8E98F15BC73EF;
        Tue,  1 Sep 2020 22:35:43 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Sep 2020
 22:35:34 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <borisp@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net/mlx5e: kTLS, Avoid kzalloc(GFP_KERNEL) under spinlock
Date:   Tue, 1 Sep 2020 22:35:12 +0800
Message-ID: <20200901143512.25424-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A spin lock is held before kzalloc, it may sleep with holding
the spinlock, so we should use GFP_ATOMIC instead.

This is detected by coccinelle.

Fixes: 0419d8c9d8f8 ("net/mlx5e: kTLS, Add kTLS RX resync support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index acf6d80a6bb7..1a32435acac3 100644
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
2.17.1



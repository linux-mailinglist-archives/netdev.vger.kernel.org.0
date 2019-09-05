Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D403CA9E92
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387540AbfIEJiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:38:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6223 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730849AbfIEJiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 05:38:19 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 02D9A2954C4594CCC8CF;
        Thu,  5 Sep 2019 17:38:17 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Sep 2019 17:38:07 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        "Erez Shitrit" <erezsh@mellanox.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net/mlx5: DR, Fix error return code in dr_domain_init_resources()
Date:   Thu, 5 Sep 2019 09:56:00 +0000
Message-ID: <20190905095600.127371-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 4ec9e7b02697 ("net/mlx5: DR, Expose steering domain functionality")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 3b9cf0bccf4d..461cc2c30538 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -66,6 +66,7 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 	dmn->uar = mlx5_get_uars_page(dmn->mdev);
 	if (!dmn->uar) {
 		mlx5dr_err(dmn, "Couldn't allocate UAR\n");
+		ret = -ENOMEM;
 		goto clean_pd;
 	}
 
@@ -73,6 +74,7 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 	if (!dmn->ste_icm_pool) {
 		mlx5dr_err(dmn, "Couldn't get icm memory for %s\n",
 			   dev_name(dmn->mdev->device));
+		ret = -ENOMEM;
 		goto clean_uar;
 	}
 
@@ -80,6 +82,7 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 	if (!dmn->action_icm_pool) {
 		mlx5dr_err(dmn, "Couldn't get action icm memory for %s\n",
 			   dev_name(dmn->mdev->device));
+		ret = -ENOMEM;
 		goto free_ste_icm_pool;
 	}




Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74527353AFD
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 04:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhDECyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 22:54:00 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16338 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbhDECx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 22:53:59 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FDFY95Bp6z942p;
        Mon,  5 Apr 2021 10:51:41 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 5 Apr 2021 10:53:42 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <vladbu@nvidia.com>,
        <dlinkin@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <roid@nvidia.com>,
        <dan.carpenter@oracle.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
CC:     <nixiaoming@huawei.com>, <xiaoqian9@huawei.com>
Subject: [PATCH] net/mlx5: fix kfree mismatch in indir_table.c
Date:   Mon, 5 Apr 2021 10:53:39 +0800
Message-ID: <20210405025339.86176-1-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory allocated by kvzalloc() should be freed by kvfree().

Fixes: 34ca65352ddf2 ("net/mlx5: E-Switch, Indirect table infrastructur")
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/indir_table.c  | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index 6f6772bf61a2..3da7becc1069 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -248,7 +248,7 @@ static int mlx5_esw_indir_table_rule_get(struct mlx5_eswitch *esw,
 err_ethertype:
 	kfree(rule);
 out:
-	kfree(rule_spec);
+	kvfree(rule_spec);
 	return err;
 }
 
@@ -328,7 +328,7 @@ static int mlx5_create_indir_recirc_group(struct mlx5_eswitch *esw,
 	e->recirc_cnt = 0;
 
 out:
-	kfree(in);
+	kvfree(in);
 	return err;
 }
 
@@ -347,7 +347,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
-		kfree(in);
+		kvfree(in);
 		return -ENOMEM;
 	}
 
@@ -371,8 +371,8 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 	}
 
 err_out:
-	kfree(spec);
-	kfree(in);
+	kvfree(spec);
+	kvfree(in);
 	return err;
 }
 
-- 
2.27.0


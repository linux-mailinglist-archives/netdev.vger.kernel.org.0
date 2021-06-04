Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7545F39B6C3
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 12:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhFDKKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 06:10:22 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:43394 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229931AbhFDKKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 06:10:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UbFZ5Y6_1622801312;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UbFZ5Y6_1622801312)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Jun 2021 18:08:34 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     saeedm@nvidia.com
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH v2] net/mlx5e: Fix an error code in mlx5e_arfs_create_tables()
Date:   Fri,  4 Jun 2021 18:08:27 +0800
Message-Id: <1622801307-34745-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the code execute 'if (!priv->fs.arfs->wq)', the value of err is 0.
So, we use -ENOMEM to indicate that the function
create_singlethread_workqueue() return NULL.

Clean up smatch warning:
drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c:373
mlx5e_arfs_create_tables() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: f6755b80d693 ("net/mlx5e: Dynamic alloc arfs table for netdev when needed")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---

Changes in v2:
--According to Saeed's suggestion, we modify the format of Fixes tag, 
--and initialize err to -ENOMEM.
https://lore.kernel.org/patchwork/patch/1440018/

 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 5cd466e..25403af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -356,7 +356,7 @@ static int arfs_create_table(struct mlx5e_priv *priv,
 
 int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
 {
-	int err = 0;
+	int err = -ENOMEM;
 	int i;
 
 	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
-- 
1.8.3.1


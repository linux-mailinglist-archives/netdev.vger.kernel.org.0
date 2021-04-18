Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FD93637D8
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhDRV1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:27:04 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:24792 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbhDRV1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:27:03 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d25 with ME
        id uMSY2400B21Fzsu03MSZFK; Sun, 18 Apr 2021 23:26:33 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 Apr 2021 23:26:33 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        bvanassche@acm.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] net/mlx5: Simplify workqueue name creation
Date:   Sun, 18 Apr 2021 23:26:31 +0200
Message-Id: <a32dccb98017715d54853ac2e2aee360851539ce.1618780558.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to explicitly allocate, populate and free some memory
just to pass a workqueue name to 'create_singlethread_workqueue()'.

This macro can do all this for us, so keep the code simple.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
A similar patch has also been sent. It was replacing the kmalloc/strcpy/
strcat with a kasprintf.
Updating 'create_singlethread_workqueue' gives an even more elegant solution.
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 9 +--------
 1 file changed, 2 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 9ff163c5bcde..160f852b7bbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -797,19 +797,13 @@ void mlx5_health_cleanup(struct mlx5_core_dev *dev)
 int mlx5_health_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health;
-	char *name;
 
 	mlx5_fw_reporters_create(dev);
 
 	health = &dev->priv.health;
-	name = kmalloc(64, GFP_KERNEL);
-	if (!name)
-		goto out_err;
 
-	strcpy(name, "mlx5_health");
-	strcat(name, dev_name(dev->device));
-	health->wq = create_singlethread_workqueue(name);
-	kfree(name);
+	health->wq = create_singlethread_workqueue("mlx5_health%s",
+						   dev_name(dev->device));
 	if (!health->wq)
 		goto out_err;
 	spin_lock_init(&health->wq_lock);
-- 
2.27.0


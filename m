Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240CE362E42
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhDQHRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:17:19 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:48397 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhDQHRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 03:17:18 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d34 with ME
        id tjGm2400E21Fzsu03jGmVo; Sat, 17 Apr 2021 09:16:50 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 17 Apr 2021 09:16:50 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/mlx5: Use kasprintf instead of hand-writing it
Date:   Sat, 17 Apr 2021 09:16:44 +0200
Message-Id: <46235ec010551d2788483ce636686a61345e40ba.1618643703.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'kasprintf()' can replace a kmalloc/strcpy/strcat sequence.
It is less verbose and avoid the use of a magic number (64).

Anyway, the underlying 'alloc_workqueue()' would only keep the 24 first
chars (i.e. sizeof(struct workqueue_struct->name) = WQ_NAME_LEN).

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 9ff163c5bcde..a5383e701b4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -802,12 +802,10 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
 	mlx5_fw_reporters_create(dev);
 
 	health = &dev->priv.health;
-	name = kmalloc(64, GFP_KERNEL);
+	name = kasprintf(GFP_KERNEL, "mlx5_health%s", dev_name(dev->device));
 	if (!name)
 		goto out_err;
 
-	strcpy(name, "mlx5_health");
-	strcat(name, dev_name(dev->device));
 	health->wq = create_singlethread_workqueue(name);
 	kfree(name);
 	if (!health->wq)
-- 
2.27.0


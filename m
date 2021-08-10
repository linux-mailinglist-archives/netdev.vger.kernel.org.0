Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17E13E5BDF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241699AbhHJNip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241647AbhHJNiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:38:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B20C36101E;
        Tue, 10 Aug 2021 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628602674;
        bh=TvoQojqsY59TCrvQ8l2JACkOs5SoYXc6V5jqqVTGCQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDXm4IgUlJoezrUCuAzKv0mLdZjMaHw3eemrJSton4hIxatOqfX/HztjxyHagWG7G
         Vx4yuhqYBegEORxsgnnxjW7fJ8jvLfwdtxNaTg8ayepFGtau3zB7UVfyl1JJymtSHf
         208YurRn9eFewDC1axQRco32NLl1gbc2ply5FHSIkxWoUijmWrEMDgsE2BJ52BM5Rs
         5JcVsRpNkogkQ9umAiflG7n3ZHBfIHGEinH3x//myCUvGMsBNiky3Mxw68HTpw1XrD
         KeBjsYRV0tuHd/b2UTvYDyqmsZX7gXog2GVirYWB8xTgOujg6eOlAoeikySJdJtkHs
         keFvigv/0CFuQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 5/5] netdevsim: Delay user access till probe is finished
Date:   Tue, 10 Aug 2021 16:37:35 +0300
Message-Id: <e7d4e11aaa8c5ddef0c50081bbf2b543117660de.1628599239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628599239.git.leonro@nvidia.com>
References: <cover.1628599239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Don't publish supported user space accessible ops till probe is finished.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 54313bd57797..181258bd72f2 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1470,14 +1470,10 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_devlink_free;
 
-	err = devlink_register(devlink);
-	if (err)
-		goto err_resources_unregister;
-
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
 	if (err)
-		goto err_dl_unregister;
+		goto err_resources_unregister;
 	nsim_devlink_set_params_init_values(nsim_dev, devlink);
 
 	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
@@ -1515,10 +1511,17 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_psample_exit;
 
 	devlink_params_publish(devlink);
-	devlink_reload_enable(devlink);
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
+	err = devlink_register(devlink);
+	if (err)
+		goto err_port_del_all;
+
+	devlink_reload_enable(devlink);
 	return 0;
 
+err_port_del_all:
+	devlink_params_unpublish(devlink);
+	nsim_dev_port_del_all(nsim_dev);
 err_psample_exit:
 	nsim_dev_psample_exit(nsim_dev);
 err_bpf_dev_exit:
@@ -1536,8 +1539,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 err_params_unregister:
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
-err_dl_unregister:
-	devlink_unregister(devlink);
 err_resources_unregister:
 	devlink_resources_unregister(devlink, NULL);
 err_devlink_free:
@@ -1573,6 +1574,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
 	devlink_reload_disable(devlink);
+	devlink_unregister(devlink);
 
 	nsim_dev_reload_destroy(nsim_dev);
 
@@ -1580,7 +1582,6 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev_debugfs_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
-	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
 	devlink_free(devlink);
 }
-- 
2.31.1


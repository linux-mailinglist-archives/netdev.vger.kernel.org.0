Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D764A80F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbfFRRQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRRQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:16:14 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D99120B1F;
        Tue, 18 Jun 2019 17:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878173;
        bh=d7HT3TlglwhBxCwzrxyxDwA+mDpBDl5bClgi0Sz3QHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FB7EB9NkA5552QcFSfBcZMq1RcHsqsBafFHJ4HSyzn5yKRN2VP8PhNZkU88ettrb7
         05JSoLIiUhA7q6pi4TWpIZlThTLWs9oz+3JsNky8s5HkDfNHh4cyX6lJkWEHI7iEyV
         lzbNHSEBL3k6UrI/Zq/swV6Eg3D0O8vJRTypJysA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v1 03/12] net/mlx5: Expose the API to register for ANY event
Date:   Tue, 18 Jun 2019 20:15:31 +0300
Message-Id: <20190618171540.11729-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618171540.11729-1-leon@kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose the API to register for ANY event, mlx5_ib will be able to use
this functionality for its needs.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c     | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h | 3 ---
 include/linux/mlx5/driver.h                      | 2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 9d07add38940..a7a8bf73e465 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -954,6 +954,7 @@ int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 
 	return atomic_notifier_chain_register(&eqt->nh[nb->event_type], &nb->nb);
 }
+EXPORT_SYMBOL(mlx5_eq_notifier_register);
 
 int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 {
@@ -964,3 +965,4 @@ int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 
 	return atomic_notifier_chain_unregister(&eqt->nh[nb->event_type], &nb->nb);
 }
+EXPORT_SYMBOL(mlx5_eq_notifier_unregister);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index d826e63d5a17..3dfab91ae5f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -97,7 +97,4 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
 struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev);
 #endif
 
-int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
-int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
-
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d8ab633406c2..3f8b9d8e2070 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1047,6 +1047,8 @@ int mlx5_register_interface(struct mlx5_interface *intf);
 void mlx5_unregister_interface(struct mlx5_interface *intf);
 int mlx5_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb);
 int mlx5_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb);
+int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
+int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
 
 int mlx5_core_query_vendor_id(struct mlx5_core_dev *mdev, u32 *vendor_id);
 
-- 
2.20.1


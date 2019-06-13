Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5F444586
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733235AbfFMQob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbfFMG0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 02:26:52 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 337A52084D;
        Thu, 13 Jun 2019 06:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560407211;
        bh=U1xoot+76bpcwv0w0rpfM5fUjQxZCDIlL1SwHHJeR0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whRfhWED4cUmHiA72RN0dm+cmemQaifiP+5Ps3NDLXjXw+vePYzkXq7YM4XOBbIeF
         JBYmYqhqg+/48fIVxmHgcgqV9zEtubqAZhk/fQ/0/lSUvtCpwqcus6u/EYVA/+tmdK
         ACjvqPeKjL0PddE/fhFwlsjgMA6uM0T1Ub1eSdI8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 03/12] net/mlx5: Expose the API to register for ANY event
Date:   Thu, 13 Jun 2019 09:26:31 +0300
Message-Id: <20190613062640.28958-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613062640.28958-1-leon@kernel.org>
References: <20190613062640.28958-1-leon@kernel.org>
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
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c     | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h | 3 ---
 include/linux/mlx5/driver.h                      | 2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 696a0fdd075a..5971c1870e0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1064,6 +1064,7 @@ int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 
 	return atomic_notifier_chain_register(&eqt->nh[nb->event_type], &nb->nb);
 }
+EXPORT_SYMBOL(mlx5_eq_notifier_register);
 
 int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 {
@@ -1074,3 +1075,4 @@ int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 
 	return atomic_notifier_chain_unregister(&eqt->nh[nb->event_type], &nb->nb);
 }
+EXPORT_SYMBOL(mlx5_eq_notifier_unregister);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index eb105338467d..018fd72d421b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -92,7 +92,4 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
 struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev);
 #endif
 
-int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
-int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
-
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 5a27246db883..2fa95daefae0 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1042,6 +1042,8 @@ int mlx5_register_interface(struct mlx5_interface *intf);
 void mlx5_unregister_interface(struct mlx5_interface *intf);
 int mlx5_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb);
 int mlx5_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb);
+int mlx5_eq_notifier_register(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
+int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb);
 
 int mlx5_core_query_vendor_id(struct mlx5_core_dev *mdev, u32 *vendor_id);
 
-- 
2.20.1


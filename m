Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6704A819
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbfFRRQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRRQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:16:28 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23C9B214AF;
        Tue, 18 Jun 2019 17:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878187;
        bh=E96qTNfjPoM9DVoJCtbdTCrb6aEGQyKDqRNCBU0DeiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdRptx9KXZYfjt85+gmBHa94Zz+U/IrtGPQRUjFr70xa1TDgSI6146DeM0r+3vIEI
         fsAgtOsVBKp9NO/odTXf0u7wRcgOEYSpwjfPHABHzDrLxpjDe0f6vNlvvPvW6MER+L
         EjsmporasR4N7Sp0HShins33SqwOP9LhCq/vv0fI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v1 09/12] IB/mlx5: Register DEVX with mlx5_core to get async events
Date:   Tue, 18 Jun 2019 20:15:37 +0300
Message-Id: <20190618171540.11729-10-leon@kernel.org>
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

Register DEVX with with mlx5_core to get async events.  This will enable
to dispatch the applicable events to its consumers in down stream
patches.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c    | 30 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c    |  8 ++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 12 +++++++++++
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 1815ce0f8daf..e9b9ba5a3e9a 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1670,6 +1670,36 @@ static int devx_umem_cleanup(struct ib_uobject *uobject,
 	return 0;
 }
 
+static int devx_event_notifier(struct notifier_block *nb,
+			       unsigned long event_type, void *data)
+{
+	return NOTIFY_DONE;
+}
+
+void mlx5_ib_devx_init_event_table(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_devx_event_table *table = &dev->devx_event_table;
+
+	xa_init(&table->event_xa);
+	mutex_init(&table->event_xa_lock);
+	MLX5_NB_INIT(&table->devx_nb, devx_event_notifier, NOTIFY_ANY);
+	mlx5_eq_notifier_register(dev->mdev, &table->devx_nb);
+}
+
+void mlx5_ib_devx_cleanup_event_table(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_devx_event_table *table = &dev->devx_event_table;
+	void *entry;
+	unsigned long id;
+
+	mlx5_eq_notifier_unregister(dev->mdev, &table->devx_nb);
+
+	xa_for_each(&table->event_xa, id, entry)
+		kfree(entry);
+
+	xa_destroy(&table->event_xa);
+}
+
 static ssize_t devx_async_cmd_event_read(struct file *filp, char __user *buf,
 					 size_t count, loff_t *pos)
 {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c9c6710afc6b..67b9e7ac569a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6653,15 +6653,19 @@ static int mlx5_ib_stage_devx_init(struct mlx5_ib_dev *dev)
 	int uid;
 
 	uid = mlx5_ib_devx_create(dev, false);
-	if (uid > 0)
+	if (uid > 0) {
 		dev->devx_whitelist_uid = uid;
+		mlx5_ib_devx_init_event_table(dev);
+	}
 
 	return 0;
 }
 static void mlx5_ib_stage_devx_cleanup(struct mlx5_ib_dev *dev)
 {
-	if (dev->devx_whitelist_uid)
+	if (dev->devx_whitelist_uid) {
+		mlx5_ib_devx_cleanup_event_table(dev);
 		mlx5_ib_devx_destroy(dev, dev->devx_whitelist_uid);
+	}
 }
 
 void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 9cf23ae6324e..556af34b788b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -944,6 +944,13 @@ struct mlx5_ib_pf_eq {
 	mempool_t *pool;
 };
 
+struct mlx5_devx_event_table {
+	struct mlx5_nb devx_nb;
+	/* serialize updating the event_xa */
+	struct mutex event_xa_lock;
+	struct xarray event_xa;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
@@ -994,6 +1001,7 @@ struct mlx5_ib_dev {
 	struct mlx5_srq_table   srq_table;
 	struct mlx5_async_ctx   async_ctx;
 	int			free_port;
+	struct mlx5_devx_event_table devx_event_table;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
@@ -1333,6 +1341,8 @@ void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *dev,
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
 int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user);
 void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid);
+void mlx5_ib_devx_init_event_table(struct mlx5_ib_dev *dev);
+void mlx5_ib_devx_cleanup_event_table(struct mlx5_ib_dev *dev);
 const struct uverbs_object_tree_def *mlx5_ib_get_devx_tree(void);
 extern const struct uapi_definition mlx5_ib_devx_defs[];
 extern const struct uapi_definition mlx5_ib_flow_defs[];
@@ -1349,6 +1359,8 @@ static inline int
 mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
 			   bool is_user) { return -EOPNOTSUPP; }
 static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid) {}
+static inline void mlx5_ib_devx_init_event_table(struct mlx5_ib_dev *dev) {}
+static inline void mlx5_ib_devx_cleanup_event_table(struct mlx5_ib_dev *dev) {}
 static inline bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id,
 					     int *dest_type)
 {
-- 
2.20.1


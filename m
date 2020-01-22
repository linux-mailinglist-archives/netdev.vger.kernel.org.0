Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3DF145737
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgAVNxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:53:24 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41165 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbgAVNxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:53:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Jan 2020 15:53:05 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00MDr4f9013119;
        Wed, 22 Jan 2020 15:53:04 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next-mlx5 v2 02/13] net/mlx5: Add new driver lib for mappings unique ids to data
Date:   Wed, 22 Jan 2020 15:52:47 +0200
Message-Id: <1579701178-24624-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
References: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new interface for mapping data to a given id range (max_id),
and back again. It supports variable sized data, and different
allocators, and read/write locks.

This mapping interface also supports delaying the mapping removal via
a workqueue. This is for cases where we need the mapping to have
some grace period in regards to finding it back again, for example
for packets arriving from hardware that were marked with by a rule
with an old mapping that no longer exists.

We also provide a first implementation of the interface is idr_mapping
that uses idr for the allocator and a mutex lock for writes
(add/del, but not for find).

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/mapping.c  | 362 +++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lib/mapping.h  |  31 ++
 3 files changed, 394 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/mapping.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/mapping.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index d3e06ce..e84d6d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -34,7 +34,7 @@ mlx5_core-$(CONFIG_MLX5_EN_ARFS)     += en_arfs.o
 mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o en_tc.o en/tc_tun.o lib/port_tun.o lag_mp.o \
-					lib/geneve.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
+					lib/geneve.o lib/mapping.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
 					en/tc_tun_geneve.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mapping.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/mapping.c
new file mode 100644
index 0000000..1c25223
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mapping.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2018 Mellanox Technologies */
+
+#include <linux/jhash.h>
+#include <linux/slab.h>
+#include <linux/idr.h>
+#include <linux/hashtable.h>
+
+#include "mapping.h"
+
+#define MAPPING_GRACE_PERIOD 2000
+
+struct mapping_item {
+	struct hlist_node node;
+	int cnt;
+	u32 id;
+
+	char data[0]; /* Must be last for correct allocation */
+};
+
+struct mapping_ctx_ops {
+	struct mapping_item * (*alloc_item)(struct mapping_ctx *ctx);
+	void (*free_item)(struct mapping_ctx *ctx, struct mapping_item *mi);
+
+	int (*assign_id)(struct mapping_ctx *ctx, struct mapping_item *mi);
+	struct mapping_item * (*find_id)(struct mapping_ctx *ctx, u32 id);
+
+	void (*lock)(struct mapping_ctx *ctx, bool write);
+	void (*unlock)(struct mapping_ctx *ctx, bool write);
+};
+
+struct mapping_ctx {
+	unsigned long max_id;
+	size_t data_size;
+
+	const struct mapping_ctx_ops *ops;
+
+	DECLARE_HASHTABLE(ht, 8);
+};
+
+int
+mapping_add(struct mapping_ctx *ctx, void *data, u32 *id)
+{
+	struct mapping_item *mi;
+	u32 hash_key;
+	int err;
+
+	if (ctx->ops->lock)
+		ctx->ops->lock(ctx, true);
+
+	hash_key = jhash(data, ctx->data_size, 0);
+	hash_for_each_possible(ctx->ht, mi, node, hash_key) {
+		if (!memcmp(data, mi->data, ctx->data_size))
+			goto attach;
+	}
+
+	mi = ctx->ops->alloc_item(ctx);
+	if (IS_ERR(mi)) {
+		err = PTR_ERR(mi);
+		goto err_alloc;
+	}
+
+	memcpy(mi->data, data, ctx->data_size);
+	hash_add(ctx->ht, &mi->node, hash_key);
+
+	err = ctx->ops->assign_id(ctx, mi);
+	if (err)
+		goto err_assign;
+
+attach:
+	++mi->cnt;
+	*id = mi->id;
+
+	if (ctx->ops->lock)
+		ctx->ops->unlock(ctx, true);
+
+	return 0;
+
+err_assign:
+	hash_del(&mi->node);
+	ctx->ops->free_item(ctx, mi);
+err_alloc:
+	if (ctx->ops->lock)
+		ctx->ops->unlock(ctx, true);
+	return err;
+}
+
+int
+mapping_remove(struct mapping_ctx *ctx, u32 id)
+{
+	struct mapping_item *mi;
+	int err = -ENOENT;
+
+	if (ctx->ops->lock)
+		ctx->ops->lock(ctx, true);
+
+	mi = ctx->ops->find_id(ctx, id);
+	if (!mi)
+		goto out;
+	err = 0;
+
+	if (--mi->cnt > 0)
+		goto out;
+
+	hash_del(&mi->node);
+
+	ctx->ops->free_item(ctx, mi);
+
+out:
+	if (ctx->ops->lock)
+		ctx->ops->unlock(ctx, true);
+
+	return err;
+}
+
+int
+mapping_find(struct mapping_ctx *ctx, u32 id, void *data)
+{
+	struct mapping_item *mi;
+	int err = -ENOENT;
+
+	if (ctx->ops->lock)
+		ctx->ops->lock(ctx, false);
+
+	mi = ctx->ops->find_id(ctx, id);
+	if (!mi)
+		goto err_find;
+
+	memcpy(data, mi->data, ctx->data_size);
+	err = 0;
+
+err_find:
+	if (ctx->ops->lock)
+		ctx->ops->unlock(ctx, false);
+	return err;
+}
+
+static void
+mapping_ctx_init(struct mapping_ctx *ctx, size_t data_size, u32 max_id,
+		 const struct mapping_ctx_ops *ops)
+{
+	ctx->data_size = data_size;
+	ctx->max_id = max_id;
+	ctx->ops = ops;
+}
+
+struct mapping_idr_ctx {
+	struct mapping_ctx ctx;
+
+	struct idr idr;
+	struct mutex lock; /* guards the idr */
+
+	bool delayed_removal;
+	struct delayed_work dwork;
+	struct list_head pending_list;
+	spinlock_t pending_list_lock; /* guards pending list */
+};
+
+struct mapping_idr_item {
+	struct rcu_head rcu;
+	struct list_head list;
+	typeof(jiffies) timeout;
+
+	struct mapping_item item; /* Must be last for correct allocation */
+};
+
+static struct mapping_item *
+mapping_idr_alloc_item(struct mapping_ctx *ctx)
+{
+	struct mapping_idr_item *dmi;
+
+	dmi = kzalloc(sizeof(*dmi) + ctx->data_size, GFP_KERNEL);
+	return dmi ? &dmi->item : ERR_PTR(-ENOMEM);
+}
+
+static void
+mapping_idr_remove_and_free(struct mapping_idr_ctx *dctx,
+			    struct mapping_idr_item *dmi)
+{
+	idr_remove(&dctx->idr, dmi->item.id);
+	kfree_rcu(dmi, rcu);
+}
+
+static void
+mapping_idr_free_item(struct mapping_ctx *ctx, struct mapping_item *mi)
+{
+	struct mapping_idr_ctx *dctx;
+	struct mapping_idr_item *dmi;
+
+	dctx = container_of(ctx, struct mapping_idr_ctx, ctx);
+	dmi = container_of(mi, struct mapping_idr_item, item);
+
+	if (!mi->id) {
+		/* Not added to idr yet, we can free directly */
+		kfree(dmi);
+		return;
+	}
+
+	if (dctx->delayed_removal) {
+		dmi->timeout =
+			jiffies + msecs_to_jiffies(MAPPING_GRACE_PERIOD);
+
+		spin_lock(&dctx->pending_list_lock);
+		list_add_tail(&dmi->list, &dctx->pending_list);
+		spin_unlock(&dctx->pending_list_lock);
+
+		schedule_delayed_work(&dctx->dwork, MAPPING_GRACE_PERIOD);
+		return;
+	}
+
+	mapping_idr_remove_and_free(dctx, dmi);
+}
+
+static int
+mapping_idr_assign_id(struct mapping_ctx *ctx, struct mapping_item *mi)
+{
+	struct mapping_idr_ctx *dctx;
+	u32 max_id, index = 1;
+	int err;
+
+	max_id = ctx->max_id ? ctx->max_id : UINT_MAX;
+
+	dctx = container_of(ctx, struct mapping_idr_ctx, ctx);
+	err = idr_alloc_u32(&dctx->idr, mi, &index, max_id, GFP_KERNEL);
+	if (err)
+		return err;
+
+	mi->id = index;
+
+	return 0;
+}
+
+static struct mapping_item *
+mapping_idr_find_id(struct mapping_ctx *ctx, u32 id)
+{
+	struct mapping_idr_ctx *dctx;
+
+	dctx = container_of(ctx, struct mapping_idr_ctx, ctx);
+	return idr_find(&dctx->idr, id);
+}
+
+static void
+mapping_idr_lock(struct mapping_ctx *ctx, bool write)
+{
+	struct mapping_idr_ctx *dctx;
+
+	if (!write) {
+		rcu_read_lock();
+		return;
+	}
+
+	dctx = container_of(ctx, struct mapping_idr_ctx, ctx);
+	mutex_lock(&dctx->lock);
+}
+
+static void
+mapping_idr_unlock(struct mapping_ctx *ctx, bool write)
+{
+	struct mapping_idr_ctx *dctx;
+
+	if (!write) {
+		rcu_read_unlock();
+		return;
+	}
+
+	dctx = container_of(ctx, struct mapping_idr_ctx, ctx);
+	mutex_unlock(&dctx->lock);
+}
+
+static const struct mapping_ctx_ops idr_ops = {
+	.alloc_item = mapping_idr_alloc_item,
+	.free_item = mapping_idr_free_item,
+	.assign_id = mapping_idr_assign_id,
+	.find_id = mapping_idr_find_id,
+	.lock = mapping_idr_lock,
+	.unlock = mapping_idr_unlock,
+};
+
+static void
+mapping_idr_work_handler(struct work_struct *work)
+{
+	typeof(jiffies) min_timeout = 0, now = jiffies;
+	struct mapping_idr_item *dmi, *next;
+	struct mapping_idr_ctx *dctx;
+	LIST_HEAD(pending_items);
+
+	dctx = container_of(work, struct mapping_idr_ctx, dwork.work);
+
+	spin_lock(&dctx->pending_list_lock);
+	list_for_each_entry_safe(dmi, next, &dctx->pending_list, list) {
+		if (time_after(now, dmi->timeout))
+			list_move(&dmi->list, &pending_items);
+		else if (!min_timeout ||
+			 time_before(dmi->timeout, min_timeout))
+			min_timeout = dmi->timeout;
+	}
+	spin_unlock(&dctx->pending_list_lock);
+
+	list_for_each_entry_safe(dmi, next, &pending_items, list)
+		mapping_idr_remove_and_free(dctx, dmi);
+
+	if (min_timeout)
+		schedule_delayed_work(&dctx->dwork, abs(min_timeout - now));
+}
+
+static void
+mapping_idr_flush_work(struct mapping_idr_ctx *dctx)
+{
+	struct mapping_idr_item *dmi;
+
+	if (!dctx->delayed_removal)
+		return;
+
+	spin_lock(&dctx->pending_list_lock);
+	list_for_each_entry(dmi, &dctx->pending_list, list)
+		dmi->timeout = jiffies;
+	spin_unlock(&dctx->pending_list_lock);
+
+	/* Queue again, so we'll clean the pending list */
+	schedule_delayed_work(&dctx->dwork, 0);
+
+	/* Wait for queued work to be finished */
+	flush_delayed_work(&dctx->dwork);
+}
+
+struct mapping_ctx *
+mapping_idr_create(size_t data_size, u32 max_id, bool delayed_removal)
+{
+	struct mapping_idr_ctx *dctx;
+
+	dctx = kzalloc(sizeof(*dctx), GFP_KERNEL);
+	if (!dctx)
+		return ERR_PTR(-ENOMEM);
+
+	mapping_ctx_init(&dctx->ctx, data_size, max_id, &idr_ops);
+
+	if (delayed_removal) {
+		INIT_DELAYED_WORK(&dctx->dwork, mapping_idr_work_handler);
+		INIT_LIST_HEAD(&dctx->pending_list);
+		spin_lock_init(&dctx->pending_list_lock);
+	}
+
+	dctx->delayed_removal = delayed_removal;
+	idr_init(&dctx->idr);
+	mutex_init(&dctx->lock);
+
+	return &dctx->ctx;
+}
+
+void
+mapping_idr_destroy(struct mapping_ctx *ctx)
+{
+	struct mapping_idr_ctx *dctx = container_of(ctx,
+						    struct mapping_idr_ctx,
+						    ctx);
+
+	mapping_idr_flush_work(dctx);
+	idr_destroy(&dctx->idr);
+	mutex_destroy(&dctx->lock);
+
+	kfree(dctx);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mapping.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mapping.h
new file mode 100644
index 0000000..3704205
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mapping.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies */
+
+#ifndef __MLX5_MAPPING_H__
+#define __MLX5_MAPPING_H__
+
+struct mapping_ctx;
+
+int
+mapping_add(struct mapping_ctx *ctx, void *data, u32 *id);
+int
+mapping_remove(struct mapping_ctx *ctx, u32 id);
+int
+mapping_find(struct mapping_ctx *ctx, u32 id, void *data);
+
+/* mapping_idr uses an idr to map data to ids in add(), and for find().
+ * For locking, it uses a mutex for add()/remove(). find() uses
+ * rcu_read_lock().
+ * Choosing delayed_removal postpones the removal of a previously mapped
+ * id by MAPPING_GRACE_PERIOD milliseconds.
+ * This is to avoid races against hardware, where we mark the packet in
+ * hardware with a previous id, and quick remove() and add() reusing the same
+ * previous id. Then find() will get the new mapping instead of the old
+ * which was used to mark the packet.
+ */
+struct mapping_ctx *
+mapping_idr_create(size_t data_size, u32 max_id, bool delayed_removal);
+void
+mapping_idr_destroy(struct mapping_ctx *ctx);
+
+#endif /* __MLX5_MAPPING_H__ */
-- 
1.8.3.1


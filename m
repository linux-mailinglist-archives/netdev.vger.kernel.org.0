Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB774160344
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgBPKBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:54 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52946 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726939AbgBPKBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:48 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1ce1007834;
        Sun, 16 Feb 2020 12:01:39 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next-mlx5 v3 05/16] net/mlx5: Introduce mapping infra for mapping unique ids to data
Date:   Sun, 16 Feb 2020 12:01:25 +0200
Message-Id: <1581847296-19194-6-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new interface for mapping data to a given id range (max_id),
and back again. It uses xarray as the id allocator and for finding a
given id. For locking it uses xa_lock (spin_lock) for add()/del(),
and rcu_read_lock for find().

This mapping interface also supports delaying the mapping removal via
a workqueue. This is for cases where we need the mapping to have
some grace period in regards to finding it back again, for example
for packets arriving from hardware that were marked with by a rule
with an old mapping that no longer exists.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 Changelog:
   v2->v3
       Scraped generic structure
       Removed typeof()
       Cleaner flush
       Defined data[0] as data[] so comment isn't needed
       Changed from idr to xarray
       use inline style definitions
       Moved from lib to en

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/mapping.c   | 218 +++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/mapping.h   |  27 +++
 3 files changed, 246 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index d3e06ce..7f9de55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -34,7 +34,7 @@ mlx5_core-$(CONFIG_MLX5_EN_ARFS)     += en_arfs.o
 mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o en_tc.o en/tc_tun.o lib/port_tun.o lag_mp.o \
-					lib/geneve.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
+					lib/geneve.o en/mapping.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
 					en/tc_tun_geneve.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
new file mode 100644
index 0000000..ea321e5
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
@@ -0,0 +1,218 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2018 Mellanox Technologies */
+
+#include <linux/jhash.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+#include <linux/hashtable.h>
+
+#include "mapping.h"
+
+#define MAPPING_GRACE_PERIOD 2000
+
+struct mapping_ctx {
+	struct xarray xarray;
+	DECLARE_HASHTABLE(ht, 8);
+	struct mutex lock; /* Guards hashtable and xarray */
+	unsigned long max_id;
+	size_t data_size;
+	bool delayed_removal;
+	struct delayed_work dwork;
+	struct list_head pending_list;
+	spinlock_t pending_list_lock; /* Guards pending list */
+};
+
+struct mapping_item {
+	struct rcu_head rcu;
+	struct list_head list;
+	unsigned long timeout;
+	struct hlist_node node;
+	int cnt;
+	u32 id;
+	char data[];
+};
+
+int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id)
+{
+	struct mapping_item *mi;
+	int err = -ENOMEM;
+	u32 hash_key;
+
+	mutex_lock(&ctx->lock);
+
+	hash_key = jhash(data, ctx->data_size, 0);
+	hash_for_each_possible(ctx->ht, mi, node, hash_key) {
+		if (!memcmp(data, mi->data, ctx->data_size))
+			goto attach;
+	}
+
+	mi = kzalloc(sizeof(*mi) + ctx->data_size, GFP_KERNEL);
+	if (!mi)
+		goto err_alloc;
+
+	memcpy(mi->data, data, ctx->data_size);
+	hash_add(ctx->ht, &mi->node, hash_key);
+
+	err = xa_alloc(&ctx->xarray, &mi->id, mi, XA_LIMIT(1, ctx->max_id),
+		       GFP_KERNEL);
+	if (err)
+		goto err_assign;
+attach:
+	++mi->cnt;
+	*id = mi->id;
+
+	mutex_unlock(&ctx->lock);
+
+	return 0;
+
+err_assign:
+	hash_del(&mi->node);
+	kfree(mi);
+err_alloc:
+	mutex_unlock(&ctx->lock);
+
+	return err;
+}
+
+static void mapping_remove_and_free(struct mapping_ctx *ctx,
+				    struct mapping_item *mi)
+{
+	xa_erase(&ctx->xarray, mi->id);
+	kfree_rcu(mi, rcu);
+}
+
+static void mapping_free_item(struct mapping_ctx *ctx,
+			      struct mapping_item *mi)
+{
+	if (!ctx->delayed_removal) {
+		mapping_remove_and_free(ctx, mi);
+		return;
+	}
+
+	mi->timeout = jiffies + msecs_to_jiffies(MAPPING_GRACE_PERIOD);
+
+	spin_lock(&ctx->pending_list_lock);
+	list_add_tail(&mi->list, &ctx->pending_list);
+	spin_unlock(&ctx->pending_list_lock);
+
+	schedule_delayed_work(&ctx->dwork, MAPPING_GRACE_PERIOD);
+}
+
+int mapping_remove(struct mapping_ctx *ctx, u32 id)
+{
+	unsigned long index = id;
+	struct mapping_item *mi;
+	int err = -ENOENT;
+
+	mutex_lock(&ctx->lock);
+	mi = xa_load(&ctx->xarray, index);
+	if (!mi)
+		goto out;
+	err = 0;
+
+	if (--mi->cnt > 0)
+		goto out;
+
+	hash_del(&mi->node);
+	mapping_free_item(ctx, mi);
+out:
+	mutex_unlock(&ctx->lock);
+
+	return err;
+}
+
+int mapping_find(struct mapping_ctx *ctx, u32 id, void *data)
+{
+	unsigned long index = id;
+	struct mapping_item *mi;
+	int err = -ENOENT;
+
+	rcu_read_lock();
+	mi = xa_load(&ctx->xarray, index);
+	if (!mi)
+		goto err_find;
+
+	memcpy(data, mi->data, ctx->data_size);
+	err = 0;
+
+err_find:
+	rcu_read_unlock();
+	return err;
+}
+
+static void
+mapping_remove_and_free_list(struct mapping_ctx *ctx, struct list_head *list)
+{
+	struct mapping_item *mi;
+
+	list_for_each_entry(mi, list, list)
+		mapping_remove_and_free(ctx, mi);
+}
+
+static void mapping_work_handler(struct work_struct *work)
+{
+	unsigned long min_timeout = 0, now = jiffies;
+	struct mapping_item *mi, *next;
+	LIST_HEAD(pending_items);
+	struct mapping_ctx *ctx;
+
+	ctx = container_of(work, struct mapping_ctx, dwork.work);
+
+	spin_lock(&ctx->pending_list_lock);
+	list_for_each_entry_safe(mi, next, &ctx->pending_list, list) {
+		if (time_after(now, mi->timeout))
+			list_move(&mi->list, &pending_items);
+		else if (!min_timeout ||
+			 time_before(mi->timeout, min_timeout))
+			min_timeout = mi->timeout;
+	}
+	spin_unlock(&ctx->pending_list_lock);
+
+	mapping_remove_and_free_list(ctx, &pending_items);
+
+	if (min_timeout)
+		schedule_delayed_work(&ctx->dwork, abs(min_timeout - now));
+}
+
+static void mapping_flush_work(struct mapping_ctx *ctx)
+{
+	if (!ctx->delayed_removal)
+		return;
+
+	cancel_delayed_work_sync(&ctx->dwork);
+	mapping_remove_and_free_list(ctx, &ctx->pending_list);
+}
+
+struct mapping_ctx *
+mapping_create(size_t data_size, u32 max_id, bool delayed_removal)
+{
+	struct mapping_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ctx->max_id = max_id ? max_id : UINT_MAX;
+	ctx->data_size = data_size;
+
+	if (delayed_removal) {
+		INIT_DELAYED_WORK(&ctx->dwork, mapping_work_handler);
+		INIT_LIST_HEAD(&ctx->pending_list);
+		spin_lock_init(&ctx->pending_list_lock);
+		ctx->delayed_removal = true;
+	}
+
+	mutex_init(&ctx->lock);
+	xa_init_flags(&ctx->xarray, XA_FLAGS_ALLOC1);
+
+	return ctx;
+}
+
+void mapping_destroy(struct mapping_ctx *ctx)
+{
+	mapping_flush_work(ctx);
+	xa_destroy(&ctx->xarray);
+	mutex_destroy(&ctx->lock);
+
+	kfree(ctx);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
new file mode 100644
index 0000000..285525c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies */
+
+#ifndef __MLX5_MAPPING_H__
+#define __MLX5_MAPPING_H__
+
+struct mapping_ctx;
+
+int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id);
+int mapping_remove(struct mapping_ctx *ctx, u32 id);
+int mapping_find(struct mapping_ctx *ctx, u32 id, void *data);
+
+/* mapping uses an xarray to map data to ids in add(), and for find().
+ * For locking, it uses a internal xarray spin lock for add()/remove(),
+ * find() uses rcu_read_lock().
+ * Choosing delayed_removal postpones the removal of a previously mapped
+ * id by MAPPING_GRACE_PERIOD milliseconds.
+ * This is to avoid races against hardware, where we mark the packet in
+ * hardware with a previous id, and quick remove() and add() reusing the same
+ * previous id. Then find() will get the new mapping instead of the old
+ * which was used to mark the packet.
+ */
+struct mapping_ctx *mapping_create(size_t data_size, u32 max_id,
+				   bool delayed_removal);
+void mapping_destroy(struct mapping_ctx *ctx);
+
+#endif /* __MLX5_MAPPING_H__ */
-- 
1.8.3.1


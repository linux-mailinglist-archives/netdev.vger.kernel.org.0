Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A1E633B07
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiKVLRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbiKVLRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:17:15 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4188060355;
        Tue, 22 Nov 2022 03:14:33 -0800 (PST)
X-UUID: 4f10d8b7096d41d4969bd686d81cb338-20221122
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=UPVYXybqHdkNefD2nI/WDgupd5oCIdOMKakDKFgr6ck=;
        b=Sa6cXoU4mIJ0SAGUPRv11k+kfHtyzu7VzvoTaLA4DeZ8aN2wwQEXO74IO/v1PE7peKkJtm6j9vXj7FCa9FhK80ZHDPFZ2faQeJf8ZBKQ5ZmfUvS2FqEn2+0Cdbz1aLbI6eQID2qu5Dmi8mgP7duXugDz201yZLd3R4xbmN/Tapg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.13,REQID:f4ec40e6-c9ff-4813-84c2-568236c60604,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:95
X-CID-INFO: VERSION:1.1.13,REQID:f4ec40e6-c9ff-4813-84c2-568236c60604,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTION
        :quarantine,TS:95
X-CID-META: VersionHash:d12e911,CLOUDID:dc64fbf8-3a34-4838-abcf-dfedf9dd068e,B
        ulkID:221122191429XSO85QPJ,BulkQuantity:1,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: 4f10d8b7096d41d4969bd686d81cb338-20221122
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1605129759; Tue, 22 Nov 2022 19:14:26 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Tue, 22 Nov 2022 19:14:25 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 22 Nov 2022 19:14:23 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
CC:     MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        "Yanchao Yang" <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>,
        MediaTek Corporation <linuxwwan@mediatek.com>
Subject: [PATCH net-next v1 02/13] net: wwan: tmi: Add buffer management
Date:   Tue, 22 Nov 2022 19:11:41 +0800
Message-ID: <20221122111152.160377-3-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20221122111152.160377-1-yanchao.yang@mediatek.com>
References: <20221122111152.160377-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: MediaTek Corporation <linuxwwan@mediatek.com>

To malloc I/O memory as soon as possible, buffer management comes into being.
It creates buffer pools that reserve some buffers through deferred works when
the driver isn't busy.

The buffer management provides unified memory allocation/de-allocation
interfaces for other modules. It supports two buffer types of SKB and page.
Two reload work queues with different priority values are provided to meet
various requirements of the control plane and the data plane.

When the reserved buffer count of the pool is less than a threshold (default
is 2/3 of the pool size), the reload work will restart to allocate buffers
from the OS until the buffer pool becomes full. When the buffer pool fills,
the OS will recycle the buffer freed by the user.

Signed-off-by: Mingliang Xu <mingliang.xu@mediatek.com>
Signed-off-by: MediaTek Corporation <linuxwwan@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile  |   3 +-
 drivers/net/wwan/mediatek/mtk_bm.c  | 369 ++++++++++++++++++++++++++++
 drivers/net/wwan/mediatek/mtk_bm.h  |  79 ++++++
 drivers/net/wwan/mediatek/mtk_dev.c |  11 +-
 drivers/net/wwan/mediatek/mtk_dev.h |   1 +
 5 files changed, 461 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_bm.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_bm.h

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index ae5f8a5ba05a..122a791e1683 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -4,7 +4,8 @@ MODULE_NAME := mtk_tmi
 
 mtk_tmi-y = \
 	pcie/mtk_pci.o	\
-	mtk_dev.o
+	mtk_dev.o	\
+	mtk_bm.o
 
 ccflags-y += -I$(srctree)/$(src)/
 ccflags-y += -I$(srctree)/$(src)/pcie/
diff --git a/drivers/net/wwan/mediatek/mtk_bm.c b/drivers/net/wwan/mediatek/mtk_bm.c
new file mode 100644
index 000000000000..fa5abb82d038
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_bm.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#include "mtk_bm.h"
+
+#define MTK_RELOAD_TH 3
+#define MTK_WQ_NAME_LEN 48
+
+static int mtk_bm_page_pool_create(struct mtk_bm_pool *pool)
+{
+	INIT_LIST_HEAD(&pool->list.buff_list);
+
+	return 0;
+}
+
+static void mtk_bm_page_pool_destroy(struct mtk_bm_pool *pool)
+{
+	struct mtk_buff *mb, *next;
+
+	list_for_each_entry_safe(mb, next, &pool->list.buff_list, entry) {
+		list_del(&mb->entry);
+		skb_free_frag(mb->data);
+		kmem_cache_free(pool->bm_ctrl->list_cache_pool, mb);
+	}
+}
+
+static void *mtk_bm_page_buff_alloc(struct mtk_bm_pool *pool)
+{
+	struct mtk_buff *mb;
+	void *data;
+
+	spin_lock_bh(&pool->lock);
+	mb = list_first_entry_or_null(&pool->list.buff_list, struct mtk_buff, entry);
+	if (!mb) {
+		spin_unlock_bh(&pool->lock);
+		data = netdev_alloc_frag(pool->buff_size);
+	} else {
+		list_del(&mb->entry);
+		pool->curr_cnt--;
+		spin_unlock_bh(&pool->lock);
+		data = mb->data;
+		kmem_cache_free(pool->bm_ctrl->list_cache_pool, mb);
+	}
+
+	if (pool->curr_cnt < pool->threshold)
+		queue_work(pool->reload_workqueue, &pool->reload_work);
+
+	return data;
+}
+
+static void mtk_bm_page_buff_free(struct mtk_bm_pool *pool, void *data)
+{
+	struct mtk_buff *mb;
+
+	if (pool->curr_cnt >= pool->buff_cnt) {
+		skb_free_frag(data);
+		return;
+	}
+
+	mb = kmem_cache_alloc(pool->bm_ctrl->list_cache_pool, GFP_KERNEL);
+	if (mb) {
+		mb->data = data;
+		spin_lock_bh(&pool->lock);
+		list_add_tail(&mb->entry, &pool->list.buff_list);
+		pool->curr_cnt++;
+		spin_unlock_bh(&pool->lock);
+	} else {
+		skb_free_frag(data);
+	}
+}
+
+static void mtk_bm_page_pool_reload(struct work_struct *work)
+{
+	struct mtk_bm_pool *pool = container_of(work, struct mtk_bm_pool, reload_work);
+	struct mtk_buff *mb;
+
+	while (pool->curr_cnt < pool->buff_cnt && !atomic_read(&pool->work_stop)) {
+		mb = kmem_cache_alloc(pool->bm_ctrl->list_cache_pool, GFP_KERNEL);
+		if (!mb)
+			break;
+
+		mb->data = netdev_alloc_frag(pool->buff_size);
+		if (!mb->data) {
+			kmem_cache_free(pool->bm_ctrl->list_cache_pool, mb);
+			break;
+		}
+
+		spin_lock_bh(&pool->lock);
+		list_add_tail(&mb->entry, &pool->list.buff_list);
+		pool->curr_cnt++;
+		spin_unlock_bh(&pool->lock);
+	}
+}
+
+static struct mtk_buff_ops page_buf_ops = {
+	.pool_create = mtk_bm_page_pool_create,
+	.pool_destroy = mtk_bm_page_pool_destroy,
+	.buff_alloc = mtk_bm_page_buff_alloc,
+	.buff_free = mtk_bm_page_buff_free,
+	.pool_reload = mtk_bm_page_pool_reload,
+};
+
+static int mtk_bm_skb_pool_create(struct mtk_bm_pool *pool)
+{
+	skb_queue_head_init(&pool->list.skb_list);
+
+	return 0;
+}
+
+static void mtk_bm_skb_pool_destroy(struct mtk_bm_pool *pool)
+{
+	skb_queue_purge(&pool->list.skb_list);
+}
+
+static void *mtk_bm_skb_buff_alloc(struct mtk_bm_pool *pool)
+{
+	gfp_t gfp = GFP_KERNEL;
+	struct sk_buff *skb;
+
+	spin_lock_bh(&pool->lock);
+	skb = __skb_dequeue(&pool->list.skb_list);
+	spin_unlock_bh(&pool->lock);
+	if (!skb) {
+		if (in_irq() || in_softirq())
+			gfp = GFP_ATOMIC;
+		skb = __dev_alloc_skb(pool->buff_size, gfp);
+	}
+
+	if (pool->list.skb_list.qlen < pool->threshold)
+		queue_work(pool->reload_workqueue, &pool->reload_work);
+
+	return skb;
+}
+
+static void mtk_bm_skb_buff_free(struct mtk_bm_pool *pool, void *data)
+{
+	struct sk_buff *skb = data;
+
+	if (pool->list.skb_list.qlen < pool->buff_cnt) {
+		/* reset sk_buff (take __alloc_skb as ref.) */
+		skb->data = skb->head;
+		skb->len = 0;
+		skb_reset_tail_pointer(skb);
+		/* reserve memory as netdev_alloc_skb */
+		skb_reserve(skb, NET_SKB_PAD);
+
+		spin_lock_bh(&pool->lock);
+		__skb_queue_tail(&pool->list.skb_list, skb);
+		spin_unlock_bh(&pool->lock);
+	} else {
+		dev_kfree_skb_any(skb);
+	}
+}
+
+static void mtk_bm_skb_pool_reload(struct work_struct *work)
+{
+	struct mtk_bm_pool *pool = container_of(work, struct mtk_bm_pool, reload_work);
+	struct sk_buff *skb;
+
+	while (pool->list.skb_list.qlen < pool->buff_cnt && !atomic_read(&pool->work_stop)) {
+		skb = __dev_alloc_skb(pool->buff_size, GFP_KERNEL);
+		if (!skb)
+			break;
+
+		spin_lock_bh(&pool->lock);
+		__skb_queue_tail(&pool->list.skb_list, skb);
+		spin_unlock_bh(&pool->lock);
+	}
+}
+
+static struct mtk_buff_ops skb_buf_ops = {
+	.pool_create = mtk_bm_skb_pool_create,
+	.pool_destroy = mtk_bm_skb_pool_destroy,
+	.buff_alloc = mtk_bm_skb_buff_alloc,
+	.buff_free = mtk_bm_skb_buff_free,
+	.pool_reload = mtk_bm_skb_pool_reload,
+};
+
+/* mtk_bm_init - Init struct mtk_bm_ctrl
+ *
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_bm_init(struct mtk_md_dev *mdev)
+{
+	char wq_name[MTK_WQ_NAME_LEN];
+	struct mtk_bm_ctrl *bm;
+
+	bm = devm_kzalloc(mdev->dev, sizeof(*bm), GFP_KERNEL);
+	if (!bm)
+		return -ENOMEM;
+
+	bm->list_cache_pool = kmem_cache_create(mdev->dev_str, sizeof(struct mtk_buff), 0, 0, NULL);
+	if (unlikely(!bm->list_cache_pool))
+		goto err_free_buf;
+
+	snprintf(wq_name, sizeof(wq_name), "mtk_pool_reload_work_h_%s", mdev->dev_str);
+	bm->pool_reload_workqueue_h = alloc_workqueue(wq_name,
+						      WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
+	if (!bm->pool_reload_workqueue_h)
+		goto err_destroy_cache_pool;
+
+	snprintf(wq_name, sizeof(wq_name), "mtk_pool_reload_work_l_%s", mdev->dev_str);
+	bm->pool_reload_workqueue_l = alloc_workqueue(wq_name,
+						      WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!bm->pool_reload_workqueue_l)
+		goto err_destroy_wq;
+
+	mutex_init(&bm->pool_list_mtx);
+	INIT_LIST_HEAD(&bm->pool_list);
+
+	bm->m_ops[MTK_BUFF_SKB] = &skb_buf_ops;
+	bm->m_ops[MTK_BUFF_PAGE] = &page_buf_ops;
+	mdev->bm_ctrl = bm;
+
+	return 0;
+
+err_destroy_wq:
+	flush_workqueue(bm->pool_reload_workqueue_h);
+	destroy_workqueue(bm->pool_reload_workqueue_h);
+err_destroy_cache_pool:
+	kmem_cache_destroy(bm->list_cache_pool);
+err_free_buf:
+	devm_kfree(mdev->dev, bm);
+	return -ENOMEM;
+}
+
+/* mtk_bm_pool_create - Create a buffer pool
+ *
+ * @mdev: pointer to mtk_md_dev
+ * @type: pool type
+ * @buff_size: the buffer size
+ * @buff_cnt: the buffer count
+ * @prio: the priority of reload work
+ *
+ * Return: return value is a buffer pool on success, a NULL pointer on failure.
+ */
+struct mtk_bm_pool *mtk_bm_pool_create(struct mtk_md_dev *mdev,
+				       enum mtk_buff_type type, unsigned int buff_size,
+				       unsigned int buff_cnt, unsigned int prio)
+{
+	struct mtk_bm_ctrl *bm = mdev->bm_ctrl;
+	struct mtk_bm_pool *pool;
+
+	pool = devm_kzalloc(mdev->dev, sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	pool->type = type;
+	pool->buff_size = buff_size;
+	pool->buff_cnt = buff_cnt;
+	pool->pool_id = bm->pool_seq++;
+	pool->threshold = pool->buff_cnt - pool->buff_cnt / MTK_RELOAD_TH;
+	pool->dev = mdev->dev;
+
+	if (prio == MTK_BM_HIGH_PRIO)
+		pool->reload_workqueue = bm->pool_reload_workqueue_h;
+	else
+		pool->reload_workqueue = bm->pool_reload_workqueue_l;
+	pool->prio = prio;
+
+	spin_lock_init(&pool->lock);
+	pool->ops = bm->m_ops[pool->type];
+	INIT_WORK(&pool->reload_work, pool->ops->pool_reload);
+	if (pool->ops->pool_create(pool))
+		goto err_free_buf;
+	queue_work(pool->reload_workqueue, &pool->reload_work);
+	atomic_set(&pool->work_stop, 0);
+	pool->bm_ctrl = bm;
+
+	mutex_lock(&bm->pool_list_mtx);
+	list_add_tail(&pool->entry, &bm->pool_list);
+	mutex_unlock(&bm->pool_list_mtx);
+
+	return pool;
+
+err_free_buf:
+	dev_err(mdev->dev, "Failed to create bm pool\n");
+	devm_kfree(mdev->dev, pool);
+	return NULL;
+}
+
+/* mtk_bm_alloc - alloc a block of buffer from bm pool
+ *
+ * @pool: the buffer pool
+ *
+ * Return: return value is a block of buffer from bm pool on success, a NULL pointer on failure.
+ */
+void *mtk_bm_alloc(struct mtk_bm_pool *pool)
+{
+	return pool->ops->buff_alloc(pool);
+}
+
+/* mtk_bm_free - free a block of buffer to bm pool
+ *
+ * @pool: the buffer pool
+ * @data: the buffer need to free to pool
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_bm_free(struct mtk_bm_pool *pool, void *data)
+{
+	if (!data)
+		return -EINVAL;
+
+	pool->ops->buff_free(pool, data);
+
+	return 0;
+}
+
+/* mtk_bm_pool_destroy - destroy a buffer pool
+ * rule: we must stop calling alloc/free before this function is called.
+ *
+ * @mdev: pointer to mtk_md_dev
+ * @pool: the buffer pool need to destroy
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_bm_pool_destroy(struct mtk_md_dev *mdev, struct mtk_bm_pool *pool)
+{
+	struct mtk_bm_ctrl *bm = mdev->bm_ctrl;
+
+	atomic_set(&pool->work_stop, 1);
+	cancel_work_sync(&pool->reload_work);
+	spin_lock_bh(&pool->lock);
+	pool->curr_cnt = 0;
+	spin_unlock_bh(&pool->lock);
+
+	mutex_lock(&bm->pool_list_mtx);
+	list_del(&pool->entry);
+	mutex_unlock(&bm->pool_list_mtx);
+
+	pool->ops->pool_destroy(pool);
+
+	devm_kfree(mdev->dev, pool);
+	return 0;
+}
+
+/* mtk_bm_exit - deinit struct mtk_bm_ctrl
+ *
+ * @mdev : pointer to mtk_md_dev
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_bm_exit(struct mtk_md_dev *mdev)
+{
+	struct mtk_bm_ctrl *bm = mdev->bm_ctrl;
+
+	flush_workqueue(bm->pool_reload_workqueue_h);
+	destroy_workqueue(bm->pool_reload_workqueue_h);
+	flush_workqueue(bm->pool_reload_workqueue_l);
+	destroy_workqueue(bm->pool_reload_workqueue_l);
+
+	if (unlikely(!list_empty(&bm->pool_list)))
+		dev_warn(mdev->dev, "bm pool not destroyed\n");
+
+	kmem_cache_destroy(bm->list_cache_pool);
+	devm_kfree(mdev->dev, bm);
+
+	return 0;
+}
diff --git a/drivers/net/wwan/mediatek/mtk_bm.h b/drivers/net/wwan/mediatek/mtk_bm.h
new file mode 100644
index 000000000000..6ac473c05296
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_bm.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_BM_H__
+#define __MTK_BM_H__
+
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+
+#include "mtk_dev.h"
+
+#define MTK_BM_LOW_PRIO 0
+#define MTK_BM_HIGH_PRIO 1
+
+enum mtk_buff_type {
+	MTK_BUFF_SKB = 0,
+	MTK_BUFF_PAGE,
+	MTK_BUFF_MAX
+};
+
+struct mtk_bm_ctrl {
+	unsigned int pool_seq;
+	struct workqueue_struct *pool_reload_workqueue_h;
+	struct workqueue_struct *pool_reload_workqueue_l;
+	struct kmem_cache *list_cache_pool;
+	struct list_head pool_list;
+	struct mutex pool_list_mtx;	/* protects the pool list */
+	struct mtk_buff_ops *m_ops[MTK_BUFF_MAX];
+};
+
+struct mtk_buff {
+	struct list_head entry;
+	void *data;
+};
+
+union mtk_buff_list {
+	struct sk_buff_head skb_list;
+	struct list_head buff_list;
+};
+
+struct mtk_bm_pool {
+	unsigned int pool_id;
+	enum mtk_buff_type type;
+	unsigned int threshold;
+	unsigned int buff_size;
+	unsigned int buff_cnt;
+	unsigned int curr_cnt;
+	unsigned int prio;
+	atomic_t work_stop;
+	spinlock_t lock;		/* protects the buffer operation */
+	union mtk_buff_list list;
+	struct device *dev;
+	struct work_struct reload_work;
+	struct workqueue_struct *reload_workqueue;
+	struct list_head entry;
+	struct mtk_bm_ctrl *bm_ctrl;
+	struct mtk_buff_ops *ops;
+};
+
+struct mtk_buff_ops {
+	int (*pool_create)(struct mtk_bm_pool *pool);
+	void (*pool_destroy)(struct mtk_bm_pool *pool);
+	void *(*buff_alloc)(struct mtk_bm_pool *pool);
+	void (*buff_free)(struct mtk_bm_pool *pool, void *data);
+	void (*pool_reload)(struct work_struct *work);
+};
+
+int mtk_bm_init(struct mtk_md_dev *mdev);
+int mtk_bm_exit(struct mtk_md_dev *mdev);
+struct mtk_bm_pool *mtk_bm_pool_create(struct mtk_md_dev *mdev,
+				       enum mtk_buff_type type, unsigned int buff_size,
+				       unsigned int buff_cnt, unsigned int prio);
+int mtk_bm_pool_destroy(struct mtk_md_dev *mdev, struct mtk_bm_pool *pool);
+void *mtk_bm_alloc(struct mtk_bm_pool *pool);
+int mtk_bm_free(struct mtk_bm_pool *pool, void *data);
+
+#endif /* __MTK_BM_H__ */
diff --git a/drivers/net/wwan/mediatek/mtk_dev.c b/drivers/net/wwan/mediatek/mtk_dev.c
index d3d7bf940d78..513aac37cb9c 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.c
+++ b/drivers/net/wwan/mediatek/mtk_dev.c
@@ -3,15 +3,24 @@
  * Copyright (c) 2022, MediaTek Inc.
  */
 
+#include "mtk_bm.h"
 #include "mtk_dev.h"
 
 int mtk_dev_init(struct mtk_md_dev *mdev)
 {
-	return 0;
+	int ret;
+
+	ret = mtk_bm_init(mdev);
+	if (ret)
+		goto err_bm_init;
+
+err_bm_init:
+	return ret;
 }
 
 void mtk_dev_exit(struct mtk_md_dev *mdev)
 {
+	mtk_bm_exit(mdev);
 }
 
 int mtk_dev_start(struct mtk_md_dev *mdev)
diff --git a/drivers/net/wwan/mediatek/mtk_dev.h b/drivers/net/wwan/mediatek/mtk_dev.h
index bd7b1dc11daf..0c4b727b9c53 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.h
+++ b/drivers/net/wwan/mediatek/mtk_dev.h
@@ -130,6 +130,7 @@ struct mtk_md_dev {
 	u32 hw_ver;
 	int msi_nvecs;
 	char dev_str[MTK_DEV_STR_LEN];
+	struct mtk_bm_ctrl *bm_ctrl;
 };
 
 int mtk_dev_init(struct mtk_md_dev *mdev);
-- 
2.32.0


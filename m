Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BA8233F86
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 08:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbgGaG7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:59:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:18704 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731515AbgGaG7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:59:39 -0400
IronPort-SDR: 9RwZ8CBNLCli+v20FlPkSpSCx734LdLnYVZE+fi0g8P+R9LmVZ3ivnfqiGbGe/9q7v/64kS2yl
 QzO+BzaqY3iQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="152949283"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="152949283"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 23:59:39 -0700
IronPort-SDR: Burx+Fr73C1no4aoCquRhHfstnFcTgeDCODWtT104MqAz7+iYtJ2y6LJsXiIDnlW9JVvQDow+M
 XjAAWuVVLQ/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="273136573"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jul 2020 23:59:35 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 1/6] vhost: introduce vhost_vring_call
Date:   Fri, 31 Jul 2020 14:55:28 +0800
Message-Id: <20200731065533.4144-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200731065533.4144-1-lingshan.zhu@intel.com>
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces struct vhost_vring_call which replaced
raw struct eventfd_ctx *call_ctx in struct vhost_virtqueue.
Besides eventfd_ctx, it contains a spin lock and an
irq_bypass_producer in its structure.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c  |  4 ++--
 drivers/vhost/vhost.c | 22 ++++++++++++++++------
 drivers/vhost/vhost.h |  9 ++++++++-
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a54b60d6623f..df3cf386b0cd 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -96,7 +96,7 @@ static void handle_vq_kick(struct vhost_work *work)
 static irqreturn_t vhost_vdpa_virtqueue_cb(void *private)
 {
 	struct vhost_virtqueue *vq = private;
-	struct eventfd_ctx *call_ctx = vq->call_ctx;
+	struct eventfd_ctx *call_ctx = vq->call_ctx.ctx;
 
 	if (call_ctx)
 		eventfd_signal(call_ctx, 1);
@@ -382,7 +382,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		break;
 
 	case VHOST_SET_VRING_CALL:
-		if (vq->call_ctx) {
+		if (vq->call_ctx.ctx) {
 			cb.callback = vhost_vdpa_virtqueue_cb;
 			cb.private = vq;
 		} else {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d7b8df3edffc..9f1a845a9302 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -298,6 +298,13 @@ static void vhost_vq_meta_reset(struct vhost_dev *d)
 		__vhost_vq_meta_reset(d->vqs[i]);
 }
 
+static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
+{
+	call_ctx->ctx = NULL;
+	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer));
+	spin_lock_init(&call_ctx->ctx_lock);
+}
+
 static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
 {
@@ -319,13 +326,13 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->log_base = NULL;
 	vq->error_ctx = NULL;
 	vq->kick = NULL;
-	vq->call_ctx = NULL;
 	vq->log_ctx = NULL;
 	vhost_reset_is_le(vq);
 	vhost_disable_cross_endian(vq);
 	vq->busyloop_timeout = 0;
 	vq->umem = NULL;
 	vq->iotlb = NULL;
+	vhost_vring_call_reset(&vq->call_ctx);
 	__vhost_vq_meta_reset(vq);
 }
 
@@ -685,8 +692,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 			eventfd_ctx_put(dev->vqs[i]->error_ctx);
 		if (dev->vqs[i]->kick)
 			fput(dev->vqs[i]->kick);
-		if (dev->vqs[i]->call_ctx)
-			eventfd_ctx_put(dev->vqs[i]->call_ctx);
+		if (dev->vqs[i]->call_ctx.ctx)
+			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
 		vhost_vq_reset(dev, dev->vqs[i]);
 	}
 	vhost_dev_free_iovecs(dev);
@@ -1629,7 +1636,10 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = PTR_ERR(ctx);
 			break;
 		}
-		swap(ctx, vq->call_ctx);
+
+		spin_lock(&vq->call_ctx.ctx_lock);
+		swap(ctx, vq->call_ctx.ctx);
+		spin_unlock(&vq->call_ctx.ctx_lock);
 		break;
 	case VHOST_SET_VRING_ERR:
 		if (copy_from_user(&f, argp, sizeof f)) {
@@ -2440,8 +2450,8 @@ static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
 	/* Signal the Guest tell them we used something up. */
-	if (vq->call_ctx && vhost_notify(dev, vq))
-		eventfd_signal(vq->call_ctx, 1);
+	if (vq->call_ctx.ctx && vhost_notify(dev, vq))
+		eventfd_signal(vq->call_ctx.ctx, 1);
 }
 EXPORT_SYMBOL_GPL(vhost_signal);
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index c8e96a095d3b..38eb1aa3b68d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -13,6 +13,7 @@
 #include <linux/virtio_ring.h>
 #include <linux/atomic.h>
 #include <linux/vhost_iotlb.h>
+#include <linux/irqbypass.h>
 
 struct vhost_work;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
@@ -60,6 +61,12 @@ enum vhost_uaddr_type {
 	VHOST_NUM_ADDRS = 3,
 };
 
+struct vhost_vring_call {
+	struct eventfd_ctx *ctx;
+	struct irq_bypass_producer producer;
+	spinlock_t ctx_lock;
+};
+
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
@@ -72,7 +79,7 @@ struct vhost_virtqueue {
 	vring_used_t __user *used;
 	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
 	struct file *kick;
-	struct eventfd_ctx *call_ctx;
+	struct vhost_vring_call call_ctx;
 	struct eventfd_ctx *error_ctx;
 	struct eventfd_ctx *log_ctx;
 
-- 
2.18.4


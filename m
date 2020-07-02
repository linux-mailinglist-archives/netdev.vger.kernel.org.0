Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74106211E1A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgGBIWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:22:33 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55200 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgGBIWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:22:31 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628MJuo042209;
        Thu, 2 Jul 2020 03:22:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678139;
        bh=Uhwq7t9xmJ09dppFbQNiaS41cCziAqDB/ZcJ4oUfEXo=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=UC+AmEhNh3aW86RcPHPX1bzomjjyeb4yGiNuHcVwomWqfxi27c57DQN6LFLaEaB03
         X1y9lNs64MBrJRQQJ3r2u/Xgaust371pATFRpx89ycYyB/mfdagKqybKoItdeC7BrO
         K1wC2lsJ6nZLGWKJU+PzA0JtSsehQnRsA7rzMwD8=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628MJW0065146
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:22:19 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:22:18 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:22:18 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYH006145;
        Thu, 2 Jul 2020 03:22:13 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 05/22] vhost: Add MMIO helpers for operations on vhost virtqueue
Date:   Thu, 2 Jul 2020 13:51:26 +0530
Message-ID: <20200702082143.25259-6-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers for VHOST drivers to read descriptor data from
vhost_virtqueue for IN transfers or write descriptor data to
vhost_virtqueue for OUT transfers respectively. Also add
helpers to enable callback, disable callback and notify remote
virtio for events on virtqueue.

This adds helpers only for virtqueue in MMIO (helpers for virtqueue
in kernel space and user space can be added later).

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/vhost/Kconfig |   1 +
 drivers/vhost/vhost.c | 292 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/vhost.h |  22 ++++
 3 files changed, 315 insertions(+)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index c4f273793595..77e195a38469 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -24,6 +24,7 @@ config VHOST_DPN
 
 config VHOST
 	tristate
+	select VHOST_RING
 	select VHOST_IOTLB
 	help
 	  This option is selected by any driver which needs to access
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index f959abb0b1bb..8a3ad4698393 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2558,6 +2558,298 @@ struct vhost_msg_node *vhost_dequeue_msg(struct vhost_dev *dev,
 }
 EXPORT_SYMBOL_GPL(vhost_dequeue_msg);
 
+/**
+ * vhost_virtqueue_disable_cb_mmio() - Write to used ring in virtio accessed
+ *   using MMIO to stop notification
+ * @vq: vhost_virtqueue for which callbacks have to be disabled
+ *
+ * Write to used ring in virtio accessed using MMIO to stop sending notification
+ * to the vhost virtqueue.
+ */
+static void vhost_virtqueue_disable_cb_mmio(struct vhost_virtqueue *vq)
+{
+	struct vringh *vringh;
+
+	vringh = &vq->vringh;
+	vringh_notify_disable_mmio(vringh);
+}
+
+/**
+ * vhost_virtqueue_disable_cb() - Write to used ring in virtio to stop
+ *   notification
+ * @vq: vhost_virtqueue for which callbacks have to be disabled
+ *
+ * Wrapper to write to used ring in virtio to stop sending notification
+ * to the vhost virtqueue.
+ */
+void vhost_virtqueue_disable_cb(struct vhost_virtqueue *vq)
+{
+	enum vhost_type type;
+
+	type = vq->type;
+
+	/* TODO: Add support for other VHOST TYPES */
+	if (type == VHOST_TYPE_MMIO)
+		return vhost_virtqueue_disable_cb_mmio(vq);
+}
+EXPORT_SYMBOL_GPL(vhost_virtqueue_disable_cb);
+
+/**
+ * vhost_virtqueue_enable_cb_mmio() - Write to used ring in virtio accessed
+ *   using MMIO to enable notification
+ * @vq: vhost_virtqueue for which callbacks have to be enabled
+ *
+ * Write to used ring in virtio accessed using MMIO to enable notification
+ * to the vhost virtqueue.
+ */
+static bool vhost_virtqueue_enable_cb_mmio(struct vhost_virtqueue *vq)
+{
+	struct vringh *vringh;
+
+	vringh = &vq->vringh;
+	return vringh_notify_enable_mmio(vringh);
+}
+
+/**
+ * vhost_virtqueue_enable_cb() - Write to used ring in virtio to enable
+ *   notification
+ * @vq: vhost_virtqueue for which callbacks have to be enabled
+ *
+ * Wrapper to write to used ring in virtio to enable notification to the
+ * vhost virtqueue.
+ */
+bool vhost_virtqueue_enable_cb(struct vhost_virtqueue *vq)
+{
+	enum vhost_type type;
+
+	type = vq->type;
+
+	/* TODO: Add support for other VHOST TYPES */
+	if (type == VHOST_TYPE_MMIO)
+		return vhost_virtqueue_enable_cb_mmio(vq);
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(vhost_virtqueue_enable_cb);
+
+/**
+ * vhost_virtqueue_notify() - Send notification to the remote virtqueue
+ * @vq: vhost_virtqueue that sends the notification
+ *
+ * Invokes ->notify() callback to send notification to the remote virtqueue.
+ */
+void vhost_virtqueue_notify(struct vhost_virtqueue *vq)
+{
+	if (!vq->notify)
+		return;
+
+	vq->notify(vq);
+}
+EXPORT_SYMBOL_GPL(vhost_virtqueue_notify);
+
+/**
+ * vhost_virtqueue_kick_mmio() - Check if the remote virtqueue has enabled
+ *   notification (by reading available ring in virtio accessed using MMIO)
+ *   before sending notification
+ * @vq: vhost_virtqueue that sends the notification
+ *
+ * Check if the remote virtqueue has enabled notification (by reading available
+ * ring in virtio accessed using MMIO) and then invoke vhost_virtqueue_notify()
+ * to send notification to the remote virtqueue.
+ */
+static void vhost_virtqueue_kick_mmio(struct vhost_virtqueue *vq)
+{
+	if (vringh_need_notify_mmio(&vq->vringh))
+		vhost_virtqueue_notify(vq);
+}
+
+/**
+ * vhost_virtqueue_kick() - Check if the remote virtqueue has enabled
+ *   notification before sending notification
+ * @vq: vhost_virtqueue that sends the notification
+ *
+ * Wrapper to send notification to the remote virtqueue using
+ * vhost_virtqueue_kick_mmio() that checks if the remote virtqueue has
+ * enabled notification before sending the notification.
+ */
+void vhost_virtqueue_kick(struct vhost_virtqueue *vq)
+{
+	enum vhost_type type;
+
+	type = vq->type;
+
+	/* TODO: Add support for other VHOST TYPES */
+	if (type == VHOST_TYPE_MMIO)
+		return vhost_virtqueue_kick_mmio(vq);
+}
+EXPORT_SYMBOL_GPL(vhost_virtqueue_kick);
+
+/**
+ * vhost_virtqueue_callback() - Invoke vhost virtqueue callback provided by
+ *   vhost client driver
+ * @vq: vhost_virtqueue for which the callback is invoked
+ *
+ * Invoked by the driver that creates vhost device when the remote virtio
+ * driver sends notification to this virtqueue.
+ */
+void vhost_virtqueue_callback(struct vhost_virtqueue *vq)
+{
+	if (!vq->callback)
+		return;
+
+	vq->callback(vq);
+}
+EXPORT_SYMBOL_GPL(vhost_virtqueue_callback);
+
+/**
+ * vhost_virtqueue_get_outbuf_mmio() - Get the output buffer address by reading
+ *   virtqueue descriptor accessed using MMIO
+ * @vq: vhost_virtqueue used to access the descriptor
+ * @head: head index for passing to vhost_virtqueue_put_buf()
+ * @len: Length of the buffer
+ *
+ * Get the output buffer address by reading virtqueue descriptor accessed using
+ * MMIO.
+ */
+static u64 vhost_virtqueue_get_outbuf_mmio(struct vhost_virtqueue *vq,
+					   u16 *head, int *len)
+{
+	struct vringh_mmiov wiov;
+	struct mmiovec *mmiovec;
+	struct vringh *vringh;
+	int desc;
+
+	vringh = &vq->vringh;
+	vringh_mmiov_init(&wiov, NULL, 0);
+
+	desc = vringh_getdesc_mmio(vringh, NULL, &wiov, head, GFP_KERNEL);
+	if (!desc)
+		return 0;
+	mmiovec = &wiov.iov[0];
+
+	*len = mmiovec->iov_len;
+	return mmiovec->iov_base;
+}
+
+/**
+ * vhost_virtqueue_get_outbuf() - Get the output buffer address by reading
+ *   virtqueue descriptor
+ * @vq: vhost_virtqueue used to access the descriptor
+ * @head: head index for passing to vhost_virtqueue_put_buf()
+ * @len: Length of the buffer
+ *
+ * Wrapper to get the output buffer address by reading virtqueue descriptor.
+ */
+u64 vhost_virtqueue_get_outbuf(struct vhost_virtqueue *vq, u16 *head, int *len)
+{
+	enum vhost_type type;
+
+	type = vq->type;
+
+	/* TODO: Add support for other VHOST TYPES */
+	if (type == VHOST_TYPE_MMIO)
+		return vhost_virtqueue_get_outbuf_mmio(vq, head, len);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vhost_virtqueue_get_outbuf);
+
+/**
+ * vhost_virtqueue_get_inbuf_mmio() - Get the input buffer address by reading
+ *   virtqueue descriptor accessed using MMIO
+ * @vq: vhost_virtqueue used to access the descriptor
+ * @head: Head index for passing to vhost_virtqueue_put_buf()
+ * @len: Length of the buffer
+ *
+ * Get the input buffer address by reading virtqueue descriptor accessed using
+ * MMIO.
+ */
+static u64 vhost_virtqueue_get_inbuf_mmio(struct vhost_virtqueue *vq,
+					  u16 *head, int *len)
+{
+	struct vringh_mmiov riov;
+	struct mmiovec *mmiovec;
+	struct vringh *vringh;
+	int desc;
+
+	vringh = &vq->vringh;
+	vringh_mmiov_init(&riov, NULL, 0);
+
+	desc = vringh_getdesc_mmio(vringh, &riov, NULL, head, GFP_KERNEL);
+	if (!desc)
+		return 0;
+
+	mmiovec = &riov.iov[0];
+
+	*len = mmiovec->iov_len;
+	return mmiovec->iov_base;
+}
+
+/**
+ * vhost_virtqueue_get_inbuf() - Get the input buffer address by reading
+ *   virtqueue descriptor
+ * @vq: vhost_virtqueue used to access the descriptor
+ * @head: head index for passing to vhost_virtqueue_put_buf()
+ * @len: Length of the buffer
+ *
+ * Wrapper to get the input buffer address by reading virtqueue descriptor.
+ */
+u64 vhost_virtqueue_get_inbuf(struct vhost_virtqueue *vq, u16 *head, int *len)
+{
+	enum vhost_type type;
+
+	type = vq->type;
+
+	/* TODO: Add support for other VHOST TYPES */
+	if (type == VHOST_TYPE_MMIO)
+		return vhost_virtqueue_get_inbuf_mmio(vq, head, len);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vhost_virtqueue_get_inbuf);
+
+/**
+ * vhost_virtqueue_put_buf_mmio() - Publish to the remote virtio (update
+ * used ring in virtio using MMIO) to indicate the buffer has been processed
+ * @vq: vhost_virtqueue used to update the used ring
+ * @head: Head index receive from vhost_virtqueue_get_*()
+ * @len: Length of the buffer
+ *
+ * Publish to the remote virtio (update used ring in virtio using MMIO) to
+ * indicate the buffer has been processed
+ */
+static void vhost_virtqueue_put_buf_mmio(struct vhost_virtqueue *vq,
+					 u16 head, int len)
+{
+	struct vringh *vringh;
+
+	vringh = &vq->vringh;
+
+	vringh_complete_mmio(vringh, head, len);
+}
+
+/**
+ * vhost_virtqueue_put_buf() - Publish to the remote virtio to indicate the
+ *   buffer has been processed
+ * @vq: vhost_virtqueue used to update the used ring
+ * @head: Head index receive from vhost_virtqueue_get_*()
+ * @len: Length of the buffer
+ *
+ * Wrapper to publish to the remote virtio to indicate the buffer has been
+ * processed.
+ */
+void vhost_virtqueue_put_buf(struct vhost_virtqueue *vq, u16 head, int len)
+{
+	enum vhost_type type;
+
+	type = vq->type;
+
+	/* TODO: Add support for other VHOST TYPES */
+	if (type == VHOST_TYPE_MMIO)
+		return vhost_virtqueue_put_buf_mmio(vq, head, len);
+}
+EXPORT_SYMBOL_GPL(vhost_virtqueue_put_buf);
+
 /**
  * vhost_create_vqs() - Invoke vhost_config_ops to create virtqueue
  * @vdev: Vhost device that provides create_vqs() callback to create virtqueue
diff --git a/include/linux/vhost.h b/include/linux/vhost.h
index b22a19c66109..8efb9829c1b1 100644
--- a/include/linux/vhost.h
+++ b/include/linux/vhost.h
@@ -10,6 +10,7 @@
 #include <linux/uio.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_ring.h>
+#include <linux/vringh.h>
 #include <linux/atomic.h>
 #include <linux/vhost_iotlb.h>
 #include <uapi/linux/vhost.h>
@@ -60,9 +61,20 @@ enum vhost_uaddr_type {
 	VHOST_NUM_ADDRS = 3,
 };
 
+enum vhost_type {
+	VHOST_TYPE_UNKNOWN,
+	VHOST_TYPE_USER,
+	VHOST_TYPE_KERN,
+	VHOST_TYPE_MMIO,
+};
+
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
+	enum vhost_type type;
+	struct vringh vringh;
+	void (*callback)(struct vhost_virtqueue *vq);
+	void (*notify)(struct vhost_virtqueue *vq);
 
 	/* The actual ring of buffers. */
 	struct mutex mutex;
@@ -235,6 +247,16 @@ u8 vhost_get_status(struct vhost_dev *vdev);
 
 int vhost_register_notifier(struct vhost_dev *vdev, struct notifier_block *nb);
 
+u64 vhost_virtqueue_get_outbuf(struct vhost_virtqueue *vq, u16 *head, int *len);
+u64 vhost_virtqueue_get_inbuf(struct vhost_virtqueue *vq, u16 *head, int *len);
+void vhost_virtqueue_put_buf(struct vhost_virtqueue *vq, u16 head, int len);
+
+void vhost_virtqueue_disable_cb(struct vhost_virtqueue *vq);
+bool vhost_virtqueue_enable_cb(struct vhost_virtqueue *vq);
+void vhost_virtqueue_notify(struct vhost_virtqueue *vq);
+void vhost_virtqueue_kick(struct vhost_virtqueue *vq);
+void vhost_virtqueue_callback(struct vhost_virtqueue *vq);
+
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
 		    int nvqs, int iov_limit, int weight, int byte_weight,
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51836B8CA9
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 10:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393381AbfITIYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 04:24:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390765AbfITIYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 04:24:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D963F7F743;
        Fri, 20 Sep 2019 08:24:31 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-88.pek2.redhat.com [10.72.12.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03A7A1001938;
        Fri, 20 Sep 2019 08:23:20 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        pmorel@linux.ibm.com, freude@linux.ibm.com, lingshan.zhu@intel.com,
        idos@mellanox.com, eperezma@redhat.com, lulu@redhat.com,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH V2 3/6] mdev: introduce virtio device and its device ops
Date:   Fri, 20 Sep 2019 16:20:47 +0800
Message-Id: <20190920082050.19352-4-jasowang@redhat.com>
In-Reply-To: <20190920082050.19352-1-jasowang@redhat.com>
References: <20190920082050.19352-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Fri, 20 Sep 2019 08:24:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements basic support for mdev driver that support
virtio transport for kernel driver.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vfio/mdev/mdev_core.c |   7 ++
 include/linux/mdev.h          |   3 +
 include/linux/virtio_mdev.h   | 141 ++++++++++++++++++++++++++++++++++
 3 files changed, 151 insertions(+)
 create mode 100644 include/linux/virtio_mdev.h

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index a02c256a3514..6d39caf96222 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -220,6 +220,13 @@ int mdev_register_vfio_device(struct device *dev,
 }
 EXPORT_SYMBOL(mdev_register_vfio_device);
 
+int mdev_register_virtio_device(struct device *dev,
+				const struct mdev_parent_ops *ops)
+{
+	return mdev_register_device(dev, ops, MDEV_ID_VIRTIO);
+}
+EXPORT_SYMBOL(mdev_register_virtio_device);
+
 /*
  * mdev_unregister_device : Unregister a parent device
  * @dev: device structure representing parent device.
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 99fdfd74433d..780150c61493 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -109,6 +109,8 @@ extern struct bus_type mdev_bus_type;
 
 int mdev_register_vfio_device(struct device *dev,
                               const struct mdev_parent_ops *ops);
+int mdev_register_virtio_device(struct device *dev,
+				const struct mdev_parent_ops *ops);
 void mdev_unregister_device(struct device *dev);
 
 int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
@@ -119,5 +121,6 @@ struct device *mdev_dev(struct mdev_device *mdev);
 struct mdev_device *mdev_from_dev(struct device *dev);
 
 #define MDEV_ID_VFIO 1 /* VFIO device */
+#define MDEV_ID_VIRTIO 2 /* Virtio Device */
 
 #endif /* MDEV_H */
diff --git a/include/linux/virtio_mdev.h b/include/linux/virtio_mdev.h
new file mode 100644
index 000000000000..003314a76f5b
--- /dev/null
+++ b/include/linux/virtio_mdev.h
@@ -0,0 +1,141 @@
+/*
+ * Virtio mediated device driver
+ *
+ * Copyright 2019, Red Hat Corp.
+ *     Author: Jason Wang <jasowang@redhat.com>
+ */
+#ifndef _LINUX_VIRTIO_MDEV_H
+#define _LINUX_VIRTIO_MDEV_H
+
+#include <linux/interrupt.h>
+#include <uapi/linux/vhost.h>
+
+#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
+
+struct virtio_mdev_callback {
+	irqreturn_t (*callback)(void *);
+	void *private;
+};
+
+/**
+ * struct vfio_mdev_parent_ops - Structure to be registered for each
+ * parent device to register the device to virtio-mdev module.
+ *
+ * @set_vq_address:		Set the address of virtqueue
+ *				@mdev: mediated device
+ *				@idx: virtqueue index
+ *				@desc_area: address of desc area
+ *				@driver_area: address of driver area
+ *				@device_area: address of device area
+ *				Returns integer: success (0) or error (< 0)
+ * @set_vq_num:		Set the size of virtqueue
+ *				@mdev: mediated device
+ *				@idx: virtqueue index
+ *				@num: the size of virtqueue
+ * @kick_vq:			Kick the virtqueue
+ *				@mdev: mediated device
+ *				@idx: virtqueue index
+ * @set_vq_cb:			Set the interrut calback function for a virtqueue
+ *				@mdev: mediated device
+ *				@idx: virtqueue index
+ *				@cb: virtio-mdev interrupt callback structure
+ * @set_vq_ready:		Set ready status for a virtqueue
+ *				@mdev: mediated device
+ *				@idx: virtqueue index
+ *				@ready: ready (true) not ready(false)
+ * @get_vq_ready:		Get ready status for a virtqueue
+ *				@mdev: mediated device
+ *				@idx: virtqueue index
+ *				Returns boolean: ready (true) or not (false)
+ * @set_vq_state:		Set the state for a virtqueue
+ *				@mdev: mediated device
+ *				@idx: virtqueue index
+ *				@state: virtqueue state (last_avail_idx)
+ *				Returns integer: success (0) or error (< 0)
+ * @get_vq_state:		Get the state for a virtqueue
+ *				@mdev: mediated device
+ *				@idx: virtqueue index
+ *				Returns virtqueue state (last_avail_idx)
+ * @get_vq_align:		Get the virtqueue align requirement
+ *				for the device
+ *				@mdev: mediated device
+ *				Returns virtqueue algin requirement
+ * @get_features:		Get virtio features supported by the device
+ *				@mdev: mediated device
+ *				Returns the features support by the
+ *				device
+ * @get_features:		Set virtio features supported by the driver
+ *				@mdev: mediated device
+ *				@features: feature support by the driver
+ *				Returns integer: success (0) or error (< 0)
+ * @set_config_cb:		Set the config interrupt callback
+ *				@mdev: mediated device
+ *				@cb: virtio-mdev interrupt callback structure
+ * @get_device_id:		Get virtio device id
+ *				@mdev: mediated device
+ *				Returns u32: virtio device id
+ * @get_vendor_id:		Get virtio vendor id
+ *				@mdev: mediated device
+ *				Returns u32: virtio vendor id
+ * @get_status:		Get the device status
+ *				@mdev: mediated device
+ *				Returns u8: virtio device status
+ * @set_status:		Set the device status
+ *				@mdev: mediated device
+ *				@status: virtio device status
+ * @get_config:		Read from device specific confiugration space
+ *				@mdev: mediated device
+ *				@offset: offset from the beginning of
+ *				configuration space
+ *				@buf: buffer used to read to
+ *				@len: the length to read from
+ *				configration space
+ * @set_config:		Write to device specific confiugration space
+ *				@mdev: mediated device
+ *				@offset: offset from the beginning of
+ *				configuration space
+ *				@buf: buffer used to write from
+ *				@len: the length to write to
+ *				configration space
+ * @get_version:		Get the version of virtio mdev device
+ *				@mdev: mediated device
+ *				Returns integer: version of the device
+ * @get_generation:		Get the device generaton
+ *				@mdev: mediated device
+ *				Returns u32: device generation
+ */
+struct virtio_mdev_parent_ops {
+	/* Virtqueue ops */
+	int (*set_vq_address)(struct mdev_device *mdev,
+			      u16 idx, u64 desc_area, u64 driver_area,
+			      u64 device_area);
+	void (*set_vq_num)(struct mdev_device *mdev, u16 idx, u32 num);
+	void (*kick_vq)(struct mdev_device *mdev, u16 idx);
+	void (*set_vq_cb)(struct mdev_device *mdev, u16 idx,
+			  struct virtio_mdev_callback *cb);
+	void (*set_vq_ready)(struct mdev_device *mdev, u16 idx, bool ready);
+	bool (*get_vq_ready)(struct mdev_device *mdev, u16 idx);
+	int (*set_vq_state)(struct mdev_device *mdev, u16 idx, u64 state);
+	u64 (*get_vq_state)(struct mdev_device *mdev, u16 idx);
+
+        /* Device ops */
+	u16 (*get_vq_align)(struct mdev_device *mdev);
+	u64 (*get_features)(struct mdev_device *mdev);
+	int (*set_features)(struct mdev_device *mdev, u64 features);
+	void (*set_config_cb)(struct mdev_device *mdev,
+			      struct virtio_mdev_callback *cb);
+	u16 (*get_queue_max)(struct mdev_device *mdev);
+	u32 (*get_device_id)(struct mdev_device *mdev);
+	u32 (*get_vendor_id)(struct mdev_device *mdev);
+	u8 (*get_status)(struct mdev_device *mdev);
+	void (*set_status)(struct mdev_device *mdev, u8 status);
+	void (*get_config)(struct mdev_device *mdev, unsigned offset,
+			   void *buf, unsigned len);
+	void (*set_config)(struct mdev_device *mdev, unsigned offset,
+			   const void *buf, unsigned len);
+	int (*get_version)(struct mdev_device *mdev);
+	u32 (*get_generation)(struct mdev_device *mdev);
+};
+
+#endif
+
-- 
2.19.1


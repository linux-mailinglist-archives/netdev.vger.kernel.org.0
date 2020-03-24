Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7493190455
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgCXEQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:16:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:45411 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727303AbgCXEQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585023381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JNDs3i6Rs6Baajz8YAZPug7LLDJZBheu6XHWFJJkHKQ=;
        b=KS90LPwPMJYY2kS9FMGz00sYni43K5LYtmbevHeoCh86NW2jUnftmDydvGX0bwXJfPkO3F
        7lY+KcRumpSo5iiqcftEPf0AZTu395guv7Kc6jWqyUqrbordM5AStXpWqDi1bLMLP/ZmpV
        hDLIAdpFeNYRxD1Ok9hCajcmIUl6hYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-qLI6ijbUM7KutJRI7GovrA-1; Tue, 24 Mar 2020 00:16:19 -0400
X-MC-Unique: qLI6ijbUM7KutJRI7GovrA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A120800D53;
        Tue, 24 Mar 2020 04:16:16 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-216.pek2.redhat.com [10.72.13.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA06D10002A9;
        Tue, 24 Mar 2020 04:16:00 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V7 4/8] vDPA: introduce vDPA bus
Date:   Tue, 24 Mar 2020 12:14:54 +0800
Message-Id: <20200324041458.27384-5-jasowang@redhat.com>
In-Reply-To: <20200324041458.27384-1-jasowang@redhat.com>
References: <20200324041458.27384-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA device is a device that uses a datapath which complies with the
virtio specifications with vendor specific control path. vDPA devices
can be both physically located on the hardware or emulated by
software. vDPA hardware devices are usually implemented through PCIE
with the following types:

- PF (Physical Function) - A single Physical Function
- VF (Virtual Function) - Device that supports single root I/O
  virtualization (SR-IOV). Its Virtual Function (VF) represents a
  virtualized instance of the device that can be assigned to different
  partitions
- ADI (Assignable Device Interface) and its equivalents - With
  technologies such as Intel Scalable IOV, a virtual device (VDEV)
  composed by host OS utilizing one or more ADIs. Or its equivalent
  like SF (Sub function) from Mellanox.

From a driver's perspective, depends on how and where the DMA
translation is done, vDPA devices are split into two types:

- Platform specific DMA translation - From the driver's perspective,
  the device can be used on a platform where device access to data in
  memory is limited and/or translated. An example is a PCIE vDPA whose
  DMA request was tagged via a bus (e.g PCIE) specific way. DMA
  translation and protection are done at PCIE bus IOMMU level.
- Device specific DMA translation - The device implements DMA
  isolation and protection through its own logic. An example is a vDPA
  device which uses on-chip IOMMU.

To hide the differences and complexity of the above types for a vDPA
device/IOMMU options and in order to present a generic virtio device
to the upper layer, a device agnostic framework is required.

This patch introduces a software vDPA bus which abstracts the
common attributes of vDPA device, vDPA bus driver and the
communication method (vdpa_config_ops) between the vDPA device
abstraction and the vDPA bus driver. This allows multiple types of
drivers to be used for vDPA device like the virtio_vdpa and vhost_vdpa
driver to operate on the bus and allow vDPA device could be used by
either kernel virtio driver or userspace vhost drivers as:

   virtio drivers  vhost drivers
          |             |
    [virtio bus]   [vhost uAPI]
          |             |
   virtio device   vhost device
   virtio_vdpa drv vhost_vdpa drv
             \       /
            [vDPA bus]
                 |
            vDPA device
            hardware drv
                 |
            [hardware bus]
                 |
            vDPA hardware

With the abstraction of vDPA bus and vDPA bus operations, the
difference and complexity of the under layer hardware is hidden from
upper layer. The vDPA bus drivers on top can use a unified
vdpa_config_ops to control different types of vDPA device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 MAINTAINERS                  |   1 +
 drivers/virtio/Kconfig       |   2 +
 drivers/virtio/Makefile      |   1 +
 drivers/virtio/vdpa/Kconfig  |   7 +
 drivers/virtio/vdpa/Makefile |   2 +
 drivers/virtio/vdpa/vdpa.c   | 180 +++++++++++++++++++++++++
 include/linux/vdpa.h         | 247 +++++++++++++++++++++++++++++++++++
 7 files changed, 440 insertions(+)
 create mode 100644 drivers/virtio/vdpa/Kconfig
 create mode 100644 drivers/virtio/vdpa/Makefile
 create mode 100644 drivers/virtio/vdpa/vdpa.c
 create mode 100644 include/linux/vdpa.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0fb645b5a7df..2b8d9fa38d9a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17701,6 +17701,7 @@ F:	tools/virtio/
 F:	drivers/net/virtio_net.c
 F:	drivers/block/virtio_blk.c
 F:	include/linux/virtio*.h
+F:	include/linux/vdpa.h
 F:	include/uapi/linux/virtio_*.h
 F:	drivers/crypto/virtio/
 F:	mm/balloon_compaction.c
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 078615cf2afc..9c4fdb64d9ac 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -96,3 +96,5 @@ config VIRTIO_MMIO_CMDLINE_DEVICES
 	 If unsure, say 'N'.
=20
 endif # VIRTIO_MENU
+
+source "drivers/virtio/vdpa/Kconfig"
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 3a2b5c5dcf46..fdf5eacd0d0a 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -6,3 +6,4 @@ virtio_pci-y :=3D virtio_pci_modern.o virtio_pci_common.o
 virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) +=3D virtio_pci_legacy.o
 obj-$(CONFIG_VIRTIO_BALLOON) +=3D virtio_balloon.o
 obj-$(CONFIG_VIRTIO_INPUT) +=3D virtio_input.o
+obj-$(CONFIG_VDPA) +=3D vdpa/
diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
new file mode 100644
index 000000000000..351617723d12
--- /dev/null
+++ b/drivers/virtio/vdpa/Kconfig
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config VDPA
+	tristate
+	help
+	  Enable this module to support vDPA device that uses a
+	  datapath which complies with virtio specifications with
+	  vendor specific control path.
diff --git a/drivers/virtio/vdpa/Makefile b/drivers/virtio/vdpa/Makefile
new file mode 100644
index 000000000000..ee6a35e8a4fb
--- /dev/null
+++ b/drivers/virtio/vdpa/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_VDPA) +=3D vdpa.o
diff --git a/drivers/virtio/vdpa/vdpa.c b/drivers/virtio/vdpa/vdpa.c
new file mode 100644
index 000000000000..e9ed6a2b635b
--- /dev/null
+++ b/drivers/virtio/vdpa/vdpa.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vDPA bus.
+ *
+ * Copyright (c) 2020, Red Hat. All rights reserved.
+ *     Author: Jason Wang <jasowang@redhat.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/vdpa.h>
+
+static DEFINE_IDA(vdpa_index_ida);
+
+static int vdpa_dev_probe(struct device *d)
+{
+	struct vdpa_device *vdev =3D dev_to_vdpa(d);
+	struct vdpa_driver *drv =3D drv_to_vdpa(vdev->dev.driver);
+	int ret =3D 0;
+
+	if (drv && drv->probe)
+		ret =3D drv->probe(vdev);
+
+	return ret;
+}
+
+static int vdpa_dev_remove(struct device *d)
+{
+	struct vdpa_device *vdev =3D dev_to_vdpa(d);
+	struct vdpa_driver *drv =3D drv_to_vdpa(vdev->dev.driver);
+
+	if (drv && drv->remove)
+		drv->remove(vdev);
+
+	return 0;
+}
+
+static struct bus_type vdpa_bus =3D {
+	.name  =3D "vdpa",
+	.probe =3D vdpa_dev_probe,
+	.remove =3D vdpa_dev_remove,
+};
+
+static void vdpa_release_dev(struct device *d)
+{
+	struct vdpa_device *vdev =3D dev_to_vdpa(d);
+	const struct vdpa_config_ops *ops =3D vdev->config;
+
+	if (ops->free)
+		ops->free(vdev);
+
+	ida_simple_remove(&vdpa_index_ida, vdev->index);
+	kfree(vdev);
+}
+
+/**
+ * __vdpa_alloc_device - allocate and initilaize a vDPA device
+ * This allows driver to some prepartion after device is
+ * initialized but before registered.
+ * @parent: the parent device
+ * @config: the bus operations that is supported by this device
+ * @size: size of the parent structure that contains private data
+ *
+ * Drvier should use vdap_alloc_device() wrapper macro instead of
+ * using this directly.
+ *
+ * Returns an error when parent/config/dma_dev is not set or fail to get
+ * ida.
+ */
+struct vdpa_device *__vdpa_alloc_device(struct device *parent,
+					const struct vdpa_config_ops *config,
+					size_t size)
+{
+	struct vdpa_device *vdev;
+	int err =3D -EINVAL;
+
+	if (!config)
+		goto err;
+
+	if (!!config->dma_map !=3D !!config->dma_unmap)
+		goto err;
+
+	err =3D -ENOMEM;
+	vdev =3D kzalloc(size, GFP_KERNEL);
+	if (!vdev)
+		goto err;
+
+	err =3D ida_simple_get(&vdpa_index_ida, 0, 0, GFP_KERNEL);
+	if (err < 0)
+		goto err_ida;
+
+	vdev->dev.bus =3D &vdpa_bus;
+	vdev->dev.parent =3D parent;
+	vdev->dev.release =3D vdpa_release_dev;
+	vdev->index =3D err;
+	vdev->config =3D config;
+
+	err =3D dev_set_name(&vdev->dev, "vdpa%u", vdev->index);
+	if (err)
+		goto err_name;
+
+	device_initialize(&vdev->dev);
+
+	return vdev;
+
+err_name:
+	ida_simple_remove(&vdpa_index_ida, vdev->index);
+err_ida:
+	kfree(vdev);
+err:
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(__vdpa_alloc_device);
+
+/**
+ * vdpa_register_device - register a vDPA device
+ * Callers must have a succeed call of vdpa_init_device() before.
+ * @vdev: the vdpa device to be registered to vDPA bus
+ *
+ * Returns an error when fail to add to vDPA bus
+ */
+int vdpa_register_device(struct vdpa_device *vdev)
+{
+	return device_add(&vdev->dev);
+}
+EXPORT_SYMBOL_GPL(vdpa_register_device);
+
+/**
+ * vdpa_unregister_device - unregister a vDPA device
+ * @vdev: the vdpa device to be unregisted from vDPA bus
+ */
+void vdpa_unregister_device(struct vdpa_device *vdev)
+{
+	device_unregister(&vdev->dev);
+}
+EXPORT_SYMBOL_GPL(vdpa_unregister_device);
+
+/**
+ * __vdpa_register_driver - register a vDPA device driver
+ * @drv: the vdpa device driver to be registered
+ * @owner: module owner of the driver
+ *
+ * Returns an err when fail to do the registration
+ */
+int __vdpa_register_driver(struct vdpa_driver *drv, struct module *owner=
)
+{
+	drv->driver.bus =3D &vdpa_bus;
+	drv->driver.owner =3D owner;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(__vdpa_register_driver);
+
+/**
+ * vdpa_unregister_driver - unregister a vDPA device driver
+ * @drv: the vdpa device driver to be unregistered
+ */
+void vdpa_unregister_driver(struct vdpa_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(vdpa_unregister_driver);
+
+static int vdpa_init(void)
+{
+	return bus_register(&vdpa_bus);
+}
+
+static void __exit vdpa_exit(void)
+{
+	bus_unregister(&vdpa_bus);
+	ida_destroy(&vdpa_index_ida);
+}
+core_initcall(vdpa_init);
+module_exit(vdpa_exit);
+
+MODULE_AUTHOR("Jason Wang <jasowang@redhat.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
new file mode 100644
index 000000000000..4ad22e5f5191
--- /dev/null
+++ b/include/linux/vdpa.h
@@ -0,0 +1,247 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VDPA_H
+#define _LINUX_VDPA_H
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/vhost_iotlb.h>
+
+/**
+ * vDPA callback definition.
+ * @callback: interrupt callback function
+ * @private: the data passed to the callback function
+ */
+struct vdpa_callback {
+	irqreturn_t (*callback)(void *data);
+	void *private;
+};
+
+/**
+ * vDPA device - representation of a vDPA device
+ * @dev: underlying device
+ * @dma_dev: the actual device that is performing DMA
+ * @config: the configuration ops for this device.
+ * @index: device index
+ */
+struct vdpa_device {
+	struct device dev;
+	struct device *dma_dev;
+	const struct vdpa_config_ops *config;
+	unsigned int index;
+};
+
+/**
+ * vDPA_config_ops - operations for configuring a vDPA device.
+ * Note: vDPA device drivers are required to implement all of the
+ * operations unless it is mentioned to be optional in the following
+ * list.
+ *
+ * @set_vq_address:		Set the address of virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				@desc_area: address of desc area
+ *				@driver_area: address of driver area
+ *				@device_area: address of device area
+ *				Returns integer: success (0) or error (< 0)
+ * @set_vq_num:			Set the size of virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				@num: the size of virtqueue
+ * @kick_vq:			Kick the virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ * @set_vq_cb:			Set the interrupt callback function for
+ *				a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				@cb: virtio-vdev interrupt callback structure
+ * @set_vq_ready:		Set ready status for a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				@ready: ready (true) not ready(false)
+ * @get_vq_ready:		Get ready status for a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns boolean: ready (true) or not (false)
+ * @set_vq_state:		Set the state for a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				@state: virtqueue state (last_avail_idx)
+ *				Returns integer: success (0) or error (< 0)
+ * @get_vq_state:		Get the state for a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns virtqueue state (last_avail_idx)
+ * @get_vq_align:		Get the virtqueue align requirement
+ *				for the device
+ *				@vdev: vdpa device
+ *				Returns virtqueue algin requirement
+ * @get_features:		Get virtio features supported by the device
+ *				@vdev: vdpa device
+ *				Returns the virtio features support by the
+ *				device
+ * @set_features:		Set virtio features supported by the driver
+ *				@vdev: vdpa device
+ *				@features: feature support by the driver
+ *				Returns integer: success (0) or error (< 0)
+ * @set_config_cb:		Set the config interrupt callback
+ *				@vdev: vdpa device
+ *				@cb: virtio-vdev interrupt callback structure
+ * @get_vq_num_max:		Get the max size of virtqueue
+ *				@vdev: vdpa device
+ *				Returns u16: max size of virtqueue
+ * @get_device_id:		Get virtio device id
+ *				@vdev: vdpa device
+ *				Returns u32: virtio device id
+ * @get_vendor_id:		Get id for the vendor that provides this device
+ *				@vdev: vdpa device
+ *				Returns u32: virtio vendor id
+ * @get_status:			Get the device status
+ *				@vdev: vdpa device
+ *				Returns u8: virtio device status
+ * @set_status:			Set the device status
+ *				@vdev: vdpa device
+ *				@status: virtio device status
+ * @get_config:			Read from device specific configuration space
+ *				@vdev: vdpa device
+ *				@offset: offset from the beginning of
+ *				configuration space
+ *				@buf: buffer used to read to
+ *				@len: the length to read from
+ *				configuration space
+ * @set_config:			Write to device specific configuration space
+ *				@vdev: vdpa device
+ *				@offset: offset from the beginning of
+ *				configuration space
+ *				@buf: buffer used to write from
+ *				@len: the length to write to
+ *				configuration space
+ * @get_generation:		Get device config generation (optional)
+ *				@vdev: vdpa device
+ *				Returns u32: device generation
+ * @set_map:			Set device memory mapping (optional)
+ *				and only needed for device that using
+ *				device specific DMA translation
+ *				(on-chip IOMMU)
+ *				@vdev: vdpa device
+ *				@iotlb: vhost memory mapping to be
+ *				used by the vDPA
+ *				Returns integer: success (0) or error (< 0)
+ * @dma_map:			Map an area of PA to IOVA
+ *				@vdev: vdpa device
+ *				@iova: iova to be mapped
+ *				@size: size of the area
+ *				@pa: physical address for the map
+ *				@perm: device access permission (VHOST_MAP_XX)
+ *				Returns integer: success (0) or error (< 0)
+ * @dma_unmap:			Unmap an area of IOVA
+ *				@vdev: vdpa device
+ *				@iova: iova to be unmapped
+ *				@size: size of the area
+ *				Returns integer: success (0) or error (< 0)
+ * @free:			Free resources that belongs to vDPA
+ *				@vdev: vdpa device
+ */
+struct vdpa_config_ops {
+	/* Virtqueue ops */
+	int (*set_vq_address)(struct vdpa_device *vdev,
+			      u16 idx, u64 desc_area, u64 driver_area,
+			      u64 device_area);
+	void (*set_vq_num)(struct vdpa_device *vdev, u16 idx, u32 num);
+	void (*kick_vq)(struct vdpa_device *vdev, u16 idx);
+	void (*set_vq_cb)(struct vdpa_device *vdev, u16 idx,
+			  struct vdpa_callback *cb);
+	void (*set_vq_ready)(struct vdpa_device *vdev, u16 idx, bool ready);
+	bool (*get_vq_ready)(struct vdpa_device *vdev, u16 idx);
+	int (*set_vq_state)(struct vdpa_device *vdev, u16 idx, u64 state);
+	u64 (*get_vq_state)(struct vdpa_device *vdev, u16 idx);
+
+	/* Device ops */
+	u16 (*get_vq_align)(struct vdpa_device *vdev);
+	u64 (*get_features)(struct vdpa_device *vdev);
+	int (*set_features)(struct vdpa_device *vdev, u64 features);
+	void (*set_config_cb)(struct vdpa_device *vdev,
+			      struct vdpa_callback *cb);
+	u16 (*get_vq_num_max)(struct vdpa_device *vdev);
+	u32 (*get_device_id)(struct vdpa_device *vdev);
+	u32 (*get_vendor_id)(struct vdpa_device *vdev);
+	u8 (*get_status)(struct vdpa_device *vdev);
+	void (*set_status)(struct vdpa_device *vdev, u8 status);
+	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
+			   void *buf, unsigned int len);
+	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
+			   const void *buf, unsigned int len);
+	u32 (*get_generation)(struct vdpa_device *vdev);
+
+	/* DMA ops */
+	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
+	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
+		       u64 pa, u32 perm);
+	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
+
+	/* Free device resources */
+	void (*free)(struct vdpa_device *vdev);
+};
+
+struct vdpa_device *__vdpa_alloc_device(struct device *parent,
+					const struct vdpa_config_ops *config,
+					size_t size);
+
+#define vdpa_alloc_device(dev_struct, member, parent, config)   \
+			  container_of(__vdpa_alloc_device( \
+				       parent, config, \
+				       sizeof(struct dev_struct) + \
+				       BUILD_BUG_ON_ZERO(offsetof( \
+				       struct dev_struct, member))), \
+				       struct dev_struct, member)
+
+int vdpa_register_device(struct vdpa_device *vdev);
+void vdpa_unregister_device(struct vdpa_device *vdev);
+
+/**
+ * vdpa_driver - operations for a vDPA driver
+ * @driver: underlying device driver
+ * @probe: the function to call when a device is found.  Returns 0 or -e=
rrno.
+ * @remove: the function to call when a device is removed.
+ */
+struct vdpa_driver {
+	struct device_driver driver;
+	int (*probe)(struct vdpa_device *vdev);
+	void (*remove)(struct vdpa_device *vdev);
+};
+
+#define vdpa_register_driver(drv) \
+	__vdpa_register_driver(drv, THIS_MODULE)
+int __vdpa_register_driver(struct vdpa_driver *drv, struct module *owner=
);
+void vdpa_unregister_driver(struct vdpa_driver *drv);
+
+#define module_vdpa_driver(__vdpa_driver) \
+	module_driver(__vdpa_driver, vdpa_register_driver,	\
+		      vdpa_unregister_driver)
+
+static inline struct vdpa_driver *drv_to_vdpa(struct device_driver *driv=
er)
+{
+	return container_of(driver, struct vdpa_driver, driver);
+}
+
+static inline struct vdpa_device *dev_to_vdpa(struct device *_dev)
+{
+	return container_of(_dev, struct vdpa_device, dev);
+}
+
+static inline void *vdpa_get_drvdata(const struct vdpa_device *vdev)
+{
+	return dev_get_drvdata(&vdev->dev);
+}
+
+static inline void vdpa_set_drvdata(struct vdpa_device *vdev, void *data=
)
+{
+	dev_set_drvdata(&vdev->dev, data);
+}
+
+static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
+{
+	return vdev->dma_dev;
+}
+#endif /* _LINUX_VDPA_H */
--=20
2.20.1


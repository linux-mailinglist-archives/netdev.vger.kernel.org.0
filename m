Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD110211E0F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgGBIWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:22:17 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59364 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgGBIWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:22:13 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628M2Op081717;
        Thu, 2 Jul 2020 03:22:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678122;
        bh=+aGJiU5V4G+i0lcwnv8aYxc6DjyYC/equHpyXkZ20Wk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=XSyOgQSElhUwnW2/1xSvHQA9tvtPgssdIiW9G1W3QtCRYlGnb7azt1GGTaN8xwU9m
         nSSRfg9ajCMpfZlSJA2UJyL64XdQnIcWCuPVlYVK5Ef1aFxdLe0VeX82iX6Ycs9uPi
         BO0073wwyl3CLiCxhUFW4ZKCOpto6QSAh7g43W2g=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628M21U065272
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:22:02 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:22:01 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:22:02 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYE006145;
        Thu, 2 Jul 2020 03:21:56 -0500
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
Subject: [RFC PATCH 02/22] vhost: Introduce standard Linux driver model in VHOST
Date:   Thu, 2 Jul 2020 13:51:23 +0530
Message-ID: <20200702082143.25259-3-kishon@ti.com>
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

Introduce standard driver model in VHOST. This will facilitate using
multiple VHOST drivers (like net, scsi etc.,) over different VHOST
devices using MMIO (like PCIe or NTB), using kernel pointers (like
platform devices) or using userspace pointers.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/vhost/net.c                      |   3 +-
 drivers/vhost/scsi.c                     |   2 +-
 drivers/vhost/test.c                     |   3 +-
 drivers/vhost/vdpa.c                     |   2 +-
 drivers/vhost/vhost.c                    | 157 ++++++++++++++++++++++-
 drivers/vhost/vsock.c                    |   2 +-
 include/linux/mod_devicetable.h          |   6 +
 {drivers/vhost => include/linux}/vhost.h |  22 +++-
 tools/virtio/virtio_test.c               |   2 +-
 9 files changed, 190 insertions(+), 9 deletions(-)
 rename {drivers/vhost => include/linux}/vhost.h (93%)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 437126219116..3c57c345cbfd 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/sched/clock.h>
 #include <linux/sched/signal.h>
+#include <linux/vhost.h>
 #include <linux/vmalloc.h>
 
 #include <linux/net.h>
@@ -33,7 +34,7 @@
 #include <net/sock.h>
 #include <net/xdp.h>
 
-#include "vhost.h"
+#include <uapi/linux/vhost.h>
 
 static int experimental_zcopytx = 0;
 module_param(experimental_zcopytx, int, 0444);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f5138379659e..06898b7ce7dd 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -47,7 +47,7 @@
 #include <linux/llist.h>
 #include <linux/bitmap.h>
 
-#include "vhost.h"
+#include <uapi/linux/vhost.h>
 
 #define VHOST_SCSI_VERSION  "v0.1"
 #define VHOST_SCSI_NAMELEN 256
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 6518b48c0633..07508526182f 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -14,9 +14,10 @@
 #include <linux/workqueue.h>
 #include <linux/file.h>
 #include <linux/slab.h>
+#include <linux/vhost.h>
+#include <uapi/linux/vhost.h>
 
 #include "test.h"
-#include "vhost.h"
 
 /* Max number of bytes transferred before requeueing the job.
  * Using this limit prevents one virtqueue from starving others. */
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 0968361e3b77..61d90100db89 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -22,7 +22,7 @@
 #include <linux/vhost.h>
 #include <linux/virtio_net.h>
 
-#include "vhost.h"
+#include <uapi/linux/vhost.h>
 
 enum {
 	VHOST_VDPA_FEATURES =
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3c2633fb519d..fa2bc6e68be2 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -32,8 +32,6 @@
 #include <linux/nospec.h>
 #include <linux/kcov.h>
 
-#include "vhost.h"
-
 static ushort max_mem_regions = 64;
 module_param(max_mem_regions, ushort, 0444);
 MODULE_PARM_DESC(max_mem_regions,
@@ -43,6 +41,9 @@ module_param(max_iotlb_entries, int, 0444);
 MODULE_PARM_DESC(max_iotlb_entries,
 	"Maximum number of iotlb entries. (default: 2048)");
 
+static DEFINE_IDA(vhost_index_ida);
+static DEFINE_MUTEX(vhost_index_mutex);
+
 enum {
 	VHOST_MEMORY_F_LOG = 0x1,
 };
@@ -2557,14 +2558,166 @@ struct vhost_msg_node *vhost_dequeue_msg(struct vhost_dev *dev,
 }
 EXPORT_SYMBOL_GPL(vhost_dequeue_msg);
 
+static inline int vhost_id_match(const struct vhost_dev *vdev,
+				 const struct vhost_device_id *id)
+{
+	if (id->device != vdev->id.device && id->device != VIRTIO_DEV_ANY_ID)
+		return 0;
+
+	return id->vendor == VIRTIO_DEV_ANY_ID || id->vendor == vdev->id.vendor;
+}
+
+static int vhost_dev_match(struct device *dev, struct device_driver *drv)
+{
+	struct vhost_driver *driver = to_vhost_driver(drv);
+	struct vhost_dev *vdev = to_vhost_dev(dev);
+	const struct vhost_device_id *ids;
+	int i;
+
+	ids = driver->id_table;
+	for (i = 0; ids[i].device; i++)
+		if (vhost_id_match(vdev, &ids[i]))
+			return 1;
+
+	return 0;
+}
+
+static int vhost_dev_probe(struct device *dev)
+{
+	struct vhost_driver *driver = to_vhost_driver(dev->driver);
+	struct vhost_dev *vdev = to_vhost_dev(dev);
+
+	if (!driver->probe)
+		return -ENODEV;
+
+	vdev->driver = driver;
+
+	return driver->probe(vdev);
+}
+
+static int vhost_dev_remove(struct device *dev)
+{
+	struct vhost_driver *driver = to_vhost_driver(dev->driver);
+	struct vhost_dev *vdev = to_vhost_dev(dev);
+	int ret = 0;
+
+	if (driver->remove)
+		ret = driver->remove(vdev);
+	vdev->driver = NULL;
+
+	return ret;
+}
+
+static struct bus_type vhost_bus_type = {
+	.name  = "vhost",
+	.match = vhost_dev_match,
+	.probe = vhost_dev_probe,
+	.remove = vhost_dev_remove,
+};
+
+/**
+ * vhost_register_driver() - Register a vhost driver
+ * @driver: Vhost driver that has to be registered
+ *
+ * Register a vhost driver.
+ */
+int vhost_register_driver(struct vhost_driver *driver)
+{
+	int ret;
+
+	driver->driver.bus = &vhost_bus_type;
+
+	ret = driver_register(&driver->driver);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vhost_register_driver);
+
+/**
+ * vhost_unregister_driver() - Unregister a vhost driver
+ * @driver: Vhost driver that has to be un-registered
+ *
+ * Unregister a vhost driver.
+ */
+void vhost_unregister_driver(struct vhost_driver *driver)
+{
+	driver_unregister(&driver->driver);
+}
+EXPORT_SYMBOL_GPL(vhost_unregister_driver);
+
+/**
+ * vhost_register_device() - Register vhost device
+ * @vdev: Vhost device that has to be registered
+ *
+ * Allocate a ID and register vhost device.
+ */
+int vhost_register_device(struct vhost_dev *vdev)
+{
+	struct device *dev = &vdev->dev;
+	int ret;
+
+	mutex_lock(&vhost_index_mutex);
+	ret = ida_simple_get(&vhost_index_ida, 0, 0, GFP_KERNEL);
+	mutex_unlock(&vhost_index_mutex);
+	if (ret < 0)
+		return ret;
+
+	vdev->index = ret;
+	dev->bus = &vhost_bus_type;
+	device_initialize(dev);
+
+	dev_set_name(dev, "vhost%u", ret);
+
+	ret = device_add(dev);
+	if (ret) {
+		put_device(dev);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	mutex_lock(&vhost_index_mutex);
+	ida_simple_remove(&vhost_index_ida, vdev->index);
+	mutex_unlock(&vhost_index_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_register_device);
+
+/**
+ * vhost_unregister_device() - Un-register vhost device
+ * @vdev: Vhost device that has to be un-registered
+ *
+ * Un-register vhost device and free the allocated ID.
+ */
+void vhost_unregister_device(struct vhost_dev *vdev)
+{
+	device_unregister(&vdev->dev);
+	mutex_lock(&vhost_index_mutex);
+	ida_simple_remove(&vhost_index_ida, vdev->index);
+	mutex_unlock(&vhost_index_mutex);
+}
+EXPORT_SYMBOL_GPL(vhost_unregister_device);
 
 static int __init vhost_init(void)
 {
+	int ret;
+
+	ret = bus_register(&vhost_bus_type);
+	if (ret) {
+		pr_err("failed to register vhost bus --> %d\n", ret);
+		return ret;
+	}
+
 	return 0;
 }
 
 static void __exit vhost_exit(void)
 {
+	bus_unregister(&vhost_bus_type);
 }
 
 module_init(vhost_init);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 8317ad026e3d..5753048b7405 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -17,7 +17,7 @@
 #include <linux/hashtable.h>
 
 #include <net/af_vsock.h>
-#include "vhost.h"
+#include <uapi/linux/vhost.h>
 
 #define VHOST_VSOCK_DEFAULT_HOST_CID	2
 /* Max number of bytes transferred before requeueing the job.
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 8d764aab29de..c7df018989e3 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -430,6 +430,12 @@ struct virtio_device_id {
 };
 #define VIRTIO_DEV_ANY_ID	0xffffffff
 
+/* VHOST */
+struct vhost_device_id {
+	__u32 device;
+	__u32 vendor;
+};
+
 /*
  * For Hyper-V devices we use the device guid as the id.
  */
diff --git a/drivers/vhost/vhost.h b/include/linux/vhost.h
similarity index 93%
rename from drivers/vhost/vhost.h
rename to include/linux/vhost.h
index 5d1d00363e79..16c374a8fa12 100644
--- a/drivers/vhost/vhost.h
+++ b/include/linux/vhost.h
@@ -3,7 +3,6 @@
 #define _VHOST_H
 
 #include <linux/eventfd.h>
-#include <linux/vhost.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
@@ -13,6 +12,7 @@
 #include <linux/virtio_ring.h>
 #include <linux/atomic.h>
 #include <linux/vhost_iotlb.h>
+#include <uapi/linux/vhost.h>
 
 struct vhost_work;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
@@ -135,7 +135,20 @@ struct vhost_msg_node {
   struct list_head node;
 };
 
+struct vhost_driver {
+	struct device_driver driver;
+	struct vhost_device_id *id_table;
+	int (*probe)(struct vhost_dev *dev);
+	int (*remove)(struct vhost_dev *dev);
+};
+
+#define to_vhost_driver(drv) (container_of((drv), struct vhost_driver, driver))
+
 struct vhost_dev {
+	struct device dev;
+	struct vhost_driver *driver;
+	struct vhost_device_id id;
+	int index;
 	struct mm_struct *mm;
 	struct mutex mutex;
 	struct vhost_virtqueue **vqs;
@@ -158,6 +171,13 @@ struct vhost_dev {
 			   struct vhost_iotlb_msg *msg);
 };
 
+#define to_vhost_dev(d) container_of((d), struct vhost_dev, dev)
+
+int vhost_register_driver(struct vhost_driver *driver);
+void vhost_unregister_driver(struct vhost_driver *driver);
+int vhost_register_device(struct vhost_dev *vdev);
+void vhost_unregister_device(struct vhost_dev *vdev);
+
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
 		    int nvqs, int iov_limit, int weight, int byte_weight,
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index b427def67e7e..b13434d6c976 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -13,9 +13,9 @@
 #include <fcntl.h>
 #include <stdbool.h>
 #include <linux/virtio_types.h>
-#include <linux/vhost.h>
 #include <linux/virtio.h>
 #include <linux/virtio_ring.h>
+#include <uapi/linux/vhost.h>
 #include "../../drivers/vhost/test.h"
 
 /* Unused */
-- 
2.17.1


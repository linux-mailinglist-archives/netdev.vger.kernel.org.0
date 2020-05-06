Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D601B1C7BEA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgEFVFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:05:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:30092 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgEFVFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 17:05:19 -0400
IronPort-SDR: JMzXMY9Pu+UD4sBsj1QYRDzI/poXTUiT8asx1axskYvYpoutlAs/LUImQVIPO1g9KdZzbeqj5/
 cvXrPBPUo0KA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 14:05:10 -0700
IronPort-SDR: opvg52JbfNW7B9ZcaQd0H2iarPq9JgqQEMwFlSpdzUhoQzOPAwy85urG054qr6txFBfnEhpYAm
 2kYUVLlkC94w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,360,1583222400"; 
   d="scan'208";a="263703802"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2020 14:05:08 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        leonro@mellanox.com, mkalderon@marvell.com, aditr@vmware.com,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 1/9] Implementation of Virtual Bus
Date:   Wed,  6 May 2020 14:04:57 -0700
Message-Id: <20200506210505.507254-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
References: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

This is the initial implementation of the Virtual Bus,
virtbus_device and virtbus_driver.  The virtual bus is
a software based bus intended to support registering
virtbus_devices and virtbus_drivers and provide matching
between them and probing of the registered drivers.

The bus will support probe/remove shutdown and
suspend/resume callbacks.

Kconfig and Makefile alterations are included

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 Documentation/driver-api/virtual_bus.rst |  88 ++++++++
 drivers/bus/Kconfig                      |  10 +
 drivers/bus/Makefile                     |   2 +
 drivers/bus/virtual_bus.c                | 255 +++++++++++++++++++++++
 include/linux/mod_devicetable.h          |   8 +
 include/linux/virtual_bus.h              |  62 ++++++
 scripts/mod/devicetable-offsets.c        |   3 +
 scripts/mod/file2alias.c                 |   7 +
 8 files changed, 435 insertions(+)
 create mode 100644 Documentation/driver-api/virtual_bus.rst
 create mode 100644 drivers/bus/virtual_bus.c
 create mode 100644 include/linux/virtual_bus.h

diff --git a/Documentation/driver-api/virtual_bus.rst b/Documentation/driver-api/virtual_bus.rst
new file mode 100644
index 000000000000..33cef5433dcd
--- /dev/null
+++ b/Documentation/driver-api/virtual_bus.rst
@@ -0,0 +1,88 @@
+===============================
+Virtual Bus Devices and Drivers
+===============================
+
+See <linux/virtual_bus.h> for the models for virtbus_device and virtbus_driver.
+This bus is meant to be a minimalist software based bus to attach generic
+devices and drivers to so that a chunk of data can be passed between them.
+
+Memory Allocation Lifespan and Model
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Originating KO - The kernel object that is defining either the
+virtbus_device or the virtbus_driver and registering it with the virtual_bus.
+
+The originating KO is expected to allocate memory for the virtbus_device or
+virtbus_driver before registering it with the virtual_bus.
+
+For a virtbus_device, this memory is expected to remain viable until the
+device's mandatory .release() callback is accessed.  The memory cleanup will
+ideally be performed within this callback.
+
+For a virtbus_driver, this memory is expected to remain viable until the
+driver's .remove() or .shutdown() callbacks are accessed.  The memory cleanup
+will ideally be performed with these callbacks.
+
+Device Enumeration
+~~~~~~~~~~~~~~~~~~
+
+Enumeration is handled automatically by the bus infrastructure.
+
+Device naming and driver binding
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The virtbus_device.dev.name is the canonical name for the device. It is
+built from two other parts:
+
+        - virtbus_device.match_name (used for matching).
+        - virtbus_device.id (generated automatically from ida_simple calls)
+
+Virtbus device's sub-device names are always in "<name>.<instance>" format.
+
+For a virtbus_device to be matched with a virtbus_driver, the device's match
+name must be populated, as this is what will be evaluated to perform the match.
+
+Common Usage and Structure Design
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The two (or more) Originating KO's (one for the driver and one or more for
+the devices) will have to have a common header file, so that a struct can
+be defined that they both use.  This allows for the following design.
+
+In the common header file outside of the virtual_bus infrastructure, define
+struct virtbus_object:
+
+                 virtbus_object
+                        |
+                -------------------------
+                |                       |
+        virtbus_device          private_struct/data
+
+The virtbus_device cannot be a pointer so that a container_of can be
+performed by the driver.
+
+The device originating KO will allocate a virtbus_object and then populate
+virtbus_device->match_name and register the virtbus_device with virtbus.
+
+When the virtbus_driver registers with the virtual_bus and a match is made,
+the .probe() callback of the driver will be called with the virtbus_device
+struct as a parameter.  This allows the virtbus_driver to perform a
+contain_of call to get access to the virtbus_object, and to the pointer to
+the private_struct/data.
+
+This is the main goal of virtual_bus, to get a common pointer available
+to both of the originating KOs involved in a match.
+
+Mandatory Elements
+~~~~~~~~~~~~~~~~~
+
+virtbus_device:
+        .relase() callback must not be NULL and is expected to perform
+                memory cleanup.
+        .match_name must be populated to be able to match with a driver
+
+virtbus_driver:
+        .probe() callback must not be NULL
+        .remove() callback must not be NULL
+        .shutdown() callback must not be NULL
+        .id_table must not be NULL, used to perform matching
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 6d4e4497b59b..00553c78510c 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -203,4 +203,14 @@ config DA8XX_MSTPRI
 source "drivers/bus/fsl-mc/Kconfig"
 source "drivers/bus/mhi/Kconfig"
 
+config VIRTUAL_BUS
+       tristate "Software based Virtual Bus"
+       help
+         Provides a software bus for virtbus_devices to be added to it
+         and virtbus_drivers to be registered on it.  It matches driver
+         and device based on id and calls the driver's probe routine.
+         One example is the irdma driver needing to connect with various
+         PCI LAN drivers to request resources (queues) to be able to perform
+         its function.
+
 endmenu
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 05f32cd694a4..d30828a4768c 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -37,3 +37,5 @@ obj-$(CONFIG_DA8XX_MSTPRI)	+= da8xx-mstpri.o
 
 # MHI
 obj-$(CONFIG_MHI_BUS)		+= mhi/
+
+obj-$(CONFIG_VIRTUAL_BUS)	+= virtual_bus.o
diff --git a/drivers/bus/virtual_bus.c b/drivers/bus/virtual_bus.c
new file mode 100644
index 000000000000..fe8000a53a0a
--- /dev/null
+++ b/drivers/bus/virtual_bus.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * virtual_bus.c - lightweight software based bus for virtual devices
+ *
+ * Copyright (c) 2019-2020 Intel Corporation
+ *
+ * Please see Documentation/driver-api/virtual_bus.rst for
+ * more information
+ */
+
+#include <linux/string.h>
+#include <linux/virtual_bus.h>
+#include <linux/of_irq.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pm_runtime.h>
+#include <linux/pm_domain.h>
+#include <linux/acpi.h>
+#include <linux/device.h>
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Virtual Bus");
+MODULE_AUTHOR("David Ertman <david.m.ertman@intel.com>");
+MODULE_AUTHOR("Kiran Patil <kiran.patil@intel.com>");
+
+static DEFINE_IDA(virtbus_dev_ida);
+#define VIRTBUS_INVALID_ID	0xFFFFFFFF
+
+static const
+struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id *id,
+					struct virtbus_device *vdev)
+{
+	while (id->name[0]) {
+		if (!strcmp(vdev->match_name, id->name))
+			return id;
+		id++;
+	}
+	return NULL;
+}
+
+static int virtbus_match(struct device *dev, struct device_driver *drv)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(drv);
+	struct virtbus_device *vdev = to_virtbus_dev(dev);
+
+	return virtbus_match_id(vdrv->id_table, vdev) != NULL;
+}
+
+static int virtbus_probe(struct device *dev)
+{
+	return dev->driver->probe(dev);
+}
+
+static int virtbus_remove(struct device *dev)
+{
+	return dev->driver->remove(dev);
+}
+
+static void virtbus_shutdown(struct device *dev)
+{
+	dev->driver->shutdown(dev);
+}
+
+static int virtbus_suspend(struct device *dev, pm_message_t state)
+{
+	if (!dev->driver->suspend)
+		return 0;
+
+	return dev->driver->suspend(dev, state);
+}
+
+static int virtbus_resume(struct device *dev)
+{
+	if (!dev->driver->resume)
+		return 0;
+
+	return dev->driver->resume(dev);
+}
+
+struct bus_type virtual_bus_type = {
+	.name = "virtbus",
+	.match = virtbus_match,
+	.probe = virtbus_probe,
+	.remove = virtbus_remove,
+	.shutdown = virtbus_shutdown,
+	.suspend = virtbus_suspend,
+	.resume = virtbus_resume,
+};
+
+/**
+ * virtbus_release_device - Destroy a virtbus device
+ * @_dev: device to release
+ */
+static void virtbus_release_device(struct device *_dev)
+{
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+	u32 ida = vdev->id;
+
+	vdev->release(vdev);
+	if (ida != VIRTBUS_INVALID_ID)
+		ida_simple_remove(&virtbus_dev_ida, ida);
+}
+
+/**
+ * virtbus_register_device - add a virtual bus device
+ * @vdev: virtual bus device to add
+ */
+int virtbus_register_device(struct virtbus_device *vdev)
+{
+	int ret;
+
+	if (WARN_ON(!vdev->release))
+		return -EINVAL;
+
+	/* All error paths out of this function after the device_initialize
+	 * must perform a put_device() so that the .release() callback is
+	 * called for an error condition.
+	 */
+	device_initialize(&vdev->dev);
+
+	vdev->dev.bus = &virtual_bus_type;
+	vdev->dev.release = virtbus_release_device;
+
+	/* All device IDs are automatically allocated */
+	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
+
+	if (ret < 0) {
+		vdev->id = VIRTBUS_INVALID_ID;
+		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
+		goto device_add_err;
+	}
+
+	vdev->id = ret;
+
+	ret = dev_set_name(&vdev->dev, "%s.%d", vdev->match_name, vdev->id);
+	if (ret) {
+		dev_err(&vdev->dev, "dev_set_name failed for device\n");
+		goto device_add_err;
+	}
+
+	dev_dbg(&vdev->dev, "Registering virtbus device '%s'\n",
+		dev_name(&vdev->dev));
+
+	ret = device_add(&vdev->dev);
+	if (ret)
+		goto device_add_err;
+
+	return 0;
+
+device_add_err:
+	dev_err(&vdev->dev, "Add device to virtbus failed!: %d\n", ret);
+	put_device(&vdev->dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtbus_register_device);
+
+static int virtbus_probe_driver(struct device *_dev)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+	int ret;
+
+	ret = dev_pm_domain_attach(_dev, true);
+	if (ret) {
+		dev_warn(_dev, "Failed to attach to PM Domain : %d\n", ret);
+		return ret;
+	}
+
+	ret = vdrv->probe(vdev);
+	if (ret) {
+		dev_err(&vdev->dev, "Probe returned error\n");
+		dev_pm_domain_detach(_dev, true);
+	}
+
+	return ret;
+}
+
+static int virtbus_remove_driver(struct device *_dev)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+	int ret = 0;
+
+	ret = vdrv->remove(vdev);
+	dev_pm_domain_detach(_dev, true);
+
+	return ret;
+}
+
+static void virtbus_shutdown_driver(struct device *_dev)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+
+	vdrv->shutdown(vdev);
+}
+
+static int virtbus_suspend_driver(struct device *_dev, pm_message_t state)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+
+	if (!vdrv->suspend)
+		return 0;
+
+	return vdrv->suspend(vdev, state);
+}
+
+static int virtbus_resume_driver(struct device *_dev)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+
+	if (!vdrv->resume)
+		return 0;
+
+	return vdrv->resume(vdev);
+}
+
+/**
+ * __virtbus_register_driver - register a driver for virtual bus devices
+ * @vdrv: virtbus_driver structure
+ * @owner: owning module/driver
+ */
+int __virtbus_register_driver(struct virtbus_driver *vdrv, struct module *owner)
+{
+	if (!vdrv->probe || !vdrv->remove || !vdrv->shutdown || !vdrv->id_table)
+		return -EINVAL;
+
+	vdrv->driver.owner = owner;
+	vdrv->driver.bus = &virtual_bus_type;
+	vdrv->driver.probe = virtbus_probe_driver;
+	vdrv->driver.remove = virtbus_remove_driver;
+	vdrv->driver.shutdown = virtbus_shutdown_driver;
+	vdrv->driver.suspend = virtbus_suspend_driver;
+	vdrv->driver.resume = virtbus_resume_driver;
+
+	return driver_register(&vdrv->driver);
+}
+EXPORT_SYMBOL_GPL(__virtbus_register_driver);
+
+static int __init virtual_bus_init(void)
+{
+	return bus_register(&virtual_bus_type);
+}
+
+static void __exit virtual_bus_exit(void)
+{
+	bus_unregister(&virtual_bus_type);
+	ida_destroy(&virtbus_dev_ida);
+}
+
+module_init(virtual_bus_init);
+module_exit(virtual_bus_exit);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 4c2ddd0941a7..60bcfe75fb94 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -832,4 +832,12 @@ struct mhi_device_id {
 	kernel_ulong_t driver_data;
 };
 
+#define VIRTBUS_NAME_SIZE 20
+#define VIRTBUS_MODULE_PREFIX "virtbus:"
+
+struct virtbus_dev_id {
+	char name[VIRTBUS_NAME_SIZE];
+	kernel_ulong_t driver_data;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/virtual_bus.h b/include/linux/virtual_bus.h
new file mode 100644
index 000000000000..4872fd5a9218
--- /dev/null
+++ b/include/linux/virtual_bus.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * virtual_bus.h - lightweight software bus
+ *
+ * Copyright (c) 2019-2020 Intel Corporation
+ *
+ * Please see Documentation/driver-api/virtual_bus.rst for more information
+ */
+
+#ifndef _VIRTUAL_BUS_H_
+#define _VIRTUAL_BUS_H_
+
+#include <linux/device.h>
+
+struct virtbus_device {
+	struct device dev;
+	const char *match_name;
+	void (*release)(struct virtbus_device *);
+	u32 id;
+};
+
+struct virtbus_driver {
+	int (*probe)(struct virtbus_device *);
+	int (*remove)(struct virtbus_device *);
+	void (*shutdown)(struct virtbus_device *);
+	int (*suspend)(struct virtbus_device *, pm_message_t);
+	int (*resume)(struct virtbus_device *);
+	struct device_driver driver;
+	const struct virtbus_dev_id *id_table;
+};
+
+static inline
+struct virtbus_device *to_virtbus_dev(struct device *dev)
+{
+	return container_of(dev, struct virtbus_device, dev);
+}
+
+static inline
+struct virtbus_driver *to_virtbus_drv(struct device_driver *drv)
+{
+	return container_of(drv, struct virtbus_driver, driver);
+}
+
+int virtbus_register_device(struct virtbus_device *vdev);
+
+int
+__virtbus_register_driver(struct virtbus_driver *vdrv, struct module *owner);
+
+#define virtbus_register_driver(vdrv) \
+	__virtbus_register_driver(vdrv, THIS_MODULE)
+
+static inline void virtbus_unregister_device(struct virtbus_device *vdev)
+{
+	device_unregister(&vdev->dev);
+}
+
+static inline void virtbus_unregister_driver(struct virtbus_driver *vdrv)
+{
+	driver_unregister(&vdrv->driver);
+}
+
+#endif /* _VIRTUAL_BUS_H_ */
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index 010be8ba2116..0c8e0e3a7c84 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -241,5 +241,8 @@ int main(void)
 	DEVID(mhi_device_id);
 	DEVID_FIELD(mhi_device_id, chan);
 
+	DEVID(virtbus_dev_id);
+	DEVID_FIELD(virtbus_dev_id, name);
+
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 02d5d79da284..7d78fa3fba34 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1358,7 +1358,13 @@ static int do_mhi_entry(const char *filename, void *symval, char *alias)
 {
 	DEF_FIELD_ADDR(symval, mhi_device_id, chan);
 	sprintf(alias, MHI_DEVICE_MODALIAS_FMT, *chan);
+	return 1;
+}
 
+static int do_virtbus_entry(const char *filename, void *symval, char *alias)
+{
+	DEF_FIELD_ADDR(symval, virtbus_dev_id, name);
+	sprintf(alias, VIRTBUS_MODULE_PREFIX "%s", *name);
 	return 1;
 }
 
@@ -1436,6 +1442,7 @@ static const struct devtable devtable[] = {
 	{"tee", SIZE_tee_client_device_id, do_tee_entry},
 	{"wmi", SIZE_wmi_device_id, do_wmi_entry},
 	{"mhi", SIZE_mhi_device_id, do_mhi_entry},
+	{"virtbus", SIZE_virtbus_dev_id, do_virtbus_entry},
 };
 
 /* Create MODULE_ALIAS() statements.
-- 
2.26.2


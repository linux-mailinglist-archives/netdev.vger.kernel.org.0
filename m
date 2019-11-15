Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E612CFE7F4
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKOWeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:34:00 -0500
Received: from mga05.intel.com ([192.55.52.43]:30088 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbfKOWd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 17:33:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2019 14:33:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,309,1569308400"; 
   d="scan'208";a="406810723"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga006.fm.intel.com with ESMTP; 15 Nov 2019 14:33:57 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        Kiran Patil <kiran.patil@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Date:   Fri, 15 Nov 2019 14:33:55 -0800
Message-Id: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

This is the initial implementation of the Virtual Bus,
virtbus_device and virtbus_driver.  The virtual bus is
a software based bus intended to support lightweight
devices and drivers and provide matching between them
and probing of the registered drivers.

The primary purpose of the virual bus is to provide
matching services and to pass the data pointer
contained in the virtbus_device to the virtbus_driver
during its probe call.  This will allow two separate
kernel objects to match up and start communication.

The bus will support probe/remove shutdown and
suspend/resume callbacks.

Kconfig and Makefile alterations are included

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
v2: Cleaned up the virtual bus interface based on feedback from Greg KH
    and provided a test driver and test virtual bus device as an example
    of how to implement the virtual bus.

 Documentation/driver-api/virtual_bus.rst      |  76 ++++
 drivers/bus/Kconfig                           |  14 +
 drivers/bus/Makefile                          |   1 +
 drivers/bus/virtual_bus.c                     | 326 ++++++++++++++++++
 include/linux/virtual_bus.h                   |  55 +++
 .../virtual_bus/virtual_bus_dev/Makefile      |   7 +
 .../virtual_bus_dev/virtual_bus_dev.c         |  67 ++++
 .../virtual_bus/virtual_bus_drv/Makefile      |   7 +
 .../virtual_bus_drv/virtual_bus_drv.c         | 101 ++++++
 9 files changed, 654 insertions(+)
 create mode 100644 Documentation/driver-api/virtual_bus.rst
 create mode 100644 drivers/bus/virtual_bus.c
 create mode 100644 include/linux/virtual_bus.h
 create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_dev/Makefile
 create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_dev/virtual_bus_dev.c
 create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_drv/Makefile
 create mode 100644 tools/testing/selftests/virtual_bus/virtual_bus_drv/virtual_bus_drv.c

diff --git a/Documentation/driver-api/virtual_bus.rst b/Documentation/driver-api/virtual_bus.rst
new file mode 100644
index 000000000000..970e06267284
--- /dev/null
+++ b/Documentation/driver-api/virtual_bus.rst
@@ -0,0 +1,76 @@
+===============================
+Virtual Bus Devices and Drivers
+===============================
+
+See <linux/virtual_bus.h> for the models for virtbus_device and virtbus_driver.
+This bus is meant to be a lightweight software based bus to attach generic
+devices and drivers to so that a chunk of data can be passed between them.
+
+One use case example is an rdma driver needing to connect with several
+different types of PCI LAN devices to be able to request resources from
+them (queue sets).  Each LAN driver that supports rdma will register a
+virtbus_device on the virtual bus for each physical function.  The rdma
+driver will register as a virtbus_driver on the virtual bus to be
+matched up with multiple virtbus_devices and receive a pointer to a
+struct containing the callbacks that the PCI LAN drivers support for
+registering with them.
+
+Sections in this document:
+        Virtbus devices
+        Virtbus drivers
+        Device Enumeration
+        Device naming and driver binding
+        Virtual Bus API entry points
+
+Virtbus devices
+~~~~~~~~~~~~~~~
+Virtbus_devices are lightweight objects that support the minimal device
+functionality.  Devices will accept a name, and then an automatically
+generated index is concatenated onto it for the virtbus_device->name.
+
+The memory backing the "void *data" element of the virtbus_device is
+expected to be allocated and freed outside the context of the bus
+operations.  This memory is also expected to remain viable for the
+duration of the time that the virtbus_device is registered to the
+virtual bus. (e.g. from before the virtbus_dev_register until after
+the paired virtbus_dev_unregister).
+
+The provided API for virtbus_dev_alloc is an efficient way of allocating
+the memory for the virtbus_device (except for the data element) and
+automatically freeing it when the device is removed from the bus.
+
+Virtbus drivers
+~~~~~~~~~~~~~~~
+Virtbus drivers register with the virtual bus to be matched with virtbus
+devices.  They expect to be registered with a probe and remove callback,
+and also support shutdown, suspend, and resume callbacks.  They otherwise
+follow the standard driver behavior of having discovery and enumeration
+handled in the bus infrastructure.
+
+Virtbus drivers register themselves with the API entry point virtbus_drv_reg
+and unregister with virtbus_drv_unreg.
+
+Device Enumeration
+~~~~~~~~~~~~~~~~~~
+Enumeration is handled automatically by the bus infrastructure via the
+ida_simple methods.
+
+Device naming and driver binding
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+The virtbus_device.dev.name is the canonical name for the device. It is
+built from two other parts:
+
+        - virtbus_device.name (also used for matching).
+        - virtbus_device.id (generated automatically from ida_simple calls)
+
+This allows for multiple virtbus_devices with the same name, which will all
+be matched to the same virtbus_driver. Driver binding is performed by the
+driver core, invoking driver probe() after finding a match between device and driver.
+
+Virtual Bus API entry points
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+struct virtbus_device *virtbus_dev_alloc(const char *name, void *data)
+int virtbus_dev_register(struct virtbus_device *vdev)
+void virtbus_dev_unregister(struct virtbus_device *vdev)
+int virtbus_drv_register(struct virtbus_driver *vdrv, struct module *owner)
+void virtbus_drv_unregister(struct virtbus_driver *vdrv)
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 6b331061d34b..30cef35b0c30 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -193,4 +193,18 @@ config DA8XX_MSTPRI
 
 source "drivers/bus/fsl-mc/Kconfig"
 
+config VIRTUAL_BUS
+       tristate "lightweight Virtual Bus"
+       depends on PM
+       help
+         Provides a lightweight bus for virtbus_devices to be added to it
+         and virtbus_drivers to be registered on it.  Will create a match
+         between the driver and device, then call the driver's probe with
+         the virtbus_device's struct (including a pointer for data).
+         One example is the irdma driver needing to connect with various
+         PCI LAN drivers to request resources (queues) to be able to perform
+         its function.  The data in the virtbus_device created by the
+         PCI LAN driver is a set of ops (function pointers) for the irdma
+         driver to use to register and communicate with the PCI LAN driver.
+
 endmenu
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 16b43d3468c6..0b0ba53cbe5b 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -33,3 +33,4 @@ obj-$(CONFIG_UNIPHIER_SYSTEM_BUS)	+= uniphier-system-bus.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
 
 obj-$(CONFIG_DA8XX_MSTPRI)	+= da8xx-mstpri.o
+obj-$(CONFIG_VIRTUAL_BUS)	+= virtual_bus.o
diff --git a/drivers/bus/virtual_bus.c b/drivers/bus/virtual_bus.c
new file mode 100644
index 000000000000..c6eab1658391
--- /dev/null
+++ b/drivers/bus/virtual_bus.c
@@ -0,0 +1,326 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * virtual_bus.c - lightweight software based bus for virtual devices
+ *
+ * Copyright (c) 2019-20 Intel Corporation
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
+MODULE_DESCRIPTION("Lightweight Virtual Bus");
+MODULE_AUTHOR("David Ertman <david.m.ertman@intel.com>");
+MODULE_AUTHOR("Kiran Patil <kiran.patil@intel.com>");
+
+static DEFINE_IDA(virtbus_dev_ida);
+
+static const
+struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id *id,
+					struct virtbus_device *vdev)
+{
+	while (id->name[0]) {
+		if (!strcmp(vdev->name, id->name)) {
+			vdev->dev_id = id;
+			return id;
+		}
+		id++;
+	}
+	return NULL;
+}
+
+#define to_virtbus_dev(x)	(container_of((x), struct virtbus_device, dev))
+#define to_virtbus_drv(x)	(container_of((x), struct virtbus_driver, \
+				 driver))
+
+/**
+ * virtbus_match - bind virtbus device to virtbus driver
+ * @dev: device
+ * @drv: driver
+ *
+ * Virtbus device IDs are always in "<name>.<instance>" format.
+ * Instances are automatically selected through an ida_simple_get so
+ * are positive integers. Names are taken from the device name field.
+ * Driver IDs are simple <name>.  Need to extract the name from the
+ * Virtual Device compare to name of the driver.
+ */
+static int virtbus_match(struct device *dev, struct device_driver *drv)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(drv);
+	struct virtbus_device *vdev = to_virtbus_dev(dev);
+
+	if (vdrv->id_table)
+		return virtbus_match_id(vdrv->id_table, vdev) != NULL;
+
+	return !strcmp(vdev->name, drv->name);
+}
+
+/**
+ * virtbus_probe - call probe of the virtbus_drv
+ * @dev: device struct
+ */
+static int virtbus_probe(struct device *dev)
+{
+	if (dev->driver->probe)
+		return dev->driver->probe(dev);
+
+	return 0;
+}
+
+static int virtbus_remove(struct device *dev)
+{
+	if (dev->driver->remove)
+		return dev->driver->remove(dev);
+
+	return 0;
+}
+
+static void virtbus_shutdown(struct device *dev)
+{
+	if (dev->driver->shutdown)
+		dev->driver->shutdown(dev);
+}
+
+static int virtbus_suspend(struct device *dev, pm_message_t state)
+{
+	if (dev->driver->suspend)
+		return dev->driver->suspend(dev, state);
+
+	return 0;
+}
+
+static int virtbus_resume(struct device *dev)
+{
+	if (dev->driver->resume)
+		return dev->driver->resume(dev);
+
+	return 0;
+}
+
+struct bus_type virtual_bus_type = {
+	.name		= "virtbus",
+	.match		= virtbus_match,
+	.probe		= virtbus_probe,
+	.remove		= virtbus_remove,
+	.shutdown	= virtbus_shutdown,
+	.suspend	= virtbus_suspend,
+	.resume		= virtbus_resume,
+};
+
+/**
+ * virtbus_dev_register - add a virtual bus device
+ * @vdev: virtual bus device to add
+ */
+int virtbus_dev_register(struct virtbus_device *vdev)
+{
+	int ret;
+
+	if (!vdev)
+		return -EINVAL;
+
+	device_initialize(&vdev->dev);
+
+	vdev->dev.bus = &virtual_bus_type;
+	/* All device IDs are automatically allocated */
+	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	vdev->id = ret;
+	dev_set_name(&vdev->dev, "%s.%d", vdev->name, vdev->id);
+
+	dev_dbg(&vdev->dev, "Registering VirtBus device '%s'\n",
+		dev_name(&vdev->dev));
+
+	ret = device_add(&vdev->dev);
+	if (!ret)
+		return ret;
+
+	/* Error adding virtual device */
+	device_del(&vdev->dev);
+	ida_simple_remove(&virtbus_dev_ida, vdev->id);
+	vdev->id = VIRTBUS_DEVID_NONE;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtbus_dev_register);
+
+/**
+ * virtbus_dev_unregister - remove a virtual bus device
+ * vdev: virtual bus device we are removing
+ */
+void virtbus_dev_unregister(struct virtbus_device *vdev)
+{
+	if (!IS_ERR_OR_NULL(vdev)) {
+		device_del(&vdev->dev);
+
+		ida_simple_remove(&virtbus_dev_ida, vdev->id);
+		vdev->id = VIRTBUS_DEVID_NONE;
+	}
+}
+EXPORT_SYMBOL_GPL(virtbus_dev_unregister);
+
+struct virtbus_object {
+	struct virtbus_device vdev;
+	char name[];
+};
+
+/**
+ * virtbus_dev_release - Destroy a virtbus device
+ * @vdev: virtual device to release
+ *
+ * Note that the vdev->data which is separately allocated needs to be
+ * separately freed on it own.
+ */
+static void virtbus_dev_release(struct device *dev)
+{
+	struct virtbus_object *vo = container_of(dev, struct virtbus_object,
+						 vdev.dev);
+
+	kfree(vo);
+}
+
+/**
+ * virtbus_dev_alloc - allocate a virtbus device
+ * @name: name to associate with the vdev
+ * @data: pointer to data to be associated with this device
+ */
+struct virtbus_device *virtbus_dev_alloc(const char *name, void *data)
+{
+	struct virtbus_object *vo;
+
+	/* Create a virtbus object to contain the vdev and name.  This
+	 * avoids a problem with the const attribute of name in the vdev.
+	 * The virtbus_object will be allocated here and freed in the
+	 * release function.
+	 */
+	vo = kzalloc(sizeof(*vo) + strlen(name) + 1, GFP_KERNEL);
+	if (!vo)
+		return NULL;
+
+	strcpy(vo->name, name);
+	vo->vdev.name = vo->name;
+	vo->vdev.data = data;
+	vo->vdev.dev.release = virtbus_dev_release;
+
+	return &vo->vdev;
+}
+EXPORT_SYMBOL_GPL(virtbus_dev_alloc);
+
+static int virtbus_drv_probe(struct device *_dev)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+	int ret;
+
+	ret = dev_pm_domain_attach(_dev, true);
+	if (ret) {
+		dev_warn(_dev, "Failed to attatch to PM Domain : %d\n", ret);
+		return ret;
+	}
+
+	if (vdrv->probe) {
+		ret = vdrv->probe(vdev);
+		if (ret)
+			dev_pm_domain_detach(_dev, true);
+	}
+
+	return ret;
+}
+
+static int virtbus_drv_remove(struct device *_dev)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+	int ret = 0;
+
+	if (vdrv->remove)
+		ret = vdrv->remove(vdev);
+
+	dev_pm_domain_detach(_dev, true);
+
+	return ret;
+}
+
+static void virtbus_drv_shutdown(struct device *_dev)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+
+	if (vdrv->shutdown)
+		vdrv->shutdown(vdev);
+}
+
+static int virtbus_drv_suspend(struct device *_dev, pm_message_t state)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+
+	if (vdrv->suspend)
+		return vdrv->suspend(vdev, state);
+
+	return 0;
+}
+
+static int virtbus_drv_resume(struct device *_dev)
+{
+	struct virtbus_driver *vdrv = to_virtbus_drv(_dev->driver);
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+
+	if (vdrv->resume)
+		return vdrv->resume(vdev);
+
+	return 0;
+}
+
+/**
+ * __virtbus_drv_register - register a driver for virtual bus devices
+ * @vdrv: virtbus_driver structure
+ * @owner: owning module/driver
+ */
+int __virtbus_drv_register(struct virtbus_driver *vdrv, struct module *owner)
+{
+	vdrv->driver.owner = owner;
+	vdrv->driver.bus = &virtual_bus_type;
+	vdrv->driver.probe = virtbus_drv_probe;
+	vdrv->driver.remove = virtbus_drv_remove;
+	vdrv->driver.shutdown = virtbus_drv_shutdown;
+	vdrv->driver.suspend = virtbus_drv_suspend;
+	vdrv->driver.resume = virtbus_drv_resume;
+
+	return driver_register(&vdrv->driver);
+}
+EXPORT_SYMBOL_GPL(__virtbus_drv_register);
+
+/**
+ * virtbus_drv_unregister - unregister a driver for virtual bus devices
+ * @drv: virtbus_driver structure
+ */
+void virtbus_drv_unregister(struct virtbus_driver *vdrv)
+{
+	driver_unregister(&vdrv->driver);
+}
+EXPORT_SYMBOL_GPL(virtbus_drv_unregister);
+
+static int __init virtual_bus_init(void)
+{
+	return bus_register(&virtual_bus_type);
+}
+
+static void __exit virtual_bus_exit(void)
+{
+	bus_unregister(&virtual_bus_type);
+}
+
+module_init(virtual_bus_init);
+module_exit(virtual_bus_exit);
diff --git a/include/linux/virtual_bus.h b/include/linux/virtual_bus.h
new file mode 100644
index 000000000000..b6f2406180f8
--- /dev/null
+++ b/include/linux/virtual_bus.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * virtual_bus.h - lightweight software bus
+ *
+ * Copyright (c) 2019-20 Intel Corporation
+ *
+ * Please see Documentation/driver-api/virtual_bus.rst for more information
+ */
+
+#ifndef _VIRTUAL_BUS_H_
+#define _VIRTUAL_BUS_H_
+
+#include <linux/device.h>
+
+#define VIRTBUS_DEVID_NONE	(-1)
+#define VIRTBUS_NAME_SIZE	20
+
+struct virtbus_dev_id {
+	char name[VIRTBUS_NAME_SIZE];
+	u64 driver_data;
+};
+
+struct virtbus_device {
+	const char			*name;
+	int				id;
+	const struct virtbus_dev_id	*dev_id;
+	struct device			dev;
+	void				*data;
+};
+
+/* If the driver uses a id_table to match with virtbus_devices, then the
+ * memory for the table is expected to remain allocated for the duration
+ * of the pairing between driver and device.  The pointer for the matching
+ * element will be copied to the dev_id field of the virtbus_device.
+ */
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
+int virtbus_dev_register(struct virtbus_device *vdev);
+void virtbus_dev_unregister(struct virtbus_device *vdev);
+struct virtbus_device *virtbus_dev_alloc(const char *name, void *devdata);
+int __virtbus_drv_register(struct virtbus_driver *vdrv, struct module *owner);
+void virtbus_drv_unregister(struct virtbus_driver *vdrv);
+
+#define virtbus_drv_register(vdrv) \
+	__virtbus_drv_register(vdrv, THIS_MODULE)
+
+#endif /* _VIRTUAL_BUS_H_ */
diff --git a/tools/testing/selftests/virtual_bus/virtual_bus_dev/Makefile b/tools/testing/selftests/virtual_bus/virtual_bus_dev/Makefile
new file mode 100644
index 000000000000..ddd5088eb26b
--- /dev/null
+++ b/tools/testing/selftests/virtual_bus/virtual_bus_dev/Makefile
@@ -0,0 +1,7 @@
+obj-m += virtual_bus_dev.o
+
+all:
+	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
+
+clean:
+	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
diff --git a/tools/testing/selftests/virtual_bus/virtual_bus_dev/virtual_bus_dev.c b/tools/testing/selftests/virtual_bus/virtual_bus_dev/virtual_bus_dev.c
new file mode 100644
index 000000000000..7257e599f12b
--- /dev/null
+++ b/tools/testing/selftests/virtual_bus/virtual_bus_dev/virtual_bus_dev.c
@@ -0,0 +1,67 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/module.h>
+#include <linux/virtual_bus.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Dave Ertman");
+MODULE_DESCRIPTION("Test to create a device on virtual bus");
+MODULE_VERSION("1.0");
+
+static struct virtbus_device *vdev;
+static char *data;
+
+static int __init test_dev_init(void)
+{
+	int ret = 0;
+	static char *name;
+
+	printk(KERN_INFO "Loading Virtual Bus Test Device\n");
+
+	name = kzalloc(VIRTBUS_NAME_SIZE, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+	strcpy(name, "virtual_bus_dev");
+
+	data = kzalloc(128, GFP_KERNEL);
+	if (!data) {
+		kfree(name);
+		return -ENOMEM;
+	}
+	strcpy(data, "This is my data string - isn't it wonderful!");
+
+	vdev = virtbus_dev_alloc(name, data);
+	if (!vdev) {
+		kfree(name);
+		kfree(data);
+		return -EINVAL;
+	}
+
+	printk(KERN_ERR "Virtbus Device allocated:\n\t%s\n\t%s\n", vdev->name,
+	       (char *)vdev->data);
+
+	ret = virtbus_dev_register(vdev);
+	kfree(name);
+	if (ret) {
+		printk(KERN_ERR "FAILED TO ADD VIRTBUS DEVICE %d\n", ret);
+		return ret;
+	}
+
+	printk(KERN_INFO "Virtual Device created\n");
+	return ret;
+}
+
+static void __exit test_dev_exit(void)
+{
+	printk(KERN_INFO "Exiting Virtual Bus Test Device");
+
+	virtbus_dev_unregister(vdev);
+	kfree(data);
+
+	printk(KERN_INFO "Virtual Bus Test Device removed\n");
+}
+
+module_init(test_dev_init);
+module_exit(test_dev_exit);
diff --git a/tools/testing/selftests/virtual_bus/virtual_bus_drv/Makefile b/tools/testing/selftests/virtual_bus/virtual_bus_drv/Makefile
new file mode 100644
index 000000000000..a4b7467f7878
--- /dev/null
+++ b/tools/testing/selftests/virtual_bus/virtual_bus_drv/Makefile
@@ -0,0 +1,7 @@
+obj-m += virtual_bus_drv.o
+
+all:
+	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
+
+clean:
+	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
diff --git a/tools/testing/selftests/virtual_bus/virtual_bus_drv/virtual_bus_drv.c b/tools/testing/selftests/virtual_bus/virtual_bus_drv/virtual_bus_drv.c
new file mode 100644
index 000000000000..202288809b1c
--- /dev/null
+++ b/tools/testing/selftests/virtual_bus/virtual_bus_drv/virtual_bus_drv.c
@@ -0,0 +1,101 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/module.h>
+#include <linux/virtual_bus.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dave Ertman");
+MODULE_DESCRIPTION("Test to register a driver on virtual bus");
+MODULE_VERSION("1.0");
+
+static int td_probe(struct virtbus_device *vdev)
+{
+	printk(KERN_ERR "VIRTBUS DRIVER PROBED\n");
+	printk(KERN_ERR "DATA IS %s", vdev->data ? "NOT NULL" : "NULL");
+	if (vdev->dev_id) {
+		printk(KERN_ERR "DEV_ID->DATA 0x%08x\n",
+			(uint)vdev->dev_id->driver_data);
+		if (vdev->dev_id->driver_data == 1)
+			printk(KERN_ERR "DATA STRING: %s\n",
+			       (char *)vdev->data);
+	} else {
+		printk(KERN_ERR "DEV_ID->DATA is NULL\n");
+	}
+
+	return 0;
+}
+
+static int td_remove(struct virtbus_device *vdev)
+{
+	printk(KERN_ERR "VIRTBUS DRIVER REMOVED\n");
+	return 0;
+}
+
+static void td_shutdown(struct virtbus_device *vdev)
+{
+	printk(KERN_ERR "VIRTBUS DRIVER SHUTDOWN\n");
+}
+
+static const struct virtbus_dev_id vdev_id_table[] = {
+
+	{
+		.name = "NOT THE NAME",
+		.driver_data = 0x00000000,
+	},
+	{
+		.name = "virtual_bus_dev",
+		.driver_data = 0x00000001,
+	},
+	{
+		.name = "ice_rdma",
+		.driver_data = 0x00000002,
+	},
+	{
+		.name = "YET AGAIN NOT NAME",
+		.driver_data = 0x00000003,
+	},
+};
+
+static struct virtbus_driver vdrv = {
+	.probe = td_probe,
+	.remove = td_remove,
+	.shutdown = td_shutdown,
+	.driver = {
+		.name = "virtual_bus_dev",
+	},
+};
+
+static int __init test_drv_init(void)
+{
+	int ret;
+
+	printk(KERN_INFO "Registering Virtual Bus Test Driver\n");
+
+	/* To do a simple match, leave the id_table as NULL */
+	vdrv.id_table = &vdev_id_table[0];
+
+	printk(KERN_ERR "name of 0 is %s\n", vdrv.id_table->name);
+
+	ret = virtbus_drv_register(&vdrv);
+
+	if (!ret)
+		printk(KERN_INFO "Virtual Driver registered\n");
+	else
+		printk(KERN_INFO "Virtual Driver FAILED!!\n");
+
+	return ret;
+}
+
+static void __exit test_drv_exit(void)
+{
+	printk(KERN_INFO "Exiting Virtual Bus Test Driver");
+
+	virtbus_drv_unregister(&vdrv);
+
+	printk(KERN_INFO "Virtual Bus Test Driver removed\n");
+}
+
+module_init(test_drv_init);
+module_exit(test_drv_exit);
-- 
2.23.0


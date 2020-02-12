Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8188815B0BD
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 20:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgBLTOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 14:14:30 -0500
Received: from mga07.intel.com ([134.134.136.100]:19422 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbgBLTO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 14:14:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 11:14:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,433,1574150400"; 
   d="scan'208";a="237806976"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 12 Feb 2020 11:14:25 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        leonro@mellanox.com, mkalderon@marvell.com, aditr@vmware.com,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [RFC PATCH v4 01/25] virtual-bus: Implementation of Virtual Bus
Date:   Wed, 12 Feb 2020 11:14:00 -0800
Message-Id: <20200212191424.1715577-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
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
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 Documentation/driver-api/virtual_bus.rst |  59 +++++
 drivers/bus/Kconfig                      |  11 +
 drivers/bus/Makefile                     |   1 +
 drivers/bus/virtual_bus.c                | 267 +++++++++++++++++++++++
 include/linux/mod_devicetable.h          |   8 +
 include/linux/virtual_bus.h              |  57 +++++
 scripts/mod/devicetable-offsets.c        |   3 +
 scripts/mod/file2alias.c                 |   8 +
 8 files changed, 414 insertions(+)
 create mode 100644 Documentation/driver-api/virtual_bus.rst
 create mode 100644 drivers/bus/virtual_bus.c
 create mode 100644 include/linux/virtual_bus.h

diff --git a/Documentation/driver-api/virtual_bus.rst b/Documentation/driver-api/virtual_bus.rst
new file mode 100644
index 000000000000..5f35c19171d7
--- /dev/null
+++ b/Documentation/driver-api/virtual_bus.rst
@@ -0,0 +1,59 @@
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
+Virtbus_devices support the minimal device functionality.  Devices will
+accept a name, and then, when added to the virtual bus, an automatically
+generated index is concatenated onto it for the virtbus_device->name.
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
+Virtbus device IDs are always in "<name>.<instance>" format.  Instances are
+automatically selected through an ida_simple_get so are positive integers.
+Names are taken from the device name field.  Driver IDs are simple <name>.
+Need to extract the name from the Virtual Device compare to name of the
+driver.
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 6095b6df8a81..2e8b89c1761a 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -202,4 +202,15 @@ config DA8XX_MSTPRI
 
 source "drivers/bus/fsl-mc/Kconfig"
 
+config VIRTUAL_BUS
+       tristate "Software based Virtual Bus"
+       help
+         Provides a software bus for virtbus_devices to be added to it
+         and virtbus_drivers to be registered on it.  Will create a match
+         between the driver and device, then call the driver's probe with
+         the virtbus_device's struct.
+         One example is the irdma driver needing to connect with various
+         PCI LAN drivers to request resources (queues) to be able to perform
+         its function.
+
 endmenu
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 1320bcf9fa9d..6721c77dc71b 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_UNIPHIER_SYSTEM_BUS)	+= uniphier-system-bus.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
 
 obj-$(CONFIG_DA8XX_MSTPRI)	+= da8xx-mstpri.o
+obj-$(CONFIG_VIRTUAL_BUS)	+= virtual_bus.o
diff --git a/drivers/bus/virtual_bus.c b/drivers/bus/virtual_bus.c
new file mode 100644
index 000000000000..85d2dbfa3376
--- /dev/null
+++ b/drivers/bus/virtual_bus.c
@@ -0,0 +1,267 @@
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
+			vdev->matched_element = id;
+			return id;
+		}
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
+ * virtbus_dev_release - Destroy a virtbus device
+ * @vdev: virtual device to release
+ */
+static void virtbus_dev_release(struct device *_dev)
+{
+	struct virtbus_device *vdev = to_virtbus_dev(_dev);
+
+	ida_simple_remove(&virtbus_dev_ida, vdev->id);
+	vdev->release(vdev);
+}
+
+/**
+ * virtbus_dev_register - add a virtual bus device
+ * @vdev: virtual bus device to add
+ */
+int virtbus_dev_register(struct virtbus_device *vdev)
+{
+	int ret;
+
+	if (!vdev->release) {
+		dev_err(&vdev->dev, "virtbus_device .release callback NULL\n");
+		return -EINVAL;
+	}
+
+	device_initialize(&vdev->dev);
+
+	vdev->dev.bus = &virtual_bus_type;
+	vdev->dev.release = virtbus_dev_release;
+	/* All device IDs are automatically allocated */
+	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
+	if (ret < 0) {
+		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
+		put_device(&vdev->dev);
+		return ret;
+	}
+
+	vdev->id = ret;
+	dev_set_name(&vdev->dev, "%s.%d", vdev->name, vdev->id);
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
+	dev_err(&vdev->dev, "Add device to virtbus failed!\n");
+	put_device(&vdev->dev);
+	ida_simple_remove(&virtbus_dev_ida, vdev->id);
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
+	device_del(&vdev->dev);
+	put_device(&vdev->dev);
+}
+EXPORT_SYMBOL_GPL(virtbus_dev_unregister);
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
+	ret = vdrv->probe(vdev);
+	if (ret) {
+		dev_err(&vdev->dev, "Probe returned error\n");
+		dev_pm_domain_detach(_dev, true);
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
+	ret = vdrv->remove(vdev);
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
+	vdrv->shutdown(vdev);
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
+	if (!vdrv->probe || !vdrv->remove || !vdrv->shutdown || !vdrv->id_table)
+		return -EINVAL;
+
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
+	ida_destroy(&virtbus_dev_ida);
+}
+
+module_init(virtual_bus_init);
+module_exit(virtual_bus_exit);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index e3596db077dc..442f82128a2f 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -821,4 +821,12 @@ struct wmi_device_id {
 	const void *context;
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
index 000000000000..2cbc0e72e182
--- /dev/null
+++ b/include/linux/virtual_bus.h
@@ -0,0 +1,57 @@
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
+struct virtbus_device {
+	struct device dev;
+	const char *name;
+	void (*release)(struct virtbus_device *);
+	int id;
+	const struct virtbus_dev_id *matched_element;
+};
+
+/* The memory for the table is expected to remain allocated for the duration
+ * of the pairing between driver and device.  The pointer for the matching
+ * element will be copied to the matched_element field of the virtbus_device.
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
+int virtbus_dev_register(struct virtbus_device *vdev);
+void virtbus_dev_unregister(struct virtbus_device *vdev);
+int __virtbus_drv_register(struct virtbus_driver *vdrv, struct module *owner);
+void virtbus_drv_unregister(struct virtbus_driver *vdrv);
+
+#define virtbus_drv_register(vdrv) \
+	__virtbus_drv_register(vdrv, THIS_MODULE)
+
+#endif /* _VIRTUAL_BUS_H_ */
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index 054405b90ba4..9a6099bf90c8 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -231,5 +231,8 @@ int main(void)
 	DEVID(wmi_device_id);
 	DEVID_FIELD(wmi_device_id, guid_string);
 
+	DEVID(virtbus_dev_id);
+	DEVID_FIELD(virtbus_dev_id, name);
+
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index c91eba751804..713fdfe010b0 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1335,6 +1335,13 @@ static int do_wmi_entry(const char *filename, void *symval, char *alias)
 	return 1;
 }
 
+static int do_virtbus_entry(const char *filename, void *symval, char *alias)
+{
+	DEF_FIELD_ADDR(symval, virtbus_dev_id, name);
+	sprintf(alias, VIRTBUS_MODULE_PREFIX "%s", *name);
+	return 1;
+}
+
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
 {
@@ -1407,6 +1414,7 @@ static const struct devtable devtable[] = {
 	{"typec", SIZE_typec_device_id, do_typec_entry},
 	{"tee", SIZE_tee_client_device_id, do_tee_entry},
 	{"wmi", SIZE_wmi_device_id, do_wmi_entry},
+	{"virtbus", SIZE_virtbus_dev_id, do_virtbus_entry},
 };
 
 /* Create MODULE_ALIAS() statements.
-- 
2.24.1


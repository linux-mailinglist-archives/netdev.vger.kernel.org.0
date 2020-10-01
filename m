Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B6A27F8E1
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 07:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgJAFJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 01:09:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:7039 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgJAFJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 01:09:41 -0400
IronPort-SDR: kvpM2IqdBY+IngfoX6NgK4q9TLqBTzvBDJdUfScoMHJs0bPV32WG/uneRnULO/Bw9uXXAQKIyM
 zEv8PSf1eKIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="224238484"
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="224238484"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 22:09:37 -0700
IronPort-SDR: nlyNjKlaRzw2WTKXbqLOdFdpIO18ESygjx7UvzSUwFyzA9u7Rc+dwD9BRJXw7eYJu+sy1bWWlq
 cUBo+kC10IuQ==
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="341443342"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 22:09:37 -0700
From:   Dave Ertman <david.m.ertman@intel.com>
To:     netdev@vger.kernel.org
Subject: [PATCH 1/6] Add ancillary bus support
Date:   Wed, 30 Sep 2020 22:08:46 -0700
Message-Id: <20201001050851.890722-2-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001050851.890722-1-david.m.ertman@intel.com>
References: <20201001050851.890722-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
It enables drivers to create an ancillary_device and bind an
ancillary_driver to it.

The bus supports probe/remove shutdown and suspend/resume callbacks.
Each ancillary_device has a unique string based id; driver binds to
an ancillary_device based on this id through the bus.

Co-developed-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 Documentation/driver-api/ancillary_bus.rst | 230 +++++++++++++++++++++
 Documentation/driver-api/index.rst         |   1 +
 drivers/bus/Kconfig                        |   3 +
 drivers/bus/Makefile                       |   3 +
 drivers/bus/ancillary.c                    | 191 +++++++++++++++++
 include/linux/ancillary_bus.h              |  58 ++++++
 include/linux/mod_devicetable.h            |   8 +
 scripts/mod/devicetable-offsets.c          |   3 +
 scripts/mod/file2alias.c                   |   8 +
 9 files changed, 505 insertions(+)
 create mode 100644 Documentation/driver-api/ancillary_bus.rst
 create mode 100644 drivers/bus/ancillary.c
 create mode 100644 include/linux/ancillary_bus.h

diff --git a/Documentation/driver-api/ancillary_bus.rst b/Documentation/driver-api/ancillary_bus.rst
new file mode 100644
index 000000000000..0a11979aa927
--- /dev/null
+++ b/Documentation/driver-api/ancillary_bus.rst
@@ -0,0 +1,230 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+=============
+Ancillary Bus
+=============
+
+In some subsystems, the functionality of the core device (PCI/ACPI/other) is
+too complex for a single device to be managed as a monolithic block or a part of
+the functionality needs to be exposed to a different subsystem.  Splitting the
+functionality into smaller orthogonal devices would make it easier to manage
+data, power management and domain-specific interaction with the hardware. A key
+requirement for such a split is that there is no dependency on a physical bus,
+device, register accesses or regmap support. These individual devices split from
+the core cannot live on the platform bus as they are not physical devices that
+are controlled by DT/ACPI. The same argument applies for not using MFD in this
+scenario as MFD relies on individual function devices being physical devices
+that are DT enumerated.
+
+An example for this kind of requirement is the audio subsystem where a single
+IP is handling multiple entities such as HDMI, Soundwire, local devices such as
+mics/speakers etc. The split for the core's functionality can be arbitrary or
+be defined by the DSP firmware topology and include hooks for test/debug. This
+allows for the audio core device to be minimal and focused on hardware-specific
+control and communication.
+
+The ancillary bus is intended to be minimal, generic and avoid domain-specific
+assumptions. Each ancillary_device represents a part of its parent
+functionality. The generic behavior can be extended and specialized as needed
+by encapsulating an ancillary_device within other domain-specific structures and
+the use of .ops callbacks. Devices on the ancillary bus do not share any
+structures and the use of a communication channel with the parent is
+domain-specific.
+
+When Should the Ancillary Bus Be Used
+=====================================
+
+The ancillary bus is to be used when a driver and one or more kernel modules,
+who share a common header file with the driver, need a mechanism to connect and
+provide access to a shared object allocated by the ancillary_device's
+registering driver.  The registering driver for the ancillary_device(s) and the
+kernel module(s) registering ancillary_drivers can be from the same subsystem,
+or from multiple subsystems.
+
+The emphasis here is on a common generic interface that keeps subsystem
+customization out of the bus infrastructure.
+
+One example could be a multi-port PCI network device that is rdma-capable and
+needs to export this functionality and attach to an rdma driver in another
+subsystem.  The PCI driver will allocate and register an ancillary_device for
+each physical function on the NIC.  The rdma driver will register an
+ancillary_driver that will be matched with and probed for each of these
+ancillary_devices.  This will give the rdma driver access to the shared data/ops
+in the PCI drivers shared object to establish a connection with the PCI driver.
+
+Another use case is for the a PCI device to be split out into multiple sub
+functions.  For each sub function an ancillary_device will be created.  A PCI
+sub function driver will bind to such devices that will create its own one or
+more class devices.  A PCI sub function ancillary device will likely be
+contained in a struct with additional attributes such as user defined sub
+function number and optional attributes such as resources and a link to the
+parent device.  These attributes could be used by systemd/udev; and hence should
+be initialized before a driver binds to an ancillary_device.
+
+Ancillary Device
+================
+
+An ancillary_device is created and registered to represent a part of its parent
+device's functionality. It is given a name that, combined with the registering
+drivers KBUILD_MODNAME, creates a match_name that is used for driver binding,
+and an id that combined with the match_name provide a unique name to register
+with the bus subsystem.
+
+Registering an ancillary_device is a two-step process.  First you must call
+ancillary_device_initialize(), which will check several aspects of the
+ancillary_device struct and perform a device_initialize().  After this step
+completes, any error state must have a call to put_device() in its resolution
+path.  The second step in registering an ancillary_device is to perform a call
+to ancillary_device_add(), which will set the name of the device and add the
+device to the bus.
+
+To unregister an ancillary_device, just a call to ancillary_device_unregister()
+is used.  This will perform both a device_del() and a put_device().
+
+.. code-block:: c
+
+	struct ancillary_device {
+		struct device dev;
+                const char *name;
+		u32 id;
+	};
+
+If two ancillary_devices both with a match_name "mod.foo" are registered onto
+the bus, they must have unique id values (e.g. "x" and "y") so that the
+registered devices names will be "mod.foo.x" and "mod.foo.y".  If match_name +
+id are not unique, then the device_add will fail and generate an error message.
+
+The ancillary_device.dev.type.release or ancillary_device.dev.release must be
+populated with a non-NULL pointer to successfully register the ancillary_device.
+
+The ancillary_device.dev.parent must also be populated.
+
+Ancillary Device Memory Model and Lifespan
+------------------------------------------
+
+When a kernel driver registers an ancillary_device on the ancillary bus, we will
+use the nomenclature to refer to this kernel driver as a registering driver.  It
+is the entity that will allocate memory for the ancillary_device and register it
+on the ancillary bus.  It is important to note that, as opposed to the platform
+bus, the registering driver is wholly responsible for the management for the
+memory used for the driver object.
+
+A parent object, defined in the shared header file, will contain the
+ancillary_device.  It will also contain a pointer to the shared object(s), which
+will also be defined in the shared header.  Both the parent object and the
+shared object(s) will be allocated by the registering driver.  This layout
+allows the ancillary_driver's registering module to perform a container_of()
+call to go from the pointer to the ancillary_device, that is passed during the
+call to the ancillary_driver's probe function, up to the parent object, and then
+have access to the shared object(s).
+
+The memory for the ancillary_device will be freed only in its release()
+callback flow as defined by its registering driver.
+
+The memory for the shared object(s) must have a lifespan equal to, or greater
+than, the lifespan of the memory for the ancillary_device.  The ancillary_driver
+should only consider that this shared object is valid as long as the
+ancillary_device is still registered on the ancillary bus.  It is up to the
+registering driver to manage (e.g. free or keep available) the memory for the
+shared object beyond the life of the ancillary_device.
+
+Registering driver must unregister all ancillary devices before its registering
+parent device's remove() is completed.
+
+Ancillary Drivers
+=================
+
+Ancillary drivers follow the standard driver model convention, where
+discovery/enumeration is handled by the core, and drivers
+provide probe() and remove() methods. They support power management
+and shutdown notifications using the standard conventions.
+
+.. code-block:: c
+
+	struct ancillary_driver {
+		int (*probe)(struct ancillary_device *,
+                             const struct ancillary_device_id *id);
+		int (*remove)(struct ancillary_device *);
+		void (*shutdown)(struct ancillary_device *);
+		int (*suspend)(struct ancillary_device *, pm_message_t);
+		int (*resume)(struct ancillary_device *);
+		struct device_driver driver;
+		const struct ancillary_device_id *id_table;
+	};
+
+Ancillary drivers register themselves with the bus by calling
+ancillary_driver_register(). The id_table contains the match_names of ancillary
+devices that a driver can bind with.
+
+Example Usage
+=============
+
+Ancillary devices are created and registered by a subsystem-level core device
+that needs to break up its functionality into smaller fragments. One way to
+extend the scope of an ancillary_device would be to encapsulate it within a
+domain-specific structure defined by the parent device. This structure contains
+the ancillary_device and any associated shared data/callbacks needed to
+establish the connection with the parent.
+
+An example would be:
+
+.. code-block:: c
+
+        struct foo {
+		struct ancillary_device ancildev;
+		void (*connect)(struct ancillary_device *ancildev);
+		void (*disconnect)(struct ancillary_device *ancildev);
+		void *data;
+        };
+
+The parent device would then register the ancillary_device by calling
+ancillary_device_initialize(), and then ancillary_device_add(), with the pointer
+to the ancildev member of the above structure. The parent would provide a name
+for the ancillary_device that, combined with the parent's KBUILD_MODNAME, will
+create a match_name that will be used for matching and binding with a driver.
+
+Whenever an ancillary_driver is registered, based on the match_name, the
+ancillary_driver's probe() is invoked for the matching devices.  The
+ancillary_driver can also be encapsulated inside custom drivers that make the
+core device's functionality extensible by adding additional domain-specific ops
+as follows:
+
+.. code-block:: c
+
+	struct my_ops {
+		void (*send)(struct ancillary_device *ancildev);
+		void (*receive)(struct ancillary_device *ancildev);
+	};
+
+
+	struct my_driver {
+		struct ancillary_driver ancillary_drv;
+		const struct my_ops ops;
+	};
+
+An example of this type of usage would be:
+
+.. code-block:: c
+
+	const struct ancillary_device_id my_ancillary_id_table[] = {
+		{ .name = "foo_mod.foo_dev" },
+		{ },
+	};
+
+	const struct my_ops my_custom_ops = {
+		.send = my_tx,
+		.receive = my_rx,
+	};
+
+	const struct my_driver my_drv = {
+		.ancillary_drv = {
+			.driver = {
+				.name = "myancillarydrv",
+			},
+			.id_table = my_ancillary_id_table,
+			.probe = my_probe,
+			.remove = my_remove,
+			.shutdown = my_shutdown,
+		},
+		.ops = my_custom_ops,
+	};
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index 5ef2cfe3a16b..9584ac2ed1f5 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -74,6 +74,7 @@ available subsections can be seen below.
    thermal/index
    fpga/index
    acpi/index
+   ancillary_bus
    backlight/lp855x-driver.rst
    connector
    console
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 0c262c2aeaf2..ba82a045b847 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -5,6 +5,9 @@
 
 menu "Bus devices"
 
+config ANCILLARY_BUS
+       tristate
+
 config ARM_CCI
 	bool
 
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 397e35392bff..1fd238094543 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -3,6 +3,9 @@
 # Makefile for the bus drivers.
 #
 
+#Ancillary bus driver
+obj-$(CONFIG_ANCILLARY_BUS)	+= ancillary.o
+
 # Interconnect bus drivers for ARM platforms
 obj-$(CONFIG_ARM_CCI)		+= arm-cci.o
 obj-$(CONFIG_ARM_INTEGRATOR_LM)	+= arm-integrator-lm.o
diff --git a/drivers/bus/ancillary.c b/drivers/bus/ancillary.c
new file mode 100644
index 000000000000..2d940fe5717a
--- /dev/null
+++ b/drivers/bus/ancillary.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Software based bus for Ancillary devices
+ *
+ * Copyright (c) 2019-2020 Intel Corporation
+ *
+ * Please see Documentation/driver-api/ancillary_bus.rst for more information.
+ */
+
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pm_domain.h>
+#include <linux/pm_runtime.h>
+#include <linux/string.h>
+#include <linux/ancillary_bus.h>
+
+static const struct ancillary_device_id *ancillary_match_id(const struct ancillary_device_id *id,
+							    const struct ancillary_device *ancildev)
+{
+
+	while (id->name[0]) {
+		const char *p = strrchr(dev_name(&ancildev->dev), '.');
+		int match_size;
+
+		if (!p)
+			continue;
+		match_size = p - dev_name(&ancildev->dev);
+
+		/* use dev_name(&ancildev->dev) prefix before last '.' char to match to */
+		if (!strncmp(dev_name(&ancildev->dev), id->name, match_size))
+			return id;
+		id++;
+	}
+	return NULL;
+}
+
+static int ancillary_match(struct device *dev, struct device_driver *drv)
+{
+	struct ancillary_device *ancildev = to_ancillary_dev(dev);
+	struct ancillary_driver *ancildrv = to_ancillary_drv(drv);
+
+	return !!ancillary_match_id(ancildrv->id_table, ancildev);
+}
+
+static int ancillary_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	const char *name, *p;
+
+	name = dev_name(dev);
+	p = strrchr(name, '.');
+
+	return add_uevent_var(env, "MODALIAS=%s%.*s", ANCILLARY_MODULE_PREFIX, (int)(p - name),
+			      name);
+}
+
+static const struct dev_pm_ops ancillary_dev_pm_ops = {
+	SET_RUNTIME_PM_OPS(pm_generic_runtime_suspend, pm_generic_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_generic_suspend, pm_generic_resume)
+};
+
+struct bus_type ancillary_bus_type = {
+	.name = "ancillary",
+	.match = ancillary_match,
+	.uevent = ancillary_uevent,
+	.pm = &ancillary_dev_pm_ops,
+};
+
+/**
+ * ancillary_device_initialize - check ancillary_device and initialize
+ * @ancildev: ancillary device struct
+ */
+int ancillary_device_initialize(struct ancillary_device *ancildev)
+{
+	struct device *dev = &ancildev->dev;
+
+	dev->bus = &ancillary_bus_type;
+
+	if (WARN_ON(!dev->parent) || WARN_ON(!ancildev->name) ||
+	    WARN_ON(!(dev->type && dev->type->release) && !dev->release))
+		return -EINVAL;
+
+	device_initialize(&ancildev->dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ancillary_device_initialize);
+
+/**
+ * __ancillary_device_add - add an ancillary bus device
+ * @ancildev: ancillary bus device to add to the bus
+ * @modname: name of the parent device's driver module
+ */
+int __ancillary_device_add(struct ancillary_device *ancildev, const char *modname)
+{
+	struct device *dev = &ancildev->dev;
+	int ret;
+
+	if (WARN_ON(!modname))
+		return -EINVAL;
+
+	ret = dev_set_name(dev, "%s.%s.%d", modname, ancildev->name, ancildev->id);
+	if (ret) {
+		dev_err(dev->parent, "dev_set_name failed for device: %d\n", ret);
+		return ret;
+	}
+
+	ret = device_add(dev);
+	if (ret)
+		dev_err(dev, "adding device failed!: %d\n", ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__ancillary_device_add);
+
+static int ancillary_probe_driver(struct device *dev)
+{
+	struct ancillary_driver *ancildrv = to_ancillary_drv(dev->driver);
+	struct ancillary_device *ancildev = to_ancillary_dev(dev);
+	int ret;
+
+	ret = dev_pm_domain_attach(dev, true);
+	if (ret) {
+		dev_warn(&ancildev->dev, "Failed to attach to PM Domain : %d\n", ret);
+		return ret;
+	}
+
+	ret = ancildrv->probe(ancildev, ancillary_match_id(ancildrv->id_table, ancildev));
+	if (ret)
+		dev_pm_domain_detach(dev, true);
+
+	return ret;
+}
+
+static int ancillary_remove_driver(struct device *dev)
+{
+	struct ancillary_driver *ancildrv = to_ancillary_drv(dev->driver);
+	struct ancillary_device *ancildev = to_ancillary_dev(dev);
+	int ret;
+
+	ret = ancildrv->remove(ancildev);
+	dev_pm_domain_detach(dev, true);
+
+	return ret;
+}
+
+static void ancillary_shutdown_driver(struct device *dev)
+{
+	struct ancillary_driver *ancildrv = to_ancillary_drv(dev->driver);
+	struct ancillary_device *ancildev = to_ancillary_dev(dev);
+
+	ancildrv->shutdown(ancildev);
+}
+
+/**
+ * __ancillary_driver_register - register a driver for ancillary bus devices
+ * @ancildrv: ancillary_driver structure
+ * @owner: owning module/driver
+ */
+int __ancillary_driver_register(struct ancillary_driver *ancildrv, struct module *owner)
+{
+	if (WARN_ON(!ancildrv->probe) || WARN_ON(!ancildrv->remove) ||
+	    WARN_ON(!ancildrv->shutdown) || WARN_ON(!ancildrv->id_table))
+		return -EINVAL;
+
+	ancildrv->driver.owner = owner;
+	ancildrv->driver.bus = &ancillary_bus_type;
+	ancildrv->driver.probe = ancillary_probe_driver;
+	ancildrv->driver.remove = ancillary_remove_driver;
+	ancildrv->driver.shutdown = ancillary_shutdown_driver;
+
+	return driver_register(&ancildrv->driver);
+}
+EXPORT_SYMBOL_GPL(__ancillary_driver_register);
+
+static int __init ancillary_bus_init(void)
+{
+	return bus_register(&ancillary_bus_type);
+}
+
+static void __exit ancillary_bus_exit(void)
+{
+	bus_unregister(&ancillary_bus_type);
+}
+
+module_init(ancillary_bus_init);
+module_exit(ancillary_bus_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Ancillary Bus");
+MODULE_AUTHOR("David Ertman <david.m.ertman@intel.com>");
+MODULE_AUTHOR("Kiran Patil <kiran.patil@intel.com>");
diff --git a/include/linux/ancillary_bus.h b/include/linux/ancillary_bus.h
new file mode 100644
index 000000000000..73b13b56403d
--- /dev/null
+++ b/include/linux/ancillary_bus.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2019-2020 Intel Corporation
+ *
+ * Please see Documentation/driver-api/ancillary_bus.rst for more information.
+ */
+
+#ifndef _ANCILLARY_BUS_H_
+#define _ANCILLARY_BUS_H_
+
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+#include <linux/slab.h>
+
+struct ancillary_device {
+	struct device dev;
+	const char *name;
+	u32 id;
+};
+
+struct ancillary_driver {
+	int (*probe)(struct ancillary_device *ancildev, const struct ancillary_device_id *id);
+	int (*remove)(struct ancillary_device *ancildev);
+	void (*shutdown)(struct ancillary_device *ancildev);
+	int (*suspend)(struct ancillary_device *ancildev, pm_message_t state);
+	int (*resume)(struct ancillary_device *ancildev);
+	struct device_driver driver;
+	const struct ancillary_device_id *id_table;
+};
+
+static inline struct ancillary_device *to_ancillary_dev(struct device *dev)
+{
+	return container_of(dev, struct ancillary_device, dev);
+}
+
+static inline struct ancillary_driver *to_ancillary_drv(struct device_driver *drv)
+{
+	return container_of(drv, struct ancillary_driver, driver);
+}
+
+int ancillary_device_initialize(struct ancillary_device *ancildev);
+int __ancillary_device_add(struct ancillary_device *ancildev, const char *modname);
+#define ancillary_device_add(ancildev) __ancillary_device_add(ancildev, KBUILD_MODNAME)
+
+static inline void ancillary_device_unregister(struct ancillary_device *ancildev)
+{
+	device_unregister(&ancildev->dev);
+}
+
+int __ancillary_driver_register(struct ancillary_driver *ancildrv, struct module *owner);
+#define ancillary_driver_register(ancildrv) __ancillary_driver_register(ancildrv, THIS_MODULE)
+
+static inline void ancillary_driver_unregister(struct ancillary_driver *ancildrv)
+{
+	driver_unregister(&ancildrv->driver);
+}
+
+#endif /* _ANCILLARY_BUS_H_ */
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 5b08a473cdba..7d596dc30833 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -838,4 +838,12 @@ struct mhi_device_id {
 	kernel_ulong_t driver_data;
 };
 
+#define ANCILLARY_NAME_SIZE 32
+#define ANCILLARY_MODULE_PREFIX "ancillary:"
+
+struct ancillary_device_id {
+	char name[ANCILLARY_NAME_SIZE];
+	kernel_ulong_t driver_data;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index 27007c18e754..79e37c4c25b3 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -243,5 +243,8 @@ int main(void)
 	DEVID(mhi_device_id);
 	DEVID_FIELD(mhi_device_id, chan);
 
+	DEVID(ancillary_device_id);
+	DEVID_FIELD(ancillary_device_id, name);
+
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 2417dd1dee33..99c4fcd82bf3 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1364,6 +1364,13 @@ static int do_mhi_entry(const char *filename, void *symval, char *alias)
 {
 	DEF_FIELD_ADDR(symval, mhi_device_id, chan);
 	sprintf(alias, MHI_DEVICE_MODALIAS_FMT, *chan);
+	return 1;
+}
+
+static int do_ancillary_entry(const char *filename, void *symval, char *alias)
+{
+	DEF_FIELD_ADDR(symval, ancillary_device_id, name);
+	sprintf(alias, ANCILLARY_MODULE_PREFIX "%s", *name);
 
 	return 1;
 }
@@ -1442,6 +1449,7 @@ static const struct devtable devtable[] = {
 	{"tee", SIZE_tee_client_device_id, do_tee_entry},
 	{"wmi", SIZE_wmi_device_id, do_wmi_entry},
 	{"mhi", SIZE_mhi_device_id, do_mhi_entry},
+	{"ancillary", SIZE_ancillary_device_id, do_ancillary_entry},
 };
 
 /* Create MODULE_ALIAS() statements.
-- 
2.26.2


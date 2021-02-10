Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA681316D6A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhBJR4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:56:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:60432 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232274AbhBJR4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:56:43 -0500
IronPort-SDR: sIoWY3t6W0qZ1hOSFQD8bf5snlt+odbceISAwdlVNTikDSfWj93g6ybvUBqZ4DRseI2pr02p/O
 2Z++gtqdMl+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201236005"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="201236005"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 09:56:02 -0800
IronPort-SDR: 8uy9I7ybgjEMVQytNpsoC1/p379sC/UlYpDSrkUSr9Id+sVi0clJ6k4Dj4cPNzh4VeqA40+v2w
 tuOMEqO8erDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="380235660"
Received: from txasoft-yocto.an.intel.com ([10.123.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 10 Feb 2021 09:56:02 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Date:   Wed, 10 Feb 2021 11:54:04 -0600
Message-Id: <20210210175423.1873-2-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20210210175423.1873-1-mike.ximing.chen@intel.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic driver functionality (load, unload, probe, and remove callbacks)
for the DLB driver.

Add documentation which describes in detail the hardware, the user
interface, device interrupts, and the driver's power-management strategy.
For more details about the driver see the documentation in the patch.

Add a DLB entry to the MAINTAINERS file.

Signed-off-by: Gage Eads <gage.eads@intel.com>
Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
Reviewed-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/misc-devices/dlb.rst   | 259 +++++++++++++++++++++++++++
 Documentation/misc-devices/index.rst |   1 +
 MAINTAINERS                          |   8 +
 drivers/misc/Kconfig                 |   1 +
 drivers/misc/Makefile                |   1 +
 drivers/misc/dlb/Kconfig             |  18 ++
 drivers/misc/dlb/Makefile            |   9 +
 drivers/misc/dlb/dlb_hw_types.h      |  32 ++++
 drivers/misc/dlb/dlb_main.c          | 156 ++++++++++++++++
 drivers/misc/dlb/dlb_main.h          |  37 ++++
 10 files changed, 522 insertions(+)
 create mode 100644 Documentation/misc-devices/dlb.rst
 create mode 100644 drivers/misc/dlb/Kconfig
 create mode 100644 drivers/misc/dlb/Makefile
 create mode 100644 drivers/misc/dlb/dlb_hw_types.h
 create mode 100644 drivers/misc/dlb/dlb_main.c
 create mode 100644 drivers/misc/dlb/dlb_main.h

diff --git a/Documentation/misc-devices/dlb.rst b/Documentation/misc-devices/dlb.rst
new file mode 100644
index 000000000000..aa79be07ee49
--- /dev/null
+++ b/Documentation/misc-devices/dlb.rst
@@ -0,0 +1,259 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+===========================================
+Intel(R) Dynamic Load Balancer Overview
+===========================================
+
+:Authors: Gage Eads and Mike Ximing Chen
+
+Contents
+========
+
+- Introduction
+- Scheduling
+- Queue Entry
+- Port
+- Queue
+- Credits
+- Scheduling Domain
+- Interrupts
+- Power Management
+- User Interface
+- Reset
+
+Introduction
+============
+
+The Intel(r) Dynamic Load Balancer (Intel(r) DLB) is a PCIe device that
+provides load-balanced, prioritized scheduling of core-to-core communication.
+
+Intel DLB is an accelerator for the event-driven programming model of
+DPDK's Event Device Library[2]. The library is used in packet processing
+pipelines that arrange for multi-core scalability, dynamic load-balancing, and
+variety of packet distribution and synchronization schemes.
+
+Intel DLB device consists of queues and arbiters that connect producer
+cores and consumer cores. The device implements load-balanced queueing features
+including:
+- Lock-free multi-producer/multi-consumer operation.
+- Multiple priority levels for varying traffic types.
+- 'Direct' traffic (i.e. multi-producer/single-consumer)
+- Simple unordered load-balanced distribution.
+- Atomic lock free load balancing across multiple consumers.
+- Queue element reordering feature allowing ordered load-balanced distribution.
+
+Note: this document uses 'DLB' when discussing the device hardware and 'dlb' when
+discussing the driver implementation.
+
+Following diagram illustrates the functional blocks of an Intel DLB device.
+
+                                       +----+
+                                       |    |
+                        +----------+   |    |   +-------+
+                       /|   IQ     |---|----|--/|       |
+                      / +----------+   |    | / |  CP   |
+                     /                 |    |/  +-------+
+        +--------+  /                  |    |
+        |        | /    +----------+   |   /|   +-------+
+        |  PP    |------|   IQ     |---|----|---|       |
+        +--------+ \    +----------+   | /  |   |  CP   |
+                    \                  |/   |   +-------+
+           ...       \     ...         |    |
+        +--------+    \               /|    |   +-------+
+        |        |     \+----------+ / |    |   |       |
+        |  PP    |------|   IQ     |/--|----|---|  CP   |
+        +--------+      +----------+   |    |   +-------+
+                                       |    |
+                                       +----+     ...
+PP: Producer Port                        |
+CP: Consumer Port                        |
+IQ: Internal Queue                   DLB Scheduler
+
+
+Scheduling Types
+================
+
+Intel DLB supports four types of scheduling of 'events' (using DPDK
+terminology), where an event can represent any type of data (e.g. a network
+packet). The first, ``directed``, is multi-producer/single-consumer style
+core-to-core communication. The remaining three are
+multi-producer/multi-consumer, and support load-balancing across the consumers.
+
+- ``Directed``: events are scheduled to a single consumer.
+
+- ``Unordered``: events are load-balanced across consumers without any ordering
+                 guarantees.
+
+- ``Ordered``: events are load-balanced across consumers, and the consumer can
+               re-enqueue its events so the device re-orders them into the
+               original order. This scheduling type allows software to
+               parallelize ordered event processing without the synchronization
+               cost of re-ordering packets.
+
+- ``Atomic``: events are load-balanced across consumers, with the guarantee that
+              events from a particular 'flow' are only scheduled to a single
+              consumer at a time (but can migrate over time). This allows, for
+              example, packet processing applications to parallelize while
+              avoiding locks on per-flow data and maintaining ordering within a
+              flow.
+
+Intel DLB provides hierarchical priority scheduling, with eight priority
+levels within each. Each consumer selects up to eight queues to receive events
+from, and assigns a priority to each of these 'connected' queues. To schedule
+an event to a consumer, the device selects the highest priority non-empty queue
+of the (up to) eight connected queues. Within that queue, the device selects
+the highest priority event available (selecting a lower priority event for
+starvation avoidance 1% of the time, by default).
+
+The device also supports four load-balanced scheduler classes of service. Each
+class of service receives a (user-configurable) guaranteed percentage of the
+scheduler bandwidth, and any unreserved bandwidth is divided evenly among the
+four classes.
+
+Queue Entry
+===========
+
+Each event is contained in a queue entry (QE), the fundamental unit of
+communication through the device, which consists of 8B of data and 8B of
+metadata, as depicted below.
+
+QE structure format
+::
+    data     :64
+    opaque   :16
+    qid      :8
+    sched    :2
+    priority :3
+    msg_type :3
+    lock_id  :16
+    rsvd     :8
+    cmd      :8
+
+The ``data`` field can be any type that fits within 8B (pointer, integer,
+etc.); DLB merely copies this field from producer to consumer. The
+``opaque`` and ``msg_type`` fields behave the same way.
+
+``qid`` is set by the producer to specify to which DLB 2.0 queue it wishes to
+enqueue this QE. The ID spaces for load-balanced and directed queues are both
+zero-based.
+
+``sched`` controls the scheduling type: atomic, unordered, ordered, or
+directed. The first three scheduling types are only valid for load-balanced
+queues, and the directed scheduling type is only valid for directed queues.
+This field distinguishes whether ``qid`` is load-balanced or directed, since
+their ID spaces overlap.
+
+``priority`` is the priority with which this QE should be scheduled.
+
+``lock_id``, used for atomic scheduling and ignored for ordered and unordered
+scheduling, identifies the atomic flow to which the QE belongs. When sending a
+directed event, ``lock_id`` is simply copied like the ``data``, ``opaque``, and
+``msg_type`` fields.
+
+``cmd`` specifies the operation, such as:
+- Enqueue a new QE
+- Forward a QE that was dequeued
+- Complete/terminate a QE that was dequeued
+- Return one or more consumer queue tokens.
+- Arm the port's consumer queue interrupt.
+
+Port
+====
+
+A core's interface to the DLB is called a "port," and consists of an MMIO
+region (producer port) through which the core enqueues a queue entry, and an
+in-memory queue (the "consumer queue" or cosumer port) to which the device
+schedules QEs. A core enqueues a QE to a device queue, then the device
+schedules the event to a port. Software specifies the connection of queues
+and ports; i.e. for each queue, to which ports the device is allowed to
+schedule its events. The device uses a credit scheme to prevent overflow of
+the on-device queue storage.
+
+Applications interface directly with the device by mapping the port's memory
+and MMIO regions into the application's address space for enqueue and dequeue
+operations, but call into the kernel driver for configuration operations. An
+application can be polling- or interrupt-driven; DLB supports both modes
+of operation.
+
+Internal Queue
+==============
+
+A DLB device supports an implementation specific and runtime discoverable
+number of load-balanced (i.e. capable of atomic, ordered, and unordered
+scheduling) and directed queues. Each internal queue supports a set of
+priority levels.
+
+A load-balanced queue is capable of scheduling its events to any combination of
+load-balanced ports, whereas each directed queue has one-to-one mapping with a
+directed port. There is no restriction on port or queue types when a port
+enqueues an event to a queue; that is, a load-balanced port can enqueue to a
+directed queue and vice versa.
+
+Credits
+=======
+
+The Intel DLB uses a credit scheme to prevent overflow of the on-device
+queue storage, with separate credits for load-balanced and directed queues. A
+port spends one credit when it enqueues a QE, and one credit is replenished
+when a QE is scheduled to a consumer queue. Each scheduling domain has one pool
+of load-balanced credits and one pool of directed credits; software is
+responsible for managing the allocation and replenishment of these credits among
+the scheduling domain's ports.
+
+Scheduling Domain
+=================
+
+Device resources -- including ports, queues, and credits -- are contained
+within a scheduling domain. Scheduling domains are isolated from one another; a
+port can only enqueue to and dequeue from queues within its scheduling domain.
+
+The scheduling domain creation ioctl returns a domain file descriptor, through
+which the domain's resources are configured. For a multi-process scenario, the
+owner of this descriptor must share it with the other processes (e.g. inherited
+through fork() or shared over a unix domain socket).
+
+Consumer Queue Interrupts
+=========================
+
+Each port has its own interrupt which fires, if armed, when the consumer queue
+depth becomes non-zero. Software arms an interrupt by enqueueing a special
+'interrupt arm' command to the device through the port's MMIO window.
+
+Power Management
+================
+
+The kernel driver keeps the device in D3Hot when not in use. The driver
+transitions the device to D0 when the first device file is opened, and keeps it
+there until there are no open device files or memory mappings.
+
+User Interface
+==============
+
+The dlb driver uses ioctls as its primary interface. It provides two types of
+files: the dlb device file and the scheduling domain file.
+
+The two types support different ioctl interfaces; the dlb device file is used
+for device-wide operations (including scheduling domain creation), and the
+scheduling domain device file supports operations on the scheduling domain's
+resources such as port and queue configuration.
+
+The dlb device file is created during driver probe and is located at
+/dev/dlb<N>, where N is the zero-based device ID. The scheduling domain fd is
+an anonymous inode created by a dlb device ioctl.
+
+The driver also exports an mmap interface through port files, which are
+acquired through scheduling domain ioctls. This mmap interface is used to map
+a port's memory and MMIO window into the process's address space. Once the
+ports are mapped, applications may use 64-byte direct-store instructions such
+movdir64b or enqcmd to enqueue the events for better performance.
+
+Reset
+=====
+
+The dlb driver currently supports scheduling domain reset.
+
+Scheduling domain reset occurs when an application stops using its domain.
+Specifically, when no more file references or memory mappings exist. At this
+time, the driver resets all the domain's resources (flushes its queues and
+ports) and puts them in their respective available-resource lists for later
+use.
diff --git a/Documentation/misc-devices/index.rst b/Documentation/misc-devices/index.rst
index 64420b3314fe..c9954e8b72a3 100644
--- a/Documentation/misc-devices/index.rst
+++ b/Documentation/misc-devices/index.rst
@@ -17,6 +17,7 @@ fit into other categories.
    ad525x_dpot
    apds990x
    bh1770glc
+   dlb
    eeprom
    c2port
    ibmvmc
diff --git a/MAINTAINERS b/MAINTAINERS
index 6eff4f720c72..b408c1ec8fdf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8896,6 +8896,14 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	arch/x86/include/asm/intel-family.h
 
+INTEL DYNAMIC LOAD BALANCER DRIVER
+M:	Mike Ximing Chen <mike.ximing.chen@intel.com>
+M:	Gage Eads <gage.eads@intel.com>
+S:	Maintained
+F:	Documentation/ABI/testing/sysfs-driver-dlb
+F:	drivers/misc/dlb/
+F:	include/uapi/linux/dlb_user.h
+
 INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
 M:	Jani Nikula <jani.nikula@linux.intel.com>
 M:	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index fafa8b0d8099..fef26819eb1e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -481,4 +481,5 @@ source "drivers/misc/ocxl/Kconfig"
 source "drivers/misc/cardreader/Kconfig"
 source "drivers/misc/habanalabs/Kconfig"
 source "drivers/misc/uacce/Kconfig"
+source "drivers/misc/dlb/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index d23231e73330..a0bafe336277 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_HABANA_AI)		+= habanalabs/
 obj-$(CONFIG_UACCE)		+= uacce/
 obj-$(CONFIG_XILINX_SDFEC)	+= xilinx_sdfec.o
 obj-$(CONFIG_HISI_HIKEY_USB)	+= hisi_hikey_usb.o
+obj-$(CONFIG_INTEL_DLB)		+= dlb/
diff --git a/drivers/misc/dlb/Kconfig b/drivers/misc/dlb/Kconfig
new file mode 100644
index 000000000000..cfa978c705bd
--- /dev/null
+++ b/drivers/misc/dlb/Kconfig
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config INTEL_DLB
+	tristate "Intel Dynamic Load Balancer Driver"
+	depends on 64BIT && PCI && X86
+	help
+	  This driver supports the Intel Dynamic Load Balancer (DLB), a
+	  PCIe device (PCI ID 8086:27xx) that provides load-balanced,
+	  prioritized scheduling of core-to-core communication and improves
+	  DPDK Event Device library performance.
+
+	  The user-space interface is described in
+	  include/uapi/linux/dlb_user.h
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called dlb.
+
+	  If unsure, select N.
diff --git a/drivers/misc/dlb/Makefile b/drivers/misc/dlb/Makefile
new file mode 100644
index 000000000000..8911375effd2
--- /dev/null
+++ b/drivers/misc/dlb/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+#
+# Makefile for the Intel(R) Dynamic Load Balancer (dlb.ko) driver
+#
+
+obj-$(CONFIG_INTEL_DLB) := dlb.o
+
+dlb-objs := dlb_main.o
diff --git a/drivers/misc/dlb/dlb_hw_types.h b/drivers/misc/dlb/dlb_hw_types.h
new file mode 100644
index 000000000000..778ec8665ea0
--- /dev/null
+++ b/drivers/misc/dlb/dlb_hw_types.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#ifndef __DLB_HW_TYPES_H
+#define __DLB_HW_TYPES_H
+
+#define DLB_MAX_NUM_VDEVS			16
+#define DLB_MAX_NUM_DOMAINS			32
+#define DLB_MAX_NUM_LDB_QUEUES			32 /* LDB == load-balanced */
+#define DLB_MAX_NUM_DIR_QUEUES			64 /* DIR == directed */
+#define DLB_MAX_NUM_LDB_PORTS			64
+#define DLB_MAX_NUM_DIR_PORTS			DLB_MAX_NUM_DIR_QUEUES
+#define DLB_MAX_NUM_LDB_CREDITS			8192
+#define DLB_MAX_NUM_DIR_CREDITS			2048
+#define DLB_MAX_NUM_HIST_LIST_ENTRIES		2048
+#define DLB_MAX_NUM_AQED_ENTRIES		2048
+#define DLB_MAX_NUM_QIDS_PER_LDB_CQ		8
+#define DLB_MAX_NUM_SEQUENCE_NUMBER_GROUPS	2
+#define DLB_MAX_NUM_SEQUENCE_NUMBER_MODES	5
+#define DLB_QID_PRIORITIES			8
+#define DLB_NUM_ARB_WEIGHTS			8
+#define DLB_MAX_WEIGHT				255
+#define DLB_NUM_COS_DOMAINS			4
+#define DLB_MAX_CQ_COMP_CHECK_LOOPS		409600
+#define DLB_MAX_QID_EMPTY_CHECK_LOOPS		(32 * 64 * 1024 * (800 / 30))
+#define DLB_HZ					800000000
+#define DLB_FUNC_BAR				0
+#define DLB_CSR_BAR				2
+
+#define PCI_DEVICE_ID_INTEL_DLB_PF		0x2710
+
+#endif /* __DLB_HW_TYPES_H */
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
new file mode 100644
index 000000000000..fbd77203b398
--- /dev/null
+++ b/drivers/misc/dlb/dlb_main.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include <linux/aer.h>
+#include <linux/cdev.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/uaccess.h>
+
+#include "dlb_main.h"
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Intel(R) Dynamic Load Balancer (DLB) Driver");
+
+static struct class *dlb_class;
+static dev_t dlb_devt;
+static DEFINE_IDR(dlb_ids);
+static DEFINE_SPINLOCK(dlb_ids_lock);
+
+/**********************************/
+/****** PCI driver callbacks ******/
+/**********************************/
+
+static int dlb_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
+{
+	struct dlb *dlb;
+	int ret;
+
+	dlb = devm_kzalloc(&pdev->dev, sizeof(*dlb), GFP_KERNEL);
+	if (!dlb)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, dlb);
+
+	dlb->pdev = pdev;
+
+	spin_lock(&dlb_ids_lock);
+	dlb->id = idr_alloc(&dlb_ids, (void *)dlb, 0, DLB_MAX_NUM_DEVICES - 1,
+			    GFP_KERNEL);
+	spin_unlock(&dlb_ids_lock);
+
+	if (dlb->id < 0) {
+		dev_err(&pdev->dev, "probe: device ID allocation failed\n");
+
+		ret = dlb->id;
+		goto alloc_id_fail;
+	}
+
+	ret = pcim_enable_device(pdev);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "pcim_enable_device() returned %d\n", ret);
+
+		goto pci_enable_device_fail;
+	}
+
+	ret = pcim_iomap_regions(pdev,
+				 (1U << DLB_CSR_BAR) | (1U << DLB_FUNC_BAR),
+				 "dlb");
+	if (ret != 0) {
+		dev_err(&pdev->dev, "pcim_iomap_regions(): returned %d\n", ret);
+
+		goto pci_enable_device_fail;
+	}
+
+	pci_set_master(pdev);
+
+	ret = pci_enable_pcie_error_reporting(pdev);
+	if (ret != 0)
+		dev_info(&pdev->dev, "Failed to enable AER %d\n", ret);
+
+	return 0;
+
+pci_enable_device_fail:
+	spin_lock(&dlb_ids_lock);
+	idr_remove(&dlb_ids, dlb->id);
+	spin_unlock(&dlb_ids_lock);
+alloc_id_fail:
+	return ret;
+}
+
+static void dlb_remove(struct pci_dev *pdev)
+{
+	struct dlb *dlb = pci_get_drvdata(pdev);
+
+	pci_disable_pcie_error_reporting(pdev);
+
+	spin_lock(&dlb_ids_lock);
+	idr_remove(&dlb_ids, dlb->id);
+	spin_unlock(&dlb_ids_lock);
+}
+
+static struct pci_device_id dlb_id_table[] = {
+	{ PCI_DEVICE_DATA(INTEL, DLB_PF, DLB_PF) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, dlb_id_table);
+
+static struct pci_driver dlb_pci_driver = {
+	.name		 = "dlb",
+	.id_table	 = dlb_id_table,
+	.probe		 = dlb_probe,
+	.remove		 = dlb_remove,
+};
+
+static int __init dlb_init_module(void)
+{
+	int err;
+
+	dlb_class = class_create(THIS_MODULE, "dlb");
+
+	if (IS_ERR(dlb_class)) {
+		pr_err("dlb: class_create() returned %ld\n",
+		       PTR_ERR(dlb_class));
+
+		return PTR_ERR(dlb_class);
+	}
+
+	err = alloc_chrdev_region(&dlb_devt, 0, DLB_MAX_NUM_DEVICES, "dlb");
+
+	if (err < 0) {
+		pr_err("dlb: alloc_chrdev_region() returned %d\n", err);
+
+		goto alloc_chrdev_fail;
+	}
+
+	err = pci_register_driver(&dlb_pci_driver);
+	if (err < 0) {
+		pr_err("dlb: pci_register_driver() returned %d\n", err);
+
+		goto pci_register_fail;
+	}
+
+	return 0;
+
+pci_register_fail:
+	unregister_chrdev_region(dlb_devt, DLB_MAX_NUM_DEVICES);
+alloc_chrdev_fail:
+	class_destroy(dlb_class);
+
+	return err;
+}
+
+static void __exit dlb_exit_module(void)
+{
+	pci_unregister_driver(&dlb_pci_driver);
+
+	unregister_chrdev_region(dlb_devt, DLB_MAX_NUM_DEVICES);
+
+	class_destroy(dlb_class);
+}
+
+module_init(dlb_init_module);
+module_exit(dlb_exit_module);
diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
new file mode 100644
index 000000000000..ab2a2014bafd
--- /dev/null
+++ b/drivers/misc/dlb/dlb_main.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
+
+#ifndef __DLB_MAIN_H
+#define __DLB_MAIN_H
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/ktime.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+
+#include "dlb_hw_types.h"
+
+/*
+ * The dlb driver uses a different minor number for each device file, of which
+ * there are:
+ * - 33 per device (PF or VF/VDEV): 1 for the device, 32 for scheduling domains
+ * - Up to 17 devices per PF: 1 PF and up to 16 VFs/VDEVs
+ * - Up to 16 PFs per system
+ */
+#define DLB_MAX_NUM_PFS	  16
+#define DLB_NUM_FUNCS_PER_DEVICE (1 + DLB_MAX_NUM_VDEVS)
+#define DLB_MAX_NUM_DEVICES	 (DLB_MAX_NUM_PFS * DLB_NUM_FUNCS_PER_DEVICE)
+
+enum dlb_device_type {
+	DLB_PF,
+};
+
+struct dlb {
+	struct pci_dev *pdev;
+	int id;
+};
+
+#endif /* __DLB_MAIN_H */
-- 
2.17.1


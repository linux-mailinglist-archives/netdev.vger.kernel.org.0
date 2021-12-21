Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346E647BA25
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhLUGuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:50:15 -0500
Received: from mga06.intel.com ([134.134.136.31]:29879 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234070AbhLUGuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069413; x=1671605413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IwcQYEyVlORH6WB7r+MkpKU1eTPoAwWO706n86nA+JY=;
  b=VA3Ui05ZCHwPC7k+6X7Lv8tEBr5vu98qO14x1SFp7cgC2OicNk0eP3M/
   N1B8qPsUskU9fDFWXTQLtFeRGV0NTk5ng7lWKFwaUMtw5z4s/bwzIZBua
   Z88mbIy8llItLDjIGMeBMVPTwkauzD7fyxaKxcigY0TpE6fdRC0JcTVwi
   uDxzql7xCg7LXtOTSmtc1HxX4eNdVK14wN0sDiCc0BBTfP9br5sCcbrjR
   CJgm1/cbVYDH64lDo/djlSx5sWsZJZqOeOGQMEwQ4W+jMVDZocPbVJ1ma
   WuFJcAR/Z5YbqW0+S0b+jY2gthoyCaubpXYWaqhkVE5Bn84HMamTF+++R
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107455"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107455"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570118963"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:09 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Date:   Tue, 21 Dec 2021 00:50:31 -0600
Message-Id: <20211221065047.290182-2-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic driver functionality (load, unload, probe, and remove callbacks)
for the DLB driver.

Add documentation which describes in detail the hardware, the user
interface, device interrupts, and the driver's power-management strategy.
For more details about the driver see the documentation in the patch.

Add a DLB entry to the MAINTAINERS file.

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 Documentation/misc-devices/dlb.rst   | 323 +++++++++++++++++++++++++++
 Documentation/misc-devices/index.rst |   1 +
 MAINTAINERS                          |   7 +
 drivers/misc/Kconfig                 |   1 +
 drivers/misc/Makefile                |   1 +
 drivers/misc/dlb/Kconfig             |  18 ++
 drivers/misc/dlb/Makefile            |   5 +
 drivers/misc/dlb/dlb_main.c          | 156 +++++++++++++
 drivers/misc/dlb/dlb_main.h          |  64 ++++++
 9 files changed, 576 insertions(+)
 create mode 100644 Documentation/misc-devices/dlb.rst
 create mode 100644 drivers/misc/dlb/Kconfig
 create mode 100644 drivers/misc/dlb/Makefile
 create mode 100644 drivers/misc/dlb/dlb_main.c
 create mode 100644 drivers/misc/dlb/dlb_main.h

diff --git a/Documentation/misc-devices/dlb.rst b/Documentation/misc-devices/dlb.rst
new file mode 100644
index 000000000000..2e5f9ec155a5
--- /dev/null
+++ b/Documentation/misc-devices/dlb.rst
@@ -0,0 +1,323 @@
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
+The Intel(r) Dynamic Load Balancer (Intel(r) DLB) is a PCIe device and hardware
+accelerator that provides load-balanced, prioritized scheduling for event based
+workloads across CPU cores. It can be used to save CPU resources in high
+throughput pipelines by replacing software based distribution and synchronization
+schemes. Using Intel DLB in place of software based methods has been
+demonstrated to reduce CPU utilization up to 2-3 CPU cores per DLB device,
+while also improving packet processing pipeline performance.
+
+In many applications running on processors with a large number of cores,
+workloads must be distributed (load-balanced) across a number of cores.
+In packet processing applications, for example, streams of incoming packets can
+exceed the capacity of any single core. So they have to be divided between
+available worker cores. The workload can be split by either breaking the
+processing flow into stages and places distinct stages on separate cores in a
+daisy chain fashion (a pipeline), or spraying packets across multiple workers
+that may be executing the same processing stage. Many systems employ a hybrid
+approach whereby each packet encounters multiple pipelined stages with
+distribution across multiple workers at each individual stage.
+
+The following diagram shows a typical packet processing pipeline with the Intel DLB.
+
+                              WC1              WC4
+ +-----+   +----+   +---+  /      \  +---+  /      \  +---+   +----+   +-----+
+ |NIC  |   |Rx  |   |DLB| /        \ |DLB| /        \ |DLB|   |Tx  |   |NIC  |
+ |Ports|---|Core|---|   |-----WC2----|   |-----WC5----|   |---|Core|---|Ports|
+ +-----+   -----+   +---+ \        / +---+ \        / +---+   +----+   ------+
+                           \      /         \      /
+                              WC3              WC6
+
+WCs are the worker cores which process packets distributed by DLB. Without
+hardware accelerators (such as DLB) the distribution and load balancing are normally
+carried out by software running on CPU cores. Using Intel DLB in this case not only
+saves the CPU resources but also improves the system performance.
+
+The Intel DLB consists of queues and arbiters that connect producer cores (which
+enqueues events to DLB) and consumer cores (which dequeue events from DLB). The
+device implements load-balanced queueing features including:
+
+- Lock-free multi-producer/multi-consumer operation.
+- Multiple priority levels for varying traffic types.
+- Direct traffic (i.e. multi-producer/single-consumer)
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
+As shown in the diagram, the high-level Intel DLB data flow is as follows:
+ - Software threads interact with the hardware by enqueuing and dequeuing Queue
+   Elements (QEs).
+ - QEs are sent through a Producer Port (PP) to the Intel DLB internal QE
+   storage (internal queues), optionally being reordered along the way.
+ - The Intel DLB schedules QEs from internal queues to a consumer according to
+   a two-stage priority arbiter (DLB Scheduler).
+ - Once scheduled, the Intel DLB writes the QE to a memory-based Consumer Port
+   (CP), which the software thread reads and processes.
+
+
+Scheduling Types
+================
+
+Intel DLB supports four types of scheduling of 'events' (i.e., queue elements),
+where an event can represent any type of data (e.g. a network packet). The
+first, `directed`, is multi-producer/single-consumer style scheduling. The
+remaining three are multi-producer/multi-consumer, and support load-balancing
+across the consumers.
+
+- `Directed`: events are scheduled to a single consumer.
+
+- `Unordered`: events are load-balanced across consumers without any ordering
+                 guarantees.
+
+- `Ordered`: events are load-balanced across consumers, and the consumer can
+               re-enqueue its events so the device re-orders them into the
+               original order. This scheduling type allows software to
+               parallelize ordered event processing without the synchronization
+               cost of re-ordering packets.
+
+- `Atomic`: events are load-balanced across consumers, with the guarantee that
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
+Queue Element
+===========
+
+Each event is contained in a queue element (QE), the fundamental unit of
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
+The `data` field can be any type that fits within 8B (pointer, integer,
+etc.); DLB merely copies this field from producer to consumer. The
+`opaque` and `msg_type` fields behave the same way.
+
+`qid` is set by the producer to specify to which DLB internal queue it wishes
+to enqueue this QE. The ID spaces for load-balanced and directed queues are both
+zero-based.
+
+`sched` controls the scheduling type: atomic, unordered, ordered, or
+directed. The first three scheduling types are only valid for load-balanced
+queues, and the directed scheduling type is only valid for directed queues.
+This field distinguishes whether `qid` is load-balanced or directed, since
+their ID spaces overlap.
+
+`priority` is the priority with which this QE should be scheduled.
+
+`lock_id`, used for atomic scheduling and ignored for ordered and unordered
+scheduling, identifies the atomic flow to which the QE belongs. When sending a
+directed event, `lock_id` is simply copied like the `data`, `opaque`, and
+`msg_type` fields.
+
+`cmd` specifies the operation, such as:
+- Enqueue a new QE
+- Forward a QE that was dequeued
+- Complete/terminate a QE that was dequeued
+- Return one or more consumer queue tokens.
+- Arm the port's consumer queue interrupt.
+
+Port
+====
+
+A core's interface to the DLB is called a "port", and consists of an MMIO
+region (producer port) through which the core enqueues a queue element, and an
+in-memory queue (the "consumer queue" or consumer port) to which the device
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
+A load-balanced queue is capable of scheduling its events to any combination
+of load-balanced ports, whereas each directed queue can only haveone-to-one
+mapping with any directed port. There is no restriction on port or queue types
+when a port enqueues an event to a queue; that is, a load-balanced port can
+enqueue to a directed queue and vice versa.
+
+Credits
+=======
+
+The Intel DLB uses a credit scheme to prevent overflow of the on-device
+queue storage, with separate credits for load-balanced and directed queues. A
+port spends one credit when it enqueues a QE, and one credit is replenished
+when a QE is dequeued from a consumer queue. Each scheduling domain has one pool
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
+The scheduling domain with a set of resources is created through configfs, and
+can be accessed/shared by multiple processes.
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
+The kernel driver keeps the device in D3Hot (power save mode) when not in use.
+The driver transitions the device to D0 when the first device file is opened,
+and keeps it there until there are no open device files or memory mappings.
+
+User Interface
+==============
+
+The dlb driver uses configfs and sysfs as its primary user interfaces. While
+the sysfs is used to configure and inquire device-wide operation and
+resources, the configfs provides domain/queue/port level configuration and
+resource management.
+
+The dlb device level sysfs files are created during driver probe and is located
+at /sys/class/dlb/dlb<N>/device, where N is the zero-based device ID. The
+configfs directories/files can be created by user applications at
+/sys/kernel/config/dlb/dlb<N> using 'mkdir'. For example, 'mkdir domain0' will
+create a /domain0 directory and associated files in the configfs. Within the
+domain directory, directories for queues and ports can be created. An example of
+a DLB configfs structure is shown in the following diagram.
+
+                              config
+                                |
+                               dlb
+                                |
+                        +------+------+------+---
+                        |      |      |      |
+                       dlb0   dlb1   dlb2   dlb3
+                        |
+                +-----------+--+--------+-------
+                |           |           |
+             domain0     domain1     domain2
+                |
+        +-------+-----+------------+---------------+------------+------------
+        |             |            |               |            |
+ num_ldb_queues     port0         port1   ...    queue0       queue1   ...
+ num_ldb_ports        |                            |
+ ...                is_ldb                   num_sequence_numbers
+ create             cq_depth                 num_qid_inflights
+ start              ...                      num_atomic_iflights
+                    enable                   ...
+                    create                   create
+
+
+To create a domain/queue/port in DLB, an application can configure the resources
+by writing to corresponding files, and then write '1' to the 'create' file to
+trigger the action in the driver.
+
+The driver also exports an mmap interface through port files, which are
+acquired through port configfs. This mmap interface is used to map
+a port's memory and MMIO window into the process's address space. Once the
+ports are mapped, applications may use 64-byte direct-store instructions such
+as movdir64b to enqueue the events for better performance.
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
index 30ac58f81901..555257a1d45c 100644
--- a/Documentation/misc-devices/index.rst
+++ b/Documentation/misc-devices/index.rst
@@ -17,6 +17,7 @@ fit into other categories.
    ad525x_dpot
    apds990x
    bh1770glc
+   dlb
    eeprom
    c2port
    dw-xdata-pcie
diff --git a/MAINTAINERS b/MAINTAINERS
index 8d118d7957d2..8f4de91cd1fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9335,6 +9335,13 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	arch/x86/include/asm/intel-family.h
 
+INTEL DYNAMIC LOAD BALANCER DRIVER
+M:	Mike Ximing Chen <mike.ximing.chen@intel.com>
+S:	Maintained
+F:	Documentation/ABI/testing/sysfs-driver-dlb
+F:	drivers/misc/dlb/
+F:	include/uapi/linux/dlb.h
+
 INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
 M:	Jani Nikula <jani.nikula@linux.intel.com>
 M:	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0f5a49fc7c9e..e97a1b52e023 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -487,4 +487,5 @@ source "drivers/misc/cardreader/Kconfig"
 source "drivers/misc/habanalabs/Kconfig"
 source "drivers/misc/uacce/Kconfig"
 source "drivers/misc/pvpanic/Kconfig"
+source "drivers/misc/dlb/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index a086197af544..9b8f11190cdd 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -59,3 +59,4 @@ obj-$(CONFIG_UACCE)		+= uacce/
 obj-$(CONFIG_XILINX_SDFEC)	+= xilinx_sdfec.o
 obj-$(CONFIG_HISI_HIKEY_USB)	+= hisi_hikey_usb.o
 obj-$(CONFIG_HI6421V600_IRQ)	+= hi6421v600-irq.o
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
index 000000000000..a5cd3eec3304
--- /dev/null
+++ b/drivers/misc/dlb/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_INTEL_DLB) := dlb.o
+
+dlb-objs := dlb_main.o
diff --git a/drivers/misc/dlb/dlb_main.c b/drivers/misc/dlb/dlb_main.c
new file mode 100644
index 000000000000..12346ee8acf7
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
+static DEFINE_MUTEX(dlb_ids_lock);
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
+	mutex_lock(&dlb_ids_lock);
+	dlb->id = idr_alloc(&dlb_ids, (void *)dlb, 0, DLB_MAX_NUM_DEVICES - 1,
+			    GFP_KERNEL);
+	mutex_unlock(&dlb_ids_lock);
+
+	if (dlb->id < 0) {
+		dev_err(&pdev->dev, "device ID allocation failed\n");
+
+		ret = dlb->id;
+		goto alloc_id_fail;
+	}
+
+	ret = pcim_enable_device(pdev);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "failed to enable: %d\n", ret);
+
+		goto pci_enable_device_fail;
+	}
+
+	ret = pcim_iomap_regions(pdev,
+				 (1U << DLB_CSR_BAR) | (1U << DLB_FUNC_BAR),
+				 "dlb");
+	if (ret != 0) {
+		dev_err(&pdev->dev, "failed to map: %d\n", ret);
+
+		goto pci_enable_device_fail;
+	}
+
+	pci_set_master(pdev);
+
+	ret = pci_enable_pcie_error_reporting(pdev);
+	if (ret != 0)
+		dev_info(&pdev->dev, "AER is not supported\n");
+
+	return 0;
+
+pci_enable_device_fail:
+	mutex_lock(&dlb_ids_lock);
+	idr_remove(&dlb_ids, dlb->id);
+	mutex_unlock(&dlb_ids_lock);
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
+	mutex_lock(&dlb_ids_lock);
+	idr_remove(&dlb_ids, dlb->id);
+	mutex_unlock(&dlb_ids_lock);
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
index 000000000000..23f059ec86f1
--- /dev/null
+++ b/drivers/misc/dlb/dlb_main.h
@@ -0,0 +1,64 @@
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
+/*
+ * Hardware related #defines and data structures.
+ *
+ */
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
2.27.0


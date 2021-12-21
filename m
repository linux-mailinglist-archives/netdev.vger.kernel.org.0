Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF5A47BA23
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhLUGuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:50:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:29879 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231449AbhLUGuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:50:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069413; x=1671605413;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S3PtmoZyoETbBON/s5s+1zpfY39hvSJC7cXt8L82/EM=;
  b=Wp0NCN1Nf68gihhNnRxzicv9NLySHx4xcGLcYvmak2oksxsWphRkvoOS
   5aD4iy77cJ/6pRUAbtv9l9bqsBSSpyE8B84e+jEyE4mXGq2UdLdGkrX4e
   0TtcSAd3HId7TFL56vwsAUExBYdNagPsQWSGhQ2Va9uMD8t05WMeqSnXT
   YAF7cV8t/l2ma54ArZInnVJ40TxJPzxREtF2600C967OuNgIv2nOibToT
   ZntDfiRjGbfDcOLPpVuiQMiEecCZkJg5GbrDfjXVFGllH5E9ff1R1jfhi
   urkCfeKy3ZWk1am20EHFyBCSct+rSvVXs/QRy2f+P5MVRWVsF/W9GNKZY
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107450"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107450"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570118951"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:06 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
Date:   Tue, 21 Dec 2021 00:50:30 -0600
Message-Id: <20211221065047.290182-1-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Intel(r) Dynamic Load Balancer (Intel(r) DLB) is a PCIe device and hardware
accelerator that provides load-balanced, prioritized scheduling for event based
workloads across CPU cores. It can be used to save CPU resources in high
throughput pipelines by replacing software based distribution and synchronization
schemes. Using Intel DLB has been demonstrated to reduce CPU utilization up to
2-3 CPU cores per DLB device, while also improving packet processing pipeline
performance.

In many applications running on processors with a large number of cores,
workloads must be distributed (load-balanced) across a number of cores.
In packet processing applications, for example, streams of incoming packets can
exceed the capacity of any single core. So they have to be divided between
available worker cores. The workload can be split by either breaking the
processing flow into stages and places distinct stages on separate cores in a
daisy chain fashion (a pipeline), or spraying packets across multiple workers
that may be executing the same processing stage. Many systems employ a hybrid
approach whereby each packet encounters multiple pipelined stages with
distribution across multiple workers at each individual stage.

Intel DLB distribution schemes include "parallel" (packets are load-balanced
across multiple cores and processed in parallel), "ordered" (similar to
"parallel" but packets are reordered into ingress order by the device), and
"atomic" (packet flows are scheduled to a single core at a time such that
locks are not required to access per-flow data, and dynamically migrated to
ensure load-balance).

Intel DLB consists of queues and arbiters that connect producer
cores and consumer cores. The device implements load-balanced queueing
features including:
- Lock-free multi-producer/multi-consumer operation.
- Multiple priority levels for varying traffic types.
- 'Direct' traffic (i.e. multi-producer/single-consumer)
- Simple unordered load-balanced distribution.
- Atomic lock free load balancing across multiple consumers.
- Queue element reordering feature allowing ordered load-balanced
  distribution.

The fundamental unit of communication through the device is a queue element
(QE), which consists of 8B of data and 8B of metadata (destination queue,
priority, etc.). The data field can be any type that fits within 8B.

A core's interface to the device, a "port," consists of a memory-mappable
region through which the core enqueues a queue entry, and an in-memory
queue (the "consumer queue") to which the device schedules QEs. Each QE
is enqueued to a device-managed queue, and from there scheduled to a port.
Software specifies the "linking" of queues and ports; i.e. which ports the
device is allowed to schedule to for a given queue. The device uses a
credit scheme to prevent overflow of the on-device queue storage.

Applications can interface directly with the device by mapping the port's
memory and MMIO regions into the application's address space for enqueue
and dequeue operations, but call into the kernel driver for configuration
operations. An application can also be polling- or interrupt-driven;
Intel DLB supports both modes of operation.

Device resources -- i.e. ports, queues, and credits -- are contained within
a scheduling domain. Scheduling domains are isolated from one another; a
port can only enqueue to and dequeue from queues within its scheduling
domain. A scheduling domain's resources are configured through a configfs
interface. Please refer to Documentation/misc-devices/dlb.rst (in patch 01/17)
for a detailed description on the DLB configfs implementation.

Intel DLB supports SR-IOV and Scalable IOV, and allows for a flexible
division of its resources among the PF and its virtual devices. The virtual
devices are incapable of configuring the device directly; they use a
hardware mailbox to proxy configuration requests to the PF driver. This
driver supports both PF and virtual devices, as there is significant code
re-use between the two, with device-specific behavior handled through a
callback interface.  Virtualization support will be added in a later patch
set.

The DLB driver uses configfs and sysfs as its primary interface While the
DLB sysfs allows users to configure DLB at the device level, the configfs
lets users to create and control DLB scheduling domains, ports and queues.
Configfs supports operations on a scheduling domain's resources
(primarily resource configuration).  Scheduling domains are created
dynamically by user-space software.

[1] https://builders.intel.com/docs/networkbuilders/SKU-343247-001US-queue-management-and-load-balancing-on-intel-architecture.pdf
[2] https://doc.dpdk.org/guides/prog_guide/eventdev.html

This submission is still a work in progress. We have replaced ioctl interface
with configfs and made a few other changes based on earlier reviews (see
https://lore.kernel.org/all/BYAPR11MB30952BA538BB905331392A08D9119@BYAPR11MB3095.namprd11.prod.outlook.com/).
There are a couple of issues that we would like to get help and suggestions
from reviewers and community.

1. Before a scheduling domain is created/enabled, a set of parameters are
passed to the kernel driver via configfs attribute files in an configfs domain
directory (say $domain) created by user. Each attribute file corresponds to
a configuration parameter of the domain. After writing to all the attribute
files, user writes 1 to "create" attribute, which triggers an action (i.e.,
domain creation) in the kernel driver. Since multiple processes/users can
access the $domain directory, multiple users can write to the attribute files
at the same time.  How do we guarantee an atomic update/configuration of a
domain? In other words, if user A wants to set attributes 1 and 2, how can we
prevent user B from changing attribute 1 and 2 before user A writes 1 to
"create"? A configfs directory with individual attribute files seems to not
be able to provide atomic configuration in this case. One option to solve this
issue could be write a structured data (with a set of parameters) to a single
attribute file. This would guarantee the atomic configuration, but may not be
a conventional configfs operation.
 
2. When a user space dlb application exits, it needs to tell the kernel driver
to reset the scheduling domain and return the associated resources back to the
resource pool for a future use. The application does so by write 0 to "create"
attribute file, and it works fine with a normal program exit. However when an
application is killed (for example, kill -9) by user, we need to a way to reset
the domain in the driver. What would be the best approach for the tear down
process in this case? In our current implementation (see patch 06/17) we create
and open an anon file descriptor when a domain is created/enabled. Since the
file is closed automatically when the user application exits or is killed, we
use the file close() operation in the driver to reset and tear down the domain.
Would this approach be acceptable with the configfs implementation? 

Dan points out that configfs puts atomic update and configuration teardown
responsibilities in userspacer. We are looking for a direction check on these
issues before doing deeper reworks.

v12:
- Address Dan's following feedbacks on coding stylei issues.
-- Remove DLB_HW_ERR() and DLB_HW_DBG() macros. Use dev_err() and dev_dbg()
   directly.
-- Replace FIELD_SET() macro with direct coding.
-- Remove all refererences on virt_id/phys_id. They will be introduced in
   future patches.
-- Use list_move() instead of list_del() and list_add() whenever possible.
-- Remove device revision numbers.
-- Reverse the order of iosubmit_cmds512() and wmb().
-- Other cleanups based on Dan's comments.

- The following coding style changes suggested by Dan will be implemented
  in the next revision
-- Replace DLB_CSR_RD() and DLB_CSR_WR() with direct ioread32() and
   iowrite32() call.
-- Remove bitmap wrappers and use linux bitmap functions directly.
-- Use trace_event in configfs attribute file update.

v11:
- Change the user interface from ioctls to configfs. Provide configfs
  interface for create and configure scheduling domains, queues, ports,
  and link/unlink of queues and ports.
- Address all of Greg's feedback on v10, including
-- Consolidate header files. Merged dlb_main.h, dlb_hw_types.h,
   dlb_resources.h and dlb_bitmap.h into dlb_main.h.
-- Removed device ops callbacks. They will be added back to when
   VM support is introduced.
-- Use macros/fucntions provided by linux kernel. Replace BITS_GET()
   and BITS_SET() by the existing linux kernel macros FIELD_GET()
   and FIELD_PREP().
-- Revise the DLB overview document dlb.rst and provide detailed
   descriptions on how DLB works.
- Remove configurations for sequeuence number and class of services.
- Remove all VF and VDEV (specially in dlb_resource.c) related code. Will
  add them back in a later patches.
- Add dlb sysfs for device level control and configurtion.
- Move dynamic port and queueu linking and unlinking to future patch
  set. This reduces the total patches in this set to 17 from 20 in v10.
  Only static linking and unlinking is supported in this submission.

v10:
- Addressed an issue reported by kernel test robot <lkp@intel.com>
-- Add "WITH Linux-syscall-note" to the SPDX-License-Identifier in uapi
   header file dlb.h.

v9:
- Addressed all of Greg's feecback on v8, including
-- Remove function name (__func__) from dev_err() messages, that could spam log.
-- Replace list and function pointer calls in dlb_ioctl() with switch-case
   and real function calls for ioctl.
-- Drop the compat_ptr_ioctl in dlb_ops (struct file_operations).
-- Change ioctl magic number for DLB to unused 0x81 (from 'h').
-- Remove all placeholder/dummy functions in the patch set.
-- Re-arrange the comments in dlb.h so that the order is consistent with that
   of data structures referred.
-- Correct the comments on SPDX License and DLB versions in dlb.h.
-- Replace BIT_SET() and BITS_CLR() marcos with direct coding.   
-- Remove NULL pointer checking (f->private_data) in dlb_ioctl().
-- Use whole line whenever possible and not wrapping lines unnecessarily.
-- Remove __attribute__((unused)).
-- Merge dlb_ioctl.h and dlb_file.h into dlb_main.h

v8:
- Add a functional block diagram in dlb.rst 
- Modify change logs to reflect the links between patches and DPDK
  eventdev library.
- Add a check of power-of-2 for CQ depth.
- Move call to INIT_WORK() to dlb_open().
- Clean dlb workqueue by calling flush_scheduled_work().
- Add unmap_mapping_range() in dlb_port_close().

v7 (Intel internal version):
- Address all of Dan's feedback, including
-- Drop DLB 2.0 throughout the patch set, use DLB only.
-- Fix license and copyright statements
-- Use pcim_enable_device() and pcim_iomap_regions(), instead of
   unmanaged version.
-- Move cdev_add() to dlb_init() and add all devices at once.
-- Fix Makefile, using "+=" style.
-- Remove FLR description and mention movdir64/enqcmd usage in doc.
-- Make the permission for the domain same as that for device for
   ioctl access.
-- Use idr instead of ida.
-- Add a lock in dlb_close() to prevent driver unbinding while ioctl
   coomands are in progress.
-- Remove wrappers that are used for code sharing between kernel driver
   and DPDK. 
- Address Pierre-Louis' feedback, including
-- Clean the warinings from checkpatch
-- Fix the warnings from "make W=1"

v6 (Intel internal version):
- Change the module name to dlb(from dlb2), which currently supports Intel
  DLB 2.0 only.
- Address all of Pierre-Louis' feedback on v5, including
-- Consolidate the two near-identical for loops in dlb2_release_domain_memory().
-- Remove an unnecessary "port = NULL" initialization
-- Consistently use curly braces on the *_LIST_FOR macros
   when the for-loop contents spans multiple lines.
-- Add a comment to the definition of DLB2FS_MAGIC
-- Remove always true if statemnets
-- Move the get_cos_bw mutex unlock call earlier to shorten the critical
   section.
- Address all of Dan's feedbacks, including
-- Replace the unions for register bits access with bitmask and shifts
-- Centralize the "to/from" user memory copies for ioctl functions.
-- Review ioctl design against Documentation/process/botching-up-ioctls.rst
-- Remove wraper functions for memory barriers.
-- Use ilog() to simplify a switch code block.
-- Add base-commit to cover letter.

v5 (Intel internal version):
- Reduce the scope of the initial patch set (drop the last 8 patches)
- Further decompose some of the remaining patches into multiple patches.
- Address all of Pierre-Louis' feedback, including:
-- Move kerneldoc to *.c files
-- Fix SPDX comment style
-- Add BAR macros
-- Improve/clarify struct dlb2_dev and struct device variable naming
-- Add const where missing
-- Clarify existing comments and add new ones in various places
-- Remove unnecessary memsets and zero-initialization
-- Remove PM abstraction, fix missing pm_runtime_allow(), and don't
   update PM refcnt when port files are opened and closed.
-- Convert certain ternary operations into if-statements
-- Out-line the CQ depth valid check
-- De-duplicate the logic in dlb2_release_device_memory()
-- Limit use of devm functions to allocating/freeing struct dlb2
- Address Ira's comments on dlb2.rst and correct commit messages that
  don't use the imperative voice.

v4:
- Move PCI device ID definitions into dlb2_hw_types.h, drop the VF definition
- Remove dlb2_dev_list
- Remove open/close functions and fops structure (unused)
- Remove "(char *)" cast from PCI driver name
- Unwind init failures properly
- Remove ID alloc helper functions and call IDA interfaces directly instead

v3:
- Remove DLB2_PCI_REG_READ/WRITE macros

v2:
- Change driver license to GPLv2 only
- Expand Kconfig help text and remove unnecessary (R)s
- Remove unnecessary prints
- Add a new entry in ioctl-number.rst
- Convert the ioctl handler into a switch statement
- Correct some instances of IOWR that should have been IOR
- Align macro blocks
- Don't break ioctl ABI when introducing new commands
- Remove indirect pointers from ioctl data structures
- Remove the get-sched-domain-fd ioctl command

Mike Ximing Chen (17):
  dlb: add skeleton for DLB driver
  dlb: initialize DLB device
  dlb: add resource and device initialization
  dlb: add configfs interface and scheduling domain directory
  dlb: add scheduling domain configuration
  dlb: add domain software reset
  dlb: add low-level register reset operations
  dlb: add runtime power-management support
  dlb: add queue create, reset, get-depth configfs interface
  dlb: add register operations for queue management
  dlb: add configfs interface to configure ports
  dlb: add register operations for port management
  dlb: add port mmap support
  dlb: add start domain configfs attribute
  dlb: add queue map, unmap, and pending unmap
  dlb: add static queue map register operations
  dlb: add basic sysfs interfaces

 Documentation/ABI/testing/sysfs-driver-dlb |  116 +
 Documentation/misc-devices/dlb.rst         |  323 ++
 Documentation/misc-devices/index.rst       |    1 +
 MAINTAINERS                                |    7 +
 drivers/misc/Kconfig                       |    1 +
 drivers/misc/Makefile                      |    1 +
 drivers/misc/dlb/Kconfig                   |   18 +
 drivers/misc/dlb/Makefile                  |    7 +
 drivers/misc/dlb/dlb_args.h                |  372 ++
 drivers/misc/dlb/dlb_configfs.c            | 1225 ++++++
 drivers/misc/dlb/dlb_configfs.h            |  195 +
 drivers/misc/dlb/dlb_file.c                |  149 +
 drivers/misc/dlb/dlb_main.c                |  616 +++
 drivers/misc/dlb/dlb_main.h                |  653 ++++
 drivers/misc/dlb/dlb_pf_ops.c              |  299 ++
 drivers/misc/dlb/dlb_regs.h                | 3640 ++++++++++++++++++
 drivers/misc/dlb/dlb_resource.c            | 3960 ++++++++++++++++++++
 include/uapi/linux/dlb.h                   |   40 +
 18 files changed, 11623 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-dlb
 create mode 100644 Documentation/misc-devices/dlb.rst
 create mode 100644 drivers/misc/dlb/Kconfig
 create mode 100644 drivers/misc/dlb/Makefile
 create mode 100644 drivers/misc/dlb/dlb_args.h
 create mode 100644 drivers/misc/dlb/dlb_configfs.c
 create mode 100644 drivers/misc/dlb/dlb_configfs.h
 create mode 100644 drivers/misc/dlb/dlb_file.c
 create mode 100644 drivers/misc/dlb/dlb_main.c
 create mode 100644 drivers/misc/dlb/dlb_main.h
 create mode 100644 drivers/misc/dlb/dlb_pf_ops.c
 create mode 100644 drivers/misc/dlb/dlb_regs.h
 create mode 100644 drivers/misc/dlb/dlb_resource.c
 create mode 100644 include/uapi/linux/dlb.h


base-commit: 519d81956ee277b4419c723adfb154603c2565ba
-- 
2.27.0


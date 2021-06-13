Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732603A587B
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhFMMx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 08:53:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:20206 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231920AbhFMMxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 08:53:36 -0400
IronPort-SDR: QChW4JnqQmLsaTegreO8ww2HIi3l+ffUEQmQBXJ8DBK0Kils8Ux6frOitalPTheL+slg1i85AP
 ZqGs4on8aYFw==
X-IronPort-AV: E=McAfee;i="6200,9189,10013"; a="227158495"
X-IronPort-AV: E=Sophos;i="5.83,271,1616482800"; 
   d="scan'208";a="227158495"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2021 05:51:31 -0700
IronPort-SDR: yVE5WhQPhRluM+zxYjEmw4EyJ+Y1xO/j2Wpv9FALUHERFPSs4YSkolg8DnI1Kk8xHZYudsogVl
 9/a0AzwAa74w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,271,1616482800"; 
   d="scan'208";a="449613099"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga008.jf.intel.com with ESMTP; 13 Jun 2021 05:51:29 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V5 16/16] net: iosm: infrastructure
Date:   Sun, 13 Jun 2021 18:20:23 +0530
Message-Id: <20210613125023.18945-17-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210613125023.18945-1-m.chetan.kumar@intel.com>
References: <20210613125023.18945-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Kconfig & Makefile changes for IOSM Driver compilation.
2) Add IOSM Driver documentation.
3) Modified MAINTAINER file for IOSM Driver addition.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v5: Update mbim port name in doc to wwan0mbim0.
v4: Adapt to wwan subsystem rtnet_link framework.
v3:
* Clean-up driver/net Kconfig & Makefile (Changes available as
  part of wwan subsystem).
* Removed NET dependency key word from iosm Kconfig.
* Removed IOCTL section from documentation.
v2:
* Moved driver documentation to RsT file.
* Modified if_link.h file to support link type iosm.
---
 .../networking/device_drivers/index.rst       |  1 +
 .../networking/device_drivers/wwan/index.rst  | 18 ++++
 .../networking/device_drivers/wwan/iosm.rst   | 96 +++++++++++++++++++
 MAINTAINERS                                   |  7 ++
 drivers/net/wwan/Kconfig                      | 12 +++
 drivers/net/wwan/Makefile                     |  1 +
 drivers/net/wwan/iosm/Makefile                | 26 +++++
 7 files changed, 161 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/wwan/index.rst
 create mode 100644 Documentation/networking/device_drivers/wwan/iosm.rst
 create mode 100644 drivers/net/wwan/iosm/Makefile

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index d8279de7bf25..3a5a1d46e77e 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -18,6 +18,7 @@ Contents:
    qlogic/index
    wan/index
    wifi/index
+   wwan/index
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/wwan/index.rst b/Documentation/networking/device_drivers/wwan/index.rst
new file mode 100644
index 000000000000..1cb8c7371401
--- /dev/null
+++ b/Documentation/networking/device_drivers/wwan/index.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+WWAN Device Drivers
+===================
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   iosm
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/networking/device_drivers/wwan/iosm.rst b/Documentation/networking/device_drivers/wwan/iosm.rst
new file mode 100644
index 000000000000..cd12f57d980a
--- /dev/null
+++ b/Documentation/networking/device_drivers/wwan/iosm.rst
@@ -0,0 +1,96 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+.. Copyright (C) 2020-21 Intel Corporation
+
+.. _iosm_driver_doc:
+
+===========================================
+IOSM Driver for Intel M.2 PCIe based Modems
+===========================================
+The IOSM (IPC over Shared Memory) driver is a WWAN PCIe host driver developed
+for linux or chrome platform for data exchange over PCIe interface between
+Host platform & Intel M.2 Modem. The driver exposes interface conforming to the
+MBIM protocol [1]. Any front end application ( eg: Modem Manager) could easily
+manage the MBIM interface to enable data communication towards WWAN.
+
+Basic usage
+===========
+MBIM functions are inactive when unmanaged. The IOSM driver only provides a
+userspace interface MBIM "WWAN PORT" representing MBIM control channel and does
+not play any role in managing the functionality. It is the job of a userspace
+application to detect port enumeration and enable MBIM functionality.
+
+Examples of few such userspace application are:
+- mbimcli (included with the libmbim [2] library), and
+- Modem Manager [3]
+
+Management Applications to carry out below required actions for establishing
+MBIM IP session:
+- open the MBIM control channel
+- configure network connection settings
+- connect to network
+- configure IP network interface
+
+Management application development
+==================================
+The driver and userspace interfaces are described below. The MBIM protocol is
+described in [1] Mobile Broadband Interface Model v1.0 Errata-1.
+
+MBIM control channel userspace ABI
+----------------------------------
+
+/dev/wwan0mbim0 character device
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+The driver exposes an MBIM interface to the MBIM function by implementing
+MBIM WWAN Port. The userspace end of the control channel pipe is a
+/dev/wwan0mbim0 character device. Application shall use this interface for
+MBIM protocol communication.
+
+Fragmentation
+~~~~~~~~~~~~~
+The userspace application is responsible for all control message fragmentation
+and defragmentation as per MBIM specification.
+
+/dev/wwan0mbim0 write()
+~~~~~~~~~~~~~~~~~~~~~
+The MBIM control messages from the management application must not exceed the
+negotiated control message size.
+
+/dev/wwan0mbim0 read()
+~~~~~~~~~~~~~~~~~~~~
+The management application must accept control messages of up the negotiated
+control message size.
+
+MBIM data channel userspace ABI
+-------------------------------
+
+wwan0-X network device
+~~~~~~~~~~~~~~~~~~~~
+The IOSM driver exposes IP link interface "wwan0-X" of type "wwan" for IP
+traffic. Iproute network utility is used for creating "wwan0-X" network
+interface and for associating it with MBIM IP session. The Driver supports
+upto 8 IP sessions for simultaneous IP communication.
+
+The userspace management application is responsible for creating new IP link
+prior to establishing MBIM IP session where the SessionId is greater than 0.
+
+For example, creating new IP link for a MBIM IP session with SessionId 1:
+
+  ip link add dev wwan0-1 parentdev-name wwan0 type wwan linkid 1
+
+The driver will automatically map the "wwan0-1" network device to MBIM IP
+session 1.
+
+References
+==========
+[1] "MBIM (Mobile Broadband Interface Model) Errata-1"
+      - https://www.usb.org/document-library/
+
+[2] libmbim - "a glib-based library for talking to WWAN modems and
+      devices which speak the Mobile Interface Broadband Model (MBIM)
+      protocol"
+      - http://www.freedesktop.org/wiki/Software/libmbim/
+
+[3] Modem Manager - "a DBus-activated daemon which controls mobile
+      broadband (2G/3G/4G) devices and connections"
+      - http://www.freedesktop.org/wiki/Software/ModemManager/
diff --git a/MAINTAINERS b/MAINTAINERS
index 349a87b42d3c..183cc61e2dc0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9453,6 +9453,13 @@ L:	Dell.Client.Kernel@dell.com
 S:	Maintained
 F:	drivers/platform/x86/intel-wmi-thunderbolt.c
 
+INTEL WWAN IOSM DRIVER
+M:	M Chetan Kumar <m.chetan.kumar@intel.com>
+M:	Intel Corporation <linuxwwan@intel.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wwan/iosm/
+
 INTEL(R) TRACE HUB
 M:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
 S:	Supported
diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index ec0b194a373c..13613a4f53d8 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -44,4 +44,16 @@ config MHI_WWAN_CTRL
 	  To compile this driver as a module, choose M here: the module will be
 	  called mhi_wwan_ctrl.
 
+config IOSM
+	tristate "IOSM Driver for Intel M.2 WWAN Device"
+	select WWAN_CORE
+	depends on INTEL_IOMMU
+	help
+	  This driver enables Intel M.2 WWAN Device communication.
+
+	  If you have one of those Intel M.2 WWAN Modules and wish to use it in
+	  Linux say Y/M here.
+
+	  If unsure, say N.
+
 endif # WWAN
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
index f33f77ca1021..3e565d3f984f 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -9,3 +9,4 @@ wwan-objs += wwan_core.o
 obj-$(CONFIG_WWAN_HWSIM) += wwan_hwsim.o
 
 obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
+obj-$(CONFIG_IOSM) += iosm/
diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
new file mode 100644
index 000000000000..cdeeb9357af6
--- /dev/null
+++ b/drivers/net/wwan/iosm/Makefile
@@ -0,0 +1,26 @@
+# SPDX-License-Identifier: (GPL-2.0-only)
+#
+# Copyright (C) 2020-21 Intel Corporation.
+#
+
+iosm-y = \
+	iosm_ipc_task_queue.o	\
+	iosm_ipc_imem.o			\
+	iosm_ipc_imem_ops.o		\
+	iosm_ipc_mmio.o			\
+	iosm_ipc_port.o			\
+	iosm_ipc_wwan.o			\
+	iosm_ipc_uevent.o		\
+	iosm_ipc_pm.o			\
+	iosm_ipc_pcie.o			\
+	iosm_ipc_irq.o			\
+	iosm_ipc_chnl_cfg.o		\
+	iosm_ipc_protocol.o		\
+	iosm_ipc_protocol_ops.o	\
+	iosm_ipc_mux.o			\
+	iosm_ipc_mux_codec.o
+
+obj-$(CONFIG_IOSM) := iosm.o
+
+# compilation flags
+ccflags-y += -DDEBUG
-- 
2.25.1


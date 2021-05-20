Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E1538B12A
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243745AbhETOLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:11:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:5245 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243929AbhETOKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 10:10:03 -0400
IronPort-SDR: i3m9vPPZ49yAzVnTzM0ZHfOG/RBsCOEV+5KpCCUGztSnRMJ/haJO4Ac/ugQgR/jRanYVWocDhK
 PMeXnaLZNF2w==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="198144835"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="198144835"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 07:03:13 -0700
IronPort-SDR: QXfWj5fq2MfH7x4d6BHoMf4KOAfp0RkrQ6lBPg0WngxRFT2tujMyXyq0p0XK+46XoA6z3TMll2
 ++6yP0qJUgnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="631407683"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by fmsmga005.fm.intel.com with ESMTP; 20 May 2021 07:03:11 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V3 16/16] net: iosm: infrastructure
Date:   Thu, 20 May 2021 19:31:58 +0530
Message-Id: <20210520140158.10132-17-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210520140158.10132-1-m.chetan.kumar@intel.com>
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Kconfig & Makefile changes for IOSM Driver compilation.
2) Add IOSM Driver documentation.
3) Modified if_link.h file to support link type iosm.
4) Modified MAINTAINER file for IOSM Driver addition.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
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
 .../networking/device_drivers/wwan/iosm.rst   | 95 +++++++++++++++++++
 MAINTAINERS                                   |  7 ++
 drivers/net/wwan/Kconfig                      | 12 +++
 drivers/net/wwan/Makefile                     |  1 +
 drivers/net/wwan/iosm/Makefile                | 26 +++++
 include/uapi/linux/if_link.h                  | 10 ++
 tools/include/uapi/linux/if_link.h            | 10 ++
 9 files changed, 180 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/wwan/index.rst
 create mode 100755 Documentation/networking/device_drivers/wwan/iosm.rst
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
new file mode 100755
index 000000000000..ab5509bd84f6
--- /dev/null
+++ b/Documentation/networking/device_drivers/wwan/iosm.rst
@@ -0,0 +1,95 @@
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
+/dev/wwan0p3MBIM character device
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+The driver exposes an MBIM interface to the MBIM function by implementing
+MBIM WWAN Port. The userspace end of the control channel pipe is a
+/dev/wwan0p3MBIM character device. Application shall use this interface for
+MBIM protocol communication.
+
+Fragmentation
+~~~~~~~~~~~~~
+The userspace application is responsible for all control message fragmentation
+and defragmentation as per MBIM specification.
+
+/dev/wwan0p3MBIM write()
+~~~~~~~~~~~~~~~~~~~~~
+The MBIM control messages from the management application must not exceed the
+negotiated control message size.
+
+/dev/wwan0p3MBIM read()
+~~~~~~~~~~~~~~~~~~~~
+The management application must accept control messages of up the negotiated
+control message size.
+
+MBIM data channel userspace ABI
+-------------------------------
+
+inmX network device
+~~~~~~~~~~~~~~~~~~~~
+The IOSM driver exposes IP link interface "inmX" of type "IOSM" for IP traffic.
+Iproute network utility is used for creating "inmX" network interface and for
+associating it with MBIM IP session. The Driver supports upto 8 IP sessions for
+simultaneous IP communication.
+
+The userspace management application is responsible for creating new IP link
+prior to establishing MBIM IP session where the SessionId is greater than 0.
+
+For example, creating new IP link for a MBIM IP session with SessionId 1:
+
+  ip link add link wwan0 name inm1 type IOSM if_id 1
+
+The driver will automatically map the "inm1" network device to MBIM IP session 1.
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
index 008fcad7ac00..79feacdc7dd0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9443,6 +9443,13 @@ L:	Dell.Client.Kernel@dell.com
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
index 7ad1920120bc..d91bc646706e 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -34,4 +34,16 @@ config MHI_WWAN_CTRL
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
index 556cd90958ca..5ff6725943da 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_WWAN_CORE) += wwan.o
 wwan-objs += wwan_core.o
 
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
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index cd5b382a4138..f7c3beebb074 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1251,4 +1251,14 @@ struct ifla_rmnet_flags {
 	__u32	mask;
 };
 
+/* IOSM Section */
+
+enum {
+	IFLA_IOSM_UNSPEC,
+	IFLA_IOSM_IF_ID,
+	__IFLA_IOSM_MAX,
+};
+
+#define IFLA_IOSM_MAX  (__IFLA_IOSM_MAX - 1)
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index d208b2af697f..cb496d0de39e 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -1046,4 +1046,14 @@ struct ifla_rmnet_flags {
 	__u32	mask;
 };
 
+/* IOSM Section */
+
+enum {
+	IFLA_IOSM_UNSPEC,
+	IFLA_IOSM_IF_ID,
+	__IFLA_IOSM_MAX,
+};
+
+#define IFLA_IOSM_MAX  (__IFLA_IOSM_MAX - 1)
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
-- 
2.25.1


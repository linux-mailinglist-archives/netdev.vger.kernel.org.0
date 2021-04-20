Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4791365D1D
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhDTQQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:16:32 -0400
Received: from mga05.intel.com ([192.55.52.43]:42702 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233191AbhDTQPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 12:15:55 -0400
IronPort-SDR: gJE89apgBDK5TTmCxggHhUJWmXeqg6uC9dZFFh+6n6B4k4Aigh/Fk7pA4LBuCpiIGomTB+999+
 q0ClcZ2AomWg==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="280866091"
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="280866091"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 09:15:09 -0700
IronPort-SDR: Y5ECGXUwQx5waQJR54KHEszpl5oVNcEX99gqR4feWT5hQYqsWEOmYLbdXLbNgJgfElRHTnfuOD
 CDckDZbSK4FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="454883970"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by fmsmga002.fm.intel.com with ESMTP; 20 Apr 2021 09:15:07 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V2 16/16] net: iosm: infrastructure
Date:   Tue, 20 Apr 2021 21:43:10 +0530
Message-Id: <20210420161310.16189-17-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210420161310.16189-1-m.chetan.kumar@intel.com>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Kconfig & Makefile changes for IOSM Driver compilation.
2) Modified driver/net Kconfig & Makefile for driver inclusion.
3) Add IOSM Driver documentation.
4) Modified MAINTAINER file for IOSM Driver addition.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v2:
* Moved driver documentation to RsT file.
* Modified if_link.h file to support link type iosm.
---
 .../networking/device_drivers/index.rst       |   1 +
 .../networking/device_drivers/wwan/index.rst  |  18 +++
 .../networking/device_drivers/wwan/iosm.rst   | 126 ++++++++++++++++++
 MAINTAINERS                                   |   7 +
 drivers/net/Kconfig                           |   1 +
 drivers/net/Makefile                          |   1 +
 drivers/net/wwan/Kconfig                      |  19 +++
 drivers/net/wwan/Makefile                     |   5 +
 drivers/net/wwan/iosm/Kconfig                 |  17 +++
 drivers/net/wwan/iosm/Makefile                |  26 ++++
 include/uapi/linux/if_link.h                  |  10 ++
 tools/include/uapi/linux/if_link.h            |  10 ++
 12 files changed, 241 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/wwan/index.rst
 create mode 100755 Documentation/networking/device_drivers/wwan/iosm.rst
 create mode 100644 drivers/net/wwan/Kconfig
 create mode 100644 drivers/net/wwan/Makefile
 create mode 100644 drivers/net/wwan/iosm/Kconfig
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
index 000000000000..13aa6e400d53
--- /dev/null
+++ b/Documentation/networking/device_drivers/wwan/iosm.rst
@@ -0,0 +1,126 @@
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
+userspace interface of a character device representing MBIM control channel
+and does not play any role in managing the functionality. It is the job of a
+userspace application to detect port enumeration and enable MBIM functionality.
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
+/dev/wwanctrl character device
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+The driver exposes an interface to the MBIM function control channel using char
+driver as a sub driver. The userspace end of the control channel pipe is a
+/dev/wwanctrl character device.
+
+The /dev/wwanctrl device is created as a subordinate character device under
+IOSM driver. The character device associated with a specific MBIM function
+can be looked up using sysfs with matching the above device name.
+
+Control channel configuration
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+The wMaxControlMessage field of the MBIM functional descriptor limits the
+maximum control message size. The management application needs to negotiate
+the control message size as per the requirements. See also the ioctl
+documentation below.
+
+Fragmentation
+~~~~~~~~~~~~~
+The userspace application is responsible for all control message
+fragmentation and defragmentation as per MBIM specification.
+
+/dev/wwanctrl write()
+~~~~~~~~~~~~~~~~~~~~~
+The MBIM control messages from the management application must not
+exceed the negotiated control message size.
+
+/dev/wwanctrl read()
+~~~~~~~~~~~~~~~~~~~~
+The management application must accept control messages of up the
+negotiated control message size.
+
+/dev/wwanctrl ioctl()
+~~~~~~~~~~~~~~~~~~~~~
+IOCTL_WDM_MAX_COMMAND: Get Maximum Command Size
+This IOCTL command could be used by applications to fetch the Maximum Command
+buffer length supported by the driver which is restricted to 4096 bytes.
+
+.. code-block:: C
+   :linenos:
+
+    #include <stdio.h>
+    #include <fcntl.h>
+    #include <sys/ioctl.h>
+    #include <linux/types.h>
+    int main()
+    {
+        __u16 max;
+        int fd = open("/dev/wwanctrl", O_RDWR);
+        if (!ioctl(fd, IOCTL_WDM_MAX_COMMAND, &max))
+            printf("wMaxControlMessage is %d\n", max);
+    }
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
index 9450e052f1b1..25bc94f47a42 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9256,6 +9256,13 @@ M:	Mario Limonciello <mario.limonciello@dell.com>
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
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index bcd31f458d1a..0e9d67a8b3ef 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -600,4 +600,5 @@ config NET_FAILOVER
 	  a VM with direct attached VF by failing over to the paravirtual
 	  datapath when the VF is unplugged.
 
+source "drivers/net/wwan/Kconfig"
 endif # NETDEVICES
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index f4990ff32fa4..ef916874fc4a 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -84,3 +84,4 @@ thunderbolt-net-y += thunderbolt.o
 obj-$(CONFIG_USB4_NET) += thunderbolt-net.o
 obj-$(CONFIG_NETDEVSIM) += netdevsim/
 obj-$(CONFIG_NET_FAILOVER) += net_failover.o
+obj-$(CONFIG_WWAN)+= wwan/
diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
new file mode 100644
index 000000000000..6507970653d2
--- /dev/null
+++ b/drivers/net/wwan/Kconfig
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Wireless WAN device configuration
+#
+
+menuconfig WWAN
+	bool "Wireless WAN"
+	depends on NET
+	help
+	  This section contains all Wireless WAN (WWAN) device drivers.
+
+	  If you have one of those WWAN M.2 Modules and wish to use it in Linux
+	  say Y here and also to the Module specific WWAN Device Driver.
+
+	  If unsure, say N.
+
+if WWAN
+source "drivers/net/wwan/iosm/Kconfig"
+endif # WWAN
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
new file mode 100644
index 000000000000..a81ff28e6cd9
--- /dev/null
+++ b/drivers/net/wwan/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Linux WWAN Device Drivers.
+#
+obj-$(CONFIG_IOSM)+= iosm/
diff --git a/drivers/net/wwan/iosm/Kconfig b/drivers/net/wwan/iosm/Kconfig
new file mode 100644
index 000000000000..ec1109d9638e
--- /dev/null
+++ b/drivers/net/wwan/iosm/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: (GPL-2.0-only)
+#
+# IOSM Driver configuration
+#
+# Copyright (C) 2020-21 Intel Corporation
+#
+
+config IOSM
+	tristate "IOSM Driver"
+	depends on INTEL_IOMMU
+	help
+	  This driver enables Intel M.2 WWAN Device communication.
+
+	  If you have one of those Intel M.2 WWAN Modules and wish to use it in
+	  Linux say Y/M here.
+
+	  If unsure, say N.
diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
new file mode 100644
index 000000000000..a70c5ba88caf
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
+	iosm_ipc_mbim.o			\
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
index 91c8dda6d95d..f3ce8492cafc 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1250,4 +1250,14 @@ struct ifla_rmnet_flags {
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


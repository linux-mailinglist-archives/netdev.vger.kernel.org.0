Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C951A3D36AB
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhGWHtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:49:15 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33970 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbhGWHtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:49:14 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 411C0213D5; Fri, 23 Jul 2021 16:29:46 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v3 01/16] mctp: Add MCTP base
Date:   Fri, 23 Jul 2021 16:29:17 +0800
Message-Id: <20210723082932.3570396-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723082932.3570396-1-jk@codeconstruct.com.au>
References: <20210723082932.3570396-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic Kconfig, an initial (empty) af_mctp source object, and
{AF,PF}_MCTP definitions, and the required selinux definitions.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

---
v2:
 - Add Linux-syscall-note to uapi header
 - Add selinux defs for new AF_MCTP
 - Controller -> component
 - Don't use strict cflags; warnings are present in #includes
---
 MAINTAINERS                         |  7 +++++++
 include/linux/socket.h              |  6 +++++-
 include/uapi/linux/mctp.h           | 15 +++++++++++++++
 net/Kconfig                         |  1 +
 net/Makefile                        |  1 +
 net/mctp/Kconfig                    | 13 +++++++++++++
 net/mctp/Makefile                   |  3 +++
 net/mctp/af_mctp.c                  |  7 +++++++
 security/selinux/hooks.c            |  4 +++-
 security/selinux/include/classmap.h |  4 +++-
 10 files changed, 58 insertions(+), 3 deletions(-)
 create mode 100644 include/uapi/linux/mctp.h
 create mode 100644 net/mctp/Kconfig
 create mode 100644 net/mctp/Makefile
 create mode 100644 net/mctp/af_mctp.c

diff --git a/MAINTAINERS b/MAINTAINERS
index da478d5c8b0c..aa2a51ff3aa4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11030,6 +11030,13 @@ F:	drivers/mailbox/arm_mhuv2.c
 F:	include/linux/mailbox/arm_mhuv2_message.h
 F:	Documentation/devicetree/bindings/mailbox/arm,mhuv2.yaml
 
+MANAGEMENT COMPONENT TRANSPORT PROTOCOL (MCTP)
+M:	Jeremy Kerr <jk@codeconstruct.com.au>
+M:	Matt Johnston <matt@codeconstruct.com.au>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	net/mctp/
+
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 M:	Michael Kerrisk <mtk.manpages@gmail.com>
 L:	linux-man@vger.kernel.org
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 0d8e3dcb7f88..fd9ce51582d8 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -223,8 +223,11 @@ struct ucred {
 				 * reuses AF_INET address family
 				 */
 #define AF_XDP		44	/* XDP sockets			*/
+#define AF_MCTP		45	/* Management component
+				 * transport protocol
+				 */
 
-#define AF_MAX		45	/* For now.. */
+#define AF_MAX		46	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -274,6 +277,7 @@ struct ucred {
 #define PF_QIPCRTR	AF_QIPCRTR
 #define PF_SMC		AF_SMC
 #define PF_XDP		AF_XDP
+#define PF_MCTP		AF_MCTP
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
new file mode 100644
index 000000000000..2640a589c14c
--- /dev/null
+++ b/include/uapi/linux/mctp.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Management Component Transport Protocol (MCTP)
+ *
+ * Copyright (c) 2021 Code Construct
+ * Copyright (c) 2021 Google
+ */
+
+#ifndef __UAPI_MCTP_H
+#define __UAPI_MCTP_H
+
+struct sockaddr_mctp {
+};
+
+#endif /* __UAPI_MCTP_H */
diff --git a/net/Kconfig b/net/Kconfig
index c7392c449b25..fb13460c6dab 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -363,6 +363,7 @@ source "net/bluetooth/Kconfig"
 source "net/rxrpc/Kconfig"
 source "net/kcm/Kconfig"
 source "net/strparser/Kconfig"
+source "net/mctp/Kconfig"
 
 config FIB_RULES
 	bool
diff --git a/net/Makefile b/net/Makefile
index 9ca9572188fe..fbfeb8a0bb37 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_QRTR)		+= qrtr/
 obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
 obj-$(CONFIG_MPTCP)		+= mptcp/
+obj-$(CONFIG_MCTP)		+= mctp/
diff --git a/net/mctp/Kconfig b/net/mctp/Kconfig
new file mode 100644
index 000000000000..2cdf3d0a28c9
--- /dev/null
+++ b/net/mctp/Kconfig
@@ -0,0 +1,13 @@
+
+menuconfig MCTP
+	depends on NET
+	tristate "MCTP core protocol support"
+	help
+	  Management Component Transport Protocol (MCTP) is an in-system
+	  protocol for communicating between management controllers and
+	  their managed devices (peripherals, host processors, etc.). The
+	  protocol is defined by DMTF specification DSP0236.
+
+	  This option enables core MCTP support. For communicating with other
+	  devices, you'll want to enable a driver for a specific hardware
+	  channel.
diff --git a/net/mctp/Makefile b/net/mctp/Makefile
new file mode 100644
index 000000000000..7c056b1b7939
--- /dev/null
+++ b/net/mctp/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_MCTP) += mctp.o
+mctp-objs := af_mctp.o
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
new file mode 100644
index 000000000000..1b63b753057b
--- /dev/null
+++ b/net/mctp/af_mctp.c
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Management Component Transport Protocol (MCTP)
+ *
+ * Copyright (c) 2021 Code Construct
+ * Copyright (c) 2021 Google
+ */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b0032c42333e..2143f590e3d6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1330,7 +1330,9 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
 			return SECCLASS_SMC_SOCKET;
 		case PF_XDP:
 			return SECCLASS_XDP_SOCKET;
-#if PF_MAX > 45
+		case PF_MCTP:
+			return SECCLASS_MCTP_SOCKET;
+#if PF_MAX > 46
 #error New address family defined, please update this function.
 #endif
 		}
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 62d19bccf3de..084757ff4390 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -246,6 +246,8 @@ struct security_class_mapping secclass_map[] = {
 	    NULL } },
 	{ "xdp_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
+	{ "mctp_socket",
+	  { COMMON_SOCK_PERMS, NULL } },
 	{ "perf_event",
 	  { "open", "cpu", "kernel", "tracepoint", "read", "write", NULL } },
 	{ "lockdown",
@@ -255,6 +257,6 @@ struct security_class_mapping secclass_map[] = {
 	{ NULL }
   };
 
-#if PF_MAX > 45
+#if PF_MAX > 46
 #error New address family defined, please update secclass_map.
 #endif
-- 
2.30.2


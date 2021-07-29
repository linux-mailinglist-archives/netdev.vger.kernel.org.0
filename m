Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787093D9BA4
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhG2CVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:21:13 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:35804 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbhG2CVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 22:21:10 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 3EA3720227; Thu, 29 Jul 2021 10:21:04 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org
Subject: [PATCH net-next v4 01/15] mctp: Add MCTP base
Date:   Thu, 29 Jul 2021 10:20:39 +0800
Message-Id: <20210729022053.134453-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729022053.134453-1-jk@codeconstruct.com.au>
References: <20210729022053.134453-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic Kconfig, an initial (empty) af_mctp source object, and
{AF,PF}_MCTP definitions, and the required definitions for a new
protocol type.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

---
v2:
 - Add Linux-syscall-note to uapi header
 - Add selinux defs for new AF_MCTP
 - Controller -> component
 - Don't use strict cflags; warnings are present in #includes
v4:
 - Include AF_MCTP in af_family_slock_keys and pf_family_names
 - Introduce MODULE_ definitions earlier
---
 MAINTAINERS                         |  7 +++++++
 include/linux/socket.h              |  6 +++++-
 include/uapi/linux/mctp.h           | 15 +++++++++++++++
 net/Kconfig                         |  1 +
 net/Makefile                        |  1 +
 net/core/sock.c                     |  1 +
 net/mctp/Kconfig                    | 13 +++++++++++++
 net/mctp/Makefile                   |  3 +++
 net/mctp/af_mctp.c                  | 13 +++++++++++++
 net/socket.c                        |  1 +
 security/selinux/hooks.c            |  4 +++-
 security/selinux/include/classmap.h |  4 +++-
 12 files changed, 66 insertions(+), 3 deletions(-)
 create mode 100644 include/uapi/linux/mctp.h
 create mode 100644 net/mctp/Kconfig
 create mode 100644 net/mctp/Makefile
 create mode 100644 net/mctp/af_mctp.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4c32a9c532b7..22a1ff9afd9d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11032,6 +11032,13 @@ F:	drivers/mailbox/arm_mhuv2.c
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
diff --git a/net/core/sock.c b/net/core/sock.c
index a3eea6e0b30a..9671c32e6ef5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -226,6 +226,7 @@ static struct lock_class_key af_family_kern_slock_keys[AF_MAX];
   x "AF_IEEE802154",	x "AF_CAIF"	,	x "AF_ALG"      , \
   x "AF_NFC"   ,	x "AF_VSOCK"    ,	x "AF_KCM"      , \
   x "AF_QIPCRTR",	x "AF_SMC"	,	x "AF_XDP"	, \
+  x "AF_MCTP"  , \
   x "AF_MAX"
 
 static const char *const af_family_key_strings[AF_MAX+1] = {
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
index 000000000000..8f9c77e97357
--- /dev/null
+++ b/net/mctp/af_mctp.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Management Component Transport Protocol (MCTP)
+ *
+ * Copyright (c) 2021 Code Construct
+ * Copyright (c) 2021 Google
+ */
+
+#include <linux/module.h>
+
+MODULE_DESCRIPTION("MCTP core");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Jeremy Kerr <jk@codeconstruct.com.au>");
diff --git a/net/socket.c b/net/socket.c
index 42665bd99ea4..3c10504e46d9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -212,6 +212,7 @@ static const char * const pf_family_names[] = {
 	[PF_QIPCRTR]	= "PF_QIPCRTR",
 	[PF_SMC]	= "PF_SMC",
 	[PF_XDP]	= "PF_XDP",
+	[PF_MCTP]	= "PF_MCTP",
 };
 
 /*
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


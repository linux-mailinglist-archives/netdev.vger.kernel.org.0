Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170ED12B555
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 15:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfL0OzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 09:55:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:42540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfL0OzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 09:55:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 760DEAD78;
        Fri, 27 Dec 2019 14:55:18 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1F52CE008A; Fri, 27 Dec 2019 15:55:18 +0100 (CET)
Message-Id: <27f2be5891f9795fc6dff7e7bd50c2943b6f5eb5.1577457846.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577457846.git.mkubecek@suse.cz>
References: <cover.1577457846.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v9 01/14] ethtool: introduce ethtool netlink
 interface
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Dec 2019 15:55:18 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basic genetlink and init infrastructure for the netlink interface, register
genetlink family "ethtool". Add CONFIG_ETHTOOL_NETLINK Kconfig option to
make the build optional. Add initial overall interface description into
Documentation/networking/ethtool-netlink.rst, further patches will add more
detailed information.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/ethtool-netlink.rst | 216 +++++++++++++++++++
 Documentation/networking/index.rst           |   1 +
 include/linux/ethtool_netlink.h              |   9 +
 include/uapi/linux/ethtool_netlink.h         |  36 ++++
 net/Kconfig                                  |   8 +
 net/ethtool/Makefile                         |   6 +-
 net/ethtool/netlink.c                        |  33 +++
 net/ethtool/netlink.h                        |  10 +
 8 files changed, 318 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/ethtool-netlink.rst
 create mode 100644 include/linux/ethtool_netlink.h
 create mode 100644 include/uapi/linux/ethtool_netlink.h
 create mode 100644 net/ethtool/netlink.c
 create mode 100644 net/ethtool/netlink.h

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
new file mode 100644
index 000000000000..9448442ad293
--- /dev/null
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -0,0 +1,216 @@
+=============================
+Netlink interface for ethtool
+=============================
+
+
+Basic information
+=================
+
+Netlink interface for ethtool uses generic netlink family ``ethtool``
+(userspace application should use macros ``ETHTOOL_GENL_NAME`` and
+``ETHTOOL_GENL_VERSION`` defined in ``<linux/ethtool_netlink.h>`` uapi
+header). This family does not use a specific header, all information in
+requests and replies is passed using netlink attributes.
+
+The ethtool netlink interface uses extended ACK for error and warning
+reporting, userspace application developers are encouraged to make these
+messages available to user in a suitable way.
+
+Requests can be divided into three categories: "get" (retrieving information),
+"set" (setting parameters) and "action" (invoking an action).
+
+All "set" and "action" type requests require admin privileges
+(``CAP_NET_ADMIN`` in the namespace). Most "get" type requests are allowed for
+anyone but there are exceptions (where the response contains sensitive
+information). In some cases, the request as such is allowed for anyone but
+unprivileged users have attributes with sensitive information (e.g.
+wake-on-lan password) omitted.
+
+
+Conventions
+===========
+
+Attributes which represent a boolean value usually use NLA_U8 type so that we
+can distinguish three states: "on", "off" and "not present" (meaning the
+information is not available in "get" requests or value is not to be changed
+in "set" requests). For these attributes, the "true" value should be passed as
+number 1 but any non-zero value should be understood as "true" by recipient.
+In the tables below, "bool" denotes NLA_U8 attributes interpreted in this way.
+
+In the message structure descriptions below, if an attribute name is suffixed
+with "+", parent nest can contain multiple attributes of the same type. This
+implements an array of entries.
+
+
+Request header
+==============
+
+Each request or reply message contains a nested attribute with common header.
+Structure of this header is
+
+  ==============================  ======  =============================
+  ``ETHTOOL_A_HEADER_DEV_INDEX``  u32     device ifindex
+  ``ETHTOOL_A_HEADER_DEV_NAME``   string  device name
+  ``ETHTOOL_A_HEADER_FLAGS``      u32     flags common for all requests
+  ==============================  ======  =============================
+
+``ETHTOOL_A_HEADER_DEV_INDEX`` and ``ETHTOOL_A_HEADER_DEV_NAME`` identify the
+device message relates to. One of them is sufficient in requests, if both are
+used, they must identify the same device. Some requests, e.g. global string
+sets, do not require device identification. Most ``GET`` requests also allow
+dump requests without device identification to query the same information for
+all devices providing it (each device in a separate message).
+
+``ETHTOOL_A_HEADER_FLAGS`` is a bitmap of request flags common for all request
+types. The interpretation of these flags is the same for all request types but
+the flags may not apply to requests. Recognized flags are:
+
+  =================================  ===================================
+  ``ETHTOOL_FLAG_COMPACT_BITSETS``   use compact format bitsets in reply
+  ``ETHTOOL_FLAG_OMIT_REPLY``        omit optional reply (_SET and _ACT)
+  =================================  ===================================
+
+New request flags should follow the general idea that if the flag is not set,
+the behaviour is backward compatible, i.e. requests from old clients not aware
+of the flag should be interpreted the way the client expects. A client must
+not set flags it does not understand.
+
+
+List of message types
+=====================
+
+All constants identifying message types use ``ETHTOOL_CMD_`` prefix and suffix
+according to message purpose:
+
+  ==============    ======================================
+  ``_GET``          userspace request to retrieve data
+  ``_SET``          userspace request to set data
+  ``_ACT``          userspace request to perform an action
+  ``_GET_REPLY``    kernel reply to a ``GET`` request
+  ``_SET_REPLY``    kernel reply to a ``SET`` request
+  ``_ACT_REPLY``    kernel reply to an ``ACT`` request
+  ``_NTF``          kernel notification
+  ==============    ======================================
+
+``GET`` requests are sent by userspace applications to retrieve device
+information. They usually do not contain any message specific attributes.
+Kernel replies with corresponding "GET_REPLY" message. For most types, ``GET``
+request with ``NLM_F_DUMP`` and no device identification can be used to query
+the information for all devices supporting the request.
+
+If the data can be also modified, corresponding ``SET`` message with the same
+layout as corresponding ``GET_REPLY`` is used to request changes. Only
+attributes where a change is requested are included in such request (also, not
+all attributes may be changed). Replies to most ``SET`` request consist only
+of error code and extack; if kernel provides additional data, it is sent in
+the form of corresponding ``SET_REPLY`` message which can be suppressed by
+setting ``ETHTOOL_FLAG_OMIT_REPLY`` flag in request header.
+
+Data modification also triggers sending a ``NTF`` message with a notification.
+These usually bear only a subset of attributes which was affected by the
+change. The same notification is issued if the data is modified using other
+means (mostly ioctl ethtool interface). Unlike notifications from ethtool
+netlink code which are only sent if something actually changed, notifications
+triggered by ioctl interface may be sent even if the request did not actually
+change any data.
+
+``ACT`` messages request kernel (driver) to perform a specific action. If some
+information is reported by kernel (which can be suppressed by setting
+``ETHTOOL_FLAG_OMIT_REPLY`` flag in request header), the reply takes form of
+an ``ACT_REPLY`` message. Performing an action also triggers a notification
+(``NTF`` message).
+
+Later sections describe the format and semantics of these messages.
+
+
+Request translation
+===================
+
+The following table maps ioctl commands to netlink commands providing their
+functionality. Entries with "n/a" in right column are commands which do not
+have their netlink replacement yet.
+
+  =================================== =====================================
+  ioctl command                       netlink command
+  =================================== =====================================
+  ``ETHTOOL_GSET``                    n/a
+  ``ETHTOOL_SSET``                    n/a
+  ``ETHTOOL_GDRVINFO``                n/a
+  ``ETHTOOL_GREGS``                   n/a
+  ``ETHTOOL_GWOL``                    n/a
+  ``ETHTOOL_SWOL``                    n/a
+  ``ETHTOOL_GMSGLVL``                 n/a
+  ``ETHTOOL_SMSGLVL``                 n/a
+  ``ETHTOOL_NWAY_RST``                n/a
+  ``ETHTOOL_GLINK``                   n/a
+  ``ETHTOOL_GEEPROM``                 n/a
+  ``ETHTOOL_SEEPROM``                 n/a
+  ``ETHTOOL_GCOALESCE``               n/a
+  ``ETHTOOL_SCOALESCE``               n/a
+  ``ETHTOOL_GRINGPARAM``              n/a
+  ``ETHTOOL_SRINGPARAM``              n/a
+  ``ETHTOOL_GPAUSEPARAM``             n/a
+  ``ETHTOOL_SPAUSEPARAM``             n/a
+  ``ETHTOOL_GRXCSUM``                 n/a
+  ``ETHTOOL_SRXCSUM``                 n/a
+  ``ETHTOOL_GTXCSUM``                 n/a
+  ``ETHTOOL_STXCSUM``                 n/a
+  ``ETHTOOL_GSG``                     n/a
+  ``ETHTOOL_SSG``                     n/a
+  ``ETHTOOL_TEST``                    n/a
+  ``ETHTOOL_GSTRINGS``                n/a
+  ``ETHTOOL_PHYS_ID``                 n/a
+  ``ETHTOOL_GSTATS``                  n/a
+  ``ETHTOOL_GTSO``                    n/a
+  ``ETHTOOL_STSO``                    n/a
+  ``ETHTOOL_GPERMADDR``               rtnetlink ``RTM_GETLINK``
+  ``ETHTOOL_GUFO``                    n/a
+  ``ETHTOOL_SUFO``                    n/a
+  ``ETHTOOL_GGSO``                    n/a
+  ``ETHTOOL_SGSO``                    n/a
+  ``ETHTOOL_GFLAGS``                  n/a
+  ``ETHTOOL_SFLAGS``                  n/a
+  ``ETHTOOL_GPFLAGS``                 n/a
+  ``ETHTOOL_SPFLAGS``                 n/a
+  ``ETHTOOL_GRXFH``                   n/a
+  ``ETHTOOL_SRXFH``                   n/a
+  ``ETHTOOL_GGRO``                    n/a
+  ``ETHTOOL_SGRO``                    n/a
+  ``ETHTOOL_GRXRINGS``                n/a
+  ``ETHTOOL_GRXCLSRLCNT``             n/a
+  ``ETHTOOL_GRXCLSRULE``              n/a
+  ``ETHTOOL_GRXCLSRLALL``             n/a
+  ``ETHTOOL_SRXCLSRLDEL``             n/a
+  ``ETHTOOL_SRXCLSRLINS``             n/a
+  ``ETHTOOL_FLASHDEV``                n/a
+  ``ETHTOOL_RESET``                   n/a
+  ``ETHTOOL_SRXNTUPLE``               n/a
+  ``ETHTOOL_GRXNTUPLE``               n/a
+  ``ETHTOOL_GSSET_INFO``              n/a
+  ``ETHTOOL_GRXFHINDIR``              n/a
+  ``ETHTOOL_SRXFHINDIR``              n/a
+  ``ETHTOOL_GFEATURES``               n/a
+  ``ETHTOOL_SFEATURES``               n/a
+  ``ETHTOOL_GCHANNELS``               n/a
+  ``ETHTOOL_SCHANNELS``               n/a
+  ``ETHTOOL_SET_DUMP``                n/a
+  ``ETHTOOL_GET_DUMP_FLAG``           n/a
+  ``ETHTOOL_GET_DUMP_DATA``           n/a
+  ``ETHTOOL_GET_TS_INFO``             n/a
+  ``ETHTOOL_GMODULEINFO``             n/a
+  ``ETHTOOL_GMODULEEEPROM``           n/a
+  ``ETHTOOL_GEEE``                    n/a
+  ``ETHTOOL_SEEE``                    n/a
+  ``ETHTOOL_GRSSH``                   n/a
+  ``ETHTOOL_SRSSH``                   n/a
+  ``ETHTOOL_GTUNABLE``                n/a
+  ``ETHTOOL_STUNABLE``                n/a
+  ``ETHTOOL_GPHYSTATS``               n/a
+  ``ETHTOOL_PERQUEUE``                n/a
+  ``ETHTOOL_GLINKSETTINGS``           n/a
+  ``ETHTOOL_SLINKSETTINGS``           n/a
+  ``ETHTOOL_PHY_GTUNABLE``            n/a
+  ``ETHTOOL_PHY_STUNABLE``            n/a
+  ``ETHTOOL_GFECPARAM``               n/a
+  ``ETHTOOL_SFECPARAM``               n/a
+  =================================== =====================================
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 5acab1290e03..bee73be7af93 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -16,6 +16,7 @@ Contents:
    devlink-info-versions
    devlink-trap
    devlink-trap-netdevsim
+   ethtool-netlink
    ieee802154
    j1939
    kapi
diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
new file mode 100644
index 000000000000..f27e92b5f344
--- /dev/null
+++ b/include/linux/ethtool_netlink.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _LINUX_ETHTOOL_NETLINK_H_
+#define _LINUX_ETHTOOL_NETLINK_H_
+
+#include <uapi/linux/ethtool_netlink.h>
+#include <linux/ethtool.h>
+
+#endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
new file mode 100644
index 000000000000..3c93276ba066
--- /dev/null
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * include/uapi/linux/ethtool_netlink.h - netlink interface for ethtool
+ *
+ * See Documentation/networking/ethtool-netlink.txt in kernel source tree for
+ * doucumentation of the interface.
+ */
+
+#ifndef _UAPI_LINUX_ETHTOOL_NETLINK_H_
+#define _UAPI_LINUX_ETHTOOL_NETLINK_H_
+
+#include <linux/ethtool.h>
+
+/* message types - userspace to kernel */
+enum {
+	ETHTOOL_MSG_USER_NONE,
+
+	/* add new constants above here */
+	__ETHTOOL_MSG_USER_CNT,
+	ETHTOOL_MSG_USER_MAX = __ETHTOOL_MSG_USER_CNT - 1
+};
+
+/* message types - kernel to userspace */
+enum {
+	ETHTOOL_MSG_KERNEL_NONE,
+
+	/* add new constants above here */
+	__ETHTOOL_MSG_KERNEL_CNT,
+	ETHTOOL_MSG_KERNEL_MAX = __ETHTOOL_MSG_KERNEL_CNT - 1
+};
+
+/* generic netlink info */
+#define ETHTOOL_GENL_NAME "ethtool"
+#define ETHTOOL_GENL_VERSION 1
+
+#endif /* _UAPI_LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/net/Kconfig b/net/Kconfig
index 52af65e5d28c..54916b7adb9b 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -449,6 +449,14 @@ config FAILOVER
 	  migration of VMs with direct attached VFs by failing over to the
 	  paravirtual datapath when the VF is unplugged.
 
+config ETHTOOL_NETLINK
+	bool "Netlink interface for ethtool"
+	default y
+	help
+	  An alternative userspace interface for ethtool based on generic
+	  netlink. It provides better extensibility and some new features,
+	  e.g. notification messages.
+
 endif   # if NET
 
 # Used by archs to tell that they support BPF JIT compiler plus which flavour.
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index f68387618973..59d5ee230c29 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -1,3 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-obj-y		+= ioctl.o common.o
+obj-y				+= ioctl.o common.o
+
+obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
+
+ethtool_nl-y	:= netlink.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
new file mode 100644
index 000000000000..59e1ebde2f15
--- /dev/null
+++ b/net/ethtool/netlink.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ethtool_netlink.h>
+#include "netlink.h"
+
+/* genetlink setup */
+
+static const struct genl_ops ethtool_genl_ops[] = {
+};
+
+static struct genl_family ethtool_genl_family = {
+	.name		= ETHTOOL_GENL_NAME,
+	.version	= ETHTOOL_GENL_VERSION,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.ops		= ethtool_genl_ops,
+	.n_ops		= ARRAY_SIZE(ethtool_genl_ops),
+};
+
+/* module setup */
+
+static int __init ethnl_init(void)
+{
+	int ret;
+
+	ret = genl_register_family(&ethtool_genl_family);
+	if (WARN(ret < 0, "ethtool: genetlink family registration failed"))
+		return ret;
+
+	return 0;
+}
+
+subsys_initcall(ethnl_init);
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
new file mode 100644
index 000000000000..e4220780d368
--- /dev/null
+++ b/net/ethtool/netlink.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _NET_ETHTOOL_NETLINK_H
+#define _NET_ETHTOOL_NETLINK_H
+
+#include <linux/ethtool_netlink.h>
+#include <linux/netdevice.h>
+#include <net/genetlink.h>
+
+#endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.24.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB849E324
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241582AbiA0NQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:16:48 -0500
Received: from mga03.intel.com ([134.134.136.65]:49561 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241575AbiA0NQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 08:16:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643289407; x=1674825407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iUeWPO9iIOZJeYzr/vCwPC18UmqYvywDRzrd9XkSsEw=;
  b=luHxKr2Ne/Zct9pc6eSbiC0A7Zj8uS83zjmjTiFsTkV1xgs60p7fC8x7
   P5Ov/w7L70ajoSULEvE7slaAiJ/N7RqdaLkvFpZtHiTrCwQiyI6hWNht7
   CHrHyQUzW6pr/fPzsPkkYPvqJN/csxwHmRtb5D9Iw0xQZNS4VIE+QANtd
   hsaOh6UP2dx3AdIKnJsEIXV6iHgUlMSgHT8V7SzPoBqeiDrLNrVgh3tuL
   8nbgAMcizDB3LCFZXBhvHcl23lTAiHrRXWtkYh9qVArt78WdvyjVbp6qW
   Oq3g9YryZQSrE6mmigVdjf3XzKgWolPCQSQQle8zTQ0PgzVqKmdfXYOpt
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246788455"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="246788455"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 05:16:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="674708693"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jan 2022 05:16:45 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RDGipd023596;
        Thu, 27 Jan 2022 13:16:44 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: [PATCH iproute2-next 1/2] ip: GTP support in ip link
Date:   Thu, 27 Jan 2022 14:13:54 +0100
Message-Id: <20220127131355.126824-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127131355.126824-1-wojciech.drewek@intel.com>
References: <20220127131355.126824-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for creating GTP devices through ip link. Two arguments
can be specified by the user when adding device of the GTP type.
 - role (sgsn or ggsn) - indicates whether we are on the GGSN or SGSN
 - hsize - indicates the size of the hash table where PDP sessions
   are stored

IFLA_GTP_FD0 and IFLA_GTP_FD1 arguments would not be provided. Those
are file descriptores to the sockets created in the userspace. Since
we are not going to create sockets in ip link, we don't have to
provide them.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 ip/Makefile           |   2 +-
 ip/iplink.c           |   2 +-
 ip/iplink_gtp.c       | 116 ++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in |  25 ++++++++-
 4 files changed, 142 insertions(+), 3 deletions(-)
 create mode 100644 ip/iplink_gtp.c

diff --git a/ip/Makefile b/ip/Makefile
index 2a7a51c313c6..06ba60b341af 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -12,7 +12,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
     ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o \
-    iplink_amt.o
+    iplink_amt.o iplink_gtp.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink.c b/ip/iplink.c
index a3ea775d2b23..3d1127f437e4 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -57,7 +57,7 @@ void iplink_types_usage(void)
 		"          macsec | macvlan | macvtap |\n"
 		"          netdevsim | nlmon | rmnet | sit | team | team_slave |\n"
 		"          vcan | veth | vlan | vrf | vti | vxcan | vxlan | wwan |\n"
-		"          xfrm }\n");
+		"          xfrm | gtp }\n");
 }
 
 void iplink_usage(void)
diff --git a/ip/iplink_gtp.c b/ip/iplink_gtp.c
new file mode 100644
index 000000000000..d007b45d2c68
--- /dev/null
+++ b/ip/iplink_gtp.c
@@ -0,0 +1,116 @@
+/*
+ * iplink_gtp.c	GTP device support
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Wojciech Drewek <wojciech.drewek@intel.com>
+ */
+
+#include <stdio.h>
+
+#include "rt_names.h"
+#include "utils.h"
+#include "ip_common.h"
+
+#define GTP_ATTRSET(attrs, type) (((attrs) & (1L << (type))) != 0)
+
+static void print_explain(FILE *f)
+{
+	fprintf(f,
+		"Usage: ... gtp role ROLE\n"
+		"		[ hsize HSIZE ]\n"
+		"\n"
+		"Where:	ROLE   := { sgsn | ggsn }\n"
+		"	HSIZE  := 1-131071\n"
+	);
+}
+
+static void check_duparg(__u32 *attrs, int type, const char *key,
+			 const char *argv)
+{
+	if (!GTP_ATTRSET(*attrs, type)) {
+		*attrs |= (1L << type);
+		return;
+	}
+	duparg2(key, argv);
+}
+
+static int gtp_parse_opt(struct link_util *lu, int argc, char **argv,
+			 struct nlmsghdr *n)
+{
+	__u32 attrs = 0;
+
+	while (argc > 0) {
+		if (!matches(*argv, "role")) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_GTP_ROLE, "role", *argv);
+			if (!strcmp(*argv, "sgsn"))
+				addattr32(n, 1024, IFLA_GTP_ROLE, GTP_ROLE_SGSN);
+			else if (!strcmp(*argv, "ggsn"))
+				addattr32(n, 1024, IFLA_GTP_ROLE, GTP_ROLE_GGSN);
+			else
+				invarg("invalid role, use sgsn or ggsn", *argv);
+		} else if (!matches(*argv, "hsize")) {
+			__u32 hsize;
+
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_GTP_PDP_HASHSIZE, "hsize", *argv);
+
+			if (get_u32(&hsize, *argv, 0))
+				invarg("invalid PDP hash size", *argv);
+			if (hsize >= 1u << 17)
+				invarg("PDP hash size too big", *argv);
+			addattr32(n, 1024, IFLA_GTP_PDP_HASHSIZE, hsize);
+		} else if (!matches(*argv, "help")) {
+			print_explain(stderr);
+			return -1;
+		}
+		argc--, argv++;
+	}
+
+	if (!GTP_ATTRSET(attrs, IFLA_GTP_ROLE)) {
+		fprintf(stderr, "gtp: role of the gtp device was not specified\n");
+		return -1;
+	}
+
+	if (!GTP_ATTRSET(attrs, IFLA_GTP_PDP_HASHSIZE))
+		addattr32(n, 1024, IFLA_GTP_PDP_HASHSIZE, 1024);
+
+	return 0;
+}
+
+static void gtp_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
+{
+
+	if (tb[IFLA_GTP_ROLE]) {
+		__u32 role = rta_getattr_u32(tb[IFLA_GTP_ROLE]);
+
+		if (role == GTP_ROLE_SGSN)
+			print_string(PRINT_ANY, "role", "role %s ", "sgsn");
+		else
+			print_string(PRINT_ANY, "role", "role %s ", "ggsn");
+	}
+
+	if (tb[IFLA_GTP_PDP_HASHSIZE]) {
+		__u32 hsize = rta_getattr_u32(tb[IFLA_GTP_PDP_HASHSIZE]);
+
+		print_uint(PRINT_ANY, "hsize", "hsize %u ", hsize);
+	}
+}
+
+static void gtp_print_help(struct link_util *lu, int argc, char **argv,
+			   FILE *f)
+{
+	print_explain(f);
+}
+
+struct link_util gtp_link_util = {
+	.id		= "gtp",
+	.maxattr	= IFLA_GTP_MAX,
+	.parse_opt	= gtp_parse_opt,
+	.print_opt	= gtp_print_opt,
+	.print_help	= gtp_print_help,
+};
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 19a0c9cab811..819ca8f7a330 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -233,7 +233,8 @@ ip-link \- network device configuration
 .BR macsec " |"
 .BR netdevsim " |"
 .BR rmnet " |"
-.BR xfrm " ]"
+.BR xfrm " |"
+.BR gtp " ]"
 
 .ti -8
 .IR ETYPE " := [ " TYPE " |"
@@ -382,6 +383,9 @@ Link types:
 .sp
 .BR xfrm
 - Virtual xfrm interface
+.sp
+.BR gtp
+- GPRS Tunneling Protocol
 .in -8
 
 .TP
@@ -1926,6 +1930,25 @@ policies. Policies must be configured with the same key. If not set, the key def
 
 .in -8
 
+.TP
+GTP Type Support
+For a link of type
+.I GTP
+the following additional arguments are supported:
+
+.BI "ip link add " DEVICE " type gtp role " ROLE " hsize " HSIZE
+
+.in +8
+.sp
+.BI role " ROLE "
+- specifies the role of the GTP device, either sgsn or ggsn
+
+.sp
+.BI hsize " HSIZE "
+- specifies size of the hashtable which stores PDP contexts
+
+.in -8
+
 .SS ip link delete - delete virtual link
 
 .TP
-- 
2.31.1


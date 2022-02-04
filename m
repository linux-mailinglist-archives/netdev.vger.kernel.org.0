Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5BB4A9D48
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376713AbiBDRB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:01:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:44535 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233140AbiBDRB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 12:01:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643994086; x=1675530086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cB/K0O7tgH+As3NmXC+AqUTfVA0LcCXiQAlCahtp7kg=;
  b=gVkjoNivjceJWX8LHfZ15lVxML0SwkF/y7UZhdms6BWRIQnZaSLdFHop
   NWPfQ9bc6JCOQoRDSO0n7W9euiKMEzZ8/BN+bkomJcZd/Lxpd2AODR3Av
   5K5VEBXinjmadEKpKG0DUPcmCPPwkBE2kIQZ2JF+hY1lQldX070bQgQZh
   xLeA48TQbti6KX3+N1smhuCeGW+1dGX5wr/8xzGEdVR3kupdIdwFYgrQb
   Yuv4KC64w1xOnZYeVD+bNEYi1ZD68r3J84kZ8meZ8DJo4/Rs1AGHSGG81
   JzzMV1qHjSTGEvYXz6JxIPwKEoajEfGn66wZm+IAzfV00dCOKmYi5fR0q
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="311702117"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="311702117"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 09:01:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="483668905"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 04 Feb 2022 09:01:23 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 214H1MV6027661;
        Fri, 4 Feb 2022 17:01:23 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: [PATCH iproute2-next v2 1/2] ip: GTP support in ip link
Date:   Fri,  4 Feb 2022 17:58:20 +0100
Message-Id: <20220204165821.12104-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220204165821.12104-1-wojciech.drewek@intel.com>
References: <20220204165821.12104-1-wojciech.drewek@intel.com>
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
v2: use SPDX tag, use strcmp() instead of matches(), parse
    IFLA_GTP_RESTART_COUNT arg
---
 include/uapi/linux/if_link.h |   1 +
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_gtp.c              | 123 +++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  29 ++++++++-
 5 files changed, 154 insertions(+), 3 deletions(-)
 create mode 100644 ip/iplink_gtp.c

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 41708e26a3c9..c6713aecfa85 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -820,6 +820,7 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_RESTART_COUNT,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
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
index 000000000000..79ef0da92fb3
--- /dev/null
+++ b/ip/iplink_gtp.c
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+		"		[ restart_count RESTART_COUNT ]\n"
+		"\n"
+		"Where:	ROLE		:= { sgsn | ggsn }\n"
+		"	HSIZE		:= 1-131071\n"
+		"	RESTART_COUNT	:= 0-255\n"
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
+		if (!strcmp(*argv, "role")) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_GTP_ROLE, "role", *argv);
+			if (!strcmp(*argv, "sgsn"))
+				addattr32(n, 1024, IFLA_GTP_ROLE, GTP_ROLE_SGSN);
+			else if (!strcmp(*argv, "ggsn"))
+				addattr32(n, 1024, IFLA_GTP_ROLE, GTP_ROLE_GGSN);
+			else
+				invarg("invalid role, use sgsn or ggsn", *argv);
+		} else if (!strcmp(*argv, "hsize")) {
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
+		} else if (!strcmp(*argv, "restart_count")) {
+			__u8 restart_count;
+
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_GTP_RESTART_COUNT, "restart_count", *argv);
+
+			if (get_u8(&restart_count, *argv, 10))
+				invarg("invalid restart_count", *argv);
+			addattr8(n, 1024, IFLA_GTP_RESTART_COUNT, restart_count);
+		} else if (!strcmp(*argv, "help")) {
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
+		print_string(PRINT_ANY, "role", "role %s ",
+			     role == GTP_ROLE_SGSN ? "sgsn" : "ggsn");
+	}
+
+	if (tb[IFLA_GTP_PDP_HASHSIZE]) {
+		__u32 hsize = rta_getattr_u32(tb[IFLA_GTP_PDP_HASHSIZE]);
+
+		print_uint(PRINT_ANY, "hsize", "hsize %u ", hsize);
+	}
+
+	if (tb[IFLA_GTP_RESTART_COUNT]) {
+		__u8 restart_count = rta_getattr_u8(tb[IFLA_GTP_RESTART_COUNT]);
+
+		print_uint(PRINT_ANY, "restart_count",
+			   "restart_count %u ", restart_count);
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
index 19a0c9cab811..9c754c4b99cf 100644
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
@@ -1926,6 +1930,29 @@ policies. Policies must be configured with the same key. If not set, the key def
 
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
+.sp
+.BI restart_count " RESTART_COUNT "
+- GTP instance restart counter
+
+.in -8
+
 .SS ip link delete - delete virtual link
 
 .TP
-- 
2.31.1


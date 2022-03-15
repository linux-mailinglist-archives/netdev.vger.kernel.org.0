Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2274D9901
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347195AbiCOKoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345589AbiCOKoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:44:14 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB9FDC1
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647340982; x=1678876982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mJZChNvXgli+KZaSekixb/+k6i1oaOscXfkmptJAS34=;
  b=mO5YsgassAMNGr72s/CfkwbIChZCrpNV/C5eGQOhnxXWKUHiRJ181ss8
   y8T5D3SMSLan2hxrKcUPas1GFUj5SDhfGn+e7sT2KLcweX8QdSyIVLHBM
   j5wN18R9mwkoo29yRCHCHGpqNKj2iyOKjC5za3c+BanXMmocVeDR4kaY1
   N3YGW3hb61nZ4tWcYs43gGq6DbBoDNtQk/hfAx7OxwVT06JCfs3gJ+MNa
   BworrGjHdNnqg/sghy7/vZJbtYdatUbLeEFZ18K8hoz2ehjmmuTHufpiB
   cwXrPmHyD/FlLeD+S5SFTBh5zz8yzPb0k+olyZewSGzKKJwTXAta+pxaU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="316988490"
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="316988490"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 03:43:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="690151153"
Received: from unknown (HELO giewont.igk.intel.com) ([10.211.8.15])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 03:43:01 -0700
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute2-next v4 1/2] ip: GTP support in ip link
Date:   Tue, 15 Mar 2022 11:42:58 +0100
Message-Id: <20220315104259.578133-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315104259.578133-1-wojciech.drewek@intel.com>
References: <20220315104259.578133-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: Harald Welte <laforge@gnumonks.org>
---
 include/uapi/linux/if_link.h |   2 +
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_gtp.c              | 128 +++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  29 +++++++-
 5 files changed, 160 insertions(+), 3 deletions(-)
 create mode 100644 ip/iplink_gtp.c

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5f36ff8e8c26..3edc5547f8dd 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -885,6 +885,8 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_CREATE_SOCKETS,
+	IFLA_GTP_RESTART_COUNT,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
diff --git a/ip/Makefile b/ip/Makefile
index 11a361cef5de..0f14c609a4f0 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -12,7 +12,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
     ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o \
-    iplink_amt.o iplink_batadv.o
+    iplink_amt.o iplink_batadv.o iplink_gtp.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink.c b/ip/iplink.c
index c0a3a9ad3e62..1fe163794d35 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -51,7 +51,7 @@ void iplink_types_usage(void)
 	/* Remember to add new entry here if new type is added. */
 	fprintf(stderr,
 		"TYPE := { amt | bareudp | bond | bond_slave | bridge | bridge_slave |\n"
-		"          dummy | erspan | geneve | gre | gretap | ifb |\n"
+		"          dummy | erspan | geneve | gre | gretap | gtp | ifb |\n"
 		"          ip6erspan | ip6gre | ip6gretap | ip6tnl |\n"
 		"          ipip | ipoib | ipvlan | ipvtap |\n"
 		"          macsec | macvlan | macvtap |\n"
diff --git a/ip/iplink_gtp.c b/ip/iplink_gtp.c
new file mode 100644
index 000000000000..6ba684876a66
--- /dev/null
+++ b/ip/iplink_gtp.c
@@ -0,0 +1,128 @@
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
+	/* When creating GTP device through ip link,
+	 * this flag has to be set.
+	 */
+	addattr8(n, 1024, IFLA_GTP_CREATE_SOCKETS, true);
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
index 93106d7f79ce..7a6753747468 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -243,7 +243,8 @@ ip-link \- network device configuration
 .BR macsec " |"
 .BR netdevsim " |"
 .BR rmnet " |"
-.BR xfrm " ]"
+.BR xfrm " |"
+.BR gtp " ]"
 
 .ti -8
 .IR ETYPE " := [ " TYPE " |"
@@ -392,6 +393,9 @@ Link types:
 .sp
 .BR xfrm
 - Virtual xfrm interface
+.sp
+.BR gtp
+- GPRS Tunneling Protocol
 .in -8
 
 .TP
@@ -1941,6 +1945,29 @@ policies. Policies must be configured with the same key. If not set, the key def
 
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
2.35.1


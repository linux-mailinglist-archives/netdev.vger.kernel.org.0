Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903C03D3BFD
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhGWOIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:08:02 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:59445 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbhGWOHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:07:55 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id F0DCB20AE960;
        Fri, 23 Jul 2021 16:48:26 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be F0DCB20AE960
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1627051707;
        bh=+hEHeu/fnMO8E1cxU/7aweZSx9nn1cp3FoFDTl6EDcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdDq6wlpFRT0SgzzJ/rsBVjrJDp7fxOFZ3EWoLMo/C14kH3SVVJ9tnXixzd7Pkgra
         v6oPE5poCEVVTFo/mshrK3iMewARQb3BbKKREFSlGIQEVBVNfi7iqtg13NzMpOmZeo
         TpZxFSSUR4XOnzwW5k5ru0oiSdbUeqkA6RgxbLYxsJh1QA7h4yF5PskF7VMQeAQV6z
         oRu4gbL5JxSrrQMB1+2pfwn8Phonec7TfheWHL0/PkIz/S22Sdsr7pqVDwUcAlSBTJ
         TIsMS0xUzUSQd6dyBBf1UuSjMjyXqJsyucMv/7fjyMsenXSb11OCFf+Db5/sjQ3Dk6
         U6wvmFfPywbhA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, justin.iurman@uliege.be
Subject: [PATCH iproute2-next 1/3] Add, show, link, remove IOAM namespaces and schemas
Date:   Fri, 23 Jul 2021 16:48:00 +0200
Message-Id: <20210723144802.14380-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210723144802.14380-1-justin.iurman@uliege.be>
References: <20210723144802.14380-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides support for adding, listing and removing IOAM namespaces
and schemas with iproute2. When adding an IOAM namespace, both "data" (=u32)
and "wide" (=u64) are optional. Therefore, you can either have none, one of
them, or both at the same time. When adding an IOAM schema, there is no
restriction on "DATA" except its size (see IOAM6_MAX_SCHEMA_DATA_LEN). By
default, an IOAM namespace has no active IOAM schema (meaning an IOAM namespace
is not linked to an IOAM schema), and an IOAM schema is not considered
as "active" (meaning an IOAM schema is not linked to an IOAM namespace). It is
possible to link an IOAM namespace with an IOAM schema, thanks to the last
command below (meaning the IOAM schema will be considered as "active" for the
specific IOAM namespace).

$ ip ioam
Usage:	ip ioam { COMMAND | help }
	ip ioam namespace show
	ip ioam namespace add ID [ data DATA32 ] [ wide DATA64 ]
	ip ioam namespace del ID
	ip ioam schema show
	ip ioam schema add ID DATA
	ip ioam schema del ID
	ip ioam namespace set ID schema { ID | none }

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/uapi/linux/ioam6_genl.h |  52 +++++
 ip/Makefile                     |   2 +-
 ip/ip.c                         |   3 +-
 ip/ip_common.h                  |   1 +
 ip/ipioam6.c                    | 351 ++++++++++++++++++++++++++++++++
 5 files changed, 407 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/ioam6_genl.h
 create mode 100644 ip/ipioam6.c

diff --git a/include/uapi/linux/ioam6_genl.h b/include/uapi/linux/ioam6_genl.h
new file mode 100644
index 00000000..ca4b2283
--- /dev/null
+++ b/include/uapi/linux/ioam6_genl.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  IPv6 IOAM Generic Netlink API
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#ifndef _UAPI_LINUX_IOAM6_GENL_H
+#define _UAPI_LINUX_IOAM6_GENL_H
+
+#define IOAM6_GENL_NAME "IOAM6"
+#define IOAM6_GENL_VERSION 0x1
+
+enum {
+	IOAM6_ATTR_UNSPEC,
+
+	IOAM6_ATTR_NS_ID,	/* u16 */
+	IOAM6_ATTR_NS_DATA,	/* u32 */
+	IOAM6_ATTR_NS_DATA_WIDE,/* u64 */
+
+#define IOAM6_MAX_SCHEMA_DATA_LEN (255 * 4)
+	IOAM6_ATTR_SC_ID,	/* u32 */
+	IOAM6_ATTR_SC_DATA,	/* Binary */
+	IOAM6_ATTR_SC_NONE,	/* Flag */
+
+	IOAM6_ATTR_PAD,
+
+	__IOAM6_ATTR_MAX,
+};
+
+#define IOAM6_ATTR_MAX (__IOAM6_ATTR_MAX - 1)
+
+enum {
+	IOAM6_CMD_UNSPEC,
+
+	IOAM6_CMD_ADD_NAMESPACE,
+	IOAM6_CMD_DEL_NAMESPACE,
+	IOAM6_CMD_DUMP_NAMESPACES,
+
+	IOAM6_CMD_ADD_SCHEMA,
+	IOAM6_CMD_DEL_SCHEMA,
+	IOAM6_CMD_DUMP_SCHEMAS,
+
+	IOAM6_CMD_NS_SET_SCHEMA,
+
+	__IOAM6_CMD_MAX,
+};
+
+#define IOAM6_CMD_MAX (__IOAM6_CMD_MAX - 1)
+
+#endif /* _UAPI_LINUX_IOAM6_GENL_H */
diff --git a/ip/Makefile b/ip/Makefile
index b03af29b..2ae9df89 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -11,7 +11,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
-    ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o
+    ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/ip.c b/ip/ip.c
index 8e4c6eb5..e7ffeaff 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -64,7 +64,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: ip [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       ip [ -force ] -batch filename\n"
-		"where  OBJECT := { address | addrlabel | fou | help | ila | l2tp | link |\n"
+		"where  OBJECT := { address | addrlabel | fou | help | ila | ioam | l2tp | link |\n"
 		"                   macsec | maddress | monitor | mptcp | mroute | mrule |\n"
 		"                   neighbor | neighbour | netconf | netns | nexthop | ntable |\n"
 		"                   ntbl | route | rule | sr | tap | tcpmetrics |\n"
@@ -121,6 +121,7 @@ static const struct cmd {
 	{ "sr",		do_seg6 },
 	{ "nexthop",	do_ipnh },
 	{ "mptcp",	do_mptcp },
+	{ "ioam",	do_ioam6 },
 	{ "help",	do_help },
 	{ 0 }
 };
diff --git a/ip/ip_common.h b/ip/ip_common.h
index b5b2b082..ad018183 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -90,6 +90,7 @@ int netns_identify_pid(const char *pidstr, char *name, int len);
 int do_seg6(int argc, char **argv);
 int do_ipnh(int argc, char **argv);
 int do_mptcp(int argc, char **argv);
+int do_ioam6(int argc, char **argv);
 
 int iplink_get(char *name, __u32 filt_mask);
 int iplink_ifla_xstats(int argc, char **argv);
diff --git a/ip/ipioam6.c b/ip/ipioam6.c
new file mode 100644
index 00000000..75a59ed4
--- /dev/null
+++ b/ip/ipioam6.c
@@ -0,0 +1,351 @@
+/*
+ * ioam6.c "ip ioam"
+ *
+ *	  This program is free software; you can redistribute it and/or
+ *	  modify it under the terms of the GNU General Public License
+ *	  version 2 as published by the Free Software Foundation;
+ *
+ * Author: Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <inttypes.h>
+
+#include <linux/genetlink.h>
+#include <linux/ioam6_genl.h>
+
+#include "utils.h"
+#include "ip_common.h"
+#include "libgenl.h"
+#include "json_print.h"
+
+static void usage(void)
+{
+	fprintf(stderr,
+		"Usage:	ip ioam { COMMAND | help }\n"
+		"	ip ioam namespace show\n"
+		"	ip ioam namespace add ID [ data DATA32 ] [ wide DATA64 ]\n"
+		"	ip ioam namespace del ID\n"
+		"	ip ioam schema show\n"
+		"	ip ioam schema add ID DATA\n"
+		"	ip ioam schema del ID\n"
+		"	ip ioam namespace set ID schema { ID | none }\n");
+	exit(-1);
+}
+
+static struct rtnl_handle grth = { .fd = -1 };
+static int genl_family = -1;
+
+#define IOAM6_REQUEST(_req, _bufsiz, _cmd, _flags) \
+	 GENL_REQUEST(_req, _bufsiz, genl_family, 0, \
+				IOAM6_GENL_VERSION, _cmd, _flags)
+
+static struct {
+	unsigned int cmd;
+	__u32 sc_id;
+	__u32 ns_data;
+	__u64 ns_data_wide;
+	__u16 ns_id;
+	bool has_ns_data;
+	bool has_ns_data_wide;
+	bool sc_none;
+	__u8 sc_data[IOAM6_MAX_SCHEMA_DATA_LEN];
+} opts;
+
+static void print_namespace(struct rtattr *attrs[])
+{
+	char data[20];
+
+	print_uint(PRINT_ANY, "namespace", "namespace %u",
+		   rta_getattr_u16(attrs[IOAM6_ATTR_NS_ID]));
+
+	if (attrs[IOAM6_ATTR_SC_ID])
+		print_uint(PRINT_ANY, "schema", " [schema %u]",
+			   rta_getattr_u32(attrs[IOAM6_ATTR_SC_ID]));
+
+	if (!attrs[IOAM6_ATTR_NS_DATA]) {
+		print_null(PRINT_ANY, "data", "", NULL);
+	} else {
+		sprintf(data, "0x%" PRIx32,
+			(uint32_t)rta_getattr_u32(attrs[IOAM6_ATTR_NS_DATA]));
+
+		print_string(PRINT_ANY, "data", ", data %s", data);
+	}
+
+	if (!attrs[IOAM6_ATTR_NS_DATA_WIDE]) {
+		print_null(PRINT_ANY, "wide", "", NULL);
+	} else {
+		sprintf(data, "0x%" PRIx64,
+			(uint64_t)rta_getattr_u64(attrs[IOAM6_ATTR_NS_DATA_WIDE]));
+
+		print_string(PRINT_ANY, "wide", ", wide %s", data);
+	}
+
+	print_null(PRINT_ANY, "", "\n", NULL);
+}
+
+static void print_schema(struct rtattr *attrs[])
+{
+	__u8 data[IOAM6_MAX_SCHEMA_DATA_LEN + 1];
+	int len;
+
+	print_uint(PRINT_ANY, "schema", "schema %u",
+		   rta_getattr_u32(attrs[IOAM6_ATTR_SC_ID]));
+
+	if (attrs[IOAM6_ATTR_NS_ID])
+		print_uint(PRINT_ANY, "namespace", " [namespace %u]",
+			   rta_getattr_u16(attrs[IOAM6_ATTR_NS_ID]));
+
+	len = RTA_PAYLOAD(attrs[IOAM6_ATTR_SC_DATA]);
+	memcpy(data, RTA_DATA(attrs[IOAM6_ATTR_SC_DATA]), len);
+	data[len] = '\0';
+
+	print_string(PRINT_ANY, "data", ", data \"%s\"", (const char *)data);
+	print_null(PRINT_ANY, "", "\n", NULL);
+}
+
+static int process_msg(struct nlmsghdr *n, void *arg)
+{
+	struct rtattr *attrs[IOAM6_ATTR_MAX + 1];
+	struct genlmsghdr *ghdr;
+	int len = n->nlmsg_len;
+
+	if (n->nlmsg_type != genl_family)
+		return -1;
+
+	len -= NLMSG_LENGTH(GENL_HDRLEN);
+	if (len < 0)
+		return -1;
+
+	ghdr = NLMSG_DATA(n);
+	parse_rtattr(attrs, IOAM6_ATTR_MAX, (void *)ghdr + GENL_HDRLEN, len);
+
+	open_json_object(NULL);
+	switch (ghdr->cmd) {
+	case IOAM6_CMD_DUMP_NAMESPACES:
+		print_namespace(attrs);
+		break;
+	case IOAM6_CMD_DUMP_SCHEMAS:
+		print_schema(attrs);
+		break;
+	}
+	close_json_object();
+
+	return 0;
+}
+
+static int ioam6_do_cmd(void)
+{
+	IOAM6_REQUEST(req, 1036, opts.cmd, NLM_F_REQUEST);
+	int dump = 0;
+
+	if (genl_family < 0) {
+		if (rtnl_open_byproto(&grth, 0, NETLINK_GENERIC) < 0) {
+			fprintf(stderr, "Cannot open generic netlink socket\n");
+			exit(1);
+		}
+		genl_family = genl_resolve_family(&grth, IOAM6_GENL_NAME);
+		if (genl_family < 0)
+			exit(1);
+		req.n.nlmsg_type = genl_family;
+	}
+
+	switch (opts.cmd) {
+	case IOAM6_CMD_ADD_NAMESPACE:
+		addattr16(&req.n, sizeof(req), IOAM6_ATTR_NS_ID, opts.ns_id);
+		if (opts.has_ns_data)
+			addattr32(&req.n, sizeof(req), IOAM6_ATTR_NS_DATA,
+				  opts.ns_data);
+		if (opts.has_ns_data_wide)
+			addattr64(&req.n, sizeof(req), IOAM6_ATTR_NS_DATA_WIDE,
+				  opts.ns_data_wide);
+		break;
+	case IOAM6_CMD_DEL_NAMESPACE:
+		addattr16(&req.n, sizeof(req), IOAM6_ATTR_NS_ID, opts.ns_id);
+		break;
+	case IOAM6_CMD_DUMP_NAMESPACES:
+	case IOAM6_CMD_DUMP_SCHEMAS:
+		dump = 1;
+		break;
+	case IOAM6_CMD_ADD_SCHEMA:
+		addattr32(&req.n, sizeof(req), IOAM6_ATTR_SC_ID, opts.sc_id);
+		addattr_l(&req.n, sizeof(req), IOAM6_ATTR_SC_DATA, opts.sc_data,
+			  strlen((const char *)opts.sc_data));
+		break;
+	case IOAM6_CMD_DEL_SCHEMA:
+		addattr32(&req.n, sizeof(req), IOAM6_ATTR_SC_ID, opts.sc_id);
+		break;
+	case IOAM6_CMD_NS_SET_SCHEMA:
+		addattr16(&req.n, sizeof(req), IOAM6_ATTR_NS_ID, opts.ns_id);
+		if (opts.sc_none)
+			addattr(&req.n, sizeof(req), IOAM6_ATTR_SC_NONE);
+		else
+			addattr32(&req.n, sizeof(req), IOAM6_ATTR_SC_ID,
+				  opts.sc_id);
+		break;
+	}
+
+	if (!dump) {
+		if (rtnl_talk(&grth, &req.n, NULL) < 0)
+			return -1;
+	} else {
+		req.n.nlmsg_flags |= NLM_F_DUMP;
+		req.n.nlmsg_seq = grth.dump = ++grth.seq;
+		if (rtnl_send(&grth, &req, req.n.nlmsg_len) < 0) {
+			perror("Failed to send dump request");
+			exit(1);
+		}
+
+		new_json_obj(json);
+		if (rtnl_dump_filter(&grth, process_msg, stdout) < 0) {
+			fprintf(stderr, "Dump terminated\n");
+			exit(1);
+		}
+		delete_json_obj();
+		fflush(stdout);
+	}
+
+	return 0;
+}
+
+int do_ioam6(int argc, char **argv)
+{
+	bool maybe_wide = false;
+
+	if (argc < 1 || matches(*argv, "help") == 0)
+		usage();
+
+	memset(&opts, 0, sizeof(opts));
+
+	if (matches(*argv, "namespace") == 0) {
+		NEXT_ARG();
+
+		if (matches(*argv, "show") == 0) {
+			opts.cmd = IOAM6_CMD_DUMP_NAMESPACES;
+
+		} else if (matches(*argv, "add") == 0) {
+			NEXT_ARG();
+
+			if (get_u16(&opts.ns_id, *argv, 0))
+				invarg("Invalid namespace ID", *argv);
+
+			if (NEXT_ARG_OK()) {
+				NEXT_ARG_FWD();
+
+				if (matches(*argv, "data") == 0) {
+					NEXT_ARG();
+
+					if (get_u32(&opts.ns_data, *argv, 0))
+						invarg("Invalid data", *argv);
+
+					maybe_wide = true;
+					opts.has_ns_data = true;
+
+				} else if (matches(*argv, "wide") == 0) {
+					NEXT_ARG();
+
+					if (get_u64(&opts.ns_data_wide, *argv, 16))
+						invarg("Invalid wide data", *argv);
+
+					opts.has_ns_data_wide = true;
+
+				} else {
+					invarg("Invalid argument", *argv);
+				}
+			}
+
+			if (NEXT_ARG_OK()) {
+				NEXT_ARG_FWD();
+
+				if (!maybe_wide || matches(*argv, "wide") != 0)
+					invarg("Unexpected argument", *argv);
+
+				NEXT_ARG();
+
+				if (get_u64(&opts.ns_data_wide, *argv, 16))
+					invarg("Invalid wide data", *argv);
+
+				opts.has_ns_data_wide = true;
+			}
+
+			opts.cmd = IOAM6_CMD_ADD_NAMESPACE;
+
+		} else if (matches(*argv, "del") == 0) {
+			NEXT_ARG();
+
+			if (get_u16(&opts.ns_id, *argv, 0))
+				invarg("Invalid namespace ID", *argv);
+
+			opts.cmd = IOAM6_CMD_DEL_NAMESPACE;
+
+		} else if (matches(*argv, "set") == 0) {
+			NEXT_ARG();
+
+			if (get_u16(&opts.ns_id, *argv, 0))
+				invarg("Invalid namespace ID", *argv);
+
+			NEXT_ARG();
+
+			if (matches(*argv, "schema") != 0)
+				invarg("Unknown", *argv);
+
+			NEXT_ARG();
+
+			if (matches(*argv, "none") == 0) {
+				opts.sc_none = true;
+
+			} else {
+				if (get_u32(&opts.sc_id, *argv, 0))
+					invarg("Invalid schema ID", *argv);
+
+				opts.sc_none = false;
+			}
+
+			opts.cmd = IOAM6_CMD_NS_SET_SCHEMA;
+
+		} else {
+			invarg("Unknown", *argv);
+		}
+
+	} else if (matches(*argv, "schema") == 0) {
+		NEXT_ARG();
+
+		if (matches(*argv, "show") == 0) {
+			opts.cmd = IOAM6_CMD_DUMP_SCHEMAS;
+
+		} else if (matches(*argv, "add") == 0) {
+			NEXT_ARG();
+
+			if (get_u32(&opts.sc_id, *argv, 0))
+				invarg("Invalid schema ID", *argv);
+
+			NEXT_ARG();
+
+			if (strlen(*argv) > IOAM6_MAX_SCHEMA_DATA_LEN)
+				invarg("Schema DATA too big", *argv);
+
+			memcpy(opts.sc_data, *argv, strlen(*argv));
+			opts.cmd = IOAM6_CMD_ADD_SCHEMA;
+
+		} else if (matches(*argv, "del") == 0) {
+			NEXT_ARG();
+
+			if (get_u32(&opts.sc_id, *argv, 0))
+				invarg("Invalid schema ID", *argv);
+
+			opts.cmd = IOAM6_CMD_DEL_SCHEMA;
+
+		} else {
+			invarg("Unknown", *argv);
+		}
+
+	} else {
+		invarg("Unknown", *argv);
+	}
+
+	return ioam6_do_cmd();
+}
-- 
2.25.1


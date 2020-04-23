Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4CE1B5CB6
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgDWNj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:39:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48704 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728153AbgDWNj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:39:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587649163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CNoK9FeyjIoGvZkSjCXUC6JUzS9g2oCXp5MBDvFh/GM=;
        b=Dz7q4E9GZxOAVnwWcHpTdBe/YKZAnbPsdsEuKHTK8MNVpmVsvhv+nTRFJ29sB8SZuTpGKu
        adm5Y11WqHvCyO+TFULbojVNTyBL5MkswAxv0PMISVKUkH1tbMTkJz8JWtKeVHvHY+jnft
        B1zel4phua4Ca0S6wimqv0haUQYLRsg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-D99k2xSzNPu9eICkuTDe-w-1; Thu, 23 Apr 2020 09:39:20 -0400
X-MC-Unique: D99k2xSzNPu9eICkuTDe-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68534461;
        Thu, 23 Apr 2020 13:39:19 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-154.ams2.redhat.com [10.36.114.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 147BF1000325;
        Thu, 23 Apr 2020 13:39:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     dcaratti@redhat.com
Subject: [PATCH iproute2-next 2/4] add support for mptcp netlink interface
Date:   Thu, 23 Apr 2020 15:37:08 +0200
Message-Id: <cea8ab2c807b8ccfbde988ecb7153ae1fcf853ab.1587572928.git.pabeni@redhat.com>
In-Reply-To: <cover.1587572928.git.pabeni@redhat.com>
References: <cover.1587572928.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement basic commands to:
- manipulate MPTCP endpoints list
- manipulate MPTCP connection limits

Examples:
1. Allows multiple subflows per MPTCP connection
   $ ip mptcp limits set subflows 2

2. Accept ADD_ADDR announcement from the peer (server):
   $ ip mptcp limits set add_addr_accepted 2

3. Add a ipv4 address to be annunced for backup subflows:
   $ ip mptcp endpoint add 10.99.1.2 signal backup

4. Add an ipv6 address used as source for additional subflows:
   $ ip mptcp endpoint add 2001::2 subflow

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 ip/Makefile    |   2 +-
 ip/ip.c        |   3 +-
 ip/ip_common.h |   1 +
 ip/ipmptcp.c   | 436 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 440 insertions(+), 2 deletions(-)
 create mode 100644 ip/ipmptcp.c

diff --git a/ip/Makefile b/ip/Makefile
index 5ab78d7d..8735b8e4 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -11,7 +11,7 @@ IPOBJ=3Dip.o ipaddress.o ipaddrlabel.o iproute.o iprule=
.o ipnetns.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
-    ipnexthop.o
+    ipnexthop.o ipmptcp.o
=20
 RTMONOBJ=3Drtmon.o
=20
diff --git a/ip/ip.c b/ip/ip.c
index 90392c2a..4249df03 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -51,7 +51,7 @@ static void usage(void)
 		"where  OBJECT :=3D { link | address | addrlabel | route | rule | neig=
h | ntable |\n"
 		"                   tunnel | tuntap | maddress | mroute | mrule | moni=
tor | xfrm |\n"
 		"                   netns | l2tp | fou | macsec | tcp_metrics | token =
| netconf | ila |\n"
-		"                   vrf | sr | nexthop }\n"
+		"                   vrf | sr | nexthop | mptcp }\n"
 		"       OPTIONS :=3D { -V[ersion] | -s[tatistics] | -d[etails] | -r[es=
olve] |\n"
 		"                    -h[uman-readable] | -iec | -j[son] | -p[retty] |\=
n"
 		"                    -f[amily] { inet | inet6 | mpls | bridge | link }=
 |\n"
@@ -103,6 +103,7 @@ static const struct cmd {
 	{ "vrf",	do_ipvrf},
 	{ "sr",		do_seg6 },
 	{ "nexthop",	do_ipnh },
+	{ "mptcp",	do_mptcp },
 	{ "help",	do_help },
 	{ 0 }
 };
diff --git a/ip/ip_common.h b/ip/ip_common.h
index 879287e3..d604f755 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -83,6 +83,7 @@ void vrf_reset(void);
 int netns_identify_pid(const char *pidstr, char *name, int len);
 int do_seg6(int argc, char **argv);
 int do_ipnh(int argc, char **argv);
+int do_mptcp(int argc, char **argv);
=20
 int iplink_get(char *name, __u32 filt_mask);
 int iplink_ifla_xstats(int argc, char **argv);
diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
new file mode 100644
index 00000000..bc12418b
--- /dev/null
+++ b/ip/ipmptcp.c
@@ -0,0 +1,436 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <string.h>
+#include <rt_names.h>
+#include <errno.h>
+
+#include <linux/genetlink.h>
+#include <linux/mptcp.h>
+
+#include "utils.h"
+#include "ip_common.h"
+#include "libgenl.h"
+#include "json_print.h"
+
+static void usage(void)
+{
+	fprintf(stderr,
+		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
+		"				      [ FLAG-LIST ]\n"
+		"	ip mptcp endpoint delete id ID\n"
+		"	ip mptcp endpoint show [ id ID ]\n"
+		"	ip mptcp endpoint flush\n"
+		"	ip mptcp limits set [ subflows NR ] [ add_addr_accepted NR ]\n"
+		"	ip mptcp limits show\n"
+		"FLAG-LIST :=3D [ FLAG-LIST ] FLAG\n"
+		"FLAG  :=3D [ signal | subflow | backup ]\n");
+
+	exit(-1);
+}
+
+/* netlink socket */
+static struct rtnl_handle genl_rth =3D { .fd =3D -1 };
+static int genl_family =3D -1;
+
+#define MPTCP_BUFLEN	4096
+#define MPTCP_REQUEST(_req,  _cmd, _flags)	\
+	GENL_REQUEST(_req, MPTCP_BUFLEN, genl_family, 0,	\
+		     MPTCP_PM_VER, _cmd, _flags)
+
+/* Mapping from argument to address flag mask */
+static const struct {
+	const char *name;
+	unsigned long value;
+} mptcp_addr_flag_names[] =3D {
+	{ "signal",		MPTCP_PM_ADDR_FLAG_SIGNAL },
+	{ "subflow",		MPTCP_PM_ADDR_FLAG_SUBFLOW },
+	{ "backup",		MPTCP_PM_ADDR_FLAG_BACKUP },
+};
+
+static void print_mptcp_addr_flags(unsigned int flags)
+{
+	unsigned int i;
+
+	for (i =3D 0; i < ARRAY_SIZE(mptcp_addr_flag_names); i++) {
+		unsigned long mask =3D mptcp_addr_flag_names[i].value;
+
+		if (flags & mask) {
+			print_string(PRINT_FP, NULL, "%s ",
+				     mptcp_addr_flag_names[i].name);
+			print_bool(PRINT_JSON,
+				   mptcp_addr_flag_names[i].name, NULL, true);
+		}
+
+		flags &=3D ~mask;
+	}
+
+	if (flags) {
+		/* unknown flags */
+		SPRINT_BUF(b1);
+
+		snprintf(b1, sizeof(b1), "%02x", flags);
+		print_string(PRINT_ANY, "rawflags", "rawflags %s ", b1);
+	}
+}
+
+static int get_flags(const char *arg, __u32 *flags)
+{
+	unsigned int i;
+
+	for (i =3D 0; i < ARRAY_SIZE(mptcp_addr_flag_names); i++) {
+		if (strcmp(arg, mptcp_addr_flag_names[i].name))
+			continue;
+
+		*flags |=3D mptcp_addr_flag_names[i].value;
+		return 0;
+	}
+	return -1;
+}
+
+static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n,
+			 bool adding)
+{
+	struct rtattr *attr_addr;
+	bool addr_set =3D false;
+	inet_prefix address;
+	bool id_set =3D false;
+	__u32 index =3D 0;
+	__u32 flags =3D 0;
+	__u8 id =3D 0;
+
+	ll_init_map(&rth);
+	while (argc > 0) {
+		if (get_flags(*argv, &flags) =3D=3D 0) {
+		} else if (matches(*argv, "id") =3D=3D 0) {
+			NEXT_ARG();
+
+			if (get_u8(&id, *argv, 0))
+				invarg("invalid ID\n", *argv);
+			id_set =3D true;
+		} else if (matches(*argv, "dev") =3D=3D 0) {
+			const char *ifname;
+
+			NEXT_ARG();
+
+			ifname =3D *argv;
+
+			if (check_ifname(ifname))
+				invarg("invalid interface name\n", ifname);
+
+			index =3D ll_name_to_index(ifname);
+
+			if (!index)
+				invarg("device does not exist\n", ifname);
+
+		} else if (get_addr(&address, *argv, AF_UNSPEC) =3D=3D 0) {
+			addr_set =3D true;
+		} else {
+			invarg("unknown argument", *argv);
+		}
+		NEXT_ARG_FWD();
+	}
+
+	if (!addr_set && adding)
+		missarg("ADDRESS");
+
+	if (!id_set && !adding)
+		missarg("ID");
+
+	attr_addr =3D addattr_nest(n, MPTCP_BUFLEN,
+				 MPTCP_PM_ATTR_ADDR | NLA_F_NESTED);
+	if (id_set)
+		addattr8(n, MPTCP_BUFLEN, MPTCP_PM_ADDR_ATTR_ID, id);
+	if (flags)
+		addattr32(n, MPTCP_BUFLEN, MPTCP_PM_ADDR_ATTR_FLAGS, flags);
+	if (index)
+		addattr32(n, MPTCP_BUFLEN, MPTCP_PM_ADDR_ATTR_IF_IDX, index);
+	if (addr_set) {
+		int type;
+
+		addattr16(n, MPTCP_BUFLEN, MPTCP_PM_ADDR_ATTR_FAMILY,
+			  address.family);
+		type =3D address.family =3D=3D AF_INET ? MPTCP_PM_ADDR_ATTR_ADDR4 :
+						   MPTCP_PM_ADDR_ATTR_ADDR6;
+		addattr_l(n, MPTCP_BUFLEN, type, &address.data,
+			  address.bytelen);
+	}
+
+	addattr_nest_end(n, attr_addr);
+	return 0;
+}
+
+static int mptcp_addr_modify(int argc, char **argv, int cmd)
+{
+	MPTCP_REQUEST(req, cmd, NLM_F_REQUEST);
+	int ret;
+
+	ret =3D mptcp_parse_opt(argc, argv, &req.n, cmd =3D=3D MPTCP_PM_CMD_ADD=
_ADDR);
+	if (ret)
+		return ret;
+
+	if (rtnl_talk(&genl_rth, &req.n, NULL) < 0)
+		return -2;
+
+	return 0;
+}
+
+static int print_mptcp_addrinfo(struct rtattr *addrinfo)
+{
+	struct rtattr *tb[MPTCP_PM_ADDR_ATTR_MAX + 1];
+	__u8 family =3D AF_UNSPEC, addr_attr_type;
+	const char *ifname;
+	unsigned int flags;
+	int index;
+	__u16 id;
+
+	parse_rtattr_nested(tb, MPTCP_PM_ADDR_ATTR_MAX, addrinfo);
+
+	open_json_object(NULL);
+	if (tb[MPTCP_PM_ADDR_ATTR_FAMILY])
+		family =3D rta_getattr_u8(tb[MPTCP_PM_ADDR_ATTR_FAMILY]);
+
+	addr_attr_type =3D family =3D=3D AF_INET ? MPTCP_PM_ADDR_ATTR_ADDR4 :
+					     MPTCP_PM_ADDR_ATTR_ADDR6;
+	if (tb[addr_attr_type]) {
+		print_string(PRINT_ANY, "address", "%s ",
+			     format_host_rta(family, tb[addr_attr_type]));
+	}
+	if (tb[MPTCP_PM_ADDR_ATTR_ID]) {
+		id =3D rta_getattr_u8(tb[MPTCP_PM_ADDR_ATTR_ID]);
+		print_uint(PRINT_ANY, "id", "id %u ", id);
+	}
+	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS]) {
+		flags =3D rta_getattr_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
+		print_mptcp_addr_flags(flags);
+	}
+	if (tb[MPTCP_PM_ADDR_ATTR_IF_IDX]) {
+		index =3D rta_getattr_s32(tb[MPTCP_PM_ADDR_ATTR_IF_IDX]);
+		ifname =3D index ? ll_index_to_name(index) : NULL;
+
+		if (ifname)
+			print_string(PRINT_ANY, "dev", "dev %s ", ifname);
+	}
+
+	close_json_object();
+	print_string(PRINT_FP, NULL, "\n", NULL);
+	fflush(stdout);
+
+	return 0;
+}
+
+static int print_mptcp_addr(struct nlmsghdr *n, void *arg)
+{
+	struct rtattr *tb[MPTCP_PM_ATTR_MAX + 1];
+	struct genlmsghdr *ghdr;
+	struct rtattr *addrinfo;
+	int len =3D n->nlmsg_len;
+
+	if (n->nlmsg_type !=3D genl_family)
+		return 0;
+
+	len -=3D NLMSG_LENGTH(GENL_HDRLEN);
+	if (len < 0)
+		return -1;
+
+	ghdr =3D NLMSG_DATA(n);
+	parse_rtattr_flags(tb, MPTCP_PM_ATTR_MAX, (void *) ghdr + GENL_HDRLEN,
+			   len, NLA_F_NESTED);
+	addrinfo =3D tb[MPTCP_PM_ATTR_ADDR];
+	if (!addrinfo)
+		return -1;
+
+	ll_init_map(&rth);
+	return print_mptcp_addrinfo(addrinfo);
+}
+
+static int mptcp_addr_dump(void)
+{
+	MPTCP_REQUEST(req, MPTCP_PM_CMD_GET_ADDR, NLM_F_REQUEST | NLM_F_DUMP);
+
+	if (rtnl_send(&genl_rth, &req.n, req.n.nlmsg_len) < 0) {
+		perror("Cannot send show request");
+		exit(1);
+	}
+
+	new_json_obj(json);
+
+	if (rtnl_dump_filter(&genl_rth, print_mptcp_addr, stdout) < 0) {
+		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
+		fflush(stdout);
+		return -2;
+	}
+
+	close_json_object();
+	fflush(stdout);
+	return 0;
+}
+
+static int mptcp_addr_show(int argc, char **argv)
+{
+	MPTCP_REQUEST(req, MPTCP_PM_CMD_GET_ADDR, NLM_F_REQUEST);
+	struct nlmsghdr *answer;
+	int ret;
+
+	if (!argv)
+		return mptcp_addr_dump();
+
+	ret =3D mptcp_parse_opt(argc, argv, &req.n, false);
+	if (ret)
+		return ret;
+
+	if (rtnl_talk(&genl_rth, &req.n, &answer) < 0)
+		return -2;
+
+	return print_mptcp_addr(answer, stdout);
+}
+
+static int mptcp_addr_flush(int argc, char **argv)
+{
+	MPTCP_REQUEST(req, MPTCP_PM_CMD_FLUSH_ADDRS, NLM_F_REQUEST);
+
+	if (rtnl_talk(&genl_rth, &req.n, NULL) < 0)
+		return -2;
+
+	return 0;
+}
+
+static int mptcp_parse_limit(int argc, char **argv, struct nlmsghdr *n)
+{
+	bool set_rcv_add_addrs =3D false;
+	bool set_subflows =3D false;
+	__u32 rcv_add_addrs =3D 0;
+	__u32 subflows =3D 0;
+
+	while (argc > 0) {
+		if (matches(*argv, "subflows") =3D=3D 0) {
+			NEXT_ARG();
+
+			if (get_u32(&subflows, *argv, 0))
+				invarg("invalid subflows\n", *argv);
+			set_subflows =3D true;
+		} else if (matches(*argv, "add_addr_accepted") =3D=3D 0) {
+			NEXT_ARG();
+
+			if (get_u32(&rcv_add_addrs, *argv, 0))
+				invarg("invalid add_addr_accepted\n", *argv);
+			set_rcv_add_addrs =3D true;
+		} else {
+			invarg("unknown limit", *argv);
+		}
+		NEXT_ARG_FWD();
+	}
+
+	if (set_rcv_add_addrs)
+		addattr32(n, MPTCP_BUFLEN, MPTCP_PM_ATTR_RCV_ADD_ADDRS,
+			  rcv_add_addrs);
+	if (set_subflows)
+		addattr32(n, MPTCP_BUFLEN, MPTCP_PM_ATTR_SUBFLOWS, subflows);
+	return set_rcv_add_addrs || set_subflows;
+}
+
+static int print_mptcp_limit(struct nlmsghdr *n, void *arg)
+{
+	struct rtattr *tb[MPTCP_PM_ATTR_MAX + 1];
+	struct genlmsghdr *ghdr;
+	int len =3D n->nlmsg_len;
+	__u32 val;
+
+	if (n->nlmsg_type !=3D genl_family)
+		return 0;
+
+	len -=3D NLMSG_LENGTH(GENL_HDRLEN);
+	if (len < 0)
+		return -1;
+
+	ghdr =3D NLMSG_DATA(n);
+	parse_rtattr(tb, MPTCP_PM_ATTR_MAX, (void *) ghdr + GENL_HDRLEN, len);
+
+	open_json_object(NULL);
+	if (tb[MPTCP_PM_ATTR_RCV_ADD_ADDRS]) {
+		val =3D rta_getattr_u32(tb[MPTCP_PM_ATTR_RCV_ADD_ADDRS]);
+
+		print_uint(PRINT_ANY, "add_addr_accepted",
+			   "add_addr_accepted %d ", val);
+	}
+
+	if (tb[MPTCP_PM_ATTR_SUBFLOWS]) {
+		val =3D rta_getattr_u32(tb[MPTCP_PM_ATTR_SUBFLOWS]);
+
+		print_uint(PRINT_ANY, "subflows", "subflows %d ", val);
+	}
+	print_string(PRINT_FP, NULL, "%s", "\n");
+	fflush(stdout);
+	close_json_object();
+	return 0;
+}
+
+static int mptcp_limit_get_set(int argc, char **argv, int cmd)
+{
+	bool do_get =3D cmd =3D=3D MPTCP_PM_CMD_GET_LIMITS;
+	MPTCP_REQUEST(req, cmd, NLM_F_REQUEST);
+	struct nlmsghdr *answer;
+	int ret;
+
+	ret =3D mptcp_parse_limit(argc, argv, &req.n);
+	if (ret < 0)
+		return -1;
+
+	if (rtnl_talk(&genl_rth, &req.n, do_get ? &answer : NULL) < 0)
+		return -2;
+
+	if (do_get)
+		return print_mptcp_limit(answer, stdout);
+	return 0;
+}
+
+int do_mptcp(int argc, char **argv)
+{
+	if (argc =3D=3D 0)
+		usage();
+
+	if (matches(*argv, "help") =3D=3D 0)
+		usage();
+
+	if (genl_init_handle(&genl_rth, MPTCP_PM_NAME, &genl_family))
+		exit(1);
+
+	if (matches(*argv, "endpoint") =3D=3D 0) {
+		NEXT_ARG_FWD();
+		if (argc =3D=3D 0)
+			return mptcp_addr_show(0, NULL);
+
+		if (matches(*argv, "add") =3D=3D 0)
+			return mptcp_addr_modify(argc-1, argv+1,
+						 MPTCP_PM_CMD_ADD_ADDR);
+		if (matches(*argv, "delete") =3D=3D 0)
+			return mptcp_addr_modify(argc-1, argv+1,
+						 MPTCP_PM_CMD_DEL_ADDR);
+		if (matches(*argv, "show") =3D=3D 0)
+			return mptcp_addr_show(argc-1, argv+1);
+		if (matches(*argv, "flush") =3D=3D 0)
+			return mptcp_addr_flush(argc-1, argv+1);
+
+		goto unknown;
+	}
+
+	if (matches(*argv, "limits") =3D=3D 0) {
+		NEXT_ARG_FWD();
+		if (argc =3D=3D 0)
+			return mptcp_limit_get_set(0, NULL,
+						   MPTCP_PM_CMD_GET_LIMITS);
+
+		if (matches(*argv, "set") =3D=3D 0)
+			return mptcp_limit_get_set(argc-1, argv+1,
+						   MPTCP_PM_CMD_SET_LIMITS);
+		if (matches(*argv, "show") =3D=3D 0)
+			return mptcp_limit_get_set(argc-1, argv+1,
+						   MPTCP_PM_CMD_GET_LIMITS);
+	}
+
+unknown:
+	fprintf(stderr, "Command \"%s\" is unknown, try \"ip mptcp help\".\n",
+		*argv);
+	exit(-1);
+}
--=20
2.21.1


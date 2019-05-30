Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9592F079
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbfE3EE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731284AbfE3DRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:17:51 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A1BC24726;
        Thu, 30 May 2019 03:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186270;
        bh=TnAzSjysJjoHjdM1cJsd6M/JgE89A33czrFw+dA8t2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HjltWk1BpbsSydq7B479zqWnalKkuPHxUYL25vrcVxq/L2a2/eE0uhuUwh+Ved0q
         T3fCp9mNvDUXp/dXq+3Cbh5CBcQqW12em+zbPZrtaqeiz/fVpBktWObIHRUgosKjAV
         koILXVB7W+MDDyf09EemNQ9EP8oKOx6G8ITaWhCg=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 7/9] Add support for nexthop objects
Date:   Wed, 29 May 2019 20:17:44 -0700
Message-Id: <20190530031746.2040-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530031746.2040-1-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add nexthop subcommand to ip. Implement basic commands for creating,
deleting and dumping nexthop objects. Syntax follows 'nexthop' syntax
from existing 'ip route' command.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/Makefile    |   3 +-
 ip/ip.c        |   3 +-
 ip/ip_common.h |   2 +
 ip/ipnexthop.c | 571 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 577 insertions(+), 2 deletions(-)
 create mode 100644 ip/ipnexthop.c

diff --git a/ip/Makefile b/ip/Makefile
index 7ce6e91a528c..5ab78d7d3b84 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -10,7 +10,8 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     link_iptnl.o link_gre6.o iplink_bond.o iplink_bond_slave.o iplink_hsr.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
-    ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o
+    ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
+    ipnexthop.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/ip.c b/ip/ip.c
index b71ae816e24d..b46fd8dd056c 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -50,7 +50,7 @@ static void usage(void)
 		"where  OBJECT := { link | address | addrlabel | route | rule | neigh | ntable |\n"
 		"                   tunnel | tuntap | maddress | mroute | mrule | monitor | xfrm |\n"
 		"                   netns | l2tp | fou | macsec | tcp_metrics | token | netconf | ila |\n"
-		"                   vrf | sr }\n"
+		"                   vrf | sr | nexthop }\n"
 		"       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[esolve] |\n"
 		"                    -h[uman-readable] | -iec | -j[son] | -p[retty] |\n"
 		"                    -f[amily] { inet | inet6 | mpls | bridge | link } |\n"
@@ -100,6 +100,7 @@ static const struct cmd {
 	{ "netconf",	do_ipnetconf },
 	{ "vrf",	do_ipvrf},
 	{ "sr",		do_seg6 },
+	{ "nexthop",	do_ipnh },
 	{ "help",	do_help },
 	{ 0 }
 };
diff --git a/ip/ip_common.h b/ip/ip_common.h
index 1c90770be548..5f73247ac488 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -47,6 +47,7 @@ int print_prefix(struct nlmsghdr *n, void *arg);
 int print_rule(struct nlmsghdr *n, void *arg);
 int print_netconf(struct rtnl_ctrl_data *ctrl,
 		  struct nlmsghdr *n, void *arg);
+int print_nexthop(struct nlmsghdr *n, void *arg);
 void netns_map_init(void);
 void netns_nsid_socket_init(void);
 int print_nsid(struct nlmsghdr *n, void *arg);
@@ -80,6 +81,7 @@ int do_ipvrf(int argc, char **argv);
 void vrf_reset(void);
 int netns_identify_pid(const char *pidstr, char *name, int len);
 int do_seg6(int argc, char **argv);
+int do_ipnh(int argc, char **argv);
 
 int iplink_get(char *name, __u32 filt_mask);
 int iplink_ifla_xstats(int argc, char **argv);
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
new file mode 100644
index 000000000000..84c2f01d7309
--- /dev/null
+++ b/ip/ipnexthop.c
@@ -0,0 +1,571 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ip nexthop
+ *
+ * Copyright (c) 2017-19 Cumulus Networks
+ * Copyright (c) 2017-19 David Ahern <dsahern@gmail.com>
+ */
+
+#include <linux/nexthop.h>
+#include <stdio.h>
+#include <string.h>
+#include <rt_names.h>
+#include <errno.h>
+
+#include "utils.h"
+#include "ip_common.h"
+
+static struct
+{
+	unsigned int flushed;
+	unsigned int groups;
+	unsigned int ifindex;
+	unsigned int master;
+	char *flushb;
+	int flushp;
+	int flushe;
+} filter;
+
+enum {
+	IPNH_LIST,
+	IPNH_FLUSH,
+};
+
+#define RTM_NHA(h)  ((struct rtattr *)(((char *)(h)) + \
+			NLMSG_ALIGN(sizeof(struct nhmsg))))
+
+static void usage(void) __attribute__((noreturn));
+
+static void usage(void)
+{
+	fprintf(stderr,
+		"Usage: ip nexthop { list | flush } SELECTOR\n"
+		"       ip nexthop get id ID\n"
+		"       ip nexthop { add | replace } NH\n"
+		"       ip nexthop del id ID\n"
+		"SELECTOR := [ id ID ] [ dev DEV ] [ vrf NAME ] [ master DEV ] [ groups ]\n"
+		"NH := [ id ID ] [ via [ FAMILY ] ADDRESS ] [ dev DEV ]\n"
+		"      [ group <id[,weight]>[/<id[,weight]>/...] ] [ NHFLAGS ]\n"
+		"      [ encap ENCAPTYPE ENCAPHDR ]\n"
+		"NHFLAGS := [ onlink ]\n");
+	exit(-1);
+}
+
+static int nh_dump_filter(struct nlmsghdr *nlh, int reqlen)
+{
+	int err;
+
+	if (filter.ifindex) {
+		err = addattr32(nlh, reqlen, NHA_OIF, filter.ifindex);
+		if (err)
+			return err;
+	}
+
+	if (filter.groups) {
+		addattr_l(nlh, reqlen, NHA_GROUPS, NULL, 0);
+		if (err)
+			return err;
+	}
+
+	if (filter.master) {
+		addattr32(nlh, reqlen, NHA_MASTER, filter.master);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+struct rtnl_handle rth_del = { .fd = -1 };
+
+static int delete_nexthop(__u32 id)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct nhmsg	nhm;
+		char		buf[64];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct nhmsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = RTM_DELNEXTHOP,
+		.nhm.nh_family = AF_UNSPEC,
+	};
+
+	req.n.nlmsg_seq = ++rth_del.seq;
+
+	addattr32(&req.n, sizeof(req), NHA_ID, id);
+
+	if (rtnl_talk(&rth_del, &req.n, NULL) < 0)
+		return -1;
+	return 0;
+}
+
+static int flush_nexthop(struct nlmsghdr *nlh, void *arg)
+{
+	struct nhmsg *nhm = NLMSG_DATA(nlh);
+	struct rtattr *tb[NHA_MAX+1];
+	__u32 id = 0;
+	int len;
+
+	len = nlh->nlmsg_len - NLMSG_SPACE(sizeof(*nhm));
+	if (len < 0) {
+		fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
+		return -1;
+	}
+
+	parse_rtattr(tb, NHA_MAX, RTM_NHA(nhm), len);
+	if (tb[NHA_ID])
+		id = rta_getattr_u32(tb[NHA_ID]);
+
+	if (id && !delete_nexthop(id))
+		filter.flushed++;
+
+	return 0;
+}
+
+static int ipnh_flush(unsigned int all)
+{
+	int rc = -2;
+
+	if (all) {
+		filter.groups = 1;
+		filter.ifindex = 0;
+		filter.master = 0;
+	}
+
+	if (rtnl_open(&rth_del, 0) < 0) {
+		fprintf(stderr, "Cannot open rtnetlink\n");
+		return EXIT_FAILURE;
+	}
+again:
+	if (rtnl_nexthopdump_req(&rth, preferred_family, nh_dump_filter) < 0) {
+		perror("Cannot send dump request");
+		goto out;
+	}
+
+	if (rtnl_dump_filter(&rth, flush_nexthop, stdout) < 0) {
+		fprintf(stderr, "Dump terminated\n");
+		goto out;
+	}
+
+	/* if deleting all, then remove groups first */
+	if (all && filter.groups) {
+		filter.groups = 0;
+		goto again;
+	}
+
+	rc = 0;
+out:
+	rtnl_close(&rth_del);
+	if (!filter.flushed)
+		printf("Nothing to flush\n");
+	else
+		printf("Flushed %d nexthops\n", filter.flushed);
+
+	return rc;
+}
+
+static void print_nh_group(FILE *fp, const struct rtattr *grps_attr)
+{
+	struct nexthop_grp *nhg = RTA_DATA(grps_attr);
+	int num = RTA_PAYLOAD(grps_attr) / sizeof(*nhg);
+	int i;
+
+	if (!num || num * sizeof(*nhg) != RTA_PAYLOAD(grps_attr)) {
+		fprintf(fp, "<invalid nexthop group>");
+		return;
+	}
+
+	open_json_array(PRINT_JSON, "group");
+	print_string(PRINT_FP, NULL, "%s", "group ");
+	for (i = 0; i < num; ++i) {
+		open_json_object(NULL);
+
+		if (i)
+			print_string(PRINT_FP, NULL, "%s", "/");
+
+		print_uint(PRINT_ANY, "id", "%u", nhg[i].id);
+		if (nhg[i].weight)
+			print_uint(PRINT_ANY, "weight", ",%u", nhg[i].weight);
+
+		close_json_object();
+	}
+	close_json_array(PRINT_JSON, NULL);
+}
+
+static void print_nh_gateway(FILE *fp, const struct nhmsg *nhm,
+			      const struct rtattr *rta)
+{
+	const char *gateway = format_host_rta(nhm->nh_family, rta);
+
+	if (is_json_context())
+		print_string(PRINT_JSON, "gateway", NULL, gateway);
+	else {
+		fprintf(fp, "via ");
+		print_color_string(PRINT_FP, ifa_family_color(nhm->nh_family),
+				  NULL, "%s ", gateway);
+	}
+}
+
+int print_nexthop(struct nlmsghdr *n, void *arg)
+{
+	struct nhmsg *nhm = NLMSG_DATA(n);
+	struct rtattr *tb[NHA_MAX+1];
+	FILE *fp = (FILE *)arg;
+	int len;
+
+	SPRINT_BUF(b1);
+
+	if (n->nlmsg_type != RTM_DELNEXTHOP &&
+	    n->nlmsg_type != RTM_NEWNEXTHOP) {
+		fprintf(stderr, "Not a nexthop: %08x %08x %08x\n",
+			n->nlmsg_len, n->nlmsg_type, n->nlmsg_flags);
+		return -1;
+	}
+
+	len = n->nlmsg_len - NLMSG_SPACE(sizeof(*nhm));
+	if (len < 0) {
+		close_json_object();
+		fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
+		return -1;
+	}
+
+	parse_rtattr(tb, NHA_MAX, RTM_NHA(nhm), len);
+
+	open_json_object(NULL);
+
+	if (n->nlmsg_type == RTM_DELROUTE)
+		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
+
+	if (tb[NHA_ID])
+		print_uint(PRINT_ANY, "id", "id %u ",
+			   rta_getattr_u32(tb[NHA_ID]));
+
+	if (tb[NHA_GROUP])
+		print_nh_group(fp, tb[NHA_GROUP]);
+
+	if (tb[NHA_ENCAP])
+		lwt_print_encap(fp, tb[NHA_ENCAP_TYPE], tb[NHA_ENCAP]);
+
+	if (tb[NHA_GATEWAY])
+		print_nh_gateway(fp, nhm, tb[NHA_GATEWAY]);
+
+	if (tb[NHA_OIF])
+		print_rta_if(fp, tb[NHA_OIF], "dev");
+
+	if (nhm->nh_scope != RT_SCOPE_UNIVERSE || show_details > 0) {
+		print_string(PRINT_ANY, "scope", "scope %s ",
+			     rtnl_rtscope_n2a(nhm->nh_scope, b1, sizeof(b1)));
+	}
+
+	if (tb[NHA_BLACKHOLE])
+		print_null(PRINT_ANY, "blackhole", "blackhole", NULL);
+
+	if (nhm->nh_protocol != RTPROT_UNSPEC || show_details > 0) {
+		print_string(PRINT_ANY, "protocol", "proto %s ",
+			     rtnl_rtprot_n2a(nhm->nh_protocol, b1, sizeof(b1)));
+	}
+
+	if (tb[NHA_OIF])
+		print_rt_flags(fp, nhm->nh_flags);
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+	close_json_object();
+	fflush(fp);
+
+	return 0;
+}
+
+static int add_nh_group_attr(struct nlmsghdr *n, int maxlen, char *argv)
+{
+	struct nexthop_grp *grps;
+	int count = 0, i;
+	char *sep, *wsep;
+
+	if (*argv != '\0')
+		count = 1;
+
+	/* separator is '/' */
+	sep = strchr(argv, '/');
+	while (sep) {
+		count++;
+		sep = strchr(sep + 1, '/');
+	}
+
+	if (count == 0)
+		return -1;
+
+	grps = calloc(count, sizeof(*grps));
+	if (!grps)
+		return -1;
+
+	for (i = 0; i < count; ++i) {
+		sep = strchr(argv, '/');
+		if (sep)
+			*sep = '\0';
+
+		wsep = strchr(argv, ',');
+		if (wsep)
+			*wsep = '\0';
+
+		if (get_unsigned(&grps[i].id, argv, 0))
+			return -1;
+		if (wsep) {
+			unsigned int tmp;
+
+			wsep++;
+			if (get_unsigned(&tmp, wsep, 0))
+				return -1;
+			if (tmp > 254)
+				return -1;
+			grps[i].weight = tmp;
+		}
+
+		if (!sep)
+			break;
+
+		argv = sep + 1;
+	}
+
+	return addattr_l(n, maxlen, NHA_GROUP, grps, count * sizeof(*grps));
+}
+
+static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct nhmsg	nhm;
+		char		buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct nhmsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST | flags,
+		.n.nlmsg_type = cmd,
+		.nhm.nh_family = preferred_family,
+	};
+	__u32 nh_flags = 0;
+
+	while (argc > 0) {
+		if (!strcmp(*argv, "id")) {
+			__u32 id;
+
+			NEXT_ARG();
+			if (get_unsigned(&id, *argv, 0))
+				invarg("invalid id value", *argv);
+			addattr32(&req.n, sizeof(req), NHA_ID, id);
+		} else if (!strcmp(*argv, "dev")) {
+			int ifindex;
+
+			NEXT_ARG();
+			ifindex = ll_name_to_index(*argv);
+			if (!ifindex)
+				invarg("Device does not exist\n", *argv);
+			addattr32(&req.n, sizeof(req), NHA_OIF, ifindex);
+			if (req.nhm.nh_family == AF_UNSPEC)
+				req.nhm.nh_family = AF_INET;
+		} else if (strcmp(*argv, "via") == 0) {
+			inet_prefix addr;
+			int family;
+
+			NEXT_ARG();
+			family = read_family(*argv);
+			if (family == AF_UNSPEC)
+				family = req.nhm.nh_family;
+			else
+				NEXT_ARG();
+			get_addr(&addr, *argv, family);
+			if (req.nhm.nh_family == AF_UNSPEC)
+				req.nhm.nh_family = addr.family;
+			else if (req.nhm.nh_family != addr.family)
+				invarg("address family mismatch\n", *argv);
+			addattr_l(&req.n, sizeof(req), NHA_GATEWAY,
+				  &addr.data, addr.bytelen);
+		} else if (strcmp(*argv, "encap") == 0) {
+			char buf[1024];
+			struct rtattr *rta = (void *)buf;
+
+			rta->rta_type = NHA_ENCAP;
+			rta->rta_len = RTA_LENGTH(0);
+
+			lwt_parse_encap(rta, sizeof(buf), &argc, &argv,
+					NHA_ENCAP, NHA_ENCAP_TYPE);
+
+			if (rta->rta_len > RTA_LENGTH(0)) {
+				addraw_l(&req.n, 1024, RTA_DATA(rta),
+					 RTA_PAYLOAD(rta));
+			}
+		} else if (!strcmp(*argv, "blackhole")) {
+			addattr_l(&req.n, sizeof(req), NHA_BLACKHOLE, NULL, 0);
+			if (req.nhm.nh_family == AF_UNSPEC)
+				req.nhm.nh_family = AF_INET;
+		} else if (!strcmp(*argv, "onlink")) {
+			nh_flags |= RTNH_F_ONLINK;
+		} else if (!strcmp(*argv, "group")) {
+			NEXT_ARG();
+
+			if (add_nh_group_attr(&req.n, sizeof(req), *argv))
+				invarg("\"group\" value is invalid\n", *argv);
+		} else if (strcmp(*argv, "help") == 0) {
+			usage();
+		} else {
+			invarg("", *argv);
+		}
+		argc--; argv++;
+	}
+
+	req.nhm.nh_flags = nh_flags;
+
+	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+		return -2;
+
+	return 0;
+}
+
+static int ipnh_get_id(__u32 id)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct nhmsg	nhm;
+		char		buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct nhmsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type  = RTM_GETNEXTHOP,
+		.nhm.nh_family = preferred_family,
+	};
+	struct nlmsghdr *answer;
+
+	addattr32(&req.n, sizeof(req), NHA_ID, id);
+
+	if (rtnl_talk(&rth, &req.n, &answer) < 0)
+		return -2;
+
+	new_json_obj(json);
+
+	if (print_nexthop(answer, (void *)stdout) < 0) {
+		free(answer);
+		return -1;
+	}
+
+	delete_json_obj();
+	fflush(stdout);
+
+	free(answer);
+
+	return 0;
+}
+
+static int ipnh_list_flush(int argc, char **argv, int action)
+{
+	unsigned int all = (argc == 0);
+
+	while (argc > 0) {
+		if (!matches(*argv, "dev")) {
+			NEXT_ARG();
+			filter.ifindex = ll_name_to_index(*argv);
+			if (!filter.ifindex)
+				invarg("Device does not exist\n", *argv);
+		} else if (!matches(*argv, "groups")) {
+			filter.groups = 1;
+		} else if (!matches(*argv, "master")) {
+			NEXT_ARG();
+			filter.master = ll_name_to_index(*argv);
+			if (!filter.master)
+				invarg("Device does not exist\n", *argv);
+		} else if (matches(*argv, "vrf") == 0) {
+			NEXT_ARG();
+			if (!name_is_vrf(*argv))
+				invarg("Invalid VRF\n", *argv);
+			filter.master = ll_name_to_index(*argv);
+			if (!filter.master)
+				invarg("VRF does not exist\n", *argv);
+		} else if (!strcmp(*argv, "id")) {
+			__u32 id;
+
+			NEXT_ARG();
+			if (get_unsigned(&id, *argv, 0))
+				invarg("invalid id value", *argv);
+			return ipnh_get_id(id);
+		} else if (matches(*argv, "help") == 0) {
+			usage();
+		} else {
+			invarg("", *argv);
+		}
+		argc--; argv++;
+	}
+
+	if (action == IPNH_FLUSH)
+		return ipnh_flush(all);
+
+	if (rtnl_nexthopdump_req(&rth, preferred_family, nh_dump_filter) < 0) {
+		perror("Cannot send dump request");
+		return -2;
+	}
+
+	new_json_obj(json);
+
+	if (rtnl_dump_filter(&rth, print_nexthop, stdout) < 0) {
+		fprintf(stderr, "Dump terminated\n");
+		return -2;
+	}
+
+	delete_json_obj();
+	fflush(stdout);
+
+	return 0;
+}
+
+static int ipnh_get(int argc, char **argv)
+{
+	__u32 id = 0;
+
+	while (argc > 0) {
+		if (!strcmp(*argv, "id")) {
+			NEXT_ARG();
+			if (get_unsigned(&id, *argv, 0))
+				invarg("invalid id value", *argv);
+		} else  {
+			usage();
+		}
+		argc--; argv++;
+	}
+
+	if (!id) {
+		usage();
+		return -1;
+	}
+
+	return ipnh_get_id(id);
+}
+
+int do_ipnh(int argc, char **argv)
+{
+	if (argc < 1)
+		return ipnh_list_flush(0, NULL, IPNH_LIST);
+
+	if (!matches(*argv, "add"))
+		return ipnh_modify(RTM_NEWNEXTHOP, NLM_F_CREATE|NLM_F_EXCL,
+				   argc-1, argv+1);
+	if (!matches(*argv, "replace"))
+		return ipnh_modify(RTM_NEWNEXTHOP, NLM_F_CREATE|NLM_F_REPLACE,
+				   argc-1, argv+1);
+	if (!matches(*argv, "delete"))
+		return ipnh_modify(RTM_DELNEXTHOP, 0, argc-1, argv+1);
+
+	if (!matches(*argv, "list") ||
+	    !matches(*argv, "show") ||
+	    !matches(*argv, "lst"))
+		return ipnh_list_flush(argc-1, argv+1, IPNH_LIST);
+
+	if (!matches(*argv, "get"))
+		return ipnh_get(argc-1, argv+1);
+
+	if (!matches(*argv, "flush"))
+		return ipnh_list_flush(argc-1, argv+1, IPNH_FLUSH);
+
+	if (!matches(*argv, "help"))
+		usage();
+
+	fprintf(stderr,
+		"Command \"%s\" is unknown, try \"ip nexthop help\".\n", *argv);
+	exit(-1);
+}
-- 
2.11.0


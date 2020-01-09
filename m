Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7DB135CD0
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732448AbgAIPcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:32:24 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:37900 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732374AbgAIPcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:32:23 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: YOGpGf+tKt1gnjUv7HgqiQmWegdmGwXMG2WYSCzrZU2Gs312G+nHKOVLh+6qs3A7iF1LQHhORT
 R8zF1idjw63/InZGncXcHtvqATbBOHYa2S63u20MH2rpjWhWQ1jXIoHK96pHePQNaRintapHdg
 i7ynHQqQfV4R40gc4PjxkbZ3hQzNsMkTQpv4SRDAOu3pULG90Qv6aDj3+5tfu7VKo6w5S9lnot
 JniVpTG8pkehjTf9WzaWlh0sJFNyZMwoIZEKDH09AGQQ2YUmleT299oWWumwZaZVZx3NjaSMMw
 uJw=
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="60256312"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2020 08:32:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 Jan 2020 08:32:22 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Thu, 9 Jan 2020 08:32:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     <davem@davemloft.net>, <roopa@cumulusnetworks.com>,
        <nikolay@cumulusnetworks.com>, <jakub.kicinski@netronome.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <jeffrey.t.kirsher@intel.com>, <olteanv@gmail.com>,
        <anirudh.venkataramanan@intel.com>, <dsahern@gmail.com>,
        <jiri@mellanox.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC iproute2] bridge: Add suppport to configure MRP
Date:   Thu, 9 Jan 2020 16:31:32 +0100
Message-ID: <20200109153132.12256-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend br_netlink to be able to create/delete MRP instances. The current
configurations options for each instance are:
- set primary port
- set secondary port
- set MRP ring role (MRM or MRC)
- set MRP ring id.

To create a MRP instance on the bridge:
$ bridge mrp add dev br0 p_port eth0 s_port eth1 ring_role 2 ring_id 1

Where:
p_port, s_port: can be any port under the bridge
ring_role: can have the value 1(MRC - Media Redundancy Client) or
           2(MRM - Media Redundancy Manager). In a ring can be only one MRM.
ring_id: unique id for each MRP instance.

It is possible to create multiple instances. Each instance has to have it's own
ring_id and a port can't be part of multiple instances:
$ bridge mrp add dev br0 p_port eth2 s_port eth3 ring_role 1 ring_id 2

To see current MRP instances and their status:
$ bridge mrp show
dev br0 p_port eth2 s_port eth3 ring_role 1 ring_id 2 ring_state 3
dev br0 p_port eth0 s_port eth1 ring_role 2 ring_id 1 ring_state 4

Where:
p_port, s_port, ring_role, ring_id: represent the configuration values. It is
   possible for primary port to change the role with the secondary port.
   It depends on the states through which the node goes.
ring_state: depends on the ring_role. If mrp_ring_role is 1(MRC) then the values
   of mrp_ring_state can be: 0(AC_STAT1), 1(DE_IDLE), 2(PT), 3(DE), 4(PT_IDLE).
   If mrp_ring_role is 2(MRM) then the values of mrp_ring_state can be:
   0(AC_STAT1), 1(PRM_UP), 2(CHK_RO), 3(CHK_RC).

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 bridge/Makefile                |   2 +-
 bridge/br_common.h             |   1 +
 bridge/bridge.c                |   3 +-
 bridge/mrp.c                   | 252 +++++++++++++++++++++++++++++++++
 include/libnetlink.h           |   2 +
 include/uapi/linux/if_bridge.h |  25 ++++
 include/uapi/linux/rtnetlink.h |   7 +
 lib/libnetlink.c               |  16 +++
 8 files changed, 306 insertions(+), 2 deletions(-)
 create mode 100644 bridge/mrp.c

diff --git a/bridge/Makefile b/bridge/Makefile
index c6b7d08d..330b5a8c 100644
--- a/bridge/Makefile
+++ b/bridge/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-BROBJ = bridge.o fdb.o monitor.o link.o mdb.o vlan.o
+BROBJ = bridge.o fdb.o monitor.o link.o mdb.o vlan.o mrp.o
 
 include ../config.mk
 
diff --git a/bridge/br_common.h b/bridge/br_common.h
index b5798da3..b2639d18 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -13,6 +13,7 @@ int print_fdb(struct nlmsghdr *n, void *arg);
 
 int do_fdb(int argc, char **argv);
 int do_mdb(int argc, char **argv);
+int do_mrp(int argc, char **argv);
 int do_monitor(int argc, char **argv);
 int do_vlan(int argc, char **argv);
 int do_link(int argc, char **argv);
diff --git a/bridge/bridge.c b/bridge/bridge.c
index a50d9d59..ebbee013 100644
--- a/bridge/bridge.c
+++ b/bridge/bridge.c
@@ -37,7 +37,7 @@ static void usage(void)
 	fprintf(stderr,
 "Usage: bridge [ OPTIONS ] OBJECT { COMMAND | help }\n"
 "       bridge [ -force ] -batch filename\n"
-"where	OBJECT := { link | fdb | mdb | vlan | monitor }\n"
+"where	OBJECT := { link | fdb | mdb | mrp | vlan | monitor }\n"
 "	OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] |\n"
 "		     -o[neline] | -t[imestamp] | -n[etns] name |\n"
 "		     -c[ompressvlans] -color -p[retty] -j[son] }\n");
@@ -57,6 +57,7 @@ static const struct cmd {
 	{ "link",	do_link },
 	{ "fdb",	do_fdb },
 	{ "mdb",	do_mdb },
+	{ "mrp",	do_mrp },
 	{ "vlan",	do_vlan },
 	{ "monitor",	do_monitor },
 	{ "help",	do_help },
diff --git a/bridge/mrp.c b/bridge/mrp.c
new file mode 100644
index 00000000..8f6df19a
--- /dev/null
+++ b/bridge/mrp.c
@@ -0,0 +1,252 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Get mrp table with netlink
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <net/if.h>
+#include <netinet/in.h>
+#include <linux/if_bridge.h>
+#include <linux/if_ether.h>
+#include <string.h>
+#include <arpa/inet.h>
+
+#include "libnetlink.h"
+#include "br_common.h"
+#include "rt_names.h"
+#include "utils.h"
+#include "json_print.h"
+
+#ifndef MRPA_RTA
+#define MRPA_RTA(r) \
+	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct br_port_msg))))
+#endif
+
+static void usage(void)
+{
+	fprintf(stderr,
+		"Usage: bridge mrp { add | del } dev DEV p_port PORT s_port PORT ring_role ROLE ring_nr ID\n"
+		"       bridge mpr {show}\n");
+	exit(-1);
+}
+
+static void print_mrp_entry(FILE *f, int ifindex,
+			    struct nlmsghdr *n, struct rtattr **tb)
+{
+	const char *dev;
+
+	open_json_object(NULL);
+
+	dev = ll_index_to_name(ifindex);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "dev", "dev %s", dev);
+
+	if (tb[MRP_ATTR_P_IFINDEX]) {
+		dev = ll_index_to_name(rta_getattr_u32(tb[MRP_ATTR_P_IFINDEX]));
+		print_color_string(PRINT_ANY, COLOR_IFNAME, "p_port",
+				   " p_port %s", dev);
+	} else {
+		print_color_string(PRINT_ANY, COLOR_IFNAME, "p_port",
+				   " p_port %s", "*");
+	}
+
+	if (tb[MRP_ATTR_S_IFINDEX]) {
+		dev = ll_index_to_name(rta_getattr_u32(tb[MRP_ATTR_S_IFINDEX]));
+		print_color_string(PRINT_ANY, COLOR_IFNAME, "s_port",
+				   " s_port %s", dev);
+	} else {
+		print_color_string(PRINT_ANY, COLOR_IFNAME, "s_port",
+				   " s_port %s", "*");
+	}
+
+	if (tb[MRP_ATTR_RING_NR])
+		print_uint(PRINT_ANY, "ring_id", " ring_id %u",
+			   rta_getattr_u32(tb[MRP_ATTR_RING_NR]));
+	if (tb[MRP_ATTR_RING_ROLE])
+		print_uint(PRINT_ANY, "ring_role", " ring_role %u",
+			   rta_getattr_u32(tb[MRP_ATTR_RING_ROLE]));
+	if (tb[MRP_ATTR_RING_STATE])
+		print_uint(PRINT_ANY, "ring_state", " ring_state %u",
+			   rta_getattr_u32(tb[MRP_ATTR_RING_STATE]));
+
+	print_nl();
+	close_json_object();
+}
+
+static void print_mrp_entries(FILE *fp, struct nlmsghdr *n,
+			      int ifindex,  struct rtattr *attr)
+{
+	struct rtattr *etb[MRP_ATTR_MAX + 1];
+	int rem = RTA_PAYLOAD(attr);
+	struct rtattr *i;
+
+	for (i = RTA_DATA(attr); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
+		parse_rtattr(etb, MRP_ATTR_MAX, RTA_DATA(i), rem - 4);
+		print_mrp_entry(fp, ifindex, n, etb);
+	}
+}
+
+static int __parse_mrp_nlmsg(struct nlmsghdr *n, struct rtattr **tb)
+{
+	struct br_port_msg *r = NLMSG_DATA(n);
+	int len = n->nlmsg_len;
+
+	if (n->nlmsg_type != RTM_GETMRP &&
+	    n->nlmsg_type != RTM_NEWMRP &&
+	    n->nlmsg_type != RTM_DELMRP) {
+		fprintf(stderr,
+			"Not RTM_GETMRP, RTM_NEWMRP or RTM_DELMRP: %08x %08x %08x\n",
+			n->nlmsg_len, n->nlmsg_type, n->nlmsg_flags);
+
+		return 0;
+	}
+
+	len -= NLMSG_LENGTH(sizeof(*r));
+	if (len < 0) {
+		fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
+		return -1;
+	}
+
+	parse_rtattr(tb, MRPA_MAX, MRPA_RTA(r),
+		     n->nlmsg_len - NLMSG_LENGTH(sizeof(*r)));
+
+	return 1;
+}
+
+static int print_mrps(struct nlmsghdr *n, void *arg)
+{
+	struct br_port_msg *r = NLMSG_DATA(n);
+	struct rtattr *tb[MRPA_MAX+1];
+	FILE *fp = arg;
+	int ret;
+
+	ret = __parse_mrp_nlmsg(n, tb);
+	if (ret != 1)
+		return ret;
+
+	if (tb[MRPA_MRP])
+		print_mrp_entries(fp, n, r->ifindex, tb[MRPA_MRP]);
+
+	return 0;
+}
+
+static int mrp_show(int argc, char **argv)
+{
+	new_json_obj(json);
+	open_json_object(NULL);
+
+	/* get mrp entries */
+	if (rtnl_mrpdump_req(&rth, PF_BRIDGE) < 0) {
+		perror("Cannot send dump request");
+		return -1;
+	}
+
+	open_json_array(PRINT_JSON, "mrp");
+	if (rtnl_dump_filter(&rth, print_mrps, stdout) < 0) {
+		fprintf(stderr, "Dump terminated\n");
+		return -1;
+	}
+	close_json_array(PRINT_JSON, NULL);
+
+	close_json_object();
+	delete_json_obj();
+	fflush(stdout);
+
+	return 0;
+	return 0;
+}
+
+static int mrp_modify(int cmd, int flags, int argc, char **argv)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct br_port_msg	bpm;
+		char			buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct br_port_msg)),
+		.n.nlmsg_flags = NLM_F_REQUEST | flags,
+		.n.nlmsg_type = cmd,
+		.bpm.family = PF_BRIDGE,
+	};
+	char *dev = NULL, *p_port = NULL, *s_port = NULL;
+	uint8_t ring_role = 0;
+	uint32_t ring_id = 0, p_ifindex = 0, s_ifindex = 0;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			dev = *argv;
+		} else if (strcmp(*argv, "p_port") == 0) {
+			NEXT_ARG();
+			p_port = *argv;
+		} else if (strcmp(*argv, "s_port") == 0) {
+			NEXT_ARG();
+			s_port = *argv;
+		} else if (strcmp(*argv, "ring_role") == 0) {
+			NEXT_ARG();
+			ring_role = atoi(*argv);
+		} else if (strcmp(*argv, "ring_id") == 0) {
+			NEXT_ARG();
+			ring_id = atoi(*argv);
+		} else {
+			if (matches(*argv, "help") == 0)
+				usage();
+		}
+		argc--; argv++;
+	}
+
+	if (cmd == RTM_DELMRP && (dev == NULL || ring_id == 0)) {
+		fprintf(stderr, "Device and ring_id are required arguments for del. \n");
+		return -1;
+	}
+	if (cmd == RTM_NEWMRP &&
+	    (dev == NULL || p_port == NULL || s_port == NULL || ring_role == 0 || ring_id == 0)) {
+		fprintf(stderr, "Device, p_port, s_port, ring_role and ring_id are required arguments for add.\n");
+		return -1;
+	}
+
+	req.bpm.ifindex = ll_name_to_index(dev);
+	if (!req.bpm.ifindex)
+		return nodev(dev);
+
+	p_ifindex = ll_name_to_index(p_port);
+	if (!p_ifindex && cmd == RTM_NEWMRP)
+		return nodev(p_port);
+
+	s_ifindex = ll_name_to_index(s_port);
+	if (!s_ifindex && cmd == RTM_NEWMRP)
+		return nodev(p_port);
+
+	addattr32(&req.n, sizeof(req), MRP_ATTR_P_IFINDEX, p_ifindex);
+	addattr32(&req.n, sizeof(req), MRP_ATTR_S_IFINDEX, s_ifindex);
+	addattr8(&req.n, sizeof(req), MRP_ATTR_RING_ROLE, ring_role);
+	addattr32(&req.n, sizeof(req), MRP_ATTR_RING_NR, ring_id);
+
+	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+		return -1;
+
+	return 0;
+}
+
+int do_mrp(int argc, char **argv)
+{
+	ll_init_map(&rth);
+
+	if (argc > 0) {
+		if (matches(*argv, "add") == 0)
+			return mrp_modify(RTM_NEWMRP, NLM_F_CREATE|NLM_F_EXCL, argc-1, argv+1);
+		if (matches(*argv, "delete") == 0)
+			return mrp_modify(RTM_DELMRP, 0, argc-1, argv+1);
+		if (matches(*argv, "show") == 0)
+			return mrp_show(argc-1, argv+1);
+		if (matches(*argv, "help") == 0)
+			usage();
+	} else
+		return mrp_show(0, NULL);
+
+	fprintf(stderr, "Command \"%s\" is unknown, try \"bridge mrp help\".\n", *argv);
+	exit(-1);
+}
diff --git a/include/libnetlink.h b/include/libnetlink.h
index 8ebdc6d3..4e065164 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -69,6 +69,8 @@ int rtnl_neightbldump_req(struct rtnl_handle *rth, int family)
 	__attribute__((warn_unused_result));
 int rtnl_mdbdump_req(struct rtnl_handle *rth, int family)
 	__attribute__((warn_unused_result));
+int rtnl_mrpdump_req(struct rtnl_handle *rth, int family)
+	__attribute__((warn_unused_result));
 int rtnl_netconfdump_req(struct rtnl_handle *rth, int family)
 	__attribute__((warn_unused_result));
 
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 31fc51bd..0220fe5f 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -256,6 +256,31 @@ enum {
 };
 #define MDBA_SET_ENTRY_MAX (__MDBA_SET_ENTRY_MAX - 1)
 
+enum {
+	MRPA_UNSPEC,
+	MRPA_MRP,
+	__MRPA_MAX,
+};
+#define MRPA_MAX (__MRPA_MAX - 1)
+
+enum {
+	MRPA_MRP_UNSPEC,
+	MRPA_MRP_ENTRY,
+	__MRPA_MRP_MAX,
+};
+#define MRPA_MRP_MAX (__MRPA_MRP_MAX - 1)
+
+enum {
+	MRP_ATTR_UNSPEC,
+	MRP_ATTR_P_IFINDEX,
+	MRP_ATTR_S_IFINDEX,
+	MRP_ATTR_RING_ROLE,
+	MRP_ATTR_RING_NR,
+	MRP_ATTR_RING_STATE,
+	__MRP_ATTR_MAX,
+};
+#define MRP_ATTR_MAX (__MRP_ATTR_MAX - 1)
+
 /* Embedded inside LINK_XSTATS_TYPE_BRIDGE */
 enum {
 	BRIDGE_XSTATS_UNSPEC,
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 4b93791c..8335360f 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -171,6 +171,13 @@ enum {
 	RTM_GETLINKPROP,
 #define RTM_GETLINKPROP	RTM_GETLINKPROP
 
+	RTM_NEWMRP = 112,
+#define RTM_NEWMRP	RTM_NEWMRP
+	RTM_DELMRP,
+#define RTM_DELMRP	RTM_DELMRP
+	RTM_GETMRP,
+#define RTM_GETMRP	RTM_GETMRP
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index e02d6294..f1f84733 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -421,6 +421,22 @@ int rtnl_mdbdump_req(struct rtnl_handle *rth, int family)
 	return send(rth->fd, &req, sizeof(req), 0);
 }
 
+int rtnl_mrpdump_req(struct rtnl_handle *rth, int family)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct br_port_msg bpm;
+	} req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct br_port_msg)),
+		.nlh.nlmsg_type = RTM_GETMRP,
+		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
+		.nlh.nlmsg_seq = rth->dump = ++rth->seq,
+		.bpm.family = family,
+	};
+
+	return send(rth->fd, &req, sizeof(req), 0);
+}
+
 int rtnl_netconfdump_req(struct rtnl_handle *rth, int family)
 {
 	struct {
-- 
2.17.1


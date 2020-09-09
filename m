Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06002638E9
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgIIWST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgIIWSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 18:18:17 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5A1C20C09;
        Wed,  9 Sep 2020 22:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599689896;
        bh=8OQlY1Ifia55a0X3+T3pSVFnvt9bQTDX9fLpaUGcp9g=;
        h=From:To:Cc:Subject:Date:From;
        b=FKPKY0g4XErHGfrKhPT/KNH7xAdSq+l/85iSuQyf60mSgdIp/Ato+zPH2Xg0m3XSL
         6FBo2kzO7MzXzsArnellQH0aHKPPUAquUGF5bY5dlmXbD4wCkLlSR3peLFDgOXPNCk
         CxZh5TpnfgtsebSnGxrlSznpeBWBOH3VQjN3SVbE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool] tunnels: implement new --show-tunnels command
Date:   Wed,  9 Sep 2020 15:18:11 -0700
Message-Id: <20200909221811.410014-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the new show-tunnels command. Support dump.

 # ethtool --show-tunnels \*
Tunnel information for eth0:
  UDP port table 0:
    Size: 4
    Types: vxlan
    No entries
  UDP port table 1:
    Size: 4
    Types: geneve, vxlan-gpe
    Entries (2):
        port 1230, vxlan-gpe
        port 6081, geneve

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Makefile.am       |   2 +-
 ethtool.8.in      |   9 ++
 ethtool.c         |   5 +
 netlink/extapi.h  |   2 +
 netlink/tunnels.c | 236 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 253 insertions(+), 1 deletion(-)
 create mode 100644 netlink/tunnels.c

diff --git a/Makefile.am b/Makefile.am
index aca0ad7bc773..0e237d070d4b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -37,7 +37,7 @@ ethtool_SOURCES += \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
 		  netlink/eee.c netlink/tsinfo.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
-		  netlink/desc-rtnl.c netlink/cable_test.c \
+		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/ethtool.8.in b/ethtool.8.in
index a50a4769895c..42c4767db33e 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -459,6 +459,9 @@ ethtool \- query or control network driver and hardware settings
 .BN last N
 .BN step N
 .BN pair N
+.HP
+.B ethtool \-\-show\-tunnels
+.I devname
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -1383,6 +1386,12 @@ shown.
 If a device name is used as argument, only notification for this device are
 shown. Default is to show notifications for all devices.
 .RE
+.TP
+.B \-\-show\-tunnels
+Show tunnel-related device capabilities and state.
+List UDP ports kernel has programmed the device to parse as VxLAN,
+or GENEVE tunnels.
+.RE
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
diff --git a/ethtool.c b/ethtool.c
index 606af3e6b48f..23ecfcfd069c 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5919,6 +5919,11 @@ static const struct option args[] = {
 			  "		[ step N ]\n"
 			  "		[ pair N ]\n"
 	},
+	{
+		.opts	= "--show-tunnels",
+		.nlfunc	= nl_gtunnels,
+		.help	= "Show NIC tunnel offload information",
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/extapi.h b/netlink/extapi.h
index a35d5f2c0b26..9285e2325dfd 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -37,6 +37,7 @@ int nl_seee(struct cmd_context *ctx);
 int nl_tsinfo(struct cmd_context *ctx);
 int nl_cable_test(struct cmd_context *ctx);
 int nl_cable_test_tdr(struct cmd_context *ctx);
+int nl_gtunnels(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -84,6 +85,7 @@ static inline void nl_monitor_usage(void)
 #define nl_tsinfo		NULL
 #define nl_cable_test		NULL
 #define nl_cable_test_tdr	NULL
+#define nl_gtunnels		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/tunnels.c b/netlink/tunnels.c
new file mode 100644
index 000000000000..71daa267dce8
--- /dev/null
+++ b/netlink/tunnels.c
@@ -0,0 +1,236 @@
+/*
+ * tunnel.c - device tunnel information
+ *
+ * Implementation of "ethtool --show-tunnels <dev>"
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+#include <arpa/inet.h>
+
+#include "../common.h"
+#include "../internal.h"
+
+#include "bitset.h"
+#include "netlink.h"
+#include "strset.h"
+
+/* TUNNEL_INFO_GET */
+
+static int
+tunnel_info_strings_load(struct nl_context *nlctx,
+			 const struct stringset **strings)
+{
+	int ret;
+
+	if (*strings)
+		return 0;
+	ret = netlink_init_ethnl2_socket(nlctx);
+	if (ret < 0)
+		return ret;
+	*strings = global_stringset(ETH_SS_UDP_TUNNEL_TYPES,
+				    nlctx->ethnl2_socket);
+	return 0;
+}
+
+static int
+tunnel_info_dump_udp_entry(struct nl_context *nlctx, const struct nlattr *entry,
+			   const struct stringset **strings)
+{
+	const struct nlattr *entry_tb[ETHTOOL_A_TUNNEL_UDP_ENTRY_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(entry_tb);
+	const struct nlattr *attr;
+	unsigned int port, type;
+	int ret;
+
+	if (tunnel_info_strings_load(nlctx, strings))
+		return 1;
+
+	ret = mnl_attr_parse_nested(entry, attr_cb, &entry_tb_info);
+	if (ret < 0) {
+		fprintf(stderr, "malformed netlink message (udp entry)\n");
+		return 1;
+	}
+
+	attr = entry_tb[ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT];
+	if (!attr || mnl_attr_validate(attr, MNL_TYPE_U16) < 0) {
+		fprintf(stderr, "malformed netlink message (port)\n");
+		return 1;
+	}
+	port = htons(mnl_attr_get_u16(attr));
+
+	attr = entry_tb[ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE];
+	if (!attr || mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+		fprintf(stderr, "malformed netlink message (tunnel type)\n");
+		return 1;
+	}
+	type = mnl_attr_get_u32(attr);
+
+	printf("        port %d, %s\n", port, get_string(*strings, type));
+
+	return 0;
+}
+
+static void tunnel_info_dump_cb(unsigned int idx, const char *name, bool val,
+				void *data)
+{
+	bool *first = data;
+
+	if (!val)
+		return;
+
+	if (!*first)
+		putchar(',');
+	*first = false;
+
+	if (name)
+		printf(" %s", name);
+	else
+		printf(" bit%u", idx);
+}
+
+static int
+tunnel_info_dump_list(struct nl_context *nlctx, const struct nlattr *attr,
+		      const struct stringset **strings)
+{
+	bool first = true;
+	int ret;
+
+	if (bitset_is_empty(attr, false, &ret) || ret) {
+		if (ret)
+			return 1;
+
+		printf("    Types: none (static entries)\n");
+		return 0;
+	}
+
+	if (bitset_is_compact(attr) &&
+	    tunnel_info_strings_load(nlctx, strings))
+		return 1;
+
+	printf("    Types:");
+	ret = walk_bitset(attr, *strings, tunnel_info_dump_cb, &first);
+	putchar('\n');
+	return ret;
+}
+
+static int
+tunnel_info_dump_udp_table(const struct nlattr *table, struct nl_context *nlctx,
+			   const struct stringset **strings)
+{
+	const struct nlattr *table_tb[ETHTOOL_A_TUNNEL_UDP_TABLE_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(table_tb);
+	const struct nlattr *attr;
+	int i, ret;
+
+	ret = mnl_attr_parse_nested(table, attr_cb, &table_tb_info);
+	if (ret < 0) {
+		fprintf(stderr, "malformed netlink message (udp table)\n");
+		return 1;
+	}
+
+	attr = table_tb[ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE];
+	if (!attr || mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+		fprintf(stderr, "malformed netlink message (table size)\n");
+		return 1;
+	}
+	printf("    Size: %d\n", mnl_attr_get_u32(attr));
+
+	attr = table_tb[ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES];
+	if (!attr || tunnel_info_dump_list(nlctx, attr, strings)) {
+		fprintf(stderr, "malformed netlink message (types)\n");
+		return 1;
+	}
+
+	if (!table_tb[ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY]) {
+		printf("    No entries\n");
+		return 0;
+	}
+
+	i = 0;
+	mnl_attr_for_each_nested(attr, table) {
+		if (mnl_attr_get_type(attr) == ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY)
+			i++;
+	}
+
+	printf("    Entries (%d):\n", i++);
+	mnl_attr_for_each_nested(attr, table) {
+		if (mnl_attr_get_type(attr) == ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY)
+			if (tunnel_info_dump_udp_entry(nlctx, attr, strings))
+				return 1;
+	}
+
+	return 0;
+}
+
+static int
+tunnel_info_dump_udp(const struct nlattr *udp_ports, struct nl_context *nlctx)
+{
+	const struct stringset *strings = NULL;
+	const struct nlattr *table;
+	int i, err;
+
+	i = 0;
+	mnl_attr_for_each_nested(table, udp_ports) {
+		if (mnl_attr_get_type(table) != ETHTOOL_A_TUNNEL_UDP_TABLE)
+			continue;
+
+		printf("  UDP port table %d: \n", i++);
+		err = tunnel_info_dump_udp_table(table, nlctx, &strings);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int tunnel_info_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	const struct nlattr *udp_ports;
+	struct nl_context *nlctx = data;
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_TUNNEL_INFO_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	printf("Tunnel information for %s:\n", nlctx->devname);
+
+	udp_ports = tb[ETHTOOL_A_TUNNEL_INFO_UDP_PORTS];
+	if (udp_ports)
+		if (tunnel_info_dump_udp(udp_ports, nlctx))
+			return err_ret;
+
+	return MNL_CB_OK;
+}
+
+int nl_gtunnels(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_TUNNEL_INFO_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_TUNNEL_INFO_GET,
+				      ETHTOOL_A_TUNNEL_INFO_HEADER, 0);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, tunnel_info_reply_cb);
+}
-- 
2.26.2


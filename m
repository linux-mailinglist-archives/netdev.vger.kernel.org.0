Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C7620A5BB
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406418AbgFYTZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:25:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403792AbgFYTZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 15:25:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joXUX-002FNz-1V; Thu, 25 Jun 2020 21:24:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v3 1/6] Add cable test support
Date:   Thu, 25 Jun 2020 21:24:41 +0200
Message-Id: <20200625192446.535754-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625192446.535754-1-andrew@lunn.ch>
References: <20200625192446.535754-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for starting a cable test, and report the results.

This code does not follow the usual patterns because of the way the
kernel reports the results of the cable test. It can take a number of
seconds for cable testing to occur. So the action request messages is
immediately acknowledges, and the test is then performed asynchronous.
Once the test has completed, the results are returned as a
notification.

This means the command starts as usual. It then monitors multicast
messages until it receives the results.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Makefile.am          |   2 +-
 ethtool.c            |   5 +
 netlink/cable_test.c | 257 +++++++++++++++++++++++++++++++++++++++++++
 netlink/extapi.h     |   2 +
 netlink/monitor.c    |   4 +
 netlink/netlink.h    |   3 +-
 6 files changed, 271 insertions(+), 2 deletions(-)
 create mode 100644 netlink/cable_test.c

diff --git a/Makefile.am b/Makefile.am
index 63c3fb3..a818cf8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -35,7 +35,7 @@ ethtool_SOURCES += \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
 		  netlink/eee.c netlink/tsinfo.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
-		  netlink/desc-rtnl.c \
+		  netlink/desc-rtnl.c netlink/cable_test.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/ethtool.c b/ethtool.c
index 8522d6b..a616943 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5482,6 +5482,11 @@ static const struct option args[] = {
 		.xhelp	= "The supported sub commands include --show-coalesce, --coalesce"
 			  "             [queue_mask %x] SUB_COMMAND\n",
 	},
+	{
+		.opts	= "--cable-test",
+		.nlfunc	= nl_cable_test,
+		.help	= "Perform a cable test",
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/cable_test.c b/netlink/cable_test.c
new file mode 100644
index 0000000..b77346e
--- /dev/null
+++ b/netlink/cable_test.c
@@ -0,0 +1,257 @@
+/*
+ * cable_test.c - netlink implementation of cable test command
+ *
+ * Implementation of ethtool <dev> --cable-test
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+
+static bool breakout;
+
+static int nl_get_cable_test_result(const struct nlattr *nest, uint8_t *pair,
+				    uint16_t *code)
+{
+	const struct nlattr *tb[ETHTOOL_A_CABLE_RESULT_MAX+1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0 ||
+	    !tb[ETHTOOL_A_CABLE_RESULT_PAIR] ||
+	    !tb[ETHTOOL_A_CABLE_RESULT_CODE])
+		return -EFAULT;
+
+	*pair = mnl_attr_get_u8(tb[ETHTOOL_A_CABLE_RESULT_PAIR]);
+	*code = mnl_attr_get_u8(tb[ETHTOOL_A_CABLE_RESULT_CODE]);
+
+	return 0;
+}
+
+static int nl_get_cable_test_fault_length(const struct nlattr *nest,
+					  uint8_t *pair, unsigned int *cm)
+{
+	const struct nlattr *tb[ETHTOOL_A_CABLE_FAULT_LENGTH_MAX+1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0 ||
+	    !tb[ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR] ||
+	    !tb[ETHTOOL_A_CABLE_FAULT_LENGTH_CM])
+		return -EFAULT;
+
+	*pair = mnl_attr_get_u8(tb[ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR]);
+	*cm = mnl_attr_get_u32(tb[ETHTOOL_A_CABLE_FAULT_LENGTH_CM]);
+
+	return 0;
+}
+
+static char *nl_code2txt(uint16_t code)
+{
+	switch(code) {
+	case ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC:
+	default:
+		return "Unknown";
+	case ETHTOOL_A_CABLE_RESULT_CODE_OK:
+		return "OK";
+	case ETHTOOL_A_CABLE_RESULT_CODE_OPEN:
+		return "Open Circuit";
+	case ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT:
+		return "Short within Pair";
+	case ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT:
+		return "Short to another pair";
+	}
+}
+
+static char *nl_pair2txt(uint8_t pair)
+{
+	switch (pair) {
+	case ETHTOOL_A_CABLE_PAIR_A:
+		return "Pair A";
+	case ETHTOOL_A_CABLE_PAIR_B:
+		return "Pair B";
+	case ETHTOOL_A_CABLE_PAIR_C:
+		return "Pair C";
+	case ETHTOOL_A_CABLE_PAIR_D:
+		return "Pair D";
+	default:
+		return "Unexpected pair";
+	}
+}
+
+static int nl_cable_test_ntf_attr(struct nlattr *evattr)
+{
+	unsigned int cm;
+	uint16_t code;
+	uint8_t pair;
+	int ret;
+
+	switch (mnl_attr_get_type(evattr)) {
+	case ETHTOOL_A_CABLE_NEST_RESULT:
+		ret = nl_get_cable_test_result(evattr, &pair, &code);
+		if (ret < 0)
+			return ret;
+
+		printf("Pair: %s, result: %s\n", nl_pair2txt(pair),
+		       nl_code2txt(code));
+		break;
+
+	case ETHTOOL_A_CABLE_NEST_FAULT_LENGTH:
+		ret = nl_get_cable_test_fault_length(evattr, &pair, &cm);
+		if (ret < 0)
+			return ret;
+
+		printf("Pair: %s, fault length: %0.2fm\n",
+		       nl_pair2txt(pair), (float)cm / 100);
+		break;
+	}
+	return 0;
+}
+
+static void cable_test_ntf_nest(const struct nlattr *nest)
+{
+	struct nlattr *pos;
+	int ret;
+
+	mnl_attr_for_each_nested(pos, nest) {
+		ret = nl_cable_test_ntf_attr(pos);
+		if (ret < 0)
+			return;
+	}
+}
+
+/* Returns MNL_CB_STOP when the test is complete. Used when executing
+   a test, but not suitable for monitor. */
+static int cable_test_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_CABLE_TEST_NTF_MAX + 1] = {};
+	u8 status = ETHTOOL_A_CABLE_TEST_NTF_STATUS_UNSPEC;
+	struct nl_context *nlctx = data;
+	DECLARE_ATTR_TB_INFO(tb);
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_CABLE_TEST_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (tb[ETHTOOL_A_CABLE_TEST_NTF_STATUS])
+		status = mnl_attr_get_u8(tb[ETHTOOL_A_CABLE_TEST_NTF_STATUS]);
+
+	switch (status) {
+	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED:
+		printf("Cable test started for device %s.\n",
+		       nlctx->devname);
+		break;
+	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED:
+		printf("Cable test completed for device %s.\n",
+		       nlctx->devname);
+		break;
+	default:
+		break;
+	}
+
+	if (tb[ETHTOOL_A_CABLE_TEST_NTF_NEST])
+		cable_test_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_NTF_NEST]);
+
+	if (status == ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED) {
+		breakout = true;
+		return MNL_CB_STOP;
+	}
+
+	return MNL_CB_OK;
+}
+
+/* Wrapper around cable_test_ntf_stop_cb() which does not return STOP,
+ * used for monitor */
+int cable_test_ntf_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	int status = cable_test_ntf_stop_cb(nlhdr, data);
+
+	if (status == MNL_CB_STOP)
+		status = MNL_CB_OK;
+
+	return status;
+}
+
+static int nl_cable_test_results_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct genlmsghdr *ghdr = (const struct genlmsghdr *)(nlhdr + 1);
+
+	if (ghdr->cmd != ETHTOOL_MSG_CABLE_TEST_NTF) {
+		return MNL_CB_OK;
+	}
+
+	return cable_test_ntf_stop_cb(nlhdr, data);
+}
+
+/* Receive the broadcasted messages until we get the cable test
+ * results
+ */
+static int nl_cable_test_process_results(struct cmd_context *ctx)
+{
+        struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int err;
+
+        nlctx->is_monitor = true;
+        nlsk->port = 0;
+	nlsk->seq = 0;
+
+	breakout = false;
+
+	while (!breakout) {
+		err = nlsock_process_reply(nlsk, nl_cable_test_results_cb,
+					   nlctx);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+int nl_cable_test(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+        uint32_t grpid = nlctx->ethnl_mongrp;
+	int ret;
+
+	/* Join the multicast group so we can receive the results in a
+	 * race free way.
+	 */
+        if (!grpid) {
+                fprintf(stderr, "multicast group 'monitor' not found\n");
+                return -EOPNOTSUPP;
+        }
+
+        ret = mnl_socket_setsockopt(nlsk->sk, NETLINK_ADD_MEMBERSHIP,
+                                    &grpid, sizeof(grpid));
+        if (ret < 0)
+                return ret;
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_CABLE_TEST_ACT,
+				      ETHTOOL_A_CABLE_TEST_HEADER, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		fprintf(stderr, "Cannot start cable test\n");
+	else
+		ret = nl_cable_test_process_results(ctx);
+	return ret;
+}
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 1b39ed9..a2293c1 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -35,6 +35,7 @@ int nl_spause(struct cmd_context *ctx);
 int nl_geee(struct cmd_context *ctx);
 int nl_seee(struct cmd_context *ctx);
 int nl_tsinfo(struct cmd_context *ctx);
+int nl_cable_test(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -74,6 +75,7 @@ static inline void nl_monitor_usage(void)
 #define nl_geee			NULL
 #define nl_seee			NULL
 #define nl_tsinfo		NULL
+#define nl_cable_test		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/monitor.c b/netlink/monitor.c
index 18d4efd..1af11ee 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -59,6 +59,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_EEE_NTF,
 		.cb	= eee_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_CABLE_TEST_NTF,
+		.cb	= cable_test_ntf_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index fe53fd0..2a2b60e 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -78,6 +78,8 @@ int channels_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int eee_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int cable_test_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int cable_test_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
@@ -108,7 +110,6 @@ static inline void show_bool(const struct nlattr *attr, const char *label)
 }
 
 /* misc */
-
 static inline void copy_devname(char *dst, const char *src)
 {
 	strncpy(dst, src, ALTIFNAMSIZ);
-- 
2.27.0


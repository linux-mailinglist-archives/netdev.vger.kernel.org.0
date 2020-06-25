Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBAA20A5BA
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406399AbgFYTZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:25:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403780AbgFYTZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 15:25:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joXUX-002FO2-36; Thu, 25 Jun 2020 21:24:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v3 2/6] Add cable test TDR support
Date:   Thu, 25 Jun 2020 21:24:42 +0200
Message-Id: <20200625192446.535754-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625192446.535754-1-andrew@lunn.ch>
References: <20200625192446.535754-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for accessing the cable test time domain reflectromatry
data. Add a new command --cable-test-tdr, and support for dumping the
data which is returned.

signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 ethtool.c            |   8 ++
 netlink/cable_test.c | 289 +++++++++++++++++++++++++++++++++++++++++++
 netlink/extapi.h     |   2 +
 netlink/monitor.c    |   4 +
 netlink/netlink.h    |   2 +
 netlink/parser.c     |  41 ++++++
 netlink/parser.h     |   4 +
 7 files changed, 350 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index a616943..a6bb9ac 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5487,6 +5487,14 @@ static const struct option args[] = {
 		.nlfunc	= nl_cable_test,
 		.help	= "Perform a cable test",
 	},
+	{
+		.opts	= "--cable-test-tdr",
+		.nlfunc	= nl_cable_test_tdr,
+		.help	= "Print cable test time domain reflectrometery data",
+		.xhelp	= "		[ first N ]\n"
+			  "		[ last N ]\n"
+			  "		[ step N ]\n"
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/cable_test.c b/netlink/cable_test.c
index b77346e..1b9ae9c 100644
--- a/netlink/cable_test.c
+++ b/netlink/cable_test.c
@@ -11,6 +11,7 @@
 #include "../internal.h"
 #include "../common.h"
 #include "netlink.h"
+#include "parser.h"
 
 static bool breakout;
 
@@ -255,3 +256,291 @@ int nl_cable_test(struct cmd_context *ctx)
 		ret = nl_cable_test_process_results(ctx);
 	return ret;
 }
+
+static int nl_get_cable_test_tdr_amplitude(const struct nlattr *nest,
+					   uint8_t *pair, int16_t *mV)
+{
+	const struct nlattr *tb[ETHTOOL_A_CABLE_AMPLITUDE_MAX+1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	uint16_t mV_unsigned;
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0 ||
+	    !tb[ETHTOOL_A_CABLE_AMPLITUDE_PAIR] ||
+	    !tb[ETHTOOL_A_CABLE_AMPLITUDE_mV])
+		return -EFAULT;
+
+	*pair = mnl_attr_get_u8(tb[ETHTOOL_A_CABLE_AMPLITUDE_PAIR]);
+	mV_unsigned = mnl_attr_get_u16(tb[ETHTOOL_A_CABLE_AMPLITUDE_mV]);
+	*mV = (int16_t)(mV_unsigned);
+
+	return 0;
+}
+
+static int nl_get_cable_test_tdr_pulse(const struct nlattr *nest, uint16_t *mV)
+{
+	const struct nlattr *tb[ETHTOOL_A_CABLE_PULSE_MAX+1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0 ||
+	    !tb[ETHTOOL_A_CABLE_PULSE_mV])
+		return -EFAULT;
+
+	*mV = mnl_attr_get_u16(tb[ETHTOOL_A_CABLE_PULSE_mV]);
+
+	return 0;
+}
+
+static int nl_get_cable_test_tdr_step(const struct nlattr *nest,
+				      uint32_t *first, uint32_t *last,
+				      uint32_t *step)
+{
+	const struct nlattr *tb[ETHTOOL_A_CABLE_STEP_MAX+1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0 ||
+	    !tb[ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE] ||
+	    !tb[ETHTOOL_A_CABLE_STEP_LAST_DISTANCE] ||
+	    !tb[ETHTOOL_A_CABLE_STEP_STEP_DISTANCE])
+		return -EFAULT;
+
+	*first = mnl_attr_get_u32(tb[ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE]);
+	*last = mnl_attr_get_u32(tb[ETHTOOL_A_CABLE_STEP_LAST_DISTANCE]);
+	*step = mnl_attr_get_u32(tb[ETHTOOL_A_CABLE_STEP_STEP_DISTANCE]);
+
+	return 0;
+}
+
+static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
+{
+	uint32_t first, last, step;
+	uint8_t pair;
+	int ret;
+
+	switch (mnl_attr_get_type(evattr)) {
+	case ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE: {
+		int16_t mV;
+
+		ret = nl_get_cable_test_tdr_amplitude(
+			evattr, &pair, &mV);
+		if (ret < 0)
+			return ret;
+
+		printf("Pair: %s, amplitude %4d\n", nl_pair2txt(pair), mV);
+		break;
+	}
+	case ETHTOOL_A_CABLE_TDR_NEST_PULSE: {
+		uint16_t mV;
+
+		ret = nl_get_cable_test_tdr_pulse(evattr, &mV);
+		if (ret < 0)
+			return ret;
+
+		printf("TDR pulse %dmV\n", mV);
+		break;
+	}
+	case ETHTOOL_A_CABLE_TDR_NEST_STEP:
+		ret = nl_get_cable_test_tdr_step(evattr, &first, &last, &step);
+		if (ret < 0)
+			return ret;
+
+		printf("Step configuration, %.2f-%.2f meters in %.2fm steps\n",
+		       (float)first / 100, (float)last /  100,
+		       (float)step /  100);
+		break;
+	}
+	return 0;
+}
+
+static void cable_test_tdr_ntf_nest(const struct nlattr *nest)
+{
+	struct nlattr *pos;
+	int ret;
+
+	mnl_attr_for_each_nested(pos, nest) {
+		ret = nl_cable_test_tdr_ntf_attr(pos);
+		if (ret < 0)
+			return;
+	}
+}
+
+/* Returns MNL_CB_STOP when the test is complete. Used when executing
+   a test, but not suitable for monitor. */
+int cable_test_tdr_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_MAX + 1] = {};
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
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_CABLE_TEST_TDR_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (tb[ETHTOOL_A_CABLE_TEST_NTF_STATUS])
+		status = mnl_attr_get_u8(tb[ETHTOOL_A_CABLE_TEST_NTF_STATUS]);
+
+	switch (status) {
+	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED:
+		printf("Cable test TDR started for device %s.\n",
+		       nlctx->devname);
+		break;
+	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED:
+		printf("Cable test TDR completed for device %s.\n",
+		       nlctx->devname);
+		break;
+	default:
+		break;
+	}
+
+	if (tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST])
+		cable_test_tdr_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST]);
+
+	if (status == ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED) {
+		breakout = true;
+		return MNL_CB_STOP;
+	}
+
+	return MNL_CB_OK;
+}
+
+/* Wrapper around cable_test_tdr_ntf_stop_cb() which does not return
+ * STOP, used for monitor */
+int cable_test_tdr_ntf_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	int status = cable_test_tdr_ntf_stop_cb(nlhdr, data);
+
+	if (status == MNL_CB_STOP)
+		status = MNL_CB_OK;
+
+	return status;
+}
+
+static int nl_cable_test_tdr_results_cb(const struct nlmsghdr *nlhdr,
+					void *data)
+{
+	const struct genlmsghdr *ghdr = (const struct genlmsghdr *)(nlhdr + 1);
+
+	if (ghdr->cmd != ETHTOOL_MSG_CABLE_TEST_TDR_NTF) {
+		return MNL_CB_OK;
+	}
+
+	cable_test_tdr_ntf_cb(nlhdr, data);
+
+	return MNL_CB_STOP;
+}
+
+/* Receive the broadcasted messages until we get the cable test
+ * results
+ */
+static int nl_cable_test_tdr_process_results(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int err;
+
+	nlctx->is_monitor = true;
+	nlsk->port = 0;
+	nlsk->seq = 0;
+
+	breakout = false;
+
+	while (!breakout) {
+		err = nlsock_process_reply(nlsk, nl_cable_test_tdr_results_cb,
+					   nlctx);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static const struct param_parser tdr_params[] = {
+	{
+		.arg		= "first",
+		.type		= ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST,
+		.group		= ETHTOOL_A_CABLE_TEST_TDR_CFG,
+		.handler	= nl_parse_direct_m2cm,
+	},
+	{
+		.arg		= "last",
+		.type		= ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST,
+		.group		= ETHTOOL_A_CABLE_TEST_TDR_CFG,
+		.handler	= nl_parse_direct_m2cm,
+	},
+	{
+		.arg		= "step",
+		.type		= ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP,
+		.group		= ETHTOOL_A_CABLE_TEST_TDR_CFG,
+		.handler	= nl_parse_direct_m2cm,
+	},
+	{
+		.arg		= "pair",
+		.type		= ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR,
+		.group		= ETHTOOL_A_CABLE_TEST_TDR_CFG,
+		.handler	= nl_parse_direct_u8,
+	},
+	{}
+};
+
+int nl_cable_test_tdr(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	uint32_t grpid = nlctx->ethnl_mongrp;
+	struct nl_msg_buff *msgbuff;
+	int ret;
+
+	nlctx->cmd = "--cable-test-tdr";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	msgbuff = &nlsk->msgbuff;
+
+	/* Join the multicast group so we can receive the results in a
+	 * race free way.
+	 */
+	if (!grpid) {
+		fprintf(stderr, "multicast group 'monitor' not found\n");
+		return -EOPNOTSUPP;
+	}
+
+	ret = mnl_socket_setsockopt(nlsk->sk, NETLINK_ADD_MEMBERSHIP,
+				    &grpid, sizeof(grpid));
+	if (ret < 0)
+		return ret;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_CABLE_TEST_TDR_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, tdr_params, NULL, PARSER_GROUP_NEST);
+	if (ret < 0)
+		return ret;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		fprintf(stderr, "Cannot start cable test TDR\n");
+	else
+		ret = nl_cable_test_tdr_process_results(ctx);
+	return ret;
+}
diff --git a/netlink/extapi.h b/netlink/extapi.h
index a2293c1..c5bfde9 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -36,6 +36,7 @@ int nl_geee(struct cmd_context *ctx);
 int nl_seee(struct cmd_context *ctx);
 int nl_tsinfo(struct cmd_context *ctx);
 int nl_cable_test(struct cmd_context *ctx);
+int nl_cable_test_tdr(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -76,6 +77,7 @@ static inline void nl_monitor_usage(void)
 #define nl_seee			NULL
 #define nl_tsinfo		NULL
 #define nl_cable_test		NULL
+#define nl_cable_test_tdr	NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/monitor.c b/netlink/monitor.c
index 1af11ee..280fd0b 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -63,6 +63,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_CABLE_TEST_NTF,
 		.cb	= cable_test_ntf_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
+		.cb	= cable_test_tdr_ntf_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 2a2b60e..d330c21 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -80,6 +80,8 @@ int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int eee_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
+int cable_test_tdr_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int cable_test_tdr_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
diff --git a/netlink/parser.c b/netlink/parser.c
index bd3526f..dbefc08 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -54,6 +54,22 @@ static bool __prefix_0x(const char *p)
 	return p[0] == '0' && (p[1] == 'x' || p[1] == 'X');
 }
 
+static float parse_float(const char *arg, float *result, float min,
+			 float max)
+{
+        char *endptr;
+        float val;
+
+        if (!arg || !arg[0])
+                return -EINVAL;
+        val = strtof(arg, &endptr);
+        if (*endptr || val < min || val > max)
+                return -EINVAL;
+
+        *result = val;
+        return 0;
+}
+
 static int __parse_u32(const char *arg, uint32_t *result, uint32_t min,
 		       uint32_t max, int base)
 {
@@ -211,6 +227,31 @@ int nl_parse_direct_u8(struct nl_context *nlctx, uint16_t type,
 	return (type && ethnla_put_u8(msgbuff, type, val)) ? -EMSGSIZE : 0;
 }
 
+/* Parser handler for float meters and convert it to cm. Generates
+ * NLA_U32 or fills an uint32_t.*/
+int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
+			 const void *data, struct nl_msg_buff *msgbuff,
+			 void *dest)
+{
+	const char *arg = *nlctx->argp;
+	float meters;
+	uint32_t cm;
+	int ret;
+
+	nlctx->argp++;
+	nlctx->argc--;
+	ret = parse_float(arg, &meters, 0, 150);
+	if (ret < 0) {
+		parser_err_invalid_value(nlctx, arg);
+		return ret;
+	}
+
+	cm = (uint32_t)(meters * 100);
+	if (dest)
+		*(uint32_t *)dest = cm;
+	return (type && ethnla_put_u32(msgbuff, type, cm)) ? -EMSGSIZE : 0;
+}
+
 /* Parser handler for (tri-state) bool. Expects "name on|off", generates
  * NLA_U8 which is 1 for "on" and 0 for "off".
  */
diff --git a/netlink/parser.h b/netlink/parser.h
index 3cc26d2..fd55bc7 100644
--- a/netlink/parser.h
+++ b/netlink/parser.h
@@ -111,6 +111,10 @@ int nl_parse_direct_u32(struct nl_context *nlctx, uint16_t type,
 int nl_parse_direct_u8(struct nl_context *nlctx, uint16_t type,
 		       const void *data, struct nl_msg_buff *msgbuff,
 		       void *dest);
+/* NLA_U32 represented as float number of meters, converted to cm. */
+int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
+			 const void *data, struct nl_msg_buff *msgbuff,
+			 void *dest);
 /* NLA_U8 represented as on | off */
 int nl_parse_u8bool(struct nl_context *nlctx, uint16_t type, const void *data,
 		    struct nl_msg_buff *msgbuff, void *dest);
-- 
2.27.0


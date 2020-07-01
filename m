Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24017210149
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGABIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 21:08:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgGABIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 21:08:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqRER-00344w-3U; Wed, 01 Jul 2020 03:08:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v4 4/6] Add --json command line argument parsing
Date:   Wed,  1 Jul 2020 03:07:41 +0200
Message-Id: <20200701010743.730606-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701010743.730606-1-andrew@lunn.ch>
References: <20200701010743.730606-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow --json to be passed as an option to select JSON output. The
option is handled in the same way as --debug, setting a variable in
the command context, which can then later be used per option to select
JSON outputters.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
v3:
Make use of json_print to simplify the code.
---
 ethtool.c            | 33 ++++++++++------
 internal.h           |  4 ++
 netlink/cable_test.c | 92 ++++++++++++++++++++++++++++++--------------
 3 files changed, 90 insertions(+), 39 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index a6bb9ac..ed132d4 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5518,10 +5518,10 @@ static int show_usage(struct cmd_context *ctx maybe_unused)
 	fprintf(stdout, PACKAGE " version " VERSION "\n");
 	fprintf(stdout,
 		"Usage:\n"
-		"        ethtool [ --debug MASK ] DEVNAME\t"
+		"        ethtool [ --debug MASK ][ --json ] DEVNAME\t"
 		"Display standard information about device\n");
 	for (i = 0; args[i].opts; i++) {
-		fputs("        ethtool [ --debug MASK ] ", stdout);
+		fputs("        ethtool [ --debug MASK ][ --json ] ", stdout);
 		fprintf(stdout, "%s %s\t%s\n",
 			args[i].opts,
 			args[i].no_dev ? "\t" : "DEVNAME",
@@ -5530,6 +5530,7 @@ static int show_usage(struct cmd_context *ctx maybe_unused)
 			fputs(args[i].xhelp, stdout);
 	}
 	nl_monitor_usage();
+	fprintf(stdout, "Not all options support JSON output\n");
 
 	return 0;
 }
@@ -5768,17 +5769,27 @@ int main(int argc, char **argp)
 	argp++;
 	argc--;
 
-	if (*argp && !strcmp(*argp, "--debug")) {
-		char *eptr;
+	while (true) {
+		if (*argp && !strcmp(*argp, "--debug")) {
+			char *eptr;
 
-		if (argc < 2)
-			exit_bad_args();
-		ctx.debug = strtoul(argp[1], &eptr, 0);
-		if (!argp[1][0] || *eptr)
-			exit_bad_args();
+			if (argc < 2)
+				exit_bad_args();
+			ctx.debug = strtoul(argp[1], &eptr, 0);
+			if (!argp[1][0] || *eptr)
+				exit_bad_args();
 
-		argp += 2;
-		argc -= 2;
+			argp += 2;
+			argc -= 2;
+			continue;
+		}
+		if (*argp && !strcmp(*argp, "--json")) {
+			ctx.json = true;
+			argp += 1;
+			argc -= 1;
+			continue;
+		}
+		break;
 	}
 	if (*argp && !strcmp(*argp, "--monitor")) {
 		ctx.argp = ++argp;
diff --git a/internal.h b/internal.h
index edb07bd..45b63b7 100644
--- a/internal.h
+++ b/internal.h
@@ -23,6 +23,9 @@
 #include <sys/ioctl.h>
 #include <net/if.h>
 
+#include "json_writer.h"
+#include "json_print.h"
+
 #define maybe_unused __attribute__((__unused__))
 
 /* internal for netlink interface */
@@ -221,6 +224,7 @@ struct cmd_context {
 	int argc;		/* number of arguments to the sub-command */
 	char **argp;		/* arguments to the sub-command */
 	unsigned long debug;	/* debugging mask */
+	bool json;		/* Output JSON, if supported */
 #ifdef ETHTOOL_ENABLE_NETLINK
 	struct nl_context *nlctx;	/* netlink context (opaque) */
 #endif
diff --git a/netlink/cable_test.c b/netlink/cable_test.c
index 1672f55..c2b9c97 100644
--- a/netlink/cable_test.c
+++ b/netlink/cable_test.c
@@ -88,7 +88,8 @@ static char *nl_pair2txt(uint8_t pair)
 	}
 }
 
-static int nl_cable_test_ntf_attr(struct nlattr *evattr)
+static int nl_cable_test_ntf_attr(struct nlattr *evattr,
+				  struct nl_context *nlctx)
 {
 	unsigned int cm;
 	uint16_t code;
@@ -101,29 +102,34 @@ static int nl_cable_test_ntf_attr(struct nlattr *evattr)
 		if (ret < 0)
 			return ret;
 
-		printf("Pair: %s, result: %s\n", nl_pair2txt(pair),
-		       nl_code2txt(code));
+		open_json_object(NULL);
+		print_string(PRINT_ANY, "pair", "%s ", nl_pair2txt(pair));
+		print_string(PRINT_ANY, "code", "code %s\n", nl_code2txt(code));
+		close_json_object();
 		break;
 
 	case ETHTOOL_A_CABLE_NEST_FAULT_LENGTH:
 		ret = nl_get_cable_test_fault_length(evattr, &pair, &cm);
 		if (ret < 0)
 			return ret;
-
-		printf("Pair: %s, fault length: %0.2fm\n",
-		       nl_pair2txt(pair), (float)cm / 100);
+		open_json_object(NULL);
+		print_string(PRINT_ANY, "pair", "%s, ", nl_pair2txt(pair));
+		print_float(PRINT_ANY, "length", "fault length: %0.2fm\n",
+			    (float)cm / 100);
+		close_json_object();
 		break;
 	}
 	return 0;
 }
 
-static void cable_test_ntf_nest(const struct nlattr *nest)
+static void cable_test_ntf_nest(const struct nlattr *nest,
+				struct nl_context *nlctx)
 {
 	struct nlattr *pos;
 	int ret;
 
 	mnl_attr_for_each_nested(pos, nest) {
-		ret = nl_cable_test_ntf_attr(pos);
+		ret = nl_cable_test_ntf_attr(pos, nlctx);
 		if (ret < 0)
 			return;
 	}
@@ -160,19 +166,21 @@ static int cable_test_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
 
 	switch (status) {
 	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED:
-		printf("Cable test started for device %s.\n",
-		       nlctx->devname);
+		print_string(PRINT_FP, "status",
+			     "Cable test started for device %s.\n",
+			     nlctx->devname);
 		break;
 	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED:
-		printf("Cable test completed for device %s.\n",
-		       nlctx->devname);
+		print_string(PRINT_FP, "status",
+			     "Cable test completed for device %s.\n",
+			     nlctx->devname);
 		break;
 	default:
 		break;
 	}
 
 	if (tb[ETHTOOL_A_CABLE_TEST_NTF_NEST])
-		cable_test_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_NTF_NEST]);
+		cable_test_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_NTF_NEST], nlctx);
 
 	if (status == ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED) {
 		if (ctctx)
@@ -261,8 +269,14 @@ int nl_cable_test(struct cmd_context *ctx)
 	ret = nlsock_sendmsg(nlsk, NULL);
 	if (ret < 0)
 		fprintf(stderr, "Cannot start cable test\n");
-	else
+	else {
+		new_json_obj(ctx->json);
+
 		ret = nl_cable_test_process_results(ctx);
+
+		delete_json_obj();
+	}
+
 	return ret;
 }
 
@@ -325,7 +339,8 @@ static int nl_get_cable_test_tdr_step(const struct nlattr *nest,
 	return 0;
 }
 
-static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
+static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr,
+				      struct nl_context *nlctx)
 {
 	uint32_t first, last, step;
 	uint8_t pair;
@@ -340,7 +355,10 @@ static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
 		if (ret < 0)
 			return ret;
 
-		printf("Pair: %s, amplitude %4d\n", nl_pair2txt(pair), mV);
+		open_json_object(NULL);
+		print_string(PRINT_ANY, "pair", "%s ", nl_pair2txt(pair));
+		print_uint(PRINT_ANY, "amplitude", "Amplitude %4d\n", mV);
+		close_json_object();
 		break;
 	}
 	case ETHTOOL_A_CABLE_TDR_NEST_PULSE: {
@@ -350,7 +368,9 @@ static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
 		if (ret < 0)
 			return ret;
 
-		printf("TDR pulse %dmV\n", mV);
+		open_json_object(NULL);
+		print_uint(PRINT_ANY, "pulse", "TDR Pulse %dmV\n", mV);
+		close_json_object();
 		break;
 	}
 	case ETHTOOL_A_CABLE_TDR_NEST_STEP:
@@ -358,21 +378,27 @@ static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
 		if (ret < 0)
 			return ret;
 
-		printf("Step configuration, %.2f-%.2f meters in %.2fm steps\n",
-		       (float)first / 100, (float)last /  100,
-		       (float)step /  100);
+		open_json_object(NULL);
+		print_float(PRINT_ANY, "first", "Step configuration: %.2f-",
+			    (float)first / 100);
+		print_float(PRINT_ANY, "last", "%.2f meters ",
+			    (float)last / 100);
+		print_float(PRINT_ANY, "step", "in %.2fm steps\n",
+			    (float)step / 100);
+		close_json_object();
 		break;
 	}
 	return 0;
 }
 
-static void cable_test_tdr_ntf_nest(const struct nlattr *nest)
+static void cable_test_tdr_ntf_nest(const struct nlattr *nest,
+				    struct nl_context *nlctx)
 {
 	struct nlattr *pos;
 	int ret;
 
 	mnl_attr_for_each_nested(pos, nest) {
-		ret = nl_cable_test_tdr_ntf_attr(pos);
+		ret = nl_cable_test_tdr_ntf_attr(pos, nlctx);
 		if (ret < 0)
 			return;
 	}
@@ -387,6 +413,7 @@ int cable_test_tdr_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
 	u8 status = ETHTOOL_A_CABLE_TEST_NTF_STATUS_UNSPEC;
 	struct cable_test_context *ctctx;
 	struct nl_context *nlctx = data;
+
 	DECLARE_ATTR_TB_INFO(tb);
 	bool silent;
 	int err_ret;
@@ -409,19 +436,22 @@ int cable_test_tdr_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
 
 	switch (status) {
 	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED:
-		printf("Cable test TDR started for device %s.\n",
-		       nlctx->devname);
+		print_string(PRINT_FP, "status",
+			     "Cable test TDR started for device %s.\n",
+			     nlctx->devname);
 		break;
 	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED:
-		printf("Cable test TDR completed for device %s.\n",
-		       nlctx->devname);
+		print_string(PRINT_FP, "status",
+			     "Cable test TDR completed for device %s.\n",
+			     nlctx->devname);
 		break;
 	default:
 		break;
 	}
 
 	if (tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST])
-		cable_test_tdr_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST]);
+		cable_test_tdr_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST],
+					nlctx);
 
 	if (status == ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED) {
 		if (ctctx)
@@ -556,7 +586,13 @@ int nl_cable_test_tdr(struct cmd_context *ctx)
 	ret = nlsock_sendmsg(nlsk, NULL);
 	if (ret < 0)
 		fprintf(stderr, "Cannot start cable test TDR\n");
-	else
+	else {
+		new_json_obj(ctx->json);
+
 		ret = nl_cable_test_tdr_process_results(ctx);
+
+		delete_json_obj();
+	}
+
 	return ret;
 }
-- 
2.27.0


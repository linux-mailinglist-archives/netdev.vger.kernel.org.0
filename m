Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACE1206941
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 03:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388102AbgFXBCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 21:02:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgFXBCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 21:02:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jntnq-001woU-Pu; Wed, 24 Jun 2020 03:02:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v1 4/6] Add --json command line argument parsing
Date:   Wed, 24 Jun 2020 03:01:53 +0200
Message-Id: <20200624010155.464334-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200624010155.464334-1-andrew@lunn.ch>
References: <20200624010155.464334-1-andrew@lunn.ch>
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
---
 ethtool.c            |  33 ++++++---
 internal.h           |   4 ++
 netlink/cable_test.c | 162 ++++++++++++++++++++++++++++++++-----------
 3 files changed, 146 insertions(+), 53 deletions(-)

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
index edb07bd..7135140 100644
--- a/internal.h
+++ b/internal.h
@@ -23,6 +23,8 @@
 #include <sys/ioctl.h>
 #include <net/if.h>
 
+#include "json_writer.h"
+
 #define maybe_unused __attribute__((__unused__))
 
 /* internal for netlink interface */
@@ -221,6 +223,8 @@ struct cmd_context {
 	int argc;		/* number of arguments to the sub-command */
 	char **argp;		/* arguments to the sub-command */
 	unsigned long debug;	/* debugging mask */
+	bool json;		/* Output JSON, if supported */
+	json_writer_t *jw;      /* JSON writer instance */
 #ifdef ETHTOOL_ENABLE_NETLINK
 	struct nl_context *nlctx;	/* netlink context (opaque) */
 #endif
diff --git a/netlink/cable_test.c b/netlink/cable_test.c
index 1b9ae9c..be98247 100644
--- a/netlink/cable_test.c
+++ b/netlink/cable_test.c
@@ -86,8 +86,10 @@ static char *nl_pair2txt(uint8_t pair)
 	}
 }
 
-static int nl_cable_test_ntf_attr(struct nlattr *evattr)
+static int nl_cable_test_ntf_attr(struct nlattr *evattr,
+				  struct nl_context *nlctx)
 {
+	struct cmd_context *ctx =  nlctx->ctx;
 	unsigned int cm;
 	uint16_t code;
 	uint8_t pair;
@@ -99,29 +101,44 @@ static int nl_cable_test_ntf_attr(struct nlattr *evattr)
 		if (ret < 0)
 			return ret;
 
-		printf("Pair: %s, result: %s\n", nl_pair2txt(pair),
-		       nl_code2txt(code));
+		if (ctx->jw) {
+			jsonw_start_object(ctx->jw);
+			jsonw_string_field(ctx->jw, "pair", nl_pair2txt(pair));
+			jsonw_string_field(ctx->jw, "code", nl_code2txt(code));
+			jsonw_end_object(ctx->jw);
+		} else {
+			printf("Pair: %s, result: %s\n", nl_pair2txt(pair),
+			       nl_code2txt(code));
+		}
+
 		break;
 
 	case ETHTOOL_A_CABLE_NEST_FAULT_LENGTH:
 		ret = nl_get_cable_test_fault_length(evattr, &pair, &cm);
 		if (ret < 0)
 			return ret;
-
-		printf("Pair: %s, fault length: %0.2fm\n",
-		       nl_pair2txt(pair), (float)cm / 100);
+		if (ctx->jw) {
+			jsonw_start_object(ctx->jw);
+			jsonw_string_field(ctx->jw, "pair", nl_pair2txt(pair));
+			jsonw_float_field(ctx->jw, "length", (float)cm / 100);
+			jsonw_end_object(ctx->jw);
+		} else {
+			printf("Pair: %s, fault length: %0.2fm\n",
+			       nl_pair2txt(pair), (float)cm / 100);
+		}
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
@@ -134,6 +151,7 @@ static int cable_test_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
 	const struct nlattr *tb[ETHTOOL_A_CABLE_TEST_NTF_MAX + 1] = {};
 	u8 status = ETHTOOL_A_CABLE_TEST_NTF_STATUS_UNSPEC;
 	struct nl_context *nlctx = data;
+	struct cmd_context *ctx =  nlctx->ctx;
 	DECLARE_ATTR_TB_INFO(tb);
 	bool silent;
 	int err_ret;
@@ -152,21 +170,23 @@ static int cable_test_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
 	if (tb[ETHTOOL_A_CABLE_TEST_NTF_STATUS])
 		status = mnl_attr_get_u8(tb[ETHTOOL_A_CABLE_TEST_NTF_STATUS]);
 
-	switch (status) {
-	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED:
-		printf("Cable test started for device %s.\n",
-		       nlctx->devname);
-		break;
-	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED:
-		printf("Cable test completed for device %s.\n",
-		       nlctx->devname);
-		break;
-	default:
-		break;
+	if (!ctx->json) {
+		switch (status) {
+		case ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED:
+			printf("Cable test started for device %s.\n",
+			       nlctx->devname);
+			break;
+		case ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED:
+			printf("Cable test completed for device %s.\n",
+			       nlctx->devname);
+			break;
+		default:
+			break;
+		}
 	}
 
 	if (tb[ETHTOOL_A_CABLE_TEST_NTF_NEST])
-		cable_test_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_NTF_NEST]);
+		cable_test_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_NTF_NEST], nlctx);
 
 	if (status == ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED) {
 		breakout = true;
@@ -252,8 +272,21 @@ int nl_cable_test(struct cmd_context *ctx)
 	ret = nlsock_sendmsg(nlsk, NULL);
 	if (ret < 0)
 		fprintf(stderr, "Cannot start cable test\n");
-	else
+	else {
+		if (ctx->json) {
+			ctx->jw =  jsonw_new(stdout);
+			jsonw_pretty(ctx->jw, true);
+			jsonw_start_array(ctx->jw);
+		}
+
 		ret = nl_cable_test_process_results(ctx);
+
+		if (ctx->json) {
+			jsonw_end_array(ctx->jw);
+			jsonw_destroy(&ctx->jw);
+		}
+	}
+
 	return ret;
 }
 
@@ -316,8 +349,10 @@ static int nl_get_cable_test_tdr_step(const struct nlattr *nest,
 	return 0;
 }
 
-static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
+static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr,
+				      struct nl_context *nlctx)
 {
+	struct cmd_context *ctx =  nlctx->ctx;
 	uint32_t first, last, step;
 	uint8_t pair;
 	int ret;
@@ -331,7 +366,16 @@ static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
 		if (ret < 0)
 			return ret;
 
-		printf("Pair: %s, amplitude %4d\n", nl_pair2txt(pair), mV);
+		if (ctx->jw) {
+			jsonw_start_object(ctx->jw);
+			jsonw_string_field(ctx->jw, "pair", nl_pair2txt(pair));
+			jsonw_int_field(ctx->jw, "amplitude", mV);
+			jsonw_end_object(ctx->jw);
+		} else {
+			printf("Pair: %s, amplitude %4d\n",
+			       nl_pair2txt(pair), mV);
+		}
+
 		break;
 	}
 	case ETHTOOL_A_CABLE_TDR_NEST_PULSE: {
@@ -341,7 +385,14 @@ static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
 		if (ret < 0)
 			return ret;
 
-		printf("TDR pulse %dmV\n", mV);
+		if (ctx->jw) {
+			jsonw_start_object(ctx->jw);
+			jsonw_uint_field(ctx->jw, "pulse", mV);
+			jsonw_end_object(ctx->jw);
+		} else {
+			printf("TDR pulse %dmV\n", mV);
+		}
+
 		break;
 	}
 	case ETHTOOL_A_CABLE_TDR_NEST_STEP:
@@ -349,21 +400,30 @@ static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
 		if (ret < 0)
 			return ret;
 
-		printf("Step configuration, %.2f-%.2f meters in %.2fm steps\n",
-		       (float)first / 100, (float)last /  100,
-		       (float)step /  100);
+		if (ctx->jw) {
+			jsonw_start_object(ctx->jw);
+			jsonw_float_field(ctx->jw, "first", (float)first / 100);
+			jsonw_float_field(ctx->jw, "last", (float)last / 100);
+			jsonw_float_field(ctx->jw, "step", (float)step / 100);
+			jsonw_end_object(ctx->jw);
+		} else {
+			printf("Step configuration, %.2f-%.2f meters in %.2fm steps\n",
+			       (float)first / 100, (float)last /  100,
+			       (float)step /  100);
+		}
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
@@ -376,6 +436,8 @@ int cable_test_tdr_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
 	const struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_MAX + 1] = {};
 	u8 status = ETHTOOL_A_CABLE_TEST_NTF_STATUS_UNSPEC;
 	struct nl_context *nlctx = data;
+	struct cmd_context *ctx =  nlctx->ctx;
+
 	DECLARE_ATTR_TB_INFO(tb);
 	bool silent;
 	int err_ret;
@@ -394,21 +456,24 @@ int cable_test_tdr_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
 	if (tb[ETHTOOL_A_CABLE_TEST_NTF_STATUS])
 		status = mnl_attr_get_u8(tb[ETHTOOL_A_CABLE_TEST_NTF_STATUS]);
 
-	switch (status) {
-	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED:
-		printf("Cable test TDR started for device %s.\n",
-		       nlctx->devname);
-		break;
-	case ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED:
-		printf("Cable test TDR completed for device %s.\n",
-		       nlctx->devname);
-		break;
-	default:
-		break;
+	if (!ctx->json) {
+		switch (status) {
+		case ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED:
+			printf("Cable test TDR started for device %s.\n",
+			       nlctx->devname);
+			break;
+		case ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED:
+			printf("Cable test TDR completed for device %s.\n",
+			       nlctx->devname);
+			break;
+		default:
+			break;
+		}
 	}
 
 	if (tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST])
-		cable_test_tdr_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST]);
+		cable_test_tdr_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST],
+					nlctx);
 
 	if (status == ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED) {
 		breakout = true;
@@ -540,7 +605,20 @@ int nl_cable_test_tdr(struct cmd_context *ctx)
 	ret = nlsock_sendmsg(nlsk, NULL);
 	if (ret < 0)
 		fprintf(stderr, "Cannot start cable test TDR\n");
-	else
+	else {
+		if (ctx->json) {
+			ctx->jw =  jsonw_new(stdout);
+			jsonw_pretty(ctx->jw, true);
+			jsonw_start_array(ctx->jw);
+		}
+
 		ret = nl_cable_test_tdr_process_results(ctx);
+
+		if (ctx->json) {
+			jsonw_end_array(ctx->jw);
+			jsonw_destroy(&ctx->jw);
+		}
+	}
+
 	return ret;
 }
-- 
2.26.2


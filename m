Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D9D1BCFF9
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgD1WaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:30:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:57114 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgD1WaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 18:30:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4F8EAACD0;
        Tue, 28 Apr 2020 22:30:05 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B4F01E128C; Wed, 29 Apr 2020 00:30:05 +0200 (CEST)
Message-Id: <cb6ec48745c0626a6ca14fdc0c22f11a6578d648.1588112572.git.mkubecek@suse.cz>
In-Reply-To: <cover.1588112572.git.mkubecek@suse.cz>
References: <cover.1588112572.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 1/2] refactor interface between ioctl and netlink code
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Date:   Wed, 29 Apr 2020 00:30:05 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move netlink related code from main() to separate handlers in netlink code.
Improve the logic of fallback to ioctl and improve error messages when
fallback is not possible (e.g. wildcard device name or name longer than
IFNAMSIZ). Also handle the (theoretical for now) case when ioctl handler is
not available.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c         | 51 +++++++++++-----------------------------
 netlink/extapi.h  | 14 +++++++----
 netlink/monitor.c | 15 +++++++++---
 netlink/netlink.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++-
 netlink/netlink.h |  1 +
 5 files changed, 93 insertions(+), 47 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 1b4e08b6e60f..14c0bdc776f6 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5157,7 +5157,7 @@ struct option {
 	const char	*opts;
 	bool		no_dev;
 	int		(*func)(struct cmd_context *);
-	int		(*nlfunc)(struct cmd_context *);
+	nl_func_t	nlfunc;
 	const char	*help;
 	const char	*xhelp;
 };
@@ -5731,6 +5731,11 @@ static int ioctl_init(struct cmd_context *ctx, bool no_dev)
 		ctx->fd = -1;
 		return 0;
 	}
+	if (strlen(ctx->devname) >= IFNAMSIZ) {
+		fprintf(stderr, "Device name longer than %u characters\n",
+			IFNAMSIZ - 1);
+		exit_bad_args();
+	}
 
 	/* Setup our control structures. */
 	memset(&ctx->ifr, 0, sizeof(ctx->ifr));
@@ -5750,9 +5755,9 @@ static int ioctl_init(struct cmd_context *ctx, bool no_dev)
 
 int main(int argc, char **argp)
 {
-	int (*nlfunc)(struct cmd_context *) = NULL;
 	int (*func)(struct cmd_context *);
 	struct cmd_context ctx = {};
+	nl_func_t nlfunc = NULL;
 	bool no_dev;
 	int ret;
 	int k;
@@ -5775,19 +5780,12 @@ int main(int argc, char **argp)
 		argp += 2;
 		argc -= 2;
 	}
-#ifdef ETHTOOL_ENABLE_NETLINK
 	if (*argp && !strcmp(*argp, "--monitor")) {
-		if (netlink_init(&ctx)) {
-			fprintf(stderr,
-				"Option --monitor is only available with netlink.\n");
-			return 1;
-		} else {
-			ctx.argp = ++argp;
-			ctx.argc = --argc;
-			return nl_monitor(&ctx);
-		}
+		ctx.argp = ++argp;
+		ctx.argc = --argc;
+		ret = nl_monitor(&ctx);
+		return ret ? 1 : 0;
 	}
-#endif
 
 	/* First argument must be either a valid option or a device
 	 * name to get settings for (which we don't expect to begin
@@ -5812,40 +5810,17 @@ int main(int argc, char **argp)
 	no_dev = false;
 
 opt_found:
-	if (nlfunc) {
-		if (netlink_init(&ctx))
-			nlfunc = NULL;		/* fallback to ioctl() */
-	}
-
 	if (!no_dev) {
 		ctx.devname = *argp++;
 		argc--;
 
-		/* netlink supports altnames, we will have to recheck against
-		 * IFNAMSIZ later in case of fallback to ioctl
-		 */
-		if (!ctx.devname || strlen(ctx.devname) >= ALTIFNAMSIZ) {
-			netlink_done(&ctx);
+		if (!ctx.devname)
 			exit_bad_args();
-		}
 	}
-
 	ctx.argc = argc;
 	ctx.argp = argp;
+	netlink_run_handler(&ctx, nlfunc, !func);
 
-	if (nlfunc) {
-		ret = nlfunc(&ctx);
-		netlink_done(&ctx);
-		if ((ret != -EOPNOTSUPP) || !func)
-			return (ret >= 0) ? ret : 1;
-	}
-
-	if (ctx.devname && strlen(ctx.devname) >= IFNAMSIZ) {
-		fprintf(stderr,
-			"ethtool: device names longer than %u characters are only allowed with netlink\n",
-			IFNAMSIZ - 1);
-		exit_bad_args();
-	}
 	ret = ioctl_init(&ctx, no_dev);
 	if (ret)
 		return ret;
diff --git a/netlink/extapi.h b/netlink/extapi.h
index d5b3cd92d4ab..9484b4c5ae7e 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -10,10 +10,12 @@
 struct cmd_context;
 struct nl_context;
 
+typedef int (*nl_func_t)(struct cmd_context *);
+
 #ifdef ETHTOOL_ENABLE_NETLINK
 
-int netlink_init(struct cmd_context *ctx);
-void netlink_done(struct cmd_context *ctx);
+void netlink_run_handler(struct cmd_context *ctx, nl_func_t nlfunc,
+			 bool no_fallback);
 
 int nl_gset(struct cmd_context *ctx);
 int nl_sset(struct cmd_context *ctx);
@@ -24,13 +26,15 @@ void nl_monitor_usage(void);
 
 #else /* ETHTOOL_ENABLE_NETLINK */
 
-static inline int netlink_init(struct cmd_context *ctx maybe_unused)
+static inline void netlink_run_handler(struct cmd_context *ctx,
+				       nl_func_t nlfunc, bool no_fallback)
 {
-	return -EOPNOTSUPP;
 }
 
-static inline void netlink_done(struct cmd_context *ctx maybe_unused)
+static inline int nl_monitor(struct cmd_context *ctx)
 {
+	fprintf(stderr, "Netlink not supported by ethtool, option --monitor unsupported.\n");
+	return -EOPNOTSUPP;
 }
 
 static inline void nl_monitor_usage(void)
diff --git a/netlink/monitor.c b/netlink/monitor.c
index 5fce6b64c08c..e20db5fc79d4 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -167,16 +167,25 @@ static int parse_monitor(struct cmd_context *ctx)
 
 int nl_monitor(struct cmd_context *ctx)
 {
-	struct nl_context *nlctx = ctx->nlctx;
-	struct nl_socket *nlsk = nlctx->ethnl_socket;
-	uint32_t grpid = nlctx->ethnl_mongrp;
+	struct nl_context *nlctx;
+	struct nl_socket *nlsk;
+	uint32_t grpid;
 	bool is_dev;
 	int ret;
 
+	ret = netlink_init(ctx);
+	if (ret < 0) {
+		fprintf(stderr, "Netlink interface initialization failed, option --monitor not supported.\n");
+		return ret;
+	}
+	nlctx = ctx->nlctx;
+	nlsk = nlctx->ethnl_socket;
+	grpid = nlctx->ethnl_mongrp;
 	if (!grpid) {
 		fprintf(stderr, "multicast group 'monitor' not found\n");
 		return -EOPNOTSUPP;
 	}
+
 	if (parse_monitor(ctx) < 0)
 		return 1;
 	is_dev = ctx->devname && strcmp(ctx->devname, WILDCARD_DEVNAME);
diff --git a/netlink/netlink.c b/netlink/netlink.c
index 39f406387233..59dbab2dee00 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -205,7 +205,7 @@ out_free:
 	return ret;
 }
 
-void netlink_done(struct cmd_context *ctx)
+static void netlink_done(struct cmd_context *ctx)
 {
 	if (!ctx->nlctx)
 		return;
@@ -214,3 +214,60 @@ void netlink_done(struct cmd_context *ctx)
 	ctx->nlctx = NULL;
 	cleanup_all_strings();
 }
+
+/**
+ * netlink_run_handler() - run netlink handler for subcommand
+ * @ctx:         command context
+ * @nlfunc:      subcommand netlink handler to call
+ * @no_fallback: there is no ioctl fallback handler
+ *
+ * This function returns only if ioctl() handler should be run as fallback.
+ * Otherwise it exits with appropriate return code.
+ */
+void netlink_run_handler(struct cmd_context *ctx, nl_func_t nlfunc,
+			 bool no_fallback)
+{
+	bool wildcard = ctx->devname && !strcmp(ctx->devname, WILDCARD_DEVNAME);
+	const char *reason;
+	int ret;
+
+	if (ctx->devname && strlen(ctx->devname) >= ALTIFNAMSIZ) {
+		fprintf(stderr, "device name '%s' longer than %u characters\n",
+			ctx->devname, ALTIFNAMSIZ - 1);
+		exit(1);
+	}
+
+	if (!nlfunc) {
+		reason = "ethtool netlink support for subcommand missing";
+		goto no_support;
+	}
+	if (netlink_init(ctx)) {
+		reason = "netlink interface initialization failed";
+		goto no_support;
+	}
+
+	ret = nlfunc(ctx);
+	netlink_done(ctx);
+	if (ret != -EOPNOTSUPP || no_fallback)
+		exit(ret >= 0 ? ret : 1);
+	reason = "kernel netlink support for subcommand missing";
+
+no_support:
+	if (no_fallback) {
+		fprintf(stderr, "%s, subcommand not supported by ioctl\n",
+			reason);
+		exit(1);
+	}
+	if (wildcard) {
+		fprintf(stderr, "%s, wildcard dump not supported\n", reason);
+		exit(1);
+	}
+	if (ctx->devname && strlen(ctx->devname) >= IFNAMSIZ) {
+		fprintf(stderr,
+			"%s, device name longer than %u not supported\n",
+			reason, IFNAMSIZ - 1);
+		exit(1);
+	}
+
+	/* fallback to ioctl() */
+}
diff --git a/netlink/netlink.h b/netlink/netlink.h
index db078d28fabb..41102d270eaf 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -49,6 +49,7 @@ struct attr_tb_info {
 int nomsg_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int attr_cb(const struct nlattr *attr, void *data);
 
+int netlink_init(struct cmd_context *ctx);
 const char *get_dev_name(const struct nlattr *nest);
 int get_dev_info(const struct nlattr *nest, int *ifindex, char *ifname);
 
-- 
2.26.2


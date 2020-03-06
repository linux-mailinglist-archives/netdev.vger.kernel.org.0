Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645C917C383
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgCFREc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:04:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:43198 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgCFREc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:04:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2E58DB28D;
        Fri,  6 Mar 2020 17:04:30 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D3677E00E7; Fri,  6 Mar 2020 18:04:29 +0100 (CET)
Message-Id: <5b9b0cb3b4f3f9b3af4d7eb217068ad0862b2a9c.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 06/25] netlink: introduce the netlink interface
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:04:29 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial part of netlink interface based on genetlink and libmnl. The
netlink interface is available in kernel since 5.6-rc1. This commit only
adds the generic infrastructure but does not override any ethtool command
so that there is no actual change in behaviour.

Netlink handlers for ethtool commands are added as nlfunc members to args
array in ethtool.c. A netlink handler is used if it is available (i.e.
nlfunc is not null) and ethtool succeeds to initialize netlink socket.
If netlink implementation exists for a command but the request is not
supported by kernel (e.g. when new ethtool is used on older kernel), ioctl
implementation is also used as fallback.

Running configure with --disable-netlink completely disables the netlink
interface.

v2:
  - change type of nl_context::suppress_nlerr
  - add nl_context::rtnl_socket
v3:
  - drop ethtool_CFLAGS and ethtool_LDADD in Makefile.am

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am       | 10 +++++++
 configure.ac      | 14 ++++++++-
 ethtool.c         | 76 +++++++++++++++++++++++++++++++++++------------
 internal.h        | 12 ++++++++
 netlink/extapi.h  | 31 +++++++++++++++++++
 netlink/netlink.c | 36 ++++++++++++++++++++++
 netlink/netlink.h | 26 ++++++++++++++++
 7 files changed, 185 insertions(+), 20 deletions(-)
 create mode 100644 netlink/extapi.h
 create mode 100644 netlink/netlink.c
 create mode 100644 netlink/netlink.h

diff --git a/Makefile.am b/Makefile.am
index e6d6e4ccda9e..f5448350746b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -23,6 +23,16 @@ bashcompletiondir = $(BASH_COMPLETION_DIR)
 dist_bashcompletion_DATA = shell-completion/bash/ethtool
 endif
 
+if ETHTOOL_ENABLE_NETLINK
+ethtool_SOURCES += \
+		  netlink/netlink.c netlink/netlink.h netlink/extapi.h \
+		  uapi/linux/ethtool_netlink.h \
+		  uapi/linux/netlink.h uapi/linux/genetlink.h \
+		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
+AM_CPPFLAGS += @MNL_CFLAGS@
+LDADD += @MNL_LIBS@
+endif
+
 TESTS = test-cmdline test-features
 check_PROGRAMS = test-cmdline test-features
 test_cmdline_SOURCES = test-cmdline.c test-common.c $(ethtool_SOURCES) 
diff --git a/configure.ac b/configure.ac
index a5c1469f9b63..19e7fcb44fb5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@ dnl Process this file with autoconf to produce a configure script.
 AC_INIT(ethtool, 5.4, netdev@vger.kernel.org)
 AC_PREREQ(2.52)
 AC_CONFIG_SRCDIR([ethtool.c])
-AM_INIT_AUTOMAKE([gnu])
+AM_INIT_AUTOMAKE([gnu subdir-objects])
 AC_CONFIG_HEADERS([ethtool-config.h])
 
 AM_MAINTAINER_MODE
@@ -66,5 +66,17 @@ AC_SUBST([BASH_COMPLETION_DIR])
 AM_CONDITIONAL([ENABLE_BASH_COMPLETION],
 	       [test "x$with_bash_completion_dir" != xno])
 
+AC_ARG_ENABLE(netlink,
+	      [  --enable-netlink	  enable netlink interface (enabled by default)],
+	      ,
+	      enable_netlink=yes)
+if test x$enable_netlink = xyes; then
+    PKG_PROG_PKG_CONFIG
+    PKG_CHECK_MODULES([MNL], [libmnl])
+    AC_DEFINE(ETHTOOL_ENABLE_NETLINK, 1,
+	      Define this to support netlink interface to talk to kernel.)
+fi
+AM_CONDITIONAL([ETHTOOL_ENABLE_NETLINK], [test x$enable_netlink = xyes])
+
 AC_CONFIG_FILES([Makefile ethtool.spec ethtool.8])
 AC_OUTPUT
diff --git a/ethtool.c b/ethtool.c
index 3186a72644fd..5d1ef537f692 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -48,6 +48,8 @@
 #include <linux/sockios.h>
 #include <linux/netlink.h>
 
+#include "netlink/extapi.h"
+
 #ifndef MAX_ADDR_LEN
 #define MAX_ADDR_LEN	32
 #endif
@@ -5292,6 +5294,7 @@ struct option {
 	const char	*opts;
 	bool		no_dev;
 	int		(*func)(struct cmd_context *);
+	int		(*nlfunc)(struct cmd_context *);
 	const char	*help;
 	const char	*xhelp;
 };
@@ -5856,11 +5859,36 @@ static int do_perqueue(struct cmd_context *ctx)
 	return 0;
 }
 
+static int ioctl_init(struct cmd_context *ctx, bool no_dev)
+{
+	if (no_dev) {
+		ctx->fd = -1;
+		return 0;
+	}
+
+	/* Setup our control structures. */
+	memset(&ctx->ifr, 0, sizeof(ctx->ifr));
+	strcpy(ctx->ifr.ifr_name, ctx->devname);
+
+	/* Open control socket. */
+	ctx->fd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (ctx->fd < 0)
+		ctx->fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
+	if (ctx->fd < 0) {
+		perror("Cannot get control socket");
+		return 70;
+	}
+
+	return 0;
+}
+
 int main(int argc, char **argp)
 {
+	int (*nlfunc)(struct cmd_context *) = NULL;
 	int (*func)(struct cmd_context *);
-	struct cmd_context ctx;
+	struct cmd_context ctx = {};
 	bool no_dev;
+	int ret;
 	int k;
 
 	init_global_link_mode_masks();
@@ -5869,7 +5897,6 @@ int main(int argc, char **argp)
 	argp++;
 	argc--;
 
-	ctx.debug = 0;
 	if (*argp && !strcmp(*argp, "--debug")) {
 		char *eptr;
 
@@ -5895,6 +5922,7 @@ int main(int argc, char **argp)
 		argp++;
 		argc--;
 		func = args[k].func;
+		nlfunc = args[k].nlfunc;
 		no_dev = args[k].no_dev;
 		goto opt_found;
 	}
@@ -5904,33 +5932,43 @@ int main(int argc, char **argp)
 	no_dev = false;
 
 opt_found:
+	if (nlfunc) {
+		if (netlink_init(&ctx))
+			nlfunc = NULL;		/* fallback to ioctl() */
+	}
+
 	if (!no_dev) {
 		ctx.devname = *argp++;
 		argc--;
 
-		if (ctx.devname == NULL)
-			exit_bad_args();
-		if (strlen(ctx.devname) >= IFNAMSIZ)
+		/* netlink supports altnames, we will have to recheck against
+		 * IFNAMSIZ later in case of fallback to ioctl
+		 */
+		if (!ctx.devname || strlen(ctx.devname) >= ALTIFNAMSIZ) {
+			netlink_done(&ctx);
 			exit_bad_args();
-
-		/* Setup our control structures. */
-		memset(&ctx.ifr, 0, sizeof(ctx.ifr));
-		strcpy(ctx.ifr.ifr_name, ctx.devname);
-
-		/* Open control socket. */
-		ctx.fd = socket(AF_INET, SOCK_DGRAM, 0);
-		if (ctx.fd < 0)
-			ctx.fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
-		if (ctx.fd < 0) {
-			perror("Cannot get control socket");
-			return 70;
 		}
-	} else {
-		ctx.fd = -1;
 	}
 
 	ctx.argc = argc;
 	ctx.argp = argp;
 
+	if (nlfunc) {
+		ret = nlfunc(&ctx);
+		netlink_done(&ctx);
+		if ((ret != -EOPNOTSUPP) || !func)
+			return (ret >= 0) ? ret : 1;
+	}
+
+	if (ctx.devname && strlen(ctx.devname) >= IFNAMSIZ) {
+		fprintf(stderr,
+			"ethtool: device names longer than %u characters are only allowed with netlink\n",
+			IFNAMSIZ - 1);
+		exit_bad_args();
+	}
+	ret = ioctl_init(&ctx, no_dev);
+	if (ret)
+		return ret;
+
 	return func(&ctx);
 }
diff --git a/internal.h b/internal.h
index 9ec145f55dcb..72a04e638a13 100644
--- a/internal.h
+++ b/internal.h
@@ -25,6 +25,11 @@
 
 #define maybe_unused __attribute__((__unused__))
 
+/* internal for netlink interface */
+#ifdef ETHTOOL_ENABLE_NETLINK
+struct nl_context;
+#endif
+
 /* ethtool.h expects these to be defined by <linux/types.h> */
 #ifndef HAVE_BE_TYPES
 typedef uint16_t __be16;
@@ -44,6 +49,10 @@ typedef int32_t s32;
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
 #endif
 
+#ifndef ALTIFNAMSIZ
+#define ALTIFNAMSIZ 128
+#endif
+
 #include <linux/ethtool.h>
 #include <linux/net_tstamp.h>
 
@@ -203,6 +212,9 @@ struct cmd_context {
 	int argc;		/* number of arguments to the sub-command */
 	char **argp;		/* arguments to the sub-command */
 	unsigned long debug;	/* debugging mask */
+#ifdef ETHTOOL_ENABLE_NETLINK
+	struct nl_context *nlctx;	/* netlink context (opaque) */
+#endif
 };
 
 #ifdef TEST_ETHTOOL
diff --git a/netlink/extapi.h b/netlink/extapi.h
new file mode 100644
index 000000000000..898dc6cfee71
--- /dev/null
+++ b/netlink/extapi.h
@@ -0,0 +1,31 @@
+/*
+ * extapi.h - external interface of netlink code
+ *
+ * Declarations needed by non-netlink code (mostly ethtool.c).
+ */
+
+#ifndef ETHTOOL_EXTAPI_H__
+#define ETHTOOL_EXTAPI_H__
+
+struct cmd_context;
+struct nl_context;
+
+#ifdef ETHTOOL_ENABLE_NETLINK
+
+int netlink_init(struct cmd_context *ctx);
+void netlink_done(struct cmd_context *ctx);
+
+#else /* ETHTOOL_ENABLE_NETLINK */
+
+static inline int netlink_init(struct cmd_context *ctx maybe_unused)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void netlink_done(struct cmd_context *ctx maybe_unused)
+{
+}
+
+#endif /* ETHTOOL_ENABLE_NETLINK */
+
+#endif /* ETHTOOL_EXTAPI_H__ */
diff --git a/netlink/netlink.c b/netlink/netlink.c
new file mode 100644
index 000000000000..84e188119989
--- /dev/null
+++ b/netlink/netlink.c
@@ -0,0 +1,36 @@
+/*
+ * netlink.c - basic infrastructure for netlink code
+ *
+ * Heart of the netlink interface implementation.
+ */
+
+#include <errno.h>
+
+#include "../internal.h"
+#include "netlink.h"
+#include "extapi.h"
+
+/* initialization */
+
+int netlink_init(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx;
+
+	nlctx = calloc(1, sizeof(*nlctx));
+	if (!nlctx)
+		return -ENOMEM;
+	nlctx->ctx = ctx;
+
+	ctx->nlctx = nlctx;
+
+	return 0;
+}
+
+void netlink_done(struct cmd_context *ctx)
+{
+	if (!ctx->nlctx)
+		return;
+
+	free(ctx->nlctx);
+	ctx->nlctx = NULL;
+}
diff --git a/netlink/netlink.h b/netlink/netlink.h
new file mode 100644
index 000000000000..99636ac8d9c4
--- /dev/null
+++ b/netlink/netlink.h
@@ -0,0 +1,26 @@
+/*
+ * netlink.h - common interface for all netlink code
+ *
+ * Declarations of data structures, global data and helpers for netlink code
+ */
+
+#ifndef ETHTOOL_NETLINK_INT_H__
+#define ETHTOOL_NETLINK_INT_H__
+
+#include <libmnl/libmnl.h>
+#include <linux/netlink.h>
+#include <linux/genetlink.h>
+#include <linux/ethtool_netlink.h>
+
+#define WILDCARD_DEVNAME "*"
+
+struct nl_context {
+	struct cmd_context	*ctx;
+	void			*cmd_private;
+	const char		*devname;
+	bool			is_dump;
+	int			exit_code;
+	unsigned int		suppress_nlerr;
+};
+
+#endif /* ETHTOOL_NETLINK_INT_H__ */
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 003231799B9
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388302AbgCDUZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:25:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:33458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbgCDUZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:25:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 96CFBB2A5;
        Wed,  4 Mar 2020 20:25:31 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 45FD0E037F; Wed,  4 Mar 2020 21:25:31 +0100 (CET)
Message-Id: <5ca8a91fd1cc6be16b8959d4fd5d5ce83701fe4c.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 11/25] netlink: add notification monitor
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:25:31 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With 'ethtool --monitor [ --all | opt ] [dev]', let ethtool listen to
netlink notification and display them in a format similar to output of
related "get" commands.

With --all or without option, show all types of notifications. If a device
name is specified, show only notifications for that device, if no device
name or "*" is passed, show notifications for all devices.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am       |   1 +
 ethtool.8.in      |  21 +++++
 ethtool.c         |  14 ++++
 netlink/extapi.h  |   8 ++
 netlink/monitor.c | 197 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/netlink.h |  11 +++
 netlink/strset.c  |   2 +
 7 files changed, 254 insertions(+)
 create mode 100644 netlink/monitor.c

diff --git a/Makefile.am b/Makefile.am
index aa41b21fa779..0aa88ead27d5 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -29,6 +29,7 @@ ethtool_SOURCES += \
 		  netlink/netlink.c netlink/netlink.h netlink/extapi.h \
 		  netlink/msgbuff.c netlink/msgbuff.h netlink/nlsock.c \
 		  netlink/nlsock.h netlink/strset.c netlink/strset.h \
+		  netlink/monitor.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/ethtool.8.in b/ethtool.8.in
index 680cad9fbb8f..28e4f75eee8d 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -133,6 +133,13 @@ ethtool \- query or control network driver and hardware settings
 .BN --debug
 .I args
 .HP
+.B ethtool \-\-monitor
+[
+.I command
+] [
+.I devname
+]
+.HP
 .B ethtool \-a|\-\-show\-pause
 .I devname
 .HP
@@ -1244,6 +1251,20 @@ If queue_mask is not set, the sub command will be applied to all queues.
 Sub command to apply. The supported sub commands include --show-coalesce and
 --coalesce.
 .RE
+.TP
+.B \-\-monitor
+Listens to netlink notification and displays them.
+.RS 4
+.TP
+.I command
+If argument matching a command is used, ethtool only shows notifications of
+this type. Without such argument or with --all, all notification types are
+shown.
+.TP
+.I devname
+If a device name is used as argument, only notification for this device are
+shown. Default is to show notifications for all devices.
+.RE
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
diff --git a/ethtool.c b/ethtool.c
index 5d1ef537f692..97eaa58a3090 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5664,6 +5664,7 @@ static int show_usage(struct cmd_context *ctx maybe_unused)
 		if (args[i].xhelp)
 			fputs(args[i].xhelp, stdout);
 	}
+	nl_monitor_usage();
 
 	return 0;
 }
@@ -5909,6 +5910,19 @@ int main(int argc, char **argp)
 		argp += 2;
 		argc -= 2;
 	}
+#ifdef ETHTOOL_ENABLE_NETLINK
+	if (*argp && !strcmp(*argp, "--monitor")) {
+		if (netlink_init(&ctx)) {
+			fprintf(stderr,
+				"Option --monitor is only available with netlink.\n");
+			return 1;
+		} else {
+			ctx.argp = ++argp;
+			ctx.argc = --argc;
+			return nl_monitor(&ctx);
+		}
+	}
+#endif
 
 	/* First argument must be either a valid option or a device
 	 * name to get settings for (which we don't expect to begin
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 898dc6cfee71..1d5b68226af4 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -15,6 +15,10 @@ struct nl_context;
 int netlink_init(struct cmd_context *ctx);
 void netlink_done(struct cmd_context *ctx);
 
+int nl_monitor(struct cmd_context *ctx);
+
+void nl_monitor_usage(void);
+
 #else /* ETHTOOL_ENABLE_NETLINK */
 
 static inline int netlink_init(struct cmd_context *ctx maybe_unused)
@@ -26,6 +30,10 @@ static inline void netlink_done(struct cmd_context *ctx maybe_unused)
 {
 }
 
+static inline void nl_monitor_usage(void)
+{
+}
+
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
 #endif /* ETHTOOL_EXTAPI_H__ */
diff --git a/netlink/monitor.c b/netlink/monitor.c
new file mode 100644
index 000000000000..300fd5bc2e51
--- /dev/null
+++ b/netlink/monitor.c
@@ -0,0 +1,197 @@
+/*
+ * monitor.c - netlink notification monitor
+ *
+ * Implementation of "ethtool --monitor" for watching netlink notifications.
+ */
+
+#include <errno.h>
+
+#include "../internal.h"
+#include "netlink.h"
+#include "nlsock.h"
+#include "strset.h"
+
+static struct {
+	uint8_t		cmd;
+	mnl_cb_t	cb;
+} monitor_callbacks[] = {
+};
+
+static void clear_filter(struct nl_context *nlctx)
+{
+	unsigned int i;
+
+	for (i = 0; i < CMDMASK_WORDS; i++)
+		nlctx->filter_cmds[i] = 0;
+}
+
+static bool test_filter_cmd(const struct nl_context *nlctx, unsigned int cmd)
+{
+	return nlctx->filter_cmds[cmd / 32] & (1U << (cmd % 32));
+}
+
+static void set_filter_cmd(struct nl_context *nlctx, unsigned int cmd)
+{
+	nlctx->filter_cmds[cmd / 32] |= (1U << (cmd % 32));
+}
+
+static void set_filter_all(struct nl_context *nlctx)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(monitor_callbacks); i++)
+		set_filter_cmd(nlctx, monitor_callbacks[i].cmd);
+}
+
+static int monitor_any_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct genlmsghdr *ghdr = (const struct genlmsghdr *)(nlhdr + 1);
+	struct nl_context *nlctx = data;
+	unsigned int i;
+
+	if (!test_filter_cmd(nlctx, ghdr->cmd))
+		return MNL_CB_OK;
+
+	for (i = 0; i < MNL_ARRAY_SIZE(monitor_callbacks); i++)
+		if (monitor_callbacks[i].cmd == ghdr->cmd)
+			return monitor_callbacks[i].cb(nlhdr, data);
+
+	return MNL_CB_OK;
+}
+
+struct monitor_option {
+	const char	*pattern;
+	uint8_t		cmd;
+	uint32_t	info_mask;
+};
+
+static struct monitor_option monitor_opts[] = {
+	{
+		.pattern	= "|--all",
+		.cmd		= 0,
+	},
+};
+
+static bool pattern_match(const char *s, const char *pattern)
+{
+	const char *opt = pattern;
+	const char *next;
+	int slen = strlen(s);
+	int optlen;
+
+	do {
+		next = opt;
+		while (*next && *next != '|')
+			next++;
+		optlen = next - opt;
+		if (slen == optlen && !strncmp(s, opt, optlen))
+			return true;
+
+		opt = next;
+		if (*opt == '|')
+			opt++;
+	} while (*opt);
+
+	return false;
+}
+
+static int parse_monitor(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	char **argp = ctx->argp;
+	int argc = ctx->argc;
+	const char *opt = "";
+	bool opt_found;
+	unsigned int i;
+
+	if (*argp && argp[0][0] == '-') {
+		opt = *argp;
+		argp++;
+		argc--;
+	}
+	opt_found = false;
+	clear_filter(nlctx);
+	for (i = 0; i < MNL_ARRAY_SIZE(monitor_opts); i++) {
+		if (pattern_match(opt, monitor_opts[i].pattern)) {
+			unsigned int cmd = monitor_opts[i].cmd;
+
+			if (!cmd)
+				set_filter_all(nlctx);
+			else
+				set_filter_cmd(nlctx, cmd);
+			opt_found = true;
+		}
+	}
+	if (!opt_found) {
+		fprintf(stderr, "monitoring for option '%s' not supported\n",
+			*argp);
+		return -1;
+	}
+
+	if (*argp && strcmp(*argp, WILDCARD_DEVNAME))
+		ctx->devname = *argp;
+	return 0;
+}
+
+int nl_monitor(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	uint32_t grpid = nlctx->ethnl_mongrp;
+	bool is_dev;
+	int ret;
+
+	if (!grpid) {
+		fprintf(stderr, "multicast group 'monitor' not found\n");
+		return -EOPNOTSUPP;
+	}
+	if (parse_monitor(ctx) < 0)
+		return 1;
+	is_dev = ctx->devname && strcmp(ctx->devname, WILDCARD_DEVNAME);
+
+	ret = preload_global_strings(nlsk);
+	if (ret < 0)
+		return ret;
+	ret = mnl_socket_setsockopt(nlsk->sk, NETLINK_ADD_MEMBERSHIP,
+				    &grpid, sizeof(grpid));
+	if (ret < 0)
+		return ret;
+	if (is_dev) {
+		ret = preload_perdev_strings(nlsk, ctx->devname);
+		if (ret < 0)
+			goto out_strings;
+	}
+
+	nlctx->filter_devname = ctx->devname;
+	nlctx->is_monitor = true;
+	nlsk->port = 0;
+	nlsk->seq = 0;
+
+	fputs("listening...\n", stdout);
+	fflush(stdout);
+	ret = nlsock_process_reply(nlsk, monitor_any_cb, nlctx);
+
+out_strings:
+	cleanup_all_strings();
+	return ret;
+}
+
+void nl_monitor_usage(void)
+{
+	unsigned int i;
+	const char *p;
+
+	fputs("        ethtool --monitor               Show kernel notifications\n",
+	      stdout);
+	fputs("                ( [ --all ]", stdout);
+	for (i = 1; i < MNL_ARRAY_SIZE(monitor_opts); i++) {
+		fputs("\n                  | ", stdout);
+		for (p = monitor_opts[i].pattern; *p; p++)
+			if (*p == '|')
+				fputs(" | ", stdout);
+			else
+				fputc(*p, stdout);
+	}
+	fputs(" )\n", stdout);
+	fputs("                [ DEVNAME | * ]\n", stdout);
+}
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 04ad7bcd347c..be44f9c16f19 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -14,6 +14,7 @@
 #include "nlsock.h"
 
 #define WILDCARD_DEVNAME "*"
+#define CMDMASK_WORDS DIV_ROUND_UP(__ETHTOOL_MSG_KERNEL_CNT, 32)
 
 struct nl_context {
 	struct cmd_context	*ctx;
@@ -26,6 +27,9 @@ struct nl_context {
 	uint32_t		ethnl_mongrp;
 	struct nl_socket	*ethnl_socket;
 	struct nl_socket	*ethnl2_socket;
+	bool			is_monitor;
+	uint32_t		filter_cmds[CMDMASK_WORDS];
+	const char		*filter_devname;
 };
 
 struct attr_tb_info {
@@ -48,6 +52,13 @@ static inline void copy_devname(char *dst, const char *src)
 	dst[ALTIFNAMSIZ - 1] = '\0';
 }
 
+static inline bool dev_ok(const struct nl_context *nlctx)
+{
+	return !nlctx->filter_devname ||
+	       (nlctx->devname &&
+		!strcmp(nlctx->devname, nlctx->filter_devname));
+}
+
 static inline int netlink_init_ethnl2_socket(struct nl_context *nlctx)
 {
 	if (nlctx->ethnl2_socket)
diff --git a/netlink/strset.c b/netlink/strset.c
index bc468ae5a88e..75f0327bbe43 100644
--- a/netlink/strset.c
+++ b/netlink/strset.c
@@ -149,6 +149,8 @@ static int strset_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 			return MNL_CB_OK;
 		nlctx->devname = devname;
 	}
+	if (ifindex && !dev_ok(nlctx))
+		return MNL_CB_OK;
 
 	if (ifindex) {
 		struct perdev_strings *perdev;
-- 
2.25.1


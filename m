Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC2BB0DCD
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbfILL3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:29:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45494 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731430AbfILL3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:29:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id l16so27952320wrv.12
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 04:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=24tpNRVtEEflV/yl5P5AE90cvqamSTu4hLar8F1ym00=;
        b=U7orYgRhhCTQE/qlntgeO3vaSHAJCMmuuEEY2ouDmd1aIVxW2MJjew6mueVsz7Q7Xk
         sqYo9LnNxNtEI3XlkWqQGKkypn3U8s8n2dPebhG1DcVnQOjQokZN2IZMfm9sVCZwnrFa
         ZWf66EHKoyDfAaKiVXKb4dQNvyUU+lXOsUcIIiLF5Txri3tbdfW7x15pn1jD259akIF1
         wq8DQ00jtoBik2ZLyF6zrGqyfl1jl6Q1hB2mXGEvbgiFQy3wJ0+ZnQmg5wN0ReDuMKNM
         yFjiM77DD5tSs0nxdzRAii+geqhCypHIkSvYVDtZNI8fw4ea/n6Sl5hEIuv1z9qJaUCq
         8asg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24tpNRVtEEflV/yl5P5AE90cvqamSTu4hLar8F1ym00=;
        b=S/zKadUwLQUNMw3kWE3cs8XdjCh7mfnyLXmHEgCuAdMZll0G1GIGmz0vbptsZ8W7ke
         ia7F6dmybwTwye6QbMmIw8zAEFcu7CrHOHDieeim9wnxVk25twOlIjh6yl1D7XLirdtx
         5v87iUCd9VyLhLuKXFk+M0ePknB+d4o+TBvV2wOACKjP2sctg0psysnNiGMzqdNl38bV
         pnuyfb6qH1kd5z0tXzCjBxe+2ghufSheIvb95XJtcVOnIHFkODvGV1F/CB4YZtZAkNXv
         A08+2G64+ghQkLO/DE8Y4HyYZKDq0RREi7x3Cu+EWzIwb0HRjlp9g4/OIMSIFN9y6z+n
         mkTQ==
X-Gm-Message-State: APjAAAX+D6WGI77BUkpljEkHEaVKWjiMrXChFgPDSx84OQ9T/mERozyc
        E2jJ+EM/gJoOxqd+4kgfwLRxeLTpWcM=
X-Google-Smtp-Source: APXvYqwSKTa33WlIl9pebwNZZf86VfW+YxmzPAW+nTaGX9Kyvlq//RrZrZKvfrel6RocCAuJzh7nOQ==
X-Received: by 2002:adf:e48f:: with SMTP id i15mr4203462wrm.26.1568287781137;
        Thu, 12 Sep 2019 04:29:41 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t123sm7506582wma.40.2019.09.12.04.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 04:29:40 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, f.fainelli@gmail.com
Subject: [patch iproute2-next v4 2/2] devlink: implement flash status monitoring
Date:   Thu, 12 Sep 2019 13:29:38 +0200
Message-Id: <20190912112938.2292-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190912112938.2292-1-jiri@resnulli.us>
References: <20190912112938.2292-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Listen to status notifications coming from kernel during flashing and
put them on stdout to inform user about the status.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v3->v4:
- rebased (traps, pr_x conversion)
v2->v3:
- added example in man
v1->v2:
- fixed endless loop bug in case of no notifications
---
 devlink/devlink.c      | 215 ++++++++++++++++++++++++++++++++++++++++-
 devlink/mnlg.c         |   5 +
 devlink/mnlg.h         |   1 +
 man/man8/devlink-dev.8 |  11 +++
 4 files changed, 228 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 31c319e3ef7a..00ebfb598515 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -25,6 +25,7 @@
 #include <linux/devlink.h>
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
+#include <sys/types.h>
 
 #include "SNAPSHOT.h"
 #include "list.h"
@@ -96,6 +97,18 @@ pr_out_sp(unsigned int num, const char *fmt, ...)
 	g_new_line_count = 0;			\
 }
 
+static void __attribute__((format(printf, 1, 2)))
+pr_out_tty(const char *fmt, ...)
+{
+	va_list ap;
+
+	if (!isatty(STDOUT_FILENO))
+		return;
+	va_start(ap, fmt);
+	vprintf(fmt, ap);
+	va_end(ap);
+}
+
 static void __pr_out_indent_inc(void)
 {
 	if (g_indent_level + INDENT_STR_STEP > INDENT_STR_MAXLEN)
@@ -135,9 +148,8 @@ static int _mnlg_socket_recv_run(struct mnlg_socket *nlg,
 	return 0;
 }
 
-static int _mnlg_socket_sndrcv(struct mnlg_socket *nlg,
-			       const struct nlmsghdr *nlh,
-			       mnl_cb_t data_cb, void *data)
+static int _mnlg_socket_send(struct mnlg_socket *nlg,
+			     const struct nlmsghdr *nlh)
 {
 	int err;
 
@@ -146,6 +158,18 @@ static int _mnlg_socket_sndrcv(struct mnlg_socket *nlg,
 		pr_err("Failed to call mnlg_socket_send\n");
 		return -errno;
 	}
+	return 0;
+}
+
+static int _mnlg_socket_sndrcv(struct mnlg_socket *nlg,
+			       const struct nlmsghdr *nlh,
+			       mnl_cb_t data_cb, void *data)
+{
+	int err;
+
+	err = _mnlg_socket_send(nlg, nlh);
+	if (err)
+		return err;
 	return _mnlg_socket_recv_run(nlg, data_cb, data);
 }
 
@@ -2830,9 +2854,151 @@ static void cmd_dev_flash_help(void)
 	pr_err("Usage: devlink dev flash DEV file PATH [ component NAME ]\n");
 }
 
+
+struct cmd_dev_flash_status_ctx {
+	struct dl *dl;
+	char *last_msg;
+	char *last_component;
+	uint8_t not_first:1,
+		last_pc:1,
+		received_end:1,
+		flash_done:1;
+};
+
+static int nullstrcmp(const char *str1, const char *str2)
+{
+	if (str1 && str2)
+		return strcmp(str1, str2);
+	if (!str1 && !str2)
+		return 0;
+	return str1 ? 1 : -1;
+}
+
+static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct cmd_dev_flash_status_ctx *ctx = data;
+	struct dl_opts *opts = &ctx->dl->opts;
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	const char *component = NULL;
+	uint64_t done = 0, total = 0;
+	const char *msg = NULL;
+	const char *bus_name;
+	const char *dev_name;
+
+	if (genl->cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS &&
+	    genl->cmd != DEVLINK_CMD_FLASH_UPDATE_END)
+		return MNL_CB_STOP;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
+	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
+	if (strcmp(bus_name, opts->bus_name) ||
+	    strcmp(dev_name, opts->dev_name))
+		return MNL_CB_ERROR;
+
+	if (genl->cmd == DEVLINK_CMD_FLASH_UPDATE_END && ctx->not_first) {
+		pr_out("\n");
+		free(ctx->last_msg);
+		free(ctx->last_component);
+		ctx->received_end = 1;
+		return MNL_CB_STOP;
+	}
+
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG])
+		msg = mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG]);
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT])
+		component = mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT]);
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE])
+		done = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE]);
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL])
+		total = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL]);
+
+	if (!nullstrcmp(msg, ctx->last_msg) &&
+	    !nullstrcmp(component, ctx->last_component) &&
+	    ctx->last_pc && ctx->not_first) {
+		pr_out_tty("\b\b\b\b\b"); /* clean percentage */
+	} else {
+		if (ctx->not_first)
+			pr_out("\n");
+		if (component) {
+			pr_out("[%s] ", component);
+			free(ctx->last_component);
+			ctx->last_component = strdup(component);
+		}
+		if (msg) {
+			pr_out("%s", msg);
+			free(ctx->last_msg);
+			ctx->last_msg = strdup(msg);
+		}
+	}
+	if (total) {
+		pr_out_tty(" %3lu%%", (done * 100) / total);
+		ctx->last_pc = 1;
+	} else {
+		ctx->last_pc = 0;
+	}
+	fflush(stdout);
+	ctx->not_first = 1;
+
+	return MNL_CB_STOP;
+}
+
+static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
+				     struct mnlg_socket *nlg_ntf,
+				     int pipe_r)
+{
+	int nlfd = mnlg_socket_get_fd(nlg_ntf);
+	fd_set fds[3];
+	int fdmax;
+	int i;
+	int err;
+	int err2;
+
+	for (i = 0; i < 3; i++)
+		FD_ZERO(&fds[i]);
+	FD_SET(pipe_r, &fds[0]);
+	fdmax = pipe_r + 1;
+	FD_SET(nlfd, &fds[0]);
+	if (nlfd >= fdmax)
+		fdmax = nlfd + 1;
+
+	while (select(fdmax, &fds[0], &fds[1], &fds[2], NULL) < 0) {
+		if (errno == EINTR)
+			continue;
+		pr_err("select() failed\n");
+		return -errno;
+	}
+	if (FD_ISSET(nlfd, &fds[0])) {
+		err = _mnlg_socket_recv_run(nlg_ntf,
+					    cmd_dev_flash_status_cb, ctx);
+		if (err)
+			return err;
+	}
+	if (FD_ISSET(pipe_r, &fds[0])) {
+		err = read(pipe_r, &err2, sizeof(err2));
+		if (err == -1) {
+			pr_err("Failed to read pipe\n");
+			return -errno;
+		}
+		if (err2)
+			return err2;
+		ctx->flash_done = 1;
+	}
+	return 0;
+}
+
+
 static int cmd_dev_flash(struct dl *dl)
 {
+	struct cmd_dev_flash_status_ctx ctx = {.dl = dl,};
+	struct mnlg_socket *nlg_ntf;
 	struct nlmsghdr *nlh;
+	int pipe_r, pipe_w;
+	int pipe_fds[2];
+	pid_t pid;
 	int err;
 
 	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
@@ -2848,7 +3014,48 @@ static int cmd_dev_flash(struct dl *dl)
 	if (err)
 		return err;
 
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	nlg_ntf = mnlg_socket_open(DEVLINK_GENL_NAME, DEVLINK_GENL_VERSION);
+	if (!nlg_ntf)
+		return err;
+
+	err = _mnlg_socket_group_add(nlg_ntf, DEVLINK_GENL_MCGRP_CONFIG_NAME);
+	if (err)
+		return err;
+
+	err = pipe(pipe_fds);
+	if (err == -1)
+		return -errno;
+	pipe_r = pipe_fds[0];
+	pipe_w = pipe_fds[1];
+
+	pid = fork();
+	if (pid == -1) {
+		close(pipe_r);
+		close(pipe_w);
+		return -errno;
+	} else if (!pid) {
+		/* In child, just execute the flash and pass returned
+		 * value through pipe once it is done.
+		 */
+		close(pipe_r);
+		err = _mnlg_socket_send(dl->nlg, nlh);
+		write(pipe_w, &err, sizeof(err));
+		close(pipe_w);
+		exit(0);
+	}
+	close(pipe_w);
+
+	do {
+		err = cmd_dev_flash_fds_process(&ctx, nlg_ntf, pipe_r);
+		if (err)
+			goto out;
+	} while (!ctx.flash_done || (ctx.not_first && !ctx.received_end));
+
+	err = _mnlg_socket_recv_run(dl->nlg, NULL, NULL);
+out:
+	close(pipe_r);
+	mnlg_socket_close(nlg_ntf);
+	return err;
 }
 
 static int cmd_dev(struct dl *dl)
diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index ee125df042f0..c7d25e8713a1 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -320,3 +320,8 @@ void mnlg_socket_close(struct mnlg_socket *nlg)
 	free(nlg->buf);
 	free(nlg);
 }
+
+int mnlg_socket_get_fd(struct mnlg_socket *nlg)
+{
+	return mnl_socket_get_fd(nlg->nl);
+}
diff --git a/devlink/mnlg.h b/devlink/mnlg.h
index 4d1babf3b4c2..61bc5a3f31aa 100644
--- a/devlink/mnlg.h
+++ b/devlink/mnlg.h
@@ -23,5 +23,6 @@ int mnlg_socket_recv_run(struct mnlg_socket *nlg, mnl_cb_t data_cb, void *data);
 int mnlg_socket_group_add(struct mnlg_socket *nlg, const char *group_name);
 struct mnlg_socket *mnlg_socket_open(const char *family_name, uint8_t version);
 void mnlg_socket_close(struct mnlg_socket *nlg);
+int mnlg_socket_get_fd(struct mnlg_socket *nlg);
 
 #endif /* _MNLG_H_ */
diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 1804463b2321..1021ee8d064c 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -244,6 +244,17 @@ Sets the parameter internal_error_reset of specified devlink device to true.
 devlink dev reload pci/0000:01:00.0
 .RS 4
 Performs hot reload of specified devlink device.
+.RE
+.PP
+devlink dev flash pci/0000:01:00.0 file firmware.bin
+.RS 4
+Flashes the specified devlink device with provided firmware file name. If the driver supports it, user gets updates about the flash status. For example:
+.br
+Preparing to flash
+.br
+Flashing 100%
+.br
+Flashing done
 
 .SH SEE ALSO
 .BR devlink (8),
-- 
2.20.1


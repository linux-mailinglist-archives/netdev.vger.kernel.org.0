Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77816279A9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfEWJrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:47:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33036 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729863AbfEWJrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:47:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id d9so5536127wrx.0
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0VQMnZMOAnp0JU5L1hgvyx90p71jJ8VbfxYTGNaE6Sg=;
        b=H5dGy1UpeQlho05+utGgH85bqsoVE4GplNtA3IzocwWkDOyGgduym9WkwWgvPZfyun
         PWHdxMNdiM2RoNxVR5g8LeqzzbLODTIA3xg8MdzFB+smt/1zScOtZ/EU0aKC3vIDONy+
         kRSdoLHDKl6/tRQEgoPQYEUgVHVclnyFuAEnPZF0q4647mt/f01yYz8t5kF/Djp1+uZE
         rUIrVZGafS0F3Ejb3TPaI2LWwoyVRdCLq1wa+Hm9MI7k0HGmUMlZ9kdH2GGgB+FMyUri
         LAffDcMnUTThpAHvrTe8DQw4q2YEz/t9BvMR29G2MHLItTQAoVcM3FJ3+zN9ePdBr8dx
         d8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0VQMnZMOAnp0JU5L1hgvyx90p71jJ8VbfxYTGNaE6Sg=;
        b=OCP2HyjxKHhkMMpXJPLAc9DwTNaeIq4H62wgoolWg07LEqTldQttL0wh+le+vYJP+m
         6AGVqQZbU6DJoCGAONP6h0y/eXhgLwB6WeKhgZvCGuPd6kWjiKa9YexASBIF+096hVos
         EJwzRwEhyMCb9yv8fGkwN/Zu5J2lCtcN3rJesGptUQ0XFOQ0yVHu0f51kJNZYBx2xBTT
         xj/Emimh3TQts1TV4gzZQ5VPLzeRnxkBiiI8l/kc1+hnR9M3c3HrXhnFG9TGLLvFKE3P
         f9L8Pd6JMnNAG5eG73QGPvYw5+E5WC19k75L+qCZgbZQVZXX/HLp5dxTyucFka8e90vG
         Q8Hw==
X-Gm-Message-State: APjAAAUsSptlOspYE73flCNXghl4pJstxsW4bAX2Ypr3bi/HNiLrXY/N
        UqOyJ2Nb0JdwjlyJnYUpBBdQWostMnw=
X-Google-Smtp-Source: APXvYqydfwV+qANNSUbc1wqwZGQhfeNAAt7jeXJzM23cGQLszvMLT3G8fN3e55td2fiBUMw7Ezyqpg==
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr2014390wrm.228.1558604833388;
        Thu, 23 May 2019 02:47:13 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id n15sm29470627wru.67.2019.05.23.02.47.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:47:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch iproute2 3/3] devlink: implement flash status monitoring
Date:   Thu, 23 May 2019 11:47:10 +0200
Message-Id: <20190523094710.2410-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Listen to status notifications coming from kernel during flashing and
put them on stdout to inform user about the status.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 209 +++++++++++++++++++++++++++++++++++++++++++++-
 devlink/mnlg.c    |   5 ++
 devlink/mnlg.h    |   1 +
 3 files changed, 211 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 55cbc01189db..8078e8801e98 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -24,6 +24,7 @@
 #include <netinet/ether.h>
 #include <sys/sysinfo.h>
 #include <sys/queue.h>
+#include <sys/types.h>
 
 #include "SNAPSHOT.h"
 #include "list.h"
@@ -68,6 +69,12 @@ static int g_new_line_count;
 		g_new_line_count = 0;				\
 	} while (0)
 
+#define pr_out_tty(args...)					\
+	do {							\
+		if (isatty(STDOUT_FILENO))			\
+			fprintf(stdout, ##args);		\
+	} while (0)
+
 static int g_indent_level;
 static bool g_indent_newline;
 #define INDENT_STR_STEP 2
@@ -113,9 +120,8 @@ static int _mnlg_socket_recv_run(struct mnlg_socket *nlg,
 	return 0;
 }
 
-static int _mnlg_socket_sndrcv(struct mnlg_socket *nlg,
-			       const struct nlmsghdr *nlh,
-			       mnl_cb_t data_cb, void *data)
+static int _mnlg_socket_send(struct mnlg_socket *nlg,
+			     const struct nlmsghdr *nlh)
 {
 	int err;
 
@@ -124,6 +130,18 @@ static int _mnlg_socket_sndrcv(struct mnlg_socket *nlg,
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
 
@@ -2697,9 +2715,151 @@ static void cmd_dev_flash_help(void)
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
@@ -2715,7 +2875,48 @@ static int cmd_dev_flash(struct dl *dl)
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
+	} while (!ctx.flash_done || !ctx.received_end);
+
+	err = _mnlg_socket_recv_run(dl->nlg, NULL, NULL);
+out:
+	close(pipe_r);
+	mnlg_socket_close(nlg_ntf);
+	return err;
 }
 
 static int cmd_dev(struct dl *dl)
diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index 37cc25ddf490..f5a5dbe7f64f 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -313,3 +313,8 @@ void mnlg_socket_close(struct mnlg_socket *nlg)
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
-- 
2.17.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEC02C5BD
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfE1Lu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:50:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35877 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfE1Lu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:50:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id s17so19888341wru.3
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SCqGniy/1eCKsGcH2utQ3SjtKB3PXOqSnQDfZsw/Hz4=;
        b=LwsDWdQ4VlbGCB9UcsLohYpXzFIMY6/kV1w4Uz3kTCQPlPJLSA5FbsE5iRR7Oe8bok
         4DiVvxIRQ0gbAUJ8m55ZmI8FCK0B0ldIYlRIO9CkTsY98SK8OD1h1n2sOXtm/VWXfD/0
         RYOh8yF5WDyDbPW9A8bJ7hGMreQU4gxS8JAMPDKDnxUVF+MOIT15t/uj93MCmLqJ30LM
         byvyUQvbd331AxSioQrtPoIdh3rzNTv9tww+aA8pFNYcwDFRMBHA3a6nFNtorZoOkGGt
         hlCuQNnHMiMS4z8nT9yVlQQczZ8ezJbJ2ZnxbVrHWWw/qkOTbu/zmiZPfszGprwx3F1o
         Ws6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SCqGniy/1eCKsGcH2utQ3SjtKB3PXOqSnQDfZsw/Hz4=;
        b=C+73B3/ETw1HesvwOFGeXBT/wRUOf07ODEvPs09zRkqfnUnBnRBXwFvi9gwVgq7qWG
         bqDUT1I7vmdJQfJwUizSVfmblFyzrUOAp9Qmay/DjkQpZ0tq9CayjCHW6WIipoyjcQmI
         uU0Ko5q3gJQMpqQzmJwKOukp2fC714wFob4ocH/thX0SS/Ulgi/U4fvM+L+nIZrKbSQU
         /Uk7Kll8TrCwAM5X87RF1oJwzNxtKsT8NZxaqoZMnzUjs8CtmNPy1TFBmzDnddUrQX8e
         DZggqBJbQeqGz2dEM3lt1x1VqQWJvsXhLJdTZaon0Jm6Ji124cIZroJeyIL126ZkyE+E
         mufA==
X-Gm-Message-State: APjAAAU2qfDgRrVJWn5xRac4p7iQeu72/cRRJwS9/sgJ5F1hLlszyrov
        5RMkQIUpOSyOouY4lSIosY6vCgqrpG4=
X-Google-Smtp-Source: APXvYqwOlL7A03i1heQVHGOuTx1iCrVsSzR3tNh8J/8QLMFnGs7sUkxd9AJ7UKL0igEGXnFBVoDINg==
X-Received: by 2002:a5d:6588:: with SMTP id q8mr32793884wru.259.1559044224678;
        Tue, 28 May 2019 04:50:24 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id u11sm11366895wrn.1.2019.05.28.04.50.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:50:24 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 3/3] devlink: implement flash status monitoring
Date:   Tue, 28 May 2019 13:50:21 +0200
Message-Id: <20190528115021.2063-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190528114846.1983-1-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Listen to status notifications coming from kernel during flashing and
put them on stdout to inform user about the status.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- fixed endless loop bug in case of no notifications
---
 devlink/devlink.c | 209 +++++++++++++++++++++++++++++++++++++++++++++-
 devlink/mnlg.c    |   5 ++
 devlink/mnlg.h    |   1 +
 3 files changed, 211 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 55cbc01189db..05514312782a 100644
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


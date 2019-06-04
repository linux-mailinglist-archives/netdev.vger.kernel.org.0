Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CAB3493E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfFDNo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:44:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38988 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfFDNo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:44:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so108715wma.4
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=okPp00jm/HPoUZy4SWRj1TaD0n47SYuTK3nc70gmyGM=;
        b=FtBc5N/CkBukpLZ+eakp10hAkcVj3c9GUqGAzTI2zFmjkR6mRLKPHwcE2jjZt8geNN
         qaCGWx1ZdKUN0SOJJpNxsLdcKgTr/VMK+vaYtdZ/EAMoz7ai6H0KjHDEMZ8GTDPkHK+6
         wMDyLG63//kKdnGAJVc6aiZi4Lvb9Mon/Jm5WdTbqEQowweRxsEBkPxB2OhrBxb5DJuO
         0IxbLL0Hima6rbSnsvdfZrfFC2p9V51BlUID+oFKId+3P/2dbFx6hy7UelXG34cB3/8C
         4aaxyB/d11YdlM4XGWxa07luagwifq7A5NPH75wF6hANLCmPIlEyMaKc67wqhnqDk1he
         SFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=okPp00jm/HPoUZy4SWRj1TaD0n47SYuTK3nc70gmyGM=;
        b=VxBEAl4gZuZjJlD3Yf+sU/1ETcn5CRGrD1zfn/pLtwywGmXqab+sbxtXD9a9/BxWBZ
         geCananpGfu2R5NITIj1LsDeX6G5rueIHoixfxSYM0GLdX3uGdCvI8rd36sZXeioYkiU
         1tZnUPSi1en8dW6uF5fpAtTsBFPjbDzcUnKjHshatabOU+q00xOPMd6zKvBYmHbWElDZ
         wQZqopxKVLzv9nkwrxqQuJlKzrK14ONtOq09qhRjPXd08Sczk4rbcyvLt4hXFO4l2J20
         OgPIZya12VLjhGsgo0+KcDrJq+ODKINYdalKxIQDwAhfpgZ8+Y/QYjYR9ENmHZvfdAT8
         SJ/Q==
X-Gm-Message-State: APjAAAWWSQW9I9dMTT/V5IIUSXeWa5NsRzHf78FeA3jB2OkYk90V+dTm
        gC/wgIQV27SDm9MurwLhSETvhQmVg9+viA==
X-Google-Smtp-Source: APXvYqwUMRPS07/KnfcALEY69QURDC1jAmu43aCJZutm1y8/qfMxTk+bc2pkCjDu8Yu+RpSywkk+dA==
X-Received: by 2002:a7b:c444:: with SMTP id l4mr6389763wmi.15.1559655893014;
        Tue, 04 Jun 2019 06:44:53 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id n1sm15133530wrx.39.2019.06.04.06.44.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:44:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 3/3] devlink: implement flash status monitoring
Date:   Tue,  4 Jun 2019 15:44:50 +0200
Message-Id: <20190604134450.2839-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Listen to status notifications coming from kernel during flashing and
put them on stdout to inform user about the status.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- added example in man
v1->v2:
- fixed endless loop bug in case of no notifications
---
 devlink/devlink.c      | 209 ++++++++++++++++++++++++++++++++++++++++-
 devlink/mnlg.c         |   5 +
 devlink/mnlg.h         |   1 +
 man/man8/devlink-dev.8 |  11 +++
 4 files changed, 222 insertions(+), 4 deletions(-)

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
2.17.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61510327CB8
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhCAK7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:59:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13207 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbhCAK5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:57:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603cc8850003>; Mon, 01 Mar 2021 02:57:09 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Mar
 2021 10:57:08 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next 3/4] devlink: Use generic socket helpers from library
Date:   Mon, 1 Mar 2021 12:56:53 +0200
Message-ID: <20210301105654.291949-4-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301105654.291949-1-parav@nvidia.com>
References: <20210301105654.291949-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614596230; bh=nWXkZ8/WYFteUvDVj+xVKbMTJCWCqXaUBrt/jBIfbfk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=azdlsbrt07tGDtL04vg5X0l69Sn0JVejvnOITeqw2qJ4P0sFLoDJMnfCFEuygkI8O
         t3QOWVjiKfkTL2dLooAXMT3Q0zYG7SF6UAFfZt5CGL8OzyQujr3B091coc84ac3xHN
         YzU5ZaYqqPhUWltcoSN1luyJk8XwHG1NOcv+9PwYW4TR4pkik2/smy/dRU+NtXF8xX
         juKe/vO4zjSAu9KbN27IdlORmbIfc2ZCzO0kWmd9v2oVYeQI1ouaLkj3wFbiySe96z
         Aq2EXX454lkoak/8+u+N/xnkAaIMidnPxrt4zjHvoMZrB/9Wruq+oPAQMEsyRUVa3n
         Jrkd8Zr5Idlog==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User generic socket helpers from library for netlink generic socket
access.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 314 ++++++++++++++++++++++------------------------
 devlink/mnlg.c    | 121 ++----------------
 devlink/mnlg.h    |  13 +-
 3 files changed, 161 insertions(+), 287 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 85f90baf..eaac1806 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -39,6 +39,7 @@
 #include "version.h"
 #include "list.h"
 #include "mnlg.h"
+#include "mnl_utils.h"
 #include "json_print.h"
 #include "utils.h"
 #include "namespace.h"
@@ -148,24 +149,11 @@ static void __pr_out_newline(void)
 	g_new_line_count++;
 }
=20
-static int _mnlg_socket_recv_run(struct mnlg_socket *nlg,
-				 mnl_cb_t data_cb, void *data)
-{
-	int err;
-
-	err =3D mnlg_socket_recv_run(nlg, data_cb, data);
-	if (err < 0) {
-		pr_err("devlink answers: %s\n", strerror(errno));
-		return -errno;
-	}
-	return 0;
-}
-
 static void dummy_signal_handler(int signum)
 {
 }
=20
-static int _mnlg_socket_recv_run_intr(struct mnlg_socket *nlg,
+static int _mnlg_socket_recv_run_intr(struct mnlu_gen_socket *nlg,
 				      mnl_cb_t data_cb, void *data)
 {
 	struct sigaction act, oact;
@@ -176,7 +164,7 @@ static int _mnlg_socket_recv_run_intr(struct mnlg_socke=
t *nlg,
 	act.sa_flags =3D SA_NODEFER;
=20
 	sigaction(SIGINT, &act, &oact);
-	err =3D mnlg_socket_recv_run(nlg, data_cb, data);
+	err =3D mnlu_gen_socket_recv_run(nlg, data_cb, data);
 	sigaction(SIGINT, &oact, NULL);
 	if (err < 0 && errno !=3D EINTR) {
 		pr_err("devlink answers: %s\n", strerror(errno));
@@ -185,7 +173,7 @@ static int _mnlg_socket_recv_run_intr(struct mnlg_socke=
t *nlg,
 	return 0;
 }
=20
-static int _mnlg_socket_send(struct mnlg_socket *nlg,
+static int _mnlg_socket_send(struct mnlu_gen_socket *nlg,
 			     const struct nlmsghdr *nlh)
 {
 	int err;
@@ -198,19 +186,7 @@ static int _mnlg_socket_send(struct mnlg_socket *nlg,
 	return 0;
 }
=20
-static int _mnlg_socket_sndrcv(struct mnlg_socket *nlg,
-			       const struct nlmsghdr *nlh,
-			       mnl_cb_t data_cb, void *data)
-{
-	int err;
-
-	err =3D _mnlg_socket_send(nlg, nlh);
-	if (err)
-		return err;
-	return _mnlg_socket_recv_run(nlg, data_cb, data);
-}
-
-static int _mnlg_socket_group_add(struct mnlg_socket *nlg,
+static int _mnlg_socket_group_add(struct mnlu_gen_socket *nlg,
 				  const char *group_name)
 {
 	int err;
@@ -367,7 +343,7 @@ struct dl_opts {
 };
=20
 struct dl {
-	struct mnlg_socket *nlg;
+	struct mnlu_gen_socket nlg;
 	struct list_head ifname_map_list;
 	int argc;
 	char **argv;
@@ -821,10 +797,11 @@ static int ifname_map_init(struct dl *dl)
=20
 	INIT_LIST_HEAD(&dl->ifname_map_list);
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_GET,
+
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
=20
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, ifname_map_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, ifname_map_cb, dl);
 	if (err) {
 		ifname_map_fini(dl);
 		return err;
@@ -2550,7 +2527,7 @@ static int cmd_dev_eswitch_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_ESWITCH_GET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_ESWITCH_GET,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
@@ -2558,7 +2535,7 @@ static int cmd_dev_eswitch_show(struct dl *dl)
 		return err;
=20
 	pr_out_section_start(dl, "dev");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dev_eswitch_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_eswitch_show_cb, dl=
);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -2568,7 +2545,7 @@ static int cmd_dev_eswitch_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_ESWITCH_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_ESWITCH_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE,
@@ -2584,7 +2561,7 @@ static int cmd_dev_eswitch_set(struct dl *dl)
 		return -ENOENT;
 	}
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_dev_eswitch(struct dl *dl)
@@ -2948,16 +2925,16 @@ static int cmd_dev_param_set(struct dl *dl)
 		return err;
=20
 	/* Get value type */
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PARAM_GET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PARAM_GET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 	dl_opts_put(nlh, dl);
=20
 	ctx.dl =3D dl;
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dev_param_set_cb, &ctx);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_param_set_cb, &ctx)=
;
 	if (err)
 		return err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PARAM_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PARAM_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 	dl_opts_put(nlh, dl);
=20
@@ -3035,7 +3012,7 @@ static int cmd_dev_param_set(struct dl *dl)
 		printf("Value type not supported\n");
 		return -ENOTSUP;
 	}
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
=20
 err_param_value_parse:
 	pr_err("Value \"%s\" is not a number or not within range\n",
@@ -3067,7 +3044,7 @@ static int cmd_dev_param_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PARAM_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PARAM_GET, flag=
s);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE |
@@ -3077,7 +3054,7 @@ static int cmd_dev_param_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "param");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dev_param_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_param_show_cb, dl);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -3223,7 +3200,7 @@ static int cmd_dev_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_GET, flags);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
@@ -3232,7 +3209,7 @@ static int cmd_dev_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "dev");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dev_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_show_cb, dl);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -3298,7 +3275,7 @@ static int cmd_dev_reload(struct dl *dl)
 		return 0;
 	}
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_RELOAD,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RELOAD,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE,
@@ -3307,7 +3284,7 @@ static int cmd_dev_reload(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dev_reload_cb, dl);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_reload_cb, dl);
 }
=20
 static void pr_out_versions_single(struct dl *dl, const struct nlmsghdr *n=
lh,
@@ -3443,7 +3420,7 @@ static int cmd_dev_info(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_INFO_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_INFO_GET, flags=
);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
@@ -3452,7 +3429,7 @@ static int cmd_dev_info(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "info");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_versions_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_versions_show_cb, dl);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -3637,7 +3614,7 @@ static void cmd_dev_flash_time_elapsed(struct cmd_dev=
_flash_status_ctx *ctx)
 }
=20
 static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
-				     struct mnlg_socket *nlg_ntf,
+				     struct mnlu_gen_socket *nlg_ntf,
 				     int pipe_r)
 {
 	int nlfd =3D mnlg_socket_get_fd(nlg_ntf);
@@ -3670,8 +3647,8 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_f=
lash_status_ctx *ctx,
 		return -errno;
 	}
 	if (FD_ISSET(nlfd, &fds[0])) {
-		err =3D _mnlg_socket_recv_run(nlg_ntf,
-					    cmd_dev_flash_status_cb, ctx);
+		err =3D mnlu_gen_socket_recv_run(nlg_ntf,
+					       cmd_dev_flash_status_cb, ctx);
 		if (err)
 			return err;
 	}
@@ -3693,7 +3670,7 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_f=
lash_status_ctx *ctx,
 static int cmd_dev_flash(struct dl *dl)
 {
 	struct cmd_dev_flash_status_ctx ctx =3D {.dl =3D dl,};
-	struct mnlg_socket *nlg_ntf;
+	struct mnlu_gen_socket nlg_ntf;
 	struct nlmsghdr *nlh;
 	int pipe_r, pipe_w;
 	int pipe_fds[2];
@@ -3705,7 +3682,7 @@ static int cmd_dev_flash(struct dl *dl)
 		return 0;
 	}
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_FLASH_UPDATE,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_FLASH_UPDATE,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME=
,
@@ -3713,11 +3690,12 @@ static int cmd_dev_flash(struct dl *dl)
 	if (err)
 		return err;
=20
-	nlg_ntf =3D mnlg_socket_open(DEVLINK_GENL_NAME, DEVLINK_GENL_VERSION);
-	if (!nlg_ntf)
+	err =3D mnlu_gen_socket_open(&nlg_ntf, DEVLINK_GENL_NAME,
+				   DEVLINK_GENL_VERSION);
+	if (err)
 		return err;
=20
-	err =3D _mnlg_socket_group_add(nlg_ntf, DEVLINK_GENL_MCGRP_CONFIG_NAME);
+	err =3D _mnlg_socket_group_add(&nlg_ntf, DEVLINK_GENL_MCGRP_CONFIG_NAME);
 	if (err)
 		goto err_socket;
=20
@@ -3741,7 +3719,7 @@ static int cmd_dev_flash(struct dl *dl)
 		int cc;
=20
 		close(pipe_r);
-		err =3D _mnlg_socket_send(dl->nlg, nlh);
+		err =3D _mnlg_socket_send(&dl->nlg, nlh);
 		cc =3D write(pipe_w, &err, sizeof(err));
 		close(pipe_w);
 		exit(cc !=3D sizeof(err));
@@ -3754,16 +3732,17 @@ static int cmd_dev_flash(struct dl *dl)
 	clock_gettime(CLOCK_MONOTONIC, &ctx.time_of_last_status);
=20
 	do {
-		err =3D cmd_dev_flash_fds_process(&ctx, nlg_ntf, pipe_r);
+		err =3D cmd_dev_flash_fds_process(&ctx, &nlg_ntf, pipe_r);
 		if (err)
 			goto out;
 	} while (!ctx.flash_done || (ctx.not_first && !ctx.received_end));
=20
-	err =3D _mnlg_socket_recv_run(dl->nlg, NULL, NULL);
+	err =3D mnlu_gen_socket_recv_run(&dl->nlg, NULL, NULL);
+
 out:
 	close(pipe_r);
 err_socket:
-	mnlg_socket_close(nlg_ntf);
+	mnlu_gen_socket_close(&nlg_ntf);
 	return err;
 }
=20
@@ -4008,7 +3987,7 @@ static int cmd_port_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET, flags=
);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP, 0);
@@ -4017,7 +3996,7 @@ static int cmd_port_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "port");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_port_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_port_show_cb, dl);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -4027,14 +4006,14 @@ static int cmd_port_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_PORT_TYPE, 0);
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_port_split(struct dl *dl)
@@ -4042,14 +4021,14 @@ static int cmd_port_split(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_SPLIT,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_SPLIT,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_PORT_COUNT, 0)=
;
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_port_unsplit(struct dl *dl)
@@ -4057,14 +4036,14 @@ static int cmd_port_unsplit(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_UNSPLIT,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_UNSPLIT,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP, 0);
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_port_param_show(struct dl *dl)
@@ -4076,7 +4055,8 @@ static int cmd_port_param_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_PARAM_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_PARAM_GET,
+					  flags);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP |
@@ -4086,7 +4066,7 @@ static int cmd_port_param_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "param");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_port_param_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_port_param_show_cb, dl)=
;
 	pr_out_section_end(dl);
=20
 	return err;
@@ -4106,14 +4086,15 @@ static int cmd_port_function_set(struct dl *dl)
 		cmd_port_function_help();
 		return 0;
 	}
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_SET, NLM_F_REQUEST | N=
LM_F_ACK);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_SET,
+					  NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP,
 				DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE);
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_port_param_set_cb(const struct nlmsghdr *nlh, void *data)
@@ -4203,17 +4184,17 @@ static int cmd_port_param_set(struct dl *dl)
 		return err;
=20
 	/* Get value type */
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_PARAM_GET,
-			       NLM_F_REQUEST | NLM_F_ACK);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_PARAM_GET,
+					  NLM_F_REQUEST | NLM_F_ACK);
 	dl_opts_put(nlh, dl);
=20
 	ctx.dl =3D dl;
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_port_param_set_cb, &ctx);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_port_param_set_cb, &ctx=
);
 	if (err)
 		return err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_PARAM_SET,
-			       NLM_F_REQUEST | NLM_F_ACK);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_PARAM_SET,
+					  NLM_F_REQUEST | NLM_F_ACK);
 	dl_opts_put(nlh, dl);
=20
 	conv_exists =3D param_val_conv_exists(param_val_conv, PARAM_VAL_CONV_LEN,
@@ -4290,7 +4271,7 @@ static int cmd_port_param_set(struct dl *dl)
 		printf("Value type not supported\n");
 		return -ENOTSUP;
 	}
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
=20
 err_param_value_parse:
 	pr_err("Value \"%s\" is not a number or not within range\n",
@@ -4346,8 +4327,8 @@ static int cmd_port_add(struct dl *dl)
 		return 0;
 	}
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_NEW,
-			       NLM_F_REQUEST | NLM_F_ACK);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_NEW,
+					  NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
 				DL_OPT_PORT_FLAVOUR | DL_OPT_PORT_PFNUMBER,
@@ -4355,7 +4336,7 @@ static int cmd_port_add(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_port_show_cb, dl);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_port_show_cb, dl);
 }
=20
 static void cmd_port_del_help(void)
@@ -4373,14 +4354,14 @@ static int cmd_port_del(struct dl *dl)
 		return 0;
 	}
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_DEL,
-			       NLM_F_REQUEST | NLM_F_ACK);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_DEL,
+					  NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP, 0);
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_port(struct dl *dl)
@@ -4494,7 +4475,7 @@ static int cmd_sb_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_GET, flags);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SB);
@@ -4503,7 +4484,7 @@ static int cmd_sb_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "sb");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_sb_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_sb_show_cb, dl);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -4571,7 +4552,7 @@ static int cmd_sb_pool_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_POOL_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_POOL_GET, fl=
ags);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_SB_POOL,
@@ -4581,7 +4562,7 @@ static int cmd_sb_pool_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "pool");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_sb_pool_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_sb_pool_show_cb, dl);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -4591,7 +4572,7 @@ static int cmd_sb_pool_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_POOL_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_POOL_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_SB_POOL |
@@ -4599,7 +4580,7 @@ static int cmd_sb_pool_set(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_sb_pool(struct dl *dl)
@@ -4656,7 +4637,7 @@ static int cmd_sb_port_pool_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_PORT_POOL_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_PORT_POOL_GE=
T, flags);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl,
@@ -4667,7 +4648,7 @@ static int cmd_sb_port_pool_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "port_pool");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_sb_port_pool_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_sb_port_pool_show_cb, d=
l);
 	pr_out_section_end(dl);
 	return 0;
 }
@@ -4677,7 +4658,7 @@ static int cmd_sb_port_pool_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_PORT_POOL_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_PORT_POOL_SE=
T,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_SB_POOL |
@@ -4685,7 +4666,7 @@ static int cmd_sb_port_pool_set(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_sb_port_pool(struct dl *dl)
@@ -4760,7 +4741,7 @@ static int cmd_sb_tc_bind_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND_GET, flags)=
;
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND=
_GET, flags);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_SB_TC |
@@ -4770,7 +4751,7 @@ static int cmd_sb_tc_bind_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "tc_bind");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_sb_tc_bind_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_sb_tc_bind_show_cb, dl)=
;
 	pr_out_section_end(dl);
 	return err;
 }
@@ -4780,7 +4761,7 @@ static int cmd_sb_tc_bind_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND=
_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_SB_TC |
@@ -4789,7 +4770,7 @@ static int cmd_sb_tc_bind_set(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_sb_tc_bind(struct dl *dl)
@@ -5106,16 +5087,16 @@ static int cmd_sb_occ_show(struct dl *dl)
 	if (!occ_show)
 		return -ENOMEM;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_PORT_POOL_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_PORT_POOL_GE=
T, flags);
=20
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh,
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh,
 				  cmd_sb_occ_port_pool_process_cb, occ_show);
 	if (err)
 		goto out;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND_GET, flags)=
;
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND=
_GET, flags);
=20
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh,
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh,
 				  cmd_sb_occ_tc_pool_process_cb, occ_show);
 	if (err)
 		goto out;
@@ -5134,14 +5115,14 @@ static int cmd_sb_occ_snapshot(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_OCC_SNAPSHOT,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_OCC_SNAPSHOT=
,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SB);
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_sb_occ_clearmax(struct dl *dl)
@@ -5149,14 +5130,14 @@ static int cmd_sb_occ_clearmax(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SB_OCC_MAX_CLEAR,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_OCC_MAX_CLEA=
R,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SB);
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_sb_occ(struct dl *dl)
@@ -5513,12 +5494,12 @@ static int cmd_mon_show(struct dl *dl)
 			return -EINVAL;
 		}
 	}
-	err =3D _mnlg_socket_group_add(dl->nlg, DEVLINK_GENL_MCGRP_CONFIG_NAME);
+	err =3D _mnlg_socket_group_add(&dl->nlg, DEVLINK_GENL_MCGRP_CONFIG_NAME);
 	if (err)
 		return err;
 	open_json_object(NULL);
 	open_json_array(PRINT_JSON, "mon");
-	err =3D _mnlg_socket_recv_run_intr(dl->nlg, cmd_mon_show_cb, dl);
+	err =3D _mnlg_socket_recv_run_intr(&dl->nlg, cmd_mon_show_cb, dl);
 	close_json_array(PRINT_JSON, NULL);
 	close_json_object();
 	if (err)
@@ -6034,7 +6015,7 @@ static int cmd_dpipe_headers_show(struct dl *dl)
 	uint16_t flags =3D NLM_F_REQUEST | NLM_F_ACK;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_DPIPE_HEADERS_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_HEADERS_G=
ET, flags);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
 	if (err)
@@ -6047,7 +6028,7 @@ static int cmd_dpipe_headers_show(struct dl *dl)
 	ctx.print_headers =3D true;
=20
 	pr_out_section_start(dl, "header");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dpipe_header_cb, &ctx);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dpipe_header_cb, &ctx);
 	if (err)
 		pr_err("error get headers %s\n", strerror(ctx.err));
 	pr_out_section_end(dl);
@@ -6436,7 +6417,7 @@ static int cmd_dpipe_table_show(struct dl *dl)
 	if (err)
 		return err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_DPIPE_HEADERS_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_HEADERS_G=
ET, flags);
=20
 	err =3D dpipe_ctx_init(&dpipe_ctx, dl);
 	if (err)
@@ -6445,7 +6426,7 @@ static int cmd_dpipe_table_show(struct dl *dl)
 	dpipe_ctx.print_tables =3D true;
=20
 	dl_opts_put(nlh, dl);
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dpipe_header_cb,
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dpipe_header_cb,
 				  &dpipe_ctx);
 	if (err) {
 		pr_err("error get headers %s\n", strerror(dpipe_ctx.err));
@@ -6457,19 +6438,19 @@ static int cmd_dpipe_table_show(struct dl *dl)
 		goto err_resource_ctx_init;
=20
 	resource_ctx.print_resources =3D false;
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_RESOURCE_DUMP, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RESOURCE_DUMP, =
flags);
 	dl_opts_put(nlh, dl);
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_resource_dump_cb,
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_resource_dump_cb,
 				  &resource_ctx);
 	if (!err)
 		dpipe_ctx.resources =3D resource_ctx.resources;
=20
 	flags =3D NLM_F_REQUEST | NLM_F_ACK;
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_DPIPE_TABLE_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_TABLE_GET=
, flags);
 	dl_opts_put(nlh, dl);
=20
 	pr_out_section_start(dl, "table");
-	_mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dpipe_table_show_cb, &dpipe_ctx);
+	mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dpipe_table_show_cb, &dpipe_ctx=
);
 	pr_out_section_end(dl);
=20
 	resource_ctx_fini(&resource_ctx);
@@ -6487,7 +6468,7 @@ static int cmd_dpipe_table_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_DPIPE_TABLE_COUNTERS_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_TABLE_COU=
NTERS_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl,
@@ -6496,7 +6477,7 @@ static int cmd_dpipe_table_set(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 enum dpipe_value_type {
@@ -6864,20 +6845,20 @@ static int cmd_dpipe_table_dump(struct dl *dl)
 	if (err)
 		goto out;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_DPIPE_HEADERS_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_HEADERS_G=
ET, flags);
 	dl_opts_put(nlh, dl);
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dpipe_header_cb, &ctx);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dpipe_header_cb, &ctx);
 	if (err) {
 		pr_err("error get headers %s\n", strerror(ctx.err));
 		goto out;
 	}
=20
 	flags =3D NLM_F_REQUEST | NLM_F_ACK;
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_DPIPE_ENTRIES_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_ENTRIES_G=
ET, flags);
 	dl_opts_put(nlh, dl);
=20
 	pr_out_section_start(dl, "table_entry");
-	_mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dpipe_table_entry_dump_cb, &ctx);
+	mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dpipe_table_entry_dump_cb, &ctx=
);
 	pr_out_section_end(dl);
 out:
 	dpipe_ctx_fini(&ctx);
@@ -7141,7 +7122,7 @@ static int cmd_resource_show(struct dl *dl)
 	if (err)
 		return err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_DPIPE_TABLE_GET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_TABLE_GET=
,
 			       NLM_F_REQUEST);
 	dl_opts_put(nlh, dl);
=20
@@ -7149,7 +7130,7 @@ static int cmd_resource_show(struct dl *dl)
 	if (err)
 		return err;
=20
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dpipe_table_show_cb,
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dpipe_table_show_cb,
 				  &dpipe_ctx);
 	if (err) {
 		pr_err("error get tables %s\n", strerror(dpipe_ctx.err));
@@ -7162,11 +7143,11 @@ static int cmd_resource_show(struct dl *dl)
=20
 	resource_ctx.print_resources =3D true;
 	resource_ctx.tables =3D dpipe_ctx.tables;
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_RESOURCE_DUMP,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RESOURCE_DUMP,
 			       NLM_F_REQUEST | NLM_F_ACK);
 	dl_opts_put(nlh, dl);
 	pr_out_section_start(dl, "resources");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_resource_dump_cb,
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_resource_dump_cb,
 				  &resource_ctx);
 	pr_out_section_end(dl);
 	resource_ctx_fini(&resource_ctx);
@@ -7242,10 +7223,10 @@ static int cmd_resource_set(struct dl *dl)
 	if (err)
 		goto out;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_RESOURCE_DUMP,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RESOURCE_DUMP,
 			       NLM_F_REQUEST);
 	dl_opts_put(nlh, dl);
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_resource_dump_cb, &ctx);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_resource_dump_cb, &ctx)=
;
 	if (err) {
 		pr_err("error getting resources %s\n", strerror(ctx.err));
 		goto out;
@@ -7259,11 +7240,11 @@ static int cmd_resource_set(struct dl *dl)
 		goto out;
 	}
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_RESOURCE_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RESOURCE_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	dl_opts_put(nlh, dl);
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 out:
 	resource_ctx_fini(&ctx);
 	return err;
@@ -7404,7 +7385,7 @@ static int cmd_region_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_GET, fla=
gs);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION, 0);
@@ -7413,7 +7394,7 @@ static int cmd_region_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "regions");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_region_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_region_show_cb, dl);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -7423,7 +7404,7 @@ static int cmd_region_snapshot_del(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_DEL,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_DEL,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
@@ -7431,7 +7412,7 @@ static int cmd_region_snapshot_del(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_region_read_cb(const struct nlmsghdr *nlh, void *data)
@@ -7473,7 +7454,7 @@ static int cmd_region_dump(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_READ,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_READ,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
@@ -7482,7 +7463,7 @@ static int cmd_region_dump(struct dl *dl)
 		return err;
=20
 	pr_out_section_start(dl, "dump");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_region_read_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_region_read_cb, dl);
 	pr_out_section_end(dl);
 	if (!dl->json_output)
 		pr_out("\n");
@@ -7494,7 +7475,7 @@ static int cmd_region_read(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_READ,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_READ,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
@@ -7504,7 +7485,7 @@ static int cmd_region_read(struct dl *dl)
 		return err;
=20
 	pr_out_section_start(dl, "read");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_region_read_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_region_read_cb, dl);
 	pr_out_section_end(dl);
 	if (!dl->json_output)
 		pr_out("\n");
@@ -7533,7 +7514,7 @@ static int cmd_region_snapshot_new(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_NEW,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_NEW,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION,
@@ -7542,7 +7523,7 @@ static int cmd_region_snapshot_new(struct dl *dl)
 		return err;
=20
 	pr_out_section_start(dl, "regions");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_region_snapshot_new_cb, dl)=
;
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_region_snapshot_new_cb,=
 dl);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -7588,7 +7569,7 @@ static int cmd_health_set_params(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER=
_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 	err =3D dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_=
REPORTER_NAME,
 			    DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD |
@@ -7598,7 +7579,7 @@ static int cmd_health_set_params(struct dl *dl)
 		return err;
=20
 	dl_opts_put(nlh, dl);
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_health_dump_clear(struct dl *dl)
@@ -7606,7 +7587,7 @@ static int cmd_health_dump_clear(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER=
_DUMP_CLEAR,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl,
@@ -7616,7 +7597,7 @@ static int cmd_health_dump_clear(struct dl *dl)
 		return err;
=20
 	dl_opts_put(nlh, dl);
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data=
)
@@ -7855,7 +7836,7 @@ static int cmd_health_object_common(struct dl *dl, ui=
nt8_t cmd, uint16_t flags)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, cmd, flags | NLM_F_REQUEST | NLM_F_ACK)=
;
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, cmd, flags | NLM_F_REQUEST =
| NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl,
 				DL_OPT_HANDLE | DL_OPT_HANDLEP |
@@ -7864,7 +7845,7 @@ static int cmd_health_object_common(struct dl *dl, ui=
nt8_t cmd, uint16_t flags)
 		return err;
=20
 	cmd_fmsg_init(dl, &data);
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_fmsg_object_cb, &data);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_fmsg_object_cb, &data);
 	free(data.name);
 	return err;
 }
@@ -7895,7 +7876,7 @@ static int cmd_health_recover(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_RECOVER,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER=
_RECOVER,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl,
@@ -7905,7 +7886,7 @@ static int cmd_health_recover(struct dl *dl)
 		return err;
=20
 	dl_opts_put(nlh, dl);
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 enum devlink_health_reporter_state {
@@ -8071,7 +8052,7 @@ static int __cmd_health_show(struct dl *dl, bool show=
_device, bool show_port)
=20
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_GET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER=
_GET,
 			       flags);
=20
 	if (dl_argc(dl) > 0) {
@@ -8084,7 +8065,7 @@ static int __cmd_health_show(struct dl *dl, bool show=
_device, bool show_port)
 	}
 	pr_out_section_start(dl, "health");
=20
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_health_show_cb, &ctx);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_health_show_cb, &ctx);
 	pr_out_section_end(dl);
 	return err;
 }
@@ -8253,7 +8234,7 @@ static int cmd_trap_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GET, flags=
);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl,
@@ -8263,7 +8244,7 @@ static int cmd_trap_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "trap");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_trap_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_trap_show_cb, dl);
 	pr_out_section_end(dl);
=20
 	return err;
@@ -8274,7 +8255,7 @@ static int cmd_trap_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_TRAP_NAME,
@@ -8282,7 +8263,7 @@ static int cmd_trap_set(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool arra=
y)
@@ -8328,7 +8309,7 @@ static int cmd_trap_group_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_GROUP_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GROUP_GET,=
 flags);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl,
@@ -8339,7 +8320,7 @@ static int cmd_trap_group_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "trap_group");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_trap_group_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_trap_group_show_cb, dl)=
;
 	pr_out_section_end(dl);
=20
 	return err;
@@ -8350,7 +8331,7 @@ static int cmd_trap_group_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_GROUP_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GROUP_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl,
@@ -8359,7 +8340,7 @@ static int cmd_trap_group_set(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_trap_group(struct dl *dl)
@@ -8425,7 +8406,7 @@ static int cmd_trap_policer_show(struct dl *dl)
 	if (dl_argc(dl) =3D=3D 0)
 		flags |=3D NLM_F_DUMP;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_POLICER_GET, flags);
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_POLICER_GE=
T, flags);
=20
 	if (dl_argc(dl) > 0) {
 		err =3D dl_argv_parse_put(nlh, dl,
@@ -8436,7 +8417,7 @@ static int cmd_trap_policer_show(struct dl *dl)
 	}
=20
 	pr_out_section_start(dl, "trap_policer");
-	err =3D _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_trap_policer_show_cb, dl);
+	err =3D mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_trap_policer_show_cb, d=
l);
 	pr_out_section_end(dl);
=20
 	return err;
@@ -8447,7 +8428,7 @@ static int cmd_trap_policer_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
=20
-	nlh =3D mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_POLICER_SET,
+	nlh =3D mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_POLICER_SE=
T,
 			       NLM_F_REQUEST | NLM_F_ACK);
=20
 	err =3D dl_argv_parse_put(nlh, dl,
@@ -8457,7 +8438,7 @@ static int cmd_trap_policer_set(struct dl *dl)
 	if (err)
 		return err;
=20
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
=20
 static int cmd_trap_policer(struct dl *dl)
@@ -8552,8 +8533,9 @@ static int dl_init(struct dl *dl)
 {
 	int err;
=20
-	dl->nlg =3D mnlg_socket_open(DEVLINK_GENL_NAME, DEVLINK_GENL_VERSION);
-	if (!dl->nlg) {
+	err =3D mnlu_gen_socket_open(&dl->nlg, DEVLINK_GENL_NAME,
+				   DEVLINK_GENL_VERSION);
+	if (err) {
 		pr_err("Failed to connect to devlink Netlink\n");
 		return -errno;
 	}
@@ -8567,7 +8549,7 @@ static int dl_init(struct dl *dl)
 	return 0;
=20
 err_ifname_map_create:
-	mnlg_socket_close(dl->nlg);
+	mnlu_gen_socket_close(&dl->nlg);
 	return err;
 }
=20
@@ -8575,7 +8557,7 @@ static void dl_fini(struct dl *dl)
 {
 	delete_json_obj_plain();
 	ifname_map_fini(dl);
-	mnlg_socket_close(dl->nlg);
+	mnlu_gen_socket_close(&dl->nlg);
 }
=20
 static struct dl *dl_alloc(void)
diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index 21b10c5a..e6d92742 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -30,38 +30,11 @@ struct mnlg_socket {
 	unsigned int seq;
 };
=20
-static struct nlmsghdr *__mnlg_msg_prepare(struct mnlg_socket *nlg, uint8_=
t cmd,
-					   uint16_t flags, uint32_t id,
-					   uint8_t version)
-{
-	struct genlmsghdr genl =3D {
-		.cmd =3D cmd,
-		.version =3D version,
-	};
-	struct nlmsghdr *nlh;
-
-	nlh =3D mnlu_msg_prepare(nlg->buf, id, flags, &genl, sizeof(genl));
-	nlg->seq =3D nlh->nlmsg_seq;
-	return nlh;
-}
-
-struct nlmsghdr *mnlg_msg_prepare(struct mnlg_socket *nlg, uint8_t cmd,
-				  uint16_t flags)
-{
-	return __mnlg_msg_prepare(nlg, cmd, flags, nlg->id, nlg->version);
-}
-
-int mnlg_socket_send(struct mnlg_socket *nlg, const struct nlmsghdr *nlh)
+int mnlg_socket_send(struct mnlu_gen_socket *nlg, const struct nlmsghdr *n=
lh)
 {
 	return mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
 }
=20
-int mnlg_socket_recv_run(struct mnlg_socket *nlg, mnl_cb_t data_cb, void *=
data)
-{
-	return mnlu_socket_recv_run(nlg->nl, nlg->seq, nlg->buf, MNL_SOCKET_BUFFE=
R_SIZE,
-				    data_cb, data);
-}
-
 struct group_info {
 	bool found;
 	uint32_t id;
@@ -141,15 +114,17 @@ static int get_group_id_cb(const struct nlmsghdr *nlh=
, void *data)
 	return MNL_CB_OK;
 }
=20
-int mnlg_socket_group_add(struct mnlg_socket *nlg, const char *group_name)
+int mnlg_socket_group_add(struct mnlu_gen_socket *nlg, const char *group_n=
ame)
 {
 	struct nlmsghdr *nlh;
 	struct group_info group_info;
 	int err;
=20
-	nlh =3D __mnlg_msg_prepare(nlg, CTRL_CMD_GETFAMILY,
-				 NLM_F_REQUEST | NLM_F_ACK, GENL_ID_CTRL, 1);
-	mnl_attr_put_u16(nlh, CTRL_ATTR_FAMILY_ID, nlg->id);
+	nlh =3D _mnlu_gen_socket_cmd_prepare(nlg, CTRL_CMD_GETFAMILY,
+					   NLM_F_REQUEST | NLM_F_ACK,
+					   GENL_ID_CTRL, 1);
+
+	mnl_attr_put_u16(nlh, CTRL_ATTR_FAMILY_ID, nlg->family);
=20
 	err =3D mnlg_socket_send(nlg, nlh);
 	if (err < 0)
@@ -157,7 +132,7 @@ int mnlg_socket_group_add(struct mnlg_socket *nlg, cons=
t char *group_name)
=20
 	group_info.found =3D false;
 	group_info.name =3D group_name;
-	err =3D mnlg_socket_recv_run(nlg, get_group_id_cb, &group_info);
+	err =3D mnlu_gen_socket_recv_run(nlg, get_group_id_cb, &group_info);
 	if (err < 0)
 		return err;
=20
@@ -174,85 +149,7 @@ int mnlg_socket_group_add(struct mnlg_socket *nlg, con=
st char *group_name)
 	return 0;
 }
=20
-static int get_family_id_attr_cb(const struct nlattr *attr, void *data)
-{
-	const struct nlattr **tb =3D data;
-	int type =3D mnl_attr_get_type(attr);
-
-	if (mnl_attr_type_valid(attr, CTRL_ATTR_MAX) < 0)
-		return MNL_CB_ERROR;
-
-	if (type =3D=3D CTRL_ATTR_FAMILY_ID &&
-	    mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
-		return MNL_CB_ERROR;
-	tb[type] =3D attr;
-	return MNL_CB_OK;
-}
-
-static int get_family_id_cb(const struct nlmsghdr *nlh, void *data)
-{
-	uint32_t *p_id =3D data;
-	struct nlattr *tb[CTRL_ATTR_MAX + 1] =3D {};
-	struct genlmsghdr *genl =3D mnl_nlmsg_get_payload(nlh);
-
-	mnl_attr_parse(nlh, sizeof(*genl), get_family_id_attr_cb, tb);
-	if (!tb[CTRL_ATTR_FAMILY_ID])
-		return MNL_CB_ERROR;
-	*p_id =3D mnl_attr_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
-	return MNL_CB_OK;
-}
-
-struct mnlg_socket *mnlg_socket_open(const char *family_name, uint8_t vers=
ion)
-{
-	struct mnlg_socket *nlg;
-	struct nlmsghdr *nlh;
-	int err;
-
-	nlg =3D malloc(sizeof(*nlg));
-	if (!nlg)
-		return NULL;
-
-	nlg->buf =3D malloc(MNL_SOCKET_BUFFER_SIZE);
-	if (!nlg->buf)
-		goto err_buf_alloc;
-
-	nlg->nl =3D mnlu_socket_open(NETLINK_GENERIC);
-	if (!nlg->nl)
-		goto err_socket_open;
-
-	nlh =3D __mnlg_msg_prepare(nlg, CTRL_CMD_GETFAMILY,
-				 NLM_F_REQUEST | NLM_F_ACK, GENL_ID_CTRL, 1);
-	mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, family_name);
-
-	err =3D mnlg_socket_send(nlg, nlh);
-	if (err < 0)
-		goto err_mnlg_socket_send;
-
-	err =3D mnlg_socket_recv_run(nlg, get_family_id_cb, &nlg->id);
-	if (err < 0)
-		goto err_mnlg_socket_recv_run;
-
-	nlg->version =3D version;
-	return nlg;
-
-err_mnlg_socket_recv_run:
-err_mnlg_socket_send:
-	mnl_socket_close(nlg->nl);
-err_socket_open:
-	free(nlg->buf);
-err_buf_alloc:
-	free(nlg);
-	return NULL;
-}
-
-void mnlg_socket_close(struct mnlg_socket *nlg)
-{
-	mnl_socket_close(nlg->nl);
-	free(nlg->buf);
-	free(nlg);
-}
-
-int mnlg_socket_get_fd(struct mnlg_socket *nlg)
+int mnlg_socket_get_fd(struct mnlu_gen_socket *nlg)
 {
 	return mnl_socket_get_fd(nlg->nl);
 }
diff --git a/devlink/mnlg.h b/devlink/mnlg.h
index 61bc5a3f..24aa1756 100644
--- a/devlink/mnlg.h
+++ b/devlink/mnlg.h
@@ -14,15 +14,10 @@
=20
 #include <libmnl/libmnl.h>
=20
-struct mnlg_socket;
+struct mnlu_gen_socket;
=20
-struct nlmsghdr *mnlg_msg_prepare(struct mnlg_socket *nlg, uint8_t cmd,
-				  uint16_t flags);
-int mnlg_socket_send(struct mnlg_socket *nlg, const struct nlmsghdr *nlh);
-int mnlg_socket_recv_run(struct mnlg_socket *nlg, mnl_cb_t data_cb, void *=
data);
-int mnlg_socket_group_add(struct mnlg_socket *nlg, const char *group_name)=
;
-struct mnlg_socket *mnlg_socket_open(const char *family_name, uint8_t vers=
ion);
-void mnlg_socket_close(struct mnlg_socket *nlg);
-int mnlg_socket_get_fd(struct mnlg_socket *nlg);
+int mnlg_socket_send(struct mnlu_gen_socket *nlg, const struct nlmsghdr *n=
lh);
+int mnlg_socket_group_add(struct mnlu_gen_socket *nlg, const char *group_n=
ame);
+int mnlg_socket_get_fd(struct mnlu_gen_socket *nlg);
=20
 #endif /* _MNLG_H_ */
--=20
2.26.2


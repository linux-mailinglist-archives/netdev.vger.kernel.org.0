Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1501A39D4
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 20:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgDIS3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 14:29:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40885 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgDIS3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 14:29:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id s8so13026701wrt.7
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 11:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eC0pbUZ8erlCo7/NncIxzPbGpACWoPHQAz3sVvTJrmI=;
        b=OjcY/TB9HWjN1Cz0Rfu5zJjUPUkAPFZqONSBIypVQ20isjdBjNS1GaQ5vxYENAy4M+
         Kg3Wp5S6HCYl0A898xdQOOD41+A9YixlRFuyIUsO99te4R7rZ/iGz7ecmQEbxk/NUaqV
         SttM/WXkjwSbVvDH0jrlsK/WD6d11EmuAooBvTDG7tzpPgROPAj6+51t3qa5u35MYGeO
         CWmj5EMTE2LZcvwOYlPptLLyTf5q8WGQ6Kct5tpjLxbP0X1dTJJ26xvVdD/1AlD1wLkQ
         lPG214JPWc6PdwLey6MUiA+c1XZGNUQ9VlwSwi8GtQmVCMSyTXwaN/P5DuX7TBvqe8Ub
         2ugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eC0pbUZ8erlCo7/NncIxzPbGpACWoPHQAz3sVvTJrmI=;
        b=uSxGqxNAO27z5FXDgTeCRQ7pUo4EbpZliVreXMCFbT3fuLcNndDCd4IlmTL3orZjao
         q+3LKSCKbcyaF/1OsZ708wv3ww3dTw7pb/4gyoYGI0VrLywey7dmyIGjTXZySL5efD0f
         kPeKfmMrU4JIqzsVufgXXhFiWnIQkFAYRUZ8AF2vIRCSvcX6hknHvceCmnWQLFiBE9HZ
         2LoSx5cFTJa8ske0NcXj0kEHco3eMcoFcPVX0rZI41UTC35UExVe0khqyTQAa9SYJj4x
         NoOLmkW+VSurMnCl0nFjaCcdEQl0euScvm+Ivo5825kIH/5Ge9JTBOfbJvii61jKEqSi
         YJmA==
X-Gm-Message-State: AGi0PuZTEMW/fK+rsDsYKpUrZ7Q+jJYe1mgZOtHUbrx1SlNBK0eHErnD
        tiIZ34CdFE51tc1ZYqjQSW6hnChfI/o=
X-Google-Smtp-Source: APiQypKmiRKV0wwpPFbJZvGYtxWouoeXOXgk2ufFJq1dNPz/PU/7DHqCZ1PT0N8xPWJmDSBu7yPg/Q==
X-Received: by 2002:adf:a28e:: with SMTP id s14mr497379wra.208.1586456992686;
        Thu, 09 Apr 2020 11:29:52 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v186sm4723058wme.24.2020.04.09.11.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 11:29:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2 v2] devlink: fix JSON output of mon command
Date:   Thu,  9 Apr 2020 20:29:51 +0200
Message-Id: <20200409182951.2334-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The current JSON output of mon command is broken. Fix it and make sure
that the output is a valid JSON. Also, handle SIGINT gracefully to allow
to end the JSON properly.

Example:
$ devlink mon -j -p
{
    "mon": [ {
            "command": "new",
            "dev": {
                "netdevsim/netdevsim10": {}
            }
        },{
            "command": "new",
            "port": {
                "netdevsim/netdevsim10/0": {
                    "type": "notset",
                    "flavour": "physical",
                    "port": 1
                }
            }
        },{
            "command": "new",
            "port": {
                "netdevsim/netdevsim10/0": {
                    "type": "eth",
                    "netdev": "eth0",
                    "flavour": "physical",
                    "port": 1
                }
            }
        },{
            "command": "new",
            "port": {
                "netdevsim/netdevsim10/0": {
                    "type": "notset",
                    "flavour": "physical",
                    "port": 1
                }
            }
        },{
            "command": "del",
            "port": {
                "netdevsim/netdevsim10/0": {
                    "type": "notset",
                    "flavour": "physical",
                    "port": 1
                }
            }
        },{
            "command": "del",
            "dev": {
                "netdevsim/netdevsim10": {}
            }
        } ]
}

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- rebased on top of current master
---
 devlink/devlink.c | 54 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4cf58f408385..f67fe6dd8759 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -152,6 +152,30 @@ static int _mnlg_socket_recv_run(struct mnlg_socket *nlg,
 	return 0;
 }
 
+static void dummy_signal_handler(int signum)
+{
+}
+
+static int _mnlg_socket_recv_run_intr(struct mnlg_socket *nlg,
+				      mnl_cb_t data_cb, void *data)
+{
+	struct sigaction act, oact;
+	int err;
+
+	act.sa_handler = dummy_signal_handler;
+	sigemptyset(&act.sa_mask);
+	act.sa_flags = SA_NODEFER;
+
+	sigaction(SIGINT, &act, &oact);
+	err = mnlg_socket_recv_run(nlg, data_cb, data);
+	sigaction(SIGINT, &oact, NULL);
+	if (err < 0 && errno != EINTR) {
+		pr_err("devlink answers: %s\n", strerror(errno));
+		return -errno;
+	}
+	return 0;
+}
+
 static int _mnlg_socket_send(struct mnlg_socket *nlg,
 			     const struct nlmsghdr *nlh)
 {
@@ -4236,7 +4260,21 @@ static const char *cmd_obj(uint8_t cmd)
 
 static void pr_out_mon_header(uint8_t cmd)
 {
-	pr_out("[%s,%s] ", cmd_obj(cmd), cmd_name(cmd));
+	if (!is_json_context()) {
+		pr_out("[%s,%s] ", cmd_obj(cmd), cmd_name(cmd));
+	} else {
+		open_json_object(NULL);
+		print_string(PRINT_JSON, "command", NULL, cmd_name(cmd));
+		open_json_object(cmd_obj(cmd));
+	}
+}
+
+static void pr_out_mon_footer(void)
+{
+	if (is_json_context()) {
+		close_json_object();
+		close_json_object();
+	}
 }
 
 static bool cmd_filter_check(struct dl *dl, uint8_t cmd)
@@ -4306,6 +4344,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_handle(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_PORT_GET: /* fall through */
 	case DEVLINK_CMD_PORT_SET: /* fall through */
@@ -4317,6 +4356,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_port(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_PARAM_GET: /* fall through */
 	case DEVLINK_CMD_PARAM_SET: /* fall through */
@@ -4328,6 +4368,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_param(dl, tb, false);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_REGION_GET: /* fall through */
 	case DEVLINK_CMD_REGION_SET: /* fall through */
@@ -4339,6 +4380,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_region(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_FLASH_UPDATE: /* fall through */
 	case DEVLINK_CMD_FLASH_UPDATE_END: /* fall through */
@@ -4348,6 +4390,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_flash_update(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_HEALTH_REPORTER_RECOVER:
 		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
@@ -4356,6 +4399,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_health(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_TRAP_GET: /* fall through */
 	case DEVLINK_CMD_TRAP_SET: /* fall through */
@@ -4372,6 +4416,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap(dl, tb, false);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_TRAP_GROUP_GET: /* fall through */
 	case DEVLINK_CMD_TRAP_GROUP_SET: /* fall through */
@@ -4384,6 +4429,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap_group(dl, tb, false);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_TRAP_POLICER_GET: /* fall through */
 	case DEVLINK_CMD_TRAP_POLICER_SET: /* fall through */
@@ -4423,7 +4469,11 @@ static int cmd_mon_show(struct dl *dl)
 	err = _mnlg_socket_group_add(dl->nlg, DEVLINK_GENL_MCGRP_CONFIG_NAME);
 	if (err)
 		return err;
-	err = _mnlg_socket_recv_run(dl->nlg, cmd_mon_show_cb, dl);
+	open_json_object(NULL);
+	open_json_array(PRINT_JSON, "mon");
+	err = _mnlg_socket_recv_run_intr(dl->nlg, cmd_mon_show_cb, dl);
+	close_json_array(PRINT_JSON, NULL);
+	close_json_object();
 	if (err)
 		return err;
 	return 0;
-- 
2.21.1


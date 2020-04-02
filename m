Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA51F19BEF4
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 11:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387633AbgDBJ4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 05:56:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36805 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbgDBJ4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 05:56:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so3428893wrs.3
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 02:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3u5SoA+FUlwtaFoC92JGocu5qDUZ+j1BG9YBbtplobU=;
        b=0mgC2leFnd6mWGd464RbPbklm5RAM8hfYHP+raKEl19aVzf5ywgDYWVTyvn4/wNA8v
         LeGD0wHfqAu1KB5NGHVjZgZNxUl7BFIeJCwgs4fO9639PyXxxxBUqJsuz9OdMF3yTIFn
         qsuIAaTgdw3Fe+JcO6gHufi+J2WpM6jacSM7Nc8KM9m+TtHBj3IyklAwzs0Chti86DD+
         5txy2b/5Whl7hko2JJqudntw6YpeBj6PBzMH1asTg4AJZawldyAR52P9M1ftWMA167vs
         59ln0c1kbmccBH40pQ7ir1Qo5RnHjejgmx0DnBRaNFUKF91jsB858qO9JSv7YJmqDBFn
         O+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3u5SoA+FUlwtaFoC92JGocu5qDUZ+j1BG9YBbtplobU=;
        b=AAoKaOZx50mYeOaZwRuyXKZl0PLtjcodIIib3nKgBJiIocAh0x2zH9YxC9r2N/TsRz
         gQP+Y9N1cEWx60WtyAryJoS8rmHSD/yiYGU3m6ccklR3V/OyfVEGVqNe0FlB3zfNmE72
         +7zGNOysWvpMfHhZqsx4kSYG/iD6A1EMFPzUbrcyh6kUko7feo0RXQlKt7JChWMAOmKc
         bts5uUbAElnzRaphYWKPq9Xq0XrqEfVoTT0/tmGHsFAz2wbG2n95F8SUmjswiOITce3g
         Yb/DNX5Mk84Nbf6gAzxH6cRYmt04O2loUHWCikM4uIPYneQc3BMf4qfr8k46knlsvadc
         xU0A==
X-Gm-Message-State: AGi0Pubai95NNI7zc2rYvnv1siKXcjC2gHU4LTlRk5oxrXUimhQX+hQX
        5zjZ+nkzgBGiVZBWC2hYGA3sdbqc9bg=
X-Google-Smtp-Source: APiQypK0RhwAebTQRega8GybOhlsyCEnHz3r/EaIZxv+V+iCDIiDqtsSWBTJ/RithXQGToftuhVLXg==
X-Received: by 2002:adf:e6c8:: with SMTP id y8mr2532073wrm.279.1585821369208;
        Thu, 02 Apr 2020 02:56:09 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t16sm7102437wra.17.2020.04.02.02.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 02:56:08 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, davem@davemloft.net,
        kuba@kernel.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next] devlink: fix JSON output of mon command
Date:   Thu,  2 Apr 2020 11:56:08 +0200
Message-Id: <20200402095608.18704-1-jiri@resnulli.us>
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
 devlink/devlink.c | 54 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index b8c1170be0e2..6434e68593ea 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -149,6 +149,30 @@ static int _mnlg_socket_recv_run(struct mnlg_socket *nlg,
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
@@ -4190,7 +4214,21 @@ static const char *cmd_obj(uint8_t cmd)
 
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
@@ -4259,6 +4297,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_handle(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_PORT_GET: /* fall through */
 	case DEVLINK_CMD_PORT_SET: /* fall through */
@@ -4270,6 +4309,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_port(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_PARAM_GET: /* fall through */
 	case DEVLINK_CMD_PARAM_SET: /* fall through */
@@ -4281,6 +4321,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_param(dl, tb, false);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_REGION_GET: /* fall through */
 	case DEVLINK_CMD_REGION_SET: /* fall through */
@@ -4292,6 +4333,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_region(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_FLASH_UPDATE: /* fall through */
 	case DEVLINK_CMD_FLASH_UPDATE_END: /* fall through */
@@ -4301,6 +4343,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_flash_update(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_HEALTH_REPORTER_RECOVER:
 		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
@@ -4309,6 +4352,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_health(dl, tb);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_TRAP_GET: /* fall through */
 	case DEVLINK_CMD_TRAP_SET: /* fall through */
@@ -4325,6 +4369,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap(dl, tb, false);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_TRAP_GROUP_GET: /* fall through */
 	case DEVLINK_CMD_TRAP_GROUP_SET: /* fall through */
@@ -4337,6 +4382,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap_group(dl, tb, false);
+		pr_out_mon_footer();
 		break;
 	}
 	return MNL_CB_OK;
@@ -4362,7 +4408,11 @@ static int cmd_mon_show(struct dl *dl)
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


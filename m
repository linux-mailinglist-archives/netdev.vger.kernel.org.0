Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032F42251FD
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 15:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgGSNgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 09:36:51 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40938 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726067AbgGSNgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 09:36:49 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 19 Jul 2020 16:36:40 +0300
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06JDaetn018654;
        Sun, 19 Jul 2020 16:36:40 +0300
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 06JDaeE3013805;
        Sun, 19 Jul 2020 16:36:40 +0300
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 06JDaena013804;
        Sun, 19 Jul 2020 16:36:40 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH iproute2-next 2/3] devlink: Add devlink port health command
Date:   Sun, 19 Jul 2020 16:36:02 +0300
Message-Id: <1595165763-13657-3-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
References: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Add devlink port health show subcommand which displays information about
specified port reporter or all present port reporters as in the example.
Device and port reporters can be distinguished by a handle being used.

Make other devlink-health subcommands be aliased by devlink port health.
Refactor devlink-health commands for usage of port handles in order to
interact with port reporters.

Change devlink health show output to dump information about both device
and port reporters with correct handles.

Example:
$ devlink health show
pci/0000:00:0b.0:
  reporter fw
    state healthy error 0 recover 0 auto_dump true
  reporter fw_fatal
    state healthy error 0 recover 0 grace_period 1200000 auto_recover true auto_dump true
pci/0000:00:0b.0/1:
  reporter tx
    state healthy error 0 recover 0 grace_period 10000 auto_recover true auto_dump true
  reporter rx
    state healthy error 0 recover 0 grace_period 10000 auto_recover true auto_dump true

$ devlink health show pci/0000:00:0b.0/1 reporter rx
Which is equivalent to:
$ devlink port health show pci/0000:00:0b.0/1 reporter rx
pci/0000:00:0b.0/1:
  reporter rx
    state healthy error 0 recover 0 grace_period 10000 auto_recover true auto_dump true

$ devlink port health show pci/0000:00:0b.0/1 reporter rx -j --pretty
{
    "health": {
         "pci/0000:00:0b.0/1": [ {
                 "reporter": "rx",
                 "state": "healthy",
                 "error": 0,
                 "recover": 0,
                 "grace_period": 500,
                 "auto_recover": true,
                 "auto_dump": true
              } ]
    }
}

$ devlink health set pci/0000:00:0b.0/1 reporter rx grace_period 5000
Which is equivalent to:
$ devlink port health set pci/0000:00:0b.0/1 reporter rx grace_period 5000

$ devlink port health show pci/0000:00:0b.0/1 reporter rx
pci/0000:00:0b.0/1:
  reporter rx
    state healthy error 0 recover 0 grace_period 5000 auto_recover true auto_dump true

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c |   80 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index bb4588e..7dbe9c7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3291,6 +3291,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\n");
+	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
 }
 
 static const char *port_type_name(uint32_t type)
@@ -3540,6 +3541,9 @@ static int cmd_port_function(struct dl *dl)
 	return -ENOENT;
 }
 
+static int cmd_health(struct dl *dl);
+static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port);
+
 static int cmd_port(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -3561,6 +3565,15 @@ static int cmd_port(struct dl *dl)
 	} else if (dl_argv_match(dl, "function")) {
 		dl_arg_inc(dl);
 		return cmd_port_function(dl);
+	} else if (dl_argv_match(dl, "health")) {
+		dl_arg_inc(dl);
+		if (dl_argv_match(dl, "list") || dl_no_arg(dl)
+		    || (dl_argv_match(dl, "show") && dl_argc(dl) == 1)) {
+			dl_arg_inc(dl);
+			return __cmd_health_show(dl, false, true);
+		} else {
+			return cmd_health(dl);
+		}
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
@@ -4493,7 +4506,8 @@ static void pr_out_flash_update(struct dl *dl, struct nlattr **tb)
 }
 
 static void pr_out_region(struct dl *dl, struct nlattr **tb);
-static void pr_out_health(struct dl *dl, struct nlattr **tb_health);
+static void pr_out_health(struct dl *dl, struct nlattr **tb_health,
+			  bool show_device, bool show_port);
 static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
 static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array);
 static void pr_out_trap_policer(struct dl *dl, struct nlattr **tb, bool array);
@@ -4572,7 +4586,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		    !tb[DEVLINK_ATTR_HEALTH_REPORTER])
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
-		pr_out_health(dl, tb);
+		pr_out_health(dl, tb, true, true);
 		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_TRAP_GET: /* fall through */
@@ -6717,7 +6731,7 @@ static int cmd_health_set_params(struct dl *dl)
 
 	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HEALTH_REPORTER_NAME,
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_REPORTER_NAME,
 			    DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD |
 			    DL_OPT_HEALTH_REPORTER_AUTO_RECOVER |
 			    DL_OPT_HEALTH_REPORTER_AUTO_DUMP);
@@ -6737,7 +6751,8 @@ static int cmd_health_dump_clear(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK);
 
 	err = dl_argv_parse_put(nlh, dl,
-				DL_OPT_HANDLE | DL_OPT_HEALTH_REPORTER_NAME, 0);
+				DL_OPT_HANDLE | DL_OPT_HANDLEP |
+				DL_OPT_HEALTH_REPORTER_NAME, 0);
 	if (err)
 		return err;
 
@@ -6984,7 +6999,8 @@ static int cmd_health_object_common(struct dl *dl, uint8_t cmd, uint16_t flags)
 	nlh = mnlg_msg_prepare(dl->nlg, cmd, flags | NLM_F_REQUEST | NLM_F_ACK);
 
 	err = dl_argv_parse_put(nlh, dl,
-				DL_OPT_HANDLE | DL_OPT_HEALTH_REPORTER_NAME, 0);
+				DL_OPT_HANDLE | DL_OPT_HANDLEP |
+				DL_OPT_HEALTH_REPORTER_NAME, 0);
 	if (err)
 		return err;
 
@@ -7017,7 +7033,8 @@ static int cmd_health_recover(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK);
 
 	err = dl_argv_parse_put(nlh, dl,
-				DL_OPT_HANDLE | DL_OPT_HEALTH_REPORTER_NAME, 0);
+				DL_OPT_HANDLE | DL_OPT_HANDLEP |
+				DL_OPT_HEALTH_REPORTER_NAME, 0);
 	if (err)
 		return err;
 
@@ -7091,7 +7108,8 @@ static void pr_out_dump_report_timestamp(struct dl *dl, const struct nlattr *att
 	print_string(PRINT_ANY, "last_dump_time", " last_dump_time %s", dump_time);
 }
 
-static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
+static void pr_out_health(struct dl *dl, struct nlattr **tb_health,
+			  bool print_device, bool print_port)
 {
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
 	enum devlink_health_reporter_state state;
@@ -7108,7 +7126,20 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 	    !tb[DEVLINK_ATTR_HEALTH_REPORTER_STATE])
 		return;
 
-	pr_out_handle_start_arr(dl, tb_health);
+	if (!print_device && !print_port)
+		return;
+	if (print_port) {
+		if (!print_device && !tb_health[DEVLINK_ATTR_PORT_INDEX])
+			return;
+		else if (tb_health[DEVLINK_ATTR_PORT_INDEX])
+			pr_out_port_handle_start_arr(dl, tb_health, false);
+	}
+	if (print_device) {
+		if (!print_port && tb_health[DEVLINK_ATTR_PORT_INDEX])
+			return;
+		else if (!tb_health[DEVLINK_ATTR_PORT_INDEX])
+			pr_out_handle_start_arr(dl, tb_health);
+	}
 
 	check_indent_newline(dl);
 	print_string(PRINT_ANY, "reporter", "reporter %s",
@@ -7142,25 +7173,33 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 	pr_out_handle_end(dl);
 }
 
+struct health_ctx {
+	struct dl *dl;
+	bool show_device;
+	bool show_port;
+};
+
 static int cmd_health_show_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
-	struct dl *dl = data;
+	struct health_ctx *ctx = data;
+	struct dl *dl = ctx->dl;
 
 	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
 	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
 	    !tb[DEVLINK_ATTR_HEALTH_REPORTER])
 		return MNL_CB_ERROR;
 
-	pr_out_health(dl, tb);
+	pr_out_health(dl, tb, ctx->show_device, ctx->show_port);
 
 	return MNL_CB_OK;
 }
 
-static int cmd_health_show(struct dl *dl)
+static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port)
 {
 	struct nlmsghdr *nlh;
+	struct health_ctx ctx = { dl, show_device, show_port };
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
@@ -7170,27 +7209,28 @@ static int cmd_health_show(struct dl *dl)
 			       flags);
 
 	if (dl_argc(dl) > 0) {
+		ctx.show_port = true;
 		err = dl_argv_parse_put(nlh, dl,
-					DL_OPT_HANDLE |
+					DL_OPT_HANDLE | DL_OPT_HANDLEP |
 					DL_OPT_HEALTH_REPORTER_NAME, 0);
 		if (err)
 			return err;
 	}
 	pr_out_section_start(dl, "health");
 
-	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_health_show_cb, dl);
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_health_show_cb, &ctx);
 	pr_out_section_end(dl);
 	return err;
 }
 
 static void cmd_health_help(void)
 {
-	pr_err("Usage: devlink health show [ dev DEV reporter REPORTER_NAME ]\n");
-	pr_err("       devlink health recover DEV reporter REPORTER_NAME\n");
-	pr_err("       devlink health diagnose DEV reporter REPORTER_NAME\n");
-	pr_err("       devlink health dump show DEV reporter REPORTER_NAME\n");
-	pr_err("       devlink health dump clear DEV reporter REPORTER_NAME\n");
-	pr_err("       devlink health set DEV reporter REPORTER_NAME\n");
+	pr_err("Usage: devlink health show [ { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME ]\n");
+	pr_err("       devlink health recover { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
+	pr_err("       devlink health diagnose { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
+	pr_err("       devlink health dump show { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
+	pr_err("       devlink health dump clear { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
+	pr_err("       devlink health set { DEV | DEV/PORT_INDEX } reporter REPORTER_NAME\n");
 	pr_err("                          [ grace_period MSEC ]\n");
 	pr_err("                          [ auto_recover { true | false } ]\n");
 	pr_err("                          [ auto_dump    { true | false } ]\n");
@@ -7204,7 +7244,7 @@ static int cmd_health(struct dl *dl)
 	} else if (dl_argv_match(dl, "show") ||
 		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
 		dl_arg_inc(dl);
-		return cmd_health_show(dl);
+		return __cmd_health_show(dl, true, true);
 	} else if (dl_argv_match(dl, "recover")) {
 		dl_arg_inc(dl);
 		return cmd_health_recover(dl);
-- 
1.7.1


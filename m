Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C481A73F1
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 08:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406179AbgDNG6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 02:58:50 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37470 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2406131AbgDNG6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 02:58:50 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from eranbe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 Apr 2020 09:58:43 +0300
Received: from dev-l-vrt-198.mtl.labs.mlnx (dev-l-vrt-198.mtl.labs.mlnx [10.134.198.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03E6whps007886;
        Tue, 14 Apr 2020 09:58:43 +0300
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH iproute2-next] devlink: Add devlink health auto_dump command support
Date:   Tue, 14 Apr 2020 09:57:52 +0300
Message-Id: <1586847472-32490-1-git-send-email-eranbe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring auto_dump attribute per reporter.
With this attribute, one can indicate whether the devlink kernel core
should execute automatic dump on error.

The change will be reflected in show, set and man commands.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
---
 devlink/devlink.c         | 19 ++++++++++++++++++-
 man/man8/devlink-health.8 | 11 +++++++++--
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4cf58f408385..7c880e045ea7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -268,6 +268,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_TRAP_POLICER_ID		BIT(34)
 #define DL_OPT_TRAP_POLICER_RATE	BIT(35)
 #define DL_OPT_TRAP_POLICER_BURST	BIT(36)
+#define DL_OPT_HEALTH_REPORTER_AUTO_DUMP     BIT(37)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -304,6 +305,7 @@ struct dl_opts {
 	const char *reporter_name;
 	uint64_t reporter_graceful_period;
 	bool reporter_auto_recover;
+	bool reporter_auto_dump;
 	const char *trap_name;
 	const char *trap_group_name;
 	enum devlink_trap_action trap_action;
@@ -1450,6 +1452,13 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_HEALTH_REPORTER_AUTO_RECOVER;
+		} else if (dl_argv_match(dl, "auto_dump") &&
+			(o_all & DL_OPT_HEALTH_REPORTER_AUTO_DUMP)) {
+			dl_arg_inc(dl);
+			err = dl_argv_bool(dl, &opts->reporter_auto_dump);
+			if (err)
+				return err;
+			o_found |= DL_OPT_HEALTH_REPORTER_AUTO_DUMP;
 		} else if (dl_argv_match(dl, "trap") &&
 			   (o_all & DL_OPT_TRAP_NAME)) {
 			dl_arg_inc(dl);
@@ -1632,6 +1641,9 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_HEALTH_REPORTER_AUTO_RECOVER)
 		mnl_attr_put_u8(nlh, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
 				opts->reporter_auto_recover);
+	if (opts->present & DL_OPT_HEALTH_REPORTER_AUTO_DUMP)
+		mnl_attr_put_u8(nlh, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
+				opts->reporter_auto_dump);
 	if (opts->present & DL_OPT_TRAP_NAME)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_TRAP_NAME,
 				  opts->trap_name);
@@ -6455,7 +6467,8 @@ static int cmd_health_set_params(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK);
 	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HEALTH_REPORTER_NAME,
 			    DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD |
-			    DL_OPT_HEALTH_REPORTER_AUTO_RECOVER);
+			    DL_OPT_HEALTH_REPORTER_AUTO_RECOVER |
+			    DL_OPT_HEALTH_REPORTER_AUTO_DUMP);
 	if (err)
 		return err;
 
@@ -6869,6 +6882,9 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER])
 		print_bool(PRINT_ANY, "auto_recover", " auto_recover %s",
 			   mnl_attr_get_u8(tb[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]));
+	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
+		print_bool(PRINT_ANY, "auto_dump", " auto_dump %s",
+			   mnl_attr_get_u8(tb[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]));
 
 	__pr_out_indent_dec();
 	pr_out_handle_end(dl);
@@ -6925,6 +6941,7 @@ static void cmd_health_help(void)
 	pr_err("       devlink health set DEV reporter REPORTER_NAME\n");
 	pr_err("                          [ grace_period MSEC ]\n");
 	pr_err("                          [ auto_recover { true | false } ]\n");
+	pr_err("                          [ auto_dump    { true | false } ]\n");
 }
 
 static int cmd_health(struct dl *dl)
diff --git a/man/man8/devlink-health.8 b/man/man8/devlink-health.8
index 70a86cf0acdc..8a3c77be737b 100644
--- a/man/man8/devlink-health.8
+++ b/man/man8/devlink-health.8
@@ -58,6 +58,9 @@ devlink-health \- devlink health reporting and recovery
 .RI "[ "
 .BR auto_recover " { " true " | " false " } "
 .RI "]"
+.RI "[ "
+.BR auto_dump " { " true " | " false " } "
+.RI "]"
 
 .ti -8
 .B devlink health help
@@ -131,8 +134,8 @@ the next "devlink health dump show" command.
 - specifies the reporter's name registered on the devlink device.
 
 .SS devlink health set - Configure health reporter.
-Please note that this command is not supported on a reporter which
-doesn't support a recovery method.
+Please note that some params are not supported on a reporter which
+doesn't support a recovery or dump method.
 
 .PP
 .I "DEV"
@@ -150,6 +153,10 @@ Time interval between consecutive auto recoveries.
 .BR auto_recover " { " true " | " false " } "
 Indicates whether the devlink should execute automatic recover on error.
 
+.TP
+.BR auto_dump " { " true " | " false " } "
+Indicates whether the devlink should execute automatic dump on error.
+
 .SH "EXAMPLES"
 .PP
 devlink health show
-- 
2.17.1


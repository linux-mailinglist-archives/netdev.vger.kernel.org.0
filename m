Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211EB2C52AA
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 12:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388808AbgKZLPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 06:15:53 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34954 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727041AbgKZLPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 06:15:52 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 26 Nov 2020 13:15:39 +0200
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AQBFddI025571;
        Thu, 26 Nov 2020 13:15:39 +0200
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AQBFdCZ004261;
        Thu, 26 Nov 2020 13:15:39 +0200
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 0AQBFd2T004260;
        Thu, 26 Nov 2020 13:15:39 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2-net 1/3] devlink: Add devlink reload action and limit options
Date:   Thu, 26 Nov 2020 13:14:54 +0200
Message-Id: <1606389296-3906-2-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reload action and reload limit to devlink reload command to enable
the user to select the reload action required and constrains limits on
these actions that he may want to ensure.
The following reload actions are supported:
  driver_reinit: driver entities re-initialization, applying
                 devlink-param and devlink-resource values.
  fw_activate: firmware activate.

The uAPI is backward compatible, if the reload action option is omitted
from the reload command, the driver reinit action will be used.
Note that when required to do firmware activation some drivers may need
to reload the driver. On the other hand some drivers may need to reset
the firmware to reinitialize the driver entities. Therefore, the devlink
reload command returns the actions which were actually performed.

By default reload actions are not limited and driver implementation may
include reset or downtime as needed to perform the actions.
However, if reload limit is selected, the driver should perform only if
it can do it while keeping the limit constraints.
Reload limit added:
  no_reset: No reset allowed, no down time allowed, no link flap and no
            configuration is lost.

Command examples:
$devlink dev reload pci/0000:82:00.0 action driver_reinit
reload_actions_performed:
  driver_reinit

$devlink dev reload pci/0000:82:00.0 action fw_activate
reload_actions_performed:
  driver_reinit fw_activate

devlink dev reload pci/0000:82:00.1 action driver_reinit -jp
{
    "reload": {
        "reload_actions_performed": [ "driver_reinit" ]
    }
}

devlink dev reload pci/0000:82:00.0 action fw_activate -jp
{
    "reload": {
        "reload_actions_performed": [ "driver_reinit","fw_activate" ]
    }
}

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 136 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 133 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 1ff865bc..a9ba0072 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -304,6 +304,8 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_HEALTH_REPORTER_AUTO_DUMP     BIT(37)
 #define DL_OPT_PORT_FUNCTION_HW_ADDR BIT(38)
 #define DL_OPT_FLASH_OVERWRITE		BIT(39)
+#define DL_OPT_RELOAD_ACTION		BIT(40)
+#define DL_OPT_RELOAD_LIMIT	BIT(41)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -352,6 +354,8 @@ struct dl_opts {
 	char port_function_hw_addr[MAX_ADDR_LEN];
 	uint32_t port_function_hw_addr_len;
 	uint32_t overwrite_mask;
+	enum devlink_reload_action reload_action;
+	enum devlink_reload_limit reload_limit;
 };
 
 struct dl {
@@ -1344,6 +1348,32 @@ static int hw_addr_parse(const char *addrstr, char *hw_addr, uint32_t *len)
 	return 0;
 }
 
+static int reload_action_get(struct dl *dl, const char *actionstr,
+			     enum devlink_reload_action *action)
+{
+	if (strcmp(actionstr, "driver_reinit") == 0) {
+		*action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
+	} else if (strcmp(actionstr, "fw_activate") == 0) {
+		*action = DEVLINK_RELOAD_ACTION_FW_ACTIVATE;
+	} else {
+		pr_err("Unknown reload action \"%s\"\n", actionstr);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int reload_limit_get(struct dl *dl, const char *limitstr,
+			     enum devlink_reload_limit *limit)
+{
+	if (strcmp(limitstr, "no_reset") == 0) {
+		*limit = DEVLINK_RELOAD_LIMIT_NO_RESET;
+	} else {
+		pr_err("Unknown reload limit \"%s\"\n", limitstr);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -1730,6 +1760,30 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 				opts->netns_is_pid = true;
 			}
 			o_found |= DL_OPT_NETNS;
+		} else if (dl_argv_match(dl, "action") &&
+			   (o_all & DL_OPT_RELOAD_ACTION)) {
+			const char *actionstr;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &actionstr);
+			if (err)
+				return err;
+			err = reload_action_get(dl, actionstr, &opts->reload_action);
+			if (err)
+				return err;
+			o_found |= DL_OPT_RELOAD_ACTION;
+		} else if (dl_argv_match(dl, "limit") &&
+			   (o_all & DL_OPT_RELOAD_LIMIT)) {
+			const char *limitstr;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &limitstr);
+			if (err)
+				return err;
+			err = reload_limit_get(dl, limitstr, &opts->reload_limit);
+			if (err)
+				return err;
+			o_found |= DL_OPT_RELOAD_LIMIT;
 		} else if (dl_argv_match(dl, "policer") &&
 			   (o_all & DL_OPT_TRAP_POLICER_ID)) {
 			dl_arg_inc(dl);
@@ -1810,6 +1864,16 @@ dl_flash_update_overwrite_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
 		     sizeof(overwrite_mask), &overwrite_mask);
 }
 
+static void
+dl_reload_limits_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
+{
+	struct nla_bitfield32 limits;
+
+	limits.selector = DEVLINK_RELOAD_LIMITS_VALID_MASK;
+	limits.value = BIT(opts->reload_limit);
+	mnl_attr_put(nlh, DEVLINK_ATTR_RELOAD_LIMITS, sizeof(limits), &limits);
+}
+
 static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 {
 	struct dl_opts *opts = &dl->opts;
@@ -1926,6 +1990,11 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				 opts->netns_is_pid ? DEVLINK_ATTR_NETNS_PID :
 						      DEVLINK_ATTR_NETNS_FD,
 				 opts->netns);
+	if (opts->present & DL_OPT_RELOAD_ACTION)
+		mnl_attr_put_u8(nlh, DEVLINK_ATTR_RELOAD_ACTION,
+				opts->reload_action);
+	if (opts->present & DL_OPT_RELOAD_LIMIT)
+		dl_reload_limits_put(nlh, opts);
 	if (opts->present & DL_OPT_TRAP_POLICER_ID)
 		mnl_attr_put_u32(nlh, DEVLINK_ATTR_TRAP_POLICER_ID,
 				 opts->trap_policer_id);
@@ -1997,7 +2066,7 @@ static void cmd_dev_help(void)
 	pr_err("       devlink dev eswitch show DEV\n");
 	pr_err("       devlink dev param set DEV name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink dev param show [DEV name PARAMETER]\n");
-	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
+	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
 	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
 }
@@ -2289,6 +2358,18 @@ static const char *param_cmode_name(uint8_t cmode)
 	}
 }
 
+static const char *reload_action_name(uint8_t reload_action)
+{
+	switch (reload_action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		return "driver_reinit";
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		return "fw_activate";
+	default:
+		return "<unknown reload action>";
+	}
+}
+
 static const char *eswitch_mode_name(uint32_t mode)
 {
 	switch (mode) {
@@ -2942,6 +3023,54 @@ static int cmd_dev_show(struct dl *dl)
 	return err;
 }
 
+static void pr_out_reload_actions_performed(struct dl *dl, struct nlattr **tb)
+{
+	struct nla_bitfield32 *actions;
+	uint32_t actions_performed;
+	uint16_t len;
+	int action;
+
+	if (!tb[DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED])
+		return;
+
+	len = mnl_attr_get_payload_len(tb[DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED]);
+	if (len != sizeof(*actions))
+		return;
+	actions = mnl_attr_get_payload(tb[DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED]);
+	if (!actions)
+		return;
+	g_new_line_count = 1; /* Avoid extra new line in non-json print */
+	pr_out_array_start(dl, "reload_actions_performed");
+	actions_performed = actions->value & actions->selector;
+	for (action = 0; action <= DEVLINK_RELOAD_ACTION_MAX; action++) {
+		if (BIT(action) & actions_performed) {
+			check_indent_newline(dl);
+			print_string(PRINT_ANY, NULL, "%s", reload_action_name(action));
+		}
+	}
+	pr_out_array_end(dl);
+	if (!dl->json_output)
+		__pr_out_newline();
+}
+
+static int cmd_dev_reload_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED])
+		return MNL_CB_ERROR;
+
+	pr_out_section_start(dl, "reload");
+	pr_out_reload_actions_performed(dl, tb);
+	pr_out_section_end(dl);
+
+	return MNL_CB_OK;
+}
+
 static int cmd_dev_reload(struct dl *dl)
 {
 	struct nlmsghdr *nlh;
@@ -2955,11 +3084,12 @@ static int cmd_dev_reload(struct dl *dl)
 	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_RELOAD,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_NETNS);
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE,
+				DL_OPT_NETNS | DL_OPT_RELOAD_ACTION | DL_OPT_RELOAD_LIMIT);
 	if (err)
 		return err;
 
-	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dev_reload_cb, dl);
 }
 
 static void pr_out_versions_single(struct dl *dl, const struct nlmsghdr *nlh,
-- 
2.18.2


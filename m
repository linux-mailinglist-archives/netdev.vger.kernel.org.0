Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F9B8B285
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfHMIcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:32:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52381 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727429AbfHMIcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:32:15 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 417D921CBA;
        Tue, 13 Aug 2019 04:32:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 04:32:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=nX0Y3IBweTaFsLiBjr/kVF24WzAZms2Bst31Nj4wbPc=; b=OSd3VDzb
        HdSlupg++q0yXPsRx5flRxn1RTqHoDEhkOwYlAT5+IgxiyQp3KufcecKYqKDMFvj
        3LOMbg+Fj1g43FDCShuqkeD+wV7TZmMmI4V8l0HbxrxfDOrIegKjQ9OmXgj74VkX
        OYz8EbJmhsN9WItBz7EjxRjIsUUfpPtkk1iwbRpTJPwrgn1R267j145FME54WY+Y
        py9MVb8jz6hzVRPMfjZWnIQBHWpJyYP+xdOOhYhasFfyCV4vgMm4XiIqUYaW6v01
        +CaDXyqPhd8WfjTsUX7cL9zKUnRUKLhm1QQO8NPWHYap/zjbuy7KwwsRM7GDTDVz
        xRqtQoSLtIAU9g==
X-ME-Sender: <xms:jnVSXW1cJSgAyy0YK-ONK91pDsKXughcFRzMRrzGSZt5ELCbuHu00Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:jnVSXU9tkMs9PKUhp-pCCJMnTFxbWP9ATU6rxwqZedWrK8jqGXkKCg>
    <xmx:jnVSXfkBroRDWwL9cERY9rBvzFkY3UfiHkRaBHtoPcNT70iR5VCGXQ>
    <xmx:jnVSXTDAkRcYmh03Ms50gbnCzQXN6MQLCYgaF3iXDd1iihiIyxoqpg>
    <xmx:jnVSXauaRcR9mUCZYeRrrqP8F7OGHQquEEKMsN89_OX6D9FcOR-xAA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A7EE8005C;
        Tue, 13 Aug 2019 04:32:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 2/4] devlink: Add devlink trap set and show commands
Date:   Tue, 13 Aug 2019 11:31:41 +0300
Message-Id: <20190813083143.13509-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813083143.13509-1-idosch@idosch.org>
References: <20190813083143.13509-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The trap set command allows the user to set the action of an individual
trap. Example:

# devlink trap set netdevsim/netdevsim10 trap blackhole_route action trap

The trap show command allows the user to get the current status of an
individual trap or a dump of all traps in case one is not specified.
When '-s' is specified the trap's statistics are shown. When '-v' is
specified the metadata types the trap can provide are shown. Example:

# devlink -jvps trap show netdevsim/netdevsim10 trap blackhole_route
{
    "trap": {
        "netdevsim/netdevsim10": [ {
                "name": "blackhole_route",
                "type": "drop",
                "generic": true,
                "action": "trap",
                "group": "l3_drops",
                "metadata": [ "input_port" ],
                "stats": {
                    "rx": {
                        "bytes": 0,
                        "packets": 0
                    }
                }
            } ]
    }
}

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 devlink/devlink.c | 293 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 288 insertions(+), 5 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4ed240e251f5..81fff4429841 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -233,6 +233,8 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_HEALTH_REPORTER_NAME	BIT(27)
 #define DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD	BIT(27)
 #define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(28)
+#define DL_OPT_TRAP_NAME		BIT(29)
+#define DL_OPT_TRAP_ACTION		BIT(30)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -269,6 +271,8 @@ struct dl_opts {
 	const char *reporter_name;
 	uint64_t reporter_graceful_period;
 	bool reporter_auto_recover;
+	const char *trap_name;
+	enum devlink_trap_action trap_action;
 };
 
 struct dl {
@@ -282,6 +286,7 @@ struct dl {
 	bool json_output;
 	bool pretty_output;
 	bool verbose;
+	bool stats;
 	struct {
 		bool present;
 		char *bus_name;
@@ -436,6 +441,19 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_STATS] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_TRAP_NAME] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_TRAP_ACTION] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_TRAP_TYPE] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_TRAP_GENERIC] = MNL_TYPE_FLAG,
+	[DEVLINK_ATTR_TRAP_METADATA] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_TRAP_GROUP_NAME] = MNL_TYPE_STRING,
+};
+
+static const enum mnl_attr_data_type
+devlink_stats_policy[DEVLINK_ATTR_STATS_MAX + 1] = {
+	[DEVLINK_ATTR_STATS_RX_PACKETS] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_STATS_RX_BYTES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -454,6 +472,25 @@ static int attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static int attr_stats_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type;
+
+	/* Allow the tool to work on top of newer kernels that might contain
+	 * more attributes.
+	 */
+	if (mnl_attr_type_valid(attr, DEVLINK_ATTR_STATS_MAX) < 0)
+		return MNL_CB_OK;
+
+	type = mnl_attr_get_type(attr);
+	if (mnl_attr_validate(attr, devlink_stats_policy[type]) < 0)
+		return MNL_CB_ERROR;
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
 static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
@@ -1014,6 +1051,20 @@ static int param_cmode_get(const char *cmodestr,
 	return 0;
 }
 
+static int trap_action_get(const char *actionstr,
+			   enum devlink_trap_action *p_action)
+{
+	if (strcmp(actionstr, "drop") == 0) {
+		*p_action = DEVLINK_TRAP_ACTION_DROP;
+	} else if (strcmp(actionstr, "trap") == 0) {
+		*p_action = DEVLINK_TRAP_ACTION_TRAP;
+	} else {
+		pr_err("Unknown trap action \"%s\"\n", actionstr);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -1040,6 +1091,7 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_REGION_ADDRESS,	      "Region address value expected."},
 	{DL_OPT_REGION_LENGTH,	      "Region length value expected."},
 	{DL_OPT_HEALTH_REPORTER_NAME, "Reporter's name is expected."},
+	{DL_OPT_TRAP_NAME,            "Trap's name is expected."},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1329,6 +1381,25 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_HEALTH_REPORTER_AUTO_RECOVER;
+		} else if (dl_argv_match(dl, "trap") &&
+			   (o_all & DL_OPT_TRAP_NAME)) {
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &opts->trap_name);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_NAME;
+		} else if (dl_argv_match(dl, "action") &&
+			   (o_all & DL_OPT_TRAP_ACTION)) {
+			const char *actionstr;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &actionstr);
+			if (err)
+				return err;
+			err = trap_action_get(actionstr, &opts->trap_action);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_ACTION;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -1442,6 +1513,12 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_HEALTH_REPORTER_AUTO_RECOVER)
 		mnl_attr_put_u8(nlh, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
 				opts->reporter_auto_recover);
+	if (opts->present & DL_OPT_TRAP_NAME)
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_TRAP_NAME,
+				  opts->trap_name);
+	if (opts->present & DL_OPT_TRAP_ACTION)
+		mnl_attr_put_u8(nlh, DEVLINK_ATTR_TRAP_ACTION,
+				opts->trap_action);
 
 }
 
@@ -1945,6 +2022,30 @@ static void pr_out_entry_end(struct dl *dl)
 		__pr_out_newline();
 }
 
+static void pr_out_stats(struct dl *dl, struct nlattr *nla_stats)
+{
+	struct nlattr *tb[DEVLINK_ATTR_STATS_MAX + 1] = {};
+	int err;
+
+	if (!dl->stats)
+		return;
+
+	err = mnl_attr_parse_nested(nla_stats, attr_stats_cb, tb);
+	if (err != MNL_CB_OK)
+		return;
+
+	pr_out_object_start(dl, "stats");
+	pr_out_object_start(dl, "rx");
+	if (tb[DEVLINK_ATTR_STATS_RX_BYTES])
+		pr_out_u64(dl, "bytes",
+			   mnl_attr_get_u64(tb[DEVLINK_ATTR_STATS_RX_BYTES]));
+	if (tb[DEVLINK_ATTR_STATS_RX_PACKETS])
+		pr_out_u64(dl, "packets",
+			   mnl_attr_get_u64(tb[DEVLINK_ATTR_STATS_RX_PACKETS]));
+	pr_out_object_end(dl);
+	pr_out_object_end(dl);
+}
+
 static const char *param_cmode_name(uint8_t cmode)
 {
 	switch (cmode) {
@@ -3764,6 +3865,10 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_REGION_SET: return "set";
 	case DEVLINK_CMD_REGION_NEW: return "new";
 	case DEVLINK_CMD_REGION_DEL: return "del";
+	case DEVLINK_CMD_TRAP_GET: return "get";
+	case DEVLINK_CMD_TRAP_SET: return "set";
+	case DEVLINK_CMD_TRAP_NEW: return "new";
+	case DEVLINK_CMD_TRAP_DEL: return "del";
 	default: return "<unknown cmd>";
 	}
 }
@@ -3792,6 +3897,11 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_REGION_NEW:
 	case DEVLINK_CMD_REGION_DEL:
 		return "region";
+	case DEVLINK_CMD_TRAP_GET:
+	case DEVLINK_CMD_TRAP_SET:
+	case DEVLINK_CMD_TRAP_NEW:
+	case DEVLINK_CMD_TRAP_DEL:
+		return "trap";
 	default: return "<unknown obj>";
 	}
 }
@@ -3817,6 +3927,7 @@ static bool cmd_filter_check(struct dl *dl, uint8_t cmd)
 }
 
 static void pr_out_region(struct dl *dl, struct nlattr **tb);
+static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
 
 static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -3872,6 +3983,22 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_region(dl, tb);
 		break;
+	case DEVLINK_CMD_TRAP_GET: /* fall through */
+	case DEVLINK_CMD_TRAP_SET: /* fall through */
+	case DEVLINK_CMD_TRAP_NEW: /* fall through */
+	case DEVLINK_CMD_TRAP_DEL:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_TYPE] ||
+		    !tb[DEVLINK_ATTR_TRAP_ACTION] ||
+		    !tb[DEVLINK_ATTR_TRAP_GROUP_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_METADATA] ||
+		    !tb[DEVLINK_ATTR_STATS])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_trap(dl, tb, false);
+		break;
 	}
 	return MNL_CB_OK;
 }
@@ -3885,7 +4012,8 @@ static int cmd_mon_show(struct dl *dl)
 	while ((cur_obj = dl_argv_index(dl, index++))) {
 		if (strcmp(cur_obj, "all") != 0 &&
 		    strcmp(cur_obj, "dev") != 0 &&
-		    strcmp(cur_obj, "port") != 0) {
+		    strcmp(cur_obj, "port") != 0 &&
+		    strcmp(cur_obj, "trap") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -3902,7 +4030,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port }\n");
+	       "where  OBJECT-LIST := { dev | port | trap }\n");
 }
 
 static int cmd_mon(struct dl *dl)
@@ -6330,12 +6458,160 @@ static int cmd_health(struct dl *dl)
 	return -ENOENT;
 }
 
+static const char *trap_type_name(uint8_t type)
+{
+	switch (type) {
+	case DEVLINK_TRAP_TYPE_DROP:
+		return "drop";
+	case DEVLINK_TRAP_TYPE_EXCEPTION:
+		return "exception";
+	default:
+		return "<unknown type>";
+	}
+}
+
+static const char *trap_action_name(uint8_t action)
+{
+	switch (action) {
+	case DEVLINK_TRAP_ACTION_DROP:
+		return "drop";
+	case DEVLINK_TRAP_ACTION_TRAP:
+		return "trap";
+	default:
+		return "<unknown action>";
+	}
+}
+
+static const char *trap_metadata_name(const struct nlattr *attr)
+{
+	switch (attr->nla_type) {
+	case DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT:
+		return "input_port";
+	default:
+		return "<unknown metadata type>";
+	}
+}
+static void pr_out_trap_metadata(struct dl *dl, struct nlattr *attr)
+{
+	struct nlattr *attr_metadata;
+
+	pr_out_array_start(dl, "metadata");
+	mnl_attr_for_each_nested(attr_metadata, attr)
+		pr_out_str_value(dl, trap_metadata_name(attr_metadata));
+	pr_out_array_end(dl);
+}
+
+static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array)
+{
+	uint8_t action = mnl_attr_get_u8(tb[DEVLINK_ATTR_TRAP_ACTION]);
+	uint8_t type = mnl_attr_get_u8(tb[DEVLINK_ATTR_TRAP_TYPE]);
+
+	if (array)
+		pr_out_handle_start_arr(dl, tb);
+	else
+		__pr_out_handle_start(dl, tb, true, false);
+
+	pr_out_str(dl, "name", mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_NAME]));
+	pr_out_str(dl, "type", trap_type_name(type));
+	pr_out_bool(dl, "generic", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
+	pr_out_str(dl, "action", trap_action_name(action));
+	pr_out_str(dl, "group",
+		   mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
+	if (dl->verbose)
+		pr_out_trap_metadata(dl, tb[DEVLINK_ATTR_TRAP_METADATA]);
+	pr_out_stats(dl, tb[DEVLINK_ATTR_STATS]);
+	pr_out_handle_end(dl);
+}
+
+static int cmd_trap_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_TRAP_NAME] || !tb[DEVLINK_ATTR_TRAP_TYPE] ||
+	    !tb[DEVLINK_ATTR_TRAP_ACTION] ||
+	    !tb[DEVLINK_ATTR_TRAP_GROUP_NAME] ||
+	    !tb[DEVLINK_ATTR_TRAP_METADATA] || !tb[DEVLINK_ATTR_STATS])
+		return MNL_CB_ERROR;
+
+	pr_out_trap(dl, tb, true);
+
+	return MNL_CB_OK;
+}
+
+static void cmd_trap_help(void)
+{
+	pr_err("Usage: devlink trap set DEV trap TRAP [ action { trap | drop } ]\n");
+	pr_err("       devlink trap show [ DEV trap TRAP ]\n");
+}
+
+static int cmd_trap_show(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl,
+					DL_OPT_HANDLE | DL_OPT_TRAP_NAME, 0);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "trap");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_trap_show_cb, dl);
+	pr_out_section_end(dl);
+
+	return err;
+}
+
+static int cmd_trap_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_SET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_TRAP_NAME,
+				DL_OPT_TRAP_ACTION);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_trap(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_trap_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_trap_show(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_trap_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static void help(void)
 {
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       devlink [ -f[orce] ] -b[atch] filename\n"
-	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health }\n"
-	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
+	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
+	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
 }
 
 static int dl_cmd(struct dl *dl, int argc, char **argv)
@@ -6370,6 +6646,9 @@ static int dl_cmd(struct dl *dl, int argc, char **argv)
 	} else if (dl_argv_match(dl, "health")) {
 		dl_arg_inc(dl);
 		return cmd_health(dl);
+	} else if (dl_argv_match(dl, "trap")) {
+		dl_arg_inc(dl);
+		return cmd_trap(dl);
 	}
 	pr_err("Object \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
@@ -6479,6 +6758,7 @@ int main(int argc, char **argv)
 		{ "json",		no_argument,		NULL, 'j' },
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "verbose",		no_argument,		NULL, 'v' },
+		{ "statistics",		no_argument,		NULL, 's' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -6494,7 +6774,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpv",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvs",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -6520,6 +6800,9 @@ int main(int argc, char **argv)
 		case 'v':
 			dl->verbose = true;
 			break;
+		case 's':
+			dl->stats = true;
+			break;
 		default:
 			pr_err("Unknown option.\n");
 			help();
-- 
2.21.0


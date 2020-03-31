Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C98198EC0
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 10:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgCaIn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 04:43:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47337 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730099AbgCaIn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 04:43:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F1DD85C0449;
        Tue, 31 Mar 2020 04:43:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 31 Mar 2020 04:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Qc6sXErN2iS64T5bsNvrtGJhKXPtE+roMCtnlxI9l5o=; b=C9x3UhlC
        ZbtGWH63f/818iaUE031UwnEXjgAvIGy1Ctl5RCeQklXYmPQWvb5jYK9e3JZeFQA
        tPcR3bsXqqyMo48INFFmPAZL1pGr5UpUmOmTpiZ2HbjpgzVDT6DwoEVUDsO8m/j3
        dbhwBb05IK8/Pcw9HWGzz53xd2xFyF6L/bRnvmqL80ZImEfDbEfyBnXylx5XUWCN
        plG3z2z99RIZB7kSBGpz/Ui5yh9A4td+wE97Cq8G3+n6K8iesYK140maSLmgh64O
        +yothaSjdF59ysWWpAhpWWqyBSLPEAyA6mhfAnMz8m9fE4lVIfyjhu2vPjoUY9K4
        KqYMRk+PZExEJg==
X-ME-Sender: <xms:rQKDXvUec1Rk7ogEFywRisZZKQyGEUn1PBki8e3h4qGEptb-YREGhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeijedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:rQKDXvPOegTJ20cETTv2uf10oAT4ZwhsRuAMkWteI_mcCnPqGMol8g>
    <xmx:rQKDXmm72PxzlRMaVKvkaRU_rmBkNRckNAy-3B96dKN1W26KfvHVXA>
    <xmx:rQKDXkqHlNeOuko7JKCxqiOpIxVWrIzyPh9T4URFNYjb8TKvGw7AEw>
    <xmx:rQKDXm1H6lWOkQJfbV9N0L8iBl__rKCVEeGIDTjEOEN8P2_GFo2QQA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8168F3280063;
        Tue, 31 Mar 2020 04:43:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 1/3] devlink: Add devlink trap policer set and show commands
Date:   Tue, 31 Mar 2020 11:42:51 +0300
Message-Id: <20200331084253.2377588-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331084253.2377588-1-idosch@idosch.org>
References: <20200331084253.2377588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The trap policer set command allows the user to set the parameters of
the packet trap policer, such as rate and burst size. Example:

# devlink trap policer set netdevsim/netdevsim10 policer 1 rate 1000 burst 32

The trap policer show command allows the user to get the current
parameters of an individual policer or a dump of all policers in case
one is not specified. When '-s' is specified the policer's statistics
are shown. Example:

# devlink -jps trap policer show netdevsim/netdevsim10 policer 1
{
    "trap_policer": {
        "netdevsim/netdevsim10": [ {
                "policer": 1,
                "rate": 1000,
                "burst": 32,
                "stats": {
                    "rx": {
                        "dropped": 53
                    }
                }
            } ]
    }
}

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c          | 174 ++++++++++++++++++++++++++++++++++++-
 man/man8/devlink-monitor.8 |   2 +-
 man/man8/devlink-trap.8    |  40 +++++++++
 3 files changed, 213 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 67e6e64181f9..9380792ad423 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -262,6 +262,9 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_TRAP_ACTION		BIT(31)
 #define DL_OPT_TRAP_GROUP_NAME		BIT(32)
 #define DL_OPT_NETNS	BIT(33)
+#define DL_OPT_TRAP_POLICER_ID		BIT(34)
+#define DL_OPT_TRAP_POLICER_RATE	BIT(35)
+#define DL_OPT_TRAP_POLICER_BURST	BIT(36)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -303,6 +306,9 @@ struct dl_opts {
 	enum devlink_trap_action trap_action;
 	bool netns_is_pid;
 	uint32_t netns;
+	uint32_t trap_policer_id;
+	uint64_t trap_policer_rate;
+	uint64_t trap_policer_burst;
 };
 
 struct dl {
@@ -506,12 +512,16 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_METADATA] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = MNL_TYPE_STRING,
 	[DEVLINK_ATTR_RELOAD_FAILED] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
+	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
 };
 
 static const enum mnl_attr_data_type
 devlink_stats_policy[DEVLINK_ATTR_STATS_MAX + 1] = {
 	[DEVLINK_ATTR_STATS_RX_PACKETS] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_STATS_RX_BYTES] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_STATS_RX_DROPPED] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -1490,6 +1500,27 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 				opts->netns_is_pid = true;
 			}
 			o_found |= DL_OPT_NETNS;
+		} else if (dl_argv_match(dl, "policer") &&
+			   (o_all & DL_OPT_TRAP_POLICER_ID)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint32_t(dl, &opts->trap_policer_id);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_POLICER_ID;
+		} else if (dl_argv_match(dl, "rate") &&
+			   (o_all & DL_OPT_TRAP_POLICER_RATE)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint64_t(dl, &opts->trap_policer_rate);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_POLICER_RATE;
+		} else if (dl_argv_match(dl, "burst") &&
+			   (o_all & DL_OPT_TRAP_POLICER_BURST)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint64_t(dl, &opts->trap_policer_burst);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_POLICER_BURST;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -1617,6 +1648,15 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				 opts->netns_is_pid ? DEVLINK_ATTR_NETNS_PID :
 						      DEVLINK_ATTR_NETNS_FD,
 				 opts->netns);
+	if (opts->present & DL_OPT_TRAP_POLICER_ID)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_TRAP_POLICER_ID,
+				 opts->trap_policer_id);
+	if (opts->present & DL_OPT_TRAP_POLICER_RATE)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_TRAP_POLICER_RATE,
+				 opts->trap_policer_rate);
+	if (opts->present & DL_OPT_TRAP_POLICER_BURST)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_TRAP_POLICER_BURST,
+				 opts->trap_policer_burst);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -2058,6 +2098,9 @@ static void pr_out_stats(struct dl *dl, struct nlattr *nla_stats)
 	if (tb[DEVLINK_ATTR_STATS_RX_PACKETS])
 		pr_out_u64(dl, "packets",
 			   mnl_attr_get_u64(tb[DEVLINK_ATTR_STATS_RX_PACKETS]));
+	if (tb[DEVLINK_ATTR_STATS_RX_DROPPED])
+		pr_out_u64(dl, "dropped",
+			   mnl_attr_get_u64(tb[DEVLINK_ATTR_STATS_RX_DROPPED]));
 	pr_out_object_end(dl);
 	pr_out_object_end(dl);
 }
@@ -4141,6 +4184,10 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_GROUP_SET: return "set";
 	case DEVLINK_CMD_TRAP_GROUP_NEW: return "new";
 	case DEVLINK_CMD_TRAP_GROUP_DEL: return "del";
+	case DEVLINK_CMD_TRAP_POLICER_GET: return "get";
+	case DEVLINK_CMD_TRAP_POLICER_SET: return "set";
+	case DEVLINK_CMD_TRAP_POLICER_NEW: return "new";
+	case DEVLINK_CMD_TRAP_POLICER_DEL: return "del";
 	default: return "<unknown cmd>";
 	}
 }
@@ -4185,6 +4232,11 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_GROUP_NEW:
 	case DEVLINK_CMD_TRAP_GROUP_DEL:
 		return "trap-group";
+	case DEVLINK_CMD_TRAP_POLICER_GET:
+	case DEVLINK_CMD_TRAP_POLICER_SET:
+	case DEVLINK_CMD_TRAP_POLICER_NEW:
+	case DEVLINK_CMD_TRAP_POLICER_DEL:
+		return "trap-policer";
 	default: return "<unknown obj>";
 	}
 }
@@ -4239,6 +4291,7 @@ static void pr_out_region(struct dl *dl, struct nlattr **tb);
 static void pr_out_health(struct dl *dl, struct nlattr **tb_health);
 static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
 static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array);
+static void pr_out_trap_policer(struct dl *dl, struct nlattr **tb, bool array);
 
 static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -4339,6 +4392,19 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap_group(dl, tb, false);
 		break;
+	case DEVLINK_CMD_TRAP_POLICER_GET: /* fall through */
+	case DEVLINK_CMD_TRAP_POLICER_SET: /* fall through */
+	case DEVLINK_CMD_TRAP_POLICER_NEW: /* fall through */
+	case DEVLINK_CMD_TRAP_POLICER_DEL: /* fall through */
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_POLICER_ID] ||
+		    !tb[DEVLINK_ATTR_TRAP_POLICER_RATE] ||
+		    !tb[DEVLINK_ATTR_TRAP_POLICER_BURST])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_trap_policer(dl, tb, false);
+		break;
 	}
 	return MNL_CB_OK;
 }
@@ -4355,7 +4421,8 @@ static int cmd_mon_show(struct dl *dl)
 		    strcmp(cur_obj, "port") != 0 &&
 		    strcmp(cur_obj, "health") != 0 &&
 		    strcmp(cur_obj, "trap") != 0 &&
-		    strcmp(cur_obj, "trap-group") != 0) {
+		    strcmp(cur_obj, "trap-group") != 0 &&
+		    strcmp(cur_obj, "trap-policer") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -4372,7 +4439,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port | health | trap | trap-group }\n");
+	       "where  OBJECT-LIST := { dev | port | health | trap | trap-group | trap-policer }\n");
 }
 
 static int cmd_mon(struct dl *dl)
@@ -7002,6 +7069,8 @@ static void cmd_trap_help(void)
 	pr_err("       devlink trap show [ DEV trap TRAP ]\n");
 	pr_err("       devlink trap group set DEV group GROUP [ action { trap | drop } ]\n");
 	pr_err("       devlink trap group show [ DEV group GROUP ]\n");
+	pr_err("       devlink trap policer set DEV policer POLICER [ rate RATE ] [ burst BURST ]\n");
+	pr_err("       devlink trap policer show DEV policer POLICER\n");
 }
 
 static int cmd_trap_show(struct dl *dl)
@@ -7136,6 +7205,104 @@ static int cmd_trap_group(struct dl *dl)
 	return -ENOENT;
 }
 
+static void pr_out_trap_policer(struct dl *dl, struct nlattr **tb, bool array)
+{
+	if (array)
+		pr_out_handle_start_arr(dl, tb);
+	else
+		__pr_out_handle_start(dl, tb, true, false);
+
+	check_indent_newline(dl);
+	print_uint(PRINT_ANY, "policer", "policer %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_TRAP_POLICER_ID]));
+	print_u64(PRINT_ANY, "rate", " rate %llu",
+		   mnl_attr_get_u64(tb[DEVLINK_ATTR_TRAP_POLICER_RATE]));
+	print_u64(PRINT_ANY, "burst", " burst %llu",
+		   mnl_attr_get_u64(tb[DEVLINK_ATTR_TRAP_POLICER_BURST]));
+	if (tb[DEVLINK_ATTR_STATS])
+		pr_out_stats(dl, tb[DEVLINK_ATTR_STATS]);
+	pr_out_handle_end(dl);
+}
+
+static int cmd_trap_policer_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_TRAP_POLICER_ID] ||
+	    !tb[DEVLINK_ATTR_TRAP_POLICER_RATE] ||
+	    !tb[DEVLINK_ATTR_TRAP_POLICER_BURST])
+		return MNL_CB_ERROR;
+
+	pr_out_trap_policer(dl, tb, true);
+
+	return MNL_CB_OK;
+}
+
+static int cmd_trap_policer_show(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_POLICER_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl,
+					DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID,
+					0);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "trap_policer");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_trap_policer_show_cb, dl);
+	pr_out_section_end(dl);
+
+	return err;
+}
+
+static int cmd_trap_policer_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_POLICER_SET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl,
+				DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID,
+				DL_OPT_TRAP_POLICER_RATE |
+				DL_OPT_TRAP_POLICER_BURST);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_trap_policer(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_trap_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_trap_policer_show(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_trap_policer_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_trap(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -7151,6 +7318,9 @@ static int cmd_trap(struct dl *dl)
 	} else if (dl_argv_match(dl, "group")) {
 		dl_arg_inc(dl);
 		return cmd_trap_group(dl);
+	} else if (dl_argv_match(dl, "policer")) {
+		dl_arg_inc(dl);
+		return cmd_trap_policer(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
diff --git a/man/man8/devlink-monitor.8 b/man/man8/devlink-monitor.8
index a96d350f4241..de351f32a1e5 100644
--- a/man/man8/devlink-monitor.8
+++ b/man/man8/devlink-monitor.8
@@ -21,7 +21,7 @@ command is the first in the command line and then the object list.
 .I OBJECT-LIST
 is the list of object types that we want to monitor.
 It may contain
-.BR dev ", " port ", " health ", " trap ", " trap-group .
+.BR dev ", " port ", " health ", " trap ", " trap-group ", " trap-policer .
 
 .B devlink
 opens Devlink Netlink socket, listens on it and dumps state changes.
diff --git a/man/man8/devlink-trap.8 b/man/man8/devlink-trap.8
index db19fe4c7452..113eda4ac790 100644
--- a/man/man8/devlink-trap.8
+++ b/man/man8/devlink-trap.8
@@ -38,6 +38,13 @@ devlink-trap \- devlink trap configuration
 .BI "devlink trap group set " DEV " group " GROUP
 .RB "[ " action " { " trap " | " drop " } ]"
 
+.ti -8
+.BI "devlink trap policer set " DEV " policer " POLICER
+.RB "[ " rate
+.IR "RATE " ]
+.RB "[ " burst
+.IR "BURST " ]
+
 .ti -8
 .B devlink trap help
 
@@ -102,6 +109,24 @@ packet trap action. The action is set for all the packet traps member in the
 trap group. The actions of non-drop traps cannot be changed and are thus
 skipped.
 
+.SS devlink trap policer set - set attributes of packet trap policer
+
+.PP
+.I "DEV"
+- specifies the devlink device the packet trap policer belongs to.
+
+.PP
+.BI "policer " POLICER
+- specifies the packet trap policer.
+
+.PP
+.BI rate " RATE "
+- packet trap policer rate in packets per second.
+
+.PP
+.BI burst " BURST "
+- packet trap policer burst size in packets.
+
 .SH "EXAMPLES"
 .PP
 devlink trap show
@@ -128,6 +153,21 @@ devlink trap set pci/0000:01:00.0 trap source_mac_is_multicast action trap
 .RS 4
 Set the action of a specific packet trap to 'trap'.
 .RE
+.PP
+devlink trap policer show
+.RS 4
+List available packet trap policers.
+.RE
+.PP
+devlink -s trap policer show pci/0000:01:00.0 policer 1
+.RS 4
+Show attributes and statistics of a specific packet trap policer.
+.RE
+.PP
+devlink trap policer set pci/0000:01:00.0 policer 1 rate 1000 burst 128
+.RS 4
+Set the rate and burst size of a specific packet trap policer.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
-- 
2.24.1


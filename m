Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB478B286
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfHMIcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:32:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49541 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728210AbfHMIcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:32:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C60C821D6E;
        Tue, 13 Aug 2019 04:32:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 04:32:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=8ul+8MWIDKHn/mufUIotNBDuzFPFesRqRqCsA9gjdpI=; b=FkbD5jlE
        F7wnErOwfe+rhg+V1Q5lfmg5CZnGVb/2rveIhpYyCQgYfeSTqSJVFXf2VtksVRF3
        kJ5Sjvh4zoI/7YQ5dIGOr0xiGrZOcqhymZBoJUY4VhzzJ8OWU71gIUrUGEl1esI/
        C7746+7+OrRtI99YRF2HNi7T8+HGDBEjmNlg8WuZ0hXD3O9mQrxhSyLQVFgzOhtG
        Atbg3wdKJmvd48U0HDOM8PNHM3bcoQhRN0wN53UVZT8Kg+IJVclKzvv55qIXCTsm
        1+oo4Sikt7CM0gq09mHJpIncJo7fmXOtvB8EWUn5MkrkGcW5tDW2SQnVC1phJF8X
        sXkngNEm1p5EcA==
X-ME-Sender: <xms:j3VSXas4y0CjHayJmqa0FJ5oVOfZ--CUXhzjnvjhJ0q1ybRYrmHGXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:j3VSXdCeWJ6CRk75Y9vGYnvOgJjJHmIW1d84bmIQpASySBMkOhC-VA>
    <xmx:j3VSXcPs2WCK0rzdfZRyj4XQUb2IHaC9qGun250D_7M5WSHdTrkiVA>
    <xmx:j3VSXWzV-axvn5CxUek-gaAtKKFPnIxP3jEjEiz7zsdO_qS47YJ9YA>
    <xmx:j3VSXf67BvucfHbazEnlyBcAAD1az7n7cb3tDaG3HjXV5VDz5WeT5g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C7418005A;
        Tue, 13 Aug 2019 04:32:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 3/4] devlink: Add devlink trap group set and show commands
Date:   Tue, 13 Aug 2019 11:31:42 +0300
Message-Id: <20190813083143.13509-4-idosch@idosch.org>
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

These commands are similar to the trap set and show commands, but
operate on a trap group and not individual traps. Example:

# devlink trap group set netdevsim/netdevsim10 group l3_drops action trap
# devlink -jps trap group show netdevsim/netdevsim10 group l3_drops
{
    "trap_group": {
        "netdevsim/netdevsim10": [ {
                "name": "l3_drops",
                "generic": true,
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
 devlink/devlink.c | 135 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 133 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 81fff4429841..2f084c020765 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -235,6 +235,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(28)
 #define DL_OPT_TRAP_NAME		BIT(29)
 #define DL_OPT_TRAP_ACTION		BIT(30)
+#define DL_OPT_TRAP_GROUP_NAME		BIT(31)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -272,6 +273,7 @@ struct dl_opts {
 	uint64_t reporter_graceful_period;
 	bool reporter_auto_recover;
 	const char *trap_name;
+	const char *trap_group_name;
 	enum devlink_trap_action trap_action;
 };
 
@@ -1092,6 +1094,7 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_REGION_LENGTH,	      "Region length value expected."},
 	{DL_OPT_HEALTH_REPORTER_NAME, "Reporter's name is expected."},
 	{DL_OPT_TRAP_NAME,            "Trap's name is expected."},
+	{DL_OPT_TRAP_GROUP_NAME,      "Trap group's name is expected."},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1388,6 +1391,13 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_TRAP_NAME;
+		} else if (dl_argv_match(dl, "group") &&
+			   (o_all & DL_OPT_TRAP_GROUP_NAME)) {
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &opts->trap_group_name);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_GROUP_NAME;
 		} else if (dl_argv_match(dl, "action") &&
 			   (o_all & DL_OPT_TRAP_ACTION)) {
 			const char *actionstr;
@@ -1516,6 +1526,9 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_TRAP_NAME)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_TRAP_NAME,
 				  opts->trap_name);
+	if (opts->present & DL_OPT_TRAP_GROUP_NAME)
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_TRAP_GROUP_NAME,
+				  opts->trap_group_name);
 	if (opts->present & DL_OPT_TRAP_ACTION)
 		mnl_attr_put_u8(nlh, DEVLINK_ATTR_TRAP_ACTION,
 				opts->trap_action);
@@ -3869,6 +3882,10 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_SET: return "set";
 	case DEVLINK_CMD_TRAP_NEW: return "new";
 	case DEVLINK_CMD_TRAP_DEL: return "del";
+	case DEVLINK_CMD_TRAP_GROUP_GET: return "get";
+	case DEVLINK_CMD_TRAP_GROUP_SET: return "set";
+	case DEVLINK_CMD_TRAP_GROUP_NEW: return "new";
+	case DEVLINK_CMD_TRAP_GROUP_DEL: return "del";
 	default: return "<unknown cmd>";
 	}
 }
@@ -3902,6 +3919,11 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_NEW:
 	case DEVLINK_CMD_TRAP_DEL:
 		return "trap";
+	case DEVLINK_CMD_TRAP_GROUP_GET:
+	case DEVLINK_CMD_TRAP_GROUP_SET:
+	case DEVLINK_CMD_TRAP_GROUP_NEW:
+	case DEVLINK_CMD_TRAP_GROUP_DEL:
+		return "trap-group";
 	default: return "<unknown obj>";
 	}
 }
@@ -3928,6 +3950,7 @@ static bool cmd_filter_check(struct dl *dl, uint8_t cmd)
 
 static void pr_out_region(struct dl *dl, struct nlattr **tb);
 static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
+static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array);
 
 static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -3999,6 +4022,18 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap(dl, tb, false);
 		break;
+	case DEVLINK_CMD_TRAP_GROUP_GET: /* fall through */
+	case DEVLINK_CMD_TRAP_GROUP_SET: /* fall through */
+	case DEVLINK_CMD_TRAP_GROUP_NEW: /* fall through */
+	case DEVLINK_CMD_TRAP_GROUP_DEL:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_GROUP_NAME] ||
+		    !tb[DEVLINK_ATTR_STATS])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_trap_group(dl, tb, false);
+		break;
 	}
 	return MNL_CB_OK;
 }
@@ -4013,7 +4048,8 @@ static int cmd_mon_show(struct dl *dl)
 		if (strcmp(cur_obj, "all") != 0 &&
 		    strcmp(cur_obj, "dev") != 0 &&
 		    strcmp(cur_obj, "port") != 0 &&
-		    strcmp(cur_obj, "trap") != 0) {
+		    strcmp(cur_obj, "trap") != 0 &&
+		    strcmp(cur_obj, "trap-group") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -4030,7 +4066,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port | trap }\n");
+	       "where  OBJECT-LIST := { dev | port | trap | trap-group }\n");
 }
 
 static int cmd_mon(struct dl *dl)
@@ -6546,6 +6582,8 @@ static void cmd_trap_help(void)
 {
 	pr_err("Usage: devlink trap set DEV trap TRAP [ action { trap | drop } ]\n");
 	pr_err("       devlink trap show [ DEV trap TRAP ]\n");
+	pr_err("       devlink trap group set DEV group GROUP [ action { trap | drop } ]\n");
+	pr_err("       devlink trap group show [ DEV group GROUP ]\n");
 }
 
 static int cmd_trap_show(struct dl *dl)
@@ -6589,6 +6627,96 @@ static int cmd_trap_set(struct dl *dl)
 	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
 }
 
+static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array)
+{
+	if (array)
+		pr_out_handle_start_arr(dl, tb);
+	else
+		__pr_out_handle_start(dl, tb, true, false);
+
+	pr_out_str(dl, "name",
+		   mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
+	pr_out_bool(dl, "generic", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
+	pr_out_stats(dl, tb[DEVLINK_ATTR_STATS]);
+	pr_out_handle_end(dl);
+}
+
+static int cmd_trap_group_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_TRAP_GROUP_NAME] || !tb[DEVLINK_ATTR_STATS])
+		return MNL_CB_ERROR;
+
+	pr_out_trap_group(dl, tb, true);
+
+	return MNL_CB_OK;
+}
+
+static int cmd_trap_group_show(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_GROUP_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl,
+					DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
+					0);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "trap_group");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_trap_group_show_cb, dl);
+	pr_out_section_end(dl);
+
+	return err;
+}
+
+static int cmd_trap_group_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_GROUP_SET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl,
+				DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
+				DL_OPT_TRAP_ACTION);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_trap_group(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_trap_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_trap_group_show(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_trap_group_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_trap(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -6601,6 +6729,9 @@ static int cmd_trap(struct dl *dl)
 	} else if (dl_argv_match(dl, "set")) {
 		dl_arg_inc(dl);
 		return cmd_trap_set(dl);
+	} else if (dl_argv_match(dl, "group")) {
+		dl_arg_inc(dl);
+		return cmd_trap_group(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
-- 
2.21.0


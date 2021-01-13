Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9261C2F4C58
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbhAMNkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbhAMNkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 08:40:42 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87416C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 05:40:01 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id h17so1437126wmq.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 05:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XdxJTvWvaHBiV3VIQ3bPCNJD5OxTrXOwIIXGgEKqopw=;
        b=bfJiaWwk7XKTpcQhtV/hZ1zJrLN5nh0dNnDFuy1W0erG3Bty/R8BE0gzh77lNyAjjm
         tjUiPSUthC6Bvml2tHA5PEMbmMVJbzxkT/bAX4rgPAFLhjRJcvnilqT1FM13tNUDKdyl
         uaxD5e217MTk4VKe04Vphm0fBEjSPC+Z15wZsK6cl+PzS12KSouLGtx2kmyj8k42tT2z
         gUa0clzj/2ga0AKyakLEwdDgfuc5lANvP2PZKLPeINMGMyftx/nw7s97WAM3zmTOm5OP
         mUjYgNPYloM+coxjmdHUlcLvjDvSYuQLdtVH0iz9gydcOHQ0BcP6V7913LOAXyV5g8sC
         yvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XdxJTvWvaHBiV3VIQ3bPCNJD5OxTrXOwIIXGgEKqopw=;
        b=RcJtxQJItppPYdwrd62dBfhuLeE3X/c/fgEKN/mmp+STZkXlArlTWixWxebCouaVCt
         SSjtO75c14Jqi9L4X1fRJgjb/gtrISMuKQpiSSo+R+RidT/UYNV1yyfPwUOZ2/YqdEY9
         DVGtINC8/pxqHI6VRKk1ysarehmC2Kb/CNOMB3EbvUwDnSeDA0N+GgCZnIQzXeUcibMd
         5Vzw8SpyvlZkXAXk0oTvZSwzJRXfFRZD0efnaQ8jnabLp7gQy8Dj3P9LoHW+52ShZFhG
         HbCzcarFoxAT0tJb44NrLPP0fob3+rjEq4w/9ai2V4SHsraxZckS3ZPZLAjNu7Gwi8f2
         +5RA==
X-Gm-Message-State: AOAM531LaTNyWTqNDW9Cd69PnE1DlqCxeGmtJLq6Bv+Nm6H56W8yEcA/
        4ZbKvAPonHAYBhWuwfxF+byu9vPtWYwmSfgz
X-Google-Smtp-Source: ABdhPJzN2AIWgE1DEj38flgEiOyewRTiZHK25h5gzklTiq+/xKIRKX7W/1zLByR+2CDfrztRB6BbOQ==
X-Received: by 2002:a7b:c842:: with SMTP id c2mr2280614wml.100.1610545199815;
        Wed, 13 Jan 2021 05:39:59 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id j2sm3394191wrh.78.2021.01.13.05.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 05:39:59 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: [patch iproute2/net-next RFC] devlink: add support for linecard show and provision
Date:   Wed, 13 Jan 2021 14:39:58 +0100
Message-Id: <20210113133958.736884-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
References: <20210113121222.733517-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 218 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 214 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index a2e066441e8a..960f1078591e 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -306,6 +306,8 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_FLASH_OVERWRITE		BIT(39)
 #define DL_OPT_RELOAD_ACTION		BIT(40)
 #define DL_OPT_RELOAD_LIMIT	BIT(41)
+#define DL_OPT_LINECARD		BIT(42)
+#define DL_OPT_LINECARD_TYPE	BIT(43)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -356,6 +358,8 @@ struct dl_opts {
 	uint32_t overwrite_mask;
 	enum devlink_reload_action reload_action;
 	enum devlink_reload_limit reload_limit;
+	uint32_t linecard_index;
+	const char *linecard_type;
 };
 
 struct dl {
@@ -1414,6 +1418,8 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_TRAP_NAME,            "Trap's name is expected."},
 	{DL_OPT_TRAP_GROUP_NAME,      "Trap group's name is expected."},
 	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expected."},
+	{DL_OPT_LINECARD,	      "Linecard index expected."},
+	{DL_OPT_LINECARD_TYPE,	      "Linecard type expected."},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1832,7 +1838,20 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_FUNCTION_HW_ADDR;
-
+		} else if (dl_argv_match(dl, "lc") &&
+			   (o_all & DL_OPT_LINECARD)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint32_t(dl, &opts->linecard_index);
+			if (err)
+				return err;
+			o_found |= DL_OPT_LINECARD;
+		} else if (dl_argv_match(dl, "type") &&
+			   (o_all & DL_OPT_LINECARD_TYPE)) {
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &opts->linecard_type);
+			if (err)
+				return err;
+			o_found |= DL_OPT_LINECARD_TYPE;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -2015,6 +2034,12 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				 opts->trap_policer_burst);
 	if (opts->present & DL_OPT_PORT_FUNCTION_HW_ADDR)
 		dl_function_attr_put(nlh, opts);
+	if (opts->present & DL_OPT_LINECARD)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_LINECARD_INDEX,
+				 opts->linecard_index);
+	if (opts->present & DL_OPT_LINECARD_TYPE)
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_LINECARD_TYPE,
+				  opts->linecard_type);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -2036,6 +2061,7 @@ static bool dl_dump_filter(struct dl *dl, struct nlattr **tb)
 	struct nlattr *attr_dev_name = tb[DEVLINK_ATTR_DEV_NAME];
 	struct nlattr *attr_port_index = tb[DEVLINK_ATTR_PORT_INDEX];
 	struct nlattr *attr_sb_index = tb[DEVLINK_ATTR_SB_INDEX];
+	struct nlattr *attr_linecard_index = tb[DEVLINK_ATTR_LINECARD_INDEX];
 
 	if (opts->present & DL_OPT_HANDLE &&
 	    attr_bus_name && attr_dev_name) {
@@ -2063,6 +2089,12 @@ static bool dl_dump_filter(struct dl *dl, struct nlattr **tb)
 		if (sb_index != opts->sb_index)
 			return false;
 	}
+	if (opts->present & DL_OPT_LINECARD && attr_linecard_index) {
+		uint32_t linecard_index = mnl_attr_get_u32(attr_linecard_index);
+
+		if (linecard_index != opts->linecard_index)
+			return false;
+	}
 	return true;
 }
 
@@ -3833,6 +3865,9 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 			break;
 		}
 	}
+	if (tb[DEVLINK_ATTR_LINECARD_INDEX])
+		print_uint(PRINT_ANY, "lc", " lc %u",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_LINECARD_INDEX]));
 	if (tb[DEVLINK_ATTR_PORT_NUMBER]) {
 		uint32_t port_number;
 
@@ -4005,6 +4040,156 @@ static int cmd_port(struct dl *dl)
 	return -ENOENT;
 }
 
+static void cmd_linecard_help(void)
+{
+	pr_err("Usage: devlink lc show [ DEV [ lc LC_INDEX ] ]\n");
+	pr_err("       devlink lc provision DEV lc LC_INDEX type LC_TYPE\n");
+	pr_err("       devlink lc unprovision DEV lc LC_INDEX\n");
+}
+
+static const char *linecard_state_name(uint16_t flavour)
+{
+	switch (flavour) {
+	case DEVLINK_LINECARD_STATE_UNPROVISIONED:
+		return "unprovisioned";
+	case DEVLINK_LINECARD_STATE_UNPROVISIONING:
+		return "unprovisioning";
+	case DEVLINK_LINECARD_STATE_PROVISIONING:
+		return "provisioning";
+	case DEVLINK_LINECARD_STATE_PROVISIONED:
+		return "provisioned";
+	case DEVLINK_LINECARD_STATE_ACTIVE:
+		return "active";
+	default:
+		return "<unknown state>";
+	}
+}
+
+static void pr_out_linecard_supported_types(struct dl *dl, struct nlattr **tb)
+{
+	struct nlattr *nla_types = tb[DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES];
+	struct nlattr *nla_type;
+
+	if (!nla_types)
+		return;
+
+	pr_out_array_start(dl, "supported_types");
+	check_indent_newline(dl);
+	mnl_attr_for_each_nested(nla_type, nla_types) {
+		print_string(PRINT_ANY, NULL, " %s",
+			     mnl_attr_get_str(nla_type));
+	}
+	pr_out_array_end(dl);
+}
+
+static void pr_out_linecard(struct dl *dl, struct nlattr **tb)
+{
+	uint8_t state;
+
+	pr_out_handle_start_arr(dl, tb);
+	check_indent_newline(dl);
+	print_uint(PRINT_ANY, "lc", "lc %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_LINECARD_INDEX]));
+	state = mnl_attr_get_u8(tb[DEVLINK_ATTR_LINECARD_STATE]);
+	print_string(PRINT_ANY, "state", " state %s",
+		     linecard_state_name(state));
+	if (tb[DEVLINK_ATTR_LINECARD_TYPE])
+		print_string(PRINT_ANY, "type", " type %s",
+			     mnl_attr_get_str(tb[DEVLINK_ATTR_LINECARD_TYPE]));
+	pr_out_linecard_supported_types(dl, tb);
+	pr_out_handle_end(dl);
+}
+
+static int cmd_linecard_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct dl *dl = data;
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_LINECARD_INDEX] ||
+	    !tb[DEVLINK_ATTR_LINECARD_STATE])
+		return MNL_CB_ERROR;
+	pr_out_linecard(dl, tb);
+	return MNL_CB_OK;
+}
+
+static int cmd_linecard_show(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_LINECARD_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE,
+					DL_OPT_LINECARD);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "lc");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_linecard_show_cb, dl);
+	pr_out_section_end(dl);
+	return err;
+}
+
+static int cmd_linecard_provision(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_LINECARD_PROVISION,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_LINECARD |
+					 DL_OPT_LINECARD_TYPE, 0);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_linecard_unprovision(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_LINECARD_UNPROVISION,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_LINECARD, 0);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_linecard(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_linecard_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_linecard_show(dl);
+	} else if (dl_argv_match(dl, "provision")) {
+		dl_arg_inc(dl);
+		return cmd_linecard_provision(dl);
+	} else if (dl_argv_match(dl, "unprovision")) {
+		dl_arg_inc(dl);
+		return cmd_linecard_unprovision(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static void cmd_sb_help(void)
 {
 	pr_err("Usage: devlink sb show [ DEV [ sb SB_INDEX ] ]\n");
@@ -4818,6 +5003,10 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_POLICER_SET: return "set";
 	case DEVLINK_CMD_TRAP_POLICER_NEW: return "new";
 	case DEVLINK_CMD_TRAP_POLICER_DEL: return "del";
+	case DEVLINK_CMD_LINECARD_GET: return "get";
+	case DEVLINK_CMD_LINECARD_SET: return "set";
+	case DEVLINK_CMD_LINECARD_NEW: return "new";
+	case DEVLINK_CMD_LINECARD_DEL: return "del";
 	default: return "<unknown cmd>";
 	}
 }
@@ -4867,6 +5056,11 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_POLICER_NEW:
 	case DEVLINK_CMD_TRAP_POLICER_DEL:
 		return "trap-policer";
+	case DEVLINK_CMD_LINECARD_GET:
+	case DEVLINK_CMD_LINECARD_SET:
+	case DEVLINK_CMD_LINECARD_NEW:
+	case DEVLINK_CMD_LINECARD_DEL:
+		return "lc";
 	default: return "<unknown obj>";
 	}
 }
@@ -5059,6 +5253,18 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap_policer(dl, tb, false);
 		break;
+	case DEVLINK_CMD_LINECARD_GET: /* fall through */
+	case DEVLINK_CMD_LINECARD_SET: /* fall through */
+	case DEVLINK_CMD_LINECARD_NEW: /* fall through */
+	case DEVLINK_CMD_LINECARD_DEL:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_LINECARD_INDEX])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_linecard(dl, tb);
+		pr_out_mon_footer();
+		break;
 	}
 	fflush(stdout);
 	return MNL_CB_OK;
@@ -5077,7 +5283,8 @@ static int cmd_mon_show(struct dl *dl)
 		    strcmp(cur_obj, "health") != 0 &&
 		    strcmp(cur_obj, "trap") != 0 &&
 		    strcmp(cur_obj, "trap-group") != 0 &&
-		    strcmp(cur_obj, "trap-policer") != 0) {
+		    strcmp(cur_obj, "trap-policer") != 0 &&
+		    strcmp(cur_obj, "lc") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -5098,7 +5305,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port | health | trap | trap-group | trap-policer }\n");
+	       "where  OBJECT-LIST := { dev | port | lc | health | trap | trap-group | trap-policer }\n");
 }
 
 static int cmd_mon(struct dl *dl)
@@ -8073,7 +8280,7 @@ static void help(void)
 {
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
-	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
+	       "where  OBJECT := { dev | port | lc | sb | monitor | dpipe | resource | region | health | trap }\n"
 	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
 }
 
@@ -8112,6 +8319,9 @@ static int dl_cmd(struct dl *dl, int argc, char **argv)
 	} else if (dl_argv_match(dl, "trap")) {
 		dl_arg_inc(dl);
 		return cmd_trap(dl);
+	} else if (dl_argv_match(dl, "lc")) {
+		dl_arg_inc(dl);
+		return cmd_linecard(dl);
 	}
 	pr_err("Object \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
-- 
2.26.2


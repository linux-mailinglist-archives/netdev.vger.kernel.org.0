Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DF858B2CF
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 01:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241894AbiHEXmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 19:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241891AbiHEXmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 19:42:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C5318E28
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659742925; x=1691278925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QvZPCG2T6UjRzJ46Eai/CRvwQ46M/A105xotA70d/2w=;
  b=YeAyIxrEx071C94l97oPde7tMAvD6BUPKvk+XtY+w5GoVr/f+TumeiAS
   jEvA7cJ/5Q/TZ6oJDrcMgfV97XDS1bYvB6i/BSk/yDAC+isgqEbfDfR95
   m4D/jI6TZwLsADM86015DEKcHKMnvS/JqpvyST0R0N4M0r2/pGXiWkx+w
   UsD8M29p7OtRam4jU0nHv8Q0KCNmNFUcEGC5bG0la2INUCU4ddYPTTMHx
   vwQEnV9WptfM5AlNBdGzhqYa4JzShiVbwBIs+HeTQ12K9nYK/cXgvfX6X
   3+lk8UlU7GrTaWXzC5XRRBdykocNo7k38rSjGN1FeCoT9gx8JmVehIjvD
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="289072938"
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="289072938"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="931401669"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:03 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 6/6] devlink: check attributes against policy
Date:   Fri,  5 Aug 2022 16:41:55 -0700
Message-Id: <20220805234155.2878160-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
In-Reply-To: <20220805234155.2878160-1-jacob.e.keller@intel.com>
References: <20220805234155.2878160-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current versions of the Linux kernel do not strictly validate attributes
for some devlink commands. Additionally, these kernels also report a fixed
policy for all commands rather than using a separate policy tailored to the
attributes accepted by that specific command.

This could lead to problems in the future if a new attribute is added to an
existing command. Userspace might issue a command and expect some behavior,
but the kernel could be silently ignoring the attribute.

To protect against this, modify the devlink userspace to check each
attribute before adding it to the header. This relies on the recently added
mnlu_gen_get_op_policy function that will extract the policy for the
command from the kernel.

Each attribute is checked to make sure the kernel recognizes it as valid
for the command. This ensures that the devlink userspace won't add an
attribute which is not supported by the kernel.

This definitely protects the userspace from silently passing unknown
attributes: the kernel policy would not include any attributes which are
not known at the point of its compilation. This is equivalent to checking
the maximum attribute repoorted by CTRL_CMD_GETFAMILY.

This is also a necessary step for protecting against an attribute which the
kernel knows about in one version, but only becomes accepted by a command
in a later version. Once the kernel has been fixed to provide per-command
policy instead of sharing the same policy for all commands, this code will
also help protect against accidentally sending an attribute not honored by
the kernel.

Given the amount of places which need to handle the DL_OPT_* ->
DEVLINK_ATTR_*, it might be worth investigating addition of a structured
lookup table or other flow to reduce some of this duplicated work.

It might also be worth adding a single helper which does
dl_argv_parse_checked, mnlu_gen_socket_cmd_prepare and then dl_opts_put.
This combination is done for almost all devlink commands.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 452 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 347 insertions(+), 105 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 67a57e9ba550..ae017bb2a5bf 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2083,6 +2083,206 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 	return dl_args_finding_required_validate(o_required, o_found);
 }
 
+static int dl_opts_check(struct dl *dl, uint32_t cmd)
+{
+	struct dl_opts *opts = &dl->opts;
+	struct mnlu_attr_policy *policy;
+	int err;
+
+	policy = calloc(DEVLINK_ATTR_MAX + 1, sizeof(*policy));
+	if (!policy)
+		return -ENOMEM;
+
+	/* We only check the DO policy currently, since none of the commands
+	 * with NLM_F_DUMP send any attributes.
+	 */
+	err = mnlu_gen_get_op_policy(&dl->nlg, cmd, false, policy);
+	if (err)
+		return err;
+
+	if (opts->present & DL_OPT_HANDLE) {
+		if (!policy[DEVLINK_ATTR_BUS_NAME].valid ||
+		    !policy[DEVLINK_ATTR_DEV_NAME].valid)
+			return -EOPNOTSUPP;
+	} else if (opts->present & DL_OPT_HANDLEP) {
+		if (!policy[DEVLINK_ATTR_BUS_NAME].valid ||
+		    !policy[DEVLINK_ATTR_DEV_NAME].valid ||
+		    !policy[DEVLINK_ATTR_PORT_INDEX].valid)
+			return -EOPNOTSUPP;
+	} else if (opts->present & DL_OPT_HANDLE_REGION) {
+		if (!policy[DEVLINK_ATTR_BUS_NAME].valid ||
+		    !policy[DEVLINK_ATTR_DEV_NAME].valid ||
+		    !policy[DEVLINK_ATTR_REGION_NAME].valid)
+			return -EOPNOTSUPP;
+	} else if (opts->present & DL_OPT_PORT_FN_RATE_NODE_NAME) {
+		if (!policy[DEVLINK_ATTR_BUS_NAME].valid ||
+		    !policy[DEVLINK_ATTR_DEV_NAME].valid ||
+		    !policy[DEVLINK_ATTR_RATE_NODE_NAME].valid)
+			return -EOPNOTSUPP;
+	}
+	if (opts->present & DL_OPT_PORT_TYPE)
+		if (!policy[DEVLINK_ATTR_PORT_TYPE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PORT_COUNT)
+		if (!policy[DEVLINK_ATTR_PORT_SPLIT_COUNT].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_SB)
+		if (!policy[DEVLINK_ATTR_SB_INDEX].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_SB_POOL)
+		if (!policy[DEVLINK_ATTR_SB_POOL_INDEX].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_SB_SIZE)
+		if (!policy[DEVLINK_ATTR_SB_POOL_SIZE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_SB_TYPE)
+		if (!policy[DEVLINK_ATTR_SB_POOL_TYPE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_SB_THTYPE)
+		if (!policy[DEVLINK_ATTR_SB_POOL_THRESHOLD_TYPE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_SB_TH)
+		if (!policy[DEVLINK_ATTR_SB_THRESHOLD].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_SB_TC)
+		if (!policy[DEVLINK_ATTR_SB_TC_INDEX].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_ESWITCH_MODE)
+		if (!policy[DEVLINK_ATTR_ESWITCH_MODE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_ESWITCH_INLINE_MODE)
+		if (!policy[DEVLINK_ATTR_ESWITCH_INLINE_MODE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_DPIPE_TABLE_NAME)
+		if (!policy[DEVLINK_ATTR_DPIPE_TABLE_NAME].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_DPIPE_TABLE_COUNTERS)
+		if (!policy[DEVLINK_ATTR_DPIPE_TABLE_COUNTERS_ENABLED].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_ESWITCH_ENCAP_MODE)
+		if (!policy[DEVLINK_ATTR_ESWITCH_ENCAP_MODE].valid)
+			return -EOPNOTSUPP;
+	if ((opts->present & DL_OPT_RESOURCE_PATH) && opts->resource_id_valid)
+		if (!policy[DEVLINK_ATTR_RESOURCE_ID].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_RESOURCE_SIZE)
+		if (!policy[DEVLINK_ATTR_RESOURCE_SIZE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PARAM_NAME)
+		if (!policy[DEVLINK_ATTR_PARAM_NAME].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PARAM_CMODE)
+		if (!policy[DEVLINK_ATTR_PARAM_VALUE_CMODE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_REGION_SNAPSHOT_ID)
+		if (!policy[DEVLINK_ATTR_REGION_SNAPSHOT_ID].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_REGION_ADDRESS)
+		if (!policy[DEVLINK_ATTR_REGION_CHUNK_ADDR].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_REGION_LENGTH)
+		if (!policy[DEVLINK_ATTR_REGION_CHUNK_LEN].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_FLASH_FILE_NAME)
+		if (!policy[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_FLASH_COMPONENT)
+		if (!policy[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_FLASH_OVERWRITE)
+		if (!policy[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_HEALTH_REPORTER_NAME)
+		if (!policy[DEVLINK_ATTR_HEALTH_REPORTER_NAME].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD)
+		if (!policy[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_HEALTH_REPORTER_AUTO_RECOVER)
+		if (!policy[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_HEALTH_REPORTER_AUTO_DUMP)
+		if (!policy[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_TRAP_NAME)
+		if (!policy[DEVLINK_ATTR_TRAP_NAME].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_TRAP_GROUP_NAME)
+		if (!policy[DEVLINK_ATTR_TRAP_GROUP_NAME].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_TRAP_ACTION)
+		if (!policy[DEVLINK_ATTR_TRAP_ACTION].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_NETNS)
+		if (!policy[opts->netns_is_pid ? DEVLINK_ATTR_NETNS_PID :
+		    DEVLINK_ATTR_NETNS_FD].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_RELOAD_ACTION)
+		if (!policy[DEVLINK_ATTR_RELOAD_ACTION].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_RELOAD_LIMIT)
+		if (!policy[DEVLINK_ATTR_RELOAD_LIMITS].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_TRAP_POLICER_ID)
+		if (!policy[DEVLINK_ATTR_TRAP_POLICER_ID].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_TRAP_POLICER_RATE)
+		if (!policy[DEVLINK_ATTR_TRAP_POLICER_RATE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_TRAP_POLICER_BURST)
+		if (!policy[DEVLINK_ATTR_TRAP_POLICER_BURST].valid)
+			return -EOPNOTSUPP;
+	/* TODO: figure how to properly handle nested attributes? */
+	if (opts->present & (DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE))
+		if (!policy[DEVLINK_ATTR_PORT_FUNCTION].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PORT_FLAVOUR)
+		if (!policy[DEVLINK_ATTR_PORT_FLAVOUR].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PORT_PFNUMBER)
+		if (!policy[DEVLINK_ATTR_PORT_PCI_PF_NUMBER].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PORT_SFNUMBER)
+		if (!policy[DEVLINK_ATTR_PORT_PCI_SF_NUMBER].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PORT_CONTROLLER)
+		if (!policy[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PORT_FN_RATE_TYPE)
+		if (!policy[DEVLINK_ATTR_RATE_TYPE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_SHARE)
+		if (!policy[DEVLINK_ATTR_RATE_TX_SHARE].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_MAX)
+		if (!policy[DEVLINK_ATTR_RATE_TX_MAX].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_PORT_FN_RATE_PARENT)
+		if (!policy[DEVLINK_ATTR_RATE_PARENT_NODE_NAME].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_LINECARD)
+		if (!policy[DEVLINK_ATTR_LINECARD_INDEX].valid)
+			return -EOPNOTSUPP;
+	if (opts->present & DL_OPT_LINECARD_TYPE)
+		if (!policy[DEVLINK_ATTR_LINECARD_TYPE].valid)
+			return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int dl_argv_parse_checked(struct dl *dl, uint32_t cmd,
+				 uint64_t o_required,
+				 uint64_t o_optional)
+{
+	int err;
+
+	err = dl_argv_parse(dl, o_required, o_optional);
+	if (err)
+		return err;
+
+	return dl_opts_check(dl, cmd);
+}
+
 static void
 dl_function_attr_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
 {
@@ -2806,7 +3006,8 @@ static int cmd_dev_eswitch_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_ESWITCH_GET,
+				    DL_OPT_HANDLE, 0);
 	if (err)
 		return err;
 
@@ -2826,10 +3027,9 @@ static int cmd_dev_eswitch_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE,
-			    DL_OPT_ESWITCH_MODE |
-			    DL_OPT_ESWITCH_INLINE_MODE |
-			    DL_OPT_ESWITCH_ENCAP_MODE);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_ESWITCH_SET,
+				    DL_OPT_HANDLE,
+				    DL_OPT_ESWITCH_MODE | DL_OPT_ESWITCH_INLINE_MODE | DL_OPT_ESWITCH_ENCAP_MODE);
 	if (err)
 		return err;
 
@@ -3201,10 +3401,9 @@ static int cmd_dev_param_set(struct dl *dl)
 	bool val_bool;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE |
-			    DL_OPT_PARAM_NAME |
-			    DL_OPT_PARAM_VALUE |
-			    DL_OPT_PARAM_CMODE, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_PARAM_GET,
+				    DL_OPT_HANDLE | DL_OPT_PARAM_NAME | DL_OPT_PARAM_VALUE | DL_OPT_PARAM_CMODE,
+				    0);
 	if (err)
 		return err;
 
@@ -3332,7 +3531,9 @@ static int cmd_dev_param_show(struct dl *dl)
 	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
 	} else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_PARAM_NAME, 0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_PARAM_GET,
+					    DL_OPT_HANDLE | DL_OPT_PARAM_NAME,
+					    0);
 		if (err)
 			return err;
 	}
@@ -3489,7 +3690,8 @@ static int cmd_dev_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_GET,
+					    DL_OPT_HANDLE, 0);
 		if (err)
 			return err;
 	}
@@ -3565,9 +3767,8 @@ static int cmd_dev_reload(struct dl *dl)
 		return 0;
 	}
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE,
-			    DL_OPT_NETNS | DL_OPT_RELOAD_ACTION |
-			    DL_OPT_RELOAD_LIMIT);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_RELOAD, DL_OPT_HANDLE,
+				    DL_OPT_NETNS | DL_OPT_RELOAD_ACTION | DL_OPT_RELOAD_LIMIT);
 	if (err)
 		return err;
 
@@ -3713,7 +3914,8 @@ static int cmd_dev_info(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_INFO_GET,
+					    DL_OPT_HANDLE, 0);
 		if (err)
 			return err;
 	}
@@ -3976,8 +4178,9 @@ static int cmd_dev_flash(struct dl *dl)
 		return 0;
 	}
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
-			    DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_FLASH_UPDATE,
+				    DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
+				    DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
 	if (err)
 		return err;
 
@@ -4520,7 +4723,8 @@ static int cmd_port_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLEP, 0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_PORT_GET,
+					    DL_OPT_HANDLEP, 0);
 		if (err)
 			return err;
 	}
@@ -4540,7 +4744,8 @@ static int cmd_port_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_PORT_TYPE, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_PORT_SET,
+				    DL_OPT_HANDLEP | DL_OPT_PORT_TYPE, 0);
 	if (err)
 		return err;
 
@@ -4557,7 +4762,8 @@ static int cmd_port_split(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_PORT_COUNT, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_PORT_SPLIT,
+				    DL_OPT_HANDLEP | DL_OPT_PORT_COUNT, 0);
 	if (err)
 		return err;
 
@@ -4574,7 +4780,8 @@ static int cmd_port_unsplit(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLEP, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_PORT_UNSPLIT,
+				    DL_OPT_HANDLEP, 0);
 	if (err)
 		return err;
 
@@ -4596,7 +4803,9 @@ static int cmd_port_param_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_PARAM_NAME, 0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_PORT_PARAM_GET,
+					    DL_OPT_HANDLEP | DL_OPT_PARAM_NAME,
+					    0);
 		if (err)
 			return err;
 	}
@@ -4628,8 +4837,8 @@ static int cmd_port_function_set(struct dl *dl)
 		cmd_port_function_help();
 		return 0;
 	}
-	err = dl_argv_parse(dl, DL_OPT_HANDLEP,
-			    DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_PORT_SET, DL_OPT_HANDLEP,
+				    DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE);
 	if (err)
 		return err;
 
@@ -4720,10 +4929,9 @@ static int cmd_port_param_set(struct dl *dl)
 	bool val_bool;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLEP |
-			    DL_OPT_PARAM_NAME |
-			    DL_OPT_PARAM_VALUE |
-			    DL_OPT_PARAM_CMODE, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_PORT_PARAM_GET,
+				    DL_OPT_HANDLEP | DL_OPT_PARAM_NAME | DL_OPT_PARAM_VALUE | DL_OPT_PARAM_CMODE,
+				    0);
 	if (err)
 		return err;
 
@@ -4953,9 +5161,9 @@ static int cmd_port_fn_rate_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl,
-				    DL_OPT_HANDLEP | DL_OPT_PORT_FN_RATE_NODE_NAME,
-				    0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_RATE_GET,
+					    DL_OPT_HANDLEP | DL_OPT_PORT_FN_RATE_NODE_NAME,
+					    0);
 		if (err)
 			return err;
 	}
@@ -4995,8 +5203,9 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
-			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_RATE_NEW,
+				    DL_OPT_PORT_FN_RATE_NODE_NAME,
+				    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX);
 	if (err)
 		return err;
 
@@ -5020,7 +5229,8 @@ static int cmd_port_fn_rate_del(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_RATE_DEL,
+				    DL_OPT_PORT_FN_RATE_NODE_NAME, 0);
 	if (err)
 		return err;
 
@@ -5155,9 +5365,9 @@ static int cmd_port_add(struct dl *dl)
 		return 0;
 	}
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
-			    DL_OPT_PORT_FLAVOUR | DL_OPT_PORT_PFNUMBER,
-			    DL_OPT_PORT_SFNUMBER | DL_OPT_PORT_CONTROLLER);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_PORT_NEW,
+				    DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_PORT_FLAVOUR | DL_OPT_PORT_PFNUMBER,
+				    DL_OPT_PORT_SFNUMBER | DL_OPT_PORT_CONTROLLER);
 	if (err)
 		return err;
 
@@ -5184,7 +5394,8 @@ static int cmd_port_del(struct dl *dl)
 		return 0;
 	}
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLEP, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_PORT_DEL, DL_OPT_HANDLEP,
+				    0);
 	if (err)
 		return err;
 
@@ -5327,7 +5538,8 @@ static int cmd_linecard_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_LINECARD);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_LINECARD_GET,
+					    DL_OPT_HANDLE, DL_OPT_LINECARD);
 		if (err)
 			return err;
 	}
@@ -5348,8 +5560,9 @@ static int cmd_linecard_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_LINECARD |
-			    DL_OPT_LINECARD_TYPE, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_LINECARD_SET,
+				    DL_OPT_HANDLE | DL_OPT_LINECARD | DL_OPT_LINECARD_TYPE,
+				    0);
 	if (err)
 		return err;
 
@@ -5445,7 +5658,8 @@ static int cmd_sb_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_SB);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_SB_GET,
+					    DL_OPT_HANDLE, DL_OPT_SB);
 		if (err)
 			return err;
 	}
@@ -5524,8 +5738,9 @@ static int cmd_sb_pool_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_SB_POOL,
-				    DL_OPT_SB);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_SB_POOL_GET,
+					    DL_OPT_HANDLE | DL_OPT_SB_POOL,
+					    DL_OPT_SB);
 		if (err)
 			return err;
 	}
@@ -5545,8 +5760,9 @@ static int cmd_sb_pool_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_SB_POOL |
-			    DL_OPT_SB_SIZE | DL_OPT_SB_THTYPE, DL_OPT_SB);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_SB_POOL_SET,
+				    DL_OPT_HANDLE | DL_OPT_SB_POOL | DL_OPT_SB_SIZE | DL_OPT_SB_THTYPE,
+				    DL_OPT_SB);
 	if (err)
 		return err;
 
@@ -5613,8 +5829,9 @@ static int cmd_sb_port_pool_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_SB_POOL,
-				    DL_OPT_SB);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_SB_PORT_POOL_GET,
+					    DL_OPT_HANDLEP | DL_OPT_SB_POOL,
+					    DL_OPT_SB);
 		if (err)
 			return err;
 	}
@@ -5634,8 +5851,9 @@ static int cmd_sb_port_pool_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_SB_POOL | DL_OPT_SB_TH,
-			    DL_OPT_SB);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_SB_PORT_POOL_SET,
+				    DL_OPT_HANDLEP | DL_OPT_SB_POOL | DL_OPT_SB_TH,
+				    DL_OPT_SB);
 	if (err)
 		return err;
 
@@ -5720,8 +5938,10 @@ static int cmd_sb_tc_bind_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_SB_TC |
-				    DL_OPT_SB_TYPE, DL_OPT_SB);
+		err = dl_argv_parse_checked(dl,
+					    DEVLINK_CMD_SB_TC_POOL_BIND_GET,
+					    DL_OPT_HANDLEP | DL_OPT_SB_TC | DL_OPT_SB_TYPE,
+					    DL_OPT_SB);
 		if (err)
 			return err;
 	}
@@ -5741,9 +5961,9 @@ static int cmd_sb_tc_bind_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_SB_TC |
-			    DL_OPT_SB_TYPE | DL_OPT_SB_POOL | DL_OPT_SB_TH,
-			    DL_OPT_SB);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_SB_TC_POOL_BIND_SET,
+				    DL_OPT_HANDLEP | DL_OPT_SB_TC | DL_OPT_SB_TYPE | DL_OPT_SB_POOL | DL_OPT_SB_TH,
+				    DL_OPT_SB);
 	if (err)
 		return err;
 
@@ -6097,7 +6317,8 @@ static int cmd_sb_occ_snapshot(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_SB);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_SB_OCC_SNAPSHOT,
+				    DL_OPT_HANDLE, DL_OPT_SB);
 	if (err)
 		return err;
 
@@ -6114,7 +6335,8 @@ static int cmd_sb_occ_clearmax(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_SB);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_SB_OCC_MAX_CLEAR,
+				    DL_OPT_HANDLE, DL_OPT_SB);
 	if (err)
 		return err;
 
@@ -7023,7 +7245,8 @@ static int cmd_dpipe_headers_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_DPIPE_HEADERS_GET,
+				    DL_OPT_HANDLE, 0);
 	if (err)
 		return err;
 
@@ -7423,7 +7646,8 @@ static int cmd_dpipe_table_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_DPIPE_TABLE_NAME);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_DPIPE_HEADERS_GET,
+				    DL_OPT_HANDLE, DL_OPT_DPIPE_TABLE_NAME);
 	if (err)
 		return err;
 
@@ -7478,8 +7702,9 @@ static int cmd_dpipe_table_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_DPIPE_TABLE_NAME |
-			    DL_OPT_DPIPE_TABLE_COUNTERS, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_DPIPE_TABLE_COUNTERS_SET,
+				    DL_OPT_HANDLE | DL_OPT_DPIPE_TABLE_NAME | DL_OPT_DPIPE_TABLE_COUNTERS,
+				    0);
 	if (err)
 		return err;
 
@@ -7852,7 +8077,9 @@ static int cmd_dpipe_table_dump(struct dl *dl)
 	if (err)
 		return err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_DPIPE_TABLE_NAME, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_DPIPE_HEADERS_GET,
+				    DL_OPT_HANDLE | DL_OPT_DPIPE_TABLE_NAME,
+				    0);
 	if (err)
 		goto out;
 
@@ -8129,7 +8356,8 @@ static int cmd_resource_show(struct dl *dl)
 	struct resource_ctx resource_ctx = {};
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_DPIPE_TABLE_GET,
+				    DL_OPT_HANDLE, 0);
 	if (err)
 		return err;
 
@@ -8229,8 +8457,9 @@ static int cmd_resource_set(struct dl *dl)
 		return err;
 
 	ctx.print_resources = false;
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_RESOURCE_PATH |
-			    DL_OPT_RESOURCE_SIZE, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_RESOURCE_DUMP,
+				    DL_OPT_HANDLE | DL_OPT_RESOURCE_PATH |
+				    DL_OPT_RESOURCE_SIZE, 0);
 	if (err)
 		goto out;
 
@@ -8401,7 +8630,8 @@ static int cmd_region_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION, 0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_REGION_GET,
+					    DL_OPT_HANDLE_REGION, 0);
 		if (err)
 			return err;
 	}
@@ -8421,8 +8651,9 @@ static int cmd_region_snapshot_del(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION |
-			    DL_OPT_REGION_SNAPSHOT_ID, 0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_REGION_DEL,
+				    DL_OPT_HANDLE_REGION | DL_OPT_REGION_SNAPSHOT_ID,
+				    0);
 	if (err)
 		return err;
 
@@ -8473,9 +8704,9 @@ static int cmd_region_dump(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl,
-			    DL_OPT_HANDLE_REGION | DL_OPT_REGION_SNAPSHOT_ID,
-			    0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_REGION_READ,
+				    DL_OPT_HANDLE_REGION | DL_OPT_REGION_SNAPSHOT_ID,
+				    0);
 	if (err)
 		return err;
 
@@ -8497,9 +8728,9 @@ static int cmd_region_read(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION | DL_OPT_REGION_ADDRESS |
-			    DL_OPT_REGION_LENGTH | DL_OPT_REGION_SNAPSHOT_ID,
-			    0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_REGION_READ,
+				    DL_OPT_HANDLE_REGION | DL_OPT_REGION_ADDRESS | DL_OPT_REGION_LENGTH | DL_OPT_REGION_SNAPSHOT_ID,
+				    0);
 	if (err)
 		return err;
 
@@ -8538,8 +8769,9 @@ static int cmd_region_snapshot_new(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION,
-			    DL_OPT_REGION_SNAPSHOT_ID);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_REGION_NEW,
+				    DL_OPT_HANDLE_REGION,
+				    DL_OPT_REGION_SNAPSHOT_ID);
 	if (err)
 		return err;
 
@@ -8595,15 +8827,16 @@ static int cmd_health_set_params(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_SET,
-			       NLM_F_REQUEST | NLM_F_ACK);
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_REPORTER_NAME,
-			    DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD |
-			    DL_OPT_HEALTH_REPORTER_AUTO_RECOVER |
-			    DL_OPT_HEALTH_REPORTER_AUTO_DUMP);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_HEALTH_REPORTER_SET,
+				    DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_REPORTER_NAME,
+				    DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD |
+				    DL_OPT_HEALTH_REPORTER_AUTO_RECOVER |
+				    DL_OPT_HEALTH_REPORTER_AUTO_DUMP);
 	if (err)
 		return err;
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_SET,
+			       NLM_F_REQUEST | NLM_F_ACK);
 	dl_opts_put(nlh, dl);
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -8613,9 +8846,10 @@ static int cmd_health_dump_clear(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
-			    DL_OPT_HEALTH_REPORTER_NAME,
-			    0);
+	err = dl_argv_parse_checked(dl,
+				    DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,
+				    DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_REPORTER_NAME,
+				    0);
 	if (err)
 		return err;
 
@@ -8866,9 +9100,9 @@ static int cmd_health_object_common(struct dl *dl, uint8_t cmd, uint16_t flags)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl,
-			    DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_REPORTER_NAME,
-			    0);
+	err = dl_argv_parse_checked(dl, cmd,
+				    DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_REPORTER_NAME,
+				    0);
 	if (err)
 		return err;
 
@@ -8908,9 +9142,9 @@ static int cmd_health_recover(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
-			    DL_OPT_HEALTH_REPORTER_NAME,
-			    0);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_HEALTH_REPORTER_RECOVER,
+				    DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_REPORTER_NAME,
+				    0);
 	if (err)
 		return err;
 
@@ -9088,9 +9322,10 @@ static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port)
 		flags |= NLM_F_DUMP;
 	} else {
 		ctx.show_port = true;
-		err = dl_argv_parse(dl,
-				    DL_OPT_HANDLE | DL_OPT_HANDLEP |
-				    DL_OPT_HEALTH_REPORTER_NAME, 0);
+		err = dl_argv_parse_checked(dl,
+					    DEVLINK_CMD_HEALTH_REPORTER_GET,
+					    DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_REPORTER_NAME,
+					    0);
 		if (err)
 			return err;
 	}
@@ -9282,7 +9517,9 @@ static int cmd_trap_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_TRAP_NAME, 0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_TRAP_GET,
+					    DL_OPT_HANDLE | DL_OPT_TRAP_NAME,
+					    0);
 		if (err)
 			return err;
 	}
@@ -9303,8 +9540,9 @@ static int cmd_trap_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_TRAP_NAME,
-			    DL_OPT_TRAP_ACTION);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_TRAP_SET,
+				    DL_OPT_HANDLE | DL_OPT_TRAP_NAME,
+				    DL_OPT_TRAP_ACTION);
 	if (err)
 		return err;
 
@@ -9360,8 +9598,9 @@ static int cmd_trap_group_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl,
-				    DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME, 0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_TRAP_GROUP_GET,
+					    DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
+					    0);
 		if (err)
 			return err;
 	}
@@ -9382,8 +9621,9 @@ static int cmd_trap_group_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
-			    DL_OPT_TRAP_ACTION | DL_OPT_TRAP_POLICER_ID);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_TRAP_GROUP_SET,
+				    DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
+				    DL_OPT_TRAP_ACTION | DL_OPT_TRAP_POLICER_ID);
 	if (err)
 		return err;
 
@@ -9459,8 +9699,9 @@ static int cmd_trap_policer_show(struct dl *dl)
 		flags |= NLM_F_DUMP;
 	}
 	else {
-		err = dl_argv_parse(dl,
-				    DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID, 0);
+		err = dl_argv_parse_checked(dl, DEVLINK_CMD_TRAP_POLICER_GET,
+					    DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID,
+					    0);
 		if (err)
 			return err;
 	}
@@ -9481,8 +9722,9 @@ static int cmd_trap_policer_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID,
-			    DL_OPT_TRAP_POLICER_RATE | DL_OPT_TRAP_POLICER_BURST);
+	err = dl_argv_parse_checked(dl, DEVLINK_CMD_TRAP_POLICER_SET,
+				    DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID,
+				    DL_OPT_TRAP_POLICER_RATE | DL_OPT_TRAP_POLICER_BURST);
 	if (err)
 		return err;
 
-- 
2.37.1.208.ge72d93e88cb2


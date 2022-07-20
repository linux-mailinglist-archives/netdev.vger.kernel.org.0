Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D5057BDE2
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiGTSfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiGTSfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:35:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B091971BEA
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658342099; x=1689878099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n64FFDpS9caIMXpagRHDXtwGx9eoVTz1dxi5sDRkdSk=;
  b=iW8RYggRNfCG3f6dnk0LWJ54D7PnM1JUll+ezrEQ81EIbiEqZmxQA8rU
   +fseNlqsY9wjmyEH4JtLNn7bEx0fjCSbGAQCMurcXiPCchlKnM+9MSIt8
   nPpfXFCdZfsn77KpLMT9m/d8bUI/PPsN1k0pxqCHXYp0yWPOG0nFDHpjs
   ga3XmMsge7YR9kKOEphudt0ga9RH/zonjDJ39zmgGTOyAwONJqtImpWEG
   +L56wxiVC1NGM90r4IpO6C98X5Oza7ha55uEUrBGpenjS9in/9FIPCx1+
   aR/tbFYu0N8mJKO46G/FeaeVBNJU4u1JW+zltm3gApn2gelg78x4lpEgx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="285620858"
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="285620858"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="925337494"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:58 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next PATCH 3/3] devlink: add dry run attribute support to devlink flash
Date:   Wed, 20 Jul 2022 11:34:49 -0700
Message-Id: <20220720183449.2070222-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
In-Reply-To: <20220720183449.2070222-1-jacob.e.keller@intel.com>
References: <20220720183449.2070222-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent versions of the kernel support the DEVLINK_ATTR_DRY_RUN attribute
which allows requesting a dry run of a command. A dry run is simply
a request to validate that a command would work, without performing any
destructive changes.

The attribute is supported by the devlink flash update as a way to
validate an update, including potentially the binary image, without
modifying the device.

Add a "dry_run" option to the command line parsing which will enable
this attribute when requested.

To avoid potential issues, only allow the attribute to be added to
commands when the kernel recognizes it. This is important because some
commands do not perform strict validation. If we were to add the
attribute without this check, an old kernel may silently accept the
command and perform an update even when dry_run was requested.

Before adding the attribute, check the maximum attribute from the
CTRL_CMD_GETFAMILY and make sure that the kernel recognizes the
DEVLINK_ATTR_DRY_RUN attribute.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ddf430bbb02a..5649360b1417 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -294,6 +294,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(49)
 #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
 #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
+#define DL_OPT_DRY_RUN			BIT(52)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -368,6 +369,8 @@ struct dl {
 	bool verbose;
 	bool stats;
 	bool hex;
+	bool max_attr_valid;
+	uint32_t max_attr;
 	struct {
 		bool present;
 		char *bus_name;
@@ -693,6 +696,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_DRY_RUN] = MNL_TYPE_FLAG,
 };
 
 static const enum mnl_attr_data_type
@@ -1512,6 +1516,30 @@ static int dl_args_finding_required_validate(uint64_t o_required,
 	return 0;
 }
 
+static void dl_get_max_attr(struct dl *dl)
+{
+	if (!dl->max_attr_valid) {
+		uint32_t max_attr;
+		int err;
+
+		err = mnlg_socket_get_max_attr(&dl->nlg, &max_attr);
+		if (err) {
+			pr_err("Unable to determine maximum supported devlink attribute\n");
+			return;
+		}
+
+		dl->max_attr = max_attr;
+		dl->max_attr_valid = true;
+	}
+}
+
+static bool dl_kernel_supports_dry_run(struct dl *dl)
+{
+	dl_get_max_attr(dl);
+
+	return (dl->max_attr_valid && dl->max_attr >= DEVLINK_ATTR_DRY_RUN);
+}
+
 static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			 uint64_t o_optional)
 {
@@ -2008,6 +2036,16 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			dl_arg_inc(dl);
 			opts->rate_parent_node = "";
 			o_found |= DL_OPT_PORT_FN_RATE_PARENT;
+		} else if (dl_argv_match(dl, "dry_run") &&
+			   (o_all & DL_OPT_DRY_RUN)) {
+
+			if (!dl_kernel_supports_dry_run(dl)) {
+				pr_err("Kernel does not support dry_run attribute\n");
+				return -EOPNOTSUPP;
+			}
+
+			dl_arg_inc(dl);
+			o_found |= DL_OPT_DRY_RUN;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -2086,6 +2124,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_NODE_NAME,
 				  opts->rate_node_name);
 	}
+	if (opts->present & DL_OPT_DRY_RUN)
+		mnl_attr_put(nlh, DEVLINK_ATTR_DRY_RUN, 0, NULL);
 	if (opts->present & DL_OPT_PORT_TYPE)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_TYPE,
 				 opts->port_type);
@@ -2284,7 +2324,7 @@ static void cmd_dev_help(void)
 	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
 	pr_err("                              [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
-	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
+	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ] [ dry_run ]\n");
 }
 
 static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
@@ -3844,7 +3884,8 @@ static int cmd_dev_flash(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK);
 
 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
-				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
+				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE |
+				DL_OPT_DRY_RUN);
 	if (err)
 		return err;
 
-- 
2.36.1


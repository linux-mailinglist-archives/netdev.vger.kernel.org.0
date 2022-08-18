Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11CB598F7C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbiHRVZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345594AbiHRVZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:25:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD50EA164
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 14:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660857430; x=1692393430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jw26CPSgoZpO5FJq023gKM6KL92wVDHu3PCU3DC6Lyk=;
  b=bgoxsG1r3Sf2azQOhifacSNcWh+PQAFQmipOFcrG0+vaIdT0AnlUHeNM
   K5D3YgtGl3avA5soT6KWEVGDmU0sW6SG7f3xc+bfshF4TuVCrR+qPqV+x
   ekvzdSjgcER2St00rl3/02kIW5FLmKVJNznwnjYV8IieZSszfUS8ATG01
   xlaXgfq+BvjO00nJeFGyfHnrsA/N6pOFioCZBBC9myTTjQI5bzm5zSiwY
   cLkCL2OV/yc+lulTOxv6+8IPSxDoTNVWkOyEqJhP7Kb6Za5kB+9BzNafY
   2VASEb6ObQnUpg3ONPUGbcg1Ahh4IuB0FGYlGS3wFHcwxzZKNphzjzlsN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="293661518"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="293661518"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:15:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="641016164"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:15:28 -0700
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
Subject: [iproute2-next 2/2] devlink: remove dl_argv_parse_put
Date:   Thu, 18 Aug 2022 14:15:21 -0700
Message-Id: <20220818211521.169569-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
In-Reply-To: <20220818211521.169569-1-jacob.e.keller@intel.com>
References: <20220818211521.169569-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dl_argv_parse_put function is used to extract arguments from the
command line and convert them to the appropriate netlink attributes. This
function is a combination of calling dl_argv_parse and dl_put_opts.

A future change is going to refactor dl_argv_parse to check the kernel's
netlink policy for the command. This requires issuing another netlink
message which requires calling dl_argv_parse before
mnlu_gen_socket_cmd_prepare. Otherwise, the get policy command issued in
dl_argv_parse would overwrite the prepared buffer.

This conflicts with dl_argv_parse_put which requires being called after
mnlu_gen_socket_cmd_prepare.

Remove dl_argv_parse_put and replace it with appropriate calls to
dl_argv_parse and dl_put_opts. This allows us to ensure dl_argv_parse is
called before mnlu_gen_socket_cmd_prepare while dl_put_opts is called
afterwards.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 587 ++++++++++++++++++++++++++--------------------
 1 file changed, 329 insertions(+), 258 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index aa4fdcff14ac..b69c89778804 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2319,18 +2319,6 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				  opts->linecard_type);
 }
 
-static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
-			     uint64_t o_required, uint64_t o_optional)
-{
-	int err;
-
-	err = dl_argv_parse(dl, o_required, o_optional);
-	if (err)
-		return err;
-	dl_opts_put(nlh, dl);
-	return 0;
-}
-
 static bool dl_dump_filter(struct dl *dl, struct nlattr **tb)
 {
 	struct dl_opts *opts = &dl->opts;
@@ -2838,12 +2826,14 @@ static int cmd_dev_eswitch_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_ESWITCH_GET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	pr_out_section_start(dl, "dev");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_eswitch_show_cb, dl);
@@ -2856,16 +2846,17 @@ static int cmd_dev_eswitch_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE,
+			    DL_OPT_ESWITCH_MODE |
+			    DL_OPT_ESWITCH_INLINE_MODE |
+			    DL_OPT_ESWITCH_ENCAP_MODE);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_ESWITCH_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE,
-				DL_OPT_ESWITCH_MODE |
-				DL_OPT_ESWITCH_INLINE_MODE |
-				DL_OPT_ESWITCH_ENCAP_MODE);
-
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	if (dl->opts.present == 1) {
 		pr_err("Need to set at least one option\n");
@@ -3358,18 +3349,18 @@ static int cmd_dev_param_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PARAM_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE |
-					DL_OPT_PARAM_NAME, 0);
+	} else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_PARAM_NAME, 0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PARAM_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "param");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_param_show_cb, dl);
 	pr_out_section_end(dl);
@@ -3514,17 +3505,19 @@ static int cmd_dev_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "dev");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_show_cb, dl);
 	pr_out_section_end(dl);
@@ -3592,14 +3585,16 @@ static int cmd_dev_reload(struct dl *dl)
 		return 0;
 	}
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE,
+			    DL_OPT_NETNS | DL_OPT_RELOAD_ACTION |
+			    DL_OPT_RELOAD_LIMIT);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RELOAD,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE,
-				DL_OPT_NETNS | DL_OPT_RELOAD_ACTION |
-				DL_OPT_RELOAD_LIMIT);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_reload_cb, dl);
 }
@@ -3734,17 +3729,19 @@ static int cmd_dev_info(struct dl *dl)
 		return 0;
 	}
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_INFO_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_INFO_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "info");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_versions_show_cb, dl);
 	pr_out_section_end(dl);
@@ -3999,13 +3996,15 @@ static int cmd_dev_flash(struct dl *dl)
 		return 0;
 	}
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
+			    DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_FLASH_UPDATE,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
-				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	err = mnlu_gen_socket_open(&nlg_ntf, DEVLINK_GENL_NAME,
 				   DEVLINK_GENL_VERSION);
@@ -4238,12 +4237,14 @@ static int cmd_dev_selftests_run(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_RUN, flags);
-
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SELFTESTS);
+	err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_SELFTESTS);
 	if (err)
 		return err;
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_RUN, flags);
+
+	dl_opts_put(nlh, dl);
+
 	if (!(dl->opts.present & DL_OPT_SELFTESTS))
 		dl_selftests_put(nlh, &dl->opts);
 
@@ -4257,17 +4258,18 @@ static int cmd_dev_selftests_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_argc(dl) == 0) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
+	} else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "selftests");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_selftests_show_cb, dl);
 	pr_out_section_end(dl);
@@ -4537,17 +4539,19 @@ static int cmd_port_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP, 0);
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLEP, 0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "port");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_port_show_cb, dl);
 	pr_out_section_end(dl);
@@ -4559,12 +4563,14 @@ static int cmd_port_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_PORT_TYPE, 0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_PORT_TYPE, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -4574,12 +4580,14 @@ static int cmd_port_split(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_PORT_COUNT, 0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_SPLIT,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_PORT_COUNT, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -4589,12 +4597,14 @@ static int cmd_port_unsplit(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP, 0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_UNSPLIT,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -4605,18 +4615,19 @@ static int cmd_port_param_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_PARAM_NAME, 0);
+		if (err)
+			return err;
+	}
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_PARAM_GET,
 					  flags);
 
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP |
-					DL_OPT_PARAM_NAME, 0);
-		if (err)
-			return err;
-	}
+	dl_opts_put(nlh, dl);
 
 	pr_out_section_start(dl, "param");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_port_param_show_cb, dl);
@@ -4640,13 +4651,15 @@ static int cmd_port_function_set(struct dl *dl)
 		cmd_port_function_help();
 		return 0;
 	}
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP,
+			    DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_SET,
 					  NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP,
-				DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -4959,18 +4972,21 @@ static int cmd_port_fn_rate_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP |
-					DL_OPT_PORT_FN_RATE_NODE_NAME, 0);
+	}
+	else {
+		err = dl_argv_parse(dl,
+				    DL_OPT_HANDLEP | DL_OPT_PORT_FN_RATE_NODE_NAME,
+				    0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "rate");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_port_fn_rate_show_cb, dl);
 	pr_out_section_end(dl);
@@ -5002,14 +5018,15 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_NEW,
-					  NLM_F_REQUEST | NLM_F_ACK);
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
-				DL_OPT_PORT_FN_RATE_TX_SHARE |
-				DL_OPT_PORT_FN_RATE_TX_MAX);
+	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
+			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX);
 	if (err)
 		return err;
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_NEW,
+					  NLM_F_REQUEST | NLM_F_ACK);
+	dl_opts_put(nlh, dl);
+
 	if ((dl->opts.present & DL_OPT_PORT_FN_RATE_TX_SHARE) &&
 	    (dl->opts.present & DL_OPT_PORT_FN_RATE_TX_MAX)) {
 		err = port_fn_check_tx_rates(dl->opts.rate_tx_share,
@@ -5026,12 +5043,14 @@ static int cmd_port_fn_rate_del(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_DEL,
-					  NLM_F_REQUEST | NLM_F_ACK);
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_PORT_FN_RATE_NODE_NAME, 0);
+	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME, 0);
 	if (err)
 		return err;
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_DEL,
+					  NLM_F_REQUEST | NLM_F_ACK);
+	dl_opts_put(nlh, dl);
+
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
 
@@ -5159,14 +5178,16 @@ static int cmd_port_add(struct dl *dl)
 		return 0;
 	}
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
+			    DL_OPT_PORT_FLAVOUR | DL_OPT_PORT_PFNUMBER,
+			    DL_OPT_PORT_SFNUMBER | DL_OPT_PORT_CONTROLLER);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_NEW,
 					  NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
-				DL_OPT_PORT_FLAVOUR | DL_OPT_PORT_PFNUMBER,
-				DL_OPT_PORT_SFNUMBER | DL_OPT_PORT_CONTROLLER);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_port_show_cb, dl);
 }
@@ -5186,12 +5207,14 @@ static int cmd_port_del(struct dl *dl)
 		return 0;
 	}
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP, 0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_DEL,
 					  NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -5326,18 +5349,19 @@ static int cmd_linecard_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_LINECARD);
+		if (err)
+			return err;
+	}
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_LINECARD_GET,
 					  flags);
 
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE,
-					DL_OPT_LINECARD);
-		if (err)
-			return err;
-	}
+	dl_opts_put(nlh, dl);
 
 	pr_out_section_start(dl, "lc");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_linecard_show_cb, dl);
@@ -5350,13 +5374,15 @@ static int cmd_linecard_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_LINECARD |
+			    DL_OPT_LINECARD_TYPE, 0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_LINECARD_SET,
 					  NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_LINECARD |
-					 DL_OPT_LINECARD_TYPE, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -5441,17 +5467,19 @@ static int cmd_sb_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SB);
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_SB);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "sb");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_sb_show_cb, dl);
 	pr_out_section_end(dl);
@@ -5518,18 +5546,20 @@ static int cmd_sb_pool_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_POOL_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_SB_POOL,
-					DL_OPT_SB);
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_SB_POOL,
+				    DL_OPT_SB);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_POOL_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "pool");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_sb_pool_show_cb, dl);
 	pr_out_section_end(dl);
@@ -5541,13 +5571,15 @@ static int cmd_sb_pool_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_SB_POOL |
+			    DL_OPT_SB_SIZE | DL_OPT_SB_THTYPE, DL_OPT_SB);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_POOL_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_SB_POOL |
-				DL_OPT_SB_SIZE | DL_OPT_SB_THTYPE, DL_OPT_SB);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -5603,19 +5635,20 @@ static int cmd_sb_port_pool_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_PORT_POOL_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl,
-					DL_OPT_HANDLEP | DL_OPT_SB_POOL,
-					DL_OPT_SB);
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_SB_POOL,
+				    DL_OPT_SB);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_PORT_POOL_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "port_pool");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_sb_port_pool_show_cb, dl);
 	pr_out_section_end(dl);
@@ -5627,13 +5660,15 @@ static int cmd_sb_port_pool_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_SB_POOL | DL_OPT_SB_TH,
+			    DL_OPT_SB);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_PORT_POOL_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_SB_POOL |
-				DL_OPT_SB_TH, DL_OPT_SB);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -5707,18 +5742,20 @@ static int cmd_sb_tc_bind_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_SB_TC |
-					DL_OPT_SB_TYPE, DL_OPT_SB);
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_SB_TC |
+				    DL_OPT_SB_TYPE, DL_OPT_SB);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "tc_bind");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_sb_tc_bind_show_cb, dl);
 	pr_out_section_end(dl);
@@ -5730,14 +5767,16 @@ static int cmd_sb_tc_bind_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_SB_TC |
+			    DL_OPT_SB_TYPE | DL_OPT_SB_POOL | DL_OPT_SB_TH,
+			    DL_OPT_SB);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP | DL_OPT_SB_TC |
-				DL_OPT_SB_TYPE | DL_OPT_SB_POOL | DL_OPT_SB_TH,
-				DL_OPT_SB);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -6084,12 +6123,14 @@ static int cmd_sb_occ_snapshot(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_SB);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_OCC_SNAPSHOT,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SB);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -6099,12 +6140,14 @@ static int cmd_sb_occ_clearmax(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE, DL_OPT_SB);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_OCC_MAX_CLEAR,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SB);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -7006,12 +7049,14 @@ static int cmd_dpipe_headers_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_HEADERS_GET, flags);
-
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
+	err = dl_argv_parse(dl, DL_OPT_HANDLE, 0);
 	if (err)
 		return err;
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_HEADERS_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	err = dpipe_ctx_init(&ctx, dl);
 	if (err)
 		return err;
@@ -7459,14 +7504,15 @@ static int cmd_dpipe_table_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_DPIPE_TABLE_NAME |
+			    DL_OPT_DPIPE_TABLE_COUNTERS, 0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_DPIPE_TABLE_COUNTERS_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl,
-				DL_OPT_HANDLE | DL_OPT_DPIPE_TABLE_NAME |
-				DL_OPT_DPIPE_TABLE_COUNTERS, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -8377,17 +8423,19 @@ static int cmd_region_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION, 0);
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION, 0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "regions");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_region_show_cb, dl);
 	pr_out_section_end(dl);
@@ -8399,13 +8447,15 @@ static int cmd_region_snapshot_del(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION |
+			    DL_OPT_REGION_SNAPSHOT_ID, 0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_DEL,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
-				DL_OPT_REGION_SNAPSHOT_ID, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -8449,13 +8499,16 @@ static int cmd_region_dump(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl,
+			    DL_OPT_HANDLE_REGION | DL_OPT_REGION_SNAPSHOT_ID,
+			    0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_READ,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
-				DL_OPT_REGION_SNAPSHOT_ID, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	pr_out_section_start(dl, "dump");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_region_read_cb, dl);
@@ -8470,14 +8523,16 @@ static int cmd_region_read(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION | DL_OPT_REGION_ADDRESS |
+			    DL_OPT_REGION_LENGTH | DL_OPT_REGION_SNAPSHOT_ID,
+			    0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_READ,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
-				DL_OPT_REGION_ADDRESS | DL_OPT_REGION_LENGTH |
-				DL_OPT_REGION_SNAPSHOT_ID, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	pr_out_section_start(dl, "read");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_region_read_cb, dl);
@@ -8509,13 +8564,15 @@ static int cmd_region_snapshot_new(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION,
+			    DL_OPT_REGION_SNAPSHOT_ID);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_NEW,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION,
-				DL_OPT_REGION_SNAPSHOT_ID);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	pr_out_section_start(dl, "regions");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_region_snapshot_new_cb, dl);
@@ -8582,14 +8639,16 @@ static int cmd_health_dump_clear(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
+			    DL_OPT_HEALTH_REPORTER_NAME,
+			    0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl,
-				DL_OPT_HANDLE | DL_OPT_HANDLEP |
-				DL_OPT_HEALTH_REPORTER_NAME, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	dl_opts_put(nlh, dl);
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
@@ -8833,14 +8892,16 @@ static int cmd_health_object_common(struct dl *dl, uint8_t cmd, uint16_t flags)
 	struct nlmsghdr *nlh;
 	int err;
 
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, cmd, flags | NLM_F_REQUEST | NLM_F_ACK);
-
-	err = dl_argv_parse_put(nlh, dl,
-				DL_OPT_HANDLE | DL_OPT_HANDLEP |
-				DL_OPT_HEALTH_REPORTER_NAME, 0);
+	err = dl_argv_parse(dl,
+			    DL_OPT_HANDLE | DL_OPT_HANDLEP | DL_OPT_HEALTH_REPORTER_NAME,
+			    0);
 	if (err)
 		return err;
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, cmd, flags | NLM_F_REQUEST | NLM_F_ACK);
+
+	dl_opts_put(nlh, dl);
+
 	cmd_fmsg_init(dl, &data);
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_fmsg_object_cb, &data);
 	free(data.name);
@@ -8873,14 +8934,16 @@ static int cmd_health_recover(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
+			    DL_OPT_HEALTH_REPORTER_NAME,
+			    0);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_RECOVER,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl,
-				DL_OPT_HANDLE | DL_OPT_HANDLEP |
-				DL_OPT_HEALTH_REPORTER_NAME, 0);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	dl_opts_put(nlh, dl);
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
@@ -9047,19 +9110,21 @@ static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_GET,
-			       flags);
-
-	if (dl_argc(dl) > 0) {
+	} else {
 		ctx.show_port = true;
-		err = dl_argv_parse_put(nlh, dl,
-					DL_OPT_HANDLE | DL_OPT_HANDLEP |
-					DL_OPT_HEALTH_REPORTER_NAME, 0);
+		err = dl_argv_parse(dl,
+				    DL_OPT_HANDLE | DL_OPT_HANDLEP |
+				    DL_OPT_HEALTH_REPORTER_NAME, 0);
 		if (err)
 			return err;
 	}
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_GET,
+			       flags);
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "health");
 
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_health_show_cb, &ctx);
@@ -9239,18 +9304,19 @@ static int cmd_trap_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl,
-					DL_OPT_HANDLE | DL_OPT_TRAP_NAME, 0);
+	}
+	else {
+		err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_TRAP_NAME, 0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "trap");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_trap_show_cb, dl);
 	pr_out_section_end(dl);
@@ -9263,13 +9329,15 @@ static int cmd_trap_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_TRAP_NAME,
+			    DL_OPT_TRAP_ACTION);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_TRAP_NAME,
-				DL_OPT_TRAP_ACTION);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -9314,19 +9382,20 @@ static int cmd_trap_group_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GROUP_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl,
-					DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
-					0);
+	}
+	else {
+		err = dl_argv_parse(dl,
+				    DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME, 0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GROUP_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "trap_group");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_trap_group_show_cb, dl);
 	pr_out_section_end(dl);
@@ -9339,14 +9408,15 @@ static int cmd_trap_group_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
+			    DL_OPT_TRAP_ACTION | DL_OPT_TRAP_POLICER_ID);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GROUP_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl,
-				DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
-				DL_OPT_TRAP_ACTION | DL_OPT_TRAP_POLICER_ID);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
@@ -9411,19 +9481,20 @@ static int cmd_trap_policer_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_no_arg(dl))
+	if (dl_no_arg(dl)) {
 		flags |= NLM_F_DUMP;
-
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_POLICER_GET, flags);
-
-	if (dl_argc(dl) > 0) {
-		err = dl_argv_parse_put(nlh, dl,
-					DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID,
-					0);
+	}
+	else {
+		err = dl_argv_parse(dl,
+				    DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID, 0);
 		if (err)
 			return err;
 	}
 
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_POLICER_GET, flags);
+
+	dl_opts_put(nlh, dl);
+
 	pr_out_section_start(dl, "trap_policer");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_trap_policer_show_cb, dl);
 	pr_out_section_end(dl);
@@ -9436,15 +9507,15 @@ static int cmd_trap_policer_set(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID,
+			    DL_OPT_TRAP_POLICER_RATE | DL_OPT_TRAP_POLICER_BURST);
+	if (err)
+		return err;
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_POLICER_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl,
-				DL_OPT_HANDLE | DL_OPT_TRAP_POLICER_ID,
-				DL_OPT_TRAP_POLICER_RATE |
-				DL_OPT_TRAP_POLICER_BURST);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
-- 
2.37.1.394.gc50926e1f488


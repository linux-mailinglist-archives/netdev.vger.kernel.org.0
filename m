Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4B58B2D1
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 01:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbiHEXmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 19:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241893AbiHEXmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 19:42:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C7A29C87
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659742925; x=1691278925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AIgbcjBNwhFL8O9I1pBUIYkB3SuMxTt9R81qVToilYk=;
  b=NLDkN+xQjRgUEc4I6bZrvAVNif/bESmWOPuEGNzAnlI2c142tPcOoqEM
   mNqBEb/ww2DOXvNk+KZ/xJmA5DpTxeTTzedH0VdpvRCvtuiFXPsIndsvN
   51xWKFaDyp/dzvWmb5iBhMW5YjM0Iv42V3DpcRRie96Rzwodobzn/ma10
   0j8CBVVN9JYEew0eYC58ciFHEFcsidD1jTE58gPbZvWrIaARsMvP5Deyp
   5QeAF0R147nyEk0qWxmdAosepDyTEGPjT10oydcmtssr56Is+L6EDz0lM
   +p/tocn0+pF6GqvV7MUDPDPXsL4qa2UfBqu3bqKVTRJmc37cyyiEAJshu
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="289072936"
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="289072936"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="931401663"
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
Subject: [RFC iproute2 5/6] devlink: remove dl_argv_parse_put
Date:   Fri,  5 Aug 2022 16:41:54 -0700
Message-Id: <20220805234155.2878160-6-jacob.e.keller@intel.com>
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
 devlink/devlink.c | 566 ++++++++++++++++++++++++++--------------------
 1 file changed, 317 insertions(+), 249 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 485b1a82f9ef..67a57e9ba550 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2318,18 +2318,6 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
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
@@ -2818,12 +2806,14 @@ static int cmd_dev_eswitch_show(struct dl *dl)
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
@@ -2836,16 +2826,17 @@ static int cmd_dev_eswitch_set(struct dl *dl)
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
@@ -3338,18 +3329,18 @@ static int cmd_dev_param_show(struct dl *dl)
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
@@ -3494,17 +3485,19 @@ static int cmd_dev_show(struct dl *dl)
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
@@ -3572,14 +3565,16 @@ static int cmd_dev_reload(struct dl *dl)
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
@@ -3714,17 +3709,19 @@ static int cmd_dev_info(struct dl *dl)
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
@@ -3979,13 +3976,15 @@ static int cmd_dev_flash(struct dl *dl)
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
@@ -4517,17 +4516,19 @@ static int cmd_port_show(struct dl *dl)
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
@@ -4539,12 +4540,14 @@ static int cmd_port_set(struct dl *dl)
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
@@ -4554,12 +4557,14 @@ static int cmd_port_split(struct dl *dl)
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
@@ -4569,12 +4574,14 @@ static int cmd_port_unsplit(struct dl *dl)
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
@@ -4585,18 +4592,19 @@ static int cmd_port_param_show(struct dl *dl)
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
@@ -4620,13 +4628,15 @@ static int cmd_port_function_set(struct dl *dl)
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
@@ -4939,18 +4949,21 @@ static int cmd_port_fn_rate_show(struct dl *dl)
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
@@ -4982,14 +4995,15 @@ static int cmd_port_fn_rate_add(struct dl *dl)
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
@@ -5006,12 +5020,14 @@ static int cmd_port_fn_rate_del(struct dl *dl)
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
 
@@ -5139,14 +5155,16 @@ static int cmd_port_add(struct dl *dl)
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
@@ -5166,12 +5184,14 @@ static int cmd_port_del(struct dl *dl)
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
@@ -5303,18 +5323,19 @@ static int cmd_linecard_show(struct dl *dl)
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
@@ -5327,13 +5348,15 @@ static int cmd_linecard_set(struct dl *dl)
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
@@ -5418,17 +5441,19 @@ static int cmd_sb_show(struct dl *dl)
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
@@ -5495,18 +5520,20 @@ static int cmd_sb_pool_show(struct dl *dl)
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
@@ -5518,13 +5545,15 @@ static int cmd_sb_pool_set(struct dl *dl)
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
@@ -5580,19 +5609,20 @@ static int cmd_sb_port_pool_show(struct dl *dl)
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
@@ -5604,13 +5634,15 @@ static int cmd_sb_port_pool_set(struct dl *dl)
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
@@ -5684,18 +5716,20 @@ static int cmd_sb_tc_bind_show(struct dl *dl)
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
@@ -5707,14 +5741,16 @@ static int cmd_sb_tc_bind_set(struct dl *dl)
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
@@ -6061,12 +6097,14 @@ static int cmd_sb_occ_snapshot(struct dl *dl)
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
@@ -6076,12 +6114,14 @@ static int cmd_sb_occ_clearmax(struct dl *dl)
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
@@ -6983,12 +7023,14 @@ static int cmd_dpipe_headers_show(struct dl *dl)
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
@@ -7436,14 +7478,15 @@ static int cmd_dpipe_table_set(struct dl *dl)
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
@@ -8354,17 +8397,19 @@ static int cmd_region_show(struct dl *dl)
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
@@ -8376,13 +8421,15 @@ static int cmd_region_snapshot_del(struct dl *dl)
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
@@ -8426,13 +8473,16 @@ static int cmd_region_dump(struct dl *dl)
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
@@ -8447,14 +8497,16 @@ static int cmd_region_read(struct dl *dl)
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
@@ -8486,13 +8538,15 @@ static int cmd_region_snapshot_new(struct dl *dl)
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
@@ -8559,14 +8613,16 @@ static int cmd_health_dump_clear(struct dl *dl)
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
@@ -8810,14 +8866,16 @@ static int cmd_health_object_common(struct dl *dl, uint8_t cmd, uint16_t flags)
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
@@ -8850,14 +8908,16 @@ static int cmd_health_recover(struct dl *dl)
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
@@ -9024,19 +9084,21 @@ static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port)
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
@@ -9216,18 +9278,19 @@ static int cmd_trap_show(struct dl *dl)
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
@@ -9240,13 +9303,15 @@ static int cmd_trap_set(struct dl *dl)
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
@@ -9291,19 +9356,20 @@ static int cmd_trap_group_show(struct dl *dl)
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
@@ -9316,14 +9382,15 @@ static int cmd_trap_group_set(struct dl *dl)
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
@@ -9388,19 +9455,20 @@ static int cmd_trap_policer_show(struct dl *dl)
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
@@ -9413,15 +9481,15 @@ static int cmd_trap_policer_set(struct dl *dl)
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
2.37.1.208.ge72d93e88cb2


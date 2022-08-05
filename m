Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83DB58B2D2
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 01:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241895AbiHEXmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 19:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241883AbiHEXmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 19:42:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E773718E28
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 16:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659742924; x=1691278924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OKGAe9HURuRaJS8H5DmC+QFA3cfQtBnJWWaWdKkiqoU=;
  b=htUKAdNsGhgY8OGUh185CFqNx/7F1u5TRjFF96eCCdtnw12E6FTq3OCM
   T+P82N4MJ0eey+RcndfwZ7reRKuxn5QEcz0fyZai3Pmdv5qSneG9/UHwC
   w9nSFiCWXwPEycs47K3jYIKBGHFSz0uy+coHJXpacqrEo4op8Xf3YHxtK
   YSnqIuJV+4ovM2kF3QLG5QDM7txmMj2cGwKXI7A2LdCuCxulNq/f8pmNH
   R7cBWQJO3EWBTj/ZtxxJr2bqCDgQeHtRESkcXuxTSb86acSlPYTWboQyv
   tQQOrFFC054wdax5QPlBapmR1gQ/JvBYwjdU/IhNR+6ADBWA6MqGLLPHf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="289072935"
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="289072935"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 16:42:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="931401660"
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
Subject: [RFC iproute2 4/6] devlink: use dl_no_arg instead of checking dl_argc == 0
Date:   Fri,  5 Aug 2022 16:41:53 -0700
Message-Id: <20220805234155.2878160-5-jacob.e.keller@intel.com>
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

Use the helper dl_no_arg function to check for whether the command has any
arguments.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 21f26246f91b..485b1a82f9ef 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3338,7 +3338,7 @@ static int cmd_dev_param_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PARAM_GET, flags);
@@ -3494,7 +3494,7 @@ static int cmd_dev_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_GET, flags);
@@ -3714,7 +3714,7 @@ static int cmd_dev_info(struct dl *dl)
 		return 0;
 	}
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_INFO_GET, flags);
@@ -4517,7 +4517,7 @@ static int cmd_port_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET, flags);
@@ -4585,7 +4585,7 @@ static int cmd_port_param_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_PARAM_GET,
@@ -4939,7 +4939,7 @@ static int cmd_port_fn_rate_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_GET, flags);
@@ -5303,7 +5303,7 @@ static int cmd_linecard_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_LINECARD_GET,
@@ -5418,7 +5418,7 @@ static int cmd_sb_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_GET, flags);
@@ -5495,7 +5495,7 @@ static int cmd_sb_pool_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_POOL_GET, flags);
@@ -5580,7 +5580,7 @@ static int cmd_sb_port_pool_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_PORT_POOL_GET, flags);
@@ -5684,7 +5684,7 @@ static int cmd_sb_tc_bind_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND_GET, flags);
@@ -8354,7 +8354,7 @@ static int cmd_region_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_GET, flags);
@@ -9024,7 +9024,7 @@ static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_GET,
 			       flags);
@@ -9216,7 +9216,7 @@ static int cmd_trap_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GET, flags);
@@ -9291,7 +9291,7 @@ static int cmd_trap_group_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GROUP_GET, flags);
@@ -9388,7 +9388,7 @@ static int cmd_trap_policer_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_POLICER_GET, flags);
-- 
2.37.1.208.ge72d93e88cb2


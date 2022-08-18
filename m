Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45906598F80
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241339AbiHRVZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346997AbiHRVYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:24:45 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD079EA143
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 14:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660857426; x=1692393426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4G0T7LPjh4l8W3kzZjekDumBdC7k2HIIbdAJWmq6uc0=;
  b=LFM6yQIXoihsNhwzHGMcok67oSWLXlizpZ2VXfh49F8hySLp6B5epWOR
   +31O3lCoiFYWMpwdm44PfWknOGw6YpRxmIdNYF1ysOKElQDxVaQU9V37a
   rIl15AfdUR2Wb1iOn1p5ktN3jLZyPqTqrtVmWrgVHQeM/Jxh20VHL0QbN
   KW01R7ox2oEFrYNo98qd+1gr1WQI0rwkqILamOoUCnN5SGFnxZUesCVj8
   azPPmkqQXgPHD/GGtsmW9AokCA63VAR/w9+d+lO4Y//wyXUoYuRDt6lzD
   ar28xyg9eXhXX8rr3aKIHKVj0hlPLiqBzqJWek402flyzDGEwlWB6kyOv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="293661515"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="293661515"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:15:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="641016161"
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
Subject: [iproute2-next 1/2] devlink: use dl_no_arg instead of checking dl_argc == 0
Date:   Thu, 18 Aug 2022 14:15:20 -0700
Message-Id: <20220818211521.169569-2-jacob.e.keller@intel.com>
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

Use the helper dl_no_arg function to check for whether the command has any
arguments.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 1ccb669c423b..aa4fdcff14ac 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3358,7 +3358,7 @@ static int cmd_dev_param_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PARAM_GET, flags);
@@ -3514,7 +3514,7 @@ static int cmd_dev_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_GET, flags);
@@ -3734,7 +3734,7 @@ static int cmd_dev_info(struct dl *dl)
 		return 0;
 	}
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_INFO_GET, flags);
@@ -4537,7 +4537,7 @@ static int cmd_port_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET, flags);
@@ -4605,7 +4605,7 @@ static int cmd_port_param_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_PARAM_GET,
@@ -4959,7 +4959,7 @@ static int cmd_port_fn_rate_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_GET, flags);
@@ -5326,7 +5326,7 @@ static int cmd_linecard_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_LINECARD_GET,
@@ -5441,7 +5441,7 @@ static int cmd_sb_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_GET, flags);
@@ -5518,7 +5518,7 @@ static int cmd_sb_pool_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_POOL_GET, flags);
@@ -5603,7 +5603,7 @@ static int cmd_sb_port_pool_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_PORT_POOL_GET, flags);
@@ -5707,7 +5707,7 @@ static int cmd_sb_tc_bind_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SB_TC_POOL_BIND_GET, flags);
@@ -8377,7 +8377,7 @@ static int cmd_region_show(struct dl *dl)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_GET, flags);
@@ -9047,7 +9047,7 @@ static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port)
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_HEALTH_REPORTER_GET,
 			       flags);
@@ -9239,7 +9239,7 @@ static int cmd_trap_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GET, flags);
@@ -9314,7 +9314,7 @@ static int cmd_trap_group_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_GROUP_GET, flags);
@@ -9411,7 +9411,7 @@ static int cmd_trap_policer_show(struct dl *dl)
 	struct nlmsghdr *nlh;
 	int err;
 
-	if (dl_argc(dl) == 0)
+	if (dl_no_arg(dl))
 		flags |= NLM_F_DUMP;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_TRAP_POLICER_GET, flags);
-- 
2.37.1.394.gc50926e1f488


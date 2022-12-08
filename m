Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A289646650
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiLHBLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiLHBLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A248DBFB
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461899; x=1701997899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OErDcSNfZFvvYfmX4c/lAN9SUJ9ApnKKSLBccrXBl40=;
  b=PFFL/qkF/n880IaVAVnMUHOwFEdts3n7FcqGNdJjBlYaO2iiUBShdEoy
   qdNwFEFkXJWKJYPocv7XvQIwsZbLG/p3Dpwxr7Uw1jiIHSOy5GGPOLAAS
   pBKpMowDjmdRTJ06Bb2NIC0jrIBNV3p3+djV5fg9HgWBSnR6kETUC5zQI
   KQfb7o32HPSlPIq1g1/2kmQ4iU2dnTZcRn5aBUL5ZsLaQwZGkXZVI7YLk
   H8DyHM9Xw+hIoNwaMyoCvYErpGaa1GdIKCrMfHXS3DbcjsY5SqhdKImPC
   lvzNCTfuYrtS7Zy8f0qzIejkhn6PQjRwbfdFGNl9XAsqQNDH5BSvahDd1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672886"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672886"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445369"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445369"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v2 06/13] ethtool: fix uninitialized local variable use
Date:   Wed,  7 Dec 2022 17:11:15 -0800
Message-Id: <20221208011122.2343363-7-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'$ scan-build make' reports:

netlink/parser.c:252:25: warning: The left operand of '*' is a garbage value [core.UndefinedBinaryOperatorResult]
        cm = (uint32_t)(meters * 100 + 0.5);
                        ~~~~~~ ^

This is a little more complicated than it seems, but for some
unexplained reason, parse_float always returns integers but was declared
to return a float. This is confusing at best. In the case of the error
above, parse_float could conceivably return without initializing it's
output variable, and because the function return variable was declared
as float but downgraded to an int via assignment (-Wconversion anyone?)
upon the return, the return value could be ignored.

To fix the bug above, declare an initial value for meters, and make sure
that parse_float() always returns an integer value.

It would probably be even more ideal if parse_float always initialized
it's output variables before even checking for input errors, but that's
for some future day.

CC: Andrew Lunn <andrew@lunn.ch>
Fixes: 9561db9b76f4 ("Add cable test TDR support")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 netlink/parser.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/netlink/parser.c b/netlink/parser.c
index f982f229a040..70f451008eb4 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -54,8 +54,7 @@ static bool __prefix_0x(const char *p)
 	return p[0] == '0' && (p[1] == 'x' || p[1] == 'X');
 }
 
-static float parse_float(const char *arg, float *result, float min,
-			 float max)
+static int parse_float(const char *arg, float *result, float min, float max)
 {
 	char *endptr;
 	float val;
@@ -237,7 +236,7 @@ int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
 			 struct nl_msg_buff *msgbuff, void *dest)
 {
 	const char *arg = *nlctx->argp;
-	float meters;
+	float meters = 0;
 	uint32_t cm;
 	int ret;
 
-- 
2.31.1


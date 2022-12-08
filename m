Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E5C646656
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLHBMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiLHBLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:49 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998D78DFD6
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461902; x=1701997902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5ZlYFmdCnc7dmsRGYjQg4/KS5MxZqjmOAMz2DrOU7WM=;
  b=i54OH/IXWOP2Y/llMANKXKwcZiPA9MhX6nVrS6tJxHb00G84oulGUyFG
   A8WU2L8MiOJmh5LbanFvAhufVsJSwBMwH2hAt11ovAZtn9/2+siaBvh4k
   Xjhl9uSTWeAz9Y6AU58vyjvRxwq4WZN4qCjekvbLTJSfTvSbyVXRZFjzt
   HJzeEUZhFZ3GblI6xeivdsBlJ5UcjoXhvEbrDkcMQTeGrajDA6makOXnW
   KFoAVHldwHBKZUUwe9zy46hWKeAcs5EXGFgwiwkBOrE/tQ5BuXg/XCNtM
   ttgr9CJMA54tPeqsilxJdR6HwmxpYz2WUSeNUxyDwPGbSUkam/suMYARZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672899"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672899"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445383"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445383"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 13/13] ethtool: fix bug and use standard string parsing
Date:   Wed,  7 Dec 2022 17:11:22 -0800
Message-Id: <20221208011122.2343363-14-jesse.brandeburg@intel.com>
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

The parse_reset function was open-coding string parsing routines and can
be converted to using standard routines. It was trying to be tricky and
parse partial strings to make things like "mgmt" and "mgmt-shared"
strings mostly use the same code. This is better done with strncmp().

This also fixes an array overflow bug where it's possible for the for
loop to access past the end of the input array, which is bad.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 ethtool.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 4776afe89e23..d294b5f8d92a 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5280,17 +5280,21 @@ static int do_get_phy_tunable(struct cmd_context *ctx)
 static __u32 parse_reset(char *val, __u32 bitset, char *arg, __u32 *data)
 {
 	__u32 bitval = 0;
-	int i;
+	int vallen = strlen(val);
+	int strret;
 
 	/* Check for component match */
-	for (i = 0; val[i] != '\0'; i++)
-		if (arg[i] != val[i])
-			return 0;
+	strret = strncmp(arg, val, vallen);
+	if (strret < 0)
+		return 0;
 
-	/* Check if component has -shared specified or not */
-	if (arg[i] == '\0')
+	/* if perfect match to val
+	 * else
+	 * Check if component has -shared specified or not
+	 */
+	if (strret == 0)
 		bitval = bitset;
-	else if (!strcmp(arg+i, "-shared"))
+	else if (!strcmp(arg + vallen, "-shared"))
 		bitval = bitset << ETH_RESET_SHARED_SHIFT;
 
 	if (bitval) {
-- 
2.31.1


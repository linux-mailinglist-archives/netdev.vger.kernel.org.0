Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7839764664B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiLHBLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLHBLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:38 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC098BD24
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461896; x=1701997896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G/gtypLqGWd2UXMVG+9YnzuoHRET7BaPO+GuB+2WVzo=;
  b=YwTy65Qsg4jEo7BhEjNniARxHYMycgaEbHUzhRKjWB/gus0ktiDB1Mmr
   UoVomh987I7745LtvsVta4SRoS09zRxSWOW1khePO4k3Pz6GestdDZ3Fr
   eYmx4Bw6wW8124w7QJbGj6J6LFOv4Ts9Hc9BWwHiol8pCj7n0LmVxfnqK
   qGMICRBII0tcLVVKufpzaSw5kKj7Mb2Z/Dj7KOTqsTDynBcOQam7tfNHW
   zvmA2BYnxg6iu5Maj3jp4+Oxh5qAvn9ZGxnf13/Kd5lLvmRmokVjsvaWT
   Ub19SrXOa4q033oS4z+rLxfWW3Bv6tULTQpMdI9oMb5fpSmV1EVeI+biL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672879"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672879"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445334"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445334"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 03/13] ethtool: disallow passing null to find_option
Date:   Wed,  7 Dec 2022 17:11:12 -0800
Message-Id: <20221208011122.2343363-4-jesse.brandeburg@intel.com>
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

After testing with this code in the debugger, it is technically possible
to pass a NULL argument to ethtool which then prods it to call strncmp
with a NULL value, which triggers this warning:

Description: Null pointer passed to 1st parameter expecting 'nonnull'
File: /git/ethtool/ethtool.c
Line: 6129

Since segfaults are bad, let's just add a check for NULL when parsing
the initial arguments. The other cases of a NULL option are seemingly
handled.

Fixes: 127f80691f96 ("Move argument parsing to sub-command functions")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index 3207e49137c4..a72577b32601 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6389,7 +6389,7 @@ int main(int argc, char **argp)
 	 * name to get settings for (which we don't expect to begin
 	 * with '-').
 	 */
-	if (argc == 0)
+	if (argc == 0 || *argp == NULL)
 		exit_bad_args();
 
 	k = find_option(*argp);
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4D464664C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiLHBLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiLHBLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:36 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F68E8BD16
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461895; x=1701997895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kajYkTYLBzW7yzsd1OBn2Lv+k3P8/0QS/kkiGY/xMuw=;
  b=Il/znQZU1/Ucykg1sgOJ3OpIY2WH+pTU2mkCrwwVcyz5gCcG2IBf3feE
   Fi1UitETCLib4iFdM3Y8dhieYrNhuIk/aT2voShH1abKagQnNkXep5a7C
   BfT1qqnn/unn+8px52zfj6QeMnIHIS4teOBcohVU1aRI/Xp3H6MYt1Qgl
   +wdYT4A9Y8op+BUrg4At7xNDh/hSLfxmQKoBNs2kNW4CJ6KXDEVH6bMee
   ZeR/kmC9PZWC4WSWcpEYE2c47BW61gJPFDNp6on+bbJNDqh148lPbiJyR
   iXsc1QkjO8Ig57MJ12rSO65dzZXI85uWCI8p75e0+1aJZMqaGI5ZsXHO2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672873"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672873"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445331"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445331"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 02/13] ethtool: fix trivial issue in allocation
Date:   Wed,  7 Dec 2022 17:11:11 -0800
Message-Id: <20221208011122.2343363-3-jesse.brandeburg@intel.com>
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

Fix the following warning by changing the type being multiplied by to
the type being assigned to.

Description: Result of 'calloc' is converted to a pointer of type
'unsigned long', which is incompatible with sizeof operand type 'long'
File: /home/jbrandeb/git/ethtool/rxclass.c
Line: 527

Fixes: 5a3279e43f2b ("rxclass: Replace global rmgr with automatic variable/parameter")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 rxclass.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rxclass.c b/rxclass.c
index 6cf81fdafc85..ebdd97960e5b 100644
--- a/rxclass.c
+++ b/rxclass.c
@@ -524,7 +524,7 @@ static int rmgr_init(struct cmd_context *ctx, struct rmgr_ctrl *rmgr)
 	}
 
 	/* initialize bitmap for storage of valid locations */
-	rmgr->slot = calloc(1, BITS_TO_LONGS(rmgr->size) * sizeof(long));
+	rmgr->slot = calloc(1, BITS_TO_LONGS(rmgr->size) * sizeof(unsigned long));
 	if (!rmgr->slot) {
 		perror("rmgr: Cannot allocate memory for RX class rules");
 		return -1;
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C257646652
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiLHBMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiLHBLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99668BD14
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461900; x=1701997900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UwGKh2ucp8AeHXJQY0SWYjqOJN6C/ikV3sPiFpsYGjE=;
  b=n1r1TjZROUi3MQgfYS0jZjinqKsDMbhKq+a8TLQDEJyQXQR4CFBkqfcp
   y35Ha4SjyOlujfaK/DkM2ug2su7JEeR4goQLNVMxPSorjlZOTyOtXXz4/
   iEK55ztpzpjNGfDdTTih9ikbQFbEg9FePLLrV+gH4abg4l0PLVqAhrj+l
   x9tVbFibLlBk95Lqa4BUcNpTW0S6t2luKrxGm2boGukEeJoIUtoZiZPIo
   XIQJFzUlMtu1p05RgO4PAodore+kahdB3Fe8cM7Zu/pq3wueQldk4Jdce
   ou/Wv7zYeDS6TgBS/kqOlKi9Xc1R2UilEQpH96aTVLmUo3UnIM84Y4P3S
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672889"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672889"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445379"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445379"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 11/13] ethtool: fix missing free of memory after failure
Date:   Wed,  7 Dec 2022 17:11:20 -0800
Message-Id: <20221208011122.2343363-12-jesse.brandeburg@intel.com>
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

cppcheck warns:
test-common.c:106:2: error: Common realloc mistake: 'block' nulled but not freed upon failure [memleakOnRealloc]
 block = realloc(block, sizeof(*block) + size);
 ^

Fix the issue by storing a local copy of the old pointer and using that
to free the original if the realloc fails, as the manual for realloc()
suggests.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 test-common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/test-common.c b/test-common.c
index e4dac3298577..b472027140f6 100644
--- a/test-common.c
+++ b/test-common.c
@@ -97,15 +97,18 @@ void test_free(void *ptr)
 
 void *test_realloc(void *ptr, size_t size)
 {
-	struct list_head *block = NULL;
+	struct list_head *block = NULL, *oldblock;
 
 	if (ptr) {
 		block = (struct list_head *)ptr - 1;
 		list_del(block);
 	}
-	block = realloc(block, sizeof(*block) + size);
-	if (!block)
+	oldblock = block;
+	block = realloc(oldblock, sizeof(*oldblock) + size);
+	if (!block) {
+		free(oldblock);
 		return NULL;
+	}
 	list_add(block, &malloc_list);
 	return block + 1;
 }
-- 
2.31.1


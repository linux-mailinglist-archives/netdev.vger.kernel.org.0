Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8055863B35F
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbiK1UhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbiK1UhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:37:02 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532EA2DA97
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669667820; x=1701203820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yz3Jb2u461xf/jkzRVs5WyHFPSrYPal3Ndx1a1FsNtQ=;
  b=O7P7lmOdUr0B+1bN61MxMZ52Jd0qQSI+Un+0n74RaqPF4KV5+CxTuWvj
   2q+6kuGxJ5pXyHMCc+7WkY7FoQ9v7nJ01WGGQf5ZfTES+0sPVlM7VDhmo
   77OvdOhzUL4LFBbE4xuao6aKN6lg30rh4m5V2OIObZKG/oQWWZ3QBN32o
   XM9n64MIQ0enAxAL2XkfCxRvfoSV0vBZAQbTNvjXlTgaQs7NuFKm0bCAE
   ipUB35HW1ZYxIqDI2YFSm4kFgtwLHrm3yrJmVVxuMstj7VubnLRe/M2IM
   lbugpC/LT94884n203hMyDx52TBK/TbEGzGei9fomdl9HaGQKBZ2WXMi3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379205377"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379205377"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732286342"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732286342"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:58 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 1/9] devlink: use min_t to calculate data_size
Date:   Mon, 28 Nov 2022 12:36:39 -0800
Message-Id: <20221128203647.1198669-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221128203647.1198669-1-jacob.e.keller@intel.com>
References: <20221128203647.1198669-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The calculation for the data_size in the devlink_nl_read_snapshot_fill
function uses an if statement that is better expressed using the min_t
macro.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
No changes since v2.

 net/core/devlink.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index cea154ddce7a..ff802788ee05 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6485,10 +6485,8 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 		u32 data_size;
 		u8 *data;
 
-		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
-			data_size = end_offset - curr_offset;
-		else
-			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
+		data_size = min_t(u32, end_offset - curr_offset,
+				  DEVLINK_REGION_READ_CHUNK_SIZE);
 
 		data = &snapshot->data[curr_offset];
 		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
-- 
2.38.1.420.g319605f8f00e


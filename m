Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB98646653
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLHBMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiLHBLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858A78DBE1
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461901; x=1701997901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/BgfYB6056acD6DXQN6G/LQonXV1tCmSKPk5joytpc4=;
  b=YUK49wW3LakwimpkUFbqlOM0XJtfeC5ugaESJz03oNDiFwoAt3h6lmG/
   LBwMzmZY0dNaKgj5msJFOUqRUW/nDDnzpyu9APsmhrice4gGJie8lITUq
   WnT/UQKbh9kij2mNV7gBLihCbWV0626EBWCqGpFpyrOJGpwrdn3MNCu0m
   /YtexMB0fkHwNMDHGpYVPQ84xAVdu5b+Rwt6neblv/YGjKSSGgyTT/EUY
   j8HDkNFuUragCpu0WOACYS+qKtMYrzpKtU9k5bM87aadUnkaLr3pJ6Ufm
   QMDv0ZecfOow3vrW4FsrqD890eT7hjDNGi97DtEwl9eME3onUyQzLHzEy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672897"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672897"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445372"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445372"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 08/13] ethtool: fix runtime errors found by sanitizers
Date:   Wed,  7 Dec 2022 17:11:17 -0800
Message-Id: <20221208011122.2343363-9-jesse.brandeburg@intel.com>
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

The sanitizers[1] found a couple of things, but this change addresses
some bit shifts that cannot be contained by the target type.

The mistake is that the code is using unsigned int a = (1 << N) all over
the place, but the appropriate way to code this is unsigned int an
assignment of (1UL << N) especially if N can ever be 31.

Fix the most egregious of these problems by changing "1" to "1UL", as
per it would be if we had used the BIT() macro.

[1] make CFLAGS+='-fsanitize=address,undefined' \
         LDFLAGS+='-lubsan -lasan'

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 amd8111e.c         | 2 +-
 internal.h         | 4 ++--
 netlink/features.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/amd8111e.c b/amd8111e.c
index 175516bd2904..5a2fc2082e55 100644
--- a/amd8111e.c
+++ b/amd8111e.c
@@ -75,7 +75,7 @@ typedef enum {
 }CMD3_BITS;
 typedef enum {
 
-	INTR			= (1 << 31),
+	INTR			= (1UL << 31),
 	PCSINT			= (1 << 28),
 	LCINT			= (1 << 27),
 	APINT5			= (1 << 26),
diff --git a/internal.h b/internal.h
index dd7d6ac70ad4..6e79374bcfd5 100644
--- a/internal.h
+++ b/internal.h
@@ -205,14 +205,14 @@ static inline int ethtool_link_mode_test_bit(unsigned int nr, const u32 *mask)
 {
 	if (nr >= ETHTOOL_LINK_MODE_MASK_MAX_KERNEL_NBITS)
 		return !!0;
-	return !!(mask[nr / 32] & (1 << (nr % 32)));
+	return !!(mask[nr / 32] & (1UL << (nr % 32)));
 }
 
 static inline int ethtool_link_mode_set_bit(unsigned int nr, u32 *mask)
 {
 	if (nr >= ETHTOOL_LINK_MODE_MASK_MAX_KERNEL_NBITS)
 		return -1;
-	mask[nr / 32] |= (1 << (nr % 32));
+	mask[nr / 32] |= (1UL << (nr % 32));
 	return 0;
 }
 
diff --git a/netlink/features.c b/netlink/features.c
index a4dae8fac4dc..f6ba47f21a12 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -57,7 +57,7 @@ static int prepare_feature_results(const struct nlattr *const *tb,
 
 static bool feature_on(const uint32_t *bitmap, unsigned int idx)
 {
-	return bitmap[idx / 32] & (1 << (idx % 32));
+	return bitmap[idx / 32] & (1UL << (idx % 32));
 }
 
 static void dump_feature(const struct feature_results *results,
@@ -302,7 +302,7 @@ static void set_sf_req_mask(struct nl_context *nlctx, unsigned int idx)
 {
 	struct sfeatures_context *sfctx = nlctx->cmd_private;
 
-	sfctx->req_mask[idx / 32] |= (1 << (idx % 32));
+	sfctx->req_mask[idx / 32] |= (1UL << (idx % 32));
 }
 
 static int fill_legacy_flag(struct nl_context *nlctx, const char *flag_name,
-- 
2.31.1


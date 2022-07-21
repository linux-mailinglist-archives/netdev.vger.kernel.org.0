Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F1C57D084
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiGUQBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGUQBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:01:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F1758876;
        Thu, 21 Jul 2022 09:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658419305; x=1689955305;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IxIOJp2Qbj+WW3trb3/dQrpMihcnTdPMAtB9cP4gT5k=;
  b=m19b/MDRaPbVE+V5aAdWfPMeDgKtw3XCNebbXTwyoHDLVphZTzekl8jP
   75fKkGGLE6myER+53DjpO7fNUJIZSeCgXnpk2noQ90vzw+RwE/23WXB+m
   O9r97oTqdsdyq/R6hQcftd7WYlwgdpxvN+oytCGySw6hqm/Gs218zeepg
   5wisXag0wYbopFNSz3aL9bIN9FbuXdppZ+Y+0/56dxSqmC1DD8Wh+SkQx
   vFxu8zZkR52/mETdI8gQ0MIxnQ31mU2qJm6dD3/H+aN1H09SLsPnu120q
   zYtM4HO4L9DUmoslL9IEKRKHtSix4VOQwWjT5iVRWsyGZkzYRbLSN8qQ8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="373389478"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="373389478"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="598512084"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 21 Jul 2022 09:01:42 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26LG1crb003918;
        Thu, 21 Jul 2022 17:01:41 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] lib/test_bitmap: cover explicitly byteordered arr64s
Date:   Thu, 21 Jul 2022 17:59:49 +0200
Message-Id: <20220721155950.747251-4-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721155950.747251-1-alexandr.lobakin@intel.com>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When testing converting bitmaps <-> arr64, test Big and Little
Endianned variants as well to make sure it works as expected on
all platforms.
Also, use more complex bitmap_validate_arr64_type() instead of just
checking the tail. It will handle different Endiannesses correctly
(note we don't pass `sizeof(arr)` to it as we poison it with 0xa5).

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 lib/test_bitmap.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 98754ff9fe68..8a44290b60ba 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -585,7 +585,7 @@ static void __init test_bitmap_arr32(void)
 	}
 }
 
-static void __init test_bitmap_arr64(void)
+static void __init test_bitmap_arr64_type(u32 type)
 {
 	unsigned int nbits, next_bit;
 	u64 arr[EXP1_IN_BITS / 64];
@@ -594,9 +594,11 @@ static void __init test_bitmap_arr64(void)
 	memset(arr, 0xa5, sizeof(arr));
 
 	for (nbits = 0; nbits < EXP1_IN_BITS; ++nbits) {
+		int res;
+
 		memset(bmap2, 0xff, sizeof(arr));
-		bitmap_to_arr64(arr, exp1, nbits);
-		bitmap_from_arr64(bmap2, arr, nbits);
+		bitmap_to_arr64_type(arr, exp1, nbits, type);
+		bitmap_from_arr64_type(bmap2, arr, nbits, type);
 		expect_eq_bitmap(bmap2, exp1, nbits);
 
 		next_bit = find_next_bit(bmap2, round_up(nbits, BITS_PER_LONG), nbits);
@@ -604,17 +606,21 @@ static void __init test_bitmap_arr64(void)
 			pr_err("bitmap_copy_arr64(nbits == %d:"
 				" tail is not safely cleared: %d\n", nbits, next_bit);
 
-		if ((nbits % 64) &&
-		    (arr[(nbits - 1) / 64] & ~GENMASK_ULL((nbits - 1) % 64, 0)))
-			pr_err("bitmap_to_arr64(nbits == %d): tail is not safely cleared: 0x%016llx (must be 0x%016llx)\n",
-			       nbits, arr[(nbits - 1) / 64],
-			       GENMASK_ULL((nbits - 1) % 64, 0));
+		res = bitmap_validate_arr64_type(arr, bitmap_arr64_size(nbits),
+						 nbits, type);
+		expect_eq_uint(nbits ? 0 : -EINVAL, res);
 
 		if (nbits < EXP1_IN_BITS - 64)
 			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 64)], 0xa5a5a5a5);
 	}
 }
 
+static void __init test_bitmap_arr64(void)
+{
+	for (u32 type = 0; type < __BITMAP_ARR_TYPE_NUM; type++)
+		test_bitmap_arr64_type(type);
+}
+
 static void noinline __init test_mem_optimisations(void)
 {
 	DECLARE_BITMAP(bmap1, 1024);
-- 
2.36.1


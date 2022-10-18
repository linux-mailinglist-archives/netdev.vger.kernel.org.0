Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02568602DC9
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiJROCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiJROCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:02:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA1ED0189;
        Tue, 18 Oct 2022 07:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666101757; x=1697637757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KKCVdrqHKAJ3G/YmZRke57HdG0Ps2/KbJfT4bWvKeyo=;
  b=IvgQhARIwueb6fGExFMQ6Eg99miUgQyvF14jA76wgja1l47xS9MbIEhj
   b00LU0h1JE69/JEqUCcADGpGd4h/HUS+jqcAeiBlG842ciI5CjOjmDTJJ
   rnf6W9hRV9Rnc6duaHhQqWqEBmlCAS4E1vvP/dBZ/mVXuD83g6Gn7Qyxm
   RGMd6fp7BQWxGRYhFuRZ/6cZZw1/ohP5YRZvleK8kW6XAS9rnc8f/jViR
   Gxx5hS6R07whZyPnYTZg0KNmWUv3kPSJck1BwBkjknbIQzD8MNOdpwbA0
   YLa31hv8/LJuZq0eqRAxa7Nh+WJTlMkMkEtAmwAHQvEpm2IqQXJpx1Qcq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="286502873"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="286502873"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:02:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="697510401"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="697510401"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2022 07:02:34 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29IE2TUO011675;
        Tue, 18 Oct 2022 15:02:33 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@linux.intel.com>
Subject: [PATCH v2 net-next 4/6] lib/test_bitmap: test the newly added arr32 functions
Date:   Tue, 18 Oct 2022 16:00:25 +0200
Message-Id: <20221018140027.48086-5-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018140027.48086-1-alexandr.lobakin@intel.com>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple of trivial test cases, which will trial three newly
added helpers to work with arr32s:

* bitmap_validate_arr32() -- test all the branches the function can
  take when validating;
* bitmap_arr32_size() -- sometimes is also called inside the
  previous one;
* BITMAP_TO_U64() -- testing it casted to u32 against arr32[0].

Suggested-by: Andy Shevchenko <andy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 lib/test_bitmap.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index c40ab3dfa776..f168f0a79e4f 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -600,6 +600,36 @@ static void __init test_bitmap_parse(void)
 	}
 }
 
+static const struct {
+	DECLARE_BITMAP(bitmap, 128);
+	u32 nbits;
+	u32 msglen;
+	u32 exp_size;
+	u32 exp_valid:1;
+} arr32_test_cases[] __initconst = {
+#define BITMAP_ARR32_CASE(h, l, nr, len, ev, es) {	\
+	.bitmap = {					\
+		BITMAP_FROM_U64(l),			\
+		BITMAP_FROM_U64(h),			\
+	},						\
+	.nbits = (nr),					\
+	.msglen = (len),				\
+	.exp_valid = (ev),				\
+	.exp_size = (es),				\
+}
+	/* fail: msglen is not a multiple of 4 */
+	BITMAP_ARR32_CASE(0x00000000, 0x0000accedeadfeed, 48,  6, false,  8),
+	/* pass: kernel supports more bits than received */
+	BITMAP_ARR32_CASE(0x00000000, 0xacdcbadadd0afc18, 90,  8, true,  12),
+	/* fail: unsupported bits set within the last supported word */
+	BITMAP_ARR32_CASE(0xfa588103, 0xd3d0a58544864a9c, 88, 12, false, 12),
+	/* fail: unsupported bits set past the last supported word */
+	BITMAP_ARR32_CASE(0x00b84e53, 0x0000a3bafb6484f8, 64, 16, false,  8),
+	/* pass: kernel supports less bits than received, no unsupported set */
+	BITMAP_ARR32_CASE(0x00000000, 0x848d7a2acc7ff31e, 64, 16, true,   8),
+#undef BITMAP_ARR32_CASE
+};
+
 static void __init test_bitmap_arr32(void)
 {
 	unsigned int nbits, next_bit;
@@ -628,6 +658,19 @@ static void __init test_bitmap_arr32(void)
 			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 32)],
 								0xa5a5a5a5);
 	}
+
+	for (u32 i = 0; i < ARRAY_SIZE(arr32_test_cases); i++) {
+		typeof(*arr32_test_cases) *test = &arr32_test_cases[i];
+
+		memset(arr, 0, sizeof(arr));
+		bitmap_to_arr32(arr, test->bitmap, BYTES_TO_BITS(test->msglen));
+
+		valid = bitmap_validate_arr32(arr, test->msglen, test->nbits);
+		expect_eq_uint(test->exp_valid, valid);
+
+		expect_eq_uint(test->exp_size, bitmap_arr32_size(test->nbits));
+		expect_eq_uint((u32)BITMAP_TO_U64(test->bitmap), arr[0]);
+	}
 }
 
 static void __init test_bitmap_arr64(void)
-- 
2.37.3


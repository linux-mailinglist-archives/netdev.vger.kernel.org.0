Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250C5602DC4
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiJROCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiJROCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:02:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28839CF845;
        Tue, 18 Oct 2022 07:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666101756; x=1697637756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cOdKTamNw2tvKAGbxW7BgvAt+f+G49WumYQ+CrWTe+Q=;
  b=oFsBDMYiC0dukIz2kfxDariEcf/6eHXyVw7AiK7IQ28yKn3QHIfdxZZD
   vfMh3gr8BS6Ew5cDWFo+iHi4Omt+xcXX/O2ovhsCI+tKb++yfyjfXrJnV
   EdyfjK5XoTuYkNES7u56xYPLjB8z2UvuVJp7K7GNLnPhSqeAFcH3A9ADO
   u/P8NuJa8kYMDBPsrVKjZavJ6uknW/nUBWln/I3xaFw1V8gV0d9sSm0/L
   S3AJ+Y4JZiU7K+MahiLQaHOOHh+qIeS0L4cFXW0lOLRR8ar1r9l5O3NcL
   iKo6bxwCYmOzMo4vEp/eGUHO81umDvxrJSKqIFweB2L+g8GH1XC5XzCdm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="286502861"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="286502861"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:02:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="697510397"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="697510397"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2022 07:02:33 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29IE2TUN011675;
        Tue, 18 Oct 2022 15:02:32 +0100
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 3/6] lib/test_bitmap: verify intermediate arr32 when converting <-> bitmap
Date:   Tue, 18 Oct 2022 16:00:24 +0200
Message-Id: <20221018140027.48086-4-alexandr.lobakin@intel.com>
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

When testing converting bitmaps from/to arr32, use
bitmap_validate_arr32() to test whether the tail of the intermediate
array was cleared correctly. Previously there were checks only for
the actual bitmap generated with the double-conversion.
Note that we pass bitmap_arr32_size() instead of `sizeof(arr)`, as
we poison the bytes past the last used word with 0xa5s. Also, for
@nbits == 0, the validation function must return false, account that
case as well.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 lib/test_bitmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index a8005ad3bd58..c40ab3dfa776 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -605,6 +605,7 @@ static void __init test_bitmap_arr32(void)
 	unsigned int nbits, next_bit;
 	u32 arr[EXP1_IN_BITS / 32];
 	DECLARE_BITMAP(bmap2, EXP1_IN_BITS);
+	bool valid;
 
 	memset(arr, 0xa5, sizeof(arr));
 
@@ -620,6 +621,9 @@ static void __init test_bitmap_arr32(void)
 				" tail is not safely cleared: %d\n",
 				nbits, next_bit);
 
+		valid = bitmap_validate_arr32(arr, bitmap_arr32_size(nbits), nbits);
+		expect_eq_uint(!!nbits, valid);
+
 		if (nbits < EXP1_IN_BITS - 32)
 			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 32)],
 								0xa5a5a5a5);
-- 
2.37.3


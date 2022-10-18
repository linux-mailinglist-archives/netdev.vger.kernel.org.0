Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0747A602DC6
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiJROCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiJROCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:02:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64886CF874;
        Tue, 18 Oct 2022 07:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666101755; x=1697637755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k+eTdXtPkqMwaDNTEUKdoz77rxk+Xe2f7Xhhd5O90Uw=;
  b=RYfsiW3w1rA+mF7KLK98laPAmBWCFQJL3Kc/Dzgc/aoZh62PTo3uVxdy
   eoDT/EQ33Mt+dSNKvDyV/GwhOZioh7U11PJaJpdWPNYHBZkhgaiZjLEB1
   b2mdLCoELEJbYiJdwKQjXP60QlZADuQ4AdyUSPpCyo6eIr8YwgtYqTmSg
   f/WlbGz5jUZH9/pbE7aYQUqmv7KvEIBMvwkjEi4mcanV8O4G3Ri3cYgiK
   H/Q6S+M8d9jfofo0qJKQW8N2w3Lv9MtAZm517010WQn9YUGDSZiQpbyB3
   oALt3cWrDTGffjo+JEtOkFOMFy5QV7kxbAsO7fEBa/AjjK6hcxPwYxAwy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="286502856"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="286502856"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:02:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="697510392"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="697510392"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2022 07:02:32 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29IE2TUM011675;
        Tue, 18 Oct 2022 15:02:31 +0100
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
Subject: [PATCH v2 net-next 2/6] bitmap: add a couple more helpers to work with arrays of u32s
Date:   Tue, 18 Oct 2022 16:00:23 +0200
Message-Id: <20221018140027.48086-3-alexandr.lobakin@intel.com>
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

Add two new functions to work on arr32s:

* bitmap_arr32_size() - takes number of bits to be stored in arr32
  and returns number of bytes required to store such arr32, can be
  useful when allocating memory for arr32 containers;
* bitmap_validate_arr32() - takes pointer to an arr32 and its size
  in bytes, plus expected number of bits. Ensures that the size is
  valid (must be a multiply of `sizeof(u32)`) and no bits past the
  number is set.

Also add BITMAP_TO_U64() macro to help return a u64 from
a DECLARE_BITMAP(1-64) (it may pick one or two longs depending
on the platform).

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/bitmap.h | 20 +++++++++++++++++++-
 lib/bitmap.c           | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 79d12e0f748b..c737b0fe2f41 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -7,7 +7,7 @@
 #include <linux/align.h>
 #include <linux/bitops.h>
 #include <linux/find.h>
-#include <linux/limits.h>
+#include <linux/overflow.h>
 #include <linux/string.h>
 #include <linux/types.h>
 
@@ -75,6 +75,8 @@ struct device;
  *  bitmap_from_arr64(dst, buf, nbits)          Copy nbits from u64[] buf to dst
  *  bitmap_to_arr32(buf, src, nbits)            Copy nbits from buf to u32[] dst
  *  bitmap_to_arr64(buf, src, nbits)            Copy nbits from buf to u64[] dst
+ *  bitmap_validate_arr32(buf, len, nbits)      Validate u32[] buf of len bytes
+ *  bitmap_arr32_size(nbits)                    Get size of u32[] arr for nbits
  *  bitmap_get_value8(map, start)               Get 8bit value from map at start
  *  bitmap_set_value8(map, value, start)        Set 8bit value to map at start
  *
@@ -324,6 +326,20 @@ static inline void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
 		__bitmap_to_arr32(buf, bitmap, nbits);
 }
 
+bool bitmap_validate_arr32(const u32 *arr, size_t len, size_t nbits);
+
+/**
+ * bitmap_arr32_size - determine the size of array of u32s for a number of bits
+ * @nbits: number of bits to store in the array
+ *
+ * Returns the size in bytes of a u32s-array needed to carry the specified
+ * number of bits.
+ */
+static inline size_t bitmap_arr32_size(size_t nbits)
+{
+	return array_size(BITS_TO_U32(nbits), sizeof(u32));
+}
+
 /*
  * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
  * machines the order of hi and lo parts of numbers match the bitmap structure.
@@ -571,9 +587,11 @@ static inline void bitmap_next_set_region(unsigned long *bitmap,
  */
 #if __BITS_PER_LONG == 64
 #define BITMAP_FROM_U64(n) (n)
+#define BITMAP_TO_U64(map) ((u64)(map)[0])
 #else
 #define BITMAP_FROM_U64(n) ((unsigned long) ((u64)(n) & ULONG_MAX)), \
 				((unsigned long) ((u64)(n) >> 32))
+#define BITMAP_TO_U64(map) (((u64)(map)[1] << 32) | (u64)(map)[0])
 #endif
 
 /**
diff --git a/lib/bitmap.c b/lib/bitmap.c
index e3eb12ff1637..e0045ecf34d6 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1495,6 +1495,46 @@ void __bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits
 EXPORT_SYMBOL(__bitmap_to_arr32);
 #endif
 
+/**
+ * bitmap_validate_arr32 - perform validation of a u32-array bitmap
+ * @arr: array of u32s, the dest bitmap
+ * @len: length of the array, in bytes
+ * @nbits: expected/supported number of bits in the bitmap
+ *
+ * Returns true if the array passes the checks (see below), false otherwise.
+ */
+bool bitmap_validate_arr32(const u32 *arr, size_t len, size_t nbits)
+{
+	size_t word = (nbits - 1) / BITS_PER_TYPE(u32);
+	u32 pos = (nbits - 1) % BITS_PER_TYPE(u32);
+
+	/* Must consist of 1...n full u32s */
+	if (!len || len % sizeof(u32))
+		return false;
+
+	/*
+	 * If the array is shorter than expected, assume we support
+	 * all of the bits set there.
+	 */
+	if (word >= len / sizeof(u32))
+		return true;
+
+	/* Last word must not contain any bits past the expected number */
+	if (arr[word] & (u32)~GENMASK(pos, 0))
+		return false;
+
+	/*
+	 * If the array is longer than expected, make sure all the bytes
+	 * past the expected length are zeroed.
+	 */
+	len -= bitmap_arr32_size(nbits);
+	if (memchr_inv(&arr[word + 1], 0, len))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL(bitmap_validate_arr32);
+
 #if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
 /**
  * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
-- 
2.37.3


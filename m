Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719AF602DC5
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiJROCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiJROCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:02:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C9DD0187;
        Tue, 18 Oct 2022 07:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666101754; x=1697637754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=if46w95X6d/6l0PtVaLFrbbviIkWXvjVlHZZP7lFcbc=;
  b=Ass0jzhZnuapdaxORYY4OoIqSrdX2CJWq3/QhNEMpHHaV7FN8u7t9cR/
   NzdEoN6TFb++T4L/l223Wm+Qd4ZhuJ2uVPnsxsyewEMDE4ckcEc2zJhoj
   ST5WCeW2KNfklt6kTU3GRizsJ3KPmTVOJNU5ii0Po76sxFG5RwipIpTrj
   nQXrzDoJQkse4vyhgsXH1v3CdPpld+aTkltBTSYrZsy3CDDzzbAWS5Zwc
   LDxRTNSJChwBVsqakEKLvP4LbbbFl6rk+xON+XLRzS1ER1tvHqKUHFklD
   4d5avNm9M7RxFEUNAvePNWQejB4pwFj+FAyenfalZDpe1dLCefo2mLLnp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="286502853"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="286502853"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:02:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="697510388"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="697510388"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2022 07:02:32 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29IE2TUL011675;
        Tue, 18 Oct 2022 15:02:30 +0100
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
Subject: [PATCH v2 net-next 1/6] bitmap: try to optimize arr32 <-> bitmap on 64-bit LEs
Date:   Tue, 18 Oct 2022 16:00:22 +0200
Message-Id: <20221018140027.48086-2-alexandr.lobakin@intel.com>
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

Unlike bitmap_{from,to}_arr64(), when there can be no out-of-bounds
accesses (due to u64 always being no shorter than unsigned long),
it can't be guaranteed with arr32s due to that on 64-bit platforms:

bits     BITS_TO_U32 * sizeof(u32)    BITS_TO_LONGS * sizeof(long)
1-32     4                            8
33-64    8                            8
95-96    12                           16
97-128   16                           16

and so on.
That is why bitmap_{from,to}_arr32() are always defined there as
externs. But quite often @nbits is a compile-time constant, which
means we could suggest whether it can be inlined or not at
compile-time basing on the number of bits (above).

So, try to determine that at compile time and, in case of both
containers having the same size in bytes, resolve it to
bitmap_copy_clear_tail() on Little Endian. No changes here for
Big Endian or when the number of bits *really* is variable.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/bitmap.h | 51 ++++++++++++++++++++++++++++++------------
 lib/bitmap.c           | 12 +++++-----
 2 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 7d6d73b78147..79d12e0f748b 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -283,24 +283,47 @@ static inline void bitmap_copy_clear_tail(unsigned long *dst,
  * On 32-bit systems bitmaps are represented as u32 arrays internally. On LE64
  * machines the order of hi and lo parts of numbers match the bitmap structure.
  * In both cases conversion is not needed when copying data from/to arrays of
- * u32. But in LE64 case, typecast in bitmap_copy_clear_tail() may lead
- * to out-of-bound access. To avoid that, both LE and BE variants of 64-bit
- * architectures are not using bitmap_copy_clear_tail().
+ * u32. But in LE64 case, typecast in bitmap_copy_clear_tail() may lead to
+ * out-of-bound access. To avoid that, LE variant of 64-bit architectures uses
+ * bitmap_copy_clear_tail() only when @bitmap and @buf containers have the same
+ * size in memory (known at compile time), and 64-bit BEs never use it.
  */
-#if BITS_PER_LONG == 64
-void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
-							unsigned int nbits);
-void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
-							unsigned int nbits);
+#if BITS_PER_LONG == 32
+#define bitmap_arr32_compat(nbits)		true
+#elif defined(__LITTLE_ENDIAN)
+#define bitmap_arr32_compat(nbits)		\
+	(__builtin_constant_p(nbits) &&		\
+	 BITS_TO_U32(nbits) * sizeof(u32) ==	\
+	 BITS_TO_LONGS(nbits) * sizeof(long))
 #else
-#define bitmap_from_arr32(bitmap, buf, nbits)			\
-	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
-			(const unsigned long *) (buf), (nbits))
-#define bitmap_to_arr32(buf, bitmap, nbits)			\
-	bitmap_copy_clear_tail((unsigned long *) (buf),		\
-			(const unsigned long *) (bitmap), (nbits))
+#define bitmap_arr32_compat(nbits)		false
 #endif
 
+void __bitmap_from_arr32(unsigned long *bitmap, const u32 *buf, unsigned int nbits);
+void __bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits);
+
+static inline void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
+				     unsigned int nbits)
+{
+	const unsigned long *src = (const unsigned long *)buf;
+
+	if (bitmap_arr32_compat(nbits))
+		bitmap_copy_clear_tail(bitmap, src, nbits);
+	else
+		__bitmap_from_arr32(bitmap, buf, nbits);
+}
+
+static inline void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
+				   unsigned int nbits)
+{
+	unsigned long *dst = (unsigned long *)buf;
+
+	if (bitmap_arr32_compat(nbits))
+		bitmap_copy_clear_tail(dst, bitmap, nbits);
+	else
+		__bitmap_to_arr32(buf, bitmap, nbits);
+}
+
 /*
  * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
  * machines the order of hi and lo parts of numbers match the bitmap structure.
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1c81413c51f8..e3eb12ff1637 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1449,12 +1449,12 @@ EXPORT_SYMBOL_GPL(devm_bitmap_zalloc);
 
 #if BITS_PER_LONG == 64
 /**
- * bitmap_from_arr32 - copy the contents of u32 array of bits to bitmap
+ * __bitmap_from_arr32 - copy the contents of u32 array of bits to bitmap
  *	@bitmap: array of unsigned longs, the destination bitmap
  *	@buf: array of u32 (in host byte order), the source bitmap
  *	@nbits: number of bits in @bitmap
  */
-void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf, unsigned int nbits)
+void __bitmap_from_arr32(unsigned long *bitmap, const u32 *buf, unsigned int nbits)
 {
 	unsigned int i, halfwords;
 
@@ -1469,15 +1469,15 @@ void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf, unsigned int nbits
 	if (nbits % BITS_PER_LONG)
 		bitmap[(halfwords - 1) / 2] &= BITMAP_LAST_WORD_MASK(nbits);
 }
-EXPORT_SYMBOL(bitmap_from_arr32);
+EXPORT_SYMBOL(__bitmap_from_arr32);
 
 /**
- * bitmap_to_arr32 - copy the contents of bitmap to a u32 array of bits
+ * __bitmap_to_arr32 - copy the contents of bitmap to a u32 array of bits
  *	@buf: array of u32 (in host byte order), the dest bitmap
  *	@bitmap: array of unsigned longs, the source bitmap
  *	@nbits: number of bits in @bitmap
  */
-void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
+void __bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
 {
 	unsigned int i, halfwords;
 
@@ -1492,7 +1492,7 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
 	if (nbits % BITS_PER_LONG)
 		buf[halfwords - 1] &= (u32) (UINT_MAX >> ((-nbits) & 31));
 }
-EXPORT_SYMBOL(bitmap_to_arr32);
+EXPORT_SYMBOL(__bitmap_to_arr32);
 #endif
 
 #if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
-- 
2.37.3


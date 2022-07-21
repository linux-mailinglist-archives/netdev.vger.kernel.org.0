Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580FC57D090
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiGUQCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiGUQCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:02:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D315D87C1C;
        Thu, 21 Jul 2022 09:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658419328; x=1689955328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YVgl0JO+cgerJOjyuUL3a2hE4LW5e+w17YvGt7vdYMQ=;
  b=LYV5Ge48dNkZGcUowEN7I+KQEP2Srwth56kMDjPz7pfLMSs8cDdlmMBo
   8x3wodC16Loi6/ESfAbaY2d3eQZsvUhF3khjbPVc4VHeUSLJmyKzecVSE
   seGgpDVmfPrjn4HxSK3mTzASZURQA8/iO3Xx5DzKqL+l8bmm2HQRqFFy4
   VPOhathufFjMnvFdBIxwkIa4+KOTNxNb7K02tS43PlvyFwNmx78n7NQDE
   kGF7NjOtFGKX93Q/Mx46++Es6Gj1hlKMc93y+98QiQM7unh+khmIFRWDi
   Fg01X/HnBKaPtCss8oBCGdSIXg28kFaqTIOLTbfyNwH0yD++Rd4eE87c7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="284644036"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="284644036"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:01:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="548825381"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 21 Jul 2022 09:01:40 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26LG1crZ003918;
        Thu, 21 Jul 2022 17:01:39 +0100
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
Subject: [PATCH net-next 1/4] bitmap: add converting from/to 64-bit arrays of explicit byteorder
Date:   Thu, 21 Jul 2022 17:59:47 +0200
Message-Id: <20220721155950.747251-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721155950.747251-1-alexandr.lobakin@intel.com>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike bitmaps, which are purely host-endian and host-type, arrays
of bits can have not only explicit type, but explicit Endianness
as well. They can come from the userspace, network, hardware etc.
Add ability to pass explicitly-byteordered arrays of u64s to
bitmap_{from,to}_arr64() by extending the already existing external
functions and adding a couple static inlines, just to not change
the prototypes of the already existing ones. Users of the existing
API which previously were being optimized to a simple copy are not
affected, since the externals are being called only when byteswap
is needed.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/bitmap.h | 58 ++++++++++++++++++++++++++----
 lib/bitmap.c           | 82 ++++++++++++++++++++++++++++++++----------
 2 files changed, 115 insertions(+), 25 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 035d4ac66641..95408d6e0f94 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -72,8 +72,10 @@ struct device;
  *  bitmap_allocate_region(bitmap, pos, order)  Allocate specified bit region
  *  bitmap_from_arr32(dst, buf, nbits)          Copy nbits from u32[] buf to dst
  *  bitmap_from_arr64(dst, buf, nbits)          Copy nbits from u64[] buf to dst
+ *  bitmap_from_arr64_type(dst, buf, nbits, type)  Copy nbits from {u,be,le}64[]
  *  bitmap_to_arr32(buf, src, nbits)            Copy nbits from buf to u32[] dst
  *  bitmap_to_arr64(buf, src, nbits)            Copy nbits from buf to u64[] dst
+ *  bitmap_to_arr64_type(buf, src, nbits, type)  Copy nbits to {u,be,le}64[] dst
  *  bitmap_get_value8(map, start)               Get 8bit value from map at start
  *  bitmap_set_value8(map, value, start)        Set 8bit value to map at start
  *
@@ -299,22 +301,64 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
 			(const unsigned long *) (bitmap), (nbits))
 #endif
 
+enum {
+	BITMAP_ARR_U64 = 0U,
+#ifdef __BIG_ENDIAN
+	BITMAP_ARR_BE64 = BITMAP_ARR_U64,
+	BITMAP_ARR_LE64,
+#else
+	BITMAP_ARR_LE64 = BITMAP_ARR_U64,
+	BITMAP_ARR_BE64,
+#endif
+	__BITMAP_ARR_TYPE_NUM,
+};
+
+void __bitmap_from_arr64_type(unsigned long *bitmap, const void *buf,
+			      unsigned int nbits, u32 type);
+void __bitmap_to_arr64_type(void *arr, const unsigned long *buf,
+			    unsigned int nbits, u32 type);
+
 /*
  * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
  * machines the order of hi and lo parts of numbers match the bitmap structure.
  * In both cases conversion is not needed when copying data from/to arrays of
  * u64.
  */
-#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
-void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits);
-void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
+#ifdef __BIG_ENDIAN
+#define bitmap_is_arr64_native(type)					\
+	(__builtin_constant_p(type) && (type) == BITMAP_ARR_U64 &&	\
+	 BITS_PER_LONG == 64)
 #else
-#define bitmap_from_arr64(bitmap, buf, nbits)			\
-	bitmap_copy_clear_tail((unsigned long *)(bitmap), (const unsigned long *)(buf), (nbits))
-#define bitmap_to_arr64(buf, bitmap, nbits)			\
-	bitmap_copy_clear_tail((unsigned long *)(buf), (const unsigned long *)(bitmap), (nbits))
+#define bitmap_is_arr64_native(type)					\
+	(__builtin_constant_p(type) && (type) == BITMAP_ARR_U64)
 #endif
 
+static __always_inline void bitmap_from_arr64_type(unsigned long *bitmap,
+						   const void *buf,
+						   unsigned int nbits,
+						   u32 type)
+{
+	if (bitmap_is_arr64_native(type))
+		bitmap_copy_clear_tail(bitmap, buf, nbits);
+	else
+		__bitmap_from_arr64_type(bitmap, buf, nbits, type);
+}
+
+static __always_inline void bitmap_to_arr64_type(void *buf,
+						 const unsigned long *bitmap,
+						 unsigned int nbits, u32 type)
+{
+	if (bitmap_is_arr64_native(type))
+		bitmap_copy_clear_tail(buf, bitmap, nbits);
+	else
+		__bitmap_to_arr64_type(buf, bitmap, nbits, type);
+}
+
+#define bitmap_from_arr64(bitmap, buf, nbits)				\
+	bitmap_from_arr64_type((bitmap), (buf), (nbits), BITMAP_ARR_U64)
+#define bitmap_to_arr64(buf, bitmap, nbits)				\
+	bitmap_to_arr64_type((buf), (bitmap), (nbits), BITMAP_ARR_U64)
+
 static inline bool bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
 {
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 2b67cd657692..e660077f2099 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1513,23 +1513,46 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
 EXPORT_SYMBOL(bitmap_to_arr32);
 #endif
 
-#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
 /**
- * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
+ * __bitmap_from_arr64_type - copy the contents of u64 array of bits to bitmap
  *	@bitmap: array of unsigned longs, the destination bitmap
- *	@buf: array of u64 (in host byte order), the source bitmap
+ *	@buf: array of u64/__be64/__le64, the source bitmap
  *	@nbits: number of bits in @bitmap
+ *	@type: type of the array (%BITMAP_ARR_*64)
  */
-void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits)
+void __bitmap_from_arr64_type(unsigned long *bitmap, const void *buf,
+			      unsigned int nbits, u32 type)
 {
+	const union {
+		__be64	be;
+		__le64	le;
+		u64	u;
+	} *src = buf;
 	int n;
 
 	for (n = nbits; n > 0; n -= 64) {
-		u64 val = *buf++;
+		u64 val;
+
+		switch (type) {
+#ifdef __LITTLE_ENDIAN
+		case BITMAP_ARR_BE64:
+			val = be64_to_cpu((src++)->be);
+			break;
+#else
+		case BITMAP_ARR_LE64:
+			val = le64_to_cpu((src++)->le);
+			break;
+#endif
+		default:
+			val = (src++)->u;
+			break;
+		}
 
 		*bitmap++ = val;
+#if BITS_PER_LONG == 32
 		if (n > 32)
 			*bitmap++ = val >> 32;
+#endif
 	}
 
 	/*
@@ -1542,28 +1565,51 @@ void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits
 	if (nbits % BITS_PER_LONG)
 		bitmap[-1] &= BITMAP_LAST_WORD_MASK(nbits);
 }
-EXPORT_SYMBOL(bitmap_from_arr64);
+EXPORT_SYMBOL(__bitmap_from_arr64_type);
 
 /**
- * bitmap_to_arr64 - copy the contents of bitmap to a u64 array of bits
- *	@buf: array of u64 (in host byte order), the dest bitmap
+ * __bitmap_to_arr64_type - copy the contents of bitmap to a u64 array of bits
+ *	@buf: array of u64/__be64/__le64, the dest bitmap
  *	@bitmap: array of unsigned longs, the source bitmap
  *	@nbits: number of bits in @bitmap
+ *	@type: type of the array (%BITMAP_ARR_*64)
  */
-void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
+void __bitmap_to_arr64_type(void *buf, const unsigned long *bitmap,
+			    unsigned int nbits, u32 type)
 {
 	const unsigned long *end = bitmap + BITS_TO_LONGS(nbits);
+	union {
+		__be64	be;
+		__le64	le;
+		u64	u;
+	} *dst = buf;
 
 	while (bitmap < end) {
-		*buf = *bitmap++;
+		u64 val = *bitmap++;
+
+#if BITS_PER_LONG == 32
 		if (bitmap < end)
-			*buf |= (u64)(*bitmap++) << 32;
-		buf++;
-	}
+			val |= (u64)(*bitmap++) << 32;
+#endif
 
-	/* Clear tail bits in the last element of array beyond nbits. */
-	if (nbits % 64)
-		buf[-1] &= GENMASK_ULL((nbits - 1) % 64, 0);
-}
-EXPORT_SYMBOL(bitmap_to_arr64);
+		/* Clear tail bits in the last element of array beyond nbits. */
+		if (bitmap == end && (nbits % 64))
+			val &= GENMASK_ULL((nbits - 1) % 64, 0);
+
+		switch (type) {
+#ifdef __LITTLE_ENDIAN
+		case BITMAP_ARR_BE64:
+			(dst++)->be = cpu_to_be64(val);
+			break;
+#else
+		case BITMAP_ARR_LE64:
+			(dst++)->le = cpu_to_le64(val);
+			break;
 #endif
+		default:
+			(dst++)->u = val;
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(__bitmap_to_arr64_type);
-- 
2.36.1


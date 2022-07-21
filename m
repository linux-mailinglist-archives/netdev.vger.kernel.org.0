Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B581B57D094
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiGUQCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbiGUQCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:02:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9959D87C19;
        Thu, 21 Jul 2022 09:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658419327; x=1689955327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TLgsJjRByhDdYcQIOFE4TYOytMD2wruMCKk+/mfVKmU=;
  b=K8vGNM2IHVmcm5SpnWhk/+VM19W6mpRb+OTcruR6l8u97AeUX42ItWyr
   3AL2mGxxTB9MuwxgDf/gmOwQDPrtVBzl626RFjHHwzXPt/xzCERRGuZOh
   30vXyQEHiyuobN6tXOnw5o6U57RSVXXr/Zk28Q1uIJ6PI3dIse7vyWI3r
   LklHnNKuSiCJ87d5cow3nXVhq8zWRiib7QUbt72wtEi3u+Nqi2G7c0+ao
   P7pYvCnHH9wF8Lo4r3JKWRov4gcFdn+m1j+TldbBfUCayEp7a5J1GodSp
   q/MyBHhXjVudFVXz1ocU7pvmkMNnxKFmSkdl84KooWsZRofPgGPeofYkb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="288255781"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="288255781"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="666337450"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jul 2022 09:01:41 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26LG1cra003918;
        Thu, 21 Jul 2022 17:01:40 +0100
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
Subject: [PATCH net-next 2/4] bitmap: add a couple more helpers to work with arrays of u64s
Date:   Thu, 21 Jul 2022 17:59:48 +0200
Message-Id: <20220721155950.747251-3-alexandr.lobakin@intel.com>
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

Add two new functions to work on arr64s:

* bitmap_arr64_size() - takes number of bits to be stored in arr64
  and returns number of bytes required to store such arr64, can be
  useful when allocating memory for arr64 containers;
* bitmap_validate_arr64{,_type}() - takes pointer to an arr64 and
  its size in bytes, plus expected number of bits and array
  Endianness. Ensures that the size is valid (must be a multiply
  of `sizeof(u64)`) and no bits past the number is set (for the
  specified byteorder).

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/bitmap.h | 22 ++++++++++++++-
 lib/bitmap.c           | 63 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 95408d6e0f94..14add46e06e4 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -7,7 +7,8 @@
 #include <linux/align.h>
 #include <linux/bitops.h>
 #include <linux/find.h>
-#include <linux/limits.h>
+#include <linux/math.h>
+#include <linux/overflow.h>
 #include <linux/string.h>
 #include <linux/types.h>
 
@@ -76,6 +77,9 @@ struct device;
  *  bitmap_to_arr32(buf, src, nbits)            Copy nbits from buf to u32[] dst
  *  bitmap_to_arr64(buf, src, nbits)            Copy nbits from buf to u64[] dst
  *  bitmap_to_arr64_type(buf, src, nbits, type)  Copy nbits to {u,be,le}64[] dst
+ *  bitmap_validate_arr64_type(buf, len, nbits, type)  Validate {u,be,le}64[]
+ *  bitmap_validate_arr64(buf, len, nbits)      Validate u64[] buf of len bytes
+ *  bitmap_arr64_size(nbits)                    Get size of u64[] arr for nbits
  *  bitmap_get_value8(map, start)               Get 8bit value from map at start
  *  bitmap_set_value8(map, value, start)        Set 8bit value to map at start
  *
@@ -317,6 +321,8 @@ void __bitmap_from_arr64_type(unsigned long *bitmap, const void *buf,
 			      unsigned int nbits, u32 type);
 void __bitmap_to_arr64_type(void *arr, const unsigned long *buf,
 			    unsigned int nbits, u32 type);
+int bitmap_validate_arr64_type(const void *buf, size_t len, size_t nbits,
+			       u32 type);
 
 /*
  * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
@@ -358,6 +364,20 @@ static __always_inline void bitmap_to_arr64_type(void *buf,
 	bitmap_from_arr64_type((bitmap), (buf), (nbits), BITMAP_ARR_U64)
 #define bitmap_to_arr64(buf, bitmap, nbits)				\
 	bitmap_to_arr64_type((buf), (bitmap), (nbits), BITMAP_ARR_U64)
+#define bitmap_validate_arr64(buf, len, nbits)				\
+	bitmap_validate_arr64_type((buf), (len), (nbits), BITMAP_ARR_U64)
+
+/**
+ * bitmap_arr64_size - determine the size of array of u64s for a number of bits
+ * @nbits: number of bits to store in the array
+ *
+ * Returns the size in bytes of a u64s-array needed to carry the specified
+ * number of bits.
+ */
+static inline size_t bitmap_arr64_size(size_t nbits)
+{
+	return array_size(BITS_TO_U64(nbits), sizeof(u64));
+}
 
 static inline bool bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
diff --git a/lib/bitmap.c b/lib/bitmap.c
index e660077f2099..5ad6f18f27dc 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1613,3 +1613,66 @@ void __bitmap_to_arr64_type(void *buf, const unsigned long *bitmap,
 	}
 }
 EXPORT_SYMBOL(__bitmap_to_arr64_type);
+
+/**
+ * bitmap_validate_arr64_type - perform validation of a u64-array bitmap
+ * @buf: array of u64/__be64/__le64, the dest bitmap
+ * @len: length of the array, in bytes
+ * @nbits: expected/supported number of bits in the bitmap
+ * @type: expected array type (%BITMAP_*64)
+ *
+ * Returns 0 if the array passed the checks (see below), -%EINVAL otherwise.
+ */
+int bitmap_validate_arr64_type(const void *buf, size_t len, size_t nbits,
+			       u32 type)
+{
+	size_t word = (nbits - 1) / BITS_PER_TYPE(u64);
+	u32 pos = (nbits - 1) % BITS_PER_TYPE(u64);
+	const union {
+		__be64	be;
+		__le64	le;
+		u64	u;
+	} *arr = buf;
+	u64 last;
+
+	/* Must consist of 1...n full u64s */
+	if (!len || len % sizeof(u64))
+		return -EINVAL;
+
+	/*
+	 * If the array is shorter than expected, assume we support
+	 * all of the bits set there
+	 */
+	if (word >= len / sizeof(u64))
+		return 0;
+
+	switch (type) {
+#ifdef __LITTLE_ENDIAN
+	case BITMAP_ARR_BE64:
+		last = be64_to_cpu(arr[word].be);
+		break;
+#else
+	case BITMAP_ARR_LE64:
+		last = le64_to_cpu(arr[word].le);
+		break;
+#endif
+	default:
+		last = arr[word].u;
+		break;
+	}
+
+	/* Last word must not contain any bits past the expected number */
+	if (last & ~GENMASK_ULL(pos, 0))
+		return -EINVAL;
+
+	/*
+	 * If the array is longer than expected, make sure all the bytes
+	 * past the expected length are zeroed
+	 */
+	len -= bitmap_arr64_size(nbits);
+	if (len && memchr_inv(&arr[word + 1], 0, len))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(bitmap_validate_arr64_type);
-- 
2.36.1


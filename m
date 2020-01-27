Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A1B149FC4
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgA0IWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:22:10 -0500
Received: from correo.us.es ([193.147.175.20]:36462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgA0IWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 03:22:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21663B193C
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:22:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FA99DA70F
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:22:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 03E71DA707; Mon, 27 Jan 2020 09:22:08 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFFE1DA716;
        Mon, 27 Jan 2020 09:22:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 27 Jan 2020 09:22:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AD2CD42EFB82;
        Mon, 27 Jan 2020 09:22:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/6] bitmap: Introduce bitmap_cut(): cut bits and shift remaining
Date:   Mon, 27 Jan 2020 09:20:52 +0100
Message-Id: <20200127082054.318263-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200127082054.318263-1-pablo@netfilter.org>
References: <20200127082054.318263-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

The new bitmap function bitmap_cut() copies bits from source to
destination by removing the region specified by parameters first
and cut, and remapping the bits above the cut region by right
shifting them.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/bitmap.h |  4 +++
 lib/bitmap.c           | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index ff335b22f23c..f0f3a9fffa6a 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -53,6 +53,7 @@
  *  bitmap_find_next_zero_area_off(buf, len, pos, n, mask)  as above
  *  bitmap_shift_right(dst, src, n, nbits)      *dst = *src >> n
  *  bitmap_shift_left(dst, src, n, nbits)       *dst = *src << n
+ *  bitmap_cut(dst, src, first, n, nbits)       Cut n bits from first, copy rest
  *  bitmap_replace(dst, old, new, mask, nbits)  *dst = (*old & ~(*mask)) | (*new & *mask)
  *  bitmap_remap(dst, src, old, new, nbits)     *dst = map(old, new)(src)
  *  bitmap_bitremap(oldbit, old, new, nbits)    newbit = map(old, new)(oldbit)
@@ -133,6 +134,9 @@ extern void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 				unsigned int shift, unsigned int nbits);
 extern void __bitmap_shift_left(unsigned long *dst, const unsigned long *src,
 				unsigned int shift, unsigned int nbits);
+extern void bitmap_cut(unsigned long *dst, const unsigned long *src,
+		       unsigned int first, unsigned int cut,
+		       unsigned int nbits);
 extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 4250519d7d1c..6e175fbd69a9 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -168,6 +168,72 @@ void __bitmap_shift_left(unsigned long *dst, const unsigned long *src,
 }
 EXPORT_SYMBOL(__bitmap_shift_left);
 
+/**
+ * bitmap_cut() - remove bit region from bitmap and right shift remaining bits
+ * @dst: destination bitmap, might overlap with src
+ * @src: source bitmap
+ * @first: start bit of region to be removed
+ * @cut: number of bits to remove
+ * @nbits: bitmap size, in bits
+ *
+ * Set the n-th bit of @dst iff the n-th bit of @src is set and
+ * n is less than @first, or the m-th bit of @src is set for any
+ * m such that @first <= n < nbits, and m = n + @cut.
+ *
+ * In pictures, example for a big-endian 32-bit architecture:
+ *
+ * @src:
+ * 31                                   63
+ * |                                    |
+ * 10000000 11000001 11110010 00010101  10000000 11000001 01110010 00010101
+ *                 |  |              |                                    |
+ *                16  14             0                                   32
+ *
+ * if @cut is 3, and @first is 14, bits 14-16 in @src are cut and @dst is:
+ *
+ * 31                                   63
+ * |                                    |
+ * 10110000 00011000 00110010 00010101  00010000 00011000 00101110 01000010
+ *                    |              |                                    |
+ *                    14 (bit 17     0                                   32
+ *                        from @src)
+ *
+ * Note that @dst and @src might overlap partially or entirely.
+ *
+ * This is implemented in the obvious way, with a shift and carry
+ * step for each moved bit. Optimisation is left as an exercise
+ * for the compiler.
+ */
+void bitmap_cut(unsigned long *dst, const unsigned long *src,
+		unsigned int first, unsigned int cut, unsigned int nbits)
+{
+	unsigned int len = BITS_TO_LONGS(nbits);
+	unsigned long keep = 0, carry;
+	int i;
+
+	memmove(dst, src, len * sizeof(*dst));
+
+	if (first % BITS_PER_LONG) {
+		keep = src[first / BITS_PER_LONG] &
+		       (~0UL >> (BITS_PER_LONG - first % BITS_PER_LONG));
+	}
+
+	while (cut--) {
+		for (i = first / BITS_PER_LONG; i < len; i++) {
+			if (i < len - 1)
+				carry = dst[i + 1] & 1UL;
+			else
+				carry = 0;
+
+			dst[i] = (dst[i] >> 1) | (carry << (BITS_PER_LONG - 1));
+		}
+	}
+
+	dst[first / BITS_PER_LONG] &= ~0UL << (first % BITS_PER_LONG);
+	dst[first / BITS_PER_LONG] |= keep;
+}
+EXPORT_SYMBOL(bitmap_cut);
+
 int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
 				const unsigned long *bitmap2, unsigned int bits)
 {
-- 
2.11.0


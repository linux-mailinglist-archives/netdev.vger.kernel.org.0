Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB612DA14
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 02:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfD2ASI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 20:18:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37477 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfD2ASG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 20:18:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id y5so12108161wma.2;
        Sun, 28 Apr 2019 17:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KkaAxwd97wwTaARTV5x8DDdbMHY9W1GA1YNkQGVL3tg=;
        b=jxb2kBE89YtCj9H8JobuVqkgIMC/yr/2wx52juhbF0ZHFCkXGPyjygT5dwbS6zHSdK
         nWGIBTxsK4Ro+0JDxt2Io+NVu6Wx7Hhzjn2Hnzjbr1FSlaS2FyWWMddHqMG7KXKhIwP+
         f92PZ58URWEV9klmhJ/RGYjJ18U0gIGSQfTRYyjBZ++w1Wvbpf9C4C/Ho4SP/qFX6xyY
         nIjA3BO0KNjkvcqsbUzshkunJ4+bHLdwtIFCWqGGpRNtlrwFCmgbCYnsYQHozl7DhpNR
         lNknZNw3kNarc5z0mifMzBM7AVjDi+rEBrQ/Z8xbsLHvEshWio+boeLosaqK8Dv9a1mY
         vRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KkaAxwd97wwTaARTV5x8DDdbMHY9W1GA1YNkQGVL3tg=;
        b=kbbZ9naqyyaJjqMH4SKwhPT4LD0/TaRpLunD+ODtemw5UemuowOEBOZZtmYBucCcLR
         k3qoIeoSiFMORH+lvaTkZyOBg2sn46mtUCPhdy1WYblTHpiBOEES7tzc87egkwWi++j8
         HX2ILtc5BV7aOfR0MaPzVxmJ0gEJ9ZvLN8PbP6VEHosPV3Ov1QFiVhMLY4b5udiWV7VT
         GB7Dn7ANA0v8M5P+/aKRpPf3HUsrA2pxlAd5w8EkansZNNHZf9A623droN1YwBX0HWxT
         TcrCOEJMsuhYgq4G6e7fvHacjLuRRLugdkZ35T4SxAYGNQn28rzlG5IV5RypoZanoULg
         SMWg==
X-Gm-Message-State: APjAAAV8ehwCrsXEykLpQHy9v/6ZPmsCq2aQPllI9slLvaxMGUYGHdVO
        zoE+ac9FNTtsJcELFcQ17u0=
X-Google-Smtp-Source: APXvYqzl5fdOUMUT0G1BS3RnN6e+7ZJuVyXKg9ji8oochcPhfTVKYV98UOJyWofrVctoA1CSBmzKLQ==
X-Received: by 2002:a1c:730c:: with SMTP id d12mr14638993wmb.47.1556497082891;
        Sun, 28 Apr 2019 17:18:02 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id h16sm5098030wrb.31.2019.04.28.17.18.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 17:18:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 01/12] lib: Add support for generic packing operations
Date:   Mon, 29 Apr 2019 03:16:55 +0300
Message-Id: <20190429001706.7449-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190429001706.7449-1-olteanv@gmail.com>
References: <20190429001706.7449-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides an unified API for accessing register bit fields
regardless of memory layout. The basic unit of data for these API
functions is the u64. The process of transforming an u64 from native CPU
encoding into the peripheral's encoding is called 'pack', and
transforming it from peripheral to native CPU encoding is 'unpack'.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:
None

Changes in v3:
None

Changes in v2:
None

 Documentation/packing.txt | 150 +++++++++++++++++++++++++++
 MAINTAINERS               |   8 ++
 include/linux/packing.h   |  49 +++++++++
 lib/Makefile              |   2 +-
 lib/packing.c             | 211 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 419 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/packing.txt
 create mode 100644 include/linux/packing.h
 create mode 100644 lib/packing.c

diff --git a/Documentation/packing.txt b/Documentation/packing.txt
new file mode 100644
index 000000000000..32eba9d23611
--- /dev/null
+++ b/Documentation/packing.txt
@@ -0,0 +1,150 @@
+=============================================
+Generic field packing and unpacking functions
+=============================================
+
+Problem statement
+-----------------
+
+When working with hardware, one has to choose between several approaches of
+interfacing with it.
+One can memory-map a pointer to a carefully crafted struct over the hardware
+device's memory region, and access its fields as struct members (potentially
+declared as bit fields). But writing code this way would make it less portable,
+due to potential endianness mismatches between the CPU and the hardware device.
+Additionally, one has to pay close attention when translating register
+definitions from the hardware documentation into bit field indices for the
+structs. Also, some hardware (typically networking equipment) tends to group
+its register fields in ways that violate any reasonable word boundaries
+(sometimes even 64 bit ones). This creates the inconvenience of having to
+define "high" and "low" portions of register fields within the struct.
+A more robust alternative to struct field definitions would be to extract the
+required fields by shifting the appropriate number of bits. But this would
+still not protect from endianness mismatches, except if all memory accesses
+were performed byte-by-byte. Also the code can easily get cluttered, and the
+high-level idea might get lost among the many bit shifts required.
+Many drivers take the bit-shifting approach and then attempt to reduce the
+clutter with tailored macros, but more often than not these macros take
+shortcuts that still prevent the code from being truly portable.
+
+The solution
+------------
+
+This API deals with 2 basic operations:
+  - Packing a CPU-usable number into a memory buffer (with hardware
+    constraints/quirks)
+  - Unpacking a memory buffer (which has hardware constraints/quirks)
+    into a CPU-usable number.
+
+The API offers an abstraction over said hardware constraints and quirks,
+over CPU endianness and therefore between possible mismatches between
+the two.
+
+The basic unit of these API functions is the u64. From the CPU's
+perspective, bit 63 always means bit offset 7 of byte 7, albeit only
+logically. The question is: where do we lay this bit out in memory?
+
+The following examples cover the memory layout of a packed u64 field.
+The byte offsets in the packed buffer are always implicitly 0, 1, ... 7.
+What the examples show is where the logical bytes and bits sit.
+
+1. Normally (no quirks), we would do it like this:
+
+63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
+7                       6                       5                        4
+31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
+3                       2                       1                        0
+
+That is, the MSByte (7) of the CPU-usable u64 sits at memory offset 0, and the
+LSByte (0) of the u64 sits at memory offset 7.
+This corresponds to what most folks would regard to as "big endian", where
+bit i corresponds to the number 2^i. This is also referred to in the code
+comments as "logical" notation.
+
+
+2. If QUIRK_MSB_ON_THE_RIGHT is set, we do it like this:
+
+56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
+7                       6                        5                       4
+24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
+3                       2                        1                       0
+
+That is, QUIRK_MSB_ON_THE_RIGHT does not affect byte positioning, but
+inverts bit offsets inside a byte.
+
+
+3. If QUIRK_LITTLE_ENDIAN is set, we do it like this:
+
+39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
+4                       5                       6                       7
+7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
+0                       1                       2                       3
+
+Therefore, QUIRK_LITTLE_ENDIAN means that inside the memory region, every
+byte from each 4-byte word is placed at its mirrored position compared to
+the boundary of that word.
+
+4. If QUIRK_MSB_ON_THE_RIGHT and QUIRK_LITTLE_ENDIAN are both set, we do it
+   like this:
+
+32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
+4                       5                       6                       7
+0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
+0                       1                       2                       3
+
+
+5. If just QUIRK_LSW32_IS_FIRST is set, we do it like this:
+
+31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
+3                       2                       1                        0
+63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
+7                       6                       5                        4
+
+In this case the 8 byte memory region is interpreted as follows: first
+4 bytes correspond to the least significant 4-byte word, next 4 bytes to
+the more significant 4-byte word.
+
+
+6. If QUIRK_LSW32_IS_FIRST and QUIRK_MSB_ON_THE_RIGHT are set, we do it like
+   this:
+
+24 25 26 27 28 29 30 31 16 17 18 19 20 21 22 23  8  9 10 11 12 13 14 15  0  1  2  3  4  5  6  7
+3                       2                        1                       0
+56 57 58 59 60 61 62 63 48 49 50 51 52 53 54 55 40 41 42 43 44 45 46 47 32 33 34 35 36 37 38 39
+7                       6                        5                       4
+
+
+7. If QUIRK_LSW32_IS_FIRST and QUIRK_LITTLE_ENDIAN are set, it looks like
+   this:
+
+7  6  5  4  3  2  1  0  15 14 13 12 11 10  9  8 23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
+0                       1                       2                       3
+39 38 37 36 35 34 33 32 47 46 45 44 43 42 41 40 55 54 53 52 51 50 49 48 63 62 61 60 59 58 57 56
+4                       5                       6                       7
+
+
+8. If QUIRK_LSW32_IS_FIRST, QUIRK_LITTLE_ENDIAN and QUIRK_MSB_ON_THE_RIGHT
+   are set, it looks like this:
+
+0  1  2  3  4  5  6  7  8   9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
+0                       1                       2                       3
+32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
+4                       5                       6                       7
+
+
+We always think of our offsets as if there were no quirk, and we translate
+them afterwards, before accessing the memory region.
+
+Intended use
+------------
+
+Drivers that opt to use this API first need to identify which of the above 3
+quirk combinations (for a total of 8) match what the hardware documentation
+describes. Then they should wrap the packing() function, creating a new
+xxx_packing() that calls it using the proper QUIRK_* one-hot bits set.
+
+The packing() function returns an int-encoded error code, which protects the
+programmer against incorrect API use.  The errors are not expected to occur
+durring runtime, therefore it is reasonable for xxx_packing() to return void
+and simply swallow those errors. Optionally it can dump stack or print the
+error description.
+
diff --git a/MAINTAINERS b/MAINTAINERS
index 0af66fa919a8..ff029f3d0f13 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11673,6 +11673,14 @@ L:	linux-i2c@vger.kernel.org
 S:	Orphan
 F:	drivers/i2c/busses/i2c-pasemi.c
 
+PACKING
+M:	Vladimir Oltean <olteanv@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	lib/packing.c
+F:	include/linux/packing.h
+F:	Documentation/packing.txt
+
 PADATA PARALLEL EXECUTION MECHANISM
 M:	Steffen Klassert <steffen.klassert@secunet.com>
 L:	linux-crypto@vger.kernel.org
diff --git a/include/linux/packing.h b/include/linux/packing.h
new file mode 100644
index 000000000000..cc646e4f5df1
--- /dev/null
+++ b/include/linux/packing.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: BSD-3-Clause
+ * Copyright (c) 2016-2018, NXP Semiconductors
+ * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#ifndef _LINUX_PACKING_H
+#define _LINUX_PACKING_H
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+
+#define QUIRK_MSB_ON_THE_RIGHT BIT(0)
+#define QUIRK_LITTLE_ENDIAN    BIT(1)
+#define QUIRK_LSW32_IS_FIRST   BIT(2)
+
+enum packing_op {
+	PACK,
+	UNPACK,
+};
+
+/**
+ * packing - Convert numbers (currently u64) between a packed and an unpacked
+ *	     format. Unpacked means laid out in memory in the CPU's native
+ *	     understanding of integers, while packed means anything else that
+ *	     requires translation.
+ *
+ * @pbuf: Pointer to a buffer holding the packed value.
+ * @uval: Pointer to an u64 holding the unpacked value.
+ * @startbit: The index (in logical notation, compensated for quirks) where
+ *	      the packed value starts within pbuf. Must be larger than, or
+ *	      equal to, endbit.
+ * @endbit: The index (in logical notation, compensated for quirks) where
+ *	    the packed value ends within pbuf. Must be smaller than, or equal
+ *	    to, startbit.
+ * @op: If PACK, then uval will be treated as const pointer and copied (packed)
+ *	into pbuf, between startbit and endbit.
+ *	If UNPACK, then pbuf will be treated as const pointer and the logical
+ *	value between startbit and endbit will be copied (unpacked) to uval.
+ * @quirks: A bit mask of QUIRK_LITTLE_ENDIAN, QUIRK_LSW32_IS_FIRST and
+ *	    QUIRK_MSB_ON_THE_RIGHT.
+ *
+ * Return: 0 on success, EINVAL or ERANGE if called incorrectly. Assuming
+ *	   correct usage, return code may be discarded.
+ *	   If op is PACK, pbuf is modified.
+ *	   If op is UNPACK, uval is modified.
+ */
+int packing(void *pbuf, u64 *uval, int startbit, int endbit, size_t pbuflen,
+	    enum packing_op op, u8 quirks);
+
+#endif
diff --git a/lib/Makefile b/lib/Makefile
index 3b08673e8881..ae4b1f52c1ec 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -37,7 +37,7 @@ obj-y += bcd.o div64.o sort.o parser.o debug_locks.o random32.o \
 	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o iov_iter.o clz_ctz.o \
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
-	 percpu-refcount.o rhashtable.o reciprocal_div.o \
+	 packing.o percpu-refcount.o rhashtable.o reciprocal_div.o \
 	 once.o refcount.o usercopy.o errseq.o bucket_locks.o \
 	 generic-radix-tree.o
 obj-$(CONFIG_STRING_SELFTEST) += test_string.o
diff --git a/lib/packing.c b/lib/packing.c
new file mode 100644
index 000000000000..2d0bfd78bfe9
--- /dev/null
+++ b/lib/packing.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/* Copyright (c) 2016-2018, NXP Semiconductors
+ * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#include <linux/packing.h>
+#include <linux/module.h>
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+
+static int get_le_offset(int offset)
+{
+	int closest_multiple_of_4;
+
+	closest_multiple_of_4 = (offset / 4) * 4;
+	offset -= closest_multiple_of_4;
+	return closest_multiple_of_4 + (3 - offset);
+}
+
+static int get_reverse_lsw32_offset(int offset, size_t len)
+{
+	int closest_multiple_of_4;
+	int word_index;
+
+	word_index = offset / 4;
+	closest_multiple_of_4 = word_index * 4;
+	offset -= closest_multiple_of_4;
+	word_index = (len / 4) - word_index - 1;
+	return word_index * 4 + offset;
+}
+
+static u64 bit_reverse(u64 val, unsigned int width)
+{
+	u64 new_val = 0;
+	unsigned int bit;
+	unsigned int i;
+
+	for (i = 0; i < width; i++) {
+		bit = (val & (1 << i)) != 0;
+		new_val |= (bit << (width - i - 1));
+	}
+	return new_val;
+}
+
+static void adjust_for_msb_right_quirk(u64 *to_write, int *box_start_bit,
+				       int *box_end_bit, u8 *box_mask)
+{
+	int box_bit_width = *box_start_bit - *box_end_bit + 1;
+	int new_box_start_bit, new_box_end_bit;
+
+	*to_write >>= *box_end_bit;
+	*to_write = bit_reverse(*to_write, box_bit_width);
+	*to_write <<= *box_end_bit;
+
+	new_box_end_bit   = box_bit_width - *box_start_bit - 1;
+	new_box_start_bit = box_bit_width - *box_end_bit - 1;
+	*box_mask = GENMASK_ULL(new_box_start_bit, new_box_end_bit);
+	*box_start_bit = new_box_start_bit;
+	*box_end_bit   = new_box_end_bit;
+}
+
+/**
+ * packing - Convert numbers (currently u64) between a packed and an unpacked
+ *	     format. Unpacked means laid out in memory in the CPU's native
+ *	     understanding of integers, while packed means anything else that
+ *	     requires translation.
+ *
+ * @pbuf: Pointer to a buffer holding the packed value.
+ * @uval: Pointer to an u64 holding the unpacked value.
+ * @startbit: The index (in logical notation, compensated for quirks) where
+ *	      the packed value starts within pbuf. Must be larger than, or
+ *	      equal to, endbit.
+ * @endbit: The index (in logical notation, compensated for quirks) where
+ *	    the packed value ends within pbuf. Must be smaller than, or equal
+ *	    to, startbit.
+ * @op: If PACK, then uval will be treated as const pointer and copied (packed)
+ *	into pbuf, between startbit and endbit.
+ *	If UNPACK, then pbuf will be treated as const pointer and the logical
+ *	value between startbit and endbit will be copied (unpacked) to uval.
+ * @quirks: A bit mask of QUIRK_LITTLE_ENDIAN, QUIRK_LSW32_IS_FIRST and
+ *	    QUIRK_MSB_ON_THE_RIGHT.
+ *
+ * Return: 0 on success, EINVAL or ERANGE if called incorrectly. Assuming
+ *	   correct usage, return code may be discarded.
+ *	   If op is PACK, pbuf is modified.
+ *	   If op is UNPACK, uval is modified.
+ */
+int packing(void *pbuf, u64 *uval, int startbit, int endbit, size_t pbuflen,
+	    enum packing_op op, u8 quirks)
+{
+	/* Number of bits for storing "uval"
+	 * also width of the field to access in the pbuf
+	 */
+	u64 value_width;
+	/* Logical byte indices corresponding to the
+	 * start and end of the field.
+	 */
+	int plogical_first_u8, plogical_last_u8, box;
+
+	/* startbit is expected to be larger than endbit */
+	if (startbit < endbit)
+		/* Invalid function call */
+		return -EINVAL;
+
+	value_width = startbit - endbit + 1;
+	if (value_width > 64)
+		return -ERANGE;
+
+	/* Check if "uval" fits in "value_width" bits.
+	 * If value_width is 64, the check will fail, but any
+	 * 64-bit uval will surely fit.
+	 */
+	if (op == PACK && value_width < 64 && (*uval >= (1ull << value_width)))
+		/* Cannot store "uval" inside "value_width" bits.
+		 * Truncating "uval" is most certainly not desirable,
+		 * so simply erroring out is appropriate.
+		 */
+		return -ERANGE;
+
+	/* Initialize parameter */
+	if (op == UNPACK)
+		*uval = 0;
+
+	/* Iterate through an idealistic view of the pbuf as an u64 with
+	 * no quirks, u8 by u8 (aligned at u8 boundaries), from high to low
+	 * logical bit significance. "box" denotes the current logical u8.
+	 */
+	plogical_first_u8 = startbit / 8;
+	plogical_last_u8  = endbit / 8;
+
+	for (box = plogical_first_u8; box >= plogical_last_u8; box--) {
+		/* Bit indices into the currently accessed 8-bit box */
+		int box_start_bit, box_end_bit, box_addr;
+		u8  box_mask;
+		/* Corresponding bits from the unpacked u64 parameter */
+		int proj_start_bit, proj_end_bit;
+		u64 proj_mask;
+
+		/* This u8 may need to be accessed in its entirety
+		 * (from bit 7 to bit 0), or not, depending on the
+		 * input arguments startbit and endbit.
+		 */
+		if (box == plogical_first_u8)
+			box_start_bit = startbit % 8;
+		else
+			box_start_bit = 7;
+		if (box == plogical_last_u8)
+			box_end_bit = endbit % 8;
+		else
+			box_end_bit = 0;
+
+		/* We have determined the box bit start and end.
+		 * Now we calculate where this (masked) u8 box would fit
+		 * in the unpacked (CPU-readable) u64 - the u8 box's
+		 * projection onto the unpacked u64. Though the
+		 * box is u8, the projection is u64 because it may fall
+		 * anywhere within the unpacked u64.
+		 */
+		proj_start_bit = ((box * 8) + box_start_bit) - endbit;
+		proj_end_bit   = ((box * 8) + box_end_bit) - endbit;
+		proj_mask = GENMASK_ULL(proj_start_bit, proj_end_bit);
+		box_mask  = GENMASK_ULL(box_start_bit, box_end_bit);
+
+		/* Determine the offset of the u8 box inside the pbuf,
+		 * adjusted for quirks. The adjusted box_addr will be used for
+		 * effective addressing inside the pbuf (so it's not
+		 * logical any longer).
+		 */
+		box_addr = pbuflen - box - 1;
+		if (quirks & QUIRK_LITTLE_ENDIAN)
+			box_addr = get_le_offset(box_addr);
+		if (quirks & QUIRK_LSW32_IS_FIRST)
+			box_addr = get_reverse_lsw32_offset(box_addr,
+							    pbuflen);
+
+		if (op == UNPACK) {
+			u64 pval;
+
+			/* Read from pbuf, write to uval */
+			pval = ((u8 *)pbuf)[box_addr] & box_mask;
+			if (quirks & QUIRK_MSB_ON_THE_RIGHT)
+				adjust_for_msb_right_quirk(&pval,
+							   &box_start_bit,
+							   &box_end_bit,
+							   &box_mask);
+
+			pval >>= box_end_bit;
+			pval <<= proj_end_bit;
+			*uval &= ~proj_mask;
+			*uval |= pval;
+		} else {
+			u64 pval;
+
+			/* Write to pbuf, read from uval */
+			pval = (*uval) & proj_mask;
+			pval >>= proj_end_bit;
+			if (quirks & QUIRK_MSB_ON_THE_RIGHT)
+				adjust_for_msb_right_quirk(&pval,
+							   &box_start_bit,
+							   &box_end_bit,
+							   &box_mask);
+
+			pval <<= box_end_bit;
+			((u8 *)pbuf)[box_addr] &= ~box_mask;
+			((u8 *)pbuf)[box_addr] |= pval;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(packing);
+
-- 
2.17.1


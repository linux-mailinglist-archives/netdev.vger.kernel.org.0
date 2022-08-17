Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71DB597578
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240992AbiHQR6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240842AbiHQR6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:58:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63682255BD
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660759107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FeC1hIbpeF331EYBQF/yk4Lw5Xn8tjgBYGOWKQGB6dY=;
        b=H65DNSX434viksn7/bLCbXgNMFZ/vGwfPptAIN8pCMWB8z4fNTTs+HjkHYtLWtMUGfCjgU
        Hp1wAFFXs59WscNK00t4fvGa+OMmKQl+fKdxRrTVmMSEHWC/BOBs3gcfks2QyjovKILeuS
        J0ov/M1JPjC+FMjLAULfhR/Rro+dWH0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-378-98p6Fi6RMz2coT1h28EK3w-1; Wed, 17 Aug 2022 13:58:26 -0400
X-MC-Unique: 98p6Fi6RMz2coT1h28EK3w-1
Received: by mail-wm1-f71.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso1390738wmq.4
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=FeC1hIbpeF331EYBQF/yk4Lw5Xn8tjgBYGOWKQGB6dY=;
        b=kZWJXT6b/huJQ2pY+2Vaq8mw7hXKabpVMMWwGVEhQO8VHbB6tmeZ4iNIrwxz3eVr09
         YQs+Z3Mvst4LycBrerFEekigFZswlw7JMz5skeKgAWojeat7lg1hnul9XIyBfjZP+6zD
         TlOUqGQHoYZmnwYaSuOQUCTJbIARtA2C6PRNdRtdSMTx1xaPmdhFTjmBux8UlwOzQtM4
         k5fVbZFTS3hhFNKJBMRYwsN6MlaX/Chr3mS1E4KXr9bnPAJNCWDb/AQxej81iZEicQvG
         pMOhpvOT4jvMZZ6Fbja16dn+4dF5V56dOJR2JMhYbXbH+A57HMe8tluZe5doJ3Htlm5M
         FnFg==
X-Gm-Message-State: ACgBeo2txYh6zwngdSI2McT4PYsye5WvS6r/ru4uWHWdxnsAyjPrfPzc
        NCg49KnCOaJBh/M2lDk2NqDMEY1ANy9FQXSw0tO85mD7TZkoFhXFmz9EzXFdSyykT5pVBoAIY8i
        KfDN9XUqeOlA8yDvPBjSoTSsAZaFDf7bYJ7IUWXlRi1Ing/RTxv2V2oZtDNe5x5qROqtd
X-Received: by 2002:a05:600c:4ece:b0:3a6:28:bc59 with SMTP id g14-20020a05600c4ece00b003a60028bc59mr2841890wmq.154.1660759104429;
        Wed, 17 Aug 2022 10:58:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR510plnN0HC3OB3lvW09uzTiD8Mi1hIvWoOCu1vCuuNhK8JvlAqdM5qXlzOkhVL+R6kqbyikQ==
X-Received: by 2002:a05:600c:4ece:b0:3a6:28:bc59 with SMTP id g14-20020a05600c4ece00b003a60028bc59mr2841852wmq.154.1660759104030;
        Wed, 17 Aug 2022 10:58:24 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id u8-20020a05600c19c800b003a541d893desm2809009wmq.38.2022.08.17.10.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:58:23 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH v2 1/5] bitops: Introduce find_next_andnot_bit()
Date:   Wed, 17 Aug 2022 18:58:08 +0100
Message-Id: <20220817175812.671843-2-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220817175812.671843-1-vschneid@redhat.com>
References: <20220817175812.671843-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of introducing for_each_cpu_andnot(), add a variant of
find_next_bit() that negate the bits in @addr2 when ANDing them with the
bits in @addr1.

Note that the _find_next_bit() @invert argument now gets split into two:
@invert1 for words in @addr1, @invert2 for words in @addr2. The only
current users of _find_next_bit() with @invert set are:
  o find_next_zero_bit()
  o find_next_zero_bit_le()
and neither of these pass an @addr2, so the conversion is straightforward.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/find.h | 44 ++++++++++++++++++++++++++++++++++++++------
 lib/find_bit.c       | 23 ++++++++++++-----------
 2 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/include/linux/find.h b/include/linux/find.h
index 424ef67d4a42..920597de4e62 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -10,7 +10,8 @@
 
 extern unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert, unsigned long le);
+		unsigned long start, unsigned long invert1, unsigned long invert2,
+		unsigned long le);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
 extern unsigned long _find_first_and_bit(const unsigned long *addr1,
 					 const unsigned long *addr2, unsigned long size);
@@ -41,7 +42,7 @@ unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
 		return val ? __ffs(val) : size;
 	}
 
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 0UL, 0);
 }
 #endif
 
@@ -71,7 +72,38 @@ unsigned long find_next_and_bit(const unsigned long *addr1,
 		return val ? __ffs(val) : size;
 	}
 
-	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0UL, 0);
+}
+#endif
+
+#ifndef find_next_andnot_bit
+/**
+ * find_next_andnot_bit - find the next set bit in one memory region
+ *                        but not in the other
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @size: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_next_andnot_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long size,
+		unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr1 & ~*addr2 & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, ~0UL, 0);
 }
 #endif
 
@@ -99,7 +131,7 @@ unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 		return val == ~0UL ? size : ffz(val);
 	}
 
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0UL, 0);
 }
 #endif
 
@@ -247,7 +279,7 @@ unsigned long find_next_zero_bit_le(const void *addr, unsigned
 		return val == ~0UL ? size : ffz(val);
 	}
 
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0UL, 1);
 }
 #endif
 
@@ -266,7 +298,7 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 		return val ? __ffs(val) : size;
 	}
 
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 0UL, 1);
 }
 #endif
 
diff --git a/lib/find_bit.c b/lib/find_bit.c
index 1b8e4b2a9cba..c46b66d7d2b4 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -21,27 +21,29 @@
 
 #if !defined(find_next_bit) || !defined(find_next_zero_bit) ||			\
 	!defined(find_next_bit_le) || !defined(find_next_zero_bit_le) ||	\
-	!defined(find_next_and_bit)
+	!defined(find_next_and_bit) || !defined(find_next_andnot_bit)
 /*
  * This is a common helper function for find_next_bit, find_next_zero_bit, and
  * find_next_and_bit. The differences are:
- *  - The "invert" argument, which is XORed with each fetched word before
- *    searching it for one bits.
  *  - The optional "addr2", which is anded with "addr1" if present.
+ *  - The "invert" arguments, which are XORed with each fetched word (invert1
+ *    for words in addr1, invert2 for those in addr2) before searching it for
+ *    one bits.
  */
 unsigned long _find_next_bit(const unsigned long *addr1,
-		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert, unsigned long le)
+			     const unsigned long *addr2,
+			     unsigned long nbits, unsigned long start,
+			     unsigned long invert1, unsigned long invert2,
+			     unsigned long le)
 {
 	unsigned long tmp, mask;
 
 	if (unlikely(start >= nbits))
 		return nbits;
 
-	tmp = addr1[start / BITS_PER_LONG];
+	tmp = addr1[start / BITS_PER_LONG] ^ invert1;
 	if (addr2)
-		tmp &= addr2[start / BITS_PER_LONG];
-	tmp ^= invert;
+		tmp &= addr2[start / BITS_PER_LONG] ^ invert2;
 
 	/* Handle 1st word. */
 	mask = BITMAP_FIRST_WORD_MASK(start);
@@ -57,10 +59,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
 		if (start >= nbits)
 			return nbits;
 
-		tmp = addr1[start / BITS_PER_LONG];
+		tmp = addr1[start / BITS_PER_LONG] ^ invert1;
 		if (addr2)
-			tmp &= addr2[start / BITS_PER_LONG];
-		tmp ^= invert;
+			tmp &= addr2[start / BITS_PER_LONG] ^ invert2;
 	}
 
 	if (le)
-- 
2.31.1


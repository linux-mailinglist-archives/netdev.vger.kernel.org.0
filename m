Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F975596205
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbiHPSIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbiHPSHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:07:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18A585A8E
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660673261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HtzANJkF3fIKBG6pDjj83ztNrPxfzq+9oZeNYsNNuu8=;
        b=LcjGLAtwDvGj/4yjtCjwbgHaZWkuBr6l04sv+KFVmpVmyQzIvrnL6dZPZjobgmWoC6bNhq
        MM81D1ER//Juf6VVTkfpp9getmVzSDkXs4NDjt/W+OzglvEgTfv6l+JPhGuvgh7SSxBaX4
        jL0P30wJAh4xiGeoQL+Z7E47xQMb2Ns=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-647-E3AbcVPyOvy2IvaZE-6l0g-1; Tue, 16 Aug 2022 14:07:40 -0400
X-MC-Unique: E3AbcVPyOvy2IvaZE-6l0g-1
Received: by mail-wm1-f72.google.com with SMTP id v64-20020a1cac43000000b003a4bea31b4dso10553406wme.3
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=HtzANJkF3fIKBG6pDjj83ztNrPxfzq+9oZeNYsNNuu8=;
        b=kw5ngkEr9HLnyGfo33+j012y/hhXI3ctwxS7sQk8I66JLsZCHfdgOT8H78CfyjpNVS
         jRjaNX6K2Ecya/anNRx4z14eibKB1RDDbQtq2l5iXS1RSsIOhIdy1JBFxrBNgij4fHch
         DPDGpuXOBRBAN8RB5Vcfe6E9yoAiUpSbmVwdo2Kjs8bFkRiYxGmaJ5mMc7r3ZPyOrtzp
         8QhGmqlgJA3ygJBUAyMCkh384wVQYm7WHGf9MojqLa/ubpLY4BXKUU9CaxMsYJAPSfdt
         uocqams9mbmHlh94VpwuPaua+beDKuiTZF3mjValII6XhZf4sucX1JnLn33ZL+vssguW
         j81w==
X-Gm-Message-State: ACgBeo2HduP5d675fyNcnRCV6Y5s3dMQHe2v6RZhGENNtyLgTD2cBz2q
        2yFT3G4F5C9kHEcCGopkZTmzS328efwL83IsInj9UGvYDdt6G2pidwcLRE88IQAaUHWIrLR9z8L
        /QrsgHotKQxy+88Uc9FvGJZH7z0gZP3RGLEMux0ysTueBlfyIWKWUAIscVGi8598PForK
X-Received: by 2002:a05:600c:1c95:b0:3a5:c28a:df3e with SMTP id k21-20020a05600c1c9500b003a5c28adf3emr14330699wms.40.1660673258331;
        Tue, 16 Aug 2022 11:07:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7tWq3rhhkG9Yu7hBK0MmyUQOoH650N5a09JOyFV+MGIy/P/ZBBA1Gd0v6ZG1BSPs9ecxa4Yg==
X-Received: by 2002:a05:600c:1c95:b0:3a5:c28a:df3e with SMTP id k21-20020a05600c1c9500b003a5c28adf3emr14330656wms.40.1660673257933;
        Tue, 16 Aug 2022 11:07:37 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c4fc800b003a319bd3278sm14694961wmq.40.2022.08.16.11.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:07:37 -0700 (PDT)
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
Subject: [PATCH 1/5] bitops: Introduce find_next_andnot_bit()
Date:   Tue, 16 Aug 2022 19:07:23 +0100
Message-Id: <20220816180727.387807-2-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220816180727.387807-1-vschneid@redhat.com>
References: <20220816180727.387807-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/find.h | 44 ++++++++++++++++++++++++++++++++++++++------
 lib/find_bit.c       | 16 +++++++++++-----
 2 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/include/linux/find.h b/include/linux/find.h
index 424ef67d4a42..454cde69b30b 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -10,7 +10,8 @@
 
 extern unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert, unsigned long le);
+		unsigned long start, unsigned long invert, unsigned long le,
+		bool negate);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
 extern unsigned long _find_first_and_bit(const unsigned long *addr1,
 					 const unsigned long *addr2, unsigned long size);
@@ -41,7 +42,7 @@ unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
 		return val ? __ffs(val) : size;
 	}
 
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 0, 0);
 }
 #endif
 
@@ -71,7 +72,38 @@ unsigned long find_next_and_bit(const unsigned long *addr1,
 		return val ? __ffs(val) : size;
 	}
 
-	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0, 0);
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
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0, 1);
 }
 #endif
 
@@ -99,7 +131,7 @@ unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 		return val == ~0UL ? size : ffz(val);
 	}
 
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0, 0);
 }
 #endif
 
@@ -247,7 +279,7 @@ unsigned long find_next_zero_bit_le(const void *addr, unsigned
 		return val == ~0UL ? size : ffz(val);
 	}
 
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1, 0);
 }
 #endif
 
@@ -266,7 +298,7 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 		return val ? __ffs(val) : size;
 	}
 
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 1, 0);
 }
 #endif
 
diff --git a/lib/find_bit.c b/lib/find_bit.c
index 1b8e4b2a9cba..6e5f42c621a9 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -21,17 +21,19 @@
 
 #if !defined(find_next_bit) || !defined(find_next_zero_bit) ||			\
 	!defined(find_next_bit_le) || !defined(find_next_zero_bit_le) ||	\
-	!defined(find_next_and_bit)
+	!defined(find_next_and_bit) || !defined(find_next_andnot_bit)
 /*
  * This is a common helper function for find_next_bit, find_next_zero_bit, and
  * find_next_and_bit. The differences are:
  *  - The "invert" argument, which is XORed with each fetched word before
  *    searching it for one bits.
- *  - The optional "addr2", which is anded with "addr1" if present.
+ *  - The optional "addr2", negated if "negate" and ANDed with "addr1" if
+ *    present.
  */
 unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert, unsigned long le)
+		unsigned long start, unsigned long invert, unsigned long le,
+		bool negate)
 {
 	unsigned long tmp, mask;
 
@@ -40,7 +42,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
 
 	tmp = addr1[start / BITS_PER_LONG];
 	if (addr2)
-		tmp &= addr2[start / BITS_PER_LONG];
+		tmp &= negate ?
+		       ~addr2[start / BITS_PER_LONG] :
+			addr2[start / BITS_PER_LONG];
 	tmp ^= invert;
 
 	/* Handle 1st word. */
@@ -59,7 +63,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
 
 		tmp = addr1[start / BITS_PER_LONG];
 		if (addr2)
-			tmp &= addr2[start / BITS_PER_LONG];
+			tmp &= negate ?
+			       ~addr2[start / BITS_PER_LONG] :
+				addr2[start / BITS_PER_LONG];
 		tmp ^= invert;
 	}
 
-- 
2.31.1


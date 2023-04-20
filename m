Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D729E6E8980
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjDTFTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjDTFTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:19:54 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF901FE4;
        Wed, 19 Apr 2023 22:19:53 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b64a32fd2so835263b3a.2;
        Wed, 19 Apr 2023 22:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681967992; x=1684559992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yl+Y/+i+a8CEnavFpm7U7sXD4kX1xop+/VNm8WF14LE=;
        b=WV6LQEdx3aZMTz9ZBq6DSlLBb4pLKYIYOV11XYbeJt3xSsRVFYHtq5ggRX4L/sywoA
         pUYJG1ugEV9TTz94wRi3y0P8aj0nmIFPUD87jNz1y9EBXoN45bzM5cxq970FkqwW8qvv
         0ibrVrkHRlneL4Lzu9ICuvUCJ2giIuXU4T4B9f8uiJGy6ZBgBDB22SF4gY33M4IORIct
         UPqm/ABNlEq1v1hXP4ay3x3OVmLib2YrRZRzpWzBbs8iPN6q3SIqYNMRY5KQ6OUSUqIZ
         OwoULCaMzA9JdLmXl2xkpdZUezUSvIA1RPXxCNWSv9fKVdJPDOHCPM0aatI2A8fKZZ9m
         Mzpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681967992; x=1684559992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yl+Y/+i+a8CEnavFpm7U7sXD4kX1xop+/VNm8WF14LE=;
        b=YCi1/sWST22SiJclX/S35qmxpLCd/OQttP/A3tKAzf5fGcNQuK1EpJAjKr1WIQu33Y
         VJEDGTSMAagFeposSgeDQkm4NJWs9v1omVXJ+vKD1QMg8ZZ8aF9p5RYgBOo1n+3BDBiG
         SXAj+87xHd55OMl/RwciufCoR/0HNBloXVzzd8m0cBkcorvHtrOTZgIeO0rF4WHYSmrs
         OZ6D9lOOQEvZUAwEty+O7sy95f28kHA8nUY2LEXDNVtjq/qBBmsHQkrkUBaP+A47PK6c
         LPEHzzWu1iCY3joE6JsKz+Dlv9svFn+Ie90yxw8c2ruVkDmb8Ux+125mTz9jhk3E6zvr
         uI3w==
X-Gm-Message-State: AAQBX9eo3Cq+IehH63/rozutsLN4pVUf4CSPv4iJJj8VK/4XXopOAz6V
        ziPsn9FGvcFSFum1QoixHGY=
X-Google-Smtp-Source: AKy350bvOHRSZA/k/jeKOotwidMo14NW5H1n6tHobQF5b3jerKc62WuXaMfCCIDHR/cjcc51Bi57hA==
X-Received: by 2002:a05:6a20:3ca2:b0:d9:9d04:2c73 with SMTP id b34-20020a056a203ca200b000d99d042c73mr452095pzj.45.1681967992446;
        Wed, 19 Apr 2023 22:19:52 -0700 (PDT)
Received: from localhost ([2603:3024:e02:8500:653b:861d:e1ca:16ac])
        by smtp.gmail.com with ESMTPSA id b23-20020a62a117000000b0063b64f1d6e9sm309903pff.33.2023.04.19.22.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:19:51 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: [PATCH v2 1/8] lib/find: add find_next_and_andnot_bit()
Date:   Wed, 19 Apr 2023 22:19:39 -0700
Message-Id: <20230420051946.7463-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230420051946.7463-1-yury.norov@gmail.com>
References: <20230420051946.7463-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to find_nth_and_andnot_bit(), find_next_and_andnot_bit() is
a convenient helper that allows traversing bitmaps without storing
intermediate results in a temporary bitmap.

In the following patches the function is used to implement NUMA-aware
CPUs enumeration.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/find.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 lib/find_bit.c       | 12 ++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/find.h b/include/linux/find.h
index 5e4f39ef2e72..90b68d76c073 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -16,6 +16,9 @@ unsigned long _find_next_andnot_bit(const unsigned long *addr1, const unsigned l
 					unsigned long nbits, unsigned long start);
 unsigned long _find_next_or_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long nbits, unsigned long start);
+unsigned long _find_next_and_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
+					const unsigned long *addr3, unsigned long nbits,
+					unsigned long start);
 unsigned long _find_next_zero_bit(const unsigned long *addr, unsigned long nbits,
 					 unsigned long start);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
@@ -159,6 +162,40 @@ unsigned long find_next_or_bit(const unsigned long *addr1,
 }
 #endif
 
+#ifndef find_next_and_andnot_bit
+/**
+ * find_next_and_andnot_bit - find the next bit set in *addr1 and *addr2,
+ *			      excluding all the bits in *addr3
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @addr3: The third address to base the search on
+ * @size: The bitmap size in bits
+ * @offset: The bitnumber to start searching at
+ *
+ * Return: the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static __always_inline
+unsigned long find_next_and_andnot_bit(const unsigned long *addr1,
+				   const unsigned long *addr2,
+				   const unsigned long *addr3,
+				   unsigned long size,
+				   unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr1 & *addr2 & ~*addr3 & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_and_andnot_bit(addr1, addr2, addr3, size, offset);
+}
+#endif
+
 #ifndef find_next_zero_bit
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region
@@ -568,6 +605,12 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 	     (bit) = find_next_andnot_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
 	     (bit)++)
 
+#define for_each_and_andnot_bit(bit, addr1, addr2, addr3, size) \
+	for ((bit) = 0;									\
+	     (bit) = find_next_and_andnot_bit((addr1), (addr2), (addr3), (size), (bit)),\
+	     (bit) < (size);								\
+	     (bit)++)
+
 #define for_each_or_bit(bit, addr1, addr2, size) \
 	for ((bit) = 0;									\
 	     (bit) = find_next_or_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
diff --git a/lib/find_bit.c b/lib/find_bit.c
index 32f99e9a670e..4403e00890b1 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -182,6 +182,18 @@ unsigned long _find_next_andnot_bit(const unsigned long *addr1, const unsigned l
 EXPORT_SYMBOL(_find_next_andnot_bit);
 #endif
 
+#ifndef find_next_and_andnot_bit
+unsigned long _find_next_and_andnot_bit(const unsigned long *addr1,
+					const unsigned long *addr2,
+					const unsigned long *addr3,
+					unsigned long nbits,
+					unsigned long start)
+{
+	return FIND_NEXT_BIT(addr1[idx] & addr2[idx] & ~addr3[idx], /* nop */, nbits, start);
+}
+EXPORT_SYMBOL(_find_next_and_andnot_bit);
+#endif
+
 #ifndef find_next_or_bit
 unsigned long _find_next_or_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long nbits, unsigned long start)
-- 
2.34.1


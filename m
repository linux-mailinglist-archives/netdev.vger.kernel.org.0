Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEDB6763B1
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjAUEYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjAUEYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:24:43 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7334FCF3;
        Fri, 20 Jan 2023 20:24:42 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id z9so5823690qtv.5;
        Fri, 20 Jan 2023 20:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rRltMfhDWKXvHDAwG9bDPvvlFe2Ak9PFTADY/ayoZE=;
        b=Hqx6+XfD4UPfIWr7eVxTnX3tc+uR9jA/tGxrrhZNSmLhVj8hDNmbBW76/zMN5rnNAu
         jlVoL3E9ZCIfQMCoBEtIxzbiIRxzJ1xPeuJ/o5vX72mFdCHvVzUl6hp1tBSfPDBABDVH
         X1MDJTc8wGTV7ORNkqW2r6tBW5Y0X6DqnqRoXWWit+x0xAV9YeZhgDA3bQPjrsTjMnv5
         689J0OJSL8ORGY6UUnSETPLmokei/9guW90WlLC/puz3qiBKbE3rBPFUQQ+XEgY0lpZw
         m8SZLZ5Xg338OcayvpRdjjYHpdEiufmJvwad0Seulk6XkSKYi9gdod6KRWS14F+zYANn
         WymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5rRltMfhDWKXvHDAwG9bDPvvlFe2Ak9PFTADY/ayoZE=;
        b=G98wp82AXWtljGtd/Q0OwYkOSQTb/8U7NOLtRQ0HkIz2ld+LQK6hZOBqunUGHAahET
         fKUt6LaO/RIGHCOHhcapsWnHsGvvx6RTsK2tZ1Kem7xE9EJGcf7HYWa3opgKDpU/+9XI
         +g9RUqfSyw0syny454CE5/V/Pd45Nup9t8R0RW2hg+Y1Wm7qOdJyNNRHP01RVW/N8y4O
         2Uxt1TbRZj17cjJZj/MhSSZguRbGxTO4X5tSsTtvlJiN9u15IBVMP87pZHbnzAxsJyJR
         r0lo0uB1n5uor0VpxQM1eD1iG5p8WMImnv2k9enda4KVs839QS1qz9lXUZ338OCdrTvi
         AsiA==
X-Gm-Message-State: AFqh2kqXUjFIkbm/SG+dEWcy9JalyUj6FNRwhaF0MOdYsRmb1NMpDZx6
        PbN45AQxJSMkRl1jKJYGDJnyIQn64Y8=
X-Google-Smtp-Source: AMrXdXvqFYXTlhRZNZcft7nP+9lmhjZ9LX4OLS+feTAn4yEGdFkPlu4X6RSn89oELN9IZ61PZOJ3Rg==
X-Received: by 2002:ac8:5607:0:b0:3b6:2fcd:6d3e with SMTP id 7-20020ac85607000000b003b62fcd6d3emr31392866qtr.33.1674275080774;
        Fri, 20 Jan 2023 20:24:40 -0800 (PST)
Received: from localhost (50-242-44-45-static.hfc.comcastbusiness.net. [50.242.44.45])
        by smtp.gmail.com with ESMTPSA id z24-20020ac875d8000000b003b68c7aeebfsm3807547qtq.3.2023.01.20.20.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 20:24:40 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 1/9] lib/find: introduce find_nth_and_andnot_bit
Date:   Fri, 20 Jan 2023 20:24:28 -0800
Message-Id: <20230121042436.2661843-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121042436.2661843-1-yury.norov@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following patches the function is used to implement in-place bitmaps
traversing without storing intermediate result in temporary bitmaps.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Peter Lafreniere <peter@n8pjl.ca>
---
 include/linux/find.h | 33 +++++++++++++++++++++++++++++++++
 lib/find_bit.c       |  9 +++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/find.h b/include/linux/find.h
index ccaf61a0f5fd..4647864a5ffd 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -22,6 +22,9 @@ unsigned long __find_nth_and_bit(const unsigned long *addr1, const unsigned long
 				unsigned long size, unsigned long n);
 unsigned long __find_nth_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long size, unsigned long n);
+unsigned long __find_nth_and_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
+					const unsigned long *addr3, unsigned long size,
+					unsigned long n);
 extern unsigned long _find_first_and_bit(const unsigned long *addr1,
 					 const unsigned long *addr2, unsigned long size);
 extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
@@ -255,6 +258,36 @@ unsigned long find_nth_andnot_bit(const unsigned long *addr1, const unsigned lon
 	return __find_nth_andnot_bit(addr1, addr2, size, n);
 }
 
+/**
+ * find_nth_and_andnot_bit - find N'th set bit in 2 memory regions,
+ *			     excluding those set in 3rd region
+ * @addr1: The 1st address to start the search at
+ * @addr2: The 2nd address to start the search at
+ * @addr3: The 3rd address to start the search at
+ * @size: The maximum number of bits to search
+ * @n: The number of set bit, which position is needed, counting from 0
+ *
+ * Returns the bit number of the N'th set bit.
+ * If no such, returns @size.
+ */
+static __always_inline
+unsigned long find_nth_and_andnot_bit(const unsigned long *addr1,
+					const unsigned long *addr2,
+					const unsigned long *addr3,
+					unsigned long size, unsigned long n)
+{
+	if (n >= size)
+		return size;
+
+	if (small_const_nbits(size)) {
+		unsigned long val =  *addr1 & *addr2 & (~*addr3) & GENMASK(size - 1, 0);
+
+		return val ? fns(val, n) : size;
+	}
+
+	return __find_nth_and_andnot_bit(addr1, addr2, addr3, size, n);
+}
+
 #ifndef find_first_and_bit
 /**
  * find_first_and_bit - find the first set bit in both memory regions
diff --git a/lib/find_bit.c b/lib/find_bit.c
index 18bc0a7ac8ee..c10920e66788 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -155,6 +155,15 @@ unsigned long __find_nth_andnot_bit(const unsigned long *addr1, const unsigned l
 }
 EXPORT_SYMBOL(__find_nth_andnot_bit);
 
+unsigned long __find_nth_and_andnot_bit(const unsigned long *addr1,
+					const unsigned long *addr2,
+					const unsigned long *addr3,
+					unsigned long size, unsigned long n)
+{
+	return FIND_NTH_BIT(addr1[idx] & addr2[idx] & ~addr3[idx], size, n);
+}
+EXPORT_SYMBOL(__find_nth_and_andnot_bit);
+
 #ifndef find_next_and_bit
 unsigned long _find_next_and_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long nbits, unsigned long start)
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC87D625205
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiKKEAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiKKEAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:00:33 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA524663D0;
        Thu, 10 Nov 2022 20:00:32 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-13b103a3e5dso4339761fac.2;
        Thu, 10 Nov 2022 20:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MPqmuncXUCU3pW/zVD2ThZ+OJwOyZGXsie5WSsI5Oh8=;
        b=d7kNbAR+XN+55Y78lTPX/AcgKjBIcFtiVfpbHNR6fGXUjfu0fc6N5DgXL0DPt0FOsG
         mImOMTGRKD058s5Opn/bS8AP/Ww/c2LPjMT2PYTrDGhjnHCSAp+roN4qibzTOjOjCEFx
         zXEm7Rs8i3yogDI2kcQcd3yTmA/g+QL12Zknka3omfARYd79Es/iCaqA0kfl84XXl+/m
         3GnoRBJHtStYrnBhiN/D2SFQbxYhTNMKe/Bmnp0GHiX6G6zpmM8DHhrNg4vDGqkxfRpj
         Ld6pUw90Am+U6cuVRt4OMLMHWKe6hExyLLvuobAhWSQnOOKnFVLiMu/Zd8adV/WnXASP
         dHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MPqmuncXUCU3pW/zVD2ThZ+OJwOyZGXsie5WSsI5Oh8=;
        b=LXLjKKtYaoZ3X0vpEeYmHUPYrZihFSffQMpG40M6CioxC67Ogqm9LCpBFcA/r/gYA+
         LP3wHxEGoL+4CJ0UcHQhxzhCunGADeMNUIAGu4eTExgmW/KDc1opU/9aL4p8xTDuaCnz
         H6w5hcNhsUJKRpYvpA0moVgLgABQt6oV8FpWEU4HwzrpiG/jEEa+Q5ZnfG9GF5zjYcWg
         BEMyIxWl3FmXkQNhK5q+B00YINIsgvDGj88o6/G6+vV7lV/9U6pxxkoGMe4KhBEZAz0i
         M3KS9D5OZX1Pw7MTrw0+7z1J+GLFVf8ZbvnGKXPB5jBCU9Prveg4nCod56+qTgdp+NJs
         5vGQ==
X-Gm-Message-State: ACrzQf2GYqg8VUfTSvYQr/Dge62q/67Ld86OCr9OtB6eJVHyiqeTOIj8
        nk+VAsCuOt8mHAM01qIcaDcXUqUREac=
X-Google-Smtp-Source: AMsMyM5Xsoo+HsbznS0m+wxPjY7H0NY3MsBKTiqPr4ytUF/Dly2hgMuLkd3Ju98TPQvPZZnrk5VooA==
X-Received: by 2002:a05:6870:c98a:b0:13b:a8de:c248 with SMTP id hi10-20020a056870c98a00b0013ba8dec248mr2928387oab.99.1668139231805;
        Thu, 10 Nov 2022 20:00:31 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id c18-20020a4ac312000000b0049be423151asm435717ooq.34.2022.11.10.20.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 20:00:31 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
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
Subject: [PATCH 1/4] lib/find: introduce find_nth_and_andnot_bit
Date:   Thu, 10 Nov 2022 20:00:24 -0800
Message-Id: <20221111040027.621646-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221111040027.621646-1-yury.norov@gmail.com>
References: <20221111040027.621646-1-yury.norov@gmail.com>
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

The function is used to implement in-place bitmaps traversing without
storing intermediate result in temporary bitmaps, in the following patches.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/find.h | 33 +++++++++++++++++++++++++++++++++
 lib/find_bit.c       |  9 +++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/find.h b/include/linux/find.h
index ccaf61a0f5fd..7a97b492b447 100644
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
+static inline
+unsigned long find_nth_and_andnot_bit(const unsigned long *addr1,
+					const unsigned long *addr2,
+					const unsigned long *addr3,
+					unsigned long size, unsigned long n)
+{
+	if (n >= size)
+		return size;
+
+	if (small_const_nbits(size)) {
+		unsigned long val =  *addr1 & *addr2 & (~*addr2) & GENMASK(size - 1, 0);
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


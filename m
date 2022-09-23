Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4085E7BC7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiIWN0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiIWN0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:26:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E877145CAB
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 06:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663939554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3v7UUwoj2z6XyTFhjMkkxJBC5oQ9g5/RV9r887kLcjk=;
        b=UBwWcXrv7KJEtHgeHbNOw/F91E19mhbqQTSmfUCTaKutxtwl90snIuKCZzSg2GWr3UMDp2
        BuIi0pNScC8mlICmOZVNpGwt21Uvst7vY3gl2eoZKjz2vZNmL7rce4fN50Lyolio4nOfwn
        ytVnzJY7+IG5nioheAbpiunWmycUEqU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-115-TogplU46Pv6y1PR3u5WS7A-1; Fri, 23 Sep 2022 09:25:52 -0400
X-MC-Unique: TogplU46Pv6y1PR3u5WS7A-1
Received: by mail-wm1-f72.google.com with SMTP id p36-20020a05600c1da400b003b4faefa2b9so129493wms.6
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 06:25:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3v7UUwoj2z6XyTFhjMkkxJBC5oQ9g5/RV9r887kLcjk=;
        b=2SLwCaWXVlPwRTQOvYJZiMkd1Nxga+XOJDeRxWAR3YAE3MCr6QdSKL4sTPNCqcbzEg
         ytmhcZseFuKgD/UdRSW3NB1+LTQXnwuRgPYg5JMT/cZsWjy2rPbUQgvwJ+hnOq5FOqyK
         DNBonkQA6UWzocgI0ejENBsDpWUooTjJlWgKuXcAc38GRiMAY3ujo0ssvCAXEAphljkm
         Hy+ytIfrAMnJQ7gXYyF2tkPrvLY9xmK0NdcWNe+yWWA7814fS9+Fy+36iqeFiLUAtUPI
         KVCwX13OOEUn9QaIc/ji7TRzRvw4QOmJf7G2Enwz4v9slGC/gYB8wjxJpvZOitwgyvgh
         S/kg==
X-Gm-Message-State: ACrzQf3U7/NgaMI8Cdl6CsVnnmU6vMP4Q2gg5wYlOfn8DWufgcZQAUFe
        ky2M5HAeSEyQ8Zct9UvJGD3vF6VcQU0zj4xD0j97I2C+DlY/+ZUikjsbKnHl31njg3WQTJu29Y6
        3DsMAd75xE61Ft70Ca7Vxs5bfagy/MKX28j4Vk8yXj5btuQHXZkl4bljMSPH3doYdfw1M
X-Received: by 2002:a7b:ca46:0:b0:3b4:7ff1:4fcc with SMTP id m6-20020a7bca46000000b003b47ff14fccmr13250225wml.47.1663939551644;
        Fri, 23 Sep 2022 06:25:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7G6JjOLCwT6f+/rhD9fsfQaNjJBH3cpQyFzkJ5Y39WRlDbzFautTo6dP0A7bA2xxxc1pNi1Q==
X-Received: by 2002:a7b:ca46:0:b0:3b4:7ff1:4fcc with SMTP id m6-20020a7bca46000000b003b47ff14fccmr13250179wml.47.1663939551281;
        Fri, 23 Sep 2022 06:25:51 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id q5-20020a5d6585000000b0022add5a6fb1sm7067306wru.30.2022.09.23.06.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 06:25:50 -0700 (PDT)
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
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v4 1/7] lib/find_bit: Introduce find_next_andnot_bit()
Date:   Fri, 23 Sep 2022 14:25:21 +0100
Message-Id: <20220923132527.1001870-2-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220923132527.1001870-1-vschneid@redhat.com>
References: <20220923132527.1001870-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 include/linux/find.h | 33 +++++++++++++++++++++++++++++++++
 lib/find_bit.c       |  9 +++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/find.h b/include/linux/find.h
index dead6f53a97b..e60b1ce89b29 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -12,6 +12,8 @@ unsigned long _find_next_bit(const unsigned long *addr1, unsigned long nbits,
 				unsigned long start);
 unsigned long _find_next_and_bit(const unsigned long *addr1, const unsigned long *addr2,
 					unsigned long nbits, unsigned long start);
+unsigned long _find_next_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
+					unsigned long nbits, unsigned long start);
 unsigned long _find_next_zero_bit(const unsigned long *addr, unsigned long nbits,
 					 unsigned long start);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
@@ -86,6 +88,37 @@ unsigned long find_next_and_bit(const unsigned long *addr1,
 }
 #endif
 
+#ifndef find_next_andnot_bit
+/**
+ * find_next_andnot_bit - find the next set bit in *addr1 excluding all the bits
+ *                        in *addr2
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
+	return _find_next_andnot_bit(addr1, addr2, size, offset);
+}
+#endif
+
 #ifndef find_next_zero_bit
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region
diff --git a/lib/find_bit.c b/lib/find_bit.c
index d00ee23ab657..53b02405421b 100644
--- a/lib/find_bit.c
+++ b/lib/find_bit.c
@@ -120,6 +120,15 @@ unsigned long _find_next_and_bit(const unsigned long *addr1, const unsigned long
 EXPORT_SYMBOL(_find_next_and_bit);
 #endif
 
+#ifndef find_next_andnot_bit
+unsigned long _find_next_andnot_bit(const unsigned long *addr1, const unsigned long *addr2,
+					unsigned long nbits, unsigned long start)
+{
+	return FIND_NEXT_BIT(addr1[idx] & ~addr2[idx], /* nop */, nbits, start);
+}
+EXPORT_SYMBOL(_find_next_andnot_bit);
+#endif
+
 #ifndef find_next_zero_bit
 unsigned long _find_next_zero_bit(const unsigned long *addr, unsigned long nbits,
 					 unsigned long start)
-- 
2.31.1


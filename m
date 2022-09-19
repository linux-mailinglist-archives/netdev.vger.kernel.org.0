Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7F95BD61F
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiISVGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiISVGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:06:37 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3CD4BA49;
        Mon, 19 Sep 2022 14:06:23 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id v15so648950qvi.11;
        Mon, 19 Sep 2022 14:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=6fETi1H2mTKvLVxOg8aLwhhuuPaALbYAFKdOKdv20oU=;
        b=gGKgpl2P00UIkv2Mu0jWezXMmi4npggcQ6MSKUqMK75AfZ0tq1UsRu6wETliNBwH0w
         xM9bMrK2ozauJIHbqvUdsk4TZh3ghoyuYM8YFUIIiMHzfi6w5m2JbU5Azi3LmBvUpnfH
         ta/rDc0HFJTsTTkfQutrkvDzFJJgAbRVk6xETfNAAE5gqOfUUMWDuKE3WXUFOKbkzc/o
         ON1GD9SmW8O/g7Bee9S+97fv/BVKx+JHiKW07g3ae2ffFxqfycfq3G8TC43PGSThXOnX
         dAeN/RdOLvpqrphF0cTw6TfdbNJrSYQjNpIzX3ZLI312/5RnDCDAG59c5aNaFKq4wTNs
         0UQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=6fETi1H2mTKvLVxOg8aLwhhuuPaALbYAFKdOKdv20oU=;
        b=L+I2Rt70c6TAL2tqGliyELTkbAeJqHrBrNadr8P59UUgrOco3c0OlT9QB9Hqtt7K0m
         AL2i/ZZgxU+fSWhkmVPKRzQ0TNC57fL2quUrRRkjRQKAyZqVQVs4sDqm/fHpG9CFr6on
         RBGwfxtjBTKokDQTKaURpP/42WamcGeJBuV7jj26jqV877i9Frw2ydwC3pwLuXrR8uC2
         UvLskLAB6xPsH2KZCxgT4+JnVdjaNHGzlS+nO3rkuje5FDGvmhKKflgi10VVTYCw4LIl
         ozoyy/F3QWir2p33sYa28V3JiOk3rmGqEhHnUSS7MVIhLo5YB/agIQTwiGzAyQC+U4n5
         ctLA==
X-Gm-Message-State: ACrzQf3k945jVNH/GPomHgSPY3d/B9rspwq1JZR28MMFpmj/NIAtX+TY
        a3rM9OfJRy/CvDrp30y/4qxVKIipowk=
X-Google-Smtp-Source: AMsMyM5Byg6loTEYHrcOaeK8MSQTszoOSTk0zHhQ3hE5pvA1kWNVArOhJBplZkwrdc6t7WAVs5zzyQ==
X-Received: by 2002:a05:6214:29cc:b0:4ad:40e0:97da with SMTP id gh12-20020a05621429cc00b004ad40e097damr5814717qvb.31.1663621582725;
        Mon, 19 Sep 2022 14:06:22 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:bb7d:3b54:df44:5476])
        by smtp.gmail.com with ESMTPSA id y11-20020a37f60b000000b006a65c58db99sm13110819qkj.64.2022.09.19.14.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 14:06:22 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 5/7] lib/bitmap: introduce for_each_set_bit_wrap() macro
Date:   Mon, 19 Sep 2022 14:05:57 -0700
Message-Id: <20220919210559.1509179-6-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220919210559.1509179-1-yury.norov@gmail.com>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
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

Add for_each_set_bit_wrap() macro and use it in for_each_cpu_wrap(). The
new macro is based on __for_each_wrap() iterator, which is simpler and
smaller than cpumask_next_wrap().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/cpumask.h |  6 ++----
 include/linux/find.h    | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 3a9566f1373a..286804bfe3b7 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -286,10 +286,8 @@ unsigned int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int sta
  *
  * After the loop, cpu is >= nr_cpu_ids.
  */
-#define for_each_cpu_wrap(cpu, mask, start)					\
-	for ((cpu) = cpumask_next_wrap((start)-1, (mask), (start), false);	\
-	     (cpu) < nr_cpumask_bits;						\
-	     (cpu) = cpumask_next_wrap((cpu), (mask), (start), true))
+#define for_each_cpu_wrap(cpu, mask, start)				\
+	for_each_set_bit_wrap(cpu, cpumask_bits(mask), nr_cpumask_bits, start)
 
 /**
  * for_each_cpu_and - iterate over every cpu in both masks
diff --git a/include/linux/find.h b/include/linux/find.h
index 77c087b7a451..3b746a183216 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -336,6 +336,32 @@ unsigned long find_next_bit_wrap(const unsigned long *addr,
 	return bit < offset ? bit : size;
 }
 
+/*
+ * Helper for for_each_set_bit_wrap(). Make sure you're doing right thing
+ * before using it alone.
+ */
+static inline
+unsigned long __for_each_wrap(const unsigned long *bitmap, unsigned long size,
+				 unsigned long start, unsigned long n)
+{
+	unsigned long bit;
+
+	/* If not wrapped around */
+	if (n > start) {
+		/* and have a bit, just return it. */
+		bit = find_next_bit(bitmap, size, n);
+		if (bit < size)
+			return bit;
+
+		/* Otherwise, wrap around and ... */
+		n = 0;
+	}
+
+	/* Search the other part. */
+	bit = find_next_bit(bitmap, start, n);
+	return bit < start ? bit : size;
+}
+
 /**
  * find_next_clump8 - find next 8-bit clump with set bits in a memory region
  * @clump: location to store copy of found clump
@@ -514,6 +540,19 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 	     (b) = find_next_zero_bit((addr), (size), (e) + 1),	\
 	     (e) = find_next_bit((addr), (size), (b) + 1))
 
+/**
+ * for_each_set_bit_wrap - iterate over all set bits starting from @start, and
+ * wrapping around the end of bitmap.
+ * @bit: offset for current iteration
+ * @addr: bitmap address to base the search on
+ * @size: bitmap size in number of bits
+ * @start: Starting bit for bitmap traversing, wrapping around the bitmap end
+ */
+#define for_each_set_bit_wrap(bit, addr, size, start) \
+	for ((bit) = find_next_bit_wrap((addr), (size), (start));		\
+	     (bit) < (size);							\
+	     (bit) = __for_each_wrap((addr), (size), (start), (bit) + 1))
+
 /**
  * for_each_set_clump8 - iterate over bitmap for each 8-bit clump with set bits
  * @start: bit offset to start search and to store the current iteration offset
-- 
2.34.1


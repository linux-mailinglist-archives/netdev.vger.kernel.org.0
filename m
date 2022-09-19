Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6A45BD620
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiISVGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiISVGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:06:38 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF59F40E37;
        Mon, 19 Sep 2022 14:06:24 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id 3so371999qka.5;
        Mon, 19 Sep 2022 14:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=tptuErfv/fu7k0PaoUFPz/CmqBpDgYxeL9X9pfAsdFw=;
        b=NGW7dN6KVT198Ogv47rTbUmJqUCYJz9eDSgwC9Up8QFWg19Nw6z5IfhnAaffRzMZnk
         Q5LxHdz2xvCAabVGDchwHI9qpl1KFAyY1jdPRRxdU+p5P3K+TP/3aSERwF1BLfc63iha
         sJeiuxH2uaB0CN+7shIt03LlEiQB23h1JxX91+cXwrJtwXqJejKHiMq0pI5oMKZ++uYb
         Foky2+ySiT6UJ5XiYvSmaYMpUgZcCuhAB0uTNSuBccDxgyfOqMyVwY8WzjpeAAnSqaMN
         Cg3m+aPTOX/Y9De2CbyE3pFQpyuOZqz70JzSTzYxXIrufFU5KII5HE+d4Ju4CNHF6MGo
         HnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=tptuErfv/fu7k0PaoUFPz/CmqBpDgYxeL9X9pfAsdFw=;
        b=GuN2nfAPMvcS+bT9Blsoa2yt6ZEZAB56wiIGjyExP9J3MblbxnU3295Sw8IatySIbk
         d/T7+5ObS2LFekhN+3kFeioMSFrod0YTafKWgtm7XTE2IVSRPfTKyqZ4xnXQUdlRCWrC
         FoRP4v+UukDhx6tcqzKggfgnyq2u7QsluBWOuXGPBe/86BY/i/AatSbM+HsUBz4bAxtl
         1iHtt5cCuU77lHvWi7GovV5DwUWcBswzgcCavdzwJhSQjt+PeCyCVc+6o9ny5y+SahXk
         Z3icksC367p7ruQjbdt+meK2UsbVsFHasVOxqmZu3yXA7ujNI6/i+BaIuPknMCg6NRm3
         d+TQ==
X-Gm-Message-State: ACrzQf1ybEclaHGRnqJa/X528ZeMi4+k+kM+HLGayIOMLicwGWYpDFa+
        x8YvUzzTVe/deKoXa2tiUy/97aKA1Es=
X-Google-Smtp-Source: AMsMyM7fP8TbSx3kK4aZYzsUWeAW/6HAH29Mr7SG5Lh9R40UvTc+uQ55uk49TnFheccEvlfIHWC6hQ==
X-Received: by 2002:a05:620a:15a1:b0:6cc:f925:7c89 with SMTP id f1-20020a05620a15a100b006ccf9257c89mr14168850qkk.319.1663621583617;
        Mon, 19 Sep 2022 14:06:23 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:bb7d:3b54:df44:5476])
        by smtp.gmail.com with ESMTPSA id m10-20020a05622a118a00b0035bb0cd479csm11984773qtk.40.2022.09.19.14.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 14:06:23 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 6/7] lib/find: optimize for_each() macros
Date:   Mon, 19 Sep 2022 14:05:58 -0700
Message-Id: <20220919210559.1509179-7-yury.norov@gmail.com>
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

Moving an iterator of the macros inside conditional part of for-loop
helps to generate a better code. It had been first implemented in commit
7baac8b91f9871ba ("cpumask: make for_each_cpu_mask a bit smaller").

Now that cpumask for-loops are the aliases to bitmap loops, it's worth
to optimize them the same way.

Bloat-o-meter says:
add/remove: 8/12 grow/shrink: 147/592 up/down: 4876/-24416 (-19540)

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/find.h | 56 ++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/include/linux/find.h b/include/linux/find.h
index 3b746a183216..0cdfab9734a6 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -458,31 +458,25 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 #endif
 
 #define for_each_set_bit(bit, addr, size) \
-	for ((bit) = find_next_bit((addr), (size), 0);		\
-	     (bit) < (size);					\
-	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+	for ((bit) = 0; (bit) = find_next_bit((addr), (size), (bit)), (bit) < (size); (bit)++)
 
 #define for_each_and_bit(bit, addr1, addr2, size) \
-	for ((bit) = find_next_and_bit((addr1), (addr2), (size), 0);		\
-	     (bit) < (size);							\
-	     (bit) = find_next_and_bit((addr1), (addr2), (size), (bit) + 1))
+	for ((bit) = 0;									\
+	     (bit) = find_next_and_bit((addr1), (addr2), (size), (bit)), (bit) < (size);\
+	     (bit)++)
 
 /* same as for_each_set_bit() but use bit as value to start with */
 #define for_each_set_bit_from(bit, addr, size) \
-	for ((bit) = find_next_bit((addr), (size), (bit));	\
-	     (bit) < (size);					\
-	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+	for (; (bit) = find_next_bit((addr), (size), (bit)), (bit) < (size); (bit)++)
 
 #define for_each_clear_bit(bit, addr, size) \
-	for ((bit) = find_next_zero_bit((addr), (size), 0);	\
-	     (bit) < (size);					\
-	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
+	for ((bit) = 0;									\
+	     (bit) = find_next_zero_bit((addr), (size), (bit)), (bit) < (size);		\
+	     (bit)++)
 
 /* same as for_each_clear_bit() but use bit as value to start with */
 #define for_each_clear_bit_from(bit, addr, size) \
-	for ((bit) = find_next_zero_bit((addr), (size), (bit));	\
-	     (bit) < (size);					\
-	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
+	for (; (bit) = find_next_zero_bit((addr), (size), (bit)), (bit) < (size); (bit)++)
 
 /**
  * for_each_set_bitrange - iterate over all set bit ranges [b; e)
@@ -492,11 +486,11 @@ unsigned long find_next_bit_le(const void *addr, unsigned
  * @size: bitmap size in number of bits
  */
 #define for_each_set_bitrange(b, e, addr, size)			\
-	for ((b) = find_next_bit((addr), (size), 0),		\
-	     (e) = find_next_zero_bit((addr), (size), (b) + 1);	\
+	for ((b) = 0;						\
+	     (b) = find_next_bit((addr), (size), b),		\
+	     (e) = find_next_zero_bit((addr), (size), (b) + 1),	\
 	     (b) < (size);					\
-	     (b) = find_next_bit((addr), (size), (e) + 1),	\
-	     (e) = find_next_zero_bit((addr), (size), (b) + 1))
+	     (b) = (e) + 1)
 
 /**
  * for_each_set_bitrange_from - iterate over all set bit ranges [b; e)
@@ -506,11 +500,11 @@ unsigned long find_next_bit_le(const void *addr, unsigned
  * @size: bitmap size in number of bits
  */
 #define for_each_set_bitrange_from(b, e, addr, size)		\
-	for ((b) = find_next_bit((addr), (size), (b)),		\
-	     (e) = find_next_zero_bit((addr), (size), (b) + 1);	\
+	for (;							\
+	     (b) = find_next_bit((addr), (size), (b)),		\
+	     (e) = find_next_zero_bit((addr), (size), (b) + 1),	\
 	     (b) < (size);					\
-	     (b) = find_next_bit((addr), (size), (e) + 1),	\
-	     (e) = find_next_zero_bit((addr), (size), (b) + 1))
+	     (b) = (e) + 1)
 
 /**
  * for_each_clear_bitrange - iterate over all unset bit ranges [b; e)
@@ -520,11 +514,11 @@ unsigned long find_next_bit_le(const void *addr, unsigned
  * @size: bitmap size in number of bits
  */
 #define for_each_clear_bitrange(b, e, addr, size)		\
-	for ((b) = find_next_zero_bit((addr), (size), 0),	\
-	     (e) = find_next_bit((addr), (size), (b) + 1);	\
+	for ((b) = 0;						\
+	     (b) = find_next_zero_bit((addr), (size), (b)),	\
+	     (e) = find_next_bit((addr), (size), (b) + 1),	\
 	     (b) < (size);					\
-	     (b) = find_next_zero_bit((addr), (size), (e) + 1),	\
-	     (e) = find_next_bit((addr), (size), (b) + 1))
+	     (b) = (e) + 1)
 
 /**
  * for_each_clear_bitrange_from - iterate over all unset bit ranges [b; e)
@@ -534,11 +528,11 @@ unsigned long find_next_bit_le(const void *addr, unsigned
  * @size: bitmap size in number of bits
  */
 #define for_each_clear_bitrange_from(b, e, addr, size)		\
-	for ((b) = find_next_zero_bit((addr), (size), (b)),	\
-	     (e) = find_next_bit((addr), (size), (b) + 1);	\
+	for (;							\
+	     (b) = find_next_zero_bit((addr), (size), (b)),	\
+	     (e) = find_next_bit((addr), (size), (b) + 1),	\
 	     (b) < (size);					\
-	     (b) = find_next_zero_bit((addr), (size), (e) + 1),	\
-	     (e) = find_next_bit((addr), (size), (b) + 1))
+	     (b) = (e) + 1)
 
 /**
  * for_each_set_bit_wrap - iterate over all set bits starting from @start, and
-- 
2.34.1


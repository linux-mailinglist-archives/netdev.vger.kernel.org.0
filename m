Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D395BD619
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiISVGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiISVGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:06:21 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F08201A2;
        Mon, 19 Sep 2022 14:06:20 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id r20so427000qtn.12;
        Mon, 19 Sep 2022 14:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=7McnKBC1d6hJiefhI/Psw8V+yIknsxdCgUA4XbjJgIs=;
        b=jLuSg5hifiTnXr/Spb39JRpbJ67hqVX9IF/EdNqzZ03PUMmV7JcTOOd4A4lr1q4FI3
         btoy5I02qI30wvAvZFcVkg9HmkKcMhvYt4cMi2SlwGfZeHoxodO35gfiA5+I5M7+SJTG
         JqtkXKKTgBQJi72Y7kw1doYwG+tiifZ7tFWU4bbQNbFm5lECYSLCNNw2lEJpyUF+o6xU
         tp8f5vVbcKVdRolaaFfhIchsmncekBDQwaI+1LKGW0hYhjQtrV/IgjJSL/u8wzPJlI5b
         umUHQMPkFXPoJGA0Asy7nQP9TDZ8h03LgAd0jghqWfySmbFo4W8qPT/m6UOSPhJ6vSzn
         sEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=7McnKBC1d6hJiefhI/Psw8V+yIknsxdCgUA4XbjJgIs=;
        b=c/BJZ3zCfUicKsAOmveFzO219pLk7bp2RYBEbwKAkMvAabLWg8lK2vIzNrBElrGWgQ
         pHn8G6mcNP2i+HOCwR31PYEKziIN3wPUEgENF/zVOMcKHUIR0y6rcxC3/0ow0RjzJ+4Z
         QXr7ibNQJiSrCRFZPuiv05ZBkWJqGCQkRswmZtaPym83jhJndHOo2zsyRH1Rp89V17A5
         diPC5Sg5lz/sQB1QMRXYM5hy0aOwRzAwIKcaUAPyAO9n6yXRra0Xc5ZJRwfqDCiiGBOa
         l9yR1d0Uvr04ySYZ7n/r62fPxEfDnLezx1FxkAr/NrHXXF5K3que7xk82FpQFp0vUAb1
         ObKQ==
X-Gm-Message-State: ACrzQf14qv2oiGVVONRyVfFKXPu1OU86VtbciTnVQ1eA1qoMdfKgopRO
        K70m0Dt7RdHWELJLi3eyh1tdqxFQ3I4=
X-Google-Smtp-Source: AMsMyM5mjfV0X6uUyVRBMsUGqQ4TewVolnYOW0MIPpDc7MPXcR41fB1nxW7bOmJDP+1L60gu13toKQ==
X-Received: by 2002:ac8:5d89:0:b0:35b:b58a:2bcb with SMTP id d9-20020ac85d89000000b0035bb58a2bcbmr16965461qtx.273.1663621579696;
        Mon, 19 Sep 2022 14:06:19 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:bb7d:3b54:df44:5476])
        by smtp.gmail.com with ESMTPSA id m12-20020ac866cc000000b0035bbc29b3c9sm11131591qtp.60.2022.09.19.14.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 14:06:19 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 2/7] net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}
Date:   Mon, 19 Sep 2022 14:05:54 -0700
Message-Id: <20220919210559.1509179-3-yury.norov@gmail.com>
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

The functions require to be passed with a cpu index prior to one that is
the first to start search, so the valid input range is [-1, nr_cpu_ids-1).
However, the code checks against [-1, nr_cpu_ids).

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/netdevice.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 05d6f3facd5a..4d6d5a2dd82e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3643,9 +3643,8 @@ static inline bool netif_attr_test_online(unsigned long j,
 static inline unsigned int netif_attrmask_next(int n, const unsigned long *srcp,
 					       unsigned int nr_bits)
 {
-	/* -1 is a legal arg here. */
-	if (n != -1)
-		cpu_max_bits_warn(n, nr_bits);
+	/* n is a prior cpu */
+	cpu_max_bits_warn(n + 1, nr_bits);
 
 	if (srcp)
 		return find_next_bit(srcp, nr_bits, n + 1);
@@ -3666,9 +3665,8 @@ static inline int netif_attrmask_next_and(int n, const unsigned long *src1p,
 					  const unsigned long *src2p,
 					  unsigned int nr_bits)
 {
-	/* -1 is a legal arg here. */
-	if (n != -1)
-		cpu_max_bits_warn(n, nr_bits);
+	/* n is a prior cpu */
+	cpu_max_bits_warn(n + 1, nr_bits);
 
 	if (src1p && src2p)
 		return find_next_and_bit(src1p, src2p, nr_bits, n + 1);
-- 
2.34.1


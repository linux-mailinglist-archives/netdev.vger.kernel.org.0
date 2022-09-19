Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D295BD618
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiISVGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiISVGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:06:20 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7D1E82;
        Mon, 19 Sep 2022 14:06:19 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id i3so379484qkl.3;
        Mon, 19 Sep 2022 14:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=i+YbDv67G8LotfUM9oVF+1zCzZ8Q2PBCNdqV7Fv3SSs=;
        b=XvizBUqTaZHLGwniEtLDcQ8fTNvupZjxri9ST9XDNKoy8R9WBWbpiGtkKO14VVHWdp
         5OdQM3cDqQrqUOgmEoewC2W4Zwa3THiaYYIqDNkaqEIzPgADE7df69pD7wpiAcEB945b
         9dZMQ57yChyKm2ptCOlk6Izsi5I6JcTsCo4UPcidsn3ppFo8PP38FwnjsrjGcEUQXgcG
         VI0ccTMUF3TuhI/54zPshHNDE7hpTF4OfxMR3D1rGwQcBhZG23WjKYTohd8W3fp3EiwI
         nYBlAABn1wsLble7eFr7odR+y6r55FLhK5O4X6OGpe5LF2G3rkvggd1W778QyL7zJY+o
         YhLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=i+YbDv67G8LotfUM9oVF+1zCzZ8Q2PBCNdqV7Fv3SSs=;
        b=muGAIYzpc9LVjY1kK9BH8ZuTrDuwNdDW6byNosNmsLIEAu/lNNUXlo5oydDsEdr6l9
         driE/Ep4n4ToN5nnZjhaNfCUOwi5V6By33OpWW8oC4LG0h0RTK3G/XUcGKpdirpwrjnb
         cRpe/sglRLD+U2EI5HS3+ws53+zofOQcQSOslIG/px+ctXRouWTKWA88mN5+GBz+eBMM
         9ImQ+JA9MYsK9qsoIZ0JfXiWoy2dbKOuozMxxqum8+Gozm0o1l0+UxCEX6x+NTkCzYyd
         jx6QyFKbvt9o9peSaWumvjinhp4GjA0OT1Ytabk68ezt7Wcm1WfoCSWV3JdigdgYA7hJ
         Y6+w==
X-Gm-Message-State: ACrzQf3eMfo0aIUedkBbUyQaVQ7kgrz+zplmPyCFu5KQViVcZ0L832/o
        B8sFDyWBfd6CGkE13KhSLjEEpTLmkr8=
X-Google-Smtp-Source: AMsMyM6AnoCFRT2WphLU9NjB2k6zkhfc82gC0Z5/g51Tdjr8eqzeB0kdHzXuIIdPw/f7twURsaX7zA==
X-Received: by 2002:a05:620a:424a:b0:6be:74ee:f093 with SMTP id w10-20020a05620a424a00b006be74eef093mr14409054qko.175.1663621578697;
        Mon, 19 Sep 2022 14:06:18 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:bb7d:3b54:df44:5476])
        by smtp.gmail.com with ESMTPSA id x26-20020a05620a0b5a00b006ce3e4fb328sm13101014qkg.42.2022.09.19.14.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 14:06:18 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 1/7] cpumask: fix checking valid cpu range
Date:   Mon, 19 Sep 2022 14:05:53 -0700
Message-Id: <20220919210559.1509179-2-yury.norov@gmail.com>
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

The range of valid CPUs is [0, nr_cpu_ids). Some cpumask functions are
passed with a shifted CPU index, and for them, the valid range is
[-1, nr_cpu_ids-1). Currently for those functions, we check the index
against [-1, nr_cpu_ids), which is wrong.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/cpumask.h | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index e4f9136a4a63..a1cd4eb1a3d6 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -174,9 +174,8 @@ static inline unsigned int cpumask_last(const struct cpumask *srcp)
 static inline
 unsigned int cpumask_next(int n, const struct cpumask *srcp)
 {
-	/* -1 is a legal arg here. */
-	if (n != -1)
-		cpumask_check(n);
+	/* n is a prior cpu */
+	cpumask_check(n + 1);
 	return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
 }
 
@@ -189,9 +188,8 @@ unsigned int cpumask_next(int n, const struct cpumask *srcp)
  */
 static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
 {
-	/* -1 is a legal arg here. */
-	if (n != -1)
-		cpumask_check(n);
+	/* n is a prior cpu */
+	cpumask_check(n + 1);
 	return find_next_zero_bit(cpumask_bits(srcp), nr_cpumask_bits, n+1);
 }
 
@@ -231,9 +229,8 @@ static inline
 unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
 		     const struct cpumask *src2p)
 {
-	/* -1 is a legal arg here. */
-	if (n != -1)
-		cpumask_check(n);
+	/* n is a prior cpu */
+	cpumask_check(n + 1);
 	return find_next_and_bit(cpumask_bits(src1p), cpumask_bits(src2p),
 		nr_cpumask_bits, n + 1);
 }
@@ -267,8 +264,8 @@ static inline
 unsigned int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap)
 {
 	cpumask_check(start);
-	if (n != -1)
-		cpumask_check(n);
+	/* n is a prior cpu */
+	cpumask_check(n + 1);
 
 	/*
 	 * Return the first available CPU when wrapping, or when starting before cpu0,
-- 
2.34.1


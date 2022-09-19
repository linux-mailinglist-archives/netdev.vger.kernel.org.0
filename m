Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665185BD61C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiISVGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiISVGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:06:22 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E010F3686E;
        Mon, 19 Sep 2022 14:06:21 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id y2so459461qtv.5;
        Mon, 19 Sep 2022 14:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=TchURNr/90KWHMrLM9Hgr2knqs7JXTfW1o1T1ys+O9U=;
        b=EoFtUEjr3hBTKUAk8CZxJHE+y410UAmqEn/pc6v7uObleuiCYx9jqfP+CKCfyjEaAT
         7Kv8u4n2qV0LbUtBtL7By9ShAuLGuyaFItVnU5ZW/I2T6yV2i0VpP6mUpajWVVFMYmdN
         reo6PAZAwPOHfsGBL8WpUYlHkbDUdfbWTqTIXqgzq2fdS2nzaTzH7ssK01dgThqmSElq
         Keym8Z9QPNxbt5WJUCwFMvDQwuQ+RR34tt77yzHrK25uzcZOjjSfNpZf1Do7+Cl6TWjJ
         qgJqBUR/XtphPC2ku0/4AJPbTJ5w6oGr+prWJoJcj63RvnPKlV+ZSsL9wXSHpzrqLMKN
         bCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TchURNr/90KWHMrLM9Hgr2knqs7JXTfW1o1T1ys+O9U=;
        b=wV7EVvhlXYqGncYTB770DeuPp90Op5iB3DrswjTwiRk17aiSnCPp16a64SGgbuk16Z
         Anhen/3KwJdXHdyrG+bBsYPBUxUbQ2L2GvJUA34VkrRb+ap6NgfJx3kFaTMm8lOejqNv
         zixcqq43v+7iuktff+2jIXduQDIe+l7D+LKSscM8DP2WZRrCrlZKjcPep9ga2I6SasWM
         l0mpqUR1l7tuzIsF4xo51PkggdiB+JnmvFPdNGJeamjAx2QYz5PLFGhQdhA6B+X/S2Ms
         XVS5SWCE98oyvcIN6kEXYYGPRAY2AZT3bRYJRUEHMecSY45QcxqKxQkT/2tfgugQ+96K
         DZ9A==
X-Gm-Message-State: ACrzQf27EOmnYdDpZvnc9oJvjzohUNplQ7vsFL4bM2DyVkPGqnkldSUt
        IJ0dDq0D3P2ZXgrQJO1hlyWgSQuk8q8=
X-Google-Smtp-Source: AMsMyM75/GQLHr8r8vLXSWqytoewoOsjNQU5sC+qpOLMQY1umzoPuDyfoSRWoxdzAeRPRdJG5HzS4g==
X-Received: by 2002:ac8:5c4c:0:b0:35c:1373:5afc with SMTP id j12-20020ac85c4c000000b0035c13735afcmr17252499qtj.86.1663621580673;
        Mon, 19 Sep 2022 14:06:20 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:bb7d:3b54:df44:5476])
        by smtp.gmail.com with ESMTPSA id t13-20020a37ea0d000000b006ce60296f97sm819972qkj.68.2022.09.19.14.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 14:06:20 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 3/7] cpumask: switch for_each_cpu{,_not} to use for_each_bit()
Date:   Mon, 19 Sep 2022 14:05:55 -0700
Message-Id: <20220919210559.1509179-4-yury.norov@gmail.com>
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

The difference between for_each_cpu() and for_each_set_bit()
is that the latter uses cpumask_next() instead of find_next_bit(),
and so calls cpumask_check().

This check is useless because the iterator value is not provided by
user. It generates false-positives for the very last iteration
of for_each_cpu().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/cpumask.h | 12 +++---------
 include/linux/find.h    |  5 +++++
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index a1cd4eb1a3d6..3a9566f1373a 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -243,9 +243,7 @@ unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
  * After the loop, cpu is >= nr_cpu_ids.
  */
 #define for_each_cpu(cpu, mask)				\
-	for ((cpu) = -1;				\
-		(cpu) = cpumask_next((cpu), (mask)),	\
-		(cpu) < nr_cpu_ids;)
+	for_each_set_bit(cpu, cpumask_bits(mask), nr_cpumask_bits)
 
 /**
  * for_each_cpu_not - iterate over every cpu in a complemented mask
@@ -255,9 +253,7 @@ unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
  * After the loop, cpu is >= nr_cpu_ids.
  */
 #define for_each_cpu_not(cpu, mask)				\
-	for ((cpu) = -1;					\
-		(cpu) = cpumask_next_zero((cpu), (mask)),	\
-		(cpu) < nr_cpu_ids;)
+	for_each_clear_bit(cpu, cpumask_bits(mask), nr_cpumask_bits)
 
 #if NR_CPUS == 1
 static inline
@@ -310,9 +306,7 @@ unsigned int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int sta
  * After the loop, cpu is >= nr_cpu_ids.
  */
 #define for_each_cpu_and(cpu, mask1, mask2)				\
-	for ((cpu) = -1;						\
-		(cpu) = cpumask_next_and((cpu), (mask1), (mask2)),	\
-		(cpu) < nr_cpu_ids;)
+	for_each_and_bit(cpu, cpumask_bits(mask1), cpumask_bits(mask2), nr_cpumask_bits)
 
 /**
  * cpumask_any_but - return a "random" in a cpumask, but not this one.
diff --git a/include/linux/find.h b/include/linux/find.h
index b100944daba0..128615a3f93e 100644
--- a/include/linux/find.h
+++ b/include/linux/find.h
@@ -390,6 +390,11 @@ unsigned long find_next_bit_le(const void *addr, unsigned
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
+#define for_each_and_bit(bit, addr1, addr2, size) \
+	for ((bit) = find_next_and_bit((addr1), (addr2), (size), 0);		\
+	     (bit) < (size);							\
+	     (bit) = find_next_and_bit((addr1), (addr2), (size), (bit) + 1))
+
 /* same as for_each_set_bit() but use bit as value to start with */
 #define for_each_set_bit_from(bit, addr, size) \
 	for ((bit) = find_next_bit((addr), (size), (bit));	\
-- 
2.34.1


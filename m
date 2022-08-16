Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B09596206
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiHPSIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236909AbiHPSHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:07:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D8785FB6
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660673262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vH2jTlmzQIwOMeKUkJzPFxzEVFleWwYuNxRt4X4XvAY=;
        b=BJWn+yEEOb729kEtBDgO+Q28HcrAHAQtrbPNqoHKkaJMeVGnWEFrVG2hqGsYHCSpdbIxse
        fpk/7Ny3qd9X7eQwGlNiN1KJVQazCmCOQ05vXNOl1Z6gQtcTqOFPy2okjMpzvWHIiBzxRP
        DHhaHOLrng21fZJOdqa45Xth//XGrGQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-120-uFVk93IWMyaF4W6iosqFPg-1; Tue, 16 Aug 2022 14:07:41 -0400
X-MC-Unique: uFVk93IWMyaF4W6iosqFPg-1
Received: by mail-wm1-f70.google.com with SMTP id f7-20020a1c6a07000000b003a60ede816cso318447wmc.0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=vH2jTlmzQIwOMeKUkJzPFxzEVFleWwYuNxRt4X4XvAY=;
        b=8SHhEEQ2BqvwNROvcWIW5ryPhmzSjULhQHwSb17LXFZnZWJ6imKH6s8sC8eHN8/6U3
         +cKQowz9e/JGiHP4F5E9u72duMsa0yW1kvru8D91b5TYoSIyfDLhCwYrovw3mdpwXF+u
         yuX7wcs/hNzxVnc6LQZKEdeMqr0ljw5MIbw4kjfFrPTwPqrOakbsZ6MFazW/XjlOMVeI
         OpB574+Zwk+YDIIPvAzBEPTMaZE6TAZmo5xYaK34hmWIWYp9XTKrhBhDa+UvmNXla6PY
         FLYqLdoFiJ6KmG+vLPj6Kcvvi9oXRx7BI4a08k9TVhJW2Rnis2qQy05RKHjLVId6xkJ5
         dpFA==
X-Gm-Message-State: ACgBeo2HdGnwvCLQBboX1Lek/ug7YOa/n5ZfdQmsfgYpyccJP+VpMvRX
        hSnN5wrhC2XiN/Qfwf0UmnYrSOI0FMS67m1qf+AOIfLRt1X3RQrxhHsUV/uCaOpflYFK3FFEk0L
        1TMEBZ5o681fQVS3LexDSGyPlM48BRRbGKimQFJ9twZB1EAQpjFl1Vd0zBbN4lj0zWfni
X-Received: by 2002:a05:600c:4fcf:b0:3a5:b7f7:3127 with SMTP id o15-20020a05600c4fcf00b003a5b7f73127mr14638626wmq.160.1660673259594;
        Tue, 16 Aug 2022 11:07:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6Ozt5n5rw1n8vb1yr16M5RH2dEqwc/tjFIJhySTHC/leYqLbNjdSwNueyR8yo+3ivUTDnsZQ==
X-Received: by 2002:a05:600c:4fcf:b0:3a5:b7f7:3127 with SMTP id o15-20020a05600c4fcf00b003a5b7f73127mr14638594wmq.160.1660673259334;
        Tue, 16 Aug 2022 11:07:39 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c4fc800b003a319bd3278sm14694961wmq.40.2022.08.16.11.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:07:38 -0700 (PDT)
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
Subject: [PATCH 2/5] cpumask: Introduce for_each_cpu_andnot()
Date:   Tue, 16 Aug 2022 19:07:24 +0100
Message-Id: <20220816180727.387807-3-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220816180727.387807-1-vschneid@redhat.com>
References: <20220816180727.387807-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

for_each_cpu_and() is very convenient as it saves having to allocate a
temporary cpumask to store the result of cpumask_and(). The same issue
applies to cpumask_andnot() which doesn't actually need temporary storage
for iteration purposes.

Following what has been done for for_each_cpu_and(), introduce
for_each_cpu_andnot().

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/cpumask.h | 32 ++++++++++++++++++++++++++++++++
 lib/cpumask.c           | 19 +++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index fe29ac7cc469..a8b2ca160e57 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -157,6 +157,13 @@ static inline unsigned int cpumask_next_and(int n,
 	return n+1;
 }
 
+static inline unsigned int cpumask_next_andnot(int n,
+					    const struct cpumask *srcp,
+					    const struct cpumask *andp)
+{
+	return n+1;
+}
+
 static inline unsigned int cpumask_next_wrap(int n, const struct cpumask *mask,
 					     int start, bool wrap)
 {
@@ -194,6 +201,8 @@ static inline int cpumask_any_distribute(const struct cpumask *srcp)
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)(start))
 #define for_each_cpu_and(cpu, mask1, mask2)	\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask1, (void)mask2)
+#define for_each_cpu_andnot(cpu, mask1, mask2)	\
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask1, (void)mask2)
 #else
 /**
  * cpumask_first - get the first cpu in a cpumask
@@ -259,6 +268,9 @@ static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
 }
 
 int __pure cpumask_next_and(int n, const struct cpumask *, const struct cpumask *);
+int __pure cpumask_next_andnot(int n,
+			       const struct cpumask *src1p,
+			       const struct cpumask *src2p);
 int __pure cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
 unsigned int cpumask_local_spread(unsigned int i, int node);
 int cpumask_any_and_distribute(const struct cpumask *src1p,
@@ -324,6 +336,26 @@ extern int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool
 	for ((cpu) = -1;						\
 		(cpu) = cpumask_next_and((cpu), (mask1), (mask2)),	\
 		(cpu) < nr_cpu_ids;)
+
+/**
+ * for_each_cpu_andnot - iterate over every cpu in one mask but not in another
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask1: the first cpumask pointer
+ * @mask2: the second cpumask pointer
+ *
+ * This saves a temporary CPU mask in many places.  It is equivalent to:
+ *	struct cpumask tmp;
+ *	cpumask_andnot(&tmp, &mask1, &mask2);
+ *	for_each_cpu(cpu, &tmp)
+ *		...
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
+#define for_each_cpu_andnot(cpu, mask1, mask2)				\
+	for ((cpu) = -1;						\
+		(cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)),	\
+		(cpu) < nr_cpu_ids;)
+
 #endif /* SMP */
 
 #define CPU_BITS_NONE						\
diff --git a/lib/cpumask.c b/lib/cpumask.c
index a971a82d2f43..6896ff4a08fd 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -42,6 +42,25 @@ int cpumask_next_and(int n, const struct cpumask *src1p,
 }
 EXPORT_SYMBOL(cpumask_next_and);
 
+/**
+ * cpumask_next_andnot - get the next cpu in *src1p & ~*src2p
+ * @n: the cpu prior to the place to search (ie. return will be > @n)
+ * @src1p: the first cpumask pointer
+ * @src2p: the second cpumask pointer
+ *
+ * Returns >= nr_cpu_ids if no further cpus set in *src1p & ~*src2p.
+ */
+int cpumask_next_andnot(int n, const struct cpumask *src1p,
+		     const struct cpumask *src2p)
+{
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
+	return find_next_andnot_bit(cpumask_bits(src1p), cpumask_bits(src2p),
+		nr_cpumask_bits, n + 1);
+}
+EXPORT_SYMBOL(cpumask_next_andnot);
+
 /**
  * cpumask_any_but - return a "random" in a cpumask, but not this one.
  * @mask: the cpumask to search
-- 
2.31.1


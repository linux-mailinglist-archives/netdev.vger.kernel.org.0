Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E1E6F29FB
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjD3RTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjD3RS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:18:57 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D653C26;
        Sun, 30 Apr 2023 10:18:26 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64115eef620so22640619b3a.1;
        Sun, 30 Apr 2023 10:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682875106; x=1685467106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NVQPAhvM42bg60bi1IlAwEIZcPjoQKQJa+YHtFWyV1o=;
        b=hN4PCyTCEMv72Ox/Rxcp0pvZ5h/Tsa+vo0js4h1J1bdZpTdHeI49d5ObSi2mWgSwK6
         u3mn0/RG3qZ0/djtCcCLgknmYmZHABoW6ZBcIllvjQpO+k//zIaEqOu1NPEasFR7+11v
         5hjZWEMFvDKxn9JM02pSjmM/ATVdN2263VdfoHAKgvqUTY32t4ZeK5zTRG0YDAlSnUdm
         fmVqJH0uXGRNaSJqzoraoyTjw6garidcNU7G4HeRPxyvy8D8cgy4YzzcPwSsoewfbedl
         tS7nWzlVwtH0umHPUKihIuxVteC2txu1DpbZj62NGGT+sdFxWL5DmIR0KvUQIU+k+YJN
         Q1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682875106; x=1685467106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NVQPAhvM42bg60bi1IlAwEIZcPjoQKQJa+YHtFWyV1o=;
        b=YYVxCCeM2ikpPCo/mR8Z1TtjQRh5mNbIsBDze5kGJWuT6zZ3cQTZ8IH4kvFzy6ZxuL
         fBVvpVOGNTA8mRYS+cIFuUa5EhG4u/jaxNZI2e9tf+OYGIZCvwkU65zBMPD17nQwx1H/
         E1F4aB0U+38xjnsmK1527u8ibyfcSr21dlFpECo686T8b/9GgSbaDNiK2xbaiKc9nvbQ
         rqBE7OO7Le/8986y3l2CmJYQPA6fWq0qfqSjSaXyI9anRZiBIiGC1iY19GHw+4YNSq0R
         /bEl6aDZbHaqPUDxuLRfoh6Y2qiIhCijJQHknv9HRV3WFDGwpC9CVt5MgFq9L2bvTJXS
         ijGw==
X-Gm-Message-State: AC+VfDyD0QJV1RrgSriuBa0K2HkWLU5jZIDRggjfGwKeqg/bkoAXRB4A
        4iYz/z0gARIMGZh5FdgjLKg=
X-Google-Smtp-Source: ACHHUZ7tvH8wofODdNT6Wh2V6qp8Vo+6xmyzjcG+xEBwWJ128LaOLk8IJN/IWA1WnaEA3PA9UH4drQ==
X-Received: by 2002:a17:902:c94f:b0:19a:727e:d4f3 with SMTP id i15-20020a170902c94f00b0019a727ed4f3mr19207851pla.5.1682875105507;
        Sun, 30 Apr 2023 10:18:25 -0700 (PDT)
Received: from localhost ([4.1.102.3])
        by smtp.gmail.com with ESMTPSA id x12-20020a1709027c0c00b001a52e3e3745sm16385404pll.296.2023.04.30.10.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 10:18:25 -0700 (PDT)
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
Subject: [PATCH v3 8/8] lib: test for_each_numa_cpus()
Date:   Sun, 30 Apr 2023 10:18:09 -0700
Message-Id: <20230430171809.124686-9-yury.norov@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230430171809.124686-1-yury.norov@gmail.com>
References: <20230430171809.124686-1-yury.norov@gmail.com>
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

Test for_each_numa_cpus() output to ensure that:
 - all CPUs are picked from NUMA nodes with non-decreasing distances to the
   original node; 
 - only online CPUs are enumerated;
 - the macro enumerates each online CPUs only once;
 - enumeration order is consistent with cpumask_local_spread().

The latter is an implementation-defined behavior. If cpumask_local_spread()
or for_each_numa_cpu() will get changed in future, the subtest may need
to be adjusted or even removed, as appropriate.

It's useful now because some architectures don't implement numa_distance(),
and generic implementation only distinguishes local and remote nodes, which
doesn't allow to test the for_each_numa_cpu() properly.

Suggested-by: Valentin Schneider <vschneid@redhat.com> (for node_distance() test)
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/test_bitmap.c | 70 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index a8005ad3bd58..ac4fe621d37b 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -12,6 +12,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/topology.h>
 #include <linux/uaccess.h>
 
 #include "../tools/testing/selftests/kselftest_module.h"
@@ -71,6 +72,16 @@ __check_eq_uint(const char *srcfile, unsigned int line,
 	return true;
 }
 
+static bool __init
+__check_ge_uint(const char *srcfile, unsigned int line,
+		const unsigned int exp_uint, unsigned int x)
+{
+	if (exp_uint >=  x)
+		return true;
+
+	pr_err("[%s:%u] expected >= %u, got %u\n", srcfile, line, exp_uint, x);
+	return false;
+}
 
 static bool __init
 __check_eq_bitmap(const char *srcfile, unsigned int line,
@@ -86,6 +97,18 @@ __check_eq_bitmap(const char *srcfile, unsigned int line,
 	return true;
 }
 
+static bool __init
+__check_eq_cpumask(const char *srcfile, unsigned int line,
+		  const struct cpumask *exp_cpumask, const struct cpumask *cpumask)
+{
+	if (cpumask_equal(exp_cpumask, cpumask))
+		return true;
+
+	pr_warn("[%s:%u] cpumasks contents differ: expected \"%*pbl\", got \"%*pbl\"\n",
+		srcfile, line, cpumask_pr_args(exp_cpumask), cpumask_pr_args(cpumask));
+	return false;
+}
+
 static bool __init
 __check_eq_pbl(const char *srcfile, unsigned int line,
 	       const char *expected_pbl,
@@ -173,11 +196,11 @@ __check_eq_str(const char *srcfile, unsigned int line,
 	return eq;
 }
 
-#define __expect_eq(suffix, ...)					\
+#define __expect(suffix, ...)						\
 	({								\
 		int result = 0;						\
 		total_tests++;						\
-		if (!__check_eq_ ## suffix(__FILE__, __LINE__,		\
+		if (!__check_ ## suffix(__FILE__, __LINE__,		\
 					   ##__VA_ARGS__)) {		\
 			failed_tests++;					\
 			result = 1;					\
@@ -185,13 +208,19 @@ __check_eq_str(const char *srcfile, unsigned int line,
 		result;							\
 	})
 
+#define __expect_eq(suffix, ...)	__expect(eq_ ## suffix, ##__VA_ARGS__)
+#define __expect_ge(suffix, ...)	__expect(ge_ ## suffix, ##__VA_ARGS__)
+
 #define expect_eq_uint(...)		__expect_eq(uint, ##__VA_ARGS__)
 #define expect_eq_bitmap(...)		__expect_eq(bitmap, ##__VA_ARGS__)
+#define expect_eq_cpumask(...)		__expect_eq(cpumask, ##__VA_ARGS__)
 #define expect_eq_pbl(...)		__expect_eq(pbl, ##__VA_ARGS__)
 #define expect_eq_u32_array(...)	__expect_eq(u32_array, ##__VA_ARGS__)
 #define expect_eq_clump8(...)		__expect_eq(clump8, ##__VA_ARGS__)
 #define expect_eq_str(...)		__expect_eq(str, ##__VA_ARGS__)
 
+#define expect_ge_uint(...)		__expect_ge(uint, ##__VA_ARGS__)
+
 static void __init test_zero_clear(void)
 {
 	DECLARE_BITMAP(bmap, 1024);
@@ -751,6 +780,42 @@ static void __init test_for_each_set_bit_wrap(void)
 	}
 }
 
+static void __init test_for_each_numa_cpu(void)
+{
+	unsigned int node, cpu, hop;
+	cpumask_var_t mask;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
+		pr_err("Can't allocate cpumask. Skipping for_each_numa_cpu() test");
+		return;
+	}
+
+	for_each_node(node) {
+		unsigned int c = 0, dist, old_dist = node_distance(node, node);
+
+		cpumask_clear(mask);
+
+		rcu_read_lock();
+		for_each_numa_cpu(cpu, hop, node, cpu_possible_mask) {
+			dist = node_distance(cpu_to_node(cpu), node);
+
+			/* Distance between nodes must never decrease */
+			expect_ge_uint(dist, old_dist);
+
+			/* Test for coherence with cpumask_local_spread() */
+			expect_eq_uint(cpumask_local_spread(c++, node), cpu);
+
+			cpumask_set_cpu(cpu, mask);
+			old_dist = dist;
+		}
+		rcu_read_unlock();
+
+		/* Each online CPU must be visited exactly once */
+		expect_eq_uint(c, num_online_cpus());
+		expect_eq_cpumask(mask, cpu_online_mask);
+	}
+}
+
 static void __init test_for_each_set_bit(void)
 {
 	DECLARE_BITMAP(orig, 500);
@@ -1237,6 +1302,7 @@ static void __init selftest(void)
 	test_for_each_clear_bitrange_from();
 	test_for_each_set_clump8();
 	test_for_each_set_bit_wrap();
+	test_for_each_numa_cpu();
 }
 
 KSTM_MODULE_LOADERS(test_bitmap);
-- 
2.37.2


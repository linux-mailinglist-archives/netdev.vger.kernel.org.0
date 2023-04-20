Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20C16E8995
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjDTFVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbjDTFUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:20:45 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4866A42;
        Wed, 19 Apr 2023 22:20:06 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b4960b015so526582b3a.3;
        Wed, 19 Apr 2023 22:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681968006; x=1684560006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEuVUyGkVR+9mS2OVPBgufzRK60Hjm+2X8xg7kaymT4=;
        b=QgcBC7QBOtNAraj6WWbRO+jlrX7uBp0bSSzwpYk1+EgdIenhJmGsDJSNCASqcre0q1
         mcPsRHaKW8qS6pQQwQw85VL0X1YQvGlYrLrfnLdAIK8+eKiHtlYV5dctnW/23DNtY/Dj
         DKkBkIan3xYzRelahUP+Eq1NnM1rosgcTqYzHZYW65TokHUShgLIaJz0iiIOWzDhJ2dN
         dICuAVKsm4jiX/b+rHrz/ewanfQhkMEzUtcmvhhPi8v0jLySFRwTvxqeBhZkdXlaXm39
         qHPOM6SBR9bC8AvG6wpm5jfl9xlVBlOV65ySAOvD+8pYTCthSBO8ugX8z4qeRKe3kMKN
         hSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681968006; x=1684560006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mEuVUyGkVR+9mS2OVPBgufzRK60Hjm+2X8xg7kaymT4=;
        b=Bh9NTq7s1xZfplIecYJBjPnPlAFnJ/KFQWpS2dZk3XV9aoKAZsVgdJ6ZTOoLp9Ud+G
         di0wyrY549v9L0fmj8BxJtjnuVizjBfmaselPgJA4T8nQiGqGLXS8fhCtKWtsJFmJDxs
         aTC7lMagNlittPL2B1dD3Dc7Jsl+MAcwclIO6FV5IiwgUSH6BKdT4bGRnme/aF4KjpCN
         cYrZ0KGMwcmhMh+Y/rPlhcSpgZ2NrsREoSpax6O2URqRpDHTkE1vl0RFXRxkFzo4Hp8u
         xnx8Yrdmq81MKP1nzEXLf30pg5syNMZxjFjjw8EpnAFI8k2u1EDOdj+C2X7OHlrbCU1I
         c/5Q==
X-Gm-Message-State: AAQBX9dcU+Y3zhOFJ9BOqLg8Z7hRnUxHgTG1b+CzYeinYz5NRBzx3esC
        ONKBGGo8RjjmE5pcurQ7vEY=
X-Google-Smtp-Source: AKy350bqU/yDYCrTiDgTOfdjRvtMMucqL2wiXqRDjP9IOAhI2Hi4gf4e1Khh7jHrIRVWJuC8Oxyaug==
X-Received: by 2002:a05:6a20:548c:b0:ef:88c8:90ec with SMTP id i12-20020a056a20548c00b000ef88c890ecmr794792pzk.10.1681968005771;
        Wed, 19 Apr 2023 22:20:05 -0700 (PDT)
Received: from localhost ([2603:3024:e02:8500:653b:861d:e1ca:16ac])
        by smtp.gmail.com with ESMTPSA id p11-20020a654bcb000000b0050376cedb3asm295957pgr.24.2023.04.19.22.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:20:05 -0700 (PDT)
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
Subject: [PATCH v2 8/8] sched: drop for_each_numa_hop_mask()
Date:   Wed, 19 Apr 2023 22:19:46 -0700
Message-Id: <20230420051946.7463-9-yury.norov@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230420051946.7463-1-yury.norov@gmail.com>
References: <20230420051946.7463-1-yury.norov@gmail.com>
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

Now that we have for_each_numa_cpu(), for_each_numa_hop_mask()
and all related code is a dead code. Drop it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h | 25 -------------------------
 kernel/sched/topology.c  | 32 --------------------------------
 lib/test_bitmap.c        | 13 -------------
 3 files changed, 70 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7ebcc886dc76..1225ade33053 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -255,7 +255,6 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 #ifdef CONFIG_NUMA
 int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
 int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop);
-extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops);
 #else
 static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 {
@@ -267,32 +266,8 @@ int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsi
 {
 	return find_next_bit(cpumask_bits(cpus), small_cpumask_bits, cpu);
 }
-
-static inline const struct cpumask *
-sched_numa_hop_mask(unsigned int node, unsigned int hops)
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
 #endif	/* CONFIG_NUMA */
 
-/**
- * for_each_numa_hop_mask - iterate over cpumasks of increasing NUMA distance
- *                          from a given node.
- * @mask: the iteration variable.
- * @node: the NUMA node to start the search from.
- *
- * Requires rcu_lock to be held.
- *
- * Yields cpu_online_mask for @node == NUMA_NO_NODE.
- */
-#define for_each_numa_hop_mask(mask, node)				       \
-	for (unsigned int __hops = 0;					       \
-	     mask = (node != NUMA_NO_NODE || __hops) ?			       \
-		     sched_numa_hop_mask(node, __hops) :		       \
-		     cpu_online_mask,					       \
-	     !IS_ERR_OR_NULL(mask);					       \
-	     __hops++)
-
 /**
  * for_each_numa_cpu - iterate over cpus in increasing order taking into account
  *		       NUMA distances from a given node.
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 56daa279c411..9d08ffdbd2d8 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2171,38 +2171,6 @@ int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsi
 }
 EXPORT_SYMBOL_GPL(sched_numa_find_next_cpu);
 
-/**
- * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away from
- *                         @node
- * @node: The node to count hops from.
- * @hops: Include CPUs up to that many hops away. 0 means local node.
- *
- * Return: On success, a pointer to a cpumask of CPUs at most @hops away from
- * @node, an error value otherwise.
- *
- * Requires rcu_lock to be held. Returned cpumask is only valid within that
- * read-side section, copy it if required beyond that.
- *
- * Note that not all hops are equal in distance; see sched_init_numa() for how
- * distances and masks are handled.
- * Also note that this is a reflection of sched_domains_numa_masks, which may change
- * during the lifetime of the system (offline nodes are taken out of the masks).
- */
-const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops)
-{
-	struct cpumask ***masks;
-
-	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
-		return ERR_PTR(-EINVAL);
-
-	masks = rcu_dereference(sched_domains_numa_masks);
-	if (!masks)
-		return ERR_PTR(-EBUSY);
-
-	return masks[hops][node];
-}
-EXPORT_SYMBOL_GPL(sched_numa_hop_mask);
-
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 1b5f805f6879..6becb044a66f 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -756,19 +756,6 @@ static void __init test_for_each_numa(void)
 {
 	unsigned int cpu, node;
 
-	for (node = 0; node < sched_domains_numa_levels; node++) {
-		const struct cpumask *m, *p = cpu_none_mask;
-		unsigned int c = 0;
-
-		rcu_read_lock();
-		for_each_numa_hop_mask(m, node) {
-			for_each_cpu_andnot(cpu, m, p)
-				expect_eq_uint(cpumask_local_spread(c++, node), cpu);
-			p = m;
-		}
-		rcu_read_unlock();
-	}
-
 	for (node = 0; node < sched_domains_numa_levels; node++) {
 		unsigned int hop, c = 0;
 
-- 
2.34.1


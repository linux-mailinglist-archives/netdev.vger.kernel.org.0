Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051886E8982
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjDTFT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjDTFT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:19:56 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED72B1FE4;
        Wed, 19 Apr 2023 22:19:54 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b509fe13eso516255b3a.1;
        Wed, 19 Apr 2023 22:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681967994; x=1684559994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V+FrYzkNBTAOE1d+tJlAIPGbtNhc7MIPbyq0PvaiMlQ=;
        b=LC/ptG50ZvrrRq38X7yUGXTnM/QM/L7x6DX5gIVV7eLu7QKqzFVwj7oNJznvJB0Y6O
         7dUjUkcE1VndvXAsae/q2mzR5JMyCGcxwXa72MNqzR+ndy1lktemW52ZiDVRLV47s7TL
         oczV0jo2FEAWc/efyumlapT2XAYAGOgaHzA0HD/BbTpUfDPLp4b9I7umP03WVfOJFIGF
         ZRpmquXPBnnYglWlr/qTX2iMCO3UcpiKGsGsIXfFAdZoadcL0Fuif03q/YGzbShdKcYj
         ItVhV43Nl14VsutaKqZBIjBj9ZjrLafHNDN+W9fvXLwfdwrOqJD2Gl6djAZJ5WYOnG5t
         Sx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681967994; x=1684559994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V+FrYzkNBTAOE1d+tJlAIPGbtNhc7MIPbyq0PvaiMlQ=;
        b=eML4VnmKLYiBC4CeyUo5/gtgiG/C0g+iMoj7PtDAHKxKsRT+qOogS9SP1Xor3MBKfh
         r7bL4IzruSNMbuToYhwJCjWY8SUdEgMeHC9X7jS6mZ1JVWO7Hmeq40rTkcg+tZcFczBc
         H34wnPqRRUUCa5YtfELSZvk1zUI/y48jy1VVtR/alQQZ6mMVbfaF/GJq17lOxBbq6yYW
         cer8CfZcu5B7CL67x6wQ8GazvUez5C3kidIxQXvyfvMLQ2EEOTmoaru4qrhGzXhSfLlf
         IYaG0RnUlvz6j5Zh0roj2xoy4VYnXe0HjZkdnLyz6flPswK3Ov1QBzBP6H76ZiAvJnCj
         X7vA==
X-Gm-Message-State: AAQBX9dSb9sSh0SY6CzOx2YY0kuzcIj1WSJK3p6mhRVpEbvEPUH6Dl3L
        eRLu4Kx3J9jj2NuiwqDtZSk=
X-Google-Smtp-Source: AKy350YjV40kKxn5fuLvZMqaKD7FR8P7oN8GuPUJhPDWMHW7VEbwFb4wyk94IBjLhUV7BvbCauWgiA==
X-Received: by 2002:a05:6a20:1583:b0:ee:524e:8426 with SMTP id h3-20020a056a20158300b000ee524e8426mr604979pzj.31.1681967994330;
        Wed, 19 Apr 2023 22:19:54 -0700 (PDT)
Received: from localhost ([2603:3024:e02:8500:653b:861d:e1ca:16ac])
        by smtp.gmail.com with ESMTPSA id f23-20020a656297000000b00514256c05c2sm303981pgv.7.2023.04.19.22.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:19:53 -0700 (PDT)
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
Subject: [PATCH v2 2/8] sched/topology: introduce sched_numa_find_next_cpu()
Date:   Wed, 19 Apr 2023 22:19:40 -0700
Message-Id: <20230420051946.7463-3-yury.norov@gmail.com>
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

The function searches for the next CPU in a given cpumask according to
NUMA topology, so that it traverses cpus per-hop.

If the CPU is the last cpu in a given hop, sched_numa_find_next_cpu()
switches to the next hop, and picks the first CPU from there, excluding
those already traversed.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h |  7 +++++++
 kernel/sched/topology.c  | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index fea32377f7c7..13209095d6e2 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -247,6 +247,7 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 
 #ifdef CONFIG_NUMA
 int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
+int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop);
 extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops);
 #else
 static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
@@ -254,6 +255,12 @@ static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, i
 	return cpumask_nth(cpu, cpus);
 }
 
+static __always_inline
+int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop)
+{
+	return find_next_bit(cpumask_bits(cpus), small_cpumask_bits, cpu);
+}
+
 static inline const struct cpumask *
 sched_numa_hop_mask(unsigned int node, unsigned int hops)
 {
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 051aaf65c749..fc163e4181e6 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2130,6 +2130,45 @@ int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 }
 EXPORT_SYMBOL_GPL(sched_numa_find_nth_cpu);
 
+/*
+ * sched_numa_find_next_cpu() - given the NUMA topology, find the next cpu
+ * cpumask: cpumask to find a cpu from
+ * cpu: current cpu
+ * node: local node
+ * hop: (in/out) indicates distance order of current CPU to a local node
+ *
+ * The function searches for next cpu at a given NUMA distance, indicated
+ * by hop, and if nothing found, tries to find CPUs at a greater distance,
+ * starting from the beginning.
+ *
+ * Return: cpu, or >= nr_cpu_ids when nothing found.
+ */
+int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop)
+{
+	unsigned long *cur, *prev;
+	struct cpumask ***masks;
+	unsigned int ret;
+
+	if (*hop >= sched_domains_numa_levels)
+		return nr_cpu_ids;
+
+	masks = rcu_dereference(sched_domains_numa_masks);
+	cur = cpumask_bits(masks[*hop][node]);
+	if (*hop == 0)
+		ret = find_next_and_bit(cpumask_bits(cpus), cur, nr_cpu_ids, cpu);
+	else {
+		prev = cpumask_bits(masks[*hop - 1][node]);
+		ret = find_next_and_andnot_bit(cpumask_bits(cpus), cur, prev, nr_cpu_ids, cpu);
+	}
+
+	if (ret < nr_cpu_ids)
+		return ret;
+
+	*hop += 1;
+	return sched_numa_find_next_cpu(cpus, 0, node, hop);
+}
+EXPORT_SYMBOL_GPL(sched_numa_find_next_cpu);
+
 /**
  * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away from
  *                         @node
-- 
2.34.1


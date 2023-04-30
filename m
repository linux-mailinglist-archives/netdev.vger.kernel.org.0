Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4E86F29E8
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbjD3RS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjD3RSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:18:18 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDB62D73;
        Sun, 30 Apr 2023 10:18:17 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63f273b219eso1216775b3a.1;
        Sun, 30 Apr 2023 10:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682875096; x=1685467096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oognvtBHKp+y57Kqu34zBdtUcBbI+DybK/7lI+VyXho=;
        b=VQYUcls8wAkuyKL2R95TT5lGXrflkHTfc53souXigvwJNGmbWpsrcAz4pi4GSaPuur
         wdDtcgnTPGvqPx+6s7uTkh6gRuYtMZ/EI127bESMIKNKI7i24bA1tyQ1RMe8HDJBgPL1
         rCYcAld1i3y6/HG/J3CjVlHxUONZEjcVrJXPsdthyCF02WvUUT4v/Szv/2mluK6Tm3jc
         dLpTt1jEfV772jz+nT1OwNisbCpmt7iWP+JnlIRmceZzfsgPssiW3my3Obt62bRFA0v4
         ZU/z79gda1Kxoijl/KMMb4Z8pnLhA1RPo096Kv3M1P/SVBo9R09suN0KfHmz0HIqZPNJ
         sgUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682875096; x=1685467096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oognvtBHKp+y57Kqu34zBdtUcBbI+DybK/7lI+VyXho=;
        b=RAsqQdCeBAnxOy/5gJr/LVqwDJCrMNZauVIBwtCMOSCZJWGgOVo0Ruj5oj9llgQNye
         kizsL6ZJGwsckODqMdXbAepL8bG5KqPrMkpvIOGVPdF1dVjLwHYAC035+tFoKxMsAO1r
         aLWCfP/c967OW5opZvgtDqFApXdLk7RuOiqll2aV4JmecTPUU5UBpEPcfpTZ8HfxkaZ+
         BuORfNZznRZMxJtY/qsObPswisH+l3SQTHR05n7RoyQOzKHvQJ6uXGCjZ8QPNx/oxmG8
         HseK1HvW7Rcmi12Qy3KWztqF6kiPnJsT7YMPXuIA3SNjz02+f4E1NOeQRnr4VizZ5G84
         O+tQ==
X-Gm-Message-State: AC+VfDzj15/W3xwoArRE6nc7LtyJZqTWf3diif+5TcZXmgTbDGmi8bYN
        xL5NwMnlmk5pE25bOUQ5U7E=
X-Google-Smtp-Source: ACHHUZ4yWaUtorBzTjTAJPBkMNnKufxSWS9Ry2Aww36MifdQmhUAlVu346qAq9Yywz9ECvQE6G4HJg==
X-Received: by 2002:a05:6a00:c88:b0:63b:1e3b:aa02 with SMTP id a8-20020a056a000c8800b0063b1e3baa02mr16689872pfv.16.1682875096461;
        Sun, 30 Apr 2023 10:18:16 -0700 (PDT)
Received: from localhost ([4.1.102.3])
        by smtp.gmail.com with ESMTPSA id f14-20020a056a00238e00b00640e64aa9b7sm11086045pfc.10.2023.04.30.10.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 10:18:16 -0700 (PDT)
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
Subject: [PATCH v3 3/8] sched/topology: introduce sched_numa_find_next_cpu()
Date:   Sun, 30 Apr 2023 10:18:04 -0700
Message-Id: <20230430171809.124686-4-yury.norov@gmail.com>
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

The function searches for a next CPU in a given cpumask according to
NUMA topology, so that it traverses CPUs per-hop.

If the CPU is the last CPU in a given hop, sched_numa_find_next_cpu()
switches to the next hop, and picks the first CPU from there, excluding
those already traversed.

Because only online CPUs are presented in the NUMA topology masks, offline
CPUs will be skipped even if presented in the 'cpus' mask provided in the
arguments.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h | 12 ++++++++++++
 kernel/sched/topology.c  | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 52f5850730b3..da92fea38585 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,8 +245,13 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
+/*
+ * sched_numa_find_*_cpu() functions family traverses only accessible CPUs,
+ * i.e. those listed in cpu_online_mask.
+ */
 #ifdef CONFIG_NUMA
 int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
+int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop);
 extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops);
 #else
 static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
@@ -254,6 +259,13 @@ static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, i
 	return cpumask_nth_and(cpu, cpus, cpu_online_mask);
 }
 
+static __always_inline
+int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop)
+{
+	return find_next_and_bit(cpumask_bits(cpus), cpumask_bits(cpu_online_mask),
+						small_cpumask_bits, cpu);
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
+ * cpumask: cpumask to find a CPU from
+ * cpu: current CPU
+ * node: local node
+ * hop: (in/out) indicates distance order of current CPU to a local node
+ *
+ * The function searches for a next CPU at a given NUMA distance, indicated
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
2.37.2


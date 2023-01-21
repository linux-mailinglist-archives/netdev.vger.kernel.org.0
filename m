Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6410C6763CD
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjAUEZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjAUEZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:25:09 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6B5518DD;
        Fri, 20 Jan 2023 20:24:48 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id g16so3765754qtu.2;
        Fri, 20 Jan 2023 20:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HV7BA/e9O5RDYHc0GpSLhXnbGhSUVych30GpzNnayWI=;
        b=p1ffXzlsXkgwWfnkIN5dHKAoPB+qji3zKzAGLiA4NxXTWvd6Z5peqTNBzwpVXCjgWv
         X2KKCxq2paGC1/zLxjdoEhzEWNI2LNxkGahKE2Db+Ym896BEyDDW5Qm0XZfSf31bZzo4
         72HnXJPhg8EvFePscmT7w3TWAXiYUav9sZfCYD6u5hdSpAGdi3hYJea4S9WrfmxTusgK
         kdX2DgvAeI25XaoojL/FWH5uJ4NwJym5E8VvzXANuNP9chp+0WWyAetY4hDJTl2nNaGr
         p6j0dB11+ap2OQmYo4f/7ESulz4ABsI0p+JBqEOIMBbq+7qP0BIHpb5lbQ2neX3XRYo1
         Y0Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HV7BA/e9O5RDYHc0GpSLhXnbGhSUVych30GpzNnayWI=;
        b=iYYJ8KwaY1vyyDOsQxu6nBdhTL3vINiPF7HMfmrvYhEa08fpfgn+nHpM7jMvTlnEy2
         Kh/zIuIYc6MUhKd9wN56BlXwHNOnGOGfPLj+cSj7vq6Vz5hOzFiASHFUl3iyOBBnsySO
         qTWOUhDuBZexF+TiK9yJEjV21AHeOaRy84VSk+tc9K0re4UJhCRE6JbTqxFWZk3njQW9
         Qp2JOLklHEg+zzQ8nhlVjt+EpAyn6E3s/5ISYkEcmxKmyDO93Oc5FHMj0GgzYAbanGk9
         B/1PSpE1+0/opHANMnCf51KcpeoMd1/nMlB63z0k7rbnTByzCjVQ54jvaQ0zGcY+kbFZ
         PF3Q==
X-Gm-Message-State: AFqh2kqNXMHZ7WUYJ1I11q0OQXYAk4AwPmv5aAiyo8UnGMIDd0TDxcn1
        SnaC3xsiWewDrEUlpJYCn2OLJAqt0M0=
X-Google-Smtp-Source: AMrXdXvcCfRLw6S+pZVgFgGVWQY4SvfcBnKbOZN7cmp7QlLgxxfe3GT3Ztq5t3a4h6SGlrgP1i0pHA==
X-Received: by 2002:ac8:760b:0:b0:3ac:7f6b:ed11 with SMTP id t11-20020ac8760b000000b003ac7f6bed11mr23372537qtq.15.1674275087742;
        Fri, 20 Jan 2023 20:24:47 -0800 (PST)
Received: from localhost (50-242-44-45-static.hfc.comcastbusiness.net. [50.242.44.45])
        by smtp.gmail.com with ESMTPSA id e13-20020ac84b4d000000b003b62cd6e60esm9329010qts.43.2023.01.20.20.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 20:24:47 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 6/9] sched/topology: Introduce sched_numa_hop_mask()
Date:   Fri, 20 Jan 2023 20:24:33 -0800
Message-Id: <20230121042436.2661843-7-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121042436.2661843-1-yury.norov@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
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

From: Valentin Schneider <vschneid@redhat.com>

Tariq has pointed out that drivers allocating IRQ vectors would benefit
from having smarter NUMA-awareness - cpumask_local_spread() only knows
about the local node and everything outside is in the same bucket.

sched_domains_numa_masks is pretty much what we want to hand out (a cpumask
of CPUs reachable within a given distance budget), introduce
sched_numa_hop_mask() to export those cpumasks.

Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h |  7 +++++++
 kernel/sched/topology.c  | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 72f264575698..344c2362755a 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -247,11 +247,18 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 
 #ifdef CONFIG_NUMA
 int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
+extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops);
 #else
 static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 {
 	return cpumask_nth(cpu, cpus);
 }
+
+static inline const struct cpumask *
+sched_numa_hop_mask(unsigned int node, unsigned int hops)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #endif	/* CONFIG_NUMA */
 
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 2bf89186a10f..1233affc106c 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2124,6 +2124,39 @@ int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(sched_numa_find_nth_cpu);
+
+/**
+ * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away from
+ *                         @node
+ * @node: The node to count hops from.
+ * @hops: Include CPUs up to that many hops away. 0 means local node.
+ *
+ * Return: On success, a pointer to a cpumask of CPUs at most @hops away from
+ * @node, an error value otherwise.
+ *
+ * Requires rcu_lock to be held. Returned cpumask is only valid within that
+ * read-side section, copy it if required beyond that.
+ *
+ * Note that not all hops are equal in distance; see sched_init_numa() for how
+ * distances and masks are handled.
+ * Also note that this is a reflection of sched_domains_numa_masks, which may change
+ * during the lifetime of the system (offline nodes are taken out of the masks).
+ */
+const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops)
+{
+	struct cpumask ***masks;
+
+	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
+		return ERR_PTR(-EINVAL);
+
+	masks = rcu_dereference(sched_domains_numa_masks);
+	if (!masks)
+		return ERR_PTR(-EBUSY);
+
+	return masks[hops][node];
+}
+EXPORT_SYMBOL_GPL(sched_numa_hop_mask);
+
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
-- 
2.34.1


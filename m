Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B45611829
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiJ1Qvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiJ1Qvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:51:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436357CE0B
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 09:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666975841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VvsEtK8QyUxcxneO/iuaAhunkW+JQwkOSt7vFL/EoPg=;
        b=NZeEWDoNP0I1zBW3KDwl0ImpbhdTC2u8bWrlyTVJS9Wrv9ZyUFzNVUx1IwtyMur2JCqsKw
        l1Wjihamm59zk0emoa7j2qxmr7RhDAh351UDLCuAFl2SBr/q/B9tTsecQVg6LSBAyKhVQf
        UMCRK0YXbYgWZBJJbD5rxIvquULNo7M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-ZB4sULHPMTO9D8JKfcJaWg-1; Fri, 28 Oct 2022 12:50:39 -0400
X-MC-Unique: ZB4sULHPMTO9D8JKfcJaWg-1
Received: by mail-wm1-f72.google.com with SMTP id f7-20020a7bcd07000000b003c6e73579d3so2534915wmj.8
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 09:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VvsEtK8QyUxcxneO/iuaAhunkW+JQwkOSt7vFL/EoPg=;
        b=DtalY43DYCmx/VlWrFv7KLqkF3Tyx12rUL27VSVltH4G5AJvd0k8JEO9FaJ1mnjTxs
         gf5oVtqXvtbAPcZTeBcAKS1T12WeagtQNHaCyBNoespiaJ0zHKvEZFY17c0jtpDBBhl8
         zJlMrWghMcw7ZUb/QiajdkCj2i1qmnZDD5t7IW7cb3uK1uj5Y4LSzkKsKrAxVnz67jBq
         NCluPR5qStx2sQDxMpZ07YlYvGZFkHU585C+1IIHAGS44rlR3akN+jR+va81JCuC0sBQ
         1AhYsRvDa/VAW/pmT0rZyS/ScM7+IzPDWCb1XdY1y58pVu6eI6m7eQNUxF+e4jvxZs84
         zakg==
X-Gm-Message-State: ACrzQf1c4OBYIPpUMUL//1ht2hGCqtYMgU1HRCCFRvyYPhpR42i4bgWF
        He7kSLNK/6gaHNS3tlZI1b+REI6D+UAXD21gjlKrNaEW43TWF5AIZ7c0zLmqaXPq8JVNiI/Vuz6
        vKrlSAjTu4VMIeZJCuIVhhV66KqeDNTUAd4hatQqCRmy0O5oYB0OUyDNryPOWpQNu+VYS
X-Received: by 2002:a05:600c:46ce:b0:3c6:f274:33b2 with SMTP id q14-20020a05600c46ce00b003c6f27433b2mr100197wmo.27.1666975833579;
        Fri, 28 Oct 2022 09:50:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6KWNMfTF8bNYIjl4T/lq0P5DYbXZ8JPnbVkrA4BuvuEcJ8NSHSRt0s61t/VqY72f5zyzH8mg==
X-Received: by 2002:a05:600c:46ce:b0:3c6:f274:33b2 with SMTP id q14-20020a05600c46ce00b003c6f27433b2mr100162wmo.27.1666975833298;
        Fri, 28 Oct 2022 09:50:33 -0700 (PDT)
Received: from vschneid.remote.csb ([149.71.65.94])
        by smtp.gmail.com with ESMTPSA id ay31-20020a05600c1e1f00b003cf537ec2efsm5065923wmb.36.2022.10.28.09.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 09:50:32 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v6 1/3] sched/topology: Introduce sched_numa_hop_mask()
Date:   Fri, 28 Oct 2022 17:49:57 +0100
Message-Id: <20221028164959.1367250-2-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221028164959.1367250-1-vschneid@redhat.com>
References: <20221028164959.1367250-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tariq has pointed out that drivers allocating IRQ vectors would benefit
from having smarter NUMA-awareness - cpumask_local_spread() only knows
about the local node and everything outside is in the same bucket.

sched_domains_numa_masks is pretty much what we want to hand out (a cpumask
of CPUs reachable within a given distance budget), introduce
sched_numa_hop_mask() to export those cpumasks.

Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h | 10 ++++++++++
 kernel/sched/topology.c  | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4564faafd0e12..64199545d7cf6 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,5 +245,15 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
+#ifdef CONFIG_NUMA
+extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops);
+#else
+static inline const struct cpumask *
+sched_numa_hop_mask(unsigned int node, unsigned int hops)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+#endif	/* CONFIG_NUMA */
+
 
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8739c2a5a54ea..3bce567241fc4 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2067,6 +2067,38 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 	return found;
 }
 
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
2.31.1


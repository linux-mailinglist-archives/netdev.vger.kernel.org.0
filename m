Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8896076C6
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJUMTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJUMTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:19:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B871B26556
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666354785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3rE72XJ0aceUfKerGW2NwZqel/SiYDWpKRmJbhA8td4=;
        b=aQAEA1t8fj27j40EXb+o1Fc9IQT9nRonGvnkmqnXk/G7k/Ro79fYsAoEIuCZaAkA0jYVmD
        JJ3Vje8if+lfh5t/M9CtzTTSttOsNl+STfKAxkjZE6kuLMsDapdtraQWy04LkXcO4SLCr+
        f3RAcHpPRgVn1hGfvcRBVtxQXoTxHDM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-aUsjcB_LNrCebQyH0HSK2g-1; Fri, 21 Oct 2022 08:19:44 -0400
X-MC-Unique: aUsjcB_LNrCebQyH0HSK2g-1
Received: by mail-qv1-f71.google.com with SMTP id dn14-20020a056214094e00b004b1a231394eso2220782qvb.13
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3rE72XJ0aceUfKerGW2NwZqel/SiYDWpKRmJbhA8td4=;
        b=WO7DCjGFvYDZnm1IVRdstv2VFwqb2u+AzQ83+RlhcHBCs0eCfq6cp3IZVuIIKDl6mG
         TMWUz6v9E9XLE9TWZdIopMH4fzs2TP1r95BqXeESylNqP4iZhEkzkyEceyE36ia2reVJ
         x4Zkk/bHwNx6QhjXey35vBijyMSxKh/xh0XGF0qeUQy3hJg7WNogD0iGo2Fv6OPwWBpQ
         wHv1rCBN8JwUxEAx253+J7lsorTbJhERjv5KtBYOsrJ2X0UjrBQa2T8aV6cy/b8HrJYj
         Lwido2PaNaUPWqHgO0VRi/tMHX1DvIEszvTfTZKoNrcrJU6PH41SSVCOKtiQwS3ZEfte
         E5dA==
X-Gm-Message-State: ACrzQf0mTB5BnLOlNT2EXFEeZzcpeQlW/S1DVG/Y9TXDTqkQlLVi9VPk
        1Z4A/S8q3oTqwIaiwHN/bCOqpGZ6LQNlatH6dTxIL+9jw1dXfbzVmkdMDUvVt7epfPztpJg/pWZ
        IN0v1VU//GDczyme9OfB1y4kmi5D6uAoFwrJ3+qGdm1HhujCU1pyNrErP9QlBZIG28EaZ
X-Received: by 2002:ac8:598b:0:b0:39d:9b6:69b3 with SMTP id e11-20020ac8598b000000b0039d09b669b3mr7962700qte.39.1666354782978;
        Fri, 21 Oct 2022 05:19:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM43z2VqBV6jSju6xBnB50pYpQbv/czfSsoiWVC0V+APInK010NQWXoC/xTaJ4deUqTqiOuPiQ==
X-Received: by 2002:ac8:598b:0:b0:39d:9b6:69b3 with SMTP id e11-20020ac8598b000000b0039d09b669b3mr7962653qte.39.1666354782635;
        Fri, 21 Oct 2022 05:19:42 -0700 (PDT)
Received: from vschneid.remote.csb ([149.71.65.94])
        by smtp.gmail.com with ESMTPSA id i9-20020ac85c09000000b0039a610a04b1sm8043410qti.37.2022.10.21.05.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 05:19:41 -0700 (PDT)
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
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v5 1/3] sched/topology: Introduce sched_numa_hop_mask()
Date:   Fri, 21 Oct 2022 13:19:25 +0100
Message-Id: <20221021121927.2893692-2-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221021121927.2893692-1-vschneid@redhat.com>
References: <20221021121927.2893692-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 include/linux/topology.h | 12 ++++++++++++
 kernel/sched/topology.c  | 31 +++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4564faafd0e12..3e91ae6d0ad58 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,5 +245,17 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
+#ifdef CONFIG_NUMA
+extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
+#else
+static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
+{
+	if (node == NUMA_NO_NODE && !hops)
+		return cpu_online_mask;
+
+	return ERR_PTR(-EOPNOTSUPP);
+}
+#endif	/* CONFIG_NUMA */
+
 
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8739c2a5a54ea..e3cb8cc375204 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2067,6 +2067,37 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
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
+	struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
+
+	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
+		return ERR_PTR(-EINVAL);
+
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


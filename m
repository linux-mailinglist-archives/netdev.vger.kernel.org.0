Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F5A589FDF
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbiHDR2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbiHDR2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:28:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB3886A4AC
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 10:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659634097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ybWDNojv72jmRJcXktwiQRGncl+ABn5fskjt5uRGsbE=;
        b=BLKQ4dGDMD4auHO1onJLoiImiYAfdgIyjh/qcUhU9ugAcAHaH9JrXWDZBiBn6ZsC0dsr+7
        VorVctElrGmyN0o5yrxTI4tHfGx1pyGT5bi9UgS5ldEeYbF520ZMcJPJGwFXvUf1CdtaKc
        J255An9I1tEd03yUpCDNsxzpbBpWV14=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-7f-S9xe_OgqjZbyIZU_0-Q-1; Thu, 04 Aug 2022 13:28:16 -0400
X-MC-Unique: 7f-S9xe_OgqjZbyIZU_0-Q-1
Received: by mail-wm1-f72.google.com with SMTP id r10-20020a05600c284a00b003a2ff6c9d6aso2864828wmb.4
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 10:28:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=ybWDNojv72jmRJcXktwiQRGncl+ABn5fskjt5uRGsbE=;
        b=Fnofj+l9R7/xNcUp78DKCCaO8n3nBHP1wBzeYtDyr05KixhDO0S7abLT86kIeJVQvJ
         rd1MgH5LwsVXrKNaSnucwmLDP1Nv8/8jiHJSQBP94cSxPVTxMj9KCP6WneJT03pKtEYU
         U+36jjoLAzFfqgjlJorUENzY3xvIMDzG+3yNg1hmWsYAycsW4yuObDfa3rbsDDtLIpp7
         1Kb602Z1Tr7B88XleD62EbWqrAFYQFdhFulCfMFgGObhctmmf130MReL/exrIIGX0Jkb
         aMRa4SspRj1U0Bo3SH0htJl5tZQYYR5JgZg6+22qihJ7ZZhUPvMWvXo6lQClsnngtLFh
         2f9g==
X-Gm-Message-State: ACgBeo07T4OtcWCwA9IXv7PiltESw8O21dGl0MHrIwlAxyiCtizTCSds
        b1jDhYhdcZQf561wGEFgI+29ZzNmuyJD2KNoz9OrzPr4SfWCRfi+uD9VEaPpfB8t8yauWLprek+
        JlMbsO/Ej3nUb1zB1
X-Received: by 2002:a05:600c:3495:b0:3a3:1fab:d01e with SMTP id a21-20020a05600c349500b003a31fabd01emr7240021wmq.150.1659634094598;
        Thu, 04 Aug 2022 10:28:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6Jmwl7TFdshejfvSaBVgESSXJ5Hx+8ErrzGPMKpQN8r/HQB+h5eJMby069n9WsL4VqCHOjhA==
X-Received: by 2002:a05:600c:3495:b0:3a3:1fab:d01e with SMTP id a21-20020a05600c349500b003a31fabd01emr7240010wmq.150.1659634094294;
        Thu, 04 Aug 2022 10:28:14 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id r6-20020a5d4e46000000b0021f0c05859esm1744458wrt.71.2022.08.04.10.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 10:28:13 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next V4 1/3] sched/topology: Add NUMA-based CPUs
 spread API
In-Reply-To: <20220728191203.4055-2-tariqt@nvidia.com>
References: <20220728191203.4055-1-tariqt@nvidia.com>
 <20220728191203.4055-2-tariqt@nvidia.com>
Date:   Thu, 04 Aug 2022 18:28:12 +0100
Message-ID: <xhsmhedxvdikz.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/22 22:12, Tariq Toukan wrote:
> Implement and expose API that sets the spread of CPUs based on distance,
> given a NUMA node.  Fallback to legacy logic that uses
> cpumask_local_spread.
>
> This logic can be used by device drivers to prefer some remote cpus over
> others.
>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

IIUC you want a multi-CPU version of sched_numa_find_closest(). I'm OK with
the need (and you have the numbers to back it up), but I have some qualms
with the implementation, see more below.

> ---
>  include/linux/sched/topology.h |  5 ++++
>  kernel/sched/topology.c        | 49 ++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
>
> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
> index 56cffe42abbc..a49167c2a0e5 100644
> --- a/include/linux/sched/topology.h
> +++ b/include/linux/sched/topology.h
> @@ -210,6 +210,7 @@ extern void set_sched_topology(struct sched_domain_topology_level *tl);
>  # define SD_INIT_NAME(type)
>  #endif
>
> +void sched_cpus_set_spread(int node, u16 *cpus, int ncpus);
>  #else /* CONFIG_SMP */
>
>  struct sched_domain_attr;
> @@ -231,6 +232,10 @@ static inline bool cpus_share_cache(int this_cpu, int that_cpu)
>       return true;
>  }
>
> +static inline void sched_cpus_set_spread(int node, u16 *cpus, int ncpus)
> +{
> +	memset(cpus, 0, ncpus * sizeof(*cpus));
> +}
>  #endif	/* !CONFIG_SMP */
>
>  #if defined(CONFIG_ENERGY_MODEL) && defined(CONFIG_CPU_FREQ_GOV_SCHEDUTIL)
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 05b6c2ad90b9..157aef862c04 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2067,8 +2067,57 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>       return found;
>  }
>
> +static bool sched_cpus_spread_by_distance(int node, u16 *cpus, int ncpus)
                                                       ^^^^^^^^^
That should be a struct *cpumask.

> +{
> +	cpumask_var_t cpumask;
> +	int first, i;
> +
> +	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL))
> +		return false;
> +
> +	cpumask_copy(cpumask, cpu_online_mask);
> +
> +	first = cpumask_first(cpumask_of_node(node));
> +
> +	for (i = 0; i < ncpus; i++) {
> +		int cpu;
> +
> +		cpu = sched_numa_find_closest(cpumask, first);
> +		if (cpu >= nr_cpu_ids) {
> +			free_cpumask_var(cpumask);
> +			return false;
> +		}
> +		cpus[i] = cpu;
> +		__cpumask_clear_cpu(cpu, cpumask);
> +	}
> +
> +	free_cpumask_var(cpumask);
> +	return true;
> +}

This will fail if ncpus > nr_cpu_ids, which shouldn't be a problem. It
would make more sense to set *up to* ncpus, the calling code can then
decide if getting fewer than requested is OK or not.

I also don't get the fallback to cpumask_local_spread(), is that if the
NUMA topology hasn't been initialized yet? It feels like most users of this
would invoke it late enough (i.e. anything after early initcalls) to have
the backing data available.

Finally, I think iterating only once per NUMA level would make more sense.

I've scribbled something together from those thoughts, see below. This has
just the mlx5 bits touched to show what I mean, but that's just compile
tested.
---
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 229728c80233..2d010d8d670c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -810,7 +810,7 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
 	int ncomp_eqs = table->num_comp_eqs;
-	u16 *cpus;
+	cpumask_var_t cpus;
 	int ret;
 	int i;
 
@@ -825,15 +825,14 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 		return ret;
 	}
 
-	cpus = kcalloc(ncomp_eqs, sizeof(*cpus), GFP_KERNEL);
-	if (!cpus) {
+	if (!zalloc_cpumask_var(&cpus, GFP_KERNEL)) {
 		ret = -ENOMEM;
 		goto free_irqs;
 	}
-	for (i = 0; i < ncomp_eqs; i++)
-		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
+
+	sched_numa_find_n_closest(cpus, dev->piv.numa_node, ncomp_eqs);
 	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
-	kfree(cpus);
+	free_cpumask_var(cpus);
 	if (ret < 0)
 		goto free_irqs;
 	return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 662f1d55e30e..2330f81aeede 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -448,7 +448,7 @@ void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs)
 /**
  * mlx5_irqs_request_vectors - request one or more IRQs for mlx5 device.
  * @dev: mlx5 device that is requesting the IRQs.
- * @cpus: CPUs array for binding the IRQs
+ * @cpus: cpumask for binding the IRQs
  * @nirqs: number of IRQs to request.
  * @irqs: an output array of IRQs pointers.
  *
@@ -458,25 +458,22 @@ void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs)
  * This function returns the number of IRQs requested, (which might be smaller than
  * @nirqs), if successful, or a negative error code in case of an error.
  */
-int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
+int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev,
+			      const struct cpumask *cpus,
+			      int nirqs,
 			      struct mlx5_irq **irqs)
 {
-	cpumask_var_t req_mask;
+	int cpu = cpumask_first(cpus);
 	struct mlx5_irq *irq;
-	int i;
 
-	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
-		return -ENOMEM;
-	for (i = 0; i < nirqs; i++) {
-		cpumask_set_cpu(cpus[i], req_mask);
-		irq = mlx5_irq_request(dev, i, req_mask);
+	for (i = 0; i < nirqs && cpu < nr_cpu_ids; i++) {
+		irq = mlx5_irq_request(dev, i, cpumask_of(cpu));
 		if (IS_ERR(irq))
 			break;
-		cpumask_clear(req_mask);
 		irqs[i] = irq;
+		cpu = cpumask_next(cpu, cpus);
 	}
 
-	free_cpumask_var(req_mask);
 	return i ? i : PTR_ERR(irq);
 }
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4564faafd0e1..bdc9c5df84cd 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,5 +245,13 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
+#ifdef CONFIG_NUMA
+extern int sched_numa_find_n_closest(struct cpumask *cpus, int node, int ncpus);
+#else
+static inline int sched_numa_find_n_closest(struct cpumask *cpus, int node, int ncpus)
+{
+	return -ENOTSUPP;
+}
+#endif
 
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8739c2a5a54e..499f6ef611fa 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2067,6 +2067,56 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 	return found;
 }
 
+/**
+ * sched_numa_find_n_closest - Find the 'n' closest cpus to a given node
+ * @cpus: The cpumask to fill in with CPUs
+ * @ncpus: How many CPUs to look for
+ * @node: The node to start the search from
+ *
+ * This will fill *up to* @ncpus in @cpus, using the closest (in NUMA distance)
+ * first and expanding outside the node if more CPUs are required.
+ *
+ * Return: Number of found CPUs, negative value on error.
+ */
+int sched_numa_find_n_closest(struct cpumask *cpus, int node, int ncpus)
+{
+	struct cpumask ***masks;
+	int cpu, lvl, ntofind = ncpus;
+
+	if (node >= nr_node_ids)
+		return -EINVAL;
+
+	rcu_read_lock();
+
+	masks = rcu_dereference(sched_domains_numa_masks);
+	if (!masks)
+		goto unlock;
+
+	/*
+	 * Walk up the level masks; the first mask should be CPUs LOCAL_DISTANCE
+	 * away (aka the local node), and we incrementally grow the search
+	 * beyond that.
+	 */
+	for (lvl = 0; lvl < sched_domains_numa_levels; lvl++) {
+		if (!masks[lvl][node])
+			goto unlock;
+
+		/* XXX: could be neater with for_each_cpu_andnot() */
+		for_each_cpu(cpu, masks[lvl][node]) {
+			if (cpumask_test_cpu(cpu, cpus))
+				continue;
+
+			__cpumask_set_cpu(cpu, cpus);
+			if (--ntofind == 0)
+				goto unlock;
+		}
+	}
+unlock:
+	rcu_read_unlock();
+	return ncpus - ntofind;
+}
+EXPORT_SYMBOL_GPL(sched_numa_find_n_closest);
+
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)


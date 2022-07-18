Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC90578446
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiGRNuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiGRNuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:50:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691011144B;
        Mon, 18 Jul 2022 06:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MhRAv8UCpG9xxDYWdTdg48Rm9BXoBV7k7BkfzrH2XLs=; b=SKiEPFXOkukWucAik/+8bTY7ud
        6V6gNJfPm7Th7pl2/f+HUzpzrkbRk6l0tJM46PUweVzs6L0PmQMmBL19kU7BFo5PnLXF7zUA4a9iY
        BGrGzg4/C9hD7Jb2JKGE04/Ki+SuyENIBc8hQ2f5w54x3UEIBqd6K6IxMnIsoo9kz1JdJ31CD8QWO
        eG+n7Wmxdiz2TTdT6xliF5cSgNGsl0Vgc7+4KJEKv8pNgGa7Y1qo/C2ojL1VGuRc9BTxzfF0TqT9V
        LNj8jxagg15n6K7nMcxBgWl0GANf11NAHBS4DlvIgmF2DzuLf68H9ZPUJU9uj1/ncAQv/GstueyLc
        yJO1jmpg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDR8R-004pkj-7D; Mon, 18 Jul 2022 13:50:07 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id B6A0A980299; Mon, 18 Jul 2022 15:50:06 +0200 (CEST)
Date:   Mon, 18 Jul 2022 15:50:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V2 2/2] net/mlx5e: Improve remote NUMA
 preferences used for the IRQ affinity hints
Message-ID: <YtVlDiLTPxm312u+@worktop.programming.kicks-ass.net>
References: <20220718124315.16648-1-tariqt@nvidia.com>
 <20220718124315.16648-3-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718124315.16648-3-tariqt@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 03:43:15PM +0300, Tariq Toukan wrote:

> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 62 +++++++++++++++++++-
>  1 file changed, 59 insertions(+), 3 deletions(-)
> 
> v2:
> Separated the set_cpu operation into two functions, per Saeed's suggestion.
> Added Saeed's Acked-by signature.
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index 229728c80233..e72bdaaad84f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -11,6 +11,9 @@
>  #ifdef CONFIG_RFS_ACCEL
>  #include <linux/cpu_rmap.h>
>  #endif
> +#ifdef CONFIG_NUMA
> +#include <linux/sched/topology.h>
> +#endif
>  #include "mlx5_core.h"
>  #include "lib/eq.h"
>  #include "fpga/core.h"
> @@ -806,13 +809,67 @@ static void comp_irqs_release(struct mlx5_core_dev *dev)
>  	kfree(table->comp_irqs);
>  }
>  
> +static void set_cpus_by_local_spread(struct mlx5_core_dev *dev, u16 *cpus,
> +				     int ncomp_eqs)
> +{
> +	int i;
> +
> +	for (i = 0; i < ncomp_eqs; i++)
> +		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
> +}
> +
> +static bool set_cpus_by_numa_distance(struct mlx5_core_dev *dev, u16 *cpus,
> +				      int ncomp_eqs)
> +{
> +#ifdef CONFIG_NUMA
> +	cpumask_var_t cpumask;
> +	int first;
> +	int i;
> +
> +	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL)) {
> +		mlx5_core_err(dev, "zalloc_cpumask_var failed\n");
> +		return false;
> +	}
> +	cpumask_copy(cpumask, cpu_online_mask);
> +
> +	first = cpumask_local_spread(0, dev->priv.numa_node);

Arguably you want something like:

	first = cpumask_any(cpumask_of_node(dev->priv.numa_node));

> +
> +	for (i = 0; i < ncomp_eqs; i++) {
> +		int cpu;
> +
> +		cpu = sched_numa_find_closest(cpumask, first);
> +		if (cpu >= nr_cpu_ids) {
> +			mlx5_core_err(dev, "sched_numa_find_closest failed, cpu(%d) >= nr_cpu_ids(%d)\n",
> +				      cpu, nr_cpu_ids);
> +
> +			free_cpumask_var(cpumask);
> +			return false;

So this will fail when ncomp_eqs > cpumask_weight(online_cpus); is that
desired?

> +		}
> +		cpus[i] = cpu;
> +		cpumask_clear_cpu(cpu, cpumask);

Since there is no concurrency on this cpumask, you don't need atomic
ops:

		__cpumask_clear_cpu(..);

> +	}
> +
> +	free_cpumask_var(cpumask);
> +	return true;
> +#else
> +	return false;
> +#endif
> +}
> +
> +static void mlx5_set_eqs_cpus(struct mlx5_core_dev *dev, u16 *cpus, int ncomp_eqs)
> +{
> +	bool success = set_cpus_by_numa_distance(dev, cpus, ncomp_eqs);
> +
> +	if (!success)
> +		set_cpus_by_local_spread(dev, cpus, ncomp_eqs);
> +}
> +
>  static int comp_irqs_request(struct mlx5_core_dev *dev)
>  {
>  	struct mlx5_eq_table *table = dev->priv.eq_table;
>  	int ncomp_eqs = table->num_comp_eqs;
>  	u16 *cpus;
>  	int ret;
> -	int i;
>  
>  	ncomp_eqs = table->num_comp_eqs;
>  	table->comp_irqs = kcalloc(ncomp_eqs, sizeof(*table->comp_irqs), GFP_KERNEL);
> @@ -830,8 +887,7 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
>  		ret = -ENOMEM;
>  		goto free_irqs;
>  	}
> -	for (i = 0; i < ncomp_eqs; i++)
> -		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
> +	mlx5_set_eqs_cpus(dev, cpus, ncomp_eqs);

So you change this for mlx5, what about the other users of
cpumask_local_spread() ?

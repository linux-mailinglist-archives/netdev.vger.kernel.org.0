Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A34423D51
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbhJFLvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238577AbhJFLvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 07:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C0661077;
        Wed,  6 Oct 2021 11:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633520951;
        bh=JfIdY6/V+d3Y36/FGCu5ngWkU42RfdFTU88pnWu1/og=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PuW7r1SJd3a+rDGJYcxrljpFcqxDoen1Q682VLWt64SsnKrz67McXNFtjMSjdUK9n
         914JDWec9xcxJvwKOfgWniiLaO8ybc/amE8MMOfKl867tRgPzs6PuF/3rHeIoqMiiA
         G4/pju7423JqIraqsnhLXOMNZaSdBABz+cVZbY8M4n7e48hp+ZJgNmewueE9dPNapb
         bB7+BGZSW9BqhiXZDzwh2ycdoa01R2KAFh1T3l0uT6McphXcl5Rpvz+CaJWcP71vzI
         BHs/78NCJsaBBlh+eKXkQk4pJSDMmxROf4R8RWf9kNA5Zr+1oPtL/V4v3xgmFmuI4i
         c2VxuGTfrlRaQ==
Date:   Wed, 6 Oct 2021 14:49:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v3 05/13] RDMA/counter: Add an is_disabled
 field in struct rdma_hw_stats
Message-ID: <YV2NMzu0izn2vWrJ@unreal>
References: <cover.1633513239.git.leonro@nvidia.com>
 <09596ef74f4c213cb236e057e20e98264b67f16e.1633513239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09596ef74f4c213cb236e057e20e98264b67f16e.1633513239.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 12:52:08PM +0300, Leon Romanovsky wrote:
> From: Aharon Landau <aharonl@nvidia.com>
> 
> Add a bitmap in rdma_hw_stat structure, with each bit indicates whether
> the corresponding counter is currently disabled or not. By default
> hwcounters are enabled.
> 
> Signed-off-by: Aharon Landau <aharonl@nvidia.com>
> Reviewed-by: Mark Zhang <markzhang@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/core/nldev.c | 11 ++++++++++-
>  drivers/infiniband/core/verbs.c | 10 ++++++++++
>  include/rdma/ib_verbs.h         |  3 +++
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 3f6b98a87566..67519730b1ac 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -968,15 +968,21 @@ static int fill_stat_counter_hwcounters(struct sk_buff *msg,
>  	if (!table_attr)
>  		return -EMSGSIZE;
>  
> -	for (i = 0; i < st->num_counters; i++)
> +	mutex_lock(&st->lock);
> +	for (i = 0; i < st->num_counters; i++) {
> +		if (test_bit(i, st->is_disabled))
> +			continue;
>  		if (rdma_nl_stat_hwcounter_entry(msg, st->descs[i].name,
>  						 st->value[i]))
>  			goto err;
> +	}
> +	mutex_unlock(&st->lock);
>  
>  	nla_nest_end(msg, table_attr);
>  	return 0;
>  
>  err:
> +	mutex_unlock(&st->lock);
>  	nla_nest_cancel(msg, table_attr);
>  	return -EMSGSIZE;
>  }
> @@ -2104,6 +2110,9 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
>  		goto err_stats;
>  	}
>  	for (i = 0; i < num_cnts; i++) {
> +		if (test_bit(i, stats->is_disabled))
> +			continue;
> +
>  		v = stats->value[i] +
>  			rdma_counter_get_hwstat_value(device, port, i);
>  		if (rdma_nl_stat_hwcounter_entry(msg,
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index c3319a7584a2..d957b23a0e23 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -2994,11 +2994,20 @@ struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
>  	if (!stats)
>  		return NULL;
>  
> +	stats->is_disabled = kcalloc(BITS_TO_LONGS(num_counters),
> +				     sizeof(*stats->is_disabled), GFP_KERNEL);
> +	if (!stats->is_disabled)
> +		goto err;
> +
>  	stats->descs = descs;
>  	stats->num_counters = num_counters;
>  	stats->lifespan = msecs_to_jiffies(lifespan);
>  
>  	return stats;
> +
> +err:
> +	kfree(stats);
> +	return NULL;
>  }
>  EXPORT_SYMBOL(rdma_alloc_hw_stats_struct);
>  
> @@ -3008,6 +3017,7 @@ EXPORT_SYMBOL(rdma_alloc_hw_stats_struct);
>   */
>  void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats)
>  {
> +	kfree(stats->is_disabled);
>  	kfree(stats);

Jason,

This hunk needs to be the following for the representors case. Can you
please fix it locally?

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index d957b23a0e23..e9e042b31386 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -3017,6 +3017,9 @@ EXPORT_SYMBOL(rdma_alloc_hw_stats_struct);
  */
 void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats)
 {
+       if (!stats)
+               return;
+
        kfree(stats->is_disabled);
        kfree(stats);
 }

Thanks

>  }
>  EXPORT_SYMBOL(rdma_free_hw_stats_struct);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 938c0c0a1c19..ae467365706b 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -565,6 +565,8 @@ struct rdma_stat_desc {
>   *   their own value during their allocation routine.
>   * @descs - Array of pointers to static descriptors used for the counters
>   *   in directory.
> + * @is_disabled - A bitmap to indicate each counter is currently disabled
> + *   or not.
>   * @num_counters - How many hardware counters there are.  If name is
>   *   shorter than this number, a kernel oops will result.  Driver authors
>   *   are encouraged to leave BUILD_BUG_ON(ARRAY_SIZE(@name) < num_counters)
> @@ -577,6 +579,7 @@ struct rdma_hw_stats {
>  	unsigned long	timestamp;
>  	unsigned long	lifespan;
>  	const struct rdma_stat_desc *descs;
> +	unsigned long	*is_disabled;
>  	int		num_counters;
>  	u64		value[];
>  };
> -- 
> 2.31.1
> 

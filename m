Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F27F57086B
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiGKQeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGKQeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:34:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D20DB2C127;
        Mon, 11 Jul 2022 09:34:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E233A1596;
        Mon, 11 Jul 2022 09:34:41 -0700 (PDT)
Received: from e126311.manchester.arm.com (unknown [10.57.72.24])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D11CA3F792;
        Mon, 11 Jul 2022 09:34:39 -0700 (PDT)
Date:   Mon, 11 Jul 2022 17:34:25 +0100
From:   Kajetan Puchalski <kajetan.puchalski@arm.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, regressions@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, Mel Gorman <mgorman@suse.de>,
        lukasz.luba@arm.com, dietmar.eggemann@arm.com,
        kajetan.puchalski@arm.com
Subject: Re: [PATCH nf v3] netfilter: conntrack: fix crash due to confirmed
 bit load reordering
Message-ID: <YsxREc/UcpT2hdni@e126311.manchester.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706145004.22355-1-fw@strlen.de>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> v3: keep smp_acquire__after_ctrl_dep close to refcount_inc_not_zero call
>     add comment in nf_conntrack_netlink, no control dependency there
>     due to locks.

Just to follow up on that, I tested v3 for 24 hours with the workload in
question and found no issues so looks like the fix is stable.

In case someone is interested in performance differences, seeing as I
was running benchmarks regardless I thought I might share the numbers on
how using refcount vs atomic here seems to affect networking workloads.

The results were collected using mmtests, the means containing asterisks
are the results that the framework considered statistically significant.

netperf-udp
                                     atomic                     v3
Hmean     send-64         189.36 (   0.00%)      227.14 *  19.95%*
Hmean     send-128        378.77 (   0.00%)      387.94 (   2.42%)
Hmean     send-256        925.96 (   0.00%)      922.77 (  -0.34%)
Hmean     send-1024      3550.03 (   0.00%)     3528.63 (  -0.60%)
Hmean     send-2048      6545.45 (   0.00%)     6655.64 *   1.68%*
Hmean     send-3312     10282.12 (   0.00%)    10388.78 *   1.04%*
Hmean     send-4096     11902.15 (   0.00%)    12052.30 *   1.26%*
Hmean     send-8192     19369.15 (   0.00%)    20363.82 *   5.14%*
Hmean     send-16384    32610.44 (   0.00%)    33080.30 (   1.44%)
Hmean     recv-64         189.36 (   0.00%)      226.34 *  19.53%*
Hmean     recv-128        378.77 (   0.00%)      386.81 (   2.12%)
Hmean     recv-256        925.95 (   0.00%)      922.77 (  -0.34%)
Hmean     recv-1024      3549.90 (   0.00%)     3528.51 (  -0.60%)
Hmean     recv-2048      6542.82 (   0.00%)     6653.05 *   1.68%*
Hmean     recv-3312     10278.46 (   0.00%)    10385.45 *   1.04%*
Hmean     recv-4096     11892.86 (   0.00%)    12041.68 *   1.25%*
Hmean     recv-8192     19345.14 (   0.00%)    20343.76 *   5.16%*
Hmean     recv-16384    32574.38 (   0.00%)    33030.53 (   1.40%)

netperf-tcp
                                atomic                     v3
Hmean     64        1324.25 (   0.00%)     1328.90 *   0.35%*
Hmean     128       2576.89 (   0.00%)     2579.71 (   0.11%)
Hmean     256       4882.34 (   0.00%)     4889.49 (   0.15%)
Hmean     1024     14560.89 (   0.00%)    14423.39 *  -0.94%*
Hmean     2048     20995.91 (   0.00%)    20818.49 *  -0.85%*
Hmean     3312     25440.20 (   0.00%)    25318.16 *  -0.48%*
Hmean     4096     27309.32 (   0.00%)    27282.26 (  -0.10%)
Hmean     8192     31204.34 (   0.00%)    31326.23 *   0.39%*
Hmean     16384    34370.49 (   0.00%)    34298.25 (  -0.21%)

Additionally, the reason I bumped into this issue in the first place was
running benchmarks on different CPUIdle governors so below are the
results for what happens if in additon to changing from atomic to
v3 refcount I also switch the idle governor from menu to TEO.

netperf-udp
                                     atomic                     v3
                                      menu                     teo
Hmean     send-64         189.36 (   0.00%)      248.79 *  31.38%*
Hmean     send-128        378.77 (   0.00%)      439.06 (  15.92%)
Hmean     send-256        925.96 (   0.00%)     1101.20 *  18.93%*
Hmean     send-1024      3550.03 (   0.00%)     3298.19 (  -7.09%)
Hmean     send-2048      6545.45 (   0.00%)     7714.21 *  17.86%*
Hmean     send-3312     10282.12 (   0.00%)    12090.56 *  17.59%*
Hmean     send-4096     11902.15 (   0.00%)    13766.56 *  15.66%*
Hmean     send-8192     19369.15 (   0.00%)    22943.77 *  18.46%*
Hmean     send-16384    32610.44 (   0.00%)    37370.44 *  14.60%*
Hmean     recv-64         189.36 (   0.00%)      248.79 *  31.38%*
Hmean     recv-128        378.77 (   0.00%)      439.06 (  15.92%)
Hmean     recv-256        925.95 (   0.00%)     1101.19 *  18.92%*
Hmean     recv-1024      3549.90 (   0.00%)     3298.16 (  -7.09%)
Hmean     recv-2048      6542.82 (   0.00%)     7711.59 *  17.86%*
Hmean     recv-3312     10278.46 (   0.00%)    12087.81 *  17.60%*
Hmean     recv-4096     11892.86 (   0.00%)    13755.48 *  15.66%*
Hmean     recv-8192     19345.14 (   0.00%)    22933.98 *  18.55%*
Hmean     recv-16384    32574.38 (   0.00%)    37332.10 *  14.61%*

netperf-tcp
                                atomic                     v3
                                 menu                     teo
Hmean     64        1324.25 (   0.00%)     1351.86 *   2.08%*
Hmean     128       2576.89 (   0.00%)     2629.08 *   2.03%*
Hmean     256       4882.34 (   0.00%)     5003.19 *   2.48%*
Hmean     1024     14560.89 (   0.00%)    15237.15 *   4.64%*
Hmean     2048     20995.91 (   0.00%)    22804.40 *   8.61%*
Hmean     3312     25440.20 (   0.00%)    27815.23 *   9.34%*
Hmean     4096     27309.32 (   0.00%)    30171.81 *  10.48%*
Hmean     8192     31204.34 (   0.00%)    37112.55 *  18.93%*
Hmean     16384    34370.49 (   0.00%)    42952.01 *  24.97%*

The absolute values might be skewed by the characteristics of the
machine in question but I thought the comparative differences between
different patches were interesting enough to share.

> Cc: Peter Zijlstra <peterz@infradead.org>
> Reported-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
> Diagnosed-by: Will Deacon <will@kernel.org>
> Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_core.c       | 22 ++++++++++++++++++++++
>  net/netfilter/nf_conntrack_netlink.c    |  1 +
>  net/netfilter/nf_conntrack_standalone.c |  3 +++
>  3 files changed, 26 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 082a2fd8d85b..369aeabb94fe 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -729,6 +729,9 @@ static void nf_ct_gc_expired(struct nf_conn *ct)
>  	if (!refcount_inc_not_zero(&ct->ct_general.use))
>  		return;
>  
> +	/* load ->status after refcount increase */
> +	smp_acquire__after_ctrl_dep();
> +
>  	if (nf_ct_should_gc(ct))
>  		nf_ct_kill(ct);
>  
> @@ -795,6 +798,9 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
>  		 */
>  		ct = nf_ct_tuplehash_to_ctrack(h);
>  		if (likely(refcount_inc_not_zero(&ct->ct_general.use))) {
> +			/* re-check key after refcount */
> +			smp_acquire__after_ctrl_dep();
> +
>  			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
>  				goto found;
>  
> @@ -1387,6 +1393,9 @@ static unsigned int early_drop_list(struct net *net,
>  		if (!refcount_inc_not_zero(&tmp->ct_general.use))
>  			continue;
>  
> +		/* load ->ct_net and ->status after refcount increase */
> +		smp_acquire__after_ctrl_dep();
> +
>  		/* kill only if still in same netns -- might have moved due to
>  		 * SLAB_TYPESAFE_BY_RCU rules.
>  		 *
> @@ -1536,6 +1545,9 @@ static void gc_worker(struct work_struct *work)
>  			if (!refcount_inc_not_zero(&tmp->ct_general.use))
>  				continue;
>  
> +			/* load ->status after refcount increase */
> +			smp_acquire__after_ctrl_dep();
> +
>  			if (gc_worker_skip_ct(tmp)) {
>  				nf_ct_put(tmp);
>  				continue;
> @@ -1775,6 +1787,16 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
>  	if (!exp)
>  		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
>  
> +	/* Other CPU might have obtained a pointer to this object before it was
> +	 * released.  Because refcount is 0, refcount_inc_not_zero() will fail.
> +	 *
> +	 * After refcount_set(1) it will succeed; ensure that zeroing of
> +	 * ct->status and the correct ct->net pointer are visible; else other
> +	 * core might observe CONFIRMED bit which means the entry is valid and
> +	 * in the hash table, but its not (anymore).
> +	 */
> +	smp_wmb();
> +
>  	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
>  	refcount_set(&ct->ct_general.use, 1);
>  
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 722af5e309ba..f5905b5201a7 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1203,6 +1203,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
>  					   hnnode) {
>  			ct = nf_ct_tuplehash_to_ctrack(h);
>  			if (nf_ct_is_expired(ct)) {
> +				/* need to defer nf_ct_kill() until lock is released */
>  				if (i < ARRAY_SIZE(nf_ct_evict) &&
>  				    refcount_inc_not_zero(&ct->ct_general.use))
>  					nf_ct_evict[i++] = ct;
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 6ad7bbc90d38..05895878610c 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -306,6 +306,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  	if (unlikely(!refcount_inc_not_zero(&ct->ct_general.use)))
>  		return 0;
>  
> +	/* load ->status after refcount increase */
> +	smp_acquire__after_ctrl_dep();
> +
>  	if (nf_ct_should_gc(ct)) {
>  		nf_ct_kill(ct);
>  		goto release;
> -- 
> 2.35.1
> 

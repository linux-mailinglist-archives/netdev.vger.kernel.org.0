Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E5B577F7F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiGRKTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiGRKTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:19:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A411C901;
        Mon, 18 Jul 2022 03:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ijs/RSv7qHQbvm9v+Fy+Qzb4VPBB1zdP6a7q0FZ2hyY=; b=mMUTuFO2xqKNFtna0kmQNGmRa+
        WQr6Gj2zDbk2LspuJH11pLa6ym0tcz0Ptv/eQ5EbMRdIqykF6+pi5NX/WeqNHzIW5QlUaAVHRMKkn
        MrfgUjKSDUZ2WFBi8cOnM/rxYytl7+sk6K6zWdO+n78+VU/wBimLTaZyUBJ22l5P7zmiN7TyYXsMH
        gOtvcXXNpFNDbeTpzoB3jfJIgeeUHAerDtDX1FpOfaFHaEqzFWja7M5rmLlTeACcYrdsDFL/ScYiJ
        Qqj7OWkWp42t++1844ZuMsPoXFb5tPRpaTo0lmPJtB2Aout9jPZRjJvXyAc3evas6rGs7IuOQIx8i
        WZXQuiRA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDNql-00CbGs-Kd; Mon, 18 Jul 2022 10:19:39 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 390EA980226; Mon, 18 Jul 2022 12:19:39 +0200 (CEST)
Date:   Mon, 18 Jul 2022 12:19:39 +0200
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
Subject: Re: [PATCH net-next 1/2] sched/topology: Expose
 sched_numa_find_closest
Message-ID: <YtUzu4d9F+V621tw@worktop.programming.kicks-ass.net>
References: <20220717052301.19067-1-tariqt@nvidia.com>
 <20220717052301.19067-2-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220717052301.19067-2-tariqt@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 08:23:00AM +0300, Tariq Toukan wrote:
> This logic can help device drivers prefer some remote cpus
> over others, according to the NUMA distance metrics.
> 
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  include/linux/sched/topology.h | 2 ++
>  kernel/sched/topology.c        | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
> index 56cffe42abbc..d467c30bdbb9 100644
> --- a/include/linux/sched/topology.h
> +++ b/include/linux/sched/topology.h
> @@ -61,6 +61,8 @@ static inline int cpu_numa_flags(void)
>  {
>  	return SD_NUMA;
>  }
> +
> +int sched_numa_find_closest(const struct cpumask *cpus, int cpu);
>  #endif
>  
>  extern int arch_asym_cpu_priority(int cpu);
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 05b6c2ad90b9..688334ac4980 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2066,6 +2066,7 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>  
>  	return found;
>  }
> +EXPORT_SYMBOL(sched_numa_find_closest);

EXPORT_SYMBOL_GPL() if anything.

Also, this thing will be subject to sched_domains, that means that if
someone uses cpusets or other means to partition the machine, that
effects the result.

Is that what you want?

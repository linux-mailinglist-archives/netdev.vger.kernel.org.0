Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0973559BDD0
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 12:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbiHVKsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 06:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiHVKr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 06:47:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56C72F644;
        Mon, 22 Aug 2022 03:47:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 52FA31FA1F;
        Mon, 22 Aug 2022 10:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661165277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1M/Zuyl600zh5OmjL3aP6WKCrt6KbCa7RpzoykruBZw=;
        b=CkwIN1GEx3GNBlcdPWCiBCFdLpTLxcdkjLWaTODElEHE6mTTBhiKC+1N97hT5Gz7LlqnCH
        9mMMdfZ0twoTWASkE/SJ3FgnBurhvYRkyqd0DI3+quAaHB4mw7f7mtFJzsVjB8LW2Bdx9C
        YwCnI1D7ziUWN9oC2VhGGm3yZP3sBJw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 343901332D;
        Mon, 22 Aug 2022 10:47:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sEDfCd1eA2OTFwAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 22 Aug 2022 10:47:57 +0000
Date:   Mon, 22 Aug 2022 12:47:56 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Message-ID: <YwNe3HBxzF+fWb2n@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-4-shakeelb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822001737.4120417-4-shakeelb@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 22-08-22 00:17:37, Shakeel Butt wrote:
> For several years, MEMCG_CHARGE_BATCH was kept at 32 but with bigger
> machines and the network intensive workloads requiring througput in
> Gbps, 32 is too small and makes the memcg charging path a bottleneck.
> For now, increase it to 64 for easy acceptance to 6.0. We will need to
> revisit this in future for ever increasing demand of higher performance.

Yes, the batch size has always been an arbitrary number. I do not think
there have ever been any solid grounds for the value we have now except
we need something and SWAP_CLUSTER_MAX was a good enough template.

Increasing it to 64 sounds like a reasonable step. It would be great to
have it scale based on the number of CPUs and potentially other factors
but that would be hard to get right and actually hard to evaluate
because it will depend on the specific workload.
 
> Please note that the memcg charge path drain the per-cpu memcg charge
> stock, so there should not be any oom behavior change.

It will have an effect on other stuff as well like high limit reclaim
backoff and stast flushing.
 
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy with top
> level having min and low setup appropriately. More specifically
> memory.min equal to size of netperf binary and memory.low double of
> that.

a similar feedback to the test case description as with other patches.
> 
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> 
> Results (average throughput of netperf):
> Without (6.0-rc1)       10482.7 Mbps
> With patch              17064.7 Mbps (62.7% improvement)
> 
> With the patch, the throughput improved by 62.7%.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>

Anyway
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  include/linux/memcontrol.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 4d31ce55b1c0..70ae91188e16 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -354,10 +354,11 @@ struct mem_cgroup {
>  };
>  
>  /*
> - * size of first charge trial. "32" comes from vmscan.c's magic value.
> - * TODO: maybe necessary to use big numbers in big irons.
> + * size of first charge trial.
> + * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
> + * workload.
>   */
> -#define MEMCG_CHARGE_BATCH 32U
> +#define MEMCG_CHARGE_BATCH 64U
>  
>  extern struct mem_cgroup *root_mem_cgroup;
>  
> -- 
> 2.37.1.595.g718a3a8f04-goog

-- 
Michal Hocko
SUSE Labs

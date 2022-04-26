Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AF550EEE7
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 04:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242646AbiDZCyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 22:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiDZCyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 22:54:04 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356A910FD6;
        Mon, 25 Apr 2022 19:50:58 -0700 (PDT)
Date:   Mon, 25 Apr 2022 19:50:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650941456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GXBsNESQZfIaAKadUYOa+SDoc+85t8RLisih8+qEL90=;
        b=BZEJVGSQbQna5YPVt/zgZb1xcavzGypztWiz7oSNbvFlNBt5UIGE3dm8UcDmm+ONRC98Zj
        tHzuasQXAuszKFYJ/KRekAxhj5LA/p6kbS+3o1nWoqjCepWBpyZavGJuUW3nqOhABMOI7v
        Dq9s7knx7Mfj6cTS9Z3wqQuxF5PHLDA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Vasily Averin <vvs@openvz.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH memcg v3] net: set proper memcg for net_init hooks
 allocations
Message-ID: <YmdeCqi6wmgiSiWh@carbon>
References: <20220424144627.GB13403@xsang-OptiPlex-9020>
 <c2f0139a-62e2-5985-34e9-d42faac81960@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2f0139a-62e2-5985-34e9-d42faac81960@openvz.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 01:56:02PM +0300, Vasily Averin wrote:

Hello, Vasily!

> __register_pernet_operations() executes init hook of registered
> pernet_operation structure in all existing net namespaces.
> 
> Typically, these hooks are called by a process associated with
> the specified net namespace, and all __GFP_ACCOUNTING marked
> allocation are accounted for corresponding container/memcg.

__GFP_ACCOUNT

> 
> However __register_pernet_operations() calls the hooks in the same
> context, and as a result all marked allocations are accounted
> to one memcg for all processed net namespaces.
> 
> This patch adjusts active memcg for each net namespace and helps
> to account memory allocated inside ops_init() into the proper memcg.
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
> v3: put_net_memcg() replaced by an alreay existing mem_cgroup_put()
>     It checks memcg before accessing it, this is required for
>     __register_pernet_operations() called before memcg initialization.
>     Additionally fixed leading whitespaces in non-memcg_kmem version
>     of mem_cgroup_from_obj().
> 
> v2: introduced get/put_net_memcg(),
>     new functions are moved under CONFIG_MEMCG_KMEM
>     to fix compilation issues reported by Intel's kernel test robot
> 
> v1: introduced get_mem_cgroup_from_kmem(), which takes the refcount
>     for the found memcg, suggested by Shakeel
> ---
>  include/linux/memcontrol.h | 29 ++++++++++++++++++++++++++++-
>  net/core/net_namespace.c   |  7 +++++++
>  2 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0abbd685703b..cfb68a3f7015 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1714,6 +1714,29 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
>  
>  struct mem_cgroup *mem_cgroup_from_obj(void *p);
>  
> +static inline struct mem_cgroup *get_mem_cgroup_from_kmem(void *p)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	do {
> +		memcg = mem_cgroup_from_obj(p);
> +	} while (memcg && !css_tryget(&memcg->css));
> +	rcu_read_unlock();
> +	return memcg;
> +}

Please, rename it to get_mem_cgroup_from_obj() for consistency.

> +
> +static inline struct mem_cgroup *get_net_memcg(void *p)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	memcg = get_mem_cgroup_from_kmem(p);
> +
> +	if (!memcg)
> +		memcg = root_mem_cgroup;
> +
> +	return memcg;
> +}

I'm not a fan of this helper: it has nothing to do with the networking,
actually it's a wrapper of get_mem_cgroup_from_kmem() replacing NULL
with root_mem_cgroup.

Overall the handling of root_mem_cgroup is very messy, I don't blame
this patch. But I wonder if it's better to simple move this code
to the call site without introducing a new function?

Alternatively, you can introduce something like:
struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
{
	return memcg ? memcg : root_mem_cgroup;
}

>  #else
>  static inline bool mem_cgroup_kmem_disabled(void)
>  {
> @@ -1763,9 +1786,13 @@ static inline void memcg_put_cache_ids(void)
>  
>  static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
>  {
> -       return NULL;
> +	return NULL;
>  }
>  
> +static inline struct mem_cgroup *get_net_memcg(void *p)
> +{
> +	return NULL;
> +}
>  #endif /* CONFIG_MEMCG_KMEM */
>  
>  #endif /* _LINUX_MEMCONTROL_H */
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index a5b5bb99c644..3093b4d5b2b9 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -26,6 +26,7 @@
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
>  
> +#include <linux/sched/mm.h>
>  /*
>   *	Our network namespace constructor/destructor lists
>   */
> @@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
>  		 * setup_net() and cleanup_net() are not possible.
>  		 */
>  		for_each_net(net) {
> +			struct mem_cgroup *old, *memcg;
> +
> +			memcg = get_net_memcg(net);
> +			old = set_active_memcg(memcg);
>  			error = ops_init(ops, net);
> +			set_active_memcg(old);
> +			mem_cgroup_put(memcg);
>  			if (error)
>  				goto out_undo;
>  			list_add_tail(&net->exit_list, &net_exit_list);
> -- 
> 2.31.1
> 

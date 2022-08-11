Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8675904BC
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbiHKQoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbiHKQoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:44:02 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EF2AB06B;
        Thu, 11 Aug 2022 09:16:51 -0700 (PDT)
Date:   Thu, 11 Aug 2022 09:16:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660234609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d9Knayh1uWBTa8dQn7LG9+/Wpow1M6VlJCr9CzUjIEk=;
        b=LGxJvmFFgkBq6tKpWN+qREjF/ahVy7BWm7keZmAcKgbf9/nmwmslHS6buM+/C3LNWpiuBb
        5sVDQmF7csohvsiNso5Vfjiok+f1fTb/KoWo5g58qWSZfEMYvDVw9rcNuWrkJMyNJhvwML
        Dj8xrlZ59L0I+SBmpHEWxwDCmuhHQs0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, shakeelb@google.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH bpf-next 13/15] mm, memcg: Add new helper
 get_obj_cgroup_from_cgroup
Message-ID: <YvUrXLJF6qrGOdjP@P9FQF9L96D.corp.robot.car>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
 <20220810151840.16394-14-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810151840.16394-14-laoar.shao@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 03:18:38PM +0000, Yafang Shao wrote:
> Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
> a specific cgroup.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/memcontrol.h |  1 +
>  mm/memcontrol.c            | 41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 2f0a611..901a921 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1713,6 +1713,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
>  int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
>  void __memcg_kmem_uncharge_page(struct page *page, int order);
>  
> +struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
>  struct obj_cgroup *get_obj_cgroup_from_current(void);
>  struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 618c366..762cffa 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2908,6 +2908,47 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
>  	return objcg;
>  }
>  
> +static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> +{
> +	struct obj_cgroup *objcg;
> +
> +	if (memcg_kmem_bypass())
> +		return NULL;
> +
> +	rcu_read_lock();
> +	objcg = __get_obj_cgroup_from_memcg(memcg);
> +	rcu_read_unlock();
> +	return objcg;

This code doesn't make sense to me. What does rcu read lock protect here?

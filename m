Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BFC59056F
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 19:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiHKRMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 13:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbiHKRLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 13:11:55 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C25E4B0E1;
        Thu, 11 Aug 2022 09:48:57 -0700 (PDT)
Date:   Thu, 11 Aug 2022 09:48:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660236536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9LRo2B5nHj7qM/j+ODxu8goN8T5MUtYCM7InUsCq2KI=;
        b=QrHjuwkWBAVOoNWWQtFUTtWsJO8fBsXjFDLsF1uNes86BAdWeJERAv5peXjCSGyRAeQi3G
        dZbC6j7ZYIV2X1KigwRp3M/GL/o6e9ZXBMy6oHZs20yvbM9tkVJcPH4eWlbuFKNqDuqqoE
        z643F+KyM7TrQ1iWqYEa7uVhv0UPS9Y=
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
Subject: Re: [PATCH bpf-next 05/15] bpf: Fix incorrect mem_cgroup_put
Message-ID: <YvUy5IA+XJp7ylIC@P9FQF9L96D.corp.robot.car>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
 <20220810151840.16394-6-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810151840.16394-6-laoar.shao@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 03:18:30PM +0000, Yafang Shao wrote:
> The memcg may be the root_mem_cgroup, in which case we shouldn't put it.
> So a new helper bpf_map_put_memcg() is introduced to pair with
> bpf_map_get_memcg().
> 
> Fixes: 4201d9ab3e42 ("bpf: reparent bpf maps on memcg offlining")
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  kernel/bpf/syscall.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 83c7136..51ab8b1 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -441,6 +441,14 @@ static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
>  	return root_mem_cgroup;
>  }
>  
> +static void bpf_map_put_memcg(struct mem_cgroup *memcg)
> +{
> +	if (mem_cgroup_is_root(memcg))
> +		return;
> +
> +	mem_cgroup_put(memcg);
> +}

+1 to what Shakeel said. mem_cgroup_put(root_mem_cgroup) is totally valid.
So this change does absolutely nothing.

The fixes tag assumes there is a bug in the existing code. If so, please,
describe the problem and how to reproduce it.

Also, if it's not related to the rest of the patchset, please, send it
separately.

Thanks!

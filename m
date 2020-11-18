Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DB72B72D5
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgKRAGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:06:22 -0500
Received: from www62.your-server.de ([213.133.104.62]:39952 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgKRAGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:06:21 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kfAzJ-0006H4-Us; Wed, 18 Nov 2020 01:06:17 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kfAzJ-000NB8-OE; Wed, 18 Nov 2020 01:06:17 +0100
Subject: Re: [PATCH bpf-next v6 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
To:     Roman Gushchin <guro@fb.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, netdev@vger.kernel.org, andrii@kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <20201117034108.1186569-1-guro@fb.com>
 <20201117034108.1186569-7-guro@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <41eb5e5b-e651-4cb3-a6ea-9ff6b8aa41fb@iogearbox.net>
Date:   Wed, 18 Nov 2020 01:06:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201117034108.1186569-7-guro@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25991/Tue Nov 17 14:12:35 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/20 4:40 AM, Roman Gushchin wrote:
> In the absolute majority of cases if a process is making a kernel
> allocation, it's memory cgroup is getting charged.
> 
> Bpf maps can be updated from an interrupt context and in such
> case there is no process which can be charged. It makes the memory
> accounting of bpf maps non-trivial.
> 
> Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
> memcg accounting from interrupt contexts") and b87d8cefe43c
> ("mm, memcg: rework remote charging API to support nesting")
> it's finally possible.
> 
> To do it, a pointer to the memory cgroup of the process which created
> the map is saved, and this cgroup is getting charged for all
> allocations made from an interrupt context.
> 
> Allocations made from a process context will be accounted in a usual way.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>
[...]
>   
> +#ifdef CONFIG_MEMCG_KMEM
> +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> +						 void *value, u64 flags)
> +{
> +	struct mem_cgroup *old_memcg;
> +	bool in_interrupt;
> +	int ret;
> +
> +	/*
> +	 * If update from an interrupt context results in a memory allocation,
> +	 * the memory cgroup to charge can't be determined from the context
> +	 * of the current task. Instead, we charge the memory cgroup, which
> +	 * contained a process created the map.
> +	 */
> +	in_interrupt = in_interrupt();
> +	if (in_interrupt)
> +		old_memcg = set_active_memcg(map->memcg);
> +
> +	ret = map->ops->map_update_elem(map, key, value, flags);
> +
> +	if (in_interrupt)
> +		set_active_memcg(old_memcg);
> +
> +	return ret;

Hmm, this approach here won't work, see also commit 09772d92cd5a ("bpf: avoid
retpoline for lookup/update/delete calls on maps") which removes the indirect
call, so the __bpf_map_update_elem() and therefore the set_active_memcg() is
not invoked for the vast majority of cases.

> +}
> +#else
> +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> +						 void *value, u64 flags)
> +{
> +	return map->ops->map_update_elem(map, key, value, flags);
> +}
> +#endif
> +
>   BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
>   	   void *, value, u64, flags)
>   {
>   	WARN_ON_ONCE(!rcu_read_lock_held());
> -	return map->ops->map_update_elem(map, key, value, flags);
> +
> +	return __bpf_map_update_elem(map, key, value, flags);
>   }
>   
>   const struct bpf_func_proto bpf_map_update_elem_proto = {
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index f3fe9f53f93c..2d77fc2496da 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -31,6 +31,7 @@
>   #include <linux/poll.h>
>   #include <linux/bpf-netns.h>
>   #include <linux/rcupdate_trace.h>
> +#include <linux/memcontrol.h>
>   
>   #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
>   			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> @@ -456,6 +457,27 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
>   		__release(&map_idr_lock);
>   }
>   
> +#ifdef CONFIG_MEMCG_KMEM
> +static void bpf_map_save_memcg(struct bpf_map *map)
> +{
> +	map->memcg = get_mem_cgroup_from_mm(current->mm);
> +}
> +
> +static void bpf_map_release_memcg(struct bpf_map *map)
> +{
> +	mem_cgroup_put(map->memcg);
> +}
> +
> +#else
> +static void bpf_map_save_memcg(struct bpf_map *map)
> +{
> +}
> +
> +static void bpf_map_release_memcg(struct bpf_map *map)
> +{
> +}
> +#endif
> +
>   /* called from workqueue */
>   static void bpf_map_free_deferred(struct work_struct *work)
>   {
> @@ -464,6 +486,7 @@ static void bpf_map_free_deferred(struct work_struct *work)
>   
>   	bpf_map_charge_move(&mem, &map->memory);
>   	security_bpf_map_free(map);
> +	bpf_map_release_memcg(map);
>   	/* implementation dependent freeing */
>   	map->ops->map_free(map);
>   	bpf_map_charge_finish(&mem);
> @@ -875,6 +898,8 @@ static int map_create(union bpf_attr *attr)
>   	if (err)
>   		goto free_map_sec;
>   
> +	bpf_map_save_memcg(map);
> +
>   	err = bpf_map_new_fd(map, f_flags);
>   	if (err < 0) {
>   		/* failed to allocate fd.
> 


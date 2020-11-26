Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7742C4BF7
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgKZAVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:21:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:60586 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKZAVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 19:21:46 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ki52c-0008Ew-NG; Thu, 26 Nov 2020 01:21:42 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ki52c-000DtB-F4; Thu, 26 Nov 2020 01:21:42 +0100
Subject: Re: [PATCH bpf-next v8 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
To:     Roman Gushchin <guro@fb.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, netdev@vger.kernel.org, andrii@kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        hannes@cmpxchg.org, tj@kernel.org
References: <20201125030119.2864302-1-guro@fb.com>
 <20201125030119.2864302-7-guro@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ef140167-8d80-c581-318c-36c0430e4cfa@iogearbox.net>
Date:   Thu, 26 Nov 2020 01:21:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201125030119.2864302-7-guro@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25999/Wed Nov 25 15:06:38 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/20 4:00 AM, Roman Gushchin wrote:
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
> To do it, a pointer to the memory cgroup of the process, which created
> the map, is saved, and this cgroup can be charged for all allocations
> made from an interrupt context. This commit introduces 2 helpers:
> bpf_map_kmalloc_node() and bpf_map_alloc_percpu(). They can be used in
> the bpf code for accounted memory allocations, both in the process and
> interrupt contexts. In the interrupt context they're using the saved
> memory cgroup, otherwise the current cgroup is getting charged.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>

Thanks for updating the cover letter; replying in this series instead
on one more item that came to mind:

[...]
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index f3fe9f53f93c..4154c616788c 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -31,6 +31,8 @@
>   #include <linux/poll.h>
>   #include <linux/bpf-netns.h>
>   #include <linux/rcupdate_trace.h>
> +#include <linux/memcontrol.h>
> +#include <linux/sched/mm.h>
>   
>   #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
>   			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> @@ -456,6 +458,77 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
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
> +void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
> +			   int node)
> +{
> +	struct mem_cgroup *old_memcg;
> +	bool in_interrupt;
> +	void *ptr;
> +
> +	/*
> +	 * If the memory allocation is performed from an interrupt context,
> +	 * the memory cgroup to charge can't be determined from the context
> +	 * of the current task. Instead, we charge the memory cgroup, which
> +	 * contained the process created the map.
> +	 */
> +	in_interrupt = in_interrupt();
> +	if (in_interrupt)
> +		old_memcg = set_active_memcg(map->memcg);
> +
> +	ptr = kmalloc_node(size, flags, node);
> +
> +	if (in_interrupt)
> +		set_active_memcg(old_memcg);
> +
> +	return ptr;
> +}
> +
> +void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
> +				    size_t align, gfp_t gfp)
> +{
> +	struct mem_cgroup *old_memcg;
> +	bool in_interrupt;
> +	void *ptr;
> +
> +	/*
> +	 * If the memory allocation is performed from an interrupt context,
> +	 * the memory cgroup to charge can't be determined from the context
> +	 * of the current task. Instead, we charge the memory cgroup, which
> +	 * contained the process created the map.
> +	 */
> +	in_interrupt = in_interrupt();
> +	if (in_interrupt)
> +		old_memcg = set_active_memcg(map->memcg);
> +
> +	ptr = __alloc_percpu_gfp(size, align, gfp);
> +
> +	if (in_interrupt)
> +		set_active_memcg(old_memcg);

For this and above bpf_map_kmalloc_node() one, wouldn't it make more sense to
perform the temporary memcg unconditionally?

	old_memcg = set_active_memcg(map->memcg);
	ptr = kmalloc_node(size, flags, node);
	set_active_memcg(old_memcg);

I think the semantics are otherwise a bit weird and the charging unpredictable;
this way it would /always/ be accounted against the prog in the memcg that
originally created the map.

E.g. maps could be shared between progs attached to, say, XDP/tc where in_interrupt()
holds true with progs attached to skb-cgroup/egress where we're still in process
context. So some part of the memory is charged against the original map's memcg and
some other part against the current process' memcg which seems odd, no? Or, for example,
if we start to run a tracing BPF prog which updates state in a BPF map ... that tracing
prog now interferes with processes in other memcgs which may not be intentional & could
lead to potential failures there as opposed when the tracing prog is not run. My concern
is that the semantics are not quite clear and behavior unpredictable compared to always
charging against map->memcg.

Similarly, what if an orchestration prog creates dedicated memcg(s) for maps with
individual limits ... the assumed behavior (imho) would be that whatever memory is
accounted on the map it can be accurately retrieved from there & similarly limits
enforced, no? It seems that would not be the case currently.

Thoughts?

> +	return ptr;
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
> @@ -464,6 +537,7 @@ static void bpf_map_free_deferred(struct work_struct *work)
>   
>   	bpf_map_charge_move(&mem, &map->memory);
>   	security_bpf_map_free(map);
> +	bpf_map_release_memcg(map);
>   	/* implementation dependent freeing */
>   	map->ops->map_free(map);
>   	bpf_map_charge_finish(&mem);
> @@ -875,6 +949,8 @@ static int map_create(union bpf_attr *attr)
>   	if (err)
>   		goto free_map_sec;
>   
> +	bpf_map_save_memcg(map);
> +
>   	err = bpf_map_new_fd(map, f_flags);
>   	if (err < 0) {
>   		/* failed to allocate fd.
> 


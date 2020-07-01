Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335F62116B7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgGAXjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:39:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:46244 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgGAXjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 19:39:44 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqmKL-0003z1-H3; Thu, 02 Jul 2020 01:39:41 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqmKL-000HRJ-8B; Thu, 02 Jul 2020 01:39:41 +0200
Subject: Re: [PATCH v5 bpf-next 5/9] bpf: cpumap: add the possibility to
 attach an eBPF program to cpumap
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        toke@redhat.com, lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com
References: <cover.1593521029.git.lorenzo@kernel.org>
 <a6bb83a429f3b073e97f81ec3935b8ebe89fbd71.1593521030.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1f4af1f3-10cf-57ca-4171-11d3bff51c99@iogearbox.net>
Date:   Thu, 2 Jul 2020 01:39:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a6bb83a429f3b073e97f81ec3935b8ebe89fbd71.1593521030.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25860/Wed Jul  1 15:40:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 2:49 PM, Lorenzo Bianconi wrote:
[...]
> +static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
> +				    void **frames, int n,
> +				    struct xdp_cpumap_stats *stats)
> +{
> +	struct xdp_rxq_info rxq;
> +	struct bpf_prog *prog;
> +	struct xdp_buff xdp;
> +	int i, nframes = 0;
> +
> +	if (!rcpu->prog)
> +		return n;
> +
> +	rcu_read_lock();
> +
> +	xdp_set_return_frame_no_direct();
> +	xdp.rxq = &rxq;
> +
> +	prog = READ_ONCE(rcpu->prog);
> +	for (i = 0; i < n; i++) {
> +		struct xdp_frame *xdpf = frames[i];
> +		u32 act;
> +		int err;
> +
> +		rxq.dev = xdpf->dev_rx;
> +		rxq.mem = xdpf->mem;
> +		/* TODO: report queue_index to xdp_rxq_info */
> +
> +		xdp_convert_frame_to_buff(xdpf, &xdp);
> +
> +		act = bpf_prog_run_xdp(prog, &xdp);
> +		switch (act) {
> +		case XDP_PASS:
> +			err = xdp_update_frame_from_buff(&xdp, xdpf);
> +			if (err < 0) {
> +				xdp_return_frame(xdpf);
> +				stats->drop++;
> +			} else {
> +				frames[nframes++] = xdpf;
> +				stats->pass++;
> +			}
> +			break;
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			/* fallthrough */
> +		case XDP_DROP:
> +			xdp_return_frame(xdpf);
> +			stats->drop++;
> +			break;
> +		}
> +	}
> +
> +	xdp_clear_return_frame_no_direct();
> +
> +	rcu_read_unlock();
> +
> +	return nframes;
> +}
> +
>   #define CPUMAP_BATCH 8
>   
>   static int cpu_map_kthread_run(void *data)
> @@ -235,11 +297,12 @@ static int cpu_map_kthread_run(void *data)
>   	 * kthread_stop signal until queue is empty.
>   	 */
>   	while (!kthread_should_stop() || !__ptr_ring_empty(rcpu->queue)) {
> +		struct xdp_cpumap_stats stats = {}; /* zero stats */
> +		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
>   		unsigned int drops = 0, sched = 0;
>   		void *frames[CPUMAP_BATCH];
>   		void *skbs[CPUMAP_BATCH];
> -		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
> -		int i, n, m;
> +		int i, n, m, nframes;
>   
>   		/* Release CPU reschedule checks */
>   		if (__ptr_ring_empty(rcpu->queue)) {
> @@ -260,8 +323,8 @@ static int cpu_map_kthread_run(void *data)
>   		 * kthread CPU pinned. Lockless access to ptr_ring
>   		 * consume side valid as no-resize allowed of queue.
>   		 */
> -		n = __ptr_ring_consume_batched(rcpu->queue, frames, CPUMAP_BATCH);
> -
> +		n = __ptr_ring_consume_batched(rcpu->queue, frames,
> +					       CPUMAP_BATCH);
>   		for (i = 0; i < n; i++) {
>   			void *f = frames[i];
>   			struct page *page = virt_to_page(f);
> @@ -273,15 +336,19 @@ static int cpu_map_kthread_run(void *data)
>   			prefetchw(page);
>   		}
>   
> -		m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, n, skbs);
> -		if (unlikely(m == 0)) {
> -			for (i = 0; i < n; i++)
> -				skbs[i] = NULL; /* effect: xdp_return_frame */
> -			drops = n;
> +		/* Support running another XDP prog on this CPU */
> +		nframes = cpu_map_bpf_prog_run_xdp(rcpu, frames, n, &stats);
> +		if (nframes) {
> +			m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, skbs);
> +			if (unlikely(m == 0)) {
> +				for (i = 0; i < nframes; i++)
> +					skbs[i] = NULL; /* effect: xdp_return_frame */
> +				drops += nframes;
> +			}
>   		}
>   
>   		local_bh_disable();
> -		for (i = 0; i < n; i++) {
> +		for (i = 0; i < nframes; i++) {
>   			struct xdp_frame *xdpf = frames[i];
>   			struct sk_buff *skb = skbs[i];
>   			int ret;
> @@ -298,7 +365,7 @@ static int cpu_map_kthread_run(void *data)
>   				drops++;
>   		}
>   		/* Feedback loop via tracepoint */
> -		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched);
> +		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);
>   
>   		local_bh_enable(); /* resched point, may call do_softirq() */
>   	}
> @@ -308,13 +375,38 @@ static int cpu_map_kthread_run(void *data)
>   	return 0;
>   }
[...]
> @@ -415,6 +510,8 @@ static void __cpu_map_entry_replace(struct bpf_cpu_map *cmap,
>   
>   	old_rcpu = xchg(&cmap->cpu_map[key_cpu], rcpu);
>   	if (old_rcpu) {
> +		if (old_rcpu->prog)
> +			bpf_prog_put(old_rcpu->prog);
>   		call_rcu(&old_rcpu->rcu, __cpu_map_entry_free);
>   		INIT_WORK(&old_rcpu->kthread_stop_wq, cpu_map_kthread_stop);
>   		schedule_work(&old_rcpu->kthread_stop_wq);

Hm, not quite sure I follow the logic here. Why is the bpf_prog_put() not placed inside
__cpu_map_entry_free(), for example? Wouldn't this at least leave a potential small race
window of UAF given the rest is still live? If we already piggy-back from RCU side on
rcpu entry, why not having it in __cpu_map_entry_free()?

Thanks,
Daniel

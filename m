Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6706421166F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgGAXCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:02:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:43310 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGAXCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 19:02:36 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqlkJ-0007yr-JA; Thu, 02 Jul 2020 01:02:27 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqlkJ-000J0J-B6; Thu, 02 Jul 2020 01:02:27 +0200
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
Message-ID: <cb2f7b80-7c0f-4f96-6285-87cc615c7484@iogearbox.net>
Date:   Thu, 2 Jul 2020 01:02:26 +0200
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
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 52d71525c2ff..0ac7b11302c2 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -226,6 +226,7 @@ enum bpf_attach_type {
>   	BPF_CGROUP_INET4_GETSOCKNAME,
>   	BPF_CGROUP_INET6_GETSOCKNAME,
>   	BPF_XDP_DEVMAP,
> +	BPF_XDP_CPUMAP,
>   	__MAX_BPF_ATTACH_TYPE
>   };
>   
> @@ -3819,6 +3820,10 @@ struct bpf_devmap_val {
>    */
>   struct bpf_cpumap_val {
>   	__u32 qsize;	/* queue size to remote target CPU */
> +	union {
> +		int   fd;	/* prog fd on map write */
> +		__u32 id;	/* prog id on map read */
> +	} bpf_prog;
>   };
>   
>   enum sk_action {
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 7e8eec4f7089..32f627bfc67c 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -67,6 +67,7 @@ struct bpf_cpu_map_entry {
>   	struct rcu_head rcu;
>   
>   	struct bpf_cpumap_val value;
> +	struct bpf_prog *prog;
>   };
>   
>   struct bpf_cpu_map {
> @@ -81,6 +82,7 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq);
>   
>   static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
>   {
> +	u32 value_size = attr->value_size;
>   	struct bpf_cpu_map *cmap;
>   	int err = -ENOMEM;
>   	u64 cost;
> @@ -91,7 +93,9 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
>   
>   	/* check sanity of attributes */
>   	if (attr->max_entries == 0 || attr->key_size != 4 ||
> -	    attr->value_size != 4 || attr->map_flags & ~BPF_F_NUMA_NODE)
> +	    (value_size != offsetofend(struct bpf_cpumap_val, qsize) &&
> +	     value_size != offsetofend(struct bpf_cpumap_val, bpf_prog.fd)) ||
> +	    attr->map_flags & ~BPF_F_NUMA_NODE)
>   		return ERR_PTR(-EINVAL);
>   
>   	cmap = kzalloc(sizeof(*cmap), GFP_USER);
> @@ -221,6 +225,64 @@ static void put_cpu_map_entry(struct bpf_cpu_map_entry *rcpu)
>   	}
>   }
>   
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

What purpose does the READ_ONCE() have here, also given you don't use it in above check?
Since upon map update you realloc, repopulate and then xchg() the rcpu entry itself, there
is never the case where you xchg() or WRITE_ONCE() the rcpu->prog, so what does READ_ONCE()
serve in this context? Imho, it should probably just be deleted and plain rcpu->prog used
to avoid confusion.

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
[...]
> +bool cpu_map_prog_allowed(struct bpf_map *map)
> +{
> +	return map->map_type == BPF_MAP_TYPE_CPUMAP &&
> +	       map->value_size != offsetofend(struct bpf_cpumap_val, qsize);
> +}
> +
> +static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu, int fd)
> +{
> +	struct bpf_prog *prog;
> +
> +	prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, false);

Nit: why the _dev variant; just use bpf_prog_get_type()?

> +	if (IS_ERR(prog))
> +		return PTR_ERR(prog);
> +
> +	if (prog->expected_attach_type != BPF_XDP_CPUMAP) {
> +		bpf_prog_put(prog);
> +		return -EINVAL;
> +	}
> +
> +	rcpu->value.bpf_prog.id = prog->aux->id;
> +	rcpu->prog = prog;
> +
> +	return 0;
> +}
> +

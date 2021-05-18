Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CAF388178
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352165AbhERUiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:38:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:59608 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbhERUiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 16:38:18 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lj6SV-000AIH-42; Tue, 18 May 2021 22:36:55 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lj6SU-000U5f-OU; Tue, 18 May 2021 22:36:54 +0200
Subject: Re: [PATCH RESEND v11 2/4] xdp: extend xdp_redirect_map with
 broadcast support
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20210513070447.1878448-1-liuhangbin@gmail.com>
 <20210513070447.1878448-3-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e5b02fa9-8b8a-bdc3-1cc3-29d4aa8d5d16@iogearbox.net>
Date:   Tue, 18 May 2021 22:36:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210513070447.1878448-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26174/Tue May 18 13:09:02 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/21 9:04 AM, Hangbin Liu wrote:
> This patch adds two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to
> extend xdp_redirect_map for broadcast support.

Just few minor bits, other than that it's good to go, imho:

> -static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex, u64 flags,
> +static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex,
> +						  u64 flags, u64 flag_mask,

nit: const u64 flag_mask

>   						  void *lookup_elem(struct bpf_map *map, u32 key))
>   {
>   	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>   
>   	/* Lower bits of the flags are used as return code on lookup failure */
> -	if (unlikely(flags > XDP_TX))
> +	if (unlikely(flags & ~(BPF_F_ACTION_MASK | flag_mask)))
>   		return XDP_ABORTED;
>   
>   	ri->tgt_value = lookup_elem(map, ifindex);
> -	if (unlikely(!ri->tgt_value)) {
> +	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
>   		/* If the lookup fails we want to clear out the state in the
>   		 * redirect_info struct completely, so that if an eBPF program
>   		 * performs multiple lookups, the last one always takes
> @@ -1482,13 +1484,21 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
>   		 */
>   		ri->map_id = INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
>   		ri->map_type = BPF_MAP_TYPE_UNSPEC;
> -		return flags;
> +		return flags & BPF_F_ACTION_MASK;
>   	}
>   
>   	ri->tgt_index = ifindex;
>   	ri->map_id = map->id;
>   	ri->map_type = map->map_type;
>   
> +	if (flags & BPF_F_BROADCAST) {
> +		WRITE_ONCE(ri->map, map);
> +		ri->flags = flags;
> +	} else {
> +		WRITE_ONCE(ri->map, NULL);
> +		ri->flags = 0;
> +	}
> +
>   	return XDP_REDIRECT;
>   }
>   
[...]
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ec6d85a81744..78d1ec401b3a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2534,8 +2534,12 @@ union bpf_attr {
>    * 		The lower two bits of *flags* are used as the return code if
>    * 		the map lookup fails. This is so that the return value can be
>    * 		one of the XDP program return codes up to **XDP_TX**, as chosen
> - * 		by the caller. Any higher bits in the *flags* argument must be
> - * 		unset.
> + * 		by the caller. The higher bits of *flags* can be set to
> + * 		BPF_F_BROADCAST or BPF_F_EXCLUDE_INGRESS as defined below.
> + *
> + * 		With BPF_F_BROADCAST the packet will be broadcasted to all the
> + * 		interfaces in the map. with BPF_F_EXCLUDE_INGRESS the ingress

nit: in the map, with

> + * 		interface will be excluded when do broadcasting.
>    *
>    * 		See also **bpf_redirect**\ (), which only supports redirecting
>    * 		to an ifindex, but doesn't require a map to do so.
> @@ -5080,6 +5084,14 @@ enum {
>   	BPF_F_BPRM_SECUREEXEC	= (1ULL << 0),
>   };
>   
> +/* Flags for bpf_redirect_map helper */
> +enum {
> +	BPF_F_BROADCAST		= (1ULL << 3),
> +	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
> +};
> +
> +#define BPF_F_ACTION_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)

Why do we need to expose BPF_F_ACTION_MASK into the uapi header here?

My understanding is that this is only needed kernel-internal (and therefore
the mask itself has no meaning for a user)?

>   #define __bpf_md_ptr(type, name)	\
>   union {					\
>   	type name;			\
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 5dd3e866599a..a1a0c4e791c6 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -601,7 +601,8 @@ static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
>   
>   static int cpu_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
>   {
> -	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_elem);
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
> +				      __cpu_map_lookup_elem);
>   }
>   
>   static int cpu_map_btf_id;
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 3980fb3bfb09..5262a62355a1 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -198,6 +198,7 @@ static void dev_map_free(struct bpf_map *map)
>   	list_del_rcu(&dtab->list);
>   	spin_unlock(&dev_map_lock);
>   
> +	bpf_clear_redirect_map(map);
>   	synchronize_rcu();
>   
>   	/* Make sure prior __dev_map_entry_free() have completed. */
> @@ -515,6 +516,99 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>   	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
>   }
>   
> +static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_buff *xdp,
> +			 int exclude_ifindex)
> +{
> +	if (!obj || obj->dev->ifindex == exclude_ifindex ||
> +	    !obj->dev->netdev_ops->ndo_xdp_xmit)
> +		return false;
> +
> +	if (xdp_ok_fwd_dev(obj->dev, xdp->data_end - xdp->data))
> +		return false;
> +
> +	return true;
> +}
> +
> +static int dev_map_enqueue_clone(struct bpf_dtab_netdev *obj,
> +				 struct net_device *dev_rx,
> +				 struct xdp_frame *xdpf)
> +{
> +	struct xdp_frame *nxdpf;
> +
> +	nxdpf = xdpf_clone(xdpf);
> +	if (!nxdpf)
> +		return -ENOMEM;
> +
> +	bq_enqueue(obj->dev, nxdpf, dev_rx, obj->xdp_prog);
> +
> +	return 0;
> +}
> +
[...]
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 858276e72c68..b33f4c4b6d65 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -584,3 +584,32 @@ struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>   	return __xdp_build_skb_from_frame(xdpf, skb, dev);
>   }
>   EXPORT_SYMBOL_GPL(xdp_build_skb_from_frame);
> +
> +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
> +{
> +	unsigned int headroom, totalsize;
> +	struct xdp_frame *nxdpf;
> +	struct page *page;
> +	void *addr;
> +
> +	headroom = xdpf->headroom + sizeof(*xdpf);
> +	totalsize = headroom + xdpf->len;
> +
> +	if (unlikely(totalsize > PAGE_SIZE))
> +		return NULL;
> +	page = dev_alloc_page();
> +	if (!page)
> +		return NULL;
> +	addr = page_to_virt(page);
> +
> +	memcpy(addr, xdpf, totalsize);
> +
> +	nxdpf = addr;
> +	nxdpf->data = addr + headroom;
> +	nxdpf->frame_sz = PAGE_SIZE;
> +	nxdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
> +	nxdpf->mem.id = 0;
> +
> +	return nxdpf;
> +}
> +EXPORT_SYMBOL_GPL(xdpf_clone);

This doesn't have a module user, why it needs to be exported?

> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> index 67b4ce504852..9df75ea4a567 100644
> --- a/net/xdp/xskmap.c
> +++ b/net/xdp/xskmap.c
> @@ -226,7 +226,8 @@ static int xsk_map_delete_elem(struct bpf_map *map, void *key)
>   
>   static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
>   {
> -	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_elem);
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
> +				      __xsk_map_lookup_elem);
>   }
>   
>   void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,

Thanks,
Daniel

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019E42CC991
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgLBWYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:24:35 -0500
Received: from www62.your-server.de ([213.133.104.62]:44946 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbgLBWYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:24:35 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkaXQ-0006sH-Ua; Wed, 02 Dec 2020 23:23:52 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kkaXQ-000Xh6-M4; Wed, 02 Dec 2020 23:23:52 +0100
Subject: Re: [PATCH bpf-next V8 3/8] bpf: bpf_fib_lookup return MTU value as
 output when looked up
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
 <160650039275.2890576.7191201185534571391.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c68ebe46-9359-f9af-85e8-1694db5fdc21@iogearbox.net>
Date:   Wed, 2 Dec 2020 23:23:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160650039275.2890576.7191201185534571391.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26006/Wed Dec  2 14:14:18 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/20 7:06 PM, Jesper Dangaard Brouer wrote:
> The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_lookup)
> can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED.  The BPF-prog
> don't know the MTU value that caused this rejection.
> 
> If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) it
> need to know this MTU value for the ICMP packet.
> 
> Patch change lookup and result struct bpf_fib_lookup, to contain this MTU
> value as output via a union with 'tot_len' as this is the value used for
> the MTU lookup.
> 
> V5:
>   - Fixed uninit value spotted by Dan Carpenter.
>   - Name struct output member mtu_result
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/uapi/linux/bpf.h       |   11 +++++++++--
>   net/core/filter.c              |   22 +++++++++++++++-------
>   tools/include/uapi/linux/bpf.h |   11 +++++++++--
>   3 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c3458ec1f30a..848398bd5a54 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2220,6 +2220,9 @@ union bpf_attr {
>    *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
>    *		  packet is not forwarded or needs assist from full stack
>    *
> + *		If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
> + *		was exceeded and output params->mtu_result contains the MTU.
> + *
>    * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
>    *	Description
>    *		Add an entry to, or update a sockhash *map* referencing sockets.
> @@ -4961,9 +4964,13 @@ struct bpf_fib_lookup {
>   	__be16	sport;
>   	__be16	dport;
>   
> -	/* total length of packet from network header - used for MTU check */
> -	__u16	tot_len;
> +	union {	/* used for MTU check */
> +		/* input to lookup */
> +		__u16	tot_len; /* L3 length from network hdr (iph->tot_len) */
>   
> +		/* output: MTU value */
> +		__u16	mtu_result;
> +	};
>   	/* input: L3 device index for lookup
>   	 * output: device index from FIB lookup
>   	 */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 84d77c425fbe..25b137ffdced 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5265,12 +5265,14 @@ static const struct bpf_func_proto bpf_skb_get_xfrm_state_proto = {
>   #if IS_ENABLED(CONFIG_INET) || IS_ENABLED(CONFIG_IPV6)
>   static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params,
>   				  const struct neighbour *neigh,
> -				  const struct net_device *dev)
> +				  const struct net_device *dev, u32 mtu)
>   {
>   	memcpy(params->dmac, neigh->ha, ETH_ALEN);
>   	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
>   	params->h_vlan_TCI = 0;
>   	params->h_vlan_proto = 0;
> +	if (mtu)
> +		params->mtu_result = mtu; /* union with tot_len */
>   
>   	return 0;
>   }
> @@ -5286,8 +5288,8 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>   	struct net_device *dev;
>   	struct fib_result res;
>   	struct flowi4 fl4;
> +	u32 mtu = 0;
>   	int err;
> -	u32 mtu;
>   
>   	dev = dev_get_by_index_rcu(net, params->ifindex);
>   	if (unlikely(!dev))
> @@ -5354,8 +5356,10 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>   
>   	if (check_mtu) {
>   		mtu = ip_mtu_from_fib_result(&res, params->ipv4_dst);
> -		if (params->tot_len > mtu)
> +		if (params->tot_len > mtu) {
> +			params->mtu_result = mtu; /* union with tot_len */
>   			return BPF_FIB_LKUP_RET_FRAG_NEEDED;
> +		}
>   	}
>   
>   	nhc = res.nhc;
> @@ -5389,7 +5393,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>   	if (!neigh)
>   		return BPF_FIB_LKUP_RET_NO_NEIGH;
>   
> -	return bpf_fib_set_fwd_params(params, neigh, dev);
> +	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
>   }
>   #endif
>   
> @@ -5406,7 +5410,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>   	struct flowi6 fl6;
>   	int strict = 0;
>   	int oif, err;
> -	u32 mtu;
> +	u32 mtu = 0;
>   
>   	/* link local addresses are never forwarded */
>   	if (rt6_need_strict(dst) || rt6_need_strict(src))
> @@ -5481,8 +5485,10 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>   
>   	if (check_mtu) {
>   		mtu = ipv6_stub->ip6_mtu_from_fib6(&res, dst, src);
> -		if (params->tot_len > mtu)
> +		if (params->tot_len > mtu) {
> +			params->mtu_result = mtu; /* union with tot_len */
>   			return BPF_FIB_LKUP_RET_FRAG_NEEDED;

And with mentioned approach from [0] we also only ever need to set the above,
but we don't need to drag it anywhere else via bpf_fib_set_fwd_params() with
the extra zero check on mtu. So this should simplify this one as well.

   [0] https://lore.kernel.org/bpf/6f9cac4e-a231-ff8d-43a5-828995ca5ec7@iogearbox.net/

> +		}
>   	}
>   
>   	if (res.nh->fib_nh_lws)
> @@ -5502,7 +5508,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>   	if (!neigh)
>   		return BPF_FIB_LKUP_RET_NO_NEIGH;
>   
> -	return bpf_fib_set_fwd_params(params, neigh, dev);
> +	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);

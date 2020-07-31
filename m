Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764B5234CB9
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 23:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgGaVMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 17:12:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:43882 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgGaVMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 17:12:40 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1cKK-00049O-GM; Fri, 31 Jul 2020 23:12:28 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1cKK-000UPi-51; Fri, 31 Jul 2020 23:12:28 +0200
Subject: Re: [RFC PATCH bpf-next 2/3] bpf: Add helper to do forwarding lookups
 in kernel FDB table
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        bpf@vger.kernel.org
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <1596170660-5582-3-git-send-email-komachi.yoshiki@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9420fbc2-3139-f23e-fb6b-e3d28b9bee5f@iogearbox.net>
Date:   Fri, 31 Jul 2020 23:12:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1596170660-5582-3-git-send-email-komachi.yoshiki@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25890/Fri Jul 31 17:04:57 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 6:44 AM, Yoshiki Komachi wrote:
> This patch adds a new bpf helper to access FDB in the kernel tables
> from XDP programs. The helper enables us to find the destination port
> of master bridge in XDP layer with high speed. If an entry in the
> tables is successfully found, egress device index will be returned.
> 
> In cases of failure, packets will be dropped or forwarded to upper
> networking stack in the kernel by XDP programs. Multicast and broadcast
> packets are currently not supported. Thus, these will need to be
> passed to upper layer on the basis of XDP_PASS action.
> 
> The API uses destination MAC and VLAN ID as keys, so XDP programs
> need to extract these from forwarded packets.
> 
> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>

Few initial comments below:

> ---
>   include/uapi/linux/bpf.h       | 28 +++++++++++++++++++++
>   net/core/filter.c              | 45 ++++++++++++++++++++++++++++++++++
>   scripts/bpf_helpers_doc.py     |  1 +
>   tools/include/uapi/linux/bpf.h | 28 +++++++++++++++++++++
>   4 files changed, 102 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 54d0c886e3ba..f2e729dd1721 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2149,6 +2149,22 @@ union bpf_attr {
>    *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
>    *		  packet is not forwarded or needs assist from full stack
>    *
> + * long bpf_fdb_lookup(void *ctx, struct bpf_fdb_lookup *params, int plen, u32 flags)
> + *	Description
> + *		Do FDB lookup in kernel tables using parameters in *params*.
> + *		If lookup is successful (ie., FDB lookup finds a destination entry),
> + *		ifindex is set to the egress device index from the FDB lookup.
> + *		Both multicast and broadcast packets are currently unsupported
> + *		in XDP layer.
> + *
> + *		*plen* argument is the size of the passed **struct bpf_fdb_lookup**.
> + *		*ctx* is only **struct xdp_md** for XDP programs.
> + *
> + *     Return
> + *		* < 0 if any input argument is invalid
> + *		*   0 on success (destination port is found)
> + *		* > 0 on failure (there is no entry)
> + *
>    * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
>    *	Description
>    *		Add an entry to, or update a sockhash *map* referencing sockets.
> @@ -3449,6 +3465,7 @@ union bpf_attr {
>   	FN(get_stack),			\
>   	FN(skb_load_bytes_relative),	\
>   	FN(fib_lookup),			\
> +	FN(fdb_lookup),			\

This breaks UAPI. Needs to be added to the very end of the list.

>   	FN(sock_hash_update),		\
>   	FN(msg_redirect_hash),		\
>   	FN(sk_redirect_hash),		\
> @@ -4328,6 +4345,17 @@ struct bpf_fib_lookup {
>   	__u8	dmac[6];     /* ETH_ALEN */
>   };
>   
> +enum {
> +	BPF_FDB_LKUP_RET_SUCCESS,      /* lookup successful */
> +	BPF_FDB_LKUP_RET_NOENT,        /* entry is not found */
> +};
> +
> +struct bpf_fdb_lookup {
> +	unsigned char addr[6];     /* ETH_ALEN */
> +	__u16 vlan_id;
> +	__u32 ifindex;
> +};
> +
>   enum bpf_task_fd_type {
>   	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
>   	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 654c346b7d91..68800d1b8cd5 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -45,6 +45,7 @@
>   #include <linux/filter.h>
>   #include <linux/ratelimit.h>
>   #include <linux/seccomp.h>
> +#include <linux/if_bridge.h>
>   #include <linux/if_vlan.h>
>   #include <linux/bpf.h>
>   #include <linux/btf.h>
> @@ -5084,6 +5085,46 @@ static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
>   	.arg4_type	= ARG_ANYTHING,
>   };
>   
> +#if IS_ENABLED(CONFIG_BRIDGE)
> +BPF_CALL_4(bpf_xdp_fdb_lookup, struct xdp_buff *, ctx,
> +	   struct bpf_fdb_lookup *, params, int, plen, u32, flags)
> +{
> +	struct net_device *src, *dst;
> +	struct net *net;
> +
> +	if (plen < sizeof(*params))
> +		return -EINVAL;

Given flags are not used, this needs to reject anything invalid otherwise
you're not able to extend it in future.

> +	net = dev_net(ctx->rxq->dev);
> +
> +	if (is_multicast_ether_addr(params->addr) ||
> +	    is_broadcast_ether_addr(params->addr))
> +		return BPF_FDB_LKUP_RET_NOENT;
> +
> +	src = dev_get_by_index_rcu(net, params->ifindex);
> +	if (unlikely(!src))
> +		return -ENODEV;
> +
> +	dst = br_fdb_find_port_xdp(src, params->addr, params->vlan_id);
> +	if (dst) {
> +		params->ifindex = dst->ifindex;
> +		return BPF_FDB_LKUP_RET_SUCCESS;
> +	}

Currently the helper description says nothing that this is /only/ limited to
bridges. I think it would be better to also name the helper bpf_br_fdb_lookup()
as well if so to avoid any confusion.

> +	return BPF_FDB_LKUP_RET_NOENT;
> +}
> +
> +static const struct bpf_func_proto bpf_xdp_fdb_lookup_proto = {
> +	.func		= bpf_xdp_fdb_lookup,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type      = ARG_PTR_TO_CTX,
> +	.arg2_type      = ARG_PTR_TO_MEM,
> +	.arg3_type      = ARG_CONST_SIZE,
> +	.arg4_type	= ARG_ANYTHING,
> +};
> +#endif

This should also have a tc pendant (similar as done in routing lookup helper)
in case native XDP is not available. This will be useful for those that have
the same code compilable for both tc/XDP.

>   #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
>   static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len)
>   {
> @@ -6477,6 +6518,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &bpf_xdp_adjust_tail_proto;
>   	case BPF_FUNC_fib_lookup:
>   		return &bpf_xdp_fib_lookup_proto;
> +#if IS_ENABLED(CONFIG_BRIDGE)
> +	case BPF_FUNC_fdb_lookup:
> +		return &bpf_xdp_fdb_lookup_proto;
> +#endif
>   #ifdef CONFIG_INET
>   	case BPF_FUNC_sk_lookup_udp:
>   		return &bpf_xdp_sk_lookup_udp_proto;

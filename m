Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6462344E9
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 13:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732817AbgGaL5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 07:57:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:10744 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732689AbgGaL5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 07:57:35 -0400
IronPort-SDR: BV9KHSTU7kGjIO7SS0u4QIvccKtO9Ulz0tsCs/w1Yk2oM5hkRuXQgHKHJaiz9fXK8pWTcaEcTq
 DA2RJbvnJd9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="213295333"
X-IronPort-AV: E=Sophos;i="5.75,418,1589266800"; 
   d="scan'208";a="213295333"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 04:57:34 -0700
IronPort-SDR: UV5QW84xK48nz9lwg8jlfgUhOqpgtAmFGH6RZt4+t7VUGSTXVddFB3X2WbiBEi6dQ1GAhukv6/
 ke6SHS4Qe82g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,418,1589266800"; 
   d="scan'208";a="304922209"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga002.jf.intel.com with ESMTP; 31 Jul 2020 04:57:30 -0700
Date:   Fri, 31 Jul 2020 13:52:25 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 2/3] bpf: Add helper to do forwarding
 lookups in kernel FDB table
Message-ID: <20200731115225.GA5097@ranger.igk.intel.com>
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <1596170660-5582-3-git-send-email-komachi.yoshiki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596170660-5582-3-git-send-email-komachi.yoshiki@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 01:44:19PM +0900, Yoshiki Komachi wrote:
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
> ---
>  include/uapi/linux/bpf.h       | 28 +++++++++++++++++++++
>  net/core/filter.c              | 45 ++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  1 +
>  tools/include/uapi/linux/bpf.h | 28 +++++++++++++++++++++
>  4 files changed, 102 insertions(+)
> 

[...]

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 654c346b7d91..68800d1b8cd5 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -45,6 +45,7 @@
>  #include <linux/filter.h>
>  #include <linux/ratelimit.h>
>  #include <linux/seccomp.h>
> +#include <linux/if_bridge.h>
>  #include <linux/if_vlan.h>
>  #include <linux/bpf.h>
>  #include <linux/btf.h>
> @@ -5084,6 +5085,46 @@ static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
>  	.arg4_type	= ARG_ANYTHING,
>  };
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
> +
> +	net = dev_net(ctx->rxq->dev);
> +
> +	if (is_multicast_ether_addr(params->addr) ||
> +	    is_broadcast_ether_addr(params->addr))
> +		return BPF_FDB_LKUP_RET_NOENT;

small nit: you could move that validation before dev_net() call.

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
> +
> +	return BPF_FDB_LKUP_RET_NOENT;
> +}

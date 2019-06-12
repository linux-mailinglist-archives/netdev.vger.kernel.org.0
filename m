Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF41642BE4
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbfFLQQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:16:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:43164 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfFLQQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:16:31 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb5vH-0006i5-3G; Wed, 12 Jun 2019 18:16:27 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb5vG-0003em-UF; Wed, 12 Jun 2019 18:16:26 +0200
Subject: Re: [PATCH bpf-next v5 1/4] bpf: sock ops: add netns ino and dev in
 bpf context
To:     =?UTF-8?Q?Iago_L=c3=b3pez_Galeiras?= <iago@kinvolk.io>,
        john.fastabend@gmail.com, ast@kernel.org
Cc:     alban@kinvolk.io, krzesimir@kinvolk.io, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190607141106.32148-1-iago@kinvolk.io>
 <20190607141106.32148-2-iago@kinvolk.io>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d3eeb0f0-b222-1b15-af22-28dfd129771d@iogearbox.net>
Date:   Wed, 12 Jun 2019 18:16:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190607141106.32148-2-iago@kinvolk.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25478/Wed Jun 12 10:14:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2019 04:11 PM, Iago López Galeiras wrote:
> From: Alban Crequy <alban@kinvolk.io>
> 
> sockops programs can now access the network namespace inode and device
> via (struct bpf_sock_ops)->netns_ino and ->netns_dev. This can be useful
> to apply different policies on different network namespaces.
> 
> In the unlikely case where network namespaces are not compiled in
> (CONFIG_NET_NS=n), the verifier will return netns_dev as usual and will
> return 0 for netns_ino.
> 
> The generated BPF bytecode for netns_ino is loading the correct inode
> number at the time of execution.
> 
> However, the generated BPF bytecode for netns_dev is loading an
> immediate value determined at BPF-load-time by looking at the initial
> network namespace. In practice, this works because all netns currently
> use the same virtual device. If this was to change, this code would need
> to be updated too.
> 
> Co-authored-by: Iago López Galeiras <iago@kinvolk.io>
> Signed-off-by: Alban Crequy <alban@kinvolk.io>
> Signed-off-by: Iago López Galeiras <iago@kinvolk.io>
> 
> ---
> 
> Changes since v1:
> - add netns_dev (review from Alexei)
> 
> Changes since v2:
> - replace __u64 by u64 in kernel code (review from Y Song)
> - remove unneeded #else branch: program would be rejected in
>   is_valid_access (review from Y Song)
> - allow partial reads (<u64) (review from Y Song)
> 
> Changes since v3:
> - return netns_dev unconditionally and set netns_ino to 0 if
>   CONFIG_NET_NS is not enabled (review from Jakub Kicinski)
> - use bpf_ctx_record_field_size and bpf_ctx_narrow_access_ok instead of
>   manually deal with partial reads (review from Y Song)
> - update commit message to reflect new code and remove note about
>   partial reads since it was discussed in the review
> - use bpf_ctx_range() and offsetofend()
> 
> Changes since v4:
> - add netns_dev comment on uapi header (review from Y Song)
> - remove redundant bounds check (review from Y Song)
> ---
>  include/uapi/linux/bpf.h |  6 ++++
>  net/core/filter.c        | 67 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 63e0cf66f01a..41f54ac3db95 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3261,6 +3261,12 @@ struct bpf_sock_ops {
>  	__u32 sk_txhash;
>  	__u64 bytes_received;
>  	__u64 bytes_acked;
> +	/*
> +	 * netns_dev might be zero if there's an error getting it
> +	 * when loading the BPF program. This is very unlikely.
> +	 */
> +	__u64 netns_dev;
> +	__u64 netns_ino;
>  };
>  
>  /* Definitions for bpf_sock_ops_cb_flags */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 55bfc941d17a..ce3dc5fef57e 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -76,6 +76,8 @@
>  #include <net/lwtunnel.h>
>  #include <net/ipv6_stubs.h>
>  #include <net/bpf_sk_storage.h>
> +#include <linux/kdev_t.h>
> +#include <linux/proc_ns.h>
>  
>  /**
>   *	sk_filter_trim_cap - run a packet through a socket filter
> @@ -6822,6 +6824,15 @@ static bool sock_ops_is_valid_access(int off, int size,
>  		}
>  	} else {
>  		switch (off) {
> +		case bpf_ctx_range(struct bpf_sock_ops, netns_dev):
> +			bpf_ctx_record_field_size(info, sizeof(u64));
> +			if (!bpf_ctx_narrow_access_ok(off, size, sizeof(u64)))
> +				return false;
> +			break;
> +		case offsetof(struct bpf_sock_ops, netns_ino):
> +			if (size != sizeof(u64))
> +				return false;
> +			break;
>  		case bpf_ctx_range_till(struct bpf_sock_ops, bytes_received,
>  					bytes_acked):
>  			if (size != sizeof(__u64))
> @@ -7739,6 +7750,11 @@ static u32 sock_addr_convert_ctx_access(enum bpf_access_type type,
>  	return insn - insn_buf;
>  }
>  
> +static struct ns_common *sockops_netns_cb(void *private_data)
> +{
> +	return &init_net.ns;
> +}
> +
>  static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
>  				       const struct bpf_insn *si,
>  				       struct bpf_insn *insn_buf,
> @@ -7747,6 +7763,10 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
>  {
>  	struct bpf_insn *insn = insn_buf;
>  	int off;
> +	struct inode *ns_inode;
> +	struct path ns_path;
> +	u64 netns_dev;
> +	void *res;
>  
>  /* Helper macro for adding read access to tcp_sock or sock fields. */
>  #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
> @@ -7993,6 +8013,53 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
>  		SOCK_OPS_GET_OR_SET_FIELD(sk_txhash, sk_txhash,
>  					  struct sock, type);
>  		break;
> +
> +	case bpf_ctx_range(struct bpf_sock_ops, netns_dev):
> +		/* We get the netns_dev at BPF-load-time and not at
> +		 * BPF-exec-time. We assume that netns_dev is a constant.
> +		 */
> +		res = ns_get_path_cb(&ns_path, sockops_netns_cb, NULL);
> +		if (IS_ERR(res)) {
> +			netns_dev = 0;
> +		} else {
> +			ns_inode = ns_path.dentry->d_inode;
> +			netns_dev = new_encode_dev(ns_inode->i_sb->s_dev);
> +		}

This is leaking the netns path ref here, you're missing a path_put().

The feature looks very useful, thanks! But more on a higher level, the assumption
that netns_dev is and will remain a constant is a bit troublesome to me. As soon
as this assumption changes at some point, this ctx uapi restriction will give us
a potentially hard time to fix up at runtime. It basically would mean that all this
needs to be correctly resolved via BPF asm ctx rewrite at program /runtime/ as
opposed to load time.

Imho, it would be more future proof to design this as a helper function which would
pass dev and ino back to the program when passed as args plus perhaps a bitmask
which can select to fill in one of them or both (but that's an implementation detail).
Issue I'd see here is that __ns_get_path() can be quite expensive and potentially
sleep, but perhaps ns->stashed could be filled / cached such that we'll always hit
fast-path at BPF runtime? (Anyway, as a helper, this should also be enabled for other
program types.)

> +		*target_size = 8;
> +		*insn++ = BPF_MOV64_IMM(si->dst_reg, netns_dev);
> +		break;
> +
> +	case offsetof(struct bpf_sock_ops, netns_ino):
> +#ifdef CONFIG_NET_NS
> +		/* Loading: sk_ops->sk->__sk_common.skc_net.net->ns.inum
> +		 * Type: (struct bpf_sock_ops_kern *)
> +		 *       ->(struct sock *)
> +		 *       ->(struct sock_common)
> +		 *       .possible_net_t
> +		 *       .(struct net *)
> +		 *       ->(struct ns_common)
> +		 *       .(unsigned int)
> +		 */
> +		BUILD_BUG_ON(offsetof(struct sock, __sk_common) != 0);
> +		BUILD_BUG_ON(offsetof(possible_net_t, net) != 0);
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> +						struct bpf_sock_ops_kern, sk),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sock_ops_kern, sk));
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> +						possible_net_t, net),
> +				      si->dst_reg, si->dst_reg,
> +				      offsetof(struct sock_common, skc_net));
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> +						struct ns_common, inum),
> +				      si->dst_reg, si->dst_reg,
> +				      offsetof(struct net, ns) +
> +				      offsetof(struct ns_common, inum));
> +#else
> +		*insn++ = BPF_MOV64_IMM(si->dst_reg, 0);
> +#endif
> +		break;
> +
>  	}
>  	return insn - insn_buf;
>  }
> 


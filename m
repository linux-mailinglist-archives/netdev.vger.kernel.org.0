Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1803F1868B6
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 11:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbgCPKI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 06:08:26 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39890 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730430AbgCPKI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 06:08:26 -0400
Received: by mail-lj1-f196.google.com with SMTP id f10so17905097ljn.6
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 03:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=wiPq37TQcmv/j8DXzF82UVls7gLD7nfxkRjphi/xnhQ=;
        b=a3EEd1ZoH77ZtJyojDDciIWfx0K+gfSuEQa80gQ+k9Sg8vcpLF7kfuymsl3fY+hn/c
         H/+NGRu4McYttlAAxFgjWm8cBMmHB5Z34LCMHAJ7ORFSErJ6R/1TKQS/AytaUhI7dJzF
         X386bLZfXrpxs25+7f4ahKvTTldEq3bT+ysmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=wiPq37TQcmv/j8DXzF82UVls7gLD7nfxkRjphi/xnhQ=;
        b=sRFrXqhzHW1RIk4u7GQIRHntcb5eaNpA+tF5jGJ2699lSAg6VT+5gCyfr/mFpPR2dO
         skWIvc6RMZbnEnWWChYegPGcgChWzCCUNShrF0HoLpCekFd/12iQuufnbZ1i9Fy7Hi14
         SEH/aB1pwcWmWhSOLxGyUYtz7Q/+8n99tbWO8caVagmaGSlVlhEHiKGdL2+RQpK/1bkp
         4q//552UdvpggXVktLzAm3Mu4RA802DO+9OU0DaUAhyxWjEROiALVftpjPwJ5tfdjr0t
         9t3yTh83Ju7fEOiC9Q0D/9pGDI9mJEPFbdigBnD1A5BDMFioNLa3r+DB0YoEFddlgW5D
         /VHg==
X-Gm-Message-State: ANhLgQ3ViSHI6f370vUuu+aALrYKnqTJmyAxdIXSrWB99DZ8eaXHdrE+
        FCFAAcVnbYoVSqFtoSkXFqc9MA==
X-Google-Smtp-Source: ADFU+vu18xobEfN8sFNIDLEVd+xzp0/BQLPfyDuKUUEutLRlyTQzFrs6hMVm7lfKDA5ZB1kP74e5Qw==
X-Received: by 2002:a2e:b88d:: with SMTP id r13mr15140800ljp.66.1584353299513;
        Mon, 16 Mar 2020 03:08:19 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id y18sm34344515ljm.93.2020.03.16.03.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 03:08:18 -0700 (PDT)
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, eric.dumazet@gmail.com, lmb@cloudflare.com,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
In-reply-to: <20200312233648.1767-4-joe@wand.net.nz>
Date:   Mon, 16 Mar 2020 11:08:17 +0100
Message-ID: <87mu8gy5m6.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+CC Florian]

Hey Joe,

On Fri, Mar 13, 2020 at 12:36 AM CET, Joe Stringer wrote:
> Add support for TPROXY via a new bpf helper, bpf_sk_assign().
>
> This helper requires the BPF program to discover the socket via a call
> to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> helper takes its own reference to the socket in addition to any existing
> reference that may or may not currently be obtained for the duration of
> BPF processing. For the destination socket to receive the traffic, the
> traffic must be routed towards that socket via local route, the socket
> must have the transparent option enabled out-of-band, and the socket
> must not be closing. If all of these conditions hold, the socket will be
> assigned to the skb to allow delivery to the socket.

My impression from the last time we have been discussing TPROXY is that
the check for IP_TRANSPARENT on ingress doesn't serve any purpose [0].

The socket option only has effect on output, when there is a need to
source traffic from a non-local address.

Setting IP_TRANSPARENT requires CAP_NET_{RAW|ADMIN}, which grant a wider
range of capabilities than needed to build a transparent proxy app. This
is problematic because you to lock down your application with seccomp.

It seems it should be enough to use a port number from a privileged
range, if you want to ensure that only the designed process can receive
the proxied traffic.

Or, alternatively, instead of using socket lookup + IP_TRANSPARENT
check, get the socket from sockmap and apply control to who can update
the BPF map.

Thanks,
-jkbs

[0] https://lore.kernel.org/bpf/20190621125155.2sdw7pugepj3ityx@breakpoint.cc/

>
> The recently introduced dst_sk_prefetch is used to communicate from the
> TC layer to the IP receive layer that the socket should be retained
> across the receive. The dst_sk_prefetch destination wraps any existing
> destination (if available) and stores it temporarily in a per-cpu var.
>
> To ensure that no dst references held by the skb prior to sk_assign()
> are lost, they are stored in the per-cpu variable associated with
> dst_sk_prefetch. When the BPF program invocation from the TC action
> completes, we check the return code against TC_ACT_OK and if any other
> return code is used, we restore the dst to avoid unintentionally leaking
> the reference held in the per-CPU variable. If the packet is cloned or
> dropped before reaching ip{,6}_rcv_core(), the original dst will also be
> restored from the per-cpu variable to avoid the leak; if the packet makes
> its way to the receive function for the protocol, then the destination
> (if any) will be restored to the packet at that point.
>
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> ---
>  include/uapi/linux/bpf.h       | 23 ++++++++++++++++++++++-
>  net/core/filter.c              | 28 ++++++++++++++++++++++++++++
>  net/core/skbuff.c              |  3 +++
>  net/ipv4/ip_input.c            |  5 ++++-
>  net/ipv6/ip6_input.c           |  5 ++++-
>  net/sched/act_bpf.c            |  3 +++
>  tools/include/uapi/linux/bpf.h | 18 +++++++++++++++++-
>  7 files changed, 81 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 40b2d9476268..35f282cc745e 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2914,6 +2914,26 @@ union bpf_attr {
>   *		of sizeof(struct perf_branch_entry).
>   *
>   *		**-ENOENT** if architecture does not support branch records.
> + *
> + * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
> + *	Description
> + *		Assign the *sk* to the *skb*. When combined with appropriate
> + *		routing configuration to receive the packet towards the socket,
> + *		will cause *skb* to be delivered to the specified socket.
> + *		Subsequent redirection of *skb* via  **bpf_redirect**\ (),
> + *		**bpf_clone_redirect**\ () or other methods outside of BPF may
> + *		interfere with successful delivery to the socket.
> + *
> + *		This operation is only valid from TC ingress path.
> + *
> + *		The *flags* argument must be zero.
> + *	Return
> + *		0 on success, or a negative errno in case of failure.
> + *
> + *		* **-EINVAL**		Unsupported flags specified.
> + *		* **-EOPNOTSUPP**:	Unsupported operation, for example a
> + *					call from outside of TC ingress.
> + *		* **-ENOENT**		The socket cannot be assigned.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3035,7 +3055,8 @@ union bpf_attr {
>  	FN(tcp_send_ack),		\
>  	FN(send_signal_thread),		\
>  	FN(jiffies64),			\
> -	FN(read_branch_records),
> +	FN(read_branch_records),	\
> +	FN(sk_assign),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/net/core/filter.c b/net/core/filter.c
> index cd0a532db4e7..bae0874289d8 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
>  	.arg5_type	= ARG_CONST_SIZE,
>  };
>
> +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> +{
> +	if (flags != 0)
> +		return -EINVAL;
> +	if (!skb_at_tc_ingress(skb))
> +		return -EOPNOTSUPP;
> +	if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> +		return -ENOENT;
> +
> +	skb_orphan(skb);
> +	skb->sk = sk;
> +	skb->destructor = sock_edemux;
> +	dst_sk_prefetch_store(skb);
> +
> +	return 0;
> +}
> +
> +static const struct bpf_func_proto bpf_sk_assign_proto = {
> +	.func		= bpf_sk_assign,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type      = ARG_PTR_TO_CTX,
> +	.arg2_type      = ARG_PTR_TO_SOCK_COMMON,
> +	.arg3_type	= ARG_ANYTHING,
> +};
> +
>  #endif /* CONFIG_INET */
>
>  bool bpf_helper_changes_pkt_data(void *func)
> @@ -6139,6 +6165,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_skb_ecn_set_ce_proto;
>  	case BPF_FUNC_tcp_gen_syncookie:
>  		return &bpf_tcp_gen_syncookie_proto;
> +	case BPF_FUNC_sk_assign:
> +		return &bpf_sk_assign_proto;
>  #endif
>  	default:
>  		return bpf_base_func_proto(func_id);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 6b2798450fd4..80ee8f7b6a19 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -63,6 +63,7 @@
>
>  #include <net/protocol.h>
>  #include <net/dst.h>
> +#include <net/dst_metadata.h>
>  #include <net/sock.h>
>  #include <net/checksum.h>
>  #include <net/ip6_checksum.h>
> @@ -1042,6 +1043,7 @@ EXPORT_SYMBOL_GPL(alloc_skb_for_msg);
>   */
>  void skb_dst_drop(struct sk_buff *skb)
>  {
> +	dst_sk_prefetch_reset(skb);
>  	if (skb->_skb_refdst) {
>  		refdst_drop(skb->_skb_refdst);
>  		skb->_skb_refdst = 0UL;
> @@ -1466,6 +1468,7 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
>  		n->fclone = SKB_FCLONE_UNAVAILABLE;
>  	}
>
> +	dst_sk_prefetch_reset(skb);
>  	return __skb_clone(n, skb);
>  }
>  EXPORT_SYMBOL(skb_clone);
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index aa438c6758a7..9bd4858d20fc 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -509,7 +509,10 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>  	IPCB(skb)->iif = skb->skb_iif;
>
>  	/* Must drop socket now because of tproxy. */
> -	skb_orphan(skb);
> +	if (skb_dst_is_sk_prefetch(skb))
> +		dst_sk_prefetch_fetch(skb);
> +	else
> +		skb_orphan(skb);
>
>  	return skb;
>
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index 7b089d0ac8cd..f7b42adca9d0 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -285,7 +285,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>  	rcu_read_unlock();
>
>  	/* Must drop socket now because of tproxy. */
> -	skb_orphan(skb);
> +	if (skb_dst_is_sk_prefetch(skb))
> +		dst_sk_prefetch_fetch(skb);
> +	else
> +		skb_orphan(skb);
>
>  	return skb;
>  err:
> diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
> index 46f47e58b3be..b4c557e6158d 100644
> --- a/net/sched/act_bpf.c
> +++ b/net/sched/act_bpf.c
> @@ -11,6 +11,7 @@
>  #include <linux/filter.h>
>  #include <linux/bpf.h>
>
> +#include <net/dst_metadata.h>
>  #include <net/netlink.h>
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
> @@ -53,6 +54,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
>  		bpf_compute_data_pointers(skb);
>  		filter_res = BPF_PROG_RUN(filter, skb);
>  	}
> +	if (filter_res != TC_ACT_OK)
> +		dst_sk_prefetch_reset(skb);
>  	rcu_read_unlock();
>
>  	/* A BPF program may overwrite the default action opcode.
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 40b2d9476268..546e9e1368ff 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -2914,6 +2914,21 @@ union bpf_attr {
>   *		of sizeof(struct perf_branch_entry).
>   *
>   *		**-ENOENT** if architecture does not support branch records.
> + *
> + * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
> + *	Description
> + *		Assign the *sk* to the *skb*.
> + *
> + *		This operation is only valid from TC ingress path.
> + *
> + *		The *flags* argument must be zero.
> + *	Return
> + *		0 on success, or a negative errno in case of failure.
> + *
> + *		* **-EINVAL**		Unsupported flags specified.
> + *		* **-EOPNOTSUPP**:	Unsupported operation, for example a
> + *					call from outside of TC ingress.
> + *		* **-ENOENT**		The socket cannot be assigned.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3035,7 +3050,8 @@ union bpf_attr {
>  	FN(tcp_send_ack),		\
>  	FN(send_signal_thread),		\
>  	FN(jiffies64),			\
> -	FN(read_branch_records),
> +	FN(read_branch_records),	\
> +	FN(sk_assign),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call

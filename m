Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A877184F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 14:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732072AbfGWMdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 08:33:07 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33825 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfGWMdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 08:33:06 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so8893697edb.1
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 05:33:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6AenKOZ+i89XBv+YO072ocgOr6Rxwnwlz4jQLCmTOx0=;
        b=cu5aUVX26bZXxEOwrqCEdhodxlgmtz8/Ktywso7lw+dbL1cfGcC82p9FHwReTq19qk
         qtGs1HTXHFov3RzbENXxNH9MM41WRw8fOpTEAbKTIgKBWErxHEqKozVWwl+WUsCbwXfK
         T8lDopTGXjVgakN5bL0FdlTH9C2F1rAIA88xW8PGFKbNLXoODIiYTK6daf8/liIOnWBh
         AeBPm9JHBl/4pg7kUtn068EuzcBj6Bnze9uav8lbN/dd75Kc0datpVXdW111GbelDbFQ
         LbZbTiFnuaUTU2NeBJ3YKybqh7PdBxz5AOhuH9qAKUwI65FHFHZL5vQC/zwG8QLQc8Pi
         9RQQ==
X-Gm-Message-State: APjAAAWEwx8z5Bjrs5jiDPA/u7AOtOzE4BTscZKGJX7H1/+NQX9v3/1M
        neOaVPnFF9Aw7YK2X2zTLerl7A==
X-Google-Smtp-Source: APXvYqxYuH3cSlk20yaiBhVj6QejHB9Mm/th498jFDmwTXAJPsYBN3dV12K/jT5IHcJGSB8ztIq1Rw==
X-Received: by 2002:a17:906:4ed8:: with SMTP id i24mr56443586ejv.118.1563885184582;
        Tue, 23 Jul 2019 05:33:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b15sm8748680ejp.7.2019.07.23.05.33.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 05:33:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BA936181CE7; Tue, 23 Jul 2019 14:33:02 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Petar Penkov <ppenkov.kernel@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [bpf-next 3/6] bpf: add bpf_tcp_gen_syncookie helper
In-Reply-To: <20190723002042.105927-4-ppenkov.kernel@gmail.com>
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com> <20190723002042.105927-4-ppenkov.kernel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 23 Jul 2019 14:33:02 +0200
Message-ID: <8736ix3p8h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petar Penkov <ppenkov.kernel@gmail.com> writes:

> From: Petar Penkov <ppenkov@google.com>
>
> This helper function allows BPF programs to try to generate SYN
> cookies, given a reference to a listener socket. The function works
> from XDP and with an skb context since bpf_skc_lookup_tcp can lookup a
> socket in both cases.
>
> Signed-off-by: Petar Penkov <ppenkov@google.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/uapi/linux/bpf.h | 30 ++++++++++++++++-
>  net/core/filter.c        | 73 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 102 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 6f68438aa4ed..20baee7b2219 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2713,6 +2713,33 @@ union bpf_attr {
>   *		**-EPERM** if no permission to send the *sig*.
>   *
>   *		**-EAGAIN** if bpf program can try again.
> + *
> + * s64 bpf_tcp_gen_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
> + *	Description
> + *		Try to issue a SYN cookie for the packet with corresponding
> + *		IP/TCP headers, *iph* and *th*, on the listening socket in *sk*.
> + *
> + *		*iph* points to the start of the IPv4 or IPv6 header, while
> + *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
> + *		**sizeof**\ (**struct ip6hdr**).
> + *
> + *		*th* points to the start of the TCP header, while *th_len*
> + *		contains the length of the TCP header.
> + *
> + *	Return
> + *		On success, lower 32 bits hold the generated SYN cookie in
> + *		followed by 16 bits which hold the MSS value for that cookie,
> + *		and the top 16 bits are unused.
> + *
> + *		On failure, the returned value is one of the following:
> + *
> + *		**-EINVAL** SYN cookie cannot be issued due to error
> + *
> + *		**-ENOENT** SYN cookie should not be issued (no SYN flood)
> + *
> + *		**-ENOTSUPP** kernel configuration does not enable SYN
> cookies

nit: This should be EOPNOTSUPP - the other one is for NFS...

> + *
> + *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -2824,7 +2851,8 @@ union bpf_attr {
>  	FN(strtoul),			\
>  	FN(sk_storage_get),		\
>  	FN(sk_storage_delete),		\
> -	FN(send_signal),
> +	FN(send_signal),		\
> +	FN(tcp_gen_syncookie),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 47f6386fb17a..92114271eff6 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5850,6 +5850,75 @@ static const struct bpf_func_proto bpf_tcp_check_syncookie_proto = {
>  	.arg5_type	= ARG_CONST_SIZE,
>  };
>  
> +BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
> +	   struct tcphdr *, th, u32, th_len)
> +{
> +#ifdef CONFIG_SYN_COOKIES
> +	u32 cookie;
> +	u16 mss;
> +
> +	if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
> +		return -EINVAL;
> +
> +	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
> +		return -EINVAL;
> +
> +	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> +		return -ENOENT;
> +
> +	if (!th->syn || th->ack || th->fin || th->rst)
> +		return -EINVAL;
> +
> +	if (unlikely(iph_len < sizeof(struct iphdr)))
> +		return -EINVAL;
> +
> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
> +	 * same offset so we can cast to the shorter header (struct iphdr).
> +	 */
> +	switch (((struct iphdr *)iph)->version) {
> +	case 4:
> +		if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
> +			return -EINVAL;
> +
> +		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
> +		break;
> +
> +#if IS_BUILTIN(CONFIG_IPV6)
> +	case 6:
> +		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
> +			return -EINVAL;
> +
> +		if (sk->sk_family != AF_INET6)
> +			return -EINVAL;
> +
> +		mss = tcp_v6_get_syncookie(sk, iph, th, &cookie);
> +		break;
> +#endif /* CONFIG_IPV6 */
> +
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +	if (mss <= 0)
> +		return -ENOENT;
> +
> +	return cookie | ((u64)mss << 32);
> +#else
> +	return -ENOTSUPP;

See above

> +#endif /* CONFIG_SYN_COOKIES */
> +}
> +
> +static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> +	.func		= bpf_tcp_gen_syncookie,
> +	.gpl_only	= true, /* __cookie_v*_init_sequence() is GPL */
> +	.pkt_access	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_SOCK_COMMON,
> +	.arg2_type	= ARG_PTR_TO_MEM,
> +	.arg3_type	= ARG_CONST_SIZE,
> +	.arg4_type	= ARG_PTR_TO_MEM,
> +	.arg5_type	= ARG_CONST_SIZE,
> +};
> +
>  #endif /* CONFIG_INET */
>  
>  bool bpf_helper_changes_pkt_data(void *func)
> @@ -6135,6 +6204,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_tcp_check_syncookie_proto;
>  	case BPF_FUNC_skb_ecn_set_ce:
>  		return &bpf_skb_ecn_set_ce_proto;
> +	case BPF_FUNC_tcp_gen_syncookie:
> +		return &bpf_tcp_gen_syncookie_proto;
>  #endif
>  	default:
>  		return bpf_base_func_proto(func_id);
> @@ -6174,6 +6245,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_xdp_skc_lookup_tcp_proto;
>  	case BPF_FUNC_tcp_check_syncookie:
>  		return &bpf_tcp_check_syncookie_proto;
> +	case BPF_FUNC_tcp_gen_syncookie:
> +		return &bpf_tcp_gen_syncookie_proto;
>  #endif
>  	default:
>  		return bpf_base_func_proto(func_id);
> -- 
> 2.22.0.657.g960e92d24f-goog

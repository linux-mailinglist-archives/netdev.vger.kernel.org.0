Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6B36A7BB
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 13:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfGPLzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 07:55:12 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37240 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfGPLzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 07:55:12 -0400
Received: by mail-ot1-f68.google.com with SMTP id s20so20736935otp.4
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 04:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vWr8oomGMOSfZnim+O2wKmvtfyR5x3n3He036TvLado=;
        b=b5dJ5JITd4haY6/EWB2mqqLWE8e0PSxbfYVPkPO4p29TZd9RJoa4z6+Sfn1T63jFdR
         yF6nMQd1Df84vDv/ylddMUea9farozRU3Nq2w/bHHmmVMXWtuDyVCLxc6XOVpcz9tXBv
         anFF5tUui2Uq0B5v55Iv4eZcjov2cZ3NTabfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vWr8oomGMOSfZnim+O2wKmvtfyR5x3n3He036TvLado=;
        b=pHlF198T1SetKuehosKUG563amA3m/1a3I/PfX4jNwIEehwnRx+EBeOKi8bMI/qQtA
         Bocod/CbFc6MMz6mk0xmAbvS+Wdt+8hLur3dhCclth73wA3yIdQHzQ7rZewe9D4fri8X
         KIEdyTOj/5Zu/LhNWVYxcaF7001batFh/Aa07P8TDF1YdlLAZA5Fwfr7VmuBd1QfaYzV
         HhHM11eG4oBXMGQ/xFvSU+UJuolwlTW7rYv9pWg2bLyUEE7mJBVg7jF6jpp0WoHpEWSf
         7i6QV9sfnLj0QHXoM/wrOL0gVExoyBfKkBa5TBEX+fdIu/N/CEJOLeA2G+4Stc2lEVRn
         PkWg==
X-Gm-Message-State: APjAAAUHSa7+Gx9dy6QmFTb0LgKJH0lw95xFtW51h/2kmm3bJ0wi5xRn
        BHgx0AINVjTdhDUdM9jFlzNZHbDhsGd9HWorUEmULw==
X-Google-Smtp-Source: APXvYqx2p75tfQ6IiKg/zPvAgseCvAef3Tv62UWcUZRicM3t681GbOVNcTJC3iKzQ0gE4wYJooLUi7PB/VDzcNw/1dg=
X-Received: by 2002:a9d:32d:: with SMTP id 42mr23401846otv.147.1563278110559;
 Tue, 16 Jul 2019 04:55:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com> <20190716002650.154729-4-ppenkov.kernel@gmail.com>
In-Reply-To: <20190716002650.154729-4-ppenkov.kernel@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 16 Jul 2019 12:54:59 +0100
Message-ID: <CACAyw9_ZomkBT0HG0ccht7LMNYubmQ18jvd_1YMFHPWrPHwvCg@mail.gmail.com>
Subject: Re: [bpf-next RFC 3/6] bpf: add bpf_tcp_gen_syncookie helper
To:     Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jul 2019 at 01:27, Petar Penkov <ppenkov.kernel@gmail.com> wrote:
>
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
>  include/uapi/linux/bpf.h | 30 ++++++++++++++++++-
>  net/core/filter.c        | 62 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 91 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 6f68438aa4ed..abf4a85c76d1 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2713,6 +2713,33 @@ union bpf_attr {
>   *             **-EPERM** if no permission to send the *sig*.
>   *
>   *             **-EAGAIN** if bpf program can try again.
> + *
> + * s64 bpf_tcp_gen_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
> + *     Description
> + *             Try to issue a SYN cookie for the packet with corresponding
> + *             IP/TCP headers, *iph* and *th*, on the listening socket in *sk*.
> + *
> + *             *iph* points to the start of the IPv4 or IPv6 header, while
> + *             *iph_len* contains **sizeof**\ (**struct iphdr**) or
> + *             **sizeof**\ (**struct ip6hdr**).
> + *
> + *             *th* points to the start of the TCP header, while *th_len*
> + *             contains **sizeof**\ (**struct tcphdr**).
> + *
> + *     Return
> + *             On success, lower 32 bits hold the generated SYN cookie in
> + *             network order and the higher 32 bits hold the MSS value for that
> + *             cookie.

I prefer returning the cookie vs. directly creating the packet.
Returning a struct would
be nicest, but it doesn't seem worth it to extend the verifier for
that. Taking a pointer
to a result struct would also be good, but we're out of arguments :/

Nit: the MSS is only 16 bit?

> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EINVAL** SYN cookie cannot be issued due to error
> + *
> + *             **-ENOENT** SYN cookie should not be issued (no SYN flood)
> + *
> + *             **-ENOTSUPP** kernel configuration does not enable SYN cookies
> + *
> + *             **-EPROTONOSUPPORT** *sk* family is not AF_INET/AF_INET6
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -2824,7 +2851,8 @@ union bpf_attr {
>         FN(strtoul),                    \
>         FN(sk_storage_get),             \
>         FN(sk_storage_delete),          \
> -       FN(send_signal),
> +       FN(send_signal),                \
> +       FN(tcp_gen_syncookie),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 47f6386fb17a..109fd1e286f4 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5850,6 +5850,64 @@ static const struct bpf_func_proto bpf_tcp_check_syncookie_proto = {
>         .arg5_type      = ARG_CONST_SIZE,
>  };
>
> +BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
> +          struct tcphdr *, th, u32, th_len)
> +{
> +#ifdef CONFIG_SYN_COOKIES
> +       u32 cookie;
> +       u16 mss;
> +
> +       if (unlikely(th_len < sizeof(*th)))
> +               return -EINVAL;
> +
> +       if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
> +               return -EINVAL;
> +
> +       if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> +               return -EINVAL;

Should this be ENOENT instead?

> +
> +       if (!th->syn || th->ack || th->fin || th->rst)
> +               return -EINVAL;
> +
> +       switch (sk->sk_family) {
> +       case AF_INET:
> +               if (unlikely(iph_len < sizeof(struct iphdr)))
> +                       return -EINVAL;
> +               mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
> +               break;
> +
> +#if IS_BUILTIN(CONFIG_IPV6)
> +       case AF_INET6:
> +               if (unlikely(iph_len < sizeof(struct ipv6hdr)))
> +                       return -EINVAL;
> +               mss = tcp_v6_get_syncookie(sk, iph, th, &cookie);
> +               break;
> +#endif /* CONFIG_IPV6 */
> +
> +       default:
> +               return -EPROTONOSUPPORT;
> +       }
> +       if (mss <= 0)
> +               return -ENOENT;
> +
> +       return htonl(cookie) | ((u64)mss << 32);
> +#else
> +       return -ENOTSUPP;
> +#endif /* CONFIG_SYN_COOKIES */
> +}
> +
> +static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> +       .func           = bpf_tcp_gen_syncookie,
> +       .gpl_only       = true, /* __cookie_v*_init_sequence() is GPL */
> +       .pkt_access     = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_SOCK_COMMON,
> +       .arg2_type      = ARG_PTR_TO_MEM,
> +       .arg3_type      = ARG_CONST_SIZE,
> +       .arg4_type      = ARG_PTR_TO_MEM,
> +       .arg5_type      = ARG_CONST_SIZE,
> +};
> +
>  #endif /* CONFIG_INET */
>
>  bool bpf_helper_changes_pkt_data(void *func)
> @@ -6135,6 +6193,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_tcp_check_syncookie_proto;
>         case BPF_FUNC_skb_ecn_set_ce:
>                 return &bpf_skb_ecn_set_ce_proto;
> +       case BPF_FUNC_tcp_gen_syncookie:
> +               return &bpf_tcp_gen_syncookie_proto;
>  #endif
>         default:
>                 return bpf_base_func_proto(func_id);
> @@ -6174,6 +6234,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_xdp_skc_lookup_tcp_proto;
>         case BPF_FUNC_tcp_check_syncookie:
>                 return &bpf_tcp_check_syncookie_proto;
> +       case BPF_FUNC_tcp_gen_syncookie:
> +               return &bpf_tcp_gen_syncookie_proto;
>  #endif
>         default:
>                 return bpf_base_func_proto(func_id);
> --
> 2.22.0.510.g264f2c817a-goog
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com

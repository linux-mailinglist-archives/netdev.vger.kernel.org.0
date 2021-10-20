Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20807434F7F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhJTP7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhJTP7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 11:59:13 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7033C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 08:56:58 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id n8so15996330lfk.6
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 08:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TCZ683u99Jm41qEN6eWPpP1n8rGety/eAnHibS9A2GQ=;
        b=UoEY0usm5DXMVHSQsT6pMf14NgDa018KZ90Gl4MACFJB/bi0CXOzd28A8QyMTsyJjX
         4IKnOSoPOSq9AM0rv4e32uiLrc+5g9MYyAjPd/vGaE/aaKhX5AhYcUwA5Cp7CiNXnWmd
         6QtsxrBUM5dSQGECTjQn4oq7b/Y14Mg0dwoqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TCZ683u99Jm41qEN6eWPpP1n8rGety/eAnHibS9A2GQ=;
        b=06VLqUnP0wfZSHkBDYQJb1d62WHzFzs0xP62YtYXuTMZA9wcpqTmw69FnPkmz5BGX+
         1Eu1Y+E+VkDdTkEwRxhrasv+zWBcUfHih30aHR2DFHFCj1S+72sRH9jJUZPOJyzsz7Dh
         rqiN5gEoAqGpNQj+EPBvmHpJE4U4ZjH1SecD7k+yvRN6fff1VOan1pr+ETA+ngDlL5gk
         bGjr1oU8v630O3iQRokuY2a57TbF3bO8+7Y9RpUVJGojCHLQMvJJ8nnzmjrowL6BYfQm
         Xs4YXjgfTjTQxPtWTuf61T0QYhD42SuOmZ6DoMymsd9afaBdTRF6tkAys+dpU1V7uDPw
         RUrg==
X-Gm-Message-State: AOAM5334yyPj3W5uDAoxtAKphUJ9Cu2XUnST6R2M4paujhPz+UrHEn7k
        K0HkEWrckR8lBrLbUN7P5ze17MKipKYiuqsW0kB1jA==
X-Google-Smtp-Source: ABdhPJy3PpTlDciRIIloIP1t/37pw5N/rZE7Pu5xGX4BiYf125qTL3TMpv58efY/EJzh8K1MSn2Wc8aIz4qA4iMEC3I=
X-Received: by 2002:a05:6512:3bc:: with SMTP id v28mr152447lfp.102.1634745417053;
 Wed, 20 Oct 2021 08:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211019144655.3483197-1-maximmi@nvidia.com> <20211019144655.3483197-10-maximmi@nvidia.com>
In-Reply-To: <20211019144655.3483197-10-maximmi@nvidia.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 20 Oct 2021 16:56:46 +0100
Message-ID: <CACAyw9_MT-+n_b1pLYrU+m6OicgRcndEBiOwb5Kc1w0CANd_9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/10] bpf: Add a helper to issue timestamp
 cookies in XDP
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>, Tariq Toukan <tariqt@nvidia.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 at 15:49, Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> The new helper bpf_tcp_raw_gen_tscookie allows an XDP program to
> generate timestamp cookies (to be used together with SYN cookies) which
> encode different options set by the client in the SYN packet: SACK
> support, ECN support, window scale. These options are encoded in lower
> bits of the timestamp, which will be returned by the client in a
> subsequent ACK packet. The format is the same used by synproxy.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  include/net/tcp.h              |  1 +
>  include/uapi/linux/bpf.h       | 27 +++++++++++++++
>  net/core/filter.c              | 38 +++++++++++++++++++++
>  net/ipv4/syncookies.c          | 60 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 27 +++++++++++++++
>  5 files changed, 153 insertions(+)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 1cc96a225848..651820bef6a2 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -564,6 +564,7 @@ u32 __cookie_v4_init_sequence(const struct iphdr *iph, const struct tcphdr *th,
>                               u16 *mssp);
>  __u32 cookie_v4_init_sequence(const struct sk_buff *skb, __u16 *mss);
>  u64 cookie_init_timestamp(struct request_sock *req, u64 now);
> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 *tsval, __be32 *tsecr);
>  bool cookie_timestamp_decode(const struct net *net,
>                              struct tcp_options_received *opt);
>  bool cookie_ecn_ok(const struct tcp_options_received *opt,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index e32f72077250..791790b41874 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5053,6 +5053,32 @@ union bpf_attr {
>   *
>   *             **-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
>   *             CONFIG_IPV6 is disabled).
> + *
> + * int bpf_tcp_raw_gen_tscookie(struct tcphdr *th, u32 th_len, __be32 *tsopt, u32 tsopt_len)

flags which must be 0?

> + *     Description
> + *             Try to generate a timestamp cookie which encodes some of the
> + *             flags sent by the client in the SYN packet: SACK support, ECN
> + *             support, window scale. To be used with SYN cookies.
> + *
> + *             *th* points to the start of the TCP header of the client's SYN
> + *             packet, while *th_len* contains the length of the TCP header (at
> + *             least **sizeof**\ (**struct tcphdr**)).
> + *
> + *             *tsopt* points to the output location where to put the resulting
> + *             timestamp values: tsval and tsecr, in the format of the TCP
> + *             timestamp option.
> + *
> + *     Return
> + *             On success, 0.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EINVAL** if the input arguments are invalid.
> + *
> + *             **-ENOENT** if the TCP header doesn't have the timestamp option.
> + *
> + *             **-EOPNOTSUPP** if the kernel configuration does not enable SYN
> + *             cookies (CONFIG_SYN_COOKIES is off).
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5238,6 +5264,7 @@ union bpf_attr {
>         FN(ct_release),                 \
>         FN(tcp_raw_gen_syncookie),      \
>         FN(tcp_raw_check_syncookie),    \
> +       FN(tcp_raw_gen_tscookie),       \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5f03d4a282a0..73fe20ef7442 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7403,6 +7403,42 @@ static const struct bpf_func_proto bpf_tcp_raw_check_syncookie_proto = {
>         .arg4_type      = ARG_CONST_SIZE,
>  };
>
> +BPF_CALL_4(bpf_tcp_raw_gen_tscookie, struct tcphdr *, th, u32, th_len,
> +          __be32 *, tsopt, u32, tsopt_len)
> +{
> +       int err;

Missing check for th_len?

> +
> +#ifdef CONFIG_SYN_COOKIES
> +       if (tsopt_len != sizeof(u64)) {

sizeof(u32) * 2? That u64 isn't really relevant here.

> +               err = -EINVAL;
> +               goto err_out;
> +       }
> +
> +       if (!cookie_init_timestamp_raw(th, &tsopt[0], &tsopt[1])) {
> +               err = -ENOENT;
> +               goto err_out;
> +       }
> +
> +       return 0;
> +err_out:
> +#else
> +       err = -EOPNOTSUPP;
> +#endif
> +       memset(tsopt, 0, tsopt_len);
> +       return err;
> +}
> +
> +static const struct bpf_func_proto bpf_tcp_raw_gen_tscookie_proto = {
> +       .func           = bpf_tcp_raw_gen_tscookie,
> +       .gpl_only       = false,
> +       .pkt_access     = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_MEM,
> +       .arg2_type      = ARG_CONST_SIZE,
> +       .arg3_type      = ARG_PTR_TO_UNINIT_MEM,
> +       .arg4_type      = ARG_CONST_SIZE,
> +};
> +
>  #endif /* CONFIG_INET */
>
>  bool bpf_helper_changes_pkt_data(void *func)
> @@ -7825,6 +7861,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_tcp_raw_gen_syncookie_proto;
>         case BPF_FUNC_tcp_raw_check_syncookie:
>                 return &bpf_tcp_raw_check_syncookie_proto;
> +       case BPF_FUNC_tcp_raw_gen_tscookie:
> +               return &bpf_tcp_raw_gen_tscookie_proto;
>  #endif
>         default:
>                 return bpf_sk_base_func_proto(func_id);
> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
> index 8696dc343ad2..4dd2c7a096eb 100644
> --- a/net/ipv4/syncookies.c
> +++ b/net/ipv4/syncookies.c
> @@ -85,6 +85,66 @@ u64 cookie_init_timestamp(struct request_sock *req, u64 now)
>         return (u64)ts * (NSEC_PER_SEC / TCP_TS_HZ);
>  }
>
> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 *tsval, __be32 *tsecr)

I'm probably missing context, Is there something in this function that
means you can't implement it in BPF?

Lorenz

--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com

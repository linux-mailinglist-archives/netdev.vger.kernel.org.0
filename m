Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6532950024F
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 01:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbiDMXKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 19:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbiDMXKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 19:10:45 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A856A37AAB;
        Wed, 13 Apr 2022 16:08:22 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1neln7-0002b3-6M; Thu, 14 Apr 2022 00:48:49 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1neln6-000WBX-JK; Thu, 14 Apr 2022 00:48:48 +0200
Subject: Re: [PATCH bpf-next v5 4/6] bpf: Add helpers to issue and check SYN
 cookies in XDP
To:     Maxim Mikityanskiy <maximmi@nvidia.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        linux-kselftest@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
References: <20220413134120.3253433-1-maximmi@nvidia.com>
 <20220413134120.3253433-5-maximmi@nvidia.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e75057fd-42d4-071e-b8b9-0b93e643adfd@iogearbox.net>
Date:   Thu, 14 Apr 2022 00:48:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220413134120.3253433-5-maximmi@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26511/Wed Apr 13 10:22:45 2022)
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 3:41 PM, Maxim Mikityanskiy wrote:
[...]
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7446b0ba4e38..428cc63ecdf7 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7425,6 +7425,124 @@ static const struct bpf_func_proto bpf_skb_set_tstamp_proto = {
>   	.arg3_type      = ARG_ANYTHING,
>   };
>   
> +BPF_CALL_3(bpf_tcp_raw_gen_syncookie_ipv4, struct iphdr *, iph,
> +	   struct tcphdr *, th, u32, th_len)
> +{
> +#ifdef CONFIG_SYN_COOKIES
> +	u32 cookie;
> +	u16 mss;
> +
> +	if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
> +		return -EINVAL;
> +
> +	mss = tcp_parse_mss_option(th, 0) ?: TCP_MSS_DEFAULT;
> +	cookie = __cookie_v4_init_sequence(iph, th, &mss);
> +
> +	return cookie | ((u64)mss << 32);
> +#else
> +	return -EOPNOTSUPP;
> +#endif /* CONFIG_SYN_COOKIES */

This (and for other added helpers below) will be rather tricky to probe for availability
e.g. via `bpftool feature probe [...]`. Much better if you wrap the ifdef CONFIG_SYN_COOKIES
around the {xdp,tc_cls_act}_func_proto() instead as we do elsewhere.

> +}
> +
> +static const struct bpf_func_proto bpf_tcp_raw_gen_syncookie_ipv4_proto = {
> +	.func		= bpf_tcp_raw_gen_syncookie_ipv4,
> +	.gpl_only	= true, /* __cookie_v4_init_sequence() is GPL */
> +	.pkt_access	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_MEM,
> +	.arg1_size	= sizeof(struct iphdr),
> +	.arg2_type	= ARG_PTR_TO_MEM,
> +	.arg3_type	= ARG_CONST_SIZE,
> +};
> +
> +BPF_CALL_3(bpf_tcp_raw_gen_syncookie_ipv6, struct ipv6hdr *, iph,
> +	   struct tcphdr *, th, u32, th_len)
> +{
> +#ifndef CONFIG_SYN_COOKIES
> +	return -EOPNOTSUPP;
> +#elif !IS_BUILTIN(CONFIG_IPV6)
> +	return -EPROTONOSUPPORT;
> +#else
> +	const u16 mss_clamp = IPV6_MIN_MTU - sizeof(struct tcphdr) -
> +		sizeof(struct ipv6hdr);
> +	u32 cookie;
> +	u16 mss;
> +
> +	if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
> +		return -EINVAL;
> +
> +	mss = tcp_parse_mss_option(th, 0) ?: mss_clamp;
> +	cookie = __cookie_v6_init_sequence(iph, th, &mss);
> +
> +	return cookie | ((u64)mss << 32);
> +#endif
> +}
> +
> +static const struct bpf_func_proto bpf_tcp_raw_gen_syncookie_ipv6_proto = {
> +	.func		= bpf_tcp_raw_gen_syncookie_ipv6,
> +	.gpl_only	= true, /* __cookie_v6_init_sequence() is GPL */
> +	.pkt_access	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_MEM,
> +	.arg1_size	= sizeof(struct ipv6hdr),
> +	.arg2_type	= ARG_PTR_TO_MEM,
> +	.arg3_type	= ARG_CONST_SIZE,
> +};
[...]
>   
>   bool bpf_helper_changes_pkt_data(void *func)
> @@ -7837,6 +7955,14 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &bpf_tcp_check_syncookie_proto;
>   	case BPF_FUNC_tcp_gen_syncookie:
>   		return &bpf_tcp_gen_syncookie_proto;
> +	case BPF_FUNC_tcp_raw_gen_syncookie_ipv4:
> +		return &bpf_tcp_raw_gen_syncookie_ipv4_proto;
> +	case BPF_FUNC_tcp_raw_gen_syncookie_ipv6:
> +		return &bpf_tcp_raw_gen_syncookie_ipv6_proto;
> +	case BPF_FUNC_tcp_raw_check_syncookie_ipv4:
> +		return &bpf_tcp_raw_check_syncookie_ipv4_proto;
> +	case BPF_FUNC_tcp_raw_check_syncookie_ipv6:
> +		return &bpf_tcp_raw_check_syncookie_ipv6_proto;
>   #endif
>   	default:
>   		return bpf_sk_base_func_proto(func_id);

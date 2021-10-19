Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C96D433CA7
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhJSQsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhJSQsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 12:48:15 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1228EC06161C;
        Tue, 19 Oct 2021 09:46:02 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i76so422467pfe.13;
        Tue, 19 Oct 2021 09:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m6ifRcXTDP6HSBZmS0xYlQ4bXkqgkStw3rde+wfGT3U=;
        b=YMR2Y6botW84pgiWlV2rOb1lBH+VAk6Qv021wt5VOUKg61nHJKFiGLsIq8B2Hh5BOK
         +utpqUnsYqfW6zzd6RufJnmu1ckI1QYNNWzaLKcFxq1x2oD1G22QZYPPtFj256grfpad
         wwZp1+EKf+qJzzNGSwCJvMI2r03UxwTpp2eOA9cz4d9+OdDbGj8K56UEty+WWPQoPbP5
         /xDeNrLwsoKNmJA/p8C2lqjGmMX7U3yG3M+CIVq3UtgNKbvEaHmt4Cqu4KfiyzhsrwL9
         emxYj/EvQljFpUD7Yipz92UQpja8PIh2RgAKkRFXtuS+XMs7w0wYAjfgeNSQY/XJ30ir
         hHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m6ifRcXTDP6HSBZmS0xYlQ4bXkqgkStw3rde+wfGT3U=;
        b=dWSpfUWYC7+UuR/qLK+9FOIUMPfh84ki2MwC5fJ9BSGEmYZ85ZvX6irnGjMBbHPfDT
         9IcHYSWwtAJ0qX4xdyuKsscVat1Gz0uhqkV/Hrmkt8SIcMPyUQdARn7VHxkbPBU94W7V
         TnljTOKzaFqVRUOSReLybVG1YteKFRyrf1GrvfV/EF0Y3vjBZW/nwAtHv/vjcm5TTKFJ
         rlgkzF9GZ52mZKekx8Gu+5rI2hepYO0H1lmt7EzNQwbSwUknkVOAivfmVrWFRgOmfa4T
         H6FrFEmoYY8DaTzutLXuVMLN/Y1bMyrWg0pa3xoIAO3u//39teC93y5IaCdCEjGiPm3X
         CrQg==
X-Gm-Message-State: AOAM532ylRfLuo+oXLr/cVS8bLWdIZxHoKKlIrIGolhhyCjSNBtnPoj4
        Mopm0DFgAWwRes/Cc/RvUZs=
X-Google-Smtp-Source: ABdhPJzFKdfpb7pBgZQZCK3ss28kxJa50w2ejY0CK3HNLNozCUKxTcbdChyP9RU5eL2TlD8n7mo39A==
X-Received: by 2002:a05:6a00:1a8e:b0:44c:f3cb:2a77 with SMTP id e14-20020a056a001a8e00b0044cf3cb2a77mr918202pfv.53.1634661961528;
        Tue, 19 Oct 2021 09:46:01 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:554e:89d1:9693:8d66? ([2620:15c:2c1:200:554e:89d1:9693:8d66])
        by smtp.gmail.com with ESMTPSA id fv9sm3346007pjb.26.2021.10.19.09.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 09:46:01 -0700 (PDT)
Subject: Re: [PATCH bpf-next 09/10] bpf: Add a helper to issue timestamp
 cookies in XDP
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-10-maximmi@nvidia.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <834e92a4-8a4d-945f-c894-9730ff7d91dc@gmail.com>
Date:   Tue, 19 Oct 2021 09:45:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019144655.3483197-10-maximmi@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/21 7:46 AM, Maxim Mikityanskiy wrote:
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
>  			      u16 *mssp);
>  __u32 cookie_v4_init_sequence(const struct sk_buff *skb, __u16 *mss);
>  u64 cookie_init_timestamp(struct request_sock *req, u64 now);
> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 *tsval, __be32 *tsecr);
>  bool cookie_timestamp_decode(const struct net *net,
>  			     struct tcp_options_received *opt);
>  bool cookie_ecn_ok(const struct tcp_options_received *opt,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index e32f72077250..791790b41874 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5053,6 +5053,32 @@ union bpf_attr {
>   *
>   *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
>   *		CONFIG_IPV6 is disabled).
> + *
> + * int bpf_tcp_raw_gen_tscookie(struct tcphdr *th, u32 th_len, __be32 *tsopt, u32 tsopt_len)
> + *	Description
> + *		Try to generate a timestamp cookie which encodes some of the
> + *		flags sent by the client in the SYN packet: SACK support, ECN
> + *		support, window scale. To be used with SYN cookies.
> + *
> + *		*th* points to the start of the TCP header of the client's SYN
> + *		packet, while *th_len* contains the length of the TCP header (at
> + *		least **sizeof**\ (**struct tcphdr**)).
> + *
> + *		*tsopt* points to the output location where to put the resulting
> + *		timestamp values: tsval and tsecr, in the format of the TCP
> + *		timestamp option.
> + *
> + *	Return
> + *		On success, 0.
> + *
> + *		On failure, the returned value is one of the following:
> + *
> + *		**-EINVAL** if the input arguments are invalid.
> + *
> + *		**-ENOENT** if the TCP header doesn't have the timestamp option.
> + *
> + *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
> + *		cookies (CONFIG_SYN_COOKIES is off).
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -5238,6 +5264,7 @@ union bpf_attr {
>  	FN(ct_release),			\
>  	FN(tcp_raw_gen_syncookie),	\
>  	FN(tcp_raw_check_syncookie),	\
> +	FN(tcp_raw_gen_tscookie),	\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5f03d4a282a0..73fe20ef7442 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7403,6 +7403,42 @@ static const struct bpf_func_proto bpf_tcp_raw_check_syncookie_proto = {
>  	.arg4_type	= ARG_CONST_SIZE,
>  };
>  
> +BPF_CALL_4(bpf_tcp_raw_gen_tscookie, struct tcphdr *, th, u32, th_len,
> +	   __be32 *, tsopt, u32, tsopt_len)
> +{
> +	int err;
> +
> +#ifdef CONFIG_SYN_COOKIES
> +	if (tsopt_len != sizeof(u64)) {
> +		err = -EINVAL;
> +		goto err_out;
> +	}
> +
> +	if (!cookie_init_timestamp_raw(th, &tsopt[0], &tsopt[1])) {
> +		err = -ENOENT;
> +		goto err_out;
> +	}
> +
> +	return 0;
> +err_out:
> +#else
> +	err = -EOPNOTSUPP;
> +#endif
> +	memset(tsopt, 0, tsopt_len);
> +	return err;
> +}
> +
> +static const struct bpf_func_proto bpf_tcp_raw_gen_tscookie_proto = {
> +	.func		= bpf_tcp_raw_gen_tscookie,
> +	.gpl_only	= false,
> +	.pkt_access	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_MEM,
> +	.arg2_type	= ARG_CONST_SIZE,
> +	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
> +	.arg4_type	= ARG_CONST_SIZE,
> +};
> +
>  #endif /* CONFIG_INET */
>  
>  bool bpf_helper_changes_pkt_data(void *func)
> @@ -7825,6 +7861,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_tcp_raw_gen_syncookie_proto;
>  	case BPF_FUNC_tcp_raw_check_syncookie:
>  		return &bpf_tcp_raw_check_syncookie_proto;
> +	case BPF_FUNC_tcp_raw_gen_tscookie:
> +		return &bpf_tcp_raw_gen_tscookie_proto;
>  #endif
>  	default:
>  		return bpf_sk_base_func_proto(func_id);
> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
> index 8696dc343ad2..4dd2c7a096eb 100644
> --- a/net/ipv4/syncookies.c
> +++ b/net/ipv4/syncookies.c
> @@ -85,6 +85,66 @@ u64 cookie_init_timestamp(struct request_sock *req, u64 now)
>  	return (u64)ts * (NSEC_PER_SEC / TCP_TS_HZ);
>  }
>  
> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 *tsval, __be32 *tsecr)
> +{
> +	int length = (th->doff * 4) - sizeof(*th);
> +	u8 wscale = TS_OPT_WSCALE_MASK;
> +	bool option_timestamp = false;
> +	bool option_sack = false;
> +	u32 cookie;
> +	u8 *ptr;
> +
> +	ptr = (u8 *)(th + 1);
> +
> +	while (length > 0) {
> +		u8 opcode = *ptr++;
> +		u8 opsize;
> +
> +		if (opcode == TCPOPT_EOL)
> +			break;
> +		if (opcode == TCPOPT_NOP) {
> +			length--;
> +			continue;
> +		}
> +
> +		if (length < 2)
> +			break;
> +		opsize = *ptr++;
> +		if (opsize < 2)
> +			break;
> +		if (opsize > length)
> +			break;
> +
> +		switch (opcode) {
> +		case TCPOPT_WINDOW:

You must check osize.

> +			wscale = min_t(u8, *ptr, TCP_MAX_WSCALE);
> +			break;
> +		case TCPOPT_TIMESTAMP:

You must check opsize.

> +			option_timestamp = true;
> +			/* Client's tsval becomes our tsecr. */
> +			*tsecr = cpu_to_be32(get_unaligned_be32(ptr));

Please avoid useless ntohl/htonl dance (even if compiler probably optimizes this)
No need to obfuscate :)

			*tsecr = get_unaligned((__be32 *)ptr);

> +			break;
> +		case TCPOPT_SACK_PERM:
> +			option_sack = true;
> +			break;
> +		}
> +
> +		ptr += opsize - 2;
> +		length -= opsize;
> +	}
> +
> +	if (!option_timestamp)
> +		return false;
> +
> +	cookie = tcp_time_stamp_raw() & ~TSMASK;
> +	cookie |= wscale & TS_OPT_WSCALE_MASK;
> +	if (option_sack)
> +		cookie |= TS_OPT_SACK;
> +	if (th->ece && th->cwr)
> +		cookie |= TS_OPT_ECN;
> +	*tsval = cpu_to_be32(cookie);
> +	return true;
> +}
>  
>  static __u32 secure_tcp_syn_cookie(__be32 saddr, __be32 daddr, __be16 sport,
>  				   __be16 dport, __u32 sseq, __u32 data)
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index e32f72077250..791790b41874 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5053,6 +5053,32 @@ union bpf_attr {
>   *
>   *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
>   *		CONFIG_IPV6 is disabled).
> + *
> + * int bpf_tcp_raw_gen_tscookie(struct tcphdr *th, u32 th_len, __be32 *tsopt, u32 tsopt_len)
> + *	Description
> + *		Try to generate a timestamp cookie which encodes some of the
> + *		flags sent by the client in the SYN packet: SACK support, ECN
> + *		support, window scale. To be used with SYN cookies.
> + *
> + *		*th* points to the start of the TCP header of the client's SYN
> + *		packet, while *th_len* contains the length of the TCP header (at
> + *		least **sizeof**\ (**struct tcphdr**)).
> + *
> + *		*tsopt* points to the output location where to put the resulting
> + *		timestamp values: tsval and tsecr, in the format of the TCP
> + *		timestamp option.
> + *
> + *	Return
> + *		On success, 0.
> + *
> + *		On failure, the returned value is one of the following:
> + *
> + *		**-EINVAL** if the input arguments are invalid.
> + *
> + *		**-ENOENT** if the TCP header doesn't have the timestamp option.
> + *
> + *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
> + *		cookies (CONFIG_SYN_COOKIES is off).
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -5238,6 +5264,7 @@ union bpf_attr {
>  	FN(ct_release),			\
>  	FN(tcp_raw_gen_syncookie),	\
>  	FN(tcp_raw_check_syncookie),	\
> +	FN(tcp_raw_gen_tscookie),	\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> 

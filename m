Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4F23FFBD5
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 10:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348231AbhICIYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 04:24:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:44384 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348203AbhICIYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 04:24:07 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mM4TT-0005dx-Fd; Fri, 03 Sep 2021 10:22:59 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mM4TT-000UbJ-6X; Fri, 03 Sep 2021 10:22:59 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf: add hardware timestamp field to
 __sk_buff
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, willemb@google.com
References: <20210902221551.15566-1-vfedorenko@novek.ru>
 <20210902221551.15566-2-vfedorenko@novek.ru>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fd2e2457-b3c2-81a4-481a-27555e4473dc@iogearbox.net>
Date:   Fri, 3 Sep 2021 10:22:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210902221551.15566-2-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26282/Thu Sep  2 10:22:04 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/21 12:15 AM, Vadim Fedorenko wrote:
> BPF programs may want to know hardware timestamps if NIC supports
> such timestamping.
> 
> Expose this data as hwtstamp field of __sk_buff the same way as
> gso_segs/gso_size.
> 
> Also update BPF_PROG_TEST_RUN tests of the feature.
> 
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>   include/uapi/linux/bpf.h       |  2 ++
>   net/core/filter.c              | 11 +++++++++++
>   tools/include/uapi/linux/bpf.h |  2 ++
>   3 files changed, 15 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 791f31dd0abe..c7d05b49f557 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5284,6 +5284,8 @@ struct __sk_buff {
>   	__u32 gso_segs;
>   	__bpf_md_ptr(struct bpf_sock *, sk);
>   	__u32 gso_size;
> +	__u32 padding;		/* Padding, future use. */

nit, instead of explicit padding field, just use: __u32 :32;

Also please add test_verifier coverage for this in BPF selftests, meaning,
the expectation would be in case someone tries to access the padding field
with this patch that we get a 'bpf verifier is misconfigured' error given
it would have no bpf_convert_ctx_access() translation. But it would be overall
better to add this to bpf_skb_is_valid_access(), so we can reject access to
the padding area right there instead.

> +	__u64 hwtstamp;
>   };
>   
>   struct bpf_tunnel_key {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2e32cee2c469..1d8f8494d325 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8884,6 +8884,17 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
>   				      si->dst_reg, si->src_reg,
>   				      offsetof(struct sk_buff, sk));
>   		break;
> +	case offsetof(struct __sk_buff, hwtstamp):
> +		BUILD_BUG_ON(sizeof_field(struct skb_shared_hwtstamps, hwtstamp) != 8);
> +		BUILD_BUG_ON(offsetof(struct skb_shared_hwtstamps, hwtstamp) != 0);
> +
> +		insn = bpf_convert_shinfo_access(si, insn);
> +		*insn++ = BPF_LDX_MEM(BPF_DW,
> +				      si->dst_reg, si->dst_reg,
> +				      bpf_target_off(struct skb_shared_info,
> +						     hwtstamps, 8,
> +						     target_size));
> +		break;
>   	}
>   
>   	return insn - insn_buf;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 791f31dd0abe..c7d05b49f557 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5284,6 +5284,8 @@ struct __sk_buff {
>   	__u32 gso_segs;
>   	__bpf_md_ptr(struct bpf_sock *, sk);
>   	__u32 gso_size;
> +	__u32 padding;		/* Padding, future use. */
> +	__u64 hwtstamp;
>   };
>   
>   struct bpf_tunnel_key {
> 


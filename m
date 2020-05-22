Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5D61DF305
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbgEVXfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:35:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:54094 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgEVXfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:35:02 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcHBh-0008AK-Pm; Sat, 23 May 2020 01:34:49 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcHBh-000TWP-HF; Sat, 23 May 2020 01:34:49 +0200
Subject: Re: [bpf-next PATCH v2] bpf: Add rx_queue_mapping to bpf_sock
To:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org
Cc:     kafai@fb.com, sridhar.samudrala@intel.com
References: <159017210823.76267.780907394437543496.stgit@anambiarhost.jf.intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a648441b-6546-c904-d2a0-583b4c9e77d7@iogearbox.net>
Date:   Sat, 23 May 2020 01:34:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <159017210823.76267.780907394437543496.stgit@anambiarhost.jf.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25820/Fri May 22 14:21:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 8:28 PM, Amritha Nambiar wrote:
> Add "rx_queue_mapping" to bpf_sock. This gives read access for the
> existing field (sk_rx_queue_mapping) of struct sock from bpf_sock.
> Semantics for the bpf_sock rx_queue_mapping access are similar to
> sk_rx_queue_get(), i.e the value NO_QUEUE_MAPPING is not allowed
> and -1 is returned in that case.

This adds the "what this patch does" but could you also add a description for
the use-case in here?

> v2: fixed build error for CONFIG_XPS wrapping, reported by
>      kbuild test robot <lkp@intel.com>
> 
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
> ---
>   include/uapi/linux/bpf.h |    1 +
>   net/core/filter.c        |   18 ++++++++++++++++++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 97e1fd19ff58..d2acd5aeae8d 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3530,6 +3530,7 @@ struct bpf_sock {
>   	__u32 dst_ip4;
>   	__u32 dst_ip6[4];
>   	__u32 state;
> +	__u32 rx_queue_mapping;
>   };
>   
>   struct bpf_tcp_sock {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bd2853d23b50..c4ba92204b73 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6829,6 +6829,7 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
>   	case offsetof(struct bpf_sock, protocol):
>   	case offsetof(struct bpf_sock, dst_port):
>   	case offsetof(struct bpf_sock, src_port):
> +	case offsetof(struct bpf_sock, rx_queue_mapping):
>   	case bpf_ctx_range(struct bpf_sock, src_ip4):
>   	case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
>   	case bpf_ctx_range(struct bpf_sock, dst_ip4):
> @@ -7872,6 +7873,23 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
>   						    skc_state),
>   				       target_size));
>   		break;
> +	case offsetof(struct bpf_sock, rx_queue_mapping):
> +#ifdef CONFIG_XPS
> +		*insn++ = BPF_LDX_MEM(
> +			BPF_FIELD_SIZEOF(struct sock, sk_rx_queue_mapping),
> +			si->dst_reg, si->src_reg,
> +			bpf_target_off(struct sock, sk_rx_queue_mapping,
> +				       sizeof_field(struct sock,
> +						    sk_rx_queue_mapping),
> +				       target_size));
> +		*insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, NO_QUEUE_MAPPING,
> +				      1);
> +		*insn++ = BPF_MOV64_IMM(si->dst_reg, -1);
> +#else
> +		*insn++ = BPF_MOV64_IMM(si->dst_reg, 0);

This should be -1 as queue mapping as well if XPS is not configured, no?
Otherwise, how do you tell it apart from an actual mapping to 0 if XPS is
built-in?

> +		*target_size = 2;
> +#endif
> +		break;
>   	}
>   
>   	return insn - insn_buf;
> 


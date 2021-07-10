Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62003C33A9
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhGJH6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230007AbhGJH6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 03:58:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AA0D6138C;
        Sat, 10 Jul 2021 07:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625903715;
        bh=I82NcPrpE2AF3Sa9S2uzODKoHfhwlgvUQmPEyDhgCWg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ro52pCSnuw7lIdE3lEdlAON16FNmS0DcEfJMUQZgKAyI/gcNQb4AAnNQg5NuSI44J
         Gwb+m6CTI18ZNBWaIipyF9+MaqAq1g2sYyGuIBnk+Cr7unBV9adxkt8StSwCczndkD
         5E/JLTSKYclTlRmvS38N0/ddK0bbJDU2YLPV6RNqk4VjBVUmAAI+NyDvu5OmTxT7E6
         w0FIX5jHOBeeisEUXAYeL+yaaUGiAfB9GmDeNPNWd7TglUMM9KS6XDxsD+pJfQmk0/
         JkyyypYxsI3fHDtxOq0Vpl3Q3qcP/S/btpAZZWTTCZ5o2ZPKq/nf8e+y3ocHaipbKo
         457akoD8ACfwg==
Date:   Sat, 10 Jul 2021 16:55:12 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCHv3 bpf-next 4/7] bpf: Add bpf_get_func_ip helper for
 kprobe programs
Message-Id: <20210710165512.8b0ffc67a894fef9a883eef2@kernel.org>
In-Reply-To: <20210707214751.159713-5-jolsa@kernel.org>
References: <20210707214751.159713-1-jolsa@kernel.org>
        <20210707214751.159713-5-jolsa@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Jul 2021 23:47:48 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> Adding bpf_get_func_ip helper for BPF_PROG_TYPE_KPROBE programs,
> so it's now possible to call bpf_get_func_ip from both kprobe and
> kretprobe programs.
> 
> Taking the caller's address from 'struct kprobe::addr', which is
> defined for both kprobe and kretprobe.
> 

Note that the kp->addr of kretprobe will be the callee function
address, even if the handler is called when the end of the callee.

Anyway, this looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/uapi/linux/bpf.h       |  2 +-
>  kernel/bpf/verifier.c          |  2 ++
>  kernel/trace/bpf_trace.c       | 17 +++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  2 +-
>  4 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 83e87ffdbb6e..4894f99a1993 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4783,7 +4783,7 @@ union bpf_attr {
>   *
>   * u64 bpf_get_func_ip(void *ctx)
>   * 	Description
> - * 		Get address of the traced function (for tracing programs).
> + * 		Get address of the traced function (for tracing and kprobe programs).
>   * 	Return
>   * 		Address of the traced function.
>   */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index f975a3aa9368..79eb9d81a198 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5979,6 +5979,8 @@ static int has_get_func_ip(struct bpf_verifier_env *env)
>  			return -ENOTSUPP;
>  		}
>  		return 0;
> +	} else if (type == BPF_PROG_TYPE_KPROBE) {
> +		return 0;
>  	}
>  
>  	verbose(env, "func %s#%d not supported for program type %d\n",
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 9edd3b1a00ad..55acf56b0c3a 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -17,6 +17,7 @@
>  #include <linux/error-injection.h>
>  #include <linux/btf_ids.h>
>  #include <linux/bpf_lsm.h>
> +#include <linux/kprobes.h>
>  
>  #include <net/bpf_sk_storage.h>
>  
> @@ -961,6 +962,20 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
>  	.arg1_type	= ARG_PTR_TO_CTX,
>  };
>  
> +BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
> +{
> +	struct kprobe *kp = kprobe_running();
> +
> +	return kp ? (u64) kp->addr : 0;
> +}
> +
> +static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> +	.func		= bpf_get_func_ip_kprobe,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +};
> +
>  const struct bpf_func_proto *
>  bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  {
> @@ -1092,6 +1107,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  	case BPF_FUNC_override_return:
>  		return &bpf_override_return_proto;
>  #endif
> +	case BPF_FUNC_get_func_ip:
> +		return &bpf_get_func_ip_proto_kprobe;
>  	default:
>  		return bpf_tracing_func_proto(func_id, prog);
>  	}
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 83e87ffdbb6e..4894f99a1993 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -4783,7 +4783,7 @@ union bpf_attr {
>   *
>   * u64 bpf_get_func_ip(void *ctx)
>   * 	Description
> - * 		Get address of the traced function (for tracing programs).
> + * 		Get address of the traced function (for tracing and kprobe programs).
>   * 	Return
>   * 		Address of the traced function.
>   */
> -- 
> 2.31.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>

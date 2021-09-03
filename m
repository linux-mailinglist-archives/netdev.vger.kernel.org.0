Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986CE3FFB72
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 10:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348044AbhICIBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 04:01:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:40308 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347597AbhICIBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 04:01:03 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mM47F-0002qT-OO; Fri, 03 Sep 2021 10:00:01 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mM47F-000Xgi-GI; Fri, 03 Sep 2021 10:00:01 +0200
Subject: Re: [PATCH v3 bpf-next 2/7] bpf: add bpf_trace_vprintk helper
To:     Dave Marchevsky <davemarchevsky@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org
References: <20210828052006.1313788-1-davemarchevsky@fb.com>
 <20210828052006.1313788-3-davemarchevsky@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1253feeb-9832-1a86-7eb2-5076698c4ca3@iogearbox.net>
Date:   Fri, 3 Sep 2021 10:00:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210828052006.1313788-3-davemarchevsky@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26282/Thu Sep  2 10:22:04 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/21 7:20 AM, Dave Marchevsky wrote:
> This helper is meant to be "bpf_trace_printk, but with proper vararg
> support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> array. Write to /sys/kernel/debug/tracing/trace_pipe using the same
> mechanism as bpf_trace_printk.
> 
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>

lgtm, minor comments below:

> ---
>   include/linux/bpf.h            |  1 +
>   include/uapi/linux/bpf.h       |  9 ++++++
>   kernel/bpf/core.c              |  5 ++++
>   kernel/bpf/helpers.c           |  2 ++
>   kernel/trace/bpf_trace.c       | 52 +++++++++++++++++++++++++++++++++-
>   tools/include/uapi/linux/bpf.h |  9 ++++++
>   6 files changed, 77 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index be8d57e6e78a..b6c45a6cbbba 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1088,6 +1088,7 @@ bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *f
>   int bpf_prog_calc_tag(struct bpf_prog *fp);
>   
>   const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
> +const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void);
>   
>   typedef unsigned long (*bpf_ctx_copy_t)(void *dst, const void *src,
>   					unsigned long off, unsigned long len);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 791f31dd0abe..f171d4d33136 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4877,6 +4877,14 @@ union bpf_attr {
>    *		Get the struct pt_regs associated with **task**.
>    *	Return
>    *		A pointer to struct pt_regs.
> + *
> + * u64 bpf_trace_vprintk(const char *fmt, u32 fmt_size, const void *data, u32 data_len)

s/u64/long/

> + *	Description
> + *		Behaves like **bpf_trace_printk**\ () helper, but takes an array of u64

nit: maybe for users it's more clear from description if you instead mention that data_len
needs to be multiple of 8 bytes? Or somehow mention the relation with data more clearly
resp. which shortcoming it addresses compared to bpf_trace_printk(), so developers can more
easily parse it.

> + *		to format. Arguments are to be used as in **bpf_seq_printf**\ () helper.
> + *	Return
> + *		The number of bytes written to the buffer, or a negative error
> + *		in case of failure.
>    */
[...]
>   	default:
>   		return NULL;
>   	}
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 10672ebc63b7..ea8358b0c748 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -398,7 +398,7 @@ static const struct bpf_func_proto bpf_trace_printk_proto = {
>   	.arg2_type	= ARG_CONST_SIZE,
>   };
>   
> -const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
> +static void __set_printk_clr_event(void)
>   {
>   	/*
>   	 * This program might be calling bpf_trace_printk,
> @@ -410,10 +410,58 @@ const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>   	 */
>   	if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
>   		pr_warn_ratelimited("could not enable bpf_trace_printk events");
> +}
>   
> +const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
> +{
> +	__set_printk_clr_event();
>   	return &bpf_trace_printk_proto;
>   }
>   
> +BPF_CALL_4(bpf_trace_vprintk, char *, fmt, u32, fmt_size, const void *, data,
> +	   u32, data_len)
> +{
> +	static char buf[BPF_TRACE_PRINTK_SIZE];
> +	unsigned long flags;
> +	int ret, num_args;
> +	u32 *bin_args;
> +
> +	if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
> +	    (data_len && !data))
> +		return -EINVAL;
> +	num_args = data_len / 8;
> +
> +	ret = bpf_bprintf_prepare(fmt, fmt_size, data, &bin_args, num_args);
> +	if (ret < 0)
> +		return ret;

Given you have ARG_PTR_TO_MEM_OR_NULL for data, does this gracefully handle the
case where you pass in fmt string containing e.g. %ps but data being NULL? From
reading bpf_bprintf_prepare() looks like it does just fine, but might be nice
to explicitly add a tiny selftest case for it while you're at it.

> +	raw_spin_lock_irqsave(&trace_printk_lock, flags);
> +	ret = bstr_printf(buf, sizeof(buf), fmt, bin_args);
> +
> +	trace_bpf_trace_printk(buf);
> +	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
> +
> +	bpf_bprintf_cleanup();
> +
> +	return ret;
> +}

Thanks,
Daniel

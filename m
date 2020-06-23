Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41832055C9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 17:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733029AbgFWPZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 11:25:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:57924 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgFWPZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 11:25:33 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnknj-0000qr-6p; Tue, 23 Jun 2020 17:25:31 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnknL-000TYI-UG; Tue, 23 Jun 2020 17:25:30 +0200
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce helper
 bpf_get_task_stack_trace()
To:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, kernel-team@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-2-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a50decc5-df68-0b6d-3449-41c5fb07330a@iogearbox.net>
Date:   Tue, 23 Jun 2020 17:22:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200623070802.2310018-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25852/Tue Jun 23 15:09:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/20 9:08 AM, Song Liu wrote:
> This helper can be used with bpf_iter__task to dump all /proc/*/stack to
> a seq_file.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   include/uapi/linux/bpf.h       | 10 +++++++++-
>   kernel/trace/bpf_trace.c       | 21 +++++++++++++++++++++
>   scripts/bpf_helpers_doc.py     |  2 ++
>   tools/include/uapi/linux/bpf.h | 10 +++++++++-
>   4 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 19684813faaed..a30416b822fe3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3252,6 +3252,13 @@ union bpf_attr {
>    * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
>    * 		is returned or the error code -EACCES in case the skb is not
>    * 		subject to CHECKSUM_UNNECESSARY.
> + *
> + * int bpf_get_task_stack_trace(struct task_struct *task, void *entries, u32 size)
> + *	Description
> + *		Save a task stack trace into array *entries*. This is a wrapper
> + *		over stack_trace_save_tsk().
> + *	Return
> + *		Number of trace entries stored.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -3389,7 +3396,8 @@ union bpf_attr {
>   	FN(ringbuf_submit),		\
>   	FN(ringbuf_discard),		\
>   	FN(ringbuf_query),		\
> -	FN(csum_level),
> +	FN(csum_level),			\
> +	FN(get_task_stack_trace),
> 
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>    * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index e729c9e587a07..2c13bcb5c2bce 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1488,6 +1488,23 @@ static const struct bpf_func_proto bpf_get_stack_proto_raw_tp = {
>   	.arg4_type	= ARG_ANYTHING,
>   };
> 
> +BPF_CALL_3(bpf_get_task_stack_trace, struct task_struct *, task,
> +	   void *, entries, u32, size)
> +{
> +	return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);

nit: cast not needed.

> +}
> +
> +static int bpf_get_task_stack_trace_btf_ids[5];
> +static const struct bpf_func_proto bpf_get_task_stack_trace_proto = {
> +	.func		= bpf_get_task_stack_trace,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_BTF_ID,
> +	.arg2_type	= ARG_PTR_TO_MEM,
> +	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,

Is there a use-case to pass in entries == NULL + size == 0?

> +	.btf_id		= bpf_get_task_stack_trace_btf_ids,
> +};
> +

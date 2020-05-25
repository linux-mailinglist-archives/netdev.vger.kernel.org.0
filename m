Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BBC1E1769
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388757AbgEYVwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:52:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:47908 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbgEYVwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:52:43 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdL1S-0007FG-NG; Mon, 25 May 2020 23:52:39 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdL1S-000EVZ-Ep; Mon, 25 May 2020 23:52:38 +0200
Subject: Re: [bpf-next PATCH v5 2/5] bpf: extend bpf_base_func_proto helpers
 with probe_* and *current_task*
To:     John Fastabend <john.fastabend@gmail.com>, yhs@fb.com,
        andrii.nakryiko@gmail.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033905529.12355.4368381069655254932.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3503d44d-799f-5440-781a-3c4cd2d89282@iogearbox.net>
Date:   Mon, 25 May 2020 23:52:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <159033905529.12355.4368381069655254932.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25823/Mon May 25 14:23:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/20 6:50 PM, John Fastabend wrote:
> Often it is useful when applying policy to know something about the
> task. If the administrator has CAP_SYS_ADMIN rights then they can
> use kprobe + networking hook and link the two programs together to
> accomplish this. However, this is a bit clunky and also means we have
> to call both the network program and kprobe program when we could just
> use a single program and avoid passing metadata through sk_msg/skb->cb,
> socket, maps, etc.
> 
> To accomplish this add probe_* helpers to bpf_base_func_proto programs
> guarded by a perfmon_capable() check. New supported helpers are the
> following,
> 
>   BPF_FUNC_get_current_task
>   BPF_FUNC_current_task_under_cgroup

Nit: Stale commit message?

>   BPF_FUNC_probe_read_user
>   BPF_FUNC_probe_read_kernel
>   BPF_FUNC_probe_read_user_str
>   BPF_FUNC_probe_read_kernel_str
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---
>   kernel/bpf/helpers.c     |   24 ++++++++++++++++++++++++
>   kernel/trace/bpf_trace.c |   10 +++++-----
>   2 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 886949f..bb4fb63 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -601,6 +601,12 @@ const struct bpf_func_proto bpf_event_output_data_proto =  {
>   	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
>   };
>   
> +const struct bpf_func_proto bpf_get_current_task_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_user_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_kernel_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_kernel_str_proto __weak;
> +
>   const struct bpf_func_proto *
>   bpf_base_func_proto(enum bpf_func_id func_id)
>   {
> @@ -648,6 +654,24 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>   	case BPF_FUNC_jiffies64:
>   		return &bpf_jiffies64_proto;
>   	default:
> +		break;
> +	}
> +
> +	if (!perfmon_capable())
> +		return NULL;
> +
> +	switch (func_id) {
> +	case BPF_FUNC_get_current_task:
> +		return &bpf_get_current_task_proto;
> +	case BPF_FUNC_probe_read_user:
> +		return &bpf_probe_read_user_proto;
> +	case BPF_FUNC_probe_read_kernel:
> +		return &bpf_probe_read_kernel_proto;
> +	case BPF_FUNC_probe_read_user_str:
> +		return &bpf_probe_read_user_str_proto;
> +	case BPF_FUNC_probe_read_kernel_str:
> +		return &bpf_probe_read_kernel_str_proto;
> +	default:
>   		return NULL;
>   	}
>   }
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 9531f54..187cd69 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -147,7 +147,7 @@ BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size,
>   	return ret;
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_user_proto = {
> +const struct bpf_func_proto bpf_probe_read_user_proto = {
>   	.func		= bpf_probe_read_user,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -167,7 +167,7 @@ BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
>   	return ret;
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_user_str_proto = {
> +const struct bpf_func_proto bpf_probe_read_user_str_proto = {
>   	.func		= bpf_probe_read_user_str,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -198,7 +198,7 @@ BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size,
>   	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, false);
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_kernel_proto = {
> +const struct bpf_func_proto bpf_probe_read_kernel_proto = {
>   	.func		= bpf_probe_read_kernel,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -253,7 +253,7 @@ BPF_CALL_3(bpf_probe_read_kernel_str, void *, dst, u32, size,
>   	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, false);
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
> +const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
>   	.func		= bpf_probe_read_kernel_str,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -907,7 +907,7 @@ BPF_CALL_0(bpf_get_current_task)
>   	return (long) current;
>   }
>   
> -static const struct bpf_func_proto bpf_get_current_task_proto = {
> +const struct bpf_func_proto bpf_get_current_task_proto = {
>   	.func		= bpf_get_current_task,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> 


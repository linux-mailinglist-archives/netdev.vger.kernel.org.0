Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B6B1DF2A7
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgEVXDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:03:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:50794 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731193AbgEVXDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:03:36 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcGhP-0004nE-5S; Sat, 23 May 2020 01:03:31 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcGhO-0003La-QL; Sat, 23 May 2020 01:03:30 +0200
Subject: Re: [bpf-next PATCH v4 2/5] bpf: extend bpf_base_func_proto helpers
 with probe_* and *current_task*
To:     John Fastabend <john.fastabend@gmail.com>, yhs@fb.com,
        andrii.nakryiko@gmail.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
References: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
 <159012146282.14791.7652481804905295417.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f6f5b27f-0a60-0e86-6e7b-f721b069a88c@iogearbox.net>
Date:   Sat, 23 May 2020 01:03:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <159012146282.14791.7652481804905295417.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25820/Fri May 22 14:21:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 6:24 AM, John Fastabend wrote:
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
>   BPF_FUNC_probe_read_user
>   BPF_FUNC_probe_read_kernel
>   BPF_FUNC_probe_read_user_str
>   BPF_FUNC_probe_read_kernel_str
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---
>   0 files changed
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 886949f..ee992dd 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -601,6 +601,13 @@ const struct bpf_func_proto bpf_event_output_data_proto =  {
>   	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
>   };
>   
> +const struct bpf_func_proto bpf_current_task_under_cgroup_proto __weak;
> +const struct bpf_func_proto bpf_get_current_task_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_user_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_kernel_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_kernel_str_proto __weak;
> +
>   const struct bpf_func_proto *
>   bpf_base_func_proto(enum bpf_func_id func_id)
>   {
> @@ -648,6 +655,26 @@ bpf_base_func_proto(enum bpf_func_id func_id)
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
> +	case BPF_FUNC_current_task_under_cgroup:
> +		return &bpf_current_task_under_cgroup_proto;

Afaics, the map creation of BPF_MAP_TYPE_CGROUP_ARRAY is only tied to CAP_BPF and
the bpf_current_task_under_cgroup() technically is not strictly tracing related.
We do have similar bpf_skb_under_cgroup() for this map type in networking, for
example, so 'current' is the only differentiator between the two.

Imho, the get_current_task() and memory probes below are fine and perfmon_capable()
is also required for them. It's just that this one above stands out from the rest,
and while thinking about it, what is the rationale for enabling bpf_current_task_under_cgroup()
but not e.g. bpf_get_current_cgroup_id() or bpf_get_current_ancestor_cgroup_id() helpers
that you've added in prior patch to sk_msg_func_proto()? What makes these different?

The question is also wrt cgroup helpers on how reliable they could be used, say, in
networking programs when we're under softirq instead of process context? Something
would need to be documented at min, but I think it's probably best to say that we
allow retrieving current and the probe mem helpers only, given for these cases you're
on your own anyway and have to know what you're doing.. while the others can be used
w/o much thought in some cases where we always have a valid current (like sock_addr
progs), but not in others tc/BPF or XDP. Wdyt?

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
> index 9531f54..6fabbc4 100644
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
> @@ -213,7 +213,7 @@ BPF_CALL_3(bpf_probe_read_compat, void *, dst, u32, size,
>   	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, true);
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_compat_proto = {
> +const struct bpf_func_proto bpf_probe_read_compat_proto = {
>   	.func		= bpf_probe_read_compat,
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
> @@ -268,7 +268,7 @@ BPF_CALL_3(bpf_probe_read_compat_str, void *, dst, u32, size,
>   	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, true);
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
> +const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
>   	.func		= bpf_probe_read_compat_str,
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
> @@ -928,7 +928,7 @@ BPF_CALL_2(bpf_current_task_under_cgroup, struct bpf_map *, map, u32, idx)
>   	return task_under_cgroup_hierarchy(current, cgrp);
>   }
>   
> -static const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
> +const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
>   	.func           = bpf_current_task_under_cgroup,
>   	.gpl_only       = false,
>   	.ret_type       = RET_INTEGER,
> 


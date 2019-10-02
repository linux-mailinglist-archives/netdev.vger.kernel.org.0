Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3885DC86BA
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 12:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfJBKwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 06:52:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:38208 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfJBKwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 06:52:33 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFcFB-0001JE-TV; Wed, 02 Oct 2019 12:52:29 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFcFB-00071q-NJ; Wed, 02 Oct 2019 12:52:29 +0200
Subject: Re: [PATCH V12 2/4] bpf: added new helper bpf_get_ns_current_pid_tgid
To:     Carlos Neira <cneirabustos@gmail.com>, netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org
References: <20191001214141.6294-1-cneirabustos@gmail.com>
 <20191001214141.6294-3-cneirabustos@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <79645731-da32-6071-e05f-6345cf47bcd1@iogearbox.net>
Date:   Wed, 2 Oct 2019 12:52:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191001214141.6294-3-cneirabustos@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25590/Wed Oct  2 10:31:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/19 11:41 PM, Carlos Neira wrote:
> New bpf helper bpf_get_ns_current_pid_tgid,
> This helper will return pid and tgid from current task
> which namespace matches dev_t and inode number provided,
> this will allows us to instrument a process inside a container.
> 
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>   include/linux/bpf.h      |  1 +
>   include/uapi/linux/bpf.h | 18 +++++++++++++++++-
>   kernel/bpf/core.c        |  1 +
>   kernel/bpf/helpers.c     | 36 ++++++++++++++++++++++++++++++++++++
>   kernel/trace/bpf_trace.c |  2 ++
>   5 files changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5b9d22338606..231001475504 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
>   extern const struct bpf_func_proto bpf_strtol_proto;
>   extern const struct bpf_func_proto bpf_strtoul_proto;
>   extern const struct bpf_func_proto bpf_tcp_sock_proto;
> +extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
>   
>   /* Shared helpers among cBPF and eBPF. */
>   void bpf_user_rnd_init_once(void);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 77c6be96d676..ea8145d7f897 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2750,6 +2750,21 @@ union bpf_attr {
>    *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
>    *
>    *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
> + *
> + * u64 bpf_get_ns_current_pid_tgid(u64 dev, u64 inum)
> + *	Return
> + *		A 64-bit integer containing the current tgid and pid from current task
> + *              which namespace inode and dev_t matches , and is create as such:
> + *		*current_task*\ **->tgid << 32 \|**
> + *		*current_task*\ **->pid**.
> + *
> + *		On failure, the returned value is one of the following:
> + *
> + *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
> + *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
> + *
> + *		**-ENOENT** if /proc/self/ns does not exists.
> + *
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -2862,7 +2877,8 @@ union bpf_attr {
>   	FN(sk_storage_get),		\
>   	FN(sk_storage_delete),		\
>   	FN(send_signal),		\
> -	FN(tcp_gen_syncookie),
> +	FN(tcp_gen_syncookie),          \
> +	FN(get_ns_current_pid_tgid),
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>    * function eBPF program intends to call
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 66088a9e9b9e..b2fd5358f472 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2042,6 +2042,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
>   const struct bpf_func_proto bpf_get_current_comm_proto __weak;
>   const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
>   const struct bpf_func_proto bpf_get_local_storage_proto __weak;
> +const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
>   
>   const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
>   {
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 5e28718928ca..8777181d1717 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -11,6 +11,8 @@
>   #include <linux/uidgid.h>
>   #include <linux/filter.h>
>   #include <linux/ctype.h>
> +#include <linux/pid_namespace.h>
> +#include <linux/proc_ns.h>
>   
>   #include "../../lib/kstrtox.h"
>   
> @@ -487,3 +489,37 @@ const struct bpf_func_proto bpf_strtoul_proto = {
>   	.arg4_type	= ARG_PTR_TO_LONG,
>   };
>   #endif
> +
> +BPF_CALL_2(bpf_get_ns_current_pid_tgid, u64, dev, u64, inum)
> +{
> +	struct task_struct *task = current;
> +	struct pid_namespace *pidns;
> +	pid_t pid, tgid;
> +
> +	if ((u64)(dev_t)dev != dev)
> +		return -EINVAL;
> +
> +	if (unlikely(!task))
> +		return -EINVAL;
> +
> +	pidns = task_active_pid_ns(task);
> +	if (unlikely(!pidns))
> +		return -ENOENT;
> +
> +
> +	if (!ns_match(&pidns->ns, (dev_t)dev, inum))
> +		return -EINVAL;
> +
> +	pid = task_pid_nr_ns(task, pidns);
> +	tgid = task_tgid_nr_ns(task, pidns);
> +
> +	return (u64) tgid << 32 | pid;

Basically here you are overlapping the 64-bit return value for the valid
outcome with the error codes above for the invalid case. If you look at
bpf_perf_event_read() we already had such broken occasion that bit us in
the past, and needed to introduce bpf_perf_event_read_value() instead.
Lets not go there again and design it similarly to the latter.

> +}
> +
> +const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto = {
> +	.func		= bpf_get_ns_current_pid_tgid,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_ANYTHING,
> +	.arg2_type	= ARG_ANYTHING,
> +};
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 44bd08f2443b..32331a1dcb6d 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -735,6 +735,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   #endif
>   	case BPF_FUNC_send_signal:
>   		return &bpf_send_signal_proto;
> +	case BPF_FUNC_get_ns_current_pid_tgid:
> +		return &bpf_get_ns_current_pid_tgid_proto;
>   	default:
>   		return NULL;
>   	}
> 


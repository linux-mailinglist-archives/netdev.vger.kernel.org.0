Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF4425F82
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbhJGVs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:48:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:40494 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbhJGVsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 17:48:55 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mYbEC-000FZ1-1R; Thu, 07 Oct 2021 23:47:00 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mYbEB-000VG4-S8; Thu, 07 Oct 2021 23:46:59 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf: add insn_processed to bpf_prog_info and
 fdinfo
To:     Dave Marchevsky <davemarchevsky@fb.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20211007080952.1255615-1-davemarchevsky@fb.com>
 <20211007080952.1255615-2-davemarchevsky@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b500e3bf-ade7-5bb5-4bcd-a67c4be8a8bc@iogearbox.net>
Date:   Thu, 7 Oct 2021 23:46:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211007080952.1255615-2-davemarchevsky@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26315/Thu Oct  7 11:09:01 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 10:09 AM, Dave Marchevsky wrote:
> This stat is currently printed in the verifier log and not stored
> anywhere. To ease consumption of this data, add a field to bpf_prog_aux
> so it can be exposed via BPF_OBJ_GET_INFO_BY_FD and fdinfo.
> 
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>   include/linux/bpf.h            | 1 +
>   include/uapi/linux/bpf.h       | 1 +
>   kernel/bpf/syscall.c           | 8 ++++++--
>   kernel/bpf/verifier.c          | 1 +
>   tools/include/uapi/linux/bpf.h | 1 +
>   5 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index d604c8251d88..921ad62b892c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -887,6 +887,7 @@ struct bpf_prog_aux {
>   	struct bpf_prog *prog;
>   	struct user_struct *user;
>   	u64 load_time; /* ns since boottime */
> +	u64 verif_insn_processed;

nit: why u64 and not u32?

>   	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
>   	char name[BPF_OBJ_NAME_LEN];
>   #ifdef CONFIG_SECURITY
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 6fc59d61937a..89be6ecf9204 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5613,6 +5613,7 @@ struct bpf_prog_info {
>   	__u64 run_time_ns;
>   	__u64 run_cnt;
>   	__u64 recursion_misses;
> +	__u64 verif_insn_processed;

There's a '__u32 :31; /* alignment pad */' which could be reused. Given this
is uapi, I'd probably just name it 'insn_processed' or 'verified_insns' (maybe
the latter is more appropriate) to avoid abbreviation on verif_ which may not
be obvious.

>   } __attribute__((aligned(8)));
>   
>   struct bpf_map_info {
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 4e50c0bfdb7d..ea452ced2296 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1848,7 +1848,8 @@ static void bpf_prog_show_fdinfo(struct seq_file *m, struct file *filp)
>   		   "prog_id:\t%u\n"
>   		   "run_time_ns:\t%llu\n"
>   		   "run_cnt:\t%llu\n"
> -		   "recursion_misses:\t%llu\n",
> +		   "recursion_misses:\t%llu\n"
> +		   "verif_insn_processed:\t%llu\n",
>   		   prog->type,
>   		   prog->jited,
>   		   prog_tag,
> @@ -1856,7 +1857,8 @@ static void bpf_prog_show_fdinfo(struct seq_file *m, struct file *filp)
>   		   prog->aux->id,
>   		   stats.nsecs,
>   		   stats.cnt,
> -		   stats.misses);
> +		   stats.misses,
> +		   prog->aux->verif_insn_processed);
>   }
>   #endif
>   
> @@ -3625,6 +3627,8 @@ static int bpf_prog_get_info_by_fd(struct file *file,
>   	info.run_cnt = stats.cnt;
>   	info.recursion_misses = stats.misses;
>   
> +	info.verif_insn_processed = prog->aux->verif_insn_processed;

Bit off-topic, but stack depth might be useful as well.

> +
>   	if (!bpf_capable()) {
>   		info.jited_prog_len = 0;
>   		info.xlated_prog_len = 0;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 20900a1bac12..9ca301191d78 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -14038,6 +14038,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
>   
>   	env->verification_time = ktime_get_ns() - start_time;
>   	print_verification_stats(env);
> +	env->prog->aux->verif_insn_processed = env->insn_processed;
>   
>   	if (log->level && bpf_verifier_log_full(log))
>   		ret = -ENOSPC;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 6fc59d61937a..89be6ecf9204 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5613,6 +5613,7 @@ struct bpf_prog_info {
>   	__u64 run_time_ns;
>   	__u64 run_cnt;
>   	__u64 recursion_misses;
> +	__u64 verif_insn_processed;
>   } __attribute__((aligned(8)));
>   
>   struct bpf_map_info {
> 


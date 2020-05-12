Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B471CF73B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbgELOf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:35:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:53908 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgELOf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:35:57 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYW0V-0007ba-3j; Tue, 12 May 2020 16:35:43 +0200
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-5.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYW0U-0009oj-Ob; Tue, 12 May 2020 16:35:42 +0200
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-security-module@vger.kernel.org, acme@redhat.com,
        jamorris@linux.microsoft.com, jannh@google.com, kpsingh@google.com
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2aac2366-151a-5ae1-d65f-9232433f425f@iogearbox.net>
Date:   Tue, 12 May 2020 16:35:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200508215340.41921-3-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25810/Tue May 12 14:14:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/20 11:53 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Implement permissions as stated in uapi/linux/capability.h
> In order to do that the verifier allow_ptr_leaks flag is split
> into allow_ptr_leaks and bpf_capable flags and they are set as:
>    env->allow_ptr_leaks = perfmon_capable();
>    env->bpf_capable = bpf_capable();
> 
> bpf_capable enables bounded loops, variable stack access and other verifier features.
> allow_ptr_leaks enable ptr leaks, ptr conversions, subtraction of pointers, etc.
> It also disables side channel mitigations.
> 
> That means that the networking BPF program loaded with CAP_BPF + CAP_NET_ADMIN will
> have speculative checks done by the verifier and other spectre mitigation applied.
> Such networking BPF program will not be able to leak kernel pointers.

I don't quite follow this part in the code below yet, see my comments.

> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[...]
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 6abd5a778fcd..c32a7880fa62 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -375,6 +375,7 @@ struct bpf_verifier_env {
>   	u32 used_map_cnt;		/* number of used maps */
>   	u32 id_gen;			/* used to generate unique reg IDs */
>   	bool allow_ptr_leaks;
> +	bool bpf_capable;
>   	bool seen_direct_write;
>   	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
>   	const struct bpf_line_info *prev_linfo;
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 95d77770353c..264a9254dc39 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -77,7 +77,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
>   	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
>   	int ret, numa_node = bpf_map_attr_numa_node(attr);
>   	u32 elem_size, index_mask, max_entries;
> -	bool unpriv = !capable(CAP_SYS_ADMIN);
> +	bool unpriv = !bpf_capable();

So here progs loaded with CAP_BPF will have spectre mitigations bypassed which
is the opposite of above statement, no?

>   	u64 cost, array_size, mask64;
>   	struct bpf_map_memory mem;
>   	struct bpf_array *array;
[...]
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 6aa11de67315..8f421dd0c4cf 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -646,7 +646,7 @@ static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
>   void bpf_prog_kallsyms_add(struct bpf_prog *fp)
>   {
>   	if (!bpf_prog_kallsyms_candidate(fp) ||
> -	    !capable(CAP_SYS_ADMIN))
> +	    !bpf_capable())
>   		return;
>   
>   	bpf_prog_ksym_set_addr(fp);
> @@ -824,7 +824,7 @@ static int bpf_jit_charge_modmem(u32 pages)
>   {
>   	if (atomic_long_add_return(pages, &bpf_jit_current) >
>   	    (bpf_jit_limit >> PAGE_SHIFT)) {
> -		if (!capable(CAP_SYS_ADMIN)) {
> +		if (!bpf_capable()) {

Should there still be an upper charge on module mem for !CAP_SYS_ADMIN?

>   			atomic_long_sub(pages, &bpf_jit_current);
>   			return -EPERM;
>   		}
[...]
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 70ad009577f8..a6893746cd87 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
[...]
> @@ -3428,7 +3429,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
>   		 * Spectre masking for stack ALU.
>   		 * See also retrieve_ptr_limit().
>   		 */
> -		if (!env->allow_ptr_leaks) {
> +		if (!env->bpf_capable) {

This needs to stay on env->allow_ptr_leaks, the can_skip_alu_sanitation() does
check on env->allow_ptr_leaks as well, otherwise this breaks spectre mitgation
when masking alu.

>   			char tn_buf[48];
>   
>   			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
> @@ -7229,7 +7230,7 @@ static int push_insn(int t, int w, int e, struct bpf_verifier_env *env,
>   		insn_stack[env->cfg.cur_stack++] = w;
>   		return 1;
>   	} else if ((insn_state[w] & 0xF0) == DISCOVERED) {
> -		if (loop_ok && env->allow_ptr_leaks)
> +		if (loop_ok && env->bpf_capable)
>   			return 0;
>   		verbose_linfo(env, t, "%d: ", t);
>   		verbose_linfo(env, w, "%d: ", w);
> @@ -8338,7 +8339,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>   	if (env->max_states_per_insn < states_cnt)
>   		env->max_states_per_insn = states_cnt;
>   
> -	if (!env->allow_ptr_leaks && states_cnt > BPF_COMPLEXITY_LIMIT_STATES)
> +	if (!env->bpf_capable && states_cnt > BPF_COMPLEXITY_LIMIT_STATES)
>   		return push_jmp_history(env, cur);
>   
>   	if (!add_new_state)
> @@ -9998,7 +9999,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>   			insn->code = BPF_JMP | BPF_TAIL_CALL;
>   
>   			aux = &env->insn_aux_data[i + delta];
> -			if (env->allow_ptr_leaks && !expect_blinding &&
> +			if (env->bpf_capable && !expect_blinding &&
>   			    prog->jit_requested &&
>   			    !bpf_map_key_poisoned(aux) &&
>   			    !bpf_map_ptr_poisoned(aux) &&
> @@ -10725,7 +10726,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>   		env->insn_aux_data[i].orig_idx = i;
>   	env->prog = *prog;
>   	env->ops = bpf_verifier_ops[env->prog->type];
> -	is_priv = capable(CAP_SYS_ADMIN);
> +	is_priv = bpf_capable();
>   
>   	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
>   		mutex_lock(&bpf_verifier_lock);
> @@ -10766,7 +10767,8 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>   	if (attr->prog_flags & BPF_F_ANY_ALIGNMENT)
>   		env->strict_alignment = false;
>   
> -	env->allow_ptr_leaks = is_priv;
> +	env->allow_ptr_leaks = perfmon_capable();
> +	env->bpf_capable = bpf_capable();
>   

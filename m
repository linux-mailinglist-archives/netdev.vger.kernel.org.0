Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717581CF874
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgELPF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:05:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:60050 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730763AbgELPFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:05:16 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYWT3-0001eq-DD; Tue, 12 May 2020 17:05:13 +0200
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-5.fritz.box)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYWT3-000X97-1y; Tue, 12 May 2020 17:05:13 +0200
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-security-module@vger.kernel.org, acme@redhat.com,
        jamorris@linux.microsoft.com, jannh@google.com, kpsingh@google.com
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fcc61b50-16f7-4fc9-5cd4-7def57f37c35@iogearbox.net>
Date:   Tue, 12 May 2020 17:05:12 +0200
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

[...]
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 70ad009577f8..a6893746cd87 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1293,7 +1293,7 @@ static void __mark_reg_unknown(const struct bpf_verifier_env *env,
>   	reg->type = SCALAR_VALUE;
>   	reg->var_off = tnum_unknown;
>   	reg->frameno = 0;
> -	reg->precise = env->subprog_cnt > 1 || !env->allow_ptr_leaks;
> +	reg->precise = env->subprog_cnt > 1 || !env->bpf_capable;
>   	__mark_reg_unbounded(reg);
>   }
>   
> @@ -1425,8 +1425,9 @@ static int check_subprogs(struct bpf_verifier_env *env)
>   			continue;
>   		if (insn[i].src_reg != BPF_PSEUDO_CALL)
>   			continue;
> -		if (!env->allow_ptr_leaks) {
> -			verbose(env, "function calls to other bpf functions are allowed for root only\n");
> +		if (!env->bpf_capable) {
> +			verbose(env,
> +				"function calls to other bpf functions are allowed for CAP_BPF and CAP_SYS_ADMIN\n");
>   			return -EPERM;
>   		}
>   		ret = add_subprog(env, i + insn[i].imm + 1);
> @@ -1960,7 +1961,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
>   	bool new_marks = false;
>   	int i, err;
>   
> -	if (!env->allow_ptr_leaks)
> +	if (!env->bpf_capable)
>   		/* backtracking is root only for now */
>   		return 0;
>   
> @@ -2208,7 +2209,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
>   		reg = &cur->regs[value_regno];
>   
>   	if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
> -	    !register_is_null(reg) && env->allow_ptr_leaks) {
> +	    !register_is_null(reg) && env->bpf_capable) {
>   		if (dst_reg != BPF_REG_FP) {
>   			/* The backtracking logic can only recognize explicit
>   			 * stack slot address like [fp - 8]. Other spill of
> @@ -3428,7 +3429,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
>   		 * Spectre masking for stack ALU.
>   		 * See also retrieve_ptr_limit().
>   		 */
> -		if (!env->allow_ptr_leaks) {
> +		if (!env->bpf_capable) {
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

Probably more of a detail, but it feels weird to tie perfmon_capable() into the BPF
core and use it in various places there. I would rather make this a proper bpf_*
prefixed helper and add a more descriptive name (what does it have to do with perf
or monitoring directly?). For example, all the main functionality could be under
`bpf_base_capable()` and everything with potential to leak pointers or mem to user
space as `bpf_leak_capable()`. Then inside include/linux/capability.h this can still
resolve under the hood to something like:

static inline bool bpf_base_capable(void)
{
	return capable(CAP_BPF) || capable(CAP_SYS_ADMIN);
}

static inline bool bpf_leak_capable(void)
{
	return perfmon_capable();
}

Thanks,
Daniel

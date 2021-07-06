Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE093BC7A8
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhGFIN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:13:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:44358 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhGFIN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 04:13:26 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m0gAC-000FvQ-Le; Tue, 06 Jul 2021 10:10:40 +0200
Received: from [85.5.47.65] (helo=linux-3.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1m0gAC-000WNp-FI; Tue, 06 Jul 2021 10:10:40 +0200
Subject: Re: [PATCH bpf 1/2] bpf: track subprog poke correctly, fix
 use-after-free
To:     John Fastabend <john.fastabend@gmail.com>,
        maciej.fijalkowski@intel.com, ast@kernel.org, andriin@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20210630194049.46453-1-john.fastabend@gmail.com>
 <20210630194049.46453-2-john.fastabend@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fae09019-fffc-dc78-3c50-483d9c042bfe@iogearbox.net>
Date:   Tue, 6 Jul 2021 10:10:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210630194049.46453-2-john.fastabend@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26222/Mon Jul  5 13:05:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/21 9:40 PM, John Fastabend wrote:
[...]
>   arch/x86/net/bpf_jit_comp.c |  4 ++++
>   include/linux/bpf.h         |  1 +
>   kernel/bpf/core.c           |  7 ++++++-
>   kernel/bpf/verifier.c       | 39 +++++++------------------------------
>   4 files changed, 18 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 2a2e290fa5d8..ce8dbc9310a9 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -576,6 +576,10 @@ static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
>   
>   	for (i = 0; i < prog->aux->size_poke_tab; i++) {
>   		poke = &prog->aux->poke_tab[i];
> +
> +		if (poke->aux && poke->aux != prog->aux)
> +			continue;
> +
>   		WARN_ON_ONCE(READ_ONCE(poke->tailcall_target_stable));
>   
>   		if (poke->reason != BPF_POKE_REASON_TAIL_CALL)
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 02b02cb29ce2..a7532cb3493a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -777,6 +777,7 @@ struct bpf_jit_poke_descriptor {
>   	void *tailcall_target;
>   	void *tailcall_bypass;
>   	void *bypass_addr;
> +	void *aux;
>   	union {
>   		struct {
>   			struct bpf_map *map;
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 5e31ee9f7512..72810314c43b 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2211,8 +2211,13 @@ static void bpf_prog_free_deferred(struct work_struct *work)
>   #endif
>   	if (aux->dst_trampoline)
>   		bpf_trampoline_put(aux->dst_trampoline);
> -	for (i = 0; i < aux->func_cnt; i++)
> +	for (i = 0; i < aux->func_cnt; i++) {
> +		/* poke_tab in subprogs are links to main prog and are
> +		 * freed above so delete link without kfree.
> +		 */
> +		aux->func[i]->aux->poke_tab = NULL;
>   		bpf_jit_free(aux->func[i]);
> +	}
>   	if (aux->func_cnt) {
>   		kfree(aux->func);
>   		bpf_prog_unlock_free(aux->prog);
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6e2ebcb0d66f..daa5a3f5e7b8 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -12109,30 +12109,17 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>   		/* the btf and func_info will be freed only at prog->aux */
>   		func[i]->aux->btf = prog->aux->btf;
>   		func[i]->aux->func_info = prog->aux->func_info;
> +		func[i]->aux->poke_tab = prog->aux->poke_tab;
> +		func[i]->aux->size_poke_tab = prog->aux->size_poke_tab;
>   
>   		for (j = 0; j < prog->aux->size_poke_tab; j++) {
> -			u32 insn_idx = prog->aux->poke_tab[j].insn_idx;
> -			int ret;
> +			struct bpf_jit_poke_descriptor *poke;
>   
> -			if (!(insn_idx >= subprog_start &&
> -			      insn_idx <= subprog_end))
> -				continue;
> -
> -			ret = bpf_jit_add_poke_descriptor(func[i],
> -							  &prog->aux->poke_tab[j]);
> -			if (ret < 0) {
> -				verbose(env, "adding tail call poke descriptor failed\n");
> -				goto out_free;
> -			}
> +			poke = &prog->aux->poke_tab[j];
>   
> -			func[i]->insnsi[insn_idx - subprog_start].imm = ret + 1;
> -
> -			map_ptr = func[i]->aux->poke_tab[ret].tail_call.map;
> -			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
> -			if (ret < 0) {
> -				verbose(env, "tracking tail call prog failed\n");
> -				goto out_free;
> -			}
> +			if (poke->insn_idx < subprog_end &&
> +			    poke->insn_idx >= subprog_start)
> +				poke->aux = func[i]->aux;
>   		}

This still has a bug which leads to a use-after-free. Check the out_free label:

   out_free:
         for (i = 0; i < env->subprog_cnt; i++) {
                 if (!func[i])
                         continue;

                 for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
                         map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
                         map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
                 }
                 bpf_jit_free(func[i]);
         }
         kfree(func);

Neither the map_poke_untrack() belongs in there nor bpf_jit_free() with non-NULL
aux->func[i]->aux->poke_tab (given it belongs to the main prog instead).

>   		/* Use bpf_prog_F_tag to indicate functions in stack traces.
> @@ -12163,18 +12150,6 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>   		cond_resched();
>   	}
>   
> -	/* Untrack main program's aux structs so that during map_poke_run()
> -	 * we will not stumble upon the unfilled poke descriptors; each
> -	 * of the main program's poke descs got distributed across subprogs
> -	 * and got tracked onto map, so we are sure that none of them will
> -	 * be missed after the operation below
> -	 */
> -	for (i = 0; i < prog->aux->size_poke_tab; i++) {
> -		map_ptr = prog->aux->poke_tab[i].tail_call.map;
> -
> -		map_ptr->ops->map_poke_untrack(map_ptr, prog->aux);
> -	}
> -
>   	/* at this point all bpf functions were successfully JITed
>   	 * now populate all bpf_calls with correct addresses and
>   	 * run last pass of JIT
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FD922C9AD
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgGXQCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:02:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:54644 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXQCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:02:36 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jz09X-0001kG-Hz; Fri, 24 Jul 2020 18:02:31 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jz09X-0007EY-Ae; Fri, 24 Jul 2020 18:02:31 +0200
Subject: Re: [PATCH v4 bpf-next 2/6] bpf: propagate poke descriptors to
 subprograms
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
References: <20200724123644.5096-1-maciej.fijalkowski@intel.com>
 <20200724123644.5096-3-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1545902f-3cbb-73bc-e241-d2e8a3118cd4@iogearbox.net>
Date:   Fri, 24 Jul 2020 18:02:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200724123644.5096-3-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25883/Fri Jul 24 16:43:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 2:36 PM, Maciej Fijalkowski wrote:
> Previously, there was no need for poke descriptors being present in
> subprogram's bpf_prog_aux struct since tailcalls were simply not allowed
> in them. Each subprog is JITed independently so in order to enable
> JITing such subprograms, simply copy poke descriptors from main program
> to subprogram's poke tab.
> 
> Add also subprog's aux struct to the BPF map poke_progs list by calling
> on it map_poke_track().
> 
> In case of any error, call the map_poke_untrack() on subprog's aux
> structs that have already been registered to prog array map.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>   kernel/bpf/verifier.c | 41 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 41 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 9a6703bc3f36..3e931e3e2239 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9900,9 +9900,12 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>   {
>   	struct bpf_prog *prog = env->prog, **func, *tmp;
>   	int i, j, subprog_start, subprog_end = 0, len, subprog;
> +	struct bpf_map *map_ptr;
>   	struct bpf_insn *insn;
>   	void *old_bpf_func;
>   	int err, num_exentries;
> +	int last_poke_desc = 0;
> +	int last_subprog = 0;
>   
>   	if (env->subprog_cnt <= 1)
>   		return 0;
> @@ -9967,6 +9970,26 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>   		func[i]->aux->btf = prog->aux->btf;
>   		func[i]->aux->func_info = prog->aux->func_info;
>   
> +		for (j = 0; j < prog->aux->size_poke_tab; j++) {
> +			int ret;
> +
> +			ret = bpf_jit_add_poke_descriptor(func[i],
> +							  &prog->aux->poke_tab[j]);
> +			if (ret < 0) {
> +				verbose(env, "adding tail call poke descriptor failed\n");
> +				goto out_untrack;
> +			}
> +			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
> +			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
> +			if (ret < 0) {
> +				verbose(env, "tracking tail call prog failed\n");
> +				goto out_untrack;
> +			}
> +			last_poke_desc = j;
> +		}
> +		last_poke_desc = 0;
> +		last_subprog = i;
> +
>   		/* Use bpf_prog_F_tag to indicate functions in stack traces.
>   		 * Long term would need debug info to populate names
>   		 */
> @@ -10059,7 +10082,25 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>   	prog->aux->func_cnt = env->subprog_cnt;
>   	bpf_prog_free_unused_jited_linfo(prog);
>   	return 0;
> +out_untrack:
> +	/* this loop is only for handling the case where propagating all of
> +	 * the main prog's poke descs was not successful for a particular
> +	 * subprog; last_poke_desc is zeroed once we walked through all
> +	 * of the poke descs; if last_poke_desc != 0 then 'i' is valid since
> +	 * it is pointing to the subprog that we were at when got an error
> +	 */
> +	while (last_poke_desc--) {
> +		map_ptr = func[i]->aux->poke_tab[last_poke_desc].tail_call.map;
> +		map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
> +	}
> +	last_subprog = i - 1;
>   out_free:
> +	for (i = last_subprog; i >= 0; i--) {
> +		for (j = 0; j < prog->aux->size_poke_tab; j++) {
> +			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
> +			map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
> +		}
> +	}

After staring at this code for a while, the logic looks correct to me, but feels overly
complicated with making sure all the corner cases do function above. I wonder, why didn't
you consider just something like ...

    	for (i = 0; i < env->subprog_cnt; i++)
    		if (func[i]) {
			for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
				map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
				map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
			}
    			bpf_jit_free(func[i]);
		}

... instead of last_poke_desc/last_subprog tracking and the fallthrough trick above. Am
I missing something?

>   	for (i = 0; i < env->subprog_cnt; i++)
>   		if (func[i])
>   			bpf_jit_free(func[i]);
> 


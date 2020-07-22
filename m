Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2387229A5C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732723AbgGVOku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:40:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:54594 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgGVOks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:40:48 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jyFvH-0000Al-9o; Wed, 22 Jul 2020 16:40:43 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jyFvH-000Rx7-4E; Wed, 22 Jul 2020 16:40:43 +0200
Subject: Re: [PATCH v2 bpf-next 2/6] bpf: propagate poke descriptors to
 subprograms
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
References: <20200721115321.3099-1-maciej.fijalkowski@intel.com>
 <20200721115321.3099-3-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <29a3dcfc-9d85-c113-19d2-e33f80ce5430@iogearbox.net>
Date:   Wed, 22 Jul 2020 16:40:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200721115321.3099-3-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25880/Tue Jul 21 16:34:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/20 1:53 PM, Maciej Fijalkowski wrote:
> Previously, there was no need for poke descriptors being present in
> subprogram's bpf_prog_aux struct since tailcalls were simply not allowed
> in them. Each subprog is JITed independently so in order to enable
> JITing such subprograms, simply copy poke descriptors from main program
> to subprogram's poke tab.
> 
> Add also subprog's aux struct to the BPF map poke_progs list by calling
> on it map_poke_track().
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>   kernel/bpf/verifier.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 3c1efc9d08fd..3428edf85220 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9936,6 +9936,9 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>   		goto out_undo_insn;
>   
>   	for (i = 0; i < env->subprog_cnt; i++) {
> +		struct bpf_map *map_ptr;
> +		int j;
> +
>   		subprog_start = subprog_end;
>   		subprog_end = env->subprog_info[i + 1].start;
>   
> @@ -9960,6 +9963,23 @@ static int jit_subprogs(struct bpf_verifier_env *env)
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
> +				goto out_free;
> +			}
> +			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
> +			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
> +			if (ret < 0) {
> +				verbose(env, "tracking tail call prog failed\n");
> +				goto out_free;
> +			}

Hmm, I don't think this is correct/complete. If some of these have been registered or
if later on the JIT'ing fails but the subprog is already exposed to the prog array then
it's /public/ at this point, so a later bpf_jit_free() in out_free will rip them mem
while doing live patching on prog updates leading to UAF.

> +		}
> +
>   		/* Use bpf_prog_F_tag to indicate functions in stack traces.
>   		 * Long term would need debug info to populate names
>   		 */
> 


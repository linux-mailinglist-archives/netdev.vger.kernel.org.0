Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FF5222D8C
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGPVQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:16:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:57226 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgGPVQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 17:16:18 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwBEk-0005Dh-Rw; Thu, 16 Jul 2020 23:16:14 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwBEk-000XQf-Kz; Thu, 16 Jul 2020 23:16:14 +0200
Subject: Re: [PATCH bpf-next 3/5] bpf: propagate poke descriptors to
 subprograms
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-4-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <93a9ff59-79d1-34ac-213e-1586fd0d04ef@iogearbox.net>
Date:   Thu, 16 Jul 2020 23:16:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200715233634.3868-4-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25875/Thu Jul 16 16:46:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/20 1:36 AM, Maciej Fijalkowski wrote:
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
>   kernel/bpf/verifier.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6481342b31ba..3b406b2860ef 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9932,6 +9932,9 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>   		goto out_undo_insn;
>   
>   	for (i = 0; i < env->subprog_cnt; i++) {
> +		struct bpf_map *map_ptr;
> +		int j;
> +
>   		subprog_start = subprog_end;
>   		subprog_end = env->subprog_info[i + 1].start;
>   
> @@ -9956,6 +9959,12 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>   		func[i]->aux->btf = prog->aux->btf;
>   		func[i]->aux->func_info = prog->aux->func_info;
>   
> +		for (j = 0; j < prog->aux->size_poke_tab; j++) {
> +			bpf_jit_add_poke_descriptor(func[i], &prog->aux->poke_tab[j]);
> +			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
> +			map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);

Error checking missing for bpf_jit_add_poke_descriptor() and map_poke_track() ..? It
must be guaranteed that adding this to the tracker must not fail, otherwise this will
be a real pain to debug given the prog will never be patched.

> +		}
> +
>   		/* Use bpf_prog_F_tag to indicate functions in stack traces.
>   		 * Long term would need debug info to populate names
>   		 */
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917063269AF
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBZVtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:49:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:59304 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZVtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 16:49:20 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFkyS-000AU9-Bp; Fri, 26 Feb 2021 22:48:36 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFkyS-000B7h-38; Fri, 26 Feb 2021 22:48:36 +0100
Subject: Re: [PATCH bpf-next v4 1/2] bpf, xdp: make bpf_redirect_map() a map
 operation
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
 <20210226112322.144927-2-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c36e681a-673d-d0d2-816a-e8f2c8ef5df7@iogearbox.net>
Date:   Fri, 26 Feb 2021 22:48:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210226112322.144927-2-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26092/Fri Feb 26 13:12:59 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/21 12:23 PM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Currently the bpf_redirect_map() implementation dispatches to the
> correct map-lookup function via a switch-statement. To avoid the
> dispatching, this change adds bpf_redirect_map() as a map
> operation. Each map provides its bpf_redirect_map() version, and
> correct function is automatically selected by the BPF verifier.
> 
> A nice side-effect of the code movement is that the map lookup
> functions are now local to the map implementation files, which removes
> one additional function call.
> 
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>   include/linux/bpf.h    | 26 ++++++--------------------
>   include/linux/filter.h | 27 +++++++++++++++++++++++++++
>   include/net/xdp_sock.h | 19 -------------------
>   kernel/bpf/cpumap.c    |  8 +++++++-
>   kernel/bpf/devmap.c    | 16 ++++++++++++++--
>   kernel/bpf/verifier.c  | 11 +++++++++--
>   net/core/filter.c      | 39 +--------------------------------------
>   net/xdp/xskmap.c       | 18 ++++++++++++++++++
>   8 files changed, 82 insertions(+), 82 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index cccaef1088ea..a44ba904ca37 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -117,6 +117,9 @@ struct bpf_map_ops {
>   					   void *owner, u32 size);
>   	struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void *owner);
>   
> +	/* XDP helpers.*/
> +	int (*xdp_redirect_map)(struct bpf_map *map, u32 ifindex, u64 flags);
> +
>   	/* map_meta_equal must be implemented for maps that can be
>   	 * used as an inner map.  It is a runtime check to ensure
>   	 * an inner map can be inserted to an outer map.
[...]
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1dda9d81f12c..96705a49225e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5409,7 +5409,8 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
>   	    func_id != BPF_FUNC_map_delete_elem &&
>   	    func_id != BPF_FUNC_map_push_elem &&
>   	    func_id != BPF_FUNC_map_pop_elem &&
> -	    func_id != BPF_FUNC_map_peek_elem)
> +	    func_id != BPF_FUNC_map_peek_elem &&
> +	    func_id != BPF_FUNC_redirect_map)
>   		return 0;
>   
>   	if (map == NULL) {
> @@ -11762,7 +11763,8 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>   		     insn->imm == BPF_FUNC_map_delete_elem ||
>   		     insn->imm == BPF_FUNC_map_push_elem   ||
>   		     insn->imm == BPF_FUNC_map_pop_elem    ||
> -		     insn->imm == BPF_FUNC_map_peek_elem)) {
> +		     insn->imm == BPF_FUNC_map_peek_elem   ||
> +		     insn->imm == BPF_FUNC_redirect_map)) {
>   			aux = &env->insn_aux_data[i + delta];
>   			if (bpf_map_ptr_poisoned(aux))
>   				goto patch_call_imm;
> @@ -11804,6 +11806,8 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>   				     (int (*)(struct bpf_map *map, void *value))NULL));
>   			BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
>   				     (int (*)(struct bpf_map *map, void *value))NULL));
> +			BUILD_BUG_ON(!__same_type(ops->xdp_redirect_map,
> +				     (int (*)(struct bpf_map *map, u32 ifindex, u64 flags))NULL));
>   patch_map_ops_generic:
>   			switch (insn->imm) {
>   			case BPF_FUNC_map_lookup_elem:
> @@ -11830,6 +11834,9 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>   				insn->imm = BPF_CAST_CALL(ops->map_peek_elem) -
>   					    __bpf_call_base;
>   				continue;
> +			case BPF_FUNC_redirect_map:
> +				insn->imm = BPF_CAST_CALL(ops->xdp_redirect_map) - __bpf_call_base;

Small nit: I would name the generic callback ops->map_redirect so that this is in line with
the general naming convention for the map ops. Otherwise this looks much better, thx!

> +				continue;
>   			}
>   
>   			goto patch_call_imm;

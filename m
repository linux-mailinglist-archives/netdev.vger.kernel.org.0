Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313B8324792
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhBXXjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:39:35 -0500
Received: from www62.your-server.de ([213.133.104.62]:58942 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhBXXjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 18:39:32 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lF3jx-000CJg-8q; Thu, 25 Feb 2021 00:38:45 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lF3jw-000B81-W6; Thu, 25 Feb 2021 00:38:45 +0100
Subject: Re: [PATCH bpf-next v3 1/2] bpf, xdp: per-map bpf_redirect_map
 functions for XDP
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
References: <20210221200954.164125-1-bjorn.topel@gmail.com>
 <20210221200954.164125-2-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <755205ef-819d-15f7-3fcd-30d964b6668d@iogearbox.net>
Date:   Thu, 25 Feb 2021 00:38:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210221200954.164125-2-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26090/Wed Feb 24 13:09:42 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/21 9:09 PM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Currently the bpf_redirect_map() implementation dispatches to the
> correct map-lookup function via a switch-statement. To avoid the
> dispatching, this change adds one bpf_redirect_map() implementation per
> map. Correct function is automatically selected by the BPF verifier.
> 
> v2->v3 : Fix build when CONFIG_NET is not set. (lkp)
> v1->v2 : Re-added comment. (Toke)
> rfc->v1: Get rid of the macro and use __always_inline. (Jesper)
> 
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

[...]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 3d34ba492d46..89ccc10c6348 100644
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
> @@ -11545,12 +11546,12 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>   	struct bpf_prog *prog = env->prog;
>   	bool expect_blinding = bpf_jit_blinding_enabled(prog);
>   	struct bpf_insn *insn = prog->insnsi;
> -	const struct bpf_func_proto *fn;
>   	const int insn_cnt = prog->len;
>   	const struct bpf_map_ops *ops;
>   	struct bpf_insn_aux_data *aux;
>   	struct bpf_insn insn_buf[16];
>   	struct bpf_prog *new_prog;
> +	bpf_func_proto_func func;
>   	struct bpf_map *map_ptr;
>   	int i, ret, cnt, delta = 0;
>   
> @@ -11860,17 +11861,23 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>   		}
>   
>   patch_call_imm:
> -		fn = env->ops->get_func_proto(insn->imm, env->prog);
> +		if (insn->imm == BPF_FUNC_redirect_map) {
> +			aux = &env->insn_aux_data[i];
> +			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
> +			func = get_xdp_redirect_func(map_ptr->map_type);

Nope, this is broken. :/ The map_ptr could be poisoned, so unconditionally fetching
map_ptr->map_type can crash the box for specially crafted BPF progs.

Also, given you add the related BPF_CALL_3() functions below, what is the reason
to not properly integrate this like the map ops near patch_map_ops_generic?

> +		} else {
> +			func = env->ops->get_func_proto(insn->imm, env->prog)->func;
> +		}
>   		/* all functions that have prototype and verifier allowed
>   		 * programs to call them, must be real in-kernel functions
>   		 */
> -		if (!fn->func) {
> +		if (!func) {
>   			verbose(env,
>   				"kernel subsystem misconfigured func %s#%d\n",
>   				func_id_name(insn->imm), insn->imm);
>   			return -EFAULT;
>   		}
> -		insn->imm = fn->func - __bpf_call_base;
> +		insn->imm = func - __bpf_call_base;
>   	}
>   
>   	/* Since poke tab is now finalized, publish aux to tracker. */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index adfdad234674..502e7856f107 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3944,22 +3944,6 @@ void xdp_do_flush(void)
>   }
>   EXPORT_SYMBOL_GPL(xdp_do_flush);
>   
> -static inline void *__xdp_map_lookup_elem(struct bpf_map *map, u32 index)
> -{
> -	switch (map->map_type) {
> -	case BPF_MAP_TYPE_DEVMAP:
> -		return __dev_map_lookup_elem(map, index);
> -	case BPF_MAP_TYPE_DEVMAP_HASH:
> -		return __dev_map_hash_lookup_elem(map, index);
> -	case BPF_MAP_TYPE_CPUMAP:
> -		return __cpu_map_lookup_elem(map, index);
> -	case BPF_MAP_TYPE_XSKMAP:
> -		return __xsk_map_lookup_elem(map, index);
> -	default:
> -		return NULL;
> -	}
> -}
> -
>   void bpf_clear_redirect_map(struct bpf_map *map)
>   {
>   	struct bpf_redirect_info *ri;
> @@ -4110,8 +4094,9 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
>   	.arg2_type      = ARG_ANYTHING,
>   };
>   
> -BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
> -	   u64, flags)
> +static __always_inline s64 __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex, u64 flags,
> +						  void *lookup_elem(struct bpf_map *map,
> +								    u32 key))
>   {
>   	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>   
> @@ -4119,7 +4104,7 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>   	if (unlikely(flags > XDP_TX))
>   		return XDP_ABORTED;
>   
> -	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
> +	ri->tgt_value = lookup_elem(map, ifindex);
>   	if (unlikely(!ri->tgt_value)) {
>   		/* If the lookup fails we want to clear out the state in the
>   		 * redirect_info struct completely, so that if an eBPF program
> @@ -4137,8 +4122,44 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>   	return XDP_REDIRECT;
>   }
>   
> +BPF_CALL_3(bpf_xdp_redirect_devmap, struct bpf_map *, map, u32, ifindex, u64, flags)
> +{
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_elem);
> +}
> +
> +BPF_CALL_3(bpf_xdp_redirect_devmap_hash, struct bpf_map *, map, u32, ifindex, u64, flags)
> +{
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_lookup_elem);
> +}
> +
> +BPF_CALL_3(bpf_xdp_redirect_cpumap, struct bpf_map *, map, u32, ifindex, u64, flags)
> +{
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_elem);
> +}
> +
> +BPF_CALL_3(bpf_xdp_redirect_xskmap, struct bpf_map *, map, u32, ifindex, u64, flags)
> +{
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_elem);
> +}
> +
> +bpf_func_proto_func get_xdp_redirect_func(enum bpf_map_type map_type)
> +{
> +	switch (map_type) {
> +	case BPF_MAP_TYPE_DEVMAP:
> +		return bpf_xdp_redirect_devmap;
> +	case BPF_MAP_TYPE_DEVMAP_HASH:
> +		return bpf_xdp_redirect_devmap_hash;
> +	case BPF_MAP_TYPE_CPUMAP:
> +		return bpf_xdp_redirect_cpumap;
> +	case BPF_MAP_TYPE_XSKMAP:
> +		return bpf_xdp_redirect_xskmap;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +/* NB! .func is NULL! get_xdp_redirect_func() is used instead! */
>   static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
> -	.func           = bpf_xdp_redirect_map,
>   	.gpl_only       = false,
>   	.ret_type       = RET_INTEGER,
>   	.arg1_type      = ARG_CONST_MAP_PTR,
> 


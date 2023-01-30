Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CCE681DA5
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 23:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjA3WE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 17:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjA3WEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 17:04:48 -0500
Received: from out-157.mta0.migadu.com (out-157.mta0.migadu.com [IPv6:2001:41d0:1004:224b::9d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C244A1D1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 14:04:23 -0800 (PST)
Message-ID: <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675116261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzXgITO6Sgy0WWxMEqer8fWo1UpMG1cjijjAJkT2HZE=;
        b=giIKQyTqsZF3Mzs7oLjM8VoRqPKTISRDT77uvthK/qG/5NKRifRfQs+9srDod5V7HdXL82
        Zk5u+b83KFNS9seyxiHv1gFahcYqUEYnOo2aUac5CsCVRZ8hBLrMqn6NyCcoE47upc2lw+
        zDEi5kvMAb3o4o+PxHKE4wr6UGTjSys=
Date:   Mon, 30 Jan 2023 14:04:08 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
Content-Language: en-US
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, memxor@gmail.com,
        kernel-team@fb.com, bpf@vger.kernel.org
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230127191703.3864860-4-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/23 11:17 AM, Joanne Koong wrote:
> @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>   		mark_reg_known_zero(env, regs, BPF_REG_0);
>   		regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
>   		regs[BPF_REG_0].mem_size = meta.mem_size;
> +		if (func_id == BPF_FUNC_dynptr_data &&
> +		    dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> +			bool seen_direct_write = env->seen_direct_write;
> +
> +			regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> +			if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> +				regs[BPF_REG_0].type |= MEM_RDONLY;
> +			else
> +				/*
> +				 * Calling may_access_direct_pkt_data() will set
> +				 * env->seen_direct_write to true if the skb is
> +				 * writable. As an optimization, we can ignore
> +				 * setting env->seen_direct_write.
> +				 *
> +				 * env->seen_direct_write is used by skb
> +				 * programs to determine whether the skb's page
> +				 * buffers should be cloned. Since data slice
> +				 * writes would only be to the head, we can skip
> +				 * this.
> +				 */
> +				env->seen_direct_write = seen_direct_write;
> +		}

[ ... ]

> @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
>   				return ret;
>   			break;
>   		case KF_ARG_PTR_TO_DYNPTR:
> +		{
> +			enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> +
>   			if (reg->type != PTR_TO_STACK &&
>   			    reg->type != CONST_PTR_TO_DYNPTR) {
>   				verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
>   				return -EINVAL;
>   			}
>   
> -			ret = process_dynptr_func(env, regno, insn_idx,
> -						  ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> +			if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> +				dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> +			else
> +				dynptr_arg_type |= MEM_RDONLY;
> +
> +			ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> +						  meta->func_id);
>   			if (ret < 0)
>   				return ret;
>   			break;
> +		}
>   		case KF_ARG_PTR_TO_LIST_HEAD:
>   			if (reg->type != PTR_TO_MAP_VALUE &&
>   			    reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>   		   desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
>   		insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
>   		*cnt = 1;
> +	} else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> +		bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);

Does it need to restore the env->seen_direct_write here also?

It seems this 'seen_direct_write' saving/restoring is needed now because 
'may_access_direct_pkt_data(BPF_WRITE)' is not only called when it is actually 
writing the packet. Some refactoring can help to avoid issue like this.

While at 'seen_direct_write', Alexei has also pointed out that the verifier 
needs to track whether the (packet) 'slice' returned by bpf_dynptr_data() has 
been written. It should be tracked in 'seen_direct_write'. Take a look at how 
reg_is_pkt_pointer() and may_access_direct_pkt_data() are done in 
check_mem_access(). iirc, this reg_is_pkt_pointer() part got loss somewhere in 
v5 (or v4?) when bpf_dynptr_data() was changed to return register typed 
PTR_TO_MEM instead of PTR_TO_PACKET.


[ ... ]

> +int bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags,
> +			struct bpf_dynptr_kern *ptr, int is_rdonly)

hmm... this exposed kfunc takes "int is_rdonly".

What if the bpf prog calls it like bpf_dynptr_from_skb(..., false) in some hook 
that is not writable to packet?

> +{
> +	if (flags) {
> +		bpf_dynptr_set_null(ptr);
> +		return -EINVAL;
> +	}
> +
> +	bpf_dynptr_init(ptr, skb, BPF_DYNPTR_TYPE_SKB, 0, skb->len);
> +
> +	if (is_rdonly)
> +		bpf_dynptr_set_rdonly(ptr);
> +
> +	return 0;
> +}
> +
>   BPF_CALL_1(bpf_sk_fullsock, struct sock *, sk)
>   {
>   	return sk_fullsock(sk) ? (unsigned long)sk : (unsigned long)NULL;
> @@ -11607,3 +11634,28 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
>   
>   	return func;
>   }
> +
> +BTF_SET8_START(bpf_kfunc_check_set_skb)
> +BTF_ID_FLAGS(func, bpf_dynptr_from_skb)
> +BTF_SET8_END(bpf_kfunc_check_set_skb)
> +
> +static const struct btf_kfunc_id_set bpf_kfunc_set_skb = {
> +	.owner = THIS_MODULE,
> +	.set = &bpf_kfunc_check_set_skb,
> +};
> +
> +static int __init bpf_kfunc_init(void)
> +{
> +	int ret;
> +
> +	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SK_SKB, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCKET_FILTER, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_OUT, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_IN, &bpf_kfunc_set_skb);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_XMIT, &bpf_kfunc_set_skb);
> +	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &bpf_kfunc_set_skb);
> +}
> +late_initcall(bpf_kfunc_init);



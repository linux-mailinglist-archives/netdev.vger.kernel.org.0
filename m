Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE19681F70
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 00:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjA3XLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 18:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjA3XLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 18:11:41 -0500
Received: from out-192.mta0.migadu.com (out-192.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DD81F5F3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 15:11:26 -0800 (PST)
Message-ID: <7c1faed8-9533-5916-5f61-4b078038c7e3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675120284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qtEt1hLT7lXUbTDxf+6AKAzBTb8zdBXIOfIlybikZ0M=;
        b=DXYEBxPEuercf38BvcnvfQw7GRQGjIgDZBq1AWfeA0m/mgIjS8QvNnPMbWBc8fs2eU2Rlg
        6b+rEYuRjWMWx8treC9iGCj6b++Iyt7Zjh2kbooJJPW7f7IgkZMqkvJkEtCnPZhBSW2KCn
        mrzwDcpeDxNPjeak51AJocoh4V9kwcQ=
Date:   Mon, 30 Jan 2023 15:11:13 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, kernel-team@fb.com,
        bpf@vger.kernel.org
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com>
 <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
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

On 1/30/23 2:31 PM, Alexei Starovoitov wrote:
> On Mon, Jan 30, 2023 at 02:04:08PM -0800, Martin KaFai Lau wrote:
>> On 1/27/23 11:17 AM, Joanne Koong wrote:
>>> @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>>>    		mark_reg_known_zero(env, regs, BPF_REG_0);
>>>    		regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
>>>    		regs[BPF_REG_0].mem_size = meta.mem_size;
>>> +		if (func_id == BPF_FUNC_dynptr_data &&
>>> +		    dynptr_type == BPF_DYNPTR_TYPE_SKB) {
>>> +			bool seen_direct_write = env->seen_direct_write;
>>> +
>>> +			regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
>>> +			if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
>>> +				regs[BPF_REG_0].type |= MEM_RDONLY;
>>> +			else
>>> +				/*
>>> +				 * Calling may_access_direct_pkt_data() will set
>>> +				 * env->seen_direct_write to true if the skb is
>>> +				 * writable. As an optimization, we can ignore
>>> +				 * setting env->seen_direct_write.
>>> +				 *
>>> +				 * env->seen_direct_write is used by skb
>>> +				 * programs to determine whether the skb's page
>>> +				 * buffers should be cloned. Since data slice
>>> +				 * writes would only be to the head, we can skip
>>> +				 * this.
>>> +				 */
>>> +				env->seen_direct_write = seen_direct_write;
>>> +		}
>>
>> [ ... ]
>>
>>> @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
>>>    				return ret;
>>>    			break;
>>>    		case KF_ARG_PTR_TO_DYNPTR:
>>> +		{
>>> +			enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
>>> +
>>>    			if (reg->type != PTR_TO_STACK &&
>>>    			    reg->type != CONST_PTR_TO_DYNPTR) {
>>>    				verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
>>>    				return -EINVAL;
>>>    			}
>>> -			ret = process_dynptr_func(env, regno, insn_idx,
>>> -						  ARG_PTR_TO_DYNPTR | MEM_RDONLY);
>>> +			if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
>>> +				dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
>>> +			else
>>> +				dynptr_arg_type |= MEM_RDONLY;
>>> +
>>> +			ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
>>> +						  meta->func_id);
>>>    			if (ret < 0)
>>>    				return ret;
>>>    			break;
>>> +		}
>>>    		case KF_ARG_PTR_TO_LIST_HEAD:
>>>    			if (reg->type != PTR_TO_MAP_VALUE &&
>>>    			    reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
>>> @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>>>    		   desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
>>>    		insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
>>>    		*cnt = 1;
>>> +	} else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
>>> +		bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
>>
>> Does it need to restore the env->seen_direct_write here also?
>>
>> It seems this 'seen_direct_write' saving/restoring is needed now because
>> 'may_access_direct_pkt_data(BPF_WRITE)' is not only called when it is
>> actually writing the packet. Some refactoring can help to avoid issue like
>> this.
>>
>> While at 'seen_direct_write', Alexei has also pointed out that the verifier
>> needs to track whether the (packet) 'slice' returned by bpf_dynptr_data()
>> has been written. It should be tracked in 'seen_direct_write'. Take a look
>> at how reg_is_pkt_pointer() and may_access_direct_pkt_data() are done in
>> check_mem_access(). iirc, this reg_is_pkt_pointer() part got loss somewhere
>> in v5 (or v4?) when bpf_dynptr_data() was changed to return register typed
>> PTR_TO_MEM instead of PTR_TO_PACKET.
> 
> btw tc progs are using gen_prologue() approach because data/data_end are not kfuncs
> (nothing is being called by the bpf prog).
> In this case we don't need to repeat this approach. If so we don't need to
> set seen_direct_write.
> Instead bpf_dynptr_data() can call bpf_skb_pull_data() directly.
> And technically we don't need to limit it to skb head. It can handle any off/len.
> It will work for skb, but there is no equivalent for xdp_pull_data().
> I don't think we can implement xdp_pull_data in all drivers.
> That's massive amount of work, but we need to be consistent if we want
> dynptr to wrap both skb and xdp.
> We can say dynptr_data is for head only, but we've seen bugs where people
> had to switch from data/data_end to load_bytes.
> 
> Also bpf_skb_pull_data is quite heavy. For progs that only want to parse
> the packet calling that in bpf_dynptr_data is a heavy hammer.
> 
> It feels that we need to go back to skb_header_pointer-like discussion.
> Something like:
> bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void *buffer)
> Whether buffer is a part of dynptr or program provided is tbd.
It would be nice if it can get something similar to skb_header_pointer(). I 
think Jakub has mentioned that also.

No pull in the common case. Copy to 'buffer' when it is not in head (for skb) or 
across frags (for xdp). In the copy-to-'buffer' case and the bpf prog did change 
the 'buffer', the bpf prog will be responsible to call bpf_dynptr_write() to 
write back to the skb/xdp if needed?


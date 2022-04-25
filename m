Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151BD50E85A
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244450AbiDYSis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 14:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbiDYSir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 14:38:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1D9B5D;
        Mon, 25 Apr 2022 11:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650911743; x=1682447743;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=jxbvBtekAQyafZG/6gsKCcs1vl7kzHFJLIuvZSknLb4=;
  b=GPXb2OyN5lbtqGqA/LfHTsxvxVxXya5CvD6hktpPttGrtQD/pGAINGRA
   avmpoNEqA+KQhMZZh+OzL2m950xyhS3lA/3sqt1EQ9DxHaQW4qaO3uRiz
   /BmUhOOob3gWTdpXt9CCm2sehDYqzflW4DF+YCfncePG75SRsNnrJX1rl
   C3C2e1VhhLozggzZdg7VvNaPrkkeghEll2S1rA9m2QsJTiWd0ktr7XPwt
   vWBdmlzL4TqJHOwrTPi2sBDfgApLW0feEGuwFA1RqAn/eROwQ/vtfvs2J
   Q4Xja2O4JpLC2fADbPKYQZlzl+z/pJpPdG5UTwoW/nTeWyUWeIxegyGMA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="265136531"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="265136531"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 11:35:42 -0700
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="677350592"
Received: from rderber-mobl.amr.corp.intel.com ([10.212.151.176])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 11:35:42 -0700
Date:   Mon, 25 Apr 2022 11:35:42 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Geliang Tang <geliang.tang@suse.com>
cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        mptcp@lists.linux.dev,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next 2/7] bpf: add bpf_skc_to_mptcp_sock_proto
In-Reply-To: <903108df-161e-515b-da3d-bff4fb49de39@iogearbox.net>
Message-ID: <b1ca1a8-8e54-b31d-3165-8cad22305b33@linux.intel.com>
References: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com> <20220420222459.307649-3-mathew.j.martineau@linux.intel.com> <903108df-161e-515b-da3d-bff4fb49de39@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022, Daniel Borkmann wrote:

> On 4/21/22 12:24 AM, Mat Martineau wrote:
> [...]
>>   static const struct bpf_func_proto *
>>   bpf_sk_base_func_proto(enum bpf_func_id func_id);
>> @@ -11279,6 +11280,19 @@ const struct bpf_func_proto 
>> bpf_skc_to_unix_sock_proto = {
>>   	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_UNIX],
>>   };
>>   +BPF_CALL_1(bpf_skc_to_mptcp_sock, struct sock *, sk)
>> +{
>> +	return (unsigned long)bpf_mptcp_sock_from_subflow(sk);
>> +}
>> +
>> +static const struct bpf_func_proto bpf_skc_to_mptcp_sock_proto = {
>> +	.func		= bpf_skc_to_mptcp_sock,
>> +	.gpl_only	= false,
>> +	.ret_type	= RET_PTR_TO_BTF_ID_OR_NULL,
>> +	.arg1_type	= ARG_PTR_TO_SOCK_COMMON,
>> +	.ret_btf_id	= &btf_sock_ids[BTF_SOCK_TYPE_MPTCP],
>> +};
>
> BPF CI 
> (https://github.com/kernel-patches/bpf/runs/6136052684?check_suite_focus=true) 
> fails with:
>
>  #7   base:FAIL
>  libbpf: prog '_sockops': BPF program load failed: Invalid argument
>  libbpf: prog '_sockops': -- BEGIN PROG LOAD LOG --
>  0: R1=ctx(off=0,imm=0) R10=fp0
>  ; int op = (int)ctx->op;
>  0: (61) r2 = *(u32 *)(r1 +0)          ; R1=ctx(off=0,imm=0) 
> R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
>  ; if (op != BPF_SOCK_OPS_TCP_CONNECT_CB)
>  1: (56) if w2 != 0x3 goto pc+50       ; R2_w=3
>  ; sk = ctx->sk;
>  2: (79) r6 = *(u64 *)(r1 +184)        ; R1=ctx(off=0,imm=0) 
> R6_w=sock_or_null(id=1,off=0,imm=0)
>  ; if (!sk)
>  3: (15) if r6 == 0x0 goto pc+48       ; R6_w=sock(off=0,imm=0)
>  ; tcp_sk = bpf_tcp_sock(sk);
>  4: (bf) r1 = r6                       ; R1_w=sock(off=0,imm=0) 
> R6_w=sock(off=0,imm=0)
>  5: (85) call bpf_tcp_sock#96          ; 
> R0_w=tcp_sock_or_null(id=2,off=0,imm=0)
>  6: (bf) r7 = r0                       ; 
> R0=tcp_sock_or_null(id=2,off=0,imm=0) R7=tcp_sock_or_null(id=2,off=0,imm=0)
>  ; if (!tcp_sk)
>  7: (15) if r7 == 0x0 goto pc+44       ; R7=tcp_sock(off=0,imm=0)
>  ; if (!tcp_sk->is_mptcp) {
>  8: (61) r1 = *(u32 *)(r7 +112)        ; 
> R1_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff)) 
> R7=tcp_sock(off=0,imm=0)
>  ; if (!tcp_sk->is_mptcp) {
>  9: (56) if w1 != 0x0 goto pc+14 24: R0=tcp_sock(off=0,imm=0) 
> R1_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff)) R6=sock(off=0,imm=0) 
> R7=tcp_sock(off=0,imm=0) R10=fp0
>  ; msk = bpf_skc_to_mptcp_sock(sk);
>  24: (bf) r1 = r6                      ; R1_w=sock(off=0,imm=0) 
> R6=sock(off=0,imm=0)
>  25: (85) call bpf_skc_to_mptcp_sock#194
>  invalid return type 8 of func bpf_skc_to_mptcp_sock#194
>  processed 34 insns (limit 1000000) max_states_per_insn 0 total_states 3 
> peak_states 3 mark_read 1
>  -- END PROG LOAD LOG --
>  libbpf: failed to load program '_sockops'
>  libbpf: failed to load object './mptcp_sock.o'
>  run_test:FAIL:165
>  test_base:FAIL:227
>  (network_helpers.c:88: errno: Protocol not supported) Failed to create 
> server socket
>  test_base:FAIL:241
>  RTNETLINK answers: No such file or directory
>  Error talking to the kernel
> [...]
>
> Looking at bpf_skc_to_tcp6_sock(), do we similarly need a BTF_TYPE_EMIT() 
> here?
>

Geliang, in addition to the BTF_TYPE_EMIT() can you also take a look at 
the places in kernel/trace/bpf_trace.c and kernel/bpf/verifier.c where 
bpf_skc_to_tcp6_sock and bpf_skc_to_tcp6_sock_proto are referenced?

--
Mat Martineau
Intel

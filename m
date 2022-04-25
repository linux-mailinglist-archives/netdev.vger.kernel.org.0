Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1756550E312
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 16:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbiDYO37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiDYO36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:29:58 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2618BB66;
        Mon, 25 Apr 2022 07:26:54 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nizfw-000AO2-4n; Mon, 25 Apr 2022 16:26:52 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nizfv-000L1s-Fh; Mon, 25 Apr 2022 16:26:51 +0200
Subject: Re: [PATCH bpf-next 2/7] bpf: add bpf_skc_to_mptcp_sock_proto
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        andrii@kernel.org, mptcp@lists.linux.dev,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
References: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
 <20220420222459.307649-3-mathew.j.martineau@linux.intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <903108df-161e-515b-da3d-bff4fb49de39@iogearbox.net>
Date:   Mon, 25 Apr 2022 16:26:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220420222459.307649-3-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26523/Mon Apr 25 10:20:35 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/22 12:24 AM, Mat Martineau wrote:
[...]
>   static const struct bpf_func_proto *
>   bpf_sk_base_func_proto(enum bpf_func_id func_id);
> @@ -11279,6 +11280,19 @@ const struct bpf_func_proto bpf_skc_to_unix_sock_proto = {
>   	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_UNIX],
>   };
>   
> +BPF_CALL_1(bpf_skc_to_mptcp_sock, struct sock *, sk)
> +{
> +	return (unsigned long)bpf_mptcp_sock_from_subflow(sk);
> +}
> +
> +static const struct bpf_func_proto bpf_skc_to_mptcp_sock_proto = {
> +	.func		= bpf_skc_to_mptcp_sock,
> +	.gpl_only	= false,
> +	.ret_type	= RET_PTR_TO_BTF_ID_OR_NULL,
> +	.arg1_type	= ARG_PTR_TO_SOCK_COMMON,
> +	.ret_btf_id	= &btf_sock_ids[BTF_SOCK_TYPE_MPTCP],
> +};

BPF CI (https://github.com/kernel-patches/bpf/runs/6136052684?check_suite_focus=true) fails with:

   #7   base:FAIL
   libbpf: prog '_sockops': BPF program load failed: Invalid argument
   libbpf: prog '_sockops': -- BEGIN PROG LOAD LOG --
   0: R1=ctx(off=0,imm=0) R10=fp0
   ; int op = (int)ctx->op;
   0: (61) r2 = *(u32 *)(r1 +0)          ; R1=ctx(off=0,imm=0) R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
   ; if (op != BPF_SOCK_OPS_TCP_CONNECT_CB)
   1: (56) if w2 != 0x3 goto pc+50       ; R2_w=3
   ; sk = ctx->sk;
   2: (79) r6 = *(u64 *)(r1 +184)        ; R1=ctx(off=0,imm=0) R6_w=sock_or_null(id=1,off=0,imm=0)
   ; if (!sk)
   3: (15) if r6 == 0x0 goto pc+48       ; R6_w=sock(off=0,imm=0)
   ; tcp_sk = bpf_tcp_sock(sk);
   4: (bf) r1 = r6                       ; R1_w=sock(off=0,imm=0) R6_w=sock(off=0,imm=0)
   5: (85) call bpf_tcp_sock#96          ; R0_w=tcp_sock_or_null(id=2,off=0,imm=0)
   6: (bf) r7 = r0                       ; R0=tcp_sock_or_null(id=2,off=0,imm=0) R7=tcp_sock_or_null(id=2,off=0,imm=0)
   ; if (!tcp_sk)
   7: (15) if r7 == 0x0 goto pc+44       ; R7=tcp_sock(off=0,imm=0)
   ; if (!tcp_sk->is_mptcp) {
   8: (61) r1 = *(u32 *)(r7 +112)        ; R1_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff)) R7=tcp_sock(off=0,imm=0)
   ; if (!tcp_sk->is_mptcp) {
   9: (56) if w1 != 0x0 goto pc+14 24: R0=tcp_sock(off=0,imm=0) R1_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff)) R6=sock(off=0,imm=0) R7=tcp_sock(off=0,imm=0) R10=fp0
   ; msk = bpf_skc_to_mptcp_sock(sk);
   24: (bf) r1 = r6                      ; R1_w=sock(off=0,imm=0) R6=sock(off=0,imm=0)
   25: (85) call bpf_skc_to_mptcp_sock#194
   invalid return type 8 of func bpf_skc_to_mptcp_sock#194
   processed 34 insns (limit 1000000) max_states_per_insn 0 total_states 3 peak_states 3 mark_read 1
   -- END PROG LOAD LOG --
   libbpf: failed to load program '_sockops'
   libbpf: failed to load object './mptcp_sock.o'
   run_test:FAIL:165
   test_base:FAIL:227
   (network_helpers.c:88: errno: Protocol not supported) Failed to create server socket
   test_base:FAIL:241
   RTNETLINK answers: No such file or directory
   Error talking to the kernel
[...]

Looking at bpf_skc_to_tcp6_sock(), do we similarly need a BTF_TYPE_EMIT() here?

Thanks,
Daniel

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1EE14B2C
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 15:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfEFNta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 09:49:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:38266 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEFNta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 09:49:30 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNdzi-0006uv-Tv; Mon, 06 May 2019 15:49:27 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNdzi-000F2F-MY; Mon, 06 May 2019 15:49:26 +0200
Subject: Re: [PATCH v6 bpf-next 02/17] bpf: verifier: mark verified-insn with
 sub-register zext flag
To:     Jiong Wang <jiong.wang@netronome.com>, alexei.starovoitov@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
 <1556880164-10689-3-git-send-email-jiong.wang@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <76304717-347f-990a-2a5a-0999ebbc3b70@iogearbox.net>
Date:   Mon, 6 May 2019 15:49:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1556880164-10689-3-git-send-email-jiong.wang@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25441/Mon May  6 10:04:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/03/2019 12:42 PM, Jiong Wang wrote:
> eBPF ISA specification requires high 32-bit cleared when low 32-bit
> sub-register is written. This applies to destination register of ALU32 etc.
> JIT back-ends must guarantee this semantic when doing code-gen.
> 
> x86-64 and arm64 ISA has the same semantic, so the corresponding JIT
> back-end doesn't need to do extra work. However, 32-bit arches (arm, nfp
> etc.) and some other 64-bit arches (powerpc, sparc etc), need explicit zero
> extension sequence to meet such semantic.
> 
> This is important, because for code the following:
> 
>   u64_value = (u64) u32_value
>   ... other uses of u64_value
> 
> compiler could exploit the semantic described above and save those zero
> extensions for extending u32_value to u64_value. Hardware, runtime, or BPF
> JIT back-ends, are responsible for guaranteeing this. Some benchmarks show
> ~40% sub-register writes out of total insns, meaning ~40% extra code-gen (
> could go up to more for some arches which requires two shifts for zero
> extension) because JIT back-end needs to do extra code-gen for all such
> instructions.
> 
> However this is not always necessary in case u32_value is never cast into
> a u64, which is quite normal in real life program. So, it would be really
> good if we could identify those places where such type cast happened, and
> only do zero extensions for them, not for the others. This could save a lot
> of BPF code-gen.
> 
> Algo:
>  - Split read flags into READ32 and READ64.
> 
>  - Record indices of instructions that do sub-register def (write). And
>    these indices need to stay with reg state so path pruning and bpf
>    to bpf function call could be handled properly.
> 
>    These indices are kept up to date while doing insn walk.
> 
>  - A full register read on an active sub-register def marks the def insn as
>    needing zero extension on dst register.
> 
>  - A new sub-register write overrides the old one.
> 
>    A new full register write makes the register free of zero extension on
>    dst register.
> 
>  - When propagating read64 during path pruning, also marks def insns whose
>    defs are hanging active sub-register.
> 
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>

[...]
> +/* This function is supposed to be used by the following 32-bit optimization
> + * code only. It returns TRUE if the source or destination register operates
> + * on 64-bit, otherwise return FALSE.
> + */
> +static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
> +		     u32 regno, struct bpf_reg_state *reg, enum reg_arg_type t)
> +{
> +	u8 code, class, op;
> +
> +	code = insn->code;
> +	class = BPF_CLASS(code);
> +	op = BPF_OP(code);
> +	if (class == BPF_JMP) {
> +		/* BPF_EXIT for "main" will reach here. Return TRUE
> +		 * conservatively.
> +		 */
> +		if (op == BPF_EXIT)
> +			return true;
> +		if (op == BPF_CALL) {
> +			/* BPF to BPF call will reach here because of marking
> +			 * caller saved clobber with DST_OP_NO_MARK for which we
> +			 * don't care the register def because they are anyway
> +			 * marked as NOT_INIT already.
> +			 */
> +			if (insn->src_reg == BPF_PSEUDO_CALL)
> +				return false;
> +			/* Helper call will reach here because of arg type
> +			 * check.
> +			 */
> +			if (t == SRC_OP)
> +				return helper_call_arg64(env, insn->imm, regno);
> +
> +			return false;
> +		}
> +	}
> +
> +	if (class == BPF_ALU64 || class == BPF_JMP ||
> +	    /* BPF_END always use BPF_ALU class. */
> +	    (class == BPF_ALU && op == BPF_END && insn->imm == 64))
> +		return true;

For the BPF_JMP + JA case we don't look at registers, but I presume here
we 'pretend' to use 64 bit regs to be more conservative as verifier would
otherwise need to do more complex analysis at the jump target wrt zero
extension, correct?

> +
> +	if (class == BPF_ALU || class == BPF_JMP32)
> +		return false;
> +
> +	if (class == BPF_LDX) {
> +		if (t != SRC_OP)
> +			return BPF_SIZE(code) == BPF_DW;
> +		/* LDX source must be ptr. */
> +		return true;
> +	}
> +
> +	if (class == BPF_STX) {
> +		if (reg->type != SCALAR_VALUE)
> +			return true;
> +		return BPF_SIZE(code) == BPF_DW;
> +	}
> +
> +	if (class == BPF_LD) {
> +		u8 mode = BPF_MODE(code);
> +
> +		/* LD_IMM64 */
> +		if (mode == BPF_IMM)
> +			return true;
> +
> +		/* Both LD_IND and LD_ABS return 32-bit data. */
> +		if (t != SRC_OP)
> +			return  false;
> +
> +		/* Implicit ctx ptr. */
> +		if (regno == BPF_REG_6)
> +			return true;
> +
> +		/* Explicit source could be any width. */
> +		return true;
> +	}
> +
> +	if (class == BPF_ST)
> +		/* The only source register for BPF_ST is a ptr. */
> +		return true;
> +
> +	/* Conservatively return true at default. */
> +	return true;
> +}

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC549DC41
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbiA0IKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:10:37 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17818 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbiA0IKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:10:36 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JktXT58QPz9sTK;
        Thu, 27 Jan 2022 16:09:13 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 16:10:33 +0800
Subject: Re: [PATCH bpf-next 2/2] arm64, bpf: support more atomic operations
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20220121135632.136976-1-houtao1@huawei.com>
 <20220121135632.136976-3-houtao1@huawei.com>
 <61f23655411bc_57f032084@john.notmuch>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <8b67fa3d-f83c-85a5-5159-70b0f913833a@huawei.com>
Date:   Thu, 27 Jan 2022 16:10:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <61f23655411bc_57f032084@john.notmuch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/27/2022 2:06 PM, John Fastabend wrote:
> Hou Tao wrote:
>> Atomics for eBPF patch series adds support for atomic[64]_fetch_add,
>> atomic[64]_[fetch_]{and,or,xor} and atomic[64]_{xchg|cmpxchg}, but
>> it only add support for x86-64, so support these atomic operations
>> for arm64 as well.
>>
>> +static int emit_lse_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
>> +{
>> +	const u8 code = insn->code;
>> +	const u8 dst = bpf2a64[insn->dst_reg];
>> +	const u8 src = bpf2a64[insn->src_reg];
>> +	const u8 tmp = bpf2a64[TMP_REG_1];
>> +	const u8 tmp2 = bpf2a64[TMP_REG_2];
>> +	const bool isdw = BPF_SIZE(code) == BPF_DW;
>> +	const s16 off = insn->off;
>> +	u8 reg;
>> +
>> +	if (!off) {
>> +		reg = dst;
>> +	} else {
>> +		emit_a64_mov_i(1, tmp, off, ctx);
>> +		emit(A64_ADD(1, tmp, tmp, dst), ctx);
>> +		reg = tmp;
>> +	}
>> +
>> +	switch (insn->imm) {
> Diff'ing X86 implementation which has a BPF_SUB case how is it avoided
> here?
I think it is just left over from patchset [1], because according to the LLVM
commit [2]
__sync_fetch_and_sub(&addr, value) is implemented by __sync_fetch_and_add(&addr,
-value).
I will post a patch to remove it.

[1]: https://lore.kernel.org/bpf/20210114181751.768687-1-jackmanb@google.com/
[2]: https://reviews.llvm.org/D72184
>> +	/* lock *(u32/u64 *)(dst_reg + off) <op>= src_reg */
>> +	case BPF_ADD:
>> +		emit(A64_STADD(isdw, reg, src), ctx);
>> +		break;
>> +	case BPF_AND:
>> +		emit(A64_MVN(isdw, tmp2, src), ctx);
>> +		emit(A64_STCLR(isdw, reg, tmp2), ctx);
>> +		break;
>> +	case BPF_OR:
>> +		emit(A64_STSET(isdw, reg, src), ctx);
>> +		break;
>> +	case BPF_XOR:
>> +		emit(A64_STEOR(isdw, reg, src), ctx);
>> +		break;
>> +	/* src_reg = atomic_fetch_add(dst_reg + off, src_reg) */
>> +	case BPF_ADD | BPF_FETCH:
>> +		emit(A64_LDADDAL(isdw, src, reg, src), ctx);
>> +		break;
>> +	case BPF_AND | BPF_FETCH:
>> +		emit(A64_MVN(isdw, tmp2, src), ctx);
>> +		emit(A64_LDCLRAL(isdw, src, reg, tmp2), ctx);
>> +		break;
>> +	case BPF_OR | BPF_FETCH:
>> +		emit(A64_LDSETAL(isdw, src, reg, src), ctx);
>> +		break;
>> +	case BPF_XOR | BPF_FETCH:
>> +		emit(A64_LDEORAL(isdw, src, reg, src), ctx);
>> +		break;
>> +	/* src_reg = atomic_xchg(dst_reg + off, src_reg); */
>> +	case BPF_XCHG:
>> +		emit(A64_SWPAL(isdw, src, reg, src), ctx);
>> +		break;
>> +	/* r0 = atomic_cmpxchg(dst_reg + off, r0, src_reg); */
>> +	case BPF_CMPXCHG:
>> +		emit(A64_CASAL(isdw, src, reg, bpf2a64[BPF_REG_0]), ctx);
>> +		break;
>> +	default:
>> +		pr_err_once("unknown atomic op code %02x\n", insn->imm);
>> +		return -EINVAL;
> Was about to suggest maybe EFAULT to align with x86, but on second
> thought seems arm jit uses EINVAL more universally so best to be
> self consistent. Just an observation.
OK. So I will still return -EINVAL for invalid atomic operation.
>
>> +	}
>> +
>> +	return 0;
>> +}
>> +
> .


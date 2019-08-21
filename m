Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB9897716
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfHUKZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:25:39 -0400
Received: from ozlabs.org ([203.11.71.1]:35609 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbfHUKZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 06:25:39 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46D3hP6b02z9sN4;
        Wed, 21 Aug 2019 20:25:24 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiong Wang <jiong.wang@netronome.com>
Cc:     bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Regression fix for bpf in v5.3 (was Re: [RFC PATCH] bpf: handle 32-bit zext during constant blinding)
In-Reply-To: <20190813171018.28221-1-naveen.n.rao@linux.vnet.ibm.com>
References: <20190813171018.28221-1-naveen.n.rao@linux.vnet.ibm.com>
Date:   Wed, 21 Aug 2019 20:25:17 +1000
Message-ID: <87d0gy6cj6.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> writes:
> Since BPF constant blinding is performed after the verifier pass, there
> are certain ALU32 instructions inserted which don't have a corresponding
> zext instruction inserted after. This is causing a kernel oops on
> powerpc and can be reproduced by running 'test_cgroup_storage' with
> bpf_jit_harden=2.
>
> Fix this by emitting BPF_ZEXT during constant blinding if
> prog->aux->verifier_zext is set.
>
> Fixes: a4b1d3c1ddf6cb ("bpf: verifier: insert zero extension according to analysis result")
> Reported-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
> This approach (the location where zext is being introduced below, in 
> particular) works for powerpc, but I am not entirely sure if this is 
> sufficient for other architectures as well. This is broken on v5.3-rc4.

Any comment on this?

This is a regression in v5.3, which results in a kernel crash, it would
be nice to get it fixed before the release please?

cheers

> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 8191a7db2777..d84146e6fd9e 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -890,7 +890,8 @@ int bpf_jit_get_func_addr(const struct bpf_prog *prog,
>  
>  static int bpf_jit_blind_insn(const struct bpf_insn *from,
>  			      const struct bpf_insn *aux,
> -			      struct bpf_insn *to_buff)
> +			      struct bpf_insn *to_buff,
> +			      bool emit_zext)
>  {
>  	struct bpf_insn *to = to_buff;
>  	u32 imm_rnd = get_random_int();
> @@ -939,6 +940,8 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
>  		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
>  		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
>  		*to++ = BPF_ALU32_REG(from->code, from->dst_reg, BPF_REG_AX);
> +		if (emit_zext)
> +			*to++ = BPF_ZEXT_REG(from->dst_reg);
>  		break;
>  
>  	case BPF_ALU64 | BPF_ADD | BPF_K:
> @@ -992,6 +995,10 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
>  			off -= 2;
>  		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
>  		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
> +		if (emit_zext) {
> +			*to++ = BPF_ZEXT_REG(BPF_REG_AX);
> +			off--;
> +		}
>  		*to++ = BPF_JMP32_REG(from->code, from->dst_reg, BPF_REG_AX,
>  				      off);
>  		break;
> @@ -1005,6 +1012,8 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
>  	case 0: /* Part 2 of BPF_LD | BPF_IMM | BPF_DW. */
>  		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ aux[0].imm);
>  		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
> +		if (emit_zext)
> +			*to++ = BPF_ZEXT_REG(BPF_REG_AX);
>  		*to++ = BPF_ALU64_REG(BPF_OR,  aux[0].dst_reg, BPF_REG_AX);
>  		break;
>  
> @@ -1088,7 +1097,8 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
>  		    insn[1].code == 0)
>  			memcpy(aux, insn, sizeof(aux));
>  
> -		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff);
> +		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff,
> +						clone->aux->verifier_zext);
>  		if (!rewritten)
>  			continue;
>  
> -- 
> 2.22.0

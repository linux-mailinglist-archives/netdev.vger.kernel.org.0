Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5842C6E00
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 01:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732106AbgK1AoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 19:44:04 -0500
Received: from www62.your-server.de ([213.133.104.62]:52848 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731981AbgK1Amh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 19:42:37 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kinul-00017Y-E5; Sat, 28 Nov 2020 01:16:35 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kinul-0003pI-8U; Sat, 28 Nov 2020 01:16:35 +0100
Subject: Re: [PATCH] bpf, x64: add extra passes without size optimizations
To:     Gary Lin <glin@suse.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, andreas.taschner@suse.com
References: <20201127072254.1061-1-glin@suse.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <28f86fa2-96dd-2fb5-db3f-38702bc6e72a@iogearbox.net>
Date:   Sat, 28 Nov 2020 01:16:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201127072254.1061-1-glin@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26001/Fri Nov 27 14:45:56 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/20 8:22 AM, Gary Lin wrote:
> The x64 bpf jit expects bpf images converge within the given passes, but
> it could fail to do so with some corner cases. For example:
> 
>        l0:     ldh [4]
>        l1:     jeq #0x537d, l2, l40
>        l2:     ld [0]
>        l3:     jeq #0xfa163e0d, l4, l40
>        l4:     ldh [12]
>        l5:     ldx #0xe
>        l6:     jeq #0x86dd, l41, l7
>        l7:     jeq #0x800, l8, l41
>        l8:     ld [x+16]
>        l9:     ja 41
> 
>          [... repeated ja 41 ]
> 
>        l40:    ja 41
>        l41:    ret #0
>        l42:    ld #len
>        l43:    ret a
> 
> This bpf program contains 32 "ja 41" instructions which are effectively
> NOPs and designed to be replaced with valid code dynamically. Ideally,
> bpf jit should optimize those "ja 41" instructions out when translating
> translating the bpf instructions into x86_64 machine code. However,
> do_jit() can only remove one "ja 41" for offset==0 on each pass, so it
> requires at least 32 runs to eliminate those JMPs and exceeds the
> current limit of passes (20). In the end, the program got rejected when
> BPF_JIT_ALWAYS_ON is set even though it's legit as a classic socket
> filter.
> 
> Instead of pursuing the fully optimized image, this commit adds 5 extra
> passes which only use imm32 JMPs and disable the NOP optimization. Since
> all imm8 JMPs (2 bytes) are replaced with imm32 JMPs, the image size is
> expected to grow, but it could reduce the size variance between passes
> and make the images more likely to converge. The NOP optimization is
> also disabled to avoid the further jump offset changes.
> 
> Due to the fact that the images are not optimized after the extra
> passes, a warning is issued to notify the user, but at least the images
> are allocated and ready to run.
> 
> Signed-off-by: Gary Lin <glin@suse.com>
> ---
>   arch/x86/net/bpf_jit_comp.c | 35 ++++++++++++++++++++++++++++-------
>   1 file changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 796506dcfc42..125f373d6e97 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -790,7 +790,8 @@ static void detect_reg_usage(struct bpf_insn *insn, int insn_cnt,
>   }
>   
>   static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
> -		  int oldproglen, struct jit_context *ctx)
> +		  int oldproglen, struct jit_context *ctx, bool no_optz,
> +		  bool allow_grow)
>   {
>   	bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
>   	struct bpf_insn *insn = bpf_prog->insnsi;
> @@ -1408,7 +1409,7 @@ xadd:			if (is_imm8(insn->off))
>   				return -EFAULT;
>   			}
>   			jmp_offset = addrs[i + insn->off] - addrs[i];
> -			if (is_imm8(jmp_offset)) {
> +			if (is_imm8(jmp_offset) && !no_optz) {
>   				EMIT2(jmp_cond, jmp_offset);
>   			} else if (is_simm32(jmp_offset)) {
>   				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
> @@ -1431,11 +1432,11 @@ xadd:			if (is_imm8(insn->off))
>   			else
>   				jmp_offset = addrs[i + insn->off] - addrs[i];
>   
> -			if (!jmp_offset)
> +			if (!jmp_offset && !no_optz)
>   				/* Optimize out nop jumps */
>   				break;
>   emit_jmp:
> -			if (is_imm8(jmp_offset)) {
> +			if (is_imm8(jmp_offset) && !no_optz) {
>   				EMIT2(0xEB, jmp_offset);
>   			} else if (is_simm32(jmp_offset)) {
>   				EMIT1_off32(0xE9, jmp_offset);
> @@ -1476,7 +1477,7 @@ xadd:			if (is_imm8(insn->off))
>   		}
>   
>   		if (image) {
> -			if (unlikely(proglen + ilen > oldproglen)) {
> +			if (unlikely(proglen + ilen > oldproglen) && !allow_grow) {
>   				pr_err("bpf_jit: fatal error\n");
>   				return -EFAULT;
>   			}
> @@ -1972,6 +1973,9 @@ struct x64_jit_data {
>   	struct jit_context ctx;
>   };
>   
> +#define MAX_JIT_PASSES 25
> +#define NO_OPTZ_PASSES (MAX_JIT_PASSES - 5)
> +
>   struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   {
>   	struct bpf_binary_header *header = NULL;
> @@ -1981,6 +1985,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   	struct jit_context ctx = {};
>   	bool tmp_blinded = false;
>   	bool extra_pass = false;
> +	bool no_optz = false;
> +	bool allow_grow = false;
>   	u8 *image = NULL;
>   	int *addrs;
>   	int pass;
> @@ -2042,8 +2048,23 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   	 * may converge on the last pass. In such case do one more
>   	 * pass to emit the final image.
>   	 */
> -	for (pass = 0; pass < 20 || image; pass++) {
> -		proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> +	for (pass = 0; pass < MAX_JIT_PASSES || image; pass++) {
> +		/*
> +		 * On the 21th pass, if the image still doesn't converge,
> +		 * then no_optz is set afterward to make do_jit() disable
> +		 * some size optimizations to reduce the size variance.
> +		 * The side effect is that the image size may grow, so
> +		 * allow_grow is flipped to true only for this pass.
> +		 */
> +		if (pass == NO_OPTZ_PASSES && !image) {
> +			pr_warn("bpf_jit: disable optimizations for further passes\n");
> +			no_optz = true;
> +			allow_grow = true;
> +		} else {
> +			allow_grow = false;
> +		}
> +
> +		proglen = do_jit(prog, addrs, image, oldproglen, &ctx, no_optz, allow_grow);

Fwiw, this logic looks quite complex and fragile to me, for example, having the no_optz
toggle can easily get missed when adding new instructions and then we run into subtle
buggy JIT images that are tricky to debug & pinpoint the source of error when running
into weird program behaviors. Also, I think this might break with BPF to BPF calls given
this relies on the images to be converged in the initial JITing step, so that in the
last extra step we're guaranteed that call offsets are fixed when filling in actual
relative offsets. In the above case, we could stop shrinking in the initial phase when
hitting the NO_OPTZ_PASSES pass and then in the extra step we continue to shrink again
(though in that case we should hit the proglen != oldproglen safeguard and fail there)
but this feels complex and not straight forward behavior and only addresses part of the
problem (e.g. not covering mentioned case for BPF to BPF calls). So far with complex
LLVM-compiled progs we haven't seen an issue of not converging within the 20 iterations,
and the synthetic case you are solving is on cBPF [or hand-crafted eBPF]. Given we had
the 1 mio insn / complexity limit more or less recently, maybe it's okay to just bump
'pass < 64' heuristic which would better address such manual written corner cases but
avoid adding fragile complexity into the JIT.. we do have the cond_resched() in the JIT
passes loop, so should not cause additional issues. Yes, the bumping doesn't address
all sort of weird corner cases, but given we haven't seen such issue at this point from
LLVM code generation side, I think it's not worth the complexity trade-off, so I'd opt
for just bumping the passes at this point.

Thanks,
Daniel

>   		if (proglen <= 0) {
>   out_image:
>   			image = NULL;
> 


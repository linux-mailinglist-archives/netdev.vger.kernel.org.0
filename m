Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D372EFB0D
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbhAHWV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 17:21:57 -0500
Received: from www62.your-server.de ([213.133.104.62]:34450 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbhAHWV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 17:21:57 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ky08A-000DnU-He; Fri, 08 Jan 2021 23:21:14 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ky08A-000BXb-BZ; Fri, 08 Jan 2021 23:21:14 +0100
Subject: Re: [PATCH RESEND v2 1/3] bpf,x64: pad NOPs to make images converge
 more easily
To:     Gary Lin <glin@suse.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
References: <20210107021701.1797-1-glin@suse.com>
 <20210107021701.1797-2-glin@suse.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <450c7789-f9bb-113e-0a88-3ef11b453846@iogearbox.net>
Date:   Fri, 8 Jan 2021 23:21:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210107021701.1797-2-glin@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26043/Fri Jan  8 13:38:18 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 3:16 AM, Gary Lin wrote:
> The x64 bpf jit expects bpf images converge within the given passes, but
> it could fail to do so with some corner cases. For example:
> 
>        l0:     ja 40
>        l1:     ja 40
> 
>          [... repeated ja 40 ]
> 
>        l39:    ja 40
>        l40:    ret #0
> 
> This bpf program contains 40 "ja 40" instructions which are effectively
> NOPs and designed to be replaced with valid code dynamically. Ideally,
> bpf jit should optimize those "ja 40" instructions out when translating
> the bpf instructions into x64 machine code. However, do_jit() can only
> remove one "ja 40" for offset==0 on each pass, so it requires at least
> 40 runs to eliminate those JMPs and exceeds the current limit of
> passes(20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> is set even though it's legit as a classic socket filter.
> 
> To make bpf images more likely converge within 20 passes, this commit
> pads some instructions with NOPs in the last 5 passes:
> 
> 1. conditional jumps
>    A possible size variance comes from the adoption of imm8 JMP. If the
>    offset is imm8, we calculate the size difference of this BPF instruction
>    between the previous and the current pass and fill the gap with NOPs.
>    To avoid the recalculation of jump offset, those NOPs are inserted before
>    the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
>    calculating the NOP number.
> 
> 2. BPF_JA
>    There are two conditions for BPF_JA.
>    a.) nop jumps
>      If this instruction is not optimized out in the previous pass,
>      instead of removing it, we insert the equivalent size of NOPs.
>    b.) label jumps
>      Similar to condition jumps, we prepend NOPs right before the JMP
>      code.
> 
> To make the code concise, emit_nops() is modified to use the signed len and
> return the number of inserted NOPs.
> 
> For bpf-to-bpf, the 'padded' flag is introduced to 'struct x64_jit_data' so
> that bpf_int_jit_compile() could know whether the program is padded in the
> previous run or not.
> 
> After applying this patch, the corner case was loaded with the following
> jit code:
> 
>      flen=45 proglen=77 pass=17 image=ffffffffc03367d4 from=jump pid=10097
>      JIT code: 00000000: 0f 1f 44 00 00 55 48 89 e5 53 41 55 31 c0 45 31
>      JIT code: 00000010: ed 48 89 fb eb 30 eb 2e eb 2c eb 2a eb 28 eb 26
>      JIT code: 00000020: eb 24 eb 22 eb 20 eb 1e eb 1c eb 1a eb 18 eb 16
>      JIT code: 00000030: eb 14 eb 12 eb 10 eb 0e eb 0c eb 0a eb 08 eb 06
>      JIT code: 00000040: eb 04 eb 02 66 90 31 c0 41 5d 5b c9 c3
> 
>       0: 0f 1f 44 00 00          nop    DWORD PTR [rax+rax*1+0x0]
>       5: 55                      push   rbp
>       6: 48 89 e5                mov    rbp,rsp
>       9: 53                      push   rbx
>       a: 41 55                   push   r13
>       c: 31 c0                   xor    eax,eax
>       e: 45 31 ed                xor    r13d,r13d
>      11: 48 89 fb                mov    rbx,rdi
>      14: eb 30                   jmp    0x46
>      16: eb 2e                   jmp    0x46
>          ...
>      3e: eb 06                   jmp    0x46
>      40: eb 04                   jmp    0x46
>      42: eb 02                   jmp    0x46
>      44: 66 90                   xchg   ax,ax
>      46: 31 c0                   xor    eax,eax
>      48: 41 5d                   pop    r13
>      4a: 5b                      pop    rbx
>      4b: c9                      leave
>      4c: c3                      ret
> 
> At the 16th pass, 15 jumps were already optimized out, and one jump was
> replaced with NOPs at 44 and the image converged at the 17th pass.
> 
> v2:
>    - Simplify the sample code in the description and provide the jit code
>    - Check the expected padding bytes with WARN_ONCE
>    - Move the 'padded' flag to 'struct x64_jit_data'
> 
> Signed-off-by: Gary Lin <glin@suse.com>
> ---
>   arch/x86/net/bpf_jit_comp.c | 86 ++++++++++++++++++++++++++-----------
>   1 file changed, 62 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 796506dcfc42..9ecc1fd72b67 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -789,8 +789,31 @@ static void detect_reg_usage(struct bpf_insn *insn, int insn_cnt,
>   	}
>   }
>   
> +static int emit_nops(u8 **pprog, int len)
> +{
> +	u8 *prog = *pprog;
> +	int i, noplen, cnt = 0;
> +
> +	while (len > 0) {
> +		noplen = len;
> +
> +		if (noplen > ASM_NOP_MAX)
> +			noplen = ASM_NOP_MAX;
> +
> +		for (i = 0; i < noplen; i++)
> +			EMIT1(ideal_nops[noplen][i]);
> +		len -= noplen;
> +	}
> +
> +	*pprog = prog;
> +
> +	return cnt;
> +}
> +
> +#define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
> +
>   static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
> -		  int oldproglen, struct jit_context *ctx)
> +		  int oldproglen, struct jit_context *ctx, bool jmp_padding)
>   {
>   	bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
>   	struct bpf_insn *insn = bpf_prog->insnsi;
> @@ -824,6 +847,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
>   		u8 jmp_cond;
>   		int ilen;
>   		u8 *func;
> +		int nops;
>   
>   		switch (insn->code) {
>   			/* ALU */
> @@ -1409,6 +1433,13 @@ xadd:			if (is_imm8(insn->off))
>   			}
>   			jmp_offset = addrs[i + insn->off] - addrs[i];
>   			if (is_imm8(jmp_offset)) {
> +				if (jmp_padding) {
> +					nops = INSN_SZ_DIFF - 2;
> +					WARN_ONCE((nops != 0 && nops != 4),
> +						  "unexpected cond_jmp padding: %d bytes\n",
> +						  nops);

Instead of all the new WARN_ONCE() occurrences, I'd rather prefer if we do a
pr_err() and reject the JITing with an error (see also the 'jmp gen bug' one).

Some folks might panic their kernel on warning, but with an error we would
recover just fine by simply aborting JITing process.

> +					cnt += emit_nops(&prog, nops);
> +				}
>   				EMIT2(jmp_cond, jmp_offset);
>   			} else if (is_simm32(jmp_offset)) {
>   				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
> @@ -1431,11 +1462,29 @@ xadd:			if (is_imm8(insn->off))
>   			else
>   				jmp_offset = addrs[i + insn->off] - addrs[i];
>   
> -			if (!jmp_offset)
> -				/* Optimize out nop jumps */
> +			if (!jmp_offset) {
> +				/*
> +				 * If jmp_padding is enabled, the extra nops will
> +				 * be inserted. Otherwise, optimize out nop jumps.
> +				 */
> +				if (jmp_padding) {
> +					nops = INSN_SZ_DIFF;
> +					WARN_ONCE((nops != 0 && nops != 2 && nops != 5),
> +						  "unexpected nop jump padding: %d bytes\n",
> +						  nops);
> +					cnt += emit_nops(&prog, nops);
> +				}
>   				break;
> +			}
>   emit_jmp:
>   			if (is_imm8(jmp_offset)) {
> +				if (jmp_padding) {
> +					nops = INSN_SZ_DIFF - 2;
> +					WARN_ONCE((nops != 0 && nops != 3),
> +						  "unexpected jump padding: %d bytes\n",
> +						  nops);
> +					cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
> +				}
>   				EMIT2(0xEB, jmp_offset);
>   			} else if (is_simm32(jmp_offset)) {
>   				EMIT1_off32(0xE9, jmp_offset);
> @@ -1578,26 +1627,6 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
>   	return 0;
>   }
>   
> -static void emit_nops(u8 **pprog, unsigned int len)
> -{
> -	unsigned int i, noplen;
> -	u8 *prog = *pprog;
> -	int cnt = 0;
> -
> -	while (len > 0) {
> -		noplen = len;
> -
> -		if (noplen > ASM_NOP_MAX)
> -			noplen = ASM_NOP_MAX;
> -
> -		for (i = 0; i < noplen; i++)
> -			EMIT1(ideal_nops[noplen][i]);
> -		len -= noplen;
> -	}
> -
> -	*pprog = prog;
> -}
> -
>   static void emit_align(u8 **pprog, u32 align)
>   {
>   	u8 *target, *prog = *pprog;
> @@ -1970,8 +1999,12 @@ struct x64_jit_data {
>   	u8 *image;
>   	int proglen;
>   	struct jit_context ctx;
> +	bool padded;
>   };
>   
> +#define MAX_PASSES 20
> +#define PADDING_PASSES (MAX_PASSES - 5)
> +
>   struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   {
>   	struct bpf_binary_header *header = NULL;
> @@ -1981,6 +2014,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   	struct jit_context ctx = {};
>   	bool tmp_blinded = false;
>   	bool extra_pass = false;
> +	bool padding = false;
>   	u8 *image = NULL;
>   	int *addrs;
>   	int pass;
> @@ -2010,6 +2044,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   		}
>   		prog->aux->jit_data = jit_data;
>   	}
> +	padding = jit_data->padded;
>   	addrs = jit_data->addrs;
>   	if (addrs) {
>   		ctx = jit_data->ctx;
> @@ -2043,7 +2078,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   	 * pass to emit the final image.
>   	 */
>   	for (pass = 0; pass < 20 || image; pass++) {

Nit: s/20/MAX_PASSES/ given we have the define now.

> -		proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
> +		if (!padding && pass >= PADDING_PASSES)

Shouldn't this rather guard on !extra_pass instead of dragging this info via jit_data->padded?

What is the rationale for the latter when JIT is called again for subprog to fill in relative
call locations?

> +			padding = true;
> +		proglen = do_jit(prog, addrs, image, oldproglen, &ctx, padding);
>   		if (proglen <= 0) {
>   out_image:
>   			image = NULL;
> @@ -2097,6 +2134,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   			jit_data->proglen = proglen;
>   			jit_data->image = image;
>   			jit_data->header = header;
> +			jit_data->padded = padding;
>   		}
>   		prog->bpf_func = (void *)image;
>   		prog->jited = 1;
> 


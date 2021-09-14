Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3557040A770
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 09:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbhINHdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 03:33:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:41046 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240787AbhINHdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 03:33:05 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mQ2uD-000F8r-Bq; Tue, 14 Sep 2021 09:31:01 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mQ2uC-0000Sp-Kk; Tue, 14 Sep 2021 09:31:00 +0200
Subject: Re: [PATCH bpf-next v2] bpf: Change value of MAX_TAIL_CALL_CNT from
 32 to 33
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        naveen.n.rao@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, bjorn@kernel.org,
        davem@davemloft.net,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Paul Chaignon <paul@cilium.io>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, sparclinux@vger.kernel.org
References: <1631325361-9851-1-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0fb8d16f-67e7-7197-fce2-a4c17f1e5987@iogearbox.net>
Date:   Tue, 14 Sep 2021 09:30:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1631325361-9851-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26293/Mon Sep 13 10:23:39 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/21 3:56 AM, Tiezhu Yang wrote:
> In the current code, the actual max tail call count is 33 which is greater
> than MAX_TAIL_CALL_CNT (defined as 32), the actual limit is not consistent
> with the meaning of MAX_TAIL_CALL_CNT, there is some confusion and need to
> spend some time to think about the reason at the first glance.
> 
> We can see the historical evolution from commit 04fd61ab36ec ("bpf: allow
> bpf programs to tail-call other bpf programs") and commit f9dabe016b63
> ("bpf: Undo off-by-one in interpreter tail call count limit").
> 
> In order to avoid changing existing behavior, the actual limit is 33 now,
> this is reasonable.
> 
> After commit 874be05f525e ("bpf, tests: Add tail call test suite"), we can
> see there exists failed testcase.
> 
> On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
>   # echo 0 > /proc/sys/net/core/bpf_jit_enable
>   # modprobe test_bpf
>   # dmesg | grep -w FAIL
>   Tail call error path, max count reached jited:0 ret 34 != 33 FAIL
> 
> On some archs:
>   # echo 1 > /proc/sys/net/core/bpf_jit_enable
>   # modprobe test_bpf
>   # dmesg | grep -w FAIL
>   Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
> 
> So it is necessary to change the value of MAX_TAIL_CALL_CNT from 32 to 33,
> then do some small changes of the related code.
> 
> With this patch, it does not change the current limit 33, MAX_TAIL_CALL_CNT
> can reflect the actual max tail call count, the tailcall selftests can work
> well, and also the above failed testcase in test_bpf can be fixed for the
> interpreter (all archs) and the JIT (all archs except for x86).
> 
>   # uname -m
>   x86_64
>   # echo 1 > /proc/sys/net/core/bpf_jit_enable
>   # modprobe test_bpf
>   # dmesg | grep -w FAIL
>   Tail call error path, max count reached jited:1 ret 33 != 34 FAIL

Could you also state in here which archs you have tested with this change? I
presume /every/ arch which has a JIT?

> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
> 
> v2:
>    -- fix the typos in the commit message and update the commit message.
>    -- fix the failed tailcall selftests for x86 jit.
>       I am not quite sure the change on x86 is proper, with this change,
>       tailcall selftests passed, but tailcall limit test in test_bpf.ko
>       failed, I do not know the reason now, I think this is another issue,
>       maybe someone more versed in x86 jit could take a look.

There should be a series from Johan coming today with regards to test_bpf.ko
that will fix the "tail call error path, max count reached" test which had an
assumption in that R0 would always be valid for the fall-through and could be
passed to the bpf_exit insn whereas it is not guaranteed and verifier, for
example, forbids a subsequent access to R0 w/o reinit. For your testing, I
would suggested to recheck once this series is out.

>   arch/arm/net/bpf_jit_32.c         | 11 ++++++-----
>   arch/arm64/net/bpf_jit_comp.c     |  7 ++++---
>   arch/mips/net/ebpf_jit.c          |  4 ++--
>   arch/powerpc/net/bpf_jit_comp32.c |  4 ++--
>   arch/powerpc/net/bpf_jit_comp64.c | 12 ++++++------
>   arch/riscv/net/bpf_jit_comp32.c   |  4 ++--
>   arch/riscv/net/bpf_jit_comp64.c   |  4 ++--
>   arch/sparc/net/bpf_jit_comp_64.c  |  8 ++++----
>   arch/x86/net/bpf_jit_comp.c       | 10 +++++-----
>   include/linux/bpf.h               |  2 +-
>   kernel/bpf/core.c                 |  4 ++--
>   11 files changed, 36 insertions(+), 34 deletions(-)
[...]
>   	/* prog = array->ptrs[index]
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 41c23f4..5d6c843 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -286,14 +286,15 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
>   	emit(A64_CMP(0, r3, tmp), ctx);
>   	emit(A64_B_(A64_COND_CS, jmp_offset), ctx);
>   
> -	/* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> -	 *     goto out;
> +	/*
>   	 * tail_call_cnt++;
> +	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> +	 *     goto out;
>   	 */
> +	emit(A64_ADD_I(1, tcc, tcc, 1), ctx);
>   	emit_a64_mov_i64(tmp, MAX_TAIL_CALL_CNT, ctx);
>   	emit(A64_CMP(1, tcc, tmp), ctx);
>   	emit(A64_B_(A64_COND_HI, jmp_offset), ctx);
> -	emit(A64_ADD_I(1, tcc, tcc, 1), ctx);
>   
>   	/* prog = array->ptrs[index];
>   	 * if (prog == NULL)
[...]
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 0fe6aac..74a9e61 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -402,7 +402,7 @@ static int get_pop_bytes(bool *callee_regs_used)
>    * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
>    *   if (index >= array->map.max_entries)
>    *     goto out;
> - *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
> + *   if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)

Why such inconsistency to e.g. above with arm64 case but also compared to
x86 32 bit which uses JAE? If so, we should cleanly follow the reference
implementation (== interpreter) _everywhere_ and _not_ introduce additional
variants/implementations across JITs.

>    *     goto out;
>    *   prog = array->ptrs[index];
>    *   if (prog == NULL)
> @@ -452,13 +452,13 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
>   	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
>   
>   	/*
> -	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> +	 * if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)
>   	 *	goto out;
>   	 */
>   	EMIT2_off32(0x8B, 0x85, tcc_off);         /* mov eax, dword ptr [rbp - tcc_off] */
>   	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
>   #define OFFSET2 (off2 + RETPOLINE_RCX_BPF_JIT_SIZE)
> -	EMIT2(X86_JA, OFFSET2);                   /* ja out */
> +	EMIT2(X86_JE, OFFSET2);                   /* je out */
>   	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
>   	EMIT2_off32(0x89, 0x85, tcc_off);         /* mov dword ptr [rbp - tcc_off], eax */
>   
> @@ -530,12 +530,12 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
>   	}
>   
>   	/*
> -	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> +	 * if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)
>   	 *	goto out;
>   	 */
>   	EMIT2_off32(0x8B, 0x85, tcc_off);             /* mov eax, dword ptr [rbp - tcc_off] */
>   	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);         /* cmp eax, MAX_TAIL_CALL_CNT */
> -	EMIT2(X86_JA, off1);                          /* ja out */
> +	EMIT2(X86_JE, off1);                          /* je out */
>   	EMIT3(0x83, 0xC0, 0x01);                      /* add eax, 1 */
>   	EMIT2_off32(0x89, 0x85, tcc_off);             /* mov dword ptr [rbp - tcc_off], eax */
>   
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f4c16f1..224cc7e 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1046,7 +1046,7 @@ struct bpf_array {
>   };
>   
>   #define BPF_COMPLEXITY_LIMIT_INSNS      1000000 /* yes. 1M insns */
> -#define MAX_TAIL_CALL_CNT 32
> +#define MAX_TAIL_CALL_CNT 33
>   
>   #define BPF_F_ACCESS_MASK	(BPF_F_RDONLY |		\
>   				 BPF_F_RDONLY_PROG |	\
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 9f4636d..8edb1c3 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1564,10 +1564,10 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
>   
>   		if (unlikely(index >= array->map.max_entries))
>   			goto out;
> -		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
> -			goto out;
>   
>   		tail_call_cnt++;
> +		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
> +			goto out;
>   
>   		prog = READ_ONCE(array->ptrs[index]);
>   		if (!prog)
> 


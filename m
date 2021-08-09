Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FFE3E490E
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 17:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhHIPoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 11:44:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:49910 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbhHIPm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 11:42:26 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mD7Pb-0008Yg-3E; Mon, 09 Aug 2021 17:41:59 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mD7Pa-000DNS-Jk; Mon, 09 Aug 2021 17:41:58 +0200
Subject: Re: [PATCH bpf-next 7/7] x86: bpf: Fix comments on tail call count
 limiting
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>, ast@kernel.org,
        andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        illusionist.neo@gmail.com, zlim.lnx@gmail.com,
        paulburton@kernel.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, luke.r.nels@gmail.com, bjorn@kernel.org,
        iii@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        davem@davemloft.net, udknight@gmail.com
References: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
 <20210809093437.876558-8-johan.almbladh@anyfinetworks.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bab35321-9142-c51d-7244-438fc5a0efb9@iogearbox.net>
Date:   Mon, 9 Aug 2021 17:41:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210809093437.876558-8-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26258/Mon Aug  9 10:18:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/21 11:34 AM, Johan Almbladh wrote:
> Before, the comments in the 32-bit eBPF JIT claimed that up to
> MAX_TAIL_CALL_CNT + 1 tail calls were allowed, when in fact the
> implementation was using the correct limit of MAX_TAIL_CALL_CNT.
> Now, the comments are in line with what the code actually does.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>   arch/x86/net/bpf_jit_comp32.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
> index 3bfda5f502cb..8db9ab11abda 100644
> --- a/arch/x86/net/bpf_jit_comp32.c
> +++ b/arch/x86/net/bpf_jit_comp32.c
> @@ -1272,7 +1272,7 @@ static void emit_epilogue(u8 **pprog, u32 stack_depth)
>    * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
>    *   if (index >= array->map.max_entries)
>    *     goto out;
> - *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
> + *   if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
>    *     goto out;
>    *   prog = array->ptrs[index];
>    *   if (prog == NULL)
> @@ -1307,7 +1307,7 @@ static void emit_bpf_tail_call(u8 **pprog)
>   	EMIT2(IA32_JBE, jmp_label(jmp_label1, 2));
>   
>   	/*
> -	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> +	 * if (tail_call_cnt >= MAX_TAIL_CALL_CNT)
>   	 *     goto out;
>   	 */
>   	lo = (u32)MAX_TAIL_CALL_CNT;
> @@ -1321,7 +1321,7 @@ static void emit_bpf_tail_call(u8 **pprog)
>   	/* cmp ecx,lo */
>   	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);
>   
> -	/* ja out */
> +	/* jae out */
>   	EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));

You have me confused here ... b61a28cf11d6 ("bpf: Fix off-by-one in tail call count
limiting") from bpf-next says '[interpreter is now] in line with the behavior of the
x86 JITs'. From the latter I assumed you implicitly refer to x86-64. Which one did you
test specifically wrt the prior statement? It looks like x86-64 vs x86-32 differ:

   [...]
   EMIT2_off32(0x8B, 0x85, tcc_off);         /* mov eax, dword ptr [rbp - tcc_off] */
   EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
   EMIT2(X86_JA, OFFSET2);                   /* ja out */
   EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
   EMIT2_off32(0x89, 0x85, tcc_off);         /* mov dword ptr [rbp - tcc_off], eax */
   [...]

So it's ja vs jae ... unless I need more coffee? ;)

>   	/* add eax,0x1 */
> 


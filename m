Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB084222D11
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGPUgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:36:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:52162 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgGPUgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:36:11 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwAbw-0001FI-Bm; Thu, 16 Jul 2020 22:36:08 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwAbw-0009qD-4z; Thu, 16 Jul 2020 22:36:08 +0200
Subject: Re: [PATCH bpf-next 1/5] bpf, x64: use %rcx instead of %rax for tail
 call retpolines
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-2-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d631a16d-2cf0-cf12-2ddc-82ac64e51f6e@iogearbox.net>
Date:   Thu, 16 Jul 2020 22:36:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200715233634.3868-2-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25875/Thu Jul 16 16:46:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/20 1:36 AM, Maciej Fijalkowski wrote:
> Currently, %rax is used to store the jump target when BPF program is
> emitting the retpoline instructions that are handling the indirect
> tailcall.
> 
> There is a plan to use %rax for different purpose, which is storing the
> tail call counter. In order to preserve this value across the tailcalls,
> use %rcx instead for jump target storage in retpoline instructions.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>   arch/x86/include/asm/nospec-branch.h | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index e7752b4038ff..e491c3d9f227 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -314,19 +314,19 @@ static inline void mds_idle_clear_cpu_buffers(void)
>    *    lfence
>    *    jmp spec_trap
>    *  do_rop:
> - *    mov %rax,(%rsp) for x86_64
> + *    mov %rcx,(%rsp) for x86_64
>    *    mov %edx,(%esp) for x86_32
>    *    retq
>    *
>    * Without retpolines configured:
>    *
> - *    jmp *%rax for x86_64
> + *    jmp *%rcx for x86_64
>    *    jmp *%edx for x86_32
>    */
>   #ifdef CONFIG_RETPOLINE
>   # ifdef CONFIG_X86_64
> -#  define RETPOLINE_RAX_BPF_JIT_SIZE	17
> -#  define RETPOLINE_RAX_BPF_JIT()				\
> +#  define RETPOLINE_RCX_BPF_JIT_SIZE	17
> +#  define RETPOLINE_RCX_BPF_JIT()				\
>   do {								\
>   	EMIT1_off32(0xE8, 7);	 /* callq do_rop */		\
>   	/* spec_trap: */					\
> @@ -334,7 +334,7 @@ do {								\
>   	EMIT3(0x0F, 0xAE, 0xE8); /* lfence */			\
>   	EMIT2(0xEB, 0xF9);       /* jmp spec_trap */		\
>   	/* do_rop: */						\
> -	EMIT4(0x48, 0x89, 0x04, 0x24); /* mov %rax,(%rsp) */	\
> +	EMIT4(0x48, 0x89, 0x0C, 0x24); /* mov %rcx,(%rsp) */	\
>   	EMIT1(0xC3);             /* retq */			\
>   } while (0)
>   # else /* !CONFIG_X86_64 */
> @@ -352,9 +352,9 @@ do {								\
>   # endif
>   #else /* !CONFIG_RETPOLINE */
>   # ifdef CONFIG_X86_64
> -#  define RETPOLINE_RAX_BPF_JIT_SIZE	2
> -#  define RETPOLINE_RAX_BPF_JIT()				\
> -	EMIT2(0xFF, 0xE0);       /* jmp *%rax */
> +#  define RETPOLINE_RCX_BPF_JIT_SIZE	2
> +#  define RETPOLINE_RCX_BPF_JIT()				\
> +	EMIT2(0xFF, 0xE1);       /* jmp *%rcx */

Hmm, so the target prog gets loaded into rax in emit_bpf_tail_call_indirect()
but then you jump into rcx? What am I missing? This still needs to be bisectable.

>   # else /* !CONFIG_X86_64 */
>   #  define RETPOLINE_EDX_BPF_JIT()				\
>   	EMIT2(0xFF, 0xE2)        /* jmp *%edx */
> 


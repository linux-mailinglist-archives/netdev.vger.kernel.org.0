Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75863AB1DF
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 13:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhFQLGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 07:06:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:50258 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhFQLGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 07:06:20 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltpof-000GAa-G9; Thu, 17 Jun 2021 13:04:09 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltpof-0003GQ-7d; Thu, 17 Jun 2021 13:04:09 +0200
Subject: Re: [PATCH bpf-next] bpf, x86: Remove unused cnt increase from EMIT
 macro
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20210616133400.315039-1-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <08876866-c004-ede7-6657-10a15f51f6d8@iogearbox.net>
Date:   Thu, 17 Jun 2021 13:04:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210616133400.315039-1-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26203/Wed Jun 16 13:07:58 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/21 3:34 PM, Jiri Olsa wrote:
> Removing unused cnt increase from EMIT macro together
> with cnt declarations. This was introduced in commit [1]
> to ensure proper code generation. But that code was
> removed in commit [2] and this extra code was left in.
> 
> [1] b52f00e6a715 ("x86: bpf_jit: implement bpf_tail_call() helper")
> [2] ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>   arch/x86/net/bpf_jit_comp.c | 39 ++++++++++---------------------------
>   1 file changed, 10 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 2a2e290fa5d8..19715542cd9c 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -31,7 +31,7 @@ static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
>   }
>   
>   #define EMIT(bytes, len) \
> -	do { prog = emit_code(prog, bytes, len); cnt += len; } while (0)
> +	do { prog = emit_code(prog, bytes, len); } while (0)
>   
>   #define EMIT1(b1)		EMIT(b1, 1)
>   #define EMIT2(b1, b2)		EMIT((b1) + ((b2) << 8), 2)
> @@ -239,7 +239,6 @@ struct jit_context {
>   static void push_callee_regs(u8 **pprog, bool *callee_regs_used)
>   {
>   	u8 *prog = *pprog;
> -	int cnt = 0;
>   
>   	if (callee_regs_used[0])
>   		EMIT1(0x53);         /* push rbx */
> @@ -255,7 +254,6 @@ static void push_callee_regs(u8 **pprog, bool *callee_regs_used)
>   static void pop_callee_regs(u8 **pprog, bool *callee_regs_used)
>   {
>   	u8 *prog = *pprog;
> -	int cnt = 0;
>   
>   	if (callee_regs_used[3])
>   		EMIT2(0x41, 0x5F);   /* pop r15 */
> @@ -303,7 +301,6 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,

nit: In emit_prologue() we also have cnt that we could just replace with X86_PATCH_SIZE
directly as well.

>   static int emit_patch(u8 **pprog, void *func, void *ip, u8 opcode)
>   {
>   	u8 *prog = *pprog;

Otherwise, lgtm.

Thanks,
Daniel

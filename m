Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A6437EE7B
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242159AbhELVvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:51:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:46736 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241781AbhELU63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 16:58:29 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lgvuQ-000FjQ-J8; Wed, 12 May 2021 22:56:46 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lgvuQ-000Rj0-9d; Wed, 12 May 2021 22:56:46 +0200
Subject: Re: [PATCH bpf-next] bpf: arm64: Replace STACK_ALIGN() with
 round_up() to align stack size
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1620651119-5663-1-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c1f5d54e-333f-733b-5806-498f2b4e3d5a@iogearbox.net>
Date:   Wed, 12 May 2021 22:56:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1620651119-5663-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26168/Wed May 12 13:07:33 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/21 2:51 PM, Tiezhu Yang wrote:
> Use the common function round_up() directly to show the align size
> explicitly, the function STACK_ALIGN() is needless, remove it.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   arch/arm64/net/bpf_jit_comp.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index f7b1948..81c380f 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -178,9 +178,6 @@ static bool is_addsub_imm(u32 imm)
>   	return !(imm & ~0xfff) || !(imm & ~0xfff000);
>   }
>   
> -/* Stack must be multiples of 16B */
> -#define STACK_ALIGN(sz) (((sz) + 15) & ~15)
> -
>   /* Tail call offset to jump into */
>   #if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
>   #define PROLOGUE_OFFSET 8
> @@ -255,7 +252,7 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
>   			emit(A64_BTI_J, ctx);
>   	}
>   
> -	ctx->stack_size = STACK_ALIGN(prog->aux->stack_depth);
> +	ctx->stack_size = round_up(prog->aux->stack_depth, 16);
>   

Applied, thanks! (I retained the comment wrt stack requirement to have it explicitly stated.)

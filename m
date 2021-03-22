Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC041343C38
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 10:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCVJBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 05:01:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:41384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhCVJAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 05:00:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C4E01AD71;
        Mon, 22 Mar 2021 09:00:43 +0000 (UTC)
Date:   Mon, 22 Mar 2021 10:00:36 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20210322090036.GB10031@zn.tnic>
References: <20210322143714.494603ed@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210322143714.494603ed@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 02:37:14PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> arch/x86/net/bpf_jit_comp.c: In function 'arch_prepare_bpf_trampoline':
> arch/x86/net/bpf_jit_comp.c:2015:16: error: 'ideal_nops' undeclared (first use in this function)
>  2015 |   memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
>       |                ^~~~~~~~~~
> arch/x86/net/bpf_jit_comp.c:2015:16: note: each undeclared identifier is reported only once for each function it appears in
> arch/x86/net/bpf_jit_comp.c:2015:27: error: 'NOP_ATOMIC5' undeclared (first use in this function); did you mean 'GFP_ATOMIC'?
>  2015 |   memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
>       |                           ^~~~~~~~~~~
>       |                           GFP_ATOMIC
> 
> Caused by commit
> 
>   a89dfde3dc3c ("x86: Remove dynamic NOP selection")
> 
> interacting with commit
> 
>   b90829704780 ("bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG")
> 
> from the net tree.
> 
> I have applied the following merge fix patch.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 22 Mar 2021 14:30:37 +1100
> Subject: [PATCH] x86: fix up for "bpf: Use NOP_ATOMIC5 instead of
>  emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG"
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/x86/net/bpf_jit_comp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index db50ab14df67..e2b5da5d441d 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -2012,7 +2012,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>  		/* remember return value in a stack for bpf prog to access */
>  		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
>  		im->ip_after_call = prog;
> -		memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> +		memcpy(prog, x86_nops[5], X86_PATCH_SIZE);
>  		prog += X86_PATCH_SIZE;
>  	}
>  
> -- 

I guess we can do the same as with the hyperv tree - the folks who send the
respective branches to Linus in the next merge window should point to this patch
of yours which Linus can apply after merging the second branch in order.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432443F27E4
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbhHTHu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:50:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36029 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238603AbhHTHuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 03:50:24 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GrYgn1dHhz9sW5;
        Fri, 20 Aug 2021 17:49:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1629445784;
        bh=J88K3uaWPTCJyDGiM5or1YoD8rBCAEgZEcryK0u/Zo8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Z88hVJChPLNbFu7va+/1tqYNPa130kSyesJQV170fqBHtyrBHgsoYQ2vG7jWAFenK
         UnM2Xa2WgoEuieSkc1ZLVVCug9f3+zRWbhv+8Kwz9lJ0T0OnirC7rGiJCfhmiQugbk
         Gsb7MIcErTNH7IqyHIXf4NSUrbbL24pfQhAXgxRcFTJzWh3imrJnTVx0viKKp/yGsL
         l2OmzlfcafH3m4gmgvP4ByLj0MCm/9nnxFrtr8KESxwRDR7p6qbKr/nDLbVfTi5zPT
         FKKzWNEL1TGEoS3kCLjjXXVT5+f+vjk1mCNrPw4HFdJEtcPLwmj4uEVdYODVh2zgGX
         +3YZnoSC4+cKQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sudeep Holla <sudeep.holla@arm.com>,
        linuxppc-dev@lists.ozlabs.org, kernel test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 57/63] powerpc/signal32: Use struct_group() to zero
 spe regs
In-Reply-To: <20210818060533.3569517-58-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-58-keescook@chromium.org>
Date:   Fri, 20 Aug 2021 17:49:35 +1000
Message-ID: <877dggeesw.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
>
> Add a struct_group() for the spe registers so that memset() can correctly reason
> about the size:
>
>    In function 'fortify_memset_chk',
>        inlined from 'restore_user_regs.part.0' at arch/powerpc/kernel/signal_32.c:539:3:
>>> include/linux/fortify-string.h:195:4: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>      195 |    __write_overflow_field();
>          |    ^~~~~~~~~~~~~~~~~~~~~~~~
>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/powerpc/include/asm/processor.h | 6 ++++--
>  arch/powerpc/kernel/signal_32.c      | 6 +++---
>  2 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
> index f348e564f7dd..05dc567cb9a8 100644
> --- a/arch/powerpc/include/asm/processor.h
> +++ b/arch/powerpc/include/asm/processor.h
> @@ -191,8 +191,10 @@ struct thread_struct {
>  	int		used_vsr;	/* set if process has used VSX */
>  #endif /* CONFIG_VSX */
>  #ifdef CONFIG_SPE
> -	unsigned long	evr[32];	/* upper 32-bits of SPE regs */
> -	u64		acc;		/* Accumulator */
> +	struct_group(spe,
> +		unsigned long	evr[32];	/* upper 32-bits of SPE regs */
> +		u64		acc;		/* Accumulator */
> +	);
>  	unsigned long	spefscr;	/* SPE & eFP status */
>  	unsigned long	spefscr_last;	/* SPEFSCR value on last prctl
>  					   call or trap return */
> diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
> index 0608581967f0..77b86caf5c51 100644
> --- a/arch/powerpc/kernel/signal_32.c
> +++ b/arch/powerpc/kernel/signal_32.c
> @@ -532,11 +532,11 @@ static long restore_user_regs(struct pt_regs *regs,
>  	regs_set_return_msr(regs, regs->msr & ~MSR_SPE);
>  	if (msr & MSR_SPE) {
>  		/* restore spe registers from the stack */
> -		unsafe_copy_from_user(current->thread.evr, &sr->mc_vregs,
> -				      ELF_NEVRREG * sizeof(u32), failed);
> +		unsafe_copy_from_user(&current->thread.spe, &sr->mc_vregs,
> +				      sizeof(current->thread.spe), failed);

This makes me nervous, because the ABI is that we copy ELF_NEVRREG *
sizeof(u32) bytes, not whatever sizeof(current->thread.spe) happens to
be.

ie. if we use sizeof an inadvertent change to the fields in
thread_struct could change how many bytes we copy out to userspace,
which would be an ABI break.

And that's not that hard to do, because it's not at all obvious that the
size and layout of fields in thread_struct affects the user ABI.

At the same time we don't want to copy the right number of bytes but
the wrong content, so from that point of view using sizeof is good :)

The way we handle it in ptrace is to have BUILD_BUG_ON()s to verify that
things match up, so maybe we should do that here too.

ie. add:

	BUILD_BUG_ON(sizeof(current->thread.spe) == ELF_NEVRREG * sizeof(u32));


Not sure if you are happy doing that as part of this patch. I can always
do it later if not.

cheers

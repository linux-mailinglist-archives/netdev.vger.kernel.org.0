Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64083F4485
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 06:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhHWE4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 00:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhHWE4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 00:56:50 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB190C061575;
        Sun, 22 Aug 2021 21:56:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GtKh13JJDz9sWS;
        Mon, 23 Aug 2021 14:56:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1629694564;
        bh=R8PBxC/HynH4xEcQANJCH6rE1jH+u8gsKBuxIbMNLTs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=a1iW2Pt1kHHliRzWnsgUWnUPXzAPa6K0czSeVW/lgopJWaUMSBdXd9RvxA2oo+2Bi
         pmRIJH5PBg6bByQY/cxKNxkoprS4/Y5ACVbXiYIchmTaPZGQCOlmNym0Z7HGM2wM4c
         4Fp2ulP/ZaQxpRgJz4EDHxe4xx6yYeKW+hpsTCDkiHP5QbMve8C48MLs61Q+vEPfdI
         VTqXFsDNZDd3tnl+2/9gl12uMzzs6VCYFegjMVs0YdD8TM9avqLkWjZK74C6aBMExz
         Etv9zteIN82cJPx68a7lGtZT15hKDTFtgcJJIQISdDBokbfeJWLCrCJY//wTldYX9G
         LRVCHoyBJgAkQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
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
In-Reply-To: <202108200851.8AF09CDB71@keescook>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-58-keescook@chromium.org>
 <877dggeesw.fsf@mpe.ellerman.id.au> <202108200851.8AF09CDB71@keescook>
Date:   Mon, 23 Aug 2021 14:55:58 +1000
Message-ID: <87k0kcdajl.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> On Fri, Aug 20, 2021 at 05:49:35PM +1000, Michael Ellerman wrote:
>> Kees Cook <keescook@chromium.org> writes:
>> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
>> > field bounds checking for memset(), avoid intentionally writing across
>> > neighboring fields.
>> >
>> > Add a struct_group() for the spe registers so that memset() can correctly reason
>> > about the size:
>> >
>> >    In function 'fortify_memset_chk',
>> >        inlined from 'restore_user_regs.part.0' at arch/powerpc/kernel/signal_32.c:539:3:
>> >>> include/linux/fortify-string.h:195:4: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>> >      195 |    __write_overflow_field();
>> >          |    ^~~~~~~~~~~~~~~~~~~~~~~~
>> >
>> > Cc: Michael Ellerman <mpe@ellerman.id.au>
>> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> > Cc: Paul Mackerras <paulus@samba.org>
>> > Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>> > Cc: Sudeep Holla <sudeep.holla@arm.com>
>> > Cc: linuxppc-dev@lists.ozlabs.org
>> > Reported-by: kernel test robot <lkp@intel.com>
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > ---
>> >  arch/powerpc/include/asm/processor.h | 6 ++++--
>> >  arch/powerpc/kernel/signal_32.c      | 6 +++---
>> >  2 files changed, 7 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
>> > index f348e564f7dd..05dc567cb9a8 100644
>> > --- a/arch/powerpc/include/asm/processor.h
>> > +++ b/arch/powerpc/include/asm/processor.h
>> > @@ -191,8 +191,10 @@ struct thread_struct {
>> >  	int		used_vsr;	/* set if process has used VSX */
>> >  #endif /* CONFIG_VSX */
>> >  #ifdef CONFIG_SPE
>> > -	unsigned long	evr[32];	/* upper 32-bits of SPE regs */
>> > -	u64		acc;		/* Accumulator */
>> > +	struct_group(spe,
>> > +		unsigned long	evr[32];	/* upper 32-bits of SPE regs */
>> > +		u64		acc;		/* Accumulator */
>> > +	);
>> >  	unsigned long	spefscr;	/* SPE & eFP status */
>> >  	unsigned long	spefscr_last;	/* SPEFSCR value on last prctl
>> >  					   call or trap return */
>> > diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
>> > index 0608581967f0..77b86caf5c51 100644
>> > --- a/arch/powerpc/kernel/signal_32.c
>> > +++ b/arch/powerpc/kernel/signal_32.c
>> > @@ -532,11 +532,11 @@ static long restore_user_regs(struct pt_regs *regs,
>> >  	regs_set_return_msr(regs, regs->msr & ~MSR_SPE);
>> >  	if (msr & MSR_SPE) {
>> >  		/* restore spe registers from the stack */
>> > -		unsafe_copy_from_user(current->thread.evr, &sr->mc_vregs,
>> > -				      ELF_NEVRREG * sizeof(u32), failed);
>> > +		unsafe_copy_from_user(&current->thread.spe, &sr->mc_vregs,
>> > +				      sizeof(current->thread.spe), failed);
>> 
>> This makes me nervous, because the ABI is that we copy ELF_NEVRREG *
>> sizeof(u32) bytes, not whatever sizeof(current->thread.spe) happens to
>> be.
>> 
>> ie. if we use sizeof an inadvertent change to the fields in
>> thread_struct could change how many bytes we copy out to userspace,
>> which would be an ABI break.
>> 
>> And that's not that hard to do, because it's not at all obvious that the
>> size and layout of fields in thread_struct affects the user ABI.
>> 
>> At the same time we don't want to copy the right number of bytes but
>> the wrong content, so from that point of view using sizeof is good :)
>> 
>> The way we handle it in ptrace is to have BUILD_BUG_ON()s to verify that
>> things match up, so maybe we should do that here too.
>> 
>> ie. add:
>> 
>> 	BUILD_BUG_ON(sizeof(current->thread.spe) == ELF_NEVRREG * sizeof(u32));
>> 
>> Not sure if you are happy doing that as part of this patch. I can always
>> do it later if not.
>
> Sounds good to me; I did that in a few other cases in the series where
> the relationships between things seemed tenuous. :) I'll add this (as
> !=) in v3.

Thanks.

cheers

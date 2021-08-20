Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3463B3F27F8
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbhHTHy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:54:27 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:41517 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236378AbhHTHy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 03:54:26 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4GrYmV3rRlz9sTr;
        Fri, 20 Aug 2021 09:53:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id E8Ffz9K-cCxD; Fri, 20 Aug 2021 09:53:46 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4GrYmV2jCFz9sTj;
        Fri, 20 Aug 2021 09:53:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3A2918B868;
        Fri, 20 Aug 2021 09:53:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id GYJg-josgfgQ; Fri, 20 Aug 2021 09:53:46 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0AEB28B862;
        Fri, 20 Aug 2021 09:53:45 +0200 (CEST)
Subject: Re: [PATCH v2 57/63] powerpc/signal32: Use struct_group() to zero spe
 regs
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
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
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-58-keescook@chromium.org>
 <877dggeesw.fsf@mpe.ellerman.id.au>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <0f6e508e-62b6-3840-5ff4-eb5a77635bd1@csgroup.eu>
Date:   Fri, 20 Aug 2021 09:53:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <877dggeesw.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 20/08/2021 à 09:49, Michael Ellerman a écrit :
> Kees Cook <keescook@chromium.org> writes:
>> In preparation for FORTIFY_SOURCE performing compile-time and run-time
>> field bounds checking for memset(), avoid intentionally writing across
>> neighboring fields.
>>
>> Add a struct_group() for the spe registers so that memset() can correctly reason
>> about the size:
>>
>>     In function 'fortify_memset_chk',
>>         inlined from 'restore_user_regs.part.0' at arch/powerpc/kernel/signal_32.c:539:3:
>>>> include/linux/fortify-string.h:195:4: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>>       195 |    __write_overflow_field();
>>           |    ^~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Cc: Sudeep Holla <sudeep.holla@arm.com>
>> Cc: linuxppc-dev@lists.ozlabs.org
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>   arch/powerpc/include/asm/processor.h | 6 ++++--
>>   arch/powerpc/kernel/signal_32.c      | 6 +++---
>>   2 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
>> index f348e564f7dd..05dc567cb9a8 100644
>> --- a/arch/powerpc/include/asm/processor.h
>> +++ b/arch/powerpc/include/asm/processor.h
>> @@ -191,8 +191,10 @@ struct thread_struct {
>>   	int		used_vsr;	/* set if process has used VSX */
>>   #endif /* CONFIG_VSX */
>>   #ifdef CONFIG_SPE
>> -	unsigned long	evr[32];	/* upper 32-bits of SPE regs */
>> -	u64		acc;		/* Accumulator */
>> +	struct_group(spe,
>> +		unsigned long	evr[32];	/* upper 32-bits of SPE regs */
>> +		u64		acc;		/* Accumulator */
>> +	);
>>   	unsigned long	spefscr;	/* SPE & eFP status */
>>   	unsigned long	spefscr_last;	/* SPEFSCR value on last prctl
>>   					   call or trap return */
>> diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
>> index 0608581967f0..77b86caf5c51 100644
>> --- a/arch/powerpc/kernel/signal_32.c
>> +++ b/arch/powerpc/kernel/signal_32.c
>> @@ -532,11 +532,11 @@ static long restore_user_regs(struct pt_regs *regs,
>>   	regs_set_return_msr(regs, regs->msr & ~MSR_SPE);
>>   	if (msr & MSR_SPE) {
>>   		/* restore spe registers from the stack */
>> -		unsafe_copy_from_user(current->thread.evr, &sr->mc_vregs,
>> -				      ELF_NEVRREG * sizeof(u32), failed);
>> +		unsafe_copy_from_user(&current->thread.spe, &sr->mc_vregs,
>> +				      sizeof(current->thread.spe), failed);
> 
> This makes me nervous, because the ABI is that we copy ELF_NEVRREG *
> sizeof(u32) bytes, not whatever sizeof(current->thread.spe) happens to
> be.
> 
> ie. if we use sizeof an inadvertent change to the fields in
> thread_struct could change how many bytes we copy out to userspace,
> which would be an ABI break.
> 
> And that's not that hard to do, because it's not at all obvious that the
> size and layout of fields in thread_struct affects the user ABI.
> 
> At the same time we don't want to copy the right number of bytes but
> the wrong content, so from that point of view using sizeof is good :)
> 
> The way we handle it in ptrace is to have BUILD_BUG_ON()s to verify that
> things match up, so maybe we should do that here too.
> 
> ie. add:
> 
> 	BUILD_BUG_ON(sizeof(current->thread.spe) == ELF_NEVRREG * sizeof(u32));

You mean != I guess ?


> 
> 
> Not sure if you are happy doing that as part of this patch. I can always
> do it later if not.
> 
> cheers
> 

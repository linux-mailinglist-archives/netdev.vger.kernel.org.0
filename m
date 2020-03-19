Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B7818B234
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgCSLRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:17:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:48380 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726933AbgCSLRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584616623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=owRQsKwA9dFOy6TRW7LYRc1oipCF11iMEKwcjW7tiVo=;
        b=ivCQZ221mNg/U1rQGHqMTqRnTqxaUsw1PGaXmLmc9CHkmX8CfAPy/lISCJTQ+eg9OYAN+o
        xf+9IbRh5UvD9jqbsQrt0VwtTyugsIeHaDbTfUEKBOSbSVTQv63wF9q30orjxCAqT8i9oO
        e/rYTJOiFcIbLIswuwCRokJEggh38Jw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-Ya3Q54nxNX21qjK2_dyxvw-1; Thu, 19 Mar 2020 07:17:00 -0400
X-MC-Unique: Ya3Q54nxNX21qjK2_dyxvw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABB04477;
        Thu, 19 Mar 2020 11:16:58 +0000 (UTC)
Received: from elisabeth (unknown [10.40.208.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1366C6EF95;
        Thu, 19 Mar 2020 11:16:55 +0000 (UTC)
Date:   Thu, 19 Mar 2020 12:16:50 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 19/29] nft_set_pipapo: Introduce AVX2-based lookup
 implementation
Message-ID: <20200319121650.44bf3c17@elisabeth>
In-Reply-To: <CACRpkdbK0dZ87beU8qPSHmRMxTWog-8WbiDQvM-ec06_hAjkoQ@mail.gmail.com>
References: <20200318003956.73573-1-pablo@netfilter.org>
        <20200318003956.73573-20-pablo@netfilter.org>
        <CACRpkdbK0dZ87beU8qPSHmRMxTWog-8WbiDQvM-ec06_hAjkoQ@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Thu, 19 Mar 2020 11:20:28 +0100
Linus Walleij <linus.walleij@linaro.org> wrote:

> Hi Pablo,
> 
> First: I really like this type of optimizations. It's really cool to
> see this hardware being put to good use. So for the record,
> I'm impressed with your work here.

Thanks! :)

> On Wed, Mar 18, 2020 at 1:40 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > +ifdef CONFIG_X86_64
> > +ifneq (,$(findstring -DCONFIG_AS_AVX2=1,$(KBUILD_CFLAGS)))
> > +nf_tables-objs += nft_set_pipapo_avx2.o
> > +endif
> > +endif  
> 
> So this is the first time I see some x86-specific asm optimizations
> in the middle of nftables. That's pretty significant, so it should be
> pointed out in the commit message I think.

It didn't occur to me, you're right, sorry for that (this is in
net-next already).

> I have a question around this:
> 
> > +#define NFT_PIPAPO_LONGS_PER_M256      (XSAVE_YMM_SIZE / BITS_PER_LONG)
> > +
> > +/* Load from memory into YMM register with non-temporal hint ("stream load"),
> > + * that is, don't fetch lines from memory into the cache. This avoids pushing
> > + * precious packet data out of the cache hierarchy, and is appropriate when:
> > + *
> > + * - loading buckets from lookup tables, as they are not going to be used
> > + *   again before packets are entirely classified
> > + *
> > + * - loading the result bitmap from the previous field, as it's never used
> > + *   again
> > + */
> > +#define NFT_PIPAPO_AVX2_LOAD(reg, loc)                                 \
> > +       asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc))  
> 
> (...)
> 
> > +/* Bitwise AND: the staple operation of this algorithm */
> > +#define NFT_PIPAPO_AVX2_AND(dst, a, b)                                 \
> > +       asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst)
> > +
> > +/* Jump to label if @reg is zero */
> > +#define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label)                       \
> > +       asm_volatile_goto("vptest %%ymm" #reg ", %%ymm" #reg ";"        \
> > +                         "je %l[" #label "]" : : : : label)
> > +
> > +/* Store 256 bits from YMM register into memory. Contrary to bucket load
> > + * operation, we don't bypass the cache here, as stored matching results
> > + * are always used shortly after.
> > + */
> > +#define NFT_PIPAPO_AVX2_STORE(loc, reg)                                        \
> > +       asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc))
> > +
> > +/* Zero out a complete YMM register, @reg */
> > +#define NFT_PIPAPO_AVX2_ZERO(reg)                                      \
> > +       asm volatile("vpxor %ymm" #reg ", %ymm" #reg ", %ymm" #reg)  
> 
> The usual practice for this kind of asm optimizations is to store it
> in the arch.
> 
> See for example
> arch/x86/include/asm/bitops.h
> arch/arm64/include/asm/bitrev.h
> which optimize a few bit operations with inline assembly.
> 
> The upside is that bitwise operations can be optimized per-arch
> depending on available arch instructions.

I spent some time trying to figure out where to fit this, and decided
instead to go the same way as RAID6 and some crypto implementations.

A reasonable threshold (and what appears to be the current practice for
the few examples we have) seems to be how specific to a subsystem an
implementation actually is. In that perspective, this looks to me
conceptually similar to AVX2 (or NEON) RAID6 implementations.

> If other archs have similar instructions to AVX2 which can
> slot in and optimize the same code, it would make sense to
> move the assembly to the arch and define some new
> bitops for loading, storing, zero and bitwise AND, possibly even
> if restricted to 256 bits bitmaps.

I'm currently taking care of that for NEON, and while we'll have obvious
gains using a vectorised bitwise AND (with different sizes), the cost of
other operations involved (e.g. branching, or the "refill" operation)
is different, so I'll probably have to arrange algorithm steps in a
different way, and use SIMD instructions that are fundamentally not
equivalent.

On top of that, some architectures are not super-scalar, and some are
but in a different way. Another example: I'm using vmovntdqa here, but,
for a generic 256-bit AND operation, vmovdqa (without non-temporal
memory hint, that is, pushing to cache) makes more sense in the general
case.

So, well, this implementation has to be way more specific (at least for
AVX2 and NEON) than just a random pile of AND operations. :) However,

> We have lib/bitmap.c I can see that this library contain
> things such as:
> 
> int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
>                                 const unsigned long *bitmap2, unsigned int bits)
> 
> Which intuitively seems like something that could use
> these optimizations. It should be fine to augment the kernel
> to handle arch-specific optimizations of bitmap operations
> just like we do for setting bits or finding the first set bit
> in a bitmap etc. Today only bitops.h contain arch optimizations
> but if needed surely we can expand on that?

...yes, absolutely, this makes a lot of sense, I've also been thinking
about this.

For instance, I use __bitmap_and() in the non-AVX2 implementation, and
that would benefit from generic vectorised operations on other
architectures (AltiVec extensions are probably a good example). I plan
to eventually work on this, help would be greatly appreciated (ARM/MIPS
person here :)).

> So I would like to see an explanation why we cannot take
> an extra step and make this code something that is entire
> abstract from x86 and will optimize any arch that can to
> 256 bit bitwise acceleration such as this.

I can add some specific comments if you think it makes sense, detailing
exactly what makes this special compared to a simple sequence of
vectorised 256-bit AND operations. The current comments probably give a
hint about that, but I haven't provided a detailed list there, I can add
it.

-- 
Stefano


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3D144F8AA
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 16:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhKNPHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 10:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKNPHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 10:07:06 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719DAC061746
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 07:04:10 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id e136so38861479ybc.4
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 07:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KTHD7hdM59m1lllSi7ONxfmi/AsuXIhy1Z+zI4Eplys=;
        b=gDX/mpS30DUoG7qe74IuE33TsbWy0rKFWHVQNNkwSnj9COtQBd/iXfSb3hNTS/o6dV
         gZlfNi4wCjLlrIPZQfgyjLEgr+3YzwRAoioNza45CveEiXwcBWTpun0+ZUM02KLgtJ6Y
         ZZmSWgmcpdqk9yT/xNGFFSECA9NMOMRB6J6WnqSKQoY/AWMPelR0CnqWwY/esSDBBTeU
         hYY9/DbFhzv5GlxpQilF4MD6RMWD+gxpX6D4jgWjb6UhriGTzXwV2lYihDGdbQgnODPq
         T9j80XMx+/pKc/KzDVOCN95H274fsktnRMHJwLoyH+ZxBn40I8B7tmbX23ho2c012mvI
         0UYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KTHD7hdM59m1lllSi7ONxfmi/AsuXIhy1Z+zI4Eplys=;
        b=e2ptDuuvjuVNUXSbTNWFD3H6OPKG/kKspb2qpisuZ5ZhQPN2/Q20wUhgezR6+O7/1A
         d75V/zUk581ZtZ8cHQ1156wGzNIuLJlJDbhDedqXrEnm7qs7vvTfFdB+rp0NnUgkruUZ
         Q1cpjuiVHpiuMjx/zw3IvGg/PLaFW8jysfZIdHSvJWQkFHVHU2IwbHvj6OJlJVkMI4TM
         0QKtGGTtCAFKTYHEUy0Q8b4If8fsp3LfADMxL8kXwC506EXsANoZkygc3abwRrxCC1i9
         Kgib89M0QFI/VlHmCXG/skk+TyWY+jsHzto9i4MlL5jDB68o7ct77EzUTqVXPZHbH6EA
         gVmg==
X-Gm-Message-State: AOAM530kHf4FwIwWMcXEufXgEXFP1fehe4znElB44lyxB1tsjzbc4MIR
        +M8Ify5VY0AH7SoflD8o7EawEItITqFRsrDSBKheHw==
X-Google-Smtp-Source: ABdhPJyj5v3xFabvLeLriN0uWC6j7zynnMUp60DnNJ8aqeP3l8JWHVQq0PKz3jna4IesIXknXLGTAX4rVGyUX19O7OE=
X-Received: by 2002:a25:d652:: with SMTP id n79mr35343550ybg.398.1636902249641;
 Sun, 14 Nov 2021 07:04:09 -0800 (PST)
MIME-Version: 1.0
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
 <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
 <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com> <226c88f6446d43afb6d9b5dffda5ab2a@AcuMS.aculab.com>
In-Reply-To: <226c88f6446d43afb6d9b5dffda5ab2a@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 14 Nov 2021 07:03:58 -0800
Message-ID: <CANn89iJtqTGuJL6JgfOAuHxbkej9faURhj3yf2a9Y43Uh_4+Kg@mail.gmail.com>
Subject: Re: [PATCH v1] x86/csum: rewrite csum_partial()
To:     David Laight <David.Laight@aculab.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 14, 2021 at 6:44 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 11 November 2021 22:31
> ..
> > That requires an extra add32_with_carry(), which unfortunately made
> > the thing slower for me.
> >
> > I even hardcoded an inline fast_csum_40bytes() and got best results
> > with the 10+1 addl,
> > instead of
> >  (5 + 1) acql +  mov (needing one extra  register) + shift + addl + adcl
>
> Did you try something like:
>         sum = buf[0];
>         val = buf[1]:
>         asm(
>                 add64 sum, val
>                 adc64 sum, buf[2]
>                 adc64 sum, buf[3]
>                 adc64 sum, buf[4]
>                 adc64 sum, 0
>         }
>         sum_hi = sum >> 32;
>         asm(
>                 add32 sum, sum_hi
>                 adc32 sum, 0
>         )

This is what I tried. but the last part was using add32_with_carry(),
and clang was adding stupid mov to temp variable on the stack,
killing the perf.

This issue was solved with

diff --git a/arch/x86/include/asm/checksum_64.h
b/arch/x86/include/asm/checksum_64.h
index 9af3aed54c6b945e1216719db6889d38ef47cce7..56981943d49cbaa934f7dbac9afb1f575a2437b9
100644
--- a/arch/x86/include/asm/checksum_64.h
+++ b/arch/x86/include/asm/checksum_64.h
@@ -174,7 +174,7 @@ static inline unsigned add32_with_carry(unsigned
a, unsigned b)
        asm("addl %2,%0\n\t"
            "adcl $0,%0"
            : "=r" (a)
-           : "0" (a), "rm" (b));
+           : "0" (a), "r" (b));
        return a;
 }



> Splitting it like that should allow thew compiler to insert
> additional instructions between the two 'adc' blocks
> making it much more likely that the cpu will schedule them
> in parallel with other instructions.
>
> The extra 5 adc32 have to add 5 clocks (register dependency chain).
> The 'mov' ought to be free (register rename) and the extra shift
> and adds one clock each - so 3 (maybe 4) clocks.
> So the 64bit version really ought to be faster even a s single
> asm block.
>
> Trying to second-guess the x86 cpu is largely impossible :-)
>
> Oh, and then try the benchmarks of one of the 64bit Atom cpus
> used in embedded systems....
> We've some 4core+hyperthreading ones that aren't exactly slow.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

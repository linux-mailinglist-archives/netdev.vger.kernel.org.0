Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76A144DDE4
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 23:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhKKWdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 17:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhKKWdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 17:33:54 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015A6C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 14:31:05 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c4so12201160wrd.9
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 14:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BwWtAHX5pJsSsHEcgn2Lc0+imowiVr6fln/FEFtwHp0=;
        b=DbR9ZOVbBEXAJY9+4CVd5BoPWf+HGSashnWB1DlgLkQNN6OVoJVXqyjPoeUCc/b2/g
         kKPHjikGNiuqvwx7vUrs20LmK1pT0eN3JayLgl3Ktz5US+uMXsIsFG4otWsI21kxa9Rc
         gpGIlf3BkN6q/2iDaumtEujDFrvalgacYyShVpwpKM1PJ4sfWBQsusuuI5MGDSEDnkbR
         NGV/mtzEjiwJaISwLrhmOVreVvHGcpNkqONyCWJGcKxuykrP9O7yPbVUYvieL3aQnZEL
         /OubsO0RsllIuNzobqrVqlxdj54hFwFBhv8Sriclwmk05bFpsxqlQKTBZaBkhRMFgLDW
         YdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BwWtAHX5pJsSsHEcgn2Lc0+imowiVr6fln/FEFtwHp0=;
        b=TxvC1e8+Ez3s4APcheZGohwxXvTluZ2neqs5cdOwOrKJFSdWLmIGlk40PdC3Tra88i
         3GWoJgWHF+hJhDtz1evIi3Wa4uWDez8o0VtHcp7Mv8NhRXW7XtoXaFsQ7H11zxUHuFIz
         jCSRaaEJus4Kpg537CXldh98i9DDA28rGBGBi5X7nwPSXZ6M5NGDE9PlkqkWfBE0sYKE
         dv56Mmt4kvfxdthZ/1lAZKG4cp22a3xutdnd6wDjMMVTJxVejXxps+E5Ua1iyCTo3qhL
         EKqXEGslwg2LkUYP8e/hrATFZuLbHVSXwaC5jv8xZ6OEsDVzV+hse8NsOidMmBEOdSIC
         vYBw==
X-Gm-Message-State: AOAM533fA1vDB11fBQ9mJUBX5fmqp1T0jg+OgBW2FRd0IQGYDp9IdtfW
        ox0vEgcuo1zywa9/s4RQx0Z6aZNKKE8XfrNd9SfYe6H/QCmxIA==
X-Google-Smtp-Source: ABdhPJxzk5reQp36o59L7gZ0JTqzIBme1YZWTR5I/12GhHcn9ISkwepUr6beWXkSc+aH8QB1UeWpe4CSICReyPspINc=
X-Received: by 2002:adf:e387:: with SMTP id e7mr12926597wrm.412.1636669863114;
 Thu, 11 Nov 2021 14:31:03 -0800 (PST)
MIME-Version: 1.0
References: <20211111181025.2139131-1-eric.dumazet@gmail.com> <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
In-Reply-To: <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 11 Nov 2021 14:30:50 -0800
Message-ID: <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com>
Subject: Re: [PATCH v1] x86/csum: rewrite csum_partial()
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 1:56 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Nov 11, 2021 at 10:10 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > With more NIC supporting CHECKSUM_COMPLETE, and IPv6 being widely used.
> > csum_partial() is heavily used with small amount of bytes,
> > and is consuming many cycles.
> >
> > IPv6 header size for instance is 40 bytes.
> >
> > Another thing to consider is that NET_IP_ALIGN is 0 on x86,
> > meaning that network headers are not word-aligned, unless
> > the driver forces this.
> >
> > This means that csum_partial() fetches one u16
> > to 'align the buffer', then perform seven u64 additions
> > with carry in a loop, then a remaining u32, then a remaining u16.
> >
> > With this new version, we perform 10 u32 adds with carry, to
> > avoid the expensive 64->32 transformation.
> >
> > Also note that this avoids loops for less than ~60 bytes.
> >
> > Tested on various cpus, all of them show a big reduction in
> > csum_partial() cost (by 50 to 75 %)
> >
> > v2: - removed the hard-coded switch(), as it was not RETPOLINE aware.
> >     - removed the final add32_with_carry() that we were doing
> >       in csum_partial(), we can simply pass @sum to do_csum()
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Alexander Duyck <alexander.duyck@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > ---
> >  arch/x86/lib/csum-partial_64.c | 151 +++++++++++++++++----------------
> >  1 file changed, 76 insertions(+), 75 deletions(-)
> >
> > diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
> > index e7925d668b680269fb2442766deaf416dc42f9a1..910806a1b954c5fed90020191143d16aec74bf0a 100644
> > --- a/arch/x86/lib/csum-partial_64.c
> > +++ b/arch/x86/lib/csum-partial_64.c
> > @@ -21,97 +21,99 @@ static inline unsigned short from32to16(unsigned a)
> >  }
> >
> >  /*
> > - * Do a 64-bit checksum on an arbitrary memory area.
> > + * Do a checksum on an arbitrary memory area.
> >   * Returns a 32bit checksum.
> >   *
> >   * This isn't as time critical as it used to be because many NICs
> >   * do hardware checksumming these days.
> > - *
> > - * Things tried and found to not make it faster:
> > - * Manual Prefetching
> > - * Unrolling to an 128 bytes inner loop.
> > - * Using interleaving with more registers to break the carry chains.
> > + *
> > + * Still, with CHECKSUM_COMPLETE this is called to compute
> > + * checksums on IPv6 headers (40 bytes) and other small parts.
> >   */
> > -static unsigned do_csum(const unsigned char *buff, unsigned len)
> > +static unsigned do_csum(const unsigned char *buff, unsigned len, u32 result)
> >  {
> > -       unsigned odd, count;
> > -       unsigned long result = 0;
> > +       unsigned odd;
> >
> > -       if (unlikely(len == 0))
> > -               return result;
> >         odd = 1 & (unsigned long) buff;
> >         if (unlikely(odd)) {
> > +               if (unlikely(len == 0))
> > +                       return result;
> >                 result = *buff << 8;
> >                 len--;
> >                 buff++;
> >         }
>
> It might be worthwhile to beef up the odd check to account for
> anything 7 bytes or less. To address it you could do something along
> the lines of:
>     unaligned = 7 & (unsigned long) buff;
>     if (unaligned) {
>         shift = unaligned * 8;
>         temp64 = (*(unsigned long)buff >> shift) << shift;

What happens if len=={1..7}  ? KASAN will complain.

>         buff += 8 - unaligned;
>         if (len < 8 - unaligned) {
>             shift = (8 - len - unaligned) * 8;
>             temp64 <<= shift;
>             temp64 >>= shift;
>             len = 0;
>         } else {
>             len -= 8 - unaligned;
>         }
>         result += temp64;
>         result += result < temp64;

Also this will trigger all the time because NET_IP_ALIGN == 0


>    }
>
> Then the check for odd at the end would have to be updated to check
> for the lsb of the "unaligned" value, or you could just do away with
> the conditional check and just rotate the final result by "unaligned *
> 8" before folding the value down to 32b.
>
> > -       count = len >> 1;               /* nr of 16-bit words.. */
> > -       if (count) {
> > -               if (2 & (unsigned long) buff) {
> > -                       result += *(unsigned short *)buff;
> > -                       count--;
> > -                       len -= 2;
> > -                       buff += 2;
> > -               }
> > -               count >>= 1;            /* nr of 32-bit words.. */
> > -               if (count) {
> > -                       unsigned long zero;
> > -                       unsigned count64;
> > -                       if (4 & (unsigned long) buff) {
> > -                               result += *(unsigned int *) buff;
> > -                               count--;
> > -                               len -= 4;
> > -                               buff += 4;
> > -                       }
> > -                       count >>= 1;    /* nr of 64-bit words.. */
> > -
> > -                       /* main loop using 64byte blocks */
> > -                       zero = 0;
> > -                       count64 = count >> 3;
> > -                       while (count64) {
> > -                               asm("addq 0*8(%[src]),%[res]\n\t"
> > -                                   "adcq 1*8(%[src]),%[res]\n\t"
> > -                                   "adcq 2*8(%[src]),%[res]\n\t"
> > -                                   "adcq 3*8(%[src]),%[res]\n\t"
> > -                                   "adcq 4*8(%[src]),%[res]\n\t"
> > -                                   "adcq 5*8(%[src]),%[res]\n\t"
> > -                                   "adcq 6*8(%[src]),%[res]\n\t"
> > -                                   "adcq 7*8(%[src]),%[res]\n\t"
> > -                                   "adcq %[zero],%[res]"
> > -                                   : [res] "=r" (result)
> > -                                   : [src] "r" (buff), [zero] "r" (zero),
> > -                                   "[res]" (result));
> > -                               buff += 64;
> > -                               count64--;
> > -                       }
> > -
> > -                       /* last up to 7 8byte blocks */
> > -                       count %= 8;
> > -                       while (count) {
> > -                               asm("addq %1,%0\n\t"
> > -                                   "adcq %2,%0\n"
> > -                                           : "=r" (result)
> > -                                   : "m" (*(unsigned long *)buff),
> > -                                   "r" (zero),  "0" (result));
> > -                               --count;
> > -                               buff += 8;
> > -                       }
> > -                       result = add32_with_carry(result>>32,
> > -                                                 result&0xffffffff);
> > -
> > -                       if (len & 4) {
> > -                               result += *(unsigned int *) buff;
> > -                               buff += 4;
> > -                       }
> > -               }
> > +       if (unlikely(len >= 64)) {
> > +               unsigned long temp64 = result;
> > +               do {
> > +                       asm("   addq 0*8(%[src]),%[res]\n"
> > +                           "   adcq 1*8(%[src]),%[res]\n"
> > +                           "   adcq 2*8(%[src]),%[res]\n"
> > +                           "   adcq 3*8(%[src]),%[res]\n"
> > +                           "   adcq 4*8(%[src]),%[res]\n"
> > +                           "   adcq 5*8(%[src]),%[res]\n"
> > +                           "   adcq 6*8(%[src]),%[res]\n"
> > +                           "   adcq 7*8(%[src]),%[res]\n"
> > +                           "   adcq $0,%[res]"
> > +                           : [res] "=r" (temp64)
> > +                           : [src] "r" (buff), "[res]" (temp64)
> > +                           : "memory");
> > +                       buff += 64;
> > +                       len -= 64;
> > +               } while (len >= 64);
>
> I wonder if we couldn't optimize this loop by tracking buff versus
> another pointer instead of updating and checking the length.
>
> Basically just update it so that we have something like:
>     trailer = len & 63;
>     end = buf + len - trailer;
>     do {
>         ...
>         buff += 64;
>     } while (buff < end);

Yeah, but I wonder why the compiler could not do that for us ?

>
> > +               result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
>
> Squashing this to 32b here seems a bit premature. As I mentioned
> before an add w/ carry is going to be one per cycle as it serializes
> on the carry flag, so if you are doing it 4 bytes at a time you can
> probably get the same or better by using adcq for the 32, 16, and 8B
> lengths.

That would work for a specialized fast_csum_40bytes(), but not if we have to
add checks about length == 40 ?

The squash happens once, _if_ we had to sum more than 64 bytes,
and needs to be done because of the following operations.

>
> > +       }
> > +       if (len & 32) {
> > +               asm("   addl 0*4(%[src]),%[res]\n"
> > +                   "   adcl 1*4(%[src]),%[res]\n"
> > +                   "   adcl 2*4(%[src]),%[res]\n"
> > +                   "   adcl 3*4(%[src]),%[res]\n"
> > +                   "   adcl 4*4(%[src]),%[res]\n"
> > +                   "   adcl 5*4(%[src]),%[res]\n"
> > +                   "   adcl 6*4(%[src]),%[res]\n"
> > +                   "   adcl 7*4(%[src]),%[res]\n"
> > +                   "   adcl $0,%[res]"
> > +                       : [res] "=r" (result)
> > +                       : [src] "r" (buff), "[res]" (result)
> > +                       : "memory");
> > +               buff += 32;
> > +       }
> > +       if (len & 16) {
> > +               asm("   addl 0*4(%[src]),%[res]\n"
> > +                   "   adcl 1*4(%[src]),%[res]\n"
> > +                   "   adcl 2*4(%[src]),%[res]\n"
> > +                   "   adcl 3*4(%[src]),%[res]\n"
> > +                   "   adcl $0,%[res]"
> > +                       : [res] "=r" (result)
> > +                       : [src] "r" (buff), "[res]" (result)
> > +                       : "memory");
> > +               buff += 16;
> > +       }
> > +       if (len & 8) {
> > +               asm("   addl 0*4(%[src]),%[res]\n"
> > +                   "   adcl 1*4(%[src]),%[res]\n"
> > +                   "   adcl $0,%[res]"
> > +                       : [res] "=r" (result)
> > +                       : [src] "r" (buff), "[res]" (result)
> > +                       : "memory");
> > +               buff += 8;
> > +       }
>
> Alternatively we could look at accumulating the 32b values into a 64b
> register to get rid of the need to monitor the carry flag and that may
> improve the speed of things on architectures such as Haswell or newer.

That requires an extra add32_with_carry(), which unfortunately made
the thing slower for me.

I even hardcoded an inline fast_csum_40bytes() and got best results
with the 10+1 addl,
instead of
 (5 + 1) acql +  mov (needing one extra  register) + shift + addl + adcl

So that was not because of the clang bug I mentioned earlier.

>
> > +       if (len & 4) {
> > +               asm("   addl 0*4(%[src]),%[res]\n"
> > +                   "   adcl $0,%[res]\n"
> > +                       : [res] "=r" (result)
> > +                       : [src] "r" (buff), "[res]" (result)
> > +                       : "memory");
> > +               buff += 4;
> > +       }
> > +       if (len & 3U) {
> > +               result = from32to16(result);
> >                 if (len & 2) {
> >                         result += *(unsigned short *) buff;
> >                         buff += 2;
> >                 }
> > +               if (len & 1)
> > +                       result += *buff;
> >         }
>
> For values 7 through 1 I wonder if you wouldn't be better served by
> just doing a single QWORD read and a pair of shifts. Something along
> the lines of:
>     if (len) {
>         shift = (8 - len) * 8;
>         temp64 = (*(unsigned long)buff << shift) >> shift;
>         result += temp64;
>         result += result < temp64;
>     }

Again, KASAN will not be happy.

>
> > -       if (len & 1)
> > -               result += *buff;
> > -       result = add32_with_carry(result>>32, result & 0xffffffff);
> >         if (unlikely(odd)) {
> >                 result = from32to16(result);
> >                 result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
> > @@ -133,8 +135,7 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
> >   */
> >  __wsum csum_partial(const void *buff, int len, __wsum sum)
> >  {
> > -       return (__force __wsum)add32_with_carry(do_csum(buff, len),
> > -                                               (__force u32)sum);
> > +       return (__force __wsum)do_csum(buff, len, (__force u32)sum);
> >  }
> >  EXPORT_SYMBOL(csum_partial);
> >
> > --
> > 2.34.0.rc1.387.gb447b232ab-goog
> >

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4961044DD5B
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 22:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhKKV7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 16:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhKKV7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 16:59:23 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D47C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 13:56:33 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z10so3174659edc.11
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 13:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=owq7R4D05VlqUoRQdPncZAcIVu0VHRA7wbfhHET9zNE=;
        b=PQ/AdngmUPYI3/BewhuEWZub+wWLLYSKNyX/mc9oT38lnj+80pk2wfqQBrug5370GQ
         NmPNHp1X0e2cTmv9srkJsZTxpZ8IOy+e/CsWybFLdBr9j/9g8N9Q9nlTVw59A8zX/xxV
         UGS3PYi6T57jcnfVWlhDDpFfWdWckFwE5kKifXSMSWFQSGd0FqcPIGknCshgxTksWjgY
         fW86y1JcT93As2vSKsCQutlfIJ2T4j4MUN+KgY6Tv5g4UPXDRCS2q77Gq/21zp4olH23
         y4wY01/yhYu1HoVE953bDnOT6kvcbmIbZHtOXM2eNM13gDJxVIOKP/ruVmHk2vhBDG4l
         8l1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=owq7R4D05VlqUoRQdPncZAcIVu0VHRA7wbfhHET9zNE=;
        b=S4YqWoomWuukT4BHvzy2Gmusbp8DEdNHA+E94IpNHwsYOYfc8IbgVBGIZC1VxH+0Es
         GUD4S6XYcKdtrUJcPe1uXz9UJ+h6R/3BhWU7otl55eOoCtNzQRKzJXOj60XcCyVY5gcd
         HdOIlrFihbUA57FbY+30r1eLrSH+M34sdZfGrMLzucKfpuLcWng3TKJjOEkDO/jXoEwe
         bsIevfMZpqXv7wwtIsEG7PMf5uRbg1qKug3n3TBDUkQ8nJY9ruHy/Bms3skSkK1Uwzml
         ZdndARO3NiuJ6vLO3sB5xjnxdwkEsKXYKhjg5vD5EtVR3Mj8uHlwKvccQIYl6+L2Kigt
         Xuiw==
X-Gm-Message-State: AOAM533QUlt/FUyLRSr+aR+h12YLYPVJs3hUhFidJ+PQG/HMXjc2n+oe
        oEZXbnc6yMuz2m57JP22x48jUHoQgBb0mMqmdsM=
X-Google-Smtp-Source: ABdhPJwB6J52rJEiNfoSfmak/c6JFDHBFnY1fLp5l2riRiqBofLUVQ1hUJYm9/D7UjFwfKAVgx5z+EfeTwpqF1HhWYs=
X-Received: by 2002:a17:906:140b:: with SMTP id p11mr13079656ejc.116.1636667791797;
 Thu, 11 Nov 2021 13:56:31 -0800 (PST)
MIME-Version: 1.0
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
In-Reply-To: <20211111181025.2139131-1-eric.dumazet@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Nov 2021 13:56:20 -0800
Message-ID: <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
Subject: Re: [PATCH v1] x86/csum: rewrite csum_partial()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 10:10 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> With more NIC supporting CHECKSUM_COMPLETE, and IPv6 being widely used.
> csum_partial() is heavily used with small amount of bytes,
> and is consuming many cycles.
>
> IPv6 header size for instance is 40 bytes.
>
> Another thing to consider is that NET_IP_ALIGN is 0 on x86,
> meaning that network headers are not word-aligned, unless
> the driver forces this.
>
> This means that csum_partial() fetches one u16
> to 'align the buffer', then perform seven u64 additions
> with carry in a loop, then a remaining u32, then a remaining u16.
>
> With this new version, we perform 10 u32 adds with carry, to
> avoid the expensive 64->32 transformation.
>
> Also note that this avoids loops for less than ~60 bytes.
>
> Tested on various cpus, all of them show a big reduction in
> csum_partial() cost (by 50 to 75 %)
>
> v2: - removed the hard-coded switch(), as it was not RETPOLINE aware.
>     - removed the final add32_with_carry() that we were doing
>       in csum_partial(), we can simply pass @sum to do_csum()
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Duyck <alexander.duyck@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/lib/csum-partial_64.c | 151 +++++++++++++++++----------------
>  1 file changed, 76 insertions(+), 75 deletions(-)
>
> diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
> index e7925d668b680269fb2442766deaf416dc42f9a1..910806a1b954c5fed90020191143d16aec74bf0a 100644
> --- a/arch/x86/lib/csum-partial_64.c
> +++ b/arch/x86/lib/csum-partial_64.c
> @@ -21,97 +21,99 @@ static inline unsigned short from32to16(unsigned a)
>  }
>
>  /*
> - * Do a 64-bit checksum on an arbitrary memory area.
> + * Do a checksum on an arbitrary memory area.
>   * Returns a 32bit checksum.
>   *
>   * This isn't as time critical as it used to be because many NICs
>   * do hardware checksumming these days.
> - *
> - * Things tried and found to not make it faster:
> - * Manual Prefetching
> - * Unrolling to an 128 bytes inner loop.
> - * Using interleaving with more registers to break the carry chains.
> + *
> + * Still, with CHECKSUM_COMPLETE this is called to compute
> + * checksums on IPv6 headers (40 bytes) and other small parts.
>   */
> -static unsigned do_csum(const unsigned char *buff, unsigned len)
> +static unsigned do_csum(const unsigned char *buff, unsigned len, u32 result)
>  {
> -       unsigned odd, count;
> -       unsigned long result = 0;
> +       unsigned odd;
>
> -       if (unlikely(len == 0))
> -               return result;
>         odd = 1 & (unsigned long) buff;
>         if (unlikely(odd)) {
> +               if (unlikely(len == 0))
> +                       return result;
>                 result = *buff << 8;
>                 len--;
>                 buff++;
>         }

It might be worthwhile to beef up the odd check to account for
anything 7 bytes or less. To address it you could do something along
the lines of:
    unaligned = 7 & (unsigned long) buff;
    if (unaligned) {
        shift = unaligned * 8;
        temp64 = (*(unsigned long)buff >> shift) << shift;
        buff += 8 - unaligned;
        if (len < 8 - unaligned) {
            shift = (8 - len - unaligned) * 8;
            temp64 <<= shift;
            temp64 >>= shift;
            len = 0;
        } else {
            len -= 8 - unaligned;
        }
        result += temp64;
        result += result < temp64;
   }

Then the check for odd at the end would have to be updated to check
for the lsb of the "unaligned" value, or you could just do away with
the conditional check and just rotate the final result by "unaligned *
8" before folding the value down to 32b.

> -       count = len >> 1;               /* nr of 16-bit words.. */
> -       if (count) {
> -               if (2 & (unsigned long) buff) {
> -                       result += *(unsigned short *)buff;
> -                       count--;
> -                       len -= 2;
> -                       buff += 2;
> -               }
> -               count >>= 1;            /* nr of 32-bit words.. */
> -               if (count) {
> -                       unsigned long zero;
> -                       unsigned count64;
> -                       if (4 & (unsigned long) buff) {
> -                               result += *(unsigned int *) buff;
> -                               count--;
> -                               len -= 4;
> -                               buff += 4;
> -                       }
> -                       count >>= 1;    /* nr of 64-bit words.. */
> -
> -                       /* main loop using 64byte blocks */
> -                       zero = 0;
> -                       count64 = count >> 3;
> -                       while (count64) {
> -                               asm("addq 0*8(%[src]),%[res]\n\t"
> -                                   "adcq 1*8(%[src]),%[res]\n\t"
> -                                   "adcq 2*8(%[src]),%[res]\n\t"
> -                                   "adcq 3*8(%[src]),%[res]\n\t"
> -                                   "adcq 4*8(%[src]),%[res]\n\t"
> -                                   "adcq 5*8(%[src]),%[res]\n\t"
> -                                   "adcq 6*8(%[src]),%[res]\n\t"
> -                                   "adcq 7*8(%[src]),%[res]\n\t"
> -                                   "adcq %[zero],%[res]"
> -                                   : [res] "=r" (result)
> -                                   : [src] "r" (buff), [zero] "r" (zero),
> -                                   "[res]" (result));
> -                               buff += 64;
> -                               count64--;
> -                       }
> -
> -                       /* last up to 7 8byte blocks */
> -                       count %= 8;
> -                       while (count) {
> -                               asm("addq %1,%0\n\t"
> -                                   "adcq %2,%0\n"
> -                                           : "=r" (result)
> -                                   : "m" (*(unsigned long *)buff),
> -                                   "r" (zero),  "0" (result));
> -                               --count;
> -                               buff += 8;
> -                       }
> -                       result = add32_with_carry(result>>32,
> -                                                 result&0xffffffff);
> -
> -                       if (len & 4) {
> -                               result += *(unsigned int *) buff;
> -                               buff += 4;
> -                       }
> -               }
> +       if (unlikely(len >= 64)) {
> +               unsigned long temp64 = result;
> +               do {
> +                       asm("   addq 0*8(%[src]),%[res]\n"
> +                           "   adcq 1*8(%[src]),%[res]\n"
> +                           "   adcq 2*8(%[src]),%[res]\n"
> +                           "   adcq 3*8(%[src]),%[res]\n"
> +                           "   adcq 4*8(%[src]),%[res]\n"
> +                           "   adcq 5*8(%[src]),%[res]\n"
> +                           "   adcq 6*8(%[src]),%[res]\n"
> +                           "   adcq 7*8(%[src]),%[res]\n"
> +                           "   adcq $0,%[res]"
> +                           : [res] "=r" (temp64)
> +                           : [src] "r" (buff), "[res]" (temp64)
> +                           : "memory");
> +                       buff += 64;
> +                       len -= 64;
> +               } while (len >= 64);

I wonder if we couldn't optimize this loop by tracking buff versus
another pointer instead of updating and checking the length.

Basically just update it so that we have something like:
    trailer = len & 63;
    end = buf + len - trailer;
    do {
        ...
        buff += 64;
    } while (buff < end);

> +               result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);

Squashing this to 32b here seems a bit premature. As I mentioned
before an add w/ carry is going to be one per cycle as it serializes
on the carry flag, so if you are doing it 4 bytes at a time you can
probably get the same or better by using adcq for the 32, 16, and 8B
lengths.

> +       }
> +       if (len & 32) {
> +               asm("   addl 0*4(%[src]),%[res]\n"
> +                   "   adcl 1*4(%[src]),%[res]\n"
> +                   "   adcl 2*4(%[src]),%[res]\n"
> +                   "   adcl 3*4(%[src]),%[res]\n"
> +                   "   adcl 4*4(%[src]),%[res]\n"
> +                   "   adcl 5*4(%[src]),%[res]\n"
> +                   "   adcl 6*4(%[src]),%[res]\n"
> +                   "   adcl 7*4(%[src]),%[res]\n"
> +                   "   adcl $0,%[res]"
> +                       : [res] "=r" (result)
> +                       : [src] "r" (buff), "[res]" (result)
> +                       : "memory");
> +               buff += 32;
> +       }
> +       if (len & 16) {
> +               asm("   addl 0*4(%[src]),%[res]\n"
> +                   "   adcl 1*4(%[src]),%[res]\n"
> +                   "   adcl 2*4(%[src]),%[res]\n"
> +                   "   adcl 3*4(%[src]),%[res]\n"
> +                   "   adcl $0,%[res]"
> +                       : [res] "=r" (result)
> +                       : [src] "r" (buff), "[res]" (result)
> +                       : "memory");
> +               buff += 16;
> +       }
> +       if (len & 8) {
> +               asm("   addl 0*4(%[src]),%[res]\n"
> +                   "   adcl 1*4(%[src]),%[res]\n"
> +                   "   adcl $0,%[res]"
> +                       : [res] "=r" (result)
> +                       : [src] "r" (buff), "[res]" (result)
> +                       : "memory");
> +               buff += 8;
> +       }

Alternatively we could look at accumulating the 32b values into a 64b
register to get rid of the need to monitor the carry flag and that may
improve the speed of things on architectures such as Haswell or newer.

> +       if (len & 4) {
> +               asm("   addl 0*4(%[src]),%[res]\n"
> +                   "   adcl $0,%[res]\n"
> +                       : [res] "=r" (result)
> +                       : [src] "r" (buff), "[res]" (result)
> +                       : "memory");
> +               buff += 4;
> +       }
> +       if (len & 3U) {
> +               result = from32to16(result);
>                 if (len & 2) {
>                         result += *(unsigned short *) buff;
>                         buff += 2;
>                 }
> +               if (len & 1)
> +                       result += *buff;
>         }

For values 7 through 1 I wonder if you wouldn't be better served by
just doing a single QWORD read and a pair of shifts. Something along
the lines of:
    if (len) {
        shift = (8 - len) * 8;
        temp64 = (*(unsigned long)buff << shift) >> shift;
        result += temp64;
        result += result < temp64;
    }

> -       if (len & 1)
> -               result += *buff;
> -       result = add32_with_carry(result>>32, result & 0xffffffff);
>         if (unlikely(odd)) {
>                 result = from32to16(result);
>                 result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
> @@ -133,8 +135,7 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
>   */
>  __wsum csum_partial(const void *buff, int len, __wsum sum)
>  {
> -       return (__force __wsum)add32_with_carry(do_csum(buff, len),
> -                                               (__force u32)sum);
> +       return (__force __wsum)do_csum(buff, len, (__force u32)sum);
>  }
>  EXPORT_SYMBOL(csum_partial);
>
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>

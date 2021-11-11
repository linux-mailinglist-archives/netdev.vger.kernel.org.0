Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F1B44DACC
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbhKKQyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhKKQyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 11:54:40 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C93C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:51:50 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id o8so26536982edc.3
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RBpHaDMYV+prx8honre10OrFOHJ05/0LLmPbyW9bHW4=;
        b=H8ndpen9tyXIh8AS97iXsGpi9ewg1ylNW5gSj2fdVawglboY2GdswU2ziPjMwpQMFj
         wSWwbt9xahrC/sxwHb6MNByyF4Snl1VtocAEAOTOWpLJiWon8nJexiqNVkM2FSIRGQSz
         Nk3GrX26TOEpNOGiu8NAYUywHDFHSMrC7MJCWQnaBH58kl+RwIrtBc2vsusKhTiSFxx5
         VqhaDoZo8ZHWbL5nVI/0ypuxaC8PycqWS2lTRg4C9iPoalwCaXBlcflvC2pi5UrNd96z
         1HGaPr/bJPE1X5ZIIPDKV+YHwXBfX5mK/eF7DNXZALCum4zYebOprtnwORsnPknz9GPm
         DPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RBpHaDMYV+prx8honre10OrFOHJ05/0LLmPbyW9bHW4=;
        b=IVk14rOcvJP7DkCeizoUfVvHUvvgO15e80AEhKiF4woABuImfnM55J+Q+PFICqzhY0
         Q5CS3nFtJ7LiO5Clgu0GV6rNufpTrinwL3NQ0irFafKHJ8hM5HezV8fJLEO1t5esGZhf
         DjV7VKfW6CRcFxvjXFvTE+zKqfmAWh9AHaOYCiHGywiBqezIRoTetRIeA/qCb/X3F4ns
         JQJ/tvumZetlaMjAg91z0+cHIfIeylNPMtl1gXkMBD26aeoatO7SBPSwhrD8OTwT+ovx
         +aVxkSwdU8Uowblvrtr9wP7VWSkIeRcHxqPes8miaN9l2LtfYqGM3jFeiuSoM4sipHPb
         oCdg==
X-Gm-Message-State: AOAM532o7C/vJ91LlYUPUKWTQ1pg6Ayyubet+1nDTquLaA/g10+n2BHf
        yqfFuqdHNB+fmdgdJ8KmAgIq3yEh6BoSX/a4RNk=
X-Google-Smtp-Source: ABdhPJybWc6NqG3aA5dxq5kX4Iq+OnCEvoXYr6toqn/wTpsMHC511iWhHM9Z7UeqZXTG0Zn8bN4Jehjx7qlbPpiQ79Q=
X-Received: by 2002:aa7:c34c:: with SMTP id j12mr11800461edr.31.1636649507199;
 Thu, 11 Nov 2021 08:51:47 -0800 (PST)
MIME-Version: 1.0
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
In-Reply-To: <20211111065322.1261275-1-eric.dumazet@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Nov 2021 08:51:35 -0800
Message-ID: <CAKgT0Ue2P6OXwk-+n2k_E_KRVUaBVyg=Xb8yvo=RkRLJHfJW=g@mail.gmail.com>
Subject: Re: [RFC] x86/csum: rewrite csum_partial()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 10:53 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
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
> meaning that network headers in RX path are not word-aligned,
> unless the driver forces this.
>
> This means that csum_partial() fetches one u16
> to 'align the buffer', then perform seven u64 additions
> with carry in a loop, then a remaining u32, then a remaining u16.
>
> With this new version, we perform 10 u32 adds with carry, to
> avoid the expensive 64->32 transformation. Using 5 u64 adds
> plus one add32_with_carry() is more expensive.
>
> Also note that this avoids loops for less than ~60 bytes.
>
> Tested on various cpus, all of them show a big reduction in
> csum_partial() cost (by 30 to 75 %)
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Duyck <alexander.duyck@gmail.com>
> ---
>  arch/x86/lib/csum-partial_64.c | 146 +++++++++++++++++----------------
>  1 file changed, 77 insertions(+), 69 deletions(-)
>
> diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
> index e7925d668b680269fb2442766deaf416dc42f9a1..f48fe0ec9663ff3afa1b5403f135407b8b0fde01 100644
> --- a/arch/x86/lib/csum-partial_64.c
> +++ b/arch/x86/lib/csum-partial_64.c
> @@ -21,97 +21,105 @@ static inline unsigned short from32to16(unsigned a)
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
>  static unsigned do_csum(const unsigned char *buff, unsigned len)
>  {
> -       unsigned odd, count;
> -       unsigned long result = 0;
> +       unsigned long dwords;
> +       unsigned odd, result = 0;
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

So for most cases getting rid of the alignment code should be fine.
However as I recall my main concern when dealing with something like
this was the case of a page straddling value. For most network packets
that shouldn't be the case but it may be something we want to add some
sort of debug check for where if we are unaligned, and the address
straddles pages, and the debugging is enabled we throw a warning at
least.

Otherwise as an alternative we might consider just performing one 8B
read at the start with us forcing the alignment via masking the
address and data and then just dropping the unused values in order get
us into 8B alignment so that we don't trigger the page straddling
read, and we can just rotate the result later to align it to the
start.

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
> +               result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
> +       }
>
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

So in terms of this main loop it is probably as good as it gets for
anything pre-Haswell, but I am wondering if we might be able to
improve upon this for Haswell and newer architectures that have more
read throughput since I think those parts would be serialized on the
carry flag instead of being limited to one read per cycle.

> +       dwords = len >> 2;
> +       if (dwords) { /* dwords is in [1..15] */
> +               unsigned long dest;
>
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
> +               /*
> +                * This implements an optimized version of
> +                * switch (dwords) {
> +                * case 15: res = add_with_carry(res, buf32[14]); fallthrough;
> +                * case 14: res = add_with_carry(res, buf32[13]); fallthrough;
> +                * case 13: res = add_with_carry(res, buf32[12]); fallthrough;
> +                * ...
> +                * case 3: res = add_with_carry(res, buf32[2]); fallthrough;
> +                * case 2: res = add_with_carry(res, buf32[1]); fallthrough;
> +                * case 1: res = add_with_carry(res, buf32[0]); fallthrough;
> +                * }
> +                *
> +                * "adcl 8byteoff(%reg1),%reg2" are using either 3 or 4 bytes.
> +                */
> +               asm("   call 1f\n"
> +                   "1: pop %[dest]\n"
> +                   "   lea (2f-1b)(%[dest],%[skip],4),%[dest]\n"
> +                   "   clc\n"
> +                   "   jmp *%[dest]\n               .align 4\n"
> +                   "2:\n"
> +                   "   adcl 14*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 13*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 12*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 11*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 10*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 9*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 8*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 7*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 6*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 5*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 4*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 3*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 2*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 1*4(%[src]),%[res]\n   .align 4\n"
> +                   "   adcl 0*4(%[src]),%[res]\n"
> +                   "   adcl $0,%[res]"
> +                       : [res] "=r" (result), [dest] "=&r" (dest)
> +                       : [src] "r" (buff), "[res]" (result),
> +                         [skip] "r" (dwords ^ 15)
> +                       : "memory");
> +       }

I gave up on this after the whole specter/meltdown thing because it
was an indirect jump. Packing it down to a tight loop processing
single QWORDs may be in our favor as it can just replay the decoded
instructions for as many times as we need to.

>
> -                       if (len & 4) {
> -                               result += *(unsigned int *) buff;
> -                               buff += 4;
> -                       }
> -               }
> +       if (len & 3U) {
> +               buff += len & ~3U;
> +               result = from32to16(result);
>                 if (len & 2) {
>                         result += *(unsigned short *) buff;
>                         buff += 2;
>                 }
> +               if (len & 1)
> +                       result += *buff;
>         }
> -       if (len & 1)
> -               result += *buff;

This is another spot where I wonder if we can't get away with a single
8B read and then just mask the value based on the length remaining. I
would think it would save us a fair bit of time and a number of
cycles.

> -       result = add32_with_carry(result>>32, result & 0xffffffff);
>         if (unlikely(odd)) {
>                 result = from32to16(result);
>                 result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);

Rather than doing the fold and rotate if odd would it maybe make sense
for us just to do a single 64b rotate based on the offset of the
original value. We could do that before the result is folded to a 32b
value and it would likely only cost us one cycle instead of the
several that are being spent here doing the test for zero, fold, and
rotate.

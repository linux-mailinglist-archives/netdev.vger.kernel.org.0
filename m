Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C006D18B11D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 11:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgCSKUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 06:20:43 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46774 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCSKUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 06:20:42 -0400
Received: by mail-lf1-f67.google.com with SMTP id a28so1113444lfr.13
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 03:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TQcasci4XhSrKCJoPRA/qSrDjHc7fp39qcsEw/ahKX0=;
        b=MSgi21U0HiEtb+VOKq4HocZQ/U6wvkd5CsdWTOSFmR+ziVKqNIFuSgTp4prNkWzn/A
         AYfkVwDR1k3bF71X81xApg+Rrj7LmELIUDNIaprXCzE+rrix9WZvUGGbQeru2aVcDVUg
         kNrs1oGPjUQ+m01XHPrQjI4dhbfQpB/Yii3wqnjTekBmr++XHHx97gdIi0sXEkEQX9mt
         RSRMGub7M0Xaufs0ENHsZYonb3nrC4jhQg+Ijhh2KC1DXHkZ0ptcubbb1MQdOnNo3Tt5
         gsb/V0eizY4VNoyJHnnJ8fD8GF44/KRf5y3HDyojG35vL+Uy3+/rKnAmoMQzU6TdRMXo
         vFwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TQcasci4XhSrKCJoPRA/qSrDjHc7fp39qcsEw/ahKX0=;
        b=C78Pf4t5JCgkJXDJjiFdkgHRfFG8zNx3YM019zZyPR5CGRAui55MMdAhiFXOrOxJoE
         Ic1hWYmJcIzJ6X6uKhDgexDItMnAE4A3oha5uw8PMJl/SCM/kEEZDE0kai2xahPIVDKo
         EDLhdII3wFqULc2tkOKyPNcMIz078PT8v5hCv/HXWiD155YDSbC63c5YzDrMccoJY900
         OsgjaHQq0uwfgabv3EkVnvzhCb8lbRlGR4dTT+CJEiw0vm0Lk7pWFcA6l8eD3DgM3dcz
         jg4J+suf1XaB8W2mXzgA9VfLZ39B9+zKCZ3IuPGhooBCRjEYuecgh+BKVn00GH99decN
         /QpQ==
X-Gm-Message-State: ANhLgQ1v1tQAgtmQcxfL4vX8iLIZdmFV3n2A53YVAMD1aV1PCTkOlNv2
        eO7N45fV0CzsnfWK/5rPdSGbFK6bV972RoJ/KpUaRF1sFjM=
X-Google-Smtp-Source: ADFU+vtxQY6TLf9RCdpR3pIWpMz/lw0qNuGNd69xOwiknAhuTdy6sWA9qnnsHTERhr29y6VEpekrkFQyIu8q+rV2njg=
X-Received: by 2002:a19:6502:: with SMTP id z2mr1626078lfb.47.1584613239811;
 Thu, 19 Mar 2020 03:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200318003956.73573-1-pablo@netfilter.org> <20200318003956.73573-20-pablo@netfilter.org>
In-Reply-To: <20200318003956.73573-20-pablo@netfilter.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 19 Mar 2020 11:20:28 +0100
Message-ID: <CACRpkdbK0dZ87beU8qPSHmRMxTWog-8WbiDQvM-ec06_hAjkoQ@mail.gmail.com>
Subject: Re: [PATCH 19/29] nft_set_pipapo: Introduce AVX2-based lookup implementation
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

First: I really like this type of optimizations. It's really cool to
see this hardware being put to good use. So for the record,
I'm impressed with your work here.

On Wed, Mar 18, 2020 at 1:40 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> +ifdef CONFIG_X86_64
> +ifneq (,$(findstring -DCONFIG_AS_AVX2=1,$(KBUILD_CFLAGS)))
> +nf_tables-objs += nft_set_pipapo_avx2.o
> +endif
> +endif

So this is the first time I see some x86-specific asm optimizations
in the middle of nftables. That's pretty significant, so it should be
pointed out in the commit message I think.

I have a question around this:

> +#define NFT_PIPAPO_LONGS_PER_M256      (XSAVE_YMM_SIZE / BITS_PER_LONG)
> +
> +/* Load from memory into YMM register with non-temporal hint ("stream load"),
> + * that is, don't fetch lines from memory into the cache. This avoids pushing
> + * precious packet data out of the cache hierarchy, and is appropriate when:
> + *
> + * - loading buckets from lookup tables, as they are not going to be used
> + *   again before packets are entirely classified
> + *
> + * - loading the result bitmap from the previous field, as it's never used
> + *   again
> + */
> +#define NFT_PIPAPO_AVX2_LOAD(reg, loc)                                 \
> +       asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc))

(...)

> +/* Bitwise AND: the staple operation of this algorithm */
> +#define NFT_PIPAPO_AVX2_AND(dst, a, b)                                 \
> +       asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst)
> +
> +/* Jump to label if @reg is zero */
> +#define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label)                       \
> +       asm_volatile_goto("vptest %%ymm" #reg ", %%ymm" #reg ";"        \
> +                         "je %l[" #label "]" : : : : label)
> +
> +/* Store 256 bits from YMM register into memory. Contrary to bucket load
> + * operation, we don't bypass the cache here, as stored matching results
> + * are always used shortly after.
> + */
> +#define NFT_PIPAPO_AVX2_STORE(loc, reg)                                        \
> +       asm volatile("vmovdqa %%ymm" #reg ", %0" : "=m" (loc))
> +
> +/* Zero out a complete YMM register, @reg */
> +#define NFT_PIPAPO_AVX2_ZERO(reg)                                      \
> +       asm volatile("vpxor %ymm" #reg ", %ymm" #reg ", %ymm" #reg)

The usual practice for this kind of asm optimizations is to store it
in the arch.

See for example
arch/x86/include/asm/bitops.h
arch/arm64/include/asm/bitrev.h
which optimize a few bit operations with inline assembly.

The upside is that bitwise operations can be optimized per-arch
depending on available arch instructions.

If other archs have similar instructions to AVX2 which can
slot in and optimize the same code, it would make sense to
move the assembly to the arch and define some new
bitops for loading, storing, zero and bitwise AND, possibly even
if restricted to 256 bits bitmaps.

We have lib/bitmap.c I can see that this library contain
things such as:

int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
                                const unsigned long *bitmap2, unsigned int bits)

Which intuitively seems like something that could use
these optimizations. It should be fine to augment the kernel
to handle arch-specific optimizations of bitmap operations
just like we do for setting bits or finding the first set bit
in a bitmap etc. Today only bitops.h contain arch optimizations
but if needed surely we can expand on that?

So I would like to see an explanation why we cannot take
an extra step and make this code something that is entire
abstract from x86 and will optimize any arch that can to
256 bit bitwise acceleration such as this.

Yours,
Linus Walleij

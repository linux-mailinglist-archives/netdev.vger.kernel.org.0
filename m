Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74370473446
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241972AbhLMSp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbhLMSp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 13:45:26 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C077C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 10:45:26 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id d10so40668209ybe.3
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 10:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cz/oV6rucbFXxpVSl31hZc9OC3uLAvr6D9l8ggAwmMM=;
        b=g0s4+FNsRzHTIFMgfuac332mUINiKCGVCRW75S/B9HApUnl7HQvHB5fezY8zOE2JFi
         Oj106DoyqWG5jcPhpxbKZQvZ+o7TBuTIJyHTewsQw8A4DcVUrURhF82qDxKfQV5JrytE
         vJFgIrWjOk88LG6r7UOnZj/jM3Vw4+D4ltN7rDoR94ejEmi82Ihqk+RQTa26n91RQPSA
         3t5Uuxb+Q/qE42HGXvuntmAQfHTlso8gANDwEz8D9YitQb138N4jwxxCQTZWmaSaxNpw
         j3USbsUREPCbmoai4VhuyTpunyFz+eTZ3SGX0AZEG/w+cStqpxwjSAGYa2NcpLAqwMwH
         IkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cz/oV6rucbFXxpVSl31hZc9OC3uLAvr6D9l8ggAwmMM=;
        b=7N1AB3XPKzbxz0GUKg0GBDjVtODEdQl8JlbacaMxpA8Q9wTPsApee4lZHqq1bK80s0
         SwhIKSx/3d/JHMTXmpYnFqEz/6bs5upnqh4L/9us4qlxnsJJ8+CQsUhvud/wEQq7T5Cz
         qGvsSnlXoU1gLpu0J3BZbp5Yj6zR/KrVHyHvlQFtOp+dlpoyS6WRIgrcFvQuIi02u0y8
         xUAjEbt5c9eEe9lISdCP/u1tSB9artFKHKuGnb5k/6x2tRSOEvlEOJsXDDgg2QRcpuEb
         wxR2q9egIdtyrn9Kb55/hXrljNhjDX5/OcMQUh5aAn2nXGtn+iBTpJegukf4/l9RJeC8
         hafw==
X-Gm-Message-State: AOAM532vTGxWwNG70nBY5nRxDinF6YYOoU5Xxb0+mg0NSPlCURq6/aGm
        AuxzLEuLmzrFzsjroDlzaCAFl8mKyHqEW/me8778NA==
X-Google-Smtp-Source: ABdhPJwjCXDEoY7SsfAHxNtNDcS3iz7wdnHdybiyBTgskB0tF4HTH1L9nNXr+l8tERRSjW16SIf8IVVjE2IzldK3F9M=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr361655ybt.156.1639421125202;
 Mon, 13 Dec 2021 10:45:25 -0800 (PST)
MIME-Version: 1.0
References: <f1cd1a19878248f09e2e7cffe88c8191@AcuMS.aculab.com>
In-Reply-To: <f1cd1a19878248f09e2e7cffe88c8191@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Dec 2021 10:45:13 -0800
Message-ID: <CANn89i+FCddAJSAY1pj3kEDcP5wMnuQFVCa5ZbJwi1GqJ89Hkg@mail.gmail.com>
Subject: Re: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
To:     David Laight <David.Laight@aculab.com>
Cc:     Noah Goldstein <goldstein.w.n@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 10:00 AM David Laight <David.Laight@aculab.com> wrote:
>
>
> Add in the trailing bytes first so that there is no need to worry
> about the sum exceeding 64 bits.
>
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
>
> This ought to be faster - because of all the removed 'adc $0'.
> Guessing how fast x86 code will run is hard!
> There are other ways of handing buffers that are shorter than 8 bytes,
> but I'd rather hope they don't happen in any hot paths.
>
> Note - I've not even compile tested it.
> (But have tested an equivalent change before.)
>
>  arch/x86/lib/csum-partial_64.c | 55 ++++++++++++----------------------
>  1 file changed, 19 insertions(+), 36 deletions(-)
>
> diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
> index abf819dd8525..fbcc073fc2b5 100644
> --- a/arch/x86/lib/csum-partial_64.c
> +++ b/arch/x86/lib/csum-partial_64.c
> @@ -37,6 +37,24 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
>         u64 temp64 = (__force u64)sum;
>         unsigned result;
>
> +       if (len & 7) {
> +               if (unlikely(len < 8)) {
> +                       /* Avoid falling off the start of the buffer */
> +                       if (len & 4) {
> +                               temp64 += *(u32 *)buff;
> +                               buff += 4;
> +                       }
> +                       if (len & 2) {
> +                               temp64 += *(u16 *)buff;
> +                               buff += 2;
> +                       }
> +                       if (len & 1)
> +                               temp64 += *(u8 *)buff;
> +                       goto reduce_to32;
> +               }
> +               temp64 += *(u64 *)(buff + len - 8) << (8 - (len & 7)) * 8;

This is reading far away (end of buffer).

Maybe instead read the first bytes and adjust @buff, to allow for
better hardware prefetching ?



> +       }
> +
>         while (unlikely(len >= 64)) {
>                 asm("addq 0*8(%[src]),%[res]\n\t"
>                     "adcq 1*8(%[src]),%[res]\n\t"
> @@ -82,43 +100,8 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
>                         : "memory");
>                 buff += 8;
>         }
> -       if (len & 7) {
> -#ifdef CONFIG_DCACHE_WORD_ACCESS
> -               unsigned int shift = (8 - (len & 7)) * 8;
> -               unsigned long trail;
> -
> -               trail = (load_unaligned_zeropad(buff) << shift) >> shift;
>
> -               asm("addq %[trail],%[res]\n\t"
> -                   "adcq $0,%[res]"
> -                       : [res] "+r" (temp64)
> -                       : [trail] "r" (trail));
> -#else
> -               if (len & 4) {
> -                       asm("addq %[val],%[res]\n\t"
> -                           "adcq $0,%[res]"
> -                               : [res] "+r" (temp64)
> -                               : [val] "r" ((u64)*(u32 *)buff)
> -                               : "memory");
> -                       buff += 4;
> -               }
> -               if (len & 2) {
> -                       asm("addq %[val],%[res]\n\t"
> -                           "adcq $0,%[res]"
> -                               : [res] "+r" (temp64)
> -                               : [val] "r" ((u64)*(u16 *)buff)
> -                               : "memory");
> -                       buff += 2;
> -               }
> -               if (len & 1) {
> -                       asm("addq %[val],%[res]\n\t"
> -                           "adcq $0,%[res]"
> -                               : [res] "+r" (temp64)
> -                               : [val] "r" ((u64)*(u8 *)buff)
> -                               : "memory");
> -               }
> -#endif
> -       }
> +reduce_to32:
>         result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
>         return (__force __wsum)result;
>  }
> --
> 2.17.1
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

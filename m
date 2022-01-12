Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A1748C2B0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 12:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352686AbiALLAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 06:00:03 -0500
Received: from mail-ua1-f41.google.com ([209.85.222.41]:44714 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352683AbiALLAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 06:00:01 -0500
Received: by mail-ua1-f41.google.com with SMTP id l15so3905321uai.11;
        Wed, 12 Jan 2022 03:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P9xJBN5Sf81yronEcRpMEORUChn2S5aTbHnwQ7uOvsM=;
        b=5ePKShnpQ0O/a+y0L9hopufbzVh93pHELQUkrFa1U1FuQiackfjcmHhtXbdok4fG84
         YcknPxWjCHOveDBqFC06CsBJptPIx9xhAGHGSkPDTAoqz1IwAQJdcPkBDmuRU42e4o2U
         XMvXWeVO/JDzA921ubhnKhE029fefgaC+0eRI8CIhYtXK2WwALJGWxgqw4RLlOzwCF19
         Wa7aeyydaacOQmW6F/mvXs+9N++7yKYhT6zLLSMMVU/RdvgyixwRIiee17kxiw8uoCMa
         vTIYlxatDySwhbP1OpbDBy89U8Zjr3XkOEcKTaZwatX6jdgCqTXAfZIOK2qq1l/l6Vgz
         nP0g==
X-Gm-Message-State: AOAM533mKjb6AfrzgAj0zBnML4LlEreWLo7UODkjFUw+pq44sroeGRAW
        v1iv5aWAgQGFkGHA1V8baMMya5b5eM5qVUP6
X-Google-Smtp-Source: ABdhPJyzrfxkgE+7legUtMTTceWLgI4buGjw+odKdGY5Ga5+3Lrb9GUl9uDNe1ZeVwosCI40bW2MdA==
X-Received: by 2002:a05:6102:956:: with SMTP id a22mr2515050vsi.49.1641985200899;
        Wed, 12 Jan 2022 03:00:00 -0800 (PST)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com. [209.85.221.177])
        by smtp.gmail.com with ESMTPSA id i53sm3449490vkr.29.2022.01.12.02.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 03:00:00 -0800 (PST)
Received: by mail-vk1-f177.google.com with SMTP id 191so1401768vkc.1;
        Wed, 12 Jan 2022 02:59:59 -0800 (PST)
X-Received: by 2002:a1f:384b:: with SMTP id f72mr4324936vka.0.1641985199694;
 Wed, 12 Jan 2022 02:59:59 -0800 (PST)
MIME-Version: 1.0
References: <20220111181037.632969-1-Jason@zx2c4.com> <20220111220506.742067-1-Jason@zx2c4.com>
In-Reply-To: <20220111220506.742067-1-Jason@zx2c4.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 12 Jan 2022 11:59:48 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUcJN_ZZLnx8TuhoXYV1DAKK9NsXjH2M0xAdn9JTS16wA@mail.gmail.com>
Message-ID: <CAMuHMdUcJN_ZZLnx8TuhoXYV1DAKK9NsXjH2M0xAdn9JTS16wA@mail.gmail.com>
Subject: Re: [PATCH crypto v3 0/2] reduce code size from blake2s on m68k and
 other small platforms
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, wireguard@lists.zx2c4.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        jeanphilippe.aumasson@gmail.com, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Tue, Jan 11, 2022 at 11:05 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Geert emailed me this afternoon concerned about blake2s codesize on m68k
> and other small systems. We identified two effective ways of chopping
> down the size. One of them moves some wireguard-specific things into
> wireguard proper. The other one adds a slower codepath for small
> machines to blake2s. This worked, and was v1 of this patchset, but I
> wasn't so much of a fan. Then someone pointed out that the generic C
> SHA-1 implementation is still unrolled, which is a *lot* of extra code.
> Simply rerolling that saves about as much as v1 did. So, we instead do
> that in this patchset. SHA-1 is being phased out, and soon it won't
> be included at all (hopefully). And nothing performance-oriented has
> anything to do with it anyway.
>
> The result of these two patches mitigates Geert's feared code size
> increase for 5.17.
>
> v3 improves on v2 by making the re-rolling of SHA-1 much simpler,
> resulting in even larger code size reduction and much better
> performance. The reason I'm sending yet a third version in such a short
> amount of time is because the trick here feels obvious and substantial
> enough that I'd hate for Geert to waste time measuring the impact of the
> previous commit.
>
> Thanks,
> Jason
>
> Jason A. Donenfeld (2):
>   lib/crypto: blake2s: move hmac construction into wireguard
>   lib/crypto: sha1: re-roll loops to reduce code size

Thanks for the series!

On m68k:
add/remove: 1/4 grow/shrink: 0/1 up/down: 4/-4232 (-4228)
Function                                     old     new   delta
__ksymtab_blake2s256_hmac                     12       -     -12
blake2s_init.constprop                        94       -     -94
blake2s256_hmac                              302       -    -302
sha1_transform                              4402     582   -3820
Total: Before=4230537, After=4226309, chg -0.10%

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

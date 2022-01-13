Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9A848D367
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbiAMII4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:08:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35046 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiAMII4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 03:08:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1FACB821C6;
        Thu, 13 Jan 2022 08:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A500C36AED;
        Thu, 13 Jan 2022 08:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642061333;
        bh=fGppOKwts/UQmumuyGu94Gr0B26R/oF5wecYItkERg8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W2OF8mrKVIDoTiDK9H5MbNyXDJqp0Vl8NQoNzRCNwQwhZihdx+8aC0JWv49J+0dc3
         +gimKBiGOedrAgCE2f6qs5ncHJ2ta++mvFWVgy9a1urzB/XhIJDXQw1wDgE4e8BekF
         aBlbe+u3szNiZuBVXhnz0DWa1cj4BeMdPGuBbo+mnDfz/xMQeTylDzGKmNjYuDsOLe
         gXrDcecO5zrPna1JosAZiucdVAoSwDLdqtjryAELBCg2EiZ7O2jQGSKIoLTOlYdmlR
         lHFD0Jodk6LWuHD1aNb/ucIqa7K7db5too5VqhRhE7DOx5Sgi3sc9r831PwYh/oTi6
         ApVSqaTMoms7g==
Received: by mail-wm1-f48.google.com with SMTP id ay4-20020a05600c1e0400b0034a81a94607so2188153wmb.1;
        Thu, 13 Jan 2022 00:08:53 -0800 (PST)
X-Gm-Message-State: AOAM533eEqnMcyOUTrUv8PZc8c5fh6WJ/FYaW1Bw5mfys3aT6PAzZbMW
        U/9qXuLpOgYcbrf7wf87nO4oLwRfXuTqmra+XvI=
X-Google-Smtp-Source: ABdhPJzlNo9hTJdUbMaTWVOxiNCg8wO+mgluAAlRvMgO8203Q/53p5OTdqryVdIpOQWuQAu5yGLLVe93Y/DA2+fPsVs=
X-Received: by 2002:a05:600c:3c9c:: with SMTP id bg28mr2718897wmb.190.1642061331868;
 Thu, 13 Jan 2022 00:08:51 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <CACXcFmkauHRkTdD1zkr9QRCwG-uD8=7q9=Wk0_VFueRy-Oy+Nw@mail.gmail.com>
In-Reply-To: <CACXcFmkauHRkTdD1zkr9QRCwG-uD8=7q9=Wk0_VFueRy-Oy+Nw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 13 Jan 2022 09:08:40 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFhoyADsW9+79boCEV6zG7RZ3HquFStBUbGZoKEWVJAwQ@mail.gmail.com>
Message-ID: <CAMj1kXFhoyADsW9+79boCEV6zG7RZ3HquFStBUbGZoKEWVJAwQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1 0/3] remove remaining users of SHA-1
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 at 04:24, Sandy Harris <sandyinchina@gmail.com> wrote:
>
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> > There are currently two remaining users of SHA-1 left in the kernel: bpf
> > tag generation, and ipv6 address calculation.
>
> I think there are three, since drivers/char/random.c also uses it.
> Moreover, there's some inefficiency there (or was last time I
> looked) since it produces a 160-bit hash then folds it in half
> to give an 80-bit output.
>

That code was removed, hence the two /remaining/ users.

> A possible fix would be to use a more modern 512-bit hash.
> SHA3 would be the obvious one, but Blake2 would work,
> Blake3 might be faster & there are several other possibilities.
> Hash context size would then match ChaCha so you could
> update the whole CC context at once, maybe even use the
> same context for both.
>
> That approach has difficulties, Extracting 512 bits every
> time might drain the input pool too quickly & it is overkill
> for ChaCha which should be secure with smaller rekeyings.
>
> If you look at IPsec, SSL & other such protocols, many
> have now mostly replaced the hash-based HMAC
> constructions used in previous generations with things
> like Galois field calculations (e.g. AES-GCM) or other
> strange math (e,g. poly 1305). These have most of the
> desirable properties of hashes & are much faster. As
> far as I know, they all give 128-bit outputs.
>
> I think we should replace SHA-1 with GCM. Give
> ChaCha 128 bits somewhat more often than current
> code gives it 256.

You are conflating MACs with hashes. A MAC does is not suitable for
backtrack resistance, and GHASH in particular is really only suited to
be used in the context of GCM.

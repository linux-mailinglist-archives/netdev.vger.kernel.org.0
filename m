Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D8548C29A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 11:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352644AbiALK6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 05:58:04 -0500
Received: from mail-ua1-f46.google.com ([209.85.222.46]:43648 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238370AbiALK6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 05:58:03 -0500
Received: by mail-ua1-f46.google.com with SMTP id i5so3902352uaq.10;
        Wed, 12 Jan 2022 02:58:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sqfqmGnWErblTuhOUr48ULJ3GhOyu+Z25jTNW9S2YJk=;
        b=FWLMI5bBOVpZdyV5XoLEQEPHbScoAd25NOJKXslUmwsdI4JNnqCd9wP6fkvS2OcQZA
         ELMsurQDTPeHK7WlRYex4r9IgI5DaI+b9nTrjXfLTPvZfMhAy7B8dqhh6+4SPppi12nL
         Ed7O+69O6cH12dEKDhgySBTyBKFgY9EszyqQfRQnT4ODp7/sSZuUsDRtEVHimt+aFDCC
         Kdz15zUEqNsh9L9N1+LwlqcBW/anFAI6ozLg05Z3ezKbkEOIRdwwu2pYR2H2lXn8tJ//
         h93VM+8i2m4qjacZGuddXZG71/Ph6hehZSXtknnmSLYxLv9gK7D84hJU0fCFqgoybMZF
         Mxmw==
X-Gm-Message-State: AOAM5313d++tqQe9KNk8uIjB1LP46j1Hh6Dhp6Jmm1xIISLOF3rhbEbY
        qdtk2Ib3tJhH6yrlr2EHo5xf/GePrP91vry2
X-Google-Smtp-Source: ABdhPJzhe4W765gRBfKwtHARcs2LhOTzVbGiBQJy2gdtCbMUqbGF2ufdHAQDivWCCDwVn/IeAUMjiw==
X-Received: by 2002:ab0:25d7:: with SMTP id y23mr3719332uan.116.1641985082435;
        Wed, 12 Jan 2022 02:58:02 -0800 (PST)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id l27sm4892564vko.17.2022.01.12.02.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 02:58:01 -0800 (PST)
Received: by mail-ua1-f54.google.com with SMTP id y4so3990872uad.1;
        Wed, 12 Jan 2022 02:58:00 -0800 (PST)
X-Received: by 2002:ab0:4d5a:: with SMTP id k26mr3942936uag.122.1641985080812;
 Wed, 12 Jan 2022 02:58:00 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
 <20220111134934.324663-1-Jason@zx2c4.com> <20220111134934.324663-2-Jason@zx2c4.com>
In-Reply-To: <20220111134934.324663-2-Jason@zx2c4.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 12 Jan 2022 11:57:49 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWOheM0WsHNTA2dS=wJA8kXEYx6G78bnZ51T1X8HWdzNg@mail.gmail.com>
Message-ID: <CAMuHMdWOheM0WsHNTA2dS=wJA8kXEYx6G78bnZ51T1X8HWdzNg@mail.gmail.com>
Subject: Re: [PATCH crypto 1/2] lib/crypto: blake2s-generic: reduce code size
 on small systems
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, wireguard@lists.zx2c4.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        jeanphilippe.aumasson@gmail.com, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Tue, Jan 11, 2022 at 2:49 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Re-wind the loops entirely on kernels optimized for code size. This is
> really not good at all performance-wise. But on m68k, it shaves off 4k
> of code size, which is apparently important.

On arm32:

add/remove: 1/0 grow/shrink: 0/1 up/down: 160/-4212 (-4052)
Function                                     old     new   delta
blake2s_sigma                                  -     160    +160
blake2s_compress_generic                    4872     660   -4212
Total: Before=9846148, After=9842096, chg -0.04%

On arm64:

add/remove: 1/2 grow/shrink: 0/1 up/down: 160/-4584 (-4424)
Function                                     old     new   delta
blake2s_sigma                                  -     160    +160
e843419@0710_00007634_e8a0                     8       -      -8
e843419@0441_0000423a_178c                     8       -      -8
blake2s_compress_generic                    5088     520   -4568
Total: Before=32800278, After=32795854, chg -0.01%

> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

For the size reduction:
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B1848ED30
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242199AbiANPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:36:36 -0500
Received: from mail-vk1-f178.google.com ([209.85.221.178]:47077 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiANPgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:36:35 -0500
Received: by mail-vk1-f178.google.com with SMTP id bj47so6010278vkb.13;
        Fri, 14 Jan 2022 07:36:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YJjdZDOE3o2kL7hMCs+KcBi0cfqKaf561XO1uO98LqA=;
        b=jKv34m9Xik7cvyi1qWqtZFBtdMR88awmRcZkLEeA7XZVZba4y6gszFTE0s7E7Ab5Rq
         5KbNZpjvdKNOxDg4xz9jgl7+OHQeR/PExvzxfv2nDvGrmNwPQrEIwHvkueMXgAWgPK4p
         +xBfj9vHjMlB6DxV2djQmKxrjPKNY0LJoXOuf6lMbVz4K1CBIJAF1zUY4xMa2Y/jy0Zv
         IQ1/WLMbUc/T96jbZeYyhO9Yery8eGN+P6av1B+bd+MeRxXboyU89eoHLd2wkokKC2xH
         uhiy3uAmRmA//jXvOC9bhSWbnawimCdWsminunYrNO5F/AopKAzLAUbRrlA4GGmxtACY
         cOIw==
X-Gm-Message-State: AOAM531aYTh8dRH+GIFLosy6g05xKRC6fwSl3uzaz0ra1gAWe/qPt6GU
        04MspgBmR/9UgUmktrhagk4g3OR+Zg6Xewrv
X-Google-Smtp-Source: ABdhPJz9d1jGDGtXclbJT1JVstQJwp3ulw7+h2mXY52hq6cOelrhOpLJ+gL4rOiKf0M61CISDB/+Bg==
X-Received: by 2002:ac5:c18f:: with SMTP id z15mr2784842vkb.24.1642174594644;
        Fri, 14 Jan 2022 07:36:34 -0800 (PST)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id o12sm2172193uae.1.2022.01.14.07.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 07:36:34 -0800 (PST)
Received: by mail-ua1-f47.google.com with SMTP id p1so17529862uap.9;
        Fri, 14 Jan 2022 07:36:34 -0800 (PST)
X-Received: by 2002:a9f:3e01:: with SMTP id o1mr4495386uai.89.1642174593855;
 Fri, 14 Jan 2022 07:36:33 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk> <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
 <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
 <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
 <CAHmME9oq36JdV8ap9sPZ=CDfNyaQd6mXd21ztAaZiL7pJh8RCw@mail.gmail.com>
 <CAMj1kXE3JtNjgF3FZjbL-GOQG41yODup4+XdEFP063F=-AWg8A@mail.gmail.com> <CAHmME9oa8dAeRQfgj-U00gUtVOJ_CTGwtyBxUB4=8+XO_fFjNQ@mail.gmail.com>
In-Reply-To: <CAHmME9oa8dAeRQfgj-U00gUtVOJ_CTGwtyBxUB4=8+XO_fFjNQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 14 Jan 2022 16:36:22 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXDmwHaJuvNo8vkzudfhL0E3b=0b4mP_OqDCYFqm82J5Q@mail.gmail.com>
Message-ID: <CAMuHMdXDmwHaJuvNo8vkzudfhL0E3b=0b4mP_OqDCYFqm82J5Q@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Fri, Jan 14, 2022 at 4:20 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> I think the reason that Alexei doesn't think that the SHA-1 choice
> really matters is because the result is being truncated to 64-bits, so
> collisions are easy anyway, regardless of which hash function is
> chosen (birthday bound and all). But from Geert's perspective, that
> SHA-1 is still taking up precious bytes in m68k builds. And from my
> perspective, it's poor form and clutters vmlinux, and plus, now I'm
> curious about why this isn't using a more appropriately sized tag in
> the first place.

Not just on m68k. Same on other architectures.
Yes, people do make products with SoCs with 8 MiB of builtin SRAM,
running Linux. They might stay away from BPF, though ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

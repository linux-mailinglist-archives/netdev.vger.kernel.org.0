Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C04729E65A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgJ2IZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:25:47 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37058 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbgJ2IZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:25:45 -0400
Received: by mail-oi1-f193.google.com with SMTP id f7so2415805oib.4;
        Thu, 29 Oct 2020 01:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8GwF8lKQ/mn1SZ1RobWt+1TreFjiPRalR0H8KvHn3LY=;
        b=oC4Q8ShtuNj/DQl5n4WISJDp30sLUq4t5wOZJqd4xZAITigNGiMKyFichMf7SgMLvm
         qT3ML6K106D5kO+xjmfcXA3BbdUMzaoRPcIWSybRLoaFgLjNbj0D9JerFT4Vw66IFcyF
         0xpSQE+SnDNCvzzPC9/s8zEAZ2zWONaufAv02lszC+thEB/QrwabsvhOQnzNrhACHzMT
         oRJp3rY41IiEbPyn53fQN4ez9UZyyE70q3GK/N1LIxZa1wSodsRG8OaRyfk7UBMQ1ng0
         K1seRS51uq50Mmo4K5ei7fHK+/eCmqImnmmnn8Tef+FdPcRV4XZ2rkThbcWTzZgWbmKz
         q+9Q==
X-Gm-Message-State: AOAM531fwYKLgSQDyUnC7s01VlDCWwU5rMA2piDvePQ9L4eW0ykxqx//
        HTB56/UQIQ9+cbpKfj/x1/adT/zZtX11BY22bkk=
X-Google-Smtp-Source: ABdhPJx87qX9BOdfwH3qv6RLp/CViLF+OMQGLC5vN5b4+x9eNDcJsPC53Y3tP4N8J33BYk0mnPKJZhViwITEYgrleeY=
X-Received: by 2002:aca:c490:: with SMTP id u138mr2180030oif.54.1603959944525;
 Thu, 29 Oct 2020 01:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201028171506.15682-1-ardb@kernel.org> <20201028171506.15682-2-ardb@kernel.org>
In-Reply-To: <20201028171506.15682-2-ardb@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 29 Oct 2020 09:25:33 +0100
Message-ID: <CAMuHMdWdORV2u5zCWVspUha-WVixg=-ik_R2tRgszarptnsOsA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize))
 to disable GCSE
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 6:15 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> Commit 3193c0836 ("bpf: Disable GCC -fgcse optimization for
> ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> function scope __attribute__((optimize("-fno-gcse"))), to disable a
> GCC specific optimization that was causing trouble on x86 builds, and
> was not expected to have any positive effect in the first place.
>
> However, as the GCC manual documents, __attribute__((optimize))
> is not for production use, and results in all other optimization
> options to be forgotten for the function in question. This can
> cause all kinds of trouble, but in one particular reported case,
> it causes -fno-asynchronous-unwind-tables to be disregarded,
> resulting in .eh_frame info to be emitted for the function.
>
> This reverts commit 3193c0836, and instead, it disables the -fgcse
> optimization for the entire source file, but only when building for
> X86 using GCC with CONFIG_BPF_JIT_ALWAYS_ON disabled. Note that the
> original commit states that CONFIG_RETPOLINE=n triggers the issue,
> whereas CONFIG_RETPOLINE=y performs better without the optimization,
> so it is kept disabled in both cases.
>
> Fixes: 3193c0836 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

(probably you missed by tag on v1 due to kernel.org hickups)

Thanks, this gets rid of the following warning, which you may
want to quote in the patch description:

    aarch64-linux-gnu-ld: warning: orphan section `.eh_frame' from
`kernel/bpf/core.o' being placed in section `.eh_frame'

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

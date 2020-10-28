Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7419C29E2DE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgJ1VfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:35:10 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34437 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgJ1VfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:35:05 -0400
Received: by mail-ot1-f66.google.com with SMTP id k3so539594otp.1;
        Wed, 28 Oct 2020 14:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dm29FGJ3HmM/IlgprUU1WrHRYzNgHTCNIAv/rcKqb3E=;
        b=B2LxXgI1ogF0WFOJCxCq3Hxyf3TKRVpH2mAubeklbKWFSVuJmDy5g18jCdArVR+DcZ
         HvWKI44eYHvr/R83MgiBPBhAiBpRN2+2Jq3dwum5+byv/xQP83TZMtuh1DIzXl6Ic6fv
         PJ3fW2ZY5Yf5Mp/2/wW0893vbUlqdZdMlHT43MEX2zVbTjIBeANH6Nr26cBPaRZDfFjA
         su+Bs6iFBRew8SjCYILlq6ACQYpkhMT1yeTQ6dwR7INEsreZRgvURvVr67OqOHCIawJE
         9glllvegRQ8LWrso1soCrJj7ufoBpoalnn8EZ7yEUueX2GoevgiAKT5YS343LLJQmmMt
         LA2A==
X-Gm-Message-State: AOAM532Bwv0AUEijQC+ckAShqVz59wxAd/xiaU5FTjbSgqT3RCU0ZYXp
        WZmCINeXDjxXSL8keBaI61psi+c4IfONjdxQ1XBZQ8iAPtowqQ==
X-Google-Smtp-Source: ABdhPJyiFo5ZuvsGBWsEWNiTUNzawsjQjWkumJ/qvE8apdgG5pLkLHcLQeoXYV3O5WRNlHx+5G1aglKsES1yvUIXIU4=
X-Received: by 2002:a9d:5e14:: with SMTP id d20mr4090804oti.107.1603873848080;
 Wed, 28 Oct 2020 01:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org>
In-Reply-To: <20201027205723.12514-1-ardb@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 28 Oct 2020 09:30:37 +0100
Message-ID: <CAMuHMdVmOCmRsJVixPA2U9jB5AKL7NQdCzxx8f5FoXpyOpDwGA@mail.gmail.com>
Subject: Re: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
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

Hi Ard,

On Tue, Oct 27, 2020 at 9:57 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> Commit 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for
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
> resulting in .eh_frame info to be emitted for the function
> inadvertently.
>
> This reverts commit 3193c0836f203, and instead, it disables the -fgcse
> optimization for the entire source file, but only when building for
> X86.
>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Arvind Sankar <nivedita@alum.mit.edu>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Kees Cook <keescook@chromium.org>
> Fixes: 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

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

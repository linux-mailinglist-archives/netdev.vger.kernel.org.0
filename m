Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75C5E34C1C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfFDPYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:24:01 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37511 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfFDPYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:24:01 -0400
Received: by mail-lj1-f196.google.com with SMTP id 131so7553787ljf.4;
        Tue, 04 Jun 2019 08:23:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e9ratwkYZTHPUaWtKNjrsVcjG+vuTRZK6Xsqs+QWhpY=;
        b=aTNLjZfyGHcHc26kS31zf/6puCqLe2VVEvRMDoMCmTkKtlMERKmV598AFe69YrhMJb
         SIMOgaFYf8EFPu3yv2QsCL0iqzaowexo3oCIRhGUQoazhD8f72pEHsg1e2Ku6EMDMQ8p
         7crMAtd3Z6K3+UBWyI67wAWCvEFZGEcphmM4GLh8aO+tKYZeh50uZKj7l52qL2n7C/+G
         s5yZBS7e/1ZULMRm8lzx/ZtSbM5WZTG9R/glq1BGA+bu2+xDdrSQlYFP4CfglCbNA+e/
         ZaVeuTKW4S09098EOw0nNsPMgr/+Pu8adIbkAIErGJedn9Su3VcV8fB14iyai+ajJHRH
         AScg==
X-Gm-Message-State: APjAAAXQ5rxd0Cwgc9/avl1AOKqU9WZl9o3sv3/rO6xhZ/tNfnV7wNrW
        hEqK5UAT4vvGKnG6Vv8zpPj+0V0xiYQJ8gG5r50=
X-Google-Smtp-Source: APXvYqzJDt0nSyfZlN6vvg93pPcZ2wLxDjmcz758i3+F9frAWY9R84zZ+LDW23VZCoTddP+uj8UVER5rRJBGVcDlLgo=
X-Received: by 2002:a2e:9255:: with SMTP id v21mr10245939ljg.178.1559661838683;
 Tue, 04 Jun 2019 08:23:58 -0700 (PDT)
MIME-Version: 1.0
References: <f42c7b44b3f694056c4216e9d9ba914b44e72ab9.1559648367.git.baruch@tkos.co.il>
 <CAADnVQJ1vRvqNFsWjvwmzSc_-OY51HTsVa13XhgK1v9NbYY2_A@mail.gmail.com>
In-Reply-To: <CAADnVQJ1vRvqNFsWjvwmzSc_-OY51HTsVa13XhgK1v9NbYY2_A@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 4 Jun 2019 17:23:46 +0200
Message-ID: <CAMuHMdV-0s_ikRmCrEcMCfkAp57Fu8WTUnJsopGagbYa+GGpbA@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix uapi bpf_prog_info fields alignment
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "Dmitry V . Levin" <ldv@altlinux.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Tue, Jun 4, 2019 at 5:17 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Tue, Jun 4, 2019 at 4:40 AM Baruch Siach <baruch@tkos.co.il> wrote:
> > Merge commit 1c8c5a9d38f60 ("Merge
> > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
> > fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
> > applications") by taking the gpl_compatible 1-bit field definition from
> > commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
> > bpf_prog_info") as is. That breaks architectures with 16-bit alignment
> > like m68k. Widen gpl_compatible to 32-bit to restore alignment of the
> > following fields.
>
> The commit log is misleading and incorrect.
> Since compiler makes it into 16-bit field, it's a compiler bug.
> u32 in C should stay as u32 regardless of architecture.

C99 says (Section 6.7.2.1, Structure and union specifiers, Semantics)

    10  An implementation may allocate any addressable storage unit
        large enough to hold a bit-field.

$ cat hello.c
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

struct x {
        unsigned int bit : 1;
        unsigned char byte;
};

int main(int argc, char *argv[])
{
        struct x x;

        printf("byte is at offset %zu\n", (uintptr_t)&x.byte - (uintptr_t)&x);
        printf("sizeof(x) = %zu\n", sizeof(x));
        exit(0);
}
$ gcc -Wall hello.c -o hello && ./hello
byte is at offset 1
sizeof(x) = 4
$ uname -m
x86_64

So the compiler allocates a single byte, even on a 64-bit platform!
The gap is solely determined by the alignment rule for the
successive field.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

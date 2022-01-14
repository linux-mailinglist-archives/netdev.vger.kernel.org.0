Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F09148EC3C
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242218AbiANPIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:08:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32994 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiANPId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:08:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A07061EC0;
        Fri, 14 Jan 2022 15:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABABDC36AEB;
        Fri, 14 Jan 2022 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642172908;
        bh=CtQ6ZOtNT7z1AMej504pXmMqMHKixdfvyoxsqixy7FM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LM60DmKxPUQvy3gacRTdz07wJ/r5OcFJ21TEhgf4QvsOfoxlvFlrB/bPq7FiUGdCh
         xvi8KLQzufTlLinlVes9gFygwj0bpOXE824z/ezdl+fjl6vpAI78OznNOldDjGSJlh
         B2pxzoYNOat2ZDN3zztijbAGxq9YWRV2hHNZSCbE0UDKIrTm7XAvd7l9NgQnqY6rqi
         AtKQ2+Jaf15Ri5aGAzNHtQKH0PBq/9YT5BhieBmq3MOWRiDRgmWfJ6s8uDlzzPXpbx
         QSBYIhT67CM48GDLd2xL/2jfycJAoy9AVcypF6dpaXD+mhAIxQC0UQL7lBJN7ulW2G
         G5Jqneflltn8g==
Received: by mail-wr1-f54.google.com with SMTP id v6so16091010wra.8;
        Fri, 14 Jan 2022 07:08:28 -0800 (PST)
X-Gm-Message-State: AOAM532t21ZXqFeV0JYQ9e3OEas5Fu0f5ClE4yrgoZ6xl+2qJvYayUyb
        WmAXFVf2hYxEajpcr+8MEFqaBh3vzs6aX60V5c0=
X-Google-Smtp-Source: ABdhPJzn1XtOkPf3Uj/N7N6GWjY/AWhSkNxLOXT/oUWl44TmSou49XTna0hda7KdSVS3ckAPaCabVoldlNYLJKSmO8M=
X-Received: by 2002:a05:6000:154c:: with SMTP id 12mr8620813wry.447.1642172906987;
 Fri, 14 Jan 2022 07:08:26 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk> <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
 <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
 <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com> <CAHmME9oq36JdV8ap9sPZ=CDfNyaQd6mXd21ztAaZiL7pJh8RCw@mail.gmail.com>
In-Reply-To: <CAHmME9oq36JdV8ap9sPZ=CDfNyaQd6mXd21ztAaZiL7pJh8RCw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 14 Jan 2022 16:08:14 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE3JtNjgF3FZjbL-GOQG41yODup4+XdEFP063F=-AWg8A@mail.gmail.com>
Message-ID: <CAMj1kXE3JtNjgF3FZjbL-GOQG41yODup4+XdEFP063F=-AWg8A@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 at 15:12, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Alexei,
>
> On Thu, Jan 13, 2022 at 11:45 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Thu, Jan 13, 2022 at 4:27 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > Hi Alexei,
> > >
> > > On 1/13/22, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > > Nack.
> > > > It's part of api. We cannot change it.
> > >
> > > This is an RFC patchset, so there's no chance that it'll actually be
> > > applied as-is, and hence there's no need for the strong hammer nack.
> > > The point of "request for comments" is comments. Specifically here,
> > > I'm searching for information on the ins and outs of *why* it might be
> > > hard to change. How does userspace use this? Why must this 64-bit
> > > number be unchanged? Why did you do things this way originally? Etc.
> > > If you could provide a bit of background, we might be able to shake
> > > out a solution somewhere in there.
> >
> > There is no problem with the code and nothing to be fixed.
>
> Yes yes, my mama says I'm the specialist snowflake of a boy too. That
> makes two of us ice crystals, falling from the winter heavens,
> blessing vim with our beautiful shapes and frosty code.
>

Can we please keep it professional, guys?

> Anyway, back to reality, as Geert points out, we're hoping to be able
> to remove lib/sha1.c from vmlinux (see 3/3 of this series) for
> codesize, and this bpf usage here is one of two remaining usages of
> it. So I was hoping that by sending this RFC, it might elicit a bit
> more information about the ecosystem around the usage of the function,
> so that we can start trying to think of creative solutions to sunset
> it.
>

Yeah, so the issue is that, at *some* point, SHA-1 is going to have to
go. So it would be helpful if Alexei could clarify *why* he doesn't
see this as a problem. The fact that it is broken means that it is no
longer intractable to forge collisions, which likley means that SHA-1
no longer fulfills the task that you wanted it to do in the first
place.

And just dismissing the issue every time it comes up won't make the
problem go away. There are people on this thread that have a much
better handle on how to use crypto safely and responsibly, and it is
in everybody's interest if we can come to an agreement about when and
how SHA-1 will be phased out.


> I started trying to figure out what's up there and wound up with some
> more questions. My primary one is why you're okay with such a weak
> "checksum" -- the thing is only 64-bits, and as you told Andy Polyakov
> in 2016 when he tried to stop you from using SHA-1, "Andy, please read
> the code. \ we could have used jhash there just as well. \ Collisions
> are fine."
>
> Looking at https://github.com/iovisor/bcc/blob/e17c4f7324d8fc5cc24ba8ee1db451666cd7ced3/src/cc/bpf_module.cc#L571
> I see:
>
>   err = bpf_prog_compute_tag(insns, prog_len, &tag1);
>   if (err)
>     return err;
>   err = bpf_prog_get_tag(prog_fd, &tag2);
>   if (err)
>     return err;
>   if (tag1 != tag2) {
>     fprintf(stderr, "prog tag mismatch %llx %llx\n", tag1, tag2);
>
> So it's clearly a check for something. A collision there might prove pesky:
>
>   char buf[128];
>   ::snprintf(buf, sizeof(buf), BCC_PROG_TAG_DIR "/bpf_prog_%llx", tag1);
>   err = mkdir(buf, 0777);
>
> Maybe you don't really see a security problem here, because these
> programs are root loadable anyway? But I imagine things will
> ultimately get more complicated later on down the road when bpf
> becomes more modular and less privileged and more namespaced -- the
> usual evolution of these sorts of features.
>
> So I'm wondering - why not just do this in a more robust way entirely,
> and always export a sufficiently sized blake2s hash? That way we'll
> never have these sorts of shenanigans to care about. If that's not a
> sensible thing to do, it's likely that I _still_ don't quite grok the
> purpose of the program tag, in which case, I'd be all ears to an
> explanation.
>
> Jason
>
> [ PS: As an aside, I noticed some things in the userspace tag
> calculation code at
> https://github.com/iovisor/bcc/blob/aa7200b9b2a7a2ce2e8a6f0dc1f456f3f93af1da/src/cc/libbpf.c#L536
> - you probably shouldn't use AF_ALG for things that are software based
> and can be done in userspace faster. And the unconditional
> __builtin_bswap64 there means that the code will fail on big endian
> systems. I know you mostly only care about x86 and all, but <endian.h>
> might make this easy to fix. ]

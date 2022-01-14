Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA4648EB54
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiANOMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiANOMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:12:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C348C061574;
        Fri, 14 Jan 2022 06:12:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD7C861CB0;
        Fri, 14 Jan 2022 14:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE92AC36AEC;
        Fri, 14 Jan 2022 14:12:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FN49HvIi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642169570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LIMH262hTr1jVdFOs326DIRgfGVgp0+2qWG3fNbUYe0=;
        b=FN49HvIikRDwacVw+jUnmDgVYcLelNrJn6xdc3L00w4crPBYyNsMYLqjINzqIHNbYf59TJ
        rHLePFEWS6PBSSFZbgFPz9Z3naOs8TTB4bfFHn3pMp2cGZrsE1mTdzsVIb5x3vyLmqaXo3
        aeo9UqGrMg7CilyInPMwdReEE58rE54=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9a5dd7a9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 14:12:49 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id c10so24307987ybb.2;
        Fri, 14 Jan 2022 06:12:49 -0800 (PST)
X-Gm-Message-State: AOAM532wJ36Dti313ntlYd7xM3bHE5KMZlUB4MB9H1/9u4iZAdGEMbsk
        vT0wi3jfBHrQRzRJ4jA4Vq4eBCe4aWqc0BKvjy8=
X-Google-Smtp-Source: ABdhPJyK1aAnC+0tJZUV+DCA0RieE3QpF7oJw379/gdehyvjAagEN9wrY6yMkVRSf7JT1ik4kf+4v/JTpiaLNxm2gpY=
X-Received: by 2002:a25:a0c4:: with SMTP id i4mr13252823ybm.457.1642169568253;
 Fri, 14 Jan 2022 06:12:48 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk> <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
 <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com> <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
In-Reply-To: <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Jan 2022 15:12:37 +0100
X-Gmail-Original-Message-ID: <CAHmME9oq36JdV8ap9sPZ=CDfNyaQd6mXd21ztAaZiL7pJh8RCw@mail.gmail.com>
Message-ID: <CAHmME9oq36JdV8ap9sPZ=CDfNyaQd6mXd21ztAaZiL7pJh8RCw@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Thu, Jan 13, 2022 at 11:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Thu, Jan 13, 2022 at 4:27 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hi Alexei,
> >
> > On 1/13/22, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > Nack.
> > > It's part of api. We cannot change it.
> >
> > This is an RFC patchset, so there's no chance that it'll actually be
> > applied as-is, and hence there's no need for the strong hammer nack.
> > The point of "request for comments" is comments. Specifically here,
> > I'm searching for information on the ins and outs of *why* it might be
> > hard to change. How does userspace use this? Why must this 64-bit
> > number be unchanged? Why did you do things this way originally? Etc.
> > If you could provide a bit of background, we might be able to shake
> > out a solution somewhere in there.
>
> There is no problem with the code and nothing to be fixed.

Yes yes, my mama says I'm the specialist snowflake of a boy too. That
makes two of us ice crystals, falling from the winter heavens,
blessing vim with our beautiful shapes and frosty code.

Anyway, back to reality, as Geert points out, we're hoping to be able
to remove lib/sha1.c from vmlinux (see 3/3 of this series) for
codesize, and this bpf usage here is one of two remaining usages of
it. So I was hoping that by sending this RFC, it might elicit a bit
more information about the ecosystem around the usage of the function,
so that we can start trying to think of creative solutions to sunset
it.

I started trying to figure out what's up there and wound up with some
more questions. My primary one is why you're okay with such a weak
"checksum" -- the thing is only 64-bits, and as you told Andy Polyakov
in 2016 when he tried to stop you from using SHA-1, "Andy, please read
the code. \ we could have used jhash there just as well. \ Collisions
are fine."

Looking at https://github.com/iovisor/bcc/blob/e17c4f7324d8fc5cc24ba8ee1db451666cd7ced3/src/cc/bpf_module.cc#L571
I see:

  err = bpf_prog_compute_tag(insns, prog_len, &tag1);
  if (err)
    return err;
  err = bpf_prog_get_tag(prog_fd, &tag2);
  if (err)
    return err;
  if (tag1 != tag2) {
    fprintf(stderr, "prog tag mismatch %llx %llx\n", tag1, tag2);

So it's clearly a check for something. A collision there might prove pesky:

  char buf[128];
  ::snprintf(buf, sizeof(buf), BCC_PROG_TAG_DIR "/bpf_prog_%llx", tag1);
  err = mkdir(buf, 0777);

Maybe you don't really see a security problem here, because these
programs are root loadable anyway? But I imagine things will
ultimately get more complicated later on down the road when bpf
becomes more modular and less privileged and more namespaced -- the
usual evolution of these sorts of features.

So I'm wondering - why not just do this in a more robust way entirely,
and always export a sufficiently sized blake2s hash? That way we'll
never have these sorts of shenanigans to care about. If that's not a
sensible thing to do, it's likely that I _still_ don't quite grok the
purpose of the program tag, in which case, I'd be all ears to an
explanation.

Jason

[ PS: As an aside, I noticed some things in the userspace tag
calculation code at
https://github.com/iovisor/bcc/blob/aa7200b9b2a7a2ce2e8a6f0dc1f456f3f93af1da/src/cc/libbpf.c#L536
- you probably shouldn't use AF_ALG for things that are software based
and can be done in userspace faster. And the unconditional
__builtin_bswap64 there means that the code will fail on big endian
systems. I know you mostly only care about x86 and all, but <endian.h>
might make this easy to fix. ]

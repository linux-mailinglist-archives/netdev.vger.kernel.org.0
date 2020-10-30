Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D7C2A10DD
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJ3Wac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgJ3Wac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 18:30:32 -0400
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76F05221EB;
        Fri, 30 Oct 2020 22:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604097031;
        bh=1SEtV+7K6WPgubjmBr0YXBpynUzAYHX6x8Trau0hjY0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PFkdvN/uN9mwQJ+RX4cJkafCuiraa/ClnR4xIV6pv4X4aAUln6IbnhWR2rPiG2PDf
         KyTty//Nrb1jVh5HpeLzwv0nhZocvCGg3o5cX5yUNPQDyNnQHEkcgyDMG6AzXLqvQe
         6u+IQ7D9/fQB+tyWNDpK7Q4vM3YuHL5MCA9tm+4k=
Received: by mail-lf1-f50.google.com with SMTP id b1so9777512lfp.11;
        Fri, 30 Oct 2020 15:30:31 -0700 (PDT)
X-Gm-Message-State: AOAM531x6jSz/5sMJsbjMb1lnuUNT9Cfc1YKRqkWcpZoxL5oelc+dw9N
        bIfegCmU7xitDZ567+Z8XoB4asuE5pCiMXWrPFg=
X-Google-Smtp-Source: ABdhPJzBOsmHcOgFpWu50Y+0W3w/cW4Zma33T1uq8r0sgrEgI4b1bnx7rbJvjFkshhwvSIx7y56JXfOI4P5gcm8EXCE=
X-Received: by 2002:a19:c703:: with SMTP id x3mr1653157lff.105.1604097029626;
 Fri, 30 Oct 2020 15:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-3-andrii@kernel.org>
 <CAPhsuW6DxoRjBPJEgwzEtmVt-Uunw-MAmAF2tgh-ksjcKuJ4Bw@mail.gmail.com> <CAEf4Bzaj6mfLPtMbXBNJ9Z2E4AKS8W4vcYG6OGuO_XftAqKBeQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzaj6mfLPtMbXBNJ9Z2E4AKS8W4vcYG6OGuO_XftAqKBeQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 30 Oct 2020 15:30:18 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5yKwo47uhpJVqGNvQBDw2w7adkZYfW9nk9Uk0RKRC-og@mail.gmail.com>
Message-ID: <CAPhsuW5yKwo47uhpJVqGNvQBDw2w7adkZYfW9nk9Uk0RKRC-og@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/11] selftest/bpf: relax btf_dedup test checks
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 11:45 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
[...]
> > > @@ -6775,10 +6774,15 @@ static void do_test_dedup(unsigned int test_num)
> > >                         err = -1;
> > >                         goto done;
> > >                 }
> > > -               if (CHECK(memcmp((void *)test_type,
> > > -                                (void *)expect_type,
> > > -                                test_size),
> > > -                         "type #%d: contents differ", i)) {
> >
> > I guess test_size and expect_size are not needed anymore?
>
> hm.. they are used just one check above, still needed

Hmm... I don't know what happened to me back then.. Please ignore.

>
> >
> > > +               if (CHECK(btf_kind(test_type) != btf_kind(expect_type),
> > > +                         "type %d kind: exp %d != got %u\n",
> > > +                         i, btf_kind(expect_type), btf_kind(test_type))) {
> > > +                       err = -1;
> > > +                       goto done;
> > > +               }
> > > +               if (CHECK(test_type->info != expect_type->info,
> > > +                         "type %d info: exp %d != got %u\n",
> > > +                         i, expect_type->info, test_type->info)) {
> >
> > btf_kind() returns part of ->info, so we only need the second check, no?
>
> technically yes, but when kind mismatches, figuring that out from raw
> info field is quite painful, so having a better, more targeted check
> is still good.

Fair enough. We can have a more clear check.

Thanks,
Song

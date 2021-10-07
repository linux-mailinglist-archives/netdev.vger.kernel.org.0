Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF94425E56
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhJGU7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233984AbhJGU7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F7761260;
        Thu,  7 Oct 2021 20:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633640266;
        bh=kq9ipP3n9kqk0udZeE9so7NJ5j6P2xpJapjR4CXaRyM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J0Spw7axv/RHJn3TJ9iuauB0lE+yVrz/uEosOKMrGLroJa5QBpe69YEncu5J4Hjf/
         HABp+/opqR+pyS/ypSieRV10cNQRsj6ljxEv6p9oRlQFLIz4YJeJVlbAi4Tf12n1ov
         2bqQWpIhU/W4iLsolyyVbwTkB9e8GOheOnhIaEzwUiUgtE8pnyDXqhQVqGSgbFLJDf
         p9e0PtP7F/J/2Y0AJ3rwS4b0ZVQSZwjnraNlHu91r/bntZrW5B8AXP1SudVyj0iODf
         wkPWZrlUBDd8erp1NtQXxFb6/fQhaIVmaJKvL5dKu6ZoUBL+mBiMrS1h7gGluZzJNF
         G5WufKyQJD1Bw==
Received: by mail-lf1-f52.google.com with SMTP id i24so28769555lfj.13;
        Thu, 07 Oct 2021 13:57:46 -0700 (PDT)
X-Gm-Message-State: AOAM532h+IVnwfdKq0BjdZI9g5VhA/APV/kCWHYQ0JxXoHZ88FQyZXsT
        si4IZL9D8kj8FDz9GBfMsf01bw5G309f3OLsoL8=
X-Google-Smtp-Source: ABdhPJyn/YCpkYPG4okYft7JLZaGkH804BXrMpZSu9j5zYfD3VL842eipRpzrovUvtSQ1FGeMQhx79Nm8k58yA1m3Vk=
X-Received: by 2002:ac2:5582:: with SMTP id v2mr6512651lfg.143.1633640264670;
 Thu, 07 Oct 2021 13:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-5-memxor@gmail.com>
 <CAPhsuW7y3ycWkXLwSmJ5TKbo7Syd65aLRABtWbZcohET0RF6rA@mail.gmail.com> <20211007204609.ygrqpx4rahfzqzly@apollo.localdomain>
In-Reply-To: <20211007204609.ygrqpx4rahfzqzly@apollo.localdomain>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Oct 2021 13:57:33 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4X3L7ZZH_RfeP5xYvoMh3STthqZEFDpcqTTjbkfsh3sw@mail.gmail.com>
Message-ID: <CAPhsuW4X3L7ZZH_RfeP5xYvoMh3STthqZEFDpcqTTjbkfsh3sw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 4/6] bpf: selftests: Move test_ksyms_weak test
 to lskel, add libbpf test
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 1:46 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
[...]
> > >
> > >  /* typeless symbols, default to zero. */
> > > @@ -38,7 +37,7 @@ int pass_handler(const void *ctx)
> > >         /* tests existing symbols. */
> > >         rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
> > >         if (rq)
> > > -               out__existing_typed = rq->cpu;
> > > +               out__existing_typed = 0;
> >
> > Why do we need this change?
> >
>
> Since they share the same BPF object for generating skeleton, it needs to remove
> dependency on CO-RE which gen_loader does not support.
>
> If it is kept, we get this:
> ...
> libbpf: // TODO core_relo: prog 0 insn[5] rq kind 0
> libbpf: prog 'pass_handler': relo #0: failed to relocate: -95
> libbpf: failed to perform CO-RE relocations: -95
> libbpf: failed to load object 'test_ksyms_weak'

I see. Thanks for the explanation.

Song

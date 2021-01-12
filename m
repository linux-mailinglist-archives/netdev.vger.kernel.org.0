Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793B62F3576
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406525AbhALQSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:18:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406508AbhALQSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 11:18:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9560C23117
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 16:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610468260;
        bh=CoI1g52qNIryGpFWepCTL4prXOBxmbo4WiGrzxRBQlA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JJVzSHdgO1ws6H/D24wVXlrgHNqXtP+dlwOmTRrVvjDaJMavwKl00ORf0Sq7tdDtE
         n8oulnveMEUZ7FWxrvEbctTohR2Z9hE85YJGMYRYUnkOSTVTPkNSGg7A1NYNAXIvcB
         O2deKc9s5kBQF7ouaaTvie2lytEIXJ4OENfHkrtNxPHZoXU4NP3ncDwIy9s5ZfMhOy
         TdsVLPYFJniq2pEuDIvMFUgZO2Hj13yEO4h73mr+gQCt2uN3mBbG1WRRGyLsT5VuWA
         3R8AEoUCzrwzD7GA2NM9EgeR3t24E5TEGLeZyMkT3H49kBAA82wZt/CLk8NRwdIMOB
         cUM4L64Fj1wvg==
Received: by mail-lf1-f44.google.com with SMTP id h205so4218261lfd.5
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 08:17:39 -0800 (PST)
X-Gm-Message-State: AOAM531g0sfjc6sgFMkguhDINWUjlYrOQ+p9ZAkkLw33k8PYW0BWjxQI
        5jhz4b+MOfGWn1rb4PubPG7wsJO6OJY/asb4Gput3A==
X-Google-Smtp-Source: ABdhPJyphcIptdvuiusWElNIOsd2UVvUfETzlw5D23qNpR/REKCWs64wDJXdXhm1+cIiNbm+DcFAY8IGibS/or6YFBQ=
X-Received: by 2002:a19:cbd8:: with SMTP id b207mr2542971lfg.550.1610468257650;
 Tue, 12 Jan 2021 08:17:37 -0800 (PST)
MIME-Version: 1.0
References: <20210112091545.10535-1-gilad.reti@gmail.com> <CACYkzJ69serkHRymzDEAcQ-_KAdHA+RxP4qpAwzGmppWUxYeQQ@mail.gmail.com>
 <CANaYP3G_39cWx_L5Xs3tf1k4Vj9JSHcsr+qzNQN-dcY3qvT8Yg@mail.gmail.com> <60034a79-573f-125c-76b0-17e04941a155@iogearbox.net>
In-Reply-To: <60034a79-573f-125c-76b0-17e04941a155@iogearbox.net>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 12 Jan 2021 17:17:26 +0100
X-Gmail-Original-Message-ID: <CACYkzJ7dK62zbn_z0S=-Xps1=DCEcd1FPYFon-BUeha=N5KnJQ@mail.gmail.com>
Message-ID: <CACYkzJ7dK62zbn_z0S=-Xps1=DCEcd1FPYFon-BUeha=N5KnJQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests/bpf: add verifier test for PTR_TO_MEM spill
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Gilad Reti <gilad.reti@gmail.com>, bpf <bpf@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 4:43 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/12/21 4:35 PM, Gilad Reti wrote:
> > On Tue, Jan 12, 2021 at 4:56 PM KP Singh <kpsingh@kernel.org> wrote:
> >> On Tue, Jan 12, 2021 at 10:16 AM Gilad Reti <gilad.reti@gmail.com> wrote:
> >>>
> >>> Add test to check that the verifier is able to recognize spilling of
> >>> PTR_TO_MEM registers.
> >>
> >> It would be nice to have some explanation of what the test does to
> >> recognize the spilling of the PTR_TO_MEM registers in the commit
> >> log as well.
> >>
> >> Would it be possible to augment an existing test_progs
> >> program like tools/testing/selftests/bpf/progs/test_ringbuf.c to test
> >> this functionality?
>
> How would you guarantee that LLVM generates the spill/fill, via inline asm?

Yeah, I guess there is no sure-shot way to do it and, adding inline asm would
just be doing the same thing as this verifier test. You can ignore me
on this one :)

It would, however, be nice to have a better description about what the test is
actually doing./


>
> > It may be possible, but from what I understood from Daniel's comment here
> >
> > https://lore.kernel.org/bpf/17629073-4fab-a922-ecc3-25b019960f44@iogearbox.net/
> >
> > the test should be a part of the verifier tests (which is reasonable
> > to me since it is
> > a verifier bugfix)
>
> Yeah, the test_verifier case as you have is definitely the most straight
> forward way to add coverage in this case.

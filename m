Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CE33228A7
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhBWKLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbhBWKLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 05:11:43 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC14C061786
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 02:10:57 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id u4so10429212lfs.0
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 02:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zSiaCFu+244vSDwMi2SVRQIE07m+0ajrljfb0U+L/MI=;
        b=iBe8/+rbC8fuwkD84ucf1LPejX+eTzW8LnVHnl1Sp8npjz3bzThOJ2j05NqA+3JAwI
         dmmV/jAt6jkIDUURDz8WlhEVWZGRRhHLOkPMqq7AArvsWVehA6GiZUSgUbxI1zjEnvy/
         fvYqIp92c8Spk5opogYW88TcbXVIxsYrfU7K0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zSiaCFu+244vSDwMi2SVRQIE07m+0ajrljfb0U+L/MI=;
        b=Po9qQBOi5fYRF5QB/YRzEv20ofsOdzekIkwZ3NYZ5V6kjvej0AIqYFMqLIu7cRWeC2
         7QLOnMDfX9elF1iSXISOqexsnVk9zAKfm4CsGFb4uWsSfSWwMNfWyrzgd7nQ5pUyhgxe
         R/F6gfvo9qzb3XurtPT4eJXDwLT1AaYv2HPIZx5Wvmab+lawgGtmaqA8HFVYX+XKt+t/
         1DnM8QEWngm7aoFJ04Y5vPWj7jT5/LpZApOs0goRJ1tug0wtzmt/Wy462c3QPZyxtcch
         XpchYfwc2ZD+U8OvhFYNbDjdo761skRYTbWX6e/vaRH+ljTdmM5Uc6bhMBQNq+IW5ghO
         BSuA==
X-Gm-Message-State: AOAM5311DiUKnnoKatOhVluaOTLhnXTqGz9OPCgxgXcJ1oiDmlOqtN8N
        j4PqAIpNQhcNQ/HA3mjZ33d8kwAFjQU/HJOJOFDtEg==
X-Google-Smtp-Source: ABdhPJxEcF4RIT0ItB5V6OCMLoGA77oJGjKcGT0aK88oPFCUS8oPkE7g8gZWVNqqJO4hye7wrWmL/wI7m25hozhWvJY=
X-Received: by 2002:a19:711e:: with SMTP id m30mr15206441lfc.97.1614075055606;
 Tue, 23 Feb 2021 02:10:55 -0800 (PST)
MIME-Version: 1.0
References: <20210216105713.45052-1-lmb@cloudflare.com> <20210216105713.45052-5-lmb@cloudflare.com>
 <20210223011153.4cvzpvxqn7arbcej@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210223011153.4cvzpvxqn7arbcej@ast-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 23 Feb 2021 10:10:44 +0000
Message-ID: <CACAyw99hQgG+=WvUVmDU-E6nGsPvosSuSOWgw9uWDDZ-vFfsqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/8] bpf: add PROG_TEST_RUN support for sk_lookup programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 at 01:11, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> I'm struggling to come up with the case where running N sk_lookup progs
> like this cannot be done with running them one by one.
> It looks to me that this N prog_fds api is not really about running and
> testing the progs, but about testing BPF_PROG_SK_LOOKUP_RUN_ARRAY()
> SK_PASS vs SK_DROP logic.

In a way that is true, yes. TBH I figured that my patch set would be
rejected if I just
implemented single program test run, since it doesn't allow exercising the full
sk_lookup test run semantics.

> So it's more of the kernel infra testing than program testing.
> Are you suggesting that the sequence of sk_lookup progs are so delicate
> that they are aware of each other and _has_ to be tested together
> with gluing logic that the macro provides?

We currently don't have a case like that.

> But if it is so then testing the progs one by one would be better,
> because test_run will be able to check each individual prog return code
> instead of implicit BPF_PROG_SK_LOOKUP_RUN_ARRAY logic.

That means emulating the kind of subtle BPF_PROG_SK_LOOKUP_RUN_ARRAY
in user space, which isn't trivial and a source of bugs.

For example we rely on having multiple programs attached when
"upgrading" from old to new BPF. Here we care mostly that we don't drop
lookups on the floor, and the behaviour is tightly coupled to the in-kernel
implementation. It's not much use to cobble up my own implementation of
SK_LOOKUP_RUN_ARRAY here, I would rather use multi progs to test this.
Of course we can also already spawn a netns and test it that way, so not
much is lost if there is no multi prog test run.

> It feels less of the unit test and more as a full stack test,
> but if so then lack of cookie on input is questionable.

I'm not sure what you mean with "the lack of cookie on input is
questionable", can you rephrase?

> In other words I'm struggling with in-between state of the api.
> test_run with N fds is not really a full test, but not a unit test either.

If I understand you correctly, a "full" API would expose the
intermediate results from
individual programs as well as the final selection? Sounds quite
complicated, and as
you point out most of the benefits can be had from running single programs.

I'm happy to drop the multiple programs bit, like I mentioned I did it
for completeness sake.
I care about being able to test or benchmark a single sk_lookup program.

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com

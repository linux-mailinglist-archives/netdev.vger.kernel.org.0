Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDE526CEC9
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIPWc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgIPWc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:32:56 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EF3C061797;
        Wed, 16 Sep 2020 14:17:35 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x10so39125ybj.13;
        Wed, 16 Sep 2020 14:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O9oURKzCK+SY2r7WF/hiBkZhA0HPPtP9OQSF2tHZCb4=;
        b=N8z0gb2lxZPTenYaPje8kRJCFQ1YSG6WVnwU+NiJCuG/AsxP4na2Oj3Ic9QqnSv97k
         AIS1gymLDWepQEHtRy2lG4MKS5ehWy7zU1jckAirXEnw2ys0RR9+aA8wrDJnlV4VvUl1
         48rNjzLactFvBrlV8IHRz4zwk53P8aE3GprjqU2rLjiEGSkMtw3WSWO8KFBUqF+j8m/K
         yKVd2ZvyplkCYJx82a1n2CjKVmNL89QZGTV33zjBVbb9ji5yhbtDGyIP73yc5GGBNgPn
         LLUJBFt5UsocoOza/LCrxk+8Ga8s8SJoJ/IdPL/Iw4puLxz+gJ8OiTbVFJAI1VfPOCU9
         yURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O9oURKzCK+SY2r7WF/hiBkZhA0HPPtP9OQSF2tHZCb4=;
        b=gi64p3DdaBiiqHs727/r6+CJmzLb8e/vQB8XC1bfgAbJv8jjcqa02SoArBctPUhCqi
         AS2bsYEDEhvcTcXoh3NoFAIXaXvRN5hnxWY5U3JO9hyJs3ElWciI2yfF400UgxnZhhbw
         w8ZORPrEBZ7b1YbQ5Yc0B4s609dNVfLqVZSTk8FJWgkL6Bqr00X+v4BYAb24qLDloauZ
         4genQn940DW1klYPtqg6kQyO8O4JD8fsmWeECgom5T4itImQlnt5xNUN6DpTE08+14Kf
         jNKqGd+FMhh8qyjEB6SFRnXIhUR0aMiOgVUhf3xHx+C4tIVfd4HkXrMyXtakt6vF9kci
         n4mg==
X-Gm-Message-State: AOAM532qsq+cXyHribJFx2NHQNADoUuUrH6oSUFOyf3YY1n1pzhNu6ch
        ylssmB92oJUOX3G5Evg1bam3oVUH/V5JSwu01sw=
X-Google-Smtp-Source: ABdhPJz1NjlJNRKOu1OYGq4Uv2XMSa8M0PRGL+zygN6VI3zWo1ZU44vViaK3MXBgC1ju+Z3FSHu5ffUipZgvQyxPDus=
X-Received: by 2002:a25:d70e:: with SMTP id o14mr28397822ybg.425.1600291054948;
 Wed, 16 Sep 2020 14:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006133.98230.8867570651560085505.stgit@toke.dk> <CAEf4BzYP6MpVEqJ1TVW6rcfqJjkBi9x9U9F8MZPQdGMmoaUX_A@mail.gmail.com>
 <87r1r1pgr5.fsf@toke.dk>
In-Reply-To: <87r1r1pgr5.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Sep 2020 14:17:23 -0700
Message-ID: <CAEf4BzY+nMbye8wkQjiUra7wHtWZ14aWO5kNwkQFQaj=6-qp9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: support attaching freplace programs
 to multiple attach points
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 2:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
>
> [ will fix all your comments above ]
>
> >> @@ -3924,10 +3983,16 @@ static int tracing_bpf_link_attach(const union=
 bpf_attr *attr, struct bpf_prog *
> >>             prog->expected_attach_type =3D=3D BPF_TRACE_ITER)
> >>                 return bpf_iter_link_attach(attr, prog);
> >>
> >> +       if (attr->link_create.attach_type =3D=3D BPF_TRACE_FREPLACE &&
> >> +           !prog->expected_attach_type)
> >> +               return bpf_tracing_prog_attach(prog,
> >> +                                              attr->link_create.targe=
t_fd,
> >> +                                              attr->link_create.targe=
t_btf_id);
> >
> > Hm.. so you added a "fake" BPF_TRACE_FREPLACE attach_type, which is
> > not really set with BPF_PROG_TYPE_EXT and is only specified for the
> > LINK_CREATE command. Are you just trying to satisfy the link_create
> > flow of going from attach_type to program type? If that's the only
> > reason, I think we can adjust link_create code to handle this more
> > flexibly.
> >
> > I need to think a bit more whether we want BPF_TRACE_FREPLACE at all,
> > but if we do, whether we should make it an expected_attach_type for
> > BPF_PROG_TYPE_EXT then...
>
> Yeah, wasn't too sure about this. But attach_type seemed to be the only
> way to disambiguate between the different link types in the LINK_CREATE
> command, so went with that. Didn't think too much about it, TBH :)

having extra attach types has real costs in terms of memory (in cgroup
land), which no one ever got to fixing yet. And then
prog->expected_attach_type !=3D link's expected_attach_type looks weird
and wrong and who knows which bugs we'll get later because of this.

>
> I guess an alternative could be to just enforce attach_type=3D=3D0 and lo=
ok
> at prog->type? Or if you have any other ideas, I'm all ears!

Right, we have prog fd, so can get it (regardless of type), then do
switch by type, then translate expected attach type to prog type and
see if it matches, but only for program types that care (which right
now is all but tracing, where it's obvious from prog_type alone, I
think).

>
> -Toke
>

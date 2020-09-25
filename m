Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF799278D08
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgIYPpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728693AbgIYPpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:45:18 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44217C0613CE;
        Fri, 25 Sep 2020 08:45:18 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id y2so3289164lfy.10;
        Fri, 25 Sep 2020 08:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g2lMtapjDej6Scyz1khiHbUwhcQffu/af+JLS3CefPk=;
        b=cJJxyx3ta5SSHr6U8WwlSBLGWmls7prHrARXa3V9n5XaqtOa7S6CmZCLg2pv8E5J6s
         VEx7jm1ej2zkdYmIbk4L5RBo35z9RV9xVRSP5cN7hkqQYCbqWZQ/tOG9pZGad3BIYAy3
         YpOKzH2NXDwkXKZyIh8GtZf/2mbaqJxS/O5XUlDF5u6/8Yd8/aw85GE9bSS99OtFSkRk
         ZFSoJ8tfZTsF60RJydifRYu4Ubbs7lLmWkOZXkxO8FDLwZUaT9DJ/QZGN76KuRNYNMq0
         RET3XROtMSZM5aXpdwgPsqIyxcE71XSTbUecl7XHB7jESv8yfNig4Imfti4/4X7mxabX
         XFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g2lMtapjDej6Scyz1khiHbUwhcQffu/af+JLS3CefPk=;
        b=Unpip4TU3nA0fvskeke+n1sz40jgeYgY2G5U4U0yNn2ZSzIz7BM9MCQT77QYlepmhk
         RE4C5CCEMDTH3dMUR4sz3P5X3vGD5kGqxyeq0N/jnAWfqJD57EBEKuUrB9gYEE+/7NA5
         i3rQD5TIwFbiOVVi/LuPm72xCpore5h6hO9Ieqbi2ACbD/fZk8EmngTCpwBXA9Za2Z8l
         2JaFOItyKEhNUhXQlZ44HRQB880234iIS4+J6DwO4NEaqvdmwHeYP3wKjUmp3WmtuXLE
         4TiS8emPumz4Z+P8pGFPLy54U75uHTARHGYpGRKbUiGqMflCLX0Jjyl6NGaRzRZrcRPh
         ptEQ==
X-Gm-Message-State: AOAM533+iXHnDgOg2Lk841p+BrWru1XN3OT4JsSybAvalXL8t/FCdqng
        97Ri+0tCRWKZnuNF7EFWNk769e0OXZE+wgAF9VA=
X-Google-Smtp-Source: ABdhPJwwVPrSeaEcHh51MtJHvq7Y3p/DdgXvKIpoA6hxrY/MSh68L9Eu8sJZo5IHV0FqDiTr+duTmjFs0i8IwaLr6eU=
X-Received: by 2002:a19:8089:: with SMTP id b131mr1460992lfd.390.1601048716485;
 Fri, 25 Sep 2020 08:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk> <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
 <87tuvmbztw.fsf@toke.dk>
In-Reply-To: <87tuvmbztw.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 25 Sep 2020 08:45:04 -0700
Message-ID: <CAADnVQLMBKAYsbS4PO87yVrPWJEf9H3qzpsL-p+gFQpcomDw2w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
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
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 3:00 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> >> +    struct mutex tgt_mutex; /* protects tgt_* pointers below, *after*=
 prog becomes visible */
> >> +    struct bpf_prog *tgt_prog;
> >> +    struct bpf_trampoline *tgt_trampoline;
> >>      bool verifier_zext; /* Zero extensions has been inserted by verif=
ier. */
> >>      bool offload_requested;
> >>      bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp=
 */
> > ...
> >>  struct bpf_tracing_link {
> >>      struct bpf_link link;
> >>      enum bpf_attach_type attach_type;
> >> +    struct bpf_trampoline *trampoline;
> >> +    struct bpf_prog *tgt_prog;
> >
> > imo it's confusing to have 'tgt_prog' to mean two different things.
> > In prog->aux->tgt_prog it means target prog to attach to in the future.
> > Whereas here it means the existing prog that was used to attached to.
> > They kinda both 'target progs' but would be good to disambiguate.
> > May be keep it as 'tgt_prog' here and
> > rename to 'dest_prog' and 'dest_trampoline' in prog->aux ?
>
> I started changing this as you suggested, but I think it actually makes
> the code weirder. We'll end up with a lot of 'tgt_prog =3D
> prog->aux->dest_prog' assignments in the verifier, unless we also rename
> all of the local variables, which I think is just code churn for very
> little gain (the existing 'target' meaning is quite clear, I think).

you mean "churn" just for this patch. that's fine.
But it will make names more accurate for everyone reading it afterwards.
Hence I prefer distinct and specific names where possible.

> I also think it's quite natural that the target moves; I mean, it's
> literally the same pointer being re-assigned from prog->aux to the link.
> We could rename the link member to 'attached_tgt_prog' or something like
> that, but I'm not sure it helps (and I don't see much of a problem in
> the first place).

'attached_tgt_prog' will not be the correct name.
There is 'prog' inside the link already. That's 'attached' prog.
Not this one. This one is the 'attached_to' prog.
But such name would be too long.
imo calling it 'dest_prog' in aux is shorter and more obvious.

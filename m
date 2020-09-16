Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1B126CB83
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgIPU26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgIPU2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:28:52 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7393C06174A;
        Wed, 16 Sep 2020 13:28:51 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id c17so6383223ybe.0;
        Wed, 16 Sep 2020 13:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MVIs1JBkJFZ61cdKipIPslS3rOhT6YsS69ihKIm6isI=;
        b=Cfsh1gc4YG0BdHbDMGnWTV59MZNiCqZ1cxM25XnGcigdAnTeFkaoVX3xENNRc9suKS
         6nGKYtDFymW+I0N39d6LSxl4hpkhZGetxgIHZGlp0B7iSzcws+LLNsn4XqXcrFFzkC2N
         +0M3a2YtUaIieBSVVo30S3VmJt9Xzn3eSVMHhO8gJpfTKyXmFFFm7TkXLLqPjrIEiCXN
         XcxgAXM41VNB87PuuQVGS5ok0ai8mrXTDJy8LDiv7f+Sbo3AV/sU1sHGbAf/aFo8sBGV
         zeiolJ4RPtSAuG33JGpGIyBqoFwAWEoCm3B3kyHCBmrNB5Y/v3oWObRxV5YjErXvieTx
         MSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MVIs1JBkJFZ61cdKipIPslS3rOhT6YsS69ihKIm6isI=;
        b=LTDRd4S2l2uN0vjS+RQi5LP7O7VanVnKyZIY3BFAJn6Lu6ODjosk2oMzLLATjf/I9n
         9WHRAcDbFqCv0ijc7jw9+0/1Zv+Rr70v3gzt92T3/qPY7VbK6SEJCFM4pLuBagB+P+Gm
         I4s8AQknyZB1lVr/Qp0r7nacxQirGf9vHztmBWRzGPYskggZQ2sNkBqHxJwM9fYguZaL
         xqbPYDXnvsUoQeRO2J6ZsFmF/6/LMnC/NafB8ea6GKTbPF2VgLWGuwNfy23VkJHyRldR
         3O3ou3TfrXXYcCOeXzri4Y9sgKDxj34GnRHlqkk30kk1ODPeu9eXvw75HULXXaRtpzY6
         5eQw==
X-Gm-Message-State: AOAM533YgpMNW4n0/MxaJpdRJuVnYYeKhRyXy1+26fm7LieiFEp0ejwX
        OGfoIOPuN2duJdL0X0Y0LNdZBqlg206XtwE9dLM=
X-Google-Smtp-Source: ABdhPJy3eu8Z76RA/1AIXZuufjmbSfPRmDcmQAJT8ImQJO0F9+8jPzCF0vugf5Q+b6Rwalze40D25vht+VEIyH3OzR4=
X-Received: by 2002:a25:4446:: with SMTP id r67mr3608241yba.459.1600288131072;
 Wed, 16 Sep 2020 13:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006242.98230.15812695975228745782.stgit@toke.dk> <CAEf4Bzafmu5w6wjWT_d0B-JaUnm3KOf0Dgp+552iZii2+=3DWg@mail.gmail.com>
In-Reply-To: <CAEf4Bzafmu5w6wjWT_d0B-JaUnm3KOf0Dgp+552iZii2+=3DWg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Sep 2020 13:28:40 -0700
Message-ID: <CAEf4BzbqW12q_nXvat6=iTvKpy1P+e-r0N+9eY3vgDAZ8rcfLQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 5/8] bpf: Fix context type resolving for
 extension programs
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 12:59 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >
> > Eelco reported we can't properly access arguments if the tracing
> > program is attached to extension program.
> >
> > Having following program:
> >
> >   SEC("classifier/test_pkt_md_access")
> >   int test_pkt_md_access(struct __sk_buff *skb)
> >
> > with its extension:
> >
> >   SEC("freplace/test_pkt_md_access")
> >   int test_pkt_md_access_new(struct __sk_buff *skb)
> >
> > and tracing that extension with:
> >
> >   SEC("fentry/test_pkt_md_access_new")
> >   int BPF_PROG(fentry, struct sk_buff *skb)
> >
> > It's not possible to access skb argument in the fentry program,
> > with following error from verifier:
> >
> >   ; int BPF_PROG(fentry, struct sk_buff *skb)
> >   0: (79) r1 =3D *(u64 *)(r1 +0)
> >   invalid bpf_context access off=3D0 size=3D8
> >
> > The problem is that btf_ctx_access gets the context type for the
> > traced program, which is in this case the extension.
> >
> > But when we trace extension program, we want to get the context
> > type of the program that the extension is attached to, so we can
> > access the argument properly in the trace program.
> >
> > This version of the patch is tweaked slightly from Jiri's original one,
> > since the refactoring in the previous patches means we have to get the
> > target prog type from the new variable in prog->aux instead of directly
> > from the target prog.
> >
> > Reported-by: Eelco Chaudron <echaudro@redhat.com>
> > Suggested-by: Jiri Olsa <jolsa@kernel.org>
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
> >  kernel/bpf/btf.c |    9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 9228af9917a8..55f7b2ba1cbd 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -3860,7 +3860,14 @@ bool btf_ctx_access(int off, int size, enum bpf_=
access_type type,
> >
> >         info->reg_type =3D PTR_TO_BTF_ID;
> >         if (tgt_prog) {
> > -               ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_prog-=
>type, arg);
> > +               enum bpf_prog_type tgt_type;
> > +
> > +               if (tgt_prog->type =3D=3D BPF_PROG_TYPE_EXT)
> > +                       tgt_type =3D tgt_prog->aux->tgt_prog_type;
>
> what if tgt_prog->aux->tgt_prog_type is also BPF_PROG_TYPE_EXT? Should
> this be a loop?

ok, never mind this specifically. there is an explicit check

if (tgt_prog->type =3D=3D prog->type) {
    verbose(env, "Cannot recursively attach\n");
    return -EINVAL;
}

that will prevent this.

But, I think we still will be able to construct a long chain of
fmod_ret -> freplace -> fmod_ret -> freplace -> and so on ad
infinitum. Can you please construct such a selftest? And then we
should probably fix those checks to also disallow FMOD_RET, in
addition to BPF_TRACE_FENTRY/FEXIT (and someone more familiar with LSM
prog type should check if that can cause any problems).

>
> Which also brings up a few follow up questions. Now that we allow same
> PROG_EXT program to be attached to multiple other programs:
>
> 1. what prevents us from attaching PROG_EXT to itself?
> 2. How do we prevent long chain of EXT programs or even loops?
>
> Can you please add a few selftests testing such cases? I have a
> feeling that with your changes in this patch set now it's possible to
> break the kernel very easily. I don't know what the proper solution
> is, but let's at least have a test that does show breakage, then try
> to figure out the solution. See also comment in check_attach_btf_id()
> about fentry/fexit and freplace interactions. That might not be
> enough.
>
>
> > +               else
> > +                       tgt_type =3D tgt_prog->type;
> > +
> > +               ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_type,=
 arg);
> >                 if (ret > 0) {
> >                         info->btf_id =3D ret;
> >                         return true;
> >

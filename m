Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7740026E339
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIQSGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgIQSGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:06:35 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC493C06174A;
        Thu, 17 Sep 2020 11:06:30 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x10so2294158ybj.13;
        Thu, 17 Sep 2020 11:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=crHNAHVlKQymoKWU9RZhNMhhrAe0GtaAQ+q4H8Ky7gQ=;
        b=bYWRHxOzfJNJuoZ1Cdwv4Ywrhoy11eW8AFQj+haPXS4aRhaecmpKuVLIH9G6l13+Vb
         gmulKuPjGUHvyEASzFA5fQQhhqeEUk2NVMcpjmyLJNlqFJ3rKFn2SEuzeSVPemdepQdN
         BLHeGAKQlqjKTZZChabNjynOkF8qXxSYIr82LfM7Lka/ryteE+ymVIw3upyA3zVfwFP8
         fUUas3XOnq+/Y98w1aOoFuUB705TAeQsZ/XFS52V7UnZU7hFoz1w7CBK2OJIOSSRxscA
         99GXOnrF0g81Yeh60ESBofZTJ887ctt7B5Jv60t2zP3yaNkbkWG7JCs8gX0hSvpT7lyc
         0Rqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=crHNAHVlKQymoKWU9RZhNMhhrAe0GtaAQ+q4H8Ky7gQ=;
        b=somFH133c473myP4eXuZ1/zYeQhZ8Lr5DyTbrFZqv9+/LKlvtbZ00Xf6LWidBpZMeY
         Mt42nC/F+XqvTocOgrtOlRnpPlS97/fwDbhZ9pN9pAFZKt4DyL6ViFYjOgmadT/q53pn
         X9DZ+3P8YbbO+dmxPl4fCEyz3p6yFcMVlidIUPBza+PbDL7sMdHunRAiQgaqdW3DP7Vf
         oEbr3j2q3YVDKFp0H06iBJw2K9iopFZyuya5pbCWZVpn6aH4wTphlv3FcS+koW4wQKHV
         X8isDP6Te3Kg4FWmK+Bfy7idOg0FC2A7bLCF1RRuxYrAaNpXFtSjxE3aM8cMlWoavAoe
         n4HQ==
X-Gm-Message-State: AOAM530uH0TZXyJDJ07DAfwlB0YL1qJ3zX11srtf6T+GtLBKdYcSymJQ
        UjzJDGsUy7r9rqKBexjaA5ZoBw1IWDlxzn4U5Lc=
X-Google-Smtp-Source: ABdhPJzlpw3EHAH3wllQAWOWN4kOdf8ElsIcCSpqU2vWXffxtg1acTl1+GovFCEwviHOmq4lD8gt5VmRxkwOWF1MOQw=
X-Received: by 2002:a25:6644:: with SMTP id z4mr13530911ybm.347.1600365989911;
 Thu, 17 Sep 2020 11:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006242.98230.15812695975228745782.stgit@toke.dk> <CAEf4Bzafmu5w6wjWT_d0B-JaUnm3KOf0Dgp+552iZii2+=3DWg@mail.gmail.com>
 <CAEf4BzbqW12q_nXvat6=iTvKpy1P+e-r0N+9eY3vgDAZ8rcfLQ@mail.gmail.com> <87tuvwmirx.fsf@toke.dk>
In-Reply-To: <87tuvwmirx.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Sep 2020 11:06:18 -0700
Message-ID: <CAEf4BzZkaViCyJnnJtSVjN2q7aD1SgEOqKKmy5m+1icWd3B72Q@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 10:10 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Sep 16, 2020 at 12:59 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >> >
> >> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >
> >> > Eelco reported we can't properly access arguments if the tracing
> >> > program is attached to extension program.
> >> >
> >> > Having following program:
> >> >
> >> >   SEC("classifier/test_pkt_md_access")
> >> >   int test_pkt_md_access(struct __sk_buff *skb)
> >> >
> >> > with its extension:
> >> >
> >> >   SEC("freplace/test_pkt_md_access")
> >> >   int test_pkt_md_access_new(struct __sk_buff *skb)
> >> >
> >> > and tracing that extension with:
> >> >
> >> >   SEC("fentry/test_pkt_md_access_new")
> >> >   int BPF_PROG(fentry, struct sk_buff *skb)
> >> >
> >> > It's not possible to access skb argument in the fentry program,
> >> > with following error from verifier:
> >> >
> >> >   ; int BPF_PROG(fentry, struct sk_buff *skb)
> >> >   0: (79) r1 =3D *(u64 *)(r1 +0)
> >> >   invalid bpf_context access off=3D0 size=3D8
> >> >
> >> > The problem is that btf_ctx_access gets the context type for the
> >> > traced program, which is in this case the extension.
> >> >
> >> > But when we trace extension program, we want to get the context
> >> > type of the program that the extension is attached to, so we can
> >> > access the argument properly in the trace program.
> >> >
> >> > This version of the patch is tweaked slightly from Jiri's original o=
ne,
> >> > since the refactoring in the previous patches means we have to get t=
he
> >> > target prog type from the new variable in prog->aux instead of direc=
tly
> >> > from the target prog.
> >> >
> >> > Reported-by: Eelco Chaudron <echaudro@redhat.com>
> >> > Suggested-by: Jiri Olsa <jolsa@kernel.org>
> >> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> > ---
> >> >  kernel/bpf/btf.c |    9 ++++++++-
> >> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> >> > index 9228af9917a8..55f7b2ba1cbd 100644
> >> > --- a/kernel/bpf/btf.c
> >> > +++ b/kernel/bpf/btf.c
> >> > @@ -3860,7 +3860,14 @@ bool btf_ctx_access(int off, int size, enum b=
pf_access_type type,
> >> >
> >> >         info->reg_type =3D PTR_TO_BTF_ID;
> >> >         if (tgt_prog) {
> >> > -               ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_pr=
og->type, arg);
> >> > +               enum bpf_prog_type tgt_type;
> >> > +
> >> > +               if (tgt_prog->type =3D=3D BPF_PROG_TYPE_EXT)
> >> > +                       tgt_type =3D tgt_prog->aux->tgt_prog_type;
> >>
> >> what if tgt_prog->aux->tgt_prog_type is also BPF_PROG_TYPE_EXT? Should
> >> this be a loop?
> >
> > ok, never mind this specifically. there is an explicit check
> >
> > if (tgt_prog->type =3D=3D prog->type) {
> >     verbose(env, "Cannot recursively attach\n");
> >     return -EINVAL;
> > }
> >
> > that will prevent this.
> >
> > But, I think we still will be able to construct a long chain of
> > fmod_ret -> freplace -> fmod_ret -> freplace -> and so on ad
> > infinitum. Can you please construct such a selftest? And then we
> > should probably fix those checks to also disallow FMOD_RET, in
> > addition to BPF_TRACE_FENTRY/FEXIT (and someone more familiar with LSM
> > prog type should check if that can cause any problems).
>
> Huh, I thought fmod_ret was supposed to be for kernel functions only?

Yeah, I realized that afterwards, but didn't want to ramble on forever :)

> However, I can't really point to anywhere in the code that ensures this,
> other than check_attach_modify_return(), but I think that will allow a
> bpf function as long as its name starts with "security_" ?

I think error_injection_list check will disallow anything that's not a
specially marked kernel function. So we are probably safe as is, even
though a bit implicitly.

>
> Is there actually any use case for modify_return being attached to a BPF
> function (you could just use freplace instead, couldn't you?). Or should
> we just disallow that entirely (if I'm not missing somewhere it's
> already blocked)?

No idea, but I think it works as is right now, so I wouldn't touch it.

>
> -Toke
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB2B26CA6E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgIPT7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgIPT7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 15:59:33 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5E6C06174A;
        Wed, 16 Sep 2020 12:59:31 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a2so6328704ybj.2;
        Wed, 16 Sep 2020 12:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H0tFT+S3Q5m2KmovC6sFM4oD86DYyZDpAI79rU7bkA8=;
        b=VPUqu/GJZYhN68/l5wuDDgw1GJSAXvMPeLtAUHGMcKMKsi8nfk8mRTHdL41Penvg1y
         /vZhVH4kfCYRr0aore+rtLkam6rJ94AUlEseJT5ib74aV4pqE3el1qJbLudN1QEx18gp
         uYSaau39g7jnibEFi7kykbGhqBA1qI9jW6O+vS9u0fOxL4/62yRqAWdRBhV+g+gGEWaN
         9cdmjmDuKYmgtQlMnMOL0FiBaF+U7puPusAKUbLjrMGbW6G4E2v9VSYeJ7jGF3tw0CFu
         JgtdGlLRI5GjHhbUkoljMT8ESehBSzpZ+2aueSl3SkUOZ3Vacn3rO3hQHGrfftPgV0P3
         HegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H0tFT+S3Q5m2KmovC6sFM4oD86DYyZDpAI79rU7bkA8=;
        b=XAmLAyffO3hvnYgacn1tzd9dRvG42Sl+3rxJa7nGilKUH/l02/E3LaT8NhVfK8HjwW
         KvEedyi5Qh1LwzU9Sa3BDyHAiUDrXC8VddHtduqz1F3gA/vEza4g8yT9jlZKPbKKUbwS
         QPvnGpAINp6+Y/eSHHec4q+zBp/fVeo/nphUwtvrOa12NWjAaXcJaCQFf3TaADQUQ0WC
         zvKFAFpwnBj5ZfIpnv6ZGtt6gp5AbUEL0lg/JdNxF7p5h/3a8c5Ikg4oksu89ChzHrcf
         2S20gAubn9Ox20Cgoyq+9Wmi8mRLDxzAIJgdyFQfZqxhpAXNFlxEXCFRHCbYduLMKRwm
         fpdA==
X-Gm-Message-State: AOAM530Zor56mxYp0rfCPcE2S0BAWwcilLXP9ae/JdSomFqkYwKvv1yz
        vLQ13zx0AWVX9K5IDNvFQBGQaYzd/gaZDs4iEg8=
X-Google-Smtp-Source: ABdhPJxPOaHaZbvLP9/lzIbLOOBJF0JkQUiPOmpffmdhIzPsofqzuP3Y1WUL98OKX0PPAP6YBo4bmgFuCbvTPjlARFg=
X-Received: by 2002:a25:d70e:: with SMTP id o14mr27991264ybg.425.1600286370225;
 Wed, 16 Sep 2020 12:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk> <160017006242.98230.15812695975228745782.stgit@toke.dk>
In-Reply-To: <160017006242.98230.15812695975228745782.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Sep 2020 12:59:19 -0700
Message-ID: <CAEf4Bzafmu5w6wjWT_d0B-JaUnm3KOf0Dgp+552iZii2+=3DWg@mail.gmail.com>
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

On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Eelco reported we can't properly access arguments if the tracing
> program is attached to extension program.
>
> Having following program:
>
>   SEC("classifier/test_pkt_md_access")
>   int test_pkt_md_access(struct __sk_buff *skb)
>
> with its extension:
>
>   SEC("freplace/test_pkt_md_access")
>   int test_pkt_md_access_new(struct __sk_buff *skb)
>
> and tracing that extension with:
>
>   SEC("fentry/test_pkt_md_access_new")
>   int BPF_PROG(fentry, struct sk_buff *skb)
>
> It's not possible to access skb argument in the fentry program,
> with following error from verifier:
>
>   ; int BPF_PROG(fentry, struct sk_buff *skb)
>   0: (79) r1 =3D *(u64 *)(r1 +0)
>   invalid bpf_context access off=3D0 size=3D8
>
> The problem is that btf_ctx_access gets the context type for the
> traced program, which is in this case the extension.
>
> But when we trace extension program, we want to get the context
> type of the program that the extension is attached to, so we can
> access the argument properly in the trace program.
>
> This version of the patch is tweaked slightly from Jiri's original one,
> since the refactoring in the previous patches means we have to get the
> target prog type from the new variable in prog->aux instead of directly
> from the target prog.
>
> Reported-by: Eelco Chaudron <echaudro@redhat.com>
> Suggested-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  kernel/bpf/btf.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 9228af9917a8..55f7b2ba1cbd 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3860,7 +3860,14 @@ bool btf_ctx_access(int off, int size, enum bpf_ac=
cess_type type,
>
>         info->reg_type =3D PTR_TO_BTF_ID;
>         if (tgt_prog) {
> -               ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_prog->t=
ype, arg);
> +               enum bpf_prog_type tgt_type;
> +
> +               if (tgt_prog->type =3D=3D BPF_PROG_TYPE_EXT)
> +                       tgt_type =3D tgt_prog->aux->tgt_prog_type;

what if tgt_prog->aux->tgt_prog_type is also BPF_PROG_TYPE_EXT? Should
this be a loop?

Which also brings up a few follow up questions. Now that we allow same
PROG_EXT program to be attached to multiple other programs:

1. what prevents us from attaching PROG_EXT to itself?
2. How do we prevent long chain of EXT programs or even loops?

Can you please add a few selftests testing such cases? I have a
feeling that with your changes in this patch set now it's possible to
break the kernel very easily. I don't know what the proper solution
is, but let's at least have a test that does show breakage, then try
to figure out the solution. See also comment in check_attach_btf_id()
about fentry/fexit and freplace interactions. That might not be
enough.


> +               else
> +                       tgt_type =3D tgt_prog->type;
> +
> +               ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_type, a=
rg);
>                 if (ret > 0) {
>                         info->btf_id =3D ret;
>                         return true;
>

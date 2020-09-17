Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05C126E0E6
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 18:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgIQQjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 12:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgIQQix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 12:38:53 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CAAC06178A;
        Thu, 17 Sep 2020 09:38:52 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x8so2138806ybm.3;
        Thu, 17 Sep 2020 09:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jHJew9X9fqpF31MwstiCK+FoFBPEbcWDKXoq7YBttqc=;
        b=nT8nD0Jf5yIKM8XHs7sCzOuChXVM/xy0WiYhQRY27JUFfdgY1AYmpj1vJTp7FlV3wM
         dzdwBdkaDOnlvXT9RjVGIhEqQpwZ+8Mok6m76pD/SPYscFhH1cBMWjetzwqh2C/RYDgP
         pW6Aue1YnSoYb6pzCN4yMMlEfAUi/6V6SXl1yDLRD3X3fv5MOBIQyFZSDdIUK8tSxyg+
         by++d6hIuwI6G6vC88VJhnmfkxSkdw1+oeGiSne9OxlQASlc/bTF6DjiF+YOnyp3sAxH
         pG6XpRiIvrfqLslHfYVmFdaDOefm9jpQEFnHPZHZzIzkw3OSMRGeAIrK+jPeHrBs8Xih
         Kj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jHJew9X9fqpF31MwstiCK+FoFBPEbcWDKXoq7YBttqc=;
        b=T19BEck5i/Qwx3UrjAOYfTy1qx2N2AlvrfXHB1zfjFFZXKA13hUpqq85OaEFBxPmv3
         ZsXXiymxVjSv1+T7sxopSz6kqw5KC3+Vww2RT8HT3nhC0rB1GnwFyNozMo4Fsb/aI63p
         X6eISGppIofe+WRra/+lH6+qBfY4k8BOXDEj5AzbVrnbCTCsldDGqcKIoiTGkxrjG5xC
         5hmQFVlwZ0gRVCwWdmHiYwkQJtVhKXwySyGUCDboqcYr/JttOeqgAcGohCel5hsRr7jg
         o/kTArOORnLv8aLY1hnV9XwjRXd2jqLVJJzq7zKmgLKA0cikxcaR0X0wLZd0qqSXpHvP
         CFbQ==
X-Gm-Message-State: AOAM530IKHU4YrWUEPTyhowVilbwhOBAU9YXJiXMbq2LXNRVIKX7OR6S
        Wi74MIGNMmZb7PbiWIXKJ+Vh9q8BvfydSSPjaLI=
X-Google-Smtp-Source: ABdhPJyx6Cgx9AzcPQWhd71s1uq+XO5vwx8dPK9nB9JmFfvYMIY7qi+GJBw1c6c0Fwbq60JhLnzWYV9SoEqThaeYfAA=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr41236512ybp.510.1600360731812;
 Thu, 17 Sep 2020 09:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017005916.98230.1736872862729846213.stgit@toke.dk> <CAEf4BzbAsnzAUPksUs+bcNuuUPkumc15RLESu3jOGf87mzabBA@mail.gmail.com>
 <87lfh8ogyt.fsf@toke.dk>
In-Reply-To: <87lfh8ogyt.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Sep 2020 09:38:40 -0700
Message-ID: <CAEf4Bzbs1cGO7u8X08isxMjub5nJCBs-kNOM1swM+3uwRNPFEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 2/8] bpf: verifier: refactor check_attach_btf_id()
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

On Thu, Sep 17, 2020 at 3:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> >>
> >> +int bpf_check_attach_target(struct bpf_verifier_log *log,
> >> +                           const struct bpf_prog *prog,
> >> +                           const struct bpf_prog *tgt_prog,
> >> +                           u32 btf_id,
> >> +                           struct btf_func_model *fmodel,
> >> +                           long *tgt_addr,
> >> +                           const char **tgt_name,
> >> +                           const struct btf_type **tgt_type);
> >
> > So this is obviously an abomination of a function signature,
> > especially for a one exported to other files.
> >
> > One candidate to remove would be tgt_type, which is supposed to be a
> > derivative of target BTF (vmlinux or tgt_prog->btf) + btf_id,
> > **except** (and that's how I found the bug below), in case of
> > fentry/fexit programs attaching to "conservative" BPF functions, in
> > which case what's stored in aux->attach_func_proto is different from
> > what is passed into btf_distill_func_proto. So that's a bug already
> > (you'll return NULL in some cases for tgt_type, while it has to always
> > be non-NULL).
>
> Okay, looked at this in more detail, and I don't think the refactored
> code is doing anything different from the pre-refactor version?
>
> Before we had this:
>
>                 if (tgt_prog && conservative) {
>                         prog->aux->attach_func_proto =3D NULL;
>                         t =3D NULL;
>                 }
>
> and now we just have
>
>                 if (tgt_prog && conservative)
>                         t =3D NULL;
>
> in bpf_check_attach_target(), which gets returned as tgt_type and
> subsequently assigned to prog->aux->attach_func_proto.

Yeah, you are totally right, I don't know how I missed that
`prog->aux->attach_func_proto =3D NULL;`, sorry about that.

>
> > But related to that is fmodel. It seems like bpf_check_attach_target()
> > has no interest in fmodel itself and is just passing it from
> > btf_distill_func_proto(). So I was about to suggest dropping fmodel
> > and calling btf_distill_func_proto() outside of
> > bpf_check_attach_target(), but given the conservative + fentry/fexit
> > quirk, it's probably going to be more confusing.
> >
> > So with all this, I suggest dropping the tgt_type output param
> > altogether and let callers do a `btf__type_by_id(tgt_prog ?
> > tgt_prog->aux->btf : btf_vmlinux, btf_id);`. That will both fix the
> > bug and will make this function's signature just a tad bit less
> > horrible.
>
> Thought about this, but the logic also does a few transformations of the
> type itself, e.g., this for bpf_trace_raw_tp:
>
>                 tname +=3D sizeof(prefix) - 1;
>                 t =3D btf_type_by_id(btf, t->type);
>                 if (!btf_type_is_ptr(t))
>                         /* should never happen in valid vmlinux build */
>                         return -EINVAL;
>                 t =3D btf_type_by_id(btf, t->type);
>                 if (!btf_type_is_func_proto(t))
>                         /* should never happen in valid vmlinux build */
>                         return -EINVAL;
>
> so to catch this we really do have to return the type from the function
> as well.

yeah, with func_proto sometimes being null, btf_id isn't enough, so
that can't be done anyways.

>
> I do agree that the function signature is a tad on the long side, but I
> couldn't think of any good way of making it smaller. I considered
> replacing the last two return values with a boolean 'save' parameter,
> that would just make it same the values directly in prog->aux; but I
> actually find it easier to reason about a function that is strictly
> checking things and returning the result, instead of 'sometimes modify'
> semantics...

I agree, modifying prog->aux would be worse. And
btf_distill_func_proto() can't be extracted right away, because it
doesn't happen for the RAW_TP case. Oh well, we'll have to live with
an 8-argument function, I suppose.

Please add my ack when you post a new version:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> -Toke
>

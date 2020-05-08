Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E351CB676
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgEHSAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726746AbgEHSAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:00:11 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AF1C061A0C;
        Fri,  8 May 2020 11:00:11 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id r2so2216819ilo.6;
        Fri, 08 May 2020 11:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LITwJAQiIegyaBGUCe4rrgKlB+t1/7n82YSlBv6z3Ws=;
        b=sJlgXDpHnhAt5WU6niuDTlCC9GCH7d20RG8eqy1ckUc4RQAjSUB/ZVief5J8GMz2wo
         jBy33XxrJvCgYedM1/HErfPHoeAQGvU/8TJZRlMTs70h28+FijK0eBK07c0IaKx1f14o
         g82VuGPd3wWy8qxjDqPN/W5i0O3tc24DPYsZSeDSs7/CkFvCyHpi3DYP3xQqFEe9tOv5
         mOy73Y9ohpUfq+PtaysKpVZo3eqqNzUN804zceU/09seizv2JeGsYBXa40ED4ZFnsofv
         yHjcKxQYSygS02NhCfvqoNR0L4xfvSQWBgvtBoV0X3iQj/LfVsVcCSNAULqpCG0zA70m
         tPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LITwJAQiIegyaBGUCe4rrgKlB+t1/7n82YSlBv6z3Ws=;
        b=M/8HxzQEg8mXWOtdUMAA8V8fSfIdsG0yldY9g1sd6RzoP/4mondIF6o8haOdvMaHp0
         Gzy3jk1jBYU1ugV4VCoT6xenLqr6lv1Kipuoyh7J6TwaX3XxJridSRYTmKSKXaZ0Lcf8
         d7Lk7IV9AnRnGGXWjxGMCMAcJqrYltJWRoF0B12rSdJXx5e55C9pFS1B0mJ9WpNTbZnO
         MqGEmZ5m+9QCCPy8BpxSj4j+TTgdZiCf2SIvlIwydKWStXSkdCEk6xax+CjAQD8Wji6k
         71j7efVoKC05iagaa1NbvPLjH/jALslBCnA8dQo0QBReD5rRVdCGSIVtXPuIfjR2ETcu
         Vh5A==
X-Gm-Message-State: AGi0PuaVU8J4oEJr00ZFw5WAbonZumI64Zcrb8UrioflV2DXrm83bDGm
        9wWfESIsjL/f4VTHQFN2CGFad0q3rt1D6fKPpP0=
X-Google-Smtp-Source: APiQypKZGmGgRFBIb8ZX0zH/Tssu4Mp0QFEf2DZ6pekn81IiDmt4r6PnY4sdrfPl0w4/FMl6l9rRRVdWC8wfsCZAUog=
X-Received: by 2002:a92:4989:: with SMTP id k9mr4217910ilg.104.1588960810608;
 Fri, 08 May 2020 11:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200506125514.1020829-1-jakub@cloudflare.com>
 <20200506125514.1020829-15-jakub@cloudflare.com> <CAEf4BzaE=+0ZkwqetjDHg4MnE1WDQDKFHqEkM825h6YMCZAdNA@mail.gmail.com>
 <c3eb3e32-237f-af0b-69b4-3233ab65490c@fb.com>
In-Reply-To: <c3eb3e32-237f-af0b-69b4-3233ab65490c@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 10:59:59 -0700
Message-ID: <CAEf4BzYbZpsd69TkSgYeP+D8sGKogK2YGhwTxiNWr3RpHVD_=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 14/17] libbpf: Add support for SK_LOOKUP program type
To:     Yonghong Song <yhs@fb.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 10:52 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/8/20 10:41 AM, Andrii Nakryiko wrote:
> > On Wed, May 6, 2020 at 5:58 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> Make libbpf aware of the newly added program type, and assign it a
> >> section name.
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>   tools/lib/bpf/libbpf.c        | 3 +++
> >>   tools/lib/bpf/libbpf.h        | 2 ++
> >>   tools/lib/bpf/libbpf.map      | 2 ++
> >>   tools/lib/bpf/libbpf_probes.c | 1 +
> >>   4 files changed, 8 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index 977add1b73e2..74f4a15dc19e 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -6524,6 +6524,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
> >>   BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
> >>   BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
> >>   BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
> >> +BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
> >>
> >>   enum bpf_attach_type
> >>   bpf_program__get_expected_attach_type(struct bpf_program *prog)
> >> @@ -6684,6 +6685,8 @@ static const struct bpf_sec_def section_defs[] = {
> >>          BPF_EAPROG_SEC("cgroup/setsockopt",     BPF_PROG_TYPE_CGROUP_SOCKOPT,
> >>                                                  BPF_CGROUP_SETSOCKOPT),
> >>          BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
> >> +       BPF_EAPROG_SEC("sk_lookup",             BPF_PROG_TYPE_SK_LOOKUP,
> >> +                                               BPF_SK_LOOKUP),
> >>   };
> >>
> >>   #undef BPF_PROG_SEC_IMPL
> >> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> >> index f1dacecb1619..8373fbacbba3 100644
> >> --- a/tools/lib/bpf/libbpf.h
> >> +++ b/tools/lib/bpf/libbpf.h
> >> @@ -337,6 +337,7 @@ LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
> >>   LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
> >>   LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
> >>   LIBBPF_API int bpf_program__set_extension(struct bpf_program *prog);
> >> +LIBBPF_API int bpf_program__set_sk_lookup(struct bpf_program *prog);
> >>
> >>   LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
> >>   LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
> >> @@ -364,6 +365,7 @@ LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
> >>   LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
> >>   LIBBPF_API bool bpf_program__is_struct_ops(const struct bpf_program *prog);
> >>   LIBBPF_API bool bpf_program__is_extension(const struct bpf_program *prog);
> >> +LIBBPF_API bool bpf_program__is_sk_lookup(const struct bpf_program *prog);
> >
> > cc Yonghong, bpf_iter programs should probably have similar
> > is_xxx/set_xxx functions?..
>
> Not sure about this. bpf_iter programs have prog type TRACING
> which is covered by the above bpf_program__is_tracing.

Ah, right, never mind then, sorry.

>
> >
> >>
> >>   /*
> >>    * No need for __attribute__((packed)), all members of 'bpf_map_def'
> >> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> >> index e03bd4db827e..113ac0a669c2 100644
> >> --- a/tools/lib/bpf/libbpf.map
> >> +++ b/tools/lib/bpf/libbpf.map
> >> @@ -253,6 +253,8 @@ LIBBPF_0.0.8 {
> >>                  bpf_program__set_attach_target;
> >>                  bpf_program__set_lsm;
> >>                  bpf_set_link_xdp_fd_opts;
> >> +               bpf_program__is_sk_lookup;
> >> +               bpf_program__set_sk_lookup;
> >>   } LIBBPF_0.0.7;
> >>
> >
> > 0.0.8 is sealed, please add them into 0.0.9 map below
> >
> >>   LIBBPF_0.0.9 {
> >> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
> >> index 2c92059c0c90..5c6d3e49f254 100644
> >> --- a/tools/lib/bpf/libbpf_probes.c
> >> +++ b/tools/lib/bpf/libbpf_probes.c
> >> @@ -109,6 +109,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
> >>          case BPF_PROG_TYPE_STRUCT_OPS:
> >>          case BPF_PROG_TYPE_EXT:
> >>          case BPF_PROG_TYPE_LSM:
> >> +       case BPF_PROG_TYPE_SK_LOOKUP:
> >>          default:
> >>                  break;
> >>          }
> >> --
> >> 2.25.3
> >>

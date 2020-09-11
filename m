Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865852669D4
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 22:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgIKU4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 16:56:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725861AbgIKU4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 16:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599857788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DsTTmWLpUyxDXAfJIxLNbmdeHfYRuFYjl0JwyKN8r24=;
        b=PBHXFANF2D5HAcaN0gU74HGxNjYoRsCdcNe60WfzepsppNdvVxgXPUW81qq5HMYnJLn5b4
        ewMwhjSsBovQZUWO1s5zwlOmUf9vAeK2rSHFK7LuAj1Ozmz0RkHUQiT/9xDiHDDMbe9Oqf
        1z3vttbyYBHedBamiqXCDn/h0X0BPZ0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-1xarNwOcPsWBuqFkckW8tw-1; Fri, 11 Sep 2020 16:56:27 -0400
X-MC-Unique: 1xarNwOcPsWBuqFkckW8tw-1
Received: by mail-wm1-f71.google.com with SMTP id g79so2243818wmg.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 13:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DsTTmWLpUyxDXAfJIxLNbmdeHfYRuFYjl0JwyKN8r24=;
        b=hCNCboa/BQFog4djBEVEtPARJytStmJBTxxVBrXRPntBREKEa8DIQtWHfYEePcldyh
         xHJc4oVwVyQalEwxyjr7zMx2XXuKU+xX1BOxG5E18Bu5FKB2OJsxX11JAolp/Do11qlv
         JPcFRskdgIEaTEEjbjcuQZQY2RwKZTUZVnCgZcq2957hVEClGAPmwtt+hq0H3bqfEl2J
         5QV9wsZY+ldrKoPFIdcH9JtMIyLBcrBEV/7Q5z3e/BpHrxe4W359d0jZQdGT2xGg2hlK
         muM38vxAxiSkL0FlgtCmqqJKQ9HXw3s2om4xTSozrjDq9GMyp1sJT6xJR3KbJrCLxFY5
         4mLg==
X-Gm-Message-State: AOAM532rdkeh2CS+rE3pirE+mGV/q4sae7xFuloVITZGqelGjtVMSDI3
        2FZ0BpVWhv0vtwef4ti6SqkXOqGIEeMxnsG1mxDc+3y3KrcYa3ougV264LKRjM+PTrFDu2LMTvI
        SBUJJIlhURp9LK7RG
X-Received: by 2002:a1c:6341:: with SMTP id x62mr3932985wmb.70.1599857785370;
        Fri, 11 Sep 2020 13:56:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+IYHJwqACkNt+iTrtY6HjEM8e+ITThlo0tH19OGdeaYBwBc4CIEHYJwps0rMpHwQPK6yiRQ==
X-Received: by 2002:a1c:6341:: with SMTP id x62mr3932946wmb.70.1599857784940;
        Fri, 11 Sep 2020 13:56:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d5sm6898526wrb.28.2020.09.11.13.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 13:56:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A6FCB1829D4; Fri, 11 Sep 2020 22:56:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH RESEND bpf-next v3 3/9] bpf: wrap prog->aux->linked_prog
 in a bpf_tracing_link
In-Reply-To: <CAEf4Bzb=va0n3GMaYx-Kk7yCpsUK2iDMjVh2O2bm=9q-troH9A@mail.gmail.com>
References: <159981835466.134722.8652987144251743467.stgit@toke.dk>
 <159981835802.134722.18147008746583957688.stgit@toke.dk>
 <CAEf4Bzb=va0n3GMaYx-Kk7yCpsUK2iDMjVh2O2bm=9q-troH9A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Sep 2020 22:56:23 +0200
Message-ID: <875z8k9gnc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Sep 11, 2020 at 3:00 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> The bpf_tracing_link structure is a convenient data structure to contain
>> the reference to a linked program; in preparation for supporting multiple
>> attachments for the same freplace program, move the linked_prog in
>> prog->aux into a bpf_tracing_link wrapper.
>>
>> With this change, it is no longer possible to attach the same tracing
>> program multiple times (detaching in-between), since the reference from =
the
>> tracing program to the target disappears on the first attach. However,
>> since the next patch will let the caller supply an attach target, that w=
ill
>> also make it possible to attach to the same place multiple times.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  include/linux/bpf.h     |   21 +++++++++---
>>  kernel/bpf/btf.c        |   13 +++++---
>>  kernel/bpf/core.c       |    5 +--
>>  kernel/bpf/syscall.c    |   81 +++++++++++++++++++++++++++++++++++++---=
-------
>>  kernel/bpf/trampoline.c |   12 ++-----
>>  kernel/bpf/verifier.c   |   13 +++++---
>>  6 files changed, 102 insertions(+), 43 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 7f19c3216370..722c60f1c1fc 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -26,6 +26,7 @@ struct bpf_verifier_log;
>>  struct perf_event;
>>  struct bpf_prog;
>>  struct bpf_prog_aux;
>> +struct bpf_tracing_link;
>>  struct bpf_map;
>>  struct sock;
>>  struct seq_file;
>> @@ -614,8 +615,8 @@ static __always_inline unsigned int bpf_dispatcher_n=
op_func(
>>  }
>>  #ifdef CONFIG_BPF_JIT
>>  struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
>> -int bpf_trampoline_link_prog(struct bpf_prog *prog);
>> -int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
>> +int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoli=
ne *tr);
>> +int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampo=
line *tr);
>>  int bpf_trampoline_get(u64 key, void *addr,
>>                        struct btf_func_model *fmodel,
>>                        struct bpf_trampoline **trampoline);
>> @@ -667,11 +668,13 @@ static inline struct bpf_trampoline *bpf_trampolin=
e_lookup(u64 key)
>>  {
>>         return NULL;
>>  }
>> -static inline int bpf_trampoline_link_prog(struct bpf_prog *prog)
>> +static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
>> +                                          struct bpf_trampoline *tr)
>>  {
>>         return -ENOTSUPP;
>>  }
>> -static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
>> +static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog,
>> +                                            struct bpf_trampoline *tr)
>>  {
>>         return -ENOTSUPP;
>>  }
>> @@ -740,14 +743,13 @@ struct bpf_prog_aux {
>>         u32 max_rdonly_access;
>>         u32 max_rdwr_access;
>>         const struct bpf_ctx_arg_aux *ctx_arg_info;
>> -       struct bpf_prog *linked_prog;
>> +       struct bpf_tracing_link *tgt_link;
>>         bool verifier_zext; /* Zero extensions has been inserted by veri=
fier. */
>>         bool offload_requested;
>>         bool attach_btf_trace; /* true if attaching to BTF-enabled raw t=
p */
>>         bool func_proto_unreliable;
>>         bool sleepable;
>>         enum bpf_tramp_prog_type trampoline_prog_type;
>> -       struct bpf_trampoline *trampoline;
>>         struct hlist_node tramp_hlist;
>>         /* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
>>         const struct btf_type *attach_func_proto;
>> @@ -827,6 +829,13 @@ struct bpf_link {
>>         struct work_struct work;
>>  };
>>
>> +struct bpf_tracing_link {
>> +       struct bpf_link link;
>> +       enum bpf_attach_type attach_type;
>> +       struct bpf_trampoline *trampoline;
>> +       struct bpf_prog *tgt_prog;
>> +};
>> +
>>  struct bpf_link_ops {
>>         void (*release)(struct bpf_link *link);
>>         void (*dealloc)(struct bpf_link *link);
>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> index 2ace56c99c36..e10f13f8251c 100644
>> --- a/kernel/bpf/btf.c
>> +++ b/kernel/bpf/btf.c
>> @@ -3706,10 +3706,10 @@ struct btf *btf_parse_vmlinux(void)
>>
>>  struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
>>  {
>> -       struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
>> +       struct bpf_tracing_link *tgt_link =3D prog->aux->tgt_link;
>>
>> -       if (tgt_prog) {
>> -               return tgt_prog->aux->btf;
>> +       if (tgt_link && tgt_link->tgt_prog) {
>> +               return tgt_link->tgt_prog->aux->btf;
>>         } else {
>>                 return btf_vmlinux;
>>         }
>> @@ -3733,14 +3733,17 @@ bool btf_ctx_access(int off, int size, enum bpf_=
access_type type,
>>                     struct bpf_insn_access_aux *info)
>>  {
>>         const struct btf_type *t =3D prog->aux->attach_func_proto;
>> -       struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
>>         struct btf *btf =3D bpf_prog_get_target_btf(prog);
>>         const char *tname =3D prog->aux->attach_func_name;
>>         struct bpf_verifier_log *log =3D info->log;
>> +       struct bpf_prog *tgt_prog =3D NULL;
>>         const struct btf_param *args;
>>         u32 nr_args, arg;
>>         int i, ret;
>>
>> +       if (prog->aux->tgt_link)
>> +               tgt_prog =3D prog->aux->tgt_link->tgt_prog;
>> +
>>         if (off % 8) {
>>                 bpf_log(log, "func '%s' offset %d is not multiple of 8\n=
",
>>                         tname, off);
>> @@ -4572,7 +4575,7 @@ int btf_prepare_func_args(struct bpf_verifier_env =
*env, int subprog,
>>                 return -EFAULT;
>>         }
>>         if (prog_type =3D=3D BPF_PROG_TYPE_EXT)
>> -               prog_type =3D prog->aux->linked_prog->type;
>> +               prog_type =3D prog->aux->tgt_link->tgt_prog->type;
>>
>>         t =3D btf_type_by_id(btf, t->type);
>>         if (!t || !btf_type_is_func_proto(t)) {
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index ed0b3578867c..54c125cec218 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -2130,7 +2130,6 @@ static void bpf_prog_free_deferred(struct work_str=
uct *work)
>>         if (aux->prog->has_callchain_buf)
>>                 put_callchain_buffers();
>>  #endif
>> -       bpf_trampoline_put(aux->trampoline);
>>         for (i =3D 0; i < aux->func_cnt; i++)
>>                 bpf_jit_free(aux->func[i]);
>>         if (aux->func_cnt) {
>> @@ -2146,8 +2145,8 @@ void bpf_prog_free(struct bpf_prog *fp)
>>  {
>>         struct bpf_prog_aux *aux =3D fp->aux;
>>
>> -       if (aux->linked_prog)
>> -               bpf_prog_put(aux->linked_prog);
>> +       if (aux->tgt_link)
>> +               bpf_link_put(&aux->tgt_link->link);
>
> Until the link is primed, you shouldn't bpf_link_put() it. At this
> stage the link itself is just a piece of memory that needs to be
> kfree()'d. And your circular dependency problem doesn't exist anymore.
> You'll have to put a trampoline and target prog manually here, though
> (but you have a similar problem below as well, so might just have a
> small helper to do this). But I think it's simpler that relying on an
> artificial "defunct" state of not-yet-activated bpf_link, which you do
> with the dance around link->prog =3D NULL.

Yeah, makes sense. I initially figured that would be 'breaking the
abstraction' of bpf_link, but I ended up having to do that anyway, so
you're right I might as well treat it as a piece of memory here.

[...]

>> @@ -2574,14 +2614,16 @@ static int bpf_tracing_prog_attach(struct bpf_pr=
og *prog)
>>                 goto out_put_prog;
>>         }
>>
>> -       link =3D kzalloc(sizeof(*link), GFP_USER);
>> +       link =3D READ_ONCE(prog->aux->tgt_link);
>>         if (!link) {
>> -               err =3D -ENOMEM;
>> +               err =3D -ENOENT;
>> +               goto out_put_prog;
>> +       }
>> +       olink =3D cmpxchg(&prog->aux->tgt_link, link, NULL);
>> +       if (olink !=3D link) {
>> +               err =3D -ENOENT;
>>                 goto out_put_prog;
>>         }
>
> Wouldn't single xchg to NULL be sufficient to achieve the same?
> READ_ONCE + cmpxchg seems unnecessary to me.

It would, but in the next patch I'm introducing a check on the contents
of the link before cmpxchg'ing it, so figured it was easier to just use
the same pattern here.

>> -       bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING,
>> -                     &bpf_tracing_link_lops, prog);
>> -       link->attach_type =3D prog->expected_attach_type;
>>
>>         err =3D bpf_link_prime(&link->link, &link_primer);
>>         if (err) {
>
> if priming errors out, you need to put target prog and trampoline,
> kfree(link) won't do it (and calling bpf_link_cleanup() is not correct
> before priming). See above as well.

Ah yes, good catch!

> BTW, one interesting side effect of all this is that if your initial
> attach failed, you won't be able to try again, because
> prog->aux->tgt_link is gone. If that's the problem, we'll need to
> introduce locking and copy that link, try to attach, then clear out
> prog->aug->tgt_link only if we succeeded. Just bringing this up, as it
> might not be obvious (or I might be wrong :).

Yeah, did think about that. From a purist PoV you're right that a
"destructive attempt" is not ideal; but we already agreed that clearing
out the link on attach was an acceptable change in behaviour. And I
figured that a failure in link_prim() or trampoline_link_prog() would be
quite rare, so not something we'd want to expend a lot of effort
ensuring was really atomic...

-Toke


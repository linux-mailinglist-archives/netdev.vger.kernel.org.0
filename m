Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1EED1741
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 20:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbfJISBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 14:01:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42401 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfJISBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 14:01:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id w14so4658384qto.9;
        Wed, 09 Oct 2019 11:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMsyNgKLmk4O8TGJb+pA4jJRCwi702+27bOFPKbEtKM=;
        b=muQEPO0Kh9JzJmqbKf56uVrWPfhltZ7vX+vJgNeC57mEoIRjvVvWLYkm84aCmQssDj
         NgMVjnEEdi0Ev41H9xIJS0n2W/nC9qOGt5K1oJK3u8NREbzfh41GilYm4vOTRueHL/p2
         LB+nAeJO9n0qemVT6kTZDnQfGn0JVJwXe689XGembAdr0W2sJoBUKtPoIncBoKfwYpzs
         tkYRkAKFr4/xEe5kH/9W99HKQW7Vp4vYD12FdWI1dk2gpV02gzhowEJTGhzmTEB8mefI
         MCyDjih5lhzcaEmzY+F3LazfaUBPmf6R5/GNLTf/v8T1p10kCjRiy2roFT2P12Gnm6Rl
         j8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMsyNgKLmk4O8TGJb+pA4jJRCwi702+27bOFPKbEtKM=;
        b=kvr/aKdJTwLiNmGBFA0XRbVlY9gSWK49qL94TR59qPPA05ju+iwrdgQzRgTce7qbZp
         oDMin8s3yg/RMepwc+33qmwE+b8GzR+jd39iuke8Q5/5i3HFTc/zHtCGgnib8/NH+lT3
         j2sUjBNpfK/Yqpngoam4DrWGQ1rsaqyzfjNauUfJaPgsfE5d0uw9Ry7recvWEM/Np9Qc
         VZa0d4oAb1sJIz5iUs1mMJLNAr95w8QmiSrjSMfXN5WHFZQGu8Ub6OD2kZ9cZAocyOXS
         lEIK/iW5JBpJJHleJbzuo8chep8AlMmN7L2A4P6aeZDQsmRaNKjkpfTCAr6wf5nQdkxX
         +uTg==
X-Gm-Message-State: APjAAAXe1U4fyJnOi46dOS34AVKKxsYAOUnaZWiL4qLYh+h7evFbvhiN
        vxYyunA8AImRR1zE9iBOaLSgjFtsuwKM5cPMa5s=
X-Google-Smtp-Source: APXvYqyoQzZV07MH27qbKo8CY9CtnnCNgaEOkzLXbpJn7TDc99HKJRux+VoAEHUKYpYmT5gMm1nHESzLXvlgIvT5iD8=
X-Received: by 2002:ac8:1c34:: with SMTP id a49mr4987529qtk.59.1570644082346;
 Wed, 09 Oct 2019 11:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-9-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-9-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Oct 2019 11:01:11 -0700
Message-ID: <CAEf4BzYpPMM=RZ=_kQqin1Aqj=RDx6T8YBJp=-sxgYq54bWhSw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/10] bpf: check types of arguments passed into helpers
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 10:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Introduce new helper that reuses existing skb perf_event output
> implementation, but can be called from raw_tracepoint programs
> that receive 'struct sk_buff *' as tracepoint argument or
> can walk other kernel data structures to skb pointer.
>
> In order to do that teach verifier to resolve true C types
> of bpf helpers into in-kernel BTF ids.
> The type of kernel pointer passed by raw tracepoint into bpf
> program will be tracked by the verifier all the way until
> it's passed into helper function.
> For example:
> kfree_skb() kernel function calls trace_kfree_skb(skb, loc);
> bpf programs receives that skb pointer and may eventually
> pass it into bpf_skb_output() bpf helper which in-kernel is
> implemented via bpf_skb_event_output() kernel function.
> Its first argument in the kernel is 'struct sk_buff *'.
> The verifier makes sure that types match all the way.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

no real concerns, few questions and nits below. Looks great otherwise!

>  include/linux/bpf.h                       |  3 +
>  include/uapi/linux/bpf.h                  |  3 +-
>  kernel/bpf/btf.c                          | 73 +++++++++++++++++++++++
>  kernel/bpf/verifier.c                     | 29 +++++++++
>  kernel/trace/bpf_trace.c                  |  4 ++
>  net/core/filter.c                         | 15 ++++-
>  tools/include/uapi/linux/bpf.h            |  3 +-
>  tools/testing/selftests/bpf/bpf_helpers.h |  4 ++
>  8 files changed, 131 insertions(+), 3 deletions(-)
>

[...]

> +       args = (const struct btf_param *)(t + 1);
> +       if (arg >= btf_type_vlen(t)) {
> +               bpf_verifier_log_write(env,
> +                                      "bpf helper '%s' doesn't have %d-th argument\n",
> +                                      fnname, arg);
> +               return -EINVAL;
> +       }
> +
> +       t = btf_type_by_id(btf_vmlinux, args[arg].type);
> +       if (!btf_type_is_ptr(t) || !t->type) {
> +               /* anything but the pointer to struct is a helper config bug */
> +               bpf_verifier_log_write(env,
> +                                      "ARG_PTR_TO_BTF is misconfigured\n");
> +
> +               return -EFAULT;
> +       }
> +       btf_id = t->type;
> +
> +       t = btf_type_by_id(btf_vmlinux, t->type);
> +       if (!btf_type_is_struct(t)) {

resolve mods/typedefs?

> +               bpf_verifier_log_write(env,
> +                                      "ARG_PTR_TO_BTF is not a struct\n");
> +
> +               return -EFAULT;
> +       }
> +       bpf_verifier_log_write(env,
> +                              "helper '%s' arg%d has btf_id %d struct '%s'\n",
> +                              fnname + 4, arg, btf_id,
> +                              __btf_name_by_offset(btf_vmlinux, t->name_off));
> +       return btf_id;
> +}
> +
>  void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
>                        struct seq_file *m)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 957ee442f2b4..0717aacb7801 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -205,6 +205,7 @@ struct bpf_call_arg_meta {
>         u64 msize_umax_value;
>         int ref_obj_id;
>         int func_id;
> +       u32 btf_id;
>  };
>
>  struct btf *btf_vmlinux;
> @@ -3367,6 +3368,27 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>                 expected_type = PTR_TO_SOCKET;
>                 if (type != expected_type)
>                         goto err_type;
> +       } else if (arg_type == ARG_PTR_TO_BTF_ID) {
> +               expected_type = PTR_TO_BTF_ID;
> +               if (type != expected_type)
> +                       goto err_type;
> +               if (reg->btf_id != meta->btf_id) {

just double-checking, both reg->btf_id and meta->btf_id will be
resolved through modifiers/typedefs all the way to the struct, right?

> +                       verbose(env, "Helper has type %s got %s in R%d\n",
> +                               btf_name_by_offset(btf_vmlinux,
> +                                                  btf_type_by_id(btf_vmlinux,
> +                                                                 meta->btf_id)->name_off),
> +                               btf_name_by_offset(btf_vmlinux,
> +                                                  btf_type_by_id(btf_vmlinux,
> +                                                                 reg->btf_id)->name_off),

This is rather verbose, but popular, construct, maybe extract into a
helper func and cut on code boilerplate? I think you had similar usage
in few places in previous patches.

> +                               regno);
> +
> +                       return -EACCES;
> +               }

[...]

> @@ -4053,6 +4077,11 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>                 return err;
>         }
>
> +       if (fn->arg1_type == ARG_PTR_TO_BTF_ID) {
> +               if (!fn->btf_id[0])
> +                       fn->btf_id[0] = btf_resolve_helper_id(env, fn->func, 0);
> +               meta.btf_id = fn->btf_id[0];
> +       }

Is this this baby-stepping thing that we do it only for arg1? Any
complications from doing a loop over all 5 params?

>         meta.func_id = func_id;
>         /* check args */
>         err = check_func_arg(env, BPF_REG_1, fn->arg1_type, &meta);
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 6221e8c6ecc3..52f7e9d8c29b 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -995,6 +995,8 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
>         .arg5_type      = ARG_CONST_SIZE_OR_ZERO,
>  };
>

[...]

> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 54a50699bbfd..c5e05d1a806f 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -65,6 +65,10 @@ static int (*bpf_perf_event_output)(void *ctx, void *map,
>                                     unsigned long long flags, void *data,
>                                     int size) =
>         (void *) BPF_FUNC_perf_event_output;
> +static int (*bpf_skb_output)(void *ctx, void *map,
> +                            unsigned long long flags, void *data,
> +                            int size) =
> +       (void *) BPF_FUNC_skb_output;

Obsolete now, no more manual list of helpers.

>  static int (*bpf_get_stackid)(void *ctx, void *map, int flags) =
>         (void *) BPF_FUNC_get_stackid;
>  static int (*bpf_probe_write_user)(void *dst, const void *src, int size) =
> --
> 2.20.0
>
